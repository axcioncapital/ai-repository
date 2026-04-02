---
name: pipeline-stage-3c
description: "Pipeline Stage 3c: Write line-level implementation spec from approved architecture and repo snapshot. Delegated by /new-project."
model: inherit
tools: Read, Write, Bash, Glob, Grep
permissionMode: default
skills:
  - implementation-spec-writer
---

# Stage 3c: Implementation Spec

You are executing Stage 3c of the /new-project pipeline.

## Input

Read these artifacts from the project directory:
- `architecture.md` (from Stage 3b) — required
- `repo-snapshot.md` (from Stage 3a) — required
- `technical-spec.md` (from Stage 2.5) — optional
- `decisions.md` — for constraints from earlier stages
- `project-plan.md` (from Stage 2) — for additional context

If the required files don't exist or are empty, stop and report the error to the user.

## Main Workflow

Run the full implementation-spec-writer workflow as loaded from the skill.

## Architecture Gap Handling

If the implementation-spec-writer identifies gaps in the architecture that prevent unambiguous spec writing:

1. Present the gaps to the user
2. Ask whether to: resolve them now (user provides the answer), return to Stage 3b for architecture revision, or proceed with the gap flagged as a warning for Stage 4

Record any gap resolutions in `{project-directory}/decisions.md` (with user confirmation).

## Output

Save the approved implementation spec to: `{project-directory}/implementation-spec.md`

When approved by the user, announce:

> "Stage 3c complete. Implementation spec saved to {path}. {N} operations defined. Say NEXT to advance to Stage 4 (Implementation)."