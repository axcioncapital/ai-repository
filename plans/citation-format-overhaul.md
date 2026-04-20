# Plan — Citation Format Overhaul (ai-resources)

**Status:** DRAFT — awaiting operator approval
**Scope:** Shared skill library + project CLAUDE.md
**Blast radius:** Affects every project that invokes citation-converter and evidence-to-report-writer. Treat as workspace-level change, not project-level.

## Context

Doc 1 was reformatted on 2026-04-20 from the old citation model (global `## Bibliography`, middle-dot-chained superscripts `¹˒²˒³`, full bibliography entries with bold author + italic title + URL + date) to the Final Version model (per-module `## Sources` blocks, space-separated superscripts `¹ ² ³`, compressed org/author labels). The reformat was a post-hoc fix, not a format change at source — which means every future document will still ship in the old format unless the canonical skill spec is updated.

The old format is specified in exactly two places:

1. `ai-resources/skills/citation-converter/references/instruction-a.md` (authoritative spec for footnote rendering)
2. `ai-resources/skills/citation-converter/SKILL.md` (self-check items + structural references that echo instruction-a)

Plus one project-level alignment:

3. `projects/buy-side-service-plan/CLAUDE.md` § "Citation Conversion Rule" — uses stale "bibliography" vocabulary.

## Intended outcome

After this change, Claude Code, when invoked on any new drafting → QC → citation conversion cycle, produces cited prose whose format matches the Final Version reference example natively — no post-hoc reformat required.

## Scope

### In scope (this plan)

- Rewrite citation-converter's output format spec (Instruction A only; Instruction B is inline attribution, unaffected).
- Update citation-converter SKILL.md to align vocabulary, self-check items, and cross-references.
- Update project CLAUDE.md's Citation Conversion Rule to match new vocabulary.
- Add positive enforcement in at least one QC skill (formatting-qc or chapter-prose-reviewer) to catch drift.

### Out of scope (separate work)

- **Reformatting existing Doc 2 / Doc 3 / Part 1 chapters (1.1–1.4 chapter-cited files).** These still use the old format. Decision deferred — operator may want them reformatted in a batch, or left as-is if they've already shipped to stakeholders. Flag as a follow-up question at plan approval.
- **Instruction B (inline attribution).** Different output mode; does not use the superscript-plus-bibliography structure. No changes needed unless operator wants parallel treatment.
- **Evidence-to-report-writer citation-during-drafting path.** Citation-converter's SKILL.md claims evidence-to-report-writer can apply citations during initial writing. If it does, its format rules need the same edits. Plan's Phase 2 verifies whether evidence-to-report-writer actually emits citations in its current form — if yes, add it to the edit set; if no, skip.
- **Backward compatibility shim.** Old-format documents remain readable; no need to make the new format backward-compatible with the old renderer.

## Edits required

### File 1 — `ai-resources/skills/citation-converter/references/instruction-a.md`

**Current state:** 57 lines specifying footnote numbering, placement, bibliography entry format.

**Changes:**

1. **Placement rules (line 12).** Multi-source example changes from `¹˒³` to `¹ ³` (space-separated, not middle-dot-chained). Add explicit rule: "When a single statement cites multiple sources, separate the superscripts with regular spaces. Do not use middle-dot `˒` or commas between them."

2. **Replace the entire `## Bibliography` section (lines 25–39) with `## Sources`** specifying:
   - **Heading:** `## Sources` exactly. Do not use `Bibliography`, `References`, `Works Cited`, or any other name.
   - **Placement:** One `## Sources` block per H1 module, placed immediately after that module's last paragraph/table, separated by `---` on its own line. Not at the end of the document. Not per-subsection.
   - **Format:** Compact inline index on a single line, entries separated by ` · ` (space + U+00B7 middle dot + space).
     - Example: `¹ Source A · ² Source B · ³ Source C`
   - **Per-entry label:** Organization name or author surname(s) only. No titles, quotation marks, italics, URLs, publication dates, access dates, paywall annotations (`[preview only]` is NOT carried over into the compressed label — paywall status is recorded in the Source Registry working artifact only), or quality flags.
     - Single org: `McKinsey & Company`
     - Multi-author joint work: semicolon-separated surnames, e.g., `Harris; Jenkinson; Kaplan`
     - Org variants / successor entities: slash, e.g., `Invest Europe / EDC`
     - Proxies / sources-of-sources: parenthetical, e.g., `Copenhagen Economics (for SVCA)`, `S&P Global Market Intelligence (citing Preqin)`
     - Multi-source concatenations (one citation backed by several distinct sources): semicolon-joined, e.g., `SSE Dissertation; Sampford Advisors; Private Equity Professional`
   - **Numbering:** Section-local. Each module's `## Sources` block numbers entries `1..N` in order of first appearance in that module's prose. Numbering resets at each H1 module.
   - **Duplicate labels allowed within a module.** If two distinct bibliography entries both compress to the same org label (e.g., two separate McKinsey reports), list both entries at their respective local numbers — do not dedupe. The label can repeat; the entry numbers are distinct.
   - **Unused entries dropped.** If a source appears in the evidence pack but is never cited in a given module's prose, it does not appear in that module's `## Sources` block.
   - **Cross-module references.** When a citation in module B's prose references a source that was already cited in module A, module B's `## Sources` block gets its own entry for that source at module B's local number. Module A's block keeps its own entry. The same source can appear in multiple modules' blocks.
   - **Placement at table boundaries.** When a module's last content element is a table, insert `---` on its own line immediately after the table's last row, with no blank line between the table and the `---`. Then the `## Sources` block. This handling matches the handling for last-element paragraphs.
   - **Re-run / preserve-existing-superscripts.** If the prose entering citation-converter already contains superscript citations that resolve correctly against the new section-local source list (i.e., each in-prose superscript maps to an entry in that module's Sources block at the same local number), preserve them as-is. Do not renumber for the sake of renumbering. Renumber a module's citations only when: (a) the current numbering contradicts first-appearance order within the module, (b) uncited entries need to be dropped and doing so leaves gaps in the sequence, or (c) the module does not yet have a Sources block and one must be created. This protects Rule 1c (preserve existing source-number mapping unless renumbering is required by section-local logic) in fix-pass and re-run scenarios.

3. **Footnote-to-Source Mapping Table (lines 42–52).** Keep as internal traceability aid — part of the Traceability Layer, not the published document. But clarify: the mapping is per-module under the new model.

4. **Update self-check items in SKILL.md** (see File 2).

### File 2 — `ai-resources/skills/citation-converter/SKILL.md`

**Changes:**

1. **Line 70** ("Bibliography/Sources Consulted cover its contents") — update to "Sources blocks cover its contents".

2. **Line 158** (Output Structure Traceability Layer section header `### Bibliography`) — update to `### Sources (published) + Source Registry (internal)`. Clarify: the Sources blocks are the published artifact; the Source Registry is the working artifact that maps registry IDs to module-local numbers per module.

3. **Quality Self-Check (lines 211–232).** Rewrite these four items:
   - `- [ ] Footnote numbers are per unique source, not per claim (A)` → `- [ ] Sources numbering is per-module and per-unique-source — each module's block numbers in first-appearance order starting at 1`
   - `- [ ] Bibliography contains no duplicate sources (A)` → `- [ ] Within a module's Sources block, duplicate labels are allowed (two distinct sources with the same compressed label); duplicate registry IDs are not`
   - `- [ ] Bibliography entries contain no quality flags or supplementary tags (A)` → keep, rename to `Sources block entries`
   - `- [ ] Bibliography entries use Unicode superscript, bold author, italic title (A)` → replace with `- [ ] Sources block entries use compressed labels only — no titles, italics, bold, URLs, or dates`

4. **Add new self-check items:**
   - `- [ ] Each H1 module has its own ## Sources block placed after its last content paragraph, separated by ---`
   - `- [ ] No global ## Bibliography or ## References block exists`
   - `- [ ] Source numbering resets at each H1 module, starting at 1 in first-appearance order`
   - `- [ ] Multi-source superscripts are space-separated (¹ ² ³), not middle-dot-chained (¹˒²˒³)`

5. **Edge Cases (lines 234–246).** Add AND replace:
   - **REPLACE line 237** (`**Same source in multiple sections:** Reuse the source's existing footnote number (A). Note all sections in Claim-to-Source Map.`) with:
     `**Cross-module citation:** A source cited in module A and also in module B gets its own entry in each module's Sources block at that module's local number. The compressed label is identical across modules; the local numbers differ. This is the normal case under the section-local model, not a duplication defect. If two distinct sources from the same org are both cited cross-module, both appear in each module's Sources block with identical labels but different local numbers — this is expected and not a defect. The Source Registry (working artifact) tracks the shared registry ID across modules.`
   - Add: `**Unused evidence pack entries:** Sources present in evidence but never cited in prose do not appear in any Sources block. They appear only in the Source Registry (working artifact).`

6. **Scale Guidance (line 192) — REPLACE contradicting rule.** Current: `"Pass the full Traceability Layer (File 2) plus the working Source Registry from the previous section as Input 5. The new section extends them — adding new registry entries, claim mappings, and bibliography entries while preserving existing ones. Source numbering continues sequentially."`
   Replace the final sentence with: `"Source numbering resets at 1 for each H1 module in its published Sources block. The Source Registry (working artifact) accumulates registry IDs across sections for traceability (S01, S02... continuing globally — registry IDs do NOT reset at module boundaries; only the published Sources block's local numbering resets). Each module's Sources block uses its own independent local numbering derived from first-appearance order in that module's prose."`
   **Rationale:** This is the single most load-bearing edit. "Source numbering continues sequentially" is a concrete operational instruction in a named procedure section that will override the abstract self-check items in Quality Self-Check. Without this edit, multi-section runs produce global sequential numbering regardless of the other changes — the entire per-module reset intent fails silently.

7. **Quality Self-Check line 231 — REPLACE.** Current: `- [ ] Bibliography entries separated by blank lines (A)`. Replace with: `- [ ] Sources block entries are on a single line separated by ` · ` (space + U+00B7 middle dot + space); no blank lines between entries; no bold, italic, quotation marks, URLs, or dates in labels`.
   **Rationale:** Blank-line separation is incompatible with the single-line compact inline format. If left in place, self-check fires a false failure on every correctly-formatted run.

8. **Quality Self-Check line 219 — ANNOTATE.** Current: `- [ ] Date format consistent: MM/YYYY / year-only / "c. YYYY" / "n.d." (A)`. Replace with: `- [ ] Date format consistent in the Source Registry (working artifact): MM/YYYY / year-only / "c. YYYY" / "n.d." (A). Dates do NOT appear in the published ## Sources block — labels are org/author only.`

9. **Output Structure template (line 159) — align.** Current code-block label: `[Per Instruction A or Sources Consulted per Instruction B]`. Update to: `[Per Instruction A: compact inline Sources block — see references/instruction-a.md. Per Instruction B: Sources Consulted as inline attribution.]`

### File 3 — `projects/buy-side-service-plan/CLAUDE.md` § "Citation Conversion Rule"

**Current (line 37–39):**
> Every cited chapter file must include a complete bibliography listing all sources cited in that chapter. Never substitute a note like "sources listed in other modules" or "no new sources introduced." Even if every source was introduced in a prior module, the bibliography must reproduce the relevant entries. Each chapter is a self-contained cited artifact.

**Replace with:**
> Every cited chapter file must include its own `## Sources` block listing all sources cited in that chapter. Never substitute a note like "sources listed in other modules" or "no new sources introduced." Even if every source was introduced in a prior module, the chapter's Sources block must reproduce the relevant entries at its own local numbering. Each chapter is a self-contained cited artifact.

Rule intent is unchanged; vocabulary aligns to the new format.

### File 4 — `ai-resources/skills/formatting-qc/SKILL.md` — update existing checks AND add new ones

**Host decision:** formatting-qc (not chapter-prose-reviewer). Rationale: citation format is a formatting compliance concern, not prose quality. chapter-prose-reviewer has no existing citation scope and adding it there would be scope expansion. This is a pre-decided choice, not an open operator decision.

**Update Check 4 "Footnote Integrity":** current check says `"Footnote numbering is sequential and unbroken throughout the module (1, 2, 3... not 1, 3, 4 or 1, 2, 2)"`. Under the new format this is wrong in both name and logic — numbering resets per-section, so "sequential and unbroken throughout the module" would flag correct new-format output as defective.
- Rename heading: `Footnote Integrity` → `Sources Block Integrity`
- Replace the sequential-unbroken rule with: `Each H1 module has exactly one ## Sources block. Within each block, numbering starts at 1 and is sequential and unbroken. Numbering resets at each module boundary (it does NOT continue sequentially across modules).`
- Update the "No footnotes present — N/A" output line to `No Sources blocks present — N/A`
- Update any severity-tier references to "sequential footnote errors" to "sequential Sources block numbering errors"

**Add new checks (alongside the renamed Check 4):**

1. Exactly one `## Sources` block per H1 module, placed after the module's last content line, separated by `---`. When the last content is a table, the `---` sits on its own line immediately after the table's final row (no blank line between table and divider).
2. No global `## Bibliography` or `## References` block anywhere in the document.
3. Every superscript citation number in a module's prose has a corresponding entry in that module's `## Sources` block (and every entry is cited at least once in that module's prose).
4. No `˒` middle-dot separator appears anywhere in prose (use space between multi-citation superscripts).
5. Separator within Sources blocks is ` · ` (space + U+00B7 middle dot + space); no commas, no pipes.
6. Source labels contain no titles, italics, quotation marks, bold, URLs, or dates — org/author name only, with documented exceptions for multi-author (semicolon-separated), org variants (slash), and proxies (parenthetical).

## Execution sequence

1. **[Phase 0 — verification]** (a) Read evidence-to-report-writer SKILL.md to check whether it emits citations directly (not just claim IDs) — if yes, add it to the edit set. (b) Read the full citation-converter SKILL.md top-to-bottom and flag any additional rule that contradicts the updated instruction-a.md spec. This is an internal-consistency audit, not just a downstream-dependency check — the QC pass on this plan surfaced two such contradictions (Scale Guidance line 192 and Edge Cases line 237) and they are the single most load-bearing edits in the set.
2. **[Phase 1 — edits]** Apply File 1, File 2 (all nine sub-edits), File 3, File 4 edits.
3. **[Phase 2 — QC]** Run claude-md-auditor or qc-reviewer subagent on the edited citation-converter spec. Verify:
   - Self-consistency (SKILL.md matches instruction-a.md)
   - Coverage of all rules from the Doc 1 reformat task (the 6 numbered rules the operator gave)
   - No contradictions with Final Version reference behavior
4. **[Phase 3 — regression check]** Re-read Doc 1 (now in the new format) and confirm the updated spec would have produced its output natively. If not, the spec is still incomplete.
5. **[Phase 4 — commit]** Single commit to ai-resources (and a separate commit to the project CLAUDE.md, since it's in a different directory).

## Risk and reversibility

- **Risk: downstream drift.** Any skill that cross-references citation-converter's output format assumptions needs to stay in sync. Mitigation: Phase 0 audit. Known downstream skills that might reference: evidence-to-report-writer, chapter-prose-reviewer, document-integration-qc, formatting-qc, ai-prose-decontamination. Worth a grep for "superscript", "bibliography", "˒", "footnote" across all skill SKILL.md files as a sanity pass.

- **Risk: existing artifact inconsistency.** Doc 2 and Doc 3 in the buy-side project still use the old format. After this change, a new drafting pass on those documents would emit the new format — creating an intra-project inconsistency where Doc 1 = new format, Doc 2/3 = old format. Decision required before this plan executes: (a) reformat Doc 2/3 to match Doc 1, (b) leave Doc 2/3 on old format and accept the inconsistency, (c) defer Doc 2/3 reformat until their next natural edit cycle.

- **Risk: Part 1 chapter files.** Report chapters for sections 1.1–1.4 in `report/chapters/` also use the old format. Same decision as Doc 2/3.

- **Reversibility:** Full. All edits are in git, so `git revert` reverses the change. The old format spec can be restored from HEAD before commit.

## Open decisions for operator before execution

1. **Backfill scope.** Reformat existing Doc 2, Doc 3, and Part 1 chapters to match the new format? Options: (a) now, as a batch, (b) opportunistically when those documents are next edited, (c) never, accept inconsistency.
2. **Instruction B.** Does inline attribution (Instruction B, used for client-facing output) need an analogous overhaul, or is its current spec fine?

(QC host is pre-decided: formatting-qc. See File 4.)

## Rule coverage check (against the original Doc 1 reformat prompt)

The six numbered rules from the original operator prompt, mapped to the plan edits that cover each. Every rule is covered by at least two edits (the positive spec in instruction-a.md plus enforcement in SKILL.md / formatting-qc).

| Rule | What it requires | Covered by |
|---|---|---|
| 1a — superscript numerics only | Unicode superscript, not bracketed / parenthetical | instruction-a.md line 7 (existing, retained); formatting-qc new Check on notation |
| 1b — space-separated multi-citations | `¹ ² ³` not `¹˒²˒³` | instruction-a.md line 12 edit; SKILL.md new self-check on space-separated superscripts; formatting-qc new Check on `˒` absence |
| 1c — preserve existing mapping unless section-local renumbering requires change | Re-run / fix-pass scenarios preserve superscripts | instruction-a.md Edit 2 new Edge Case on Re-run / preserve-existing-superscripts (added during second QC pass) |
| 2 — `## Sources` label, no `Bibliography` | Exact heading | instruction-a.md replacement of `## Bibliography` section; SKILL.md line 70, 158, and self-check rewrites; project CLAUDE.md vocabulary update; formatting-qc new Check on no global Bibliography |
| 3 — compressed labels, no titles/italics/URLs/dates, `·` separator | Single-line compact inline index with `·` | instruction-a.md Per-entry label + label-shape rules; SKILL.md self-check line 231 replacement (single-line compact); formatting-qc new Check on separator + label content |
| 4 — per-H1 placement with `---` divider, not global | Block after each module's last content line | instruction-a.md Placement rule; SKILL.md new self-check on per-module placement; SKILL.md Edge Cases line 237 replacement (cross-module behavior); formatting-qc new Check on one block per H1 |
| 5 — section-local block, per-section renumbering, drop uncited | Each block contains only its own module's cited sources, renumbered 1..N | instruction-a.md Numbering + Unused entries dropped + Cross-module references rules; SKILL.md Scale Guidance replacement (line 192) — the load-bearing edit; SKILL.md Edge Cases line 237 replacement; formatting-qc Check 4 rewrite (Sources Block Integrity) |
| 6 — structural match to Final Version | Aggregate visual/structural parity | All edits in aggregate; Phase 3 regression check re-reads Doc 1 and confirms the updated spec would have produced its output natively |

**Two rules with the highest failure risk if specific edits are skipped:**
- **Rule 5** (per-section renumbering) depends critically on SKILL.md line 192 edit. Without it, "Source numbering continues sequentially" overrides the reset behavior in multi-section runs.
- **Rule 4 + 5** (section-local independence) depends on SKILL.md line 237 edit. Without it, the "reuse existing footnote number" Edge Case directly instructs the opposite of per-module independent entries.

These two edits were added to File 2 during the QC pass. If they weren't caught, the plan's other edits would execute and future documents would still fail Rules 4 and 5 on multi-module runs.

## Verification

After Phase 2 QC passes, the test is: given the same inputs that produced Doc 1's old format, would the updated citation-converter now emit Final-Version-style output directly? Confirm by:
- Reading the final instruction-a.md and SKILL.md side-by-side with the Final Version reference.
- Spot-checking five rules from Doc 1's reformat task against the updated spec — each should map to a specific line or self-check item.
- Running citation-converter in Mode 1 (dry run, no operator release) on a small prose fragment with claim IDs and confirming the output renders as `## Sources` with compact inline index.

If any of those fail, the spec is incomplete and Phase 1 edits need revision before commit.
