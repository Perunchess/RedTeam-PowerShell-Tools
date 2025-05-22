PowerShell

function Check-PowerViewModule {
    param (
        [string]$ModulePath
    )

    if (Test-Path -Path $ModulePath -PathType Leaf) {
        Write-Host "Module was found: '$ModulePath'." -ForegroundColor Green
    }
    else {
        Write-Host "Module wasn't found at the path: '$ModulePath'." -ForegroundColor Yellow
        Write-Host "Attempting to download PowerView.ps1 from GitHub..." -ForegroundColor Cyan

        try {
            $DownloadURL = "https://raw.githubusercontent.com/PowerShellMafia/PowerSploit/master/Recon/PowerView.ps1"
            (New-Object System.Net.WebClient).DownloadFile($DownloadURL, $ModulePath)
            Write-Host "PowerView.ps1 successfully downloaded to '$ModulePath'." -ForegroundColor Green
        }Ы
        catch {
            Write-Host "An error occurred while trying to download PowerView.ps1: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }

    try {
        Import-Module $ModulePath -Force
        Write-Host "PowerView module imported successfully." -ForegroundColor Green
        return $true
    }
    catch {
        Write-Host "Cannot import PowerView: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

---

$powerViewLocalPath = Join-Path $PSScriptRoot "PowerView.ps1" 

if (Check-PowerViewModule -ModulePath $powerViewLocalPath) {

    Write-Host "`nStarting Active Directory information gathering..." -ForegroundColor Blue

    Write-Host "Retrieving domain information..." -ForegroundColor DarkYellow
    $DOMAIN_INFO = Get-NetDomain | Out-String 

    Write-Host "Retrieving domain computers list..." -ForegroundColor DarkYellow
    $DOMAIN_COMPUTERS = Get-NetComputer -FullData | Select-Object Name, OperatingSystem, @{N='LastLogon'; E={[datetime]::FromFileTime($_.LastLogon)}} | Format-Table -AutoSize | Out-String

    Write-Host "Retrieving domain users list..." -ForegroundColor DarkYellow
    $DOMAIN_USERS = Get-NetUser -FullData | Select-Object SamAccountName, Description, @{N='LastLogon'; E={[datetime]::FromFileTime($_.LastLogon)}} | Format-Table -AutoSize | Out-String

    Write-Host "Retrieving 'Domain Admins' group members..." -ForegroundColor DarkYellow
    try {
        $DOMAIN_GROUP_MEMBERS = Get-NetGroupMember -GroupName "Domain Admins" | Select-Object SamAccountName | Format-Table -AutoSize | Out-String
    }
    catch {
        Write-Warning "Failed to retrieve 'Domain Admins' group members. The group might not exist or you may not have sufficient permissions."
        $DOMAIN_GROUP_MEMBERS = "Unavailable."
    }

    $report = @"
==== Active Directory Domain Report ====

--- DOMAIN INFORMATION ---
$DOMAIN_INFO

--- DOMAIN COMPUTERS ---
$DOMAIN_COMPUTERS

--- DOMAIN USERS ---
$DOMAIN_USERS

--- 'DOMAIN ADMINS' GROUP MEMBERS ---
$DOMAIN_GROUP_MEMBERS

========================================
"@

    Write-Host "`n$report" -ForegroundColor White

    # Optional: save report to file
    # $report | Out-File -FilePath ".\AD_Recon_Report.txt" -Encoding UTF8
    # Write-Host "`nReport saved to AD_Recon_Report.txt" -ForegroundColor Green

} else {
    Write-Host "`nCouldn't import module. No further AD enumeration is possible." -ForegroundColor Red
}