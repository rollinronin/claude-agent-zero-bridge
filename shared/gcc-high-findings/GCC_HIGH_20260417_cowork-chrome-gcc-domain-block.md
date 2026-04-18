# GCC High Finding: Cowork Chrome MCP Block on make.gov.powerapps.us

---

## Section 1 — Metadata

| Field | Value |
|---|---|
| **Date** | 2026-04-17 |
| **Session** | TCC#current (Session ~16–17) |
| **Reported By** | Agent Zero (openrouter/anthropic/claude-sonnet-4.6) |
| **Environment** | GCC High — Power Platform |
| **Tenant** | Metropolitan Council (`metcmn`) |
| **Target URL** | `https://make.gov.powerapps.us` |
| **Severity** | MEDIUM — Blocks autonomous browser automation; confirmed workaround available |
| **Status** | CONFIRMED — WORKAROUND IN USE |
| **Project Tag** | TCC IS Portfolio Hub (#222 / #193 / #222.2) |

---

## Section 2 — Finding Description

When the MCP browser automation tool ("Cowork Chrome" / Claude computer-use Chrome session) attempts to navigate to `https://make.gov.powerapps.us`, the request fails with a navigation error before the page loads. The domain does not resolve or is actively blocked at the network or server-side allowlist level within the Cowork Chrome sandbox environment.

This is consistent with the known pattern where GCC High Power Platform domains (`make.gov.powerapps.us`, `make.gov.powerautomate.us`) are restricted from automated browser contexts. The block appears to be enforced by one or more of:

- **Server-side allowlist** — GCC High Microsoft endpoints enforce strict origin/referer checks
- **Palo Alto Prisma Access DPI** — Metropolitan Council VPN performs deep packet inspection that may flag or drop non-human browser sessions
- **Cowork Chrome sandbox** — the MCP browser context may lack required authentication cookies, certificates, or User-Agent signatures accepted by GCC High endpoints

The navigation error occurred immediately on page load attempt, returning before any authentication challenge was presented, indicating a pre-auth network-level block rather than a credential issue.

---

## Section 3 — Impact

| Impact Area | Details |
|---|---|
| **Autonomous deployment** | ❌ Cannot autonomously navigate Power Apps Studio in GCC High via MCP Chrome |
| **Power Automate GCC High** | ❌ Same block expected at `make.gov.powerautomate.us` |
| **SharePoint (Commercial)** | ✅ Unaffected — `metcmn.sharepoint.com` accessible via MCP Chrome |
| **Graph API (via Agent Zero)** | ✅ Unaffected — REST calls from server-side work normally |
| **SharePoint REST (via Chrome)** | ✅ Unaffected — SP REST calls from within MCP Chrome session work |
| **Scope of workaround** | Power Apps canvas app YAML/Power Fx deployment only; all SP automation remains functional |

---

## Section 4 — Evidence

- Navigation error returned when MCP Chrome session attempted to load `https://make.gov.powerapps.us`
- No HTTP status code returned (pre-connection block or DNS-level intercept)
- Block is **consistent across sessions** — same result observed in multiple TCC program sessions
- Commercial Power Platform (`make.powerapps.com`) was NOT tested as a workaround due to GCC High tenant isolation requirements
- PT Tat-Siaka (Senior PM) confirmed the block behavior and approved the switch to guided walkthrough protocol
- The block pattern matches the documented GCC High MCP restriction pattern recorded in Agent Zero solution memory

---

## Section 5 — Workaround / Resolution

### Immediate Workaround (ACTIVE)

**Guided Walkthrough Protocol** — replaces autonomous browser-based Power Apps deployment:

1. **Agent Zero** generates complete YAML screen definitions and Power Fx (`OnStart`, formulas, collections)
2. **Agent Zero** delivers files to PT via local project path (`/a0/usr/projects/tcc-program/artifacts/tcc-vXX/`)
3. **PT** opens Power Apps Studio manually on work PC at `make.gov.powerapps.us`
4. **PT** navigates to **Code view** (`</>` button in Studio)
5. **PT** pastes the YAML screen content screen-by-screen as directed
6. **PT** pastes `App.OnStart` Power Fx into the App object formula bar
7. **PT** saves and publishes

### Why This Works

- PT's work PC has valid GCC High session cookies, MFA tokens, and Prisma Access trust established through normal login
- The block is specific to the **MCP Chrome sandbox context**, not to the Power Apps platform itself
- YAML/Power Fx generation by AI + human execution is fully reliable in this environment

### Long-Term Resolution Options

| Option | Feasibility | Notes |
|---|---|
| Request IT allowlist for MCP Chrome UA string | LOW | Requires IT engagement; GCC High security posture unlikely to permit |
| Power Platform CLI (`pac`) via Agent Zero terminal | MEDIUM | Requires `pac` CLI installed in container + service principal with correct GCC High permissions; worth exploring |
| Power Automate HTTP action → PA REST API | MEDIUM | Can deploy app components indirectly via PA flow if flow auth is established |
| Continue Guided Walkthrough | HIGH ✅ | Current protocol; reliable; minimal overhead once YAML artifacts are pre-generated |

---

## Section 6 — Agent Action Taken

- Switched to **Guided Walkthrough** protocol for all Power Apps GCC High deployment tasks
- All Power Apps canvas app versions (v1–v18) delivered as YAML artifact files to `/a0/usr/projects/tcc-program/artifacts/`
- PT confirmed the workaround and approved documentation push to bridge repo
- This finding committed to `shared/gcc-high-findings/` as permanent reference to prevent re-investigation in future sessions
- **Do not attempt autonomous MCP Chrome navigation to `make.gov.powerapps.us` or `make.gov.powerautomate.us`** — go straight to Guided Walkthrough

---

## Section 7 — Related Findings

| File | Topic |
|---|---|
| `GCC_HIGH_20260416_spfx-app-catalog-dead.md` | IT confirmed SPFx App Catalog closed — dead path |
| *(solutions memory)* | Dataverse permission failure — use SharePoint Lists instead |

---

*Authored by Agent Zero from session context | PT Tat-Siaka approved push | 2026-04-17*
