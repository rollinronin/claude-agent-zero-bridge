<#
.SYNOPSIS
    Generates a formatted Excel status report from live SharePoint data.

.DESCRIPTION
    Script 4 of 5 — TCC Program deployment suite.
    Pulls IS Project Tasks (IsActive=Yes) and IS Project RAID (Status!=Closed),
    creates a multi-sheet Excel workbook, and uploads it to the SharePoint
    Shared Documents/Status Reports/ library.

    Sheets produced:
      1. Executive Summary  - RAG by project, completion %, open RAID counts, EBC countdown
      2. Task Detail        - All active tasks with overdue flag
      3. RAID Log           - All open items sorted by RAG then project
      4. Milestone Tracker  - Tasks where TaskType = Milestone

    Excel generation: uses ImportExcel module if available, COM automation otherwise.

.PARAMETER SiteUrl
    SharePoint site URL.

.PARAMETER OutputPath
    Local folder for the generated XLSX. Defaults to script directory.

.PARAMETER SkipUpload
    Generate locally but skip uploading to SharePoint.

.PARAMETER Help
    Print usage and exit.

.EXAMPLE
    .\Generate_Status_Report.ps1
    Generate and upload to SharePoint.

.EXAMPLE
    .\Generate_Status_Report.ps1 -SkipUpload -OutputPath "C:\Reports"
    Generate locally only.
#>
param(
    [string]$SiteUrl    = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
    [string]$OutputPath = '',
    [switch]$SkipUpload,
    [switch]$Help
)


Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Full; exit 0 }

#region ── Console helpers ───────────────────────────────────────────────────
function Write-Success { param([string]$m) Write-Host "  [OK]  $m" -ForegroundColor Green  }
function Write-Warn    { param([string]$m) Write-Host "  [WARN] $m" -ForegroundColor Yellow }
function Write-Err     { param([string]$m) Write-Host "  [ERR] $m"  -ForegroundColor Red    }
function Write-Info    { param([string]$m) Write-Host "  [INFO] $m" -ForegroundColor Cyan   }
#endregion

#region ── Config ────────────────────────────────────────────────────────────
$EBCDate      = [datetime]'2026-04-29'           # Phase 1 Go-Live hard stop
$SPLibraryPath = 'Shared Documents/Status Reports' # SP doc library relative path
$Today        = (Get-Date).Date
$DateStamp    = Get-Date -Format 'yyyy-MM-dd'
$FileName     = "TCC_Status_Report_$DateStamp.xlsx"

if (-not $OutputPath) { $OutputPath = $PSScriptRoot }
if (-not (Test-Path $OutputPath)) { New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null }
$LocalFile = Join-Path $OutputPath $FileName
#endregion

#region ── Banner ────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC Portfolio Hub — Status Report Generator v1.0           ║' -ForegroundColor Cyan
Write-Host '║   Metropolitan Council IS — Commercial M365                         ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host "  Output : $LocalFile" -ForegroundColor Cyan
Write-Host "  EBC    : $EBCDate ($(($EBCDate - $Today).Days) days away)" -ForegroundColor Cyan
Write-Host "  Time   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
Write-Host ''
#endregion

#region ── STEP 1: Connect to SharePoint ────────────────────────────────────
Write-Host '── Step 1: Connecting to SharePoint ────────────────────────────' -ForegroundColor Cyan
try {
    Import-Module PnP.PowerShell -ErrorAction Stop
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin -ErrorAction Stop
    Write-Success "Connected: $SiteUrl"
} catch {
    Write-Err "SharePoint connection failed: $_"
    exit 2
}
#endregion

#region ── STEP 2: Load data from SharePoint ────────────────────────────────
Write-Host ''
Write-Host '── Step 2: Loading SharePoint data ─────────────────────────────' -ForegroundColor Cyan

# ── IS Project Tasks (active only) ───────────────────────────────────────────
try {
    Write-Progress -Activity 'Loading data' -Status 'IS Project Tasks (IsActive=Yes)...'
    $taskItems = Get-PnPListItem -List 'IS Project Tasks' -PageSize 500 `
        -Query '<View><Query><Where><Eq><FieldRef Name="IsActive"/><Value Type="Boolean">1</Value></Eq></Where></Query></View>' `
        -Fields 'Title','Project','Workstream','Phase','AssignedTo','DueDate',
                'PercentComplete','RAG','Priority','TaskType','Notes',
                'PlannerTaskID','IsActive','SteerCoTag','ServiceWorksTicketID' `
 -ErrorAction Stop
    Write-Success "Loaded $($taskItems.Count) active tasks"
} catch {
    Write-Err "Failed to load IS Project Tasks: $_"
    exit 2
}

# ── IS Project RAID (open items only) ────────────────────────────────────────
try {
    Write-Progress -Activity 'Loading data' -Status 'IS Project RAID (Status!=Closed)...'
    $raidItems = Get-PnPListItem -List 'IS Project RAID' -PageSize 500 `
        -Query '<View><Query><Where><Neq><FieldRef Name="Status"/><Value Type="Text">Closed</Value></Neq></Where></Query></View>' `
        -Fields 'Title','Project','RAIDType','RAG','Owner','DateRaised',
                'TargetDate','Status','Description','MitigationPlan','SteerCoTag' `
 -ErrorAction Stop
    Write-Success "Loaded $($raidItems.Count) open RAID items"
} catch {
    Write-Err "Failed to load IS Project RAID: $_"
    exit 2
}

Write-Progress -Activity 'Loading data' -Completed
#endregion

#region ── STEP 3: Build data objects for Excel ──────────────────────────────
Write-Host ''
Write-Host '── Step 3: Building report data ────────────────────────────────' -ForegroundColor Cyan

# Helper: safely read SP item field
function Get-Field {
    param($Item, [string]$Field, $Default = '')
    try {
        $val = $Item[$Field]
        if ($null -eq $val) { return $Default }
        # Handle user field objects
        if ($val -is [Microsoft.SharePoint.Client.FieldUserValue]) { return $val.LookupValue }
        if ($val -is [Microsoft.SharePoint.Client.FieldUserValue[]]) { return ($val | ForEach-Object { $_.LookupValue }) -join '; ' }
        return $val
    } catch { return $Default }
}

# ── Task rows ────────────────────────────────────────────────────────────────
$TaskRows = @(foreach ($item in $taskItems) {
    $dueDate   = Get-Field $item 'DueDate'
    $pct       = [int](Get-Field $item 'PercentComplete' 0)
    $isOverdue = $dueDate -and ([datetime]$dueDate -lt $Today) -and ($pct -lt 100)
    $dueDays   = if ($isOverdue) { "OVERDUE ($([math]::Abs(([datetime]$dueDate - $Today).Days)) days)" } else { $dueDate }

    [PSCustomObject]@{
        Title              = Get-Field $item 'Title'
        Project            = Get-Field $item 'Project'
        Workstream         = Get-Field $item 'Workstream'
        Phase              = Get-Field $item 'Phase'
        AssignedTo         = Get-Field $item 'AssignedTo'
        DueDate            = if ($dueDate) { [datetime]$dueDate } else { $null }
        OverdueFlag        = if ($isOverdue) { 'OVERDUE' } else { '' }
        PercentComplete    = $pct
        RAG                = Get-Field $item 'RAG'
        Priority           = Get-Field $item 'Priority'
        TaskType           = Get-Field $item 'TaskType'
        SteerCoTag         = Get-Field $item 'SteerCoTag' $false
        ServiceWorksTicket = Get-Field $item 'ServiceWorksTicketID'
        Notes              = Get-Field $item 'Notes'
    }
})

# ── RAID rows ─────────────────────────────────────────────────────────────────
$RAIDRows = @(foreach ($item in $raidItems) {
    [PSCustomObject]@{
        Title          = Get-Field $item 'Title'
        Project        = Get-Field $item 'Project'
        RAIDType       = Get-Field $item 'RAIDType'
        RAG            = Get-Field $item 'RAG'
        Owner          = Get-Field $item 'Owner'
        DateRaised     = Get-Field $item 'DateRaised'
        TargetDate     = Get-Field $item 'TargetDate'
        Status         = Get-Field $item 'Status'
        Description    = Get-Field $item 'Description'
        MitigationPlan = Get-Field $item 'MitigationPlan'
        SteerCoTag     = Get-Field $item 'SteerCoTag' $false
    }
}) | Sort-Object @{Expression='RAG';Descending=$false}, Project

# ── Milestones ────────────────────────────────────────────────────────────────
$MilestoneRows = $TaskRows | Where-Object { $_.TaskType -eq 'Milestone' } | Sort-Object DueDate

# ── Executive Summary: aggregate by project ───────────────────────────────────
$Projects = $TaskRows | Select-Object -ExpandProperty Project | Sort-Object -Unique
$ExecRows = foreach ($proj in $Projects) {
    $projTasks  = $TaskRows | Where-Object { $_.Project -eq $proj }
    $totalTasks = $projTasks.Count
    $avgPct     = if ($totalTasks -gt 0) {
                    [math]::Round(($projTasks | Measure-Object -Property PercentComplete -Average).Average, 1)
                  } else { 0 }
    $redCount   = ($projTasks | Where-Object { $_.RAG -eq 'Red'   }).Count
    $amberCount = ($projTasks | Where-Object { $_.RAG -eq 'Amber' }).Count
    $greenCount = ($projTasks | Where-Object { $_.RAG -eq 'Green' }).Count
    $overdueCount = ($projTasks | Where-Object { $_.OverdueFlag -eq 'OVERDUE' }).Count
    $openRAID   = ($RAIDRows  | Where-Object { $_.Project -eq $proj }).Count

    # Overall project RAG: worst-case rule
    $projRAG = if ($redCount -gt 0)   { 'Red' }
               elseif ($amberCount -gt 0) { 'Amber' }
               else { 'Green' }

    [PSCustomObject]@{
        Project             = $proj
        'Overall RAG'       = $projRAG
        'Tasks (Total)'     = $totalTasks
        'Avg Completion %'  = $avgPct
        'Red Tasks'         = $redCount
        'Amber Tasks'       = $amberCount
        'Green Tasks'       = $greenCount
        'Overdue Tasks'     = $overdueCount
        'Open RAID Items'   = $openRAID
        'Days to EBC'       = ($EBCDate - $Today).Days
        'EBC Date'          = $EBCDate
    }
}

Write-Success "Executive summary built: $($ExecRows.Count) projects"
Write-Success "Task rows: $($TaskRows.Count) | RAID rows: $($RAIDRows.Count) | Milestones: $($MilestoneRows.Count)"
#endregion

#region ── STEP 4: Generate Excel workbook ───────────────────────────────────
Write-Host ''
Write-Host '── Step 4: Generating Excel workbook ───────────────────────────' -ForegroundColor Cyan

$UseImportExcel = [bool](Get-Module -ListAvailable -Name 'ImportExcel')

if ($UseImportExcel) {
    #region ── ImportExcel path (preferred) ─────────────────────────────────
    Write-Info 'Using ImportExcel module (no Excel installation required)'
    Import-Module ImportExcel -ErrorAction Stop

    # Remove existing file to avoid conflicts
    if (Test-Path $LocalFile) { Remove-Item $LocalFile -Force }

    # ── Sheet 1: Executive Summary ───────────────────────────────────────────
    Write-Progress -Activity 'Building Excel' -Status 'Sheet 1: Executive Summary' -PercentComplete 10
    $ExecRows | Export-Excel -Path $LocalFile -WorksheetName 'Executive Summary' `
        -TableName 'ExecSummary' -TableStyle Medium2 `
        -AutoSize -FreezeTopRow -BoldTopRow -AutoFilter `
        -ConditionalText @(
            New-ConditionalText -Text 'Red'   -ConditionalTextColor ([System.Drawing.Color]::DarkRed)   -BackgroundColor ([System.Drawing.Color]::FromArgb(255,199,206))
            New-ConditionalText -Text 'Amber' -ConditionalTextColor ([System.Drawing.Color]::FromArgb(156,101,0))  -BackgroundColor ([System.Drawing.Color]::FromArgb(255,235,156))
            New-ConditionalText -Text 'Green' -ConditionalTextColor ([System.Drawing.Color]::DarkGreen)  -BackgroundColor ([System.Drawing.Color]::FromArgb(198,239,206))
        )

    # ── Sheet 2: Task Detail ─────────────────────────────────────────────────
    Write-Progress -Activity 'Building Excel' -Status 'Sheet 2: Task Detail' -PercentComplete 35
    $TaskRows | Export-Excel -Path $LocalFile -WorksheetName 'Task Detail' `
        -TableName 'TaskDetail' -TableStyle Medium6 `
        -AutoSize -FreezeTopRow -BoldTopRow -AutoFilter `
        -ConditionalText @(
            New-ConditionalText -Text 'OVERDUE' -ConditionalTextColor ([System.Drawing.Color]::DarkRed) -BackgroundColor ([System.Drawing.Color]::FromArgb(255,199,206))
            New-ConditionalText -Text 'Red'     -ConditionalTextColor ([System.Drawing.Color]::DarkRed)   -BackgroundColor ([System.Drawing.Color]::FromArgb(255,199,206))
            New-ConditionalText -Text 'Amber'   -ConditionalTextColor ([System.Drawing.Color]::FromArgb(156,101,0))  -BackgroundColor ([System.Drawing.Color]::FromArgb(255,235,156))
        ) -Append

    # ── Sheet 3: RAID Log ────────────────────────────────────────────────────
    Write-Progress -Activity 'Building Excel' -Status 'Sheet 3: RAID Log' -PercentComplete 60
    $RAIDRows | Export-Excel -Path $LocalFile -WorksheetName 'RAID Log' `
        -TableName 'RAIDLog' -TableStyle Medium9 `
        -AutoSize -FreezeTopRow -BoldTopRow -AutoFilter `
        -ConditionalText @(
            New-ConditionalText -Text 'Red'   -ConditionalTextColor ([System.Drawing.Color]::DarkRed)   -BackgroundColor ([System.Drawing.Color]::FromArgb(255,199,206))
            New-ConditionalText -Text 'Amber' -ConditionalTextColor ([System.Drawing.Color]::FromArgb(156,101,0))  -BackgroundColor ([System.Drawing.Color]::FromArgb(255,235,156))
        ) -Append

    # ── Sheet 4: Milestone Tracker ───────────────────────────────────────────
    Write-Progress -Activity 'Building Excel' -Status 'Sheet 4: Milestone Tracker' -PercentComplete 85
    if ($MilestoneRows.Count -gt 0) {
        $MilestoneRows | Export-Excel -Path $LocalFile -WorksheetName 'Milestone Tracker' `
            -TableName 'Milestones' -TableStyle Medium14 `
            -AutoSize -FreezeTopRow -BoldTopRow -AutoFilter `
            -ConditionalText @(
                New-ConditionalText -Text 'OVERDUE' -ConditionalTextColor ([System.Drawing.Color]::DarkRed) -BackgroundColor ([System.Drawing.Color]::FromArgb(255,199,206))
            ) -Append
    } else {
        # Write placeholder if no milestones
        [PSCustomObject]@{ Note = 'No milestone-type tasks found in active IS Project Tasks' } |
            Export-Excel -Path $LocalFile -WorksheetName 'Milestone Tracker' -Append
    }

    Write-Progress -Activity 'Building Excel' -Completed
    Write-Success "Workbook saved: $LocalFile"
    #endregion

} else {
    #region ── COM automation fallback (requires Excel installed) ───────────
    Write-Warn 'ImportExcel not found — using COM automation (Excel must be installed)'
    Write-Info 'Install ImportExcel for better results: Install-Module ImportExcel -Scope CurrentUser'

    try {
        $excel = New-Object -ComObject Excel.Application
        $excel.Visible = $false
        $excel.DisplayAlerts = $false
        $wb = $excel.Workbooks.Add()

        function Add-COMSheet {
            param($Workbook, [string]$SheetName, $Data, [int]$Index)
            if ($Index -le $Workbook.Sheets.Count) {
                $ws = $Workbook.Sheets.Item($Index)
                $ws.Name = $SheetName
            } else {
                $ws = $Workbook.Sheets.Add([System.Reflection.Missing]::Value, $Workbook.Sheets.Item($Workbook.Sheets.Count))
                $ws.Name = $SheetName
            }

            if (-not $Data -or @($Data).Count -eq 0) { return $ws }

            # Write headers
            $headers = @($Data)[0].PSObject.Properties.Name
            for ($c = 0; $c -lt $headers.Count; $c++) {
                $ws.Cells.Item(1, $c + 1) = $headers[$c]
                $ws.Cells.Item(1, $c + 1).Font.Bold = $true
                $ws.Cells.Item(1, $c + 1).Interior.Color = 0x4472C4  # blue header
                $ws.Cells.Item(1, $c + 1).Font.Color = 0xFFFFFF
            }

            # Write data rows
            $row = 2
            foreach ($obj in $Data) {
                for ($c = 0; $c -lt $headers.Count; $c++) {
                    $val = $obj.($headers[$c])
                    if ($val -is [datetime]) { $ws.Cells.Item($row, $c + 1) = $val.ToString('yyyy-MM-dd') }
                    elseif ($null -eq $val)  { $ws.Cells.Item($row, $c + 1) = '' }
                    else                      { $ws.Cells.Item($row, $c + 1) = $val.ToString() }

                    # RAG colouring in COM
                    $ragVal = $obj.PSObject.Properties['RAG']
                    if ($ragVal -and $c -eq $headers.IndexOf('RAG')) {
                        switch ($ragVal.Value) {
                            'Red'   { $ws.Cells.Item($row, $c+1).Interior.Color = 0x6666FF; break }  # light red (BGR)
                            'Amber' { $ws.Cells.Item($row, $c+1).Interior.Color = 0x009CFF; break }  # amber
                            'Green' { $ws.Cells.Item($row, $c+1).Interior.Color = 0x00C000; break }  # green
                        }
                    }
                }
                $row++
            }

            # Auto-fit columns
            $ws.UsedRange.Columns.AutoFit() | Out-Null
            return $ws
        }

        Add-COMSheet $wb 'Executive Summary'  $ExecRows     1
        Add-COMSheet $wb 'Task Detail'        $TaskRows     2
        Add-COMSheet $wb 'RAID Log'           $RAIDRows     3
        Add-COMSheet $wb 'Milestone Tracker'  $MilestoneRows 4

        # Delete default extra sheets if any
        while ($wb.Sheets.Count -gt 4) {
            $wb.Sheets.Item($wb.Sheets.Count).Delete()
        }

        $wb.SaveAs($LocalFile, 51)  # 51 = xlOpenXMLWorkbook
        $wb.Close($false)
        $excel.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
        Write-Success "Workbook saved via COM: $LocalFile"
    } catch {
        Write-Err "COM Excel automation failed: $_"
        Write-Warn 'Install ImportExcel module: Install-Module ImportExcel -Scope CurrentUser'
        exit 2
    }
    #endregion
}
#endregion

#region ── STEP 5: Upload to SharePoint ─────────────────────────────────────
Write-Host ''
Write-Host '── Step 5: Uploading to SharePoint ─────────────────────────────' -ForegroundColor Cyan

if ($SkipUpload) {
    Write-Warn "SkipUpload flag set — file saved locally only: $LocalFile"
} else {
    try {
        Write-Progress -Activity 'Uploading to SharePoint' -Status $FileName

        # Ensure the Status Reports folder exists in the library
        $folderUrl = $SPLibraryPath
        try {
            Resolve-PnPFolder -SiteRelativePath $folderUrl -ErrorAction Stop | Out-Null
        } catch {
            # Folder may not exist — create it
            Add-PnPFolder -Name 'Status Reports' -Folder 'Shared Documents' -ErrorAction SilentlyContinue | Out-Null
        }

        # Upload the file
        Add-PnPFile -Path $LocalFile -Folder $folderUrl -ErrorAction Stop | Out-Null
        Write-Progress -Activity 'Uploading to SharePoint' -Completed
        Write-Success "Uploaded: $SiteUrl/$folderUrl/$FileName"
    } catch {
        Write-Err "Upload failed: $_"
        Write-Warn "File is still available locally: $LocalFile"
    }
}
#endregion

#region ── Summary ───────────────────────────────────────────────────────────
Write-Host ''
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host '  STATUS REPORT COMPLETE' -ForegroundColor Cyan
Write-Host '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━' -ForegroundColor Cyan
Write-Host ''
Write-Host "  File     : $FileName"                                            -ForegroundColor White
Write-Host "  Projects : $($ExecRows.Count)"                                   -ForegroundColor White
Write-Host "  Tasks    : $($TaskRows.Count) active"                            -ForegroundColor White
Write-Host "  Overdue  : $(($TaskRows | Where-Object {$_.OverdueFlag -eq 'OVERDUE'}).Count)" -ForegroundColor $(if (($TaskRows | Where-Object {$_.OverdueFlag -eq 'OVERDUE'}).Count -gt 0) {'Red'} else {'White'})
Write-Host "  RAID     : $($RAIDRows.Count) open"                              -ForegroundColor White
Write-Host "  EBC      : $EBCDate ($( ($EBCDate - $Today).Days ) days)"        -ForegroundColor Cyan
if (-not $SkipUpload) {
    Write-Host "  SP Path  : $SiteUrl/$SPLibraryPath/$FileName"                -ForegroundColor Green
}
Write-Host ''
#endregion
