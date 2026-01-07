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

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : yandex
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
```

Checks the SPF, DMARC, DKIM and Mta configuration for the domain binsec.nl.

### Example 2
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, ing.nl -IncludeDNSSEC

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : yandex
DkimAdvisory            : We couldn't find a DKIM record associated with your domain.
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
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
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
```

Checks the SPF, DMARC, DKIM, Mta and DNSSEC configuration for the domains binsec.nl and ing.nl.

### Example 3
```powershell
PS C:\> Invoke-spfDkimDmarc binsec.nl, ing.nl -IncludeDNSSEC -DkimSelector selector1 -server 1.1.1.1

Name                    : binsec.nl
SpfRecord               : "v=spf1 -all"

SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 14
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : "v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;"
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : selector1
DkimAdvisory            : No DKIM-record found for selector selector1._domainkey.binsec.nl
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.

Name                    : ing.nl
SpfRecord               : "v=spf1 ip4:80.248.34.0/24 ip4:195.248.87.0/24 ip4:85.112.22.247 ip4:74.63.141.251 ip4:83.149.86.160/27 ip4:83.149.121.128/26 ip4:80.79.192.3
                          4/31 ip4:78.31.119.9 ip4:91.220.136.168 ip4:46.31.52.0/23 ip4:46.19.168.0/23 ip4:192.254.112.185 ip4:91.209.197.6 ip4:91.209.197.7 ip4:62.112
                          .237.21 ip4:62.112.237.23 ip6:2a00:1558:2801:4::2:1 ip6:2a00:1558:2801:4::3:1 include:_spf.ing.net include:_spf.ing.nl -all"

SpfAdvisory             : Your SPF record has more than 255 characters in one string. This MUST not be done as explicitly defined in RFC4408. An SPF-record is configur
                          ed and the policy is sufficiently strict.
SPFRecordLength         : 407
SPFRecordDnsLookupCount : 4/10 (OK)
DmarcRecord             : "v=DMARC1;p=reject;rua=mailto:Global.Mail.DMARC@ing.com,mailto:ejdvezzq@ag.dmarcian-eu.com,mailto:dmarc.feedback@ing.nl"
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              : "v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx1X7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCp
                          dtMaXjmYVG9zvSx74HUBb223TqMve8K1qBU/sW2I3ZijuP/37HacBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;"
DkimSelector            : selector1
DkimAdvisory            : DKIM-record found.
MtaRecord               : "v=spf1 -all"
MtaAdvisory             : The MTA-STS id must be alphanumeric and no longer than 32 characters.
DnsSec                  : Domain is DNSSEC signed.
DnsSecAdvisory          : Great! DNSSEC is enabled on your domain.
```

Checks the SPF, DMARC, DKIM for dkimselector selector2, Mta and DNSSEC configuration for the domains binsec.nl and ing.nl using 1.1.1.1 as the DNS Server for the lookup.

### Example 3
```powershell
Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domains.txt -server 1.1.1.1 -DkimSelector zendesk1

Name                    : binsec.nl
SpfRecord               : v=spf1 -all
SpfAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; adkim=s; aspf=s; rua=mailto:rac3n92qqi@rua.powerdmarc.com; ruf=mailto:rac3n92qqi@ruf.powerdmarc.com; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : zendesk1
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.

Name                    : itsecuritymatters.nl
SpfRecord               : v=spf1 include:_spf.protonmail.ch ~all
SpfAdvisory             : An SPF-record is configured but the policy is not sufficiently strict.
SPFRecordLength         : 38
SPFRecordDnsLookupCount : 1/10 (OK)
DmarcRecord             : v=DMARC1; p=reject; pct=100;
DmarcAdvisory           : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimRecord              :
DkimSelector            : zendesk1
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.

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
DkimRecord              :
DkimSelector            : zendesk1
MtaRecord               : No MTA-STS DNS record found.
MtaAdvisory             : The MTA-STS DNS record doesn't exist.
```

Checks the SPF, DMARC, DKIM for dkimselector zendesk1, Mta and DNSSEC configuration for the domains binsec.nl, itsecuritymatters.nl, ing.nl using 1.1.1.1 as the DNS Server for the lookup. The domains are listed in the file 'domains.txt'.

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
