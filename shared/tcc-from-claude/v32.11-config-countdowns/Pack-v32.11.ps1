$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$SourceTree      = Join-Path $WorkspaceFolder "v20\tcc_hub_src"
$OutputMsapp     = Join-Path $WorkspaceFolder "TCC_Portfolio_Dashboard_v32_11.msapp"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Section "Packing v32.11-config-countdowns"
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
Write-Host "`nWhat changed vs v32.10:" -ForegroundColor Yellow
Write-Host "  - Countdown targets sourced from IS Portfolio Config SP list (no more hardcoded dates)" -ForegroundColor Gray
Write-Host "  - DAYS TO EBC retargeted to Room 1007 Go-Live (2026-08-15)" -ForegroundColor Gray
Write-Host "  - DAYS TO HARD STOP renamed -> DAYS TO STATE FAIR (2026-08-21)" -ForegroundColor Gray
Write-Host "  - New KPI: DAYS TO TCC FINAL (2026-12-31)" -ForegroundColor Gray
Write-Host "  - KPI strip grid expanded from 7 to 8 columns; gap tightened to 10px" -ForegroundColor Gray
Write-Host "  - gDaysToHardStop aliased to gDaysToStateFair for back-compat on scrDetail" -ForegroundColor Gray
Write-Host "`nPrereq (one-time):" -ForegroundColor Yellow
Write-Host "  Run SP_Create_IS_Portfolio_Config_List.js via Claude-in-Chrome on" -ForegroundColor Gray
Write-Host "  metcmn.sharepoint.com/sites/TCCISPortfolioHub BEFORE importing this build." -ForegroundColor Gray
Write-Host "`nImport:" -ForegroundColor Yellow
Write-Host "  1. File -> Apps -> Import -> select $OutputMsapp" -ForegroundColor Gray
Write-Host "  2. Re-add 4 SP connections (IS Project Tasks, IS Project RAID, IS Project Gates, IS Portfolio Config)" -ForegroundColor Gray
Write-Host "  3. File -> Settings -> Run OnStart" -ForegroundColor Gray
Write-Host "  4. Verify KPI strip shows 8 cards; rightmost three countdowns reflect config dates" -ForegroundColor Gray
