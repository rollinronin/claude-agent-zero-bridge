# Claude ↔ Agent Zero Messaging Queue Protocol

**Version:** 1.0
**Established:** 2026-04-21
**Purpose:** Provide a structured, state-aware, append-only messaging queue layered on top of the existing GitHub bridge, so both agents can quickly answer "who knows what right now?"

---

## 1. Design Principles

1. **Append-only** — no edits, no deletes. Every event is a new line. Prevents merge conflicts when both agents write concurrently.
2. **Bidirectional by default** — both agents read and write the same log. Neither owns it.
3. **Optional but recommended** — existing `/claude-to-az/` and `/az-to-claude/` file protocols still work. The queue is a metadata layer, not a replacement.
4. **Human-scannable** — PT can `cat MESSAGE_LOG.jsonl | jq` anytime to see the full state.
5. **Thread-aware** — every message has a `thread_id` so related exchanges cluster naturally.

---

## 2. File Layout

```
bridge-repo/
├── queue/
│   ├── QUEUE_PROTOCOL.md          ← this document (the contract)
│   ├── MESSAGE_LOG.jsonl          ← append-only master log (both agents write)
│   └── bridge_queue.py            ← helper script (enqueue, ack, list_unread, etc.)
├── claude-to-az/                  ← actual message payloads (Claude → AZ)
├── az-to-claude/                  ← actual message payloads (AZ → Claude)
└── shared/                        ← shared artifacts (unchanged)
```

**Key point:** `MESSAGE_LOG.jsonl` holds **metadata only**. Actual message bodies stay in `claude-to-az/` or `az-to-claude/` as markdown files (per original bridge convention). Each log entry has a `file_ref` pointing to its payload file.

---

## 3. Event Types

| Event Type | Purpose | Written By |
|---|---|---|
| `message` | New outbound message; must have a `file_ref` | Sender |
| `ack` | "I saw it, absorbing it now" | Recipient |
| `read` | "I read and fully processed it" — stronger than ack | Recipient |
| `reply` | Explicit reply, with `ref_id` pointing to the original | Sender |
| `heartbeat` | "I'm alive and actively polling" (optional, for presence) | Either |
| `status` | Lifecycle update (e.g., `task_complete`, `task_blocked`) | Worker |

---

## 4. Message Entry Schema

Every line in `MESSAGE_LOG.jsonl` is a JSON object with these fields:

### Required
| Field | Type | Notes |
|---|---|---|
| `id` | string | Unique, e.g., `msg-20260421-051730-az-001` |
| `ts` | string | ISO 8601 with timezone (e.g., `2026-04-21T05:17:30-05:00`) |
| `event` | string | One of: `message`, `ack`, `read`, `reply`, `heartbeat`, `status` |
| `from` | string | Agent identifier: `agent-zero` or `claude-cowork` |
| `to` | string | Agent identifier (same options), or `*` for broadcast |

### Conditionally Required
| Field | When Required | Type | Notes |
|---|---|---|---|
| `subject` | For `message`, `reply` | string | Short, scannable |
| `file_ref` | For `message`, `reply` | string | Path from bridge root, e.g., `az-to-claude/RESULT_20260421_051730_v25_pac_cli_handoff.md` |
| `ref_id` | For `ack`, `read`, `reply` | string | ID of the message being referenced |
| `thread_id` | Recommended for all | string | Groups related messages, e.g., `v25-msapp-fix` |

### Optional
| Field | Type | Notes |
|---|---|---|
| `priority` | string | `high`, `medium`, `low` (default: `medium`) |
| `needs_ack` | boolean | If true, sender expects an `ack` event (default: `true` for `message`, `false` otherwise) |
| `note` | string | Free-text comment (keep short) |
| `tags` | array[string] | For search/filter (e.g., `["tcc-program", "power-apps", "msapp"]`) |

---

## 5. Example Entries

### 5.1 New message (AZ → Claude)
```json
{"id":"msg-20260421-051730-az-001","ts":"2026-04-21T05:17:30-05:00","event":"message","from":"agent-zero","to":"claude-cowork","subject":"v25 pac CLI handoff — gallery Parent bug","file_ref":"az-to-claude/RESULT_20260421_051730_v25_pac_cli_handoff.md","thread_id":"v25-msapp-fix","priority":"high","needs_ack":true,"tags":["tcc-program","power-apps","msapp","pac-cli"]}
```

### 5.2 Ack from Claude
```json
{"id":"ack-20260421-063500-cl-001","ts":"2026-04-21T06:35:00-05:00","event":"ack","from":"claude-cowork","to":"agent-zero","ref_id":"msg-20260421-051730-az-001","thread_id":"v25-msapp-fix","note":"received, starting pac canvas unpack"}
```

### 5.3 Reply with payload
```json
{"id":"msg-20260421-081200-cl-001","ts":"2026-04-21T08:12:00-05:00","event":"reply","from":"claude-cowork","to":"agent-zero","subject":"pac pack result v1 — validation errors","file_ref":"claude-to-az/RESULT_20260421_081200_pac_pack_v1.md","ref_id":"msg-20260421-051730-az-001","thread_id":"v25-msapp-fix","priority":"high","needs_ack":true}
```

### 5.4 Heartbeat (presence signal)
```json
{"id":"hb-20260421-090000-az-001","ts":"2026-04-21T09:00:00-05:00","event":"heartbeat","from":"agent-zero","to":"*","note":"active, last git pull 30s ago"}
```

### 5.5 Status update
```json
{"id":"status-20260421-094500-cl-001","ts":"2026-04-21T09:45:00-05:00","event":"status","from":"claude-cowork","to":"agent-zero","ref_id":"msg-20260421-051730-az-001","thread_id":"v25-msapp-fix","note":"task_complete: msapp imports cleanly into gov Studio"}
```

---

## 6. ID Format Convention

```
<type>-<YYYYMMDD>-<HHMMSS>-<agent-prefix>-<seq>
```

- `type`: `msg`, `ack`, `read`, `reply`, `hb`, `status`
- Agent prefix: `az` (agent-zero) or `cl` (claude-cowork)
- `seq`: 3-digit counter per agent per day (resets at midnight UTC)

Examples: `msg-20260421-051730-az-001`, `ack-20260421-063500-cl-002`

---

## 7. Recommended Polling Behavior

| Agent | Pull Frequency | Push Frequency |
|---|---|---|
| Agent Zero | On every user task + ad-hoc (when PT requests) | Immediately after producing a message |
| Claude Cowork | On Claude's next session start + when PT prompts | Immediately after producing a message |
| Optional heartbeat | Every 30 min while active session is open | — |

Agents should **always pull before writing** to prevent stale state.

---

## 8. Reading the Log

### With `jq` (human-friendly)
```bash
# Show all unread messages targeted at agent-zero
cat queue/MESSAGE_LOG.jsonl | jq -c 'select(.to == "agent-zero" and .event == "message")'

# Show the most recent event per thread
cat queue/MESSAGE_LOG.jsonl | jq -c 'group_by(.thread_id) | map(max_by(.ts))'

# Show only things needing ack from me
cat queue/MESSAGE_LOG.jsonl | jq -c 'select(.to == "agent-zero" and .needs_ack == true)'
```

### With `bridge_queue.py` (agent-friendly)
```python
from bridge_queue import list_unread, enqueue, ack

# Pull everything still pending an ack from me
unread = list_unread(agent="agent-zero")

# Acknowledge one
ack(agent="agent-zero", ref_id="msg-20260421-051730-az-001", note="got it")

# Send a new message
enqueue(
    event="message",
    from_agent="agent-zero",
    to_agent="claude-cowork",
    subject="follow-up on pac pack",
    file_ref="az-to-claude/RESULT_20260421_100000_pac_followup.md",
    thread_id="v25-msapp-fix",
)
```

---

## 9. Migration & Backward Compatibility

- **Existing `/claude-to-az/` and `/az-to-claude/` files are unchanged.** The queue indexes them retrospectively.
- When this protocol was established (commit after `1eb86ef`), all pre-existing bridge files were back-filled into `MESSAGE_LOG.jsonl` as `message` events with `ts` set to the git commit timestamp.
- No existing workflow breaks. Agents that ignore the queue continue to work as before.

---

## 10. Agent Identifiers (canonical)

| Agent ID | Entity | Location |
|---|---|---|
| `agent-zero` | Agent Zero (Aether-OS) | workflowtools.cloud / VPS container |
| `claude-cowork` | Claude in Anthropic Cowork sandbox | Anthropic-managed |

Use these exact strings in `from` and `to` fields.

---

## 11. Conflict Resolution

- If both agents push the same second, git merge handles it (append-only = no semantic conflict).
- If two events claim the same `id`, the earlier `ts` wins (the later one is a bug to fix).
- If `ref_id` points to an unknown message, flag in `note` and keep going — don't block.

---

## 12. Future Extensions (not yet implemented)

- Webhook notification when new messages arrive (via n8n)
- Auto-ack on git pull (agents set `event: read` when they've actually processed a message body)
- SLA fields (`deadline`, `response_by`) for time-sensitive requests
- Redis-backed real-time presence layer

---

## 13. Contact / Changes

Any agent proposing a schema change must:
1. Write a `message` event with `subject: "QUEUE_PROTOCOL change proposal: <title>"`
2. Drop proposed diff as the `file_ref` markdown
3. Wait for `ack` from the other agent before merging

— Agent Zero (v1.0, 2026-04-21)
