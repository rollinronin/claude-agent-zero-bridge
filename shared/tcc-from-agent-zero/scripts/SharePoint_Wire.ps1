<#
.SYNOPSIS
    Wires SharePoint lists, columns, JSON formatting, views, and indexes
    for the TCC IS Portfolio Hub at Metropolitan Council (Commercial M365).

.DESCRIPTION
    Script 1 of 5 — TCC Program deployment suite.
    - Adds missing columns to IS Project Tasks
    - Applies JSON column formatters (RAG pills, progress bar, hyperlink, overdue, SteerCo badge)
    - Creates standard views on IS Project Tasks and IS Project RAID
    - Indexes key columns for Power Automate performance
    - Outputs a full change summary report

.PARAMETER SiteUrl
    SharePoint site URL. Defaults to TCCISPortfolioHub.

.PARAMETER DryRun
    Shows what WOULD happen without making any changes.

.PARAMETER SkipFormatting
    Skip applying JSON column formatters (structural changes only).

.PARAMETER SkipViews
    Skip creating list views.

.PARAMETER Help
    Prints usage and exits.

.EXAMPLE
    .\SharePoint_Wire.ps1
    Full run against production site.

.EXAMPLE
    .\SharePoint_Wire.ps1 -DryRun -Verbose
    Preview all changes without executing.

.EXAMPLE
    .\SharePoint_Wire.ps1 -SkipFormatting -SkipViews
    Add missing columns only.
#>
[CmdletBinding(SupportsShouldProcess)]
param(
    [string]$SiteUrl        = 'https://metcmn.sharepoint.com/sites/TCCISPortfolioHub',
    [switch]$DryRun,
    [switch]$SkipFormatting,
    [switch]$SkipViews,
    [switch]$Help
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

#region ── Colour-coded console helpers ─────────────────────────────────────
function Write-Success { param([string]$msg) Write-Host "  [OK]  $msg" -ForegroundColor Green  }
function Write-Warn    { param([string]$msg) Write-Host "  [WARN] $msg" -ForegroundColor Yellow }
function Write-Err     { param([string]$msg) Write-Host "  [ERR] $msg"  -ForegroundColor Red    }
function Write-Info    { param([string]$msg) Write-Host "  [INFO] $msg" -ForegroundColor Cyan   }
function Write-Dry     { param([string]$msg) Write-Host "  [DRY RUN] $msg" -ForegroundColor Magenta }
#endregion

if ($Help) { Get-Help $MyInvocation.MyCommand.Path -Full; exit 0 }

#region ── Summary tracking ─────────────────────────────────────────────────
$Summary = [System.Collections.Generic.List[PSObject]]::new()
function Add-Summary {
    param(
        [string]$Category,
        [string]$Item,
        [string]$Status,
        [string]$Detail = ''
    )
    $Summary.Add([PSCustomObject]@{
        Category = $Category
        Item     = $Item
        Status   = $Status
        Detail   = $Detail
    })
}
#endregion

#region ── Banner ────────────────────────────────────────────────────────────
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   TCC Portfolio Hub — SharePoint Wire Script v1.1            ║' -ForegroundColor Cyan
Write-Host '║   Metropolitan Council IS — Commercial M365 | PnP 2.12.0              ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host "  Site   : $SiteUrl" -ForegroundColor Cyan
Write-Host "  Time   : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Cyan
if ($DryRun) { Write-Warn 'DRY RUN MODE — no changes will be made to SharePoint' }
Write-Host ''
#endregion

#region ── JSON Formatter Definitions ───────────────────────────────────────
# NOTE: JSON strings stored as PowerShell here-strings.
# These are applied via Set-PnPField -Values @{ CustomFormatter = $json }

# ── RAG column: colour pills with emoji prefix ────────────────────────────
$RAGFormatter = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "style": { "display": "flex", "align-items": "center" },
  "children": [{
    "elmType": "div",
    "style": {
      "padding": "4px 12px",
      "border-radius": "12px",
      "font-weight": "600",
      "font-size": "12px",
      "background-color": { "operator": "?", "operands": [
        { "operator": "==", "operands": ["[$RAG]", "Red"] },   "rgba(192,0,0,0.12)",
        { "operator": "?", "operands": [
          { "operator": "==", "operands": ["[$RAG]", "Amber"] }, "rgba(255,192,0,0.18)",
          "rgba(112,173,71,0.15)"
        ]}
      ]},
      "color": { "operator": "?", "operands": [
        { "operator": "==", "operands": ["[$RAG]", "Red"] },   "rgba(192,0,0,1)",
        { "operator": "?", "operands": [
          { "operator": "==", "operands": ["[$RAG]", "Amber"] }, "rgba(170,120,0,1)",
          "rgba(56,118,29,1)"
        ]}
      ]},
      "border": { "operator": "?", "operands": [
        { "operator": "==", "operands": ["[$RAG]", "Red"] },   "1px solid rgba(192,0,0,0.4)",
        { "operator": "?", "operands": [
          { "operator": "==", "operands": ["[$RAG]", "Amber"] }, "1px solid rgba(255,192,0,0.5)",
          "1px solid rgba(112,173,71,0.5)"
        ]}
      ]}
    },
    "txtContent": { "operator": "?", "operands": [
      { "operator": "==", "operands": ["[$RAG]", "Red"] },   "\uD83D\uDD34 Red",
      { "operator": "?", "operands": [
        { "operator": "==", "operands": ["[$RAG]", "Amber"] }, "\uD83D\uDFE1 Amber",
        "\uD83D\uDFE2 Green"
      ]}
    ]}
  }]
}
'@

# ── PercentComplete: progress bar with colour banding ─────────────────────
$ProgressFormatter = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "style": { "display": "flex", "flex-direction": "column", "min-width": "110px", "gap": "3px" },
  "children": [
    {
      "elmType": "span",
      "style": {
        "font-size": "11px", "font-weight": "600",
        "color": { "operator": "?", "operands": [
          { "operator": "<", "operands": ["[$PercentComplete]", 30] }, "rgba(192,0,0,1)",
          { "operator": "?", "operands": [
            { "operator": "<", "operands": ["[$PercentComplete]", 70] }, "rgba(170,120,0,1)",
            "rgba(56,118,29,1)"
          ]}
        ]}
      },
      "txtContent": { "operator": "+", "operands": ["[$PercentComplete]", "%"] }
    },
    {
      "elmType": "div",
      "style": {
        "background-color": "#e0e0e0", "border-radius": "4px",
        "height": "8px", "width": "100%", "overflow": "hidden"
      },
      "children": [{
        "elmType": "div",
        "style": {
          "height": "100%", "border-radius": "4px",
          "width": { "operator": "+", "operands": [
            { "operator": "toString()", "operands": ["[$PercentComplete]"] }, "%"
          ]},
          "background-color": { "operator": "?", "operands": [
            { "operator": "<", "operands": ["[$PercentComplete]", 30] }, "rgba(192,0,0,0.85)",
            { "operator": "?", "operands": [
              { "operator": "<", "operands": ["[$PercentComplete]", 70] }, "rgba(255,192,0,0.9)",
              "rgba(112,173,71,0.9)"
            ]}
          ]}
        }
      }]
    }
  ]
}
'@

# ── ServiceWorksURL: clickable hyperlink with chain-link icon ─────────────
$ServiceWorksURLFormatter = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "children": [{
    "elmType": "a",
    "style": {
      "display": "flex", "align-items": "center",
      "color": "#0078d4", "text-decoration": "none", "font-size": "13px"
    },
    "attributes": {
      "href":   "[$ServiceWorksURL.Url]",
      "target": "_blank",
      "rel":    "noopener noreferrer"
    },
    "children": [
      { "elmType": "span", "style": { "margin-right": "5px" }, "txtContent": "\uD83D\uDD17" },
      { "elmType": "span", "txtContent": { "operator": "?", "operands": [
        { "operator": "!=", "operands": ["[$ServiceWorksURL.Url]", ""] },
        "[$ServiceWorksURL.Description]", ""
      ]}}
    ]
  }]
}
'@

# ── DueDate: overdue warning (red) or normal date ─────────────────────────
$DueDateFormatter = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "style": { "display": "flex", "align-items": "center" },
  "children": [{
    "elmType": "span",
    "style": {
      "color": { "operator": "?", "operands": [
        { "operator": "&&", "operands": [
          { "operator": "<", "operands": ["[$DueDate]", "@now"] },
          { "operator": "<", "operands": ["[$PercentComplete]", 100] }
        ]}, "rgba(192,0,0,1)", "inherit"
      ]},
      "font-weight": { "operator": "?", "operands": [
        { "operator": "&&", "operands": [
          { "operator": "<", "operands": ["[$DueDate]", "@now"] },
          { "operator": "<", "operands": ["[$PercentComplete]", 100] }
        ]}, "700", "400"
      ]}
    },
    "txtContent": { "operator": "?", "operands": [
      { "operator": "&&", "operands": [
        { "operator": "<", "operands": ["[$DueDate]", "@now"] },
        { "operator": "<", "operands": ["[$PercentComplete]", 100] }
      ]},
      { "operator": "+", "operands": [
        "\u26A0\uFE0F ",
        { "operator": "toString()", "operands": [
          { "operator": "floor()", "operands": [
            { "operator": "/", "operands": [
              { "operator": "-", "operands": ["@now", "[$DueDate]"] },
              86400000
            ]}
          ]}
        ]},
        " days overdue"
      ]},
      { "operator": "toLocaleDateString()", "operands": ["[$DueDate]"] }
    ]}
  }]
}
'@

# ── SteerCoTag: blue badge if Yes, empty if No ────────────────────────────
$SteerCoFormatter = @'
{
  "$schema": "https://developer.microsoft.com/json-schemas/sp/v2/column-formatting.schema.json",
  "elmType": "div",
  "children": [{
    "elmType": "div",
    "style": {
      "display":          { "operator": "?", "operands": ["[$SteerCoTag]", "inline-flex", "none"] },
      "align-items":      "center",
      "padding":          "3px 9px",
      "border-radius":    "10px",
      "background-color": "rgba(0,120,212,0.1)",
      "color":            "rgba(0,80,160,1)",
      "border":           "1px solid rgba(0,120,212,0.3)",
      "font-size":        "12px",
      "font-weight":      "600"
    },
    "txtContent": "\uD83D\uDCCA SteerCo"
  }]
}
'@
#endregion

#region ── Helper Functions ──────────────────────────────────────────────────

function Test-ColumnExists {
    param([string]$ListName, [string]$ColumnName)
    try {
        $fields = Get-PnPField -List $ListName -ErrorAction Stop
        return [bool]($fields | Where-Object { $_.InternalName -eq $ColumnName -or $_.Title -eq $ColumnName })
    } catch { return $false }
}

function Add-ColumnIfMissing {
    param(
        [string]$ListName,
        [string]$DisplayName,
        [string]$InternalName,
        [ValidateSet('Text','URL','Boolean','Choice','Number','DateTime','Note','User')]$FieldType,
        [string]$DefaultValue = '',
        [string[]]$Choices = @()
    )
    if (Test-ColumnExists -ListName $ListName -ColumnName $InternalName) {
        Write-Warn "Column '$InternalName' already exists in '$ListName' — skipping"
        Add-Summary 'Column' "$ListName.$InternalName" 'SKIPPED' 'Already exists'
        return
    }
    if ($DryRun) {
        Write-Dry "Would add column '$InternalName' ($FieldType) to '$ListName'"
        Add-Summary 'Column' "$ListName.$InternalName" 'DRY RUN' "Would add $FieldType field"
        return
    }
    try {
        Write-Progress -Activity 'Adding Columns' -Status "$ListName.$InternalName"
        switch ($FieldType) {
            'Text' {
                Add-PnPField -List $ListName -DisplayName $DisplayName -InternalName $InternalName `
                    -Type Text -AddToDefaultView $false | Out-Null
            }
            'URL' {
                Add-PnPField -List $ListName -DisplayName $DisplayName -InternalName $InternalName `
                    -Type URL -AddToDefaultView $false | Out-Null
            }
            'Boolean' {
                # Boolean with default requires XML provisioning
                $def = if ($DefaultValue) { $DefaultValue } else { '0' }
                $xml = "<Field Type='Boolean' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName'><Default>$def</Default></Field>"
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
            'Choice' {
                # Build CHOICES XML block
                $choiceXml = ($Choices | ForEach-Object { "      <CHOICE>$_</CHOICE>" }) -join "`n"
                $defVal    = if ($DefaultValue) { "<Default>$DefaultValue</Default>" } else { '' }
                $xml = @"
<Field Type='Choice' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName' Format='Dropdown'>
  $defVal
  <CHOICES>
$choiceXml
  </CHOICES>
</Field>
"@
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
            'Number' {
                $minMax = if ($DefaultValue) { " Min='0' Max='100'" } else { '' }
                $xml = "<Field Type='Number' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName'$minMax />"
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
            'DateTime' {
                $xml = "<Field Type='DateTime' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName' Format='DateOnly' />"
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
            'Note' {
                $xml = "<Field Type='Note' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName' NumLines='6' RichText='FALSE' />"
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
            'User' {
                $xml = "<Field Type='User' DisplayName='$DisplayName' Name='$InternalName' StaticName='$InternalName' UserSelectionMode='PeopleAndGroups' />"
                Add-PnPFieldFromXml -List $ListName -FieldXml $xml | Out-Null
            }
        }
        Write-Success "Added '$InternalName' ($FieldType) to '$ListName'"
        Add-Summary 'Column' "$ListName.$InternalName" 'ADDED' "Type: $FieldType"
    } catch {
        Write-Err "Failed to add '$InternalName' to '$ListName': $_"
        Add-Summary 'Column' "$ListName.$InternalName" 'FAILED' $_.Exception.Message
    }
}

function Apply-ColumnFormatter {
    param(
        [string]$ListName,
        [string]$FieldName,
        [string]$JsonFormatter,
        [string]$FriendlyName
    )
    if ($SkipFormatting) {
        Write-Info "Skipping formatter for '$FieldName' (SkipFormatting)"
        Add-Summary 'Formatter' "$ListName.$FieldName" 'SKIPPED' 'SkipFormatting flag'
        return
    }
    if ($DryRun) {
        Write-Dry "Would apply $FriendlyName formatter to '$ListName.$FieldName'"
        Add-Summary 'Formatter' "$ListName.$FieldName" 'DRY RUN' "Would apply: $FriendlyName"
        return
    }
    try {
        Write-Progress -Activity 'Applying Formatters' -Status "$ListName.$FieldName"
        # CustomFormatter is the SharePoint internal property for column JSON formatting
        Set-PnPField -List $ListName -Identity $FieldName `
            -Values @{ CustomFormatter = $JsonFormatter } | Out-Null
        Write-Success "Applied '$FriendlyName' formatter → '$ListName.$FieldName'"
        Add-Summary 'Formatter' "$ListName.$FieldName" 'APPLIED' $FriendlyName
    } catch {
        Write-Err "Failed to apply formatter to '$ListName.$FieldName': $_"
        Add-Summary 'Formatter' "$ListName.$FieldName" 'FAILED' $_.Exception.Message
    }
}

function New-ViewIfMissing {
    param(
        [string]$ListName,
        [string]$ViewName,
        [string[]]$Fields,
        [string]$CamlQuery,
        [bool]$SetAsDefault = $false
    )
    if ($SkipViews) {
        Write-Info "Skipping view '$ViewName' (SkipViews)"
        Add-Summary 'View' "$ListName.$ViewName" 'SKIPPED' 'SkipViews flag'
        return
    }
    try {
        $existing = Get-PnPView -List $ListName -Identity $ViewName -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Warn "View '$ViewName' already exists on '$ListName' — skipping"
            Add-Summary 'View' "$ListName.$ViewName" 'SKIPPED' 'Already exists'
            return
        }
    } catch { <# not found = OK #> }

    if ($DryRun) {
        Write-Dry "Would create view '$ViewName' on '$ListName'"
        Add-Summary 'View' "$ListName.$ViewName" 'DRY RUN' 'Would create'
        return
    }
    try {
        Write-Progress -Activity 'Creating Views' -Status "$ListName.$ViewName"
        Add-PnPView -List $ListName -Title $ViewName -Fields $Fields `
            -Query $CamlQuery -SetAsDefault:$SetAsDefault | Out-Null
        Write-Success "Created view '$ViewName' on '$ListName'"
        Add-Summary 'View' "$ListName.$ViewName" 'CREATED'
    } catch {
        Write-Err "Failed to create view '$ViewName' on '$ListName': $_"
        Add-Summary 'View' "$ListName.$ViewName" 'FAILED' $_.Exception.Message
    }
}

function Set-ColumnIndex {
    param([string]$ListName, [string]$FieldName)
    if ($DryRun) {
        Write-Dry "Would index '$FieldName' on '$ListName'"
        Add-Summary 'Index' "$ListName.$FieldName" 'DRY RUN'
        return
    }
    try {
        Write-Progress -Activity 'Indexing Columns' -Status "$ListName.$FieldName"
        $field = Get-PnPField -List $ListName -Identity $FieldName -ErrorAction Stop
        if ($field.Indexed) {
            Write-Warn "'$FieldName' on '$ListName' already indexed — skipping"
            Add-Summary 'Index' "$ListName.$FieldName" 'SKIPPED' 'Already indexed'
            return
        }
        Set-PnPField -List $ListName -Identity $FieldName -Values @{ Indexed = $true } | Out-Null
        Write-Success "Indexed '$FieldName' on '$ListName'"
        Add-Summary 'Index' "$ListName.$FieldName" 'INDEXED'
    } catch {
        Write-Err "Failed to index '$FieldName' on '$ListName': $_"
        Add-Summary 'Index' "$ListName.$FieldName" 'FAILED' $_.Exception.Message
    }
}
#endregion

#region ── STEP 1: Connect ───────────────────────────────────────────────────
Write-Host ''
Write-Host '── Step 1: Connecting to SharePoint ────────────────────────────' -ForegroundColor Cyan
try {
    # UseWebLogin: opens a browser SSO login window (uses existing session/SSO — no device code needed)
    Connect-PnPOnline -Url $SiteUrl -UseWebLogin -ErrorAction Stop
    Write-Success "Connected to: $SiteUrl"
    Add-Summary 'Connection' $SiteUrl 'PASS'
} catch {
    Write-Err "Failed to connect to SharePoint: $_"
    Add-Summary 'Connection' $SiteUrl 'FAIL' $_.Exception.Message
    exit 2
}
#endregion

#region ── STEP 2: Add missing columns to IS Project Tasks ──────────────────
Write-Host ''
Write-Host '── Step 2: Adding missing columns to IS Project Tasks ──────────' -ForegroundColor Cyan

$TasksList = 'IS Project Tasks'

# ── Originally provisioned columns (idempotent — safe to re-run) ─────────
Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'ServiceWorks Ticket ID' `
    -InternalName 'ServiceWorksTicketID' `
    -FieldType 'Text'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'ServiceWorks URL' `
    -InternalName 'ServiceWorksURL' `
    -FieldType 'URL'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'SteerCo Tag' `
    -InternalName 'SteerCoTag' `
    -FieldType 'Boolean' `
    -DefaultValue '0'    # 0 = No (default)


Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Project' `
    -InternalName 'Project' `
    -FieldType 'Text'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Phase' `
    -InternalName 'Phase' `
    -FieldType 'Choice' `
    -Choices @('Initiate','Plan','Execute','Monitor','Close') `
    -DefaultValue 'Plan'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Task Type' `
    -InternalName 'TaskType' `
    -FieldType 'Choice' `
    -Choices @('Milestone','Task','Deliverable','Meeting') `
    -DefaultValue 'Task'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Notes' `
    -InternalName 'Notes' `
    -FieldType 'Note'

# ── v1.1 additions: required by formatters, views, and indexes ───────────
Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'RAG' `
    -InternalName 'RAG' `
    -FieldType 'Choice' `
    -Choices @('Green','Amber','Red','Not Started') `
    -DefaultValue 'Not Started'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Percent Complete' `
    -InternalName 'PercentComplete' `
    -FieldType 'Number' `
    -DefaultValue 'bounded'   # signals Min=0 Max=100 in XML

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Due Date' `
    -InternalName 'DueDate' `
    -FieldType 'DateTime'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Is Active' `
    -InternalName 'IsActive' `
    -FieldType 'Boolean' `
    -DefaultValue '1'    # 1 = Yes (active by default)

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Workstream' `
    -InternalName 'Workstream' `
    -FieldType 'Text'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Assigned To' `
    -InternalName 'AssignedTo' `
    -FieldType 'User'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Priority' `
    -InternalName 'Priority' `
    -FieldType 'Choice' `
    -Choices @('High','Medium','Low') `
    -DefaultValue 'Medium'

Add-ColumnIfMissing -ListName $TasksList `
    -DisplayName 'Planner Task ID' `
    -InternalName 'PlannerTaskID' `
    -FieldType 'Text'
#endregion

#region ── STEP 2b: Add missing columns to IS Project RAID ──────────────────
Write-Host ''
Write-Host '── Step 2b: Adding missing columns to IS Project RAID ──────────' -ForegroundColor Cyan

$RAIDListCols = 'IS Project RAID'


Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Project' `
    -InternalName 'Project' `
    -FieldType 'Text'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'RAID Type' `
    -InternalName 'RAIDType' `
    -FieldType 'Choice' `
    -Choices @('Risk','Assumption','Issue','Dependency') `
    -DefaultValue 'Risk'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Owner' `
    -InternalName 'Owner' `
    -FieldType 'User'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Status' `
    -InternalName 'Status' `
    -FieldType 'Choice' `
    -Choices @('Open','In Progress','Closed','Deferred') `
    -DefaultValue 'Open'
Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'RAG' `
    -InternalName 'RAG' `
    -FieldType 'Choice' `
    -Choices @('Green','Amber','Red') `
    -DefaultValue 'Amber'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Date Raised' `
    -InternalName 'DateRaised' `
    -FieldType 'DateTime'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Target Date' `
    -InternalName 'TargetDate' `
    -FieldType 'DateTime'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Description' `
    -InternalName 'Description' `
    -FieldType 'Note'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Mitigation Plan' `
    -InternalName 'MitigationPlan' `
    -FieldType 'Note'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'SteerCo Tag' `
    -InternalName 'SteerCoTag' `
    -FieldType 'Boolean' `
    -DefaultValue '0'

Add-ColumnIfMissing -ListName $RAIDListCols `
    -DisplayName 'Resolution' `
    -InternalName 'Resolution' `
    -FieldType 'Note'
#endregion

#region ── STEP 3: Apply JSON formatters — IS Project Tasks ─────────────────
Write-Host ''
Write-Host '── Step 3: Applying JSON column formatters ──────────────────────' -ForegroundColor Cyan

Apply-ColumnFormatter $TasksList 'RAG'             $RAGFormatter            'RAG Colour Pills'
Apply-ColumnFormatter $TasksList 'PercentComplete' $ProgressFormatter       'Progress Bar'
Apply-ColumnFormatter $TasksList 'ServiceWorksURL' $ServiceWorksURLFormatter 'ServiceWorks Hyperlink'
Apply-ColumnFormatter $TasksList 'DueDate'         $DueDateFormatter        'DueDate Overdue Warning'
Apply-ColumnFormatter $TasksList 'SteerCoTag'      $SteerCoFormatter        'SteerCo Badge'
#endregion

#region ── STEP 4: Apply RAG formatter to IS Project RAID ───────────────────
Write-Host ''
Write-Host '── Step 4: Applying RAG formatter to IS Project RAID ───────────' -ForegroundColor Cyan

$RAIDList = 'IS Project RAID'
Apply-ColumnFormatter $RAIDList 'RAG' $RAGFormatter 'RAG Colour Pills (RAID)'
#endregion

#region ── STEP 5: Create views — IS Project Tasks ──────────────────────────
Write-Host ''
Write-Host '── Step 5: Creating views on IS Project Tasks ──────────────────' -ForegroundColor Cyan

$TaskFields = @('Title','Project','Workstream','Phase','AssignedTo','DueDate',
                'PercentComplete','RAG','Priority','TaskType','SteerCoTag','Notes')

# Overdue Tasks: DueDate < Today AND PercentComplete < 100
New-ViewIfMissing -ListName $TasksList -ViewName 'Overdue Tasks' -Fields $TaskFields -CamlQuery @'
<Where>
  <And>
    <Lt><FieldRef Name="DueDate"/><Value Type="DateTime"><Today/></Value></Lt>
    <Lt><FieldRef Name="PercentComplete"/><Value Type="Number">100</Value></Lt>
  </And>
</Where>
<OrderBy><FieldRef Name="DueDate" Ascending="TRUE"/></OrderBy>
'@

# SteerCo Items: SteerCoTag = Yes, sorted by RAG descending
New-ViewIfMissing -ListName $TasksList -ViewName 'SteerCo Items' -Fields $TaskFields -CamlQuery @'
<Where>
  <Eq><FieldRef Name="SteerCoTag"/><Value Type="Boolean">1</Value></Eq>
</Where>
<OrderBy><FieldRef Name="RAG" Ascending="FALSE"/></OrderBy>
'@

# My Tasks: AssignedTo = [Me]
New-ViewIfMissing -ListName $TasksList -ViewName 'My Tasks' -Fields $TaskFields -CamlQuery @'
<Where>
  <Membership Type="CurrentUserMembership"><FieldRef Name="AssignedTo"/></Membership>
</Where>
<OrderBy><FieldRef Name="DueDate" Ascending="TRUE"/></OrderBy>
'@

# Red Items: RAG = Red
New-ViewIfMissing -ListName $TasksList -ViewName 'Red Items' -Fields $TaskFields -CamlQuery @'
<Where>
  <Eq><FieldRef Name="RAG"/><Value Type="Text">Red</Value></Eq>
</Where>
<OrderBy><FieldRef Name="DueDate" Ascending="TRUE"/></OrderBy>
'@
#endregion

#region ── STEP 6: Create views — IS Project RAID ───────────────────────────
Write-Host ''
Write-Host '── Step 6: Creating views on IS Project RAID ───────────────────' -ForegroundColor Cyan

$RAIDFields = @('Title','Project','RAIDType','RAG','Owner','DateRaised',
                'TargetDate','Status','Description','SteerCoTag','MitigationPlan')

# Open Red RAID: RAG=Red AND Status!=Closed
New-ViewIfMissing -ListName $RAIDList -ViewName 'Open Red RAID' -Fields $RAIDFields -CamlQuery @'
<Where>
  <And>
    <Eq><FieldRef Name="RAG"/><Value Type="Text">Red</Value></Eq>
    <Neq><FieldRef Name="Status"/><Value Type="Text">Closed</Value></Neq>
  </And>
</Where>
<OrderBy><FieldRef Name="DateRaised" Ascending="FALSE"/></OrderBy>
'@

# SteerCo RAID: SteerCoTag=Yes AND Status!=Closed
New-ViewIfMissing -ListName $RAIDList -ViewName 'SteerCo RAID' -Fields $RAIDFields -CamlQuery @'
<Where>
  <And>
    <Eq><FieldRef Name="SteerCoTag"/><Value Type="Boolean">1</Value></Eq>
    <Neq><FieldRef Name="Status"/><Value Type="Text">Closed</Value></Neq>
  </And>
</Where>
<OrderBy><FieldRef Name="RAG" Ascending="FALSE"/></OrderBy>
'@

# By Project: grouped by Project, sorted by RAG desc
# Note: PnP Add-PnPView doesn't natively support GroupBy — we add it and note manual step
New-ViewIfMissing -ListName $RAIDList -ViewName 'By Project' -Fields $RAIDFields -CamlQuery @'
<OrderBy><FieldRef Name="Project" Ascending="TRUE"/><FieldRef Name="RAG" Ascending="FALSE"/></OrderBy>
'@
Write-Info "TIP: For 'By Project' view, manually set GroupBy=Project in the SharePoint UI (PnP limitation)"
#endregion

#region ── STEP 7: Index key columns ────────────────────────────────────────
Write-Host ''
Write-Host '── Step 7: Indexing key columns for Power Automate performance ──' -ForegroundColor Cyan

# IS Project Tasks
foreach ($col in @('RAG','DueDate','PercentComplete','Project','IsActive','SteerCoTag')) {
    Set-ColumnIndex -ListName $TasksList -FieldName $col
}

# IS Project RAID
foreach ($col in @('RAG','Status','SteerCoTag','Project')) {
    Set-ColumnIndex -ListName $RAIDList -FieldName $col
}
#endregion

#region ── STEP 8: Summary Report ───────────────────────────────────────────
Write-Host ''
Write-Host '╔══════════════════════════════════════════════════════════════╗' -ForegroundColor Cyan
Write-Host '║   SHAREPOINT WIRE — DEPLOYMENT SUMMARY                       ║' -ForegroundColor Cyan
Write-Host '╚══════════════════════════════════════════════════════════════╝' -ForegroundColor Cyan
Write-Host ''

foreach ($group in ($Summary | Group-Object Category)) {
    Write-Host "  [$($group.Name.ToUpper())]" -ForegroundColor Cyan
    foreach ($item in $group.Group) {
        $col = switch ($item.Status) {
            'ADDED'   { 'Green'   } 'APPLIED'  { 'Green'   } 'CREATED'  { 'Green' }
            'INDEXED' { 'Green'   } 'PASS'     { 'Green'   } 'SKIPPED'  { 'Yellow' }
            'DRY RUN' { 'Magenta' } 'FAILED'   { 'Red'     } default    { 'White' }
        }
        $detail = if ($item.Detail) { " — $($item.Detail)" } else { '' }
        Write-Host "    $($item.Item.PadRight(45))" -NoNewline
        Write-Host " [$($item.Status)]" -ForegroundColor $col -NoNewline
        Write-Host $detail -ForegroundColor Gray
    }
    Write-Host ''
}

$pass    = ($Summary | Where-Object Status -in @('ADDED','APPLIED','CREATED','INDEXED','PASS')).Count
$skip    = ($Summary | Where-Object Status -eq 'SKIPPED').Count
$dry     = ($Summary | Where-Object Status -eq 'DRY RUN').Count
$fail    = ($Summary | Where-Object Status -eq 'FAILED').Count

Write-Host "  Total: $($Summary.Count) | " -NoNewline
Write-Host "Done: $pass " -NoNewline -ForegroundColor Green
Write-Host "| Skipped: $skip " -NoNewline -ForegroundColor Yellow
Write-Host "| DryRun: $dry " -NoNewline -ForegroundColor Magenta
Write-Host "| Failed: $fail" -ForegroundColor $(if ($fail -gt 0) {'Red'} else {'White'})
Write-Host ''

if ($DryRun) { Write-Warn 'DRY RUN complete — NO changes were made to SharePoint' }

if ($fail -gt 0) {
    Write-Err "$fail item(s) failed — review errors above then re-run"
    exit 1
} else {
    Write-Success 'SharePoint_Wire.ps1 completed successfully'
    exit 0
}
#endregion
