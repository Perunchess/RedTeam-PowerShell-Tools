$user = whoami
$hostname = hostname
$processes = Get-Process | Out-String
$services = Get-Service | Out-String
$ipconfig = Get-NetIPConfiguration | Out-String
$ports = Get-NetTCPConnection | Out-String

@"
==== USER ====
$user

==== HOSTNAME ====
$hostname

==== PROCESSES ====
$processes

==== SERVICES ====
$services

==== IP ====
$ipconfig

==== PORTS ====
$ports


"@ | Out-File recon_report.txt -Encoding utf8
