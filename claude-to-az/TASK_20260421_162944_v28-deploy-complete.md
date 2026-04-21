---
from: claude
to: agent-zero
datetime: 2026-04-21T16:29:44Z
priority: normal
task_type: deploy
expected_output: acknowledgment
context_files: shared/tcc-from-claude/v28-deploy-handoff/SESSION_HANDOFF_20260421.md
---

## Task Description

**TCC IS Portfolio Hub v20 dashboard is deployed end-to-end in the MetC gov tenant as "TCC IS Portfolio Hub v28" and rendering live SharePoint data.** This is an informational handoff — no action requested, but relevant for your context on the next round.

**Full handoff brief:** `shared/tcc-from-claude/v28-deploy-handoff/SESSION_HANDOFF_20260421.md`

## What Changed Since Your v25 Handoff

Your v25 pac CLI handoff (from earlier today) pointed us at the right diagnostic path. We followed it and discovered that the root cause was deeper than gallery grandchildren Parent refs: it's a structural mismatch between **how hand-crafted msapps represent galleries** and **what pac CLI's `GroupControlTransform` expects on read**.

Specifically, `GroupControlTransform.AfterRead(BlockNode)` calls `groupControlState.GroupedControlsKey.Count` on the editor state of any group control it finds. In a pac-packed msapp, `GroupedControlsKey` is populated by `BeforeWrite` which flattens gallery row controls to peer level alongside the `_Template` group control and stores their names in the key. In a hand-crafted msapp (v24/v25), the row controls stay nested inside `_Template` and `GroupedControlsKey` is null → NullReferenceException → gov Studio catches it as generic `ErrOpeningDocument_UnknownError` with blank entity/property fields.

**The switch that worked:** abandon hand-crafted msapp internals entirely. Author in PASopa source form (`.fx.yaml` + per-control `.editorstate.json`) and let `pac canvas pack` do the binary serialization. Your screen YAML content from v20 was correct; it just needed to be in the right source format and given to the right tool.

## Deliverables

Under `shared/tcc-from-claude/v28-deploy-handoff/`:

- `tcc_hub_src/` — reproducible PASopa v0.24 source tree. `pac canvas pack --sources ./tcc_hub_src --msapp out.msapp` rebuilds at any time.
- `pa_to_fx_converter.py` — converter from your pa.yaml list-form source to pac's fx.yaml source form. Handles multi-line formulas via paren-balance tracking.
- `App_OnStart_v20_patched_v3.fx` — canonical OnStart with `ProjectID` field fix and `As projItem` binding for Distinct iterator.
- `SESSION_HANDOFF_20260421.md` — full session handoff including decision tree for next pickup.
- `README.md` — folder overview.

Under `deliverables/`:

- `TCC_Portfolio_Dashboard_v28.msapp` — the working msapp that's currently deployed.
- `TCC_Portfolio_Hub_v28_source.zip` — zipped source tree (same as `shared/tcc-from-claude/v28-deploy-handoff/tcc_hub_src/` but packaged).

## Key Learnings You Might Want in Your Knowledge

Six categories of Power Fx bugs that were in the v20 pa.yaml I'd suggest fixing in your author-time templates for future screens:

1. **Font syntax**: use `Font: =Font.'Segoe UI'` (enum reference), never `Font: ='Segoe UI'` (interpreted as identifier, fails `Name isn't valid`).
2. **FontWeight values**: only `Normal`, `Bold`, `Semibold`, `Lighter` exist. Not `Light`.
3. **Zebra row striping**: `IsEven()` and `ThisItem.ItemIndex` don't exist in Power Fx. Use `Mod(...)` patterns or accept single fill.
4. **SharePoint Choice columns**: always access via `.Value` — `'RAID Type'.Value`, `Project.Value`, `Status.Value`. Never compare Choice record directly to string.
5. **SharePoint User columns**: access `.DisplayName` for display — `ThisItem.Owner.DisplayName`.
6. **`Distinct()` iteration**: use explicit `As projItem` alias and `projItem.Value` inside ForAll lambda. Newer Power Fx uses `Value` as the column name, not `Result`.

Also: column name mismatches between OnStart's synthesized collections and screen-level references burn a lot of iteration time. When building `colProjSummary` via ForAll, make sure the record field names exactly match what downstream LookUp calls ask for.

## Success Criteria

- [x] v28 deployed and rendering real SP data
- [x] App Checker Formulas at 0 errors
- [x] Reproducible build artifact preserved
- [x] Session learnings committed to durable storage
- [ ] Acknowledge receipt (your turn — a short ack via queue or az-to-claude is fine)

## Additional Context

PM is taking a break before the UI polish pass (task list is in the session handoff doc, items A–F). If you have capacity to prep anything on those items — especially scrExecutive project gallery partial rendering and zebra-strip restoration patterns — that'd be useful, but not time-critical.

The canvas-authoring workflow (pac unpack/pack from PASopa source) is the durable pattern going forward. Future screen additions should skip the msapp-binary path entirely.
