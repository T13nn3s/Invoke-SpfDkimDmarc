---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Invoke-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-CAARecord.md
schema: 2.0.0
---

# Get-CAARecord

## SYNOPSIS
Retrieves the DNS CAA (Certification Authority Authorization) record and checks which CA(s) are authorized. It also checks if reporting is enabled.

## SYNTAX

```
Get-CAARecord [-Name] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Retrieves the CAA DNS record for a domain using Cloudflare DNS-over-HTTPS and returns the domain name, CAA status, and advisory information.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-CAARecord binsec.nl | fl *

Name        : binsec.nl
CAARecord   : CAA record found, allowed CAs: comodoca.com, digicert.com; cansignhttpexchanges=yes, issue "letsencrypt.org", issue "sectigo.com", letsencrypt.org, pki.goog; cansi
              gnhttpexchanges=yes, ssl.com, comodoca.com, digicert.com; cansignhttpexchanges=yes, letsencrypt.org, pki.goog; cansignhttpexchanges=yes, ssl.com.
CAAAdvisory : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.
```

Checks the DNS CAA Record for the domain `binsec.nl`.

### Example 2
```powershell
PS C:\> Get-CAARecord binsec.nl, itsecuritymatters.nl | fl *

Name        : binsec.nl
CAARecord   : CAA record found, allowed CAs: comodoca.com, digicert.com; cansignhttpexchanges=yes, issue "letsencrypt.org", issue "sectigo.com", letsencrypt.org, pki.goog; cansi
              gnhttpexchanges=yes, ssl.com, comodoca.com, digicert.com; cansignhttpexchanges=yes, letsencrypt.org, pki.goog; cansignhttpexchanges=yes, ssl.com.
CAAAdvisory : CAA record found and IODEF not configured. Consider adding an IODEF contact to the CAA record to receive notifications.

Name        : itsecuritymatters.nl
CAARecord   : No CAA record found.
CAAAdvisory : No CAA record found. Consider adding a CAA record specifying which CA(s) are authorized to issue certificates for itsecuritymatters.nl.
```

Checks the DNS CAA Record for the domain `binsec.nl` and `itsecuritymatters.nl`.

## PARAMETERS

### -Name
Specifies the domain for resolving the CAA-record.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String[]

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS

[Get-DKIMRecord is part of the 'DomainHealthChecker' module, available on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)

[Project site on Github](https://www.github.com/T13nn3s/Invoke-SpfDkimDmarc/)
