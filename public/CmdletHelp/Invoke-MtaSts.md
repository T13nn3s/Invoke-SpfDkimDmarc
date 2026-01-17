---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Invoke-MtaSts.md
schema: 2.0.0
---

# Invoke-MtaSts

## SYNOPSIS
Validates a domain's MTA-STS DNS record and policy file and reports MX TLS support.

## SYNTAX

```
Invoke-MtaSts [-Name] <String[]> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
Invoke-MtaSts checks the _mta-sts TXT DNS record and downloads the MTA-STS policy file from https://mta-sts.<domain>/.well-known/mta-sts.txt. It validates record format (version and id), evaluates the policy file (version, mode, max_age, and listed mx entries), compares policy MX entries to actual MX DNS records, and tests whether MX hosts support STARTTLS. Returns PSCustomObject(s) with Name, mtaRecord, and mtaAdvisory properties. Cross-platform: uses Resolve-DnsName on Windows and dig on Linux/macOS; accepts an optional -Server parameter for custom DNS resolution.

## EXAMPLES

### Example 1
```powershell
PS C:\> Invoke-MtaSts microsoft.com

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

This exmaple checks for the MTA-STS TXT record and valid MTA-STS Policy for the domain microoft.com

### Example 2
```powershell
PS C:\>  Invoke-MtaSts binsec.nl, microsoft.com

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
binsec.nl                                  The MTA-STS DNS record doesn't exist.
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

This exmaple checks for the MTA-STS TXT record and valid MTA-STS Policy for the domain binsec.nl and microoft.com.

### Example 3
```powershell
PS C:\> Invoke-MtaSts microsoft.com -Server 1.1.1.1

Name          mtaRecord                    mtaAdvisory
----          ---------                    -----------
microsoft.com v=STSv1; id=20190225000000Z; The domain has the MTA-STS DNS record and file configured and protected against interception or tampering.
```

This exmaple checks for the MTA-STS TXT record and valid MTA-STS Policy for the domain microoft.com by using a different DNS Server. This can be used in a split DNS environment. 

## PARAMETERS

### -Name
Specifies the domain for resolving the MTA-STS record.

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

[Get-MtaSts is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](github.com/T13nn3s/Invoke-SpfDkimDmarc/)