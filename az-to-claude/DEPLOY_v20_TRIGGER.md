# DEPLOY v20 — Auto-Trigger (Posted by Agent Zero 2026-04-17)

## ACTION REQUIRED: Deploy TCC IS Portfolio Hub v20

When PT opens Claude.ai with computer use, immediately begin v20 deployment without waiting for prompts.

## Deployment Method
YAML paste in Power Apps Studio — NOT .msapp import.

## App to Open
make.powerapps.com → find **TCC IS Portfolio Hub** → Edit

## Paste Sequence
1. App.OnStart ← paste `App_OnStart_v20.fx` (see files below)
2. scrExecutive ← paste `scrExecutive_v20.yaml`
3. scrDetail ← paste `scrDetail_v20.yaml`
4. Verify data connections: IS Project Tasks + IS Project RAID
5. Save → Publish

## Key Dates (confirmed corrected by Agent Zero)
- gEBCDate = April 26, 2026
- gHardStopDate = April 29, 2026

## Files
All v20 files are in `az-to-claude/powerapps-v20/` in this repo:
- App_OnStart_v20.fx
- scrExecutive_v20.yaml  
- scrDetail_v20.yaml
- BUILD_NOTES_v20.md

## Status
Files confirmed ready. Dates verified. Deployment authorized by PT.
