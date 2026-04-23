# TCC IS Portfolio Hub — Session Handoff (v32.10)

**Date:** 2026-04-23 (session exit)
**Outgoing build:** v32.10-tasktype-tracks
**Status:** Deployed and verified in gov. Per-project mini-tracks now source from `IS Project Tasks` filtered by `TaskType`. WBS expanded from 208 → 328 rows via v3.2 placeholder pass. SP column formatters fixed. Supersedes `SESSION_HANDOFF_20260422_v32.9.1.md`.

---

## Arc of this session

Started at v32.9.1-label-switch (deployed). Outstanding #1 was date-positioning the per-project mini-tracks. That single task triggered a much larger arc:

**Phase 1 — Architectural pivot (Variant 3 Plus).** PM reframed the per-project track model. Construction gates TCC Expansion; NG911 and VuWall don't fit the synthetic G-01..G-13 shape. Decision: retire the 18 per-project rows from `IS Project Gates`, source mini-tracks from `IS Project Tasks` filtered by `TaskType` (Construction Gate for TCC, Milestone for NG911/VuWall).

**Phase 2 — WBS v3.2 placeholder pass.** Before rewiring the UI, PM wanted standard IT lifecycle scaffolding (Requirements, Implementation Plan, Configuration, Testing, Sign-Off) added back to the WBS as placeholders. Drafted a 2-page plan docx, got a thorough red-line back (20 workstreams including 9 TCC, 6 NG911, 5 VuWall with LASO/BCA approval variant). Produced `TCC_IS_WBS_v3.2_draft.xlsx` with 120 task rows + 4 RAID rows. Went through two iterations of date corrections:
- First round: all inferred + back-dated rows with suggested placeholders
- Second round: PM provided real schedule context — PC Procurement schedule pulled forward (Chad eval Apr 27 - May 7, OMF order end of May, MTPD/Council orders mid-May-June, delivery Nov 2026), Room 1007 target moved from Apr 30 → pre-State-Fair August 2026, Network Council/MTPD prep pulled to Apr-Sep with CJIS as the gate
- Third micro-correction: EBC Manager +4 PCs is part of OMF Bulk (not separate) → 91 PCs total, all refresh-funded

All 124 rows imported via SP REST, zero errors. TOTAL TASKS 208→328 exact match.

**Phase 3 — SP column formatter fixes.** PM flagged two bugs: (a) false "OVERDUE" on tasks completed early (ActualEnd set before PlannedEnd), (b) "Due this month" using 30-day rolling window (May tasks showing as due-this-month in April). Deployed `PlannedEnd` v2 and `PlannedStart` v2 with a 4-tier ladder: Complete (muted, no pill) / OVERDUE or Start-overdue / Due-this-week / Due-this-month (calendar-month via `getMonth` + `getYear`). Moved EBC CJIS Certification from 4/27 → 5/29. Deleted broken duplicate "My Tasks" view (`Owner=[Me]` CAML anti-pattern).

**Phase 4 — v32.10 dashboard refactor.** Deleted 18 per-project rows from `IS Project Gates` via SP REST. Patched `App.fx.yaml` OnStart: `gProjectRowData.GateStrip` rewritten to filter `colTasks` by Project + TaskType, sort by PlannedEnd with null-fallback, date-positioned dots, status colors derived from RAGStatus + PctComplete + ActualEnd. Packed, PM imported, verified. Mini-tracks render real TaskType data on all three projects.

---

## Current state — v32.10

### Build string
`v32.10-tasktype-tracks · Build: 2026-04-23`

### Screens
- **scrExecutive** — HTML-first. Top-to-bottom: `htmlKPIStrip`, `htmlDecisions` (3 items), `htmlPortfolioTrack` (7 portfolio gates with TODAY line), project header row, `galExecProjects` (3 row cards; last column now renders the NEW TaskType-sourced mini-track), context band, footer.
- **scrDetail** — unchanged from v32.8 / v32.9.1.

### Data sources (3 SP lists)

| List | GUID | Rows | Notes |
|---|---|---|---|
| IS Project Tasks | `37ad1da8-59ce-4672-ad5b-1767ed5c57d9` | 328 | 208 v3.1 + 120 v3.2 (imported 2026-04-23) |
| IS Project RAID | `126b79be-ea3a-48f1-856f-b3bbe28668e8` | 30 open | 26 + 4 v3.2 RAID additions |
| IS Project Gates | `bea3cbf1-5204-4c73-8fd8-de0e66dd9da8` | 7 | Portfolio P-01..P-07 only; 18 per-project retired |

### TaskType mapping (hardcoded in Power Fx)
- TCC Expansion → `Construction Gate`
- NG911 Refresh → `Milestone`
- VuWall → `Milestone`

### v3.2 workstream roster (20 workstreams, 120 new rows)

**TCC Expansion — 9 workstreams (65 rows):**
PC Procurement (11), PC Deployment & Imaging (10), Network — Council (8), Network — MTPD (8), Voice / Solacom Crossover (5), CJIS Documentation (4), OCM / Training (4), Room 1007 Temp Space (9), TCC Operational Readiness (5)

**NG911 Refresh — 6 workstreams (32 rows):**
Pre-RFP Discovery (4 back-dated), RFP & Requirements (5), Vendor Selection & Contract (6), Cloud Configuration (6), Cutover (7), Decommission Mitel lines (4)

**VuWall — 5 workstreams (24 rows):**
POC Design (6), POC Build (6), POC Testing (5), BCA Submission (4), Go/No-Go Decision (3)

### Retrospective rows (back-dated, Complete)
10 rows — Pre-RFP Discovery arc (2024-06 through 2025-07), Room 1007 planning (Oct-Dec 2025), RFP & Requirements · Requirements & Change Ticket (Apr 17 workshop).

### PC scope (per PM, 2026-04-23)

| Order | Count | Composition | Funding |
|---|---|---|---|
| OMF Bulk | 18 | 14 operator station + 4 EBC Manager-Office | Refresh |
| MTPD | 36 | MTPD console refresh (TCC Final) | Refresh |
| Council | 37 | Council console refresh (TCC Final) | Refresh |
| **Total** | **91** | all refresh-funded | |

Monitors: project-funded (TBD spec). Schedule: Demo eval Apr 27 - May 7 → OMF order May 8-31 → MTPD+Council orders May 15-Jun 15 → delivery Nov 2026 → imaging Nov-Jan 2027 → deployment Dec-Feb 2027 (construction-gated) → Go-Live Mar 2027.

### Room 1007 Temp Space
Target pulled from Apr 30 → pre-State-Fair August 2026 (earlier if achievable). Setup & Build-Out 2026-01 through 2026-07-31 Active 50%. Go-Live / Operational 2026-08-15.

### SP column formatters (deployed 2026-04-23)

**PlannedEnd v2** (CustomFormatter on IS Project Tasks "Planned End"):
- Complete (ActualEnd set OR Pct=100) → muted slate, no pill
- OVERDUE (past AND not complete) → red pill
- Due this week (≤ 7 days, not complete) → amber pill
- Due this month (same calendar month via `getMonth`+`getYear`, not complete) → amber-dim pill
- Default → plain slate, no pill

**PlannedStart v2** — analogous:
- Complete → muted
- Start overdue (past AND Pct=0 AND not complete) → amber pill
- Starts this week → amber pill
- Starts this month (calendar) → amber-dim pill

### App Checker
Assumed clean per successful import + visual render. No editor-session verification yet.

---

## Architecture decisions locked in this session

### Per-project mini-tracks source from IS Project Tasks (not IS Project Gates)
`IS Project Gates` was a synthetic shadow list; the WBS-in-Tasks is the source of truth. TaskType taxonomy (Task / Milestone / Construction Gate / Deliverable) already expresses the gate/milestone distinction. The 18 per-project G-0x rows are retired — don't re-create them. Portfolio gates P-01..P-07 stay in `IS Project Gates` (different purpose: portfolio-wide window).

### v3.2 adds to v3.1, never modifies
The 211 v3.1 rows are untouched. v3.2 added 120 new rows. Any future expansion should follow the same "add only" rule unless the PM specifically approves a v3.1 change.

### Funding-string rules
Refresh funds cover existing replacement + net new equipment (all 91 PCs). Project funds cover monitors. Captured in the `Funding String Analysis` Deliverable row (PC Procurement workstream) — must close before bulk orders place.

### Calendar-month labels, not rolling windows
PlannedEnd/Start tag logic uses `getMonth` + `getYear` match rather than 30-day delta, so "Due this month" means what it says. Accept the "dark zone" in the last week of a month where next-month tasks aren't tagged until they enter the 7-day window.

### Completion check = ActualEnd OR PctComplete=100
Either signal marks a task Complete for formatter purposes. Formatters skip OVERDUE / Due-this-X tags on complete rows.

### Claude-in-Chrome remains the proven SP write path
Confirmed this session across: 124-row bulk POST to IS Project Tasks + RAID, column formatter PATCHes, 18-row DELETE on IS Project Gates, single item MERGE for EBC CJIS date. Pattern holds — `tabs_context_mcp` → `navigate` → `javascript_tool` with async IIFE storing results to window globals.

---

## Source tree + pack recipe

Source: `v20/tcc_hub_src/`. Changes this session: `Src/App.fx.yaml` only.

**Pack:**
```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"; powershell -ExecutionPolicy Bypass -File .\Pack-v32.10.ps1
```
Produces `TCC_Portfolio_Dashboard_v32_10.msapp`. Import to MetC Data Management env. Re-add 3 SP connections. Run OnStart.

No SP prep needed for re-imports.

---

## Outstanding roadmap (priority order)

### 1. Re-target DAYS TO EBC + DAYS TO HARD STOP countdowns (PM flagged)
Both KPIs on scrExecutive still reference hardcoded April 30, 2026. PM flagged 2026-04-23: April 30 is no longer a hard stop.
- **DAYS TO EBC** should retarget to Room 1007 Go-Live (currently 2026-08-15)
- **DAYS TO HARD STOP** needs clarification — MN State Fair start (~Aug 21)? TCC Final construction complete (end of 2026)? PM decides.
- Ideal: source from an SP config row (or the Portfolio gate date directly) so the countdown shifts with reality rather than needing a Power Fx edit each time. Low-complexity refactor in `gExecKPIs` / the KPI strip HTML expressions.

### 2. Bridge repo snapshot — overdue
Last snapshot at `claude-agent-zero-bridge/shared/tcc-from-claude/` was v30.2. Now two major versions behind (v32.9.1, v32.10). Snapshot `v20/tcc_hub_src/` + Pack-v32.10.ps1 + SESSION_HANDOFF_20260423_v32.10.md to `v32.10-tasktype-tracks/`.

### 3. App Checker polish
4 a11y warnings + 46 perf warnings carried forward since v32.8. Likely candidates: htmlViewer count, repeated Filter calls in gProjectRowData, AccessibleLabel on htmlViewer controls.

### 4. Label clip on "Go-Live / Complete" portfolio gate
Carry-forward from v32.9.1. Rightmost label overruns track container (translateX(-50%) pushes half the label past edge). Fix: pad-right on track container, shorten label to "Go-Live", or clamp LeftPct to Min(92, ...).

### 5. Visual verification of PlannedStart v2 formatter
Deployed but not spot-checked in the SP list UI. Should see "Start overdue" pills on any past-start-not-started rows, "Starts this week" on Pct=0 rows with PlannedStart in the next 7 days.

### 6. Row-click drilldown verification (legacy)
`btnRowOverlay.OnSelect` in `galExecProjects` → `gSelectedProject` → scrDetail. `gSelectedProject` key-space drift mentioned in prior handoffs (short codes vs PMO IDs vs Choice literals) — still pending consolidation.

### 7. Possible v3.1 duplicates flagged at import time
Two rows in v3.2 were flagged as possible-duplicates-of-v3.1 in Notes:
- `NG911 · RFP & Requirements · IS Acceptance / Sign-Off` vs existing "FE Design Recommendation Review (Apr 17 Workshop)"
- `NG911 · Vendor Selection & Contract · Contract Award` vs existing "Vendor Selection & Contract Award"
Non-blocking; reconcile via SP list UI when convenient.

### 8. Monitor procurement detail — open
Monitor spec + price + per-console count not yet defined. Needs to land before PC Deployment & Imaging Imaging task starts (Nov 2026).

---

## Known gotchas baked into code (carry-forward)

- `DateDiff(a, b, TimeUnit.Days)` — bare `Days` fails
- `ForAll As _alias` works; `AddColumns As` doesn't
- `Concat(table, formula, separator)` — row columns accessible by bare name inside formula
- Gov export always produces `.zip` with `.msapp` buried inside `Microsoft.PowerApps/apps/<GUID>/`
- Pre-populated `Connections.json` + `DataSources/*.json` in source → import fails
- `Lower(_task.RAGStatus.Value)` on SP Choice works; use `.Value` always
- HTML Text in gov supports grid/flex/radius/shadow/rgba/unicode; no JS, no external resources, no form inputs
- `position:absolute` children inside a gallery cell need the cell wrapper to have `position:relative`
- Chrome automation (`metcmn.sharepoint.com`) works; `make.gov.powerapps.us` is blocked
- `getMonth()` returns 0-11, `getYear()` returns full year — both work in SP column formatters

## New gotchas discovered this session

- SP REST filter on Title with `·` (middle dot, U+00B7) needs URL-encoding as `%C2%B7`
- SP REST responses partially redact strings that look like JWT tokens (X.Y.Z patterns) — `ListItemEntityTypeFullName`, WBS strings at depth 3, etc. Workaround: store in window globals and use in subsequent calls without reading the value back.
- `javascript_tool` treats async IIFE returns as Promises and displays `undefined`. Pattern: store result to `window.TCC_*` globals in the IIFE, poll in a followup call after ~30s for batch POSTs.
- Demo Units task had `ActualEnd` set but `PctComplete=25` — intentional data-modeling quirk (ActualEnd = procurement event complete, PctComplete = eval work remaining). Formatter completion check handles either signal.

---

## Files added / modified this session

### Workspace root
- `TCC_IS_WBS_v3.2_Placeholder_Plan_DRAFT.docx` — the plan-level review doc (PM red-lined + approved)
- `TCC_IS_WBS_v3.2_draft.xlsx` — row-level draft with 120 task rows + 4 RAID rows (imported to SP; retained as archive)
- `TCC_IS_WBS_v3.2_Redline.md` — PM's red-line response (input to Step 2)
- `SP_Format_Column_PlannedEnd_v2.json` — new formatter (deployed)
- `SP_Format_Column_PlannedStart_v2.json` — new formatter (deployed)
- `Pack-v32.10.ps1` — new pack wrapper
- `TCC_Portfolio_Dashboard_v32_10.msapp` — packed + imported
- `SESSION_HANDOFF_20260423_v32.10.md` — **this document, canonical exit state**

### Source tree (`v20/tcc_hub_src/Src/`)
- `App.fx.yaml`:
  - `gAppVersion` → `v32.10-tasktype-tracks`, `gBuildDate` → `2026-04-23`
  - `gProjectRowData.GateStrip` inner With block rewritten: sources from `colTasks` filtered by Project + TaskType, sorts by PlannedEnd with Coalesce-null-fallback, date-positions via `DateDiff(_sd, PlannedEnd) / _wDays * 100`, status colors from RAGStatus + PctComplete + ActualEnd, empty case shows "no milestones yet"
- `scrExecutive.fx.yaml` — unchanged
- `scrDetail.fx.yaml` — unchanged

### SharePoint (`metcmn.sharepoint.com/sites/TCCISPortfolioHub`)
- `IS Project Tasks`: +120 rows (v3.2 workstream placeholders)
- `IS Project RAID`: +4 rows (Assumption, Opportunity, 2 Actions)
- `IS Project Gates`: -18 rows (IDs 1-18, per-project G-0x retired); 7 Portfolio rows remain
- `IS Project Tasks · Planned End` field: CustomFormatter updated to v2 (4-tier ladder)
- `IS Project Tasks · Planned Start` field: CustomFormatter updated to v2 (analogous)
- Item 6702 (EBC CJIS Certification): PlannedEnd 2026-04-27 → 2026-05-29
- View `My Tasks1.aspx` (guid d7d1eafe-...): deleted (broken CAML)

### Auto-memory (`.auto-memory/`)
- `project_hub_v32_10_deployed.md` — NEW — canonical "what's live" record
- `project_pc_procurement.md` — UPDATED — 91-PC scope, funding rules, Nov delivery, RAM pressure
- `project_room_1007_schedule.md` — NEW — August target, pre-State-Fair readiness
- `MEMORY.md` — INDEX entries added for v32.10 and Room 1007

---

## Reproducibility check

If a future session recreates v32.10 from scratch:
1. Source tree at `v20/tcc_hub_src/` is self-contained.
2. `pac canvas pack --sources ./tcc_hub_src --msapp TCC_Portfolio_Dashboard_v32_10.msapp` produces a working msapp.
3. SP state: 328 tasks (208 v3.1 + 120 v3.2), 30 RAID (26 + 4 v3.2), 7 Portfolio gates in `IS Project Gates`. All present and persistent.
4. `pac canvas unpack` on the packed msapp round-trips cleanly (gov-loader-compatible).
5. PlannedEnd/PlannedStart formatters are stored on the SP fields themselves — persist regardless of app state.
