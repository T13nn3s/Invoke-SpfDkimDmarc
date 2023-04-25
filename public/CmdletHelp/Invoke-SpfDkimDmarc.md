---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md
schema: 2.0.0
---

# Invoke-SpfDkimDmarc

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### domain
```
Invoke-SpfDkimDmarc [-Name] <String> [[-DkimSelector] <String>] [[-Server] <String>] [-IncludeDNSSEC]
 [<CommonParameters>]
```

### file
```
Invoke-SpfDkimDmarc [-File] <FileInfo> [[-DkimSelector] <String>] [[-Server] <String>] [-IncludeDNSSEC]
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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
