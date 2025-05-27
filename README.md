<p align="center">
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/v/DomainHealthChecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/badge/platform-windows-green"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/github/languages/code-size/t13nn3s/domainhealthchecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/dt/DomainHealthChecker"></a>
</p>
<p align="center">
<a href="https://buymeacoffee.com/t13nn3s" target="_blank"><img src="https://img.shields.io/badge/buy_me_a_coffee-FFDD00?style=for-the-badge&logo=buy-me-a-coffee&logoColor=black"></a>
</p>

# Invoke-SpfDkimDmarc
Invoke-SpfDkimDmarc is a function within the PowerShell module named `DomainHealthChecker` that can check the SPF, DKIM and DMARC record for one or multiple domains. On installing this module you can use `Invoke-SpfDKimDmarc` to check the records. You can also check the records individually by using the cmdlets `Get-SPFrecord`, `Get-DKIMRecord` or by running the `Get-DMARCRecord` to check the record of a single domain.


![Invoke-SpfDkimDmarc](https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/logo/Show-SpfDkimDmarc.png)


## System Requirements
This module requires PowerShell version 5.1 or higher. 

## Installation PowershellGallery (recommended)
The module is published on the PowerShellGallery. You can install this module directly from the PowerShellGallery with the following command:
```powershell
C:\> Install-Module DomainHealthChecker
```
PowerShellGallery will automatically download and install the latest version of the module. 

## Manual Installation
Download the module from the 'Releases' tab from Github. Just download and extract the ZIP file, and just import the module by running this command below:
```powershell
C:\> Import-Module -Name .\DomainHealthChecker.psm1
```

## Available cmdlets
After installing this module, you have the following cmdlets at your disposal.

- `Invoke-SpfDkimDmarc` to check the SPF, DKIM, and DMARC records for one or multiple domains. You can export the results to a file. For example, to a comma-separated file with the `Export-CSV` command.
- `Get-SPFRecord` to check the SPF record for a single domain. The module also checks the charachter lenght of the SPF-record. This cmdlet has also an alias `gspf` for quick checks.
- `Get-DKIMRecord` to check the DKIM record for a single domain. This cmdlet has also an alias `gdkim` for quick checks.
- `Get-DMARCRecord` to check the DMARC record for a single domain. This cmdlet has also an alias `gdmarc` for quick checks.
- `Get-DNSSec` to check whether the domain is protected with DNSSEC. This cmdlet has also an alias `gdnssec` for quick checks.
- `Invoke-MtaSts` to check for the existence of the record and also checks for a valid MTA-STS Policy.

## Split DNS environment
If you are using a split DNS environment, you can use the `-Server` parameter to specify an alternative DNS server.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : dkim
DkimAdvisory    : We couldn't find a DKIM record associated with your domain.
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
```

Checks the SPF, DMARC, DKIM and Mta configuration for the domain binsec.nl.

### Example 2
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.com -IncludeDNSSEC

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : dkim
DkimAdvisory    : We couldn't find a DKIM record associated with your domain.
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
DnsSec          : Domain is DNSSEC signed.
DnsSecAdvisory  : Great! DNSSEC is enabled on your domain.

Name            : microsoft.com
SpfRecord       : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:spf-a.ho
                  tmail.com include:_spf1-meo.microsoft.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 184
DmarcRecord     : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPkb8bu8RGWeJGk3hJrouZXIdZ+HTp/azRp8IUOHp5wKvPUAi/54PwuLscUjRk4Rh3hjIkMpKRfJJXPxWb
                  rT7eMLric7f/S0h+qF4aqIiQqHFCDAYfMnN6V3Wbke2U5EGm0H/cAUYkaf2AtuHJ/rdY/EXaldAm00PgT9QQMez66QIDAQAB;
DkimSelector    : selector2
DkimAdvisory    : DKIM-record found.
MtaRecord       : v=STSv1; id=20190225000000Z;
MtaAdvisory     : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
DnsSec          : No DNSKEY records found.
DnsSecAdvisory  : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
```

Checks the SPF, DMARC, DKIM, Mta and DNSSEC configuration for the domains binsec.nl and microsoft.com.

### Example 3
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, microsoft.com -IncludeDNSSEC -DkimSelector selector2 -server 1.1.1.1

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : selector2
DkimAdvisory    : No DKIM-record found for selector selector2._domainkey.binsec.nl
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.
DnsSec          : Domain is DNSSEC signed.
DnsSecAdvisory  : Great! DNSSEC is enabled on your domain.

Name            : microsoft.com
SpfRecord       : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:spf-a.ho
                  tmail.com include:_spf1-meo.microsoft.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 184
DmarcRecord     : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPkb8bu8RGWeJGk3hJrouZXIdZ+HTp/azRp8IUOHp5wKvPUAi/54PwuLscUjRk4Rh3hjIkMpKRfJJXPxWb
                  rT7eMLric7f/S0h+qF4aqIiQqHFCDAYfMnN6V3Wbke2U5EGm0H/cAUYkaf2AtuHJ/rdY/EXaldAm00PgT9QQMez66QIDAQAB;
DkimSelector    : selector2
DkimAdvisory    : DKIM-record found.
MtaRecord       : v=STSv1; id=20190225000000Z;
MtaAdvisory     : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
DnsSec          : No DNSKEY records found.
DnsSecAdvisory  : Enable DNSSEC on your domain. DNSSEC decreases the vulnerability to DNS attacks.
```

Checks the SPF, DMARC, DKIM for dkimselector selector2, Mta and DNSSEC configuration for the domains binsec.nl and microsoft.com using 1.1.1.1 as the DNS Server for the lookup.

### Example 3
```powershell
Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domains.txt -server 1.1.1.1 -DkimSelector zendesk1

Name            : binsec.nl
SpfRecord       : v=spf1 -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 11
DmarcRecord     : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.

Name            : itsecuritymatters.nl
SpfRecord       : v=spf1 include:spf.protection.outlook.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 46
DmarcRecord     : v=DMARC1; p=reject; pct=100;
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       :
MtaAdvisory     : The MTA-STS DNS record doesn't exist.

Name            : microsoft.com
SpfRecord       : v=spf1 include:_spf-a.microsoft.com include:_spf-b.microsoft.com include:_spf-c.microsoft.com include:_spf-ssg-a.msft.net include:spf-a.ho
                  tmail.com include:_spf1-meo.microsoft.com -all
SpfAdvisory     : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength : 184
DmarcRecord     : v=DMARC1; p=reject; pct=100; rua=mailto:itex-rua@microsoft.com; ruf=mailto:itex-ruf@microsoft.com; fo=1
DmarcAdvisory   : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord      :
DkimSelector    : zendesk1
MtaRecord       : v=STSv1; id=20190225000000Z;
MtaAdvisory     : The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

Checks the SPF, DMARC, DKIM for dkimselector zendesk1, Mta and DNSSEC configuration for the domains binsec.nl, itsecuritymatters.nl, microsoft.com using 1.1.1.1 as the DNS Server for the lookup. The domains are listed in the file 'domains.txt'.
