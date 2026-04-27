param(
    [string]$BridgeRoot = $env:TCC_BRIDGE_REPO
)

$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

function Test-IsValidBridgeClone($p) {
    return $p -and (Test-Path $p) -and (Test-Path (Join-Path $p ".git"))
}

# 1. Find the bridge clone
if (-not (Test-IsValidBridgeClone $BridgeRoot)) {
    if ($BridgeRoot) {
        Write-Host "Ignoring invalid BridgeRoot='$BridgeRoot' - rediscovering" -ForegroundColor Yellow
        $BridgeRoot = $null
    }
    Write-Section "Auto-discovering claude-agent-zero-bridge clone"
    $candidates = @(
        "$HOME\OneDrive\Documents\Claude\Projects\claude-agent-zero-bridge",
        "$HOME\Documents\GitHub\claude-agent-zero-bridge",
        "$HOME\Documents\claude-agent-zero-bridge",
        "$HOME\source\repos\claude-agent-zero-bridge",
        "$HOME\repos\claude-agent-zero-bridge",
        "$HOME\Desktop\claude-agent-zero-bridge",
        "$HOME\OneDrive\Documents\GitHub\claude-agent-zero-bridge",
        "C:\GitHub\claude-agent-zero-bridge",
        "C:\repos\claude-agent-zero-bridge",
        "C:\dev\claude-agent-zero-bridge"
    )
    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c ".git")) { $BridgeRoot = $c; break }
    }
}

if (-not (Test-IsValidBridgeClone $BridgeRoot)) {
    Write-Host "`nFAIL: no valid claude-agent-zero-bridge clone found." -ForegroundColor Red
    Write-Host "  Re-run with:  .\Sync-Bridge-v32.11.3.ps1 -BridgeRoot 'C:\path\to\clone'" -ForegroundColor Yellow
    return
}

Write-Host "  Clone found: $BridgeRoot" -ForegroundColor Green

# 2. v32.11.3-a11y-gallery-fix snapshot
$Target = Join-Path $BridgeRoot "shared\tcc-from-claude\v32.11.3-a11y-gallery-fix"
Write-Section "Snapshotting v32.11.3-a11y-gallery-fix (full)"
if (Test-Path $Target) { Remove-Item $Target -Recurse -Force }
New-Item -Type Directory -Path $Target | Out-Null

$items = @(
    @{ src = "v20\tcc_hub_src";                                dest = "tcc_hub_src"; recurse = $true }
    @{ src = "Pack-v32.11.3.ps1";                              dest = "Pack-v32.11.3.ps1" }
    @{ src = "Sync-Bridge-v32.11.3.ps1";                       dest = "Sync-Bridge-v32.11.3.ps1" }
    @{ src = "TCC_Portfolio_Dashboard_v32_11_3.msapp";         dest = "TCC_Portfolio_Dashboard_v32_11_3.msapp" }
    @{ src = "IS_Project_Tasks_DeletedFields_Backup_20260424.json"; dest = "IS_Project_Tasks_DeletedFields_Backup_20260424.json" }
)
foreach ($i in $items) {
    $s = Join-Path $WorkspaceFolder $i.src
    $d = Join-Path $Target $i.dest
    if (Test-Path $s) {
        if ($i.recurse) { Copy-Item $s $d -Recurse -Force } else { Copy-Item $s $d -Force }
        Write-Host "  + v32.11.3/$($i.dest)" -ForegroundColor Gray
    } else { Write-Host "  - missing $($i.src) (skipping)" -ForegroundColor Yellow }
}

# 3. Commit + push
Write-Section "Committing + pushing"
Set-Location $BridgeRoot
git add "shared/tcc-from-claude/v32.11.3-a11y-gallery-fix/"
$msg = @"
tcc-hub: v32.11.3-a11y-gallery-fix

Polish pass on v32.11.2. No SP schema changes; no new connections.

A11y: AccessibleLabel + TabIndex=0 added to galExecProjects (scrExecutive)
and galRAID (scrDetail). App Checker Accessibility count dropped 4 -> 0
post-import. The 4 a11y warnings on v32.11.2 turned out to be on the
gallery containers themselves, not the htmlViewers inside; the v32.11.3
fix targets the actual source.

Performance: 48 warnings unchanged - 45 are unused-variable flags
(cosmetic, no perf impact) and 3 are intentional ClearCollect calls on
App OnStart. The colProjSummary LookUp hoist landed in v32.11.2 but its
counted savings were dwarfed by the unused-variable category.

SP-side data work this session (no canvas dependency):
- Deleted duplicate RAG + PctComplete fields from IS Project Tasks
- Fresh progress-bar formatter applied to PercentComplete
- PercentComplete added to 10 affected views
- WBS row title corrections: PC Procurement Room 1007 (16 PCs -> 18 PCs)
- WBS pct/RAG corrections on 6 rows (VuWall PO, CJIS LASO, 4 Network plans)
- Gate P-03 Notice of Award marked Complete with target 2026-03-30
  (was wrongly Active May 15 - NOA was given early April; NTP on P-04
  is the pending starting gun)

Backup of deleted-field schema + populated PctComplete data:
shared/tcc-from-claude/v32.11.3-a11y-gallery-fix/IS_Project_Tasks_DeletedFields_Backup_20260424.json
"@
git commit -m $msg
git push

Write-Host "`nDone. v32.11.3-a11y-gallery-fix pushed." -ForegroundColor Green
