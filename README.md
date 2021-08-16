<p align="center">
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/v/DomainHealthChecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/badge/platform-windows-green"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/github/languages/code-size/t13nn3s/domainhealthchecker"></a>
  <a href="https://www.powershellgallery.com/packages/DomainHealthChecker/"><img src="https://img.shields.io/powershellgallery/dt/DomainHealthChecker"></a>
</p>

<p align="center">

# Invoke-SpfDkimDmarc
Invoke-SpfDkimDmarc is a function within the PowerShell module named `DomainHealthChecker` that can check the SPF, DKIM and DMARC record for one or multiple domains. On installing this module you can use `Invoke-SpfDKimDmarc` to check the records. You can also check the records individually by using the cmdlets `Get-SPFrecord`, `Get-DKIMRecord` or by running the `Get-DMARCRecord` to check the record of a single domain.


![Invoke-SpfDkimDmarc](https://github.com/T13nn3s/Show-SpfDkimDmarc/blob/main/logo/Show-SpfDkimDmarc.png)


## System Requirements
This module requires PowerShell version 5.1 or higher. 

## Installation PowershellGallery (recommended)
The module is published on the PowerShellGallery. You can install this module directly from the PowerShellGallery with the following command:
```powershell
C:\> Install-Module DomainHealthChecker
```
PowerShellGallery will automatically download and install the latest version of the module. 

## Manual Installation
Download the module from the 'Releases' tab from Github. Just download and extract the ZIP file, and just import the module by running this command below:
```powershell
C:\> Import-Module -Name .\DomainHealthChecker.psm1
```

## Available cmdlets
After installing this module, you have the following cmdlets at your disposal.

- `Invoke-SpfDkimDmarc` to check the SPF, DKIM, and DMARC records for one or multiple domains. You can export the results to a file. For example, to a comma-separated file with the `Export-CSV` command.
- `Get-SPFRecord` to check the SPF record for a single domain. This cmdlet has also an alias `gspf` for quick checks.
- `Get-DKIMRecord` to check the DKIM record for a single domain. This cmdlet has also an alias `gdkim` for quick checks.
- `Get-DMARCRecord` to check the DMARC record for a single domain. This cmdlet has also an alias `gdmarc` for quick checks.

## Split DNS environment
If you are using a split DNS environment, you can still use this module using the `-Server` parameter to specify an alternative DNS server.
