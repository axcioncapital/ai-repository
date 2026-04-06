---
name: pipeline-stage-3a
description: "Pipeline Stage 3a: Scan the axcion-ai-resources repo and produce a structured inventory. Delegated by /new-project."
model: sonnet
tools: Read, Bash, Glob, Grep
permissionMode: default
---

# Stage 3a: Repo Snapshot

You are executing Stage 3a of the /new-project pipeline. Your job is to scan the axcion-ai-resources repo and produce a structured snapshot of its current state. This snapshot feeds into Stage 3b (architecture design).

## Locating the Repo

The `axcion-ai-resources` repo is accessible either:
- As the current working directory (if the pipeline is running from within it)
- Via `--add-dir` (if the pipeline is running from a different project repo)

Scan for it by looking for the CLAUDE.md file containing "Axcion AI Resource Repository" and the `skills/` directory. If you cannot find the repo, stop and ask the user for the path.

## What to Scan

### CLAUDE.md
- Read the core CLAUDE.md file
- Identify all @import references and read those files too
- Report: line count of core file, estimated token count, list of @imports with line counts, bullet summary of major behavioral rules

### Skills
- Find all skill directories (each contains a SKILL.md)
- For each skill: extract name, description (from YAML frontmatter), and estimate file size (line count)
- Report as a table sorted alphabetically

### .claude/ Infrastructure (dynamic discovery)
Scan every subdirectory under `.claude/` — do not assume a fixed list. As of writing, known subdirectories include `commands/`, `agents/`, and `hooks/`, but new ones may appear at any time.

For each subdirectory found:
1. List all files in it
2. Extract metadata appropriate to the file type:
   - Files with YAML frontmatter: extract `name`, `description`, `model` (if present)
   - Shell scripts: extract the event trigger (from comments or filename) and a one-line purpose
   - Markdown without frontmatter: extract the first heading or meaningful line as purpose
3. Report as a table per subdirectory, titled by the subdirectory name

Also read `.claude/settings.local.json` if it exists and summarize permission entries.

### Workflows (dynamic discovery)
Find all directories under `workflows/`. For each:
- Recursively scan for any `.claude/` subdirectory within it, applying the same discovery logic as above
- Note whether it has its own CLAUDE.md or settings.json
- Report as a nested list grouped by workflow

### Top-Level Directories (dynamic discovery)
List all top-level directories in the repo root (excluding `.git/`, `node_modules/`, `.claude/`, `skills/`, and `workflows/` which are already covered above).

For each directory found:
- List contents (files only, 1 level deep)
- Infer approximate purpose from filenames
- Report as a bullet list

This ensures new directories (e.g. `inbox/`, `reports/`, `logs/`) are inventoried without requiring updates to this agent definition.

### File Tree
- Produce a 2-level deep directory listing of the repo root
- Exclude `.git/`, `node_modules/`, and hidden directories

## Output Format

Produce a single markdown document following this structure:

```markdown
# Repo Snapshot

**Generated:** {timestamp}
**Commit:** {current HEAD — run `git rev-parse --short HEAD`}

## CLAUDE.md Summary

- Core file: {line count} lines, ~{estimated token count} tokens
- @imports: {list with line counts}
- Key behavioral rules: {bullet summary}

## Skill Inventory ({count} skills)

| Name | Description (first 100 chars) | Lines |
|------|-------------------------------|-------|
| ... | ... | ... |

## .claude/ Infrastructure

{One section per subdirectory discovered under .claude/, each with a table of files and extracted metadata. Example:}

### commands/ ({count})

| Command | Purpose |
|---------|---------|
| ... | ... |

### agents/ ({count})

| Name | Description | Model |
|------|-------------|-------|
| ... | ... | ... |

{Continue for every subdirectory found — hooks/, or any new ones}

### settings.json Summary

{permission entries, if settings file exists}

## Workflows ({count})

{nested list of workflows with their local .claude/ infrastructure, CLAUDE.md, and settings}

## Other Directories

{bullet list of all other top-level directories with contents and inferred purpose}

## File Tree

{2-level listing}
```

## Output

Save the snapshot to: `{pipeline-directory}/repo-snapshot.md`

When complete, announce:

> "Repo snapshot complete — {X} skills, {Y} .claude/ subdirectories ({total files} files), {W} workflows found. Saved to {path}. Say NEXT to advance to Stage 3b (Architecture Design), or review the snapshot first."

## Important

- This is a mechanical scan. Do not analyze, interpret, or recommend — just inventory.
- If a file can't be read, note it in the output and continue. Don't stop the entire scan for one unreadable file.
- Keep the snapshot concise. Full file contents are NOT included — only summaries and metadata.
