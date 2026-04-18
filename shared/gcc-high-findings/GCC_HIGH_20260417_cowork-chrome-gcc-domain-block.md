---
Date: 2026-04-17
Session: Current (TCC IS Portfolio Hub — Cowork)
Environment: Cowork mode (Claude Agent SDK, Chrome MCP)
Tenant: Metropolitan Council (Commercial M365 + GCC High Power Platform)
Severity: High — blocks entire class of agentic workflows
Status: Confirmed, documented, no bypass available
Author: Claude (Cowork) — confirmed by Agent Zero
---

# GCC High Power Platform Domains Blocked in Cowork Chrome MCP

## Finding

Cowork's Chrome browser automation (mcp__Claude_in_Chrome__*) rejects navigation to GCC High / US Government cloud Power Platform domains. The domain allowlist is enforced server-side at the MCP layer and cannot be overridden by any prompt, tool argument, or session configuration.

### Confirmed block

- make.gov.powerapps.us via navigate → "Navigation to this domain is not allowed"
- login.microsoftonline.com via screenshot → "Permission denied for this action on this domain" (expected — auth pages sandboxed)

### Likely also blocked (same tenant class, not tested this session)

- admin.powerplatform.us (Power Platform Admin Center, gov)
- make.gov.powerautomate.us
- login.microsoftonline.us
- *.sharepoint.us (no current impact — TCC hub on .com)

## Impact

PM's work Power Apps environment is GCC High (env 83181ce4-b33c-ee76-9337-862af377e448). Any Cowork-driven browser automation of Power Apps Studio, Flow authoring, Power Platform admin, or any .us gov Power Platform UI fails at navigate. Commercial-domain work (metcmn.sharepoint.com REST, web research, GitHub) is unaffected.

## Workaround

No true bypass. Guidance:

1. Guided walkthrough is the default for gov Power Platform work — Claude produces exact clicks / Power Fx / YAML; PM executes; results pasted back.
2. Prefer non-browser tooling where an API exists (SP REST, Graph, PowerShell, Power Automate API).
3. YAML paste pattern is canonical — paste into Power Apps Studio Code View.
4. Commercial fallback not viable for TCC — Power Apps env is gov-only.
5. Allowlist escalation requires Anthropic product feedback. Not self-serve.

## Evidence

Raw MCP tool responses captured 2026-04-17:

mcp__Claude_in_Chrome__navigate to https://make.gov.powerapps.us/environments/83181ce4-b33c-ee76-9337-862af377e448/apps → Navigation to this domain is not allowed

mcp__Claude_in_Chrome__computer (screenshot) on login.microsoftonline.com → Permission denied for this action on this domain

Attempt initiated from CLAUDE_BROWSER_PROMPT_v3_MVPTest.md (Power Apps MVP platform test). Halted Phase 1 Step 1 after session redirect. Remaining phases (data source, labels, publish, embed) never ran.

## Agent Zero Action Taken

- Confirmed finding via MCP send_message.
- Reported Section 5 of agent-rules.promptinclude.md (lines 133-194) already live from prior session.
- Provided repo location, filename convention, commit message style.
- Recommended guided walkthrough + YAML paste as permanent default for gov Power Platform work.

## Claude (Cowork) Action Taken

- Persistent memory: .auto-memory/reference_cowork_chrome_domain_block.md + MEMORY.md index.
- Persistent memory: .auto-memory/reference_github_bridge_repo.md recording bridge repo + conventions.
- Workspace reference: TCC IS Portfolio Hub/Cowork_Chrome_GCCHigh_Domain_Block_20260417.md.
- Staged file for commit at shared/gcc-high-findings/ per Section 5. PAT held by PT / AZ — Cowork does not hold it.

## Cross-reference

- Originating prompt: CLAUDE_BROWSER_PROMPT_v3_MVPTest.md
- Workspace copy: Cowork_Chrome_GCCHigh_Domain_Block_20260417.md
- Related memory: project_agent_zero_collab.md, project_powerapps_pmo.md
