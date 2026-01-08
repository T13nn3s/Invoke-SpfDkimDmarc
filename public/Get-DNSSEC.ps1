<#>
.HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DNSSec.md'
#>

# Load private functions
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-DNSSec {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain name for testing for DNSSEC existance.")]
        [string[]]$Name,

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
            Test-DnsUtilsInstalled
        }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

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

        $DnsSecObject = New-Object System.Collections.Generic.List[System.Object]
    }

    process {

        foreach ($domain in $Name) {
            if ($OsPlatform -eq "Windows") {
                Write-Verbose "Querying DNSKEY records for $domain"
                $DnsSec_record = Resolve-DnsName -Name $domain -Type 'DNSKEY' @SplatParameters
                foreach ($record in $DnsSec_record) {
                    if ($record.type -contains "DNSKEY") {
                        if ($record.flags -band 256) {
                            Write-Verbose "Flag set to: $($record.flags), indicate DNSSEC is enabled."
                            $DnsSec = "Domain is DNSSEC signed."
                            $DnsSecAdvisory = "Great! DNSSEC is enabled on your domain."
                        }
                        Else {
                            Write-Verbose "No DNSKEY records found with the correct flags."
                            $DnsSec = "No DNSKEY records found."
                            $DnsSecAdvisory = "Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks."
                        }
                    }
                    Else {
                        Write-Verbose "No DNSKEY records found."
                        $DnsSec = "No DNSKEY records found."
                        $DnsSecAdvisory = "Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks."
                    }
                }
            }
            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                $DnsSec_record = $(dig DNSKEY $domain +short | Out-String)
                if ($null -ne $DnsSec_record) {
                    Write-Verbose "DNSKEY record found, checking flags and protocol..."
                    # See: https://datatracker.ietf.org/doc/html/rfc4034#section-2.2
                    $flag = [int]$DnsSec_record.split(" ")[0]
                    $Protocol = [int]$DnsSec_record.split(" ")[1]
                    if ($flag -band 256 -and $Protocol -eq 3) {
                        Write-Verbose "Flag set to: $($flag), and Protocol set to: $($Protocol), indicate DNSSEC is enabled."
                        $DnsSec = "Domain is DNSSEC signed."
                        $DnsSecAdvisory = "Great! DNSSEC is enabled on your domain."
                    }
                    Else {
                        $DnsSec = "No DNSKEY records found."
                        $DnsSecAdvisory = "Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks."
                    } 
                }
            }
            elseif ($OsPlatform -eq "macOS" -or ($OsPlatform -eq "Linux") -and $Server) {
                $DnsSec_record = $(dig DNSKEY $domain +short NS @$SplatParameters.Server | Out-String)
                
                # See: https://datatracker.ietf.org/doc/html/rfc4034#section-2.2
                $flag = [int]$DnsSec_record.split(" ")[0]
                $Protocol = [int]$DnsSec_record.split(" ")[1]
                if ($flag -band 256 -and $Protocol -eq 3) {
                    $DnsSec = "Domain is DNSSEC signed."
                    $DnsSecAdvisory = "Great! DNSSEC is enabled on your domain."
                }
                Else {
                    $DnsSec = "No DNSKEY records found."
                    $DnsSecAdvisory = "Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks."
                } 
            }
        }
            

        $DnsSecReturnValues = New-Object psobject
        $DnsSecReturnValues | Add-Member NoteProperty "Name" $domain
        $DnsSecReturnValues | Add-Member NoteProperty "DNSSEC" $DnsSec
        $DnsSecReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DnsSecAdvisory
        $DnsSecObject.Add($DnsSecReturnValues)
        $DnsSecReturnValues

    } end {}
}
Set-Alias -Name gdnssec -Value Get-DNSSEC