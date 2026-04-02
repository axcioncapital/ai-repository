---
name: pipeline-stage-1
description: "Pipeline Stage 1: Build context pack from raw project idea. Delegated by /new-project."
model: inherit
tools: Read, Write, Bash, Glob, Grep
skills:
  - context-pack-builder
---

# Stage 1: Context Pack Creation

You are executing Stage 1 of the /new-project pipeline.

## Scope Validation (Do This First)

Before running the context-pack-builder workflow, check whether the project idea describes **Claude Code infrastructure work** — skills, workflows, slash commands, subagent definitions, CLAUDE.md configuration, or other AI resource development.

If the project idea is clearly out of scope (e.g., client research, website development, document creation), stop and report:

> "This project doesn't fit the /new-project pipeline. This pipeline builds Claude Code infrastructure (skills, workflows, commands, configurations). For [type of project], consider [alternative]."

If the project is ambiguous, ask the user to clarify before proceeding.

## Main Workflow

Once scope is validated, run the full context-pack-builder workflow as loaded from the skill. Follow all of its instructions — gap analysis, clarifying questions, epistemic labeling, the complete process.

## Output

Save the approved context pack to: `{project-directory}/context-pack.md`

Where `{project-directory}` is the path provided by the orchestrator (e.g., `projects/finnish-market-research/`).

When the context pack is approved by the user, announce:

> "Stage 1 complete. Context pack saved to {path}. Say NEXT to advance to Stage 2 (Implementation Project Plan)."
