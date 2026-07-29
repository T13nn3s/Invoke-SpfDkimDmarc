<#>
HelpInfoURI 'https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-CAARecord.md'
#>

# Load private functions
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-CAARecord {
    [CmdletBinding()]
    param (
        [Parameter(
            Mandatory,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the CAA-record.")]
        [string[]]$Name
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $CAAObject = New-Object System.Collections.Generic.List[System.Object]

    }
    process {
        foreach ($domain in $Name) {

            Write-Verbose "Resolving CAA-record for $domain"
            Write-Verbose "Resolving CAA-record with https://cloudflare-dns.com/dns-query?name=$domain&type=CAA"
            
            # Use Cloudflare's DNS over HTTPS API to resolve the CAA record for the domain
            # See: https://developers.cloudflare.com/1.1.1.1/encryption/dns-over-https/make-api-requests/
            try {
                $ApiResponse = Invoke-RestMethod -Uri "https://cloudflare-dns.com/dns-query?name=$domain&type=CAA" -Headers @{ "accept" = "application/dns-json" }
                $AllowedCas = @()
                $null = $iodef =
                if ($ApiResponse.Answer) {
                    Write-verbose "CAA record found for $($domain): $($ApiResponse.Answer | ForEach-Object { $_.data })"
                    $ApiResponse.Answer | ForEach-Object {
                        $CAAValues = Convert-CaaRdata $_.data
                        Write-verbose "Converted CAA record for $($domain): $($CAAValues.Value)"
                        $FilteredCas = $CAAValues | Where-Object {$_.Tag -in @("issue", "issuewild")}
                        $AllowedCas += ($FilteredCas.Value -join ", ")
                        $iodef += $CAAValues.Value -join ", " | Where-Object {$CAAValues.Tag -eq "iodef"}
                    }
                    if ($CAAValues) {
                        $CAARecord = "CAA record found, allowed CAs: $($AllowedCas -join ', ')."
                        if ($iodef) {
                            Write-verbose "CAA record found with IODEF contact information: $iodef"
                            $CAAAdvisory = "CAA record found with IODEF contact information: $iodef"
                        }
                        else {
                            Write-verbose "CAA record found but IODEF not configured."
                            $CAAAdvisory = "CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications."
                        }
                    }
                    else {
                        $CAAAdvisory = "No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for $domain."
                    }
                }
                else {
                    $CAARecord = "No CAA record found."
                    $CAAAdvisory = "No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for $domain."
                    Write-Verbose "No CAA record found for $domain."
                }
            }
            catch {
                Write-Verbose "Failed to resolve CAA-record for $domain. Error: $($_.Exception.Message)"
            }

            $CAAReturnValues = New-Object psobject
            $CAAReturnValues | Add-Member NoteProperty "Name" $domain
            $CAAReturnValues | Add-Member NoteProperty "CAARecord" $CAARecord
            $CAAReturnValues | Add-Member NoteProperty "CAAAdvisory" $CAAAdvisory
            $CAAObject.Add($CAAReturnValues)
            $CAAReturnValues

        }
    }
    end {

    }
}
Set-Alias -Name gcaa -Value Get-CAARecord