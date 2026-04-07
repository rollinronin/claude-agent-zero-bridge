# TCC IS Portfolio — Documentation Gap Audit
**Metropolitan Council Information Services | TCC Expansion Program**
Prepared by: AI Project Management Partner (Agent Zero)
For: PT Tat-Siaka, Senior IS PM | MayAnn Severud, IS PMO Manager
Date: April 7, 2026 | Version: 1.0

> **Sharing Note:** This artifact is intended for use across both Agent Zero and Claude AI project workspaces. It is a living PM artifact — update version and date when revised.

---

## TABLE OF CONTENTS
1. Executive Summary
2. Gap Analysis Matrix
3. CJIS Documentation Requirements
4. BCA Design Proposal Process
5. Minnesota State Procurement Requirements
6. FTA Documentation Requirements
7. Cross-Project Shared Documents
8. Recommended Creation Sequence (First 10 Documents)

---

## SECTION 1: EXECUTIVE SUMMARY

### Overview

This audit evaluates documentation completeness across the TCC IS Portfolio — three projects managed by PT Tat-Siaka in the IS Infrastructure Department — against IS PMO Large Project standards, CJIS Security Policy v5.9.2 requirements, Minnesota state government procurement standards, and BCA design proposal process requirements. The audit was triggered by the IS PMO checklist identifying three confirmed gaps (OCM Intake Forms, OCM Strategies, and Requirements Documents) and expanded to a comprehensive cross-category assessment.

### Total Documents Identified

| Status | Count |
|---|---|
| Total documents identified as needed across the portfolio | 42 |
| Documents confirmed to exist (fully or partially) | 14 |
| Documents confirmed missing (net-new creation required) | 18 |
| Documents that can be derived from existing artifacts | 10 |
| Documents owned by external parties (IS cannot produce) | 4 |
| Documents deferred to future phases | 6 |

### Count by Priority Tier

| Priority | Count | Description |
|---|---|---|
| CRITICAL | 9 | Missing now; blocks BCA path, SteerCo governance, or IS PMO audit |
| HIGH | 14 | Needed this month (April 2026); affects schedule or compliance |
| MEDIUM | 12 | Needed this phase (Phase 1 close / Phase 2 entry) |
| LOW | 7 | Nice to have; Phase 2 or closeout orientation |

### Top 5 Highest-Risk Gaps

**Gap 1 — Room 1007 IS Network Architecture Diagram (EXP #222)**
Risk Level: CRITICAL | Effort: M (1–2 days)
Rationale: Eric Brown (LASO) cannot initiate the BCA design proposal for Room 1007 without a formal IS-produced network design document. This is the single document on the critical path to June 2026 BCA submission. IS Network team confirmed unavailable April–May — this document must be produced NOW before that window closes. Every week of delay compresses the BCA preparation window directly.

**Gap 2 — Requirements Documents (All Three Projects)**
Risk Level: CRITICAL | Effort: M per project (1–2 days each)
Rationale: Explicitly flagged as missing in the IS PMO audit checklist. MayAnn Severud's audit cannot close without these. For NG911, the Federal Engineering RFP workshop (April 17) produces requirements — IS must capture IS-specific requirements formally. For EXP, requirements drive the PC spec, network spec, and endpoint deployment scope. For VuWall, requirements define the POC acceptance criteria and BCA scope boundaries.

**Gap 3 — OCM Intake Forms and OCM Strategies (All Three Projects)**
Risk Level: CRITICAL | Effort: S per form, M per strategy
Rationale: IS PMO audit checklist flagged both as missing for all three projects. Organizational Change Management documentation is a gate for MayAnn Severud's Large Project audit. These cannot be deferred past the next PMO review cycle. The Intake Forms are low-effort (fillable forms) but unlock the OCM Strategy work. None of the three projects have any OCM documentation.

**Gap 4 — VuWall BCA Design Proposal Input Package (VUW #11138)**
Risk Level: CRITICAL | Effort: L (3–5 days total across IS Network + LASO)
Rationale: PO was issued March 26, 2026 — non-refundable. BCA approval target is June 2026 with an 8–10 week review window. For June submission to be achievable, IS must deliver network design documentation to Eric Brown no later than mid-April. IS Network confirmed unavailable April–May — this creates a direct conflict that must be resolved immediately with Leslie Sticht and Andrea Rucks. If the June submission window is missed, BCA approval slides to August–September, threatening the VuWall deployment timeline.

**Gap 5 — NG911 IS Requirements and Scope Statement (NG911 #193)**
Risk Level: HIGH | Effort: M (1–2 days)
Rationale: The April 17 deep-dive RFP workshop with Federal Engineering is imminent. Without a formal IS Requirements document in advance, IS risks having its needs inadequately represented in the RFP. The Mitel disentanglement SHALL requirement, cloud-hosted managed solution direction, and zero IS 24/7 operational obligation must be formally documented as IS requirements before the RFP is finalized — not just captured in meeting notes.

### Derivable vs. Net-New Summary

| Approach | Count | Key Sources |
|---|---|---|
| Derive from existing documents | 10 | Master Architecture v3, EXP WBS, RAID Log, Stakeholder Register, existing charters |
| Net-new creation required | 18 | Requirements docs, OCM artifacts, BCA input packages, network diagrams |
| Request from external party | 4 | Construction schedule (Oelrich), FE requirements output (Thompson), IES/Solacom system specs, BCA submission (Brown) |
| Already exists — no action needed | 14 | See Gap Matrix column |

### Effort Estimate Key

| Code | Definition |
|---|---|
| S | Small: Less than 4 hours; one sitting |
| M | Medium: 1–2 days; requires input from one other party |
| L | Large: 3–5 days; requires multi-party input, review cycle |
| XL | Extra-Large: 1+ week; complex, iterative, or dependent on external events |

---

## SECTION 2: GAP ANALYSIS MATRIX

> Legend — Priority: CRITICAL = blocks other work | HIGH = needed this month | MEDIUM = needed this phase | LOW = nice to have
> Action: Create = net-new | Derive = from existing docs | Request = from named external party | Defer = future phase
> Effort: S <4hrs | M 1-2 days | L 3-5 days | XL 1+ week

| # | Document Name | Category | Projects | Typical Owner | Priority | Risk if Missing | Derivable From | Action | Effort |
|---|---|---|---|---|---|---|---|---|---|
| 1 | IS Portfolio Charter v1.0 | 1-GOV | ALL | IS PM (PT) | EXISTS | — | Exists | None | — |
| 2 | EXP Project Charter v1.0 | 1-GOV | EXP | IS PM (PT) | EXISTS | — | Exists | None | — |
| 3 | NG911 Project Charter | 1-GOV | NG911 | IS PM (PT) | HIGH | No formal IS project scope boundary; FE and IS obligations undefined | Net-new | Create | M |
| 4 | VuWall Project Charter | 1-GOV | VUW | IS PM (PT) | HIGH | No formal IS project scope boundary; BCA scope unclear | Net-new | Create | M |
| 5 | OCM Intake Form — EXP | 6-CHG | EXP | IS PM (PT) | CRITICAL | IS PMO audit gate; blocks OCM Strategy; required for Large Project compliance | Net-new (PMO form) | Create | S |
| 6 | OCM Intake Form — NG911 | 6-CHG | NG911 | IS PM (PT) | CRITICAL | IS PMO audit gate; blocks OCM Strategy | Net-new (PMO form) | Create | S |
| 7 | OCM Intake Form — VuWall | 6-CHG | VUW | IS PM (PT) | CRITICAL | IS PMO audit gate; blocks OCM Strategy | Net-new (PMO form) | Create | S |
| 8 | OCM Strategy — EXP | 6-CHG | EXP | IS PM (PT) | CRITICAL | IS PMO audit gate; operator transition to EBC requires change support plan | OCM Intake Form + Charter | Create | M |
| 9 | OCM Strategy — NG911 | 6-CHG | NG911 | IS PM (PT) | CRITICAL | IS PMO audit gate; 911 dispatcher workflow change is high-impact | OCM Intake Form + Charter | Create | M |
| 10 | OCM Strategy — VuWall | 6-CHG | VUW | IS PM (PT) | CRITICAL | IS PMO audit gate; video wall operator training and adoption | OCM Intake Form + Charter | Create | M |
| 11 | IS Requirements Document — EXP | 2-TECH | EXP | IS PM (PT) + Paul Burke | CRITICAL | IS PMO audit gate; PC spec, network spec, and endpoint deployment scope undefined without it | EXP Charter + WBS + Master Architecture v3 | Create | M |
| 12 | IS Requirements Document — NG911 | 2-TECH | NG911 | IS PM (PT) + Josh Alswager | CRITICAL | IS PMO audit gate; RFP workshop April 17 — IS requirements must precede RFP drafting | FE Recommendations doc + Bridge doc | Create | M |
| 13 | IS Requirements Document — VuWall | 2-TECH | VUW | IS PM (PT) + Leslie Sticht | CRITICAL | IS PMO audit gate; defines POC acceptance criteria and BCA scope boundaries | VUW Bridge doc + POC criteria | Create | M |
| 14 | Room 1007 IS Network Architecture Diagram | 2-TECH | EXP | IS Network (Leng Ly / Casey Clay) | CRITICAL | Eric Brown (LASO) cannot initiate BCA design proposal without this; June BCA window at risk | Master Architecture v3 (partial) | Create | M |
| 15 | Room 1007 IS Network Design Document (narrative) | 2-TECH | EXP | IS Network (Leng Ly) | CRITICAL | BCA design proposal input; supports Eric Brown's submission to BCA | Network Architecture Diagram + Master Architecture v3 | Derive | M |
| 16 | VuWall AV-over-IP Network Design Document | 2-TECH | VUW | IS Network (Leslie Sticht's team) | CRITICAL | Required by Eric Brown (LASO) for VuWall BCA design proposal; June submission target | VUW POC criteria + Master Architecture v3 | Create | L |
| 17 | EXP Scope Statement v1.0 | 1-GOV | EXP | IS PM (PT) | EXISTS | — | Exists | None | — |
| 18 | NG911 Scope Statement | 1-GOV | NG911 | IS PM (PT) | HIGH | IS obligations vs. FE and IES/Solacom obligations undefined; Mitel disentanglement scope unclear | NG911 Bridge doc + FE Recommendations | Create | M |
| 19 | VuWall Scope Statement | 1-GOV | VUW | IS PM (PT) | HIGH | IS vs. vendor obligations unclear; POC scope vs. production scope boundary undefined | VUW Bridge doc | Create | S |
| 20 | EXP RACI v1.0 | 1-GOV | EXP | IS PM (PT) | EXISTS | — | Exists | None | — |
| 21 | NG911 RACI | 1-GOV | NG911 | IS PM (PT) | HIGH | IS vs. FE vs. IES/Solacom responsibility confusion; Josh Alswager IS role unclear | NG911 Scope Statement + Stakeholder Register | Derive | S |
| 22 | VuWall RACI | 1-GOV | VUW | IS PM (PT) | HIGH | IS vs. SHI vs. VuWall vendor responsibility unclear; Eric Brown's role must be explicit | VUW Scope Statement + Stakeholder Register | Derive | S |
| 23 | EXP Stakeholder Register v1.0 | 1-GOV | EXP | IS PM (PT) | EXISTS | — | Exists | None | — |
| 24 | NG911 Stakeholder Register | 1-GOV | NG911 | IS PM (PT) | MEDIUM | Stakeholder mapping for FE, IES, BCA, MTPD not documented | Master Stakeholder Register + EXP version | Derive | S |
| 25 | VuWall Stakeholder Register | 1-GOV | VUW | IS PM (PT) | MEDIUM | SHI reseller, VuWall vendor, Eric Brown, BCA stakeholders not mapped | Master Stakeholder Register + EXP version | Derive | S |
| 26 | EXP Communication Plan v1.0 | 1-GOV | EXP | IS PM (PT) | EXISTS | — | Exists | None | — |
| 27 | NG911 Communication Plan | 1-GOV | NG911 | IS PM (PT) | MEDIUM | Stakeholder communication cadence with FE, IES, BCA, TCC not documented | EXP Communication Plan (template) | Derive | S |
| 28 | VuWall Communication Plan | 1-GOV | VUW | IS PM (PT) | MEDIUM | POC status updates, BCA coordination, SHI engagement cadence undefined | EXP Communication Plan (template) | Derive | S |
| 29 | PC and Endpoint Technical Specifications — EBC Room 1007 | 2-TECH | EXP | IS Endpoint (Mark Linnell) | HIGH | 16 PC order cannot be finalized without spec; eval units ordered but full spec not documented | EXP Requirements Document | Create | S |
| 30 | Room 1007 Network Hardware Bill of Materials | 2-TECH | EXP | IS Network (Leng Ly) | HIGH | Switch, firewall, UPS procurement blocked without documented specs; CR-T01 cannot be submitted | Master Architecture v3 + Network Design | Create | S |
| 31 | Room 1007 Power Draw and UPS Requirements Document | 5-CONST | EXP | IS Network + IES (shared) | HIGH | UPS sizing requires IS network gear power draw; IES firewall load also needed; construction coordination dependency | Net-new (requires Paul Burke input) | Create | S |
| 32 | NG911 RFP Requirements Matrix | 3-PROC | NG911 | IS PM (PT) + FE (Tommy Thompson) | HIGH | April 17 workshop produces this; IS must have IS-specific inputs ready; Mitel disentanglement SHALL must be written in | FE Recommendations + IS Requirements Document | Create | M |
| 33 | NG911 Vendor Evaluation Criteria and Scoring Matrix | 3-PROC | NG911 | IS PM (PT) + Steven Kensinger | HIGH | Cannot conduct fair vendor evaluation without documented criteria; cloud-hosted managed solution preference must be formalized | NG911 RFP Requirements Matrix | Create | M |
| 34 | VuWall POC Acceptance Criteria (formal document) | 7-TEST | VUW | IS PM (PT) + Mark Linnell | HIGH | POC is underway but formal acceptance gate criteria not documented; pass/fail undefined | VUW POC criteria (informal, exists) | Derive | S |
| 35 | IS CJIS System Security Plan (SSP) — Room 1007 | 4-SEC | EXP | IS Security / Tracy French | HIGH | CJIS Policy v5.9.2 Section 5.0 requires an SSP for all systems touching CJI; BCA will ask for reference | Master Architecture v3 + CJIS documentation (initial) | Create | L |
| 36 | IS CJIS System Security Plan (SSP) — VuWall | 4-SEC | VUW | IS Security / Tracy French | HIGH | VuWall touches LENS network; BCA design proposal will reference SSP; cannot be submitted without it | Room 1007 SSP (partial basis) | Create | L |
| 37 | BCA Design Proposal — VuWall (IS Input Package) | 4-SEC | VUW | Eric Brown (LASO) — IS provides inputs | CRITICAL | June 2026 BCA submission target; 8-week approval; PO already issued; deployment blocked without BCA | VuWall Network Design + SSP + Requirements | Request from Eric Brown (post IS inputs) | L |
| 38 | BCA Design Proposal — Room 1007 / EXP (IS Input Package) | 4-SEC | EXP | Eric Brown (LASO) — IS provides inputs | CRITICAL | Room 1007 CJIS validation; LENS-connected consoles require BCA acceptance | Room 1007 Network Design + SSP | Request from Eric Brown (post IS inputs) | L |
| 39 | BCA Design Proposal — NG911 Cloud Architecture | 4-SEC | NG911 | Eric Brown (LASO) + Josh Alswager | HIGH | Cloud-hosted NG911 solution connecting to PSAP network requires BCA review; coordinate with VuWall submission | NG911 Requirements + IS SSP | Request from Eric Brown (post vendor selection) | XL |
| 40 | CJIS User Agreements — EBC Room 1007 Personnel | 4-SEC | EXP | IS Security / Tracy French | HIGH | CJIS Policy v5.9.2 Section 5.1 requires signed user agreements for all CJI-accessing personnel; cannot onboard operators without | Net-new (standard CJIS form) | Create | S |
| 41 | Construction Coordination Interface Document — Room 1007 | 5-CONST | EXP | Mark Oelrich (Construction PM) — IS inputs | HIGH | IS has zero influence on construction schedule; but IS must document its interface requirements, handoff criteria, and access needs for Lovdal (low-voltage) coordination | Net-new (IS section only) | Create (IS section) | M |
| 42 | Room 1007 IS Readiness Checklist (Pre-Occupation) | 5-CONST | EXP | IS PM (PT) | HIGH | Go/No-Go gate for April 30 EBC target; no formal IS readiness criteria documented | EXP WBS (task-level) + RAID Log | Derive | S |
| 43 | EXP Endpoint Deployment Plan — 16 PC EBC Build | 2-TECH | EXP | IS Endpoint (Mark Linnell) | HIGH | PC deployment cycle time unknown; imaging, domain join, dual-network configuration, TCC tech group handoff process not documented | PC Specs + Requirements Document | Create | M |
| 44 | VuWall Support Partner Procurement Documentation | 3-PROC | VUW | IS PM (PT) + Tina Folch | MEDIUM | Parallel procurement paths (SHI, cooperative purchasing) being explored; no formal evaluation documentation; risk if support gap not covered | Net-new | Create | M |
| 45 | NG911 Letters of Agency (IS Legal Review) | 3-PROC | NG911 | IS Legal + IS PM (PT) | MEDIUM | Required before FE RFP workshop; IS Legal review needed; without letters of agency IS may not be authorized to act in vendor negotiations | Net-new (legal template) | Request from IS Legal | S |
| 46 | Portfolio Risk Management Plan | 1-GOV | ALL | IS PM (PT) | MEDIUM | RAID Log exists (33 items) but no governing risk management methodology document; escalation thresholds undefined | RAID Log + EXP Charter | Derive | S |
| 47 | EXP Change Management Plan (IS Change Requests) | 6-CHG | EXP | IS PM (PT) + Paul Burke | MEDIUM | CR-T01 imminent; change request process not formally documented; lead times and approval chain undefined | EXP Charter + RAID Log | Create | S |
| 48 | VuWall POC Test Plan and Acceptance Report | 7-TEST | VUW | IS PM (PT) + Mark Linnell | MEDIUM | POC underway but no formal test plan; acceptance evidence needed for BCA and SteerCo | VUW POC criteria + Requirements | Create | M |
| 49 | EXP System Integration and Acceptance Test Plan | 7-TEST | EXP | IS PM (PT) + Paul Burke | MEDIUM | Room 1007 go-live requires documented test criteria; LENS and Council network dual-boot validation | EXP Requirements + WBS | Create | M |
| 50 | IS Operations Runbook — Room 1007 EBC | 8-OPS | EXP | IS PM (PT) + Paul Burke | MEDIUM | EBC is temp space (Sept–Oct 2026); IS must document operational procedures for 2-month period | Net-new | Create | M |
| 51 | SteerCo Charter and Governance Document | 1-GOV | ALL | IS PM (PT) + MayAnn Severud | MEDIUM | SteerCo meeting held March 25 but no formal charter; quorum, decision authority, escalation path undefined; IS retirements created governance gaps | EXP Charter + SteerCo meeting notes | Create | M |
| 52 | NG911 Project Schedule (IS tasks only) | 1-GOV | NG911 | IS PM (PT) | MEDIUM | IS has no formally documented schedule for NG911 IS activities; FE leads but IS tasks are not tracked | NG911 Bridge doc + EXP WBS (template) | Create | M |
| 53 | VuWall Project Schedule (IS tasks only) | 1-GOV | VUW | IS PM (PT) | MEDIUM | Post-PO IS tasks not formally scheduled; BCA milestones not tracked | VUW Bridge doc + BCA timeline | Create | S |
| 54 | Training Plan — Room 1007 EBC Operations | 9-TRAIN | EXP | IS PM (PT) + TCC (Chad Ladda) | LOW | IS and TCC staff need documented training approach for EBC systems; operator transition | Net-new | Create | M |
| 55 | Training Plan — VuWall Operators | 9-TRAIN | VUW | IS PM (PT) + SHI/VuWall vendor | LOW | Video wall operational training for TCC operators; vendor-led but IS must plan | Net-new | Create | S |
| 56 | NG911 Training and Transition Plan | 9-TRAIN | NG911 | IS PM (PT) + Josh Alswager | LOW | 911 dispatcher workflow change is high-impact; training plan needed for new system | Post-vendor-selection | Defer | — |
| 57 | EXP Lessons Learned Register | 10-CLOSE | EXP | IS PM (PT) | LOW | Phase 1 EBC close (April 30) should capture lessons for Phase 3 planning | Net-new (rolling) | Create | S |
| 58 | Portfolio Program Closeout Checklist | 10-CLOSE | ALL | IS PM (PT) + MayAnn Severud | LOW | Future phase; PMO standard closeout documentation | Net-new | Defer | — |

---

## SECTION 3: CJIS DOCUMENTATION REQUIREMENTS

### Applicable Standard

CJIS Security Policy v5.9.2 (current as of this audit) governs all information systems, networks, and personnel that access, transmit, store, or process Criminal Justice Information (CJI). The TCC environment handles law enforcement data via the LENS (Law Enforcement Network Services) network, making CJIS compliance a hard requirement across all three projects.

### Documents IS Must Produce Before Eric Brown Can Submit BCA Proposals

The BCA (Minnesota Bureau of Criminal Apprehension) reviews CJIS-impacting system changes through a design proposal process managed by the agency's LASO (Local Agency Security Officer) — in this case, Eric Brown. The BCA will not accept a design proposal that lacks supporting IS documentation. The following documents are the minimum IS must produce as inputs to Eric Brown's submissions:

**For Room 1007 EBC (EXP #222 — BCA Submission Target: June 2026)**

1. Room 1007 IS Network Architecture Diagram — A visual representation of the network topology for Room 1007, showing physical and logical connectivity, VLAN segmentation between Council and LENS networks, demarcation points, and all network devices (switches, firewall, access points if any). Must not contain IP addressing or CUI — topology only.

2. Room 1007 IS Network Design Narrative Document — Written description accompanying the diagram. Documents the design rationale, network segmentation approach, encryption boundaries, and how the design satisfies CJIS Policy v5.9.2 Section 5.10 (system interconnections) and Section 5.12 (network security).

3. IS CJIS System Security Plan (SSP) — Room 1007 — A structured document addressing how each of the 13 CJIS Security Policy control areas is satisfied within the Room 1007 deployment. This is the backbone of BCA review. Tracy French (IS CJIS SME) must lead; IS PM facilitates and coordinates.

4. CJIS User Agreements — Written acknowledgment by all personnel with access to CJI through Room 1007 systems, per CJIS Policy Section 5.1. Required before operators can use LENS-connected workstations.

**For VuWall (VUW #11138 — BCA Submission Target: June 2026)**

1. VuWall AV-over-IP Network Design Document — Documents how the VuWall system connects to the LENS and/or Council networks, video stream routing, display controller placement, network segmentation, and firewall rules. This is the document the BCA reviewers will scrutinize most closely, because AV-over-IP systems are non-traditional CJIS endpoints and BCA may have questions about data persistence and screen capture risk.

2. IS CJIS System Security Plan (SSP) — VuWall — Can be a supplement to the Room 1007 SSP if submitted together, or a standalone document if submitted separately. Addresses VuWall-specific control areas, particularly media protection (Section 5.8) and access control (Section 5.5) given the large-display nature of the system.

3. VuWall POC Security Assessment Summary — Documents the security posture observed during the POC and any remediations applied. BCA may ask whether the POC system was tested on the LENS network or only Council network.

**For NG911 Cloud Architecture (NG911 #193 — BCA Submission Timeline: Post-Vendor-Selection)**

1. NG911 Cloud Architecture Design Document — Because the IS direction is a cloud-hosted managed solution, the BCA will require documentation of how CJI flows from the PSAP (Public Safety Answering Point) through the cloud environment, what data is stored in the cloud, who manages encryption keys, and what IS has visibility and control over. Federal Engineering should produce the primary architecture document; IS must validate it meets CJIS requirements before BCA submission.

2. Cloud Service Provider CJIS Security Addendum — CJIS Policy Section 5.10 requires a formal CJIS Security Addendum with any cloud service provider that touches CJI. IS Legal and Josh Alswager must ensure this is included in the NG911 vendor contract.

### Multi-Network Environment Documentation (Council + LENS)

The dual-network architecture is a distinctive characteristic of the TCC environment that the BCA will examine carefully. IS must document:

- Physical and logical separation of Council network traffic from LENS network traffic at all points in Room 1007 and the final TCC space
- How dual-network operator workstations are configured to prevent cross-network data leakage
- Firewall rule sets (high-level, not actual rules — those are CUI) governing traffic between network segments
- The role of the CJIS-compliant firewall at the Room 1007 data room exit point and how it enforces LENS isolation
- Access control at the physical and logical layer for LENS-connected equipment

Tracey French (IS CJIS SME) is the appropriate author for this documentation, but IS PM must provide the project management framework (template, review cycle, submission timeline) to ensure it is completed before Eric Brown needs it.

### Ongoing CJIS Compliance Documentation

Beyond the BCA submission process, CJIS requires ongoing documentation maintenance:

| Document | Frequency | Owner | Notes |
|---|---|---|---|
| CJIS Audit Log Review | Per CJIS Policy (quarterly minimum) | IS Security | Verify logs are retained and reviewed |
| CJIS User Agreement Renewals | Per CJIS Policy (when personnel change) | IS Security / Tracy French | Track personnel changes in Room 1007 |
| SSP Review and Update | Annual minimum or when system changes | IS Security / Tracy French | Update SSP when network changes occur |
| Incident Response Documentation | Per event | IS Security | CJIS Section 5.3 requires incident documentation |
| Security Awareness Training Records | Annual | IS Security | Document completion for CJIS-accessing personnel |

---

## SECTION 4: BCA DESIGN PROPOSAL PROCESS

### Overview of the BCA Design Proposal Process

The Minnesota Bureau of Criminal Apprehension (BCA) reviews proposed changes to CJIS-connected systems through a design proposal review process. This review is not optional — any system connecting to the LENS network or accessing CJI must receive BCA approval before go-live. The BCA does not expedite reviews; the approximately 8–10 week approval window is fixed and must be treated as a hard constraint in IS project scheduling.

### What IS Must Provide to Eric Brown (LASO)

Eric Brown, as the LASO, prepares and submits the BCA design proposal. He cannot draft the proposal without IS-produced technical inputs. The following is the IS input package Eric Brown requires:

| Input Document | Project | Owner | Target Delivery to Brown | Status |
|---|---|---|---|---|
| Room 1007 Network Architecture Diagram | EXP | IS Network (Leng Ly) | Mid-April 2026 | NOT STARTED — CRITICAL |
| Room 1007 Network Design Narrative | EXP | IS Network (Leng Ly) | Mid-April 2026 | NOT STARTED — CRITICAL |
| IS CJIS SSP — Room 1007 | EXP | Tracy French | Late April 2026 | NOT STARTED — CRITICAL |
| VuWall AV-over-IP Network Design | VUW | IS Network (Leslie Sticht team) | Mid-April 2026 (CONFLICT — team unavailable) | NOT STARTED — CRITICAL |
| IS CJIS SSP — VuWall | VUW | Tracy French | Late April 2026 | NOT STARTED — HIGH |
| VuWall POC Security Assessment | VUW | IS Security + Mark Linnell | May 2026 | In Progress (POC active) |
| NG911 Cloud Architecture Design | NG911 | FE + Josh Alswager | Post-vendor-selection | NOT STARTED — future phase |

**CRITICAL FLAG — IS Network Availability Conflict:**
IS Network team is confirmed unavailable April–May 2026. The VuWall AV-over-IP Network Design Document requires IS Network involvement. This creates a direct conflict with the June 2026 BCA submission target. Resolution options:
1. IS Network produces VuWall design documentation in the two weeks remaining before April availability closes (requires immediate escalation to Leslie Sticht and Andrea Rucks)
2. BCA submission for VuWall slides to July/August, with approval in September–October 2026
3. IS PM escalates resource conflict to SteerCo April 22 for decision

### What Eric Brown Prepares for BCA Submission

Once IS delivers its input package, Eric Brown (LASO) prepares the formal BCA design proposal, which typically includes:

- System description and purpose statement
- Network topology (using IS-provided diagrams)
- Data flow description (what CJI moves where)
- Access control summary
- Encryption statement (referencing IS design)
- Reference to IS SSP
- LASO certification and signature
- Supporting technical documentation attachments (IS inputs)

IS PM should request a courtesy review of Brown's draft before submission to catch any factual errors in the IS section description. This is not IS's document to own, but IS PM should facilitate the review cycle.

### Timeline Documentation — 8-Week Approval Window

| Milestone | Target Date | Working Date |
|---|---|---|
| IS delivers Room 1007 network design docs to Brown | April 14–18, 2026 | 1.5 weeks from now |
| IS delivers VuWall network design docs to Brown (if April) | April 14–18, 2026 | 1.5 weeks from now — HIGH RISK |
| Brown drafts BCA design proposals | April 21 – May 8, 2026 | ~3 weeks |
| IS PM reviews Brown's drafts | May 4–8, 2026 | 1 week review cycle |
| BCA submissions filed | Week of May 11, 2026 | Stagger by 2 weeks minimum |
| BCA approval — VuWall (8 weeks from submission) | ~July 6, 2026 | Best case |
| BCA approval — EXP Room 1007 (8 weeks from submission) | ~July 13, 2026 | Best case |
| NG911 BCA submission (post vendor selection) | Q4 2026 or later | TBD |

> **NOTE:** If IS Network docs are not delivered to Brown by April 18, each week of delay pushes the BCA approval date by one week. There is no recovery mechanism once the window closes.

### VuWall vs. EXP BCA Paths — Are They Separate Submissions?

**Recommendation: Yes — treat as separate submissions, staggered by 2 weeks.**

Rationale:
- VuWall and Room 1007 are distinct systems with different network designs, vendors, and risk profiles
- BCA reviewers may have questions specific to AV-over-IP (VuWall) that require back-and-forth; a combined filing creates risk that both projects are delayed if questions arise on one
- Staggering by 2 weeks allows Brown to address questions on one submission before the second arrives, protecting his capacity
- IS PM should confirm with BCA directly (one phone call) whether combined filing is permitted and whether it offers any processing advantage

**NG911 BCA Path is independent and occurs post-vendor-selection.** Cloud-hosted NG911 will involve the cloud service provider's CJIS Security Addendum, which cannot be finalized before a vendor is selected. This submission is realistically Q4 2026 at earliest.

---

## SECTION 5: MINNESOTA STATE PROCUREMENT REQUIREMENTS

### Applicability to Metropolitan Council

The Metropolitan Council is a regional government agency created by the Minnesota Legislature. It is not a state agency and is not directly subject to MNIT (Minnesota IT Services) technology procurement governance. However, the Metropolitan Council operates under its own procurement policies that reflect Minnesota state government best practices, and it leverages Minnesota state cooperative purchasing vehicles (particularly NASPO ValuePoint and Minnesota SWIFT/MN.IT contracts) to streamline procurement.

### Cooperative Purchasing Vehicle Documentation

When IS procures through cooperative purchasing vehicles (as with the VuWall procurement through SHI on a state contract), the following documentation should exist:

| Document | Purpose | Owner | Status |
|---|---|---|---|
| Cooperative Contract Reference | Identifies the specific state contract number used; establishes legal basis for sole-source purchase | Tina Folch (Procurement) | Should exist for VuWall PO |
| Cooperative Purchasing Justification | Written justification that the state contract satisfies competitive bidding requirements | IS PM + Procurement | Confirm with Tina Folch |
| Price Reasonableness Determination | Documents that the state contract pricing is fair and reasonable | Procurement | Standard procurement practice |
| Vendor Conflict of Interest Disclosure | Required for all procurement actions above a threshold | Vendor + Procurement | Standard |

**Action for IS PM:** Confirm with Tina Folch that the VuWall PO through SHI references the correct cooperative contract number and that a cooperative purchasing justification document exists. If not, produce retroactively before the procurement file is audited.

### For NG911 — Formal RFP Process (Steven Kensinger Leads)

Because NG911 ($3.7M) is a formal competitive procurement, the following documentation standards apply:

| Document | Status | Owner | Notes |
|---|---|---|---|
| Statement of Work / Technical Requirements | IN PROGRESS (FE workshop April 17) | FE (Tommy Thompson) + IS (Josh Alswager) | IS must provide IS-specific requirements |
| RFP Document (formal) | Not yet drafted | Steven Kensinger (RA Procurement) | After requirements workshop |
| Evaluation Criteria and Scoring Matrix | Not yet created | IS PM + Steven Kensinger | IS must document cloud-hosted managed solution preference as weighted criterion |
| Vendor Shortlist and Evaluation Records | Future | Eval team | Required for procurement file |
| Best and Final Offer (BAFO) documentation | Future | Steven Kensinger | Per procurement policy |
| Contract Award Documentation | Future | Steven Kensinger + IS Legal | Includes CJIS Security Addendum |
| Vendor Performance Plan | Future | IS PM + Vendor | Post-award |

**Key Risk:** If IS does not formally document its requirements (including the Mitel disentanglement SHALL requirement and cloud-hosted managed solution direction) before the April 17 workshop, those requirements may not appear in the final RFP with sufficient specificity to be enforceable in vendor evaluation.

### General IT Procurement Documentation Standards (Met Council Context)

| Standard | Application |
|---|---|
| Sole Source Justification | Required when bypassing competitive process; VuWall cooperative purchasing justification serves this role |
| IT Security Review | IS Architecture review (Sreeni Nutulapati / John Stefanko) — already done for VuWall (thumbs-up received) |
| Capital vs. Operating Classification | Hardware (PCs, switches, VuWall) likely capital; maintenance/support likely operating; affects budget coding |
| Asset Registration | All IS-procured hardware must be registered in IS asset management system post-deployment |
| Vendor Onboarding | New vendors (VuWall, SHI for new engagement) may require vendor registration in Met Council financial system |

---

## SECTION 6: FTA DOCUMENTATION REQUIREMENTS

### Applicability Assessment

**Assessment: FTA requirements are likely NOT applicable to these three IS infrastructure projects. Flag for confirmation.**

**Rationale:**

The Federal Transit Administration (FTA) imposes documentation requirements primarily on capital projects funded wholly or partially by federal grants (Sections 5307, 5309, 5337, etc. of the Fixing America's Surface Transportation Act and the Infrastructure Investment and Jobs Act). The key question is whether any of the three TCC IS projects involve federal funding.

| Project | Funding Source Assessment | FTA Applicability |
|---|---|---|
| EXP #222 — TCC Console Expansion | IS infrastructure budget (operating/capital); no indication of federal grant funding | Likely NOT applicable |
| NG911 #193 — Solacom Refresh | $3.7M approved budget; NG911 may have federal grant eligibility (FirstNet/PSAP grants) but no indication of federal funding in project documentation | FLAG — confirm funding source with Carri Sampson and Steven Kensinger |
| VuWall #11138 | PO issued; cooperative purchasing via SHI; no indication of federal grant funding | Likely NOT applicable |

### If Federal Funding Is Confirmed for Any Project

If any project is confirmed to involve federal transit or public safety grant funds, the following FTA Circular C 5010.1E documentation requirements would apply:

**Project Management Plan (PMP):** FTA requires a formal PMP for capital projects over $1M in federal funds. The existing IS project charters and WBS would form the basis of this document but would need to be expanded to meet FTA structure requirements.

**Buy America Certification:** FTA requires that iron, steel, and manufactured products used in federally funded projects be produced in the United States. For IT infrastructure (PCs, switches, servers), the "manufactured in the US" requirement applies to the final assembly. IS Procurement must confirm with each hardware vendor whether Buy America certification can be provided. This is particularly relevant for Cisco hardware.

**Disadvantaged Business Enterprise (DBE) Reporting:** If federal funds are used, DBE participation goals and reporting may apply to any subcontractors or vendors.

**Audit Trail and Record Retention:** FTA-funded projects require a minimum 3-year record retention period post-project-close for financial and procurement records.

### NG911 — Additional Federal Funding Context

NG911 systems may be eligible for federal funding through:
- **FirstNet** (AT&T public safety broadband network) — not directly applicable to call handling systems
- **PSAP grant programs** (FCC NG911 Grant Program) — potentially applicable; Steven Kensinger should confirm
- **ARPA / State-administered NG911 funds** — Minnesota received federal NG911 transition funding; confirm with MN Department of Public Safety whether any flows to Met Council

**Action for IS PM:** Add a single line item to the April 17 FE workshop agenda: confirm whether any federal funding is in scope for NG911 and whether Buy America or FTA documentation requirements apply.

### Conclusion

Absent confirmation of federal funding, FTA documentation requirements do not apply to these projects. IS PM should document this determination in the project file to prevent future audit questions. A one-paragraph "Federal Funding Applicability Determination" memo is sufficient — file it in the PMO documentation.

---

## SECTION 7: CROSS-PROJECT SHARED DOCUMENTS

### Documents That Serve All Three Projects (Portfolio-Level)

The following documents should be created or maintained at the portfolio level and referenced by all three projects, rather than duplicated in each project file:

| Document | Current Status | Owner | Notes |
|---|---|---|---|
| IS Portfolio Charter v1.0 | EXISTS | IS PM (PT) | Covers all three; update when project charters added |
| IS Project Team Roster (28 people) | EXISTS | IS PM (PT) | Update as personnel change; single source for all projects |
| IS Master Architecture Document v3 | EXISTS | IS Architecture (John Stefanko area) | Internal; single source for network topology context for all designs |
| Access Control Strategy | EXISTS | IS Security | Applies to all three projects |
| Data Architecture Strategy | EXISTS | IS Architecture | Applies to all three projects |
| IS Portfolio RAID Log (33 items) | EXISTS | IS PM (PT) | All three projects; maintain as single log with project tagging |
| SteerCo Governance Charter | MISSING — CRITICAL | IS PM (PT) + MayAnn Severud | Single governance document covering all three projects; applies to SteerCo structure established March 25 |
| Portfolio Risk Management Plan | MISSING — MEDIUM | IS PM (PT) | Methodology document governing how the RAID Log is maintained |
| Portfolio Communication Plan (executive-level) | MISSING — MEDIUM | IS PM (PT) | Covers executive reporting, SteerCo cadence, IS PMO reporting for all three |
| IS CJIS System Security Plan (Master) | MISSING — HIGH | IS Security / Tracy French | Room 1007 and VuWall SSPs may share a master SSP with project-specific supplements |

### Documents Where Mark Oelrich (Construction PM) Is Typical Owner

IS has zero influence on the construction schedule. The following documents are owned by Mark Oelrich or the General Contractor. IS PM should REQUEST these documents (not create them) and file them as reference documents in the IS project file:

| Document | Owner | IS Action | IS Need |
|---|---|---|---|
| Construction Schedule — Room 1007 | Mark Oelrich | Request and file | IS must align IS installation schedule to construction completion |
| NTP (Notice to Proceed) Documentation | Mark Oelrich / Construction PM | Request notification | IS begins Room 1007 work only after NTP confirmed |
| Construction Substantial Completion Certificate | Mark Oelrich | Request and file | IS readiness checklist gates on construction completion |
| Low-Voltage (Lovdal) Cabling As-Built Drawings | Lovdal / Mark Oelrich | Request and file | IS needs to know Cat-6 drop locations, closet termination points |
| Room 1007 Power Distribution Documentation | IES / Facilities | Request and file | IS needs panel circuit assignments for UPS and network gear |
| Facilities Access and Key Control Log | Facilities / Mark Oelrich | Request and file | CJIS requires documentation of physical access controls |

### Documents Derivable from Master Architecture v3 or Existing WBS/RAID

| Derived Document | Source Document(s) | Derivation Effort |
|---|---|---|
| Room 1007 Network Architecture Diagram | Master Architecture v3 (extract Room 1007 section, add device-level detail) | M — IS Network must add layer 2/3 detail not in Master Architecture |
| NG911 RACI | EXP RACI (template) + NG911 Bridge doc + Stakeholder Register | S — adapt EXP template, substitute NG911 roles and parties |
| VuWall RACI | EXP RACI (template) + VuWall Bridge doc | S — same as above |
| NG911/VuWall Stakeholder Registers | EXP Stakeholder Register (template) + project-specific stakeholders | S |
| NG911/VuWall Communication Plans | EXP Communication Plan (template) | S — adapt cadence and distribution for each project |
| Room 1007 IS Readiness Checklist | EXP WBS (milestone tasks) + RAID Log (R001, R002, R004) | S — extract and format task list |
| Portfolio Risk Management Plan | RAID Log (existing 33 items) + EXP Charter (risk section) | S — document the methodology already in practice |
| SteerCo Governance Charter | EXP Charter + SteerCo meeting notes March 25 | M — formalize what was agreed verbally on March 25 |

---

## SECTION 8: RECOMMENDED CREATION SEQUENCE (FIRST 10 DOCUMENTS)

### Prioritization Logic

The recommended sequence prioritizes: (1) unblocking the BCA critical path, (2) satisfying the IS PMO audit, and (3) establishing the governance foundation for SteerCo and ongoing project management. Documents that can be done in parallel are grouped. Documents requiring MayAnn Severud audit are flagged.

---

### Priority 1 — Week of April 7, 2026 (IMMEDIATE)

**Document 1: Three OCM Intake Forms (EXP, NG911, VuWall)**
Sequence Position: 1 (parallel — all three can be done in one sitting)
Rationale: IS PMO audit gate. These are fillable forms (the PMO template exists in the PMO Project Audit Template xlsx in the project knowledge base). Completing all three in one session is feasible. This unlocks OCM Strategies and closes the first IS PMO checklist gap.
Can be done in parallel: Yes — all three forms are independent
MayAnn Severud audit required: Yes — she owns the PMO standard and should review before filing
Effort: S each (under 4 hours total for all three)

**Document 2: Room 1007 IS Network Architecture Diagram**
Sequence Position: 2 (must precede Documents 4 and 7)
Rationale: This is the single most critical missing document in the entire portfolio. Eric Brown (LASO) cannot begin the BCA design proposal without it. IS Network (Leng Ly / Casey Clay) performed the walkthrough — they have the raw information. IS PM must schedule a working session with Leng Ly this week to capture, document, and get it into a presentable format for Eric Brown. The Master Architecture v3 provides the backbone; Leng Ly adds Room 1007-specific device-level detail.
Can be done in parallel: Yes — can proceed simultaneously with Document 1
MayAnn Severud audit required: No — this is a technical document for Eric Brown
Effort: M (1–2 days with Leng Ly's input)

---

### Priority 2 — Week of April 7–11, 2026 (THIS WEEK)

**Document 3: IS Requirements Document — NG911**
Sequence Position: 3 (must precede April 17 FE workshop)
Rationale: The April 17 deep-dive RFP workshop with Federal Engineering is 10 days away. Without a formal IS requirements document, IS risks inadequate representation of its requirements in the RFP. Specifically: Mitel disentanglement SHALL, cloud-hosted managed solution, zero IS 24/7 obligation. Josh Alswager leads the technical content; IS PM frames the document structure. This can be drafted in one intensive working session with Alswager.
Can be done in parallel: Yes — can proceed simultaneously with Documents 1 and 2
MayAnn Severud audit required: Yes — IS PMO audit checklist item
Effort: M (1–2 days)

**Document 4: Room 1007 Network Design Narrative Document**
Sequence Position: 4 (must follow Document 2)
Rationale: Once the network architecture diagram exists (Document 2), the written narrative is a straightforward companion document. Both are needed together for Eric Brown's BCA input package. IS Network authors; IS PM reviews for completeness and CJIS reference accuracy.
Can be done in parallel: No — must follow Document 2
MayAnn Severud audit required: No — technical document
Effort: S–M (can be completed same day as diagram is finalized)

---

### Priority 3 — Week of April 14, 2026

**Document 5: IS Requirements Document — EXP**
Sequence Position: 5 (unblocks PC spec finalization and endpoint deployment plan)
Rationale: PC specs for the 16 EBC units remain an open action item. The Requirements Document formally captures the IS-defined scope: dual-network console configuration, PC count (16 EBC), domain join requirements, imaging standards, CJIS access requirements. Paul Burke and Mark Linnell are the technical contributors. This document is also the IS PMO audit gate item.
Can be done in parallel: Yes — can begin alongside Document 4
MayAnn Severud audit required: Yes
Effort: M (1–2 days)

**Document 6: IS Requirements Document — VuWall**
Sequence Position: 6 (unblocks VuWall BCA input package and formalizes POC scope)
Rationale: POC is underway but formal requirements are not documented. The BCA will ask what VuWall is required to do, what networks it touches, and what the acceptance criteria are. This document provides those answers and formally scopes the BCA submission.
Can be done in parallel: Yes — simultaneous with Document 5
MayAnn Severud audit required: Yes
Effort: M

**Document 7: Three OCM Strategies (EXP, NG911, VuWall)**
Sequence Position: 7 (must follow OCM Intake Forms — Document 1)
Rationale: OCM Strategies are the second IS PMO audit gate item. Once the Intake Forms are complete (Document 1), IS PM can draft the three OCM Strategies. For EXP, the focus is operator transition to EBC (temp space) and back to Minneapolis. For NG911, dispatcher workflow change. For VuWall, video wall adoption and operator training. These strategies need not be exhaustive — they must demonstrate IS has a plan for managing change.
Can be done in parallel: All three can be drafted in parallel; OCM Intake Forms must be complete first
MayAnn Severud audit required: Yes
Effort: M each (one intensive session for all three if IS PM drafts)

---

### Priority 4 — Weeks of April 14–18, 2026

**Document 8: IS CJIS System Security Plan — Room 1007 (EBC)**
Sequence Position: 8 (must follow Room 1007 Network Design Documents 2 and 4; feeds into BCA submission)
Rationale: Tracy French leads; IS PM coordinates. The SSP is the most technically complex document in the BCA input package. It references the network design (Documents 2 and 4) and addresses all 13 CJIS control areas for Room 1007. Initiating this document in week 2 gives Brown enough time to incorporate it into his design proposal before the May submission window.
Can be done in parallel: Yes — can begin as soon as Documents 2 and 4 are complete
MayAnn Severud audit required: No — CJIS document reviewed by Eric Brown and BCA, not PMO
Effort: L (3–5 days; Tracy French is the knowledge holder)

**Document 9: SteerCo Governance Charter**
Sequence Position: 9 (needed before April 22 SteerCo meeting)
Rationale: The April 22 SteerCo is 15 days away. The first SteerCo was held March 25 without a formal charter. Before the second meeting, a governance charter should be in place documenting: quorum definition, decision authority levels, escalation thresholds, meeting cadence, and voting/consensus process. This directly addresses the IS retirement governance gap and the Carri Sampson attendance issue. The document should be shared with SteerCo members before April 22.
Can be done in parallel: Yes — independent of BCA track documents
MayAnn Severud audit required: Yes — governs the IS PMO reporting relationship
Effort: M

**Document 10: VuWall AV-over-IP Network Design Document**
Sequence Position: 10 (PARALLEL TRACK — high risk due to IS Network availability conflict)
Rationale: This document is on the critical path for the VuWall June BCA submission. However, IS Network is confirmed unavailable April–May. The window to produce this document is the next 1–2 weeks, before IS Network is fully consumed by EXP Room 1007 work. IS PM must escalate the conflict to Leslie Sticht and Andrea Rucks immediately and get a commitment: either IS Network produces the VuWall design document in the next 10 business days, or IS PM acknowledges to SteerCo on April 22 that the VuWall BCA submission will slide to August at the earliest.
Can be done in parallel: Yes — but requires IS Network bandwidth that is under contention
MayAnn Severud audit required: No — technical document
Effort: L (3–5 days; requires IS Network team lead involvement)

---

### Parallel vs. Sequential Summary

```
WEEK 1 (April 7–11) — All in parallel:
  [1] OCM Intake Forms x3  ──────────────────────────────────────► [7] OCM Strategies x3
  [2] Room 1007 Network Diagram ────────────────────────────────► [4] Network Narrative ─► [8] CJIS SSP Room 1007
  [3] IS Requirements — NG911 (must finish before April 17)
  [9] SteerCo Governance Charter (must finish before April 22)
  [10] VuWall Network Design — ESCALATE IMMEDIATELY (resource conflict)

WEEK 2 (April 14–18) — After Week 1 outputs:
  [5] IS Requirements — EXP (unblocks PC spec and deployment plan)
  [6] IS Requirements — VuWall (unblocks VuWall BCA input package)
  Continue [7], [8], [10]

WEEK 3 (April 21 onward — post SteerCo April 22):
  IS delivers BCA input package to Eric Brown
  Brown begins BCA design proposal drafting
  MayAnn Severud reviews OCM and Requirements documents
```

---

## APPENDIX A: DOCUMENT STATUS SUMMARY TABLE

| # | Document | Status | Priority | Effort | Next Action |
|---|---|---|---|---|---|
| 1 | IS Portfolio Charter v1.0 | EXISTS | — | — | Maintain |
| 2 | EXP Project Charter v1.0 | EXISTS | — | — | Maintain |
| 3 | NG911 Project Charter | MISSING | HIGH | M | Create this month |
| 4 | VuWall Project Charter | MISSING | HIGH | M | Create this month |
| 5 | OCM Intake Form — EXP | MISSING | CRITICAL | S | Create this week |
| 6 | OCM Intake Form — NG911 | MISSING | CRITICAL | S | Create this week |
| 7 | OCM Intake Form — VuWall | MISSING | CRITICAL | S | Create this week |
| 8 | OCM Strategy — EXP | MISSING | CRITICAL | M | Create after Intake Form |
| 9 | OCM Strategy — NG911 | MISSING | CRITICAL | M | Create after Intake Form |
| 10 | OCM Strategy — VuWall | MISSING | CRITICAL | M | Create after Intake Form |
| 11 | IS Requirements Doc — EXP | MISSING | CRITICAL | M | Create this week |
| 12 | IS Requirements Doc — NG911 | MISSING | CRITICAL | M | Create before April 17 |
| 13 | IS Requirements Doc — VuWall | MISSING | CRITICAL | M | Create this week |
| 14 | Room 1007 Network Architecture Diagram | MISSING | CRITICAL | M | Create this week — BCA path |
| 15 | Room 1007 Network Design Narrative | MISSING | CRITICAL | M | Derive from #14 |
| 16 | VuWall AV-over-IP Network Design Doc | MISSING | CRITICAL | L | Create now — resource conflict |
| 17 | EXP Scope Statement v1.0 | EXISTS | — | — | Maintain |
| 18 | NG911 Scope Statement | MISSING | HIGH | M | Create this month |
| 19 | VuWall Scope Statement | MISSING | HIGH | S | Create this month |
| 20 | EXP RACI v1.0 | EXISTS | — | — | Maintain |
| 21 | NG911 RACI | MISSING | HIGH | S | Derive from EXP RACI |
| 22 | VuWall RACI | MISSING | HIGH | S | Derive from EXP RACI |
| 23 | EXP Stakeholder Register v1.0 | EXISTS | — | — | Maintain |
| 24 | NG911 Stakeholder Register | MISSING | MEDIUM | S | Derive from EXP version |
| 25 | VuWall Stakeholder Register | MISSING | MEDIUM | S | Derive from EXP version |
| 26 | EXP Communication Plan v1.0 | EXISTS | — | — | Maintain |
| 27 | NG911 Communication Plan | MISSING | MEDIUM | S | Derive from EXP template |
| 28 | VuWall Communication Plan | MISSING | MEDIUM | S | Derive from EXP template |
| 29 | PC/Endpoint Technical Specs — EBC | MISSING | HIGH | S | Create (Mark Linnell leads) |
| 30 | Room 1007 Network Hardware BOM | MISSING | HIGH | S | Create (Leng Ly leads) |
| 31 | Room 1007 Power Draw / UPS Requirements | MISSING | HIGH | S | Create (IS Network + IES) |
| 32 | NG911 RFP Requirements Matrix | MISSING | HIGH | M | Create before/at April 17 |
| 33 | NG911 Vendor Evaluation Criteria Matrix | MISSING | HIGH | M | Create (Steven Kensinger) |
| 34 | VuWall POC Acceptance Criteria (formal) | PARTIAL | HIGH | S | Derive from POC criteria |
| 35 | IS CJIS SSP — Room 1007 | MISSING | HIGH | L | Create (Tracy French leads) |
| 36 | IS CJIS SSP — VuWall | MISSING | HIGH | L | Create (Tracy French leads) |
| 37 | BCA Design Proposal — VuWall (IS inputs) | MISSING | CRITICAL | L | Request from Eric Brown |
| 38 | BCA Design Proposal — EXP Room 1007 (IS inputs) | MISSING | CRITICAL | L | Request from Eric Brown |
| 39 | BCA Design Proposal — NG911 Cloud | MISSING | HIGH | XL | Future phase (post-vendor) |
| 40 | CJIS User Agreements — Room 1007 Personnel | MISSING | HIGH | S | Create (Tracy French) |
| 41 | Construction Coordination Interface Doc | MISSING | HIGH | M | Create IS section; Oelrich owns rest |
| 42 | Room 1007 IS Readiness Checklist | MISSING | HIGH | S | Derive from WBS |
| 43 | EXP Endpoint Deployment Plan — 16 PCs | MISSING | HIGH | M | Create (Mark Linnell leads) |
| 44 | VuWall Support Partner Procurement Docs | MISSING | MEDIUM | M | Create (Tina Folch + IS PM) |
| 45 | NG911 Letters of Agency | MISSING | MEDIUM | S | Request from IS Legal |
| 46 | Portfolio Risk Management Plan | MISSING | MEDIUM | S | Derive from RAID Log + Charter |
| 47 | EXP Change Management Plan (IS CRs) | MISSING | MEDIUM | S | Create (Paul Burke input) |
| 48 | VuWall POC Test Plan and Acceptance Report | MISSING | MEDIUM | M | Create |
| 49 | EXP System Integration and Acceptance Test Plan | MISSING | MEDIUM | M | Create |
| 50 | IS Operations Runbook — Room 1007 EBC | MISSING | MEDIUM | M | Create (Paul Burke leads) |
| 51 | SteerCo Governance Charter | MISSING | MEDIUM | M | Create before April 22 |
| 52 | NG911 Project Schedule (IS tasks) | MISSING | MEDIUM | M | Create |
| 53 | VuWall Project Schedule (IS tasks) | MISSING | MEDIUM | S | Create |
| 54 | Training Plan — Room 1007 EBC Operations | MISSING | LOW | M | Create (Phase 2) |
| 55 | Training Plan — VuWall Operators | MISSING | LOW | S | Create (vendor-led) |
| 56 | NG911 Training and Transition Plan | MISSING | LOW | XL | Defer (post-vendor-selection) |
| 57 | EXP Lessons Learned Register | MISSING | LOW | S | Create (rolling) |
| 58 | Portfolio Program Closeout Checklist | MISSING | LOW | M | Defer (future phase) |

---

*End of TCC IS Portfolio Documentation Gap Audit v1.0*
*For questions: PT Tat-Siaka, IS Senior PM | Review required: MayAnn Severud, IS PMO Manager*
*Next review: April 22, 2026 SteerCo or upon completion of Priority 1 documents*
