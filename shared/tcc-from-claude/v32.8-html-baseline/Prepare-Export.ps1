$ErrorActionPreference = 'Stop'
$WorkspaceFolder = "$HOME\OneDrive\Documents\Claude\Projects\TCC IS Portfolio Hub"
$ExportedMsapp   = Join-Path $WorkspaceFolder "v32_5_with_gates_export.msapp"
$UnpackFolder    = Join-Path $WorkspaceFolder "v32_5_with_gates_src"
$ScratchExtract  = Join-Path $env:TEMP "tcc_export_scratch"

function Write-Section($msg) { Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Section "Scanning Downloads + workspace for newest export"
$scanPaths = @("$HOME\Downloads", $WorkspaceFolder)
$source = $scanPaths | ForEach-Object {
    Get-ChildItem $_ -Recurse -Include "*.msapp","*.zip" -EA SilentlyContinue
} | Where-Object {
    $_.Name -match "TCC.*Portfolio|Portfolio.*TCC"
} | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-not $source) {
    Write-Host "FAIL: No .zip or .msapp found in Downloads" -ForegroundColor Red
    return
}

Write-Host "  Found: $($source.Name)" -ForegroundColor Gray
Write-Host "  Size:  $([math]::Round($source.Length/1MB, 2)) MB" -ForegroundColor Gray

if ($source.Extension -eq '.zip') {
    Write-Section "Extracting zip"
    if (Test-Path $ScratchExtract) { Remove-Item $ScratchExtract -Recurse -Force }
    Expand-Archive -LiteralPath $source.FullName -DestinationPath $ScratchExtract -Force

    $msappInside = Get-ChildItem $ScratchExtract -Recurse -Filter "*.msapp" -EA SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1

    if (-not $msappInside) {
        Write-Host "FAIL: Zip contained no .msapp" -ForegroundColor Red
        return
    }

    Write-Host "  Msapp inside: $($msappInside.Name) ($([math]::Round($msappInside.Length/1MB, 2)) MB)" -ForegroundColor Gray
    $actualMsapp = $msappInside.FullName
} else {
    $actualMsapp = $source.FullName
}

Write-Section "Staging"
Copy-Item -LiteralPath $actualMsapp -Destination $ExportedMsapp -Force
Write-Host "  $ExportedMsapp" -ForegroundColor Green

if (Test-Path $UnpackFolder) { Remove-Item $UnpackFolder -Recurse -Force }
Write-Section "pac canvas unpack"
Set-Location $WorkspaceFolder
pac canvas unpack --msapp $ExportedMsapp --sources $UnpackFolder

if (Test-Path $ScratchExtract) { Remove-Item $ScratchExtract -Recurse -Force }

Write-Section "Checking for htmlViewer template"
$ctrlTemplatesPath = Join-Path $UnpackFolder "ControlTemplates.json"
$ctrlTemplates = Get-Content $ctrlTemplatesPath -Raw
$registered = [regex]::Matches($ctrlTemplates, '"Name":\s*"([^"]+)"') | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

Write-Host "  Templates registered:" -ForegroundColor Gray
$registered | ForEach-Object { Write-Host "    - $_" -ForegroundColor Gray }

$hasHtmlViewer = $registered -contains 'htmlViewer'
$pkgsXml = Get-ChildItem (Join-Path $UnpackFolder "pkgs") -Filter "htmlViewer*.xml" -EA SilentlyContinue

Write-Host ""
if ($hasHtmlViewer) {
    Write-Host "  [OK] htmlViewer registered in ControlTemplates.json" -ForegroundColor Green
} else {
    Write-Host "  [MISSING] htmlViewer NOT in ControlTemplates.json" -ForegroundColor Red
}

if ($pkgsXml) {
    Write-Host "  [OK] pkgs\$($pkgsXml.Name) present" -ForegroundColor Green
} else {
    Write-Host "  [MISSING] no htmlViewer*.xml in pkgs\" -ForegroundColor Red
}

if ($hasHtmlViewer -and $pkgsXml) {
    Write-Section "SUCCESS - ready for Claude to harvest"
    Write-Host "Tell Claude: 'ready'" -ForegroundColor White
    Write-Host "Unpacked location: $UnpackFolder" -ForegroundColor Gray
} else {
    Write-Section "Not ready"
    Write-Host "The export did not capture the HtmlText control." -ForegroundColor Yellow
    Write-Host "Verify the scratch app has exactly ONE HTML Text control on its screen," -ForegroundColor Yellow
    Write-Host "then Save the app and re-export." -ForegroundColor Yellow
}
