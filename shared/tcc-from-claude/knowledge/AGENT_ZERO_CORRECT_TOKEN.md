# Agent Zero — Correct A2A/MCP Connection Details
_Updated: 2026-04-07 (Session 7 — MCP token fix confirmed)_

## VERIFIED LIVE TOKEN

```
6cv6Y1NWS8_axKmv
```

Stable and deterministic — computed as sha256(RUNTIME_ID:username:password)[:16] base64url.
Will NOT change unless /a0/usr/.env credentials change.

## Correct Endpoints

| Endpoint | URL | Status |
|----------|-----|--------|
| A2A POST | https://workflowtools.cloud/a2a/t-6cv6Y1NWS8_axKmv/ | Auth WORKING (500 = bad payload, not auth fail) |
| MCP SSE | https://workflowtools.cloud/mcp/t-6cv6Y1NWS8_axKmv/sse | Auth WORKING |
| Agent Card | https://workflowtools.cloud/.well-known/agent.json | 404 - needs regeneration |
| Web UI | https://workflowtools.cloud/ | Live |

## DEPRECATED TOKEN (DO NOT USE)
```
aether-bridge-30077e9c311f511da408984bd9a0c8bb
```
Was manually set in settings.json — overwritten at every startup by normalize_settings().

## Root Cause Confirmed
Agent Zero settings.py line 364: normalize_settings() always calls create_auth_token() which computes
the token from dotenv values (A0_PERSISTENT_RUNTIME_ID + AUTH_LOGIN + AUTH_PASSWORD).
Manually set tokens in settings.json are ALWAYS overwritten.

## A2A Message Format
POST https://workflowtools.cloud/a2a/t-6cv6Y1NWS8_axKmv/
Content-Type: application/json
{
  "jsonrpc": "2.0",
  "id": "task-001",
  "method": "tasks/send",
  "params": {
    "id": "task-001",
    "message": {"role": "user", "parts": [{"type": "text", "text": "Your message"}]}
  }
}
