---
external help file: DomainHealthChecker-help.xml
Module Name: DomainHealthChecker
online version: https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/public/CmdletHelp/Get-DKIMRecord.md
schema: 2.0.0
---

# Get-DKIMRecord

## SYNOPSIS
Function to resolve a DKIM record of a domain.

## SYNTAX

```
Get-DKIMRecord [-Name] <String> [[-DkimSelector] <String>] [[-Server] <String>] [<CommonParameters>]
```

## DESCRIPTION
It is important to configure DKIM on an emaildomain and sending emailserver. DKIM stands for DomainKeys Identified Mail, and it's an verification protocol for verifying the legitimacy of the sender, to prevent email spoofing. This PowerShell function can resolve an DKIM record of an emaildomain and give an advisory regarding the current configuration. It's possible use a custom DKIM-selector.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-DKIMRecord -Name binsec.nl | fl *
```
```powershell
Name         : binsec.nl
DkimRecord   : {v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7b7krQw/+b1QOBkbBEW7pMNBLbb7DCEiiLM1YtM0Ekv/VgTLmdZen+m2zzaBrCpm8hnB5WogKeXJ/oE/7qzSvQFNVoOX8o5clWCL+vhnkkr+lAPOJkBJOc/ 
               asQOPc+xoPd+H86pS50gvqcJy8m0dXAp+aX62Zc2z6DDCsXl4u8QIDAQAB; n=1024,1494259634,1,  510157234}
DkimSelector : k1
DKIMAdvisory : DKIM-record found.
```
This example resolves the DKIM record for the domain binsec.nl. It automatically detects the 'k1' selector. 

### Example 2
```powershell
PS C:\> Get-DKIMRecord -Name binsec.nl -DkimSelector selector1 -Server 10.0.0.1
```
```powershell
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
Position: 2
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

[Get-DKIMRecord is part of the 'DomainHealthChecker' module on the PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)