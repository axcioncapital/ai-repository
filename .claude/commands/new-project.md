# /new-project — Project Pipeline Orchestrator

You are the orchestrator for Axcíon's project pipeline. This pipeline takes a raw project idea and produces a fully configured Claude Code setup through a series of staged gates.

## Scope Validation

This pipeline is for **AI resource development projects** — building skills, workflows, configurations, slash commands, and subagent definitions. Before doing anything else, check whether the user's input describes this kind of work. If not, stop and suggest the appropriate alternative (e.g., research workflow for research projects).

**CWD guard:** Check if the current working directory is the `ai-resources` repo (look for `skills/` directory and the ai-resources `CLAUDE.md` with "Axcion AI Resource Repository"). If so, stop and tell the user:

> "This command should be run from a project repo, not from ai-resources. Open your target project repo and connect ai-resources via `--add-dir`, then run `/new-project` from there."

## First Run vs. Continuation

**Determine which mode you're in:**

1. Look for any `projects/*/pipeline-state.md` files in the current working directory.
2. If no pipeline state files exist → **First Run**
3. If pipeline state files exist → **Continuation** (if multiple projects have pipeline state files, ask the user which project to resume)

### First Run

1. **Ask for the project name.** Use lowercase-with-hyphens format (e.g., `context-aware-skill-router`).

2. **Create the project directory** at `projects/{project-name}/`.

3. **Create `projects/{project-name}/decisions.md`** with this template:

```markdown
# Decisions — {project-name}

| # | Stage | Decision | Rationale | Decided By |
|---|-------|----------|-----------|------------|
```

4. **Create `projects/{project-name}/pipeline-state.md`** to track pipeline progress:

```markdown
# Pipeline State — {project-name}

| Stage | Status | Artifact |
|-------|--------|----------|
| 1 — Context Pack | in_progress | — |
| 2 — Project Plan | pending | — |
| 2.5 — Technical Spec | pending | — |
| 3a — Repo Snapshot | pending | — |
| 3b — Architecture Design | pending | — |
| 3c — Implementation Spec | pending | — |
| 4 — Implementation | pending | — |
| 5 — Testing | pending | — |
```

5. **Tell the user** what was created and that Stage 1 is starting.

6. **Spawn the Stage 1 subagent** (`pipeline-stage-1`) with the user's raw project idea as input. Include in the spawn prompt: "Project directory: projects/{project-name}/"

### Continuation

1. Read the pipeline state file for the project.
2. Find the stage that is `in_progress`, or the first `pending` stage whose predecessor is `completed` (or `skipped`).
3. Announce: "Resuming pipeline at [stage name]. Last completed: [previous stage]."
4. Spawn the corresponding stage subagent. Include in the spawn prompt: "Project directory: projects/{project-name}/"

## Gate Protocol

After each stage subagent completes:

1. Update `pipeline-state.md`: set the current stage to `completed` and record the artifact path.
2. Wait for the user's command:
   - **`NEXT`** → Set the next stage to `in_progress` in `pipeline-state.md`. Spawn the next stage subagent.
   - **`SKIP`** → Valid after Stage 2 (skips Stage 2.5 — marks it `skipped` in `pipeline-state.md`, sets Stage 3a to `in_progress`). Not valid at other stages.
   - **`ABORT`** → Mark all remaining `pending` stages as `cancelled` in `pipeline-state.md`. Announce abort. Do not delete project artifacts.

## Error Handling

If a stage subagent reports failure:
- Do NOT update the stage to `completed` in `pipeline-state.md`
- Report the failure to the user
- Offer options: retry the stage, abort the pipeline, or fix manually and resume

## Key Rules

- Never advance a stage without user confirmation (`NEXT`)
- Never modify decisions.md without user confirmation
- Always announce which stage is running and what it expects as input
- When spawning any subagent, always include in the spawn prompt: "Project directory: projects/{project-name}/"
- The pipeline-state.md file is the source of truth for pipeline progress — always read it before taking action, always update it after state changes
