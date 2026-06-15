#!/bin/bash
# AIOS behavior-capture hook (PostToolUse). Appends one JSON line per tool use to
# .aios/learnings.jsonl. Read by `aios reflect` to surface improvement areas. Never blocks.
INPUT=$(cat)
mkdir -p .aios
printf '%s' "$INPUT" | python3 -c '
import sys, json, datetime
try:
    d = json.load(sys.stdin)
except Exception:
    sys.exit(0)
ti = d.get("tool_input", {}) or {}
rec = {
    "ts": datetime.datetime.now().isoformat(timespec="seconds"),
    "event": d.get("hook_event_name", ""),
    "tool": d.get("tool_name", ""),
    "path": ti.get("file_path", "") or ti.get("path", ""),
}
print(json.dumps(rec))
' >> .aios/learnings.jsonl 2>/dev/null
exit 0
