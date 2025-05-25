# PowerShell Base64 Encoder & Executor

This PowerShell script provides a convenient way to encode any `.ps1` script into a Base64 string, which can then be executed via `powershell.exe -EncodedCommand`. This technique is commonly used to bypass basic signature-based antivirus detections and to obfuscate script content during command-line execution.

## 🚀 Features

* **Script Encoding:** Takes a PowerShell script file (`.ps1`) as input and converts its content to a Base64 string.
* **UTF-16LE (Unicode) Encoding:** Ensures compatibility with PowerShell's `-EncodedCommand` parameter, which specifically expects Unicode-encoded input.
* **Ready-to-Use Command:** Outputs the full `powershell.exe -EncodedCommand` line, making it easy to copy and paste for immediate use.
* **Execution Policy Bypass Suggestion:** Provides an example command that includes common bypass techniques (`-ep bypass -w hidden -nop`) for stealthier execution in various environments.

## 🛠️ How to Use

1.  **Save the Script:** Save the `encode_and_execute_b64.ps1` file to your local machine.
2.  **Edit the Input Path:** Open `encode_and_execute_b64.ps1` in a text editor (like VS Code or Notepad).
    * Locate the line `$InputFilePath = "C:\Path\To\your_script.ps1"`.
    * **Change `C:\Path\To\your_script.ps1`** to the *actual full path* of the PowerShell script you want to encode (e.g., your reverse shell script like `powershell_reverse_shell_byte_stream.ps1`).

    ```powershell
    # Example:
    $InputFilePath = "C:\Users\YourUser\Desktop\your_reverse_shell.ps1"
    ```

3.  **Run the Encoder:** Open PowerShell and navigate to the directory where you saved `encode_and_execute_b64.ps1`. Then execute it:

    ```powershell
    .\encode_and_execute_b64.ps1
    ```

4.  **Get the Output:** The script will output the Base64 string and the full command-line to execute it. Copy this command.

    ```
    --- Starting Base64 Encoding ---

    [+] PowerShell Script Encoded to Base64 Successfully!

    --- Execution Command ---
    Use the following command to execute the Base64 encoded script:
       powershell.exe -EncodedCommand <your_very_long_base64_string_here>

    Note: For remote execution or in scenarios where PowerShell's execution policy is restricted,
          you might need to add '-ep bypass -w hidden -nop' parameters:
       powershell.exe -ep bypass -w hidden -nop -EncodedCommand <your_very_long_base64_string_here>
    ```

5.  **Execute the Encoded Command:** Paste the copied command into a target PowerShell console or command prompt (if authorized) to execute your original script without directly calling the `.ps1` file.

## ⚠️ Disclaimer

This tool is intended for **educational purposes and authorized penetration testing only**. Do not use it on any systems or networks without explicit, written permission from the owner. Unauthorized use is illegal and unethical. The author is not responsible for any misuse or damage caused by this script.

While Base64 encoding can bypass some basic security measures, it's generally *not* sufficient to evade modern EDR (Endpoint Detection and Response) or advanced antivirus solutions, which often detect malicious behavior upon execution, regardless of the encoding.
