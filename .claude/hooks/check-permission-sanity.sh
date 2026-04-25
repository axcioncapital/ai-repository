#!/bin/bash
# check-permission-sanity.sh — SessionStart hook
#
# Ultra-fast check (<5s) that verifies the current project's permission config
# has the load-bearing `defaultMode: "bypassPermissions"` setting. If missing,
# emits a nudge telling the operator to run /permission-sweep.
#
# Does NOT auto-fix. Harness-level permission changes require explicit operator
# approval (Autonomy Rules pause-trigger #8). This hook only surfaces the issue.
#
# The primary root cause of recurring Edit/Delete permission prompts is:
#   1. A settings.local.json that exists but lacks defaultMode (shadows parent).
#   2. A project settings.json that has no defaultMode at all.
# This hook catches both.

PROJECT_DIR="$CLAUDE_PROJECT_DIR"
[ -n "$PROJECT_DIR" ] || exit 0

SETTINGS="$PROJECT_DIR/.claude/settings.json"
SETTINGS_LOCAL="$PROJECT_DIR/.claude/settings.local.json"

# Fast-path: no settings.json at all → project relies on parent/user-level. Skip.
[ -f "$SETTINGS" ] || exit 0

# jq is required for parsing. Bail silently if absent — don't block session start.
command -v jq >/dev/null 2>&1 || exit 0

# Check settings.json for defaultMode
main_mode=$(jq -r '.permissions.defaultMode // ""' "$SETTINGS" 2>/dev/null)

# Check settings.local.json — if present, its defaultMode shadows settings.json
local_exists=0
local_mode=""
local_has_perms=0
if [ -f "$SETTINGS_LOCAL" ]; then
  local_exists=1
  local_mode=$(jq -r '.permissions.defaultMode // ""' "$SETTINGS_LOCAL" 2>/dev/null)
  local_has_perms=$(jq -r 'if (.permissions // {}) == {} then 0 else 1 end' "$SETTINGS_LOCAL" 2>/dev/null)
  [ "$local_has_perms" = "1" ] || local_has_perms=0
fi

# Decision logic:
#   - If settings.local.json has a permissions block AND its defaultMode != "bypassPermissions" → nudge.
#   - Else if settings.json's defaultMode != "bypassPermissions" → nudge.
#   - Else if settings.json's deny array is missing safety-floor entries (Bash(rm -rf *), Bash(sudo *)) → nudge.
#   - Else pass silently.
nudge_reason=""
if [ "$local_exists" = "1" ] && [ "$local_has_perms" = "1" ] && [ "$local_mode" != "bypassPermissions" ]; then
  nudge_reason="settings.local.json has a permissions block but no 'bypassPermissions' defaultMode — it is shadowing settings.json. Run /permission-sweep to fix."
elif [ "$main_mode" != "bypassPermissions" ]; then
  nudge_reason="settings.json is missing 'defaultMode: bypassPermissions'. You will see permission prompts on Edit/Write/Delete. Run /permission-sweep to fix."
else
  # Safety-floor deny check — Bash(rm -rf *) and Bash(sudo *) must be in every settings.json's deny array
  # per docs/permission-template.md (Layers A, B, C, D all require these).
  missing_denies=""
  for entry in "Bash(rm -rf *)" "Bash(sudo *)"; do
    has_entry=$(jq --arg e "$entry" '(.permissions.deny // []) | any(. == $e)' "$SETTINGS" 2>/dev/null)
    if [ "$has_entry" != "true" ]; then
      [ -z "$missing_denies" ] && missing_denies="$entry" || missing_denies="$missing_denies, $entry"
    fi
  done
  if [ -n "$missing_denies" ]; then
    nudge_reason="settings.json is missing safety-floor deny entries: $missing_denies. These are mandatory per docs/permission-template.md. Run /permission-sweep to restore."
  fi
fi

if [ -n "$nudge_reason" ]; then
  # Emit as hookSpecificOutput.additionalContext so the main session sees it on start.
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"Permission sanity check: %s"}}\n' "$nudge_reason"
fi

exit 0
