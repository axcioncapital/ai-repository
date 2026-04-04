# Module: Session Context Hooks

## When to Include

Projects with checkpoints or other context that should be automatically loaded at session start — helps Claude resume work without manual context-gathering. Also useful for projects where forgetting to save progress is a risk.

Skip for simple projects where `/prime` provides sufficient session context.

## What It Adds

1. **SessionStart hook** — Automatically finds and loads the latest checkpoint file, providing session context (section, stage, checkpoint path)
2. **Stop hook** — Warns if no checkpoint was written during the session, reminding the operator to save progress

## How to Adapt

- Adjust the checkpoint search pattern in the SessionStart hook to match the project's checkpoint file locations and naming convention
- Adjust the `find` path in the Stop hook to match where checkpoints live
- The `-mmin -120` threshold (2 hours) in the Stop hook can be adjusted based on expected session length
