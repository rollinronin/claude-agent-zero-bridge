# TCC IS Portfolio Hub — Session Handoff (v32.11)

**Date:** 2026-04-23 (session exit, same calendar day as v32.10)
**Outgoing build:** v32.11-config-countdowns
**Status:** Packed in source tree. Pending PM run of SP list creation + pack + import. Supersedes `SESSION_HANDOFF_20260423_v32.10.md`.

---

## Why this session

PM flagged on v32.10 exit: `DAYS TO EBC` and `DAYS TO HARD STOP` on scrExecutive were still hardcoded to April 30, 2026. April 30 is no longer a hard stop — Room 1007 Go-Live shifted to pre-State-Fair August 2026. Fix was pulled forward from the outstanding roadmap.

## What v32.11 does

### New SP list: `IS Portfolio Config`

Key/value store for canvas-app config values (starting with countdown targets).

| Display | Internal | Type | Purpose |
|---|---|---|---|
| Title | `Title` | Text | Human label |
| Key | `Key` | Text, required, indexed, unique | Power Fx lookup key |
| Value | `ConfigValue` | Date | The target date |
| Notes | `ConfigNotes` | Note | Rationale |

Seed rows:

| Key | Value | KPI it drives |
|---|---|---|
| `RoomReadyDate` | 2026-08-15 | DAYS TO EBC |
| `StateFairStart` | 2026-08-21 | DAYS TO STATE FAIR (new label) |
| `TCCFinalComplete` | 2026-12-31 | DAYS TO TCC FINAL (new KPI) |

**Design decisions:**
- Internal name for the "Value" column is `ConfigValue` (not `Value`) to dodge SP reserved-token collisions. Power Fx must use `.ConfigValue`.
- Fallback `Date(...)` literals in every LookUp so a missing row or failed query doesn't black out the KPI strip.

### KPI strip refactor (scrExecutive)

Grid expanded from 7 to 8 cards. Right edge reorganized:

| # | Label | Color | Source |
|---|---|---|---|
| 6 | DAYS TO EBC | `#0097D0` cyan | `gDaysToEBC` (from `RoomReadyDate`) |
| 7 | DAYS TO STATE FAIR | `#F57C00` amber | `gDaysToStateFair` (from `StateFairStart`) |
| 8 | DAYS TO TCC FINAL | `#6B46C1` violet | `gDaysToTCCFinal` (from `TCCFinalComplete`) |

Grid gap tightened 12px → 10px to keep card density readable at 1366 wide.

### Power Fx changes (App.fx.yaml only)

- `gAppVersion` → `v32.11-config-countdowns`
- Removed `Set(gEBCDate, Date(2026,4,26))` and `Set(gHardStopDate, Date(2026,4,29))` from Concurrent
- Added `ClearCollect(colConfig, 'IS Portfolio Config')` inside Concurrent
- After Concurrent:
  ```
  Set(gEBCDate,         Coalesce(LookUp(colConfig, Key = "RoomReadyDate").ConfigValue,    Date(2026, 8, 15)));
  Set(gStateFairDate,   Coalesce(LookUp(colConfig, Key = "StateFairStart").ConfigValue,   Date(2026, 8, 21)));
  Set(gTCCFinalDate,    Coalesce(LookUp(colConfig, Key = "TCCFinalComplete").ConfigValue, Date(2026, 12, 31)));
  Set(gDaysToEBC,       DateDiff(Today(), gEBCDate,        TimeUnit.Days));
  Set(gDaysToStateFair, DateDiff(Today(), gStateFairDate,  TimeUnit.Days));
  Set(gDaysToTCCFinal,  DateDiff(Today(), gTCCFinalDate,   TimeUnit.Days));
  Set(gDaysToHardStop,  gDaysToStateFair);
  ```

`gDaysToHardStop` is preserved as an alias of `gDaysToStateFair` so scrDetail's existing EBC COUNTDOWN card (which references the old global) keeps rendering without edits.

---

## Deployment sequence (PM-side)

### Step 1 — Create the SP list (one-time)
```powershell
# Claude-in-Chrome on metcmn.sharepoint.com/sites/TCCISPortfolioHub:
#   navigate -> sign in -> javascript_tool
# Paste the contents of SP_Create_IS_Portfolio_Config_List.js
# Wait ~10s, then:
#   > window.TCC_CONFIG_DONE
# Expected: { listId: "...", steps: ~10, errors: 0 }
```

### Step 2 — Pack the app
```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"; powershell -ExecutionPolicy Bypass -File .\Pack-v32.11.ps1
```

### Step 3 — Import + reconnect
```
Power Apps Studio -> File -> Apps -> Import -> TCC_Portfolio_Dashboard_v32_11.msapp
Reconnect: IS Project Tasks, IS Project RAID, IS Project Gates, IS Portfolio Config
File -> Settings -> Run OnStart
Verify KPI strip shows 8 cards; rightmost three countdowns reflect config dates
```

### Step 4 — Bridge repo snapshot
```powershell
.\Sync-Bridge-v32.11.ps1
```
Snapshots v32.10 (handoff-only) and v32.11 (full source + pack + JS + handoff) to `claude-agent-zero-bridge/shared/tcc-from-claude/`, commits, pushes. Closes the v30.2 → v32.11 gap.

---

## Files created / modified this session

### Workspace root
- `SP_Create_IS_Portfolio_Config_List.js` — new; SP list + 3 seed rows via REST/JS
- `Pack-v32.11.ps1` — new; pack wrapper
- `Sync-Bridge-v32.11.ps1` — new; bridge snapshot for v32.10 + v32.11
- `SESSION_HANDOFF_20260423_v32.11.md` — **this document**

### Source tree (`v20/tcc_hub_src/Src/`)
- `App.fx.yaml` — version bump, colConfig ClearCollect, 3 LookUp-with-Coalesce Sets, alias
- `scrExecutive.fx.yaml` — htmlKPIStrip grid + card restructure

### Auto-memory
- `reference_is_portfolio_config.md` — NEW — list schema + usage pattern
- `project_hub_v32_11_deployed.md` — NEW — canonical "what's live" record for v32.11
- `MEMORY.md` — index updated

### SharePoint (pending PM browser action)
- `IS Portfolio Config` list creation
- 3 seed rows

---

## Outstanding roadmap (carry-forward)

Same as v32.10 minus item #1 (countdown) and #2 (bridge snapshot), once PM runs the scripts.

### Still open:

3. **App Checker polish** — 4 a11y + 46 perf warnings carried forward
4. **Label clip** on "Go-Live / Complete" portfolio gate — rightmost translateX(-50%) overruns track container
5. **PlannedStart v2 formatter** — visual spot-check in SP UI still pending
6. **Row-click drilldown** — `gSelectedProject` key-space drift
7. **v3.2 possible-dupes** — 2 NG911 rows flagged at import
8. **Monitor procurement** — spec + price + per-console count TBD
9. **Hard-stop date refinement** — State Fair start is a reasonable default, but PM may want to revise once construction PM confirms TCC Final window. SP config list makes this a 1-row edit.

---

## Gotchas to remember

- `IS Portfolio Config` column "Value" has internal name `ConfigValue` — reference as such in Power Fx
- Coalesce fallback dates protect against empty/missing config rows; keep them
- If you rename a Key, every LookUp in App.fx.yaml needs the same rename
- To shift a countdown, edit the SP row, re-run OnStart — no rebuild

---

## Reproducibility

1. Source tree at `v20/tcc_hub_src/` is self-contained (v32.11 state).
2. `pac canvas pack --sources ./tcc_hub_src --msapp TCC_Portfolio_Dashboard_v32_11.msapp` produces a working msapp.
3. SP prereq: `IS Portfolio Config` list + 3 seed rows must exist before first OnStart.
4. All other SP state (tasks, RAID, gates, column formatters) carries forward from v32.10 unchanged.
