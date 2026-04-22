$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$SourceTree      = Join-Path $WorkspaceFolder "v20\tcc_hub_src"
$OutputMsapp     = Join-Path $WorkspaceFolder "TCC_Portfolio_Dashboard_v32_8.msapp"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

# Cleanup orphaned scrHtmlTest files (removed from ScreenOrder in v32.8)
$orphans = @(
    Join-Path $SourceTree "Src\scrHtmlTest.fx.yaml"
    Join-Path $SourceTree "Src\EditorState\scrHtmlTest.editorstate.json"
)
foreach ($f in $orphans) {
    if (Test-Path $f) { Remove-Item $f -Force; Write-Host "  removed orphan $f" -ForegroundColor Gray }
}

Write-Section "Packing v32.8-html-baseline"
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
Write-Host "On import: re-add SP connections (3): IS Project Tasks, IS Project RAID, IS Project Gates" -ForegroundColor Gray
