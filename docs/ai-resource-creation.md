# AI Resource Creation Rules

> **When to read this file:** When a session identifies the need for a new or modified AI resource (skill, command, agent definition, workflow template), or when routing a skill request.

When a session identifies the need for a new or modified AI resource:

1. **Shared AI resources belong in `ai-resources/`.** Reusable skills, commands, and agent definitions — anything that could plausibly serve more than one project — belong in `ai-resources/`. Project workspaces consume shared resources via symlink or copy; they never own them. Project-specific *pipeline* commands and evaluator agents (e.g., pipeline commands tightly coupled to one project's workflow) are allowed to live locally in the project's own `.claude/` when they are tightly coupled to that project's pipeline and not intended for reuse.

2. **Do not improvise skill-like artifacts.** If the task calls for reusable procedural instructions, it's a skill — route it through the canonical pipeline.

3. **Capture the need, then route to the pipeline.** When working in a project and a skill gap surfaces, use `/request-skill` to write a structured brief to `ai-resources/inbox/`, then hand off to `/create-skill` in the same session. The `ai-resources/` directory is connected via `--add-dir` — no session switch needed.

4. **Always use the canonical pipelines:** `/create-skill` for new skills, `/improve-skill` for modifications, `/migrate-skill` for converting existing prompts. These pipelines include QC gates — skipping them means skipping quality assurance.
