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
Invoke-SpfDkimDmarc is a function within the PowerShell module DomainHealthChecker that checks SPF, DKIM, and DMARC records for one or more domains. After installing the module, you can use Invoke-SpfDkimDmarc to check all three records at once. You can also check the records individually by using the cmdlets `Get-SPFRecord`, `Get-DKIMRecord`, `Get-DNSSec`, or `Get-DMARCRecord` to retrieve the record for a single domain.

![Invoke-SpfDkimDmarc](https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/logo/Show-SpfDkimDmarc.png)

## System Requirements
This module requires PowerShell version 5.1 or later on Windows, and PowerShell Core on Linux and macOS.

## Installation

### PowershellGallery (recommended)
The module is published on the PowerShellGallery. You can install this module directly from the PowerShellGallery with the following command:
```powershell
Install-Module DomainHealthChecker
```
PowerShellGallery will automatically download and install the latest version of the module. 

### Manual Installation
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
- `Get-BimiRecord` to check for the existance of the record and also checks if the DMARC policy is configured properly according the needs of BIMI.

## Split DNS environment
If you are using a split DNS environment, you can use the `-Server` parameter to specify an alternative DNS server.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac
                          3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers
                           and spammers.
DkimRecord              :
DkimSelector            : zendesk2
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               :
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
```

Checks the SPF, DMARC, DKIM and Mta configuration for the domain binsec.nl.

### Example 2
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.nl -IncludeDNSSEC

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac
                          3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers
                           and spammers.
DkimRecord              :
DkimSelector            : zendesk2
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               :
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.

Name                    : microsoft.nl
SpfRecord               : v=spf1 mx -all v=spf1 +a +mx include:sendgrid.net -all
SpfAdvisory             : Domain has more than one SPF record. Only one SPF record per domain is allowed. This is expli
                          citly defined in RFC4408.
SPFRecordLength         : 53
SPFRecordDnsLookupCount : 3/10 (OK)
DmarcRecord             :
DmarcAdvisory           : Does not have a DMARC record. This domain is at risk to being abused by phishers and spammers
                          .
DkimRecord              :
DkimSelector            : zendesk2
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               :
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
DnsSec                  : No DNSKEY records found.
DnsSecAdvisory          : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
```

Checks the SPF, DMARC, DKIM, Mta and DNSSEC configuration for the domains binsec.nl and microsoft.com.

### Example 3
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, ing.nl -dkimselector selector1 -IncludeDNSSEC -server 1.1.1.1

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac
                          3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers
                           and spammers.
DkimRecord              :
DkimSelector            : selector1
DkimAdvisory            : No DKIM-record found for selector selector1._domainkey.binsec.nl
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.

Name                    : ing.nl
SpfRecord               : v=spf1 ip4:80.248.34.0/24 ip4:195.248.87.0/24 ip4:85.112.22.247 ip4:74.63.141.251 ip4:83.149.
                          86.160/27 ip4:83.149.121.128/26 ip4:80.79.192.34/31 ip4:78.31.119.9 ip4:91.220.136.168 ip4:46
                          .31.52.0/23 ip4:46.19.168.0/23 ip4:192.254.112.185 ip4:91.209.197.6 ip4:91.209.197.7 ip4:62.1
                          12.237.21 ip4:62.112.237.23 ip6:2a00:1558:2801:4::2:1 ip6:2a00:1558:2801:4::3:1 include:_spf.
                          ing.net include:_spf.ing.nl -all
SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicit
                          ly defined in RFC4408. An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 404
SPFRecordDnsLookupCount : 4/10 (OK)
DmarcRecord             : v=DMARC1;p=reject;rua=mailto:Global.Mail.DMARC@ing.com,mailto:ejdvezzq@ag.dmarcian-eu.com,mai
                          lto:dmarc.feedback@ing.nl
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers
                           and spammers.
DkimRecord              : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx
                          1X7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCpdtMaXjmYVG9zvSx74HUBb223TqMve8K1qBU/sW2I3ZijuP
                          /37HacBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;
DkimSelector            : selector1
DkimAdvisory            : DKIM-record found.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
```

Checks the SPF, DMARC, DKIM for dkimselector selector2, Mta and DNSSEC configuration for the domains binsec.nl and microsoft.com using 1.1.1.1 as the DNS Server for the lookup.

### Example 3
```powershell
Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domains.txt

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac
                          3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers
                           and spammers.
DkimRecord              :
DkimSelector            : yandex
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.

Name                    : itsecuritymatters.nl
SpfRecord               : v=spf1 include:_spf.protonmail.ch ~all
SpfAdvisory             : An SPF-record is configured but the policy is not sufficiently strict.
SPFRecordLength         : 38
SPFRecordDnsLookupCount : 1/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              : v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA9MKqr+i7WAJnICEl4XNrMd0yThw0vszkgJRim0i5U8+KnDW9GvhVZ4qXDTAcKRQFqGBTgoOk4QJpAnUCQEOVVkpMrhDl24isMnShqfCVdTvVZv/a627KD6gKMU8+8tNH3TpBWSJaa7C96mxSj5eNuEg3gdCSq6wXOypnwtW2GMr+UgRsonsDYDGpUENxl0MYib/ yy5Pz6qm31foiKeQLV8gLk7MAhoXek085EVT8CGFnDY/j3ODAEyLXfs8lUaqIZCgCaTrCABbB5aX4fiWr8blahEbvNNC8RL
                          01ne4dAhaotEonVYgHrVAOA3+u1d/m+nG9q9vQ5kD411S4s/Wv8wIDAQAB;
DkimSelector            : protonmail
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.

Name                    : ing.nl
SpfRecord               : v=spf1 ip4:80.248.34.0/24 ip4:195.248.87.0/24 ip4:85.112.22.247 ip4:74.63.141.251 ip4:83.149.86.160/27 ip4:83.149.121.128/26 ip4:80.79.192.34/31 ip4:78.31.119.9 ip4:91.220.136.168 ip4:46.31.52.0/23 ip4:46.19.168.0/23 ip4:192.254.112.185 ip4:91.209.197.6 ip4:91.209.197.7 ip4:62.112.237.21 ip4:62.112.237.23 ip6:2a00:1558:2801:4::2:1 ip6:2a00:1558:2801
                          :4::3:1 include:_spf.ing.net include:_spf.ing.nl -all
SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 404
SPFRecordDnsLookupCount : 4/10 (OK)
DmarcRecord             : v=DMARC1;p=reject;rua=mailto:Global.Mail.DMARC@ing.com,mailto:ejdvezzq@ag.dmarcian-eu.com,mailto:dmarc.feedback@ing.nl
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx1X7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCpdtMaXjmYVG9zvSx74HUBb223TqMve8K1qBU/sW2I3ZijuP/37HacBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;
DkimSelector            : selector1
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
```

Checks the SPF, DMARC, DKIM for dkimselector zendesk1, Mta and DNSSEC configuration for the domains binsec.nl, itsecuritymatters.nl, microsoft.com using `1.1.1.1` as the DNS Server for the lookup. The domains are listed in the file `domains.txt`.
