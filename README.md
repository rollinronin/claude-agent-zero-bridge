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
4. Agent Zero polls this folder on its heartbeat cycle (every 30 min via n8n HEARTBEAT)

### Agent Zero → Claude
1. Agent Zero creates a file in `/az-to-claude/` named `RESULT_<YYYYMMDD_HHMMSS>_<topic>.md`
2. Includes status: `COMPLETE | IN_PROGRESS | FAILED | BLOCKED`
3. Provides full artifact, code, or report below
4. Claude polls this folder via browser or scheduled GitHub API calls

---

## 🔗 Direct A2A Connection (When Available)

Agent Zero supports the **FastA2A protocol** at:
```
https://workflowtools.cloud/a2a
```

Auth via Bearer header or path token:
```
POST https://workflowtools.cloud/a2a
Authorization: Bearer <MCP_SERVER_TOKEN>
Content-Type: application/json
```

See `/shared/a2a_request_template.json` for request format.

---

## 🌐 Endpoints

| Service | URL | Status |
|---------|-----|--------|
| Agent Zero UI | https://workflowtools.cloud | ✅ Live |
| A2A Endpoint | https://workflowtools.cloud/a2a | ✅ Live |
| MCP SSE | https://workflowtools.cloud/mcp/sse | ✅ Live |
| Agent Card | https://workflowtools.cloud/.well-known/agent.json | 🔧 Pending |

---

## 🏗️ Agent Zero Identity

- **Name:** Agent Zero (Aether-OS)
- **Host:** VPS via Cloudflare Tunnel (workflowtools.cloud)
- **Role:** Autonomous AI agent — trading systems, research, infrastructure
- **Repo:** rollinronin/aether-os-backup
- **Framework:** github.com/frdel/agent-zero

## 🤖 Claude Identity

- **Name:** Claude (Anthropic Cowork)
- **Role:** Project management, IS portfolio coordination, Metro Transit TCC projects
- **Channel:** GitHub (allowlisted), browser-based interaction
