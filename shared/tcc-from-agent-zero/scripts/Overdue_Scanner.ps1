<#
.SYNOPSIS
    Daily scan for overdue tasks — auto-sets RAG=Red on qualifying items.

.DESCRIPTION
    Bonus script (also inlined in TCC_Deploy.ps1) — TCC Program deployment suite.
    Connects to SharePoint, finds tasks where:
      DueDate < Today AND PercentComplete < 100 AND IsActive = Yes
    Sets RAG = 'Red' on each found task.
    Logs all actions to /logs/overdue_scan_YYYY-MM-DD.txt.
    Optionally posts an Adaptive Card summary to a Teams channel via webhook.

.PARAMETER SiteUrl
    SharePoint site URL.

.PARAMETER TeamsWebhookUrl
    Incoming webhook URL for Teams channel notification.
    Leave empty to skip Teams notification.

.PARAMETER LogPath
    Folder path for log files. Defaults to <ScriptDir>/logs/.

.PARAMETER DryRun
    Preview changes without writing to SharePoint.

.PARAMETER Help
    Print usage and exit.

.EXAMPLE
    .\Overdue_Scanner.ps1
    Scan and update RAG silently.

.EXAMPLE
    .\Overdue_Scanner.ps1 -TeamsWebhookUrl "https://outlook.office.com/webhook/..."
    Scan, update, and post summary to Teams.

.EXAMPLE
    .\Overdue_Scanner.ps1 -DryRun
    Preview which tasks would be flagged without making changes.
#>
param(
    [string]$SiteUrl         = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
    [string]$TeamsWebhookUrl = '',
    [string]$LogPath         = '',
    [switch]$DryRun,
    [switch]$Help
)


Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Full; exit 0 }

#region ── Console helpers ───────────────────────────────────────────────────
function Write-Success { param([string]$m) Write-Host "  [OK]  $m" -ForegroundColor Green   }
function Write-Warn    { param([string]$m) Write-Host "  [WARN] $m" -ForegroundColor Yellow  }
function Write-Err     { param([string]$m) Write-Host "  [ERR] $m"  -ForegroundColor Red     }
function Write-Info    { param([string]$m) Write-Host "  [INFO] $m" -ForegroundColor Cyan    }
function Write-Dry     { param([string]$m) Write-Host "  [DRY RUN] $m" -ForegroundColor Magenta }
#endregion

#region ── Logging setup ─────────────────────────────────────────────────────
if (-not $LogPath) { $LogPath = Join-Path $PSScriptRoot 'logs' }
if (-not (Test-Path $LogPath)) { New-Item -ItemType Directory -Path $LogPath -Force | Out-Null }

$LogFile    = Join-Path $LogPath "overdue_scan_$(Get-Date -Format 'yyyy-MM-dd').txt"
$Today      = (Get-Date).Date
$RunStamp   = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

function Write-Log {
    param([string]$Message, [string]$Level = 'INFO')
    $line = "[$RunStamp] [$Level] $Message"
    Add-Content -Path $LogFile -Value $line -ErrorAction SilentlyContinue
    # Also echo notable lines to console
    if ($Level -eq 'ERROR') { Write-Err $Message }
    elseif ($Level -eq 'WARN')  { Write-Warn $Message }
}
#endregion

#region ── Banner ────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC Portfolio Hub — Overdue Task Scanner v1.0              ║' -ForegroundColor Cyan
Write-Host '║   Metropolitan Council IS — Commercial M365                         ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host "  Site    : $SiteUrl"    -ForegroundColor Cyan
Write-Host "  Time    : $RunStamp"   -ForegroundColor Cyan
Write-Host "  Log     : $LogFile"    -ForegroundColor Cyan
if ($DryRun) { Write-Warn 'DRY RUN — no SharePoint writes will occur' }
Write-Host ''

Write-Log "=== Overdue Scanner run started ==="
Write-Log "DryRun=$DryRun Site=$SiteUrl"
#endregion

#region ── STEP 1: Connect to SharePoint ────────────────────────────────────
Write-Info 'Connecting to SharePoint...'
try {
    Import-Module PnP.PowerShell -ErrorAction Stop
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin -ErrorAction Stop
    Write-Success "Connected: $SiteUrl"
    Write-Log "Connected to SharePoint: $SiteUrl"
} catch {
    Write-Err "Failed to connect to SharePoint: $_"
    Write-Log "FATAL: SharePoint connection failed: $_" 'ERROR'
    exit 2
}
#endregion

#region ── STEP 2: Query overdue tasks ───────────────────────────────────────
Write-Host ''
Write-Info 'Querying overdue tasks (DueDate < Today AND %Complete < 100 AND IsActive = Yes)...'

# CAML query: IsActive=Yes AND PercentComplete<100
# DueDate < Today filter applied in PowerShell (CAML Today comparison can have timezone edge cases)
$CamlQuery = @'
<View><Query>
  <Where>
    <And>
      <Eq><FieldRef Name="IsActive"/><Value Type="Boolean">1</Value></Eq>
      <Lt><FieldRef Name="PercentComplete"/><Value Type="Number">100</Value></Lt>
    </And>
  </Where>
</Query></View>
'@

try {
    Write-Progress -Activity 'Overdue Scanner' -Status 'Loading tasks from SharePoint...'
    $candidates = Get-PnPListItem -List 'IS Project Tasks' -PageSize 500 `
        -Query $CamlQuery `
        -Fields 'Title','Project','DueDate','PercentComplete','RAG','AssignedTo','IsActive','Id' `
 -ErrorAction Stop
    Write-Progress -Activity 'Overdue Scanner' -Completed
    Write-Info "Candidate tasks (active, <100%): $($candidates.Count)"
    Write-Log "Loaded $($candidates.Count) candidate tasks"
} catch {
    Write-Err "Failed to query IS Project Tasks: $_"
    Write-Log "FATAL: Query failed: $_" 'ERROR'
    exit 2
}

# Filter in PowerShell: DueDate must be set AND before today
$overdueTasks = $candidates | Where-Object {
    $due = $_['DueDate']
    $due -and ([datetime]$due -lt $Today)
}

Write-Info "Overdue tasks found: $($overdueTasks.Count)"
Write-Log "Overdue tasks identified: $($overdueTasks.Count)"
#endregion

#region ── STEP 3: Update RAG = Red for each overdue task ────────────────────
Write-Host ''
Write-Info 'Processing overdue tasks...'
Write-Host ''

$Updated = 0
$AlreadyRed = 0
$Failed = 0
$OverdueDetails = [System.Collections.Generic.List[PSObject]]::new()

$i = 0
foreach ($task in $overdueTasks) {
    $i++
    $title      = $task['Title']
    $project    = $task['Project']
    $dueDate    = [datetime]$task['DueDate']
    $pct        = $task['PercentComplete']
    $currentRAG = $task['RAG']
    $daysOver   = [int]([datetime]::Today - $dueDate).TotalDays

    # Record detail for Teams notification
    $OverdueDetails.Add([PSCustomObject]@{
        Title      = $title
        Project    = $project
        DueDate    = $dueDate.ToString('yyyy-MM-dd')
        DaysOver   = $daysOver
        Pct        = $pct
        PrevRAG    = $currentRAG
        Action     = ''
    })

    Write-Progress -Activity 'Setting RAG=Red' -Status "$i/$($overdueTasks.Count): $title" `
        -PercentComplete ($i / [Math]::Max($overdueTasks.Count,1) * 100)

    if ($currentRAG -eq 'Red') {
        Write-Info "Already Red — skipping: $title ($project, $daysOver days over)"
        Write-Log "SKIP (already Red): [$($task.Id)] $title | Project=$project | $daysOver days over"
        $OverdueDetails[-1].Action = 'Already Red'
        $AlreadyRed++
        continue
    }

    if ($DryRun) {
        Write-Dry "Would set RAG=Red: $title ($project, was=$currentRAG, $daysOver days over)"
        Write-Log "[DRY RUN] Would set RAG=Red: [$($task.Id)] $title | was=$currentRAG | $daysOver days over"
        $OverdueDetails[-1].Action = 'DRY RUN'
        $Updated++  # Count as would-update for summary
        continue
    }

    # Write RAG = Red to SharePoint
    try {
        Set-PnPListItem -List 'IS Project Tasks' -Identity $task.Id `
            -Values @{ RAG = 'Red' } -ErrorAction Stop | Out-Null

        Write-Success "Set RAG=Red: $title ($project, was=$currentRAG, $daysOver days over)"
        Write-Log "UPDATED RAG=Red: [$($task.Id)] $title | Project=$project | was=$currentRAG | DueDate=$($dueDate.ToString('yyyy-MM-dd')) | $daysOver days over | $pct% complete"
        $OverdueDetails[-1].Action = 'Updated to Red'
        $Updated++

        # Brief throttle guard for large lists
        Start-Sleep -Milliseconds 300
    } catch {
        Write-Err "Failed to update task [$($task.Id)] '$title': $_"
        Write-Log "ERROR: Failed to update [$($task.Id)] ${title}: $_" 'ERROR'
        $OverdueDetails[-1].Action = 'ERROR'
        $Failed++
    }
}

Write-Progress -Activity 'Setting RAG=Red' -Completed
#endregion

#region ── STEP 4: Teams notification ────────────────────────────────────────
if ($TeamsWebhookUrl -and $overdueTasks.Count -gt 0) {
    Write-Host ''
    Write-Info 'Sending Teams notification...'
    Write-Log 'Posting summary to Teams webhook'

    # Build Adaptive Card facts list (top 10 items max)
    $factsJson = ($OverdueDetails | Select-Object -First 10 | ForEach-Object {
        $emoji = if ($_.Action -eq 'Updated to Red') { '🔴' }
                 elseif ($_.Action -eq 'Already Red') { '🔴' }
                 elseif ($_.Action -eq 'DRY RUN')    { '🔍' }
                 else                                 { '⚠️' }
        "{`"title`": `"$emoji $($_.Title)`", `"value`": `"$($_.Project) | Due: $($_.DueDate) ($($_.DaysOver)d over) | $($_.Action)`"}"
    }) -join ','

    $moreText = if ($OverdueDetails.Count -gt 10) { " (+$($OverdueDetails.Count - 10) more)" } else { '' }
    $dryLabel = if ($DryRun) { ' [DRY RUN]' } else { '' }

    $cardBody = @"
{
  "type": "message",
  "attachments": [{
    "contentType": "application/vnd.microsoft.card.adaptive",
    "content": {
      "`$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
      "type": "AdaptiveCard",
      "version": "1.4",
      "body": [
        {
          "type": "TextBlock",
          "text": "⚠️ TCC Overdue Task Scan$dryLabel",
          "weight": "Bolder",
          "size": "Medium",
          "color": "Attention"
        },
        {
          "type": "TextBlock",
          "text": "$(Get-Date -Format 'MMM dd, yyyy') | $($overdueTasks.Count) overdue task(s) found | $Updated updated to Red | $AlreadyRed already Red$moreText",
          "wrap": true,
          "spacing": "Small"
        },
        {
          "type": "FactSet",
          "facts": [ $factsJson ]
        }
      ],
      "actions": [{
        "type": "Action.OpenUrl",
        "title": "View Overdue Tasks",
        "url": "$SiteUrl/Lists/IS%20Project%20Tasks/overdue.aspx"
      }]
    }
  }]
}
"@

    try {
        $response = Invoke-RestMethod -Uri $TeamsWebhookUrl -Method POST `
            -Body $cardBody -ContentType 'application/json' -ErrorAction Stop
        Write-Success 'Teams notification sent'
        Write-Log 'Teams notification posted successfully'
    } catch {
        Write-Warn "Teams notification failed (non-fatal): $_"
        Write-Log "WARN: Teams notification failed: $_" 'WARN'
    }
}
#endregion

#region ── Summary ───────────────────────────────────────────────────────────
Write-Host ''
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host '  OVERDUE SCANNER RESULTS' -ForegroundColor Cyan
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host ''
Write-Host "  Overdue tasks found    : $($overdueTasks.Count)"  -ForegroundColor White
Write-Host "  Updated to Red         : $Updated"   -ForegroundColor $(if ($Updated -gt 0) {'Red'} else {'White'})
Write-Host "  Already Red (skipped)  : $AlreadyRed" -ForegroundColor Yellow
Write-Host "  Errors                 : $Failed"     -ForegroundColor $(if ($Failed -gt 0) {'Red'} else {'White'})
Write-Host "  Log file               : $LogFile"    -ForegroundColor Gray
if ($DryRun) { Write-Host '  [DRY RUN] No changes written.' -ForegroundColor Magenta }
Write-Host ''

Write-Log "=== Scan complete: Found=$($overdueTasks.Count) Updated=$Updated AlreadyRed=$AlreadyRed Errors=$Failed ==="

exit $(if ($Failed -gt 0) { 1 } else { 0 })
#endregion
