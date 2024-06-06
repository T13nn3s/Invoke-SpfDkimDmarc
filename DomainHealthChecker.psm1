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
        [string]$Server,

        [Parameter(Mandatory = $False,
            HelpMessage = "Include this switch to check for DNSSEC existance",
            Position = 5)]
        [switch]$IncludeDNSSEC
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $InvokeObject = New-Object System.Collections.Generic.List[System.Object]        
    } process {

        $Splat = @{}

        if ($Server) {
            $Splat += @{
                'Server' = $Server
            }
        } 
        elseif ($DkimSelector) {
            $Splat += @{
                'DkimSelector' = $DkimSelector
            }
        }
        elseif ($DkimSelector -and $Server) {
            $Splat += @{
                'Server'       = $Server
                'DkimSelector' = $DkimSelector
            }
        }
        elseif ($IncludeDNSSEC -and $Server) {
            $Splat += @{
                'Server'        = $Server
                'IncludeDNSSEC' = $True
            }
        }
        elseif ($IncludeDNSSEC -and $Server -and $IncludeDNSSEC) {
            $Splat += @{
                'Server'       = $Server
                'DkimSelector' = $DkimSelector
                IncludeDNSSEC  = $True
            }
        }

        # If 'File' parameter is used
        if ($PSBoundParameters.ContainsKey('File')) {
            foreach ($Name in (Get-Content -Path $File)) {
                $SPF = Get-SPFRecord -Name $Name @Splat
                $DKIM = Get-DKIMRecord -Name $Name @Splat
                $DMARC = Get-DMARCRecord -Name $Name @Splat
                $MTASTS = Invoke-MtaSTS -Name $Name @Splat

                if ($PSBoundParameters.ContainsKey('IncludeDNSSEC')) {
                    $DNSSEC = Get-DNSSec -Name $Name @Splat
                }

                $InvokeReturnValues = New-Object psobject
                $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
                $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
                $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
                $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
                $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory
                $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" "$($DKIM.DkimRecord)"
                $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
                $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
                $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory

                if ($PSBoundParameters.ContainsKey('IncludeDNSSEC')) {
                    $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                    $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
                }

                $InvokeObject.Add($InvokeReturnValues)
                $InvokeReturnValues
            }
        }

        # If 'Name' paramter is used
        if ($PSBoundParameters.ContainsKey('Name')) {
            $SPF = Get-SPFRecord -Name $Name @Splat
            $DKIM = Get-DKIMRecord -Name $Name @Splat
            $DMARC = Get-DMARCRecord -Name $Name @Splat
            $MTASTS = Invoke-MtaSTS -Name $Name @Splat
            
            if ($PSBoundParameters.ContainsKey('IncludeDNSSEC')) {
                $DNSSEC = Get-DNSSec -Name $Name @Splat
            }

            $InvokeReturnValues = New-Object psobject
            $InvokeReturnValues | Add-Member NoteProperty "Name" $SPF.Name
            $InvokeReturnValues | Add-Member NoteProperty "SpfRecord" $SPF.SPFRecord
            $InvokeReturnValues | Add-Member NoteProperty "SpfAdvisory" $SPF.SpfAdvisory
            $InvokeReturnValues | Add-Member NoteProperty "SPFRecordLength" $SPF.SPFRecordLength
            $InvokeReturnValues | Add-Member NoteProperty "DmarcRecord" $DMARC.DmarcRecord
            $InvokeReturnValues | Add-Member NoteProperty "DmarcAdvisory" $DMARC.DmarcAdvisory
            $InvokeReturnValues | Add-Member NoteProperty "DkimRecord" "$($DKIM.DkimRecord)"
            $InvokeReturnValues | Add-Member NoteProperty "DkimSelector" $DKIM.DkimSelector
            $InvokeReturnValues | Add-Member NoteProperty "DkimAdvisory" $DKIM.DkimAdvisory
            $InvokeReturnValues | Add-Member NoteProperty "MtaRecord" $MTASTS.mtaRecord
            $InvokeReturnValues | Add-Member NoteProperty "MtaAdvisory" $MTASTS.mtaAdvisory

            if ($PSBoundParameters.ContainsKey('IncludeDNSSEC')) {
                $InvokeReturnValues | Add-Member NoteProperty "DnsSec" $DNSSEC.DNSSEC
                $InvokeReturnValues | Add-Member NoteProperty "DnsSecAdvisory" $DNSSEC.DnsSecAdvisory
            } 
        }
    }
    end {
        $InvokeObject.Add($InvokeReturnValues)
        $InvokeReturnValues
    }
}

Set-Alias Show-SpfDkimDmarc -Value Invoke-SpfDkimDmarc
Set-Alias isdd -Value Invoke-SpfDkimDmarc