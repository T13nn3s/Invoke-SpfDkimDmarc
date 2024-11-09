---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md
schema: 2.0.0
---

# Invoke-SpfDkimDmarc

## SYNOPSIS
Module for checking SPF, DKIM, DMARC and MtaSts. This module also checks for the DNSSEC configuration.

## SYNTAX

### domain
```
Invoke-SpfDkimDmarc [-Name] <String[]> [[-DkimSelector] <String>] [[-Server] <String>] [-IncludeDNSSEC] [<CommonParameters>]
```

### file
```
Invoke-SpfDkimDmarc [-File] <FileInfo> [[-DkimSelector] <String>] [[-Server] <String>] [-IncludeDNSSEC] [<CommonParameters>]
```

## DESCRIPTION
Invoke-SpfDkimDmarc is a module within the PowerShell module named DomainHealthChecker that can check the SPF, DKIM and DMARC record for one or multiple domains. On installing this module you can use Invoke-SpfDKimDmarc to check the records. You can also check the records individually by using the cmdlets Get-SPFrecord, Get-DKIMRecord or by running the Get-DMARCRecord to check the record of a single domain.

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

## PARAMETERS

### -DkimSelector
Specify a custom DKIM selector.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Show SPF, DKIM and DMARC-records from multiple domains from a file.

```yaml
Type: FileInfo
Parameter Sets: file
Aliases: Path

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -IncludeDNSSEC
Include this switch to check for DNSSEC existance

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the domain for resolving the SPF, DKIM and DMARC-record.

```yaml
Type: String[]
Parameter Sets: domain
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Server
DNS Server to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

### System.IO.FileInfo

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
