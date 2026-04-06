#!/bin/bash
# check-template-drift.sh — SessionStart hook
# Compares project .claude/ tooling against canonical workflow template.
# Outputs a nudge if updates are available. Silent if in sync.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
# Resolve ai-resources relative to this script's location
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AI_RESOURCES="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Determine template name from project CLAUDE.md (default: research-workflow)
TEMPLATE="research-workflow"
if [ -f "$PROJECT_DIR/CLAUDE.md" ]; then
  detected=$(grep -i 'template:' "$PROJECT_DIR/CLAUDE.md" 2>/dev/null | head -1 | sed 's/.*template:[[:space:]]*//' | tr -d '[:space:]')
  [ -n "$detected" ] && TEMPLATE="$detected"
fi

CANONICAL="$AI_RESOURCES/workflows/$TEMPLATE/.claude"

# Bail silently if canonical template doesn't exist
[ -d "$CANONICAL" ] || exit 0

updates=0
conflicts=0
new_files=0

for subdir in commands agents hooks; do
  canonical_dir="$CANONICAL/$subdir"
  project_dir="$PROJECT_DIR/.claude/$subdir"

  [ -d "$canonical_dir" ] || continue
  [ -d "$project_dir" ] || continue

  for canonical_file in "$canonical_dir"/*; do
    [ -f "$canonical_file" ] || continue
    filename=$(basename "$canonical_file")
    project_file="$project_dir/$filename"

    if [ -f "$project_file" ]; then
      if ! diff -q "$canonical_file" "$project_file" >/dev/null 2>&1; then
        updates=$((updates + 1))
      fi
    else
      new_files=$((new_files + 1))
    fi
  done
done

total=$((updates + new_files))

if [ "$total" -gt 0 ]; then
  msg="Template drift detected: $updates file(s) changed in canonical"
  [ "$new_files" -gt 0 ] && msg="$msg, $new_files new file(s) available"
  msg="$msg. Run /sync-workflow to review."
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"SessionStart\",\"additionalContext\":\"$msg\"}}"
fi
