---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DMARCRecord.md
schema: 2.0.0
---

# Get-DMARCRecord

## SYNOPSIS
Function to resolve a DMARC record of a domain.

## SYNTAX

```
Get-DMARCRecord [-Name] <String> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
It is important to configure DMARC on your emaildomain. DMARC stands for Domain-based Message Authentication, Reporting and Conformance. It is a policy-based protocol for enforcing a specific policy to email traffic sent on behalf of an email domain. DMARC works closely with the SPF and DKIM records, to prevent email spoofing. This PowerShell function can resolve an DMARC record of a domain and give an advisory regarding the current configuration.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DMARCRecord -Name binsec.nl
```
```powershell
Name      DmarcRecord                 DmarcAdvisory
----      -----------                 -------------
binsec.nl v=DMARC1; p=reject; pct=100 Domain has a DMARC record and your DMARC policy will prevent abuse of your domain by phishers and spammers.
```
This example resolves the DMARC record for the domain binsec.nl.

### Example 2
```powershell
PS C:\> Get-DMARCRecord -Name binsec.nl -Server 10.0.0.1
```
```powershell
Name      DmarcRecord                 DmarcAdvisory
----      -----------                 -------------
binsec.nl v=DMARC1; p=none; pct=100   Domain has a valid DMARC record but the DMARC (subdomain) policy does not prevent abuse of your domain by phishers and spammers.
```
This example resolves the DMARC record for the domain binsec.nl agains the DNS server 10.0.0.1.

## PARAMETERS

### -Name
Specifies the domain for resolving the DMARC-record.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
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
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-DMARCRecord is part of the 'DomainHealthChecker' module on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)