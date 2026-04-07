# TCC IS Portfolio Hub — Session Handoff
**Date:** March 27, 2026  
**From:** Claude.ai Portfolio Hub chat  
**To:** Claude Desktop (personal PC)  
**Purpose:** Continue Power BI report build — do NOT attempt to publish, Pro license pending

---

## STOP — READ BEFORE DOING ANYTHING

**Power BI Pro license ticket has been submitted to helpdesk. Expected next week.**
**Do NOT try to publish to Power BI service. It will fail — Free account only.**
**The .pbix file is saved locally. Build the report now, publish when Pro arrives.**

---

## WHERE WE ARE RIGHT NOW

### Power BI Desktop — current state
- File saved at: `C:\PT\Claude TCC Setup\TCC_IS_Portfolio_Dashboard.pbix`
- Data source 1: `TCC_RAID_Log_SharePoint_Import_20260326.xlsx` → sheet: `SharePoint Import` (33 rows, headers promoted)
- Data source 2: **NOT YET ADDED** — next step is to add WBS Excel file
- Three visuals built on Page 1:
  - Donut chart: Count of RAID Title by RAG
  - Stacked bar chart: Count of RAID Title by Project and RAG
  - Table: RAID Title, Project, RAID Type, RAG, Status, Owner

### What needs to happen next (in order)
1. Add WBS Excel as second data source
2. Fix column headers on WBS data (same Power Query → Use First Row as Headers step)
3. Build milestone timeline visual from WBS milestone rows
4. Clean up layout and colors (RAG colors are wrong — Red showing as blue, etc.)
5. Save .pbix
6. Publish when Pro license arrives next week

---

## ENVIRONMENT

### Personal PC
- Power BI Desktop: Version 2.152.1057.0 (March 2026) — fully current
- All project files in: `C:\PT\Claude TCC Setup\`
- Key files:
  - `TCC_IS_Portfolio_Dashboard.pbix` — Power BI report (current working file)
  - `TCC_RAID_Log_SharePoint_Import_20260326.xlsx` — 33 RAID items, import-ready
  - `TCC_WBS_Reconciled_20260327.xlsx` — 921 WBS tasks, import-ready
  - `IS_Master_Architecture_Internal_v3.md` — master reference doc (upload to Claude Desktop projects)
  - `IS_Infra_PM_Meeting_Prep_v2.html` — Paul Burke meeting prep

### Work PC
- SharePoint site live: `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub`
- Site Assets has three portal files uploaded: `tcc-status-cards.aspx`, `tcc-gantt.aspx`, `tcc-nav.aspx`
- Portal files blocked by custom scripts restriction — admin ticket submitted
- SharePoint Lists on hub site: only `IS Project RAID` created so far (empty — no data imported yet)
- Remaining four Lists not yet created: `IS Project Tasks`, `IS Milestones`, `IS Status Summary`, `Construction Gates`

---

## SHAREPOINT HUB SITE STATUS

**Site:** `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub`  
**Created:** March 27, 2026 via Teams → TCC IS Portfolio Hub team  
**Lists status:**

| List | Created | Data imported |
|------|---------|---------------|
| IS Project RAID | ✅ Yes | ❌ No |
| IS Project Tasks | ❌ No | ❌ No |
| IS Milestones | ❌ No | ❌ No |
| IS Status Summary | ❌ No | ❌ No |
| Construction Gates | ❌ No | ❌ No |

**Import blocker:** SharePoint tenant does not have "Import from Excel" feature enabled. Plan: use Power Automate to bulk-load data once Lists are created. This is Phase 3 work.

**Portal blocker:** Custom scripts disabled on tenant. Admin ticket submitted. Once approved, three `.aspx` files already in Site Assets deploy in ~10 minutes.

---

## PENDING TICKETS / ACTIONS

| Item | Status | Expected |
|------|--------|----------|
| Power BI Pro license | Ticket submitted to helpdesk | Next week |
| Custom scripts enable on TCCISPortfolioHub | Ticket submitted | Unknown — security team is restrictive |
| Paul Burke meeting (IS Infrastructure PM) | Rescheduled to Monday Mar 30 | Monday AM |

---

## PAUL BURKE MEETING — MONDAY MARCH 30

**Meeting prep doc:** `IS_Infra_PM_Meeting_Prep_v2.html` — open in browser, use as running guide

**Four things to walk out with:**
1. Power draw for IS network gear (2 switches + firewall) — contractor needs this
2. UPS decision — IS-only or shared with IES? IES firewall load needed too
3. Named IS Network resource for Room 1007 — who does the work, who owns the ticket, who to check for updates
4. Change request lead time — how many business days, who approves

**Delivery model to set early:**
> "For each work package I want to hand you an objective and get back four things: end-to-end cycle time, who's doing the work, who I assign the ticket to, and who I check for updates. Everything else stays with your team."

---

## THREE IS PROJECTS — CURRENT STATUS

### TCC Expansion (EXP) — IS Lead
- Phase: EBC Buildout (Room 1007 temp space)
- Working target: M-05 EBC Operational Apr 30 (aspirational — formal review Apr 22 SteerCo)
- 3 eval PCs ordered Mar 27 (IS-to-IS service request submitted)
- Critical path: power specs for Room 1007 → UPS/switch/firewall order → change request → install
- Construction NTP expected mid-late April (Rimstad, SteerCo Mar 25)
- IS PM planning assumption: operators in St. Paul Sep + Oct 2026 (2 months)

### NG911 Refresh — IS Coordination
- Phase: Pre-RFP requirements definition
- FE (Federal Engineering) leads — Tommy Thompson PM
- IS goal: cloud-hosted managed solution, zero IS 24/7 obligation
- Josh Alswager IS primary rep
- Steven Kensinger (Regional Administration Procurement) leads formal RFP process
- Lisa Belland (Business Continuity) and John Stefanko (IS Architecture) involved in requirements workshops
- Next step: schedule deep-dive RFP workshop with FE

### VuWall (VUW) — IS Coordination
- Phase: Post-PO design and BCA
- PO issued Mar 26 — non-refundable
- BCA submission now targeting June 2026 (IS Network unavailable Apr-May)
- BCA approval expected ~Aug 2026
- IS PMO ticket #11138 — Sreeni Nutulapati (Stefanko's team) gave initial thumbs-up
- Prior solution: Userful (introduced by Bluum, shut down for network security concerns)
- Bluum contract: last-minute extension Dec 15 2025, expected renewal didn't materialize
- Parallel procurement paths: Bluum renewal, SHI on state contract, cooperative purchasing

---

## LONG-TERM ARCHITECTURE GOAL

Single point of data entry: updates in TCC IS Portfolio Hub SharePoint Lists automatically populate MayAnn Severud's IS PMO MS Teams Lists via Power Automate. Schema alignment already planned. Power Automate sync flows are Phase 3 work — after Lists have real data.

The IS PMO Leadership Action Board (existing Power BI) = org-wide executive view.
TCC IS Portfolio Hub (what we're building) = TCC operational granularity for Carri Sampson.
These are complementary, not competing.

---

## IMMEDIATE NEXT STEP FOR THIS SESSION

**Add WBS Excel as second data source in Power BI Desktop:**

1. Click **Get data** in top ribbon
2. Click **Excel workbook**
3. Navigate to `C:\PT\Claude TCC Setup`
4. Select `TCC_WBS_Reconciled_20260327.xlsx`
5. Click **Open**
6. In Navigator — look for **WBS Master** sheet
7. Click **Transform Data** (not Load)
8. In Power Query: click **Transform** tab → **Use First Row as Headers**
9. Click **Home** → **Close & Apply**
10. Build milestone timeline visual using Task Type = "Milestone" rows
