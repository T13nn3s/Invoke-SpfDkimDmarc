---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-TlsRpt.md
schema: 2.0.0
---

# Get-TlsRpt

## SYNOPSIS
Retrieves and validates TLS-RPT records for one or more domains.

## SYNTAX

```
Get-TlsRpt [-Name] <String[]> [[-Server] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-TlsRpt queries the TLS-RPT DNS record for one or more domains and returns the record content along with an advisory indicating whether a valid TLS-RPT policy was found. It supports querying against a custom DNS server and is intended for email security and domain health checks.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-TlsRpt microsoft.com

Name          TlsRptRecord                                           TlsRptAdvisory
----          ------------                                           --------------
microsoft.com v=TLSRPTv1;rua=https://tlsrpt.azurewebsites.net/report TLS-RPT Record found. The 'rua' field is configured.
```

Queries the TLS-RPT DNS record for the domain `microsoft.com`.

### Example 2
```powershell
PS C:\> {{ command }}
```

<exlplaination>

## PARAMETERS

### -Name
Enter one or more domain names to resolve their TLS-RPT records.

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

### -ProgressAction

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-TlsRpt is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](https://www.github.com/T13nn3s/Invoke-SpfDkimDmarc/)