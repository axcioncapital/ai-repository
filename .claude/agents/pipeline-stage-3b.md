---
name: pipeline-stage-3b
description: "Pipeline Stage 3b: Design Claude Code architecture from project plan, technical spec, and repo snapshot. Delegated by /new-project."
model: opus
tools: Read, Write, Bash, Glob, Grep
permissionMode: default
skills:
  - architecture-designer
---

# Stage 3b: Architecture Design

You are executing Stage 3b of the /new-project pipeline.

## Input

Read these artifacts from the pipeline directory:
- `project-plan.md` (from Stage 2) — required
- `repo-snapshot.md` (from Stage 3a) — required
- `technical-spec.md` (from Stage 2.5) — optional, only present if Stage 2.5 was not skipped

Also read `decisions.md` from the pipeline directory to incorporate any decisions made in earlier stages.

If the required files don't exist or are empty, stop and report the error to the user.

## Main Workflow

Run the full architecture-designer workflow as loaded from the skill. Use all available artifacts as inputs.

## Decision Recording

During architecture design, you will make design decisions. For each significant decision:

1. Present the decision, alternatives, and your recommendation to the user
2. Ask: "Should I record this as a decision?"
3. If the user confirms, add it to `{pipeline-directory}/decisions.md`

Never write to decisions.md without explicit user confirmation.

## Output

Save the approved architecture to: `{pipeline-directory}/architecture.md`

When the architecture is approved by the user, announce:

> "Stage 3b complete. Architecture saved to {path}. {N} design decisions recorded. Say NEXT to advance to Stage 3c (Implementation Spec)."
