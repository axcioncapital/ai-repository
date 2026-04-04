#!/bin/bash
# Log file write/edit activity to the friction log
# Triggered by: PostToolUse hook on Write and Edit matchers
# Recursion guard: skips friction-log.md and improvement-log.md

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"

# Skip if no active friction log
[ -f "$FRICTION_LOG" ] || exit 0

# Get the file path from tool input
FILE_PATH=$(jq -r '.tool_input.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

# Recursion guard
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  friction-log.md|improvement-log.md) exit 0 ;;
esac

# Make path relative for readability
REL_PATH="${FILE_PATH#$PROJECT_DIR/}"

# Find the last "#### Write Activity" section
LAST_WRITE_LINE=$(grep -n "^#### Write Activity" "$FRICTION_LOG" | tail -1 | cut -d: -f1)
[ -z "$LAST_WRITE_LINE" ] && exit 0

# Append entry
NOW=$(date "+%H:%M")
sed -i '' "${LAST_WRITE_LINE}a\\
- ${NOW} — ${REL_PATH}" "$FRICTION_LOG" 2>/dev/null || true

exit 0
