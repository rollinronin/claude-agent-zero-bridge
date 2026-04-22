# One-Time Setup: Canvas App in a Solution with Persistent Connection References

**Why this exists:** Every canvas-app import to gov strips the SP data connections. You have to manually re-add `IS Project Tasks` and `IS Project RAID` every time. Wrapping the app in a Power Platform solution with connection references fixes this permanently — connections live at the environment level and are looked up by name on every import.

**Investment:** ~30 minutes of manual setup in gov Power Apps, once. After that every `Pack-Solution.ps1` run imports cleanly with connections intact.

**Prerequisites:** pac CLI authenticated to the gov tenant (already done — memory confirms device code flow works).

---

## Step 1 — Create connection references in gov environment (web UI, one-time)

`make.gov.powerapps.us` → left nav → **More** → **Connections**

For each of the two SP data sources:

1. Click **+ New connection**
2. Search for "SharePoint" → select
3. Authenticate with your gov account
4. Save

That creates two connections in the environment. Note their **connection names** exactly as they appear — we'll reference them.

---

## Step 2 — Scaffold the solution folder (one-time)

Run in PowerShell:

```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
mkdir tcc-hub-solution
cd tcc-hub-solution
pac solution init --publisher-name "MetCouncilIS" --publisher-prefix "metcis"
```

This creates a solution source folder structure with `Other\Solution.xml` and related files.

---

## Step 3 — Add the canvas app to the solution (one-time)

With the solution folder as current directory:

```powershell
pac solution add-reference --path "..\v20\tcc_hub_src"
```

Adjust the path if your source location is different. This registers the canvas app as part of the solution.

---

## Step 4 — Test the solution pack (one-time verification)

```powershell
pac solution pack --zipfile solution.zip --folder .
```

This should produce `solution.zip` in the current directory. If errors, paste them to Claude.

---

## Step 5 — Initial import to environment (one-time)

```powershell
pac solution import --path solution.zip --environment 83181ce4-b33c-ee76-9337-862af377e448 --async
```

After this first import, the gov environment knows about the solution. Subsequent imports update in place.

---

## From then on — every iteration uses this single command

After Claude edits source, you run:

```powershell
cd "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
powershell -ExecutionPolicy Bypass -File .\Pack-Solution.ps1
```

(Pack-Solution.ps1 to be written by Claude after you complete Steps 1-5 and confirm the first import worked.)

That one command:
1. Repacks the canvas app from source
2. Rebuilds solution.zip
3. Imports to gov environment
4. Connections stay bound automatically

No more clicking **Import app** → selecting file → re-adding two data sources → running OnStart. Just the one command; the running app refreshes.

---

## When to do this setup

Do Steps 1-5 whenever you're ready for a ~30-minute focused session. Can wait until v32.x iteration settles. Until then, keep using `Pack-v32.X.ps1` and manually re-add connections per import — that works fine, just tedious.

**If you hit any step-level failures, screenshot the error and Claude will help troubleshoot.** The pac solution commands have well-known pitfalls (publisher prefix collisions, environment GUID mismatches) that are quick to fix once the error is visible.
