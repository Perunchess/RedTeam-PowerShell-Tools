# PowerShell Active Directory Reconnaissance Script (`AD_recon.ps1`)

This script is designed for initial **Active Directory (AD) enumeration** during penetration tests or red team engagements. It automates the process of gathering crucial information about the domain, its computers, users, and especially privileged groups like "Domain Admins".

---

## 🚀 Features

* **Automated PowerView Integration:**
    * Checks for the presence of `PowerView.ps1` locally.
    * **Downloads `PowerView.ps1`** directly from the official PowerSploit GitHub repository if it's not found, ensuring necessary tools are available on the target.
    * Imports PowerView to enable its powerful AD enumeration cmdlets.
* **Comprehensive AD Data Collection:**
    * Gathers **general domain information** using `Get-NetDomain`.
    * Enumerates a detailed list of **domain computers** with `Get-NetComputer -FullData`.
    * Lists all **domain users** with detailed attributes using `Get-NetUser -FullData`.
    * Identifies **members of the 'Domain Admins' group** using `Get-NetGroupMember`, a critical step for privilege escalation paths.
* **Clear Output:**
    * Displays all collected AD reconnaissance data directly in the **PowerShell console**.
    * The report is formatted for easy readability.

---

## 🛠️ How to Use

1.  **Save the Script:** Save the `AD_recon.ps1` file to your target machine.
2.  **Transfer to Target:** Get the `.ps1` file onto the system where you want to perform the reconnaissance.
3.  **Execute:** Open a PowerShell console on the target and run the script:

    ```powershell
    .\AD_recon.ps1
    ```

    * **Execution Policy Note:** If PowerShell's execution policy prevents the script from running, you might need to bypass it:
        ```powershell
        powershell.exe -ExecutionPolicy Bypass -File .\AD_recon.ps1
        ```
    * **Stealthier Execution:** For more covert operations, consider encoding this script to Base64 (using a tool like `encode_and_execute_b64.ps1` from this repository) and executing it with `powershell.exe -EncodedCommand`.

---

## ⚠️ Disclaimer

This tool is intended for **educational purposes and authorized penetration testing only**. Do not use it on any systems or networks without explicit, written permission from the owner. Unauthorized use is illegal and unethical. The author is not responsible for any misuse or damage caused by this script.

Be aware that using this script may trigger **security alerts** (e.g., from Antivirus or EDR solutions) due to its functionality and the dynamic download of `PowerView`. It's essential to understand the detection implications in a real-world scenario.
