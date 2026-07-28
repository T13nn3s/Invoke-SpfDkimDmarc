---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DKIMRecord.md
schema: 2.0.0
---

# Get-DKIMRecord

## SYNOPSIS
Retrieves and validates DKIM records for one or more domains.

## SYNTAX

```
Get-DKIMRecord [-Name] <String[]> [[-DkimSelector] <String>] [[-Server] <String>]   [<CommonParameters>]
```

## DESCRIPTION
Get-DKIMRecord queries DKIM records using a provided selector or a list of common selectors, follows CNAME chains to locate records, and reports findings and advisories per domain. It supports Windows (Resolve-DnsName) and Linux/macOS (dig), accepts an optional DNS server, and returns objects with Name, DkimRecord, DkimSelector, and DKIMAdvisory properties.

## EXAMPLES

### Example 1
```
PS C:\> Get-DKIMRecord -Name ing.nl

Name                  : ing.nl
DkimSelectorsDetected : s1, s2, selector1, selector2
DkimSelector-1        : s1
DkimRecord-1          : k=rsa; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApnjC0Fafq6RS+zmVjT6Q9mPL1dVGdB7YKK95q
                        SvqUUtBedJj9FRJjJAlmCWo+b9ud1zjeilSbFATquehhMJTbmBKbZV55c87h9kTiYEgcgin73v6jX8BZH31V3kjhZhoihkY
                        xw1dSd+kkpg8sRSjCCUTFpZPuBFeYS+lMb2FJA4lt6Z5jXZZRYJ/Z9E8+LIrg/sI7vNvMJ4tcOB2DWR2H2jwB1BRaL/KAzW
                        fOU6tiXlSUXz8ySgEpK73QYN5eI5LF9cXI8gGRKhgPsyAMk46D/PzChfM887V/OBENl5WXfdNLIhchx7+3fPr5m4Lp7N30q
                        pptkUt4DWL8Q0pcZrsOQIDAQAB
DkimAdvisory-1        : DKIM-record found for selector s1.
DkimSelector-2        : s2
DkimRecord-2          : k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCw15owzRl7WtvB+FXW9/0v2Ejq6JLxCLQVkb0bAkNOd
                        TsyjrcyO2Y9LbJY8hl+vbiyRAwcOL6mRMdp8/9pUG5igkvbgU15X5sN9t2X35vw/PTzniXb2pgRwXky74NLECe69+vgK48h
                        hfTyt1s2IlQgmszsSH/pGPo8HFF4AzXVlwIDAQAB
DkimAdvisory-2        : DKIM-record found for selector s2.
DkimSelector-3        : selector1
DkimRecord-3          : v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCyxRaOKkzswKa19QEg3fjhhg0Uhtq+stkjkdx1X
                        7MelAGcB71tmxcJKH4iBlnltMLnyrWtfKrChTsrbF7cCpdtMaXjmYVG9zvSx74HUBb223TqMve8K1qBU/sW2I3ZijuP/37H
                        acBcCmwXSQhe8+kkuGJ1Nq9eojmrdqxjB4QuTQIDAQAB;
DkimAdvisory-3        : DKIM-record found for selector selector1.
DkimSelector-4        : selector2
DkimRecord-4          : v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvDSp8D/42mawgWJauHcYFf77NZzt/lOiP
                        ITC4+dtX3YM20gVHpazEmWdcef2WkgNSLiEpVkJxqqx8K8QufV1jPxftdg1uUP9lb1wIW2LdxDURdTPKcFPQIitjyxoKFzf
                        Zvo3zNVC967lAXYHwBOpUwWLFrD7SJzqCZHZUOHrlSwehxnBVFa2YEd2qLAUSJ3TG6O9jdrCicRpvyl6CL/S+lp0uRypdmn
                        k0adAujCXKLqTmy623JguQDwyS09wjBU4M/jVIpTxvjkd4HdWv02fEMrAFLMxJH+SBkr83oXE7vUxUuqjK6hVXupecszeFO
                        kP6B0qDv2lddsJywTuUHjqmQIDAQAB;
DkimAdvisory-4        : DKIM-record found for selector selector2.
```

This example resolves the all the detected DKIM records for the domain ing.nl. It automatically detected the `s1`, `s2`, `selector1`, and `selector2` selectors.

### Example 2
```
PS C:\> Get-DKIMRecord -Name binsec.nl -DkimSelector selector1 -Server 10.0.0.1

Name         : binsec.nl
DkimRecord   : {v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDJZs7jT+kHy/Xt/TIoTPStGbeljEEqER2eRGX+xS4SeyOEchCKreZg+FotPafhNW+HWx4NcglLfaP8l8aGnPSTSHNRfGBhXMAJj2O5kxWiIuF/31HWtzAhU+L 
               HxCJM8kPz4DIDqkFWQqrL9pTQRZUxs86pPx/GZbpvhL0f9U+11QIDAQAB;}
DkimSelector : selector1
DKIMAdvisory : DKIM-record found.
```

This example resolves the DKIM record for the domain binsec.nl for a manually defined selector against the DNS server 10.0.0.1.

## PARAMETERS

### -DkimSelector
Specify a custom DKIM selector.

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

### -Name
Specifies the domain for resolving the DKIM-record.

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

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-DKIMRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](https://www.github.com/T13nn3s/Invoke-SpfDkimDmarc/)