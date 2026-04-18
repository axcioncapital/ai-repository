#!/bin/bash
# PreToolUse [HEAVY] warning hook.
#
# Fires on Read/Grep/Bash. Emits a non-blocking [HEAVY] reminder via
# hookSpecificOutput.additionalContext when the tool input matches a
# heuristic for a context-expensive operation.
#
# Exempted commands (workspace CLAUDE.md → Session Guardrails):
#   /token-audit /repo-dd /audit-repo /analyze-workflow /cleanup-worktree
#   /create-skill /improve-skill /migrate-skill /new-project
#   /run-preparation /run-execution /run-cluster /run-analysis /run-synthesis
#
# Always exits 0 — never blocks a tool call.

set -u

# Read hook payload from stdin
payload=$(cat)

# Use python for JSON parsing, regex, and exemption check — bash quoting is
# too fragile for JSONL transcript walking.
python3 - "$payload" << 'PYEOF'
import json, sys, os, re

EXEMPT = {
    "/token-audit", "/repo-dd", "/audit-repo", "/analyze-workflow",
    "/cleanup-worktree", "/create-skill", "/improve-skill", "/migrate-skill",
    "/new-project", "/run-preparation", "/run-execution", "/run-cluster",
    "/run-analysis", "/run-synthesis",
}

BIN_EXTS = {"pdf","png","jpg","jpeg","gif","webp","mp3","mp4","zip","tar","gz","ico","svg"}

try:
    payload = json.loads(sys.argv[1])
except Exception:
    sys.exit(0)

tool_name = payload.get("tool_name", "")
tool_input = payload.get("tool_input", {}) or {}
transcript_path = payload.get("transcript_path", "")

# ---- Exemption check: most-recent real user prompt ----
def last_real_user_prompt(path):
    if not path or not os.path.isfile(path):
        return ""
    last = ""
    try:
        with open(path) as f:
            for line in f:
                try:
                    d = json.loads(line)
                except Exception:
                    continue
                if d.get("type") != "user":
                    continue
                m = d.get("message", {}) or {}
                c = m.get("content")
                if isinstance(c, str):
                    last = c
                elif isinstance(c, list):
                    txts = [b.get("text","") for b in c
                            if isinstance(b, dict) and b.get("type") == "text"]
                    if txts:
                        last = txts[0]
    except Exception:
        return ""
    return last

prompt = last_real_user_prompt(transcript_path)
# Match either inline "<command-name>/foo</command-name>" or prompt starting "/foo"
m = re.search(r"<command-name>(/[a-z0-9_-]+)", prompt)
cmd = m.group(1) if m else (prompt.split()[0] if prompt.startswith("/") else "")
if cmd in EXEMPT:
    sys.exit(0)

# ---- Heuristics ----
warning = None

if tool_name == "Read":
    fp = tool_input.get("file_path", "")
    limit = tool_input.get("limit")
    ext = fp.rsplit(".", 1)[-1].lower() if "." in fp else ""
    if limit in (None, 0) and ext not in BIN_EXTS and os.path.isfile(fp):
        try:
            with open(fp, "rb") as f:
                lines = sum(1 for _ in f)
            if lines > 500:
                warning = f"Read on {os.path.basename(fp)} ({lines} lines, no limit)"
        except Exception:
            pass

elif tool_name == "Grep":
    glob = tool_input.get("glob")
    typ = tool_input.get("type")
    head = tool_input.get("head_limit")
    if not glob and not typ and (head is None or (isinstance(head, int) and head > 250)):
        pat = tool_input.get("pattern", "")
        warning = f"Grep with no glob/type/head_limit (pattern: {pat[:40]!r})"

elif tool_name == "Bash":
    cmd_str = tool_input.get("command", "")
    if re.search(r"\bls\s+-[A-Za-z]*R\b", cmd_str):
        warning = "Bash recursive ls"
    elif re.search(r"\bfind\b", cmd_str) and not re.search(
            r"-(name|path|maxdepth|type|iname)\b", cmd_str):
        warning = "Bash find without scope filter"
    elif re.search(r"\bgit\s+log\b", cmd_str) and not re.search(
            r"(-n\s|--oneline|HEAD~|\.\.|--max-count)", cmd_str):
        warning = "Bash unbounded git log"

if warning:
    out = {
        "hookSpecificOutput": {
            "hookEventName": "PreToolUse",
            "additionalContext": f"[HEAVY] {warning}. Consider narrowing the call."
        }
    }
    print(json.dumps(out))

sys.exit(0)
PYEOF
