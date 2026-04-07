#Requires -Module PnP.PowerShell
<#
.SYNOPSIS
    T6 — Load 14 IS Milestones into SharePoint IS Milestones list
.DESCRIPTION
    Connects to TCCISPortfolioHub, discovers the IS Milestones list columns,
    then adds all 14 milestones via Add-PnPListItem.
    Auth: -UseWebLogin (browser SSO — same method as SharePoint_Wire.ps1)
.NOTES
    Run on Windows with PnP.PowerShell installed:
      Install-Module PnP.PowerShell -Scope CurrentUser
      pwsh Load_IS_Milestones.ps1
    Or run directly from container if display is available.
#>

$SiteUrl  = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub'
$ListName = 'IS Milestones'

function Write-Success { param($msg) Write-Host "  ✅ $msg" -ForegroundColor Green }
function Write-Err     { param($msg) Write-Host "  ❌ $msg" -ForegroundColor Red }
function Write-Info    { param($msg) Write-Host "  ℹ️  $msg" -ForegroundColor Cyan }
function Write-Warn    { param($msg) Write-Host "  ⚠️  $msg" -ForegroundColor Yellow }

Write-Host ''
Write-Host '════════════════════════════════════════════════════════════' -ForegroundColor Cyan
Write-Host '  T6 — TCC IS Portfolio Hub: Load IS Milestones' -ForegroundColor Cyan
Write-Host "  Site     : $SiteUrl" -ForegroundColor Cyan
Write-Host "  List     : $ListName" -ForegroundColor Cyan
Write-Host '════════════════════════════════════════════════════════════' -ForegroundColor Cyan
Write-Host ''

# ── STEP 1: Connect ──────────────────────────────────────────────────────────
Write-Host '▶ STEP 1: Connecting (browser SSO window will open)...' -ForegroundColor Yellow
try {
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin -ErrorAction Stop
    Write-Success "Connected to $SiteUrl"
} catch {
    Write-Err "Connection failed: $_"
    exit 1
}

# ── STEP 2: Discover list field internal names ────────────────────────────────
Write-Host ''
Write-Host "▶ STEP 2: Discovering field names on '$ListName'..." -ForegroundColor Yellow
try {
    $fields = Get-PnPField -List $ListName -ErrorAction Stop |
        Where-Object { -not $_.Hidden -and $_.InternalName -ne 'ContentType' } |
        Select-Object Title, InternalName, TypeAsString |
        Sort-Object Title
    Write-Info 'Fields found (use InternalName in Add-PnPListItem):'
    $fields | Format-Table -AutoSize | Out-String | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
} catch {
    Write-Warn "Could not retrieve fields: $_ — will attempt with assumed names"
    $fields = $null
}

# ── STEP 3: Build milestone payload ──────────────────────────────────────────
# Field name mapping attempt order:
#   Primary:   Title, Project, WBS_Number, Planned_Start, Planned_End, RAG_Status, Owner, Notes
#   Fallback:  Title only (if primary fields not found)

$milestones = @(
    [ordered]@{ Title='NTP — Construction Notice to Proceed';         Project='TCC Expansion'; WBS_Number='M-NTP';   Planned_Start='2026-04-15'; Planned_End='2026-04-15'; RAG_Status='Pending';  Owner='Mark Oelrich';      Notes='Gate for all Phase 2 IS work. IS cannot influence construction schedule.' },
    [ordered]@{ Title='Room 1007 network design complete';              Project='TCC Expansion'; WBS_Number='M-04';    Planned_Start='2026-04-01'; Planned_End='2026-04-14'; RAG_Status='On Track'; Owner='Leng Ly';           Notes='Power specs to contractor → hardware order → design finalization.' },
    [ordered]@{ Title='EBC fully operational — Room 1007';             Project='TCC Expansion'; WBS_Number='M-05';    Planned_Start='2026-04-30'; Planned_End='2026-04-30'; RAG_Status='Pending';  Owner='IS PM';             Notes='Working target. Formal review at April 22 SteerCo.' },
    [ordered]@{ Title='EBC operations begin (COOP window opens)';      Project='TCC Expansion'; WBS_Number='M-05B';   Planned_Start='2026-05-01'; Planned_End='2026-05-01'; RAG_Status='Pending';  Owner='IS PM';             Notes='MPLS becomes fallback. Outage-risk changes to MPLS must pause.' },
    [ordered]@{ Title='IS decision package — SteerCo presentation';    Project='NG911 Refresh'; WBS_Number='M-NG1';   Planned_Start='2026-04-22'; Planned_End='2026-04-22'; RAG_Status='On Track'; Owner='IS PM';             Notes='Discussion only. No funding vote at April 22.' },
    [ordered]@{ Title='911 Funding Decision';                           Project='NG911 Refresh'; WBS_Number='M-06';    Planned_Start='2026-06-30'; Planned_End='2026-06-30'; RAG_Status='Pending';  Owner='SteerCo';           Notes='Scenario A (~$600K) is IS recommendation. Decision unlocks implementation.' },
    [ordered]@{ Title='VuWall BCA design proposal submitted';           Project='VuWall';        WBS_Number='M-VW1';   Planned_Start='2026-06-01'; Planned_End='2026-06-01'; RAG_Status='Pending';  Owner='Eric Brown (LASO)'; Notes='~8 weeks to BCA approval after submission. Clock starts here.' },
    [ordered]@{ Title='Phase 2 network baseline known';                 Project='TCC Expansion'; WBS_Number='M-NET1';  Planned_Start='2026-06-01'; Planned_End='2026-06-30'; RAG_Status='TBD';      Owner='IS Network';        Notes='Byproduct of VuWall BCA current-state documentation work.' },
    [ordered]@{ Title='VuWall BCA approval';                            Project='VuWall';        WBS_Number='M-VW2';   Planned_Start='2026-07-31'; Planned_End='2026-07-31'; RAG_Status='TBD';      Owner='BCA (Minnesota)';   Notes='Gate for AV LAN provisioning and POC installation. IS has no control over timeline.' },
    [ordered]@{ Title='Construction activity begins';                   Project='TCC Expansion'; WBS_Number='M-CONST'; Planned_Start='2026-08-01'; Planned_End='2026-08-01'; RAG_Status='TBD';      Owner='Mark Oelrich';      Notes='TBD post-NTP. Working assumption August 2026.' },
    [ordered]@{ Title='IS operational separation complete — NG911';    Project='NG911 Refresh'; WBS_Number='M-NG2';   Planned_Start='2026-11-30'; Planned_End='2026-11-30'; RAG_Status='TBD';      Owner='IS + FE';           Notes='4 Mitel lines removed. Vendor (Solacom) owns decom delivery.' },
    [ordered]@{ Title='Phase 2 IS infrastructure ready';               Project='TCC Expansion'; WBS_Number='M-08';    Planned_Start='2026-11-30'; Planned_End='2026-11-30'; RAG_Status='TBD';      Owner='IS Network';        Notes='Gate for TCC go-live. All Phase 2 network work complete.' },
    [ordered]@{ Title='Construction complete';                          Project='TCC Expansion'; WBS_Number='M-CONST2';Planned_Start='2026-11-30'; Planned_End='2026-11-30'; RAG_Status='TBD';      Owner='Mark Oelrich';      Notes='Gate for return to Minneapolis permanent space.' },
    [ordered]@{ Title='TCC go-live — 30 consoles';                     Project='TCC Expansion'; WBS_Number='M-09';    Planned_Start='2026-12-15'; Planned_End='2026-12-15'; RAG_Status='TBD';      Owner='IS PM';             Notes='Construction-gated. Full 30-console TCC operational.' }
)

# ── STEP 4: Add items ─────────────────────────────────────────────────────────
Write-Host ''
Write-Host "▶ STEP 4: Adding $($milestones.Count) milestones to '$ListName'..." -ForegroundColor Yellow
Write-Host '  (If field-name errors occur, the script will retry with Title only)' -ForegroundColor Gray
Write-Host ''

$success  = 0
$partial  = 0
$failed   = 0
$results  = @()

foreach ($m in $milestones) {
    $title = $m.Title
    try {
        $item = Add-PnPListItem -List $ListName -Values $m -ErrorAction Stop
        Write-Success "[ID $($item.Id)] $title"
        $success++
        $results += [PSCustomObject]@{ Status='✅ OK'; ID=$item.Id; Title=$title }
    } catch {
        $err1 = $_
        Write-Warn "Full-row add failed for '$title': $err1"
        # Retry with Title only
        try {
            $item = Add-PnPListItem -List $ListName -Values @{ Title=$title } -ErrorAction Stop
            Write-Warn "[ID $($item.Id)] Title-only added — OTHER FIELDS NEED MANUAL ENTRY: $title"
            $partial++
            $results += [PSCustomObject]@{ Status='⚠️ PARTIAL'; ID=$item.Id; Title=$title }
        } catch {
            Write-Err "COMPLETE FAILURE for '$title': $_"
            $failed++
            $results += [PSCustomObject]@{ Status='❌ FAIL'; ID='N/A'; Title=$title }
        }
    }
}

# ── STEP 5: Summary ───────────────────────────────────────────────────────────
Write-Host ''
Write-Host '════════════════════════════════════════════════════════════' -ForegroundColor Cyan
Write-Host "  RESULTS: $success full ✅  |  $partial partial ⚠️  |  $failed failed ❌" -ForegroundColor Cyan
Write-Host '════════════════════════════════════════════════════════════' -ForegroundColor Cyan
Write-Host ''
$results | Format-Table -AutoSize

if ($partial -gt 0) {
    Write-Host ''
    Write-Warn "$partial items added with TITLE ONLY. The actual column internal names in SharePoint"
    Write-Warn 'did not match the expected names. Check the field list printed in Step 2 above'
    Write-Warn 'and share it with the agent to generate a corrected script.'
}
