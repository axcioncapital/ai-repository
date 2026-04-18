# Section 6 — File Handling Patterns — Full Notes

**Scope:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan`
**Protocol:** `ai-resources/audits/token-audit-protocol.md` v1.2, Section 6
**Scope exclusions applied:** symlinked content under `reference/skills/` and `.claude/` (54 symlinks total — shared ai-resources, audited separately). `.git/` and `node_modules/` excluded per protocol.
**Pre-established input:** Section 0.3 verdict = HIGH. Zero `Read(...)` entries in `.claude/settings.json` or `.claude/settings.local.json`. `additionalDirectories` setting grants the full `Axcion AI Repo` workspace as readable.

## Repo scale snapshot

- Target files in scope (md/json/txt/csv/yaml/yml, `-type f`, symlinks excluded): **620 files**
- Files >200 lines: **152**
- Files >150 lines: **215**
- Aggregate word counts by domain:
  - `execution/` + `analysis/` + `report/` + `output/` (generated/checkpoint/draft artifacts): **~735,852 words** (~956,600 tokens est. × 1.3)
  - `parts/` (per-section drafts and approved prose): **~516,917 words** (~671,900 tokens)
  - `logs/` (session notes, decisions, friction, QC): **~92,538 words** (~120,300 tokens)
- File count per top-level directory:

  | Directory | File count | Notes |
  |-----------|-----------|-------|
  | `logs/` | 13 | Session notes, decisions, QC, friction, coaching, innovation registry |
  | `output/` | 29 | Completed Document 1/2/3 prose + prose parts assemblies |
  | `parts/` | 78 | Per-section drafts (54) + approved canonical versions (14) + working hypotheses |
  | `report/` | 113 | Report assembly checkpoints, architecture, chapters |
  | `reports/` | 1 | `repo-health-report.md` |
  | `analysis/` | 145 | Chapter analyses, cluster memos, editorial reviews, gap assessments |
  | `execution/` | 147 | Raw research reports, research extracts, checkpoints, manifests |
  | `final/` | 0 | Empty skeleton (modules/ subdir only) |
  | `context/` | 10 | Project brief, glossary, style guide, production plans, quality standards |
  | `preparation/` | 41 | Research plans, answer specs, task plans, checkpoints |
  | `research/` | 0 | Empty |
  | `usage/` | 1 | One usage log |

## Read(pattern) deny-rule status (from Step 0.3)

**Verdict:** HIGH
**Covered directories:** NONE. `permissions.deny` array in `.claude/settings.json` contains only three Bash-scope entries: `Bash(git push*)`, `Bash(rm -rf *)`, `Bash(sudo *)`. Zero `Read(...)` entries.
**Missing expected coverage:** `logs/`, `reports/`, `output/`, `final/`, `parts/` (drafts subtree), `report/` (checkpoints subtree), `analysis/` (checkpoints/editorial-review/gap-* subtrees), `execution/` (raw-reports/research-extracts/checkpoints), `preparation/checkpoints/`, `usage/`.
**Compounding factor:** `additionalDirectories` in `.claude/settings.json` = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`. This grants Read/Glob/Grep/Edit access to the entire workspace, not just the project. Absence of `Read(...)` denies means Glob/Grep/Read freely surface any large file in the project plus any file anywhere else in the workspace.

## Top 20 large files (merged by words + lines, dedup)

| # | File | Words | Lines | Should Claude read this? | Parent dir covered by Read() deny? | Classification |
|---|------|-------|-------|--------------------------|------------------------------------|----------------|
| 1 | `logs/session-notes.md` | 31,008 | 2,458 | NO | NO | Active log — per-turn reload not needed; read on demand, but currently unbounded |
| 2 | `logs/decisions.md` | 22,262 | 1,191 | NO (bulk) | NO | Active log, append-only; bulk historical content, not needed per-session |
| 3 | `logs/session-notes-archive-part1.md` | 20,449 | 2,211 | NO | NO | Archive — explicit archive marker in filename; stale |
| 4 | `output/document-1-buy-side-market-analysis.md` | 20,272 | 1,239 | NO | NO | Generated output (finished Document 1); prior session deliverable |
| 5 | `report/checkpoints/doc-2/doc-1-to-doc-2-audit-pass-1-extraction.md` | 18,213 | 1,956 | NO | NO | Checkpoint/working artifact from prior audit pass |
| 6 | `output/document-2-service-model.md` | 18,083 | 550 | NO | NO | Generated output (finished Document 2) |
| 7 | `parts/part-2-service/drafts/2.8-draft-04.md` | 14,506 | 641 | NO | NO | Superseded draft (draft-09 and approved/ version exist) |
| 8 | `parts/part-2-service/drafts/2.9-draft-07.md` | 13,138 | 570 | NO | NO | Latest draft, but `approved/2.9-target-state-service-model.md` is the canonical — superseded |
| 9 | `parts/part-2-service/approved/2.9-target-state-service-model.md` | 13,138 | 570 | YES | NO | Canonical approved artifact (but dir not denied) |
| 10 | `parts/part-2-service/drafts/2.8-draft-03.md` | 12,941 | 549 | NO | NO | Superseded draft |
| 11 | `parts/part-2-service/drafts/2.8-draft-09.md` | 12,705 | 584 | NO | NO | Latest draft, `approved/2.8-core-service-definition.md` is canonical — superseded |
| 12 | `parts/part-2-service/approved/2.8-core-service-definition.md` | 12,705 | 584 | YES | NO | Canonical approved (but dir not denied) |
| 13 | `parts/part-2-service/drafts/2.8-draft-08.md` | 12,435 | 582 | NO | NO | Superseded draft |
| 14 | `parts/part-2-service/drafts/2.9-draft-06.md` | 12,069 | 555 | NO | NO | Superseded draft |
| 15 | `parts/part-2-service/drafts/2.9-draft-05.md` | 12,069 | 555 | NO | NO | Superseded draft |
| 16 | `parts/part-2-service/drafts/2.9-draft-04.md` | 11,703 | 566 | NO | NO | Superseded draft |
| 17 | `parts/part-2-service/drafts/2.8-draft-07.md` | 11,631 | 564 | NO | NO | Superseded draft |
| 18 | `report/checkpoints/doc-2/doc-1-to-doc-2-audit-pass-2-verdicts.md` | 11,441 | 1,620 | NO | NO | Checkpoint/working artifact |
| 19 | `output/part-2-prose/decontamination-log.md` | 11,277 | 1,022 | NO | NO | Generated output — working log for prose production |
| 20 | `parts/part-2-service/drafts/2.3-draft-03.md` | 11,169 | 518 | NO | NO | Superseded draft (approved version exists) |

Additional large files observed in top 30 by words (>8,000 words each): `2.3-draft-02.md`, `2.3-draft-08.md`, `2.8-draft-02.md`, `2.3-draft-09.md`, `approved/2.3-service-process-and-interaction-model.md`, `logs/friction-log.md` (9,191 words / 1,302 lines), `2.9-draft-03.md`, `2.9-draft-02.md`, `2.3-draft-06.md`, `2.8-draft-01.md`. All same classification pattern.

## Assessment — Unignored large files (protocol Q1)

Every file in the top-20 table sits in a directory with **no `Read(...)` deny rule**. Of 20 files:
- **18 files (90%)** are classified NO per the protocol rule (archive / generated output / log / draft / superseded / prior report).
- **2 files (10%)** are canonical (approved/) — but still unprotected because the parent dir has no deny.

Extrapolating beyond top-20: of 215 files >150 lines in the project, structurally only the 14 approved artifacts in `parts/*/approved/`, the 9 files in `context/` (style guide / project brief / production plans), `CLAUDE.md` (167 lines), and a handful of research plans are canonical "YES read". The remainder (200+ files) are generated output / drafts / checkpoints / logs that Claude should not freely surface.

## Assessment — Output files in repo (protocol Q2)

Outputs from prior sessions are colocated with project inputs, not isolated. Evidence:

| Output category | Location | Parent dir Read-denied? | File count |
|-----------------|----------|-------------------------|-----------|
| Finished deliverables (Document 1/2/3) | `output/` | NO | 29 |
| Prose assemblies | `output/part-2-prose/`, `output/part-3-prose/` | NO | subset of 29 |
| Knowledge-file outputs | `output/knowledge-files/` | NO | subset of 29 |
| Checkpoints (audit passes, verification) | `report/checkpoints/doc-2/`, `report/checkpoints/1.1/`, etc. | NO | 113 total in `report/` |
| Cluster memos | `analysis/cluster-memos/` | NO | 145 total in `analysis/` |
| Editorial review artifacts | `analysis/editorial-review/` | NO | subset of 145 |
| Gap assessment / supplementary | `analysis/gap-assessment/`, `analysis/gap-supplementary/` | NO | subset of 145 |
| Raw research reports | `execution/raw-reports/` (916K on disk) | NO | subset of 147 |
| Research extracts | `execution/research-extracts/` (848K on disk) | NO | subset of 147 |
| Session notes + archives | `logs/session-notes.md`, `logs/session-notes-archive-part1.md` | NO | 2 |
| Deferred designs, coaching logs | `logs/deferred-designs/`, `logs/coaching-log.md`, `logs/coaching-data.md` | NO | subset of 13 |
| Repo-health reports | `reports/repo-health-report.md` | NO | 1 |
| Usage telemetry | `usage/` | NO | 1 |

**Total estimate:** approximately 434 files in the four primary generated-output subtrees (`execution/`, `analysis/`, `report/`, `output/`) plus all `logs/`, `reports/`, and `usage/` content — approximately **460 files totaling ~828,400 words (~1.08M tokens)** sit in directories with no `Read(...)` deny coverage.

## Assessment — Workspace hygiene (protocol Q3)

Hygiene-marker scan (filename contains `draft`/`tmp`/`old`/`deprecated`/`archive`/`v1`/`v2`/`backup`/`superseded`): **91 files** in project-owned paths (excluding `.claude/` and `reference/skills/` symlinks).

Breakdown:

| Pattern | Count | Examples |
|---------|-------|----------|
| `*-draft-*.md` under `parts/part-2-service/drafts/` | 54 | `2.3-draft-01.md` through `2.9-draft-07.md` — 9 section streams, 3–9 draft iterations each |
| Cluster `*-draft.md` files under `analysis/chapters/` | ~14 | `1.1-cluster-01-draft.md`, `1.2-cluster-02-draft.md`, etc. across chapters 1.1–1.4 |
| Explicit archive marker | 1 | `logs/session-notes-archive-part1.md` |
| `v2` versioning | 1 | `output/knowledge-files/1.2-knowledge-file-v2.md` |
| Dated files (`YYYY-MM-DD` prefix) | 1 | `logs/session-reviews/2026-04-13-what-worked.md` |
| Revision notes | 1 | `parts/part-2-service/drafts/2.7-revision-note.md` |
| `2.x-draft-NN` sections (part-2-service) with superseding `approved/` file | 54 | All 9 approved canonicals exist for sections 2.1–2.9; all draft iterations are superseded |

**Superseded-draft structural evidence:** `parts/part-2-service/approved/` contains 9 canonical files (one per section 2.1–2.9). `parts/part-2-service/drafts/` contains 54 numbered-draft iterations for the same sections. Every draft has a clearly superseding version in the same part tree.

**Directories named `archive`/`deprecated`/`old`/`backup`:** Zero. The only explicit archival marker is the single filename `session-notes-archive-part1.md`.

**Empty skeleton directories:** `final/` (contains only empty `modules/` subdir), `research/` (empty), `output/integrated/` (0B).

## Classification tally — "Should Claude read this?"

Applying the protocol's YES/NO rule across the 620 target files:

| Classification | Count (estimated) | Evidence |
|----------------|-------------------|----------|
| YES — canonical active | ~35–40 | `CLAUDE.md`, 9 files in `parts/part-2-service/approved/`, 10 files in `context/`, `repo-health-report.md`, active logs header, top-level production plans. Plus approved files in `parts/part-3-*`. |
| NO — generated output / checkpoint | ~300+ | All 434 files across `execution/` + `analysis/` + `report/` + `output/` except a small fraction of architecture/style-reference material |
| NO — superseded draft | ~68 | 54 in `parts/part-2-service/drafts/` + ~14 cluster-drafts in `analysis/chapters/` |
| NO — archive/log/telemetry | ~15 | `logs/` (13) + `usage/` (1) + `reports/` (1) |
| Ambiguous / supporting | remainder | `preparation/`, `context/` (architecture files) — some YES, some one-off |

## Cross-reference to Step 0.3 finding

The protocol's Step 6.2 rule: "any large file in a directory NOT covered by a `Read(...)` deny rule is a finding." With zero `Read(...)` denies covering any directory, **every file in the top-20 table — and every one of the ~460 files identified in the "Output files in repo" table — is individually a finding**. Per protocol severity: "Large data/output files in directories not covered by a `Read(...)` deny → MEDIUM per directory."

## Findings — Severity classification per protocol Section 6

| # | Finding | Severity | Evidence |
|---|---------|----------|----------|
| F1 | No `Read(...)` deny rules exist at all (0.3 verdict applied to Section 6) | HIGH | `.claude/settings.json` permissions.deny = Bash-only (3 entries); `.claude/settings.local.json` = model-only; 620 readable target files in project + unrestricted workspace access via `additionalDirectories` |
| F2 | Generated-output directory `execution/` (147 files, incl. `raw-reports/` 916K + `research-extracts/` 848K) unprotected | MEDIUM | Step 6.1 scan shows none covered; raw research is bulky context material not needed for routine turns |
| F3 | Generated-output directory `analysis/` (145 files, incl. cluster memos, editorial review, gap assessment) unprotected | MEDIUM | Per-directory finding rule; `analysis/cluster-memos/` alone is 372K on disk |
| F4 | Generated-output directory `report/` (113 files, incl. `report/checkpoints/doc-2/` 344K) unprotected | MEDIUM | Checkpoints are prior-audit working artifacts, not canonical |
| F5 | Generated-output directory `output/` (29 files, incl. finished Document 1 [20,272 words] and Document 2 [18,083 words]) unprotected | MEDIUM | Finished deliverables are NO-read for routine task execution |
| F6 | Log directory `logs/` unprotected; contains `session-notes.md` (31,008 words / 2,458 lines), `decisions.md` (22,262 words), `session-notes-archive-part1.md` (20,449 words), `friction-log.md` (9,191 words) | MEDIUM | Active logs are append-only bulk; archive file is explicit archival marker |
| F7 | Working-draft directory `parts/part-2-service/drafts/` (54 draft files) unprotected | MEDIUM | Every file has superseding canonical in `parts/part-2-service/approved/`; 9 approved vs 54 drafts |
| F8 | Working-draft cluster files in `analysis/chapters/` (~14 `*-cluster-*-draft.md` files) unprotected | MEDIUM | Filename marker indicates superseded/working status |
| F9 | Report-assembly directory `reports/` (1 file: `repo-health-report.md`) unprotected | MEDIUM | Per-directory rule; prior report artifact |
| F10 | Usage telemetry dir `usage/` unprotected | MEDIUM | Per-directory rule |
| F11 | Explicit archive file `logs/session-notes-archive-part1.md` (20,449 words / 2,211 lines) present with archive marker but not denied | LOW | Single-file hygiene flag; deny rule would resolve it |
| F12 | Versioned file `output/knowledge-files/1.2-knowledge-file-v2.md` present (implies v1 was superseded) | LOW | `v2` marker per protocol hygiene pattern; check whether v1 still exists in same dir |
| F13 | 54 superseded draft files in `parts/part-2-service/drafts/` (total ~300K+ words) retained alongside canonicals | LOW | Clear superseding versions exist in `parts/part-2-service/approved/` |
| F14 | Revision note file `parts/part-2-service/drafts/2.7-revision-note.md` retained in drafts dir (hygiene marker present) | LOW | Single-file flag |
| F15 | Dated session review file `logs/session-reviews/2026-04-13-what-worked.md` (dated naming pattern) | LOW | Dated variant hygiene marker |
| F16 | Empty skeleton directories retained: `final/modules/`, `research/`, `output/integrated/` | LOW | Empty directories are non-functional clutter but do not cost tokens |
| F17 | `additionalDirectories` setting grants workspace-wide read access with no corresponding `Read(...)` denies at project level | HIGH | `.claude/settings.json` additionalDirectories = `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo`; compounds F1 because Glob/Grep/Read can reach any file in any project directory in the workspace |

## Severity summary

- HIGH: 2 (F1, F17)
- MEDIUM: 9 (F2, F3, F4, F5, F6, F7, F8, F9, F10)
- LOW: 6 (F11, F12, F13, F14, F15, F16)
- **Total findings: 17**

## Boundary notes (per protocol ±15% threshold caveat)

None of the file sizes in the top-20 table fall within ±15% of the protocol's 100-line or 200-line thresholds; every flagged file is well over both (smallest in top-20 = 518 lines; every log file > 1,000 lines). Classification-boundary discount is not needed for this section's evidence.

## Protocol gaps / ambiguity notes

- Protocol Section 6 severity table says "Large data/output files in directories not covered by a `Read(...)` deny → MEDIUM per directory." Applied as one MEDIUM per observed top-level generated-output directory, not per file. Nine MEDIUM findings result (F2–F10).
- Protocol does not define whether `additionalDirectories` compounding warrants a separate finding. Recorded as F17 separately because the workspace-scope leakage is structurally distinct from the project-scope Read-deny absence.
- Protocol's "Yes/No Claude read" rule is binary; some files (e.g., `preparation/research-plans/*.md`) sit between active-context and historical — classified conservatively based on whether they feed ongoing turns (production plans in `context/` = YES; research plans for already-completed execution phases = NO).
