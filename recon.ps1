$user = whoami
$hostname = hostname
$ipconfig = ipconfig
$processes = Get-Process | Out-String
$services = Get-Service | Out-String
$ports = netstat -ano

@"
==== USER ====
$user

==== HOSTNAME ====
$hostname

==== IP CONFIG ====
$ipconfig

==== PROCESSES ====
$processes

==== SERVICES ====
$services

==== PORTS ====
$ports
"@ | Out-File recon_report.txt -Encoding utf8