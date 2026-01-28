---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-BIMIecord.md
schema: 2.0.0
---

# Get-BimiRecord

## SYNOPSIS
Resolves and validates BIMI (Brand Indicators for Message Identification) records for one or more domains.

## SYNTAX

```
Get-BimiRecord [-Name] <String[]> [[-Selector] <String>] [[-Server] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get-BIMIRecord queries a domain's BIMI TXT record (optionally using a specified selector), evaluates the record contents, verifies the domain's DMARC policy for BIMI compatibility (requires p=quarantine or p=reject and pct=100), and inspects any referenced VMC certificate (from the a= tag) for a valid HTTPS URL and expiration. Returns a PSCustomObject per domain with properties: Name, BimiRecord, and BimiAdvisory. Cross-platform: uses Resolve-DnsName on Windows and dig on Linux/macOS (dnsutils required). Accepts an optional DNS server parameter for resolution.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-BIMIrecord binsec.nl | fl *

Name         : binsec.nl
BimiRecord   : We couldn't find a BIMI record associated with your domain.
BimiAdvisory : DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
```

Queries the BIMI record for the domain binsec.nl

### Example 2
```powershell
PS C:\> Get-BIMIRecord binsec.nl, dmarcadvisor.com

Name             BimiRecord                                                                                                                                BimiAdvisory
----             ----------                                                                                                                                ------------
binsec.nl        We couldn't find a BIMI record associated with your domain.                                                                               DMARC policy is set to p=reject, which is the best policy for BIMI to function. No 'a=' (VMC) tag found, it's recommended to include a VMC certificate.
dmarcadvisor.com v=BIMI1; l=https://bimi.eu.dmarcmanager.app/eu-2o4fmqie/default/logo.svg; a=https://bimi.eu.dmarcmanager.app/eu-2o4fmqie/default/cert.pem DMARC policy is set to p=reject, which is the best policy for BIMI to function. 'a=' (VMC) tag contains a valid HTTPS URL.
```

Queries the BIMI record for the domains binsec.nl and dmarcadvisor.com

### Example 3
```powershell
PS C:\> Get-BIMIRecord bimigroup.org -server 1.1.1.1

Name          BimiRecord                                       BimiAdvisory
----          ----------                                       ------------
bimigroup.org v=BIMI1; l=https://bimigroup.org/bimi-sq.svg; a= DMARC policy is set to p=reject, which is the best policy for BIMI to function. 'a=' (VMC) tag does not contain a valid HTTPS URL, it should start with 'https://'. It's recommended to use a valid HTTPS URL for VMC to prevent that scammers misuse your logo.
```

Queries the BIMI record for the domain bimigroup.org using an alternative DNS server.

## PARAMETERS

### -Name
Specifies the domain for resolving the BIMI-record.

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

### -Selector
Specify BIMI selector to query.

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

### -Server
DNS Server to use.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[Get-BIMIRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](github.com/T13nn3s/Invoke-SpfDkimDmarc/)