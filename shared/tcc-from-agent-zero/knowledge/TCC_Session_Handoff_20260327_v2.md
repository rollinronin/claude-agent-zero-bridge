# TCC IS Portfolio Hub — Session Handoff
**Date:** March 27, 2026
**Session:** Claude.ai Portfolio Hub — full-day build session
**Next session:** Monday March 30, 2026 — before or after Paul Burke meeting
**Prepared by:** Claude.ai Portfolio Hub

---

## IS PMO PROJECT NUMBERS — CANONICAL REFERENCE

| Project | IS PMO # | Tag | IS Role |
|---------|----------|-----|---------|
| TCC Expansion | **#222** | EXP | IS Lead |
| Solacom NG911 Refresh | **#193** | NG911 | IS Coordination |
| VuWall Video Wall / KVM | **#11138** | VUW | IS Coordination — #11138 is also the original IS Triage review ticket (Sreeni Nutulapati) |

---

## ⚠️ MONDAY PRIORITIES — READ FIRST

**9:00 AM — Paul Burke meeting (IS Infrastructure PM)**
Use `IS_Infra_PM_Meeting_Prep_v2.html` as your running guide. Open in browser.

**Four things to walk out with:**
1. Power draw for IS network gear (2 switches + firewall) — contractor is waiting
2. UPS decision — IS-only or shared with IES? IES firewall load needed too
3. Named IS Network resource for Room 1007 — cycle time, ticket owner, update contact
4. Change request lead time — how many business days, who approves

**Delivery model to set early in the meeting:**
> "For each work package I want to hand you an objective and get back four things: end-to-end cycle time, who's doing the work, who I assign the ticket to, and who I check for updates. Everything else stays with your team."

---

## WHAT WAS BUILT THIS SESSION

### Architecture Document
- **`IS_Master_Architecture_Internal_v3.md`** — CURRENT MASTER
  - Added: Steven Kensinger (Regional Administration Procurement — NG911 RFP lead)
  - Added: Lisa Belland (Business Continuity Manager — COOP program)
  - Added: John Stefanko (Director IS Architecture / IS Triage team lead)
  - Added: Sreeni Nutulapati (IS Architecture — conducted IS PMO #11138 VuWall triage review)
  - Updated: Tina Folch scope clarified (IS-managed equipment only — NG911 goes through Kensinger)
  - Updated: Bluum full history — Userful predecessor, contract near-cancellation end of 2025, Dec 15 2025 last-minute extension (IS PM on Christmas vacation), expected Mar-Apr 2026 renewal didn't materialize
  - Updated: VuWall project history — IS PMO ticket #11138, Sreni's review, Userful predecessor, procurement governance rationale for deferring BCA engagement until PO confirmed
  - Updated: NG911 strategic goal — full IS 24/7 disengagement (not just Mitel disentanglement)
  - **ACTION: Upload v3 to all four Claude Desktop project spaces to replace v2**

### WBS — `TCC_WBS_Reconciled_20260327.xlsx`
- **921 tasks** (up from 896 original)
- Added: 1.6.4.x — IT change request tracking tasks (CR-T01 through CR-F01)
- Added: 3.5.x — EBC Decommission & Operator Return (6 tasks, Nov 2026)
- Added: 4.2.1.x — Final space network assessment subtasks
- Added: 5.2.3.x — VuWall BCA design proposal tasks (Jun/Jul timeline)
- Section 3 dates extended to Oct 31 (was Sep 1) — 2-month operator displacement assumption
- M-07 corrected to Oct 31, M-08 to Nov 30
- Issues Log: 14 items (items 12-14 added this session)
- SharePoint Import sheet: ready for import to IS Project Tasks list

### RAID Log — `TCC_RAID_Log_SharePoint_Import_20260326.xlsx`
- 33 items, 4 sheets, SharePoint Import sheet ready
- No changes this session — still current

### Meeting Prep — `IS_Infra_PM_Meeting_Prep_v2.html`
- Updated: Meeting date → Monday March 30 (rescheduled from March 27)
- Updated: VuWall BCA timeline → Jun/Jul (IS Network Apr-May unavailable confirmed)
- Added: Delivery model section (objective-setting approach)
- Added: IT change request tracker (CR-T01 through CR-F01)
- Added: Expert review section (gaps, risks, strengths, questions)
- Updated: "tomorrow" → "Monday" throughout

### Project Artifacts — TCC Expansion (all Draft v1.0, IS PMO audit required)
| File | Status |
|------|--------|
| `TCC_EXP_Project_Charter_v1.0.docx` | ✅ Built |
| `TCC_EXP_Scope_Statement_v1.0.docx` | ✅ Built |
| `TCC_EXP_RACI_v1.0.docx` | ✅ Built |
| `TCC_EXP_Stakeholder_Register_v1.0.docx` | ✅ Built |
| `TCC_EXP_Communication_Plan_v1.0.docx` | ✅ Built |
| `TCC_IS_SteerCo_KickOff_Mar25_2026.pptx` | ✅ Built — 8 slides |
| `TCC_IS_PortalHub_HomePage.html` | ✅ Built — SharePoint home page |

**All artifacts need MayAnn Severud (IS PMO Manager) review before official approval.**
**All should be uploaded to SharePoint TCCISPortfolioHub document library.**

### SharePoint Portal Files (already in Site Assets)
- `tcc-status-cards.aspx` — blocked pending custom scripts admin ticket
- `tcc-gantt.aspx` — blocked pending custom scripts admin ticket
- `tcc-nav.aspx` — blocked pending custom scripts admin ticket
- **Admin ticket submitted** — security team may be slow to approve given AI agent concerns

### Power BI Report — `TCC_IS_Portfolio_Dashboard.pbix`
- Location: `C:\PT\Claude TCC Setup\TCC_IS_Portfolio_Dashboard.pbix`
- Data source: `TCC_RAID_Log_SharePoint_Import_20260326.xlsx` → SharePoint Import sheet
- Three visuals built: donut chart (RAG), stacked bar (RAID by project + RAG), RAID table
- **Pro license ticket submitted — publish when approved (expected next week)**
- Next steps: add WBS as second data source, build milestone timeline visual, fix RAG colors

---

## SHAREPOINT HUB SITE STATUS

**Site:** `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub`
**Teams team:** TCC IS Portfolio Hub → Portfolio channel

| List | Created | Data Imported |
|------|---------|---------------|
| IS Project RAID | ✅ | ❌ Empty — import blocker: tenant has no Import from Excel |
| IS Project Tasks | ❌ | ❌ |
| IS Milestones | ❌ | ❌ |
| IS Status Summary | ❌ | ❌ |
| Construction Gates | ❌ | ❌ |

**Import plan:** Use Power Automate (Phase 3) to bulk-load all Lists from Excel files. Import from Excel not available on this tenant.

**Immediate action:** Upload all 7 artifacts + updated meeting prep to SharePoint document library so you can share the link Monday.

---

## PENDING TICKETS / ACTIONS

| Item | Status | Expected |
|------|--------|----------|
| Power BI Pro license | Ticket submitted | Next week |
| Custom scripts on TCCISPortfolioHub | Ticket submitted | Unknown — security team restrictive |
| Paul Burke meeting | Rescheduled → **Monday March 30** | Monday AM |

---

## KEY DECISIONS MADE THIS SESSION

- **EBC operator displacement:** IS PM planning assumption = 2 months (Sep + Oct 2026). Carri's hope = 1 month. Both documented in WBS 3.5.x notes.
- **VuWall BCA timeline:** Jun/Jul submission (IS Network unavailable Apr-May confirmed). Commissioning late Aug at earliest.
- **NG911 strategic goal:** Full IS 24/7 disengagement — cloud-hosted managed service, new vendor owns 100% incident response via letters of agency.
- **VuWall procurement governance:** Deliberate decision to defer deep BCA engagement until PO confirmed (Mar 26). Rationale: Bluum contract fragility meant competitive bid possible — deep vendor engagement pre-contract would compromise bid integrity. Documented in architecture v3.
- **Bluum timeline corrected:** Near-cancellation was end of 2025 (not 2024). Dec 15 2025 extension. Mar-Apr 2026 renewal expected but didn't materialize.
- **IS PM delivery model:** Hand Paul Burke an objective; receive back cycle time, who does the work, ticket owner, update contact. Everything else stays with IS Infrastructure.
- **Hub vs. individual project spaces:** Portfolio Hub = cross-project synthesis, executive artifacts, Monday brief, SharePoint portal. Individual spaces = project depth. Split work accordingly going forward.

---

## THREE IS PROJECTS — CURRENT STATUS

### TCC Expansion (EXP) — IS Lead — RAG: AMBER
- Phase: EBC Buildout (Room 1007 temp space)
- Working target: M-05 EBC Operational Apr 30 (aspirational — formal review Apr 22 SteerCo)
- 3 eval PCs ordered Mar 27 (IS-to-IS service request submitted)
- Critical path: Room 1007 power specs → UPS/switch/firewall order → CR-T01 → install
- Construction NTP: expected mid-late April (Rimstad, SteerCo Mar 25)
- IS PM planning assumption: operators in St. Paul Sep + Oct 2026 (2 months)
- PC deployment cycle time: unknown — get estimate from Paul Burke Monday

### NG911 Refresh — IS Coordination — RAG: AMBER
- Phase: Pre-RFP requirements definition
- FE (Federal Engineering) leads — Tommy Thompson PM
- IS goal: cloud-hosted managed solution, zero IS 24/7 obligation
- Josh Alswager IS primary rep; Steven Kensinger leads formal procurement
- Lisa Belland (COOP) and John Stefanko (IS Architecture) in requirements workshops
- Next step: schedule deep-dive RFP workshop with FE
- Letters of agency: IS Legal review needed before RFP workshop

### VuWall (VUW) — IS Coordination — RAG: RED
- Phase: Post-PO design and BCA
- PO issued Mar 26 — non-refundable
- BCA submission: June 2026 (IS Network confirmed unavailable Apr-May)
- BCA approval expected: ~Aug 2026 (8-10 weeks)
- IS PMO ticket #11138 — Sreeni Nutulapati (Stefanko's team) gave initial thumbs-up
- Prior solution: Userful (introduced by Bluum, shut down for network security concerns)
- Bluum contract: Dec 15 2025 short extension, expected Mar-Apr renewal didn't materialize
- Parallel procurement paths: Bluum renewal, SHI on state contract, cooperative purchasing
- SteerCo open actions: IS resource for POC support still unconfirmed

---

## NEXT RECOMMENDED ACTIONS (IN ORDER)

**Before Monday:**
- [ ] Upload `IS_Master_Architecture_Internal_v3.md` to all four Claude Desktop project spaces
- [ ] Upload all 7 artifacts + updated meeting prep to SharePoint TCCISPortfolioHub document library
- [ ] Copy SharePoint site link and send to SteerCo attendees

**Monday — Paul Burke meeting debrief (TCC Expansion project space):**
- [ ] Capture: power draw specs, UPS decision, named resource, change request lead time
- [ ] Capture: PC deployment cycle time estimate
- [ ] Submit CR-T01 as soon as power specs confirmed
- [ ] Order Room 1007 gear immediately after specs confirmed

**This week (individual project spaces):**
- [ ] VuWall space: engage Eric Brown (LASO) — Room 1007 firewall design detail for BCA scope
- [ ] NG911 space: schedule deep-dive RFP workshop with Tommy Thompson (FE)
- [ ] TCC Expansion space: confirm PC migration assumption with Carri Sampson (all 16 return to Minneapolis)

**When Pro license arrives:**
- [ ] Publish Power BI report to Power BI service (My Workspace)
- [ ] Add Power BI Embed web part to SharePoint portal page
- [ ] Add WBS as second data source in Power BI Desktop first

**April 22 SteerCo:**
- [ ] Dedicated endpoint resource — confirm who and when (Gretchen White agreed in principle)
- [ ] Apr 30 EBC target — hard revised date with dependency chain
- [ ] VuWall BCA timeline acknowledgment (Jun/Jul, not May)
- [ ] Construction NTP update from Robert Rimstad

---

## FILE LOCATIONS

All outputs saved to `C:\PT\Claude TCC Setup\` (personal PC) and Claude.ai outputs:
- `IS_Master_Architecture_Internal_v3.md` — upload to all 4 Claude project spaces
- `TCC_WBS_Reconciled_20260327.xlsx` — 921 tasks, SharePoint import ready
- `TCC_RAID_Log_SharePoint_Import_20260326.xlsx` — 33 items, SharePoint import ready
- `IS_Infra_PM_Meeting_Prep_v2.html` — open in browser Monday before meeting
- `TCC_IS_Portfolio_Dashboard.pbix` — Power BI report (personal PC only)
- All 7 project artifacts — upload to SharePoint

## PMO AUDIT CHECKLIST (IS PMO Large Project standard)

| Artifact | Status | Audit Required |
|----------|--------|----------------|
| MS Teams / SharePoint Site | ✅ Created | — |
| Project Charter | ✅ Draft v1.0 | MayAnn Severud |
| RACI Matrix | ✅ Draft v1.0 | MayAnn Severud |
| Scope Statement | ✅ Draft v1.0 | MayAnn Severud |
| Stakeholder Register | ✅ Draft v1.0 | MayAnn Severud |
| Communication Plan | ✅ Draft v1.0 | MayAnn Severud |
| Kick Off Deck | ✅ Built (retroactive) | — |
| Project Plan / WBS | ✅ 921 tasks | — |
| Milestones | ✅ In WBS | — |
| RAID Log | ✅ 33 items | — |
| Project Change Log | ✅ In WBS 1.6 | — |
| OCM Intake Form | ❌ Not yet built | Future session |
| OCM Strategy | ❌ Not yet built | Future session |
| Requirements Document | ❌ Not yet built | Future session |

---

*TCC IS Portfolio Hub · Session Handoff · March 27, 2026 · IS Senior PM / PMO · Internal use only*
