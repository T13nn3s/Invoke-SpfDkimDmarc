<#>
.HelpInfoURI 'https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md'
#>

# Load private functions
Get-ChildItem -Path ..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-SPFRecord {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Enter one or more domain names to resolve their SPF records."
        )][string[]]$Name,

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
            Test-DnsUtilsInstalled -Verbose:$PSBoundParameters.Verbose
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

        $SpfObject = New-Object System.Collections.Generic.List[System.Object]
    }

    Process {
        foreach ($domain in $Name) {
            Write-Verbose "Processing domain: $domain"

            # Get SPF record from specified domain
            if ($OsPlatform -eq "Windows") {
                $SPF = Resolve-DnsName -Name $domain -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
            }
            Elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                $SPF = $(dig TXT $domain +short | grep "v=spf1" | Out-String)
            }
            Elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                $SPF = $(dig TXT $domain +short NS @$SplatParameters.Server | grep "v=spf1" | Out-String)
            }
            
            # Checks for SPF redirect and follow the redirect
            if ($SPF -match "redirect") {
                $redirect = $SPF.Split(" ")
                $RedirectName = $redirect -match "redirect" -replace "redirect="
                if ($OsPlatform -eq "Windows") {
                    $SPF = Resolve-DnsName -Name "$RedirectName" -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                }
                elseif ($OsPlatform -eq "macOS" -or $POslatform -eq "Linux") {
                    $SPF = $(dig TXT $RedirectName +short | grep "v=spf1" | Out-String)
                }
                Elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                    $SPF = $(dig TXT $RedirectName +short NS @$SplatParameters.Server | grep "v=spf1" | Out-String)
                }
            }

            # Check for multiple SPF records
            $RecipientServer = "v=spf1"
            $SPFCount = ($SPF -match $RecipientServer).count
            
            # If there is no SPF record 
            if ($null -eq $SPF) {
                $SpfAdvisory = "Domain does not have an SPF record. To prevent abuse of this domain, please add an SPF record to it."
            }
            elseif ($SPFCount -gt 1) {
                $SpfAdvisory = "Domain has more than one SPF record. Only one SPF record per domain is allowed. This is explicitly defined in RFC4408."     
                $SpfTotalLenght = 0
                foreach ($char in $SPF) {
                    $SPFTotalLenght += $char.Length
                    $SpfTotalLenght
                }
            }
            Else {
                $SPF = $SPF -join ""
                $SpfTotalLenght = $SPF.Length

                foreach ($mechanism in $SPF) {
                    if ($mechanism.Length -ge 450) {
                        # See: https://datatracker.ietf.org/doc/html/rfc7208#section-3.4
                        $SpfAdvisory += "Your SPF-record has more than 450 characters. This is SHOULD be avoided according to RFC7208. "
                    }
                    elseif ($mechanism.Length -ge 255) {
                        # See: https://datatracker.ietf.org/doc/html/rfc4408#section-3.1.3 
                        $SpfAdvisory = "Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. " 
                    }
                }
            
                switch -Regex ($SPF) {
                    '~all' {
                        $SpfAdvisory += "An SPF-record is configured but the policy is not sufficiently strict."
                    }
                    '-all' {
                        $SpfAdvisory += "An SPF-record is configured and the policy is sufficiently strict."
                    }
                    "\?all" {
                        $SpfAdvisory += "Your domain has a valid SPF record but your policy is not effective enough."
                    }
                    '\+all' {
                        $SpfAdvisory += "Your domain has a valid SPF record but your policy is not effective enough."
                    }
                    Default {
                        $SpfAdvisory += "No qualifier found. Your domain has a SPF record but your policy is not effective enough."
                    }
                }
            }
        
            # Starting Spf Dns Lookup Counter
            # SPF record MUST not exceed 10 DNS Lookups
            # See: https://datatracker.ietf.org/doc/html/rfc7208#section-4.6.4
            Write-Verbose "Starting calculation of SPF DNS Lookup count"
            $SpfDnsLookupCount = 0
            $includedDomain

            # Get the mechanisms that count towards the DNS lookup limit
            $SpfDnsLookupCountMechanisms = $SPF -split " " | Where-Object { $_ -match "^(include:|a:|mx:|a$|mx$|ptr$)" }

            foreach ($SpfDnsLookupCountMechanism in $SpfDnsLookupCountMechanisms) {
                Write-Verbose "Processing mechanism: $SpfDnsLookupCountMechanism"
                switch -Regex ($SpfDnsLookupCountMechanism) {
                    "^include:(\S+)" {
                        $SpfDnsLookupCount += 1
                        $includedDomain = $Matches[1]
                        try {
                            if ($OsPlatform -eq "Windows") {
                                $includedSpfRecord = Resolve-DnsName -Name $includedDomain -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                            }
                            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                                $includedSpfRecord = $(dig TXT $includedDomain +short | grep "v=spf1" | Out-String)
                            }
                            elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                                $includedSpfRecord = $(dig TXT $includedDomain +short NS @$SplatParameters.Server | grep "v=spf1" | Out-String)
                            }
                            
                            $includedSpfRecord -split " " | ForEach-Object {
                                switch -Regex ($_) {
                                    "^a:" {
                                        $SpfDnsLookupCount += 1
                                        Write-Verbose "Counting $($_) nested mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                    }
                                    "^a$" {
                                        $SpfDnsLookupCount += 1
                                        Write-Verbose "Counting $($_) nested mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                    }
                                    "^mx$" {
                                        $SpfDnsLookupCount += 1
                                        Write-Verbose "Counting $($_) nested mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                    }
                                    "^ptr$" {
                                        $SpfDnsLookupCount += 1
                                        Write-Verbose "Counting $($_) nested mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                    }
                                    "^include:(\S+)" {
                                        Write-Verbose "Found nested include: $($Matches[1]) in $($SpfDnsLookupCountMechanism)"
                                        $SpfDnsLookupCount += 1
                                        try {
                                            if ($OsPlatform -eq "Windows") {
                                                $nestedIncludedSpfRecord = Resolve-DnsName -Name $Matches[1] -Type TXT @SplatParameters | where-object { $_.strings -match "v=spf1" } | Select-Object -ExpandProperty strings -ErrorAction SilentlyContinue
                                            } elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                                                $nestedIncludedSpfRecord = $(dig TXT $Matches[1] +short | grep "v=spf1" | Out-String)
                                            } elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                                                $nestedIncludedSpfRecord = $(dig TXT $Matches[1] +short NS @$SplatParameters.Server | grep "v=spf1" | Out-String)
                                            }
                                            
                                            switch -Regex ($nestedIncludedSpfRecord) {
                                                "^include:(\S+)" {
                                                    $SpfDnsLookupCount += 1
                                                    Write-Verbose "Counting nested $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                                }
                                                "^a:" {
                                                    $SpfDnsLookupCount += 1
                                                    Write-Verbose "Counting nested $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                                }
                                                "^a$" {
                                                    $SpfDnsLookupCount += 1
                                                    Write-Verbose "Counting nested $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                                }
                                                "^mx$" {
                                                    $SpfDnsLookupCount += 1
                                                    Write-Verbose "Counting nested $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                                }
                                                "^ptr$" {
                                                    $SpfDnsLookupCount += 1
                                                    Write-Verbose "Counting nested $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                                                }
                                            }                                     
                                        }
                                        Catch {
                                            Write-Error "Failed to resolve SPF record for $($Matches[1])"
                                        }
                                    }
                                }
                            }
                                        
                        }
                        Catch {
                            Write-Error "Failed to resolve SPF record for $includedDomain"
                        }
                    }
                    "^a:" {
                        $SpfDnsLookupCount += 1
                        Write-Verbose "Counting $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                    }
                    "^a$" {
                        $SpfDnsLookupCount += 1
                        Write-Verbose "Counting $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                    }
                    "^mx$" {
                        $SpfDnsLookupCount += 1
                        Write-Verbose "Counting $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                    }
                    "^ptr$" {
                        $SpfDnsLookupCount += 1
                        Write-Verbose "Counting $($_) mechanism for DNS lookup, total so far: $SpfDnsLookupCount"
                    }
                }
            }
        }   
        foreach ($domain in $name) {

            $SpfReturnValues = New-Object psobject
            $SpfReturnValues | Add-Member NoteProperty "Name" $domain
            $SpfReturnValues | Add-Member NoteProperty "SPFRecord" "$($SPF)"
            $SpfReturnValues | Add-Member NoteProperty "SPFRecordLength" "$($SpfTotalLenght)"
            if ($SpfDnsLookupCount -eq 10) {
                $SpfReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" "$($SpfDnsLookupCount)/10 (Ok, but maximum DNS Lookups reached!)"
            }
            elseif ($SpfDnsLookupCount -gt 8) {
                $SpfReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" "$($SpfDnsLookupCount)/10 (Ok, but watch your DNS Lookups!)"
            }
            else {
                $SpfReturnValues | Add-Member NoteProperty "SPFRecordDnsLookupCount" "$($SpfDnsLookupCount)/10 (OK)"
            }
            $SpfReturnValues | Add-Member NoteProperty "SPFAdvisory" $SpfAdvisory
            $SpfObject.Add($SpfReturnValues)
            $SpfReturnValues
        }
    } end {}
} 
Set-Alias gspf -Value Get-SPFRecord