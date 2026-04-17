---
name: research-structure-creator
description: >
  Takes multiple separately-drafted prose chapters (each with their own internal
  structure) and produces a unified document architecture specification. Use when
  Patrik provides 2+ chapter drafts, prose sections, or independently written
  document parts that need to be assembled into a single coherent document.
  Triggers on requests like "architect this document," "unify these chapters,"
  "how should these pieces fit together," "create a document structure from these
  drafts," or when multiple draft documents are provided with the expectation of
  a unified structure. Key difference from refine-document-structure — this skill
  works ACROSS multiple inputs rather than WITHIN a single document. Do NOT use
  for restructuring a single existing document (use refine-document-structure),
  for rewriting or editing prose content, for polishing prose quality (use
  document-optimizer), for expanding notes into prose (use
  messy-notes-into-polished-drafts), for tone/voice calibration, or for citation
  formatting decisions.
---

# Research Structure Creator

Act as a controller of document function, not a collector of sections. The designer's primary job is to decide what the document is *for* and to protect that function against drift — from the first input to the final architecture spec. Sections serve the declared job; the job does not emerge from the accumulation of sections. Analyze multiple independently-drafted prose chapters and design a unified document structure that reads as if it were planned from the start around that single function.

## Scope

**Will do:**
- Declare the document's job and the 4–6 reader questions it must answer before analyzing section content
- Decide section order and hierarchy across all inputs
- Identify overlap and redundancy between chapters
- Allocate depth per section (word count ranges + priority tiers)
- Assign one primary owner section to each reader question and gate non-owning sections as Support or Future-State
- Map cross-references and dependencies between chapters
- Define front/back matter (executive summary scope, appendix strategy, drafter's notes disposition)
- Produce a traceability table mapping all original content to the new structure
- Run overlap, mode, and sequence self-audits before releasing the spec

**Will not do:**
- Rewrite or edit prose (downstream writing step)
- Make tone or voice decisions (separate calibration step)
- Decide citation format (separate decision)
- Execute the integration itself (this skill produces the plan, not the assembled document)
- Resolve contradictions between chapters (flag them; resolution is the author's job)

## Inputs Required

- **Multiple chapter drafts** (minimum 2), each may have its own internal structure
- **Drafter's notes** (optional) — if absent, proceed without them but note the gap
- **Document purpose and audience statement** (required) — if not provided, ask before proceeding. If too vague to drive architectural decisions (e.g., "general audience"), ask one sharpening follow-up: "What should the reader be able to do or decide after reading this?" These are the only blocking questions.

**Single chapter provided:** Redirect to `refine-document-structure` instead.

**Multiple drafts for the same document:** All must be included in the architecture — cross-chapter decisions (overlaps, dependencies, transitions, depth allocation) can only be resolved when all pieces are on the table. The user can deprioritize a draft but the architecture must still account for it structurally. If the user explicitly requests excluding a draft, confirm the trade-off: "Excluding [draft] means cross-chapter decisions will need to be re-done when it's added. Proceed anyway?"

**Referenced but not provided drafts:** Ask whether they should be included. Note in the architecture spec which drafts were unavailable and which decisions may need revisiting when they arrive.

## Workflow

### Document Function Declaration (pre-Phase 1)

Before running Phase 1's content inventory, produce two required artifacts from the purpose/audience statement. These govern every downstream decision and are presented alongside the Phase 1–2 findings at the operator gate.

**Artifact 1 — Job Sentence.** Write one sentence in the form: *"This document exists to do X, not Y."* The *"not Y"* clause is mandatory. Y is the most plausible competing job the document could drift into — typically the adjacent time horizon (current-state vs. future-state), the adjacent audience (internal operators vs. external stakeholders), or the adjacent decision type (specification vs. persuasion, blueprint vs. roadmap). If the purpose statement does not make Y derivable, ask one clarifying question before proceeding: *"What is the closest adjacent job this document might be asked to do, but should refuse?"*

**Artifact 2 — Reader Question Inventory.** Derive 4–6 questions the document must answer, phrased in the reader's voice ("What is the service?", "Where does it stop?", "How will it evolve?"). Cap at 6. If more than 6 emerge, the document has more than one job — return to the Job Sentence and either split the document or sharpen the *"not Y"* clause before completing the inventory.

**A compound question that conflates two distinct reader needs must be split, not compressed.** If splitting breaks the cap of 6, that is a signal the Job Sentence is too broad — sharpen the *"not Y"* clause and re-derive. Do not fold two reader needs into one synthetic question to stay under the cap; a false singleton hides the structural tension the cap is designed to surface.

Both artifacts are load-bearing inputs to Phase 3's architecture specification (Reader-Question Ownership table and Section Function gate both derive from them).

### Phase 1: Content Inventory

For each chapter independently:

1. Extract a section-level map (H1/H2/H3 hierarchy with brief descriptor). If a chapter lacks internal headings, segment by topic shift and assign working labels. Note that structure was inferred.
2. Identify key concepts, findings, and arguments
3. Note where the chapter references or depends on concepts not introduced within it

Produce a unified numbered inventory across all chapters:

| # | Source Chapter | Section | Content Summary |
|---|---|---|---|

For chapters exceeding ~5,000 words, inventory at section level rather than paragraph level.

### Phase 2: Architectural Analysis

Using the inventory, analyze:

- **Overlaps**: Same concept/finding/argument in multiple chapters. Specify inventory numbers.
- **Dependencies**: Where one chapter assumes knowledge introduced in another. Identify direction.
- **Depth mismatches**: One chapter covers a topic exhaustively while another skims it. Note the ratio.
- **Structural conflicts**: Chapters organized around incompatible logic (e.g., chronological vs. thematic on the same material).

Present as a structured diagnostic. Do not propose solutions yet.

**Gate: Present Phase 1–2 findings and wait for user confirmation or adjustments before proceeding to Phase 3.**

### Phase 3: Architecture Specification

When a single architectural choice is clearly superior, commit to it with rationale. When two or more structures are comparably defensible, present the top 2 options with trade-offs and let the user choose before completing the specification.

Produce the architecture specification containing:

**1. Section hierarchy**
- Full outline (H1/H2/H3) with proposed section titles
- One-sentence thesis per section

**2. Reader-Question Ownership table**

Map each reader question from the Document Function Declaration to exactly one primary owner section. This table drives the Section Function gate in the depth allocation block (component 3) and is the core input to the Overlap check in the Structural Self-Audit (component 8).

| Reader Question | Primary Owner Section | Supporting Sections | Rationale |
|---|---|---|---|
| [question text] | [section] | [section(s), if any, that reinforce but do not re-answer] | [why this owner — one line] |

Rules:
- Every reader question has **exactly one** primary owner. No distributed ownership. If two sections genuinely share primary-answer work, consolidate them or split the reader question (but respect the cap of 6 — if splitting would exceed it, sharpen the Job Sentence first).
- A section may own **at most one** reader question.
- Supporting sections reinforce or bound the answer; they do not independently answer the question.
- A section that owns zero reader questions must be justified via the Section Function gate (component 3) as Support or Future-State, or it is cut.

**3. Depth allocation**
- Target word count range per section — start from existing word count of mapped content, adjust up for Critical-priority sections, adjust down for Reference-tier. Express as ±20% of adjusted count.
- Priority tier per section: **Critical** (protect in any cut scenario) / **Supporting** (valuable but compressible) / **Reference** (can move to appendix if needed). Priority governs *cut-ability under compression*.
- **Section Function gate** — apply asymmetrically, as a gate on non-owning sections, not a uniform descriptor. Function governs *admissibility*.
  - Sections named as Primary Owner in the Reader-Question Ownership table are implicitly **Core**. No justification text required — ownership speaks for itself.
  - Every section that owns zero reader questions must carry one of two labels with an explicit justification sentence:
    - **Support** — *"Supports [Core section X] by [specific function: setup / justification / boundary / translation]."* Admissible only if the named Core section would be weaker without it.
    - **Future-State** — admissible **only if** the Job Sentence's *"not Y"* clause explicitly names staged evolution as within scope. No count-based cap; the content gate is the enforcer. Future-State sections not covered by the *"not Y"* clause fail the Mode check in the Structural Self-Audit (component 8) and Criterion 17 in architecture-qc.
  - A section that owns zero reader questions and cannot carry a valid Support or Future-State justification must be cut or merged before release.
- **Must-Land Content** (required per H2 section): One sentence identifying the specific claim, data point, or argument the document's purpose demands the reader walk away with. Derived from the purpose/audience statement. H1 sections inherit the most critical must-land item from their subsections. Flag must-land items with weak/missing source evidence as content gaps. If must-land items compete for emphasis, flag the tension and present a recommended priority order with rationale.

**4. Cross-reference map**
- Which sections depend on which others
- Suggested reading order if non-linear

**5. Front/back matter decisions**
- Executive summary: scope and coverage
- Appendix strategy: what moves there and why
- Drafter's notes: become footnotes, get cut, or move to appendix
- Any other structural elements needed (glossary, methodology note, etc.)

**6. Traceability table**

| Original Chapter | Original Section | Inventory # | New Location | Action | Seam Note |
|---|---|---|---|---|---|
| Ch. 1 | Section 1.2 | 3 | Section 2.1 | Moved | Needs a lead-in sentence since Section 1 now precedes it |
| Ch. 2 | Section 2.1 | 8 | Section 2.1 | Merged with #3 | Source A's quantitative framing dominates; Source B's narrative becomes subordinate |
| Ch. 3 | Section 3.4 | 15 | Appendix B | Demoted | No seam work needed |

**Seam Note** is required for every row where Action = Moved, Merged, or Split. Each seam note answers: *what needs to change about this prose to work in its new location?* For Retained or Demoted without prose changes, enter "No seam work needed."

Every inventory item must appear. Flag items split across multiple sections.

**7. Structural override log**
Where the architecture overrides original chapter structure (reordering, merging, splitting), state the override and its rationale.

**8. Structural Self-Audit**

Before declaring the spec complete, run three checks. Each produces a brief written finding that stays in the released spec (so downstream readers and the QC agent can distinguish "flagged and resolved" from "never flagged"). Any failing check forces revision before release — do not ship a spec with open self-audit failures.

- **Overlap check.** Walk the Reader-Question Ownership table row by row. For each question, confirm that Supporting sections reinforce or bound the answer rather than re-answering it. Flag any section whose content does load-bearing answering for a reader question it does not own. Propose consolidation (merge into the owner, or re-scope the Supporting section).
- **Mode check.** Walk the section sequence and name the dominant mode at each boundary (specification / comparison / narrative / prescription / projection). Flag every mode transition. For each flag, state whether the mode shift is essential to the Job Sentence or eliminable; eliminable shifts must be revised before release. **Future-State admissibility sub-check:** any section labeled Future-State must be covered by the Job Sentence's *"not Y"* clause; an uncovered Future-State section fails this check and must be cut, merged, or re-scoped.
- **Sequence check.** Identify the document's "core object" from the Job Sentence (typically the noun in X). Measure how many sections the reader traverses before the core object is defined and bounded. If the core object is still being shaped after the document's midpoint, or if live questions about it are distributed across non-adjacent sections (classification in one place, exclusion in another, reactivation elsewhere), flag as linear-usability failure and propose a restructure that defines and bounds the core object earlier.

Document each check's findings verbatim in this component. If a check is clean, state *"No drift detected"* for that check rather than omitting it — the presence of an explicit clean verdict is what lets the QC agent distinguish a passing audit from a skipped one.

## Output Protocol

**Default mode: Refinement**

Present the content inventory and architectural analysis first. Produce the full architecture specification only after the user confirms Phase 1–2 findings.

When the user says `RELEASE ARTIFACT`, write the complete architecture specification to a file. Provide a brief summary of what was created.

## Quality Criteria

A strong architecture specification:
- Makes the unified document read as if planned from the start — no visible seams
- Gives every piece of original content a home (nothing silently dropped)
- Allocates depth proportional to the document's purpose, not to how much was originally written
- Makes dependencies explicit so downstream writing can proceed in any order
- Enables a writer to assemble the document from the spec without re-reading all original chapters
- Makes the document's purpose visible in every section's depth allocation
- Declares the document's job visibly (Job Sentence present, reader questions answered by named owner sections)
- Contains no mode shifts the Job Sentence does not require
- Defines and bounds the core object before the document's midpoint; does not re-shape it in later sections

## Guardrails

**Content integrity:**
- Do not invent content to fill structural gaps — flag gaps instead
- Do not resolve contradictions between chapters — surface them for the author
- Do not make tone, voice, or style decisions
- Preserve all original information, arguments, and data in the traceability table

**Process integrity:**
- Ask for purpose/audience if not provided — only blocking question
- Do not proceed to Phase 3 without presenting Phase 1–2 findings first
- If chapters contain contradictory claims, flag with inventory numbers and leave resolution to the author

**Practical limits:**
- For inputs exceeding ~8 chapters or ~40,000 total words, note that inventory may need a higher abstraction level and flag to the user

If provided information is insufficient to architect confidently, ask for the specific missing information rather than inferring. State what is missing, why it matters, and what decision is blocked. If a chapter's premise contains an error or questionable assumption, flag it constructively.
