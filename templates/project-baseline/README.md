# Project Baseline Template

## What This Is

A reusable template for bootstrapping new Claude Code projects. Extracted from the buy-side-service-plan project — the most refined project setup in the workspace.

Two tiers:
- **Baseline** (`baseline/`) — Always included. Core configuration, session management commands, logging, QC infrastructure.
- **Modules** (`modules/`) — Selected per project. Each module adds a specific capability (friction logging, content lifecycle, etc.).

## Who Consumes This

This template is consumed by pipeline stages, not by humans directly:

1. **Stage 3b (architecture-designer)** reads `manifest.md` to understand what baseline components and modules are available. Selects which modules to include based on the project plan.
2. **Stage 3c (implementation-spec-writer)** reads the specific template files referenced in the architecture document. Resolves `{{PLACEHOLDERS}}` with project-specific values and produces operation blocks with exact file content.
3. **Stage 4 (project-implementer)** never reads this template. It reads the implementation spec from Stage 3c and executes mechanically.

## Parameterization Convention

Template files use `{{PLACEHOLDER_NAME}}` markers for values that vary per project. These are resolved by Stage 3c — they never appear in the final implementation spec or project files.

Standard parameters:

| Parameter | Description |
|-----------|-------------|
| `{{PROJECT_NAME}}` | Human-readable project name |
| `{{PROJECT_DESCRIPTION}}` | One-paragraph description of the project |
| `{{OPERATOR_NAME}}` | Operator's name (e.g., "Patrik") |
| `{{DIRECTORY_LAYOUT}}` | Project-specific directory tree |
| `{{WORKFLOW_OVERVIEW}}` | How the project's workflow operates |
| `{{STATUS_SCAN_DIRS}}` | Project-specific directories to scan in /prime and /status |
| `{{STATUS_SUMMARY_BULLETS}}` | Project-specific status summary items |
| `{{INITIAL_STATUS}}` | Starting state description |

## Module Convention

Each module directory contains:
- `README.md` — When to include this module, what it adds, dependencies on other modules
- Template files for the components it provides (commands, agents, hook scripts)
- `settings-additions.json` (if the module adds hooks) — Hook entries to merge into the base `settings.json`
- `claude-md-additions.md` (if the module adds CLAUDE.md sections) — Text to merge into the project CLAUDE.md

Stage 3c merges selected modules' additions into the base files when writing the implementation spec.

## Adding New Modules

When a project develops a pattern that proves valuable and reusable:

1. Create a new directory under `modules/` with a descriptive kebab-case name
2. Add a `README.md` explaining when to include it and what it provides
3. Add template files for the components
4. Add an entry to the Optional Modules table in `manifest.md`
5. The pattern is now available for future projects via the pipeline
