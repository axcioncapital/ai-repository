# File Conventions — {{PROJECT_TITLE}}

> **When to read this file:** When creating new files, naming artifacts, or setting up workspace directories. Not needed for every turn.

## General Rules

- All artifacts are markdown files
- File names use lowercase-hyphenated format
- Draft iterations append a version suffix: `chapter-01-v1.md`, `chapter-01-v2.md`
- QC verdicts use consistent format: PASS / CONDITIONAL PASS / FAIL with per-item findings
- Reference materials live in `/reference/scoping-notes/`

## Naming Rules

These rules govern all file creation. They take precedence over any implicit convention.

**Rule 1 — Section prefix and subdirectory are mandatory.** Every artifact filename in a stage directory (`preparation/`, `execution/`, `analysis/`, `report/`, `final/`) starts with `{section}-`. Every artifact goes inside a `{section}/` subdirectory within its parent directory (e.g., `execution/raw-reports/1.1/1.1-session-a-raw-report.md`). No loose files at stage root — every artifact belongs in a named subdirectory. Files in `reference/`, `logs/`, and `output/` are exempt — they are project-scoped, not section-scoped.

**Rule 2 — Variant suffix convention.** When a step produces a derived version of an existing artifact, the name is the base canonical pattern plus a variant suffix before the extension. Recognized variant suffixes: `-refined`, `-cited`, `-ctl`, `-verification`. Example: `{section}-cluster-NN-memo.md` → `{section}-cluster-NN-memo-refined.md`. A variant does not need its own row in the canonical table — it inherits from the base pattern.

**Rule 3 — Unknown artifact protocol.** If you are about to write a file and no canonical pattern matches (even with variant suffixes), construct the name from the General File Naming Convention below, write the file, AND add a new row to the Canonical Naming Standard table in this file. The table must stay complete — every artifact type that exists in the repo must have a corresponding pattern.

## Canonical Naming Standard

Every artifact follows a predictable pattern so commands and hooks can locate files mechanically. NN is always zero-padded two digits (01, 02, ...).

| Artifact Family | Directory | Filename Pattern | Example |
| --- | --- | --- | --- |
| Task plans | `preparation/task-plans/` | `{section}-task-plan-[version].md` | `1.1-task-plan-v1.md`, `1.1-task-plan-draft.md` |
| Research plans | `preparation/research-plans/` | `{section}-research-plan-[version].md` | `1.1-research-plan-v1.md` |
| Answer specs | `preparation/answer-specs/{section}/` | `chapter-NN-specs.md` | `chapter-01-specs.md` |
| Answer spec QC | `preparation/answer-specs/{section}/` | `answer-specs-qc.md` | `answer-specs-qc.md` |
| Execution manifest | `execution/manifest/{section}/` | `{section}-execution-manifest.md` | `1.1-execution-manifest.md` |
| Research prompts | `execution/research-prompts/{section}/` | `session-[letter].md` | `session-a.md` |
| Session plan | `execution/research-prompts/{section}/` | `session-plan.md` | `session-plan.md` |
| Raw reports | `execution/raw-reports/{section}/` | `{section}-session-[letter]-raw-report.md` | `1.1-session-a-raw-report.md` |
| Research extracts | `execution/research-extracts/{section}/` | `{section}-Q[N]-extract.md` | `1.1-Q1-extract.md` |
| Extract verification | `execution/extract-verification/{section}/` | `{section}-extract-verification-[letter].md` | `1.1-extract-verification-a.md` |
| Supplementary extract verification | `execution/extract-verification/{section}/` | `{section}-extract-verification-supplementary-[scope].md` | `1.1-extract-verification-supplementary-q2-q5.md` |
| Prompt QC | `execution/checkpoints/{section}/` | `{section}-step-2.1b-prompt-qc.md` | `1.1-step-2.1b-prompt-qc.md` |
| Supplementary artifacts | `execution/supplementary/{section}/` | `{section}-[descriptive-name].md` | `1.1-query-brief-pass-1.md` |
| Scarcity register | `execution/scarcity-register/{section}/` | `{section}-scarcity-register.md` | `1.1-scarcity-register.md` |
| Cluster memos | `analysis/cluster-memos/{section}/` | `{section}-cluster-NN-memo.md` | `1.1-cluster-01-memo.md` |
| Section directives | `analysis/section-directives/{section}/` | `{section}-cluster-NN-directive.md` | `1.1-cluster-01-directive.md` |
| Gap assessment | `analysis/gap-assessment/{section}/` | `{section}-gap-assessment.md` | `1.1-gap-assessment.md` |
| Gap loop state | `analysis/checkpoints/{section}/` | `{section}-gap-loop-state.md` | `1.1-gap-loop-state.md` |
| Gap failed components | `analysis/gap-supplementary/` | `cluster-NN-failed-components.md` | `cluster-01-failed-components.md` |
| Gap query brief | `analysis/gap-supplementary/` | `cluster-NN-query-brief-pass-[N].md` | `cluster-01-query-brief-pass-1.md` |
| Gap Perplexity raw | `analysis/gap-supplementary/` | `cluster-NN-perplexity-raw-pass-[N].md` | `cluster-01-perplexity-raw-pass-1.md` |
| Gap QC | `analysis/gap-supplementary/` | `cluster-NN-qc-pass-[N].md` | `cluster-01-qc-pass-1.md` |
| 3.S pass checkpoint | `analysis/checkpoints/{section}/` | `{section}-3S-pass-[N]-checkpoint.md` | `1.1-3S-pass-1-checkpoint.md` |
| Memo review | `analysis/editorial-review/{section}/` | `{section}-memo-review.md` | `1.1-memo-review.md` |
| Memo review recommendations | `analysis/editorial-review/{section}/` | `{section}-memo-review-recommendations.md` | `1.1-memo-review-recommendations.md` |
| Editorial recommendations QC | `analysis/editorial-review/{section}/` | `{section}-qc-editorial-decisions.md` | `1.1-qc-editorial-decisions.md` |
| Cluster chapter drafts | `analysis/chapters/{section}/` | `{section}-cluster-NN-draft.md` | `1.1-cluster-01-draft.md` |
| Report architecture | `report/architecture/{section}/` | `{section}-architecture.md` | `1.1-architecture.md` |
| Architecture QC | `report/checkpoints/{section}/` | `{section}-step-4.1b-architecture-qc.md` | `1.1-step-4.1b-architecture-qc.md` |
| Style reference | `report/style-reference/{section}/` | `{section}-style-reference.md` | `1.1-style-reference.md` |
| Report chapters | `report/chapters/{section}/` | `{section}-chapter-NN.md` | `1.1-chapter-01.md` |
| Combined CTL | `report/chapters/{section}/` | `{section}-chapter-NN-NN-ctl.md` | `1.1-chapter-01-02-ctl.md` |
| Final modules | `final/modules/{section}/` | `{section}-module-NN-[stage].md` | `1.1-module-01-qc.md` |
| Step checkpoints | `{stage}/checkpoints/{section}/` | `{section}-step-{id}[-descriptor]-checkpoint.md` | `1.1-step-2.1-checkpoint.md`, `1.1-step-2-gap-assessment-checkpoint.md` |
| Cluster checkpoints | `{stage}/checkpoints/{section}/` | `{section}-cluster-NN-step-{N}-checkpoint.md` | `1.1-cluster-01-step-2-checkpoint.md` |
| Chapter checkpoints | `report/checkpoints/{section}/` | `{section}-chapter-NN[-descriptor]-checkpoint.md` | `1.1-chapter-01-checkpoint.md`, `1.1-chapter-01-cited-checkpoint.md` |
| Chapter reviews | `report/checkpoints/{section}/` | `{section}-chapter-NN-review.md` | `1.1-chapter-01-review.md` |

## General File Naming Convention

For any output NOT covered by the canonical naming standard:

```
[section-number]-[descriptive-name]-v[version].md
```

**Rules:**
- Section number first — matches project plan numbering (e.g., 1.1, 2.3)
- Descriptive name in kebab-case — lowercase, hyphens, no spaces or underscores
- Version last — uses `v` prefix with minor versions (v0.1 → v0.8 → v1.0)
- v0.x = draft/in-progress, v1.0 = first complete version, v1.1+ = revisions
- Every output gets a version from the start
- When updating a file — increment version in filename, don't overwrite without versioning

## Workspace Organization

All files go in clearly named folders — never leave loose files in stage roots or the repo root.

### Directory Structure

```
preparation/
  task-plans/
  research-plans/
  answer-specs/{section}/

execution/
  manifest/{section}/
  research-prompts/{section}/
  raw-reports/{section}/
  research-extracts/{section}/
  extract-verification/{section}/
  supplementary/{section}/
  scarcity-register/{section}/
  checkpoints/{section}/

analysis/
  cluster-memos/{section}/
  section-directives/{section}/
  gap-assessment/{section}/
  editorial-review/{section}/
  gap-supplementary/{section}/
  chapters/{section}/
  checkpoints/{section}/

report/
  architecture/{section}/
  style-reference/{section}/
  chapters/{section}/
  checkpoints/{section}/
  enrichment/{section}/

final/
  modules/{section}/

reference/              (project-scoped, no section subdirs)
  skills/
  sops/
  templates/
  scoping-notes/

logs/                   (project-scoped, no section subdirs)

output/                 (project-scoped, no section subdirs)
  knowledge-files/
```

### Rules

- When starting a new section, create `{section}/` subdirectories inside each artifact directory as needed. Do not pre-create all subdirectories — create them when the stage produces its first artifact.
- `reference/`, `logs/`, and `output/` are project-scoped — no section subdirectories.
- Additional folders use descriptive kebab-case names.

**Cleanup rule:** Before ending a session, delete scratch/temporary files not needed going forward. Ask before deleting if unsure.
