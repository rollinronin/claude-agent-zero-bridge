# TCC IS Portfolio Hub — Power App v20 Build Notes

**Version:** v20.0
**Build Date:** 2026-04-15
**Organization:** Metropolitan Council IS
**Supersedes:** v19

---

## 1. What Changed: v19 to v20

### Visual Overhaul — Exact HTML CSS Variable Match

All colors sourced directly from tcc-executive-v3.html and tcc-detail-v3.html :root block:

| CSS Variable     | Hex       | Power FX Token  |
|-----------------|-----------|------------------|
| --header        | #001D3D   | cHeader          |
| --kpi-bg        | #001630   | cKPIBand         |
| --accent        | #0097D0   | cAccent          |
| --bg            | #E5E5EA   | cBgPage          |
| --red           | #C62828   | cRAGRed          |
| --amber         | #F57C00   | cRAGAmber        |
| --green         | #2E7D32   | cRAGGreen        |
| --card          | #FFFFFF   | cSurface         |
| --border        | #D1D5DB   | cBorderLight     |
| --muted         | #6B7280   | cTextSub         |
| --text          | #1A1A2E   | cTextDark        |
| --warn-bg       | #FFF3E0   | cAttnBg          |
| --warn-border   | #F57C00   | cAttnBdr         |
| --c222          | #043971   | cP222 (TCC)      |
| --c193          | #0097D0   | cP193 (NG911)    |
| --c11138        | #0054A4   | cP11138 (VuWall) |

### New Components (v20)

1. Attention Strip (Y=139, H=80)
   - Background: #FFF3E0 (--warn-bg)
   - Left border: 4px #F57C00 (--warn-border)
   - 4 decision cards D-01 to D-04 with per-color left accent bars
     - D-01: Red   (#FFEBEE bg / #C62828 fg)
     - D-02: Orange (#FFEDD5 bg / #9A3412 fg)
     - D-03: Blue  (#DBEAFE bg / #1E40AF fg)
     - D-04: Purple (#EDE9FE bg / #5B21B6 fg)

2. RAID Type Badges (colored pills in gallery rows)
   - Risk     = Red   (#FFEBEE bg / #C62828 fg)
   - Issue    = Amber (#FFF3E0 bg / #F57C00 fg)
   - Action   = Blue  (#DBEAFE bg / #1E40AF fg)
   - Decision = Purple (#EDE9FE bg / #5B21B6 fg)

3. Progress Bars (8px height, radius 4)
   - Track: #E5E7EB
   - Fill: conditional -- red <40%, amber 40-79%, green >=80%
   - Formula: Max(2, 500 * (Value(LookUp(..., PctComplete)) / 100))

4. Overdue Red Pill Badges
   - Visible only when OverdueTasks > 0
   - Fill: cOverdueBg (#C62828), Color: white

5. Per-project 5px Left Accent Border
   - TCC (P-222)   = #043971
   - NG911 (P-193) = #0097D0
   - VuWall (P-11138) = #0054A4

6. EBC G-Gate Tracker
   - Text label in project gallery rows
   - Format: G-01 [OK]  G-02 [X]  G-03 [X]  G-04 [!]  G-05 [!]  G-13 [...]
   - Status driven by gGate01Status...gGate13Status globals

7. Dynamic Countdowns
   - gDaysToEBC      = DateDiff(Today(), gEBCDate, Days)
   - gDaysToHardStop = DateDiff(Today(), gHardStopDate, Days)
   - Both shown in KPI band and context band

8. Detail Screen Metrics Strip (8 tiles, 170px each)
   - Total RAID, Risks, Issues, Actions, Decisions, Overdue Tasks, Avg%, Days to EBC
   - Each typed tile has colored top 4px bar matching RAID type color

9. Project Filter Buttons (Detail screen header band)
   - All / TCC / NG911 / VuWall
   - Active state: filled with project accent color

10. RAID Type Filter Buttons (RAID gallery header)
    - All / R / I / A / D
    - Styled with respective RAID type badge colors

---

## 2. Layout Metrics

### Executive Screen

| Zone              | Y   | H  | Y-end |
|-------------------|-----|-----|-------|
| Header            | 0   | 72  | 72    |
| Accent Bar        | 72  | 3   | 75    |
| KPI Band          | 75  | 64  | 139   |
| Attention Strip   | 139 | 80  | 219   |
| Project Table Hdr | 219 | 30  | 249   |
| Project Gallery   | 249 | 427 | 676   |
| Context Band      | 686 | 40  | 726   |
| Footer            | 726 | 42  | 768   |

### Detail Screen

| Zone              | Y   | H   | Y-end |
|-------------------|-----|-----|-------|
| Header            | 0   | 72  | 72    |
| Accent Bar        | 72  | 3   | 75    |
| Project Band      | 75  | 56  | 131   |
| Metrics Strip     | 131 | 100 | 231   |
| RAID Gallery Hdr  | 232 | 26  | 258   |
| RAID Gallery      | 258 | 424 | 682   |
| Context Band      | 686 | 40  | 726   |
| Footer            | 726 | 42  | 768   |

---

## 3. Color Token Reference

```
cHeader        RGBA(0,29,61,1)       #001D3D  -- header
cKPIBand       RGBA(0,22,48,1)       #001630  -- kpi-bg
cAccent        RGBA(0,151,208,1)     #0097D0  -- accent
cAccentDark    RGBA(0,107,160,1)     #006BA0
cFooter        RGBA(0,18,38,1)       #001226

cSurface       RGBA(255,255,255,1)   #FFFFFF  -- card
cSurfaceAlt    RGBA(249,250,251,1)   #F9FAFB
cBorderLight   RGBA(209,213,219,1)   #D1D5DB  -- border
cBgPage        RGBA(229,229,234,1)   #E5E5EA  -- bg

cTextDark      RGBA(26,26,46,1)      #1A1A2E  -- text
cTextBody      RGBA(51,65,85,1)      #334155
cTextSub       RGBA(107,114,128,1)   #6B7280  -- muted
cTextWhite     RGBA(255,255,255,1)

cRAGGreen      RGBA(46,125,50,1)     #2E7D32  -- green
cRAGAmber      RGBA(245,124,0,1)     #F57C00  -- amber
cRAGRed        RGBA(198,40,40,1)     #C62828  -- red

cP222          RGBA(4,57,113,1)      #043971  TCC
cP193          RGBA(0,151,208,1)     #0097D0  NG911
cP11138        RGBA(0,84,164,1)      #0054A4  VuWall

cRAIDRiskBg/Fg/Bdr    Red   family  #FFEBEE / #C62828
cRAIDIssueBg/Fg/Bdr   Amber family  #FFF3E0 / #F57C00
cRAIDActBg/Fg/Bdr     Blue  family  #DBEAFE / #1E40AF
cRAIDDecBg/Fg/Bdr     Purple family #EDE9FE / #5B21B6

cAttnBg        RGBA(255,243,224,1)   #FFF3E0  -- warn-bg
cAttnBdr       RGBA(245,124,0,1)     #F57C00  -- warn-border
cD01-D04 Bg/Fg pairs (red/orange/blue/purple)

cProgTrack     RGBA(229,231,235,1)   #E5E7EB
cProgFillGood  RGBA(46,125,50,1)     #2E7D32  >=80%
cProgFillWarn  RGBA(245,124,0,1)     #F57C00  40-79%
cProgFillCrit  RGBA(198,40,40,1)     #C62828  <40%
```

---

## 4. SharePoint Connections (Unchanged from v19)

- List: IS Project Tasks  -> colTasks
  Filter: IsActive = "true"  (TEXT, lowercase)
- List: IS Project RAID   -> colRAID
  Filter: Status = "Open"   (TEXT, capitalized)
- Derived: colProjSummary  (GroupBy + AddColumns)

Critical TEXT comparisons:
  IsActive = "true"   (lowercase)
  Status = "Open"     (capitalized)
  Type: "Risk" | "Issue" | "Action" | "Decision"
  ProjectID: "222" | "193" | "11138"  (all TEXT strings)

---

## 5. How to Apply in Power Apps Studio

1. Open app at https://make.powerapps.com -> Edit
2. App.OnStart
   a. Click the App node in Tree View
   b. Select OnStart in the property dropdown
   c. Select all existing formula (Ctrl+A)
   d. Paste contents of App_OnStart_v20.fx
   e. Click checkmark to save
   f. Right-click App -> Run OnStart
3. scrExecutive
   a. Select scrExecutive in Tree View
   b. Click ... -> View YAML
   c. Select all (Ctrl+A) and paste scrExecutive_v20.yaml
   d. Click Apply
4. scrDetail
   a. Select scrDetail in Tree View
   b. Click ... -> View YAML
   c. Select all and paste scrDetail_v20.yaml
   d. Click Apply
5. Verify data connections in Data panel
   - IS Project Tasks must be connected
   - IS Project RAID must be connected
6. Update dates in App.OnStart before publishing:
   Set(gEBCDate, Date(2026, 6, 15))
   Set(gHardStopDate, Date(2026, 5, 30))
7. F5 to preview, check all tiles and galleries
8. File -> Save -> Publish

---

## 6. Known Caveats

- Progress bar width formula uses colProjSummary lookup.
  If gallery is bound directly to SP list instead of gProjects,
  adjust: Value(ThisItem.PercentComplete) instead of LookUp.

- EBC dates are hardcoded. Update gEBCDate / gHardStopDate
  in OnStart before each release.

- G-Gate tracker uses static text in lblPGates.
  To make dynamic, replace with Switch on gGate0Xstatus globals.

- KPI snapshot values (60, 41, 12) are static fallbacks.
  Live data from colTasks overrides them after OnStart loads.

---

## 7. File Inventory

| File                   | Lines | Purpose                          |
|------------------------|-------|----------------------------------|
| App_OnStart_v20.fx     | ~193  | Color tokens, data load, globals |
| scrExecutive_v20.yaml  | ~1072 | Executive dashboard screen       |
| scrDetail_v20.yaml     | ~900  | RAID log detail screen           |
| BUILD_NOTES_v20.md     | this  | Documentation                    |

---

## 8. Version History

| Version | Date       | Summary                                           |
|---------|------------|---------------------------------------------------|
| v20.0   | 2026-04-15 | HTML aesthetic upgrade: exact CSS colors, attention strip, RAID badges, progress bars, overdue pills, G-gates, countdowns |
| v19     | 2026-04-14 | Previous baseline                                 |
| v18     | 2026-04-14 | 7 fixes: KPI order, amber tile, accent bar, context band, RAG circles, header split, KPI snapshots |
