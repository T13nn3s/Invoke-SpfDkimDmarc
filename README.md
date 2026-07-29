<p align="center">
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/v/DomainHealthChecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/badge/platform-windows%20|%20macos%20|%20linux-green"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/github/languages/code-size/t13nn3s/domainhealthchecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/dt/DomainHealthChecker"></a>
</p>
<p align="center">
<a href="https://buymeacoffee.com/t13nn3s" target="_blank"><img src="https://img.shields.io/badge/buy_me_a_coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black"></a>
</p>

# Invoke-SpfDkimDmarc
Invoke-SpfDkimDmarc is a function within the PowerShell module DomainHealthChecker that checks SPF, DKIM, BIMI, and DMARC records for one or more domains. After installing the module, you can use Invoke-SpfDkimDmarc to check all three records at once. You can also check the records individually by using the cmdlets `Get-SPFRecord`, `Get-DKIMRecord`, `Get-DNSSec`, `Get-BIMIrecord` or `Get-DMARCRecord` to retrieve the record for a single domain.

![Invoke-SpfDkimDmarc](https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/logo/Show-SpfDkimDmarc.png)

## The PowerShell Podcast
This PowerShell module, `DomainHealthChecker`, is discussed by Jordan in The PowerShell Podcast episode **"Jordan Returns: A Fun Dive into Life, PowerShell, and Beyond."** This episode was released on 11/25/2024. You can listen to this episode via this website: [https://powershell.org/2024/11/the-powershell-podcast-jordan-returns-a-fun-dive-into-life-powershell-and-beyond/](https://powershell.org/2024/11/the-powershell-podcast-jordan-returns-a-fun-dive-into-life-powershell-and-beyond/) or via your favorite podcast app. Make sure you follow this podcast. Thanks for the shoutout, Jordan!



# System Requirements
This module requires PowerShell version 5.1 or later on Windows, and PowerShell Core on Linux and macOS.

# Installation

## PowershellGallery (recommended)
The module is published on the PowerShellGallery. You can install this module directly from the PowerShellGallery with the following command:
```powershell
Install-Module DomainHealthChecker
```
PowerShellGallery will automatically download and install the latest version of the module. 

## Manual Installation
Download the module from the 'Releases' tab from Github. Just download and extract the ZIP file, and just import the module by running this command below:
```powershell
Import-Module -Name .\DomainHealthChecker.psm1
```

Clone the repository and import the module.

```powershell
git clone https://github.com/T13nn3s/Invoke-SpfDkimDmarc.git
cd .\Invoke-SpfDkimDmarc\
Import-Module .\DomainHealthChecker.psd1
```

## Available cmdlets
After installing this module, you have the following cmdlets at your disposal.

- `Invoke-SpfDkimDmarc` to check the SPF, DKIM, and DMARC records for one or multiple domains. You can export the results to a file. For example, to a comma-separated file with the `Export-CSV` command.
- `Get-SPFRecord` to check the SPF record for a single domain. The module also checks the charachter lenght of the SPF-record, and the counts the DNS lookups. This cmdlet has also an alias `gspf` for quick checks.
- `Get-DKIMRecord` to check the DKIM record for a single domain. This cmdlet has also an alias `gdkim` for quick checks.
- `Get-DMARCRecord` to check the DMARC record for a single domain. This cmdlet has also an alias `gdmarc` for quick checks.
- `Get-DNSSec` to check whether the domain is protected with DNSSEC. This cmdlet has also an alias `gdnssec` for quick checks.
- `Invoke-MtaSts` to check for the existence of the record and also checks for a valid MTA-STS Policy.
- `Get-BIMIRecord` to check for the existance of the record and also checks if the DMARC policy is configured properly according the needs of BIMI.
- `Get-CAARecord` to check for the existance of the CAA record. This function also checks if the IODEF is implemented. This cmdlet is also available as `gcaa`.
- `Get-TlsRpt` to check of TLS-RPT is implememted. This cmdlet is also available as alias `gtlstps`.

## Split DNS environment
If you are using a split DNS environment, you can use the `-Server` parameter to specify an alternative DNS server. This parameter is not available in the `Get-CAARecord` function, this function uses Cloudflare's DNS over HTTPS resolver since `Resolve-DnsName` does not support the `CAA` DNS record type.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector            : zohomail
DkimRecord              : No DKIM-record found.
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
TlsRptRecord            : No TLS-RPT Record found.
TlsRptAdvisory          : No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports.
CaaRecord               : CAA record found, allowed CAs: comodoca.com, digicert.com, ssl.com, letsencrypt.org.
CaaAdvisory             : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.
```

Checks the SPF, DMARC, DKIM and Mta configuration for the domain binsec.nl.

### Example 2
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.nl

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector            : zohomail
DkimRecord              : No DKIM-record found.
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
TlsRptRecord            : No TLS-RPT Record found.
TlsRptAdvisory          : No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports.
CaaRecord               : CAA record found, allowed CAs: comodoca.com, digicert.com, ssl.com, letsencrypt.org.
CaaAdvisory             : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.

Name                    : microsoft.com
SpfRecord               : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:_spf1-meo.microsoft.com -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 158
SPFRecordDnsLookupCount : 7/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelectorsDetected   : selector2
DkimSelector-1          : selector2
DkimRecord-1            : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPkb8bu8RGWeJGk3hJrouZXIdZ+HTp/azRp8IUOHp5wKvPUAi/54PwuLscUjRk4Rh3hjIkMpKRfJJXPxWbrT7eMLric7f/S
                          0h+qF4aqIiQqHFCDAYfMnN6V3Wbke2U5EGm0H/cAUYkaf2AtuHJ/rdY/EXaldAm00PgT9QQMez66QIDAQAB;
DkimAdvisory-1          : DKIM-record found for selector selector2.
MtaRecord               : v=STSv1; id=20190225000000Z;
MtaAdvisory             : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : No DNSKEY records found.
DnsSecAdvisory          : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
TlsRptRecord            : v=TLSRPTv1;rua=https://tlsrpt.azurewebsites.net/report
TlsRptAdvisory          : TLS-RPT Record found. The 'rua' field is configured.
CaaRecord               : CAA record found, allowed CAs: .
CaaAdvisory             : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.
```

Checks the SPF, DMARC, DKIM, Mta, TLS-RPT, DNSSEC, and DNS CAA configuration for the domains binsec.nl and microsoft.com.

### Example 3
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, ing.nl -dkimselector selector1 -server 1.1.1.1

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : selector1
DkimAdvisory            : No DKIM-record found for selector selector1._domainkey.binsec.nl
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.

Name                    : ing.nl
SpfRecord               : v=spf1 ip4:80.248.34.0/24 ip4:195.248.87.0/24 ip4:85.112.22.247 ip4:74.63.141.251 ip4:83.149.86.160/27 ip4:83.149.121.128/26 ip4:80.79.192.34/31 ip4:78.31.119.9
                           ip4:91.220.136.168 ip4:46.31.52.0/23 ip4:46.19.168.0/23 ip4:192.254.112.185 ip4:91.209.197.6 ip4:91.209.197.7 ip4:62.112.237.21 ip4:62.112.237.23 ip6:2a00:1558
                          :2801:4::2:1 ip6:2a00:1558:2801:4::3:1 include:_spf.ing.net include:_spf.ing.nl -all
SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. An SPF-record is configured and the policy i
                          s sufficiently strict.
SPFRecordLength         : 404
SPFRecordDnsLookupCount : 4/10 (OK)
DmarcRecord             : v=DMARC1;p=reject;rua=mailto:Global.Mail.DMARC@ing.com,mailto:ejdvezzq@ag.dmarcian-eu.com,mailto:dmarc.feedback@ing.nl
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx1X7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCpdtMaXjmYVG9zvSx74HUB
                          b223TqMve8K1qBU/sW2I3ZijuP/37HacBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;
DkimSelector            : selector1
DkimAdvisory            : DKIM-record found.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : v=spf1 -all
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
```

Checks the SPF, DMARC, DKIM for dkimselector selector2, Mta and DNSSEC configuration for the domains binsec.nl and ing.nl using 1.1.1.1 as the DNS Server for the lookup.

### Example 3
```powershell
Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domains.txt -Server 1.1.1.1

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector            : zohomail
DkimRecord              : No DKIM-record found.
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
TlsRptRecord            : No TLS-RPT Record found.
TlsRptAdvisory          : No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports.
CaaRecord               : CAA record found, allowed CAs: comodoca.com, digicert.com, ssl.com, letsencrypt.org.
CaaAdvisory             : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.

Name                    : itsecuritymatters.nl
SpfRecord               : v=spf1 include:_spf.protonmail.ch ~all
SpfAdvisory             : An SPF-record is configured but the policy is not sufficiently strict.
SPFRecordLength         : 38
SPFRecordDnsLookupCount : 2/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelectorsDetected   : protonmail2, protonmail3
DkimSelector-1          : protonmail2
DkimRecord-1            : v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsIiFwplcUwfpJ2XbEjfdp2Kzgsp7c64euhEssbiZLVxgHmvPr37fLbIFxnkCi/ee97Md6PVt511tAutQf5lvPw+M3Uq
                          NWaYJtP8+seS/8z4gOju9Sjsum2GS+ZuRE5mVrImpT9KQ1eh6q++dyRqumJLQqKxN442eHmeE5DSKifp7yDKR0ZbpyTg/GwQx8iGI8qsB8Nipmg/Vxp1Zf7l/KRAiNkbcp3cKm7hjo3nfwMem8HuTS8
                          Ph5vD2RlPmud60e9fDVpqJQdI7YLZY6oU63dpR7LHduP1L3UN0aEoceULGnt0kN8QylGeMDKFYs7nOgkvR6Uk60yIkCuqlV/e9BwIDAQAB;
DkimAdvisory-1          : DKIM-record found for selector protonmail2.
DkimSelector-2          : protonmail3
DkimRecord-2            : v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtE6cMrI4PemdY6coLG3uAurJdFk97Za2ozaqGoJ9P9h99xZqRRR1HSQIBgUsN6xvfF6yEFnmrnekNz4XepNkNoCorEA
                          G0feCd1HOcRPU8JZswXdXjlNi5YP96UgFE2BaRTN3awSuo0Oo0GNQ13SiPfItAXSUw0KNXMsHbuMgwLb76+5Z8KEDxfxI7rTMAmxQqtQ0a+aLFGrxRW1bgvYE+g7KXzBLfZ/vlf9uKoqlNm9kiR8Z06
                          Rlsc+vqBommBBOF9QWGV/FEuAEyqS4eUU0rzs0liTT7rGqKF8s1jICXdGyimnpyJdw3SwyhyXHHfnGj4QIjeuAySuvN43KmWZ1xwIDAQAB;
DkimAdvisory-2          : DKIM-record found for selector protonmail3.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : No DNSKEY records found.
DnsSecAdvisory          : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
TlsRptRecord            : No TLS-RPT Record found.
TlsRptAdvisory          : No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports.
CaaRecord               : No CAA record found.
CaaAdvisory             : No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for itsecuritymatters.nl.

Name                    : holland.com
SpfRecord               : v=spf1 include:spf.protection.outlook.com include:_spf.zimpel.de include:servers.mcsv.net include:mailplus.nl include:mailswitch.nl include:spf.crowdte
                          ch.com include:imedia.nl ip4:141.138.139.178 ip4:5.39.185.40 ip4:195.140.184.0/22 ip4:91.192.40.0/22 ip4:37.97.128.249 ip6:2a01:7c8:aaae:626::/64 -all
SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. An SPF-record is configured and the
                           policy is sufficiently strict.
SPFRecordLength         : 301
SPFRecordDnsLookupCount : 10/10 (Ok, but maximum DNS Lookups reached!)
DmarcRecord             : v=DMARC1; p=quarantine; rua=mailto:helpdesk@holland.com; ruf=mailto:helpdesk@holland.com; fo=1
DmarcAdvisory           : Domain has a DMARC record and it is set to p=quarantine. To fully take advantage of DMARC, the policy should be set to p=reject.
DkimSelectorsDetected   : fm1, fm2, k1, selector2
DkimSelector-1          : fm1
DkimRecord-1            : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCHugwe8+qUEAtJhwoS+uSrKos1B0+cVGWbmD1VlaHkSS399IakaxWQuUOFcxBywikOtc0uNs7/jInGBGvbakIDEW+lDgsny
                          CokcoPmmfXuUAlEXPb3Ln1ntrjkhx4RGrC9Z2zJUBs11EL35tv1xmQ9HLM9cnkCrI9Y31FRRydIfwIDAQAB
DkimAdvisory-1          : DKIM-record found for selector fm1.
DkimSelector-2          : fm2
DkimRecord-2            : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCObNT81yH9lAtQ6eX9/1zd+zCqxK9ZoVnYBhT8D7DGaL6BmVBxJr6cPcgGkld+EJ02OiPyWRZqh9wooeusbPLkCpKZZFMCX
                          OvL6HKtBqVk5TQxVkeFxhcA2s5czLhWhhO1edAviQhejiheBT5nTq4THfy1VbivvxD59bItND9v1QIDAQAB
DkimAdvisory-2          : DKIM-record found for selector fm2.
DkimSelector-3          : k1
DkimRecord-3            : k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDbNrX2cY/GUKIFx2G/1I00ftdAj713WP9AQ1xir85i89sA2guU0ta4UX1Xzm06XIU6iBP41VwmPwBGRNofhBVR+e6WHUoNyIR4Bn84LV
                          cfZE20rmDeXQblIupNWBqLXM1Q+VieI/eZu/7k9/vOkLSaQQdml4Cv8lb3PcnluMVIhQIDAQAB;
DkimAdvisory-3          : DKIM-record found for selector k1.
DkimSelector-4          : selector2
DkimRecord-4            : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQClofJdIWSth1xj+G7tKHvL1lgbVFf+ZzJ463o1NjPJmnJ8GBteFeZBt4SRx06jHbw+wN1tMsNcUAkY7f9tH5Jt1/I5d8cTO
                          qQH5xBVwWDvWvBZ6McWLU2Ua8Lp/J26r0LYXplmuA5i2dwtxkUHJANsG9+axaVXphB0pooAszb7uQIDAQAB;
DkimAdvisory-4          : DKIM-record found for selector selector2.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
BimiRecord              : We couldn't find a BIMI record associated with your domain.
BimiAdvisory            : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
TlsRptRecord            : No TLS-RPT Record found.
TlsRptAdvisory          : No TLS-RPT Record found. Consider configuring a TLS-RPT record for this domain, to receive reports.
CaaRecord               : No CAA record found.
CaaAdvisory             : No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for holland.com.
```

Get's the contents of the file `domains.txt`, and itterates through the domains to perform all the checks against the domains by using the `1.1.1.1` as the DNS Server for the lookup. The domains are listed in the file `domains.txt`.

Contents of the file `domains.txt`:

```
binsec.nl
itsecuritymatters.nl
holland.com
```
