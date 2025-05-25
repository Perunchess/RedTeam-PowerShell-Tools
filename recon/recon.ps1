<#
.SYNOPSIS
    Gathers essential system and network information from a target Windows machine.

.DESCRIPTION
    This script automates the collection of crucial reconnaissance data,
    including user and host details, operating system information, network configurations
    (IP addresses, connections), and DNS resolution capabilities.
    The collected data is displayed in the console and saved to a text file for later analysis.

.NOTES
    Author: Perunchess
    Disclaimer: For educational and authorized penetration testing purposes only.
                Do not use on systems without explicit, written permission.
                Running this script may leave forensic artifacts.
#>

#region System Reconnaissance

Write-Host "--- Starting System Reconnaissance ---" -ForegroundColor Yellow

# Get the current username. 'whoami.exe' is a standard Windows command.
$username = whoami.exe

# Get the hostname of the machine. 'hostname.exe' is a standard Windows command.
$hostname = hostname.exe

# Get system uptime and active user sessions using 'quser.exe'.
# This command shows users currently logged on and how long their session has been active.
$uptime = quser.exe | Out-String

# Retrieve detailed operating system information using WMI (Windows Management Instrumentation).
# Select specific properties for clarity: Caption (OS name), OSArchitecture (32-bit/64-bit), Version (build number).
$os_info = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, OSArchitecture, Version

# Check if the current user has Administrator privileges.
# This uses .NET security classes to determine if the current user token includes the Administrator role.
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

#endregion

#region Network Reconnaissance

Write-Host "`n--- Starting Network Reconnaissance ---" -ForegroundColor Yellow

# Get detailed IP configuration, including IP addresses, subnet masks, gateways, and DNS servers.
# 'ipconfig /all' is a comprehensive network command, and Out-String converts its output to a string.
$ipconfig = ipconfig /all | Out-String

# List all active TCP connections and listening ports, including process IDs (PIDs).
# 'netstat -ano' is a standard command for network statistics.
$connections = netstat -ano | Out-String

# Test DNS resolution by trying to resolve "google.com".
# Resolve-DnsName is a PowerShell cmdlet for DNS lookups.
$dns_result = Resolve-DnsName "google.com" | Out-String

#endregion

#region Output & Reporting

Write-Host "`n--- Displaying Reconnaissance Results ---" -ForegroundColor Yellow

# Display System Reconnaissance results in the console.
Write-Host "`n================ SYSTEM RECON ================" -ForegroundColor Cyan
Write-Host "User: $username"
Write-Host "Hostname: $hostname"
Write-Host "Is Admin: $isAdmin"
Write-Host "`n--- Uptime Info ---"
Write-Host $uptime
Write-Host "`n--- OS Info ---"
# Format-List ensures the OS information is displayed clearly, one property per line.
$os_info | Format-List

# Display Network Reconnaissance results in the console.
Write-Host "`n================ NETWORK RECON ===============" -ForegroundColor Cyan
Write-Host "`n--- IP Configuration ---"
Write-Host $ipconfig
Write-Host "`n--- Active TCP Connections ---"
Write-Host $connections
Write-Host "`n--- DNS Resolution ---"
Write-Host $dns_result

# Prepare the full report content as a multi-line string (here-string) for file output.
# The `Out-String` for `$os_info` ensures it's properly formatted within the report file.
$report = @"
==== SYSTEM RECON ====
User: $($username.Trim())
Hostname: $($hostname.Trim())
Is Admin: $isAdmin

-- Uptime --
$($uptime.Trim())

-- OS Info --
$($os_info | Out-String).Trim()

==== NETWORK RECON ====
-- IP Configuration --
$($ipconfig.Trim())

-- Active Connections --
$($connections.Trim())

-- DNS Result --
$($dns_result.Trim())
"@

# Save the compiled report to a text file.
# -Encoding UTF8 is recommended for broad compatibility and to handle various characters.
$report | Out-File -Encoding UTF8 recon_report.txt
Write-Host "`n[+] Recon data saved to recon_report.txt" -ForegroundColor Green

#endregion
