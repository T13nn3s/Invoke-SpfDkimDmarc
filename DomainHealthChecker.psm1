<#>
HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/README.md'
#>

# Load functions
Get-ChildItem -Path $PSScriptRoot\public\*.ps1 | 
ForEach-Object {
    . $_.FullName
}

function Show-SpfDkimDmarc {
    [CmdletBinding]
    
}