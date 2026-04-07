# TCC IS Portfolio Hub — Power Apps Quick Reference
_GCC High: make.gov.powerapps.us | Tablet 1366×768 | ~30 min_

## Colors
| Name | Value |
|---|---|
| Dark BG | `RGBA(10,15,30,1)` |
| Navy | `RGBA(0,53,78,1)` |
| Accent Blue | `RGBA(0,84,166,1)` |
| Green | `RGBA(112,173,71,1)` |
| Amber | `RGBA(255,192,0,1)` |
| Red | `RGBA(192,0,0,1)` |
| White | `RGBA(255,255,255,1)` |
| Light Gray | `RGBA(180,200,220,1)` |

---

## Steps

**1.** Go to `https://make.gov.powerapps.us` — sign in with Met Council account

**2.** Left nav → **Apps**

**3.** **+ New app** → **Canvas**

**4.** Select **Tablet layout** → **Create** _(wait 30–60 sec to load)_

**5.** Click app name (top-left) → rename to `TCC IS Portfolio Hub` → Enter

---

**6.** Tree View → click **Screen1**

**7.** Right panel → **Fill** → `RGBA(10,15,30,1)` → Enter _(screen goes dark)_

---

**8.** **Insert → Rectangle** | X:`0` Y:`0` W:`1366` H:`80` | Fill:`RGBA(0,53,78,1)` | Rename:`rctHeader`

**9.** **Insert → Label** | X:`20` Y:`12` W:`600` H:`40` | Text:`"TCC IS Portfolio Hub"` | Size:`22` Bold | Color:White | Rename:`lblAppTitle`

**10.** **Insert → Label** | X:`20` Y:`48` W:`500` H:`25` | Text:`"Metropolitan Council IS"` | Size:`12` | Color:Light Gray | Rename:`lblSubtitle`

**11.** **Insert → Label** | X:`900` Y:`22` W:`440` H:`36` | Size:`14` Bold | Color:Amber | Align:Right | Rename:`lblCountdown`
  - Text formula: `"EBC Go-Live: Apr 29, 2026 — " & Text(DateDiff(Today(), Date(2026,4,29), Days)) & " days remaining"`

**12.** **Insert → Label** | X:`20` Y:`95` W:`300` H:`28` | Text:`"PROJECT STATUS"` | Size:`11` Bold | Color:Light Gray | Rename:`lblSectionProjects`

---

### Card 1 — #222 Console Expansion (X origin: 20)

**13.** **Insert → Rectangle** | X:`20` Y:`128` W:`420` H:`110` | Fill:`RGBA(0,53,78,0.3)` | BorderColor:`RGBA(0,84,166,1)` | Border:`1` | Rename:`rctCard1`

**14.** **Insert → Label** | X:`30` Y:`135` W:`350` H:`26` | Text:`"#222 — Console Expansion & Infrastructure"` | Size:`14` Bold | Color:White | Rename:`lblCard1Title`

**15.** **Insert → Label** | X:`30` Y:`162` W:`350` H:`22` | Text:`"Phase 1: EBC Buildout | Hard Stop: Apr 29, 2026"` | Size:`11` | Color:Light Gray | Rename:`lblCard1Phase`

**16.** **Insert → Label** | X:`30` Y:`186` W:`260` H:`20` | Text:`"Assessment & Requirements ~35% complete"` | Size:`10` | Color:Light Gray | Rename:`lblCard1Detail`

**17.** **Insert → Rectangle** | X:`340` Y:`188` W:`90` H:`22` | Fill:`RGBA(112,173,71,1)` | All Radius:`11` | Rename:`rctRAG1`

**18.** **Insert → Label** | X:`340` Y:`188` W:`90` H:`22` | Text:`"ON TRACK"` | Size:`9` Bold | Color:White | Align:Center | Rename:`lblRAG1`

---

### Card 2 — #193 NG911 (X origin: 460)

**19.** **Insert → Rectangle** | X:`460` Y:`128` W:`420` H:`110` | Fill:`RGBA(0,53,78,0.3)` | BorderColor:`RGBA(0,84,166,1)` | Border:`1` | Rename:`rctCard2`

**20.** **Insert → Label** | X:`470` Y:`135` W:`350` H:`26` | Text:`"#193 — NG911 Call Handling System"` | Size:`14` Bold | Color:White | Rename:`lblCard2Title`

**21.** **Insert → Label** | X:`470` Y:`162` W:`350` H:`22` | Text:`"Phase 2: System Design & Bid | Budget: $3.7M"` | Size:`11` | Color:Light Gray | Rename:`lblCard2Phase`

**22.** **Insert → Label** | X:`470` Y:`186` W:`260` H:`20` | Text:`"FE Workshop: Mar 13 | ~10% complete"` | Size:`10` | Color:Light Gray | Rename:`lblCard2Detail`

**23.** **Insert → Rectangle** | X:`780` Y:`188` W:`90` H:`22` | Fill:`RGBA(112,173,71,1)` | All Radius:`11` | Rename:`rctRAG2`

**24.** **Insert → Label** | X:`780` Y:`188` W:`90` H:`22` | Text:`"ON TRACK"` | Size:`9` Bold | Color:White | Align:Center | Rename:`lblRAG2`

---

### Card 3 — #11138 VuWall (X origin: 900)

**25.** **Insert → Rectangle** | X:`900` Y:`128` W:`420` H:`110` | Fill:`RGBA(0,53,78,0.3)` | BorderColor:`RGBA(0,84,166,1)` | Border:`1` | Rename:`rctCard3`

**26.** **Insert → Label** | X:`910` Y:`135` W:`350` H:`26` | Text:`"#11138 — VuWall Video Wall"` | Size:`14` Bold | Color:White | Rename:`lblCard3Title`

**27.** **Insert → Label** | X:`910` Y:`162` W:`350` H:`22` | Text:`"Phase 2: Vendor Engagement | PoC Quote Pending"` | Size:`11` | Color:Light Gray | Rename:`lblCard3Phase`

**28.** **Insert → Label** | X:`910` Y:`186` W:`260` H:`20` | Text:`"Awaiting SHI PoC quote | ~5% complete"` | Size:`10` | Color:Light Gray | Rename:`lblCard3Detail`

**29.** **Insert → Rectangle** | X:`1220` Y:`188` W:`90` H:`22` | Fill:`RGBA(112,173,71,1)` | All Radius:`11` | Rename:`rctRAG3`

**30.** **Insert → Label** | X:`1220` Y:`188` W:`90` H:`22` | Text:`"ON TRACK"` | Size:`9` Bold | Color:White | Align:Center | Rename:`lblRAG3`

---

**31.** **Insert → Label** | X:`20` Y:`255` W:`300` H:`28` | Text:`"RAID LOG"` | Size:`11` Bold | Color:Light Gray | Rename:`lblSectionRAID`

---

### Add SharePoint Data Source

**32.** Left panel → **Data** icon (cylinder shape) — OR — **View** tab → **Data sources**

**33.** Click **+ Add data**

**34.** Search box → type `SharePoint` → click **SharePoint** in results _(wait 10–15 sec)_

**35.** URL field → type `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub` → **Connect** _(wait 30–60 sec)_

**36.** Check ✅ **IS Project RAID** → click **Connect** _(wait 20–30 sec — list loads)_

---

### Add RAID Gallery

**37.** **Insert → Gallery → Vertical**

**38.** X:`20` Y:`288` W:`1326` H:`440` | Rename:`galRAID`

**39.** Click gallery border → formula bar → **Items** property → type `'IS Project RAID'` → Enter _(wait 15–30 sec)_

**40.** Click inside gallery → click **Edit (pencil)** icon → click **Label 1**
  - Formula bar → Text = `ThisItem.Title` → Enter

**41.** Click **Label 2** → Text formula:
  - `ThisItem.RAIDType & " | " & ThisItem.RAG & " | Due: " & Text(ThisItem.DueDate, "mmm d, yyyy")` → Enter

**42.** Click outside gallery to exit edit mode

**43.** Gallery Fill: `RGBA(0,53,78,0.15)` | BorderColor: `RGBA(0,84,166,0.5)` | Border: `1`

---

### Save & Publish

**44.** **Ctrl + S** → confirm name → **Save** _(wait 30–60 sec)_

**45.** **File** (top-left) → **Publish** → **Publish this version** → confirm _(wait 30–60 sec)_

**46.** Click ← back or ▶ Play to preview

---

## Troubleshoot
| Problem | Fix |
|---|---|
| Gallery shows no data | Items = `'IS Project RAID'` — single quotes required |
| Color not applying | Format: `RGBA(0,53,78,1)` — no spaces, exact case |
| Red formula error in gallery | Column name may differ — try `ThisItem.RAID_x0020_Type` |
| Can't connect to SharePoint | Verify you're logged in as Met Council account; refresh Data panel |
| Formula error on text labels | All static text needs double quotes: `"like this"` |
| Gallery column name error | Open SP list settings to confirm exact internal column names |

---
_TCC IS Portfolio Program | Metropolitan Council IS | March 2026_
