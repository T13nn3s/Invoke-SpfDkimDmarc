---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Invoke-SpfDkimDmarc.md
schema: 2.0.0
---

# Invoke-SpfDkimDmarc

## SYNOPSIS
Shows the SPF, DKIM, and DMARC-record for single or multiple domains.

## SYNTAX

### domain
```
Invoke-SpfDkimDmarc [-Name] <String> [[-DkimSelector] <String>] [[-Server] <String>] [<CommonParameters>]
```

### file
```
Invoke-SpfDkimDmarc [-File] <FileInfo> [[-DkimSelector] <String>] [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Is your email domain properly protected against abuse, such as email spoofing? This form of abuse can cause (image) damage to an organization. The PowerShell script DomainHealthChecker.ps1 checks the SPF, DKIM and DMARC record of one or more email domains and gives advice if necessary.

## EXAMPLES

### EXAMPLE 1
```powershell
PS C:\> Invoke-SpfDkimDmarc -Name binsec.nl
```
```
Name          : binsec.nl
SPFRecord     : v=spf1 include:_spf.transip.email -all
SpfAdvisory   : An SPF-record is configured and the policy is sufficiently strict.
DmarcRecord   : v=DMARC1; p=reject; pct=100
DmarcAdvisory : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector  : selector1
DkimRecord    :
DkimAdvisory  : We couldn't find a DKIM record associated with your domain.
```

### EXAMPLE 2
```powershell
PS C:\> Invoke-SpfDkimDmarc -Name binsec.nl -Server 10.0.0.1
```
```
Name          : binsec.nl
SPFRecord     : v=spf1 include:_spf.transip.email -all
SpfAdvisory   : An SPF-record is configured and the policy is sufficiently strict.
DmarcRecord   : v=DMARC1; p=reject; pct=100
DmarcAdvisory : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector  : selector1
DkimRecord    :
DkimAdvisory  : We couldn't find a DKIM record associated with your domain.
```
This example resolves the SPF-record, DKIM-record (selector1) and DMARC-record for the domain binsec.nl against the DNS server at 10.0.0.1.

### EXAMPLE 3
```powershell
PS C:\> Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domain_list.txt
```
```
Name          : binsec.nl
SPFRecord     : v=spf1 include:_spf.transip.email -all
SpfAdvisory   : An SPF-record is configured and the policy is sufficiently strict.
DmarcRecord   : v=DMARC1; p=reject; pct=100
DmarcAdvisory : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector  : selector1
DkimRecord    :
DkimAdvisory  : We couldn't find a DKIM record associated with your domain.

Name          : itsecuritymatters.nl
SPFRecord     : v=spf1 -all
SpfAdvisory   : An SPF-record is configured and the policy is sufficiently strict.
DmarcRecord   : v=DMARC1; p=reject; pct=100
DmarcAdvisory : Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
DkimSelector  : selector1
DkimRecord    :
DkimAdvisory  : We couldn't find a DKIM record associated with your domain.
```

This example takes the list of domains from the file `domain_list.txt` and parse the domains through the SPF, DKIM and DMARC checker. 

### EXAMPLE 4
```powershell
PS C:\> Invoke-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domain_list.txt | Export-Csv destination.csv -NoTypeInformation -Delimiter ";"
```

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
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Name
Specifies the domain for resolving the SPF, DKIM and DMARC-record.

```yaml
Type: String
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

- [Join the talk on Reddit](https://www.reddit.com/r/PowerShell/comments/occgr2/powershell_script_for_checking_spf_dkim_and_dmarc/)
- [Script on PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)
