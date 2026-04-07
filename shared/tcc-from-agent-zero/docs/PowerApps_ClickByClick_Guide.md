# TCC IS Portfolio Dashboard — Power Apps Click-by-Click Build Guide
**Metropolitan Council IS | GCC High Environment**
_Built for project managers — no Power Apps experience required_
_Estimated time: 30 minutes | Controls: ~25 | Environment: make.gov.powerapps.us_

---

## Before You Start — Checklist

- [ ] You are logged into your Met Council work account
- [ ] You have access to: **https://make.gov.powerapps.us**
- [ ] You have at least Contributor access to the SharePoint site:
      `https://metcmn.sharepoint.com/sites/TCCISPortfolioHub`
- [ ] The SharePoint list **IS Project RAID** exists on that site
- [ ] You have 30 uninterrupted minutes
- [ ] A second monitor or side-by-side window helps (this guide on one side, Power Apps on the other)

---

## Color Reference Card (bookmark this)

| Color | Use | Value to type |
|---|---|---|
| Dark background | Screen fill | `RGBA(10,15,30,1)` |
| Met Council navy | Header bar | `RGBA(0,53,78,1)` |
| Accent blue | Buttons, borders | `RGBA(0,84,166,1)` |
| Green RAG | On Track status | `RGBA(112,173,71,1)` |
| Amber RAG | At Risk status | `RGBA(255,192,0,1)` |
| Red RAG | Off Track status | `RGBA(192,0,0,1)` |
| White text | All labels | `RGBA(255,255,255,1)` |
| Light gray text | Subtitles | `RGBA(180,200,220,1)` |

---

## PHASE 1 — CREATE THE APP (Steps 1–5)
_Time: ~3 minutes_

---

**Step 1:** Open your browser and go to **https://make.gov.powerapps.us**

Sign in with your Met Council work account if prompted. You should see the Power Apps home page with a left navigation panel.

> ⚠️ **GCC High note:** Always use `make.gov.powerapps.us` — NOT `make.powerapps.com`. The .gov version is your government tenant.

---

**Step 2:** In the left navigation panel, click **Apps**.

You should see a list of existing apps (or an empty list if none exist yet).

---

**Step 3:** In the top toolbar, click the **+ New app** button. A dropdown menu appears. Click **Canvas**.

A dialog box appears asking what format you want.

---

**Step 4:** In the dialog, click **Tablet layout** (the wider rectangle option, not Phone).

Then click **Create**.

> ⏳ **Loading warning:** Power Apps Studio may take 30–60 seconds to open. A blank white screen with a spinner is normal. Do not click anything until the studio fully loads.

You should see the Power Apps Studio editor with:
- A blank white canvas in the center
- A left panel (Tree view)
- A right panel (Properties)
- A top toolbar with Insert, Home, View, Action tabs

---

**Step 5:** In the top-left, click the app name (it says something like **App** or **App1**). A text box appears — **type exactly:**
```
TCC IS Portfolio Hub
```
Press **Enter** to confirm.

✅ **Checkpoint 1:** Your app is created with tablet layout. The canvas is blank white, sized approximately 1366×768. The title bar shows "TCC IS Portfolio Hub".

---

## PHASE 2 — SET THE SCREEN BACKGROUND (Steps 6–8)
_Time: ~2 minutes_

---

**Step 6:** In the left **Tree View** panel, click on **Screen1**.

The entire canvas becomes selected (you'll see a blue border around the canvas area).

> 💡 **Tip:** If you don't see Tree View on the left, click the **Tree view** icon (looks like three horizontal lines with indentation) at the top of the left panel.

---

**Step 7:** In the right **Properties** panel, look for the **Fill** property. It shows a color square (currently white).

Click that color square. A color picker opens.

At the bottom of the color picker, you'll see a text field. **Clear it and type exactly:**
```
RGBA(10,15,30,1)
```
Press **Enter**.

The canvas background should immediately turn very dark navy/almost-black.

> ⚠️ **If you don't see a text field in the color picker:** Look for a tab that says **Custom** or a hex input field. Some versions show `#RRGGBB` format — if so, type `#0A0F1E` instead.

---

**Step 8:** Look at the top formula bar (the long bar just below the toolbar, starts with `fx`). Make sure it shows:
```
fx  Fill
```
and the value shows `RGBA(10,15,30,1)`. If not, click **Screen1** in the Tree View again and verify the Fill property in the right panel.

✅ **Checkpoint 2:** Your screen background is dark navy/black. The canvas looks like a dark dashboard. All future controls will be placed on this dark background.

---

## PHASE 3 — HEADER BAR (Steps 9–12)
_Time: ~3 minutes_

---

**Step 9:** In the top toolbar, click the **Insert** tab. A dropdown or sidebar appears with a list of control types.

Click **Rectangle**.

> ⏳ A rectangle appears on the canvas, probably in the middle. It will be white by default.

---

**Step 10:** The rectangle is selected (blue handles around it). In the right **Properties** panel:

- Find **X** — **type:** `0`
- Find **Y** — **type:** `0`
- Find **Width** — **type:** `1366`
- Find **Height** — **type:** `80`

Press **Tab** after each value to confirm. The rectangle should snap to the top of the canvas, spanning the full width.

> 💡 **Tip:** If you don't see X, Y, Width, Height in Properties, click the **Layout** tab within the Properties panel, or look for the **Position** and **Size** sections.

---

**Step 11:** With the rectangle still selected, find the **Fill** property in the right panel.

Click the color square next to Fill. In the text field, **type exactly:**
```
RGBA(0,53,78,1)
```
Press **Enter**.

The rectangle should turn Met Council navy blue.

---

**Step 12:** In the left Tree View panel, double-click on **Rectangle1** (or whatever it named the rectangle). The name becomes editable. **Type:**
```
rctHeader
```
Press **Enter**.

✅ **Checkpoint 3:** You have a navy blue horizontal bar across the top of the dark screen. It should span full width (1366px) and be 80px tall.

---

## PHASE 4 — HEADER LABELS (Steps 13–17)
_Time: ~4 minutes_

---

**Step 13:** Click **Insert** tab → click **Label** (or **Text label**).

A label control appears on the canvas. Move it by clicking and dragging it onto the navy header bar (approximately left side).

---

**Step 14:** With the label selected, set these properties in the right **Properties** panel:

- **X:** `20`
- **Y:** `12`
- **Width:** `600`
- **Height:** `40`

Then click the **Text** property field (shows the current label text like "Text"). **Clear it and type exactly:**
```
"TCC IS Portfolio Hub"
```
_(Include the quotation marks — Power Apps requires quotes around text values)_

Press **Enter**.

---

**Step 15:** With the label still selected, in the Properties panel set these text formatting properties:

- Find **Font size** — **type:** `22`
- Find **Font weight** (or Bold) — click the **Bold** button (B) to make it bold
- Find **Color** (text color square) — click it, type: `RGBA(255,255,255,1)`, press Enter
- Find **Align** — click the **Left align** button
- Find **Vertical align** — select **Middle**

> 💡 **Tip:** You may need to click between the **Properties** tab and **Advanced** tab in the right panel to find all these options. Font properties are often under **Properties** → text section.

---

**Step 16:** In the Tree View, rename this label to:
```
lblAppTitle
```

---

**Step 17:** Now add the subtitle. Click **Insert** → **Label** again.

Set these properties:
- **X:** `20`
- **Y:** `48`
- **Width:** `500`
- **Height:** `25`
- **Text:** `"Metropolitan Council IS"`
- **Font size:** `12`
- **Color:** `RGBA(180,200,220,1)`
- **Align:** Left

Rename this label in Tree View to: `lblSubtitle`

✅ **Checkpoint 4:** Your header bar now shows "TCC IS Portfolio Hub" in large white bold text, with "Metropolitan Council IS" in smaller light blue text below it. Both are on the navy header bar.

---

## PHASE 5 — EBC COUNTDOWN LABEL (Steps 18–19)
_Time: ~2 minutes_

---

**Step 18:** Click **Insert** → **Label**.

Set these properties:
- **X:** `900`
- **Y:** `22`
- **Width:** `440`
- **Height:** `36`
- **Font size:** `14`
- **Font weight:** Bold
- **Color:** `RGBA(255,192,0,1)` _(amber/gold — urgent attention color)_
- **Align:** Right

---

**Step 19:** For the **Text** property of this label, we want it to automatically calculate the days until April 29, 2026. Click the **Text** property field and **type this formula exactly:**

```
"EBC Go-Live: Apr 29, 2026 — " & Text(DateDiff(Today(), Date(2026,4,29), Days)) & " days remaining"
```

Press **Enter**. The label should show something like:
`EBC Go-Live: Apr 29, 2026 — 31 days remaining`

> 💡 **The number will update automatically every day** — no manual updates needed!

Rename this label in Tree View to: `lblCountdown`

✅ **Checkpoint 5:** Your header now has the countdown in amber/gold on the right side. This number automatically decreases each day.

---

## PHASE 6 — SECTION LABEL & PROJECT CARDS (Steps 20–38)
_Time: ~12 minutes_

---

### Section Label

**Step 20:** Click **Insert** → **Label**.

Set these properties:
- **X:** `20`
- **Y:** `95`
- **Width:** `300`
- **Height:** `28`
- **Text:** `"PROJECT STATUS"`
- **Font size:** `11`
- **Font weight:** Bold
- **Color:** `RGBA(180,200,220,1)`
- **Align:** Left

Rename to: `lblSectionProjects`

---

### Project Card 1 — #222 Console Expansion

> 💡 Each project card = 1 background rectangle + 3 text labels + 1 colored status rectangle. You'll repeat this pattern 3 times.

**Step 21:** Click **Insert** → **Rectangle**.

This is the card background. Set:
- **X:** `20`
- **Y:** `128`
- **Width:** `420`
- **Height:** `110`
- **Fill:** `RGBA(0,53,78,0.3)` _(semi-transparent navy)_
- **BorderColor:** `RGBA(0,84,166,1)`
- **BorderThickness:** `1`

> 💡 **To set BorderColor:** In the Properties panel, look for **Border** section. Click the color box next to BorderColor and type the value.

Rename to: `rctCard1`

---

**Step 22:** Click **Insert** → **Label**.

This is the project number. Set:
- **X:** `30`
- **Y:** `135`
- **Width:** `350`
- **Height:** `26`
- **Text:** `"#222 — Console Expansion & Infrastructure"`
- **Font size:** `14`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`

Rename to: `lblCard1Title`

---

**Step 23:** Click **Insert** → **Label**.

This shows the phase. Set:
- **X:** `30`
- **Y:** `162`
- **Width:** `350`
- **Height:** `22`
- **Text:** `"Phase 1: EBC Buildout | Hard Stop: Apr 29, 2026"`
- **Font size:** `11`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard1Phase`

---

**Step 24:** Click **Insert** → **Label**.

This shows the status detail. Set:
- **X:** `30`
- **Y:** `186`
- **Width:** `260`
- **Height:** `20`
- **Text:** `"Assessment & Requirements ~35% complete"`
- **Font size:** `10`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard1Detail`

---

**Step 25:** Click **Insert** → **Rectangle**.

This is the colored RAG status pill. Set:
- **X:** `340`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Fill:** `RGBA(112,173,71,1)` _(green = On Track)_
- **RadiusTopLeft:** `11`
- **RadiusTopRight:** `11`
- **RadiusBottomLeft:** `11`
- **RadiusBottomRight:** `11`

> 💡 **Rounded corners:** In Properties panel, look for **Border radius** or expand the **Advanced** tab and look for Radius properties.

Rename to: `rctRAG1`

---

**Step 26:** Click **Insert** → **Label**.

This is the text inside the RAG pill. Set:
- **X:** `340`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Text:** `"ON TRACK"`
- **Font size:** `9`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`
- **Align:** Center
- **Vertical align:** Middle

Rename to: `lblRAG1`

---

### Project Card 2 — #193 NG911

**Step 27:** Click **Insert** → **Rectangle**.

Card 2 background. Set:
- **X:** `460`
- **Y:** `128`
- **Width:** `420`
- **Height:** `110`
- **Fill:** `RGBA(0,53,78,0.3)`
- **BorderColor:** `RGBA(0,84,166,1)`
- **BorderThickness:** `1`

Rename to: `rctCard2`

---

**Step 28:** Click **Insert** → **Label**. Set:
- **X:** `470`
- **Y:** `135`
- **Width:** `350`
- **Height:** `26`
- **Text:** `"#193 — NG911 Call Handling System"`
- **Font size:** `14`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`

Rename to: `lblCard2Title`

---

**Step 29:** Click **Insert** → **Label**. Set:
- **X:** `470`
- **Y:** `162`
- **Width:** `350`
- **Height:** `22`
- **Text:** `"Phase 2: System Design & Bid | Budget: $3.7M"`
- **Font size:** `11`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard2Phase`

---

**Step 30:** Click **Insert** → **Label**. Set:
- **X:** `470`
- **Y:** `186`
- **Width:** `260`
- **Height:** `20`
- **Text:** `"FE Workshop: Mar 13 | ~10% complete"`
- **Font size:** `10`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard2Detail`

---

**Step 31:** Click **Insert** → **Rectangle**. RAG pill. Set:
- **X:** `780`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Fill:** `RGBA(112,173,71,1)` _(green)_
- **RadiusTopLeft:** `11` | **RadiusTopRight:** `11` | **RadiusBottomLeft:** `11` | **RadiusBottomRight:** `11`

Rename to: `rctRAG2`

---

**Step 32:** Click **Insert** → **Label**. RAG text. Set:
- **X:** `780`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Text:** `"ON TRACK"`
- **Font size:** `9`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`
- **Align:** Center
- **Vertical align:** Middle

Rename to: `lblRAG2`

---

### Project Card 3 — #11138 VuWall

**Step 33:** Click **Insert** → **Rectangle**.

Card 3 background. Set:
- **X:** `900`
- **Y:** `128`
- **Width:** `420`
- **Height:** `110`
- **Fill:** `RGBA(0,53,78,0.3)`
- **BorderColor:** `RGBA(0,84,166,1)`
- **BorderThickness:** `1`

Rename to: `rctCard3`

---

**Step 34:** Click **Insert** → **Label**. Set:
- **X:** `910`
- **Y:** `135`
- **Width:** `350`
- **Height:** `26`
- **Text:** `"#11138 — VuWall Video Wall"`
- **Font size:** `14`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`

Rename to: `lblCard3Title`

---

**Step 35:** Click **Insert** → **Label**. Set:
- **X:** `910`
- **Y:** `162`
- **Width:** `350`
- **Height:** `22`
- **Text:** `"Phase 2: Vendor Engagement | PoC Quote Pending"`
- **Font size:** `11`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard3Phase`

---

**Step 36:** Click **Insert** → **Label**. Set:
- **X:** `910`
- **Y:** `186`
- **Width:** `260`
- **Height:** `20`
- **Text:** `"Awaiting SHI PoC quote | ~5% complete"`
- **Font size:** `10`
- **Color:** `RGBA(180,200,220,1)`

Rename to: `lblCard3Detail`

---

**Step 37:** Click **Insert** → **Rectangle**. RAG pill. Set:
- **X:** `1220`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Fill:** `RGBA(112,173,71,1)` _(green)_
- **RadiusTopLeft:** `11` | **RadiusTopRight:** `11` | **RadiusBottomLeft:** `11` | **RadiusBottomRight:** `11`

Rename to: `rctRAG3`

---

**Step 38:** Click **Insert** → **Label**. RAG text. Set:
- **X:** `1220`
- **Y:** `188`
- **Width:** `90`
- **Height:** `22`
- **Text:** `"ON TRACK"`
- **Font size:** `9`
- **Font weight:** Bold
- **Color:** `RGBA(255,255,255,1)`
- **Align:** Center
- **Vertical align:** Middle

Rename to: `lblRAG3`

✅ **Checkpoint 6:** You should now see 3 project cards side by side on the dark background, each with a title, phase info, detail text, and a green "ON TRACK" pill. The cards have a navy tinted background with a blue border.

---

## PHASE 7 — RAID LOG SECTION LABEL (Step 39)
_Time: ~1 minute_

---

**Step 39:** Click **Insert** → **Label**. Set:
- **X:** `20`
- **Y:** `255`
- **Width:** `300`
- **Height:** `28`
- **Text:** `"RAID LOG"`
- **Font size:** `11`
- **Font weight:** Bold
- **Color:** `RGBA(180,200,220,1)`
- **Align:** Left

Rename to: `lblSectionRAID`

---

## PHASE 8 — ADD SHAREPOINT DATA SOURCE (Steps 40–44)
_Time: ~3 minutes_

> ⚠️ **Critical phase.** Power Apps must connect to SharePoint before you can add the Gallery. Follow carefully.

---

**Step 40:** In the left panel, look for the **Data** icon — it looks like a cylinder/database icon, or a table grid. Click it.

Alternately: In the top toolbar, click the **View** tab → click **Data sources**.

A "Data" panel opens on the left.

---

**Step 41:** Click **+ Add data** (the blue button at the top of the Data panel).

A search box appears with connector options.

---

**Step 42:** In the search box, **type:**
```
SharePoint
```
You should see **SharePoint** appear in the list. Click it.

> ⏳ **Loading warning:** The SharePoint connector may take 10–15 seconds to load.

---

**Step 43:** A "Connect to a SharePoint site" dialog appears. You may see:
- Recently used sites (if you've connected before)
- A text field to enter a URL

**If you see a URL field, type exactly:**
```
https://metcmn.sharepoint.com/sites/TCCISPortfolioHub
```
Then click **Connect** or press **Enter**.

> ⏳ **Loading warning:** SharePoint connection can take 30–60 seconds. You'll see a spinning indicator. Wait — do NOT click elsewhere.

---

**Step 44:** After connecting, a list of SharePoint lists on that site appears.

Scroll down and find **IS Project RAID**. Check the checkbox next to it.

Then click the **Connect** button.

> ⏳ **Loading warning:** Power Apps will now load the list schema. This may take 20–30 seconds.

You should see **IS Project RAID** appear in the Data panel on the left under "In your app".

✅ **Checkpoint 7:** The Data panel shows "IS Project RAID" as a connected data source. You are now ready to add the Gallery.

---

## PHASE 9 — ADD RAID GALLERY (Steps 45–49)
_Time: ~5 minutes_

---

**Step 45:** Click the **Insert** tab in the top toolbar.

Look for **Gallery** in the insert options. It may be in a subsection. Click **Gallery** → click **Vertical** (the layout with items stacked top-to-bottom).

A gallery appears on the canvas with sample data.

---

**Step 46:** With the gallery selected, set the position and size:
- **X:** `20`
- **Y:** `288`
- **Width:** `1326`
- **Height:** `440`

The gallery should now fill the lower portion of the screen.

---

**Step 47:** With the gallery still selected, find the **Items** property.

- Click on the gallery (single click on the gallery border — NOT inside a gallery item)
- Look at the top formula bar — it should say `Items` on the left
- Or in the Properties panel look for **Items** or **Data source**

**Click the Items formula bar and type exactly:**
```
'IS Project RAID'
```
_(Include the single quotes — required because the list name has spaces)_

Press **Enter**.

> ⏳ **Loading warning:** The gallery will refresh and show real data from your SharePoint list. This may take 15–30 seconds.

You should see real RAID items appearing in the gallery.

---

**Step 48:** Now customize what the gallery shows. Click **once** inside the gallery on one of the items (you'll see "Edit" mode activate with a pencil icon). Click the **Edit (pencil)** icon that appears on the gallery.

You are now editing the gallery template — changes here apply to every row.

Click on the **first label** inside the gallery item (usually shows the title or first field).

In the formula bar at the top, change its **Text** property to:
```
ThisItem.Title
```
Press **Enter**.

> 💡 **ThisItem** refers to each individual row from the SharePoint list. This shows the RAID item title.

---

**Step 49:** Click on the **second label** in the gallery item. Set its **Text** to:
```
ThisItem.RAIDType & " | " & ThisItem.RAG & " | Due: " & Text(ThisItem.DueDate, "mmm d, yyyy")
```
Press **Enter**.

This will show something like: `Risk | Red | Due: Apr 15, 2026`

Optionally, set this second label's:
- **Color:** `RGBA(180,200,220,1)`
- **Font size:** `11`

> 💡 **Click outside the gallery** (on the dark canvas background) to exit gallery edit mode.

---

### Style the Gallery Background

**Step 50 (bonus):** Click once on the gallery border (not inside an item). In the Properties panel:

- **Fill:** `RGBA(0,53,78,0.15)` _(very subtle navy tint)_
- **BorderColor:** `RGBA(0,84,166,0.5)`
- **BorderThickness:** `1`
- **TemplateFill:** `RGBA(0,53,78,0.2)` _(each row background)_

Rename the gallery in Tree View to: `galRAID`

✅ **Checkpoint 8:** The RAID log gallery fills the bottom of the screen, showing real data from your SharePoint list. Each row shows the RAID title and type/RAG/due date info.

---

## PHASE 10 — SAVE AND PUBLISH (Steps 51–54)
_Time: ~2 minutes_

---

**Step 51:** Press **Ctrl + S** on your keyboard to save.

A save dialog may appear asking for a name. If so, confirm the name is **TCC IS Portfolio Hub** and click **Save**.

> ⏳ **Loading warning:** First save can take 30–60 seconds.

---

**Step 52:** After saving, click **File** in the very top-left corner of Power Apps Studio.

This opens the app settings panel.

---

**Step 53:** Look at the left side of the File panel. Click **Save** if it appears, then look for a **Publish** button or **Share** button.

Click **Publish this version**.

A confirmation dialog appears. Click **Publish this version** again to confirm.

> ⏳ Publishing may take 30–60 seconds.

---

**Step 54:** After publishing, click the **←** back arrow (top left) to return to the app editor. Or click the **Play** button (▶) in the top toolbar to preview your app.

You should see:
- Dark navy/black background
- Navy header with "TCC IS Portfolio Hub" and the EBC countdown
- Three project cards in the middle
- A RAID gallery at the bottom with real SharePoint data

✅ **FINAL CHECKPOINT: Your app is live!**

To find your app later: Go to **https://make.gov.powerapps.us** → **Apps** → find **TCC IS Portfolio Hub**.

To share with others: In the Apps list, click the **...** menu next to your app → **Share** → type their name or email.

---

## Troubleshooting — Common Issues

| Problem | Solution |
|---|---|
| Gallery shows "No data" | Click the gallery, check Items formula bar shows `'IS Project RAID'` with single quotes |
| Can't connect to SharePoint | Make sure you're logged in as your Met Council account; try clicking "Refresh" in the Data panel |
| Colors look wrong | Re-enter the RGBA values — make sure no extra spaces, exact capitalization: `RGBA(0,53,78,1)` |
| Formula bar shows red error | Check for typos in the formula; make sure text values have double quotes `"like this"` |
| Controls overlap or jump | Check X, Y, Width, Height values — re-enter them manually |
| App won't save | Try Ctrl+S again; if it fails, File → Save as → new name |
| Gallery column names not found | The SharePoint column internal name may differ; try `ThisItem.RAID_x0020_Type` for "RAID Type" |

---

## Optional Enhancements (After You Finish)

Once the basic app is working, you can add these improvements in future sessions:

1. **Filter gallery by project:** Add a dropdown (Insert → Dropdown) with choices: All, TCC Expansion, NG911, VuWall. Set gallery Items to: `Filter('IS Project RAID', Project.Value = drpFilter.Selected.Value)`

2. **Color-code RAG rows:** In gallery template, set TemplateFill based on RAG value using: `If(ThisItem.RAG.Value = "Red", RGBA(192,0,0,0.15), If(ThisItem.RAG.Value = "Amber", RGBA(255,192,0,0.15), RGBA(112,173,71,0.15)))`

3. **Add a divider line:** Insert → Rectangle, Width=1326, Height=1, Fill=RGBA(0,84,166,0.5) between sections

4. **Sort by due date:** Change gallery Items to: `Sort('IS Project RAID', DueDate, Ascending)`

---

_Guide created: March 29, 2026 | TCC IS Portfolio Program | Metropolitan Council IS_
