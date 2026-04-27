$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$SourceTree      = Join-Path $WorkspaceFolder "v20\tcc_hub_src"
$OutputMsapp     = Join-Path $WorkspaceFolder "TCC_Portfolio_Dashboard_v32_11_3.msapp"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Section "Packing v32.11.3-a11y-gallery-fix"
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
Write-Host "`nWhat changed vs v32.11.2:" -ForegroundColor Yellow
Write-Host "  - galExecProjects: AccessibleLabel + TabIndex=0" -ForegroundColor Gray
Write-Host "  - galRAID: AccessibleLabel (dynamic with item count + filter context) + TabIndex=0" -ForegroundColor Gray
Write-Host "`nTarget: Accessibility count 4 -> 0 in App Checker." -ForegroundColor Yellow
Write-Host "`nNo SP schema changes. No new connections required." -ForegroundColor Yellow
Write-Host "`nImport:" -ForegroundColor Yellow
Write-Host "  1. File -> Apps -> Import -> select $OutputMsapp" -ForegroundColor Gray
Write-Host "  2. File -> Settings -> Run OnStart" -ForegroundColor Gray
Write-Host "  3. Verify footer shows v32.11.3-a11y-gallery-fix" -ForegroundColor Gray
Write-Host "  4. Run App Checker -> Recheck all -> Accessibility should be 0" -ForegroundColor Gray
