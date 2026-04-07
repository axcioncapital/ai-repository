#!/bin/bash
# auto-sync-shared.sh — SessionStart hook
# Reads .claude/shared-manifest.json to determine which commands/agents should
# be symlinked from ai-resources. Only creates missing symlinks — never
# overwrites existing files. Silent if nothing to sync.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
MANIFEST="$PROJECT_DIR/.claude/shared-manifest.json"

# Bail if no manifest — project doesn't use managed symlinks
[ -f "$MANIFEST" ] || exit 0

# Walk up from project dir to find ai-resources
d="$PROJECT_DIR"
AI_RESOURCES=""
while [ "$d" != "/" ]; do
  d=$(dirname "$d")
  if [ -d "$d/ai-resources/.claude/commands" ]; then
    AI_RESOURCES="$d/ai-resources"
    break
  fi
done

[ -z "$AI_RESOURCES" ] && exit 0

synced=""

# Sync shared commands
for name in $(jq -r '.commands.shared[]' "$MANIFEST" 2>/dev/null); do
  src="$AI_RESOURCES/.claude/commands/${name}.md"
  target="$PROJECT_DIR/.claude/commands/${name}.md"
  [ -f "$src" ] || continue
  # Skip if anything exists at target (file, symlink, or broken symlink)
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/commands"
  ln -s "$src" "$target"
  synced="$synced ${name}.md"
done

# Sync shared agents
for name in $(jq -r '.agents.shared[]' "$MANIFEST" 2>/dev/null); do
  src="$AI_RESOURCES/.claude/agents/${name}.md"
  target="$PROJECT_DIR/.claude/agents/${name}.md"
  [ -f "$src" ] || continue
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/agents"
  ln -s "$src" "$target"
  synced="$synced ${name}.md"
done

if [ -n "$synced" ]; then
  count=$(echo $synced | wc -w | tr -d ' ')
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"Auto-synced $count new shared file(s) from ai-resources (symlinked):$synced\"}}"
fi
