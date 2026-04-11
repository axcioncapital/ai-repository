---
friction-log: true
---
Produce prose for: $ARGUMENTS

Convert a Part 2 (or Part 3) decision document into polished, formatted narrative prose. Chains up to eight skills across ten phase steps: document architecture creation (research-structure-creator), architecture QC (architecture-qc), decision-to-prose writing (decision-to-prose-writer), merged review and fix (chapter-prose-reviewer + prose-compliance-qc), cross-section integration check, merged formatting + H3 titles (prose-formatter + h3-title-pass), formatting QC (formatting-qc), and editorial integration QC (document-integration-qc). The architecture phase runs once per document part and produces a unified document structure; subsequent calls for individual sections detect the existing architecture and skip to prose conversion.

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. Parse $ARGUMENTS to identify the target section (e.g., "2.4", "2.8")
2. Locate the source document:
   a. Glob `parts/part-2-service/drafts/{section}*` (or `parts/part-3-strategy/drafts/{section}*` for Part 3 sections)
   b. If matches found: list them, extract the numeric suffix from each filename (e.g., `draft-07` → 7), and select the file with the highest number
   c. If no drafts found: fall back to `parts/part-2-service/approved/{section}*` (or `parts/part-3-strategy/approved/{section}*`)
   d. If neither exists: PAUSE — no source document available
3. Determine the document part from $ARGUMENTS:
   - Parse part number ("2.4" → Part 2, "3.1" → Part 3)
   - Set `part_dir`: Part 2 → `parts/part-2-service/`, Part 3 → `parts/part-3-strategy/`
   - Set `prose_output_dir`: Part 2 → `output/part-2-prose/`, Part 3 → `output/part-3-prose/`
4. Check for existing architecture:
   - Check if `{prose_output_dir}/architecture.md` exists
   - **If exists:** read first 50 lines, verify the target section ($ARGUMENTS) appears in the section hierarchy
     - If target section is covered → note "Architecture found — skipping Phases 2–3"
     - If target section is NOT covered → PAUSE: architecture exists but doesn't cover this section. Options: regenerate architecture with updated inputs, or proceed without architecture for this section.
   - **If does not exist:** note "No architecture found — Phases 2–3 will run. This session will produce the architecture and stop. Prose conversion will happen in a subsequent `/produce-prose` call."
   - **Staleness check:** If architecture exists, compare its section list against currently available drafts and approved files in `{part_dir}`. If new sections exist that aren't in the architecture, flag: "Architecture may be stale — new sections found: [list]. Options: regenerate architecture or proceed with current." To regenerate: delete `{prose_output_dir}/architecture.md` and `{prose_output_dir}/architecture-qc.md`, then re-run `/produce-prose {section}`. The session will run Phases 2–3 and stop, as with a first-time architecture creation.
5. If architecture is needed, inventory all available drafts:
   - Glob `{part_dir}/drafts/*` and `{part_dir}/approved/*`
   - For each section found: select the highest-numbered draft (same logic as step 2, applied to all sections). Fall back to approved/ if no drafts exist for a section.
   - **Minimum check:** If fewer than 2 sections have available content, skip Phases 2–3 with note: "Architecture requires 2+ sections. Proceeding without architecture."
   - Present the full draft inventory to the operator: which sections have drafts (with draft number), which have approved versions only, which are missing entirely
6. Check if a style reference exists at `{prose_output_dir}/style-reference.md`
   - If it exists: note it — this is the locked style reference for all prose in this document part
   - If it does not exist: flag this — Phase 4 will ask the operator to select a template from `/ai-resources/style-references/`, customize it, and lock it before prose production begins.
7. Check for existing prose versions in `{prose_output_dir}/` to understand iteration state
8. If a previous prose version exists, note it — the new version will be a fresh production, not an edit

Present the plan: which source document will be converted (and whether it comes from drafts/ or approved/), architecture status (exists / will be created / skipped), draft inventory if architecture is needed, which style reference applies (existing or to-be-generated), output file path. If architecture is needed, note that this session will produce the architecture and stop — prose conversion will happen in a subsequent `/produce-prose` call. Wait for the operator's approval before proceeding.

---

## Phase 2 — Document Architecture [delegate] (conditional)

> **Condition:** Only runs if `{prose_output_dir}/architecture.md` does not exist AND 2+ sections are available. If skipped, proceed to Phase 4.

1. Read all section drafts identified in Phase 1 step 5 (highest-numbered draft per section, or approved/ fallback)
2. Read `context/project-brief.md` (document purpose + audience)
3. Read `context/content-architecture.md` (section specs + dependency sequence)
4. Read `/ai-resources/skills/research-structure-creator/SKILL.md`
5. Launch a general-purpose sub-agent. Pass it:
   - The skill content
   - All section draft content (labeled by section ID)
   - Document purpose and audience statement (extracted from project-brief.md)
   - The content architecture's Part 2 (or Part 3) section showing dependency sequence and content type per section
   - Adaptation notes:
     - "Drafter's notes are not available for these sections. The decision documents were produced in a Chat environment and transferred without drafter's notes. Proceed without them per the skill's gap-handling rule."
     - "These are decision documents, not independently-drafted prose chapters. They contain structured decisions, design rationale, and strategic arguments rather than narrative prose. Apply the Content Inventory phase to extract the decision content and structural logic from each section."
     - "Override the skill's Phase 1-2 gate. Run all three phases end-to-end and produce the complete architecture specification. The operator will review the finished architecture."
   - Output path: `{prose_output_dir}/architecture.md`
   - Task: Execute the full 3-phase workflow of the research-structure-creator skill. Produce the complete architecture specification including: section hierarchy, depth allocation with must-land content, cross-reference map, front/back matter decisions, traceability table with seam notes, and structural override log. Write to output path. Return: section count, processing order, flagged overlaps/conflicts/gaps, word count allocations per section.
6. Write a brief Phase 2 handoff note: architecture file path, section count, processing order, any flags.
7. ▸ /compact — skill content and raw draft content no longer needed in main session.

---

## Phase 3 — Architecture QC [delegate-qc] (conditional)

> **Condition:** Runs when architecture exists but has not yet passed QC. This covers two cases: (a) immediately after Phase 2 created the architecture, or (b) when `{prose_output_dir}/architecture.md` exists but `{prose_output_dir}/architecture-qc.md` does not (e.g., after fixing a failed QC). If both files exist and the QC report shows PASS, skip this phase.

1. Read `/ai-resources/skills/architecture-qc/SKILL.md`
2. Read the architecture at `{prose_output_dir}/architecture.md`
3. Read all section drafts (same set as Phase 2 — needed for traceability verification)
4. Launch a qc-gate sub-agent. Pass it:
   - The skill content
   - The architecture content
   - All section draft content
   - Adaptation notes for absent Part 2/3 inputs:
     - "Input 2 (Scarcity register): N/A for Part 2/3 sections. These do not go through the research pipeline. No scarcity register exists. Mark criterion 11 (Scarcity register coverage) as N/A."
     - "Input 3 (Section directives): N/A. Part 2/3 sections are designed in Chat and transferred as decision documents. No section directives exist from a section-directive-drafter skill. However, the content architecture at `context/content-architecture.md` contains section-level output specs and dependency information. Use these as a proxy for criterion 13 (Section directives alignment). Compare the architecture's depth allocation against the content architecture's section descriptions for reasonableness, but do not expect word count ranges to match since none were specified."
     - "Input 4 (Approved editorial recommendations): N/A for Part 2/3. No editorial recommendations were generated. Mark criterion 12 (Editorial recommendations honored) as N/A."
     - "Criterion 14 (Style reference lock): The style reference for Part 2/3 prose is managed by the produce-prose command at `{prose_output_dir}/style-reference.md`, not by the architecture. Mark criterion 14 as N/A."
   - Output path: `{prose_output_dir}/architecture-qc.md`
   - Task: Evaluate the architecture against all 14 criteria per the skill logic. For criteria with absent inputs, apply the adaptation notes above (N/A where specified). Produce the QC report with PASS/FAIL per criterion and overall verdict.
5. Route on verdict:
   - **PASS:** Present architecture summary + QC result to the operator. **Session ends here.** Note: "Architecture complete and QC passed. Re-run `/produce-prose {section}` to begin prose conversion."
   - **FAIL with critical findings:** PAUSE — present failures to the operator. Architecture must be fixed before prose conversion can begin. Options: fix specific items in the architecture and re-run QC, or override and proceed. To re-run QC after fixing: delete `{prose_output_dir}/architecture-qc.md` and re-run `/produce-prose {section}`. Phase 1 will detect the architecture exists and skip Phase 2, but Phase 3 will re-run because the QC file is absent.
6. ▸ /compact — skill content and draft content no longer needed.

---

## Phase 4 — Decision-to-Prose Conversion [delegate]

> **Condition:** Only runs if architecture already exists (detected in Phase 1) or architecture was skipped (fewer than 2 sections). Does NOT run in the same session as Phases 2–3.

### If no style reference exists (first section only)

1. List available style reference templates by globbing `/ai-resources/style-references/*.md`. Present each template with its name, document type description (from the file's header), and typical audience. Ask the operator which template to use, or whether to generate a style reference from scratch.
2. Read the selected template
3. Read the source document (for customization context)
4. Customize the template for this document part. Apply the template's Customization Notes section. Adjustments may include: audience specificity, evidence calibration level, domain terminology, or document-specific constraints. Note which template was used and what was changed.
5. Write the customized style reference to `{prose_output_dir}/style-reference.md`
6. PAUSE — present the style reference to the operator for approval. Show the template used and customizations applied. Do not proceed until approved.
7. Once approved, the style reference is locked. It applies to all subsequent prose production for this document part.

### Prose production (all sections)

1. Read the source document identified in Phase 1
2. Read the style reference at `{prose_output_dir}/style-reference.md`
3. Read `/ai-resources/skills/decision-to-prose-writer/SKILL.md`
4. Launch a general-purpose sub-agent. Pass it:
   - The skill content
   - The source document content
   - The style reference content
   - Output path: if section begins with "2", write to `output/part-2-prose/{section}-{slug}.md`; if section begins with "3", write to `output/part-3-prose/{section}-{slug}.md` (create directory if needed). Derive slug from the document title, kebab-case.
   - The prose quality standards at `context/prose-quality-standards.md` (read and pass content to the sub-agent). These are writing principles to apply during conversion — not a post-hoc checklist. The agent should internalize the standards and write accordingly, not mechanically verify each one.
   - **Architecture specification** (if exists): Read `{prose_output_dir}/architecture.md` and extract the sections relevant to $ARGUMENTS:
     - This section's entry from the section hierarchy (H1/H2/H3 outline, thesis)
     - This section's depth allocation (word count range, priority tier, must-land content)
     - Cross-references involving this section (dependencies, what other sections reference this one)
     - This section's entries from the traceability table (including seam notes)
     - Any structural overrides affecting this section
   - Task: execute the decision-to-prose transformation per the skill logic. Apply the style reference for voice, tone, and editorial standards. Apply the prose quality standards throughout — particularly standards 3 (sentence rhythm — the short-long pattern), 1 (no self-annotation), and 2 (point-first paragraphs), which are the Tier 1 priorities per the violation guide, plus standard 5 (no preambles) and 7 (land on conclusions). If architecture is provided: honor the depth allocation, implement must-land content, respect seam notes from the traceability table, and write transitions consistent with the cross-reference map. The architecture defines this section's role in the whole document — prose should reflect its assigned position and emphasis. Write the prose file and return: file path, word count, section count, any flags.
5. Write a brief status note (file path, word count) — do not read the full output yet.
6. ▸ /compact — skill content and source document no longer needed in main session.

---

## Phase 5 — Review and Fix [delegate]

Merged diagnostic review (chapter-prose-reviewer) and compliance gate (prose-compliance-qc) in a single pass, followed by conditional fix application.

1. Read the prose file produced in Phase 4
2. Read the source document (for transformation comparison and Degraded mode)
3. Read the style reference at `{prose_output_dir}/style-reference.md`
4. Read `/ai-resources/skills/chapter-prose-reviewer/SKILL.md`
5. Read `/ai-resources/skills/prose-compliance-qc/SKILL.md`
6. Launch a qc-reviewer sub-agent. Pass it:
   - The chapter-prose-reviewer skill content (diagnostic framework)
   - The prose-compliance-qc skill content (compliance framework)
   - The prose file content (artifact under review)
   - The source document content (transformation comparison input + Degraded mode input for Scan 3)
   - The style reference content
   - Adaptation notes (conditional on architecture):
     - **If architecture exists:** "The document architecture spec is available. The chapter-prose-reviewer's §1 (architecture compliance) applies fully. Evaluate the prose against the architecture's depth allocation, must-land content, and structural decisions for this section. For compliance QC: Input 4 is present — Scan 3 runs in Standard mode." Pass the architecture content (extracted sections relevant to $ARGUMENTS, same as Phase 4).
     - **If architecture does not exist:** "The document architecture spec is intentionally absent for this prose pipeline. Override the chapter-prose-reviewer's blocking requirement for this input. Proceed with §2–§5 only; treat §1 as not applicable. Do not halt or request the architecture spec. The 'evidence prose' is a decision document, not claim-ID-organized evidence — use it for transformation quality comparison per §2. §3 Style, §4 Prose Quality, and §5 Completeness apply fully. No architecture spec provided for compliance QC (Input 4 absent — Scan 3 runs in Degraded mode)."
     - The chapter-prose-reviewer skill content serves as anti-pattern reference for compliance QC Scan 1.
     - **Sequencing note:** The diagnostic review (chapter-prose-reviewer) and compliance scans (prose-compliance-qc) run against the same unmodified prose in this merged pass. When running compliance scans, treat findings from the diagnostic review as "pending fixes" — only flag as compliance violations items that would survive after the diagnostic review's recommended fixes are applied. Do not double-count issues the diagnostic already caught.
   - **Anti-scaffolding instruction:** "Do NOT restore cross-reference codes (WH, OQ, DP, section numbers as references), chain-activity anchors, value-chain stage labels used as structural markers, or any scaffolding from the source document. These were intentionally removed during prose conversion. Do NOT flag their absence as a gap or recommend their restoration."
   - **Prose quality checks:** Read `context/prose-quality-standards.md` and pass the content to the sub-agent. Apply the detection tests from all 9 standards as additional review criteria alongside the skill frameworks, checking in the priority order defined in the violation guide (Tier 1 first: flat rhythm, self-annotation, no paragraph progression; then Tier 2; then Tier 3).
   - The style reference is the file at `{prose_output_dir}/style-reference.md` (the generated/locked reference from Phase 4), not the context file at `context/style-guide.md`.
   - Task: First, run the diagnostic review per chapter-prose-reviewer and produce a score (1-5) and flag report. Then run all four compliance scans per prose-compliance-qc (treating diagnostic findings as pending fixes per the sequencing note). Then apply the 9 prose quality checks — including Standard 6 at paragraph-to-paragraph granularity (not only at section boundaries). Produce a unified findings list combining all passes, with severity ratings (HIGH/MEDIUM/LOW) and per-spec verdicts.

7. Route on score and findings:
   - **Score 4-5 with only LOW findings:** Note findings. Proceed to Phase 6. No fix agent needed.
   - **Score 4-5 with MEDIUM+ findings:** Launch a general-purpose sub-agent with: the prose file content, the unified findings list, the style reference, the source document, and the anti-scaffolding instruction (repeated: "Do NOT restore cross-reference codes, chain-activity anchors, value-chain stage labels, or scaffolding. Do NOT flag their absence as a gap."). Task: apply all non-bright-line fixes and write the corrected file. For bright-line items (multi-paragraph changes, analytical claim alterations, sourced statement modifications): log them and present to the operator. After fixes, proceed to Phase 6.
   - **Score 3:** Same as above — launch fix sub-agent. Present bright-line items and any HIGH findings to the operator before proceeding.
   - **Score 1-2:** PAUSE — present findings to the operator. The prose conversion has failed. Options: re-run Phase 4 with editorial annotations addressing the failures, or override and proceed.

8. Write a brief Phase 5 handoff note for the main session: the score, the unified findings list (severity + one-line description per finding), which findings were auto-fixed, and which are deferred as bright-line items requiring operator review. This note feeds Phase 7. (Write this note to main session context before compacting — it must survive the compact.)

9. ▸ /compact — skill content and source document no longer needed.

---

## Phase 5b — Integration Check [delegate] (conditional)

> **Condition:** Only runs if other completed prose sections exist in `{prose_output_dir}` (i.e., this is not the first section being converted). If this is the first section, skip to Phase 6.

This phase catches cross-section issues that single-section review cannot detect: transition quality at section boundaries and redundancy/contradiction between independently written sections.

1. Glob `{prose_output_dir}/*.md` to find all completed prose sections. Exclude non-prose files by name: `architecture.md`, `architecture-qc.md`, `style-reference.md`. The remaining files are prose sections.
2. If no other prose sections exist: skip this phase entirely, proceed to Phase 6
3. Read the current section's prose file (post-Phase 5 fixes)
4. Read the architecture at `{prose_output_dir}/architecture.md` (if exists) — specifically the cross-reference map and processing order, to identify which sections are adjacent to and dependent on the current section
5. Read adjacent sections' prose files — "adjacent" means the sections immediately before and after this section in the architecture's processing order. If no architecture exists, use section numbering order.
6. Read all other completed prose sections (non-adjacent) — for redundancy/contradiction checking. For large document parts (6+ completed sections), read only the opening and closing paragraphs of non-adjacent sections to manage context size.
7. Launch a general-purpose sub-agent. Pass it:
   - The current section's prose content (labeled with section ID)
   - Adjacent sections' prose content (labeled with section IDs and position: "preceding" / "following")
   - Non-adjacent sections' prose content (labeled, full or excerpted per step 6)
   - Architecture cross-reference map and seam notes for this section (if architecture exists)
   - The style reference content
   - Task: Run two focused checks:

     **A. Transitions** — Examine the boundary between this section and each adjacent section:
     - Does this section's opening connect to the preceding section's conclusion?
     - Does this section's conclusion set up the following section's opening?
     - If architecture seam notes exist for these boundaries, are they implemented?
     - For each weak or missing transition: draft a transition passage (1–3 sentences), labeled `[TRANSITION DRAFT — Section X.X to Y.Y]`. Indicate whether the draft belongs at the end of the preceding section or the start of the current section.

     **B. Redundancy & Contradiction** — Compare this section against all other completed prose:
     - Same conclusion or argument restated across sections without cross-reference
     - Same statistic, data point, or claim stated with different figures or framing
     - Same concept explained in multiple sections without acknowledgment
     - For each finding: location in both sections, description, severity (SUBSTANTIVE if it affects credibility or creates confusion, NON-SUBSTANTIVE if minor repetition)

     Return: transition drafts (if any), redundancy/contradiction findings (if any), and a clean-pass note if no issues found.

8. Route on findings:
   - **No findings:** Note clean pass. Proceed to Phase 6.
   - **Transition drafts only:** Present drafts to the operator. the operator decides which to incorporate. Apply approved transitions to the prose file. (Transition passages of 1–3 sentences are not bright-line items. If a transition draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 6.
   - **Redundancy/contradiction findings:** Present all findings to the operator. SUBSTANTIVE findings require a decision before proceeding — the operator chooses which section to adjust, or accepts the repetition. NON-SUBSTANTIVE findings are noted for future reference. Proceed to Phase 6 after the operator reviews.
   - **Note:** Redundancy/contradiction fixes that require changes to *other* sections (not the current one) are logged to `logs/decisions.md` as cross-section revision notes, not applied directly. Only the current section's prose is modified in this phase.

9. ▸ /compact — adjacent section content no longer needed.

---

## Phase 6 — Formatting + H3 Titles [delegate, sonnet]

### Phase 6a — Formatting and H3 Placement

1. Read the prose file (post-review — the version after Phase 5 fixes, if any were applied)
2. Read `/ai-resources/skills/prose-formatter/SKILL.md`
3. Read `/ai-resources/skills/h3-title-pass/SKILL.md`
4. Read the style reference at `{prose_output_dir}/style-reference.md`
5. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The prose-formatter skill content
   - The h3-title-pass skill content
   - The prose file content
   - The style reference content
   - Output path: same file (overwrite — override the prose-formatter skill's versioning default; intermediate files are not needed)
   - Task: Execute in this order:
     1. Run all formatting operations per the prose-formatter skill (bold/italic, lists, tables, paragraph length, horizontal rules, spacing). Write the formatted file.
     2. Then run H3 title pass Step 1 only (placement) per the h3-title-pass skill. Add H3 titles where needed. Do NOT run Step 2 (refinement) yet.
     3. Return: formatting change log (per-operation summary), H3 verdict table (each H3 with placement rationale and KEEP/RENAME/REMOVE recommendation), and any flagged items.

6. Present the H3 verdict table to the operator. the operator may override individual verdicts (keep a heading the agent wants to remove, rename a heading, etc.).

### Phase 6b — H3 Refinement

7. Launch a general-purpose sub-agent with `model: "sonnet"`. Pass it:
   - The h3-title-pass skill content
   - The prose file content (post-formatting, post-placement from 6a)
   - The style reference content
   - Any operator overrides from the verdict review
   - Output path: same file (overwrite — no intermediate versioning needed)
   - Task: Apply H3 title pass Step 2 (refinement) per the skill logic, incorporating operator overrides. Write the final file and return: final H3 count, any renames applied.

8. ▸ /compact — skill content no longer needed.

---

### Phase 6c — Formatting QC [delegate-qc]

1. Read the prose file (post-H3 refinement — the final formatted version)
2. Read `/ai-resources/skills/formatting-qc/SKILL.md`
3. Read the style reference at `{prose_output_dir}/style-reference.md`
4. Collect from Phase 6a: the formatting change log and any deferred/flagged items
5. Launch a qc-reviewer sub-agent. Pass it:
   - The formatting-qc skill content
   - The prose file content
   - The formatting change log from Phase 6a
   - The style reference content
   - Any deferred items list (items flagged during formatting that should not be re-flagged)
   - Task: Run all four checks per the formatting-qc skill (formatting integrity, visual rhythm, standalone coherence, footnote integrity). Produce the QC report with findings grouped by check, severity rated per finding.
6. Route on findings:
   - **No findings or NON-SUBSTANTIVE only:** Note results. Proceed to Phase 7.
   - **SUBSTANTIVE findings:** Present to the operator. Fixes that are mechanical (broken list structure, missing table caption, orphaned sentence fragment) are applied directly to the prose file — these do not trigger the bright-line rule since they are formatting corrections, not content changes. Fixes that affect standalone coherence (missing orientation, vague cross-references) may involve adding prose — apply the bright-line rule for these. Proceed to Phase 6d after fixes.
7. ▸ /compact — skill content no longer needed.

---

### Phase 6d — Editorial Integration QC [delegate-qc]

Second-pass evaluation of the formatted module using the document-integration-qc skill. Where Phase 6c checks formatting mechanics, this pass checks editorial quality: narrative structure (does each section end with an implication?), internal consistency (tone, register, sentence complexity drift), redundancy and contradiction within the module, and completeness (undefined terms, scanability). Produces transition drafts where transitions are weak.

1. Read the prose file (post-Phase 6c fixes)
2. Read `/ai-resources/skills/document-integration-qc/SKILL.md`
3. Read the architecture at `{prose_output_dir}/architecture.md` (if exists) — provides document structure context for completeness checks
4. Launch a qc-reviewer sub-agent. Pass it:
   - The skill content
   - The prose file content
   - Module identifier: "{section ID} — {section title}" and position in the document (e.g., "Section 2.4 of 9 in Part 2"). Derive position from the architecture's processing order if available, otherwise from section numbering.
   - The architecture content (if exists) — as optional document architecture input for completeness checks
   - Adaptation notes:
     - "This module has already passed prose quality review (Phase 5), formatting (Phase 6a-b), and formatting QC (Phase 6c). Focus on editorial-level issues that those passes do not cover: narrative arc, internal consistency, redundancy/contradiction, and completeness."
     - "Do not re-flag items from the formatting change log's deferred list or from Phase 6c's findings. Phase 5b (Integration Check) has already run against other completed prose sections — do not re-flag redundancy or contradiction issues that were identified and addressed in Phase 5b. Focus redundancy/contradiction checks on issues internal to this module only."
     - "The `RELEASE ARTIFACT` protocol in the skill is overridden — produce the full QC report directly."
   - Task: Run all four check categories per the skill (Narrative Structure, Consistency, Redundancy & Contradiction, Completeness). Draft transition passages where transitions are weak. Produce the QC report with findings and transition drafts.
5. Route on findings:
   - **No SUBSTANTIVE findings:** Note results and any NON-SUBSTANTIVE items. Proceed to Phase 7.
   - **SUBSTANTIVE findings without transition drafts:** Present findings to the operator. Apply bright-line rule — SUBSTANTIVE narrative or consistency issues likely require prose changes. Proceed to Phase 7 after the operator reviews.
   - **Transition drafts produced:** Present transition drafts to the operator. the operator decides which to incorporate. Approved transitions are inserted into the prose file. (Transition passages of 1–3 sentences are not bright-line items. If a transition draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 7.
   - **Findings that suggest issues in other sections:** Log to `logs/decisions.md` as cross-section revision notes per the existing cross-section rule. Do not modify other sections' prose.
6. ▸ /compact — skill content no longer needed.

---

## Phase 7 — Review (main session)

1. Read the final formatted prose file
2. Present to the operator:
   - Word count and section structure
   - Review pass score and unified findings addressed (from Phase 5)
   - Any trade-offs: bright-line items deferred, cross-spec tensions
   - H3 titles added/renamed (from Phase 6)
   - Formatting changes summary (from Phase 6a), formatting QC results (from Phase 6c), and editorial integration QC results (from Phase 6d)
   - Architecture compliance notes (if architecture was used: whether depth allocation was honored, must-land content implemented)
   - Integration check results (from Phase 5b): transitions added, redundancy/contradiction findings and their disposition
   - Any flagged items still unresolved
3. Offer next steps:
   - **Review** — the operator reads and gives feedback for a targeted revision
   - **QC** — run `/content-review` on the prose
   - **Challenge** — run `/challenge` for strategic evaluation
   - **Service design review** — run `/service-design-review` for fund-experiential evaluation
   - **Accept** — prose is ready for its intended use
