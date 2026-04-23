$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$SourceTree      = Join-Path $WorkspaceFolder "v20\tcc_hub_src"
$OutputMsapp     = Join-Path $WorkspaceFolder "TCC_Portfolio_Dashboard_v32_10.msapp"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Section "Packing v32.10-tasktype-tracks"
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
Write-Host "`nWhat changed vs v32.9.1:" -ForegroundColor Yellow
Write-Host "  - gProjectRowData.GateStrip sources from colTasks filtered by TaskType (not colGates)" -ForegroundColor Gray
Write-Host "  - TCC Expansion -> TaskType='Construction Gate' track" -ForegroundColor Gray
Write-Host "  - NG911 Refresh -> TaskType='Milestone' track" -ForegroundColor Gray
Write-Host "  - VuWall         -> TaskType='Milestone' track" -ForegroundColor Gray
Write-Host "  - Date-positioned when PlannedEnd exists; even-spaced fallback when null" -ForegroundColor Gray
Write-Host "  - Status colors from RAGStatus + PctComplete + ActualEnd (was GateStatus)" -ForegroundColor Gray
Write-Host "  - IS Project Gates list retired for per-project rows; only 7 Portfolio remain" -ForegroundColor Gray
Write-Host "`nImport:" -ForegroundColor Yellow
Write-Host "  1. File -> Apps -> Import -> select $OutputMsapp" -ForegroundColor Gray
Write-Host "  2. Re-add 3 SP connections (IS Project Tasks, IS Project RAID, IS Project Gates)" -ForegroundColor Gray
Write-Host "  3. File -> Settings -> Run OnStart" -ForegroundColor Gray
Write-Host "  4. Verify mini-tracks populate with real TaskType data" -ForegroundColor Gray
