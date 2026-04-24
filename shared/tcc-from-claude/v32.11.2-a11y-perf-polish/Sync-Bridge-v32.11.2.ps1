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
    Write-Host "  Re-run with:  .\Sync-Bridge-v32.11.2.ps1 -BridgeRoot 'C:\path\to\clone'" -ForegroundColor Yellow
    return
}

Write-Host "  Clone found: $BridgeRoot" -ForegroundColor Green

# 2. v32.11.2-a11y-perf-polish snapshot
$Target = Join-Path $BridgeRoot "shared\tcc-from-claude\v32.11.2-a11y-perf-polish"
Write-Section "Snapshotting v32.11.2-a11y-perf-polish (full)"
if (Test-Path $Target) { Remove-Item $Target -Recurse -Force }
New-Item -Type Directory -Path $Target | Out-Null

$items = @(
    @{ src = "v20\tcc_hub_src";                                dest = "tcc_hub_src"; recurse = $true }
    @{ src = "Pack-v32.11.2.ps1";                              dest = "Pack-v32.11.2.ps1" }
    @{ src = "Sync-Bridge-v32.11.2.ps1";                       dest = "Sync-Bridge-v32.11.2.ps1" }
    @{ src = "TCC_Portfolio_Dashboard_v32_11_2.msapp";         dest = "TCC_Portfolio_Dashboard_v32_11_2.msapp" }
)
foreach ($i in $items) {
    $s = Join-Path $WorkspaceFolder $i.src
    $d = Join-Path $Target $i.dest
    if (Test-Path $s) {
        if ($i.recurse) { Copy-Item $s $d -Recurse -Force } else { Copy-Item $s $d -Force }
        Write-Host "  + v32.11.2/$($i.dest)" -ForegroundColor Gray
    } else { Write-Host "  - missing $($i.src) (skipping)" -ForegroundColor Yellow }
}

# 3. Commit + push
Write-Section "Committing + pushing"
Set-Location $BridgeRoot
git add "shared/tcc-from-claude/v32.11.2-a11y-perf-polish/"
$msg = @"
tcc-hub: v32.11.2-a11y-perf-polish

Polish pass on v32.11.1. No SP schema changes; no new connections.

Label clip fix (#4): portfolio-gate labels now anchor-align at track edges.
For LeftPct >= 92 labels right-align (translateX(-100%)); for LeftPct <= 8
labels left-align (translateX(0)); otherwise centered. Dot position
unchanged (still centered at LeftPct via translateX(-50%)). The P-07
'Go-Live / Complete' label no longer overruns the track container.

Perf (#3): colProjSummary LookUp hoisted into parent With() scope in
gProjectRowData. Before: 4 LookUps per project row (12 total). After: 1
per row (3 total). Fields _sum.PctComplete, _sum.TotalTasks,
_sum.CompleteTasks, _sum.OverdueTasks replace four separate LookUps.

A11y (#3): AccessibleLabel added to all 6 htmlViewer controls
(htmlKPIStrip, htmlDecisions, htmlPortfolioTrack, htmlProjRow,
htmlDetailKPIs, htmlRaidRow). Labels are dynamic where it adds value
(KPI strip reads live counts; RAID row names the type/ID/status).

KPI sanity-check (#1): CRITICAL=0 and OVERDUE=0 verified legitimate via
Claude-in-Chrome SP REST audit. No rows with RAGStatus Red or Blocked -
Construction in the 328-row dataset. Only 15 of 328 have past
PlannedEnds, and all 15 are complete (PercentComplete=100 + ActualEnd
stamped). Filter logic is correct; no bug. Data-hygiene observation:
194 rows have null PercentComplete, latent trap if anyone back-dates a
PlannedEnd without setting percent.
"@
git commit -m $msg
git push

Write-Host "`nDone. v32.11.2-a11y-perf-polish pushed." -ForegroundColor Green
