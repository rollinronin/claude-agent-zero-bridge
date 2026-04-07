# TCC IS Portfolio Hub — Session State (2026-03-29 Morning v4)

## Retrieval phrases
Load TCC IS Portfolio Hub context — where did we leave off? | TCC Portfolio Hub handoff | resume TCC session | TCC Executive View page | TCC SharePoint build

---

## ✅ ALL THREE POWER AUTOMATE FLOWS COMPLETE
- Flow 1: TCC Archive WBS Master — ✅ COMPLETE
- Flow 2: TCC WBS Upsert → IS Project Tasks — ✅ COMPLETE (926 rows in SharePoint)
- Flow 3: TCC RAID Upsert → IS Project RAID — ✅ COMPLETE (33 items in SharePoint, tested)

---

## 🌐 SharePoint Site: Executive View Page — LIVE
**URL:** https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/SitePages/TCC-IS-Portfolio-Executive-View.aspx
**Published:** ✅ 2026-03-29

### Page Sections Completed Today
| Section | Status | Notes |
|---|---|---|
| Section 1 — Hero Banner | ✅ Complete | Dark hero banner with RAG status pills |
| Section 2 — Construction Gate | ✅ Complete | "Construction Gate Active" block |
| Section 3 — Three Column Project Cards | ✅ Complete | IS Project RAID List web parts embedded |

### IS Project RAID — Filtered Views Created
| View Name | Filter | Status |
|---|---|---|
| EXP - Open Items | Project = Expansion, Open | ✅ Created |
| NG911 - Open Items | Project = NG911, Open | ✅ Created |
| VuWall - Open Items | Project = VuWall, Open | ✅ Created |

### 🔴 KNOWN ISSUE — FIX NEXT SESSION
**Problem:** List web parts in the three column sections are still displaying "All Items" view instead of the filtered views.
**Root cause:** View assignment not saving in the List web part configuration.
**Fix needed:** Re-open each column's List web part → Edit web part → change View dropdown to the correct filtered view → republish.
**Note:** This is a SharePoint web part quirk — sometimes requires saving the page in edit mode, setting the view, then saving/publishing in sequence.

---

## 📋 Executive View — Remaining Sections to Build
| Section | Status |
|---|---|
| Open Actions section | ❌ Not yet built |
| RAID Summary section | ❌ Not yet built |
| Quick Links section | ❌ Not yet built |

---

## 🔧 Outstanding SP Column Work
### IS Project Tasks — 3 Missing Columns
| Column | Type | Status |
|---|---|---|
| ServiceWorks Ticket ID | Single line of text | ⚠️ Outstanding |
| ServiceWorks URL | Single line of text (hyperlink) | ⚠️ Outstanding |
| SteerCo Tag | Yes/No | ⚠️ Outstanding |

> Note: Memory from earlier session indicates these MAY have been added already — verify in SharePoint before re-adding.

---

## SharePoint Lists Status
| List | Status | Count |
|---|---|---|
| IS Project Tasks | ✅ Populated | 926 rows |
| IS Project RAID | ✅ Populated | 33 items |
| IS Status Summary | ⚠️ Needs manual weekly entries | — |
| IS Milestones | ⚠️ Not separately populated (in IS Project Tasks) | — |
| Construction Gates | ⚠️ Not yet populated | — |

---

## 🗺️ Portal Pages — Full Build Status
| Page | Status | URL / Notes |
|---|---|---|
| Home / Hub Landing | ✅ Live | Status cards + nav bar deployed |
| Executive View | ✅ Live (partial) | Sections 1–3 done; Sections 4–6 outstanding; RAID web part filter bug |
| SteerCo Portal | ❌ Not yet built | — |
| IS Portfolio RAID Page | ❌ Not yet built | Full RAID log, filterable |
| ServiceWorks Tracker Widget | ❌ Not yet built | — |

---

## 🔑 Immediate Next Steps (Priority Order)
1. 🔴 Fix RAID list web part filtered view assignment (Executive View, Section 3)
2. 🟡 Verify 3 SP columns on IS Project Tasks (add if missing)
3. 🟡 Build Open Actions section (Executive View)
4. 🟡 Build RAID Summary section (Executive View)
5. 🟡 Build Quick Links section (Executive View)
6. 🟡 Build SteerCo/Executive portal page
7. 🟡 Build IS Portfolio RAID page (full RAID log, filterable)
8. 🟡 Build ServiceWorks ticket tracker widget

---

## Key Artifacts
- Handoff v3: /a0/usr/projects/tcc-program/.a0proj/knowledge/TCC_Session_Handoff_20260329_v3.md
- This handoff v4: /a0/usr/projects/tcc-program/.a0proj/knowledge/TCC_Session_Handoff_20260329_v4.md
- Flow 1 code view: /a0/usr/projects/tcc-program/artifacts/TCC_Archive_WBS_Master_CodeView.json
- Flow 2 code view: /a0/usr/projects/tcc-program/artifacts/TCC_WBS_Upsert_CodeView.json
- Flow 3 code view: /a0/usr/projects/tcc-program/artifacts/TCC_RAID_Upsert_CodeView.json
- SP Formatters: /a0/usr/projects/tcc-program/artifacts/sp-formatters/
- Power Apps YAML: /a0/usr/projects/tcc-program/artifacts/TCC_Portfolio_Dashboard_Toggle.yaml

## GCC Tenant Constraints (Always Relevant)
- DenyAddAndCustomizePages enabled — no custom HTML/ASPX rendering
- All UI via: Power Apps canvas apps, SharePoint JSON formatting, native web parts
- Power Automate Dataverse blocked — use SharePoint Lists as integration layer
- Code View in new designer (v3=true) is read-only — use v3=false for classic designer
