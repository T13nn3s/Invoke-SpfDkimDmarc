<#>
.HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DNSSec.md'
#>
function Get-DNSSec {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain name for testing for DNSSEC existance."
        )][string[]]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$Server
    )

    begin {

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
            $DnsSec_record = Resolve-DnsName -Name $domain -Type 'DNSKEY' @SplatParameters
            foreach ($record in $DnsSec_record) {
                if ($record.type -contains "DNSKEY") {
                    $DnsSec = "Domain is DNSSEC signed."
                    $DnsSecAdvisory = "Great! DNSSEC is enabled on your domain."
                }
                Else {
                    $DnsSec = "No DNSKEY records found."
                    $DnsSecAdvisory = "Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks."
                }
            }

            $DnsSecReturnValues = New-Object psobject
            $DnsSecReturnValues | Add-Member NoteProperty "Name" $domain
            $DnsSecReturnValues | Add-Member NoteProperty "DNSSEC" $DnsSec
            $DnsSecReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DnsSecAdvisory
            $DnsSecObject.Add($DnsSecReturnValues)
            $DnsSecReturnValues
        }
    }

    end {}
}
Set-Alias -Name gdnssec -Value Get-DNSSEC