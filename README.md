# STIGify-Windows
A hands‑on Windows hardening lab built around DoD STIG guidance. This project walks through tightening a Windows system the STIG way — GPO changes, audit policy tuning, Sysmon enforcement, PowerShell checks, and before/after security validation

# WinSTIG  
A Windows Hardening Lab (STIG‑ified Edition)

WinSTIG is my hands‑on Windows hardening project where I take a vanilla Windows VM and STIG‑ify it. This lab walks through applying DoD STIG‑aligned controls, tightening audit policies, enforcing secure configurations through GPO, validating changes with Sysmon and Event Viewer, and using PowerShell to verify compliance.

This project is designed to showcase practical system‑hardening skills relevant to DoD, Air Force, and federal SOC environments.

---

##  Objectives

- Apply Windows hardening controls aligned with DoD STIG guidance  
- Configure GPO‑based security settings  
- Enable and tune Windows audit policies  
- Deploy Sysmon for enhanced telemetry  
- Validate hardening through Event Viewer + Sysmon logs  
- Use PowerShell to audit and confirm applied controls  
- Document before/after security posture  
- Provide screenshots and scripts demonstrating enforcement  

---

##  Hardening Overview

Baseline Windows VM  
↓  
STIG‑aligned GPO changes  
↓  
Audit Policy lockdown  
↓  
Sysmon deployment  
↓  
PowerShell validation  
↓  
Event Viewer + Sysmon confirmation  

### **Flow Explanation**
- **GPO Hardening** applies STIG‑aligned settings for account policies, audit policies, user rights, and security options  
- **Audit Policy** ensures detailed logging of authentication, privilege use, object access, and policy changes  
- **Sysmon** provides deep telemetry for process creation, network connections, registry changes, and file modifications  
- **PowerShell Validation** confirms applied controls and checks registry/policy states  
- **Event Viewer** shows enforcement of hardening controls  
- **Screenshots** document each stage of the process  

A full screenshot index is available in `/screenshots`.

---

## 📁 Repository Structure

/docs
/STIG-overview.md

/scripts
/hardening.ps1

/screenshots
/gpo
/audit
/sysmon

/validation
/kql


---

## 🔨 Hardening Components

### **1. GPO Hardening**
Includes:
- Account policies  
- Password complexity  
- Lockout thresholds  
- Audit policy configuration  
- User rights assignment  
- Security options  

### **2. Audit Policy Enforcement**
Configured to log:
- Logon events  
- Privilege use  
- Object access  
- Policy changes  
- System events  

### **3. Sysmon Telemetry**
Provides:
- Process creation (Event ID 1)  
- Network connections (Event ID 3)  
- Registry modifications  
- File writes  
- Driver loads  

### **4. PowerShell Validation**
Used to confirm:
- GPO settings  
- Registry keys  
- Audit policy configuration  
- Sysmon installation  
- STIG‑aligned controls  

---

##  Validation Examples

### **Audit Policy Check**
```powershell
auditpol /get /category:*
```
### **Sysmon Operational Log Check**
```powershell
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" | Select -First 20
```
### **Registry Hardening Check**
```powershell
Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
```
More validation examples are available in /validation/kql

##  Notes

This project is not an official STIG implementation

It is a practical hardening lab inspired by STIG controls

All screenshots are taken from a Windows VM hardened during the project

PowerShell scripts are provided for reproducibility
