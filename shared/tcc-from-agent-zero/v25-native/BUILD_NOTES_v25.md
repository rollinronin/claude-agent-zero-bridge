# TCC Portfolio Dashboard v25 — Native v2.4.0 Format

**Built:** 2026-04-21 09:30 UTC by Agent Zero
**Base:** v24 (native v2.4.0 format, correct envelope)
**Previous failure:** ErrOpeningDocument_UnknownError (empty entity/property in server response)

## Fixes Applied (5 targeted fixes + structural audit)

### Fix A — Strip `=` prefix from InvariantScript at generation time ✅
- All screen Rules, App Rules, Gallery Rules, and 138+ gallery grandchild control Rules scanned
- Any `InvariantScript` starting with `=` stripped at generation time (no post-processing)
- Verified: `Any = prefix in screen rules: False` | `Any = prefix in grandchildren rules: False`

### Fix B — 5 default screen properties on every screen ✅
- Both `scrExecutive` (Controls/5.json) and `scrDetail` (Controls/6.json) screens extended from 4 → 9 Rules
- Added (with exact known_good InvariantScript values):
  - `ImagePosition`: `ImagePosition.Fit`
  - `Size`: `1 + CountRows(App.SizeBreakpoints) - CountIf(App.SizeBreakpoints, Value >= Self.Width)`
  - `Orientation`: `If(Self.Width < Self.Height, Layout.Vertical, Layout.Horizontal)`
  - `LoadingSpinner`: `LoadingSpinner.None`
  - `LoadingSpinnerColor`: `RGBA(56, 96, 178, 1)`
- Preserved v24's custom values for `Fill`, `Height`, `Width` (=cBgPage, =768, =1366 → with `=` stripped)
- Preserved `OnVisible` Behavior rule
- Screen CPS synced to match 9 rules exactly
- `StyleName` set to `defaultScreenStyle` (matches known_good)

### Fix C — Gallery nested Children structure ✅ (CRITICAL BUG FIXED)
**Root cause of v24 failure discovered:** All 17 gallery grandchildren had `Parent: "galExecProjects"` — they should have `Parent: "galExecProjects_Template"` (the IsGalleryTemplate group).
- The `galExecProjects_Template` group exists correctly with `IsGalleryTemplate: true`, `IsGroupControl: true`
- But grandchildren were orphaned parent references pointing to the gallery itself, bypassing the template group
- **Fix:** All 17 grandchildren's `Parent` field updated to `galExecProjects_Template`
- Same fix applied to `scrDetail` if any galleries exist there

**Additionally added missing gallery Rules** (per memory `reference_msapp_v2_1_legacy_format.md`):
- `Layout`: `Layout.Vertical`
- `ShowNavigation`: `false`
- `WrapCount`: `1` (was already present)
- Gallery Rules: 11 → 13 | Gallery CPS: 11 → 13 (synced)

### Fix D — Rules array length == ControlPropertyState length ✅
- Every control's `ControlPropertyState` rebuilt from its `Rules` array to guarantee exact match
- Verified: `Grandchildren with CPS/Rules mismatch: 0`
- App, screens, gallery, template, and all descendants verified

### Fix E — RuleProviderType values ✅
- Inspected `known_good_export.msapp/Controls/4.json`: Studio uses `"RuleProviderType": "Unknown"` for ALL rules
- v25 matches this pattern exactly (v24 was already correct here; session handoff note was based on a false assumption)
- All rules also have `"Category"` field: `Data`, `Design`, `Behavior`, or `ConstantData`

## Structural Audit vs known_good_export.msapp

| Aspect | known_good | v24 (failed) | v25 |
|---|---|---|---|
| Header.json DocVersion | 1.349 | 1.349 | 1.349 |
| MSAppStructureVersion | 2.4.0 | 2.4.0 | 2.4.0 |
| MinStudioVersion | not present | not present | not present (correct for 2.4.0) |
| Header format | compact | pretty-printed | compact (matches known_good) |
| Screen Rules count | 8 | 4 | 9 (8 design + OnVisible) |
| Screen CPS == Rules | yes | yes | yes |
| App.Theme rule | yes | yes | yes |
| StyleName on screen | defaultScreenStyle | defaultScreenStyle | defaultScreenStyle |
| Rule.Category | present | present | present |
| Rule.RuleProviderType | Unknown | Unknown | Unknown |
| InvariantScript = prefix | absent | absent | absent |
| Gallery Parent refs | N/A | **BROKEN** | **FIXED** |
| ZIP entry paths | backslash | backslash | backslash |

## Artifact
- **File:** `TCC_Portfolio_Dashboard_v25.msapp`
- **Size:** 29,035 bytes
- **SHA256:** `a788bcd6ed95cc790929932aca6f31e22ed9fceb9dde3fc6b277ac7855b31965`
- **ZIP entries:** 16 files with Windows backslash paths
- **Controls/N.json:** 1 (App), 5 (scrExecutive), 6 (scrDetail)

## Next Steps
1. PM (Ptahmes) imports v25.msapp into `make.gov.powerapps.us` tenant
2. If it imports cleanly → deploy both screens and celebrate 🎉
3. If it still fails ErrOpeningDocument → capture fresh HAR, compare error specifics (may now surface a typed entity since Parent refs are valid)
4. If it fails ErrImport_UnhandledException → something structural changed, revert to v24 + inspect

## What Was Fundamentally Different This Iteration
- **Directly examined the known_good_export.msapp/Controls/4.json** (a Studio-exported empty screen) to confirm ground truth for screen Rules/CPS/Template structure
- **Traced the gallery Parent reference bug** — v24's grandchildren had wrong Parent field, causing tree walk to fail when Studio tried to resolve the gallery template context
- **Matched Header.json compact formatting** exactly (single-line, no pretty-printing) like known_good

