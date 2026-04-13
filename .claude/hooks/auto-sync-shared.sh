#!/bin/bash
# auto-sync-shared.sh — SessionStart hook
#
# Walks ai-resources/.claude/{commands,agents}/ and symlinks every file into
# the project, EXCEPT:
#   1. Files listed in the project's .claude/shared-manifest.json under
#      commands.local / agents.local (project-owned, never overwritten).
#   2. Files in the baked-in EXCLUDE lists below (ai-resources-meta — never
#      belong inside a downstream project).
#   3. Files that already exist at the target (any kind: file, symlink, or
#      broken symlink — never overwrites).
#
# Result: when you add a new command to ai-resources, every project picks it
# up automatically on next session start. No manifest edits required.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
MANIFEST="$PROJECT_DIR/.claude/shared-manifest.json"

# Bail if no manifest — project opts out of managed symlinks entirely.
[ -f "$MANIFEST" ] || exit 0

# Walk up to find ai-resources.
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

# Baked-in exclusions: ai-resources-meta files that never belong in projects.
EXCLUDE_COMMANDS="new-project deploy-workflow"
EXCLUDE_AGENT_GLOBS="pipeline-stage-* session-guide-generator"

# Read project-local exclusions from manifest.
LOCAL_COMMANDS=$(jq -r '.commands.local[]?' "$MANIFEST" 2>/dev/null)
LOCAL_AGENTS=$(jq -r '.agents.local[]?' "$MANIFEST" 2>/dev/null)

in_list() {
  local needle="$1"; shift
  for item in $@; do
    [ "$item" = "$needle" ] && return 0
  done
  return 1
}

matches_glob() {
  local needle="$1"; shift
  for pattern in $@; do
    case "$needle" in $pattern) return 0;; esac
  done
  return 1
}

synced=""

# Sync commands.
for src in "$AI_RESOURCES"/.claude/commands/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  in_list "$name" "$EXCLUDE_COMMANDS" && continue
  in_list "$name" "$LOCAL_COMMANDS" && continue
  target="$PROJECT_DIR/.claude/commands/${name}.md"
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/commands"
  ln -s "$src" "$target"
  synced="$synced ${name}.md"
done

# Sync agents.
for src in "$AI_RESOURCES"/.claude/agents/*.md; do
  [ -f "$src" ] || continue
  name=$(basename "$src" .md)
  matches_glob "$name" "$EXCLUDE_AGENT_GLOBS" && continue
  in_list "$name" "$LOCAL_AGENTS" && continue
  target="$PROJECT_DIR/.claude/agents/${name}.md"
  [ -e "$target" ] || [ -L "$target" ] && continue
  mkdir -p "$PROJECT_DIR/.claude/agents"
  ln -s "$src" "$target"
  synced="$synced ${name}.md"
done

if [ -n "$synced" ]; then
  count=$(echo $synced | wc -w | tr -d ' ')
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"Auto-synced $count new shared file(s) from ai-resources (symlinked):$synced\"}}"
fi
