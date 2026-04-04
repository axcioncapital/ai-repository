Audit the repository's folder structure, file naming, and placement against project conventions.

This command is read-only. It does not create, move, or delete any files.

Input: $ARGUMENTS (optional) — `--save` to write the report to `/logs/`, otherwise display inline only.

---

### Step 1: Load Convention Authority

1. Read `/reference/file-conventions.md` (canonical naming patterns, general naming convention, workspace organization rules).
2. Read `/reference/stage-instructions.md` (expected directory structure and artifact output paths per stage).
3. These two files are the sole authority for what is correct. Do not invent rules beyond what they specify.

---

### Step 2: Map the Repository Tree

4. List every file and directory in the repository, excluding `.git/` and `.claude/`.
5. Record the full tree for analysis. Note the total count of files and directories.

---

### Step 3: Check Folder Structure

6. Verify that all expected top-level stage directories exist: `preparation/`, `execution/`, `analysis/`, `report/`, `final/`, `logs/`, `reference/`.
7. Within each stage directory, verify expected subdirectories exist per stage-instructions.md:
   - `preparation/` — `task-plans/`, `research-plans/`, `answer-specs/`
   - `execution/` — `manifest/`, `research-prompts/`, `raw-reports/`, `research-extracts/`, `extract-verification/`, `supplementary/`, `scarcity-register/`, `checkpoints/`
   - `analysis/` — `cluster-memos/`, `chapters/`, `gap-assessment/`, `editorial-review/`, `gap-supplementary/`, `section-directives/`, `checkpoints/`
   - `report/` — `chapters/`, `checkpoints/`, `architecture/`, `style-reference/`, `enrichment/`
   - `final/` — `modules/`
   - `reference/` — `skills/`, `sops/`, `templates/`, `scoping-notes/`
8. Flag missing expected directories as WARNING.
9. Flag unexpected directories (directories not listed above and not mentioned in conventions or stage-instructions) as INFO.
10. Flag empty directories (containing no files other than `.gitkeep`) as INFO.

---

### Step 4: Check File Naming Conventions

11. For each file (excluding `.gitkeep`, `.gitignore`, `CLAUDE.md`, and files in `.claude/` and `.git/`), check against the canonical naming patterns from file-conventions.md:
    - Match against each pattern in the Canonical Naming Standard table based on the file's parent directory.
    - If no canonical pattern matches, check against the general naming convention: `[section-number]-[descriptive-name]-v[version].md`.
    - Verify all files are markdown (`.md` extension). Non-markdown files are ERROR (excluding `.gitkeep`, `.gitignore`, `.DS_Store`).
    - Verify lowercase-hyphenated format (no uppercase letters, no underscores, no spaces in filenames). Violations are ERROR. **Exception:** Canonical patterns that themselves use uppercase (e.g., `{section}-Q[N]-extract.md`) are not violations — match against the pattern as written.
    - Verify version suffixes follow convention where applicable. Deviations are WARNING.
    - **Convention conflict rule:** If file-conventions.md and stage-instructions.md specify different names for the same artifact, flag as INFO with both references. Do not treat the file as a naming error if it follows either authority.
    - **Skill directories:** Skip `reference/skills/` subdirectories — these follow their own structure (skill subdirs containing `SKILL.md`) and are not governed by file-conventions.md.

---

### Step 5: Check File Placement

12. For each file, verify it resides in the correct directory based on stage-instructions.md artifact output paths:
    - Task plans → `preparation/task-plans/`
    - Research plans → `preparation/research-plans/`
    - Answer specs → `preparation/answer-specs/{section}/`
    - Execution manifests → `execution/manifest/`
    - Research prompts → `execution/research-prompts/{section}/`
    - Raw reports → `execution/raw-reports/`
    - Research extracts → `execution/research-extracts/`
    - Extract verifications → `execution/extract-verification/`
    - Supplementary artifacts → `execution/supplementary/`
    - Cluster memos → `analysis/cluster-memos/`
    - Section directives → `analysis/section-directives/`
    - Chapter drafts (cluster-NN-draft) → `analysis/chapters/`
    - Report chapters → `report/chapters/`
    - Final modules → `final/modules/`
    - Checkpoints → `{stage}/checkpoints/`
13. Flag misplaced files as ERROR.
14. Flag files sitting directly in a stage root directory (e.g., a file in `analysis/` rather than a subdirectory) as WARNING — the convention says all files go in clearly named folders.
    - **Exception:** Do not flag files that stage-instructions.md explicitly places at stage root. To determine this, search stage-instructions.md for output paths that target the stage root (e.g., `/execution/scarcity-register/{section}/{section}-scarcity-register.md`, `/analysis/gap-assessment/{section}/{section}-gap-assessment.md`, `/report/architecture/{section}/{section}-architecture.md`, `/report/style-reference/{section}/{section}-style-reference.md`). Check each loose file against these paths before flagging. Do not maintain a static list — always derive from stage-instructions.md.

---

### Step 6: Identify Orphans and Anomalies

15. Identify orphan files: files whose names do not match any canonical pattern AND do not follow the general naming convention AND cannot be traced to a specific stage-instructions.md output path. Flag as WARNING.
    - If a file appears to be a legitimate workflow artifact (its name is descriptive and relates to a known workflow step) but has no canonical pattern, flag as INFO under a **Convention Gaps** heading — this signals a missing pattern in file-conventions.md, not necessarily a file error.
16. Identify files in the project root (outside stage directories). Flag as WARNING unless they are `CLAUDE.md`, `.gitignore`, or `.DS_Store`.
17. Flag any non-markdown files (excluding `.gitkeep`, `.gitignore`, `.DS_Store`) as ERROR.
18. Flag unexpected nesting (directories more than 3 levels deep from project root, or unexpected subdirectory structures) as INFO.

---

### Step 7: Produce the Audit Report

19. Compile all findings into a structured report:

```
# Repository Structure Audit

**Date:** [date]
**Total files scanned:** [count]
**Total directories scanned:** [count]

## Summary

| Severity | Count |
|----------|-------|
| ERROR    | N     |
| WARNING  | N     |
| INFO     | N     |

## Findings

### ERRORS

[Each finding: file path, rule violated, expected pattern/location]

### WARNINGS

[Each finding: file path, rule violated, expected pattern/location]

### INFO

[Each finding: file path, observation]

### Convention Gaps

[Artifacts that exist as legitimate workflow outputs but lack a canonical naming pattern or have conflicting authority between file-conventions.md and stage-instructions.md. These signal gaps in the conventions themselves, not file errors.]

## Directory Tree

[Full tree listing used for the audit]

## Convention References

- File naming: `/reference/file-conventions.md`
- Directory structure: `/reference/stage-instructions.md`
```

20. If `$ARGUMENTS` contains `--save`: write the report to `/logs/structure-audit-[date].md` and confirm the path.
21. If `$ARGUMENTS` is empty or does not contain `--save`: display the full report inline.

---

### Notes

- This command is purely diagnostic. It never creates, moves, renames, or deletes files.
- Some files may have legitimate reasons for deviating from conventions (e.g., files predating a convention update, or one-off artifacts). The report flags deviations; the operator decides what to act on.
- `.gitkeep` files in empty directories are expected and not flagged as naming violations.
- Files in `reference/` that are not in the canonical naming table (e.g., `quality-standards.md`, `stage-instructions.md`) are checked against the general naming convention only.
- Re-run this command after making structural fixes to verify resolution.
