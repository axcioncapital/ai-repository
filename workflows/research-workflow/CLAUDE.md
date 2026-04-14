# {{PROJECT_TITLE}}

## Project Context

**What:** {{PROJECT_DESCRIPTION}}

**Analytical lens:** {{ANALYTICAL_LENS}}

**Current Section:** {{CURRENT_SECTION}}

**Document architecture:** {{DOCUMENT_ARCHITECTURE}}. See @reference/stage-instructions.md for full sequence constraints.

**Evidence calibration:** {{EVIDENCE_CALIBRATION}}

## Operator Profile

{{OPERATOR_NAME}} is the sole operator. They review outputs at defined gates, make editorial decisions requiring domain judgment, and approve stage transitions. Claude Code executes; the operator reviews and directs.

## Workflow Overview

Five-stage pipeline: Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production.

Artifact chain: Task Plan → Research Plan → Answer Specs → Deep Research Reports → Research Extracts → Cluster Analytical Memos → Section Directives → Report Prose

**IMPORTANT:** For detailed stage instructions, read @reference/stage-instructions.md. For file naming rules, read @reference/file-conventions.md. For QC standards and evidence handling, read @reference/quality-standards.md. For writing voice and style, read @reference/style-guide.md. Only load these when actively working on the relevant stage or task.

## Workflow Status Command

`/workflow-status` — Read-only command that displays a structured status view of every stage in the research workflow, then runs a QC health check via subagent using the `workflow-evaluator` skill. Both phases always run together. Source workflow: `reference/stage-instructions.md`. Skill reference integrity is checked against `ai-resources/skills/`.

## Utility Commands

`/audit-repo` — Run a workspace health check. Analyzes file organization, CLAUDE.md health, skill inventory, commands, settings, and best practices. Report written to `reports/repo-health-report.md`.

## Cross-Model Rules

- Research Execution GPT produces evidence (Stage 2) — Claude does not substitute its own research
- Research Execution GPT verifies Claude's prose for fact-checking (Stage 4) — Claude does not fact-check its own writing
- Perplexity handles factual retrieval and gap-filling — Claude routes queries, does not guess answers

## Autonomy Rules

When executing a process or workflow, proceed through stages automatically unless:
- A step is tagged [Operator] — always pause for input
- A step is tagged [Operator + Claude Code] — proceed if no issues found, pause only if you find something that changes the project's logic, scope, or structure
- An evaluation report contains critical findings — pause and show the findings
- A gate fails — pause and explain what failed

For non-critical issues (formatting, minor wording, small structural fixes), apply the fix and note what you changed. Do not pause for approval on minor fixes.

## Context Isolation Rules

- Sub-agents receive content from the main agent, not file paths. The main agent reads the file and passes the content.
- Exception: Verification Agent reads source files directly (independent derivation), but receives the main output from the main agent.
- Sub-agents do not persist state between invocations. Each call is fresh. If prior results are needed, the main agent provides them explicitly.
- Sub-agents do not inherit the parent agent's session state. When launching a sub-agent, pass the working state it needs — output directory paths, files already created, stages completed — so it does not rediscover what the parent already knows.

## Friction Logging

Pipeline commands auto-start a friction log session via hook (`friction-log: true` in command frontmatter). The operator can also log friction manually:

- `/friction-log start` — start a new session block
- `/friction-log [description]` — append a friction event
- `/improve` — run the improvement analyst on session friction (end-of-session)

## Citation Conversion Rule

Every cited chapter file must include a complete bibliography listing all sources cited in that chapter. Never substitute a note like "sources listed in other modules" or "no new sources introduced." Even if every source was introduced in a prior module, the bibliography must reproduce the relevant entries. Each chapter is a self-contained cited artifact.

## Bright-Line Rule (All Fix Steps)

Before applying ANY fix to report prose, run three checks:
1. **Multi-paragraph scope:** Changes more than one paragraph? → PAUSE for operator approval.
2. **Analytical claim alteration:** Changes, removes, or reframes an analytical claim? → PAUSE for operator approval.
3. **Sourced statement modification:** Alters a statement attributed to a source or carrying a claim ID? → PAUSE for operator approval.

If ANY check is true, the fix MUST NOT be applied without explicit operator approval. Log to `/logs/decisions.md`.

Applies at: Step 4.2, Step 5.2, Step 5.7, and `/verify-chapter`.

## File Verification and Git Commits

Verify files you just wrote by reading them from the filesystem, not by running git status/diff. The filesystem is the source of truth for files you just created or modified.

If a commit fails with no staged changes, report it once and move on — the most common cause is unchanged content.

## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

Do not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
