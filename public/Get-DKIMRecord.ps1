<#>
HelpInfoURI 'https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DKIMRecord.md'
#>

# Load private functions
Get-ChildItem -Path $PSScriptRoot\..\private\*.ps1 |
ForEach-Object {
    . $_.FullName
}

function Get-DKIMRecord {
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory = $True,
            ValueFromPipeline = $True,
            ValueFromPipelineByPropertyName = $True,
            HelpMessage = "Specifies the domain for resolving the DKIM-record.")]
        [string[]]$Name,

        [Parameter(Mandatory = $False,
            HelpMessage = "Specify a custom DKIM selector.")]
        [string]$DkimSelector,

        [Parameter(Mandatory = $false,
            HelpMessage = "DNS Server to use.")]
        [string]$Server
    )

    begin {

        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        $PSBoundParameters | Out-String | Write-Verbose

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
            Test-DnsUtilsInstalled
        }
        
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
                
        # Custom list of DKIM-selectors
        # See: https://help.sendmarc.com/support/solutions/articles/44001891845-email-provider-commonly-used-dkim-selectors
        # See: https://www.reddit.com/r/DMARC/comments/1bffol7/list_of_most_common_dkim_selectors/
        $DkimSelectors = @(
            'a1' # unknown / generic
            'amazonses' # Amazon SES
            'aweber_key_a' # AWeber
            'aweber_key_b' # AWeber
            'aweber_key_c' # AWeber
            'barracuda' # Barracuda
            'ces' # Cisco Email Security
            'cm' # Campaign Monitor
            'clab1' # Contactlab
            'ctct1' # Constant Contact
            'ctct2' # Constant Contact
            'default' # GoDaddy / secureserver.net
            'dk' # unknown / generic
            'dkim' # Hetzner
            'dkim1024' # Unknown / generic
            'dkim1' # Mailchimp / Mandrill / cPanel / Exim
            'dkim2' # Mailchimp / Mandrill
            'e2ma-k1' # Emma
            'e2ma-k2' # Emma
            'e2ma-k3' # Emma
            'ecm1' # Mapp Digital (former BlueHornet)
            'email' # unknown / generic
            'everlytickey1' # Everlytic
            'everlytickey2' # Everlytic
            'eversrv' # Everlytic OLD selector
            'fm1' # Fastmail
            'fm2' # Fastmail
            'google' # Google Workspace
            'hs1' # HubSpot
            'hs2' # HubSpot
            'k1' # Mailchimp / Mandrill
            'k2' # Mailchimp / Mandrill
            'k3' # Mailchimp / Mandrill
            'key1' # unknown / generic
            'key2' # unknown / generic
            'kl' # Klaviyo
            'kl1' # Klaviyo
            'kl2' # Klaviyo
            'km1' # Klaviyo
            'km2' # Klaviyo
            'kt1' # Klaviyo
            'kt2' # Klaviyo
            'litesrv' # MailerLite
            'm101' # MailUp
            'm102' # MailUp
            'mandrill' # Mailchimp / Mandrill
            'mail' # unknown / generic
            'mailgun' # Mailgun
            'mailjet' # Mailjet
            'mailin' # Sendinblue (legacy)
            'mailpoet1' # MailPoet
            'mailpoet2' # MailPoet
            'mimecast' # Mimecast
            'mte1' # Mailchimp / Mandrill
            'mte2' # Mailchimp / Mandrill
            'mxvault' # Global Micro
            'nce2048' # Netcore Cloud / Netcore Email
            'opentext' # OpenText
            'plesk' # Plesk
            'pm' # Postmark
            'pp' # Proofpoint
            'protonmail' # ProtonMail
            'protonmail2' # ProtonMail
            'protonmail3' # ProtonMail
            'sable' # SableMail
            's1' # Sendgrid / NationBulder
            's2' # Sendgrid / NationBuilder
            'selector1' # Microsoft
            'selector2' # Microsoft
            'sfdc' # Salesforce
            'sib' # Sendinblue / Brevo
            'sig1' # iCloud
            'sm' # Blackbaud, eTapestry
            'sm1' # Blackbaud, eTapestry
            'sm2' # Blackbaud, eTapestry
            'smtp' # smtp.com
            'smtpcustomer' # smtp.com
            'smtpkey' # smtp.com
            'sophos' # Sophos Email
            'sparkpost' # SparkPost
            'spop1024' # IBM
            'resend' # Resend
            'yandex' # Yandex Mail
            'zendesk1' # Zendesk
            'zendesk2' # Zendesk
            'zoho' # Zoho Mail / Campaigns
            'zohomail' # Zoho Mail
        )  

        $DKimObject = New-Object System.Collections.Generic.List[System.Object]
    }

    Process {
        foreach ($domain in $Name) {
            $DkimAdvisory = $null
            $FoundDkimSelectors = @()
            $FoundDkimRecords = @()

            if ($DkimSelector) {
                Write-Verbose "Using custom DKIM selector: $DkimSelector"
                Write-Verbose "Querying DKIM record for $($DkimSelector)._domainkey.$($domain)"

                if ($OsPlatform -eq "Windows") {
                    $DKIM = Resolve-DnsName -Type TXT -Name "$($DkimSelector)._domainkey.$($domain)" @SplatParameters
                    Write-Verbose "DKIM TXT record retrieved: $($DKIM | Out-String)"
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                    $DKIM = $(dig TXT "$($DkimSelector)._domainkey.$($domain)" +short | Out-String).Trim()
                    $DKIM = $DKIM -split '" "' -join ""
                    Write-Verbose "DKIM TXT record retrieved: $($DKIM | Out-String)"
                }
                elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                    $DKIM = $(dig TXT "$($DkimSelector)._domainkey.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
                    $DKIM = $DKIM -split '" "' -join ""
                    Write-Verbose "DKIM TXT record retrieved: $($DKIM | Out-String)"
                }
                
                if ($DKIM.Type -eq "CNAME") {
                    Write-Verbose "DKIM record is a CNAME, resolving to TXT record"
                    while ($DKIM.Type -eq "CNAME") {
                        $DKIM = $DKIM | Where-Object { $_.Type -eq "CNAME" } | Select-Object -First 1
                        $DKIMCname = $DKIM.NameHost
                        Write-Verbose "Resolving CNAME to TXT record: $DKIMCname"
                        $DKIM = Resolve-DnsName -Type TXT -name "$DKIMCname" @SplatParameters
                        Write-Verbose "DKIM CNAME record retrieved: $($DKIM | Out-String)"
                    }
                    $DKIMStrings = $DKIM | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                    $DKIM = $DKIMStrings -join ""
                    $DKIM = $DKIM -split '" "' -join ""

                    if ($null -eq $DKIM) {
                        $DkimAdvisory = "No DKIM-record found for selector $($DkimSelector)._domainkey.$($domain)"
                    }
                    elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                        $FoundDkimSelectors += $DkimSelector
                        $FoundDkimRecords += $DKIM
                        $DkimAdvisory = "DKIM-record found."
                    }
                } 
                else {
                    if ($OsPlatform -eq "Windows") {
                        $DKIMStrings = $DKIM | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                        $DKIM = $DKIMStrings -join ""
                    }
                    if ($null -eq $DKIM) {
                        $DkimAdvisory = "No DKIM-record found for selector $($DkimSelector)._domainkey.$($domain)"
                    }
                    elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                        $FoundDkimSelectors += $DkimSelector
                        $FoundDkimRecords += $DKIM
                        $DkimAdvisory = "DKIM-record found."
                    }
                }
            }
            else {
                foreach ($DkimSelector in $DkimSelectors) {
                    Write-Progress -Activity "Querying DKIM records for $domain" -Status "Checking selector: $DkimSelector" -PercentComplete (($DkimSelectors.IndexOf($DkimSelector) / $DkimSelectors.Count) * 100)
                    Write-Verbose "Querying DKIM record for $($DkimSelector)._domainkey.$($domain)"
                    if ($OsPlatform -eq "Windows") {
                        $DKIM = Resolve-DnsName -Type TXT -Name "$($DkimSelector)._domainkey.$($domain)" @SplatParameters
                        #$DKIM = $DKIM -split '" "' -join ""
                    }
                    elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux") {
                        $DKIM = $(dig TXT "$($DkimSelector)._domainkey.$($domain)" +short | Out-String).Trim()
                        $DKIM = $DKIM -split '" "' -join ""
                    }
                    elseif ($OsPlatform -eq "macOS" -or $OsPlatform -eq "Linux" -and $Server) {
                        $DKIM = $(dig TXT "$($DkimSelector)._domainkey.$($domain)" +short NS $PSBoundParameters.Server | Out-String).Trim()
                        $DKIM = $DKIM -split '" "' -join ""
                    }
                    if ($DKIM.Type -eq "CNAME") {
                        Write-Verbose "DKIM record is a CNAME, resolving to TXT record"
                        while ($DKIM.Type -eq "CNAME") {
                            $DKIM = $DKIM | Where-Object { $_.Type -eq "CNAME" } | Select-Object -First 1
                            $DKIMCname = $DKIM.NameHost
                            $DKIM = Resolve-DnsName -Type TXT -name "$DKIMCname" @SplatParameters 
                        }
                        $DKIMStrings = $DKIM | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                        $DKIM = $DKIMStrings -join ""
                        if ($null -eq $DKIM) {
                            $DkimAdvisory = "No DKIM-record found for selector $($DkimSelector)._domainkey.$($domain)"
                        }
                        elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                            Write-Verbose "DKIM record found for selector $($DkimSelector)._domainkey.$($domain)"
                            Write-Verbose "DKIM record: $($DKIM | Out-String)"
                            $FoundDkimSelectors += $DkimSelector
                            $FoundDkimRecords += $DKIM
                            $DkimAdvisory = "DKIM-record found."
                        }
                    }
                    else {
                        if ($OsPlatform -eq "Windows") {
                            $DKIMStrings = $DKIM | Select-Object -ExpandProperty Strings -ErrorAction SilentlyContinue
                            $DKIM = $DKIMStrings -join ""
                        }
                        if ($null -eq $DKIM) {
                            $DkimAdvisory = "We couldn't find a DKIM record associated with your domain."
                        }
                        elseif ($DKIM -match "v=DKIM1" -or $DKIM -match "k=") {
                            Write-Verbose "DKIM record found for selector $($DkimSelector)._domainkey.$($domain)"
                            Write-Verbose "DKIM record: $($DKIM | Out-String)"
                            $FoundDkimSelectors += $DkimSelector
                            $FoundDkimRecords += $DKIM
                            $DkimAdvisory = "DKIM-record found."
                        }
                    }
                }
            }

            $DkimReturnValues = New-Object psobject
            $DkimReturnValues | Add-Member NoteProperty "Name" $domain

            if ($FoundDkimSelectors.Count -gt 0) {
                Write-verbose "Found DKIM selectors: $($FoundDkimSelectors -join ', ')"
                $DkimReturnValues | Add-Member NoteProperty "DkimSelectorsDetected" ($FoundDkimSelectors -join ", ")
                for ($i = 0; $i -lt $FoundDkimSelectors.Count; $i++) {
                    $index = $i + 1
                    $DkimReturnValues | Add-Member NoteProperty "DkimSelector-$index" $FoundDkimSelectors[$i]
                    $DkimReturnValues | Add-Member NoteProperty "DkimRecord-$index" $FoundDkimRecords[$i]
                    $DkimReturnValues | Add-Member NoteProperty "DkimAdvisory-$index" "DKIM-record found for selector $($FoundDkimSelectors[$i])."
                }
            }
            elseif ($FoundDkimSelectors.Count -eq 0) {
                Write-Verbose "No DKIM-record found for $dkimSelector._domainkey.$domain"
                $DkimReturnValues | Add-Member NoteProperty "DkimRecord" $null
                $DkimReturnValues | Add-Member NoteProperty "DkimSelector" $null
                $DkimReturnValues | Add-Member NoteProperty "DkimAdvisory" $DkimAdvisory
            }
            else {
                $DkimReturnValues | Add-Member NoteProperty "DkimSelector" $DkimSelector
                $DkimReturnValues | Add-Member NoteProperty "DkimRecord" $DkimRecord
                $DkimReturnValues | Add-Member NoteProperty "DkimAdvisory" $DkimAdvisory
            }
            $DkimObject.Add($DkimReturnValues)
            $DkimReturnValues
        }
    } end {}
}
Set-Alias gdkim -Value Get-DKIMRecord     
