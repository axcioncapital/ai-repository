#!/bin/bash
# Stop hook: emits a session-end reminder combining two checks.
#   1. Innovation-registry: are there detected entries pending triage?
#   2. Usage telemetry: does logs/usage-log.md have an entry for today?
# Output is a single {"systemMessage":"..."} JSON object.
#
# Replaces the inline command previously in .claude/settings.json Stop hook.
# Both checks must remain non-blocking (always exit 0).

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
REGISTRY="$PROJECT_DIR/logs/innovation-registry.md"
USAGE_LOG="$PROJECT_DIR/logs/usage-log.md"
TODAY=$(date +%Y-%m-%d)

detected=0
[ -f "$REGISTRY" ] && detected=$(grep -c '| detected |' "$REGISTRY" 2>/dev/null || echo 0)

usage_today=0
[ -f "$USAGE_LOG" ] && usage_today=$(grep -c "^### ${TODAY}\b" "$USAGE_LOG" 2>/dev/null || echo 0)

parts=()
[ "$detected" -gt 0 ] && parts+=("$detected innovation(s) pending triage.")
[ "$usage_today" -eq 0 ] && parts+=("usage-log.md has no entry for $TODAY — run /usage-analysis.")
parts+=("Run /wrap-session before ending to log this session.")

# Join with single space
msg=""
for p in "${parts[@]}"; do
    if [ -z "$msg" ]; then msg="$p"; else msg="$msg $p"; fi
done

# Emit JSON via python to avoid quoting hazards
python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$msg"

exit 0
