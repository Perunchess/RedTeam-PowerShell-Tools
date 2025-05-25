<#
.SYNOPSIS
    This script performs basic Active Directory reconnaissance using the PowerView module.
    It checks for PowerView's presence, downloads it if missing, imports it,
    and then gathers information on the domain, computers, users, and 'Domain Admins' group members.

.DESCRIPTION
    This script is designed for initial enumeration during penetration tests or red team engagements.
    It helps to quickly understand the structure of the Active Directory environment,
    identify potential targets, and assess the overall security posture.

.NOTES
    Author: Perunchess
    Disclaimer: For educational and authorized penetration testing purposes only.
                Do not use on systems without explicit, written permission.
#>

#region Function: Check-PowerViewModule
# This function handles the logic for ensuring PowerView.ps1 is available and imported.
# It first checks a local path, and if the module isn't found, it attempts to download it.
function Check-PowerViewModule {
    param (
        [string]$ModulePath # Specifies the local path where PowerView.ps1 is expected or will be downloaded to.
    )

    # Check if PowerView.ps1 already exists at the specified path.
    if (Test-Path -Path $ModulePath -PathType Leaf) {
        Write-Host "Module found locally: '$ModulePath'." -ForegroundColor Green
    }
    else {
        # If the module isn't found, inform the user and attempt to download it from GitHub.
        Write-Host "PowerView module not found at: '$ModulePath'." -ForegroundColor Yellow
        Write-Host "Attempting to download PowerView.ps1 from the official PowerSploit GitHub repository..." -ForegroundColor Cyan

        try {
            # Define the direct download URL for PowerView.ps1 from GitHub.
            $DownloadURL = "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1"
            
            # Use System.Net.WebClient to download the file. This is a common method for in-memory execution or saving.
            (New-Object System.Net.WebClient).DownloadFile($DownloadURL, $ModulePath)
            Write-Host "PowerView.ps1 successfully downloaded to '$ModulePath'." -ForegroundColor Green
        }
        catch {
            # Catch any errors during download (e.g., network issues, blocked URL, Defender blocking).
            Write-Host "An error occurred during PowerView.ps1 download: $($_.Exception.Message)" -ForegroundColor Red
            return $false # Indicate failure to the calling script.
        }
    }

    # Attempt to import the PowerView module.
    try {
        # Import the module. -Force ensures it's reloaded if already present or previously failed to load.
        Import-Module $ModulePath -Force
        Write-Host "PowerView module imported successfully." -ForegroundColor Green
        return $true # Indicate success.
    }
    catch {
        # Catch any errors during module import (e.g., file corruption, security policies, AMSI blocking).
        Write-Host "Failed to import PowerView module: $($_.Exception.Message)" -ForegroundColor Red
        return $false # Indicate failure.
    }
}
#endregion

#region Main Script Execution
# This section orchestrates the reconnaissance process using the loaded PowerView module.

# Construct the local path for PowerView.ps1 relative to the script's location.
# $PSScriptRoot is an automatic variable that contains the directory of the current script.
$powerViewLocalPath = Join-Path $PSScriptRoot "PowerView.ps1" 

# Call the function to check, download, and import PowerView.
if (Check-PowerViewModule -ModulePath $powerViewLocalPath) {

    Write-Host "`nStarting Active Directory information gathering..." -ForegroundColor Blue

    # 1. Retrieve general domain information.
    # Get-NetDomain: Fetches details about the current domain (e.g., domain name, forest name, domain controllers).
    # Out-String: Converts the object output into a formatted string for easier inclusion in the report.
    Write-Host "Retrieving domain information..." -ForegroundColor DarkYellow
    $DOMAIN_INFO = Get-NetDomain | Out-String 

    # 2. Retrieve a list of domain computers.
    # Get-NetComputer -FullData: Gets detailed information for all computers in the domain.
    # Select-Object: Selects specific properties for clarity.
    # @{N='LastLogon'; E={[datetime]::FromFileTime($_.LastLogon)}}: Custom property to convert LastLogon timestamp
    # from filetime to a readable datetime format.
    # Format-Table -AutoSize: Formats the output as a table, automatically adjusting column widths.
    Write-Host "Retrieving domain computers list..." -ForegroundColor DarkYellow
    $DOMAIN_COMPUTERS = Get-NetComputer -FullData | 
                        Select-Object Name, OperatingSystem, @{N='LastLogon'; E={[datetime]::FromFileTime($_.LastLogon)}} | 
                        Format-Table -AutoSize | 
                        Out-String

    # 3. Retrieve a list of domain users.
    # Similar to Get-NetComputer, but for user accounts.
    Write-Host "Retrieving domain users list..." -ForegroundColor DarkYellow
    $DOMAIN_USERS = Get-NetUser -FullData | 
                    Select-Object SamAccountName, Description, @{N='LastLogon'; E={[datetime]::FromFileTime($_.LastLogon)}} | 
                    Format-Table -AutoSize | 
                    Out-String

    # 4. Retrieve members of the 'Domain Admins' group.
    # This is a critical group for privilege escalation paths.
    # Get-NetGroupMember: Fetches members of a specified Active Directory group.
    try {
        Write-Host "Retrieving 'Domain Admins' group members..." -ForegroundColor DarkYellow
        $DOMAIN_GROUP_MEMBERS = Get-NetGroupMember -GroupName "Domain Admins" | 
                                Select-Object SamAccountName | 
                                Format-Table -AutoSize | 
                                Out-String
    }
    catch {
        # Handle cases where 'Domain Admins' group might not exist (unlikely) or permissions are insufficient.
        Write-Warning "Failed to retrieve 'Domain Admins' group members. The group might not exist or you may not have sufficient permissions."
        $DOMAIN_GROUP_MEMBERS = "Unavailable." # Set a default value if retrieval fails.
    }

    # Construct the final reconnaissance report using a here-string for multi-line output.
    # The '---' here are part of the report's visual formatting and are not PowerShell syntax errors.
    $report = @"
==== Active Directory Domain Report ====

--- DOMAIN INFORMATION ---
$($DOMAIN_INFO.Trim())

--- DOMAIN COMPUTERS ---
$($DOMAIN_COMPUTERS.Trim())

--- DOMAIN USERS ---
$($DOMAIN_USERS.Trim())

--- 'DOMAIN ADMINS' GROUP MEMBERS ---
$($DOMAIN_GROUP_MEMBERS.Trim())

========================================
"@

    # Output the entire report to the console.
    Write-Host "`n$report" -ForegroundColor White

    # Optional: Uncomment the following lines to save the report to a file.
    # $report | Out-File -FilePath ".\AD_Recon_Report.txt" -Encoding UTF8
    # Write-Host "`nReport saved to AD_Recon_Report.txt" -ForegroundColor Green

} else {
    # If PowerView module failed to import, inform the user that AD enumeration is not possible.
    Write-Host "`nCouldn't import PowerView module. No further Active Directory enumeration is possible." -ForegroundColor Red
}
#endregion
