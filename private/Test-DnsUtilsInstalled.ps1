<#
.SYNOPSIS
Checks if DNS utilities are installed on the Linux system (dig).

.DESCRIPTION
The package 'dnsutils' provides the 'dig' command-line tool, which is essential for DNS lookups.
This function checks if 'dig' is available on the system and prompts the user to install 'dnsutils' if it is missing.

.EXAMPLE
PS /home/user> Test-DnsUtilsInstalled
[-] dnsutils is NOT installed
[?] The 'dnsutils' package is required for DNS lookups. Do you want to install it now? (y/N): Y
[*] Updating package list...
[*] Installing dnsutils...
[+] Installation complete.
[+] Installation finished.
#>

# Load private functions
Import-Module $PSScriptRoot\Get-OsPlatform.ps1 -Force -DisableNameChecking

function Test-DnsUtilsInstalled {
    [cmdletbinding()]
    param()

    begin {

        try {
            $OsPlatform = (Get-OsPlatform).Platform
        }
        catch {
            Write-Verbose "Failed to determine OS platform, defaulting to Windows"
            $OsPlatform = "Windows"
        }

        Write-Verbose "Starting $($MyInvocation.MyCommand)"

    } Process {

        if ($OsPlatform -eq "Linux") {
            Write-Verbose "Checking if 'dnsutils' package is installed."
            if (dpkg -l dnsutils 2>$null) {
                Write-verbose "dnsutils is installed"
            }
            else {
                Write-Host "[!] To use this module on Linux, the 'dnsutils' package must be installed to use the 'dig' command."
                Write-Verbose "[*] Checking if 'dnsutils' package is installed."
                Write-Host "[-] dnsutils is NOT installed"
                Write-verbose "'dnsutils' package is not installed."
                Write-Verbose "Prompting user to install 'dnsutils' package."
                $answer = Read-Host "[?] The 'dnsutils' package is required for DNS lookups. Do you want to install it now? (y/N)"

                switch ($answer) {
                    { $_.ToLower() -eq 'y' } {
                        Write-Verbose "User chose to install 'dnsutils'."
                        Write-Host "[*] Updating package list..."
                        sudo apt update

                        Write-Host "[*] Installing dnsutils..."
                        sudo apt install -y dnsutils

                        Write-Host "[+] Installation complete."
                        if (dpkg -l dnsutils 2>$null) {
                            Write-Host "[+] Installation finished."
                        }
                        else {
                            Write-Host "[-] dnsutils is NOT installed. Try to run the script again or install dnsutils manually with 'sudo apt install dnsutils'."
                            return
                        }
                    }
                    { $_.ToLower() -eq 'n' } {
                        Write-Verbose "User chose not to install 'dnsutils'."
                        Write-Host "[*] Installation canceled by user."
                        return
                    }
                    Default {
                        Write-Verbose "No valid input from user. Assuming 'No'."
                        Write-Host "[*] Installation canceled by user."
                        return
                    }
                }
            }
        }
        elseif ($OsPlatform -eq "macOS") {
            # Although 'dig' is included by default on macOS, we still want to check to make sure that the 'dig' command is available.
            Write-Verbose "Checking if the 'dig' command is available."
            if (Get-Command dig -ErrorAction SilentlyContinue) {
                Write-Verbose "dig is installed."
            }
            else {
                Write-Host "[!] To use this module on macOS, the 'bind' package must be installed to use the 'dig' command."
                Write-Verbose "[-] dig is NOT installed"
                Write-Host "[-] dig is NOT installed"
                Write-Verbose "Prompting user to install 'bind' package using 'Homebrew."
                $answer = Read-Host "[?] The 'bind' package is required for DNS lookups. Do you want to install it now using Homebrew? (y/N)"

                switch ($answer) {
                    { $_.ToLower() -eq 'y' } {
                        Write-Verbose "User chose to install 'bind' package."
                        
                        # Check if Homebrew is installed
                        Write-Verbose "Checking if Homebrew is installed."
                        if (-not (Get-Command brew -ErrorAction SilentlyContinue)) {
                            Write-Verbose "Homebrew is NOT installed."
                            Write-Host "[-] Homebrew is not installed. Please install Homebrew first or installed the 'bind' package manually. Exiting..."
                            return
                        }
                        else {

                            # Install dig (part of the BIND package)
                            Write-Verbose "Homebrew is installed. Proceeding to install 'bind' package."
                            brew install bind
                            Write-Verbose "dig has been installed."
                            if (Get-Command dig -ErrorAction SilentlyContinue) {
                                Write-Verbose "dig is installed successfully."
                            }
                            else {
                                Write-Host "[-] dig is NOT installed. Try to run the script again or install bind manually with 'brew install bind'."
                                return
                            }
                        }
                    }
                    { $_.ToLower() -eq 'n' } {
                        Write-Verbose "User chose not to install 'bind'."
                        Write-Host "[*] Installation canceled by user."
                        return
                    }
                    Default {
                        Write-Verbose "User chose not to install 'bind' package."
                        Write-Host "[*] Installation canceled by user."
                        return
                    }
                }
            }
        } 
    } End {
        Write-Verbose "Finished $($MyInvocation.MyCommand)"
    }
} 
