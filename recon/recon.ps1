# ---- [ System Reconnaissance ] ----
$username = whoami.exe
$hostname = hostname.exe
$uptime = quser.exe
$os_info = Get-WmiObject Win32_OperatingSystem | Select-Object Caption, OSArchitecture, Version
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

# ---- [ Network Reconnaissance ] ----
$ipconfig = ipconfig /all | Out-String
$connections = netstat -ano | Out-String
$dns_result = Resolve-DnsName "google.com" | Out-String

# ---- [ Output ] ----
Write-Host "`n================ SYSTEM RECON ================" -ForegroundColor Cyan
Write-Host "User: $username"
Write-Host "Hostname: $hostname"
Write-Host "Is Admin: $isAdmin"
Write-Host "`n--- Uptime Info ---"
Write-Host $uptime
Write-Host "`n--- OS Info ---"
$os_info | Format-List

Write-Host "`n================ NETWORK RECON ===============" -ForegroundColor Cyan
Write-Host "`n--- IP Configuration ---"
Write-Host $ipconfig
Write-Host "`n--- Active TCP Connections ---"
Write-Host $connections
Write-Host "`n--- DNS Resolution ---"
Write-Host $dns_result

# ---- [ Save Report to File ] ----
$report = @"
==== SYSTEM RECON ====
User: $username
Hostname: $hostname
Is Admin: $isAdmin

-- Uptime --
$uptime

-- OS Info --
$($os_info | Out-String)

==== NETWORK RECON ====
-- IP Configuration --
$ipconfig

-- Active Connections --
$connections

-- DNS Result --
$dns_result
"@

$report | Out-File -Encoding UTF8 recon_report.txt
Write-Host "`n[+] Recon data saved to recon_report.txt" -ForegroundColor Green
