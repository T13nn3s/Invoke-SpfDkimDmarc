<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Invoke-SpfDkimDmarc.md'
#>

# Load functions
Get-ChildItem -Path $PSScriptRoot\public\*.ps1 | 
ForEach-Object {
    . $_.FullName
}

function Invoke-SpfDkimDmarc {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory, ParameterSetName = 'domain',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the SPF, DKIM and DMARC-record.",
            Position = 1)]
        [string]$Name,

        [Parameter(
            Mandatory, ParameterSetName = 'file',
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Show SPF, DKIM and DMARC-records from multiple domains from a file.",
            Position = 2)]
        [Alias('Path')]
        [System.IO.FileInfo]$File,

        [Parameter(Mandatory = $False,
            HelpMessage = "Specify a custom DKIM selector.",
            Position = 3)]
        [string]$DkimSelector,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.",
            Position = 4)]
        [string]$Server
    )

    begin {
        $InvokeObject = New-Object System.Collections.Generic.List[System.Object]        
    } process {
        function StartDomainHealthCheck($Name, $DkimSelector) {
            if ($DkimSelector) {
                $Splat = @{
                    'DkimSelector' = $DkimSelector
                }
            }

            $SPF = Get-SPFRecord -Name $Name
            $DKIM = Get-DKIMRecord -Name $Name @Splat
            $DMARC = Get-DMARCRecord -Name $Name

            $InvokeReturnValues = New-Object psobject
            $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
            $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
            $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
            $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
            $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory
            $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" "$($DKIM.DkimRecord)"
            $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
            $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
            $InvokeObject.Add($InvokeReturnValues)
            $InvokeReturnValues
        }
    }
    end {
        if ($file) {
            foreach ($Name in (Get-Content -Path $File)) {
                StartDomainHealthCheck -Name $Name
            }
        }
        if ($Name) {
            StartDomainHealthCheck -Name $Name
        }
    }
}

Set-Alias Show-SpfDkimDmarc -Value Invoke-SpfDkimDmarc
Set-Alias isdd -Value Invoke-SpfDkimDmarc