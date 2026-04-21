# TCC IS Portfolio Hub v30.2 - working source snapshot
Captured 2026-04-21. Deployed in MetC Data Management gov env.

## Contents
- tcc_hub_src/ - PASopa v0.24 source tree (fx.yaml + editorstate)
- TCC_Portfolio_Dashboard_v30_2.msapp - packed msapp ready to import

## Build state
- Version stamp: v30.2-plannedend-broadcritical
- App Checker: 0 formula errors, 4 a11y warnings, 9 perf warnings
- Data: 208 tasks, 26 RAID, 3 projects (TCC/NG911/VuWall)
- KPIs: Total 208 / Avg 67% / Overdue 1 / Critical 0 / Open RAID 26
- Surfaced overdue: task #6928 (FE Design Review, NG911)

## Rebuild
`pac canvas pack --sources .\tcc_hub_src --msapp TCC_Portfolio_Dashboard_v31.msapp`

## Outstanding (see auto-memory project_tcc_hub_v28_deployed.md)
- gSelectedProject key-space drift (scrExec to scrDetail drilldown)
- Gallery layout: vertical column-tile rendering vs horizontal stacked rows
- WBS data hygiene: 76% PlannedEnd missing, 93% PercentComplete missing
