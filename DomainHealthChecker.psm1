<#>
HelpInfoURI 'https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Invoke-SpfDkimDmarc.md'
#>

# Load public functions
$PublicFolder = Join-Path -Path $PSScriptRoot -ChildPath 'public'
if (Test-Path -Path $PublicFolder) {
    Get-ChildItem -Path $PublicFolder -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }
}

# Load private functions
$PrivateFolder = Join-Path -Path $PSScriptRoot -ChildPath 'private'
if (Test-Path -Path $PrivateFolder) {
    Get-ChildItem -Path $PrivateFolder -Filter "*.ps1" -File | ForEach-Object { . $_.FullName }
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
        [string[]]$Name,

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
        [string]$Server,

        [Parameter(Mandatory = $false,
            HelpMessage = "Skip the update check on module.",
            Position = 5)]
        [switch]$SkipUpdateCheck
    )

    begin {

        # Check if there is an update available
        if (!$SkipUpdateCheck) {
        try {
            Update-ModuleDomainHealthChecker -Verbose:$False
        }
        catch {
            Write-Verbose "No update check could be performed: $_"
        }
    }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $InvokeObject = New-Object System.Collections.Generic.List[System.Object]        
    } process {

        $Splat = @{}
        $DKIMSplat = @{}

        switch -Regex ($True) { 
            { $Server -and !$DkimSelector } {
                $Splat += @{ 
                    'Server' = $Server
                } 
            } 
            { $DkimSelector -and !$Server } {
                $DKIMSplat += @{
                    'DkimSelector' = $DkimSelector
                } 
            } 
            { $DkimSelector -and $Server } { 
                $DKIMSplat += @{
                    'DkimSelector' = $DkimSelector
                }
                $Splat += @{ 
                    'Server' = $Server
                }
            }
        }

        # If 'File' parameter is used
        if ($PSBoundParameters.ContainsKey('File')) {
            foreach ($Name in (Get-Content -Path $File)) {
                $SPF = Get-SPFRecord -Name $Name @Splat
                $DKIM = Get-DKIMRecord -Name $Name @Splat @DKIMSplat
                $DMARC = Get-DMARCRecord -Name $Name @Splat
                $MTASTS = Invoke-MtaSTS -Name $Name @Splat
                $BIMI = Get-BimiRecord -Name $Name @Splat
                $DNSSEC = Get-DNSSec -Name $Name @Splat

                $InvokeReturnValues = New-Object psobject
                $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
                $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
                $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" $SPF.SPFRecordDnsLookupCount
                $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
                $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" "$($DKIM.DkimRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
                $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
                $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "BimiRecord" "$($BIMI.BimiRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "BimiAdvisory" $BIMI.BimiAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
                $InvokeObject.Add($InvokeReturnValues)
                $InvokeReturnValues
            }
        }

        # If 'Name' parameter is used
        if ($PSBoundParameters.ContainsKey('Name')) {
            foreach ($domain in $Name) {
                $SPF = Get-SPFRecord -Name $domain @Splat
                $DKIM = Get-DKIMRecord -Name $domain @Splat @DKIMSplat
                $DMARC = Get-DMARCRecord -Name $domain @Splat
                $MTASTS = Invoke-MtaSTS -Name $domain @Splat
                $DNSSEC = Get-DNSSec -Name $domain @Splat
                $BIMI = Get-BimiRecord -Name $domain @Splat

                $InvokeReturnValues = New-Object psobject
                $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
                $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
                $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" $SPF.SPFRecordDnsLookupCount
                $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
                $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" "$($DKIM.DkimRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
                $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
                $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "BimiRecord" "$($BIMI.BimiRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "BimiAdvisory" $BIMI.BimiAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
                $InvokeObject.Add($InvokeReturnValues)
                $InvokeReturnValues
            }
        }
    }
    end {
  
    }
}

Set-Alias Show-SpfDkimDmarc -Value Invoke-SpfDkimDmarc
Set-Alias isdd -Value Invoke-SpfDkimDmarc