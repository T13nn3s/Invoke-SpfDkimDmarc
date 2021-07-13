<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/README.md'
#>
function Show-SpfDkimDmarc {
    [CmdletBinding()]
    param (
        # Specifies the domain for resolving the SPF, DKIM and DMARC-record.
        [Parameter(
            Mandatory, ParameterSetName = 'domain',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the SPF, DKIM and DMARC-record.",
            Position = 1)]
        [string]$Name,

        # Show SPF, DKIM and DMARC-records from multiple domains from a file.
        [Parameter(
            Mandatory, ParameterSetName = 'file',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Show SPF, DKIM and DMARC-records from multiple domains from a file.",
            Position = 2)]
        [System.IO.FileInfo]$File,

        # Custom DKIM Selector
        [Parameter(Mandatory = $False,
            HelpMessage = "Specify a custom DKIM selector.",
            Position = 3)]
        [string]$DkimSelector,

        # DNS Server to use
        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.",
            Position = 4)]
        [string]$Server
    )

    begin {

        class SpfDkimDmarc {
            [string]$Name
            [string]$SPFRecord
            [string]$SpfAdvisory
            [string]$DmarcRecord
            [string]$DmarcAdvisory
            [string]$DkimSelector
            [string]$DkimRecord
            [string]$DkimAdvisory
        
            # Constructor: Created the object with the SPF, DMARC and DKIM values
            SpfDkimDmarc (
                [string]$d, 
                [string]$SPF,
                [string]$SpfAdvisory,
                [string]$DMARC,
                [string]$DmarcAdvisory,
                [string]$DkimSelector,
                [string]$DKIM,
                [string]$DkimAdvisory
            ) {
                $this.Name = $d
                $this.SPFRecord = $SPF
                $this.SpfAdvisory = $SpfAdvisory
                $this.DmarcRecord = $DMARC
                $this.DmarcAdvisory = $DmarcAdvisory
                $this.DkimSelector = $DkimSelector
                $this.DkimRecord = $DKIM
                $this.DkimAdvisory = $DkimAdvisory
            }
        }

        if ($PSBoundParameters.ContainsKey('Server')) {
            $SplatParameters = @{
                'Server'      = $Server
                'ErrorAction' = 'SilentlyContinue'
            }
        }
        Else {
            $SplatParameters = @{
                'ErrorAction' = 'SilentlyContinue'
            }
        }

        # Custom list of DKIM-selectors
        # https://help.sendmarc.com/support/solutions/articles/44001891845-email-provider-commonly-used-dkim-selectors
        $DkimSelectors = @(
            'google', # Google
            'everlytic', # Everlytic
            'k1', # Mailchimp / Mandrill
            'mxvault' # Global Micro
            'dkim' # Hetzner
            'selector1' # Microsoft
        )
    }

    process {
        if ($file) {
            if (-not(Test-Path $file)) {
                Write-error "$($file) does not exist"
                return
            }
        }
        
       
        function StartDomainHealthCheck($domain) {
          
            # Check SPF-record
            $SPF = $null
            $SPF = Resolve-DnsName -Name $Domain -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
            if ($SPF -eq $null) {
                $SpfAdvisory = "Domain does not have an SPF record. To prevent abuse of this domain, please add an SPF record to it."
            }
            if ($SPF -is [array]) {
                $SpfAdvisory = "Domain has more than one SPF-record. One SPF record for one domain. This is explicitly defined in RFC4408"
            }
            Else {
                switch -Regex ($SPF) {
                    '~all' {
                        $SpfAdvisory = "An SPF-record is configured but the policy is not sufficiently strict."
                    }
                    '-all' {
                        $SpfAdvisory = "An SPF-record is configured and the policy is sufficiently strict."
                    }
                    "\?all" {
                        $SpfAdvisory = "Your domain has a valid SPF record but your policy is not effective enough."
                    }
                    '\+all' {
                        $SpfAdvisory = "Your domain has a valid SPF record but your policy is not effective enough."
                    }
                    Default {
                        $SpfAdvisory = "No qualifier found. Your domain has a SPF record but your policy is not effective enough."
                    }
                }
            }
            
            # Check DKIM-record
            $DKIM = $null
            if ($DkimSelector) {
                $DKIM = Resolve-DnsName -Type TXT -Name "$($DkimSelector)._domainkey.$($Domain)" @SplatParameters | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                if ($DKIM -eq $null) {
                    $DkimAdvisory = "No DKIM-record found for selector $($DkimSelector)._domainkey."
                }
                elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                    $DkimAdvisory = "DKIM-record found."
                }
            }
            else {
                # Microsoft default DKIM check
                $DKIM = Resolve-DnsName -Type TXT -Name selector1._domainkey.$Domain @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                if ($DKIM -eq $null) {
                    $DkimAdvisory = "We couldn't find a DKIM record associated with your domain."
                }
                elseif ($DKIM -match "v=DKIM1") {
                    $DkimSelector = "selector1"
                    $DkimAdvisory = "DKIM-record found."
                } 
            }
            if ($DKIM -eq $null) {
                $DkimSelector = $null
                # If DKIM is empty try different DKIM selectors
                foreach ($DkimSelector in $DkimSelectors) {
                    $DKIM = Resolve-DnsName -Type TXT -Name  "$($DkimSelector)._domainkey.$($Domain)" @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                    if ($DKIM -eq $null) {
                        $DkimAdvisory = "We couldn't find a DKIM record associated with your domain."
                    }
                    elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                        $DkimAdvisory = "DKIM-record found."
                        break
                    } 
                }
            }
        
            # Check DMARC-record
            $DMARC = $null
            $DMARC = Resolve-DnsName -type TXT -name _dmarc.$Domain @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
            if ($DMARC -eq $null) {
                $DmarcAdvisory = "Does not have a DMARC record. This domain is at risk to being abused by phishers and spammers."
            }
            Else {
                switch -Regex ($DMARC) {
                    ('p=none') {
                        $DmarcAdvisory = "Domain has a valid DMARC record but the DMARC (subdomain) policy does not prevent abuse of your domain by phishers and spammers."
                    }
                    ('p=quarantine') {
                        $DmarcAdvisory = "Domain has a DMARC record and it is set to p=quarantine. To fully take advantage of DMARC, the policy should be set to p=reject."
                    }
                    ('p=reject') {
                        $DmarcAdvisory = "Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers."
                    }
                }
            }

            $ReturnValues = [SpfDkimDmarc]::New($Domain, $SPF, $SpfAdvisory, $DMARC, $DmarcAdvisory, $DkimSelector, $DKIM, $DkimAdvisory)

            $ReturnValues  
        }
        if ($file) {
            foreach ($Domain in (Get-Content -Path $file)) {
                StartDomainHealthCheck -Domain $Domain
            }
        }
        if ($Name) {
            StartDomainHealthCheck -Domain $Name
        } 
    } end {}
}