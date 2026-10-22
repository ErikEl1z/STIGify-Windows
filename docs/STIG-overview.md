# STIGify‑Windows: STIG Overview  
A Practical Walkthrough of Windows Hardening the STIG Way

This document provides an overview of the DoD Security Technical Implementation Guide (STIG) requirements relevant to Windows system hardening. It explains what STIGs are, why they matter for federal cybersecurity roles, and how this project applies STIG‑aligned controls to a Windows Server virtual machine.

---

## What Are STIGs?

Security Technical Implementation Guides (STIGs) are configuration standards published by the Defense Information Systems Agency (DISA). They define how systems must be secured to meet DoD cybersecurity requirements.

STIGs cover:

- Operating systems  
- Applications  
- Network devices  
- Cloud services  
- Databases  
- Security tools  

For Windows systems, STIGs provide detailed guidance on:

- Account policies  
- Audit policies  
- User rights assignment  
- Security options  
- Registry configurations  
- Logging and monitoring  
- Service hardening  

STIGs are the baseline for securing systems in DoD, Air Force, Army, Navy, and federal SOC environments.

---

## Why STIGs Matter

STIG compliance demonstrates the ability to:

- Interpret formal security requirements  
- Apply secure configurations consistently  
- Validate system posture  
- Produce evidence of compliance  
- Harden systems against common attack vectors  

For government cybersecurity roles, STIG familiarity is a direct job skill.

This project showcases practical, hands‑on experience applying STIG‑aligned controls to a Windows Server VM and validating telemetry in Microsoft Sentinel.

---

## Hardening Categories Applied in This Lab

This project focuses on the most impactful Windows STIG categories:

### 1. Account Policies
- Password complexity  
- Minimum password length  
- Maximum password age  
- Lockout threshold  
- Lockout duration  

### 2. Audit Policies
- Logon events  
- Privilege use  
- Object access  
- Policy changes  
- System events  
- Account management  

### 3. User Rights Assignment
- Local logon permissions  
- Remote logon permissions (RDP)  
- Shutdown permissions  
- System time modification  
- Debug program rights  

### 4. Security Options
- UAC configuration  
- SMB signing  
- LAN Manager authentication level  
- Anonymous access restrictions  
- Driver loading restrictions  

### 5. Registry Hardening
- LSA protection  
- Credential storage restrictions  
- Anonymous access restrictions  
- Logging configuration  

### 6. Logging & Monitoring
- Sysmon deployment  
- Event Viewer validation  
- Enhanced telemetry for process, network, registry, and file events  

---

## How Hardening Was Applied

### Group Policy (GPO)
Used to configure:

- Account policies  
- Audit policies  
- User rights assignment  
- Security options  

**Screenshots:**  
Located in `/screenshots/gpo`

---

### Sysmon Deployment

Sysmon provides:

- Process creation telemetry  
- Network connection logs  
- Registry modification logs  
- File write logs  

**Screenshots:**  
Located in `/screenshots/sysmon`

---

### Audit Policy Enforcement

Audit policies were configured to ensure detailed logging of:

- Authentication  
- Privilege use  
- Object access  
- Policy changes  

**Screenshots:**  
Located in `/screenshots/audit`

---

### Registry Hardening

Registry keys under:
## HKLM\SYSTEM\CurrentControlSet\Control\Lsa


were validated to ensure:

- Anonymous restrictions  
- LM hash removal  
- LAN Manager authentication level  
- LSA hardening  

**Screenshots:**  
Located in `/screenshots/lsa-registry`

---

### Firewall Hardening

Firewall profiles were validated using:

Get-NetFirewallProfile


**Screenshots:**  
Located in `/screenshots/firewall`

---

### PowerShell Validation

PowerShell was used to confirm:

- Audit policy configuration  
- Registry hardening  
- Sysmon installation  
- GPO enforcement  

**Commands used:**
auditpol /get /category:*
Get-Service Sysmon64
Get-ItemProperty HKLM:\SYSTEM\CurrentControlSet\Control\Lsa
Get-NetFirewallProfile


---

## Telemetry Validation (Microsoft Sentinel)

Telemetry was validated using KQL queries in Microsoft Sentinel:

### Sysmon Logs
```kql
Event
| where EventLog == "Microsoft-Windows-Sysmon/Operational"
| order by TimeGenerated desc
| take 20
```

### Security Logs
```kql
SecurityEvent
| take 20
```

### Event Log Summary
```kql
Event
| summarize count() by EventLog
```

### AMA Heartbeat
```kql
Heartbeat
| take 10
```
Screenshots:  
Located in /screenshots/kql-*

## Notes
This project is a practical hardening lab inspired by STIG guidance.

It is not an official DISA STIG implementation.

Controls were selected based on relevance, impact, and reproducibility.

All screenshots and validation outputs were captured from the hardened VM.
