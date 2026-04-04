# Project Baseline Template — Manifest

## Baseline Components (Always Included)

| Component | Type | Template File | Parameterized Fields |
|-----------|------|---------------|---------------------|
| CLAUDE.md | Config | `baseline/CLAUDE.md` | PROJECT_NAME, PROJECT_DESCRIPTION, OPERATOR_NAME, DIRECTORY_LAYOUT, WORKFLOW_OVERVIEW, INITIAL_STATUS |
| .gitignore | Config | `baseline/gitignore.md` | None |
| settings.json | Config | `baseline/claude/settings.json` | None (standard permissions, empty hooks) |
| /prime | Command | `baseline/claude/commands/prime.md` | PROJECT_NAME, OPERATOR_NAME, STATUS_SCAN_DIRS, STATUS_SUMMARY_BULLETS |
| /status | Command | `baseline/claude/commands/status.md` | PROJECT_NAME, STATUS_SCAN_DIRS |
| /note | Command | `baseline/claude/commands/note.md` | None |
| session-notes.md | Log | `baseline/logs/session-notes.md` | None |
| decisions.md | Log | `baseline/logs/decisions.md` | None |
| qc-log.md | Log | `baseline/logs/qc-log.md` | None |
| workflow-observations.md | Log | `baseline/logs/workflow-observations.md` | None |
| quality-standards.md | Reference | `baseline/reference/quality-standards.md` | None |
| Root CLAUDE.md | Config | `baseline/root-claude.md` | PROJECT_NAME, PROJECT_DESCRIPTION, SUBPROJECT_LIST — **only for multi-level projects** |

## Optional Modules

| Module | When to Include | What It Adds | Dependencies |
|--------|----------------|--------------|--------------|
| content-lifecycle | Projects that produce written content through iterative drafting (notes → drafts → approved) | `/draft-section` command, CLAUDE.md section on content lifecycle, `parts/` directory pattern | None |
| friction-logging | Projects in active development where workflow improvement matters | Hook scripts for auto-logging friction events and write activity, `/improve` command, settings.json hooks | None |
| bright-line-editing | Projects with approved or finalized prose that must be protected from casual edits | CLAUDE.md bright-line rule, PreToolUse hook that blocks edits to protected directories without operator approval | None |
| auto-commit | Projects with pipeline stage directories that produce artifacts progressively | PostToolUse hook that auto-commits artifacts written to stage directories | None |
| session-context-hooks | Projects with checkpoints or context that should be reloaded at session start | SessionStart hook (loads latest checkpoint), Stop hook (warns if no checkpoint written) | None |
| verification-agent | Projects with high-stakes outputs that need independent verification | Agent definition for independent re-derivation and discrepancy flagging | None |
