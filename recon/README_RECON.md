# PowerShell System & Network Reconnaissance

This PowerShell script is designed to perform essential reconnaissance by gathering key information about a target Windows system and its network configuration. It automates the collection of crucial data, providing a quick yet thorough overview for initial assessment during penetration tests or red team engagements.

---

## 🚀 Features

*   **Local System Reconnaissance:**
    * Retrieves the **current user** details (`whoami.exe`).
    * Obtains the **hostname** (`hostname.exe`).
    * Shows **system uptime and active user sessions** (`quser.exe`).
    * Collects detailed **operating system information** (using WMI's `Win32_OperatingSystem`).
    * Determines if the **current user has Administrator privileges**.
* **Local Network Reconnaissance:**
    * Displays **full IP configuration** (`ipconfig /all`).
    * Lists **active TCP connections and listening ports** (`netstat -ano`).
    * Performs a **DNS resolution test** (`Resolve-DnsName`).
* **Comprehensive Output:**
    * Presents all gathered information directly in the **PowerShell console**.
    * **Saves a full report** to a file named `recon_report.txt` in UTF-8 encoding for easy offline analysis.

---

## ️ How to Use

1.  **Save the Script:** Save the PowerShell script (e.g., `system_network_recon.ps1`) to your local machine.
2.  **Transfer to Target:** Transfer the `.ps1` file to your target system (ensure you have explicit, written permission to do so).
3.  **Execute:** Open a PowerShell console on the target and run the script:

    ```powershell
    .\system_network_recon.ps1
    ```

    * **Note on Execution Policy:** If PowerShell's execution policy prevents the script from running, you might need to bypass it. A common method is:
        ```powershell
        powershell.exe -ExecutionPolicy Bypass -File .\system_network_recon.ps1
        ```
    * **Stealthier Execution:** For more covert operations, you could encode this script to Base64 (using a tool like `encode_and_execute_b64.ps1` from this repository) and execute it with `powershell.exe -EncodedCommand`.

4.  **Review Report:** After execution, the reconnaissance data will be displayed in the console. Additionally, a file named `recon_report.txt` will be created in the same directory as the script, containing all the collected information for your review.

---

## ⚠️ Disclaimer

This tool is intended for **educational purposes and authorized penetration testing only**. Do not use it on any systems or networks without explicit, written permission from the owner. Unauthorized access or use is illegal and unethical. The author is not responsible for any misuse or damage caused by this script.

Please be aware that running this script may trigger **security alerts** (e.g., from Antivirus or EDR solutions) due to its use of common system commands (`whoami`, `ipconfig`, `netstat`) and its behavior of writing to a file, which can be seen as suspicious activities. It's crucial to understand the detection implications in a real-world scenario.
