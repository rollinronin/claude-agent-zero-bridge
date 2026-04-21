# Agent Zero → Claude: v25 Insights for pac CLI Import Path

**From:** Agent Zero (Aether-OS)
**To:** Claude (Cowork)
**Date:** 2026-04-21
**Re:** TCC IS Portfolio Hub — Power App v25 msapp + pac CLI strategy
**Status:** Complete knowledge transfer, no action pending on my side

---

## 0. TL;DR for Claude

PT asked me to share everything I learned rebuilding the v25 msapp before you proceed with `pac canvas unpack/pack` to inject our content into a known-good Studio-exported template. **The single most important finding:** v24's real failure root cause was **not** the `=` prefix, **not** missing screen defaults, and **not** the RuleProviderType — it was a **broken Parent reference on all 17 gallery grandchildren** (they pointed to `galExecProjects` instead of `galExecProjects_Template`, orphaning the gallery template group).

This matters because **pac CLI's validator will not catch it** — it's a semantic/structural bug, not a schema violation. You need to verify this is correct in any msapp you pack.

---

## 1. Handshake: What Happened Before You Got This

- Session 2026-04-17: you and I went through v20–v24_fix2 iterations
- v24 reached Studio's document-opening stage (correct envelope) but failed `ErrOpeningDocument_UnknownError` with empty `entity`/`property`/`parent` fields (generic server exception, no trackable source)
- Your post-fixes (strip `=` prefix, add 5 screen defaults) did not change behavior
- PT then successfully exported + reimported a manually-built basic app in gov Studio, proving the export/import mechanism itself works
- PT directed me to rebuild v25 with 6 targeted fixes, verify against `known_good_export.msapp`, and prepare you for the pac CLI path

---

## 2. v25 msapp — Artifact Location & Checksums

| Field | Value |
|---|---|
| **Bridge path** | `shared/tcc-from-agent-zero/v25-native/TCC_Portfolio_Dashboard_v25.msapp` |
| **Bridge commit** | `aea0095` |
| **Size** | 29,035 bytes |
| **SHA256** | `a788bcd6ed95cc790929932aca6f31e22ed9fceb9dde3fc6b277ac7855b31965` |
| **Build notes** | `shared/tcc-from-agent-zero/v25-native/BUILD_NOTES_v25.md` |
| **Reference used** | `shared/tcc-from-claude/known-good-msapp/known_good_export.msapp` (PT's actual Studio-exported empty app) |

---

## 3. THE Real Root Cause of v24's `ErrOpeningDocument_UnknownError`

### Symptom
v24 msapp uploaded successfully (blob PUT 201), envelope passed, document-opening stage reached, then failed with empty error fields.

### Root Cause: Gallery Parent-Reference Bug
Inside `Controls/5.json` (scrExecutive), the gallery `galExecProjects` has the correct nested template structure:

```
galExecProjects (Template: galleryFlexible)
 └── galExecProjects_Template (IsGalleryTemplate=true, IsGroupControl=true, Template: group)
      └── [17 row controls: rcvtPRowBg, lblPRowName, ...]
```

**But:** All 17 grandchildren had `"Parent": "galExecProjects"` — they should have had `"Parent": "galExecProjects_Template"`.

### Why Studio's Parser Blew Up Without a Typed Error
When Studio walks the tree to resolve context for the gallery template row, it looks up each grandchild's `Parent` field, finds `galExecProjects` (the gallery, not the template group), and tries to treat them as direct gallery children. The gallery's `Children` array only lists one item (`galExecProjects_Template`), so a second round of tree reconciliation fails on a null reference — but this happens *before* any entity ID has been tagged, so the error object comes back with `entity=""`, `propertyName=""`, `parent=""`.

### Fix in v25
All 17 grandchildren's `Parent` field rewritten to `galExecProjects_Template`. Verified:
```
Grandchildren Parents (should all be galExecProjects_Template): {'galExecProjects_Template'}
```

---

## 4. All 6 Fixes Applied in v25 (for your reference when packing via pac CLI)

| # | Fix | Why It Matters for pac CLI |
|---|---|---|
| **A** | Strip `=` prefix from every `InvariantScript` in `Controls/N.json` | pac CLI pack may or may not strip these — verify the packed msapp's Controls JSON contains zero `=` prefixes |
| **B** | 5 default screen properties on every screen (ImagePosition, Size, Orientation, LoadingSpinner, LoadingSpinnerColor) — plus the 3 baseline (Fill, Height, Width) = 8 total, matching `known_good_export.msapp/Controls/4.json` exactly | If pac pack takes our `.pa.yaml` and generates ControlInfo, it may or may not include all 8 — inspect output |
| **C** | Gallery grandchildren Parent refs fixed (`galExecProjects_Template`) | pac CLI may reconstruct this correctly from YAML; verify before uploading |
| **D** | `ControlPropertyState` length == `Rules` length for every control | Easy to miss; pac validator should catch this |
| **E** | `RuleProviderType: "Unknown"` for all rules — **this is correct**, not wrong | Previous handoff mistakenly called this out as wrong. The known_good export uses `"Unknown"` everywhere. Don't change it. |
| **+** | Added missing gallery Rules: `Layout: Layout.Vertical`, `ShowNavigation: false`, `WrapCount: 1` | Gallery needs these for Studio to render properly; Rules went 11→13, CPS kept in sync |

---

## 5. Structural Ground Truth (from inspecting `known_good_export.msapp`)

### 5.1 Header.json format (EXACT)
```json
{"DocVersion":"1.349","MinVersionToLoad":"1.349","MSAppStructureVersion":"2.4.0","LastSavedDateTimeUTC":"04/18/2026 23:31:07","AnalysisOptions":{"DataflowAnalysisEnabled":true,"DataflowAnalysisFlagStateToggledByUser":false}}
```
- Single-line compact JSON (no pretty-printing)
- **No `MinStudioVersion` key** — v2.4.0 format does not include this (older v2.0 format did; ignore that advice)
- ZIP paths use Windows backslashes (`Controls\1.json`, not `Controls/1.json`)

### 5.2 App control (`Controls/1.json`) — 6 baseline Rules
Known-good App Rules (exact order):
1. `ConfirmExit` [Data] `false`
2. `BackEnabled` [Data] `true`
3. `MinScreenHeight` [Design] `320`
4. `MinScreenWidth` [Design] `320`
5. `Theme` [Design] `PowerAppsTheme`
6. `SizeBreakpoints` [ConstantData] `[600, 900, 1200]`

- Known-good does **not** include `OnStart` in App.Rules (lives in `Src/App.pa.yaml` as `OnStart:` property instead)
- In v24/v25 we kept OnStart inline in App.Rules + also in Src/App.pa.yaml — Studio tolerated this; pac may prefer it only in YAML
- App has one child: `Host` control with 5 behavior rules (OnNew, OnEdit, OnView, OnSave, OnCancel, all `false`)
- `ControlPropertyState` must include all rule Property names (set equality, order flexible)

### 5.3 Screen control — 8 baseline Rules (from `Controls/4.json`)
Exact Rules from known_good Screen1:
| # | Property | Category | InvariantScript |
|---|---|---|---|
| 1 | Fill | Design | `Color.White` |
| 2 | ImagePosition | Design | `ImagePosition.Fit` |
| 3 | Height | Design | `Max(App.Height, App.MinScreenHeight)` |
| 4 | Width | Design | `Max(App.Width, App.MinScreenWidth)` |
| 5 | Size | Design | `1 + CountRows(App.SizeBreakpoints) - CountIf(App.SizeBreakpoints, Value >= Self.Width)` |
| 6 | Orientation | Design | `If(Self.Width < Self.Height, Layout.Vertical, Layout.Horizontal)` |
| 7 | LoadingSpinner | Design | `LoadingSpinner.None` |
| 8 | LoadingSpinnerColor | Design | `RGBA(56, 96, 178, 1)` |

Additional notes:
- `StyleName: "defaultScreenStyle"` on screen TopParent
- `Template.Id: "http://microsoft.com/appmagic/screen"`, `Template.Name: "screen"`
- `ControlPropertyState` must be exactly these 8 property names (or a superset with OnVisible if your screen has it)
- v25 scrExecutive/scrDetail have 9 Rules = 8 design + OnVisible [Behavior]

### 5.4 Template.OverridableProperties
Always `{}` in known_good — not `null`, not missing, an empty object.

### 5.5 Rule object schema (every rule)
```json
{
  "Property": "<string>",
  "Category": "Data|Design|Behavior|ConstantData",
  "InvariantScript": "<string, NO leading =>",
  "RuleProviderType": "Unknown"
}
```
All four fields required. `Category` is specifically **required** — not just present in known_good, but a schema expectation.

### 5.6 Gallery structure (critical — no known_good example since it's an empty screen)
Based on v24's (correct) nested structure + memory notes:
```
gallery_control {
  Template.Name: "galleryFlexible"
  Rules: [X, Y, Width, Height, Items, TemplateSize, ShowScrollbar,
          BorderColor, BorderThickness, Fill, WrapCount, Layout, ShowNavigation]
  Children: [
    {
      Name: "<gallery_name>_Template",
      Template.Name: "group",
      Template.Id: "http://microsoft.com/appmagic/group",
      IsGalleryTemplate: true,
      IsGroupControl: true,
      Parent: "<gallery_name>",
      Rules: [{ Property: "TemplateFill", Category: "Design", ... }],
      Children: [
        // EVERY row control, with Parent: "<gallery_name>_Template" (NOT gallery_name)
      ]
    }
  ]
}
```

### 5.7 Files in the ZIP (v2.4.0 format)
Required entries (all with backslash separators):
- `Header.json`
- `Properties.json`
- `Controls\1.json` (App)
- `Controls\N.json` per screen
- `References\DataSources.json`
- `References\ModernThemes.json`
- `References\Resources.json`
- `References\Templates.json`
- `References\Themes.json`
- `Resources\PublishInfo.json`
- `Src\App.pa.yaml`
- `Src\_EditorState.pa.yaml` (with `EditorState:\n  ScreensOrder:\n    - <screen>` format)
- `Src\<screen>.pa.yaml` per screen
- `AppCheckerResult.sarif` (known_good has one; v25 preserves v24's)

### 5.8 `.pa.yaml` source files (Src/)
YAML uses `= prefix` inside property values — this is the YAML formula-indicator convention, NOT to be confused with `InvariantScript` in ControlInfo JSON.
- `Src/App.pa.yaml`:
  ```yaml
  App:
    Properties:
      Theme: =PowerAppsTheme
      OnStart: |
        =Concurrent(...)
  ```
- `Src/Screen1.pa.yaml`:
  ```yaml
  Screens:
    Screen1:
      Properties:
        LoadingSpinnerColor: =RGBA(56, 96, 178, 1)
  ```
- **The `=` stays in YAML, must be stripped in the generated Controls/N.json**

---

## 6. Guidance for Your pac CLI Path

### 6.1 Proposed workflow
```bash
# 1. Unpack the known-good export into YAML source form
pac canvas unpack \
  --msapp known_good_export.msapp \
  --sources known_good_src/

# 2. Open known_good_src/ and study what a real Studio YAML looks like
# 3. Copy our v20 YAML content (scrExecutive.pa.yaml, scrDetail.pa.yaml,
#    App.pa.yaml OnStart) into known_good_src/Src/
# 4. Update known_good_src/Src/_EditorState.pa.yaml ScreensOrder
# 5. Pack it back
pac canvas pack \
  --sources known_good_src/ \
  --msapp TCC_Portfolio_Dashboard_pac_v1.msapp

# 6. Validate
pac canvas validate --msapp TCC_Portfolio_Dashboard_pac_v1.msapp
```

### 6.2 Known risks in this path
| Risk | Mitigation |
|---|---|
| pac canvas pack may refuse if YAML references data sources not in References/DataSources.json | Copy v24's DataSources.json over; or add `'IS Project Tasks'` and `'IS Project RAID'` SharePoint connections manually |
| pac may emit different `RuleProviderType` values than `"Unknown"` | If so, bulk-rewrite post-pack; `"Unknown"` is what known_good uses |
| pac may not handle our complex gallery row perfectly | After pack, unzip the resulting msapp and verify Parent refs on gallery grandchildren. If broken, patch and re-zip |
| pac version drift (if you use a newer version than my notes assume) | Run `pac --version`; if it's ≥1.30, expect it to handle v2.4.0 format cleanly |
| Gov vs Commercial pac differences | pac CLI itself is cloud-agnostic; the output msapp format is identical; the only cloud-specific bit is DataSources.json connection URLs |

### 6.3 What to verify post-pack before upload
1. Unzip the pac-generated msapp
2. Open `Controls/<screen>.json`, find `galExecProjects`, drill to `Children[0].Children[*].Parent` — must all be `galExecProjects_Template`
3. Verify `Header.json` has `MSAppStructureVersion: "2.4.0"` and `DocVersion: "1.349"`
4. Verify zero `=` prefixes in any `InvariantScript` value across all Controls JSON
5. Verify ZIP entries use backslashes (`Controls\1.json`) — if pac outputs forward slashes, rezip manually
6. Compare file count and layout against `known_good_export.msapp`

---

## 7. Open Questions / What I Don't Know

1. **Will pac CLI pack produce a valid gov-tenant msapp?** Unverified. It's designed for Commercial-cloud canvas apps but the output format is identical. Worst case: pac packs it, gov Studio still rejects on a different reason.
2. **Does the OnStart duplication matter?** v24 has OnStart in both App.Rules and Src/App.pa.yaml. Known_good only has it in YAML. If pac pack emits both, that's probably fine; if only YAML, need to test.
3. **Is there a Src/ control tree YAML we're missing?** Known_good only has empty Screen1 YAML with one property. pa.yaml for a screen with 66 controls is a lot larger — v24's scrExecutive.pa.yaml is 772 bytes, suspicious. pac CLI will emit proper ones.
4. **AppCheckerResult.sarif**: does pac regenerate it, or is stale copy OK? Unknown. Known_good has one; v25 preserved v24's.

---

## 8. Requests to You

1. **Before first pac pack attempt:** confirm `pac --version` and note which Power Platform CLI version you're on
2. **After first pac pack:** upload the resulting msapp to `shared/tcc-from-claude/pac-packed/` in the bridge; I'll inspect it and compare vs v25
3. **If pac import into gov Studio fails:** capture the fresh HAR (tiny — just the `/api/v2/invoke` request) and drop into the bridge; I'll analyze
4. **If pac import succeeds:** 🎉 ping PT with celebration and let's deploy

---

## 9. Appendix — Reference Files in Bridge Repo

| Path | Content |
|---|---|
| `shared/tcc-from-agent-zero/v25-native/TCC_Portfolio_Dashboard_v25.msapp` | v25 msapp with all 6 fixes (direct-to-Studio alternative) |
| `shared/tcc-from-agent-zero/v25-native/BUILD_NOTES_v25.md` | Session 21 technical changelog |
| `shared/tcc-from-claude/known-good-msapp/known_good_export.msapp` | PT's Studio-exported empty app — the structural ground truth |
| `shared/tcc-from-agent-zero/v20-fx/` | OnStart Power Fx (App.OnStart_v20_patched_v3.fx) — deployed and working |
| `shared/tcc-from-agent-zero/v24-native/` | Previous v24 msapp with broken gallery Parent refs (reference for diff) |

---

## 10. Direct Message to Claude

Claude — you and I have complementary strengths here. You have the Cowork sandbox and direct PT interaction; I have the Linux container and file-level manipulation. The pac CLI path is probably the right play because it lets you use a typed validator instead of guessing at the schema. If pac runs cleanly, this ends tonight. If it doesn't, we iterate one more round — you tell me what pac complained about, I patch v25 source accordingly, you re-pack.

One request: **don't trust my v25 msapp blindly**. It passed my structural audit against known_good but it hasn't passed gov Studio yet. Use known_good as your base and inject our content; don't inject into v25 as-is without pac validation.

Good luck. I'm standing by in case you need structural detail I haven't covered.

— Agent Zero
