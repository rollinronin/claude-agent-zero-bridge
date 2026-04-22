param(
    [string]$BridgeRoot = $env:TCC_BRIDGE_REPO
)

$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

function Test-IsValidBridgeClone($p) {
    return $p -and (Test-Path $p) -and (Test-Path (Join-Path $p ".git"))
}

# 1. Find the bridge clone if not specified (or specified path is invalid)
if (-not (Test-IsValidBridgeClone $BridgeRoot)) {
    if ($BridgeRoot) {
        Write-Host "Ignoring invalid BridgeRoot='$BridgeRoot' (not a git clone) - rediscovering" -ForegroundColor Yellow
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

    if (-not $BridgeRoot) {
        Write-Host "  None of the common locations have the clone." -ForegroundColor Yellow
        Write-Host "  Doing deeper search on C:\Users\$env:USERNAME ..." -ForegroundColor Gray
        $found = Get-ChildItem -Path "$HOME" -Filter "claude-agent-zero-bridge" -Directory -Recurse -EA SilentlyContinue |
                 Where-Object { Test-Path (Join-Path $_.FullName ".git") } |
                 Select-Object -First 1
        if ($found) { $BridgeRoot = $found.FullName }
    }
}

if (-not (Test-IsValidBridgeClone $BridgeRoot)) {
    Write-Host "`nFAIL: no valid claude-agent-zero-bridge clone (with .git) found." -ForegroundColor Red
    Write-Host "  Options to fix:" -ForegroundColor Yellow
    Write-Host "  1. Tell me where it is:  .\Sync-Bridge.ps1 -BridgeRoot 'C:\path\to\clone'" -ForegroundColor Yellow
    Write-Host "  2. Set env variable:     `$env:TCC_BRIDGE_REPO = 'C:\path\to\clone'" -ForegroundColor Yellow
    Write-Host "  3. Clone it fresh:       git clone https://github.com/rollinronin/claude-agent-zero-bridge" -ForegroundColor Yellow
    return
}

Write-Host "  Clone found: $BridgeRoot" -ForegroundColor Green

$BridgeTarget = Join-Path $BridgeRoot "shared\tcc-from-claude\v32.8-html-baseline"

Write-Section "Preparing target folder"
if (Test-Path $BridgeTarget) { Remove-Item $BridgeTarget -Recurse -Force }
New-Item -Type Directory -Path $BridgeTarget | Out-Null

Write-Section "Copying handoff artifacts"
$items = @(
    @{ src = "v20\tcc_hub_src";                                dest = "tcc_hub_src"           }
    @{ src = "Pack-v32.8.ps1";                                 dest = "Pack-v32.8.ps1"        }
    @{ src = "Prepare-Export.ps1";                             dest = "Prepare-Export.ps1"    }
    @{ src = "gates_setup_step1_create.js";                    dest = "gates_setup_step1_create.js" }
    @{ src = "gates_setup_step2_seed.js";                      dest = "gates_setup_step2_seed.js"   }
    @{ src = "SESSION_HANDOFF_20260422_v32.8.md";              dest = "SESSION_HANDOFF.md"    }
    @{ src = "SOLUTION_SETUP_GUIDE.md";                        dest = "SOLUTION_SETUP_GUIDE.md" }
    @{ src = "TCC_Portfolio_Dashboard_v32_8.msapp";            dest = "TCC_Portfolio_Dashboard_v32_8.msapp" }
    @{ src = "Sync-Bridge.ps1";                                dest = "Sync-Bridge.ps1"       }
)
foreach ($i in $items) {
    $s = Join-Path $WorkspaceFolder $i.src
    $d = Join-Path $BridgeTarget $i.dest
    if (Test-Path $s) {
        if ((Get-Item $s).PSIsContainer) {
            Copy-Item $s $d -Recurse -Force
        } else {
            Copy-Item $s $d -Force
        }
        Write-Host "  + $($i.dest)" -ForegroundColor Gray
    } else {
        Write-Host "  - missing $($i.src) (skipping)" -ForegroundColor Yellow
    }
}

Write-Section "Committing + pushing to bridge repo"
Set-Location $BridgeRoot
git add "shared/tcc-from-claude/v32.8-html-baseline/"
$msg = @"
tcc-hub: v32.8-html-baseline handoff

HTML-first rebuild complete. Both scrExecutive and scrDetail use htmlViewer
controls inside galleries bound to Power Fx collections, data-bound to SP
for decisions (colRAID filter), RAID rows, gates (new IS Project Gates list).
Schedule-aware progress with today-marker. Compact gate dot clusters.

Bumps from v30.2 (rectangle-based) through v32.7 iteration history covered
in SESSION_HANDOFF.md. Outstanding: milestone timeline, RAG from Status
Summary, app checker polish.
"@
git commit -m $msg
git push

Write-Host "`nDone. Bridge updated. Next session prompt in SESSION_HANDOFF.md." -ForegroundColor Green
Write-Host "`nTip: set `$env:TCC_BRIDGE_REPO = '$BridgeRoot' for future runs so discovery is skipped." -ForegroundColor Gray
