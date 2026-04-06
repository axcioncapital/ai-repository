#!/usr/bin/env bash
# PostToolUse (Write/Edit) hook: detect when commands, agents, or hooks are created/modified.
# Appends entry to logs/innovation-registry.md with status "detected".
# Deduplicates by file path — only logs each file once.
# Non-blocking — always exits 0.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
REGISTRY="$PROJECT_DIR/logs/innovation-registry.md"

# Read the file path from tool input
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

# Check if the file is inside .claude/commands/, .claude/agents/, or .claude/hooks/
TYPE=""
if echo "$FILE_PATH" | grep -qE '\.claude/commands/[^/]+$'; then
  TYPE="command"
elif echo "$FILE_PATH" | grep -qE '\.claude/agents/[^/]+$'; then
  TYPE="agent"
elif echo "$FILE_PATH" | grep -qE '\.claude/hooks/[^/]+$'; then
  TYPE="hook"
fi

[ -z "$TYPE" ] && exit 0

# Skip self-detection (this script)
BASENAME=$(basename "$FILE_PATH")
[ "$BASENAME" = "detect-innovation.sh" ] && exit 0

# Get relative path from project root
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Dedup: skip if this file is already in the registry
if [ -f "$REGISTRY" ] && grep -qF "$REL_PATH" "$REGISTRY"; then
  exit 0
fi

# Initialize registry if missing
if [ ! -f "$REGISTRY" ]; then
  mkdir -p "$(dirname "$REGISTRY")"
  printf '# Innovation Registry\n\n| Date | Type | File | Status | Graduated To |\n|------|------|------|--------|-------------|\n' > "$REGISTRY"
fi

# Append entry
DATE=$(date '+%Y-%m-%d')
printf '| %s | %s | %s | detected | — |\n' "$DATE" "$TYPE" "$REL_PATH" >> "$REGISTRY"

# Emit system message
echo "{\"systemMessage\":\"Innovation detected: $TYPE '$BASENAME'. Will be triaged at /wrap-session.\"}"

exit 0
