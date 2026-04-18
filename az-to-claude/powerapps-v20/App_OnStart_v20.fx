// ============================================================
// TCC IS Portfolio Hub — Power App v20
// App.OnStart — Color Tokens + Data Loading
// Metropolitan Council IS | Built: 2026-04-15
// CHANGELOG v19→v20: HTML-matched colors, RAID badges,
//   attention strip, progress bars, G-gate tracker, countdowns
// ============================================================

Concurrent(

    // ── VERSION ─────────────────────────────────────────────
    Set(gAppVersion, "v20.0"),
    Set(gBuildDate,  "2026-04-15"),
    Set(gAppTitle,   "IS Portfolio Hub"),
    Set(gOrgName,    "Metropolitan Council"),

    // ── SCREEN GEOMETRY ─────────────────────────────────────
    Set(gScreenW, 1366),
    Set(gScreenH, 768),

    // ── PRIMARY PALETTE — exact HTML :root vars ───────────────
    Set(cHeader,      RGBA(  0,  29,  61, 1)),  // --header  #001D3D
    Set(cKPIBand,     RGBA(  0,  22,  48, 1)),  // --kpi-bg  #001630
    Set(cAccent,      RGBA(  0, 151, 208, 1)),  // --accent  #0097D0
    Set(cAccentDark,  RGBA(  0, 107, 160, 1)),
    Set(cFooter,      RGBA(  0,  18,  38, 1)),

    // ── TYPOGRAPHY ON DARK ──────────────────────────────────
    Set(cTextWhite,   RGBA(255, 255, 255, 1)),
    Set(cTextLight,   RGBA(217, 217, 217, 1)),  // ~rgba(255,255,255,0.85)

    // ── SURFACES & BORDERS ──────────────────────────────────
    Set(cSurface,     RGBA(255, 255, 255, 1)),  // --card   #FFFFFF
    Set(cSurfaceAlt,  RGBA(249, 250, 251, 1)),  // alternate row
    Set(cBorderLight, RGBA(209, 213, 219, 1)),  // --border #D1D5DB
    Set(cBorderMed,   RGBA(156, 163, 175, 1)),
    Set(cBgPage,      RGBA(229, 229, 234, 1)),  // --bg     #E5E5EA

    // ── TYPOGRAPHY ON LIGHT ─────────────────────────────────
    Set(cTextDark,    RGBA( 26,  26,  46, 1)),  // --text   #1A1A2E
    Set(cTextBody,    RGBA( 51,  65,  85, 1)),
    Set(cTextSub,     RGBA(107, 114, 128, 1)),  // --muted  #6B7280

    // ── PROJECT ACCENT COLORS ────────────────────────────────
    Set(cP222,        RGBA(  4,  57, 113, 1)),  // --c222   #043971  TCC
    Set(cP222Light,   RGBA(219, 234, 254, 1)),
    Set(cP193,        RGBA(  0, 151, 208, 1)),  // --c193   #0097D0  NG911
    Set(cP193Light,   RGBA(224, 242, 254, 1)),
    Set(cP11138,      RGBA(  0,  84, 164, 1)),  // --c11138 #0054A4  VuWall
    Set(cP11138Light, RGBA(219, 234, 254, 1)),

    // ── RAG STATUS — exact HTML vars ─────────────────────────
    Set(cRAGGreen,    RGBA( 46, 125,  50, 1)),  // --green  #2E7D32
    Set(cRAGGreenBg,  RGBA(232, 245, 233, 1)),  // badge.green #E8F5E9
    Set(cRAGAmber,    RGBA(245, 124,   0, 1)),  // --amber  #F57C00
    Set(cRAGAmberBg,  RGBA(255, 243, 224, 1)),  // --warn-bg #FFF3E0
    Set(cRAGRed,      RGBA(198,  40,  40, 1)),  // --red    #C62828
    Set(cRAGRedBg,    RGBA(255, 235, 238, 1)),  // badge.red #FFEBEE
    Set(cRAGGrey,     RGBA(107, 114, 128, 1)),
    Set(cRAGGreyBg,   RGBA(243, 244, 246, 1)),

    // ── RAID TYPE BADGE COLORS ───────────────────────────────
    Set(cRAIDRiskBg,   RGBA(255, 235, 238, 1)),  // Risk   = Red
    Set(cRAIDRiskFg,   RGBA(198,  40,  40, 1)),
    Set(cRAIDRiskBdr,  RGBA(198,  40,  40, 1)),
    Set(cRAIDIssueBg,  RGBA(255, 243, 224, 1)),  // Issue  = Amber
    Set(cRAIDIssueFg,  RGBA(245, 124,   0, 1)),
    Set(cRAIDIssueBdr, RGBA(245, 124,   0, 1)),
    Set(cRAIDActBg,    RGBA(219, 234, 254, 1)),  // Action = Blue
    Set(cRAIDActFg,    RGBA( 30,  64, 175, 1)),
    Set(cRAIDActBdr,   RGBA( 59, 130, 246, 1)),
    Set(cRAIDDecBg,    RGBA(237, 233, 254, 1)),  // Decision = Purple
    Set(cRAIDDecFg,    RGBA( 91,  33, 182, 1)),
    Set(cRAIDDecBdr,   RGBA(139,  92, 246, 1)),

    // ── ATTENTION STRIP ──────────────────────────────────────
    Set(cAttnBg,   RGBA(255, 243, 224, 1)),  // --warn-bg   #FFF3E0
    Set(cAttnBdr,  RGBA(245, 124,   0, 1)),  // --warn-border #F57C00
    Set(cD01Bg,    RGBA(255, 235, 238, 1)),  Set(cD01Fg, RGBA(198,  40,  40, 1)),
    Set(cD02Bg,    RGBA(255, 237, 213, 1)),  Set(cD02Fg, RGBA(154,  52,  18, 1)),
    Set(cD03Bg,    RGBA(219, 234, 254, 1)),  Set(cD03Fg, RGBA( 30,  64, 175, 1)),
    Set(cD04Bg,    RGBA(237, 233, 254, 1)),  Set(cD04Fg, RGBA( 91,  33, 182, 1)),

    // ── PROGRESS BAR COLORS ──────────────────────────────────
    Set(cProgTrack,    RGBA(229, 231, 235, 1)),  // #E5E7EB
    Set(cProgFillGood, RGBA( 46, 125,  50, 1)),  // green >=80%
    Set(cProgFillWarn, RGBA(245, 124,   0, 1)),  // amber 40-79%
    Set(cProgFillCrit, RGBA(198,  40,  40, 1)),  // red   <40%

    // ── OVERDUE BADGE ────────────────────────────────────────
    Set(cOverdueBg,    RGBA(198,  40,  40, 1)),
    Set(cOverdueFg,    RGBA(255, 255, 255, 1)),

    // ── EBC G-GATE STATUS ────────────────────────────────────
    Set(gGate01Status, "complete"),
    Set(gGate02Status, "blocked"),
    Set(gGate03Status, "blocked"),
    Set(gGate04Status, "caution"),
    Set(gGate05Status, "caution"),
    Set(gGate13Status, "pending"),

    // ── TARGET DATES (update before publishing) ───────────────
    Set(gEBCDate,      Date(2026, 4, 26)),
    Set(gHardStopDate, Date(2026, 4, 29)),

    // ── NAVIGATION STATE ─────────────────────────────────────
    Set(gSelectedProject, ""),
    Set(gFilterRAIDType,  "All"),

    // ── KPI SNAPSHOTS ─────────────────────────────────────────
    Set(gKPITotalTasks,  60),
    Set(gKPIAvgComplete, 41),
    Set(gKPIOverdue,     12),
    Set(gKPICritical,     5),
    Set(gKPIOpenRAID,    19),
    Set(gRAIDRiskCt,      6),
    Set(gRAIDIssueCt,     5),
    Set(gRAIDActionCt,    5),
    Set(gRAIDDecCt,       3),

    // ── LOAD IS PROJECT TASKS ────────────────────────────────
    ClearCollect(
        colTasks,
        Filter(
            'IS Project Tasks',
            IsActive = "true"
        )
    ),

    // ── LOAD IS PROJECT RAID ─────────────────────────────────
    ClearCollect(
        colRAID,
        Filter(
            'IS Project RAID',
            Status = "Open"
        )
    )
);

// ── POST-LOAD: LIVE COUNTDOWNS ───────────────────────────────
Set(gDaysToEBC,      DateDiff(Today(), gEBCDate,      Days));
Set(gDaysToHardStop, DateDiff(Today(), gHardStopDate, Days));

// ── POST-LOAD: PROJECT SUMMARIES ─────────────────────────────
ClearCollect(
    colProjSummary,
    AddColumns(
        GroupBy(colTasks, "ProjectID", "Tasks"),
        "TotalTasks",    CountRows(Tasks),
        "CompleteTasks", CountIf(Tasks, Status = "Complete"),
        "OverdueTasks",
            CountIf(Tasks,
                Status <> "Complete" And
                DateValue(DueDate) < Today()
            ),
        "PctComplete",
            If(CountRows(Tasks) > 0,
               Round(CountIf(Tasks, Status = "Complete") / CountRows(Tasks) * 100, 0),
               0)
    )
);

// ── POST-LOAD: LIVE KPI OVERRIDES ────────────────────────────
If(
    CountRows(colTasks) > 0,
    Concurrent(
        Set(gKPITotalTasks, CountRows(colTasks)),
        Set(gKPIOverdue,
            CountIf(colTasks,
                Status <> "Complete" And
                DateValue(DueDate) < Today()
            )
        ),
        Set(gKPIOpenRAID,   CountRows(colRAID)),
        Set(gRAIDRiskCt,    CountIf(colRAID, Type = "Risk")),
        Set(gRAIDIssueCt,   CountIf(colRAID, Type = "Issue")),
        Set(gRAIDActionCt,  CountIf(colRAID, Type = "Action")),
        Set(gRAIDDecCt,     CountIf(colRAID, Type = "Decision"))
    )
);

// ── PROJECT MASTER TABLE ──────────────────────────────────────
Set(
    gProjects,
    Table(
        {ID: "222",   Name: "TCC Phone System",   ShortCode: "TCC",
         AccentColor: cP222,   LightColor: cP222Light,   RAG: "Amber"},
        {ID: "193",   Name: "NG911 Integration",  ShortCode: "NG911",
         AccentColor: cP193,   LightColor: cP193Light,   RAG: "Red"},
        {ID: "11138", Name: "VuWall Display Sys", ShortCode: "VuWall",
         AccentColor: cP11138, LightColor: cP11138Light, RAG: "Amber"}
    )
);
