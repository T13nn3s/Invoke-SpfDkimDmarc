<#>
.HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md'
#>
function Get-SPFRecord {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the SPF-record."
        )][string]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$Server
    )

    begin {

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

        $SpfObject = New-Object System.Collections.Generic.List[System.Object]
    }

    Process {
        $SPF = Resolve-DnsName -Name $Name -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
        if ($SPF -match "redirect") {
            $redirect = $SPF.Split(" ")
            $RedirectName = $redirect -match "redirect" -replace "redirect="
            $SPF = Resolve-DnsName -Name "$RedirectName" -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
        }

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
        
    } end {

        $SpfReturnValues = New-Object psobject
        $SpfReturnValues | Add-Member NoteProperty "Name" $Name
        $SpfReturnValues | Add-Member NoteProperty "SPFRecord" "$($SPF)"
        $SpfReturnValues | Add-Member NoteProperty "SPFAdvisory" $SpfAdvisory
        $SpfObject.Add($SpfReturnValues)
        $SpfReturnValues
    }
}
Set-Alias gspf -Value Get-SPFRecord