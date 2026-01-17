<#
.SYNOPSIS
Checks the installed DomainHealthChecker module version and updates it if a newer version is available.

.DESCRIPTION
This function checks if there is a newer version of the DomainHealthChecker module available on the PowerShell Gallery.
.EXAMPLE
Update-ModuleDomainHealthChecker
#>

function Update-ModuleDomainHealthChecker {
    [CmdletBinding()]
    param()

    begin {
        # Checks the current installed version of the DomainHealthChecker module
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        try {
            Write-Verbose "Checking the current installed module version..."
            $CurrentInstalledModuleVersion = (Get-Module -Name DomainHealthChecker).Version.ToString()
            $CurrentVersionOnPowerShellGallery = (Find-Module -Name DomainHealthChecker).Version.ToString()
            Write-Verbose "Current installed version: $CurrentInstalledModuleVersion"
            Write-Verbose "Latest version on PowerShell Gallery: $CurrentVersionOnPowerShellGallery"
        }
        catch {
            Write-Verbose "Error occurred while checking module version: $_"
            Write-Error "[-] Failed to check the module version. Ensure you have an active internet connection and access to the PowerShell Gallery."
        }

    } process {
        if ($CurrentInstalledModuleVersion -lt $CurrentVersionOnPowerShellGallery) {
            Write-Host "[*] A newer version of the DomainHealthChecker module is available. You have version $CurrentInstalledModuleVersion, we recommend to update the latest version $CurrentVersionOnPowerShellGallery." -ForegroundColor Yellow
            
            # Request user confirmation to update the module
            Write-Verbose "Prompting user for module update confirmation."

            $answer = Read-Host "[?] Do you want to update the DomainHealthChecker module now? (y/N)"
            switch ($answer) {
                { $_.ToLower() -eq 'y' } {
                    Write-Verbose "User chose to update 'DomainHealthChecker'."
                    Write-Host "[+] Updating DomainHealthChecker module..."
                    try {
                        Update-Module -Name DomainHealthChecker -Force -ErrorAction Stop
                        Write-Host "[+] Module updated successfully to version $CurrentVersionOnPowerShellGallery." -ForegroundColor Green
                    }
                    catch {
                        Write-Verbose "Error occurred during module update: $_. Trying alternative update method."
                        Install-Module -Name DomainHealthChecker -Force -AllowClobber -ErrorAction Stop
                        
                    } finally {
                        Write-Verbose "Error occurred while updating module: $_"
                        Write-Error "[-] Failed to update the DomainHealthChecker module. Please try updating it manually."
                    }
                }
                { $_.ToLower() -eq 'n' } {
                    Write-Verbose "User chose not to update 'DomainHealthChecker'."
                    Write-Host "[*] Module update skipped. You can update the module later by running Update-ModuleDomainHealthChecker." -ForegroundColor Yellow
                }
                Default {
                    Write-Verbose "User input not recognized, assuming 'No'."
                    Write-Host "[*] Module update skipped. You can update the module later by running 'Update-Module -Name DomainHealthChecker -Force'."
                }
            }
        }
    } end {
        Write-Verbose "Completed $($MyInvocation.MyCommand)"
    }
}

