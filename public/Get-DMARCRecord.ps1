<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DMARCRecord.md'
#>

# Load private functions
Get-ChildItem -Path ..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-DMARCRecord {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the DMARC-record."
        )][string[]]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$Server
    )

    begin {

        # Determine OS platform
        try {
            Write-Verbose "Determining OS platform"
            $OsPlatform = (Get-OsPlatform).Platform
        }
        catch {
            Write-Verbose "Failed to determine OS platform, defaulting to Windows"
            $OsPlatform = "Windows"
        }

        # Linux or macOS: Check if dnsutils is installed
        if ($OsPlatform -eq "Linux" -or $OsPlatform -eq "macOS") {
            Test-DnsUtilsInstalled -Verbose:$PSBoundParameters.Verbose
        }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $DMARCObject = New-Object System.Collections.Generic.List[System.Object]     

    } Process {

        foreach ($domain in $Name) {

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

            if ($OsPlatform -eq "Windows") {
                Write-Verbose "Querying DMARC record for $domain"
                $DMARC = Resolve-DnsName -Name "_dmarc.$($domain)" -Type TXT @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
            } elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                $DMARC = $(dig TXT "_dmarc.$($domain)" +short | Out-String).Trim()
            } elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                $DMARC = $(dig TXT "_dmarc.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
            }
            
            if ($null -eq $DMARC) {
                Write-Verbose "No DMARC record found for $domain"
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
                        $DmarcAdvisory = "Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers. "
                    }
                ('sp=none') {
                        $DmarcAdvisory += "The subdomain policy does not prevent abuse of your domain by phishers and spammers."
                    }
                ('sp=quarantine') {
                        $DmarcAdvisory += "The subdomain has a DMARC record and it is set to sp=quarantine. To prevent you subdomains configure the policy to sp=reject."
                    }
                ('sp=reject') {
                        $DmarcAdvisory += "The subdomain policy prevent abuse of your domain by phishers and spammers."
                    }
                }
            }
            $DMARCReturnValues = New-Object psobject
            $DMARCReturnValues | Add-Member NoteProperty "Name" $domain
            $DMARCReturnValues | Add-Member NoteProperty "DmarcRecord" "$($DMARC)"
            $DMARCReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DmarcAdvisory
            $DMARCObject.Add($DMARCReturnValues)
            $DMARCReturnValues

            
        }
    } end {}
}

Set-Alias -Name gdmarc -Value Get-DMARCRecord