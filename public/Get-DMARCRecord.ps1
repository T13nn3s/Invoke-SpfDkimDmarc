<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DMARCRecord.md'
#>
function Get-DMARCRecord {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the DMARC-record."
        )][string]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$Server
    )

    begin {

        if ($PSBoundParameters.ContainsKey('Server')) {
            $SplatParameters = @{
                'Type'        = 'TXT'
                'Name'        = "_dmarc.$($Name)"
                'Server'      = $Server
                'ErrorAction' = 'SilentlyContinue'
            }
        }
        Else {
            $SplatParameters = @{
                'Type'        = 'TXT'
                'Name'        = "_dmarc.$($Name)"
                'ErrorAction' = 'SilentlyContinue'
            }
        }

        $DMARCObject = New-Object System.Collections.Generic.List[System.Object]
    }

    Process {
        $DMARC = Resolve-DnsName @SplatParameters | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
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
    } 
    end {
        $DMARCReturnValues = New-Object psobject
        $DMARCReturnValues | Add-Member NoteProperty "Name" $Name
        $DMARCReturnValues | Add-Member NoteProperty "DmarcRecord" "$($DMARC)"
        $DMARCReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DmarcAdvisory
        $DMARCObject.Add($DMARCReturnValues)
        $DMARCReturnValues
    }
}
Set-Alias -Name gdmarc -Value Get-DMARCRecord