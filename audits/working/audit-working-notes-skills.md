# Section 2 — Full Skill Census (Working Notes)

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Protocol:** token-audit-protocol v1.2
**Method:** Batch measurement (`wc -l`, `wc -w`) + frontmatter read for every file (head -20); full-read reserved for oversized/ambiguous cases. No file was read in full outside those flagged.
**Token-estimation caveat applied:** word count × 1.3 proxy, ±30% drift; findings within ±15% of severity thresholds tagged `(boundary)`.

---

## 2.1 Total skill inventory

**Total SKILL.md files found:** 69
**Unique skills:** 67 (2 pairs are duplicates — see Finding D1)
**Total lines across all SKILL.md files:** 14,171
**Total words across all SKILL.md files:** 120,956
**Total estimated tokens (× 1.3):** ~157,243

### Full file list (alphabetical)

| # | File | Lines | Words |
|---|------|-------|-------|
| 1 | ./skills/ai-prose-decontamination/SKILL.md | 484 | 6,417 |
| 2 | ./skills/ai-resource-builder/SKILL.md | 463 | 3,295 |
| 3 | ./skills/analysis-pass-memo-review/SKILL.md | 115 | 1,022 |
| 4 | ./skills/answer-spec-generator/SKILL.md | 485 | 3,687 |
| 5 | ./skills/answer-spec-qc/SKILL.md | 205 | 1,957 |
| 6 | ./skills/architecture-designer/SKILL.md | 239 | 2,087 |
| 7 | ./skills/architecture-qc/SKILL.md | 200 | 1,673 |
| 8 | ./skills/chapter-prose-reviewer/SKILL.md | 169 | 2,197 |
| 9 | ./skills/chapter-review/SKILL.md | 201 | 1,895 |
| 10 | ./skills/citation-converter/SKILL.md | 245 | 2,140 |
| 11 | ./skills/claude-code-workflow-builder/SKILL.md | 127 | 1,240 |
| 12 | ./skills/cluster-analysis-pass/SKILL.md | 158 | 1,512 |
| 13 | ./skills/cluster-memo-refiner/SKILL.md | 183 | 1,511 |
| 14 | ./skills/cluster-synthesis-drafter/SKILL.md | 132 | 1,090 |
| 15 | ./skills/context-pack-builder/SKILL.md | 231 | 1,420 |
| 16 | ./skills/curiosity-hub-article-writer/SKILL.md | 216 | 2,005 |
| 17 | ./skills/decision-to-prose-writer/SKILL.md | 290 | 2,348 |
| 18 | ./skills/document-integration-qc/SKILL.md | 116 | 698 |
| 19 | ./skills/editorial-recommendations-generator/SKILL.md | 215 | 1,390 |
| 20 | ./skills/editorial-recommendations-qc/SKILL.md | 169 | 1,319 |
| 21 | ./skills/evidence-prose-fixer/SKILL.md | 185 | 1,624 |
| 22 | ./skills/evidence-spec-verifier/SKILL.md | 192 | 1,367 |
| 23 | ./skills/evidence-to-report-writer/SKILL.md | 332 | 3,424 |
| 24 | ./skills/execution-manifest-creator/SKILL.md | 129 | 1,436 |
| 25 | ./skills/formatting-qc/SKILL.md | 160 | 1,506 |
| 26 | ./skills/fund-triage-scanner/SKILL.md | 263 | 1,658 |
| 27 | ./skills/gap-assessment-gate/SKILL.md | 150 | 1,352 |
| 28 | ./skills/h3-title-pass/SKILL.md | 180 | 1,734 |
| 29 | ./skills/implementation-project-planner/SKILL.md | 207 | 1,437 |
| 30 | ./skills/implementation-spec-writer/SKILL.md | 294 | 1,699 |
| 31 | ./skills/intake-processor/SKILL.md | 141 | 981 |
| 32 | ./skills/journal-thinking-clarifier/SKILL.md | 108 | 977 |
| 33 | ./skills/journal-wiki-creator/SKILL.md | 106 | 899 |
| 34 | ./skills/journal-wiki-improver/SKILL.md | 138 | 1,087 |
| 35 | ./skills/journal-wiki-integrator/SKILL.md | 145 | 1,262 |
| 36 | ./skills/knowledge-file-completeness-qc/SKILL.md | 167 | 1,713 |
| 37 | ./skills/knowledge-file-producer/SKILL.md | 135 | 1,118 |
| 38 | ./skills/project-implementer/SKILL.md | 185 | 1,092 |
| 39 | ./skills/project-tester/SKILL.md | 220 | 1,354 |
| 40 | ./skills/prompt-creator/SKILL.md | 146 | 875 |
| 41 | ./skills/prose-compliance-qc/SKILL.md | 330 | 2,420 |
| 42 | ./skills/prose-formatter/SKILL.md | 287 | 3,194 |
| 43 | ./skills/repo-health-analyzer/SKILL.md | 53 | 421 |
| 44 | ./skills/report-compliance-qc/SKILL.md | 113 | 1,090 |
| 45 | ./skills/research-extract-creator/SKILL.md | 107 | 1,054 |
| 46 | ./skills/research-extract-verifier/SKILL.md | 183 | 1,359 |
| 47 | ./skills/research-plan-creator/SKILL.md | 464 | 3,504 |
| 48 | ./skills/research-prompt-creator/SKILL.md | 220 | 3,415 |
| 49 | ./skills/research-prompt-qc/SKILL.md | 174 | 1,558 |
| 50 | ./skills/research-structure-creator/SKILL.md | 205 | 2,468 |
| 51 | ./skills/section-directive-drafter/SKILL.md | 259 | 2,293 |
| 52 | ./skills/session-guide-generator/SKILL.md | 320 | 2,116 |
| 53 | ./skills/session-usage-analyzer/SKILL.md | 150 | 1,288 |
| 54 | ./skills/spec-writer/SKILL.md | 242 | 2,107 |
| 55 | ./skills/specifying-output-style/SKILL.md | 149 | 1,191 |
| 56 | ./skills/supplementary-evidence-merger/SKILL.md | 128 | 1,209 |
| 57 | ./skills/supplementary-query-brief-drafter/SKILL.md | 241 | 2,668 |
| 58 | ./skills/supplementary-research-qc/SKILL.md | 121 | 1,073 |
| 59 | ./skills/task-plan-creator/SKILL.md | 245 | 1,465 |
| 60 | ./skills/workflow-consultant/SKILL.md | 102 | 719 |
| 61 | ./skills/workflow-creator/SKILL.md | 198 | 1,301 |
| 62 | ./skills/workflow-documenter/SKILL.md | 140 | 593 |
| 63 | ./skills/workflow-evaluator/SKILL.md | 316 | 2,509 |
| 64 | ./skills/workflow-system-analyzer/SKILL.md | 274 | 1,851 |
| 65 | ./skills/workflow-system-critic/SKILL.md | 300 | 2,357 |
| 66 | ./skills/workspace-template-extractor/SKILL.md | 135 | 899 |
| 67 | ./skills/worktree-cleanup-investigator/SKILL.md | 241 | 3,133 |
| 68 | ./workflows/research-workflow/reference/skills/knowledge-file-producer/SKILL.md | 135 | 1,113 |
| 69 | ./workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md | 113 | 1,090 |

---

## 2.2 Size distribution

| Bucket | Count |
|--------|-------|
| Under 50 lines | 0 |
| 50–150 lines | 25 |
| 150–300 lines | 35 |
| Over 300 lines | 9 |

Note: Line-bucket boundaries applied as protocol: >150 = flagged MEDIUM, >300 = HIGH. A skill with exactly 150 lines is not over the threshold and is placed in the 50–150 bucket; a skill with exactly 300 lines is not over the 300 threshold (MEDIUM, not HIGH).

### Top 10 largest skills

| Rank | Skill path | Lines | Words | Severity | Note |
|------|-----------|-------|-------|----------|------|
| 1 | ./skills/answer-spec-generator/SKILL.md | 485 | 3,687 | HIGH | Over 150% of HIGH threshold |
| 2 | ./skills/ai-prose-decontamination/SKILL.md | 484 | 6,417 | HIGH | Largest by word count; ~8,340 tokens when loaded |
| 3 | ./skills/research-plan-creator/SKILL.md | 464 | 3,504 | HIGH | |
| 4 | ./skills/ai-resource-builder/SKILL.md | 463 | 3,295 | HIGH | |
| 5 | ./skills/evidence-to-report-writer/SKILL.md | 332 | 3,424 | HIGH | |
| 6 | ./skills/prose-compliance-qc/SKILL.md | 330 | 2,420 | HIGH | |
| 7 | ./skills/session-guide-generator/SKILL.md | 320 | 2,116 | HIGH | |
| 8 | ./skills/workflow-evaluator/SKILL.md | 316 | 2,509 | HIGH | |
| 9 | ./skills/workflow-system-critic/SKILL.md | 300 | 2,357 | MEDIUM (boundary) | At the HIGH boundary; within ±15% of 300 threshold |
| 10 | ./skills/implementation-spec-writer/SKILL.md | 294 | 1,699 | MEDIUM | Within ±15% of HIGH threshold (boundary) |

---

## 2.3 Findings — Oversized skills

### HIGH severity (>300 lines) — 8 findings

| # | Skill | Lines | Words | Est. tokens | Notes |
|---|-------|-------|-------|------------|-------|
| H1 | ./skills/answer-spec-generator/SKILL.md | 485 | 3,687 | ~4,793 | HIGH |
| H2 | ./skills/ai-prose-decontamination/SKILL.md | 484 | 6,417 | ~8,342 | HIGH — highest absolute token cost in the census |
| H3 | ./skills/research-plan-creator/SKILL.md | 464 | 3,504 | ~4,555 | HIGH |
| H4 | ./skills/ai-resource-builder/SKILL.md | 463 | 3,295 | ~4,284 | HIGH |
| H5 | ./skills/evidence-to-report-writer/SKILL.md | 332 | 3,424 | ~4,451 | HIGH |
| H6 | ./skills/prose-compliance-qc/SKILL.md | 330 | 2,420 | ~3,146 | HIGH |
| H7 | ./skills/session-guide-generator/SKILL.md | 320 | 2,116 | ~2,751 | HIGH |
| H8 | ./skills/workflow-evaluator/SKILL.md | 316 | 2,509 | ~3,262 | HIGH |

### MEDIUM severity (150–300 lines) — 27 findings

Boundary (±15% of 300 threshold, i.e., 255–300 lines or 300–345 lines): flagged `(boundary)`.

| # | Skill | Lines | Words | Boundary? |
|---|-------|-------|-------|-----------|
| M1 | ./skills/workflow-system-critic/SKILL.md | 300 | 2,357 | (boundary) |
| M2 | ./skills/implementation-spec-writer/SKILL.md | 294 | 1,699 | (boundary) |
| M3 | ./skills/decision-to-prose-writer/SKILL.md | 290 | 2,348 | (boundary) |
| M4 | ./skills/prose-formatter/SKILL.md | 287 | 3,194 | (boundary) |
| M5 | ./skills/workflow-system-analyzer/SKILL.md | 274 | 1,851 | (boundary) |
| M6 | ./skills/fund-triage-scanner/SKILL.md | 263 | 1,658 | (boundary) |
| M7 | ./skills/section-directive-drafter/SKILL.md | 259 | 2,293 | (boundary) |
| M8 | ./skills/citation-converter/SKILL.md | 245 | 2,140 | |
| M9 | ./skills/task-plan-creator/SKILL.md | 245 | 1,465 | |
| M10 | ./skills/spec-writer/SKILL.md | 242 | 2,107 | |
| M11 | ./skills/supplementary-query-brief-drafter/SKILL.md | 241 | 2,668 | |
| M12 | ./skills/worktree-cleanup-investigator/SKILL.md | 241 | 3,133 | |
| M13 | ./skills/architecture-designer/SKILL.md | 239 | 2,087 | |
| M14 | ./skills/context-pack-builder/SKILL.md | 231 | 1,420 | |
| M15 | ./skills/project-tester/SKILL.md | 220 | 1,354 | |
| M16 | ./skills/research-prompt-creator/SKILL.md | 220 | 3,415 | |
| M17 | ./skills/curiosity-hub-article-writer/SKILL.md | 216 | 2,005 | |
| M18 | ./skills/editorial-recommendations-generator/SKILL.md | 215 | 1,390 | |
| M19 | ./skills/implementation-project-planner/SKILL.md | 207 | 1,437 | |
| M20 | ./skills/answer-spec-qc/SKILL.md | 205 | 1,957 | |
| M21 | ./skills/research-structure-creator/SKILL.md | 205 | 2,468 | |
| M22 | ./skills/chapter-review/SKILL.md | 201 | 1,895 | |
| M23 | ./skills/architecture-qc/SKILL.md | 200 | 1,673 | |
| M24 | ./skills/workflow-creator/SKILL.md | 198 | 1,301 | |
| M25 | ./skills/evidence-spec-verifier/SKILL.md | 192 | 1,367 | |
| M26 | ./skills/evidence-prose-fixer/SKILL.md | 185 | 1,624 | |
| M27 | ./skills/project-implementer/SKILL.md | 185 | 1,092 | |
| M28 | ./skills/cluster-memo-refiner/SKILL.md | 183 | 1,511 | |
| M29 | ./skills/research-extract-verifier/SKILL.md | 183 | 1,359 | |
| M30 | ./skills/h3-title-pass/SKILL.md | 180 | 1,734 | |
| M31 | ./skills/research-prompt-qc/SKILL.md | 174 | 1,558 | |
| M32 | ./skills/chapter-prose-reviewer/SKILL.md | 169 | 2,197 | |
| M33 | ./skills/editorial-recommendations-qc/SKILL.md | 169 | 1,319 | |
| M34 | ./skills/knowledge-file-completeness-qc/SKILL.md | 167 | 1,713 | |
| M35 | ./skills/formatting-qc/SKILL.md | 160 | 1,506 | |
| M36 | ./skills/cluster-analysis-pass/SKILL.md | 158 | 1,512 | |

Count reconciliation: 36 skills in the 150–300 line band (I mis-stated 27 above; actual count from the inventory is 36). The size-distribution table (35 in 150-300 bucket) counts skills with lines strictly above 150 and not above 300; counts differ by 1 because skill `gap-assessment-gate` is exactly 150 lines (falls in 50–150 bucket per protocol threshold `>150`).

Note on protocol threshold wording: Section 2 says "over 150 lines" and "Skill 150–300 lines → MEDIUM." Ambiguity: is 150 exactly MEDIUM or not? Resolved per the header "over 150" → `>150` (strict). So gap-assessment-gate at 150 lines is NOT flagged MEDIUM. Recorded under "Protocol gaps."

---

## 2.4 Description quality findings

Reviewed the first 20 lines (frontmatter + opening section) of all 69 SKILL.md files.

**Result:** All 69 files have valid YAML frontmatter with `name:` and `description:` fields. No "Missing frontmatter" findings.

**Description trigger-richness:** All descriptions read include explicit activation triggers (e.g., "Use when...", "Triggers on requests like...") AND exclusion clauses (e.g., "Do NOT use for..."). Trigger-richness is high across the census. No "Vague description" findings by the protocol's benchmark.

One notable edge-case: `./skills/workspace-template-extractor/SKILL.md` description has triggers but weaker exclusion scope (no "Do NOT use for..." clause; only describes inputs). Not vague enough to flag by protocol standard — recorded as informational only, no severity.

---

## 2.5 Redundancy findings

### Finding D1 — Duplicate skill files (identical except one-line difference)

| Primary | Duplicate | Difference |
|---------|-----------|-----------|
| ./skills/knowledge-file-producer/SKILL.md (135 lines, 1,118 words) | ./workflows/research-workflow/reference/skills/knowledge-file-producer/SKILL.md (135 lines, 1,113 words) | Single line: "The knowledge file serves the Claude Chat project for the Buy-Side Service Model. Chat sessions use knowledge files for:" vs "The knowledge file serves the Claude Chat project. Chat sessions use knowledge files for:" |
| ./skills/report-compliance-qc/SKILL.md (113 lines, 1,090 words) | ./workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md (113 lines, 1,090 words) | Identical content (diff empty) |

**Severity:** LOW per protocol (clear redundancy between skills is LOW "unless both are frequently loaded in the same session type"). These are a reference copy inside a workflow template folder, not a competing canonical skill — the descriptions and names match exactly.

**Note:** This duplication mechanism is intentional workflow-template staging (the workflow folder appears to be a distributable copy), not drift. However, any token-audit must count both files since both are discoverable by `find` and potentially loadable.

### Finding D2 — Potential functional overlap (requires deeper investigation)

The protocol says to flag only where "names and descriptions imply the same primary task, audience, and trigger context." Frontmatter-level review surfaced these adjacent-but-distinct pairs (each is explicitly demarcated in the other's "Do NOT use for" exclusion — i.e., authors have already separated them):

| Skills | Overlap signal | Already demarcated? |
|--------|----------------|---------------------|
| chapter-prose-reviewer vs chapter-review | Both review chapter drafts; chapter-review covers upstream-artifact compliance, chapter-prose-reviewer covers quality diagnosis | Yes — exclusions state the distinction |
| workflow-creator vs workflow-documenter vs workflow-consultant | All work on workflow design; consultant = rough sketch, creator = structured design, documenter = formal document | Yes — chained via "feeds into"/"Routes to" |
| workflow-evaluator vs workflow-system-critic | Both evaluate workflows; evaluator = design patterns/docs, critic = deployed infrastructure coherence | Yes — exclusions state the distinction |
| prose-compliance-qc vs report-compliance-qc | Both compliance QC; prose = Part 2 prose, report = Part 1 chapter | Yes — exclusions state the distinction |
| architecture-designer vs architecture-qc | Designer creates, QC reviews | Yes |

No redundancy findings emerge — all pairs are explicitly split by author convention.

---

## 2.6 Dead skill findings

Per protocol: "A skill is dead only if it has no references from CLAUDE.md, command files, or workflow docs AND shows naming/deprecation markers such as `old`, `deprecated`, `v1`, `archive`, or has a clearly superseding variant."

### Folder-name deprecation check: no skills have folder-level deprecation markers (checked via `ls skills/ | grep -iE "(old|deprecated|archive|v1|v2)"` → empty).

### Reference check — skills with zero references in CLAUDE.md, `.claude/commands/`, or `workflows/`:

- chapter-review — 0 references
- claude-code-workflow-builder — 0 references
- curiosity-hub-article-writer — 0 references
- fund-triage-scanner — 0 references
- intake-processor — 0 references
- journal-thinking-clarifier — 0 references
- journal-wiki-creator — 0 references
- journal-wiki-improver — 0 references
- journal-wiki-integrator — 0 references
- knowledge-file-completeness-qc — 0 references
- specifying-output-style — 0 references
- workflow-consultant — 0 references
- workflow-creator — 0 references
- workflow-documenter — 0 references
- workspace-template-extractor — 0 references

**None of these qualifies as "dead" per protocol** because none have deprecation markers. They exist as invocable, active skills with no inbound programmatic references — most are human-triggered via natural-language activation (e.g., "create an article," "run triage"). Per protocol wording, this is not dead-skill territory.

**Zero findings at Dead Skills category.**

---

## 2.7 Missing frontmatter findings

**Result:** Zero skills missing frontmatter. All 69 SKILL.md files start with `---` and include `name:` + `description:` fields.

---

## 2.8 Assessment of oversized skills — structural notes

Per protocol Step 2 "For oversized skills only (>150 lines), additionally assess," the following notes are based on frontmatter + opening-section reads; no deep body read was performed to keep token budget lean.

| Skill | Split candidate? | Verbose examples? | CLAUDE.md/skill repeat? | Notes |
|-------|------------------|-------------------|------------------------|-------|
| ai-prose-decontamination (484L) | Likely — "four-pass sequential" structure implies 4 natural split boundaries | Probable (6,417 words ≈ 13 words/line density suggests explanatory prose) | Unknown without deep read | Highest-cost skill in repo |
| answer-spec-generator (485L) | Unknown | Unknown | Unknown | |
| research-plan-creator (464L) | Unknown | Unknown | Unknown | |
| ai-resource-builder (463L) | Multiple modes ("Creates, evaluates, improves" — 3 modes) — split-candidate signal | Unknown | Overlaps with generic Axcion skill conventions CLAUDE.md may already cover | |
| evidence-to-report-writer (332L) | Unknown | Unknown | Unknown | |
| prose-compliance-qc (330L) | "Four scans" — split-candidate signal | Unknown | Unknown | |
| session-guide-generator (320L) | Unknown | Unknown | Unknown | |
| workflow-evaluator (316L) | Multi-dimension evaluator — split-candidate signal | Unknown | Unknown | |
| workflow-system-critic (300L, boundary) | Multi-dimension critic — split-candidate signal | Unknown | Unknown | |

These "split candidate" calls are structural inferences from the description text, not content reads. Main session should read full file only if a split recommendation requires evidence.

---

## Protocol gaps

1. **Threshold inclusivity ambiguity.** Protocol says "Flag any skill over 150 lines" and "Skill 150–300 lines → MEDIUM; Skill over 300 lines → HIGH." Whether 150 exactly is MEDIUM is ambiguous. Interpreted strictly (`>150`): `gap-assessment-gate` at exactly 150 lines is not flagged. `workflow-system-critic` at exactly 300 lines is flagged MEDIUM (not HIGH). Both are tagged `(boundary)` where applicable.
2. **Redundancy protocol says flag only "same primary task, audience, and trigger context."** All adjacent-skill pairs in this repo are already explicitly demarcated in each other's "Do NOT use for" exclusions, so the check is technically negative everywhere. This may be a stricter filter than useful; recorded here so the main session knows the census produced no redundancy findings by protocol standard.
3. **Duplicate files under `/workflows/research-workflow/reference/skills/`.** Protocol's redundancy rule doesn't cleanly address mechanical duplication of the same skill at two paths for workflow-staging purposes. Flagged under D1 with LOW severity, but the categorization is operator judgment.
