<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-BIMI.md'
#>

# Load private functions
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

# Load public functions
$PublicFolder = Join-Path -Path $PSScriptRoot -ChildPath 'public'
if (Test-Path -Path $PublicFolder) {
    Get-ChildItem -Path $PublicFolder -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }
}

function Get-BimiRecord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the BIMI-record.",
            Position = 1)]
        [string[]]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.",
            Position = 2)]
        [string]$Server
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

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
            Test-DnsUtilsInstalled
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

        $BimiObject = New-Object System.Collections.Generic.List[System.Object]

    } process {

        foreach ($domain in $Name) {
            Write-Verbose "Resolving BIMI record for domain: $domain"

            # DMARC policy must be configured to at 'quarantine' or 'reject' for BIMI to function
            # DMARC quarantine policies MUST NOT have a pct less than 'pct=100'.
            # See: https://datatracker.ietf.org/doc/html/draft-brand-indicators-for-message-identification-12
            try {

                Write-Verbose "Checking DMARC record for domain: $domain"
                $DmarcPolicy = Get-DMARCRecord -Name $domain @SplatParameters
            }
            Catch {
                Write-Verbose "No DMARC record found for domain: $domain"
                $null = $DmarcPolicy
            } 
            
            if ($null -eq $DmarcPolicy) {
                Write-Verbose "No DMARC record found for $domain"
                $BimiAdvisory = "Does not have a DMARC record. To use BIMI, this domain must have a DMARC record with a policy of at least p=quarantine and pct=100."
            }
            else {
                switch -Regex ($DmarcPolicy) {
                    ('p=none') {
                        $BimiAdvisory = "DMARC policy is set to p=none. BIMI requires a DMARC policy of at least p=quarantine to function."
                    }
                    ('p=quarantine') {
                        $BimiAdvisory = "DMARC policy is set to p=quarantine. While BIMI can function with this policy, it is recommended to use p=reject for better protection."
                    }
                    ('p=reject') {
                        $BimiAdvisory = "DMARC policy is set to p=reject. This is optimal for BIMI functionality."
                    }
                    ('pct=(\d{1,2}|100)') {
                        $pctValue = [int]$Matches[1]
                        if ($pctValue -lt 100) {
                            $BimiAdvisory += "DMARC policy pct is set to less than 100%. BIMI requires a DMARC policy with pct=100 to function."
                        }
                    }
                }

            }

            if ($OsPlatform -eq "Windows") {
                $bimiRecord = Resolve-DnsName -Type TXT -Name "default._bimi.$($domain)" @SplatParameters | Select-Object -ExpandProperty strings
            }
            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                $bimiRecord = $(dig TXT "default._bimi.$($domain)" +short | Out-String).Trim()
            }
            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                $bimiRecord = $(dig TXT "default._bimi.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
            }

            if ($null -eq $bimiRecord -or $bimiRecord -eq "") {
                Write-Verbose "No BIMI record found for $domain"
                $BimiAdvisory += " No BIMI record found for domain."
                $BimiRecord = "No BiMI record found."
            }

            $BimiReturnValues = New-Object psobject
            $BimiReturnValues | Add-Member NoteProperty "Name" $domain
            $BimiReturnValues | Add-Member NoteProperty "BimiRecord" $BimiRecord
            $BimiReturnValues | Add-Member NoteProperty "BimiAdvisory" $BimiAdvisory
            $BimiObject.Add($BimiReturnValues)
            $BimiReturnValues
        }
    } end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}
Set-Alias -Name gbimi -Value Get-BimiRecord