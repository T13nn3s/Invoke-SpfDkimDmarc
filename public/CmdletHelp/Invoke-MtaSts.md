---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-SPFRecord.md
schema: 2.0.0
---

# Invoke-MtaSts

## SYNOPSIS
Function to check for MTA-STS DNS TXT Record and Valid MTA-STS Policy

## SYNTAX

```
Invoke-MtaSts [-Name] <String[]> [[-Server] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
MTA-STS (Mail Transfer Agent Strict Transport Security) is a security mechanism designed to enforce the use of encrypted (TLS) connections for email in transit, helping to prevent man-in-the-middle attacks on email communication. It enables domain owners to specify that emails sent to their domain should only be accepted over secure TLS connections and to define a policy for handling messages if secure transmission fails.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
