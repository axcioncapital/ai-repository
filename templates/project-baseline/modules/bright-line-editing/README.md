# Module: Bright-Line Editing

## When to Include

Projects with approved or finalized prose that must be protected from casual edits — strategy documents, reports, deliverables, or any content where unvetted changes could alter meaning, remove sourced claims, or introduce errors.

Skip for projects that don't produce prose artifacts, or where all content is in draft state and edits are expected.

## What It Adds

1. **CLAUDE.md bright-line rule** — Three checks before any edit to protected content: multi-paragraph scope, analytical claim alteration, sourced statement modification
2. **PreToolUse hook** — Blocks the Edit tool on protected directories and reminds Claude to run the three checks before proceeding

## How to Adapt

- Change the directory pattern in the hook command (`grep -qE '/(report|final)/'`) to match the project's protected directories
- Adjust the three checks if the project has different content sensitivities
- The decisions log path (`/logs/decisions.md`) is standard from the baseline
