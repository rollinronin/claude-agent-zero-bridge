**IS Projects — Architecture ****&**** Context**

Master Reference Document — Updated March 26, 2026

*Transit Control Center (TCC) · Metro Transit · Twin Cities Metropolitan Council*

Infrastructure Services · Senior PM / PMO · Internal use — PM and Claude Desktop

| **📖 How to use this document** This is the single source of truth for the IS project portfolio architecture. Upload it to the Portfolio Hub knowledge base. Sections 1–8 are the architecture reference. Section 9 contains the four custom instruction prompts to paste into each Claude Project during setup. When anything changes, update this document and re-upload — do not maintain separate files. |
| --- |

| **1 · Project Context** Three IS projects, one construction dependency, one PM |
| --- |

## **1.1 Organization**

Infrastructure Services (IS) is managing three projects at the Transit Control Center (TCC), operated by Metro Transit at the Twin Cities Metropolitan Council. All three IS projects derive their milestone dates from a single TCC Construction Project managed by a separate day-to-day construction PM (Mark Oelrich, reports to Robert Rimstad). IS has no ability to influence the construction schedule.

## **1.2 The three IS projects**

| **Tag** | **Project** | **IS role** | **Key constraint** |
| --- | --- | --- | --- |
| EXP | TCC Expansion | Lead — deliver PC refresh for 30 consoles (60 IS PCs: Council + LENS networks). Solacom PCs managed by IES — not IS. Initial phase: 16 PCs for EBC temp space (Room 1007 at OMF). | Construction schedule drives all IS milestones. NTP pending. ~896 tasks in reconciled WBS. |
| NG911 | Solacom NG911 Refresh | Coordination — ensure selected solution meshes with IS infrastructure. Drive: new vendor owns 100% end-to-end support, eliminating POTS/DID lines between IS-managed Mitel and Solacom. Direction confirmed: cloud-hosted managed solution only. | IS must fully disengage from Mitel-to-Solacom support. This requirement must be written into the RFP at the deep-dive workshop and survive contract negotiations. Multi-year timeline — FE schedule extends into 2027. |
| VUW | VuWall Video Wall/KVM | Coordination — infrastructure readiness, CJIS/BCA approval, POC environment support, support gap assessment. | PO issued March 26, 2026. Non-refundable POC cost. IS support gap is primary risk. Bluum (reseller) contract status uncertain — parallel procurement path exploration underway. |

## **1.3 Construction dependency (upstream, not IS-managed)**

| **⚠️ Construction schedule is day-to-day managed by Mark Oelrich (Principal Project Coordinator, reports to Robert Rimstad — Metro Transit Manager of Engineering ****&**** Construction)** IS has no ability to adjust this schedule. All three IS projects derive their milestone dates from it. Monitor Notice of Award and Notice to Proceed closely — NTP is the trigger that unlocks IS milestone planning. |
| --- |

| **Milestone** | **Status / working assumption** |
| --- | --- |
| Notice of Award | Pending. Procurement awarding general contractor bid now. |
| Notice to Proceed | Pending Notice of Award. NTP expected mid–late April 2026 (per Robert Rimstad, SteerCo March 25). |
| EBC (Room 1007) operational | Working target: April 30, 2026. Not realistic given special-build PC lead times — held deliberately to maintain momentum. Formal review at April 22 SteerCo. |
| Construction activity | Working assumption: September 2026. TBD after NTP. |
| Final space ready | Working assumption: end of 2026. All IS Final Space tasks blocked until NTP received. |

## **1.4 Key people**

| **Person / Role** | **Project(s)** | **Responsibilities** |
| --- | --- | --- |
| PT (Tat-Siaka, Ptahmes) — IS PM | All three + Portfolio | Senior PM, PMO. Portfolio management, SteerCo facilitator, IS decision authority. |
| Carri Sampson — TCC Manager / Project Sponsor | All | Primary project sponsor and TCC operational owner. Absent from inaugural SteerCo (mandatory training). |
| Chad Ladda — TCC Assistant Manager | All | Day-to-day TCC contact. Represented Carri at SteerCo March 25. IES scope verification for Room 1007. |
| MayAnn Severud — IS PMO Manager | All | IS PM’s manager (as of this week). Paul Burke also reports to her. Previously Victor Barge. |
| Gretchen White — IS Director / CIO | All | IS leadership. Resource decisions, competing priorities. Agreed in principle to dedicated endpoint resource — who/when unresolved. |
| Paul Burke — IS Infrastructure PM / PMO | EXP, VUW | New (~1 month). Covers network, security, voice, endpoint, server/identity. Go-between for IS infrastructure team. Meeting March 27 — full scope alignment for TCC and VuWall. |
| Eric Brown — LASO | EXP, VUW | Local Agency Security Officer. Assigned March 24. Owns CJIS BCA submission process — prepares formal design proposals to BCA (Bureau of Criminal Apprehension) for CJIS certification. Must be engaged once design documentation is ready. |
| Tracy French — IS Ops / CJIS SME | EXP | CJIS subject matter expert. Supports LASO engagement and BCA submission. |
| Josh Alswager — IS Principal Specialist | NG911 | Reports directly to CIO. Former IS Network Manager; left for state ASAP work; returned with deep 911 operational knowledge. Primary Met Council technical representative in FE-led NG911 RFP process. |
| Mark Linnell — IS Endpoint Manager | EXP, VUW | New to role. Leading eval PC order for EBC. VuWall support gap assessment. |
| Dale Tribbey — IS Voice Systems Engineer | EXP, VUW | Reports to Clete Erickson. Primary IS voice contact for Room 1007 and VuWall voice/AV assessment. |
| Sara Landgreen — IS Service Mgr, Endpoint Purchasing (retired) | EXP | Retired mid-March 2026. Confirmed staggered PC ordering acceptable within ~5–6 months. Purchasing ownership TBD. |
| Leslie Sticht — IS Network Manager | EXP | Reports to Andrea Rucks. Raised service ticket optimization feedback alongside Robert Rimstad. |
| Clete Erickson — IS Infrastructure Manager (Voice & Unified Communications) | VUW | VuWall support skill gap assessment. |
| Jacob Dada — Transit Applications Manager | EXP | Team manages specialized apps (TransitMaster, etc.) not in standard IS endpoint build. Handoff point in PC deployment cycle. Potential elevated-permissions mitigation for endpoint gap — feasibility TBD. |
| Robert Rimstad — Metro Transit Manager of Engineering & Construction | All (dependency) | Funding authority for TCC expansion. Authorizes funds at Transportation Committee level. Day-to-day construction schedule managed by Mark Oelrich (Principal Project Coordinator, reports to Robert Rimstad). |

Federal Engineering (FE) | NG911 | Tommy Thompson (PM), Rob Jackson (Consultant SME), Eric Parry (Consultant SME). Engaged by TCC (Carri Sampson / Robert Rimstad funding authority). |
IES | EXP, NG911 | Solacom managed services vendor. TCC is primary IES interface, not IS. |
Bluum | VUW | State contract reseller/integrator through which VuWall equipment is procured. Contract renewed Dec 15 for 3 months (expires ~March 2026). Full renewal possible but not in IS control. One of several procurement path options being explored for VuWall support partner. |
Tina Folch — Procurement | VUW | VuWall PO lead. Bluum contract point of contact. Stretched thin — parallel procurement path exploration may need a different owner. |

## **1.5 Steering committee**

| **Item** | **Detail** |
| --- | --- |
| Cadence | Monthly — third or fourth Wednesday. Inaugural meeting: March 25, 2026. Next: April 22, 2026. |
| Governance | Mixed. Major scope/resource/budget decisions go to SteerCo. Operational decisions made at PM or IS Director level between meetings. Model still being established. |
| Attendees | Carri Sampson, Chad Ladda, Robert Rimstad, Gretchen White, Tina Folch, Jacob Dada, Josh Alswager, John Stefanko, Antoinette Brasson. PT facilitating. |
| SharePoint site | To be published this week. Link distributed to all attendees. |

## **1.6 Open action items (as of March 28, 2026)**

| **Action item** | **Owner** | **Status** |
| --- | --- | --- |
| Initiate PC procurement — 3 eval units first (2 Council/special build + 1 LENS/catalog), then full order of 16 | IS PM + Mark Linnell | March 30 at earliest — order not placed as of March 28 |
| Paul Burke meeting — full IS infrastructure scope alignment (network, security, voice, endpoint, server/identity) for TCC and VuWall | IS PM + Paul Burke | March 30 |
| FE NG911 deep-dive RFP workshop — confirmed April 17 | IS PM + Josh Alswager | April 17 (confirmed) |
| Confirm VuWall PO issuance | Tina Folch | March 26 (today) |
| Begin parallel procurement path exploration for VuWall support partner (Bluum renewal, SHI on state contract, cooperative purchasing vehicles) — determine who owns if Tina is at capacity | IS PM + Procurement | This week |
| Add support needs assessment as formal VuWall POC objective | IS PM | This week |
| Publish SteerCo SharePoint site — send link to attendees | IS PM | This week |
| Raise UPS shared infrastructure question (IS + IES, Room 1007) with IES via Chad Ladda | Chad Ladda + IS PM | This week |
| Schedule Eric Brown (LASO) intro — after Paul Burke meeting when design detail is available | IS PM + Tracy French | After March 30 |
| Map end-to-end PC deployment cycle (IS endpoint → Jacob Dada’s team → TCC tech group → operator-ready) | IS PM + Jacob Dada | TBD |
| Investigate elevated permissions for Jacob Dada’s team as endpoint gap mitigation — policy/security review | IS PM + IS Security | TBD |
| Ensure Mitel disentanglement SHALL requirement is explicitly written into RFP at workshop | Josh Alswager + IS PM | At RFP workshop |
| Resolve dedicated endpoint resource — confirm who and when, or agree on alternative | Gretchen White / IS Director | April 22 SteerCo |
| Raise network hardware disposition question (Room 1007 switches, firewall, UPS) with TCC and facilities | IS PM | Next SteerCo or sooner |
| Confirm PC migration assumption — all 14 Room 1007 PCs return to Minneapolis | IS PM + Carri Sampson | TBD |
| Upload CJIS documentation to VuWall project knowledge base | IS PM | This week |

| **2 · Current Phase ****&**** Priorities** Phase 1: Foundation first. Everything else waits. |
| --- |

| **🎯 The right order matters** Do not build dashboards before data exists. Do not build Power Automate flows before SharePoint Lists exist. Do not start the portal before the Lists have real data. The foundation must be solid before the intelligence layer on top of it means anything. |
| --- |

| **Phase** | **When** | **What to build** | **Gate to next phase** |
| --- | --- | --- | --- |
| 1 — Foundation | Now | SharePoint folder structure + naming convention. Documentation gap audit. WBS import to SharePoint Lists via Claude in Excel. Master Excel tracking workbook. RAID log import. | SharePoint Lists have real data from all three projects. |
| 2 — Automation | After Phase 1 | SharePoint Lists schemas finalized. Power Automate sync flows (Planner ↔ Lists). SharePoint portal pages. Status cards, Gantt, nav bar HTML components. | Power Automate flows running and data flowing correctly. |
| 3 — Intelligence | After Phase 2 | Power BI executive dashboard. Power Apps RAID canvas app. Monday synthesis flow (Claude API). Teams adaptive card executive brief. | Portal working; leadership using it. |
| 4 — Future | Opportunistic | Copilot Studio portal agent. Predictive risk scoring. Video recap briefings. Full M365 Copilot integration if licensed. | Organization ready for advanced AI capabilities. |

## **2.1 Phase 1 action list — immediate**

- Initiate PC procurement (16 units EBC) — eval units first. See Section 1.6.

- Import reconciled WBS (.xlsx, 896 tasks) into IS Project Tasks SharePoint List via List → Integrate → Import from Excel.

- Import pre-populated RAID log into IS Project RAID SharePoint List.

- Build the SharePoint folder structure (30 min on work PC). See Section 4.1.

- Populate master Excel tracking workbook with current milestone and status data for all three projects.

| **3 · Tool Architecture** What each tool does and why |
| --- |

## **3.1 The two-device split**

The work PC is a locked-down government machine (Palo Alto Prisma Access VPN at kernel level, zero admin rights, full deep packet inspection). All development and generation work happens on the personal PC. The work PC imports, connects, and deploys.

| **Tool** | **Device** | **Role** |
| --- | --- | --- |
| Claude Desktop | Personal PC | Four Claude Projects (three IS + Portfolio Hub). Heavy drafting, code generation, document creation, Monday morning briefs, WBS restructuring. |
| Claude in Excel | Personal PC | Interim visualization layer until Power BI is warranted. WBS restructuring and SharePoint List import. Pivot tables and charts. Shared context with PowerPoint. |
| Claude in PowerPoint | Personal PC | Executive briefing decks. Shares conversation context with Excel — no re-explaining data between apps. |
| Claude Code | Personal PC | Complex multi-file generation: Power Automate .zip packages, Python synthesis scripts, SharePoint HTML/JS components. |
| Claude.ai (work browser) | Work PC | Real-time assistance during meetings and M365 work. Verify agency approval before using for work content. |
| Work Copilot (M365) | Work PC | Org-data-grounded tasks: SharePoint search, email drafting, meeting recaps. Complementary to Claude, not competing. |
| Power Automate | Work PC (import) | Sync flows: Planner ↔ SharePoint Lists. Monday synthesis flow calling Claude API. Generated as .zip on personal PC, imported on work PC. |
| Power BI Desktop | Personal PC (build) / Work browser (publish) | Executive dashboards. Phase 3 only — not until Lists have sufficient data. |
| Power Apps | Work browser | RAID canvas app. YAML generated on personal PC, pasted into Power Apps Studio on work PC. |
| SharePoint Lists | Work PC (configure) | Source of truth for all project data. Five lists. Everything downstream reads from here. |
| Planner Premium | Work PC (use) | Execution layer. Active tasks only (current phase or due within 2 weeks). Team uses this daily. |
| Teams | Work PC (use) | Project hub. SharePoint portal pages pinned as tabs. Three project channels + IS Portfolio channel. |
| Google Calendar MCP | Personal PC (Claude) | Milestone tracking calendars for Claude. Four calendars: EXP, NG911, VUW, Construction Gates. Already connected. |
| Gmail MCP | Personal PC (Claude) | Stakeholder email context for Monday briefs. Already connected. |
| WhisperFlow | Personal PC | Voice input to Claude Desktop. Click inside Claude chat input field first, then activate. |

## **3.2 What Claude generates vs what you do on the work PC**

| **Claude generates (personal PC)** | **Work PC action** | **Time** |
| --- | --- | --- |
| Power Automate flow .zip packages | Import: make.powerautomate.com → My Flows → Import → upload zip. Click 3 connection prompts per flow. | ~5 min each |
| Power BI M queries + DAX measures | Paste into Power BI Desktop Advanced Editor. Follow guided setup file. Publish to service. | ~20 min total |
| Power Apps RAID app YAML | Power Apps Studio → new blank canvas app → YAML view → paste. Connect SharePoint List. | ~10 min |
| SharePoint HTML files (status cards, Gantt, nav) | Upload to Site Assets library. Add Embed web part. Paste file URL. | ~2 min per file |
| Python synthesis script | Runs entirely on personal PC. No work PC action needed. | N/A |
| WBS restructured as .xlsx | Import to SharePoint: List → Integrate → Import from Excel. | ~10 min |

| **4 · Data Architecture** The Planner + SharePoint Lists hybrid model |
| --- |

| **💡 The hybrid model — why both tools** SharePoint Lists = source of truth and master database (all ~896 tasks with full metadata, reporting, Power BI, Power Automate). Planner = execution layer for the team (active tasks only, visual kanban, mobile app, @mentions, daily work). Power Automate keeps them in sync invisibly. Your team only touches Planner. Reporting and automation read from SharePoint Lists. |
| --- |

## **4.1 SharePoint document library structure**

⚠️ **Updated March 28, 2026.** This section replaces the original phase-based subfolder model. The new model uses one flat metadata-driven document library. See *IS Project Documents — Library Build Guide v1* for the full step-by-step build sequence.

**Naming convention (unchanged):** YYYY-MM-DD_[Tag]*[DocType]*[Version].ext — Tags: PORT · EXP · NG911 · VUW

### Library: IS Project Documents

One document library. Two zones. Max 2 levels deep. Versioning on (major versions, 20 copies).

| Zone | Folder / location | What lives here | Organisation |
| --- | --- | --- | --- |
| Zone A — Portfolio | Library root (no folder) | Bridge documents, executive briefings, integrated plan, steering committee decks | Flat. Tagged Project = Portfolio. No subfolders. |
| Zone B — EXP | EXP/ | Meeting notes, technical docs, procurement, status reports | Flat inside folder. _Archive subfolder added when a phase closes. |
| Zone B — NG911 | NG911/ | Meeting notes, FE coordination, RFP documents, IS requirements | Flat inside folder. _Archive subfolder added when a phase closes. |
| Zone B — VUW | VUW/ | Meeting notes, vendor docs, POC planning, IS requirements | Flat inside folder. _Archive subfolder added when a phase closes. |
| System | Site Assets (separate library) | status_cards.html, gantt_chart.html, nav_bar.html, logos | Managed by PM. Not user-facing. |

### Metadata columns on every document

| Column | Type | Values |
| --- | --- | --- |
| Project | Choice | TCC Expansion │ NG911 Refresh │ VuWall │ Portfolio |
| Doc Type | Choice | Bridge Document │ Charter │ Meeting Notes │ Technical Doc │ Procurement │ Status Report │ Executive Brief │ RFP │ Vendor Doc │ IS Requirements │ POC Planning |
| Phase | Choice | Planning │ Procurement │ Configuration │ Testing │ Deployment │ Closeout │ Portfolio |
| Status | Choice | Draft │ Active │ Final │ Archived — default: Active |
| Audience | Choice | IS Team │ Steering Committee │ External │ Portfolio |

### Saved views (replace folder navigation)

| View | Filter | Purpose |
| --- | --- | --- |
| All active documents (default) | Status ≠ Archived | Day-to-day working view |
| EXP — all documents | Project = TCC Expansion AND Status ≠ Archived | EXP daily work |
| NG911 — all documents | Project = NG911 Refresh AND Status ≠ Archived | NG911 daily work |
| VUW — all documents | Project = VuWall AND Status ≠ Archived | VUW daily work |
| Steering committee docs | Audience = Steering Committee | Assembling steerco packages |
| Portfolio — active | Project = Portfolio AND Status ≠ Archived | Portfolio-level live docs |
| Archive | Status = Archived | Reviewing retired documents |

## **4.2 SharePoint Lists schema**

### **IS Project Tasks List**

| **Column** | **Type** | **Values / notes** |
| --- | --- | --- |
| Title (rename to Task Name) | Single line text |  |
| Project | Choice | TCC Expansion │ NG911 Refresh │ VuWall |
| Phase | Choice | Planning │ Procurement │ Configuration │ Testing │ Deployment │ Closeout |
| Task Type | Choice | Task │ Milestone │ Construction Gate │ Deliverable |
| WBS Number | Single line text | e.g., 1.2.3 — for Gantt and plan structure |
| Owner | Person or Group | Allow single selection |
| Planned Start | Date and Time | Date only |
| Planned End | Date and Time | Date only |
| Actual End | Date and Time | Null until complete |
| % Complete | Number | 0–100, 0 decimal places |
| RAG Status | Choice | Green │ Amber │ Red │ Not Started │ Complete │ Blocked – Construction |
| Blocked By | Single line text | Construction milestone blocking this task (if applicable) |
| Predecessors | Single line text | WBS numbers of predecessor tasks, comma-separated |
| Planner Task ID | Single line text | Auto-populated by Power Automate; upsert key |
| Active in Planner | Yes/No | TRUE = task currently surfaced in Planner execution layer |
| Notes | Multiple lines | Plain text |

### **IS Project RAID List**

| **Column** | **Type** | **Values / notes** |
| --- | --- | --- |
| Title (rename to RAID Title) | Single line text |  |
| Project | Choice | TCC Expansion │ NG911 Refresh │ VuWall │ Portfolio |
| RAID Type | Choice | Risk │ Action │ Issue │ Decision |
| Description | Multiple lines |  |
| Probability | Choice | High │ Medium │ Low │ N/A |
| Impact | Choice | High │ Medium │ Low |
| Mitigation / Response | Multiple lines |  |
| Owner | Person or Group |  |
| Due Date | Date and Time |  |
| Status | Choice | Open │ In Progress │ Closed │ Accepted │ Deferred |
| RAG | Choice | Red │ Amber │ Green |
| Date Logged | Date and Time | Default: today |

### **IS Status Summary List (manually updated weekly)**

| **Column** | **Type** | **Values / notes** |
| --- | --- | --- |
| Summary ID | Single line text | Format: [Tag]-[YYYY-MM-DD], e.g., EXP-2026-03-31 |
| Project | Choice | TCC Expansion │ NG911 Refresh │ VuWall │ Construction (dependency row) |
| Week Ending | Date and Time | Friday of reporting week |
| Overall RAG | Choice | Green │ Amber │ Red |
| Status Narrative | Multiple lines | 2–3 sentence plain-language summary |
| Highlights This Week | Multiple lines | Bullet-style: what happened, what was decided |
| Next Milestone | Single line text | Name and date |
| Construction Gate Status | Choice | Pending │ Received │ Delayed │ Not Applicable |
| Open RAID Count | Number | Count of open RAID items for this project |

## **4.3 Planner + SharePoint Lists sync rules**

- SharePoint Lists = all ~896 tasks. Planner = active tasks only (current phase OR due within 14 days).

- Power Automate Flow 1 (Planner → SharePoint): when a Planner task is updated, upsert to IS Project Tasks List. Uses Planner Task ID as the unique key to prevent duplicates.

- Power Automate Flow 2 (SharePoint → Planner): when a task’s Active in Planner column is set to TRUE in SharePoint, create or update the corresponding Planner task. Triggered by phase transitions.

- Power Automate Flow 3 (Milestone alert): when RAG Status changes to Red, post a Teams adaptive card alert to the relevant project channel.

- Power Automate Flow 4 (Monday synthesis): scheduled Monday 6am. Queries all Lists. Calls Claude API. Saves analysis to SharePoint. Sends Teams notification with filename to upload to Portfolio Hub.

| **5 · Claude Desktop Project Setup** Four projects, setup order, and knowledge base content |
| --- |

## **5.1 Four Claude Projects — setup in this order**

| **Order** | **Project name (use exactly)** | **Knowledge base: upload these files** |
| --- | --- | --- |
| 1 | TCC Expansion — IS PC Refresh | This architecture doc, bridge document, reconciled WBS .xlsx, SteerCo meeting notes, any build specs |
| 2 | Solacom NG911 Refresh | This architecture doc, bridge document, FE recommendations document, any FE documentation |
| 3 | VuWall Video Wall / KVM | This architecture doc, bridge document, VuWall vendor docs, POC criteria document, CJIS documentation |
| 4 (last) | TCC IS Portfolio Hub | This architecture doc, bridge document, reconciled WBS .xlsx, RAID log .xlsx |

## **5.2 After uploading documents — first conversation for any project**

| **PASTE INTO: Any project — first conversation after setup** |
| --- |
| Summarize what you know about this project in this format: |
|  |
| PROJECT: [state the project name and organization] |
| MY ROLE: [describe IS role and responsibilities] |
| KEY STAKEHOLDERS: [list key people and their roles] |
| PRIMARY GOAL: [one sentence on the main IS objective] |
| BIGGEST RISK OR CONSTRAINT: [the most important thing to manage] |
| CURRENT STATUS: [where the project stands right now] |
| OPEN ACTION ITEMS: [any outstanding decisions or actions] |
| RELATED PROJECTS: [how this connects to the other IS projects] |
|  |
| If anything is vague or missing, tell me what information you need. |

## **5.3 Portfolio Hub initialization**

| **PASTE INTO: Portfolio Hub — first conversation after all four projects are set up** |
| --- |
| I have uploaded the master architecture document to your knowledge base. |
| Confirm your understanding by answering: |
|  |
| 1. What are the three IS projects, my role in each, and their current status? |
| 2. What is the construction dependency and what are the pending milestones? |
| 3. What is the Planner + SharePoint Lists hybrid model and why does it matter? |
| 4. What are the open action items that need resolution this week? |
| 5. What are my Phase 1 priorities right now? |
|  |
| Then identify any gaps in the knowledge base that would limit your ability |
| to help me manage this portfolio. |

## **5.4 Documentation gap audit**

| **PASTE INTO: Portfolio Hub — after initialization** |
| --- |
| Run a documentation gap analysis for all three IS projects. |
|  |
| WHAT I CURRENTLY HAVE: |
| TCC Expansion: SteerCo meeting notes, reconciled WBS (896 tasks), bridge document |
| NG911: FE recommendations document, bridge document |
| VuWall: POC criteria (documented), bridge document, CJIS documentation |
| All projects: Steering committee inaugural meeting held March 25, 2026 |
|  |
| For each missing artifact, tell me: |
| 1. Artifact name and why it matters at this stage |
| 2. Whether it can be derived from existing documents |
| 3. Priority: Critical (needed now) / Important (needed this month) / Nice to have |
|  |
| Then give me the top 5 documents to create first and offer to draft |
| whichever one I want to start with. |

## **5.5 WBS import prompt (Claude in Excel on personal PC)**

| **PASTE INTO: Claude in Excel — with reconciled WBS file open** |
| --- |
| I have the reconciled WBS open in Excel. It has 896 tasks across 10 workstreams. |
| The SharePoint Import sheet is already structured for import. |
|  |
| Please verify: |
| 1. Review the SharePoint Import sheet and confirm all 896 rows look correct |
| 2. Flag any rows where Task Name, Project, Task Type, or RAG Status look wrong |
| 3. Confirm the column names match the IS Project Tasks SharePoint List schema exactly |
| 4. Tell me the exact steps to import this sheet into the SharePoint List |
| using the built-in List → Integrate → Import from Excel feature |
|  |
| Do not change any data — only verify and flag issues. |

## **5.6 Monday morning brief prompt**

| **PASTE INTO: Portfolio Hub — every Monday after uploading bridge document** |
| --- |
| Pull my TCC IS project Google Calendars for the next three weeks. |
| Read the bridge document I uploaded this morning. |
|  |
| Give me a structured Monday planning brief: |
|  |
| == PORTFOLIO HEALTH == |
| Overall RAG and biggest portfolio risk this week. |
|  |
| == CONSTRUCTION GATE STATUS == |
| Pending construction milestones and IS planning impact. |
|  |
| == OPEN STEERING COMMITTEE ACTIONS == |
| Status of open action items from Section 1.6 of the architecture document. |
|  |
| == THIS WEEK BY PROJECT == |
| TCC Expansion: milestones due, blockers, priority actions. |
| NG911: milestones due, blockers, priority actions. |
| VuWall: milestones due, blockers, priority actions. |
|  |
| == TOP 5 ACTIONS THIS WEEK == |
| Prioritized list with suggested owner and why this week. |
|  |
| Flag anything requiring same-day attention with [URGENT]. |

| **6 · SharePoint Portal** Three audience pages, no back-button navigation, Teams-embedded |
| --- |

## **6.1 Design principle**

| **🎯 Users never think ‘I am in SharePoint’** SharePoint is the secure hosting platform. The portal is the product. Surface all pages as Teams tabs — SharePoint header and chrome disappear automatically. Custom HTML components (status cards, Gantt, nav bar) replace everything SharePoint would normally render. |
| --- |

## **6.2 Three audience pages**

| **Page** | **Audience** | **Content** |
| --- | --- | --- |
| Executive Portal | IS Director, leadership | Four RAG status cards (EXP, NG911, VUW, Construction dependency). Rollup Gantt (milestones only, color-coded by project, construction gates as blockers). Open decisions from RAID log. Read-only. |
| Team Workspace | IS project team | Power Apps RAID canvas app (full log, task views, add/edit forms). Documents, meeting notes, contact directory. Power Automate alert banner for Red items. |
| Stakeholder Updates | External stakeholders, TCC | Status narrative (auto-refreshed from Status Summary List). 90-day milestone view. Key deliverables. Read-only. |

## **6.3 Custom HTML components (Claude Code generates, no admin rights needed)**

| **Component** | **File** | **What it does** | **Deployment** |
| --- | --- | --- | --- |
| RAG status cards | status_cards.html | Four cards reading IS Status Summary List via REST API. Auto-loading, error state, navy header bar. | Upload to Site Assets. Add Embed web part. Paste file URL. |
| Executive Gantt | gantt_chart.html | Frappe Gantt from CDN. Reads IS Milestones List. Color by project. Construction gates as vertical markers. Toggle executive/detail view. | Same as above. |
| Sticky nav bar | nav_bar.html + nav_listener.html | Fixed nav bar. Clicks call window.parent.postMessage() to scroll parent SharePoint page (cross-iframe). Active section tracking via IntersectionObserver. | Two Embed web parts per portal page. |

| **7 · Security ****&**** Data Handling** Zero-trust environment; what goes where |
| --- |

## **7.1 Technical profile**

Claude.ai is standard HTTPS (TLS 1.3), inspected by Prisma Access the same as any approved SaaS. All M365 components (Teams, Planner, Power Automate, Power BI, Power Apps, SharePoint) run inside the agency M365 tenant and never leave the boundary Prisma protects.

Verify with IT security that Claude.ai is on the agency approved application list and confirm data classification limits for external SaaS before routing work content through it.

## **7.2 CJIS compliance and LASO process**

CJIS (Criminal Justice Information Services) compliance is required for any system handling Criminal Justice Information (CJI) at TCC. The compliance path for IS infrastructure is:

- IS and IS infrastructure team (Paul Burke) produce formal design documentation describing the proposed architecture, network configuration, encryption approach, authentication mechanisms, key management and rotation, and data handling at rest and in transit.

- Eric Brown (LASO — Local Agency Security Officer) reviews the design and prepares a formal design proposal submission to the BCA (Bureau of Criminal Apprehension), which is Minnesota’s CJIS Systems Agency.

- BCA reviews and certifies the design. This is the gate for IS to proceed with implementation.

- LASO maintains ongoing security documentation, ensures personnel screening (fingerprint-based background checks required before CJI access), and reports security incidents to the BCA.

This process applies to Room 1007 (EBC temp space) and VuWall. Tracy French (IS ops/CJIS SME) supports Eric Brown in this process.

## **7.3 Data handling**

| **✅ Safe to send to Claude** PM frameworks and templates Anonymized project scenarios M365 tool questions and technique HTML / JS / Python code generation Structural planning questions Document drafts without sensitive operational details | **⛔ Keep out of Claude** CJIS-regulated data (any 911 operational data) CUI (Controlled Unclassified Information) Network architecture or IP addressing Procurement-sensitive vendor details Personnel or HR matters Anything classified or marked CUI |
| --- | --- |

| **8 · Weekly Rhythm** Recurring activities and which tool handles each |
| --- |

| **Day** | **Activity** | **Tool / location** |
| --- | --- | --- |
| Monday | Update bridge document with current status for all three projects + construction dependency. Upload to Portfolio Hub. Run Monday morning brief prompt. | Portfolio Hub (Claude Desktop) + Google Calendar MCP + Gmail MCP |
| Tue–Wed | Deep project work: WBS updates, technical specs, IS requirements for FE (NG911), POC criteria and support gap (VuWall), deployment planning (Expansion). | Individual project Claude spaces |
| Tuesday | Update IS Status Summary SharePoint List with this week’s RAG, narrative, and highlights for each project. (5 min — sets the RAG cards on the portal.) | SharePoint (work PC) |
| Thursday | Team meeting: agenda prep, action item capture, RAID log updates. | Teams + Power Apps RAID log + individual project Claude spaces |
| Friday | Generate weekly status report. Update Status Summary List. Export portfolio analysis to NotebookLM if needed for stakeholder briefing. | Portfolio Hub (Claude Desktop) |
| Monthly | Generate fresh integrated master plan from Portfolio Hub. Update project instructions in all four Claude projects. Review and clean up RAID log. | Portfolio Hub + individual project spaces |

| **9 · Claude Desktop Custom Instructions** Paste each prompt into the corresponding project during setup |
| --- |

| **📋 Setup order** Create projects in this order: (1) TCC Expansion, (2) NG911, (3) VuWall, (4) Portfolio Hub. Paste instructions before uploading any documents. After pasting, click Save, then verify with: ‘Summarize what you know about this project and your role in it.’ |
| --- |

## **9.1 Project 1 — TCC Expansion**

| **PASTE INTO: ‘TCC Expansion — IS PC Refresh’ — Set project instructions** |
| --- |
| You are helping me manage the TCC Expansion IS project as part of a portfolio |
| of three IS projects at the Transit Control Center (TCC), operated by Metro Transit |
| at the Twin Cities Metropolitan Council. |
|  |
| ROLE: I am a Senior Project Manager within the PMO. My work PC is a locked-down |
| government machine (Palo Alto Prisma Access VPN, zero admin rights, deep packet |
| inspection). My personal PC has Claude Desktop, Claude in Excel, Claude in |
| PowerPoint, Power Automate, Power BI Desktop, and Power Apps installed. |
|  |
| PROJECT OVERVIEW: |
| IS is responsible for refreshing PCs on 30 operator consoles as part of the TCC |
| facility expansion (increasing from 14 to 30 consoles). Each console has 2 IS PCs |
| (1 Council network + 1 LENS network) = 60 IS PCs total for the final space. |
| Solacom PCs (managed by IES) are not IS responsibility. |
|  |
| CURRENT PHASE — EBC BUILDOUT (Room 1007, OMF): |
| The immediate work is standing up a temporary operations space in Room 1007 at the |
| OMF (Rail Operations and Maintenance Facility) — TCC’s Emergency Backup Center |
| (EBC) as part of their COOP program. Room 1007 is a conference room built out for |
| temp TCC operations during construction. It is physically ready (clean room criteria |
| met). |
|  |
| PC ORDER (16 units total for EBC): |
| - 7 stations × 2 PCs = 14 PCs in Room 1007 (1 LENS network + 1 Council network per station) |
| - 1 station × 2 PCs = 2 PCs in the adjacent room (existing EBC) |
| - Two specs: LENS PC = standard catalog; Council PC = special build (multi-week lead time) |
| - Order sequence: 3 eval units first (2 Council/special build + 1 LENS/catalog), |
| then full order of 16, then Minneapolis final space remainder TBD |
| - Mark Linnell (IS Endpoint Manager) is leading the eval order |
|  |
| PC DEPLOYMENT CYCLE (to be mapped): |
| IS endpoint (imaging, domain join) → Jacob Dada’s transit applications team |
| (TransitMaster and specialized apps) → TCC’s own small technology group (scope TBD) |
| → operator-ready. End-to-end cycle time not yet documented. |
|  |
| CJIS COMPLIANCE: |
| Room 1007 approach: firewall + end-to-end encryption in-room (no secure path to |
| OMF equipment room). CJIS certification requires Eric Brown (LASO) to submit a |
| formal design proposal to the BCA (Bureau of Criminal Apprehension). IS must |
| produce design documentation first; Eric then prepares and submits to BCA. |
| Tracy French (CJIS SME) supports. Eric was assigned March 24 — engage once |
| Paul Burke meeting produces design detail. |
|  |
| SCHEDULE STATUS: |
| Working target: EBC operational April 30, 2026. Not realistic given special-build |
| PC lead times — held deliberately to maintain momentum. Formal review at April 22 |
| SteerCo. Construction bid not yet awarded; NTP expected mid-late April. IS cannot |
| finalize final-space milestone schedule until NTP is issued. |
|  |
| KEY PEOPLE: |
| - Carri Sampson: TCC Manager and project sponsor |
| - Chad Ladda: TCC Assistant Manager, day-to-day contact |
| - Paul Burke: IS Infrastructure PM / PMO (new, ~1 month) — covers network, security, |
| voice, endpoint, server/identity. Meeting March 27. |
| - Eric Brown: LASO — owns CJIS BCA submission process |
| - Tracy French: IS ops / CJIS SME |
| - Mark Linnell: IS Endpoint Manager (new to role) |
| - Jacob Dada: Transit Applications Manager — handoff point in PC deployment cycle |
| - Gretchen White: IS Director / CIO — agreed in principle to dedicated endpoint |
| resource; who/when unresolved |
|  |
| OPEN RISKS: |
| - IS resource gap: previous TCC resource (Galen) departed, Robert Borbum redirected |
| to PD work. Dedicated endpoint resource agreed in principle by Gretchen but unresolved. |
| - All IS resources carry dual operational + project responsibilities. Any SEV1 |
| displaces project work. |
| - Network hardware disposition for Room 1007 is an open question (not yet raised). |
| - PC migration assumption (all 14 Room 1007 PCs to Minneapolis) needs formal confirmation. |
|  |
| RELATED PROJECTS: Solacom NG911 Refresh, VuWall Video Wall/KVM, Portfolio Hub. |
|  |
| PREFERENCES: Concise and action-oriented. Flag construction dependencies and |
| resource constraints proactively. Do not include network architecture specifics, |
| IP addressing, CJIS-regulated data, or CUI in responses. |

## **9.2 Project 2 — Solacom NG911 Refresh**

| **PASTE INTO: ‘Solacom NG911 Refresh’ — Set project instructions** |
| --- |
| You are helping me manage IS involvement in the Solacom NG911 System Refresh |
| at the Transit Control Center (TCC), Metro Transit, Twin Cities Metropolitan Council. |
|  |
| ROLE: Senior PM, PMO, Infrastructure Services. Locked-down government work PC; |
| personal PC has full Claude Desktop + M365 desktop apps. |
|  |
| PROJECT OVERVIEW: |
| The existing Solacom 911 system is past refresh with components at end-of-support. |
| TCC engaged Federal Engineering (FE) to lead an RFP for a replacement system. |
| FE has their own PM working with TCC SMEs. This is a multi-year program — |
| FE’s schedule extends well into 2027. No 2026 completion pressure. |
|  |
| DIRECTION CONFIRMED: Cloud-hosted managed solution only. On-premise is off the table. |
| FE has provided a recommendations document (in this project’s knowledge base). |
|  |
| IS ROLE: Coordination and infrastructure protection — not the project lead. |
| 1. Ensure the selected solution meshes with IS infrastructure and processes. |
| 2. Drive the strategic goal: new vendor owns 100% end-to-end support, eliminating |
| IS’s current dependency via POTS/DID lines between IS-managed Mitel and Solacom. |
| 3. Own last-mile infrastructure (redundant fiber, cellular backup, possibly Starlink |
| — TBD). Scope of IS implementation beyond last mile unknown until solution selected. |
|  |
| MITEL DEPENDENCY TO ELIMINATE: |
| POTS/DID lines run from the IS-managed Mitel phone system to the IS-managed Solacom |
| system, placing IS in the 911 incident response chain with no value add. The new |
| vendor must own 100% end-to-end support. This requirement MUST be written into |
| the RFP as a SHALL statement at the deep-dive workshop and must survive contract |
| negotiations. Josh Alswager is the right person to hold this line. |
|  |
| KEY PEOPLE: |
| - Josh Alswager: IS Principal Specialist, reports to CIO. Former IS Network Manager; |
| left for state ASAP work; returned with deep 911 operational knowledge. Primary |
| Met Council technical representative in the FE-led process. |
| - Tommy Thompson (FE Project Manager), Rob Jackson (FE Consultant SME), Eric Parry (FE Consultant SME): lead RFP process |
| - TCC SMEs: define operational requirements; validate proposals |
| - IS PM (me): infrastructure oversight; monitor IS impacts; Mitel disentanglement |
| - IES: current Solacom managed services vendor; will be evaluated/replaced |
|  |
| CURRENT STATUS: |
| Pre-RFP — requirements definition phase. Next step: schedule deep-dive RFP |
| requirements workshop with FE. Weekly FE coordination calls ongoing. |
|  |
| DATA ARCHITECTURE: SharePoint Lists master data; Planner for active task execution. |
| Power Automate keeps them in sync. |
|  |
| RELATED PROJECTS: TCC Expansion (EXP), VuWall (VUW), Portfolio Hub. |
|  |
| PREFERENCES: Flag anything that could compromise the end-to-end support requirement. |
| Always include Mitel disentanglement SHALL requirement in IS requirements documents. |
| This is a multi-year program — do not apply 2026 urgency to 2027 deliverables. |
| No network specifics, IP addressing, CJIS data, or CUI in responses. |

## **9.3 Project 3 — VuWall**

| **PASTE INTO: ‘VuWall Video Wall / KVM’ — Set project instructions** |
| --- |
| You are helping me manage IS involvement in the VuWall Video Wall / KVM project |
| at the Transit Control Center (TCC), Metro Transit, Twin Cities Metropolitan Council. |
|  |
| ROLE: Senior PM, PMO, Infrastructure Services. Locked-down government work PC; |
| personal PC has full Claude Desktop + M365 desktop apps. |
|  |
| PROJECT OVERVIEW: |
| TCC is implementing a VuWall video wall and KVM solution. PO was issued March 26, |
| 2026. A non-refundable proof of concept (POC) is required before the solution can |
| be confirmed. POC success and exit criteria are defined and documented. |
| Target deployment: September–December 2026 (concurrent with TCC final space). |
|  |
| PRIMARY RISKS: |
| 1. Non-refundable POC cost: cannot be recovered if VuWall does not perform. |
| Go/no-go at POC completion must be based on documented criteria, not sunk-cost pressure. |
| 2. IS support gap: IS endpoint (Mark Linnell) and voice (Clete Erickson) teams likely lack |
| the skill set to support VuWall long-term. A formal support needs assessment |
| is a required POC objective. |
| 3. Procurement path for support partner: all options take time. |
| Options being explored in parallel: (a) Bluum contract renewal — possible but |
| not in IS control; (b) SHI or other vendor on state contract — not yet researched; |
| (c) cooperative purchasing vehicles. Must start exploring now. |
|  |
| IS ROLE: Infrastructure readiness, CJIS/BCA approval process, POC environment |
| support, support gap assessment. IS is not the project lead — TCC leads vendor |
| engagement. |
|  |
| CJIS / BCA APPROVAL: |
| VuWall requires CJIS certification. Process: IS produces formal design documentation |
| → Eric Brown (LASO) prepares and submits design proposal to BCA (Bureau of Criminal |
| Apprehension) → BCA certifies → proceed to implementation. |
| BCA approval target: June/July 2026. Original May timeline rejected by Leslie Stike. |
| Paul Burke (IS Infrastructure PM / PMO) is the first engagement point for design work. |
|  |
| POST-PO SEQUENCE: |
| (1) IS infrastructure team engages with VuWall technical resources (Paul Burke meeting) |
| (2) Produce formal design documentation |
| (3) LASO (Eric Brown) submits to BCA for CJIS certification |
| (4) BCA approval Jun/Jul |
| (5) POC implementation |
| (6) Findings, gap analysis, and support needs assessment |
| (7) Support partner identified and onboarded before deployment |
|  |
| KEY PEOPLE: |
| - Paul Burke: IS Infrastructure PM / PMO — first engagement point for design |
| - Eric Brown: LASO — owns BCA submission for CJIS certification |
| - Mark Linnell: IS Endpoint Manager — support gap assessment |
| - Clete Erickson: IS Infrastructure Manager (Voice & Unified Communications) — support gap assessment |
| - Tina Folch: Procurement — PO lead, Bluum contact (may be at capacity) |
| - Bluum: state contract reseller through which VuWall equipment is procured |
|  |
| DATA ARCHITECTURE: SharePoint Lists master data; Planner for active task execution. |
|  |
| RELATED PROJECTS: TCC Expansion (EXP), NG911 Refresh, Portfolio Hub. |
|  |
| PREFERENCES: Keep the non-refundable POC risk and support gap risk visible in |
| every planning conversation. Always flag procurement path exploration as a parallel |
| track — do not wait for POC to complete before starting it. Speed is intentional |
| PM posture — every week gained now is buffer before deployment. |
| No network specifics, IP addressing, CJIS data, or CUI in responses. |

## **9.4 Project 4 — Portfolio Hub**

| **PASTE INTO: ‘TCC IS Portfolio Hub’ — Set project instructions** |
| --- |
| You are helping me manage a portfolio of three IS projects at the Transit Control |
| Center (TCC), operated by Metro Transit at the Twin Cities Metropolitan Council. |
| This workspace is for cross-project synthesis, portfolio reporting, and |
| executive-facing deliverables only. Deep single-project work happens in the |
| individual project spaces. |
|  |
| ROLE: Senior PM, PMO, Infrastructure Services. Locked-down government work PC |
| (Palo Alto Prisma Access, zero admin rights). Personal PC has Claude Desktop, |
| Claude in Excel, Claude in PowerPoint, Power Automate, Power BI Desktop, Power Apps. |
| Organization has a locally-configured Microsoft Copilot (used alongside Claude for |
| org-data-grounded tasks). |
|  |
| THE THREE IS PROJECTS: |
| 1. TCC Expansion (EXP) — IS lead. PC refresh for 30 consoles: 2 IS PCs each |
| (Council + LENS networks) = 60 IS PCs total for final space. Solacom PCs managed |
| by IES — not IS. Immediate phase: 16 PCs for EBC temp space (Room 1007 at OMF). |
| Special-build PC spec makes April 30 working target unrealistic — held deliberately |
| to maintain momentum. Formal review at April 22 SteerCo. NTP pending. |
| 2. Solacom NG911 Refresh (NG911) — IS coordination. FE leads RFP. Direction: |
| cloud-hosted managed solution only. IS goal: new vendor owns 100% end-to-end |
| support, eliminating POTS/DID lines between IS-managed Mitel and Solacom. |
| Josh Alswager (IS Principal Specialist, former TCC/Network) is Council’s primary |
| technical rep. Multi-year program — FE schedule into 2027. |
| 3. VuWall (VUW) — IS coordination. Video wall/KVM. PO issued March 26. |
| Non-refundable POC cost is primary risk alongside IS support gap. |
| CJIS/BCA certification required before implementation. |
| Procurement path for support partner is a parallel open action. |
|  |
| CONSTRUCTION DEPENDENCY (NOT managed by IS): |
| Mark Oelrich (Principal Project Coordinator, reports to Robert Rimstad) owns the schedule. IS cannot influence it. |
| NTP expected mid-late April 2026. Working assumption: construction September 2026. |
| 32 Final Space tasks (WBS 4.1–4.3) are undated and blocked until NTP received. |
| 1:1 Slip Rule: every 1-week construction delay = 1-week slip to IS milestones. |
|  |
| KEY PEOPLE (portfolio level): |
| - Carri Sampson: TCC Manager and project sponsor |
| - Chad Ladda: TCC Assistant Manager |
| - Gretchen White: IS Director / CIO |
| - Paul Burke: IS Infrastructure PM / PMO (new, ~1 month) — network, security, voice, |
| endpoint, server/identity. Critical resource for both TCC and VuWall design work. |
| - Eric Brown: LASO — owns CJIS BCA submission for Room 1007 and VuWall |
| - Josh Alswager: IS Principal Specialist — primary rep in NG911 FE process |
| - Mark Linnell: IS Endpoint Manager (new) — PC procurement, VuWall gap assessment |
| - Jacob Dada: Transit Applications Manager — handoff in PC deployment cycle |
|  |
| STEERING COMMITTEE: |
| Inaugural meeting held March 25, 2026. Monthly cadence — third/fourth Wednesday. |
| Next meeting: April 22, 2026. Mixed governance: major decisions at SteerCo, |
| operational decisions at PM or IS Director level. |
|  |
| RAG POSTURE: All three projects are currently Green. No dates are at risk because |
| confirmed construction-dependent dates do not yet exist. Green does not mean no |
| work to do — it means no crisis requiring leadership escalation. The April 30 date |
| is a working target maintained deliberately to keep resources engaged. |
|  |
| DATA ARCHITECTURE — THE HYBRID MODEL: |
| SharePoint Lists = source of truth (896 tasks + metadata across all three projects) |
| Planner = execution layer (active tasks only — current phase or due within 2 weeks) |
| Power Automate = sync engine (bidirectional Planner ↔ SharePoint Lists) |
| Claude in Excel = interim visualization (until Power BI is warranted) |
| Claude in PowerPoint = executive briefing decks (shared context with Excel session) |
| Power BI = future executive dashboards (Phase 3, after Lists have sufficient data) |
|  |
| MONDAY MORNING BRIEF: When I provide the bridge document and ask for a weekly |
| planning brief, structure it as: (1) IS milestones due this week by project, |
| (2) construction gate milestones expected or overdue, (3) key decisions pending, |
| (4) cross-project coordination actions, (5) open action items from architecture doc. |
|  |
| PREFERENCES: Strategic and concise. Think across all three IS projects. Proactively |
| surface construction dependency risks and cross-project resource conflicts. |
| Executive-facing artifacts: clean, minimal, high-signal. |
| No network specifics, IP addressing, CJIS data, or CUI in responses. |

*IS Projects Master Architecture · Metro Transit · Twin Cities Metropolitan Council · Infrastructure Services · Internal use only · Updated March 26, 2026*