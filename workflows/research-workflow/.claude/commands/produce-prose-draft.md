---
friction-log: true
---
Produce prose draft for: $ARGUMENTS

Convert one Part 2 (or Part 3) decision document into reviewed, decontaminated prose. Chains four skills: decision-to-prose-writing (decision-to-prose-writer), merged review and fix (chapter-prose-reviewer + prose-compliance-qc), cross-section integration check (conditional), and AI prose decontamination (ai-prose-decontamination). Requires architecture to exist (`/produce-architecture` runs first). Output is prose ready for `/produce-formatting`.

Per-section run: 4–5 subagent launches, target ~12–16 min wall time.

Uses `context/prose-quality-standards.md` v3 (13 standards: Standards 10–13 added post-ship — Contrast Discipline, Concrete-Verb Default, Maxim Budget, End on the Point) and the document's `style-reference.md` v2.3+ where available (Governing Voice Test + Plain-Language Register for Non-Native Professional Readers applied). The command passes both files to the Phase 2 writer, the Phase 3 reviewer, and the Phase 5 decontamination agent.

---

## Phase 1 — Plan + style-reference gate (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. Parse $ARGUMENTS to identify the target section (e.g., "2.4", "2.8", "3.1")
2. Locate the source document:
   a. Glob `parts/part-2-service/drafts/{section}*` (or `parts/part-3-strategy/drafts/{section}*` for Part 3 sections)
   b. If matches found: list them, extract the numeric suffix from each filename (e.g., `draft-07` → 7), and select the file with the highest number
   c. If no drafts found: fall back to `parts/part-2-service/approved/{section}*` (or `parts/part-3-strategy/approved/{section}*`)
   d. If neither exists: PAUSE — no source document available
3. Determine paths:
   - Set `part_dir`: Part 2 → `parts/part-2-service/`, Part 3 → `parts/part-3-strategy/`
   - Set `prose_output_dir`: Part 2 → `output/part-2-prose/`, Part 3 → `output/part-3-prose/`
4. **Architecture requirement:** Check that `{prose_output_dir}/architecture.md` exists.
   - **If exists:** read first 50 lines to verify the target section ($ARGUMENTS) appears in the section hierarchy. If covered → proceed. If not covered → PAUSE: "Architecture exists but doesn't cover {section}. Options: regenerate architecture (`/produce-architecture {part}` after deleting current architecture files), or proceed with `architecture-missing` override for this section."
   - **If does not exist:** PAUSE: "Architecture required. Run `/produce-architecture {part}` first to generate it. Or proceed with `architecture-missing` override (downstream prose will be written without depth/seam guidance — not recommended for documents with 2+ sections)."
5. **Style reference gate:** Check if `{prose_output_dir}/style-reference.md` exists.
   - **If exists:** note it — this is the locked style reference. Proceed to Phase 2.
   - **If does not exist:** Run the **first-run style-reference selection sub-flow** below. After operator approves the style reference, **auto-continue to Phase 2 within the same invocation** (no re-call required).
6. Check for existing prose versions in `{prose_output_dir}/{section}-*.md` to understand iteration state. If a previous prose version exists, note it — the new version will be a fresh production, not an edit.

Present the plan: source document path, architecture status (used or missing), style reference status (existing or to-be-generated), output file path. Wait for operator approval before proceeding.

### First-run style-reference selection sub-flow (only on first section)

> Triggered when `{prose_output_dir}/style-reference.md` does not exist.

1. List available style reference templates by globbing `/ai-resources/style-references/*.md`. Present each template with its name, document type description (from the file's header), and typical audience. Ask the operator which template to use, or whether to generate a style reference from scratch.
2. Read the selected template
3. Read the source document identified in step 2 above (for customization context)
4. Customize the template for this document part. Apply the template's Customization Notes section. Adjustments may include: audience specificity, evidence calibration level, domain terminology, or document-specific constraints. Note which template was used and what was changed.
5. Write the customized style reference to `{prose_output_dir}/style-reference.md`
6. PAUSE — present the style reference to the operator for approval. Show the template used and customizations applied. Do not proceed until approved.
7. **Once approved, the style reference is locked. Auto-continue to Phase 2 within the same invocation.** It applies to all subsequent prose production for this document part.

---

## Phase 2 — Decision-to-Prose Conversion [delegate]

1. Read the source document identified in Phase 1
2. Read the style reference at `{prose_output_dir}/style-reference.md`
3. Read `/ai-resources/skills/decision-to-prose-writer/SKILL.md`
4. **Read `context/prose-quality-standards.md`** — this is a project-specific file resolved from the project root (NOT from ai-resources). Preserve this path verbatim and pass the content to the sub-agent. These are writing principles to apply during conversion, not a post-hoc checklist. The agent should internalize the standards and write accordingly, not mechanically verify each one.
5. Launch a general-purpose sub-agent. Pass it:
   - The skill content
   - The source document content
   - The style reference content
   - The prose quality standards content (from `context/prose-quality-standards.md`)
   - Output path: if section begins with "2", write to `output/part-2-prose/{section}-{slug}.md`; if section begins with "3", write to `output/part-3-prose/{section}-{slug}.md` (create directory if needed). Derive slug from the document title, kebab-case.
   - **Architecture specification** (if exists): Read `{prose_output_dir}/architecture.md` and extract the sections relevant to $ARGUMENTS:
     - This section's entry from the section hierarchy (H1/H2/H3 outline, thesis)
     - This section's depth allocation (word count range, priority tier, must-land content)
     - Cross-references involving this section (dependencies, what other sections reference this one)
     - This section's entries from the traceability table (including seam notes)
     - Any structural overrides affecting this section
   - Task:
     1. Execute the decision-to-prose transformation per the skill logic.
     2. Apply the style reference for voice, tone, and editorial standards.
     3. Apply the prose quality standards throughout. **Tier 1 (check first, highest-impact):** Standard 3 (sentence rhythm — short-long pattern; named patterns: triadic cadence, medium-sentence monotony, rhythmic templating), Standard 10 (contrast discipline — "not X, but Y" not as default rhythm), Standard 1 (no self-annotation — including reference-back sentences that label what prior content "does"), Standard 2 (point-first paragraphs). **Tier 2 (check second):** Standard 5 (no preambles), Standard 11 (concrete-verb default — no abstract-noun stacking unless the compound is load-bearing vocabulary), Standard 13 (end on the point, not the pivot — section-final sentences land this section's conclusion, not a gesture to the next section), Standard 7 (land on conclusions — paragraph-level), Standard 8 (formatting discipline). **Tier 3 (check third):** Standard 6 (transitions carry information), Standard 4 (complexity sequencing), Standard 9 (uncertainty handling — including hedge-phrase frequency discipline and the calibration-volume re-frame), Standard 12 (maxim budget — maximum one aphoristic sentence per section). Apply the style-reference Governing Voice Test as a passage-level filter: would an experienced PE operator say this aloud in a strategy meeting? If the phrasing reads as analytical performance rather than analytical work, cut it back. If the document's style-reference includes a Plain-Language Register section (Flagged-Word Registry), apply it during writing — prefer plain alternatives for flagged vocabulary unless the instance matches a named load-bearing carve-out.
     4. If architecture is provided: honor the depth allocation, implement must-land content, respect seam notes from the traceability table, and write transitions consistent with the cross-reference map. The architecture defines this section's role in the whole document — prose should reflect its assigned position and emphasis.
     5. Write the prose file and return: file path, word count, section count, any flags.
6. Write a brief status note (file path, word count) — do not read the full output yet.
7. ▸ /compact — skill content and source document no longer needed in main session.

---

## Phase 3 — Review and Fix [delegate]

Merged diagnostic review (chapter-prose-reviewer) and compliance gate (prose-compliance-qc) in a single pass, followed by conditional fix application.

1. Read the prose file produced in Phase 2
2. Read the source document (for transformation comparison and Degraded mode)
3. Read the style reference at `{prose_output_dir}/style-reference.md`
4. Read `/ai-resources/skills/chapter-prose-reviewer/SKILL.md`
5. Read `/ai-resources/skills/prose-compliance-qc/SKILL.md`
6. **Read `context/prose-quality-standards.md`** — project-specific path resolved from the project root. Preserve verbatim.
7. Launch a qc-reviewer sub-agent. Pass it:
   - The chapter-prose-reviewer skill content (diagnostic framework)
   - The prose-compliance-qc skill content (compliance framework)
   - The prose file content (artifact under review)
   - The source document content (transformation comparison input + Degraded mode input for Scan 3)
   - The style reference content
   - The prose quality standards content (from `context/prose-quality-standards.md`)
   - Adaptation notes (conditional on architecture):
     - **If architecture exists:** "The document architecture spec is available. The chapter-prose-reviewer's §1 (architecture compliance) applies fully. Evaluate the prose against the architecture's depth allocation, must-land content, and structural decisions for this section. For compliance QC: Input 4 is present — Scan 3 runs in Standard mode." Pass the architecture content (extracted sections relevant to $ARGUMENTS, same as Phase 2).
     - **If architecture does not exist:** "The document architecture spec is intentionally absent for this prose pipeline. Override the chapter-prose-reviewer's blocking requirement for this input. Proceed with §2–§5 only; treat §1 as not applicable. Do not halt or request the architecture spec. The 'evidence prose' is a decision document, not claim-ID-organized evidence — use it for transformation quality comparison per §2. §3 Style, §4 Prose Quality, and §5 Completeness apply fully. No architecture spec provided for compliance QC (Input 4 absent — Scan 3 runs in Degraded mode)."
     - The chapter-prose-reviewer skill content serves as anti-pattern reference for compliance QC Scan 1.
     - **Sequencing note:** The diagnostic review (chapter-prose-reviewer) and compliance scans (prose-compliance-qc) run against the same unmodified prose in this merged pass. When running compliance scans, treat findings from the diagnostic review as "pending fixes" — only flag as compliance violations items that would survive after the diagnostic review's recommended fixes are applied. Do not double-count issues the diagnostic already caught.
   - **Anti-scaffolding instruction:** "Do NOT restore cross-reference codes (WH, OQ, DP, section numbers as references), chain-activity anchors, value-chain stage labels used as structural markers, or any scaffolding from the source document. These were intentionally removed during prose conversion. Do NOT flag their absence as a gap or recommend their restoration."
   - **Prose quality checks:** Apply the detection tests from all 13 standards as additional review criteria alongside the skill frameworks, checking in the priority order defined in the violation guide (Tier 1 first: flat rhythm, contrast-template overuse, self-annotation, no paragraph progression; then Tier 2: preambles, abstract-noun stacking, pivot-closings, trailing off, bold in running prose; then Tier 3: transitions, complexity sequencing, uncertainty handling, maxim budget).
   - **Expanded detection tests for Standards 10, 11, 12, 13 (apply explicitly):** (a) **Contrast constructions** — count per section ("not X, but Y", "X is Y, not Z", "not a preference but a constraint" and structural variants); flag if ≥4 in a 1,500-word section. (b) **Abstract-noun compounds** — for any three-noun compound, test whether an actor/verb rewrite would preserve meaning; if yes and the compound is not load-bearing document vocabulary, flag. (c) **Pseudo-maxim sentences** — short (<12 word) aphoristic sentences that function as standalone generalizations; count per section; flag if >1. (d) **Pivot closings** — read the last sentence of each section; if it describes what the next section will do rather than what this section established, flag. (e) **Flagged-vocabulary instances** — if the document's style-reference contains a Plain-Language Register / Flagged-Word Registry, scan the prose against it; flag any instance that is not a load-bearing PE term per the carve-outs named in the registry.
   - The style reference is the file at `{prose_output_dir}/style-reference.md` (the generated/locked reference from Phase 1), not the context file at `context/style-guide.md`.
   - Task: First, run the diagnostic review per chapter-prose-reviewer and produce a score (1-5) and flag report. Then run all four compliance scans per prose-compliance-qc (treating diagnostic findings as pending fixes per the sequencing note). Then apply the 13 prose quality checks — including Standard 6 at paragraph-to-paragraph granularity (not only at section boundaries), and the expanded Standards 10–13 detection tests above. Produce a unified findings list combining all passes, with severity ratings (HIGH/MEDIUM/LOW) and per-spec verdicts.

8. Route on score and findings:
   - **Score 4-5 with only LOW findings:** Note findings. Proceed to Phase 4. No fix agent needed.
   - **Score 4-5 with MEDIUM+ findings:** Launch a general-purpose sub-agent with: the prose file content, the unified findings list, the style reference, the source document, and the anti-scaffolding instruction from the review pass above. Task: apply all non-bright-line fixes and write the corrected file. For bright-line items (multi-paragraph changes, analytical claim alterations, sourced statement modifications): log them and present to the operator. After fixes, proceed to Phase 4.
   - **Score 3 with fewer than 3 HIGH findings:** Same as above — launch fix sub-agent. Present bright-line items and any HIGH findings to the operator before proceeding.
   - **Score 3 with 3+ HIGH findings:** PAUSE — present findings to the operator. Options: re-run Phase 2 with editorial annotations addressing the failures, or proceed with fix sub-agent.
   - **Score 1-2:** PAUSE — present findings to the operator. The prose conversion has failed. Options: re-run Phase 2 with editorial annotations addressing the failures, or override and proceed.

9. Write a brief Phase 3 handoff note for the main session: the score, the unified findings list (severity + one-line description per finding), which findings were auto-fixed, and which are deferred as bright-line items requiring operator review. This note feeds Phase 6 (handoff). (Write this note to main session context before compacting — it must survive the compact.)

10. ▸ /compact — skill content and source document no longer needed.

---

## Phase 4 — Integration Check [delegate] (conditional)

> **Condition:** Only runs if other completed prose sections exist in `{prose_output_dir}` (i.e., this is not the first section being converted). If this is the first section, skip to Phase 5.

This phase catches cross-section issues that single-section review cannot detect: transition quality at section boundaries and redundancy/contradiction between independently written sections.

1. Glob `{prose_output_dir}/*.md` to find all completed prose sections. Exclude non-prose files by name: `architecture.md`, `architecture-qc.md`, `style-reference.md`, `decontamination-log.md`. The remaining files are prose sections.
2. If no other prose sections exist: skip this phase entirely, proceed to Phase 5
3. Read the current section's prose file (post-Phase 3 fixes)
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
   - **No findings:** Note clean pass. Proceed to Phase 5.
   - **Transition drafts only:** Present drafts to the operator. The operator decides which to incorporate. Apply approved transitions to the prose file. (Transition passages of 1–3 sentences are not bright-line items. If a transition draft exceeds one paragraph, apply the bright-line rule check before inserting.) Proceed to Phase 5.
   - **Redundancy/contradiction findings:** Present all findings to the operator. SUBSTANTIVE findings require a decision before proceeding — the operator chooses which section to adjust, or accepts the repetition. NON-SUBSTANTIVE findings are noted for future reference. Proceed to Phase 5 after the operator reviews.
   - **Note:** Redundancy/contradiction fixes that require changes to *other* sections (not the current one) are logged to `logs/decisions.md` as cross-section revision notes, not applied directly. Only the current section's prose is modified in this phase.

9. ▸ /compact — adjacent section content no longer needed.

---

## Phase 5 — AI Prose Decontamination [delegate, sonnet]

Removes AI writing patterns (ornamental language, repetition, over-argumentation, flat rhythm) from substantively correct prose. Runs four sequential passes that progressively clean the voice without changing analytical content.

> **Condition:** Always runs. Skip only if the operator explicitly opts out during Phase 1 planning or Phase 3 review.

1. Read the prose file (post-Phase 3 fixes, or post-Phase 4 if 4 ran)
2. Read the style reference at `{prose_output_dir}/style-reference.md`
3. Read `context/prose-quality-standards.md` — this is a project-specific file resolved from the project root (NOT from ai-resources). Preserve this path verbatim — do not generalize.
4. Read the source document identified in Phase 1 (if available after compaction — if not, proceed without and note in the handoff)
5. Read `/ai-resources/skills/ai-prose-decontamination/SKILL.md`
6. Launch a general-purpose sub-agent with `model: "sonnet"` (pattern-based task, analytical judgment not required). Pass it:
   - The skill content
   - The prose file content
   - The style reference content
   - The prose quality standards content
   - The source document content (if available)
   - Output path: same file (explicit overwrite — this command owns the file-versioning contract; the skill's standalone default of writing to a new path does not apply here)
   - Change log output path: `{prose_output_dir}/decontamination-log.md`
   - Task: Execute all four decontamination passes per the skill logic, including the five named sub-patterns (1a contrast-template overuse, 1b abstract-noun stacking, 1c Flagged-Word Registry application, 2a pivot closings, 4a pseudo-maxim budget) the skill carries natively. Write the corrected prose file. Write the change log to the log output path. Return: change counts per pass and per sub-pattern, any bright-line flags, and any passages where decontamination was constrained by style reference or evidence calibration preservation.
   - **Bright-line rule override for Phase 5:** The decontamination pass is exempt from the multi-paragraph scope check (bright-line check 1) because it operates across the entire document by design. Checks 2 and 3 still apply: if any change alters an analytical claim or modifies a sourced statement, the sub-agent must flag it in the bright-line-flags section of the change log and must NOT apply that change. If bright-line flags are populated, the main agent PAUSEs for operator approval before proceeding.
7. Route on result:
   - **Zero bright-line flags:** Proceed to Phase 6 (handoff) automatically.
   - **Bright-line flags present:** PAUSE — present flags to the operator. Apply or discard per operator decision, then proceed to Phase 6.
   - **Zero changes across all passes:** Note "Prose already clean — no decontamination needed." Proceed to Phase 6.
8. Write Phase 5 handoff note: total changes, per-pass breakdown, any bright-line flags and their disposition, any constrained passages.
9. ▸ /compact — skill content and source document no longer needed.

---

## Phase 6 — Handoff (main session)

1. Read the post-decontamination prose file
2. Present to the operator:
   - **Source file path used** + draft number + final word count
   - **Phase 3 review score (1–5)** + critical findings (HIGH severity)
   - **Cross-section integration check summary** (from Phase 4, if it ran): transitions added, redundancy/contradiction findings and their disposition
   - **Decontamination log path** + per-pass change summary (from Phase 5). Full log available at `{prose_output_dir}/decontamination-log.md`.
   - **Architecture compliance notes** (if architecture was used): depth allocation honored, must-land content implemented, seam notes implemented
   - **Bright-line items deferred for operator decision** (any unresolved items from Phases 3, 4, or 5)
3. Suggest next step:
   - **Standard path:** "Run `/produce-formatting {section}` to apply formatting, H3 placement, and document-level integration QC."
   - **If unresolved bright-line items:** "Resolve flagged items first (apply or discard per your decision), then run `/produce-formatting {section}`."
