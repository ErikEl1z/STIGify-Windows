# STIG Overview  
A Practical Walkthrough of Windows Hardening the STIG Way

This document provides an overview of the DoD Security Technical Implementation Guide (STIG) requirements relevant to Windows system hardening. It explains what STIGs are, why they matter for federal cybersecurity roles, and how this project applies STIG‑aligned controls to a Windows virtual machine.

---

##  What Are STIGs?

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

##  Why STIGs Matter

STIG compliance demonstrates the ability to:
- Interpret formal security requirements  
- Apply secure configurations consistently  
- Validate system posture  
- Produce evidence of compliance  
- Harden systems against common attack vectors  

For government cybersecurity roles, STIG familiarity is a **direct job skill**.

This project showcases practical, hands‑on experience applying STIG‑aligned controls to a Windows VM.

---

##  Hardening Categories Applied in This Lab

This project focuses on the most impactful Windows STIG categories:

### **1. Account Policies**
- Password complexity  
- Minimum password length  
- Maximum password age  
- Lockout threshold  
- Lockout duration  

### **2. Audit Policies**
- Logon events  
- Privilege use  
- Object access  
- Policy changes  
- System events  
- Account management  

### **3. User Rights Assignment**
- Who can log on locally  
- Who can log on via RDP  
- Who can shut down the system  
- Who can change system time  
- Who can debug programs  

### **4. Security Options**
- UAC configuration  
- SMB signing  
- LAN Manager authentication level  
- Anonymous access restrictions  
- Driver loading restrictions  

### **5. Registry Hardening**
- LSA protection  
- Credential storage restrictions  
- Remote access hardening  
- Logging configuration  

### **6. Logging & Monitoring**
- Sysmon deployment  
- Event Viewer validation  
- Enhanced telemetry for process, network, registry, and file events  

---

##  How Hardening Was Applied

Hardening was applied through:

### **Group Policy (GPO)**
Used to configure:
- Account policies  
- Audit policies  
- User rights assignment  
- Security options  

Screenshots of applied GPO settings are available in `/screenshots/gpo`.

---

### **Sysmon Deployment**
Sysmon provides:
- Process creation telemetry  
- Network connection logs  
- Registry modification logs  
- File write logs  

Screenshots of Sysmon logs are available in `/screenshots/sysmon`.

---

### **Audit Policy Enforcement**
Audit policies were configured to ensure detailed logging of:
- Authentication  
- Privilege use  
- Object access  
- Policy changes  

Screenshots of audit logs are available in `/screenshots/audit`.

---

### **PowerShell Validation**
PowerShell was used to confirm:
- Audit policy configuration  
- Registry hardening  
- Sysmon installation  
- GPO enforcement  

Validation commands and outputs are available in `/validation`.

---

##  Validation Approach

Validation includes:
- Event Viewer screenshots  
- Sysmon Operational log entries  
- Audit policy output (`auditpol /get /category:*`)  
- Registry checks (`Get-ItemProperty`)  
- KQL queries confirming ingestion (optional pairing with SeemSIEM)  

These artifacts demonstrate that hardening controls were applied and are actively enforced.

---

## 📝 Notes

- This project is a practical hardening lab inspired by STIG guidance.  
- It is not an official DISA STIG implementation.  
- Controls were selected based on relevance, impact, and reproducibility.  
- All screenshots and validation outputs were captured from the hardened VM.  

---

##  Purpose of This Document

This overview provides the context behind the hardening work performed in WinSTIG.  
It explains the STIG categories applied, the methods used, and the validation steps taken to demonstrate compliance.

Together with the README, scripts, screenshots, and validation artifacts, this document helps present a complete, professional, gov‑sec‑aligned hardening project.

