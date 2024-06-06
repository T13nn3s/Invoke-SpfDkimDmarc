<#>
.HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-MTASTS.md'
#>
function Invoke-MtaSts {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the MTA-STS record."
        )][string]$Name,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$ServerF
    )

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

        $MtaObject = New-Object System.Collections.Generic.List[System.Object]

        # Test if the MX record mail server supports TLS
        # Test-MxTls -MxHostname aspmx.l.google.com
        function Test-MxTls {
            [CmdletBinding()]
            param(
                [string]$MxHostname
            )

            # https://www.checktls.com/TestReceiver
            # https://www.alitajran.com/test-smtp-connection-with-telnet-powershell-script/

            try {
                $ret = @()
                $socket = New-Object System.Net.Sockets.TcpClient($MxHostname, 25)

                $stream = $socket.GetStream()
                $writer = New-Object System.IO.StreamWriter($stream)
                $buffer = New-Object System.Byte[] 1024
                $encoding = New-Object System.Text.AsciiEncoding
                Start-Sleep -Milliseconds 100
                While ( $stream.DataAvailable ) {
                    $read = $stream.Read($buffer, 0, 1024)
                    $ret += $encoding.GetString($buffer, 0, $read)
                }

                $writer.WriteLine("EHLO TestingTLS")
                $writer.Flush()
                Start-Sleep -Milliseconds 100
                While ( $stream.DataAvailable ) {
                    $read = $stream.Read($buffer, 0, 1024)
                    $ret += $encoding.GetString($buffer, 0, $read)
                }

                $writer.WriteLine("STARTTLS")
                $writer.Flush()
                Start-Sleep -Milliseconds 500
                While ( $stream.DataAvailable ) {
                    $read = $stream.Read($buffer, 0, 1024)
                    $ret += $encoding.GetString($buffer, 0, $read)
                }

                return !!($ret -match "220")
            }
            catch {
                Write-Error $_
                return $false
            }
        }
    }

    Process {
        # Check if the MX records are all covered by the MTA file and there's no extra or few MTA MX records configured. return true if all ok
        function Get-MxMta {
            [CmdletBinding()]
            param(
                [string]$domainName,
                [string]$mtsStsFileContents
            )

            $_mx = Resolve-DnsName -Name $domainName -Type MX | Select-Object -ExpandProperty NameExchange
            Write-Verbose "MX: $($_mx)"
            $_mta = $mtsStsFileContents.Split("`n") -match '(?<=mx: ).*$' | ForEach-Object { $_.Replace("mx:", "").Trim() }
            Write-Verbose "MTA: $($_mta)"

            # Get all MX and MTA matches
            $ret = $_mx | ForEach-Object { $i = $_; $_mta | ForEach-Object { if ( $i -like $_ ) { [PSCustomObject]@{ MX = $i; MTA = $_ } } } }
            Write-Verbose "Matches: `n $($ret | Out-String)"

            $res = Compare-Object -ReferenceObject $ret.MX -DifferenceObject (Resolve-DnsName -Name $domainName -Type MX | Select-Object -ExpandProperty NameExchange) # if differences, some MX records are not in MTA
            $res += Compare-Object -ReferenceObject ($ret.MTA | Select-Object -Unique) -DifferenceObject $_mta

            return (!$res)
        }

        $cti = (Get-Culture).TextInfo

        $mtsStsDns = (Resolve-DnsName -Name "_mta-sts.$($Name)" -Type TXT -ErrorAction SilentlyContinue | Where-Object { $_.Name -eq "_mta-sts.$($Name)" -and $_.Strings -match "v=STSv1" } | Select-Object -ExpandProperty Strings) -join "`n"
        Write-Verbose "mtsStsDns: $($mtsStsDns)"

        try { 
            $mtsStsFile = Invoke-WebRequest "https://mta-sts.$($Name)/.well-known/mta-sts.txt" -UseBasicParsing -DisableKeepAlive | Select-Object -ExpandProperty Content 
        }
        catch { 
            $mtsStsFile = $null 
        }
        Write-Verbose "mtsStsFile: $($mtsStsFile)"

        $mtaRecord = $mtsStsDns

        switch -Regex ($mtsStsDns) {
            { !$_ } {
                $mtaAdvisory = "The MTA-STS DNS record doesn't exist. "; continue
            }
            { $_.Split("`n").Count -ne 1 } { $mtaAdvisory = "There are multiple MTA-STS DNS records. " }
            { $_ -notmatch 'STSv1' }
            { $mtaAdvisory = "The MTA-STS version is not configured properly. Only STSv1 is supported. " }
            { $_ -notmatch 'id=([^;\s]{1,32})(?:;|$)' } { $mtaAdvisory = "The MTA-STS id must be alphanumeric and no longer than 32 characters. " }
            default {

                switch -Regex ($mtsStsFile) {
                    { !$_ } { $mtaAdvisory = "The MTA-STS file doesn't exist. "; continue }
                    { $_ -notmatch 'version:\s*(STSv1)' } { $mtaAdvisory = "The MTA-STS version is not configured in the file. The only options is STSv1. " }
                    { $_ -notmatch 'mode:\s*(enforce|none|testing)' } { $mtaAdvisory = "The MTA-STS mode is not configured in the file. Options are Enforce, Testing and None. " }
                    { $_ -match 'mode:\sF*(enforce|none|testing)' -and $_ -notmatch 'mode:\s*Enforce' } { $mtaAdvisory = "The MTA-STS file is configured in $($null = $_ -match 'mode:\s*(enforce|none|testing)'; $cti.ToTitleCase($Matches[1].ToLower()) ) mode and not protecting interception or tampering. " }
                    { !($_.Split("`n") -match '(?<=mx: ).*$') } { $mtaAdvisory = "The MTA-STS file doesn't have any MX record configured. " }
                    { $_.Split("`n") -match '(?<=mx: ).*$' -and ( !(Get-MxMta -domainName $Name -mtsStsFileContents $mtsStsFile) ) } { $mtaAdvisory = "The MTA-STS file MX records don't match with the MX records configured in the domain. " }


                    { $_.Split("`n") -match '(?<=mx: ).*$' -and ( Resolve-DnsName -Name $Name -Type MX | Select-Object -ExpandProperty NameExchange | ForEach-Object { Test-MxTls -MxHostname $_ -Verbose } ) -contains $false } { $mtaAdvisory = "At least one of the MX records configured in the MTA-STS file MX records list doesn't support TLS. " }
                    { $_ -notmatch 'max_age:\s*(604800|31557600)' } { $mtaAdvisory = "The MTA-STS max age configured in the file should be greater than 604800 seconds and less than 31557600 seconds. " }
                    default {
                        $mtaAdvisory = "The domain has the MTA-STS DNS record and file configured and protected against interception or tampering."
                    }
                }
            }
        }
    }

    End {

        $MtaReturnValues = New-Object psobject
        $MtaReturnValues | Add-Member NoteProperty "mtaRecord" $mtaRecord
        $MtaReturnValues | Add-Member NoteProperty "mtaAdvisory" $mtaAdvisory
        $MtaObject.Add($MtaReturnValues)
        $MtaReturnValues

    }
}

#Invoke-MtaSts -Name microsoft.com -Verbose

Set-Alias -Name gmta -Value Get-MTASTS