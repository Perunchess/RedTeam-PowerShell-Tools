<#
.SYNOPSIS
    Encodes a PowerShell script to Base64 and provides the command to execute it.

.DESCRIPTION
    This script takes a specified PowerShell file, reads its content, encodes it
    into a Base64 string using UTF-16LE (Unicode) encoding, which is required
    by PowerShell's -EncodedCommand parameter. It then outputs the Base64 string
    and the command-line snippet needed to execute it remotely or locally.

.PARAMETER InputFilePath
    The full path to the PowerShell script file (.ps1) that you want to encode.

.NOTES
    Author: Perunchess
    Disclaimer: For educational and authorized penetration testing purposes only.
                Do not use on systems without explicit, written permission.
                Using Base64 encoding can bypass basic signature-based detections,
                but advanced EDR/Antivirus solutions may still detect malicious behavior
                upon execution.
#>

#region Configuration

# Define the path to the PowerShell script you want to encode.
# IMPORTANT: Replace 'C:\Path\To\your_script.ps1' with the actual path to your target .ps1 file.
# For example, if you want to encode your reverse shell:
# $InputFilePath = "C:\Users\YourUser\Desktop\powershell_reverse_shell_byte_stream.ps1"
$InputFilePath = "C:\Path\To\your_script.ps1"

#endregion

#region Base64 Encoding Logic

Write-Host "--- Starting Base64 Encoding ---" -ForegroundColor Yellow

try {
    # Check if the specified input file actually exists.
    if (-not (Test-Path -Path $InputFilePath -PathType Leaf)) {
        Write-Host "Error: Input file '$InputFilePath' not found." -ForegroundColor Red
        return # Exit the script if the file doesn't exist.
    }

    # Read the entire content of the PowerShell script file.
    # Get-Content reads the file line by line by default, but here we want the whole content as a single string.
    $code = Get-Content -Path $InputFilePath -Raw

    # Convert the script content string into a byte array.
    # PowerShell's -EncodedCommand parameter expects UTF-16LE (Unicode) encoded bytes.
    $bytes = [System.Text.Encoding]::Unicode.GetBytes($code)

    # Convert the byte array into a Base64 string.
    $base64String = [Convert]::ToBase64String($bytes)

    Write-Host "`n[+] PowerShell Script Encoded to Base64 Successfully!" -ForegroundColor Green

    #endregion

    #region Execution Command Output

    Write-Host "`n--- Execution Command ---" -ForegroundColor Yellow
    Write-Host "Use the following command to execute the Base64 encoded script:" -ForegroundColor White
    Write-Host "   powershell.exe -EncodedCommand $base64String" -ForegroundColor Cyan
    Write-Host "`nNote: For remote execution or in scenarios where PowerShell's execution policy is restricted," -ForegroundColor DarkGray
    Write-Host "      you might need to add '-ep bypass -w hidden -nop' parameters:" -ForegroundColor DarkGray
    Write-Host "   powershell.exe -ep bypass -w hidden -nop -EncodedCommand $base64String" -ForegroundColor DarkCyan

    # Optional: Save the Base64 string to a file for easy copying/pasting.
    # $base64String | Out-File -FilePath ".\encoded_payload.txt" -Encoding ASCII
    # Write-Host "`n[+] Base64 string also saved to encoded_payload.txt" -ForegroundColor Green

    #endregion

}
catch {
    # Catch any errors that occur during file reading or encoding.
    Write-Host "An error occurred during encoding: $($_.Exception.Message)" -ForegroundColor Red
}
