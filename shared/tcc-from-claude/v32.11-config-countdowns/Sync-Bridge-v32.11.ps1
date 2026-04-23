param(
    [string]$BridgeRoot = $env:TCC_BRIDGE_REPO
)

$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

function Test-IsValidBridgeClone($p) {
    return $p -and (Test-Path $p) -and (Test-Path (Join-Path $p ".git"))
}

# 1. Find the bridge clone (same discovery pattern as Sync-Bridge.ps1)
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
    Write-Host "  Re-run with:  .\Sync-Bridge-v32.11.ps1 -BridgeRoot 'C:\path\to\clone'" -ForegroundColor Yellow
    return
}

Write-Host "  Clone found: $BridgeRoot" -ForegroundColor Green

# 2. v32.10-tasktype-tracks — handoff-only snapshot (source was mutated in place,
#    only packed msapp + handoff represent the exact v32.10 state)
$Target10 = Join-Path $BridgeRoot "shared\tcc-from-claude\v32.10-tasktype-tracks"
Write-Section "Snapshotting v32.10-tasktype-tracks (handoff + msapp only)"
if (Test-Path $Target10) { Remove-Item $Target10 -Recurse -Force }
New-Item -Type Directory -Path $Target10 | Out-Null
$v10 = @(
    @{ src = "SESSION_HANDOFF_20260423_v32.10.md"; dest = "SESSION_HANDOFF.md" }
    @{ src = "Pack-v32.10.ps1";                     dest = "Pack-v32.10.ps1" }
    @{ src = "TCC_Portfolio_Dashboard_v32_10.msapp"; dest = "TCC_Portfolio_Dashboard_v32_10.msapp" }
    @{ src = "SP_Format_Column_PlannedEnd_v2.json";  dest = "SP_Format_Column_PlannedEnd_v2.json" }
    @{ src = "SP_Format_Column_PlannedStart_v2.json"; dest = "SP_Format_Column_PlannedStart_v2.json" }
    @{ src = "TCC_IS_WBS_v3.2_Placeholder_Plan_DRAFT.docx"; dest = "TCC_IS_WBS_v3.2_Placeholder_Plan_DRAFT.docx" }
    @{ src = "TCC_IS_WBS_v3.2_draft.xlsx"; dest = "TCC_IS_WBS_v3.2_draft.xlsx" }
    @{ src = "TCC_IS_WBS_v3.2_Redline.md"; dest = "TCC_IS_WBS_v3.2_Redline.md" }
)
foreach ($i in $v10) {
    $s = Join-Path $WorkspaceFolder $i.src
    if (Test-Path $s) {
        Copy-Item $s (Join-Path $Target10 $i.dest) -Force
        Write-Host "  + v32.10/$($i.dest)" -ForegroundColor Gray
    } else { Write-Host "  - missing $($i.src)" -ForegroundColor Yellow }
}

# 3. v32.11-config-countdowns — full snapshot (current source + artifacts)
$Target11 = Join-Path $BridgeRoot "shared\tcc-from-claude\v32.11-config-countdowns"
Write-Section "Snapshotting v32.11-config-countdowns (full)"
if (Test-Path $Target11) { Remove-Item $Target11 -Recurse -Force }
New-Item -Type Directory -Path $Target11 | Out-Null
$v11 = @(
    @{ src = "v20\tcc_hub_src";                             dest = "tcc_hub_src"; recurse = $true }
    @{ src = "Pack-v32.11.ps1";                             dest = "Pack-v32.11.ps1" }
    @{ src = "SP_Create_IS_Portfolio_Config_List.js";       dest = "SP_Create_IS_Portfolio_Config_List.js" }
    @{ src = "SESSION_HANDOFF_20260423_v32.11.md";          dest = "SESSION_HANDOFF.md" }
    @{ src = "TCC_Portfolio_Dashboard_v32_11.msapp";        dest = "TCC_Portfolio_Dashboard_v32_11.msapp" }
    @{ src = "Sync-Bridge-v32.11.ps1";                      dest = "Sync-Bridge-v32.11.ps1" }
)
foreach ($i in $v11) {
    $s = Join-Path $WorkspaceFolder $i.src
    $d = Join-Path $Target11 $i.dest
    if (Test-Path $s) {
        if ($i.recurse) { Copy-Item $s $d -Recurse -Force } else { Copy-Item $s $d -Force }
        Write-Host "  + v32.11/$($i.dest)" -ForegroundColor Gray
    } else { Write-Host "  - missing $($i.src) (skipping)" -ForegroundColor Yellow }
}

# 4. Commit + push
Write-Section "Committing + pushing"
Set-Location $BridgeRoot
git add "shared/tcc-from-claude/v32.10-tasktype-tracks/" "shared/tcc-from-claude/v32.11-config-countdowns/"
$msg = @"
tcc-hub: v32.10 + v32.11 handoff snapshots

v32.10-tasktype-tracks (2026-04-23) - handoff-only snapshot. Per-project
mini-tracks now source from IS Project Tasks filtered by TaskType. 18
per-project IS Project Gates rows retired. WBS expanded 208 -> 328 rows
via v3.2 placeholder pass. PlannedEnd/PlannedStart column formatters
refreshed to 4-tier ladder with calendar-month match.

v32.11-config-countdowns (2026-04-23) - full snapshot. Countdown targets
moved from hardcoded Power Fx constants to IS Portfolio Config SP list.
DAYS TO EBC retargeted to Room 1007 Go-Live 2026-08-15. DAYS TO HARD STOP
renamed DAYS TO STATE FAIR (2026-08-21). New DAYS TO TCC FINAL KPI
(2026-12-31). KPI strip expanded from 7 to 8 columns. gDaysToHardStop
aliased to gDaysToStateFair for scrDetail back-compat.
"@
git commit -m $msg
git push

Write-Host "`nDone. Bridge brought current. v30.2 -> v32.11 gap closed." -ForegroundColor Green
