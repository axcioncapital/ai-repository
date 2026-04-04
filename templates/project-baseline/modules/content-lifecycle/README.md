# Module: Content Lifecycle

## When to Include

Projects that produce written content through iterative drafting — strategy documents, reports, analyses, or any output that goes through multiple revision rounds before approval.

Do NOT include for projects that produce only code, configuration, or single-pass outputs.

## What It Adds

1. **`/draft-section` command** — Interactive drafting workflow with plan mode, dependency checking, and incremental saving
2. **CLAUDE.md additions** — Content lifecycle rules (notes → drafts → approved), plan mode default for content work, cross-referencing conventions
3. **Directory pattern** — `parts/` directory with subdirectories for each content area, each containing `notes/`, `drafts/`, and `approved/`

## How to Adapt

- Replace `parts/` subdirectory names with project-specific content areas
- Adjust the reference files listed in `/draft-section` (content-architecture, style-guide, etc.) to match the project's context directory
- The plan mode default can be relaxed for projects where content decisions are less consequential
