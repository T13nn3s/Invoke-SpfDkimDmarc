---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md
schema: 2.0.0
---

# Get-SPFRecord

## SYNOPSIS
Function to resolve the SPF-record of a domain.

## SYNTAX

```
Get-SPFRecord [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
It is important to configure an SPF record on your emaildomain.
SPF stands for Sender Policy Framework, and it's an authentication protocol to prevent email spoofing.
This PowerShell function can resolve an SPF record of a emaildomain and give an advisory regarding the current configuration.

## EXAMPLES

### Example 1
```
PS C:\> get-spfrecord binsec.nl

Name                    : binsec.nl
SPFRecord               : v=spf1 -all
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
SPFAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
```

This example resolves the SPF record for the domain binsec.nl.

### Example 2
```
PS C:\> Get-SPFRecord -Name binsec.nl -Server 10.0.0.1

Name                    : binsec.nl
SPFRecord               : v=spf1 -all
SPFRecordLength         : 11
SPFRecordDnsLookupCount : 0/10 (OK)
SPFAdvisory             : An SPF-record is configured and the policy is sufficiently strict.
```

This example resolves the SPF-record for the domain binsec.nl against the DNS server at 10.0.0.1.

## PARAMETERS

### -Name
Specifies the domain for resolving the SPF-record.

```yaml
Type: String[]
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

[Get-SPFRecord is part of the 'DomainHealthChecker' module on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

