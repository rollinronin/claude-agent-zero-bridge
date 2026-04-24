$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$SourceTree      = Join-Path $WorkspaceFolder "v20\tcc_hub_src"
$OutputMsapp     = Join-Path $WorkspaceFolder "TCC_Portfolio_Dashboard_v32_11_2.msapp"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Section "Packing v32.11.2-a11y-perf-polish"
Set-Location $WorkspaceFolder
if (Test-Path $OutputMsapp) { Remove-Item $OutputMsapp -Force }

pac canvas pack --sources $SourceTree --msapp $OutputMsapp

if (-not (Test-Path $OutputMsapp)) {
    Write-Host "`nFAIL: pack did not produce output." -ForegroundColor Red
    return
}

$sizeMB = [math]::Round((Get-Item $OutputMsapp).Length / 1MB, 2)
Write-Host "`n  Packed: $sizeMB MB" -ForegroundColor Green
Write-Host "`nFile: $OutputMsapp" -ForegroundColor White
Write-Host "`nWhat changed vs v32.11.1:" -ForegroundColor Yellow
Write-Host "  - #4 Label clip fix: portfolio-gate labels now anchor-align at track edges" -ForegroundColor Gray
Write-Host "    (LeftPct >= 92: right-align; LeftPct <= 8: left-align; else centered)" -ForegroundColor Gray
Write-Host "  - #3 Perf: colProjSummary LookUp hoisted into parent With() scope" -ForegroundColor Gray
Write-Host "    Before: 4 LookUps per project row (12 total). After: 1 per row (3 total)." -ForegroundColor Gray
Write-Host "  - #3 A11y: AccessibleLabel added to all 6 htmlViewer controls" -ForegroundColor Gray
Write-Host "    (htmlKPIStrip, htmlDecisions, htmlPortfolioTrack, htmlProjRow, htmlDetailKPIs, htmlRaidRow)" -ForegroundColor Gray
Write-Host "`nNo SP schema changes. No new connections required." -ForegroundColor Yellow
Write-Host "`nImport:" -ForegroundColor Yellow
Write-Host "  1. File -> Apps -> Import -> select $OutputMsapp" -ForegroundColor Gray
Write-Host "  2. (Connections should persist from v32.11.1 import)" -ForegroundColor Gray
Write-Host "  3. File -> Settings -> Run OnStart" -ForegroundColor Gray
Write-Host "  4. Verify footer shows v32.11.2-a11y-perf-polish" -ForegroundColor Gray
Write-Host "  5. Run App Checker and confirm a11y warnings drop (target: 4 -> 0)" -ForegroundColor Gray
Write-Host "  6. Visually confirm 'Go-Live / Complete' label no longer overruns track" -ForegroundColor Gray
