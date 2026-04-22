# TCC IS Portfolio Hub — Session Handoff (v32.8 milestone)

**Date:** 2026-04-22 (end of session)
**Outgoing build:** v32.8-html-baseline
**Status:** HTML-first architecture complete on both screens. Data-bound to SharePoint for decisions, RAID, tasks, gates. Visual design matches `tcc-design-sample.html` 1:1.

---

## Arc of this session

Started at **v30.2** (rectangle-based layout, ~900 controls, deployed in gov, PM described as "not app-store quality / too harsh"). Ended at **v32.8** (HTML-first, ~20 htmlViewer controls, design-sample fidelity, live SP data).

**v30.x → v31.x:** Attempted polish inside the rectangle paradigm — KPI cards with accents, shadows, zebra rows, per-project G-gate strings. Improved but still "institutional not modern."

**v31.x → v32.0:** Pivoted. PM revealed the 1201-line `tcc-design-sample.html` was already a functional app; they couldn't deploy it because SharePoint wrapped it in a frame. Tested whether Power Apps `htmlViewer` control renders modern CSS in gov — it does. Full support for CSS Grid, Flexbox, border-radius, box-shadow, rgba, unicode, inline styles. Architecture confirmed.

**v32.0 → v32.1 → v32.2 → v32.3:** Rebuilt scrExecutive then scrDetail with `htmlViewer` inside galleries bound to Power Fx collections. Each row renders one HTML card via `ThisItem` bindings. Added schedule-aware progress bars (work-done fill + today-marker) with ahead/behind flag.

**v32.4 → v32.5 → v32.6 → v32.7:** Moved hardcoded content to SharePoint. Decisions band filters `colRAID` for type=Decision, status=Open. Project dates compute from `colTasks` min/max with hardcoded fallback. Created new `IS Project Gates` SP list via Chrome automation, seeded 18 rows, wired live OnStart load. Replaced verbose gate text strings with compact colored dot cluster (green/amber/red/grey per gate status).

**v32.8:** Cleanup — removed `scrHtmlTest` test screen and `btnNavHtmlTest` button from production build. Source is now a clean HTML-first foundation to build on.

---

## Current state

### Screens
- **scrExecutive** — `htmlKPIStrip` (7 tiles), `htmlDecisions` (live from colRAID), `galExecProjects` with `htmlProjRow` + `btnRowOverlay` template (3 project cards, row-click nav to detail)
- **scrDetail** — `htmlDetailKPIs` (8 tiles, reactive to gSelectedProject), `galRAID` with `htmlRaidRow` template, project filter pills, RAID type filter pills

### Data sources
- **IS Project Tasks** (GUID `37ad1da8-59ce-4672-ad5b-1767ed5c57d9`) — 208 tasks
- **IS Project RAID** (GUID `126b79be-ea3a-48f1-856f-b3bbe28668e8`) — 26 items, filtered to Open in colRAID
- **IS Project Gates** (GUID `bea3cbf1-5204-4c73-8fd8-de0e66dd9da8`) — 18 items seeded 2026-04-22 (NEW this session)
  - Schema: Title (gate number like G-01), Project (Choice), GateStatus (Choice: Complete/Active/Blocked/NotStarted), TargetDate (DateTime, empty), Notes

### OnStart collections
- `colTasks` — 208 rows
- `colRAID` — filtered to Status=Open
- `colGates` — 18 rows
- `colProjSummary` — computed via `ForAll(Distinct(colTasks, Project.Value) As projItem, ...)`
- `gProjectRowData` — enriched per-project row data with joined summary counts + computed TimePct + computed GateStrip HTML
- `gDecisions` — top 4 open decisions with sequential D-codes and color cycling
- `gExecCardData` — (orphaned from scrHtmlTest removal; safe to remove next iteration)
- `gProjects` — hardcoded master list with Name, ShortCode, RAG, StartDate, EndDate, fallback GateStrip

### Hardcoded items still awaiting SP backing
- **Project RAG** — lives in `gProjects.RAG` as "Amber"/"Red"/"Amber". Could come from `IS Status Summary` list (exists per memory).
- **Project StartDate/EndDate** — hardcoded fallback used when colTasks dates are sparse (most likely will remain primary until task data is richer).
- **TargetDate per gate** — `IS Project Gates.TargetDate` field exists but empty. Populating enables milestone-timeline component (option in roadmap).

### KPIs (verified in production 2026-04-22)
Total 208 / Avg 67% / Overdue 1 / Critical 0 / Open RAID 26 / Days to EBC 4d / Days to Hard Stop 7d.
Real overdue surfaced: Task #6928 "FE Design Recommendation Review" NG911, PlannedEnd 2026-04-17 — workshop already happened, task needs close-out.

---

## Architecture decisions that carry forward

### HTML-first, not rectangle-based
Every visual component (KPI card, decision card, project row card, RAID row, gate dot) is now an HtmlText control rendered via inline CSS. Data binds through Power Fx string concatenation. Gallery iteration replaces manual row-stacking.

### Gallery + htmlViewer + transparent overlay button = the row pattern
For any interactive list (exec projects, RAID rows), use:
- Gallery with `Items = <collection>`
- `htmlViewer` inside template for the visual row (Fill=transparent)
- `button` overlay at (0,0) W=TemplateWidth H=TemplateHeight with transparent fill + OnSelect for click action

### OnStart pre-joining, not inline AddColumns
`AddColumns(source, "Col", LookUp(other, Key = source.Key))` fails with "Expected identifier name" due to scope ambiguity. Use `ForAll(source As _alias, {..., Col: LookUp(other, Key = _alias.Key)})` in App.OnStart, bind Gallery.Items to the resulting collection. Proven pattern for gProjectRowData.

### SP list for gate status
New `IS Project Gates` list created and seeded. Fields: Title/Project/GateStatus/TargetDate/Notes. OnStart loads colGates; gProjectRowData.GateStrip is computed via `Concat(Sort(Filter(colGates, ...), Title), "<div>dot html</div>", "")`. Change a row in SP → next OnStart refreshes the dots. Covers Complete/Active/Blocked/NotStarted states with colored circles.

### Data sources stay manual per-import
Tried pre-populating `Connections/Connections.json` + `DataSources/*.json` from a fresh export — **failed with `ErrOpeningDocument_UnknownError`**. Environment-specific connection GUIDs in those files get rejected on canvas-app import. PM decided re-adding three connections per import (~10s) isn't worth automating. Solution packaging (proper fix via connection references) is deferred.

---

## Build recipe

Source tree: `v20/tcc_hub_src/`

```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
powershell -ExecutionPolicy Bypass -File .\Pack-v32.8.ps1
```

Produces `TCC_Portfolio_Dashboard_v32_8.msapp`. Import to gov Power Apps, re-add 3 SP connections (IS Project Tasks / RAID / Gates), run OnStart.

### Pre-export extraction

When user exports the app from gov Studio (always saves as `.zip` never bare `.msapp`), use:

```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
powershell -ExecutionPolicy Bypass -File .\Prepare-Export.ps1
```

Scans Downloads + workspace folders for newest TCC-named zip/msapp, extracts, unpacks via pac. Useful when user's Studio-side changes need to come back into source.

---

## Claude in Chrome capability confirmed

Memory notes that Cowork Chrome blocks `make.gov.powerapps.us`, but `metcmn.sharepoint.com` works. Confirmed 2026-04-22: Claude can navigate to the SP site, execute REST API calls via `javascript_tool`, create lists + seed data without the user touching DevTools. Used this successfully to bootstrap the IS Project Gates list. Reusable pattern for future SP schema work.

---

## Outstanding roadmap (priority order)

### 1. Populate IS Project Gates TargetDate + wire milestone timeline
The gate dots show status but not timing. Adding a target date per gate + rendering a horizontal mini-timeline with dots positioned at their target dates (with today-line) gives temporal dimension. Design-sample has the `milestone-track` component pattern.

### 2. Project RAG from SP (IS Status Summary)
Move `gProjects.RAG` from hardcoded to a LookUp against `IS Status Summary` list (exists per memory, weekly rollup). Would let PMO update RAG in one place and it flows to the exec dashboard automatically.

### 3. Real project timelines from colTasks
`gProjectRowData.StartDate`/`EndDate` currently use hardcoded fallbacks because colTasks.PlannedStart/PlannedEnd are 24% populated. As more tasks get dates, the computed Min/Max path kicks in automatically. No code change needed — just data hygiene.

### 4. Row-click detail integration
`btnRowOverlay.OnSelect` already sets `gSelectedProject` and navigates to scrDetail. Verify the pill-highlight on scrDetail matches after nav, and the filter pre-selects correctly.

### 5. App Checker polish pass
Accessibility + performance warnings accumulated across v32.x. Triage before wider share.

### 6. Solution packaging (deferred by PM)
`SOLUTION_SETUP_GUIDE.md` in workspace has the 5-step config. Not needed until connection-re-add friction outweighs the setup investment.

---

## Known gotchas baked into code

- `DateDiff(a, b, TimeUnit.Days)` — bare `Days` errors
- `ForAll As _alias` works; `AddColumns As` doesn't
- `Concat(table, formula, separator)` — inside formula, row columns accessible by bare name
- `Index()` / `ThisRecord.X` in gov Power Fx — might or might not work; prefer `FirstN + Last` or named alias
- Gov export always produces a `.zip` with the `.msapp` buried inside `Microsoft.PowerApps/apps/<GUID>/`
- Pre-populated `Connections.json` + `DataSources/*.json` in source → import fails
- OneDrive sync occasionally locks files so rm fails from Linux; use PowerShell for deletes

---

## Source files to bridge repo

Everything below should land in `claude-agent-zero-bridge/shared/tcc-from-claude/v32.8-html-baseline/`:

- `v20/tcc_hub_src/` — entire canonical source (packs to working msapp)
- `Pack-v32.8.ps1` — build script
- `Prepare-Export.ps1` — export unpack helper
- `gates_setup_step1_create.js` — SP list schema creation
- `gates_setup_step2_seed.js` — SP list seed data
- `SESSION_HANDOFF_20260422_v32.8.md` — this document
- `SOLUTION_SETUP_GUIDE.md` — deferred pipeline docs
- `TCC_Portfolio_Dashboard_v32_8.msapp` — packed artifact once built

---

## Prompt for next session

```
Resume TCC IS Portfolio Hub. Current build is v32.8-html-baseline deployed in
gov tenant ("MetC Data Management" env, 83181ce4-b33c-ee76-9337-862af377e448).
HTML-first architecture complete on both screens; decisions, RAID, gates all
live from SharePoint.

Read these BEFORE doing anything else, in order:
1. TCC IS Portfolio Hub/SESSION_HANDOFF_20260422_v32.8.md (this session's full state)
2. .auto-memory/project_tcc_hub_v28_deployed.md (v32.x deploy log)
3. .auto-memory/reference_powerapps_htmltext_gov.md (HTML Text pattern + harvest procedure)
4. .auto-memory/reference_power_fx_gotchas.md (TimeUnit.Days, ForAll As, AddColumns scope)
5. .auto-memory/reference_pac_canvas_workflow.md (pack/unpack + what fails)
6. .auto-memory/reference_is_lists_schema.md (SP column refs)
7. .auto-memory/reference_tcc_design_system.md (design tokens)

Canonical build artifact: v20/tcc_hub_src/. Rebuild via:
pac canvas pack --sources .\tcc_hub_src --msapp <name>.msapp
(or ./Pack-v32.8.ps1 which wraps it)

Current state summary:
- scrExecutive + scrDetail both HTML-first with gallery+htmlViewer+overlay pattern
- 3 SP data sources: IS Project Tasks (208), IS Project RAID (26 open), IS Project Gates (18)
- Decisions band filters colRAID live; gates dots computed from colGates live
- Schedule-aware progress bars with today-marker + ahead/behind flag
- Project dates, RAG still hardcoded in gProjects (fallback + semi-static)
- Connection re-add is manual per import (~10s, PM-accepted tradeoff)

Outstanding priorities:
1) Populate IS Project Gates TargetDate + milestone timeline component
2) Project RAG from IS Status Summary SP list
3) Real project timelines once colTasks dates populate more
4) Row-click detail integration verification
5) App Checker polish pass before wider rollout

Do NOT:
- Pre-populate Connections.json / DataSources/ in source (proven to fail import)
- Use bare 'Days' in DateDiff (needs TimeUnit.Days)
- Use AddColumns with inline cross-collection lookup (use ForAll As in OnStart)
- Delete v32.8 before successor validates
- Hand-craft msapp internals (pac canvas pack is the only path that works)

Start by confirming current state in 3-4 bullets, then ask PM which outstanding
item to tackle first. #1 (milestone timeline) is the most visible UX bump;
#2 (RAG from SP) is the cleanest architectural completion.
```

---

## Memory state after this session

New memories written:
- `reference_powerapps_htmltext_gov.md` — expanded with v32.3+ data-bound pattern and htmlViewer harvesting procedure
- `reference_power_fx_gotchas.md` — added DateDiff TimeUnit, AddColumns scope, ForAll As patterns
- `reference_pac_canvas_workflow.md` — added zip-export-always + Connections.json fails notes
- `project_tcc_hub_v28_deployed.md` — updated with v32.x progression through v32.3.1
- `feedback_hub_needs_design_refresh.md` — existing, resolved (design fidelity achieved)
