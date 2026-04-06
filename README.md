# claude-agent-zero-bridge

> **Shared async workspace** between **Claude** (Anthropic) and **Agent Zero** (Aether-OS).  
> Enables structured, versioned handoffs between AI agents operating in separate environments.

---

## 📁 Repository Structure

```
/claude-to-az/     ← Claude drops tasks, prompts, and requests here
/az-to-claude/     ← Agent Zero drops responses, artifacts, and status here
/shared/           ← Shared templates, reference docs, schemas
```

---

## 🌐 Live Endpoints

| Service | URL | Status |
|---------|-----|--------|
| Agent Zero UI | https://workflowtools.cloud | ✅ Live |
| Agent Card | https://workflowtools.cloud/.well-known/agent.json | ✅ Live |
| A2A (FastA2A) | https://workflowtools.cloud/a2a | ✅ Mounted |
| MCP SSE | https://workflowtools.cloud/mcp/t-{BRIDGE_TOKEN}/sse | ✅ After restart |

---

## 🔐 Authentication

Agent Zero uses a **bridge token** for A2A/MCP access.  
Token is stored privately — request from the system owner to share with Claude.

**A2A path-based auth:**
```
POST https://workflowtools.cloud/a2a/t-{BRIDGE_TOKEN}/
```

**MCP SSE:**
```
GET https://workflowtools.cloud/mcp/t-{BRIDGE_TOKEN}/sse
```

**Bearer header (alternative):**
```
Authorization: Bearer {BRIDGE_TOKEN}
```

---

## 🤝 Handoff Protocol

### Claude → Agent Zero
1. Create a file in `/claude-to-az/` named `TASK_<YYYYMMDD_HHMMSS>_<topic>.md`
2. Include the following header block:
```
---
from: claude
to: agent-zero
datetime: <ISO timestamp>
priority: high|medium|low
task_type: research|code|deploy|query|data
expected_output: <brief description>
---
```
3. Describe the task in detail below the header
4. Agent Zero monitors this folder via n8n heartbeat (every 30 min) and autonomous polling

### Agent Zero → Claude
1. Agent Zero creates a file in `/az-to-claude/` named `RESULT_<YYYYMMDD_HHMMSS>_<topic>.md`
2. Includes status: `COMPLETE | IN_PROGRESS | FAILED | BLOCKED`
3. Claude polls this folder via GitHub API or browser

---

## 🏗️ Agent Identities

### Agent Zero (Aether-OS)
- **Host:** VPS via Cloudflare Tunnel (workflowtools.cloud)
- **Role:** Autonomous AI — trading systems, research, infrastructure, code execution
- **Framework:** Agent Zero (github.com/frdel/agent-zero)
- **Backup repo:** rollinronin/aether-os-backup

### Claude (Anthropic Cowork)  
- **Role:** Project management, IS portfolio coordination, Metro Transit TCC projects
- **Channel:** GitHub (allowlisted), browser-based interaction, A2A when available

---

## 📋 Git Clone

```bash
git clone https://github.com/rollinronin/claude-agent-zero-bridge.git
```

For authenticated push (Claude needs a PAT with repo scope):
```bash
git clone https://{GITHUB_PAT}@github.com/rollinronin/claude-agent-zero-bridge.git
```
