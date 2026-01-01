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

function Test-DnsUtilsInstalled {
    [cmdletbinding()]
    param()

    begin {
        Write-Verbose "Starting $($MyInvocation.MyCommand)"

    } Process {
        Write-Verbose "Checking if 'dnsutils' package is installed."
        if (dpkg -l dnsutils 2>$null) {
            Write-verbose "dnsutils is installed"
        }
        else {
            Write-Host "[!] To use this module on Linux or macOS, the 'dnsutils' package must be installed to use the 'dig' command."
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
                Default {
                    Write-Verbose "User chose not to install 'dnsutils'."
                    Write-Host "[*] Installation canceled by user."
                    return
                }
            }
        }
    } End {
        Write-Verbose "Finished $($MyInvocation.MyCommand)"
    }
}