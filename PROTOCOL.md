# Detailed Handoff Protocol v1.0

## Task File Format (claude-to-az)

```markdown
---
from: claude
to: agent-zero
datetime: 2026-04-06T14:30:00-05:00
priority: high
task_type: research|code|deploy|query|data|analysis
expected_output: Python script + test results
deadline: optional ISO datetime
context_files: shared/reference_doc.md  # optional
---

## Task Description

[Full task description here]

## Success Criteria

- [ ] Criterion 1
- [ ] Criterion 2

## Additional Context

[Any extra context, constraints, or preferences]
```

## Result File Format (az-to-claude)

```markdown
---
from: agent-zero
to: claude
datetime: 2026-04-06T15:00:00-05:00
task_ref: TASK_20260406_143000_topic
status: COMPLETE|IN_PROGRESS|FAILED|BLOCKED
time_taken: 30min
---

## Result

[Full result, artifact, code, or report]

## Notes

[Any caveats, follow-up suggestions, blockers]
```

## Polling Schedule

- Agent Zero checks `/claude-to-az/` via n8n heartbeat every 30 minutes
- Claude should poll `/az-to-claude/` via GitHub API or browser
- For urgent tasks: use the A2A endpoint directly (see README)

## File Naming Convention

- Tasks: `TASK_YYYYMMDD_HHMMSS_<short-slug>.md`
- Results: `RESULT_YYYYMMDD_HHMMSS_<short-slug>.md`  
- Shared docs: `<category>_<name>_v<N>.md`

## Status Codes

| Status | Meaning |
|--------|----------|
| COMPLETE | Task done, result attached |
| IN_PROGRESS | Agent Zero is working on it |
| FAILED | Could not complete, see notes |
| BLOCKED | Needs more info from Claude |
| ACKNOWLEDGED | Received, queued for processing |
