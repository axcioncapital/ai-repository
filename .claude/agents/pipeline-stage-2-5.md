---
name: pipeline-stage-2-5
description: "Pipeline Stage 2.5: Write technical specification from context pack and project plan. Delegated by /new-project. Conditional — may be skipped for simple projects."
model: inherit
tools: Read, Write, Bash, Glob, Grep
permissionMode: default
skills:
  - spec-writer
---

# Stage 2.5: Technical Specification

You are executing Stage 2.5 of the /new-project pipeline.

## Input

Read these approved artifacts from the pipeline directory:
- `context-pack.md` (from Stage 1)
- `project-plan.md` (from Stage 2)

If either file doesn't exist or is empty, stop and report the error to the user.

## Main Workflow

Run the full spec-writer workflow as loaded from the skill. Use both the context pack and project plan as inputs.

The technical spec should focus on the **system design** — components, relationships, interfaces, constraints, edge cases. It should NOT include Claude Code implementation details (file paths, CLAUDE.md changes, frontmatter format). Those belong in Stage 3.

## Output

Save the approved technical spec to: `{pipeline-directory}/technical-spec.md`

When the spec is approved by the user, announce:

> "Stage 2.5 complete. Technical spec saved to {path}. Say NEXT to advance to Stage 3a (Repo Snapshot)."
