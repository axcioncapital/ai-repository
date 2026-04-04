#!/bin/bash
# Auto-start friction log session when a command has friction-log: true
# Triggered by: PreToolUse hook on Skill matcher
# Dedup: skips if session created in last 30 minutes

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
FRICTION_LOG="$PROJECT_DIR/logs/friction-log.md"
DEDUP_MINUTES=30

# Read the tool input to get the skill/command name
SKILL_NAME=$(jq -r '.tool_input.skill // empty' 2>/dev/null)
[ -z "$SKILL_NAME" ] && exit 0

# Check if the command has friction-log: true in frontmatter
CMD_FILE="$PROJECT_DIR/.claude/commands/$SKILL_NAME.md"
[ -f "$CMD_FILE" ] || exit 0
grep -q 'friction-log: true' "$CMD_FILE" || exit 0

# Dedup: skip if a session block was created recently
if [ -f "$FRICTION_LOG" ]; then
  LAST_SESSION=$(grep -n "^### Session:" "$FRICTION_LOG" | tail -1 | cut -d: -f1)
  if [ -n "$LAST_SESSION" ]; then
    LAST_TIME=$(sed -n "${LAST_SESSION}p" "$FRICTION_LOG" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}')
    if [ -n "$LAST_TIME" ]; then
      LAST_EPOCH=$(date -j -f "%Y-%m-%d %H:%M" "$LAST_TIME" "+%s" 2>/dev/null || echo 0)
      NOW_EPOCH=$(date "+%s")
      DIFF=$(( (NOW_EPOCH - LAST_EPOCH) / 60 ))
      [ "$DIFF" -lt "$DEDUP_MINUTES" ] && exit 0
    fi
  fi
fi

# Create friction log if it doesn't exist
if [ ! -f "$FRICTION_LOG" ]; then
  echo "# Friction Log" > "$FRICTION_LOG"
  echo "" >> "$FRICTION_LOG"
fi

# Append new session block
NOW=$(date "+%Y-%m-%d %H:%M")
{
  echo ""
  echo "### Session: $NOW — Trigger: /$SKILL_NAME"
  echo ""
  echo "#### Friction Events"
  echo ""
  echo "#### Write Activity"
  echo ""
} >> "$FRICTION_LOG"

exit 0
