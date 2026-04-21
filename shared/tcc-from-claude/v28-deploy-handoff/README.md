# TCC IS Portfolio Hub v28 Deploy Handoff

**Deployed:** 2026-04-21
**App name in gov env:** `TCC IS Portfolio Hub v28`
**Status:** Rendering live SP data; UI polish pending

## What's in this folder

| File / Dir | Purpose |
|---|---|
| `SESSION_HANDOFF_20260421.md` | Full session handoff — state, file inventory, 6 follow-up tasks, pickup prompt for next Claude session |
| `tcc_hub_src/` | Reproducible build source tree (PASopa v0.24 format). Run `pac canvas pack --sources ./tcc_hub_src --msapp out.msapp` to rebuild. |
| `pa_to_fx_converter.py` | Python script: converts AZ-style pa.yaml list-form source to pac CLI's fx.yaml format. Handles multi-line formulas via paren-balance tracking. |
| `App_OnStart_v20_patched_v3.fx` | Canonical OnStart. Patches applied: `ProjectID` field in colProjSummary Set, `As projItem` binding for Distinct iterator. |

## How to rebuild v28 (or produce v29, v30, ...)

```powershell
# Prerequisites: pac CLI 2.6.4+ (install via `winget install Microsoft.PowerPlatformCLI`)
# No gov tenant auth required for unpack/pack.

# 1. Pack (modify tcc_hub_src/ first if making changes)
pac canvas pack --sources .\tcc_hub_src --msapp .\TCC_Portfolio_Dashboard_v29.msapp

# 2. Round-trip verify (optional but recommended)
pac canvas unpack --msapp .\TCC_Portfolio_Dashboard_v29.msapp --sources .\v29_roundtrip
# Should return "source format version: 0.24" with no errors

# 3. Import to gov Power Apps via browser
# Power Apps home → Apps → Import app → select the msapp → name it → Import
# Re-add SP connections after import (IS Project Tasks + IS Project RAID)
# Press F5 to launch preview and trigger OnStart
```

## Key structural facts

- **Format:** PASopa source v0.24 (NOT hand-crafted msapp internals)
- **Gallery row controls nest INSIDE the gallery in fx.yaml.** pac's `BeforeWrite` flattens + adds `GroupedControlsKey` at pack time. Never hand-roll this.
- **Font/FontWeight are enums:** `Font.'Segoe UI'`, `FontWeight.Lighter` (not `Light`).
- **`Distinct(...)` needs `As alias`** in newer Power Fx; implicit column is `Value` not `Result`.
- **SharePoint Choice columns use `.Value`; User columns use `.DisplayName`.**

Full details in `SESSION_HANDOFF_20260421.md` section 5, plus memory entries `reference_pac_canvas_workflow.md` and `reference_power_fx_gotchas.md` in Claude's `.auto-memory/`.

## Known pending items

See `SESSION_HANDOFF_20260421.md` section 3 for the full priority table. Top three:

1. **scrExecutive project gallery partial rendering** — TCC and NG911 rows show minimal data; only VuWall renders fully. First thing to tackle next session.
2. **colTasks row count validation** — currently 25; nominal list has ~926. Either delegation limit or intentional IsActive filter.
3. **Env cleanup + rename v28 → canonical "TCC IS Portfolio Hub"** — archive v20/v21/.../v27 shells.

## Why this exists

Previous sessions (April 17, v20–v25) burned ~8 hours hand-crafting msapp binaries for the gov tenant. All failed with `ErrOpeningDocument_UnknownError` due to `GroupControlTransform.AfterRead` NRE on gallery group controls. Today's session pivoted to pac CLI source-form authoring and cleared the roadblock in one afternoon. This folder is the durable artifact of that pivot — any future rebuild is a one-line `pac canvas pack`.
