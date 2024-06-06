---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DMARCRecord.md
schema: 2.0.0
---

# Get-DNSSec

## SYNOPSIS
Function to check for existence DNSSEC record.

## SYNTAX

```
Get-DNSSec [-Name] <String> [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
DNSSEC creates a secure domain name system by adding cryptographic signatures to existing DNS records. These digital signatures are stored in DNS name servers alongside common record types like A, AAAA, MX, CNAME, etc. By checking its associated signature, you can verify that a requested DNS record comes from its authoritative name server and wasn’t altered en-route, opposed to a fake record injected in a man-in-the-middle attack.

## EXAMPLES

### Example 1
```powershell
PS C:\>  Get-DNSSec -Name binsec.nl
```

This example resolved the DNSSEC records for the specified domain.

## PARAMETERS

### -Name
Specifies the domain name for testing for DNSSEC existance.

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
[A Gentle Introduction to DNSSEC](https://www.cloudflare.com/dns/dnssec/how-dnssec-works/)
[Get-SPFRecord is part of the 'DomainHealthChecker' module on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)
