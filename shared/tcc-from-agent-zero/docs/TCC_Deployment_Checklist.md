# TCC Portfolio Hub — Deployment Checklist
## Date: April 1, 2026 | Target Go-Live: April 29, 2026

---

## ⚠️ Before You Start
- Use **Windows PowerShell (blue window)** — NOT PowerShell 7 black window
- Run from: `C:\TCC_Deploy\deploy_package_v10\` (or wherever v10 was extracted)
- Site: https://metcmn.sharepoint.com/sites/TCCISPortfolioHub

---

## PHASE 1 — SharePoint Wiring (Run First)
> Idempotent — safe to run multiple times. Skips columns that already exist.

```powershell
powershell.exe -ExecutionPolicy Bypass
cd C:\TCC_Deploy\deploy_package_v10
.\scripts\SharePoint_Wire.ps1
```

**What it creates:**
| List | New Columns Added Today |
|---|---|
| IS Project Tasks | WBSNumber, PlannedStart (+ all previous columns) |
| IS Project RAID | Probability, Impact, Owner, Status, DateLogged, DueDate (+ all previous) |

**Expected output:** All green ✅ or SKIPPED (already exists) — no red ❌

---

## PHASE 2 — Run Integration Tests
> Validates SharePoint connection + all required columns exist

```powershell
.\scripts\tests\TCC_IntegrationTests.ps1
```

**Target: 5/5 PASS** (browser popup → sign in → auto-continues)

---

## PHASE 3 — Import Power Automate Flows
> In your work browser: https://make.powerautomate.com

### Flow 1 — SP → Planner Sync (main automation)
1. My Flows → Import → Import Package (Legacy)
2. Upload: `flows\TCC_Flow2_SP_to_Planner_GraphAPI_v3.zip`
3. Configure connections:
   - SharePoint → select your existing SharePoint connection
4. Import → Turn ON

### Flow 2 — WBS Bulk Import (run once to load 781 tasks)
1. Import → `flows\TCC_WBS_Upsert_Flow_v3.zip`
2. Configure: SharePoint + Excel Online connections
3. Import → **DO NOT turn on** (manual trigger only)
4. **Prereq:** Upload `TCC_WBS_Master.xlsx` to SharePoint at:
   `/_Portfolio Hub/WBS & Schedule/TCC_WBS_Master.xlsx`
   - Table in file must be named: `WBSImport`
   - Required columns: Task Name, Project, Phase, Task Type, WBS Number, Planned Start, Planned End, Pct Complete, RAG Status, Notes, ServiceWorks Ticket ID

### Flow 3 — RAID Bulk Import
1. Import → `flows\TCC_RAID_Upsert_Flow_v3.zip`
2. Configure: SharePoint + Excel Online connections
3. Import → **DO NOT turn on** (manual trigger only)
4. **Prereq:** Upload `TCC_RAID_Log_Master.xlsx` to SharePoint at:
   `/_Portfolio Hub/RAID Log/TCC_RAID_Log_Master.xlsx`
   - Table must be named: `RAIDImport`
   - Required columns: RAID Title, Project, RAID Type, Description, Probability, Impact, Mitigation, Owner, Due Date, Status, RAG Status, Date Logged, SteerCo Tag

---

## PHASE 4 — Run WBS Import (781 Tasks)
> Only after WBS Master Excel is uploaded to SharePoint

1. Power Automate → My Flows → TCC WBS Upsert
2. Click **Run** → Confirm
3. Monitor run history — expect ~5-10 minutes for 781 rows
4. Verify in SharePoint: IS Project Tasks list should show 781 items

---

## PHASE 5 — Enable SP→Planner Sync
> Only after tasks are in SharePoint

1. Power Automate → My Flows → TCC Flow 2 — SharePoint to Planner
2. Turn ON
3. In SharePoint IS Project Tasks: set `Is Active = Yes` on 1 test task
4. Wait up to 5 minutes → check Planner → task should appear

---

## PHASE 6 — PowerApp (If Ready)
> Only if pac CLI is available and PowerApp YAML is ready

```powershell
.\powerapps-src\pack.bat
```
Then import `.msapp` file at: https://make.powerapps.com → Apps → Import canvas app

---

## Known Issues / Watch List
| # | Issue | Status |
|---|---|---|
| 1 | PnP.PowerShell must be v2.12.0 | Confirmed working |
| 2 | Use Windows PowerShell (PS5.1) for PnP scripts | Confirmed working |
| 3 | SP→Planner flow uses MSI auth — needs Power Automate premium connector or HTTP | Monitor on import |
| 4 | WBS Excel table must be named exactly `WBSImport` | Pre-req |
| 5 | RAID Excel table must be named exactly `RAIDImport` | Pre-req |

---

## Quick Reference
| Resource | Location |
|---|---|
| SharePoint Site | https://metcmn.sharepoint.com/sites/TCCISPortfolioHub |
| Power Automate | https://make.powerautomate.com |
| PowerApps | https://make.powerapps.com |
| Go-Live Date | April 29, 2026 |
| Days Remaining | 29 days |
