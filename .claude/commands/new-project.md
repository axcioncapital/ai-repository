# /new-project — Project Pipeline Orchestrator

You are the orchestrator for Axcíon's project pipeline. This pipeline takes a user-provided context pack and produces a fully configured Claude Code setup through a series of staged gates.

## Scope Validation

This pipeline is for **any Axcíon project that requires Claude Code** — whether that's building AI resources (skills, workflows, agents), setting up a research project, configuring a new workspace, or any other project where Claude Code is the execution environment. Before doing anything else, check whether the user's input describes work that will be built or run through Claude Code. If not, stop and explain that this pipeline is for Claude Code-based projects.

**CWD guard:** Check if the current working directory is the `ai-resources` repo (look for `skills/` directory and the ai-resources `CLAUDE.md` with "Axcion AI Resource Repository"). If so, stop and tell the user:

> "This command should be run from a project repo, not from ai-resources. Open your target project repo and connect ai-resources via `--add-dir`, then run `/new-project` from there."

## Pre-Flight Validation

Before starting the pipeline, verify all required agent files exist in `ai-resources/.claude/agents/`:
- `pipeline-stage-2.md`, `pipeline-stage-2-5.md`, `pipeline-stage-3a.md`, `pipeline-stage-3b.md`, `pipeline-stage-3c.md`, `pipeline-stage-4.md`, `pipeline-stage-5.md`, `session-guide-generator.md`

Check with: `ls ai-resources/.claude/agents/pipeline-stage-*.md ai-resources/.claude/agents/session-guide-generator.md 2>&1`

If ANY file is missing, list all missing files and stop. Do not start the pipeline.

## Context Pack Requirement

The user must provide a context pack before the pipeline can start. The context pack can be:
- A file path to an existing context pack (e.g., `context-pack.md`)
- Pasted directly into the conversation

**If no context pack is provided, stop and ask for one.** Do not proceed without it.

## First Run vs. Continuation

**Determine which mode you're in:**

1. Look for `projects/*/pipeline/pipeline-state.md` files first. If none found, fall back to `projects/*/pipeline-state.md` (legacy layout).
2. If no pipeline state files exist → **First Run**
3. If pipeline state files exist → **Continuation** (if multiple projects have pipeline state files, ask the user which project to resume). Note whether the state file is in `pipeline/` (new layout) or at root (legacy layout) — use the same layout for all subsequent artifact paths in that project.

### First Run

1. **Ask for the project name.** Use lowercase-with-hyphens format (e.g., `context-aware-skill-router`).

2. **Ask for the GitHub repository link.** The user should provide the URL of the project's GitHub repo (e.g., `https://github.com/axcion-ai/project-name`).

3. **Create the project directory** at `projects/{project-name}/` and the pipeline artifact subdirectory at `projects/{project-name}/pipeline/`.

4. **Copy the user's context pack** to `projects/{project-name}/pipeline/context-pack.md`.

5. **Create `projects/{project-name}/pipeline/decisions.md`** with this template:

```markdown
# Decisions — {project-name}

| # | Stage | Decision | Rationale | Decided By |
|---|-------|----------|-----------|------------|
```

6. **Create `projects/{project-name}/pipeline/pipeline-state.md`** to track pipeline progress:

```markdown
# Pipeline State — {project-name}

## Metadata
- **GitHub:** {github-url}

| Stage | Status | Artifact |
|-------|--------|----------|
| 2 — Project Plan | in_progress | — |
| 2.5 — Technical Spec | pending | — |
| 3a — Repo Snapshot | pending | — |
| 3b — Architecture Design | pending | — |
| 3c — Implementation Spec | pending | — |
| 4 — Implementation | pending | — |
| 5 — Testing | pending | — |
| 6 — Session Guide | pending | — |
```

7. **Tell the user** what was created and that Stage 2 is starting.

8. **Spawn the Stage 2 subagent** (`pipeline-stage-2`) with the context pack as input. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

### Continuation

1. Read the pipeline state file for the project.
2. Find the stage that is `in_progress`, or the first `pending` stage whose predecessor is `completed` (or `skipped`).
3. Announce: "Resuming pipeline at [stage name]. Last completed: [previous stage]."
4. Spawn the corresponding stage subagent. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

**Agent name mapping:** Stages 2–5 use the `pipeline-stage-{N}` naming convention. Stage 6 (Session Guide) uses the `session-guide-generator` agent instead.

## Gate Protocol

After each stage subagent completes:

1. Update `pipeline-state.md`: set the current stage to `completed` and record the artifact path.
2. Wait for the user's command:
   - **`NEXT`** → Set the next stage to `in_progress` in `pipeline-state.md`. Spawn the next stage subagent.
   - **`SKIP`** → Valid after Stage 2 (skips Stage 2.5 — marks it `skipped` in `pipeline-state.md`, sets Stage 3a to `in_progress`) and after Stage 5 (skips Stage 6 — marks it `skipped`, announces pipeline complete). Not valid at other stages. Stage 2's complexity assessment informs whether skipping 2.5 is advisable.
   - **`ABORT`** → Mark all remaining `pending` stages as `cancelled` in `pipeline-state.md`. Announce abort. Do not delete project artifacts.

## Post-Stage 5 Behavior

After Stage 5 completes successfully, announce:

> "Pipeline core stages complete. Say NEXT to generate a Session Guide (Stage 6 — a step-by-step execution playbook for running this project), SKIP to finish the pipeline without one, or ABORT to cancel."

If the user says NEXT, spawn the `session-guide-generator` agent. If SKIP, mark Stage 6 as `skipped` and announce the pipeline is complete. After Stage 6 completes (or is skipped), announce: "Pipeline complete. All artifacts saved to projects/{project-name}/."

## Error Handling

If a stage subagent reports failure:
- Do NOT update the stage to `completed` in `pipeline-state.md`
- Report the failure to the user
- Offer options: retry the stage, abort the pipeline, or fix manually and resume

## Post-Pipeline Enrichment

After the pipeline completes (all stages done or final stage skipped), enrich the project with shared ai-resources features using the same logic as `/deploy-workflow` Step 4.

### Exclusion lists

These are ai-resources-specific and should NOT be copied to projects:

**Commands:** `create-skill`, `deploy-workflow`, `new-project`, `graduate-resource`, `migrate-skill`, `improve-skill`, `request-skill`, `sync-workflow`, `repo-dd`, `session-guide`

**Agents:** any file matching `pipeline-stage-*`, `session-guide-generator`, `repo-dd-auditor`

**Hooks:** `pre-commit`, `check-template-drift.sh`

### Copy logic

For each category (`commands`, `agents`, `hooks`):

1. List all files in `{WORKSPACE_ROOT}/ai-resources/.claude/{category}/`
2. Skip any file whose basename (without extension) matches the exclusion list
3. Skip any file that already exists in the project's `.claude/{category}/` — pipeline output takes precedence
4. Copy the remaining files, creating directories if needed

Report what was added. If a copied hook has no `settings.json` entry, warn the operator. Do not auto-modify `settings.json`. Do not commit — the operator reviews the enrichment alongside the pipeline output.

## Key Rules

- Never advance a stage without user confirmation (`NEXT`)
- Never modify decisions.md without user confirmation
- Always announce which stage is running and what it expects as input
- When spawning any subagent, always include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"
- The `pipeline/pipeline-state.md` file is the source of truth for pipeline progress — always read it before taking action, always update it after state changes. All pipeline artifacts (context-pack, project-plan, architecture, specs, logs, test-results) live in `pipeline/`. Only the project's working files live at the project root.
- If the project involves creating new skills, inform the user that skill creation must use the `/create-skill` command from ai-resources. Ensure ai-resources is connected via `--add-dir` so the command is available.
