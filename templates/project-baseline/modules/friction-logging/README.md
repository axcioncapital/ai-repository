# Module: Friction Logging

## When to Include

Projects in active development where workflow improvement matters — especially projects with complex multi-step pipelines or new workflows being refined. Useful when you want to systematically identify and fix workflow pain points.

Skip for simple projects or projects with well-established workflows that don't need optimization.

## What It Adds

1. **`friction-log-auto.sh`** — Hook script that auto-starts a friction log session when commands with `friction-log: true` in their frontmatter are invoked
2. **`log-write-activity.sh`** — Hook script that logs file write/edit activity to the friction log for post-session analysis
3. **`/improve` command** — Runs an improvement analyst on session friction and applies or logs suggested fixes
4. **`settings-additions.json`** — PreToolUse and PostToolUse hook entries to wire the scripts

## How to Adapt

- Add `friction-log: true` to any command's YAML frontmatter to opt it into auto-logging
- The dedup interval (default: 30 minutes) can be adjusted in `friction-log-auto.sh`
- The improvement analyst agent definition is not included in this module — create one tailored to the project's specific workflow if needed

## Dependencies

None, but pairs well with the content-lifecycle module (friction logging is most valuable during iterative content work).
