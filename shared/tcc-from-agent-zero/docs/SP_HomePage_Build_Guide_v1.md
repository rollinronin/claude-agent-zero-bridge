# TCC IS Portfolio Hub — Home.aspx Build Guide
**Page:** https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/SitePages/Home.aspx  
**Date:** 2026-04-02  
**Author:** AI-generated build guide for PT Tat-Siaka  
**Constraint:** Native web parts only — Text, Quick Links, Document Library, Divider. No embed/script.

---

## PRE-FLIGHT
1. Open Edge/Chrome on your home PC
2. Navigate to: `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/SitePages/Home.aspx`
3. Click **Edit** (top right) — page enters edit mode
4. If the page already has content, you'll be editing in place. Scroll to assess what exists.
5. Keep this guide open in a second tab.

> **SAVE STRATEGY:** Use **Ctrl+S** (or the Save button) frequently. Save as Draft at the end — NOT Publish.

---

## SECTION LAYOUT OVERVIEW

| # | Background | Columns | Web Part(s) |
|---|---|---|---|
| 1 | **Dark** | 1 | Text — Site header / RAG status |
| 2 | **Soft/Accent** | 1 | Text — Construction Gate notice |
| 3 | **White/Default** | **3** | Text × 3 — Project cards |
| 4 | **Default** | **2** | Quick Links (left) + Text (right) |
| 5 | **Default** | 1 | Document Library |

---

## SECTION 1 — Dark Background, Single Column
### Header / RAG Status Banner

**Add/configure the section:**
1. Click **+ Add section** (or use an existing top section)
2. Choose **One column** layout
3. Click the section's **paint bucket / background** icon (appears when you hover the left edge of the section)
4. Select **Dark** (darkest tile)

**Add a Text web part:**
1. Click **+** inside the section → choose **Text**
2. In the text editor, enter:

```
METROPOLITAN COUNCIL · INFRASTRUCTURE SERVICES
Transit Control Center — IS Project Portfolio
Three active projects · Construction-dependent schedule · NTP pending
● EXP — AMBER   ● NG911 — GREEN   ● VUW — AMBER
```

**Format each line:**
| Line | Text | Formatting |
|---|---|---|
| Line 1 | `METROPOLITAN COUNCIL · INFRASTRUCTURE SERVICES` | Select text → set size to **Small** (or use Paragraph styles → Normal) |
| Line 2 | `Transit Control Center — IS Project Portfolio` | Select text → **Heading 2** style, ensure **Bold** |
| Line 3 | `Three active projects · Construction-dependent schedule · NTP pending` | Normal / default |
| Line 4 | `● EXP — AMBER   ● NG911 — GREEN   ● VUW — AMBER` | Normal, then apply highlights (see below) |

**Apply text highlights on Line 4:**
- Select only `EXP — AMBER` → click the **highlight color** button (looks like `A` with color swatch) → choose **Yellow** or **Orange**
- Select only `NG911 — GREEN` → apply **Green** highlight
- Select only `VUW — AMBER` → apply **Yellow** or **Orange** highlight

> **Tip:** The highlight button is in the floating text toolbar that appears when you select text. It may be under the `...` overflow menu.

---

## SECTION 2 — Soft/Accent Background, Single Column
### Construction Gate Notice

**Add the section:**
1. Click **+** below Section 1 → **Add section** → **One column**
2. Set background: click paint bucket → choose **Soft** (light gray/accent — second tile usually)

**Add a Text web part:**
1. Add **Text** web part inside section
2. Type the full text:

```
▲ CONSTRUCTION GATE ACTIVE — Notice to Award pending. Working assumption: construction September 2026, avoiding MN State Fair. All IS milestone dates derive from construction schedule. 1:1 Slip Rule applies.
```

**Format:**
- Select `▲ CONSTRUCTION GATE ACTIVE —` → apply **Bold**
- Select the ENTIRE block → look in the toolbar for a **Quote** or **Blockquote** style option. If available, apply it. If not available, that's okay — the background color provides visual separation.

---

## SECTION 3 — White/Default Background, THREE Columns
### Project Cards

**Add the section:**
1. **+** below Section 2 → **Add section** → **Three columns** layout
2. Background: **Default** (white / no color)

---

### Column 1 — EXP Card
**Add Text web part in left column:**

Type:
```
EXP · IS LEAD
TCC Console Expansion
● AMBER · NTP Pending
PC refresh for 30 consoles. 60 IS PCs total (Council + MTPD networks). Construction-dependent. Temporary space: EBC Room 1007.
926 WBS Tasks | Gate: NTP Pending
```

Formatting:
| Line | Formatting |
|---|---|
| `EXP · IS LEAD` | **Small** text size |
| `TCC Console Expansion` | **Heading 2** or Bold + larger |
| `● AMBER · NTP Pending` | Normal; select `AMBER · NTP Pending` → **Yellow/Orange** highlight |
| Body paragraph | Normal |
| `926 WBS Tasks \| Gate: NTP Pending` | **Small** text size |

---

### Column 2 — NG911 Card
**Add Text web part in center column:**

Type:
```
NG911 · IS COORDINATION
Solacom NG911 Refresh
● GREEN · On Track
FE leads RFP. IS goal: new vendor owns 100% end-to-end support, eliminating 4 dedicated Mitel lines. Cloud-hosted managed solution confirmed.
Phase: RFP | Est. Complete: 2027
```

Formatting:
| Line | Formatting |
|---|---|
| `NG911 · IS COORDINATION` | **Small** text |
| `Solacom NG911 Refresh` | **Heading 2** or Bold |
| `● GREEN · On Track` | Normal; select `GREEN · On Track` → **Green** highlight |
| Body paragraph | Normal |
| `Phase: RFP \| Est. Complete: 2027` | **Small** text |

---

### Column 3 — VuWall Card
**Add Text web part in right column:**

Type:
```
VUW · IS COORDINATION
VuWall Video Wall / KVM
● AMBER · POC Active
Non-refundable POC PO issued 3/26. IS resource gap unresolved. Bluum contract status uncertain — parallel procurement path active.
Phase: POC | 2 SteerCo Actions Open
```

Formatting:
| Line | Formatting |
|---|---|
| `VUW · IS COORDINATION` | **Small** text |
| `VuWall Video Wall / KVM` | **Heading 2** or Bold |
| `● AMBER · POC Active` | Normal; select `AMBER · POC Active` → **Yellow/Orange** highlight |
| Body paragraph | Normal |
| `Phase: POC \| 2 SteerCo Actions Open` | **Small** text |

---

## SECTION 4 — Default Background, TWO Columns
### Quick Links + Open SteerCo Actions

**Add the section:**
1. **+** below Section 3 → **Add section** → **Two columns** layout
2. Background: **Default**

---

### Left Column — Quick Links
1. Click **+** in left column → add **Quick Links** web part
2. The web part edit panel opens on the right side
3. Set **Layout** to **Compact list** (look for the layout selector in the edit panel)
4. Click **+ Add** or **Add a link** to add each link:

| Title | URL |
|---|---|
| RAID Log — All Projects | `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Project%20RAID` |
| IS Project Tasks | `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Project%20Tasks` |
| IS Milestones | `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Milestones` |
| IS Status Summary | `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/IS%20Status%20Summary` |
| Construction Gates | `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub/Lists/Construction%20Gates` |

> **Tip:** For each link, click **+ Add** → paste the URL in the address field → the title may auto-populate; edit it to match the exact title in the table above.

---

### Right Column — Open SteerCo Actions
1. Click **+** in right column → add **Text** web part
2. Type:

```
Open Steering Committee Actions
• VuWall PO path and timeline — Owner: TBD
• VuWall IS resource for POC — Owner: TBD
• Dedicated endpoint resource (Chad & Carri) — Gretchen agreed in principle, confirmation pending
```

Formatting:
- `Open Steering Committee Actions` → **Bold** (Heading 3 or just Bold)
- The 3 bullet lines: Use the **bullet list** button in the toolbar, OR type the `•` character manually (copy-paste from this doc)

---

## SECTION 5 — Default Background, Single Column
### Document Library

**Add the section:**
1. **+** below Section 4 → **Add section** → **One column**
2. Background: **Default**

**Add Document Library web part:**
1. Click **+** in the column → search for **Document Library** → add it
2. In the web part properties panel (right side):
   - **Document library:** Select **Documents** (the default document library)
   - **View:** If a **Compact list** view exists, select it. Otherwise leave as default.
3. Click **Apply** or close the panel.

---

## FINAL STEPS — SAVE AS DRAFT

1. Scroll through the full page to review all 5 sections
2. Check that all text is entered correctly and highlights are applied
3. **DO NOT click Publish**
4. Click the **dropdown arrow** next to the Publish button
5. Select **Save as draft**
   - If no dropdown, look for a separate **Save** button — click it (saves as draft by default in edit mode)
6. Take a **full-page screenshot** (use browser zoom out to ~75% to capture all sections, then Snip & Sketch or browser screenshot tool)
7. Share the screenshot back so we can review and adjust before publishing

---

## TROUBLESHOOTING

| Issue | Fix |
|---|---|
| Can't find section background color | Hover over the far left edge of the section — a vertical toolbar appears with layout/background icons |
| Text highlight button not visible | Select text → look for `...` in the floating toolbar → highlight is often in the overflow menu |
| Quick Links layout options not showing | Click the pencil/edit icon on the Quick Links web part → layout options appear in the right panel |
| Document Library not showing Documents | In the web part property panel, click the library dropdown — if Documents doesn't appear, the web part may default to it; check the title shown |
| Section column layout wrong | Click the section edit icon (left edge) → change columns from there |
| Heading style not available for small text | Use the **font size** dropdown in the text toolbar to set small size manually |

---

*Guide generated by Agent Zero — TCC IS Program AI Partner*  
*Version 1.0 — 2026-04-02*
