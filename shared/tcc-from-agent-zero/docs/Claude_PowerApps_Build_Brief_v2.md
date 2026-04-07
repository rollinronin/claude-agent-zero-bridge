# Claude PowerApps Build Brief
## TCC IS Portfolio Hub — Manual Canvas App Build
### Metropolitan Council IS | GCC High Environment

---

## YOUR ROLE AS CLAUDE

You are helping a government project manager (PT) build a Microsoft Canvas PowerApp manually at **https://make.gov.powerapps.us**.

The goal is to recreate a professional portfolio dashboard that can be embedded in a SharePoint Modern Page via the **Power Apps web part** — this eliminates the "Office presence bar" that appears with standard file embedding.

**How to present each step:**
- Walk through ONE phase at a time
- For every value that needs to be typed or pasted, present it in a **code block** so it's easy to copy
- Confirm PT has completed each phase before moving to the next
- Be patient — PT is doing this manually at their work PC
- If PT gets an error, troubleshoot before continuing

---

## CONTEXT — WHAT WE'RE BUILDING

A Tablet-layout Canvas PowerApp called **TCC IS Portfolio Hub** that shows:
1. Header bar with title, subtitle, and EBC countdown timer
2. Three project status cards (#222 Console Expansion, #193 NG911, #11138 VuWall) with RAG indicators
3. A Construction Gate Active alert banner
4. Live RAID items gallery (connected to SharePoint) with **7 filter buttons** (All, #222, #193, VuWall, Red, Amber, SteerCo)
5. Portfolio at a Glance stats panel
6. Quick Links section with Planner buttons
7. **Light mode by default** with optional Dark mode toggle button
8. **6-tab navigation** (Program Overview, #222 Console, #193 NG911, #11138 VuWall, SteerCo Portal, Documents)
9. **Overlay modal popup** — click RAID count on any project card to see filtered RAID items without leaving the page
10. **Documents tab** — live SharePoint document library browser with search and one-click file launch

This app will be embedded on a SharePoint Executive View page — no Office chrome, full-bleed, professional look.

**Build plan: 17 Phases total**
- Phases 1–13: Core app, cards, RAID gallery, stats, quick links, save & embed
- Phase 14: 6-tab navigation strip
- Phase 15: RAID filter buttons
- Phase 16: Overlay modal (RAID detail popup)
- Phase 17: Documents screen (live library browser)

---

## KEY ENVIRONMENT DETAILS

- **PowerApps URL:** https://make.gov.powerapps.us (GCC High — NOT make.powerapps.com)
- **SharePoint Site:** https://metcmn.sharepoint.com/sites/TCCISPortfolioHub
- **SharePoint List 1:** IS Project RAID
- **SharePoint List 2:** IS Project Tasks
- **App Canvas Size:** Tablet layout (1366 × 768)
- **EBC Go-Live Date:** April 29, 2026

---

## COLOR PALETTE (Reference throughout)

| Name | RGBA Value | Use |
|---|---|---|
| Dark Background | RGBA(10,15,30,1) | Screen fill, dark mode |
| Light Background | RGBA(245,248,252,1) | Screen fill, light mode |
| Met Council Navy | RGBA(0,53,78,1) | Header bar |
| Card Dark | RGBA(0,53,78,0.3) | Card backgrounds (dark mode) |
| Card Light | RGBA(255,255,255,1) | Card backgrounds (light mode) |
| Accent Blue | RGBA(0,84,166,1) | Borders, buttons, accent |
| Green RAG | RGBA(112,173,71,1) | ON TRACK status |
| Amber RAG | RGBA(255,192,0,1) | AT RISK status / countdown |
| Red RAG | RGBA(192,0,0,1) | OFF TRACK / CRITICAL |
| White Text | RGBA(255,255,255,1) | Labels on dark |
| Dark Text | RGBA(10,15,30,1) | Labels on light |
| Gray Subtext | RGBA(180,200,220,1) | Subtitles on dark |
| Gray Subtext Light | RGBA(100,120,140,1) | Subtitles on light |

---

## PHASE 1 — CREATE THE APP
*Expected time: 3 minutes*

Steps to tell PT:
1. Navigate to: https://make.gov.powerapps.us
2. Sign in with Met Council work account
3. Left navigation → click **Apps**
4. Click **+ New app** → select **Canvas**
5. Select **Tablet layout** → click **Create** (wait 30–60 seconds)
6. Click the app name in the top-left → rename to:
```
TCC IS Portfolio Hub
```
7. Press Enter to confirm the name

---

## PHASE 2 — LIGHT BACKGROUND + TOGGLE VARIABLE
*Expected time: 2 minutes*

### Set up the light/dark toggle (do this FIRST before any controls)

The app defaults to **light mode**. The toggle button lets users switch to dark mode if they prefer.

1. Click **Screen1** in the Tree View (left panel)
2. Click on **Screen1** in Tree View
3. In the formula bar, look for the **OnVisible** property
4. Set it to:
```
Set(varDarkMode, false)
```

> ✅ This sets the app to **light mode by default** every time the screen loads. Users can switch to dark mode using the toggle button in the header.

5. Now set the Screen Fill:
   - Click **Screen1** → right panel → **Fill** property
   - Type:
```
If(varDarkMode, RGBA(10,15,30,1), RGBA(245,248,252,1))
```

> 💡 When `varDarkMode` is **false** (default), the screen shows the clean light background. When **true**, it switches to the dark navy background.

---

## PHASE 3 — HEADER BAR
*Expected time: 5 minutes*

### Control 1: Header Rectangle
- Insert → Rectangle → set these properties:

| Property | Value |
|---|---|
| Name | rctHeader |
| X | 0 |
| Y | 0 |
| Width | 1366 |
| Height | 80 |
| Fill | RGBA(0,53,78,1) |

### Control 2: App Title Label
- Insert → Text label

| Property | Value |
|---|---|
| Name | lblAppTitle |
| X | 20 |
| Y | 10 |
| Width | 600 |
| Height | 36 |
| Text (in formula bar) | "TCC IS Portfolio Hub" |
| Font Size | 22 |
| Bold | On |
| Color | RGBA(255,255,255,1) |

### Control 3: Subtitle Label
- Insert → Text label

| Property | Value |
|---|---|
| Name | lblSubtitle |
| X | 20 |
| Y | 46 |
| Width | 700 |
| Height | 24 |
| Text | "Metropolitan Council Infrastructure Services · IS Department" |
| Font Size | 11 |
| Color | RGBA(180,200,220,1) |

### Control 4: EBC Countdown Label
- Insert → Text label

| Property | Value |
|---|---|
| Name | lblCountdown |
| X | 860 |
| Y | 20 |
| Width | 480 |
| Height | 40 |
| Font Size | 13 |
| Bold | On |
| Color | RGBA(255,192,0,1) |
| Align | Right |

For the Text formula (paste this in the formula bar):
```
"⏱ EBC Go-Live: Apr 29, 2026 — " & Text(DateDiff(Today(), Date(2026,4,29), Days)) & " days remaining"
```

### Control 5: Dark/Light Toggle Button
- Insert → Button

| Property | Value |
|---|---|
| Name | btnToggle |
| X | 1230 |
| Y | 90 |
| Width | 120 |
| Height | 30 |
| Font Size | 10 |
| Bold | On |

For Text formula:
```
If(varDarkMode, "☀️ Light Mode", "🌙 Dark Mode")
```

> 💡 When the app is in **light mode** (default, varDarkMode=false), the button shows **🌙 Dark Mode** — inviting the user to switch to dark. When in **dark mode** (varDarkMode=true), it shows **☀️ Light Mode** — to switch back.

For OnSelect formula:
```
Set(varDarkMode, !varDarkMode)
```

For Fill formula:
```
If(varDarkMode, RGBA(0,84,166,1), RGBA(0,53,78,1))
```

For Color:
```
RGBA(255,255,255,1)
```

---

## PHASE 4 — PROJECT STATUS SECTION LABEL

- Insert → Text label

| Property | Value |
|---|---|
| Name | lblSectionProjects |
| X | 20 |
| Y | 135 |
| Width | 600 |
| Height | 24 |
| Text | "PROJECT STATUS — 3 ACTIVE PROJECTS" |
| Font Size | 10 |
| Bold | On |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

---

## PHASE 5 — PROJECT STATUS CARDS
*Build 3 cards. Each card = 4 controls: background rect, title label, detail label, RAG pill rect + RAG pill label*

### CARD 1 — Console Expansion (X origin: 20)

**Card 1 Background Rectangle:**
| Property | Value |
|---|---|
| Name | rctCard1 |
| X | 20 |
| Y | 165 |
| Width | 420 |
| Height | 115 |
| BorderThickness | 1 |
| BorderColor | RGBA(0,84,166,1) |
| Fill formula | If(varDarkMode, RGBA(0,53,78,0.3), RGBA(255,255,255,1)) |
| RadiusTopLeft | 6 |
| RadiusTopRight | 6 |
| RadiusBottomLeft | 6 |
| RadiusBottomRight | 6 |

**Card 1 Title:**
| Property | Value |
|---|---|
| Name | lblCard1Title |
| X | 32 |
| Y | 172 |
| Width | 380 |
| Height | 28 |
| Text | "#222 — Console Expansion & Infrastructure" |
| Font Size | 13 |
| Bold | On |
| Color formula | If(varDarkMode, RGBA(255,255,255,1), RGBA(10,15,30,1)) |

**Card 1 Phase:**
| Property | Value |
|---|---|
| Name | lblCard1Phase |
| X | 32 |
| Y | 200 |
| Width | 380 |
| Height | 20 |
| Text | "Phase 1: EBC Buildout | Hard Stop: Apr 29, 2026" |
| Font Size | 10 |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

**Card 1 Detail:**
| Property | Value |
|---|---|
| Name | lblCard1Detail |
| X | 32 |
| Y | 220 |
| Width | 290 |
| Height | 20 |
| Text | "~35% complete | 8 open RAID" |
| Font Size | 10 |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

**Card 1 RAG Pill (Rectangle):**
| Property | Value |
|---|---|
| Name | rctRAG1 |
| X | 330 |
| Y | 222 |
| Width | 100 |
| Height | 22 |
| Fill | RGBA(112,173,71,1) |
| RadiusTopLeft | 11 |
| RadiusTopRight | 11 |
| RadiusBottomLeft | 11 |
| RadiusBottomRight | 11 |

**Card 1 RAG Label (on top of pill):**
| Property | Value |
|---|---|
| Name | lblRAG1 |
| X | 330 |
| Y | 222 |
| Width | 100 |
| Height | 22 |
| Text | "ON TRACK" |
| Font Size | 9 |
| Bold | On |
| Color | RGBA(255,255,255,1) |
| Align | Center |

---

### CARD 2 — NG911 (X origin: 460)

*Same structure as Card 1 but X starts at 460*

| Control | Name | X | Y | W | H | Key Value |
|---|---|---|---|---|---|---|
| Background | rctCard2 | 460 | 165 | 420 | 115 | Same fill formula as Card 1 |
| Title | lblCard2Title | 472 | 172 | 380 | 28 | "#193 — NG911 Call Handling System" |
| Phase | lblCard2Phase | 472 | 200 | 380 | 20 | "Phase 2: System Design & Bid | Budget: $3.7M" |
| Detail | lblCard2Detail | 472 | 220 | 290 | 20 | "~10% complete | 5 open RAID" |
| RAG Pill | rctRAG2 | 770 | 222 | 100 | 22 | Fill: RGBA(112,173,71,1) |
| RAG Label | lblRAG2 | 770 | 222 | 100 | 22 | "ON TRACK" |

---

### CARD 3 — VuWall (X origin: 900)

| Control | Name | X | Y | W | H | Key Value |
|---|---|---|---|---|---|---|
| Background | rctCard3 | 900 | 165 | 420 | 115 | Same fill formula as Card 1 |
| Title | lblCard3Title | 912 | 172 | 380 | 28 | "#11138 — VuWall Video Wall" |
| Phase | lblCard3Phase | 912 | 200 | 380 | 20 | "Phase 2: Vendor Engagement | PoC Quote Pending" |
| Detail | lblCard3Detail | 912 | 220 | 290 | 20 | "~5% complete | 4 open RAID" |
| RAG Pill | rctRAG3 | 1210 | 222 | 100 | 22 | Fill: RGBA(255,192,0,1) — AMBER |
| RAG Label | lblRAG3 | 1210 | 222 | 100 | 22 | "AT RISK" |

---

## PHASE 6 — ALERT BANNER
*Construction Gate Active warning*

**Alert Background Rectangle:**
| Property | Value |
|---|---|
| Name | rctAlert |
| X | 20 |
| Y | 292 |
| Width | 1326 |
| Height | 44 |
| Fill | RGBA(192,0,0,0.15) |
| BorderColor | RGBA(192,0,0,0.6) |
| BorderThickness | 1 |
| RadiusTopLeft | 4 |
| RadiusTopRight | 4 |
| RadiusBottomLeft | 4 |
| RadiusBottomRight | 4 |

**Alert Label:**
| Property | Value |
|---|---|
| Name | lblAlert |
| X | 32 |
| Y | 292 |
| Width | 1300 |
| Height | 44 |
| Text | "⚠ Construction Gate Active — NTP pending March 2026 | All Final Space IS deliverables blocked | 1:1 Slip Rule in effect" |
| Font Size | 12 |
| Bold | On |
| Color | RGBA(220,80,80,1) |

---

## PHASE 7 — CONNECT SHAREPOINT DATA
*Expected time: 3 minutes*

1. Click the **Data** icon in the left sidebar (looks like a cylinder/database)
2. Click **+ Add data**
3. In the search box, type: `SharePoint`
4. Click **SharePoint** in the results (wait 10–15 seconds)
5. In the URL field, paste:
```
https://metcmn.sharepoint.com/sites/TCCISPortfolioHub
```
6. Click **Connect** (wait 30–60 seconds for connection)
7. Check the box next to **IS Project RAID**
8. Also check the box next to **IS Project Tasks** (if visible)
9. Click **Connect** (wait 20–30 seconds)

✅ You should now see both lists appear in your Data panel.

---

## PHASE 8 — RAID SECTION LABEL

- Insert → Text label

| Property | Value |
|---|---|
| Name | lblSectionRAID |
| X | 20 |
| Y | 350 |
| Width | 400 |
| Height | 24 |
| Text | "OPEN RAID ITEMS" |
| Font Size | 10 |
| Bold | On |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

---

## PHASE 9 — RAID GALLERY
*Expected time: 5 minutes*

1. Insert → Gallery → **Vertical**
2. Set these properties:

| Property | Value |
|---|---|
| Name | galRAID |
| X | 20 |
| Y | 378 |
| Width | 820 |
| Height | 340 |

3. Click the gallery border → find **Items** property in formula bar → paste:
```
SortByColumns('IS Project RAID', "Modified", Descending)
```

4. Set gallery Fill formula:
```
If(varDarkMode, RGBA(0,20,40,0.5), RGBA(240,245,255,1))
```

5. Click the **Edit (pencil) icon** inside the gallery to enter edit mode

6. Click **Title** (Label 1) → set Text to:
```
ThisItem.Title
```
Font Size: `13` | Bold: On | Color formula:
```
If(varDarkMode, RGBA(255,255,255,1), RGBA(10,15,30,1))
```

7. Click **Subtitle** (Label 2) → set Text to:
```
ThisItem.RAIDType & " | " & ThisItem.RAG & " | " & ThisItem.Project & " | Due: " & Text(ThisItem.DueDate, "mmm d, yyyy")
```
Font Size: `10` | Color formula:
```
If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1))
```

8. Click outside gallery to exit edit mode

> ⚠️ **Troubleshoot note for Claude:** If column names like `RAIDType`, `RAG`, `Project`, `DueDate` show errors, tell PT to check the exact column internal names by going to: SharePoint list → Settings → List Settings → each column → the name in the URL is the internal name. Common variants: `RAID_x0020_Type`, `RAG_x0020_Status`

---

## PHASE 10 — PORTFOLIO AT A GLANCE PANEL
*Right side stats panel*

**Panel Background:**
| Property | Value |
|---|---|
| Name | rctGlance |
| X | 858 |
| Y | 350 |
| Width | 488 |
| Height | 340 |
| Fill formula | If(varDarkMode, RGBA(0,53,78,0.3), RGBA(255,255,255,1)) |
| BorderColor | RGBA(0,84,166,1) |
| BorderThickness | 1 |
| RadiusTopLeft | 6 |
| RadiusTopRight | 6 |
| RadiusBottomLeft | 6 |
| RadiusBottomRight | 6 |

**Panel Title:**
| Property | Value |
|---|---|
| Name | lblGlanceTitle |
| X | 870 |
| Y | 358 |
| Width | 460 |
| Height | 24 |
| Text | "Portfolio at a Glance" |
| Font Size | 12 |
| Bold | On |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

**Stat 1 — Red Items (top-left of panel):**
| Property | Value |
|---|---|
| Name | lblStatRed |
| X | 870 |
| Y | 390 |
| Width | 230 |
| Height | 60 |
| Font Size | 36 |
| Bold | On |
| Color | RGBA(192,0,0,1) |

Text formula:
```
Text(CountIf('IS Project RAID', RAG = "Red"))
```

**Stat 1 Label:**
| Property | Value |
|---|---|
| Name | lblStatRedLabel |
| X | 870 |
| Y | 450 |
| Width | 230 |
| Height | 20 |
| Text | "Red Items" |
| Font Size | 11 |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

**Stat 2 — Amber Items (top-right of panel):**
*Same as Stat 1 but X: 1100, Color: RGBA(255,192,0,1)*

Text formula:
```
Text(CountIf('IS Project RAID', RAG = "Amber"))
```

**Stat 3 — Total Open (bottom-left):**
*X: 870, Y: 490, Color: White/Dark, Font Size: 36*

Text formula:
```
Text(CountRows('IS Project RAID'))
```

**Stat 4 — Decisions Pending (bottom-right):**
*X: 1100, Y: 490*

Text formula:
```
Text(CountIf('IS Project RAID', RAIDType = "Decision"))
```

**EBC Target Label:**
| Property | Value |
|---|---|
| Name | lblEBCTarget |
| X | 870 |
| Y | 570 |
| Width | 460 |
| Height | 50 |
| Text | "EBC Go-Live Target" |
| Font Size | 11 |
| Color formula | If(varDarkMode, RGBA(180,200,220,1), RGBA(100,120,140,1)) |

**EBC Date:**
| Property | Value |
|---|---|
| Name | lblEBCDate |
| X | 870 |
| Y | 592 |
| Width | 230 |
| Height | 30 |
| Text | "April 29, 2026" |
| Font Size | 16 |
| Bold | On |
| Color | RGBA(255,192,0,1) |

**Days Remaining (large):**
| Property | Value |
|---|---|
| Name | lblDaysRemaining |
| X | 1100 |
| Y | 575 |
| Width | 230 |
| Height | 60 |
| Font Size | 36 |
| Bold | On |
| Color | RGBA(255,192,0,1) |

Text formula:
```
Text(DateDiff(Today(), Date(2026,4,29), Days))
```

---

## PHASE 11 — QUICK LINKS SECTION

**Section Label:**
| Property | Value |
|---|---|
| Name | lblQuickLinksTitle |
| X | 858 |
| Y | 700 |
| Width | 460 |
| Height | 24 |
| Text | "Quick Links" |
| Font Size | 12 |
| Bold | On |

**Button 1 — Open Full RAID Log:**
| Property | Value |
|---|---|
| Name | btnRAIDLog |
| X | 858 |
| Y | 726 |
| Width | 235 |
| Height | 34 |
| Text | "📋 Open Full RAID Log" |
| Font Size | 11 |
| Fill | RGBA(0,84,166,1) |
| Color | RGBA(255,255,255,1) |

OnSelect formula:
```
Launch("https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Project%20RAID")
```

**Button 2 — IS Project Tasks:**
| Property | Value |
|---|---|
| Name | btnTasks |
| X | 1103 |
| Y | 726 |
| Width | 235 |
| Height | 34 |
| Text | "✅ IS Project Tasks" |
| Font Size | 11 |
| Fill | RGBA(0,84,166,1) |
| Color | RGBA(255,255,255,1) |

OnSelect formula:
```
Launch("https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Project%20Tasks")
```

**Button 3 — Open #222 in Planner:**
| Property | Value |
|---|---|
| Name | btnPlanner222 |
| X | 858 |
| Y | 768 |
| Width | 235 |
| Height | 34 |
| Text | "📌 #222 Planner Plan" |
| Font Size | 11 |
| Fill | RGBA(0,53,78,1) |
| Color | RGBA(255,255,255,1) |

OnSelect formula:
```
Launch("https://tasks.office.com/metcmn.onmicrosoft.com/en-US/Home/Planner/#/plantaskboard?groupId=&planId=a9148b0d-0b5d-4e0c-a684-681962cc4f9d")
```

**Button 4 — Open #193 in Planner:**
| Property | Value |
|---|---|
| Name | btnPlanner193 |
| X | 1103 |
| Y | 768 |
| Width | 235 |
| Height | 34 |
| Text | "📌 #193 Planner Plan" |
| Font Size | 11 |
| Fill | RGBA(0,53,78,1) |
| Color | RGBA(255,255,255,1) |

OnSelect formula:
```
Launch("https://tasks.office.com/metcmn.onmicrosoft.com/en-US/Home/Planner/#/plantaskboard?groupId=&planId=7b0e9802-96c1-4f2a-9bb6-15620af016c8")
```

---

## PHASE 12 — SAVE & PUBLISH

1. Press **Ctrl + S** to save
2. Confirm the app name is **TCC IS Portfolio Hub**
3. Click **Publish** in the top toolbar
4. Click **Publish this version**
5. Wait 30–60 seconds

---

## PHASE 13 — EMBED IN SHAREPOINT

1. In PowerApps, click **Apps** in left nav
2. Find **TCC IS Portfolio Hub** → click the **3 dots (...)** → **Details**
3. Copy the **App ID** (long GUID in the URL or Details panel)
4. Go to your SharePoint Executive View page
5. Click **Edit** (top right)
6. Click **+** to add a web part → search: **Power Apps**
7. Select **Power Apps** web part
8. Paste the App ID
9. Resize the web part to fill the section
10. Click **Publish** on the SharePoint page

✅ **Result: Your dashboard displays with ZERO Office chrome. Full-bleed. Professional.**

---

## PHASE 14 — TAB NAVIGATION (6 Tabs)
*Expected time: 8 minutes*

Create 6 tab buttons across the top of the app (below the header, above the project cards). Each tab switches the visible content area using a variable.

### Tab variable setup
In Screen1 OnVisible formula, **replace** the existing formula with:
```
Set(varDarkMode, false); Set(varActiveTab, "Overview")
```

### Tab button strip — Rectangle background
Insert Rectangle:

| Property | Value |
|---|---|
| Name | rctTabBar |
| X | 0 |
| Y | 80 |
| Width | 1366 |
| Height | 44 |
| Fill | If(varDarkMode, RGBA(0,30,50,1), RGBA(220,232,242,1)) |
| BorderThickness | 0 |

### Tab Button 1 — Program Overview
Insert Button:

| Property | Value |
|---|---|
| Name | btnTabOverview |
| X | 0 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "📊 Program Overview" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="Overview", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="Overview", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "Overview")
```

### Tab Button 2 — #222 Console
Insert Button:

| Property | Value |
|---|---|
| Name | btnTab222 |
| X | 200 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "#222 Console" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="222", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="222", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "222")
```

### Tab Button 3 — #193 NG911
Insert Button:

| Property | Value |
|---|---|
| Name | btnTab193 |
| X | 400 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "#193 NG911" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="193", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="193", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "193")
```

### Tab Button 4 — #11138 VuWall
Insert Button:

| Property | Value |
|---|---|
| Name | btnTabVuWall |
| X | 600 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "#11138 VuWall" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="VuWall", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="VuWall", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "VuWall")
```

### Tab Button 5 — SteerCo Portal
Insert Button:

| Property | Value |
|---|---|
| Name | btnTabSteerCo |
| X | 800 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "📋 SteerCo" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="SteerCo", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="SteerCo", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "SteerCo")
```

### Tab Button 6 — Documents
Insert Button:

| Property | Value |
|---|---|
| Name | btnTabDocs |
| X | 1000 |
| Y | 80 |
| Width | 200 |
| Height | 44 |
| Text | "📁 Documents" |
| Size | 11 |
| Bold | On |
| Fill | If(varActiveTab="Documents", RGBA(0,84,166,1), Transparent) |
| Color | If(varActiveTab="Documents", RGBA(255,255,255,1), If(varDarkMode, RGBA(180,200,220,1), RGBA(0,53,78,1))) |
| BorderThickness | 0 |

OnSelect:
```
Set(varActiveTab, "Documents")
```

### Show/Hide content sections
All existing content (project cards, RAID gallery, stats panel, quick links) goes in a Group:
- Name: **grpOverview**
- Visible formula:
```
varActiveTab = "Overview"
```

This means when user clicks another tab, the overview content hides. Other tab screens (Phases 15–17) use the same pattern with their own groups.

> 📐 **Y-coordinate adjustment:** Push all existing content down by 44px to accommodate the tab bar. Any content that was at Y:80 now starts at Y:124. Apply a **+44 offset** to all controls that previously sat below Y:80 (section labels, cards, alert banner, gallery, stats panel, quick links).

---

## PHASE 15 — RAID FILTER BUTTONS
*Expected time: 5 minutes*

Add 7 filter buttons above the RAID gallery. Replace the static section label with interactive filters.

### Filter variable
In Screen1 OnVisible, **replace** the formula with:
```
Set(varDarkMode, false); Set(varActiveTab, "Overview"); Set(varRAIDFilter, "All")
```

### Filter button strip
Insert 7 buttons in a horizontal row above galRAID:

| Name | X | Y | W | H | Text | Filter Value |
|---|---|---|---|---|---|---|
| btnFilterAll | 20 | (above gallery — adjust to gallery Y - 36) | 50 | 28 | "All" | "All" |
| btnFilter222 | 75 | same row | 50 | 28 | "#222" | "222" |
| btnFilter193 | 130 | same row | 50 | 28 | "#193" | "193" |
| btnFilterVuWall | 185 | same row | 70 | 28 | "VuWall" | "VuWall" |
| btnFilterRed | 260 | same row | 65 | 28 | "🔴 Red" | "Red" |
| btnFilterAmber | 330 | same row | 75 | 28 | "🟡 Amber" | "Amber" |
| btnFilterSteerCo | 410 | same row | 85 | 28 | "📊 SteerCo" | "SteerCo" |

All filter buttons share these properties (substitute the correct Filter Value for each):
- Size: 10 | Bold: On
- Fill: `If(varRAIDFilter="<FilterValue>", RGBA(0,84,166,1), RGBA(0,53,78,0.2))`
- Color: `RGBA(255,255,255,1)`
- BorderThickness: 0
- RadiusTopLeft / TopRight / BottomLeft / BottomRight: 14
- OnSelect: `Set(varRAIDFilter, "<FilterValue>")`

### Update galRAID Items formula
Click **galRAID** → **Items** property → replace with:
```
Switch(varRAIDFilter,
  "222",      Filter('IS Project RAID', Project = "#222 Console Expansion"),
  "193",      Filter('IS Project RAID', Project = "#193 NG911 Refresh"),
  "VuWall",   Filter('IS Project RAID', Project = "#11138 VuWall"),
  "Red",      Filter('IS Project RAID', RAG = "Red"),
  "Amber",    Filter('IS Project RAID', RAG = "Amber"),
  "SteerCo",  Filter('IS Project RAID', SteerCoTag = true),
              'IS Project RAID'
)
```

---

## PHASE 16 — OVERLAY MODAL (Click RAID Count → Popup)
*Expected time: 8 minutes*

When user clicks the RAID count on a project card (e.g. "8 open RAID" on #222), an overlay panel slides in showing filtered RAID items for that project. User clicks X to close. Never leaves the page.

### Overlay variables
In Screen1 OnVisible, **replace** the formula with:
```
Set(varDarkMode, false); Set(varActiveTab, "Overview"); Set(varRAIDFilter, "All"); Set(varShowOverlay, false); Set(varOverlayProject, "")
```

### Make RAID count labels on project cards clickable
For each project card, find the RAID count label (e.g. lblCard1Detail showing "8 open RAID").

Change its **OnSelect** property to:
```
Set(varOverlayProject, "#222 Console Expansion"); Set(varShowOverlay, true)
```
*(Use the correct project name string for each card)*

Also:
- Change **BorderThickness** to 1
- Add underline styling to signal it's clickable

### Overlay dim background
Insert Rectangle:

| Property | Value |
|---|---|
| Name | rctOverlayDim |
| X | 0 |
| Y | 0 |
| Width | 1366 |
| Height | 768 |
| Fill | RGBA(0,0,0,0.6) |
| Visible | varShowOverlay |
| OnSelect | Set(varShowOverlay, false) |

> ⚠️ **IMPORTANT:** This control must be at the **TOP of the Tree View** (front layer). Right-click → Reorder → **Bring to Front**. All overlay controls must also be brought to front.

### Overlay panel
Insert Rectangle:

| Property | Value |
|---|---|
| Name | rctOverlayPanel |
| X | 183 |
| Y | 84 |
| Width | 1000 |
| Height | 600 |
| Fill | If(varDarkMode, RGBA(10,25,45,1), RGBA(245,248,252,1)) |
| BorderColor | RGBA(0,84,166,1) |
| BorderThickness | 1 |
| RadiusTopLeft / TopRight / BottomLeft / BottomRight | 8 |
| Visible | varShowOverlay |

### Overlay title
Insert Label:

| Property | Value |
|---|---|
| Name | lblOverlayTitle |
| X | 203 |
| Y | 100 |
| Width | 700 |
| Height | 36 |
| Text | varOverlayProject & " — Open RAID Items" |
| Size | 18 |
| Bold | On |
| Color | If(varDarkMode, RGBA(255,255,255,1), RGBA(10,15,30,1)) |
| Visible | varShowOverlay |

### Overlay close button
Insert Button:

| Property | Value |
|---|---|
| Name | btnOverlayClose |
| X | 1133 |
| Y | 100 |
| Width | 40 |
| Height | 36 |
| Text | "✕" |
| Size | 16 |
| Bold | On |
| Fill | RGBA(192,0,0,1) |
| Color | RGBA(255,255,255,1) |
| BorderThickness | 0 |
| OnSelect | Set(varShowOverlay, false) |
| Visible | varShowOverlay |

### Overlay RAID gallery
Insert Gallery → Vertical:

| Property | Value |
|---|---|
| Name | galOverlayRAID |
| X | 203 |
| Y | 150 |
| Width | 960 |
| Height | 490 |
| Visible | varShowOverlay |

Items formula:
```
Filter('IS Project RAID', Project = varOverlayProject)
```

Inside gallery template (click Edit pencil):
- **Label 1 (title):** `ThisItem.Title` | Size: 13 | Bold: On | Color: `If(varDarkMode, RGBA(255,255,255,1), RGBA(10,15,30,1))`
- **Label 2 (meta):** `ThisItem.RAIDType & " | " & ThisItem.RAG & " | Owner: " & ThisItem.Owner` | Size: 10 | Color: gray subtext
- **Label 3 (dates):** `"Raised: " & Text(ThisItem.DateRaised, "mmm dd") & " | Target: " & Text(ThisItem.TargetDate, "mmm dd")` | Size: 10
- **Rectangle (RAG indicator):** W: 8 | H: full template height | Fill: `Switch(ThisItem.RAG, "Red", RGBA(192,0,0,1), "Amber", RGBA(255,192,0,1), RGBA(112,173,71,1))`
- **Template fill:** `If(varDarkMode, RGBA(0,53,78,0.2), RGBA(255,255,255,1))`
- **TemplatePadding:** 8

### Open in SharePoint button (in overlay)
Insert Button:

| Property | Value |
|---|---|
| Name | btnOverlayOpenSP |
| X | 203 |
| Y | 650 |
| Width | 240 |
| Height | 36 |
| Text | "🔗 Open in SharePoint" |
| Fill | RGBA(0,84,166,1) |
| Color | RGBA(255,255,255,1) |
| Visible | varShowOverlay |

OnSelect:
```
Launch("https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Project%20RAID")
```

---

## PHASE 17 — DOCUMENTS SCREEN (Live Library Browser)
*Expected time: 8 minutes*

A Documents view that appears when user clicks the Documents tab. Shows live files from SharePoint document library with search — user can click any file to open in a new tab without leaving the app.

### Add SharePoint document library as data source
1. Left sidebar → **Data** → **+ Add data** → **SharePoint**
2. Same site URL:
```
https://metcmn.sharepoint.com/sites/TCCISPortfolioHub
```
3. Check: **Documents** (or **Shared Documents** — whatever your library is named)
4. Click **Connect**

### Documents container
Insert Rectangle:

| Property | Value |
|---|---|
| Name | rctDocsContainer |
| X | 0 |
| Y | 124 |
| Width | 1366 |
| Height | 644 |
| Fill | Transparent |
| Visible | varActiveTab = "Documents" |

### Search box
Insert Text Input:

| Property | Value |
|---|---|
| Name | txtDocSearch |
| X | 20 |
| Y | 134 |
| Width | 400 |
| Height | 36 |
| PlaceholderText | "Search documents..." |
| Fill | If(varDarkMode, RGBA(0,30,50,1), RGBA(255,255,255,1)) |
| Color | If(varDarkMode, RGBA(255,255,255,1), RGBA(10,15,30,1)) |
| BorderColor | RGBA(0,84,166,1) |
| Visible | varActiveTab = "Documents" |

### Documents gallery
Insert Gallery → Vertical:

| Property | Value |
|---|---|
| Name | galDocuments |
| X | 20 |
| Y | 178 |
| Width | 1326 |
| Height | 570 |
| Visible | varActiveTab = "Documents" |

Items formula:
```
Filter(Documents, StartsWith(Name, txtDocSearch.Text) || txtDocSearch.Text = "")
```
*(Adjust `Documents` to match the exact name shown in your Data panel — may be `Shared Documents`)*

Inside gallery template:
- **Icon (file type):** Insert → Icon → Document icon
- **Label 1 (filename):** `ThisItem.Name` | Size: 13 | Bold: On
- **Label 2 (modified):** `"Modified: " & Text(ThisItem.'{Modified}', "mmm dd yyyy") & " by " & ThisItem.Editor.DisplayName` | Size: 10
- **Label 3 (path hint):** `Left(ThisItem.FullPath, 60) & "..."` | Size: 9 | Color: gray
- **Template OnSelect (whole row clickable):**
```
Launch(ThisItem.'{Link}')
```
*Opens file in a new browser tab — user stays in the portal*
- **TemplateFill:** `If(varDarkMode, If(IsEven(ThisItemIndex), RGBA(0,53,78,0.15), RGBA(0,53,78,0.25)), If(IsEven(ThisItemIndex), RGBA(245,248,252,1), RGBA(230,238,246,1)))`
- **TemplateSize:** 64

### No-results message
Insert Label:

| Property | Value |
|---|---|
| Name | lblNoDocsFound |
| X | 20 |
| Y | 300 |
| Width | 600 |
| Height | 40 |
| Text | "No documents found matching '" & txtDocSearch.Text & "'" |
| Size | 14 |
| Color | RGBA(100,120,140,1) |
| Visible | varActiveTab="Documents" && CountRows(galDocuments.AllItems) = 0 |

---

## TROUBLESHOOTING GUIDE FOR CLAUDE

| Problem | Fix |
|---|---|
| Gallery shows no data / error on Items | Wrap list name in single quotes: `'IS Project RAID'` |
| Column name error in gallery | Check actual internal name: SP List → Settings → Column → look at URL `Field=XXXX` |
| RAIDType column not found | Try: `RAID_x0020_Type` or `RAIDType` or `Type` |
| RAG column not found | Try: `RAG_x0020_Status` or `Status` |
| Formula error on CountIf | Verify column name matches exactly — it's case-sensitive |
| Color not applying | Make sure format is `RGBA(0,53,78,1)` — no spaces in RGBA |
| Toggle button not changing theme | Verify `OnVisible` of Screen1 has `Set(varDarkMode, false)` and toggle OnSelect is `Set(varDarkMode, !varDarkMode)` |
| Can't connect to SharePoint | Verify Met Council work account is signed in; try refreshing Data panel |
| Launch() button not working | In GCC, Launch() may need a confirmation — this is normal security behavior |
| Controls overlapping | Use Tree View to reorder; bring labels to front via right-click → Reorder |
| App looks squished | Confirm Tablet layout 1366×768 was selected at creation |
| Tab buttons not hiding content | Wrap all Overview content in a Group, set Group Visible = `varActiveTab="Overview"` |
| Overlay appears behind content | Tree View → rctOverlayDim and all overlay controls → right-click → Bring to Front |
| RAID filter shows wrong items | Check Project column exact values in your SP list — strings must match exactly |
| Documents gallery empty | Check data source name — use exact name shown in Data panel (may be `Shared Documents`) |
| Launch() asks for confirmation | Normal GCC behavior — click Allow. Cannot be disabled in GCC High. |
| Gallery flickers on tab switch | Normal — SharePoint data refreshes on view. Add a loading spinner if needed. |

---

## NOTES FOR CLAUDE ON INTERACTION STYLE

- Present **one phase at a time**
- For each control, show all properties in a **table** with a **code block for each value that needs to be typed**
- After each phase, ask: *"Phase X complete? Ready for Phase Y?"*
- If PT reports an error, ask them to describe or paste the exact error before suggesting a fix
- PT is NOT a developer — explain what each thing does in plain English
- The most common errors in GCC PowerApps: column name mismatches in formulas, single quotes required around list names, RGBA format must be exact
- Encourage PT — this is 17 phases but each one is simple and the result is worth it!
- **Phases 14–17 are advanced features** — confirm PT wants to proceed with each before starting. They can stop at Phase 13 for a fully functional app and add these enhancements later.

---
*TCC IS Portfolio Program | Metropolitan Council IS | Generated by Agent Zero*
