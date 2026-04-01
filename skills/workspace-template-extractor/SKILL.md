---
name: workspace-template-extractor
description: >
  Extract a reusable project template from a working Claude Code workspace.
  Use when a project workspace has matured enough that its structure, commands,
  hooks, agents, and reference documents represent a proven pattern worth
  replicating. Produces a clean template directory with parameterized placeholders
  for project-specific content. Requires an operator-provided extraction manifest
  classifying each file/folder.
---

# Workspace Template Extractor

## Overview

Takes a working Claude Code project workspace and produces a clean, reusable template by separating infrastructure from project-specific content. The operator provides the classification decisions via a manifest; this skill handles the mechanical extraction.

## Inputs

1. **Source workspace path** — the working project to extract from
2. **Target template path** — where the template should be created
3. **Extraction manifest** — classifies each file/folder (see Classification Types below)

## Classification Types

Each file or folder in the source workspace must be classified as one of:

| Type | Behavior |
|------|----------|
| `infrastructure` | Copy as-is to the template |
| `placeholder` | Copy structure but replace project-specific content with `{{PLACEHOLDER}}` markers |
| `project-content` | Exclude from template entirely |
| `empty-structure` | Create directory with `.gitkeep` (or file with headers only, no entries) |

## Procedure

### Phase 1: Inventory

1. Enumerate the source workspace's complete directory tree.
2. List all files in `.claude/` (settings.json, commands/, agents/, hooks/).
3. List all files in `reference/` (stage instructions, conventions, skills, SOPs).
4. List all log files and their header structures.
5. Identify symlinks vs. real files in `reference/skills/`.

### Phase 2: Classify

For each discovered item, apply the extraction manifest classification. Verify coverage — every file/folder must be classified. Flag any items the manifest doesn't cover.

Classification heuristics (when manifest is ambiguous):
- Files that reference project name, operator name, specific sections, or absolute paths → `placeholder`
- Files containing research artifacts, drafts, evidence, or analysis → `project-content`
- Directories that hold per-section subdirectories (1.1/, 1.2/, etc.) → `empty-structure` (parent only)
- Configuration, commands, agents, hooks, reference docs → `infrastructure`

### Phase 3: Scaffold

1. Create the target template directory.
2. Mirror the source directory tree, applying classifications:
   - `infrastructure` directories: create and populate
   - `empty-structure` directories: create with `.gitkeep`
   - `project-content` directories: skip entirely
3. Do NOT create per-section subdirectories — those are project-specific.

### Phase 4: Parameterize

#### Standard placeholder vocabulary

| Placeholder | Purpose |
|------------|---------|
| `{{PROJECT_NAME}}` | kebab-case project identifier |
| `{{PROJECT_TITLE}}` | Human-readable project title (used in headers) |
| `{{PROJECT_DESCRIPTION}}` | 2-3 sentence project description |
| `{{OPERATOR_NAME}}` | Operator's name |
| `{{CURRENT_SECTION}}` | Initial section identifier |
| `{{DOCUMENT_ARCHITECTURE}}` | Document structure description |
| `{{EVIDENCE_CALIBRATION}}` | Evidence calibration note |
| `{{ANALYTICAL_LENS}}` | Analytical framework description |
| `{{SECTION_SEQUENCE}}` | Section ordering and co-dependency constraints |

#### Parameterization rules

- **CLAUDE.md**: Replace project context fields with placeholders. Keep all workflow infrastructure sections verbatim.
- **settings.json**: Replace hardcoded absolute paths with `$CLAUDE_PROJECT_DIR`. Replace project-name-specific regex patterns with `$CLAUDE_PROJECT_DIR`-relative patterns.
- **Command files**: Replace operator's personal name with "the operator". Leave all other content (relative paths, skill references, stage logic) as-is.
- **Reference docs**: Replace project name in titles with `{{PROJECT_TITLE}}`. Replace section-specific sequences with `{{SECTION_SEQUENCE}}`. Keep all procedural content verbatim.
- **Agent files**: Copy verbatim (they use relative paths and generic descriptions).

#### Symlink handling

Skill symlinks are NOT included in the template. The template's SETUP.md lists all required symlinks. During project setup, the operator creates them with paths relative to the project's location. Symlink all skills in the library — unused skills cost nothing, missing skills break execution.

Local skills (real directories in `reference/skills/`, not symlinks) ARE included — they're workflow infrastructure.

### Phase 5: Create SETUP.md

Write a setup checklist inside the template covering:

1. Copy template to target project location
2. Initialize git repo
3. Fill all `{{PLACEHOLDER}}` values in CLAUDE.md
4. Fill sequence constraints in stage-instructions.md
5. Create skill symlinks (list all required skills with example `ln -s` commands)
6. Optional customizations (context folder, SOP adjustments)
7. Write initial task plan draft
8. Initial git commit
9. Validation steps (run `/status`, run `/run-preparation`)

### Phase 6: Validate

1. **No residual project content**: Search all template files for the source project's name, operator name, specific section IDs, and hardcoded absolute paths.
2. **Structural completeness**: Every source parent directory has a template counterpart (or is explicitly excluded).
3. **File completeness**: All command files, agent files, and hooks are present.
4. **JSON validity**: Parse settings.json to confirm valid JSON.
5. **Placeholder consistency**: Every `{{X}}` used in template files is documented in SETUP.md.

### Phase 7: Produce manifest log

Write a summary of the extraction:
- Files copied as infrastructure (count + list)
- Files templatized (count + list of changes)
- Files excluded as project content (count)
- Directories created as empty structure (count)
- Validation results

## Output

- Complete template directory at the target path
- SETUP.md inside the template with project initialization steps
- Manifest log showing extraction decisions

## Notes

- This skill handles the mechanical extraction. The operator decides what's infrastructure vs. project-specific via the manifest.
- The skill is workflow-agnostic. The same procedure works for research workflows, service development workflows, or any other Claude Code project type — the manifest defines the boundary.
- When extracting from a mature project, expect ~80 files in the template (commands, agents, hooks, reference docs, .gitkeep stubs, CLAUDE.md, settings.json, SETUP.md).
