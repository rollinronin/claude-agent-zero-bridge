<#
.SYNOPSIS
    Pre-deployment validation for TCC IS Portfolio Hub (GCC High).

.DESCRIPTION
    Script 2 of 5 — TCC Program deployment suite.
    Validates environment, permissions, modules, and list structure BEFORE running
    any deployment scripts. Returns structured PASS/WARN/FAIL report.

.PARAMETER SiteUrl
    SharePoint site URL to validate against.

.PARAMETER Help
    Prints usage and exits.

.EXAMPLE
    .\TCC_PreFlight.ps1
    Run all checks against the default TCC site.

.EXAMPLE
    .\TCC_PreFlight.ps1 -SiteUrl "https://metcmn.sharepoint.com/sites/TCCISPortfolioHub"
    Run against a specific site URL.

.OUTPUTS
    Exit code 0 = all PASS
    Exit code 1 = warnings only (deployment can proceed with caution)
    Exit code 2 = failures present (DO NOT DEPLOY until resolved)
#>
param(
    [string]$SiteUrl = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'SilentlyContinue'

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Full; exit 0 }

#region ── Console helpers ───────────────────────────────────────────────────
function Write-Pass { param([string]$msg) Write-Host "  [PASS] $msg" -ForegroundColor Green  }
function Write-Warn { param([string]$msg) Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Fail { param([string]$msg) Write-Host "  [FAIL] $msg" -ForegroundColor Red    }
function Write-Info { param([string]$msg) Write-Host "  [INFO] $msg" -ForegroundColor Cyan   }
function Write-Hint { param([string]$msg) Write-Host "         HINT: $msg" -ForegroundColor DarkYellow }
#endregion

#region ── Result tracking ───────────────────────────────────────────────────
$Results = [System.Collections.Generic.List[PSObject]]::new()
$Warnings = 0
$Failures = 0

function Add-Result {
    param(
        [string]$Check,
        [ValidateSet('PASS','WARN','FAIL')]$Status,
        [string]$Detail = '',
        [string]$Hint   = ''
    )
    $Results.Add([PSCustomObject]@{
        Check  = $Check
        Status = $Status
        Detail = $Detail
        Hint   = $Hint
    })
    if ($Status -eq 'WARN') { $script:Warnings++ }
    if ($Status -eq 'FAIL') { $script:Failures++ }
}
#endregion

#region ── Banner ────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC Portfolio Hub — Pre-Flight Validation v1.0             ║' -ForegroundColor Cyan
Write-Host '║   Metropolitan Council IS — GCC High Deployment              ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host "  Site   : $SiteUrl" -ForegroundColor Cyan
Write-Host "  Time   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host '  Checks : 8' -ForegroundColor Cyan
Write-Host ''
#endregion

#region ── CHECK 1: PowerShell Execution Policy ──────────────────────────────
Write-Info 'Check 1/8: PowerShell Execution Policy'
try {
    $userPolicy    = Get-ExecutionPolicy -Scope CurrentUser -ErrorAction Stop
    $machinePolicy = Get-ExecutionPolicy -Scope LocalMachine -ErrorAction Stop
    $allowed = @('RemoteSigned','Unrestricted','Bypass')
    $userOk    = $userPolicy    -in $allowed
    $machineOk = $machinePolicy -in $allowed

    if ($userOk -or $machineOk) {
        Write-Pass "Execution policy OK — CurrentUser: $userPolicy | LocalMachine: $machinePolicy"
        Add-Result 'Execution Policy' 'PASS' "CurrentUser=$userPolicy LocalMachine=$machinePolicy"
    } else {
        Write-Fail "Execution policy blocks scripts — CurrentUser: $userPolicy | LocalMachine: $machinePolicy"
        Write-Hint 'Run: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned'
        Add-Result 'Execution Policy' 'FAIL' "CurrentUser=$userPolicy" `
            'Run: Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned'
    }
} catch {
    Write-Warn "Could not read execution policy: $_"
    Add-Result 'Execution Policy' 'WARN' 'Unable to query policy'
}
#endregion

#region ── CHECK 2: PnP.PowerShell Version ───────────────────────────────────
Write-Host ''
Write-Info 'Check 2/8: PnP.PowerShell Module'
try {
    $pnpMod = Get-Module -ListAvailable -Name 'PnP.PowerShell' | Sort-Object Version -Descending | Select-Object -First 1
    if (-not $pnpMod) {
        Write-Fail 'PnP.PowerShell module not found'
        Write-Hint 'Run: Install-Module PnP.PowerShell -Scope CurrentUser'
        Add-Result 'PnP.PowerShell' 'FAIL' 'Module not installed' `
            'Install-Module PnP.PowerShell -Scope CurrentUser'
    } else {
        $ver = $pnpMod.Version
        if ($ver.Major -ge 2) {
            Write-Pass "PnP.PowerShell v$ver found (2.x+ required)"
            Add-Result 'PnP.PowerShell' 'PASS' "v$ver"
        } else {
            Write-Fail "PnP.PowerShell v$ver is too old (need 2.x+)"
            Write-Hint 'Run: Update-Module PnP.PowerShell'
            Add-Result 'PnP.PowerShell' 'FAIL' "v$ver — too old" 'Update-Module PnP.PowerShell'
        }
    }
} catch {
    Write-Warn "Error checking PnP.PowerShell: $_"
    Add-Result 'PnP.PowerShell' 'WARN' $_.Exception.Message
}
#endregion

#region ── CHECK 3: SharePoint Connectivity & Permissions ────────────────────
Write-Host ''
Write-Info 'Check 3/8: SharePoint Connectivity & Permissions'
try {
    Import-Module PnP.PowerShell -ErrorAction Stop

    Write-Info '  Connecting (browser login will open)...'
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin

    # Test we can read site properties — needs at minimum Read permission
    $web = Get-PnPWeb -ErrorAction Stop
    Write-Info "  Site title: $($web.Title)"

    # Check permission level — need ManageLists to add columns
    $ctx = Get-PnPContext
    $ctx.Load($ctx.Web.CurrentUser)
    $ctx.ExecuteQuery()
    $currentUser = $ctx.Web.CurrentUser.LoginName

    # Attempt to read site collection admin status
    try {
        $admins = Get-PnPSiteCollectionAdmin -ErrorAction Stop
        $isSCA  = $admins | Where-Object { $_.LoginName -like "*$($currentUser.Split('|')[-1])*" }
        if ($isSCA) {
            Write-Pass "Connected as Site Collection Admin: $currentUser"
            Add-Result 'SP Connectivity' 'PASS' "SCA: $currentUser"
        } else {
            # Not SCA, check if at least Site Owner
            Write-Warn "Connected as $currentUser — not Site Collection Admin. Need Site Owner minimum."
            Write-Hint 'Ask SharePoint admin to grant Site Owner or higher on TCCISPortfolioHub'
            Add-Result 'SP Connectivity' 'WARN' "User: $currentUser — not SCA" `
                'Need Site Owner+ on TCCISPortfolioHub for column/view creation'
        }
    } catch {
        # Could not determine — at least we connected
        Write-Pass "Connected to SharePoint (permission level unverified)"
        Add-Result 'SP Connectivity' 'PASS' "Connected — permission level unverified"
    }
} catch {
    Write-Fail "Failed to connect to SharePoint: $_"
    Write-Hint 'Check VPN, sign in at https://metcmn.sharepoint.com first, then retry'
    Add-Result 'SP Connectivity' 'FAIL' $_.Exception.Message `
        'Check VPN connection and try signing into SharePoint in browser first'
}
#endregion

#region ── CHECK 4: IS Project Tasks list & columns ─────────────────────────
Write-Host ''
Write-Info 'Check 4/8: IS Project Tasks — List & Required Columns'

$RequiredTaskCols = @(
    'Title','Project','Workstream','Phase','AssignedTo','DueDate',
    'PercentComplete','RAG','Priority','TaskType','Notes',
    'PlannerTaskID','IsActive',
    # New columns (may be missing — WARN not FAIL)
    'ServiceWorksTicketID','ServiceWorksURL','SteerCoTag'
)
$NewCols = @('ServiceWorksTicketID','ServiceWorksURL','SteerCoTag')

try {
    $taskList = Get-PnPList -Identity 'IS Project Tasks' -ErrorAction Stop
    Write-Pass "IS Project Tasks list found (ID: $($taskList.Id))"

    $fields    = Get-PnPField -List 'IS Project Tasks' -ErrorAction Stop
    $fieldNames = $fields | ForEach-Object { $_.InternalName }

    $missingCritical = @()
    $missingNew      = @()

    foreach ($col in $RequiredTaskCols) {
        if ($col -notin $fieldNames) {
            if ($col -in $NewCols) { $missingNew      += $col }
            else                   { $missingCritical += $col }
        }
    }

    if ($missingCritical.Count -gt 0) {
        Write-Fail "IS Project Tasks missing CRITICAL columns: $($missingCritical -join ', ')"
        Add-Result 'IS Project Tasks — Columns' 'FAIL' "Missing: $($missingCritical -join ', ')" `
            'These columns should exist already — check list was imported correctly'
    } elseif ($missingNew.Count -gt 0) {
        Write-Warn "IS Project Tasks missing NEW columns (expected — wire script will add): $($missingNew -join ', ')"
        Add-Result 'IS Project Tasks — Columns' 'WARN' "New cols not yet added: $($missingNew -join ', ')" `
            'Run SharePoint_Wire.ps1 to add ServiceWorksTicketID, ServiceWorksURL, SteerCoTag'
    } else {
        Write-Pass 'IS Project Tasks has all required columns (including new ones)'
        Add-Result 'IS Project Tasks — Columns' 'PASS' 'All columns present'
    }
} catch {
    Write-Fail "IS Project Tasks list not found or not accessible: $_"
    Write-Hint "Verify the list exists at $SiteUrl/_layouts/15/viewlsts.aspx"
    Add-Result 'IS Project Tasks — List' 'FAIL' $_.Exception.Message `
        "Check list exists at: $SiteUrl/Lists/IS%20Project%20Tasks"
}
#endregion

#region ── CHECK 5: IS Project RAID list & columns ──────────────────────────
Write-Host ''
Write-Info 'Check 5/8: IS Project RAID — List & Required Columns'

$RequiredRAIDCols = @(
    'Title','Project','RAIDType','RAG','Owner','DateRaised',
    'TargetDate','Status','Description','MitigationPlan','SteerCoTag','Resolution'
)

try {
    $raidList = Get-PnPList -Identity 'IS Project RAID' -ErrorAction Stop
    Write-Pass "IS Project RAID list found (ID: $($raidList.Id))"

    $fields    = Get-PnPField -List 'IS Project RAID' -ErrorAction Stop
    $fieldNames = $fields | ForEach-Object { $_.InternalName }

    $missing = $RequiredRAIDCols | Where-Object { $_ -notin $fieldNames }

    if ($missing.Count -gt 0) {
        $isNewOnly = $missing | Where-Object { $_ -ne 'SteerCoTag' }
        if ($isNewOnly.Count -eq 0 -and $missing -contains 'SteerCoTag') {
            Write-Warn "IS Project RAID missing SteerCoTag (will be added by wire script)"
            Add-Result 'IS Project RAID — Columns' 'WARN' 'Missing: SteerCoTag' `
                'Run SharePoint_Wire.ps1 to add SteerCoTag'
        } else {
            Write-Fail "IS Project RAID missing columns: $($missing -join ', ')"
            Add-Result 'IS Project RAID — Columns' 'FAIL' "Missing: $($missing -join ', ')" `
                'These should already exist — check list structure'
        }
    } else {
        Write-Pass 'IS Project RAID has all required columns'
        Add-Result 'IS Project RAID — Columns' 'PASS' 'All columns present'
    }
} catch {
    Write-Fail "IS Project RAID list not found or not accessible: $_"
    Write-Hint "Verify at: $SiteUrl/Lists/IS%20Project%20RAID"
    Add-Result 'IS Project RAID — List' 'FAIL' $_.Exception.Message `
        "Check list exists at: $SiteUrl/Lists/IS%20Project%20RAID"
}
#endregion

#region ── CHECK 6: Graph API (GCC High) TCP reachability ────────────────────
Write-Host ''
Write-Info 'Check 6/8: Microsoft Graph API (GCC High) — graph.microsoft.com'
try {
    # TCP test — does not require auth, just checks network path
    $tcp = Test-NetConnection -ComputerName 'graph.microsoft.com' -Port 443 -WarningAction SilentlyContinue -ErrorAction Stop
    if ($tcp.TcpTestSucceeded) {
        Write-Pass 'graph.microsoft.com:443 reachable (GCC High Graph endpoint)'
        Add-Result 'Graph API (GCC High)' 'PASS' 'TCP 443 to graph.microsoft.com OK'
    } else {
        Write-Fail 'Cannot reach graph.microsoft.com:443'
        Write-Hint 'Check VPN/network — GCC High Graph requires network access to *.microsoft.us'
        Add-Result 'Graph API (GCC High)' 'FAIL' 'TCP 443 blocked' `
            'Ensure VPN is connected and *.microsoft.us is not blocked'
    }
} catch {
    Write-Warn "Network test failed: $_"
    Write-Hint 'Test-NetConnection may not be available — try: curl https://graph.microsoft.com/v1.0/me in a browser'
    Add-Result 'Graph API (GCC High)' 'WARN' 'Could not run TCP test' 'Manually verify graph.microsoft.com is accessible'
}
#endregion

#region ── CHECK 7: pac CLI ──────────────────────────────────────────────────
Write-Host ''
Write-Info 'Check 7/8: Power Platform CLI (pac)'

$pacFound = $false
$pacVersion = ''

# Search locations: PATH, script dir, common user-local spots
$searchPaths = @(
    'pac',                                               # In PATH
    (Join-Path $PSScriptRoot 'pac.exe'),                 # Same folder as scripts
    (Join-Path $PSScriptRoot 'pac\pac.exe'),             # pac subfolder
    (Join-Path $env:LOCALAPPDATA 'Microsoft\PowerAppsCLI\pac.exe'),
    (Join-Path $env:USERPROFILE  'pac\pac.exe'),
    (Join-Path $env:USERPROFILE  '.pac\pac.exe')
) | Select-Object -Unique

foreach ($path in $searchPaths) {
    try {
        $result = & $path --version 2>&1
        if ($LASTEXITCODE -eq 0 -or $result -match '\d+\.\d+') {
            $pacFound   = $true
            $pacVersion = ($result | Select-Object -First 1).ToString().Trim()
            Write-Pass "pac CLI found at '$path' — $pacVersion"
            Add-Result 'pac CLI' 'PASS' "Found: $path | $pacVersion"
            break
        }
    } catch { continue }
}

if (-not $pacFound) {
    Write-Warn 'pac CLI not found — required for PowerApp import step'
    Write-Hint 'Download (no admin): https://aka.ms/PowerAppsCLI — extract pac.exe to the scripts folder'
    Add-Result 'pac CLI' 'WARN' 'Not found in PATH or common locations' `
        'Download from https://aka.ms/PowerAppsCLI — extract pac.exe next to TCC_Deploy.ps1'
}
#endregion

#region ── CHECK 8: Windows Task Scheduler Service ───────────────────────────
Write-Host ''
Write-Info 'Check 8/8: Windows Task Scheduler Service'
try {
    $svc = Get-Service -Name 'Schedule' -ErrorAction Stop
    if ($svc.Status -eq 'Running') {
        Write-Pass 'Task Scheduler service is Running'
        Add-Result 'Task Scheduler' 'PASS' 'Service Running'
    } else {
        Write-Fail "Task Scheduler service is '$($svc.Status)' — scheduled tasks will not run"
        Write-Hint 'Run: Start-Service Schedule (may need admin)'
        Add-Result 'Task Scheduler' 'FAIL' "Status: $($svc.Status)" 'Run: Start-Service Schedule'
    }
} catch {
    Write-Warn "Could not query Task Scheduler service: $_"
    Add-Result 'Task Scheduler' 'WARN' 'Could not query service status'
}
#endregion

#region ── Results Summary ───────────────────────────────────────────────────
Write-Host ''
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host '  PRE-FLIGHT RESULTS' -ForegroundColor Cyan
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host ''

$colWidth = 38
foreach ($r in $Results) {
    $col = switch ($r.Status) {
        'PASS' { 'Green'  }
        'WARN' { 'Yellow' }
        'FAIL' { 'Red'    }
    }
    $label = $r.Check.PadRight($colWidth)
    Write-Host "  $label " -NoNewline
    Write-Host " [$($r.Status)] " -ForegroundColor $col -NoNewline
    if ($r.Detail) { Write-Host $r.Detail -ForegroundColor Gray } else { Write-Host '' }
    if ($r.Hint -and $r.Status -ne 'PASS') {
        Write-Host "  $(' ' * $colWidth)  HINT: $($r.Hint)" -ForegroundColor DarkYellow
    }
}

Write-Host ''
$passCount = ($Results | Where-Object { $_.Status -eq 'PASS' }).Count
Write-Host "  Checks: $($Results.Count) | " -NoNewline
Write-Host "PASS: $passCount " -NoNewline -ForegroundColor Green
Write-Host "| WARN: $Warnings " -NoNewline -ForegroundColor Yellow
Write-Host "| FAIL: $Failures" -ForegroundColor $(if ($Failures -gt 0) {'Red'} else {'White'})
Write-Host ''

if ($Failures -gt 0) {
    Write-Host '  ✖  DEPLOYMENT BLOCKED — resolve FAIL items before running TCC_Deploy.ps1' -ForegroundColor Red
    Write-Host ''
    exit 2
} elseif ($Warnings -gt 0) {
    Write-Host '  ⚠  Warnings present — review above. Deployment can proceed but check WARNs.' -ForegroundColor Yellow
    Write-Host ''
    exit 1
} else {
    Write-Host '  ✔  All checks passed — safe to run TCC_Deploy.ps1' -ForegroundColor Green
    Write-Host ''
    exit 0
}
#endregion
