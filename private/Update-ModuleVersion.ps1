<#
.SYNOPSIS
Checks the installed DomainHealthChecker module version and updates it if a newer version is available.

.DESCRIPTION
This function checks if there is a newer version of the DomainHealthChecker module available on the PowerShell Gallery.
.EXAMPLE
Update-ModuleVersion
#>

function Update-ModuleVersion {
    [CmdletBinding()]
    param()

    begin {
        # Checks the current installed version of the DomainHealthChecker module
        Write-Verbose "Starting $($MyInvocation.MyCommand)"
        try {
            $CurrentInstalledModuleVersion = (Get-Module -Name DomainHealthChecker).Version.ToString()
            $CurrentVersionOnPowerShellGallery = (Find-Module -Name DomainHealthChecker).Version.ToString()
        }
        catch {
            Write-Error "Failed to check the module version. Ensure you have an active internet connection and access to the PowerShell Gallery."
        }

    } process {
        if ($CurrentInstalledModuleVersion -lt $CurrentVersionOnPowerShellGallery) {
            Write-Host "A newer version of the DomainHealthChecker module is available. You have version $CurrentInstalledModuleVersion, we recommend to update the latest version $CurrentVersionOnPowerShellGallery." -ForegroundColor Yellow
            
            # Request user confirmation to update the module
            Read-Host "Do you want to update the DomainHealthChecker module now? (Y/N)" -OutVariable UpdateRequest
            while ($UpdateRequest -eq "Y" -or $UpdateRequest -eq "N") {
                switch ($UpdateRequest) {
                    Y { 
                        Write-Host "Updating DomainHealthChecker module..." -ForegroundColor Green
                    }
                    N {
                        Write-Host "Module update skipped. You can update the module later by running Update-ModuleVersion." -ForegroundColor Yellow
                    }
                    Default {
                        Write-Host "Updating DomainHealthChecker module..." -ForegroundColor Green
                    }
                }
            }
        }

    } end {
        Write-Host "Module version check completed." -ForegroundColor Green
    }
}