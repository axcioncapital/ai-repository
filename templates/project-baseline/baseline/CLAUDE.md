# {{PROJECT_NAME}}

## Project Context

{{PROJECT_DESCRIPTION}}

## Project Structure

{{DIRECTORY_LAYOUT}}

## Operator Profile

{{OPERATOR_NAME}} is the sole operator. Reviews outputs at defined gates, makes editorial decisions requiring domain judgment, and approves stage transitions. Claude Code executes; {{OPERATOR_NAME}} reviews and directs.

## How to Work in This Project

{{WORKFLOW_OVERVIEW}}

## Context Isolation Rules

- Sub-agents receive content from the main agent, not file paths. The main agent reads the file and passes the content.
- Sub-agents do not persist state between invocations. Each call is fresh.
- Sub-agents do not inherit the parent agent's session state. When launching a sub-agent, pass the working state it needs — output directory paths, files already created, stages completed — so it does not rediscover what the parent already knows.

## QC Pattern

Use sub-agents for all artifact evaluations to maintain QC independence. The pattern:
1. Main agent reads the artifact and evaluation criteria
2. Main agent launches a QC sub-agent, passing content (not file paths)
3. Sub-agent evaluates independently and returns a structured verdict
4. Main agent writes the review report and logs the verdict to `logs/qc-log.md`

See @reference/quality-standards.md for verdict definitions and QC principles.

## File Verification and Git Commits

Verify files you just wrote by reading them from the filesystem, not by running git status/diff. The filesystem is the source of truth for files you just created or modified.

If a commit fails with no staged changes, report it once and move on — the most common cause is unchanged content.

## Logging Conventions

- `logs/session-notes.md` — Where we left off. Updated at session end.
- `logs/decisions.md` — Operator decisions requiring judgment. Timestamped.
- `logs/qc-log.md` — QC verdicts. Updated after each quality check.
- `logs/workflow-observations.md` — Ad-hoc notes via `/note`.

## Current Status

{{INITIAL_STATUS}}
