# {{PROJECT_NAME}}

## What This Project Is

{{PROJECT_DESCRIPTION}}

## Project Structure

This is a multi-level project. The root directory holds spec files and orientation. Active work happens in subproject directories.

### Subprojects

{{SUBPROJECT_LIST}}

### Pipeline Artifacts

Build-time documents live in `pipeline/`:

| File | Purpose |
|------|---------|
| `pipeline/context-pack.md` | Original project context and requirements |
| `pipeline/project-plan.md` | Project plan (from pipeline Stage 2) |
| `pipeline/architecture.md` | Claude Code architecture design (from pipeline Stage 3b) |
| `pipeline/implementation-spec.md` | Line-level build instructions (from pipeline Stage 3c) |
| `pipeline/decisions.md` | Design decisions from the pipeline |
| `pipeline/pipeline-state.md` | Pipeline progress tracking |

## Where to Work

Open sessions in the subproject directory for active work. This root directory is for orientation and spec files only — no commands or workflows run from here.

There is no `.claude/` directory at this level. All commands, agents, settings, and hooks live in the subproject directories.
