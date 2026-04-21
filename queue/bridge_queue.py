#!/usr/bin/env python3
"""
bridge_queue.py — Helper library for Claude ↔ Agent Zero messaging queue.

Usage (imported):
    from bridge_queue import enqueue, ack, read, list_unread, list_thread, heartbeat

Usage (CLI):
    python bridge_queue.py list-unread --agent agent-zero
    python bridge_queue.py ack --agent agent-zero --ref-id msg-20260421-051730-az-001
    python bridge_queue.py show-thread --thread-id v25-msapp-fix
    python bridge_queue.py heartbeat --agent agent-zero

Design:
- Append-only JSONL at queue/MESSAGE_LOG.jsonl
- Always pulls git before reading/writing to stay current
- Auto-generates IDs in the canonical format
- Works for both agent-zero and claude-cowork identities
"""
from __future__ import annotations

import argparse
import json
import os
import sys
import subprocess
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Optional

# ---------- Config ----------
QUEUE_DIR = Path(__file__).resolve().parent
LOG_FILE = QUEUE_DIR / "MESSAGE_LOG.jsonl"
AGENT_PREFIX = {"agent-zero": "az", "claude-cowork": "cl"}
VALID_AGENTS = set(AGENT_PREFIX.keys())
VALID_EVENTS = {"message", "ack", "read", "reply", "heartbeat", "status"}
EVENT_TYPE_PREFIX = {
    "message": "msg",
    "ack": "ack",
    "read": "read",
    "reply": "msg",  # replies are still messages structurally
    "heartbeat": "hb",
    "status": "status",
}

# ---------- Time helpers ----------
def now_iso(tz_offset_hours: int = -5) -> str:
    """Return ISO 8601 timestamp in the given timezone (default CDT/CST offset -5).

    We standardize on CDT/CST (Metro Council PT's local time) for consistency.
    """
    tz = timezone(timedelta(hours=tz_offset_hours))
    return datetime.now(tz).isoformat(timespec="seconds")


def today_yyyymmdd() -> str:
    return datetime.now(timezone.utc).strftime("%Y%m%d")


# ---------- ID generation ----------
def _existing_seq_today(agent_prefix: str, event_prefix: str) -> int:
    """Count how many IDs today already exist for this agent/event type."""
    if not LOG_FILE.exists():
        return 0
    today = today_yyyymmdd()
    pattern = f"{event_prefix}-{today}-"
    count = 0
    for line in LOG_FILE.read_text().splitlines():
        if not line.strip():
            continue
        try:
            obj = json.loads(line)
            if obj.get("id", "").startswith(pattern) and obj.get("id", "").endswith(f"-{agent_prefix}-" + obj["id"].split("-")[-1]):
                # More reliable: parse structure
                parts = obj["id"].split("-")
                if len(parts) >= 5 and parts[-2] == agent_prefix:
                    count += 1
        except (json.JSONDecodeError, KeyError):
            continue
    return count


def generate_id(event: str, agent: str) -> str:
    """Generate a canonical queue ID: <type>-<YYYYMMDD>-<HHMMSS>-<prefix>-<seq>."""
    if agent not in AGENT_PREFIX:
        raise ValueError(f"Unknown agent '{agent}'. Must be one of {VALID_AGENTS}")
    if event not in VALID_EVENTS:
        raise ValueError(f"Unknown event '{event}'. Must be one of {VALID_EVENTS}")

    prefix = EVENT_TYPE_PREFIX[event]
    agent_prefix = AGENT_PREFIX[agent]
    now = datetime.now(timezone.utc)
    ts_str = now.strftime("%Y%m%d-%H%M%S")
    seq = _existing_seq_today(agent_prefix, prefix) + 1
    return f"{prefix}-{ts_str}-{agent_prefix}-{seq:03d}"


# ---------- Git helpers ----------
def _git(*args: str, cwd: Optional[Path] = None, check: bool = True) -> str:
    cwd = cwd or QUEUE_DIR.parent
    result = subprocess.run(
        ["git", *args],
        cwd=str(cwd),
        capture_output=True,
        text=True,
    )
    if check and result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed:\n{result.stderr}")
    return result.stdout.strip()


def git_pull() -> bool:
    """Pull latest from origin/main. Returns True on success."""
    try:
        _git("pull", "--quiet", check=False)
        return True
    except Exception as e:
        print(f"[warn] git pull failed: {e}", file=sys.stderr)
        return False


def git_commit_and_push(message: str, pat_path: Optional[str] = None) -> bool:
    """Stage MESSAGE_LOG.jsonl, commit, and push. Returns True on success."""
    try:
        _git("add", str(LOG_FILE.relative_to(QUEUE_DIR.parent)))
        _git("-c", "user.email=bridge-queue@workflowtools.cloud",
             "-c", "user.name=Bridge Queue",
             "commit", "-m", message, check=False)
        # Push with PAT if provided
        if pat_path and Path(pat_path).exists():
            pat = Path(pat_path).read_text().strip()
            push_url = f"https://{pat}@github.com/rollinronin/claude-agent-zero-bridge.git"
            _git("push", push_url, "main", check=False)
        else:
            _git("push", check=False)
        return True
    except Exception as e:
        print(f"[warn] git commit/push failed: {e}", file=sys.stderr)
        return False


# ---------- Core log operations ----------
def _append_entry(entry: dict, auto_push: bool = False, pat_path: Optional[str] = None) -> dict:
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    with LOG_FILE.open("a") as f:
        f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    if auto_push:
        git_commit_and_push(f"queue: {entry.get('event')} {entry.get('id')}", pat_path=pat_path)
    return entry


def read_log() -> list[dict]:
    if not LOG_FILE.exists():
        return []
    entries = []
    for line in LOG_FILE.read_text().splitlines():
        if not line.strip():
            continue
        try:
            entries.append(json.loads(line))
        except json.JSONDecodeError as e:
            print(f"[warn] malformed line skipped: {e}", file=sys.stderr)
    return entries


# ---------- Public API ----------
def enqueue(
    event: str,
    from_agent: str,
    to_agent: str,
    subject: Optional[str] = None,
    file_ref: Optional[str] = None,
    ref_id: Optional[str] = None,
    thread_id: Optional[str] = None,
    priority: str = "medium",
    needs_ack: Optional[bool] = None,
    note: Optional[str] = None,
    tags: Optional[list[str]] = None,
    auto_push: bool = False,
    pat_path: Optional[str] = None,
) -> dict:
    """Append a new event to the queue log."""
    if event not in VALID_EVENTS:
        raise ValueError(f"Invalid event '{event}'. Must be one of {VALID_EVENTS}")
    if from_agent not in VALID_AGENTS:
        raise ValueError(f"Invalid from_agent '{from_agent}'")
    if to_agent not in VALID_AGENTS and to_agent != "*":
        raise ValueError(f"Invalid to_agent '{to_agent}'")
    if event in ("message", "reply") and not file_ref:
        raise ValueError(f"event '{event}' requires file_ref")
    if event in ("ack", "read", "reply") and not ref_id:
        raise ValueError(f"event '{event}' requires ref_id")

    # Default needs_ack: True for messages, False otherwise
    if needs_ack is None:
        needs_ack = event in ("message", "reply")

    entry: dict = {
        "id": generate_id(event, from_agent),
        "ts": now_iso(),
        "event": event,
        "from": from_agent,
        "to": to_agent,
    }
    if subject: entry["subject"] = subject
    if file_ref: entry["file_ref"] = file_ref
    if ref_id: entry["ref_id"] = ref_id
    if thread_id: entry["thread_id"] = thread_id
    if priority and priority != "medium": entry["priority"] = priority
    if event in ("message", "reply"): entry["needs_ack"] = needs_ack
    if note: entry["note"] = note
    if tags: entry["tags"] = tags

    return _append_entry(entry, auto_push=auto_push, pat_path=pat_path)


def ack(agent: str, ref_id: str, note: Optional[str] = None, auto_push: bool = False, pat_path: Optional[str] = None) -> dict:
    """Acknowledge a specific message by ID."""
    entries = read_log()
    source = next((e for e in entries if e.get("id") == ref_id), None)
    thread_id = source.get("thread_id") if source else None
    other = next(iter(VALID_AGENTS - {agent}))
    return enqueue(
        event="ack",
        from_agent=agent,
        to_agent=other,
        ref_id=ref_id,
        thread_id=thread_id,
        note=note,
        auto_push=auto_push,
        pat_path=pat_path,
    )


def read(agent: str, ref_id: str, note: Optional[str] = None, auto_push: bool = False, pat_path: Optional[str] = None) -> dict:
    """Mark a message as fully read/processed (stronger than ack)."""
    entries = read_log()
    source = next((e for e in entries if e.get("id") == ref_id), None)
    thread_id = source.get("thread_id") if source else None
    other = next(iter(VALID_AGENTS - {agent}))
    return enqueue(
        event="read",
        from_agent=agent,
        to_agent=other,
        ref_id=ref_id,
        thread_id=thread_id,
        note=note,
        auto_push=auto_push,
        pat_path=pat_path,
    )


def heartbeat(agent: str, note: Optional[str] = None, auto_push: bool = False, pat_path: Optional[str] = None) -> dict:
    """Emit a heartbeat/presence signal."""
    return enqueue(
        event="heartbeat",
        from_agent=agent,
        to_agent="*",
        note=note or "active",
        auto_push=auto_push,
        pat_path=pat_path,
    )


def list_unread(agent: str, include_acked: bool = False) -> list[dict]:
    """Return messages addressed to `agent` that still need ack (or all if include_acked)."""
    entries = read_log()
    messages = [e for e in entries if e.get("event") in ("message", "reply") and e.get("to") == agent]
    if include_acked:
        return messages
    # Find ack IDs already emitted by this agent
    acked_ids = {
        e.get("ref_id") for e in entries
        if e.get("event") in ("ack", "read") and e.get("from") == agent
    }
    return [m for m in messages if m.get("needs_ack", True) and m["id"] not in acked_ids]


def list_thread(thread_id: str) -> list[dict]:
    """Return all events in a given thread, chronologically."""
    entries = read_log()
    thread = [e for e in entries if e.get("thread_id") == thread_id]
    return sorted(thread, key=lambda e: e.get("ts", ""))


def last_heartbeat(agent: str) -> Optional[dict]:
    """Return the most recent heartbeat from `agent`, or None."""
    entries = read_log()
    heartbeats = [e for e in entries if e.get("event") == "heartbeat" and e.get("from") == agent]
    if not heartbeats:
        return None
    return max(heartbeats, key=lambda e: e.get("ts", ""))


# ---------- CLI ----------
def _cmd_list_unread(args):
    if args.pull: git_pull()
    unread = list_unread(args.agent, include_acked=args.include_acked)
    print(f"=== {len(unread)} unread for {args.agent} ===")
    for e in unread:
        print(json.dumps(e, indent=2))


def _cmd_ack(args):
    if args.pull: git_pull()
    entry = ack(args.agent, args.ref_id, note=args.note, auto_push=args.push, pat_path=args.pat)
    print(json.dumps(entry, indent=2))


def _cmd_read(args):
    if args.pull: git_pull()
    entry = read(args.agent, args.ref_id, note=args.note, auto_push=args.push, pat_path=args.pat)
    print(json.dumps(entry, indent=2))


def _cmd_heartbeat(args):
    if args.pull: git_pull()
    entry = heartbeat(args.agent, note=args.note, auto_push=args.push, pat_path=args.pat)
    print(json.dumps(entry, indent=2))


def _cmd_thread(args):
    if args.pull: git_pull()
    thread = list_thread(args.thread_id)
    print(f"=== Thread '{args.thread_id}' — {len(thread)} events ===")
    for e in thread:
        print(json.dumps(e, indent=2))


def _cmd_enqueue(args):
    if args.pull: git_pull()
    entry = enqueue(
        event=args.event,
        from_agent=args.from_agent,
        to_agent=args.to_agent,
        subject=args.subject,
        file_ref=args.file_ref,
        ref_id=args.ref_id,
        thread_id=args.thread_id,
        priority=args.priority,
        note=args.note,
        tags=args.tags.split(",") if args.tags else None,
        auto_push=args.push,
        pat_path=args.pat,
    )
    print(json.dumps(entry, indent=2))


def main():
    parser = argparse.ArgumentParser(description="Claude ↔ Agent Zero queue helper")
    sub = parser.add_subparsers(dest="cmd", required=True)

    p_list = sub.add_parser("list-unread", help="List messages awaiting ack for an agent")
    p_list.add_argument("--agent", required=True, choices=list(VALID_AGENTS))
    p_list.add_argument("--include-acked", action="store_true")
    p_list.add_argument("--pull", action="store_true", help="git pull before reading")
    p_list.set_defaults(func=_cmd_list_unread)

    p_ack = sub.add_parser("ack", help="Acknowledge a message")
    p_ack.add_argument("--agent", required=True, choices=list(VALID_AGENTS))
    p_ack.add_argument("--ref-id", required=True)
    p_ack.add_argument("--note")
    p_ack.add_argument("--push", action="store_true")
    p_ack.add_argument("--pat", help="Path to PAT file for push")
    p_ack.add_argument("--pull", action="store_true")
    p_ack.set_defaults(func=_cmd_ack)

    p_read = sub.add_parser("read", help="Mark message as read/processed")
    p_read.add_argument("--agent", required=True, choices=list(VALID_AGENTS))
    p_read.add_argument("--ref-id", required=True)
    p_read.add_argument("--note")
    p_read.add_argument("--push", action="store_true")
    p_read.add_argument("--pat")
    p_read.add_argument("--pull", action="store_true")
    p_read.set_defaults(func=_cmd_read)

    p_hb = sub.add_parser("heartbeat", help="Emit presence signal")
    p_hb.add_argument("--agent", required=True, choices=list(VALID_AGENTS))
    p_hb.add_argument("--note")
    p_hb.add_argument("--push", action="store_true")
    p_hb.add_argument("--pat")
    p_hb.add_argument("--pull", action="store_true")
    p_hb.set_defaults(func=_cmd_heartbeat)

    p_thread = sub.add_parser("show-thread", help="Show all events in a thread")
    p_thread.add_argument("--thread-id", required=True)
    p_thread.add_argument("--pull", action="store_true")
    p_thread.set_defaults(func=_cmd_thread)

    p_enq = sub.add_parser("enqueue", help="Send a new message")
    p_enq.add_argument("--event", required=True, choices=list(VALID_EVENTS))
    p_enq.add_argument("--from-agent", required=True, choices=list(VALID_AGENTS))
    p_enq.add_argument("--to-agent", required=True)
    p_enq.add_argument("--subject")
    p_enq.add_argument("--file-ref")
    p_enq.add_argument("--ref-id")
    p_enq.add_argument("--thread-id")
    p_enq.add_argument("--priority", default="medium")
    p_enq.add_argument("--note")
    p_enq.add_argument("--tags", help="Comma-separated")
    p_enq.add_argument("--push", action="store_true")
    p_enq.add_argument("--pat")
    p_enq.add_argument("--pull", action="store_true")
    p_enq.set_defaults(func=_cmd_enqueue)

    args = parser.parse_args()
    args.func(args)


if __name__ == "__main__":
    main()
