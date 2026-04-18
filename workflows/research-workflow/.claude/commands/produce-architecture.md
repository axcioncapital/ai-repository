---
friction-log: true
---
Produce document architecture for: $ARGUMENTS

Generate a unified document architecture from a Part 2 (or Part 3) document's section drafts. Chains two skills: document architecture creation (research-structure-creator) and architecture QC (architecture-qc). Architecture is generated once per document part and serves as the structural input to `/produce-prose-draft` for individual section conversion. The architecture file (`{prose_output_dir}/architecture.md`) and its QC verdict (`{prose_output_dir}/architecture-qc.md`) persist on disk; subsequent invocations detect existing PASSing architecture and skip.

$ARGUMENTS may be a part identifier ("part-2", "2", "part-3", "3") or empty (defaults to inventorying both Part 2 and Part 3 and asking which to architect). Per-part run: 2 subagent launches (Phase 2 + Phase 3), target ~6–10 min wall time.

---

## Phase 1 — Plan (main session)

Keep this phase lightweight. Do NOT read source files yet.

1. Parse $ARGUMENTS to identify the target document part:
   - "part-2", "2", or empty starting with Part 2 → Part 2
   - "part-3", "3" → Part 3
   - If $ARGUMENTS is empty: inventory both Part 2 and Part 3 directories and ask the operator which to architect
2. Determine paths:
   - Set `part_dir`: Part 2 → `parts/part-2-service/`, Part 3 → `parts/part-3-strategy/`
   - Set `prose_output_dir`: Part 2 → `output/part-2-prose/`, Part 3 → `output/part-3-prose/`
3. **Skip condition check (mirrors the monolith's two-file PASS check exactly):**
   - Check if `{prose_output_dir}/architecture.md` exists AND `{prose_output_dir}/architecture-qc.md` exists AND the QC file contains a PASS verdict.
   - **If all three conditions hold:** Note "Architecture exists and passed QC — skipping Phases 2 and 3. Nothing to do." Present the existing architecture summary (file path, section count from architecture.md hierarchy) and exit. Suggest `/produce-prose-draft {first_section}` to begin prose conversion.
   - **If `architecture.md` exists but `architecture-qc.md` does not, or QC file does not show PASS:** Skip Phase 2 only. Run Phase 3 to QC the existing architecture (or re-QC after fixing).
   - **If `architecture.md` does not exist:** Run both Phase 2 and Phase 3.
4. **Staleness check (when architecture exists):** Compare the architecture's section list against currently available drafts and approved files in `{part_dir}`. If new sections exist that aren't in the architecture, flag: "Architecture may be stale — new sections found: [list]. Options: regenerate architecture (delete `{prose_output_dir}/architecture.md` and `{prose_output_dir}/architecture-qc.md`, then re-run `/produce-architecture {part}`) or proceed with current and re-run later."
5. Inventory all available drafts (needed if Phase 2 will run):
   - Glob `{part_dir}/drafts/*` and `{part_dir}/approved/*`
   - For each section found: select the highest-numbered draft (extract numeric suffix from filename, e.g., `draft-07` → 7, pick highest). Fall back to `approved/` if no drafts exist for a section.
   - **Minimum check:** If fewer than 2 sections have available content, PAUSE: "Architecture requires 2+ sections. Currently {N} available. Options: wait until more sections exist, or proceed without architecture (downstream `/produce-prose-draft` calls will run with `architecture-missing` override)."
   - Present the full draft inventory to the operator: which sections have drafts (with draft number), which have approved versions only, which are missing entirely.

Present the plan: target document part, draft inventory, what will run (skip / Phase 3 only / Phases 2+3), output paths. Wait for the operator's approval before proceeding.

---

## Phase 2 — Document Architecture [delegate] (conditional)

> **Condition:** Only runs if `{prose_output_dir}/architecture.md` does not exist AND 2+ sections are available. If skipped, proceed to Phase 3 (which will skip if QC PASS already exists).

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

> **Condition:** Runs when architecture exists but has not yet passed QC. This covers two cases: (a) immediately after Phase 2 created the architecture, or (b) when `{prose_output_dir}/architecture.md` exists but `{prose_output_dir}/architecture-qc.md` does not (e.g., after fixing a failed QC). If both files exist and the QC report shows PASS, this phase is skipped per the Phase 1 skip condition.

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
     - "Criterion 14 (Style reference lock): The style reference for Part 2/3 prose is managed by the `/produce-prose-draft` command at `{prose_output_dir}/style-reference.md`, not by the architecture. Mark criterion 14 as N/A."
   - Output path: `{prose_output_dir}/architecture-qc.md`
   - Task: Evaluate the architecture against all 14 criteria per the skill logic. For criteria with absent inputs, apply the adaptation notes above (N/A where specified). Produce the QC report with PASS/FAIL per criterion and overall verdict.
5. Route on verdict:
   - **PASS:** Note architecture summary + QC result. Proceed to Phase 4 (handoff).
   - **FAIL with critical findings:** PAUSE — present failures to the operator. Architecture must be fixed before prose conversion can begin. Options: fix specific items in the architecture and re-run QC (delete `{prose_output_dir}/architecture-qc.md` and re-run `/produce-architecture {part}`; Phase 1 will detect the architecture exists and skip Phase 2, but Phase 3 will re-run because the QC file is absent), or override and proceed.
6. ▸ /compact — skill content and draft content no longer needed.

---

## Phase 4 — Handoff (main session)

1. Read `{prose_output_dir}/architecture.md` and `{prose_output_dir}/architecture-qc.md`
2. Present to the operator:
   - Architecture file path
   - QC verdict (PASS or FAIL with findings)
   - Section count and processing order
   - Word count allocations per section
   - Any flagged overlaps, conflicts, or gaps from Phase 2
   - Per-criterion QC verdicts (highlight any FAIL or partial-PASS items explicitly)
3. Suggest next step:
   - **On PASS:** "Run `/produce-prose-draft {first_section}` to begin prose conversion. If this is the document's first section, the command will pause to lock the style reference before proceeding."
   - **On FAIL:** "Fix the flagged architecture items, delete `{prose_output_dir}/architecture-qc.md`, and re-run `/produce-architecture {part}` to re-QC."
