param(
    [string]$SiteUrl               = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
    [string]$ScriptsPath           = '',
    [string]$PowerAppPath          = '',
    [string]$PowerAppEnvironmentId = '',
    [string]$TeamsWebhookUrl       = '',
    [switch]$SkipPreFlight,
    [switch]$SkipScheduler,
    [switch]$DryRun,
    [switch]$Help
)


Set-StrictMode -Version Latest
$ErrorActionPreference = 'Continue'

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Full; exit 0 }

#region -- Paths
if (-not $ScriptsPath) { $ScriptsPath = $PSScriptRoot }
$Version   = '1.0.0'
$StartTime = Get-Date
#endregion

#region -- Console helpers
function Write-Success { param([string]$m) Write-Host "  [OK]  $m" -ForegroundColor Green   }
function Write-Warn    { param([string]$m) Write-Host "  [WARN] $m" -ForegroundColor Yellow  }
function Write-Err     { param([string]$m) Write-Host "  [ERR] $m"  -ForegroundColor Red     }
function Write-Info    { param([string]$m) Write-Host "  [INFO] $m" -ForegroundColor Cyan    }
function Write-Dry     { param([string]$m) Write-Host "  [DRY RUN] $m" -ForegroundColor Magenta }
function Write-Step    { param([string]$m) Write-Host "`n-- $m" -ForegroundColor Cyan }
#endregion

#region -- Deployment log
$DeployLog = [System.Collections.Generic.List[PSObject]]::new()
function Log-Deploy {
    param([string]$Step, [string]$Status, [string]$Detail = '')
    $DeployLog.Add([PSCustomObject]@{
        Time   = (Get-Date -Format 'HH:mm:ss')
        Step   = $Step
        Status = $Status
        Detail = $Detail
    })
}
#endregion

#region -- Banner
Clear-Host
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC IS Portfolio Hub -- Master Deployment Orchestrator     ║' -ForegroundColor Cyan
Write-Host '║   Metropolitan Council IS -- Commercial M365                        ║' -ForegroundColor Cyan
Write-Host "║   Version $Version  |  $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')             ║" -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host ''
Write-Host "  Site    : $SiteUrl" -ForegroundColor White
Write-Host "  Scripts : $ScriptsPath" -ForegroundColor White
Write-Host "  EBC Go-Live : April 29, 2026 ($([math]::Max(0,([datetime]'2026-04-29'-(Get-Date).Date).Days)) days away)" -ForegroundColor Yellow
if ($DryRun) {
    Write-Host ''
    Write-Host '  *** DRY RUN MODE -- no changes will be written ***' -ForegroundColor Magenta
}
Write-Host ''
Write-Host '  Deployment pipeline:' -ForegroundColor Gray
Write-Host '    [1] Pre-Flight Validation' -ForegroundColor Gray
Write-Host '    [2] SharePoint Wire' -ForegroundColor Gray
Write-Host '    [3] pac CLI / PowerApp Import' -ForegroundColor Gray
Write-Host '    [4] Power Automate Flow Import' -ForegroundColor Gray
Write-Host '    [5] Windows Scheduled Task Registration' -ForegroundColor Gray
Write-Host '    [6] Final Summary + Browser Launch' -ForegroundColor Gray
Write-Host ''
Read-Host '  Press ENTER to begin deployment (Ctrl+C to abort)'
#endregion

#region -- Helper: run a sub-script
function Invoke-TCCScript {
    param(
        [string]$ScriptName,
        [string]$DisplayName,
        [string[]]$ExtraArgs = @()
    )
    $scriptFile = Join-Path $ScriptsPath $ScriptName
    if (-not (Test-Path $scriptFile)) {
        Write-Err "Script not found: $scriptFile"
        Log-Deploy $DisplayName 'FAILED' "File not found: $scriptFile"
        return $false
    }
    Write-Info "Running: $ScriptName"
    try {
        $baseArgs = @('-SiteUrl', $SiteUrl)
        if ($DryRun) { $baseArgs += '-DryRun' }
        $allArgs  = $baseArgs + $ExtraArgs
        & $scriptFile @allArgs
        $ec = $LASTEXITCODE
        if ($ec -eq 0 -or $null -eq $ec) {
            Write-Success "$ScriptName completed"
            Log-Deploy $DisplayName 'DONE' 'Exit: 0'
            return $true
        } else {
            Write-Warn "$ScriptName exit code: $ec"
            Log-Deploy $DisplayName 'PARTIAL' "Exit: $ec"
            return $ec
        }
    } catch {
        Write-Err "$ScriptName exception: $_"
        Log-Deploy $DisplayName 'FAILED' $_.Exception.Message
        return $false
    }
}
#endregion

#region ====== STEP 1: Pre-Flight Validation ======
Write-Step 'Step 1/6 -- Pre-Flight Validation'
if ($SkipPreFlight) {
    Write-Warn 'SkipPreFlight flag set -- skipping (not recommended)'
    Log-Deploy 'Pre-Flight' 'SKIPPED' '-SkipPreFlight flag'
} else {
    $pfScript = Join-Path $ScriptsPath 'TCC_PreFlight.ps1'
    if (-not (Test-Path $pfScript)) {
        Write-Err "TCC_PreFlight.ps1 not found in: $ScriptsPath"
        Log-Deploy 'Pre-Flight' 'FAILED' 'Script not found'
        exit 2
    }
    & $pfScript -SiteUrl $SiteUrl
    $pfCode = $LASTEXITCODE
    switch ($pfCode) {
        0 {
            Write-Success 'Pre-flight: All checks PASSED'
            Log-Deploy 'Pre-Flight' 'PASS' 'All checks passed'
        }
        1 {
            Write-Warn 'Pre-flight warnings -- review output above'
            Log-Deploy 'Pre-Flight' 'WARN' 'Warnings present'
            $cont = Read-Host '  Warnings found. Continue anyway? [Y/N]'
            if ($cont -ne 'Y' -and $cont -ne 'y') { Write-Info 'Aborted.'; exit 1 }
        }
        2 {
            Write-Err 'Pre-flight FAILED -- resolve FAIL items first.'
            Log-Deploy 'Pre-Flight' 'ABORTED' 'Exit code 2'
            exit 2
        }
        default {
            Write-Warn "Pre-flight exit code: $pfCode -- continuing"
            Log-Deploy 'Pre-Flight' 'WARN' "Unexpected exit: $pfCode"
        }
    }
}
#endregion

#region ====== STEP 2: SharePoint Wire ======
Write-Step 'Step 2/6 -- SharePoint Wire (columns, formatters, views, indexes)'
Invoke-TCCScript 'SharePoint_Wire.ps1' 'SharePoint Wire' | Out-Null
#endregion

#region ====== STEP 3: pac CLI / PowerApp Import ======
Write-Step 'Step 3/6 -- pac CLI / PowerApp Import'

# pac is a standalone exe -- no admin install required
$pacExe   = $null
$pacPaths = @(
    (Join-Path $ScriptsPath 'pac.exe'),
    (Join-Path $ScriptsPath 'pac\pac.exe'),
    'pac',
    (Join-Path $env:LOCALAPPDATA 'Microsoft\PowerAppsCLI\pac.exe'),
    (Join-Path $env:USERPROFILE  'pac\pac.exe')
) | Select-Object -Unique

foreach ($p in $pacPaths) {
    try {
        $v = & $p --version 2>&1
        if ($LASTEXITCODE -eq 0) {
            $pacExe = $p; Write-Success "pac CLI found: $p"; Log-Deploy 'pac CLI' 'FOUND' $p; break
        }
    } catch { continue }
}

if (-not $pacExe) {
    Write-Warn 'pac CLI not found -- PowerApp import skipped.'
    Write-Host '  Download (no admin needed): https://aka.ms/PowerAppsCLI' -ForegroundColor Yellow
    Write-Host "  Extract pac.exe to: $ScriptsPath" -ForegroundColor Yellow
    Log-Deploy 'pac CLI' 'NOT FOUND' 'Download: https://aka.ms/PowerAppsCLI'
    Read-Host '  Press ENTER to continue without app import'
} elseif (-not $PowerAppPath) {
    Write-Warn 'No -PowerAppPath specified -- skipping PowerApp import.'
    Log-Deploy 'PowerApp Import' 'SKIPPED' 'No -PowerAppPath provided'
} elseif (-not (Test-Path $PowerAppPath)) {
    Write-Err "PowerApp file not found: $PowerAppPath"
    Log-Deploy 'PowerApp Import' 'FAILED' "File not found: $PowerAppPath"
} else {
    Write-Info "Importing PowerApp: $PowerAppPath"
    if ($DryRun) {
        Write-Dry "Would import: $PowerAppPath via pac"
        Log-Deploy 'PowerApp Import' 'DRY RUN' $PowerAppPath
    } else {
        try {
            Write-Info 'Authenticating pac CLI to Commercial tenant (browser will open)...'
            $authArgs = @('auth','create','--kind','USER','--cloud','Public')
            if ($PowerAppEnvironmentId) { $authArgs += @('--environment',$PowerAppEnvironmentId) }
            & $pacExe @authArgs
            Write-Info 'Importing canvas app...'
            if ($PowerAppEnvironmentId) {
                & $pacExe application import --path $PowerAppPath --environment $PowerAppEnvironmentId
            } else {
                & $pacExe canvas pack --msapp $PowerAppPath
            }
            if ($LASTEXITCODE -eq 0) {
                Write-Success 'PowerApp imported successfully'
                Log-Deploy 'PowerApp Import' 'DONE' $PowerAppPath
            } else {
                Write-Warn "pac exited $LASTEXITCODE -- verify in Power Apps portal"
                Log-Deploy 'PowerApp Import' 'WARN' "pac exit: $LASTEXITCODE"
            }
        } catch {
            Write-Err "pac import failed: $_"
            Log-Deploy 'PowerApp Import' 'FAILED' $_.Exception.Message
        }
    }
}
#endregion

#region ====== STEP 4: Power Automate Flow Import ======
Write-Step 'Step 4/6 -- Power Automate Flow Import'

$flowZip = Join-Path (Split-Path $ScriptsPath -Parent) `
    'artifacts\planner-automation\TCC_Flow2_SP_to_Planner_GraphAPI_v2.zip'

Write-Host ''
Write-Host '  Power Automate flows must be imported manually (Commercial M365).' -ForegroundColor Yellow
Write-Host ''
Write-Host '  Steps:' -ForegroundColor Cyan
Write-Host '    1. Go to: https://make.powerautomate.com' -ForegroundColor White
Write-Host '    2. My Flows -> Import -> Import Package (Legacy)' -ForegroundColor White
if (Test-Path $flowZip) {
    Write-Host "    3. Upload: $flowZip" -ForegroundColor Green
    Log-Deploy 'Flow ZIP' 'FOUND' $flowZip
} else {
    Write-Host '    3. Upload: TCC_Flow2_SP_to_Planner_GraphAPI_v2.zip' -ForegroundColor Yellow
    Write-Host "       Expected: $flowZip" -ForegroundColor Gray
    Log-Deploy 'Flow ZIP' 'NOT FOUND' "Expected: $flowZip"
}
Write-Host '    4. Map connections: SharePoint, MSI (Graph), Planner' -ForegroundColor White
Write-Host '    5. Set environment variables: SiteUrl, ListName' -ForegroundColor White
Write-Host '    6. Turn on the flow after import' -ForegroundColor White
Write-Host ''
if ($DryRun) {
    Write-Dry 'Browser NOT opened in DryRun mode'
    Log-Deploy 'Power Automate' 'DRY RUN' 'Browser not opened'
} else {
    $ob = Read-Host '  Open Power Automate portal now? [Y/N]'
    if ($ob -eq 'Y' -or $ob -eq 'y') {
        Start-Process 'https://make.powerautomate.com'
        Write-Success 'Browser opened: https://make.powerautomate.com'
        Log-Deploy 'Power Automate' 'BROWSER OPENED' 'Manual import required'
    } else {
        Write-Warn 'Skipped -- remember to import the flow manually'
        Log-Deploy 'Power Automate' 'SKIPPED' 'User skipped'
    }
}
#endregion

#region ====== STEP 5: Windows Scheduled Task Registration ======
Write-Step 'Step 5/6 -- Windows Scheduled Task Registration'

if ($SkipScheduler) {
    Write-Warn '-SkipScheduler set -- skipping task registration'
    Log-Deploy 'Scheduled Tasks' 'SKIPPED' '-SkipScheduler flag'
} else {
    $psExe = (Get-Process -Id $PID).Path
    if (-not $psExe) { $psExe = 'powershell.exe' }

    function Register-TCCTask {
        param(
            [string]   $TaskName,
            [string]   $ScriptFile,
            [string]   $Description,
            [string]   $TriggerType,
            [string]   $StartTime,
            [string[]] $WeekDays  = @(),
            [string]   $ExtraArgs = ''
        )
        $sf  = Join-Path $ScriptsPath $ScriptFile
        $tArg = ''
        if ($TeamsWebhookUrl) { $tArg = "-TeamsWebhookUrl '$TeamsWebhookUrl'" }
        $arg = "-NonInteractive -ExecutionPolicy Bypass -File `"$sf`" -SiteUrl '$SiteUrl' $tArg $ExtraArgs".Trim()

        Write-Info "Registering: $TaskName ($TriggerType $StartTime)"
        if ($DryRun) {
            Write-Dry "Would register: $TaskName -- $TriggerType $StartTime"
            Log-Deploy "Task: $TaskName" 'DRY RUN' "$TriggerType $StartTime"
            return
        }
        try {
            Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
            if ($TriggerType -eq 'Daily') {
                $trigger = New-ScheduledTaskTrigger -Daily -At ([datetime]::Parse($StartTime))
            } else {
                $trigger = $WeekDays | ForEach-Object {
                    New-ScheduledTaskTrigger -Weekly -DaysOfWeek $_ -At ([datetime]::Parse($StartTime))
                }
            }
            $action   = New-ScheduledTaskAction -Execute $psExe -Argument $arg -WorkingDirectory $ScriptsPath
            $settings = New-ScheduledTaskSettingsSet `
                            -ExecutionTimeLimit (New-TimeSpan -Hours 1) `
                            -StartWhenAvailable `
                            -RunOnlyIfNetworkAvailable
            Register-ScheduledTask `
                -TaskName    $TaskName `
                -Trigger     $trigger `
                -Action      $action `
                -Settings    $settings `
                -Description $Description `
                -RunLevel    Limited `
                -Force | Out-Null
            Write-Success "Registered: $TaskName ($TriggerType $StartTime)"
            Log-Deploy "Task: $TaskName" 'REGISTERED' "$TriggerType $StartTime"
        } catch {
            Write-Err "Failed to register ${TaskName}: $_"
            Log-Deploy "Task: $TaskName" 'FAILED' $_.Exception.Message
        }
    }

    # a) Planner Sync Back -- Mon/Wed/Fri 9:00 AM
    Register-TCCTask `
        -TaskName    'TCC_Planner_Sync_Back' `
        -ScriptFile  'Planner_Sync_Back.ps1' `
        -Description 'TCC: Sync Planner completion back to IS Project Tasks' `
        -TriggerType 'Weekly' `
        -StartTime   '09:00' `
        -WeekDays    @('Monday','Wednesday','Friday')

    # b) Generate Status Report -- Monday 6:00 AM
    Register-TCCTask `
        -TaskName    'TCC_Generate_Status_Report' `
        -ScriptFile  'Generate_Status_Report.ps1' `
        -Description 'TCC: Generate weekly Excel status report and upload to SharePoint' `
        -TriggerType 'Weekly' `
        -StartTime   '06:00' `
        -WeekDays    @('Monday')

    # c) Overdue Scanner -- Daily 7:00 AM
    Register-TCCTask `
        -TaskName    'TCC_Overdue_Scanner' `
        -ScriptFile  'Overdue_Scanner.ps1' `
        -Description 'TCC: Daily scan -- auto-sets RAG=Red on overdue active tasks' `
        -TriggerType 'Daily' `
        -StartTime   '07:00'
}
#endregion

#region -- INLINE FUNCTION: Invoke-OverdueScan
# Mirrors Overdue_Scanner.ps1 logic for ad-hoc use within this session
function Invoke-OverdueScan {
    param(
        [string]$InlineSiteUrl = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
        [string]$LogPath       = '',
        [switch]$DryRun
    )
    if (-not $LogPath) { $LogPath = Join-Path $PSScriptRoot 'logs' }
    if (-not (Test-Path $LogPath)) { New-Item -ItemType Directory -Path $LogPath -Force | Out-Null }
    $lf = Join-Path $LogPath "overdue_scan_$(Get-Date -Format 'yyyy-MM-dd').txt"
    $td = (Get-Date).Date
    function Lg { param([string]$M) Add-Content -Path $lf -Value "[$(Get-Date -Format 'HH:mm:ss')] $M" -ErrorAction SilentlyContinue }
    Write-Info "[OverdueScan] Connecting to $InlineSiteUrl"
    Lg '=== Inline Overdue Scan started ==='
    try {
        Import-Module PnP.PowerShell -ErrorAction Stop
        if (-not (Get-PnPConnection -ErrorAction SilentlyContinue)) {
            Connect-PnPOnline -Url $InlineSiteUrl -UseWebLogin -ErrorAction Stop
        }
    } catch {
        Write-Err "[OverdueScan] Connection failed: $_"; Lg "FATAL: $_"; return
    }
    # CAML: active tasks with <100% complete
    $caml = '<View><Query><Where><And>'
    $caml += '<Eq><FieldRef Name="IsActive"/><Value Type="Boolean">1</Value></Eq>'
    $caml += '<Lt><FieldRef Name="PercentComplete"/><Value Type="Number">100</Value></Lt>'
    $caml += '</And></Where></Query></View>'
    try {
        $cands = Get-PnPListItem -List 'IS Project Tasks' -PageSize 500 `
            -Query $caml `
            -Fields 'Title','Project','DueDate','PercentComplete','RAG','Id' `
            -ErrorAction Stop
    } catch {
        Write-Err "[OverdueScan] Query failed: $_"; Lg "ERROR: $_"; return
    }
    $od  = $cands | Where-Object { $_['DueDate'] -and ([datetime]$_['DueDate'] -lt $td) }
    Write-Info "[OverdueScan] Found $($od.Count) overdue task(s)"
    Lg "Found $($od.Count) overdue"
    $upd = 0
    foreach ($t in $od) {
        if ($t['RAG'] -eq 'Red') { continue }
        if ($DryRun) {
            Write-Dry "[OverdueScan] Would flag Red: $($t['Title'])"; $upd++; continue
        }
        try {
            Set-PnPListItem -List 'IS Project Tasks' -Identity $t.Id `
                -Values @{ RAG = 'Red' } -ErrorAction Stop | Out-Null
            Write-Success "[OverdueScan] Flagged Red: $($t['Title'])"
            Lg "UPDATED Red: [$($t.Id)] $($t['Title'])"
            $upd++
            Start-Sleep -Milliseconds 300
        } catch {
            Write-Err "[OverdueScan] Failed [$($t.Id)]: $_"
        }
    }
    Write-Info "[OverdueScan] Complete -- $upd flagged. Log: $lf"
    Lg "=== Complete Updated=$upd ==="
}
#endregion

#region ====== STEP 6: Final Summary ======
$elapsed = [math]::Round(((Get-Date) - $StartTime).TotalSeconds)
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC DEPLOYMENT COMPLETE                                    ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host ''
Write-Host "  Elapsed : ${elapsed}s" -ForegroundColor Gray
Write-Host "  Time    : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ''
# Print deploy log table
$cw = 44
foreach ($e in $DeployLog) {
    $col = switch ($e.Status) {
        'DONE'           { 'Green'   }
        'PASS'           { 'Green'   }
        'REGISTERED'     { 'Green'   }
        'FOUND'          { 'Green'   }
        'BROWSER OPENED' { 'Green'   }
        'SKIPPED'        { 'Yellow'  }
        'DRY RUN'        { 'Magenta' }
        'NOT FOUND'      { 'Yellow'  }
        'WARN'           { 'Yellow'  }
        'FAILED'         { 'Red'     }
        'ABORTED'        { 'Red'     }
        'PARTIAL'        { 'Yellow'  }
        default          { 'White'   }
    }
    $d = if ($e.Detail) { " -- $($e.Detail)" } else { '' }
    Write-Host "  $($e.Time)  $($e.Step.PadRight($cw))" -NoNewline
    Write-Host " [$($e.Status)]" -ForegroundColor $col -NoNewline
    Write-Host $d -ForegroundColor Gray
}
Write-Host ''
$done  = ($DeployLog | Where-Object { $_.Status -in @('DONE','PASS','REGISTERED','FOUND','BROWSER OPENED') }).Count
$skip  = ($DeployLog | Where-Object { $_.Status -in @('SKIPPED','DRY RUN','NOT FOUND') }).Count
$warns = ($DeployLog | Where-Object { $_.Status -in @('WARN','PARTIAL') }).Count
$fails = ($DeployLog | Where-Object { $_.Status -in @('FAILED','ABORTED') }).Count
Write-Host ("  Steps: " + $DeployLog.Count + " | ") -NoNewline
Write-Host "Done: $done  " -NoNewline -ForegroundColor Green
Write-Host "Skipped: $skip  " -NoNewline -ForegroundColor Yellow
Write-Host "Warnings: $warns  " -NoNewline -ForegroundColor Yellow
$_errCol = if ($fails -gt 0) {'Red'} else {'White'}
Write-Host "Errors: $fails" -ForegroundColor $_errCol
Write-Host ''
if ($DryRun) {
    Write-Host '  DRY RUN -- no changes were written to any system.' -ForegroundColor Magenta
    Write-Host ''
}
if ($fails -gt 0) {
    Write-Host '  Some steps failed -- review errors above.' -ForegroundColor Red
} else {
    Write-Host '  Deployment pipeline complete! Opening TCC Portfolio Hub...' -ForegroundColor Green
}
Write-Host ''
Write-Host '  Scheduled Tasks registered:' -ForegroundColor Cyan
Write-Host '    TCC_Planner_Sync_Back       Mon/Wed/Fri  9:00 AM' -ForegroundColor White
Write-Host '    TCC_Generate_Status_Report  Monday       6:00 AM' -ForegroundColor White
Write-Host '    TCC_Overdue_Scanner         Daily        7:00 AM' -ForegroundColor White
Write-Host ''
Write-Host '  View in Task Scheduler: taskschd.msc -> Task Scheduler Library -> TCC_*' -ForegroundColor Gray
Write-Host ''
if (-not $DryRun) { Start-Sleep -Seconds 2; Start-Process $SiteUrl }
#endregion