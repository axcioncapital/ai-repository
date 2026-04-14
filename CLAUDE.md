# Axcion AI Resource Repository

## What This Repo Contains

This repo stores AI resources — primarily skills (SKILL.md files), plus occasional prompts and project instructions. Each skill lives in its own folder under `skills/`. Resource briefs from project workspaces land in `inbox/` — these are requests for new skills, created via `/request-skill` in project sessions and picked up by `/create-skill` here.

Other directories:
- `prompts/` — Standalone prompts for cross-tool workflows (e.g., supplementary research prompts consumed by GPT-5)
- `reports/` — Generated audit and health reports
- `logs/` — Session notes, decisions, innovation registry
- `audits/` — Due diligence and audit artifacts
- `docs/` — Process documentation (session rituals, etc.)
- `scripts/` — Utility scripts for repo maintenance
- `style-references/` — Style reference materials consumed by formatting and prose-compliance skills

These resources operate across a multi-tool ecosystem — not just Claude. Skills may reference or interact with GPT-5 (via API/CustomGPT), Perplexity (via API), Notion, and NotebookLM. Do not design resources that assume a single-tool environment.

## How I Work

I am Patrik, a non-developer. Explain technical details in plain language. I review and approve all changes before they are committed or pushed.

## Skill Format Standard

Skills are consumed by other Claude instances, not by humans. Write instructions that would be beneficial and non-obvious to a fresh Claude encountering the skill for the first time. Omit what Claude already knows from general training. Include procedural knowledge, domain-specific details, and failure mode handling that a general-purpose Claude would lack.

Every skill follows the structure defined in the ai-resource-builder methodology:

- YAML frontmatter with `name` and `description` (required)
- Markdown body with instructions
- Optional subdirectories: scripts/, references/, assets/
- No auxiliary files (no README, CHANGELOG, etc.)

Key conventions:

- Folder naming: lowercase, hyphenated (e.g., evidence-pack-validator)
- File: SKILL.md (exact name, in its own folder under `skills/`)
- Description field must include trigger conditions AND exclusions
- Body should stay under 500 lines

## Model Preference

Default to Claude Opus 4.6 (`claude-opus-4-6`) for subagents and API calls unless a faster model is explicitly justified for the task.

## Development Workflow

When creating or improving AI resources, follow this sequence.

### Creation

1. Discuss the need — understand use cases, triggers, exclusions
2. Plan the skill structure (what goes in SKILL.md vs. references vs. scripts)
3. Present an outline for my review before writing the full file
4. After my approval, write the complete SKILL.md to the correct folder
5. If the skill includes scripts in scripts/, test each script by running it before proceeding
6. Run a quality check (evaluate against the eight-layer framework)
7. Present any issues found. Fix what I approve.
8. Show me the final diff and wait for my go-ahead before committing

### Improvement

1. Read the existing file I point you to
2. Confirm your understanding of my feedback before making changes
3. Propose specific changes (what, where, why) and wait for approval
4. Apply approved changes to the file
5. Run quality check on the modified version
6. Present issues and iteration suggestions
7. Show diff, wait for my approval before committing

### Quality Check (Default: Lightweight)

After every creation or improvement, read `skills/ai-resource-builder/references/evaluation-framework.md` in this repo and apply the evaluation framework (behavioral analysis + convention gate) with the priority matrix for the relevant resource type. Flag issues as Critical / Major / Minor with specific fixes. This is the default — I will tell you when to skip it.

## General Session Rules

- Do not create files or resources that weren't explicitly requested. Suggest additions in chat instead.
- Complete the requested task before proposing extensions or improvements.
- Pull the latest from GitHub at the start of each session.

## Cross-References

Research workflow skills form a pipeline. When modifying any skill in this chain, check downstream skills for impact:

```
research-plan-creator → answer-spec-generator → [external: GPT-5 execution]
→ cluster-analysis-pass → evidence-to-report-writer
```

## Git Rules

- Always show me the diff before committing
- Use descriptive commit messages: `new: skill-name — purpose` or `update: skill-name — what changed`
- Multi-file changes: `batch: description`
- Never force-push
- Never push without my explicit approval
- After committing, remind Patrik to push and to wrap the session (`/wrap-session`) if the work is complete
- Default branch: main

## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

Do not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
