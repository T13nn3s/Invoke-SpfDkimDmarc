<p align="center">
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/v/DomainHealthChecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/badge/platform-windows-green"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/github/languages/code-size/t13nn3s/domainhealthchecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/dt/DomainHealthChecker"></a>
</p>

<p align="center">
  </p>
  
# DomainHealthChecker
Is your email domain properly protected against abuse, such as email spoofing? This form of abuse can cause (image) damage to an organization. The PowerShell script DomainHealthChecker.ps1 checks the SPF, DKIM and DMARC record of one or more email domains and gives advice if necessary. 

In short: this PowerShell Script can you use for checking SPF, DKIM and DMARC-record.

## Module installation

```
PS C:\> Install-Module -Name DomainHealthChecker
```

## Update Module to latest version

```
PS C:\> Update-Module DomainHealthChecker -Requiredversion 1.4.1
```

## SYNOPSIS
The `DomainHealthChecker` cmdlet performs a DNS query on the SPF-record, DKIM-record and DMARC-record for the specified domain name. This cmdlet takes the output and is adding some advisory if there is room for improvements for the SPF or DMARC-record.

## SYNTAX

```
Show-SpfDkimDmarc [-Name] <String> [-File] <string] [-Server <String[]>] [<CommonParameters>]
```
## EXAMPLES

### EXAMPLE 1
```
PS C:\> Show-SpfDkimDmarc -Name binsec.nl
```
This example resolves the SPF-record, DKIM-record (selector1) and DMARC-record for the domain binsec.nl.

### EXAMPLE 2
```
PS C:\> Show-SpfDkimDmarc -Name binsec.nl -Server 10.0.0.1
```
This example resolves the SPF-record, DKIM-record (selector1) and DMARC-record for the domain binsec.nl against the DNS server at 10.0.0.1.

### EXAMPLE 3
```
PS C:\> Show-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domain_list.txt
```

This example takes the list of domains from the file `domain_list.txt` and parse the domains through the SPF, DKIM and DMARC checker. 

### EXAMPLE 4
```
PS C:\> Show-SpfDkimDmarc -File $env:USERPROFILE\Desktop\domain_list.txt | Export-Csv destination.csv -NoTypeInformation -Delimiter ";"
```

This example takes the list of domains from the file `domain_list.txt` and parse the domains through the SPF, DKIM and DMARC checker. 

## PARAMETERS


### -Name
Specifies the domain for resolving the SPF, DKIM and DMARC-record.

```yaml
Type: String
Parameter Sets: domain
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```
### -File
Retrieves a list of domain names from the specified file and checks the SPF, DKIM, and DMARC-records against these domains.

```yaml
Type: String
Parameter Sets: file
Aliases: 

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -DkimSelector
Specify a custom DKIM-selector, the script will try to find and lookup the proper DKIM-record.

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

### -Server
Specifies the IP addresses or host names of the DNS servers to be queried.
By default the interface DNS servers are queried if this parameter is not supplied.

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
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS

[Script sharing post on Reddit](https://www.reddit.com/r/PowerShell/comments/occgr2/powershell_script_for_checking_spf_dkim_and_dmarc/)
[Script on PowerShellGallery](https://www.powershellgallery.com/packages/DomainHealthChecker/)
