# KQL Validation Pipeline
## Overview
These KQL queries validate that WinSTIG hardening is functioning correctly across the Windows VM → Sysmon → Windows Event Logs → Log Analytics pipeline.
Each query confirms a STIG‑aligned control, ensuring that logging, auditing, and registry protections are active and producing telemetry.

---

## 1. Log Ingestion Verification

Windows VM
↓
SecurityEvent + Sysmon + Event Tables
↓
Log Analytics Workspace
```kql
union SecurityEvent, Sysmon, Event
| summarize count() by Type = $table
```
### Purpose: Ensures all major log sources are active. STIG auditing depends on these tables being populated.

---

## 2. Sysmon Operational Validation

Sysmon
↓
Process, Network, and Registry Telemetry
↓
Sentinel Analytics
### Process Creation (EventID 1)
```kql
Sysmon
| where EventID == 1
| project TimeGenerated, Computer, Process, CommandLine, ParentProcess
| order by TimeGenerated desc
```
### Network Connections (EventID 3)
```kql
Sysmon
| where EventID == 3
| project TimeGenerated, Computer, SourceIp, DestinationIp, DestinationPort, Image
| order by TimeGenerated desc
```
### Registry Modifications (EventID 13)
```kql
Sysmon
| where EventID == 13
| project TimeGenerated, TargetObject, Details, Image
| order by TimeGenerated desc
```
### Purpose: Confirms Sysmon is installed, configured, and generating STIG‑relevant telemetry.

---

## 3. Windows Security Event Validation
Windows Security Log
↓
Authentication + Privilege Use + Group Changes
↓
SecurityEvent Table

## Logon Events (4624, 4625)
```kql
SecurityEvent
| where EventID in (4624, 4625)
| project TimeGenerated, EventID, Account, Computer, LogonType
| order by TimeGenerated desc
```
## Privilege Escalation (4672, 4688)
```kql
SecurityEvent
| where EventID in (4672, 4688)
| project TimeGenerated, EventID, Account, Process, CommandLine
| order by TimeGenerated desc
```
## Group Membership Changes (4728, 4729, 4732, 4733)
```kql
SecurityEvent
| where EventID in (4728, 4729, 4732, 4733)
| project TimeGenerated, EventID, Account, TargetAccount, Computer
| order by TimeGenerated desc
```
### Purpose: Validates STIG‑required auditing of authentication, privilege use, and group membership changes.

## 4. Audit Policy Enforcement
Audit Policy Engine
↓
Policy Changes + Log Clearing + Sensitive Privileges
↓
SecurityEvent Table

## Audit Policy Changes (4719)
```kql
SecurityEvent
| where EventID == 4719
| project TimeGenerated, Account, PolicyChanges
```
## Log Clearing Events (1102)
```kql
SecurityEvent
| where EventID == 1102
| project TimeGenerated, Account, Computer
```
## Sensitive Privilege Use (4673, 4674)
```kql
SecurityEvent
| where EventID in (4673, 4674)
| project TimeGenerated, Account, PrivilegeList
```
### Purpose: Confirms STIG‑required audit categories are active and producing events.

## 5. Registry Hardening Validation
Registry Engine
↓
LSA Protection + SMB Signing + Audit Keys
↓
Sysmon Registry Events

## Registry Modifications (EventID 13)
```kql
Sysmon
| where EventID == 13
| where TargetObject has_any ("LSA", "Audit", "Security", "Policies")
| project TimeGenerated, TargetObject, Details, Image
| order by TimeGenerated desc
```
## LSA Protection (RunAsPPL)
```kql
Sysmon
| where EventID == 13
| where TargetObject endswith "RunAsPPL"
| project TimeGenerated, TargetObject, Details
```
## SMB Signing Changes
```kql
Sysmon
| where EventID == 13
| where TargetObject has "SMB"
| project TimeGenerated, TargetObject, Details
```
### Purpose: Confirms registry‑based STIG controls such as LSA protection and SMB signing.



