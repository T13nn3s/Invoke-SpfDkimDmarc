
<#PSScriptInfo

.VERSION 1.3.1

.GUID 829d6e7f-2d4c-40de-9ead-36e508258b89

.AUTHOR Martien van Dijk

.COMPANYNAME Avantage IT

.COPYRIGHT (c) 2021 Martien van Dijk @ All rights reserved.

.TAGS @('Windows','Email','Security','Email Security','SPF','DKIM','DMARC')

.LICENSEURI https://github.com/T13nn3s/DomainHealthChecker/blob/main/LICENSE

.PROJECTURI https://github.com/T13nn3s/Show-SpfDkimDmarc

.ICONURI

.EXTERNALMODULEDEPENDENCIES 

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES https://github.com/T13nn3s/Show-SpfDkimDmarc

.PRIVATEDATA

#>

<# 

.DESCRIPTION 
 Is your email domain properly protected against abuse, such as email spoofing? This form of abuse can cause (image) damage to an organization. The PowerShell script DomainHealthChecker.ps1 checks the SPF, DKIM and DMARC record of one or more email domains and gives advice if necessary. 
#> 

Param()
function Show-SpfDkimDmarc {
    [CmdletBinding()]
    param (
        # Check a single domain
        [Parameter(
            Mandatory, ParameterSetName = 'domain',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specify domain name whose SPF, DMARC and DKIM record should be checked.",
            Position = 1)]
        [string]$Name,

        # Check domains from a file
        [Parameter(
            Mandatory, ParameterSetName = 'file',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies file name which contains a list of domain names.",
            Position = 2)]
        [System.IO.FileInfo]$File,

        # Custom DKIM Selector
        [Parameter(Mandatory = $False,
            HelpMessage = "Specify a custom DKIM selector.",
            Position = 3)]
        [string]$DkimSelector,

        # DNS Server to use
        [Parameter(Mandatory = $false,
            Position = 4)]
        [string]$Server = "1.1.1.1"
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
            $SPF = Resolve-DnsName -type TXT -name $Domain -server $Server -ErrorAction SilentlyContinue | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings
            if ($SPF -eq $null) {
                $SpfAdvisory = "No SPF record found."
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
                $DKIM = Resolve-DnsName -Type TXT -Name "$($DkimSelector)._domainkey.$($Domain)" -Server $Server -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                if ($DKIM -like " ") {
                    $DkimAdvisory = "No DKIM-record found for selector $($DkimSelector)._domainkey."
                }
                elseif ($DKIM -match "v=DKIM1") {
                    $DkimAdvisory = "DKIM-record found."
                    $DkimAdvisory
                }
            }
            Else {
                $DkimSelector = "selector1" # Microsoft
                $CnameSelector1 = Resolve-DnsName -Type CNAME -Name "$($DkimSelector)._domainkey.$Domain" -server $Server -ErrorAction SilentlyContinue
                if ($CnameSelector1.Name -notmatch "domainkey") {
                    $DkimAdvisory = "We couldn't find a DKIM record associated with your domain."
                }
                else {
                    $DKIM = Resolve-DnsName -Type TXT -Name $CnameSelector1.namehost -server $Server | Select-Object -ExpandProperty strings
                    if ($DKIM -like "") {
                        $DkimAdvisory = "We couldn't find a DKIM record associated with your domain."
                    }
                    elseif ($DKIM -match "v=DKIM1") {
                        $DkimAdvisory = "DKIM-record is valid."
                    } 
                }
            }
        
            # Check DMARC-record
            $DMARC = Resolve-DnsName -type TXT -name _dmarc.$Domain -Server $Server -ErrorAction SilentlyContinue | Select-Object -ExpandProperty strings
            if ($DMARC -like "") {
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