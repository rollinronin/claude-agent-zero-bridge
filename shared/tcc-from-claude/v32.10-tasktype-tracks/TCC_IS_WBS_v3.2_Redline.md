# TCC IS Portfolio Hub — WBS v3.2 Red-Line

**Status:** Plan-level locked · Ready for Step 2 (xlsx draft).
**Prepared:** 2026-04-22 · Successor to `TCC_IS_WBS_v3.2_Placeholder_Plan_DRAFT.docx`.
**Supersedes:** `TCC_IS_WBS_v3.1.xlsx` (which remains the v3.1 canonical baseline; v3.2 adds to it, does not rewrite).

---

## 1. What changed vs. the draft

The draft proposed 17 workstreams (7 TCC + 5 NG911 + 5 VuWall) and ~90 new rows. The red-line settles on **20 workstreams (9 TCC + 6 NG911 + 5 VuWall) and ~117 new rows**. SP moves 208 → ~325. Core delta from the draft:

- **Two new workstreams per project for historical back-fill.** TCC gets Room 1007 Temp Space (back-dated setup + forward decommission) and TCC Operational Readiness (Andre's support-needs work stream). NG911 gets Pre-RFP Discovery (Solacom EOL → upgrade proposal → FE cloud pivot, all back-dated). VuWall stays at 5 workstreams but POC Design and Go/No-Go each gain one row.
- **LASO is now explicit as the CJIS-environment gatekeeper.** CJIS Documentation (TCC) and BCA Submission (VuWall) each expand 3 → 4 rows with a dedicated LASO Review Deliverable. NG911 Vendor Selection & Contract adds a LASO Review row as a CJIS-compliance gate before vendor signature.
- **Monitor work is absorbed into PC Deployment & Imaging** (not a separate workstream). Procurement, deploy, and a Back-out / mitigation row (migrate MPLS monitors to OMF if procurement slips — sub-optimal because it complicates fail-back).
- **Phase 2 network capacity analysis pulled forward as Deliverables only** inside both Network workstreams. The broader "Phase 2 Network Capacity" workstream is held as a RAID opportunity; promotable after VuWall current-state findings return.
- **Back-out plan coverage expands from 4 → 6 workstreams** (adds PC Deployment & Imaging and VuWall POC Build).
- **Template and paring principles untouched.** Core 5 + Optional 3 preserved. No SP schema changes.

---

## 2. Template (locked, not modified)

**Core 5 (every technical workstream):**

1. Requirements & Change Ticket — `Task`
2. Implementation Plan — `Deliverable`
3. Configuration / Build — `Task`
4. Testing — `Task`
5. IS Acceptance / Sign-Off — `Milestone`

**Optional 3 (attach when warranted):**

6. Procurement / PO Tracking — `Task` (equipment or licenses)
7. Back-out Plan — `Deliverable` (high-risk cutovers only)
8. Go-Live — `Milestone` or `Construction Gate`

**Variant shapes used on specific workstreams:**

- **Docs-only (3 rows):** Requirements → Deliverable → Sign-Off. Not used anywhere after red-line; CJIS Docs and BCA Submission both moved to 4 rows with explicit LASO Review.
- **OCM/Training (4 rows):** Requirements → Plan → Delivery → Sign-Off.
- **External approval (4 rows):** Requirements → LASO Review → [BCA if needed] → Sign-Off. Used by CJIS Documentation and VuWall BCA Submission.
- **Decommission simple (4 rows):** Requirements → Plan → Execute → Verify. Used by NG911 Mitel line decommission.
- **Decision/artifact (3 rows):** Decision Milestone + Deliverable + optional second Milestone. Used by VuWall Go/No-Go.

---

## 3. Workstream roster (locked)

### TCC Expansion — 9 workstreams

| # | Workstream | Template fit | Est. rows | Notes |
|---|---|---|---|---|
| 1 | PC Procurement | Core 5 + PO + 2 OMF rows | 8 | Initial OMF PC order back-filled; +4 PCs forward for EBC manager-office expansion. Go-Live = `Milestone`. |
| 2 | PC Deployment & Imaging | Core 5 + Go-Live + Back-out + monitor rows (PO, Deploy, Sign-Off) | ~10 | Monitors ride this lane. Go-Live = `Construction Gate` (TCC Final). Back-out mitigation = migrate MPLS monitors to OMF if procurement slips (sub-optimal; complicates fail-back). |
| 3 | Network — Council | Core 5 + PO + Back-out + 30-console capacity Deliverable | 8 | Phase 2 capacity pull-forward lives here. Go-Live = `Construction Gate`. |
| 4 | Network — MTPD | Core 5 + PO + Back-out + 30-console capacity Deliverable | 8 | Parallel change-ticket stream to Council. Go-Live = `Construction Gate`. |
| 5 | Voice / Solacom Crossover | Core 5 | 5 | On-hold during RFP — operating on existing Solacom. Go-Live = `Construction Gate`. |
| 6 | CJIS Documentation | Requirements → LASO Review → [BCA if needed] → Sign-Off | 4 | LASO Review row merged to cover both general CJIS posture and EBC discretionary-determination confirm. BCA row is conditional. Go-Live = `Milestone`. |
| 7 | OCM / Training | Requirements → Plan → Delivery → Sign-Off | 4 | Variant shape. Go-Live = `Milestone`. |
| 8 | Room 1007 Temp Space | Core 5 setup (back-dated) + 3–4 decommission rows (Plan, Equipment Relocation, IES Coordination, Cleanup & Return) | 8–9 | Two-phase workstream. Setup rows back-dated to reflect completed planning (space identification, finalization, encrypted-tunnel network design, LASO ticket). Decommission rows forward, triggered by TCC Final construction complete. IES Solacom equipment coordination required for decommission. Go-Live = `Milestone`. |
| 9 | TCC Operational Readiness | Core 5 | 5 | New workstream capturing Andre Quesnell's scoping path (quantify support needs → recommend solution → shepherd implementation). Replacement interface for Paul Burke across voice / network / security / endpoint teams. Testing row = validate the solution (person / KB / hybrid) works. Go-Live = `Milestone`. |

**TCC subtotal:** ~61 rows.

### NG911 Refresh — 6 workstreams

| # | Workstream | Template fit | Est. rows | Notes |
|---|---|---|---|---|
| 1 | Pre-RFP Discovery | 4 back-dated rows | 4 | Captures re-baseline story: Solacom EOL assessment · Solacom upgrade proposal (response: replace the whole system) · FE cloud-RFP recommendation · Pivot decision record. All back-dated to when work occurred. |
| 2 | RFP & Requirements | Core 5 | 5 | FE-led; IS contributes requirements input. |
| 3 | Vendor Selection & Contract | Core 5 + LASO Review Deliverable | 6 | LASO Review ensures cloud vendor meets CJIS before contract signature. |
| 4 | Cloud Configuration | Core 5 + Back-out | 6 | Cloud-hosted per FE recommendation; back-out for service-impact scenarios. |
| 5 | Cutover | Core 5 + Go-Live (`Milestone`) + Back-out | 7 | Highest-risk NG911 workstream. Go-Live is `Milestone` (not construction-dependent). |
| 6 | Decommission (Mitel lines) | Requirements → Plan → Execute → Verify | 4 | 4-line decommission post-cutover. |

**NG911 subtotal:** ~32 rows.

### VuWall — 5 workstreams

| # | Workstream | Template fit | Est. rows | Notes |
|---|---|---|---|---|
| 1 | POC Design | Core 5 + Phase 2 Infrastructure Location Analysis Deliverable | 6 | Phase 2 deliverable covers MPLS data-room vs. data-center evaluation + chassis / blade needs at 30-console scale. Related but distinct from Network 30-console capacity rows. |
| 2 | POC Build | Core 5 + Back-out | 6 | Back-out = firewall / switch-port rollback if POC gear has to come out. |
| 3 | POC Testing | Core 5 | 5 | Template unchanged. Testing is the POC itself (evaluation criteria, results, IS acceptance). |
| 4 | BCA Submission | Requirements → LASO Review → BCA Deliverable → Sign-Off | 4 | LASO is the BCA intake path (design → LASO → BCA → LASO thumbs-up → deploy). |
| 5 | Go/No-Go Decision & Deployment Plan | Decision Milestone + Deployment Plan Deliverable + Disposition Milestone | 3 | Single decision point + deployment artifact + disposition milestone (leave / remove / migrate POC equipment at end of POC). |

**VuWall subtotal:** ~24 rows.

**Grand total: 20 workstreams, ~117 new rows. SP moves 208 → ~325.**

---

## 4. Back-out coverage (6 workstreams)

1. Network — Council
2. Network — MTPD
3. PC Deployment & Imaging (monitor procurement fallback = MPLS monitor migration)
4. NG911 Cloud Configuration
5. NG911 Cutover
6. VuWall POC Build (firewall / switch-port rollback)

Back-out is **not** attached to: any docs-only or decision workstream, NG911 Pre-RFP Discovery (retrospective), PC Procurement, Voice/Solacom Crossover (on-hold), OCM/Training, CJIS Documentation, Room 1007 Temp Space, TCC Operational Readiness, VuWall POC Design, VuWall POC Testing, VuWall BCA Submission, VuWall Go/No-Go.

---

## 5. Go-Live TaskType mapping

**TCC Expansion:**

- `Construction Gate` (dependent on TCC Final construction complete): **PC Deployment & Imaging · Network — Council · Network — MTPD · Voice/Solacom Crossover**
- `Milestone` (IS-owned date): **PC Procurement · CJIS Documentation · OCM/Training · Room 1007 Temp Space · TCC Operational Readiness**

**NG911 Refresh:**

- `Milestone` (IS-owned / FE-owned, not construction-dependent): **Cutover** is the only workstream with Go-Live; remaining workstreams have Sign-Off milestones, not Go-Live.

**VuWall:**

- `Milestone` (decision-driven): Go/No-Go Decision & Deployment Plan carries the Decision Milestone; no Construction Gate on the VuWall side of v3.2.

---

## 6. LASO / BCA approval pattern

LASO is the single intake for all CJIS-environment infrastructure changes. Flow: design → LASO review → BCA (when required) → LASO thumbs-up → deploy.

| Workstream | LASO role | BCA path |
|---|---|---|
| CJIS Documentation (TCC) | LASO Review row covers (a) general CJIS posture and (b) EBC discretionary determination | Conditional — only if LASO escalates EBC. Represented as `[BCA if needed]` row. |
| VuWall BCA Submission | LASO Review row precedes BCA submission | Required (confirmed path — VuWall is net-new infrastructure) |
| NG911 Vendor Selection & Contract | LASO Review Deliverable before contract signature | Not IS-tracked — FE handles compliance evaluation within RFP. |

---

## 7. Row naming convention

`Workstream · Task` using middle dot (Unicode `·`, not the regular hyphen or em dash).

Example titles:

- `NG911 Cutover · Testing`
- `PC Deployment & Imaging · Monitor Procurement`
- `VuWall POC Design · Phase 2 Infrastructure Location Analysis`
- `Room 1007 Temp Space · Equipment Relocation` (decommission phase)

Rationale: sorts cleanly on SP default views (Title ascending), reads at a glance in the Planner mini-track and the v32.x Hub dashboard, and keeps the Workstream column free as a filter key.

---

## 8. RAID additions (parallel to WBS)

These do **not** become WBS rows — they live in IS Project RAID alongside the task list:

- **Assumption (open):** *BCA may be required for EBC scope — LASO-discretionary until confirmed.* Ties to the CJIS Documentation LASO Review action. Close when LASO rules.
- **Opportunity (open):** *Phase 2 Network Capacity as its own forward workstream — promote once VuWall current-state findings return.* Ties to the Network Council + MTPD 30-console Deliverable rows.
- **Action (open, existing — stays open):** *Quantify TCC support needs per Chad Ladda's 4/17 "TCC Current State & Upcoming Needs" doc; Quesnell leads.* Parallel to the new TCC Operational Readiness workstream. Does not close until a dedicated resource solution is actually in place — naming Andre is a milestone within the action, not its resolution.
- **Action (new, open):** *IES coordination for Room 1007 decommission — confirm IES Solacom equipment removal timeline alignment with IS equipment return to MPLS.* Ties to Room 1007 decommission rows.

---

## 9. Workstream notes carried into Rationale column

Items that should surface on specific rows' Rationale / PM Notes field:

- **Voice/Solacom Crossover:** "On-hold during RFP — operating on existing Solacom; workstream holds a coordination placeholder."
- **Pre-RFP Discovery rows:** "Back-dated — captures re-baseline story behind apparent schedule drift."
- **Room 1007 Setup rows:** "Back-dated — planning work completed Q1-Q2 2026; network design simplified after encrypted-tunnel approach removed firewall dependency."
- **Room 1007 Decommission rows:** "Triggered by TCC Final construction complete; return room to Rail operations."
- **PC Procurement initial OMF row:** "Back-dated — covers the initial OMF PC order. EBC manager-office +4 PCs is the forward row."
- **Network Council / MTPD 30-console capacity Deliverables:** "Pulled forward from Phase 2; cloud NG911 removes the earlier dependency. Cross-references VuWall POC Design Phase 2 Infrastructure Location Analysis."
- **VuWall POC Design Phase 2 Deliverable:** "Cross-references Network 30-console capacity Deliverables — shared inputs, distinct evidence and owners."
- **TCC Operational Readiness:** "Replacement interface for Paul Burke (now off this work); Andre Quesnell owns quantify → recommend → shepherd path."

---

## 10. What is NOT in v3.2

For clarity — items intentionally excluded or deferred:

- No Solacom NG911 Integration TCC workstream (on hold; operating on existing Solacom).
- No Phase 2 Network Capacity workstream (held in RAID; promotable).
- No BCA-EXP standalone workstream (covered by CJIS Documentation LASO Review row + RAID Assumption).
- No POC Scoring & Recommendation standalone workstream (covered by POC Testing + Go/No-Go Decision).
- No changes to the existing 211 v3.1 rows. v3.2 adds only.
- No dashboard work — v32.10 UI refactor resumes after v3.2 lands in SP.
- No row titles drafted — that's the Step 2 deliverable.

---

## 11. Sequencing

1. ✅ **This document — v3.2 plan red-line locked.**
2. **Next — produce `TCC_IS_WBS_v3.2_draft.xlsx`** — one row per new task, Title / Project / TaskType / Workstream / PM Notes columns populated per this document.
3. **Second red-line** — review the xlsx row titles, adjust, drop any that duplicate existing v3.1 rows.
4. **Bulk SP import** — Claude-in-Chrome SP REST against IS Project Tasks list GUID `37ad1da8-59ce-4672-ad5b-1767ed5c57d9`. Back-date `PlannedStart` / `PlannedEnd` / `ActualEnd` / `PercentComplete` on retrospective rows so the dashboard renders them as Complete.
5. **v32.10 UI refactor** — mini-tracks source from TaskType filter; new placeholders render immediately.

---

## 12. Ready for Step 2

Reply **"v3.2 plan approved — produce the row-level draft xlsx"** to kick off xlsx generation.
