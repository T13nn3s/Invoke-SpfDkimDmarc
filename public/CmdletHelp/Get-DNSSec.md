---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DNSSec.md
schema: 2.0.0
---

# Get-DNSSec

## SYNOPSIS
Determines whether one or more domains are DNSSEC-signed.

## SYNTAX

```
Get-DNSSec [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get-DNSSec queries DNSKEY records for the specified domain(s) and evaluates DNSSEC configuration (flags and protocol) per RFC4034. On Windows it uses Resolve-DnsName; on Linux/macOS it uses dig (dnsutils required). Returns PSCustomObject(s) with properties: Name, DNSSEC, and DnsSecAdvisory. Supports an optional -Server parameter to query a specific DNS server.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DNSSec -Name binsec.nl
```

This example resolved the DNSSEC records for the specified domain.

## PARAMETERS

### -Name
Specifies the domain name for testing for DNSSEC existance.

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

[A Gentle Introduction to DNSSEC](https://www.cloudflare.com/dns/dnssec/how-dnssec-works/)

[Get-DNSSec is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](github.com/T13nn3s/Invoke-SpfDkimDmarc/)
