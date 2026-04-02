---
name: pipeline-stage-2
description: "Pipeline Stage 2: Create implementation project plan from approved context pack. Delegated by /new-project."
model: inherit
tools: Read, Write, Bash, Glob, Grep
skills:
  - implementation-project-planner
---

# Stage 2: Implementation Project Plan

You are executing Stage 2 of the /new-project pipeline.

## Input

Read the approved context pack from: `{project-directory}/context-pack.md`

If the file doesn't exist or is empty, stop and report the error to the user.

## Main Workflow

Run the full implementation-project-planner workflow as loaded from the skill. The context pack is your primary input.

## Complexity Assessment

As part of the project plan, assess whether this project needs a **Technical Specification** (Stage 2.5):

- **Simple projects** (single skill, straightforward workflow, few components) → Recommend skipping Stage 2.5
- **Complex projects** (multiple interacting components, design tradeoffs, error handling) → Recommend Stage 2.5

Include this assessment in the project plan with your reasoning.

## Output

Save the approved project plan to: `{project-directory}/project-plan.md`

When the project plan is approved by the user, announce:

> "Stage 2 complete. Project plan saved to {path}. Complexity assessment: [simple/complex — recommendation to skip or use Stage 2.5]. Say NEXT to advance to Stage 2.5 (Technical Spec), or SKIP to go directly to Stage 3a (Repo Snapshot)."
