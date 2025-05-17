#Encode to base64
$code = Get-Content -Path test_payload.ps1
$bytes = [System.Text.Encoding]::Unicode.GetBytes($code)
[Convert]::ToBase64String($bytes)

#Execute the command
#powershell.exe -EncodedCommand <your_base64_string>