<#
.SYNOPSIS
    WinSTIG Hardening Script (Lab Edition)

.DESCRIPTION
    Applies a set of Windows hardening controls inspired by DoD STIG guidance.
    Focus areas:
        - Password and account policies
        - Audit policy configuration
        - Basic security options
        - Sysmon installation check (optional)
        - Validation output

    NOTE: This is a lab script, not an official DISA STIG implementation.
#>

Write-Host "=== WinSTIG Hardening Script Starting ===" -ForegroundColor Cyan

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "[!] This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# -----------------------------
# SECTION 1: Password & Account Policies
# -----------------------------

Write-Host "`n[+] Configuring password and account policies..." -ForegroundColor Yellow

# Minimum password length: 14
secedit /export /cfg "$env:TEMP\secpol.cfg" | Out-Null
$secpol = Get-Content "$env:TEMP\secpol.cfg"

$secpol = $secpol -replace 'MinimumPasswordLength = \d+', 'MinimumPasswordLength = 14'
$secpol = $secpol -replace 'PasswordComplexity = \d+', 'PasswordComplexity = 1'
$secpol = $secpol -replace 'MaximumPasswordAge = \d+', 'MaximumPasswordAge = 60'
$secpol = $secpol -replace 'LockoutBadCount = \d+', 'LockoutBadCount = 5'
$secpol = $secpol -replace 'ResetLockoutCount = \d+', 'ResetLockoutCount = 15'
$secpol = $secpol -replace 'LockoutDuration = \d+', 'LockoutDuration = 15'

$secpol | Set-Content "$env:TEMP\secpol.cfg"
secedit /configure /db secedit.sdb /cfg "$env:TEMP\secpol.cfg" /areas SECURITYPOLICY | Out-Null

Write-Host "[+] Password and account policies updated." -ForegroundColor Green

# -----------------------------
# SECTION 2: Audit Policy Configuration
# -----------------------------

Write-Host "`n[+] Configuring audit policies..." -ForegroundColor Yellow

# Enable detailed auditing for key categories
auditpol /set /category:"Logon/Logoff" /success:enable /failure:enable | Out-Null
auditpol /set /category:"Account Logon" /success:enable /failure:enable | Out-Null
auditpol /set /category:"Account Management" /success:enable /failure:enable | Out-Null
auditpol /set /category:"Policy Change" /success:enable /failure:enable | Out-Null
auditpol /set /category:"Privilege Use" /success:disable /failure:enable | Out-Null
auditpol /set /category:"System" /success:enable /failure:enable | Out-Null
auditpol /set /category:"Object Access" /success:enable /failure:enable | Out-Null

Write-Host "[+] Audit policies configured." -ForegroundColor Green

# -----------------------------
# SECTION 3: Basic Security Options (Registry-Based)
# -----------------------------

Write-Host "`n[+] Applying basic security options..." -ForegroundColor Yellow

# LSA protection: Restrict anonymous enumeration
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymous" -Value 1 -PropertyType DWord -Force | Out-Null
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "RestrictAnonymousSAM" -Value 1 -PropertyType DWord -Force | Out-Null

# LAN Manager authentication level: Send NTLMv2 response only
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "LmCompatibilityLevel" -Value 5 -PropertyType DWord -Force | Out-Null

# Disable storage of LM hash
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" -Name "NoLMHash" -Value 1 -PropertyType DWord -Force | Out-Null

Write-Host "[+] Security options applied." -ForegroundColor Green

# -----------------------------
# SECTION 4: Sysmon Presence Check (Optional)
# -----------------------------

Write-Host "`n[+] Checking for Sysmon installation..." -ForegroundColor Yellow

$sysmonService = Get-Service -Name "Sysmon" -ErrorAction SilentlyContinue

if ($sysmonService) {
    Write-Host "[+] Sysmon service detected: $($sysmonService.Status)" -ForegroundColor Green
} else {
    Write-Host "[!] Sysmon service not found. Install Sysmon separately for full telemetry." -ForegroundColor Red
    Write-Host "    Suggested: sysmon64.exe -i sysmonconfig.xml" -ForegroundColor DarkYellow
}

# -----------------------------
# SECTION 5: Validation Output
# -----------------------------

Write-Host "`n[+] Collecting validation output..." -ForegroundColor Yellow

Write-Host "`n--- Audit Policy ---" -ForegroundColor Cyan
auditpol /get /category:* | Out-Host

Write-Host "`n--- LSA Registry Settings ---" -ForegroundColor Cyan
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa" | `
    Select-Object RestrictAnonymous, RestrictAnonymousSAM, LmCompatibilityLevel, NoLMHash | Format-List

Write-Host "`n--- Sysmon Log Check (if installed) ---" -ForegroundColor Cyan
try {
    Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" -MaxEvents 10 | `
        Select-Object TimeCreated, Id, ProviderName, Message | Format-Table -AutoSize
} catch {
    Write-Host "[!] Sysmon Operational log not available." -ForegroundColor DarkYellow
}

Write-Host "`n=== WinSTIG Hardening Script Completed ===" -ForegroundColor Cyan

