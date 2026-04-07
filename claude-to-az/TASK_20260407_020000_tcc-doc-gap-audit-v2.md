---
from: claude
to: agent-zero
datetime: 2026-04-07T02:00:00Z
priority: high
task_type: research
task_id: task-001-doc-gap-audit-v2
expected_output: Markdown report with gap analysis matrix, risk assessment, and recommended action items
supersedes: task-001-doc-gap-audit
---

# TCC IS Portfolio Documentation Gap Audit (Revised)

## Context

Rollin (PT / Ptahmes Tat-Siaka) is Senior PM for Infrastructure Services at the Transit Control Center (TCC), operated by Metro Transit at the Twin Cities Metropolitan Council. He manages three IS projects that share construction dependencies and a common SharePoint-based data architecture.

We are in Phase 1 (Foundation) of standing up the portfolio management system. The documentation gap audit is a critical early step. The WBS has been reconciled and pared down to **76 tasks across all three projects** (from an original ~896). The revised 76-task WBS is already imported into the IS Project Tasks SharePoint List (926 items including the original full set; the 76-task revised set is the current working reference).

## The Three IS Projects

### 1. TCC Expansion (EXP) - IS Lead
- PC refresh for 30 operator consoles: 2 IS PCs each (Council network + LENS network) = 60 IS PCs total
- Solacom PCs (2 per console, managed by IES) are NOT IS responsibility
- Two phases: Phase 1 is EBC buildout in Room 1007 (OMF St. Paul) - IS-owned, not NTP-dependent. Phase 2 is 30-console final space in Minneapolis - construction-gated
- Initial phase: 16 PCs for EBC temp space (Room 1007 at OMF). 3 demo/eval units ordered first (2 HP Z2 special build + 1 CAD catalog)
- Construction-dependent schedule: NTP expected mid-late April 2026 (per Robert Rimstad, SteerCo March 25)
- EBC target: April 30, 2026 held deliberately to maintain momentum; formal review at April 22 SteerCo
- Working assumption: construction activity September 2026, avoiding MN State Fair in August
- 32 WBS tasks tagged Blocked-Construction pending NTP

### 2. Solacom NG911 Refresh (NG911) - IS Coordination
- Federal Engineering (FE) leads the RFP process with TCC SMEs
- Direction confirmed: cloud-hosted managed solution only
- IS goal: new vendor owns 100% end-to-end support, eliminating 4 Mitel lines between IS-managed Mitel and Solacom
- Mitel disentanglement is a SHALL requirement - must be written into the RFP at the deep-dive workshop (April 17) and survive contract negotiations
- Josh Alswager (IS Principal Specialist, former IS Network Manager, PSAP background) is Councils primary technical rep
- Scenario A (~600K new system) vs Scenario B (lift-and-shift) decision package in development - target: present at April 22 SteerCo (discussion only). Funding decision by June 30
- Multi-year timeline - FE schedule extends into 2027

### 3. VuWall (VUW) - IS Coordination
- Video wall/KVM proof of concept
- PO issued March 26, 2026. POC underway
- BCA design proposal is the critical path item - ~8 weeks from submission to approval
- IS Network and LASO (Eric Brown, assigned March 24) must produce design documentation before BCA can be submitted
- Bluum (reseller) contract expired March 31, 2026. Parallel procurement path exploration underway (Bluum renewal, SHI on state contract, cooperative purchasing vehicles)
- IS support gap is primary risk - Clete Erickson (IS Infrastructure Manager, Voice and UC) owns skill gap assessment

### Key People for Documentation Context
- Eric Brown - LASO (Local Agency Security Officer), assigned March 24. Owns BCA submissions for all three projects. Single point for CJIS compliance across portfolio.
- Tracy French - IS Ops / CJIS SME, supports LASO
- Paul Burke - IS Infrastructure PM/PMO (~1 month in role). Network, security, voice, endpoint, server/identity. Go-between for IS infrastructure team.
- Mark Linnell - IS Endpoint Manager. Leading eval PC order for EBC.
- Leslie Sticht - IS Network Manager. Team owns Room 1007 network buildout, VuWall AV LAN, Minneapolis final space assessment.

## What Exists Today

Per the architecture document (Section 5.4), the current documentation inventory is:
- TCC Expansion: SteerCo meeting notes, reconciled WBS (76 tasks revised / 896 original), bridge document
- NG911: FE recommendations document, bridge document
- VuWall: POC criteria (documented), bridge document, CJIS documentation
- All projects: Steering committee inaugural meeting held March 25, 2026
- Portfolio-level: Portfolio Charter v1.0, Master Architecture doc v3, Data Architecture Strategy, Access Control Strategy, IS Project Team roster (28 people), SharePoint folder structure deployed

## What I Need You To Research

For each of the three projects, research and compile what documentation artifacts should exist for a government IT infrastructure project of this type.

### Document Categories to Audit
1. Project governance: charter, RACI, stakeholder register, communication plan
2. Technical: network diagrams, hardware specs, configuration standards, as-built drawings
3. Procurement: RFP/RFQ docs, vendor evaluation matrices, contract/SOW, PO tracking
4. Security/compliance: CJIS compliance docs (TCC handles law enforcement data via LENS network), BCA design proposals, security plans, ATO documentation
5. Construction coordination: phasing plans, space allocation, temporary relocation plans, cable/pathway specs
6. Change management: CAB records, change request logs, rollback plans
7. Testing/acceptance: test plans, UAT criteria, acceptance sign-off templates
8. Operations: runbooks, SOPs, escalation procedures, support handoff documentation
9. Training: user guides, training plans, knowledge transfer docs
10. Closeout: lessons learned, final acceptance, warranty tracking, asset inventory

### Deliverable Format

Create a gap analysis matrix as a markdown table with these columns:
- Document Name
- Category (from list above)
- Applicable Projects (EXP, NG911, VUW, or ALL)
- Typical Owner (PM, IS, vendor, construction PM, FE, LASO)
- Priority (Critical / High / Medium / Low)
- Risk if Missing (brief statement)
- Recommended Action

### Additional Research Requests
1. Look up what CJIS Security Policy (latest version) requires for documentation on projects handling criminal justice information - particularly relevant since Eric Brown (LASO) needs design documentation from IS before he can submit BCA proposals
2. Research Minnesota state procurement documentation requirements for government IT projects
3. Identify any FTA (Federal Transit Administration) documentation requirements that might apply to transit control center infrastructure
4. Note any documentation that should exist specifically because this is a multi-network environment (Council + LENS law enforcement network)
5. What documentation should exist for the BCA design proposal process specifically? Eric Brown needs IS to produce formal design docs before he can submit to BCA.

### Constraints
- Do NOT include any specific network details, IP addressing, CJIS-controlled data, or CUI in your response
- Focus on document TYPES and their purposes, not actual content
- Flag any documents where the construction PM (Mark Oelrich, reports to Robert Rimstad) would be the typical owner - IS has no ability to influence the construction schedule
- Call out documents that are cross-project (shared across EXP/NG911/VUW) vs project-specific
- Note which documents can be derived from existing artifacts (architecture doc, charter, WBS)

## Response Instructions

Drop your completed audit in /az-to-claude/ as:
RESULT_YYYYMMDD_HHMMSS_tcc-doc-gap-audit.md

Include a summary section at the top with:
- Total documents identified
- Count by priority tier
- Top 5 highest-risk gaps to address first
- Which gaps can be derived from existing documents vs need net-new creation
- Estimated effort to close gaps (rough t-shirt sizing: S/M/L/XL)
