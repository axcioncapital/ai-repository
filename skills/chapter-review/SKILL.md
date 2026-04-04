---
name: chapter-review
description: >
  Reviews a chapter draft against the research workflow's upstream artifacts:
  architecture spec, style reference, section directive, scarcity register,
  cluster memo, and synthesis brief. Produces a structured findings report with
  per-finding severity and an overall verdict. Does not apply fixes. Use when
  the operator wants to QC a chapter at any point during Stage 4 — after
  drafting, after revisions, or before citation conversion. Do NOT use for
  cross-module integration QC (that's document-integration-qc), inline draft
  review during Step 4.2 (that's chapter-prose-reviewer), or fact verification
  (that's verify-chapter).
---

## Role + Scope

**Role:** Chapter compliance reviewer. Evaluate a chapter draft against the research workflow's own upstream artifacts — the specifications, directives, and evidence that the chapter was built from. Produce a findings report with severity ratings and an overall verdict.

**Hard constraint:** This skill does NOT apply fixes or rewrite prose. It identifies compliance gaps and recommends corrections. Fixes happen in a separate step where the bright-line rule is enforced.

**Stateless:** Each review is independent. Evaluate the chapter as-is.

**Distinction from other QC skills:**
- `chapter-prose-reviewer` — evaluates prose quality (structure, style, argument flow). This skill evaluates *upstream compliance* (did the chapter deliver what the workflow specified?).
- `document-integration-qc` — evaluates cross-module integration. This skill evaluates a *single chapter* against its own specifications.
- `verify-chapter` — checks factual accuracy against evidence. This skill checks *structural and editorial compliance* against upstream artifacts.

## Inputs

All inputs are required unless marked optional. The main agent reads files and passes content to the reviewer — the reviewer does not read files itself.

### 1. Chapter Draft (required)

The chapter prose to evaluate. May be the base version or the cited version — the reviewer evaluates reader-facing prose either way. If claim IDs are present, they support traceability checks but are not the focus.

### 2. Architecture Section Spec (required — blocking)

The relevant section from `report/architecture.md`. Must include:
- Section thesis
- Target word count
- Must-land content
- H3 structure
- Cross-reference requirements
- Writer compliance checklist items relevant to this chapter

**If missing:** Do not proceed. Flag and request.

### 3. Style Reference (required — blocking)

The style specification from `report/style-reference.md`.

**If missing:** Do not proceed. Flag and request.

### 4. Section Directive (required — blocking)

The section directive for this chapter from `analysis/section-directives/`. Must include:
- Section objective
- Reader question
- Claim allocation table (which findings, what treatment level)
- Target length
- Narrative arc (how this section fits in the sequence)

**If missing:** Do not proceed. Flag and request.

### 5. Scarcity Register (required)

The scarcity register from `execution/scarcity-register.md`. The reviewer checks whether the chapter implements the editorial instructions (HEDGE / SCOPE CAVEAT / PROXY FRAMING) for any scarcity items in its scope.

**If no scarcity items fall within this chapter's scope:** Note "no scarcity items in scope" and skip Check 4.

### 6. Cluster Memo (required)

The refined cluster memo from `analysis/cluster-memos/` that corresponds to this chapter's cluster. The reviewer checks whether the chapter's prose accurately reflects the evidence base as characterized in the memo.

### 7. Synthesis Brief / Chapter Draft from Stage 3 (optional, recommended)

The synthesis draft from `analysis/chapters/` that was the direct input to the report writer. Enables detection of evidence that was present in the synthesis but dropped in the chapter, or claims that appeared in the chapter but were not in the synthesis.

**If not available:** Note "synthesis brief not provided." Evidence fidelity checks rely on the cluster memo alone.

## Evaluation Checks

Apply these as substantive evaluations, not a mechanical checklist. Context matters. For every finding, quote the specific passage (or note the specific absence), state the problem in one sentence, and rate severity.

### Check 1: Architecture Compliance

Does the chapter conform to its section specification in the document architecture?

- **Thesis delivery:** Does the chapter deliver on the one-sentence thesis from the architecture? Is the thesis evident to the reader?
- **Must-land content:** Does every item listed under "Must-Land Content" in the depth allocation table appear in the chapter? Is the most prominent must-land item treated with appropriate prominence?
- **Word count:** Is the chapter within +/-15% of the architecture target? If outside range, identify what should be compressed or expanded.
- **H3 coverage:** Does the chapter's content map to all H3 segments specified in the section hierarchy? Content segments may be implemented as visible subheadings or unmarked topic shifts — check for content presence, not heading format.
- **Cross-references:** Are required cross-references from the cross-reference map present and correctly pointed? Check both incoming references (from prior sections) and outgoing references (to subsequent sections).
- **Writer compliance checklist:** Check each item in the architecture's Writer Compliance Checklist that applies to this chapter. Flag any unchecked item.

### Check 2: Style Compliance

Does the chapter conform to the style reference?

- Evaluate every constraint in the style reference: tone, voice, audience calibration, formatting conventions, prohibited patterns.
- This is a mechanical check — if the style reference says something, the draft must comply.
- Flag each violation with the specific style reference constraint it breaks.

### Check 3: Directive Delivery

Did the chapter deliver what the section directive specified?

- **Section objective:** Does the chapter achieve the stated objective? After reading the chapter, does the reader understand what the objective says they should understand?
- **Reader question:** Does the chapter answer the reader question stated in the directive?
- **Claim allocation:** For each finding in the claim allocation table, verify:
  - Is it present in the chapter?
  - Does it receive the treatment level specified (Full / Standard / Summary / Brief / Supporting)?
  - Treatment level check: Full findings should receive prominent multi-sentence treatment. Standard findings get clear development. Summary findings get concise but complete coverage. Brief findings get a sentence or clause. Supporting findings appear in service of other claims, not independently.
- **Narrative arc:** Does the chapter fulfill its role in the section sequence as described in the directive's narrative arc?

### Check 4: Scarcity Compliance

Did the chapter implement the required editorial instructions for scarcity items in its scope?

For each scarcity register item that falls within this chapter's scope:
- **Identify the item** by register number and component ID.
- **Check the editorial instruction** (HEDGE / SCOPE CAVEAT / PROXY FRAMING).
- **Verify implementation:** Does the prose contain language that implements the specified instruction? Quote the implementing passage.
- **Flag missing implementations** as HIGH severity — scarcity editorial instructions are non-negotiable per the workflow.

Definitions for reference:
- **HEDGE:** Explicit uncertainty language ("evidence suggests...", "available data indicates...").
- **SCOPE CAVEAT:** Brief caveat noting the evidence boundary ("No Nordic-specific data is available; the following uses [proxy] as directional context").
- **PROXY FRAMING:** Present available proxy data with explicit note of its non-local origin and the inference gap.

### Check 5: Evidence Fidelity

Does the chapter's prose accurately reflect the evidence base?

- **Against cluster memo:** Compare the chapter's claims against the cluster memo's findings, tensions, and evidence strength ratings. Flag any claim in the chapter that is not grounded in the memo, or any claim presented with more confidence than the memo's evidence strength supports.
- **Against synthesis brief (if provided):** Check for evidence present in the synthesis that was dropped in the chapter without apparent justification. Check for claims in the chapter that do not appear in the synthesis.
- **Evidence strength alignment:** Where the cluster memo rates evidence as "Establishes," the chapter may state the finding confidently. Where rated as "Suggests" or "Preliminary signal," the chapter must hedge appropriately. Flag mismatches.
- **Analytical vs. source-grounded:** Where the cluster memo or directive tags a finding as ANALYTICAL, verify the chapter distinguishes it from source-grounded findings (e.g., through hedging, framing, or explicit flagging).

### Check 6: Completeness

Is anything missing that the upstream artifacts require?

- **Content gaps:** Any must-land content, allocated claim, or scarcity instruction that is entirely absent from the chapter.
- **Structural gaps:** Any H3 segment from the architecture that has no corresponding content.
- **Cross-reference gaps:** Any required cross-reference that is missing.
- **Dropped evidence:** Any finding from the claim allocation that receives no treatment at all (not even a brief mention when Brief or Supporting treatment was specified).

This check consolidates and elevates the most critical gaps found in Checks 1-5. Its purpose is to provide a single "what's missing" summary. Do not duplicate findings — reference the original check number.

## Output Format

### Verdict

One of:
- **PASS** — Chapter meets all upstream compliance requirements. No HIGH-severity findings. Proceed to next step (citation conversion, Stage 5, or operator review).
- **CONDITIONAL PASS** — Chapter meets most requirements but has MEDIUM-severity findings that should be addressed. Operator decides whether to fix before proceeding.
- **REVISE** — Chapter has HIGH-severity findings that must be addressed before proceeding.

### Summary Assessment

2-3 sentences: overall compliance status, the single most significant gap (if any), and routing recommendation.

### Findings Report

Organize findings by check number. Each finding uses this format:

**[Check N] — [Short description]**
Passage: "[exact quote from draft, or 'ABSENT' if the finding is about missing content]"
Problem: [one sentence]
Severity: HIGH / MEDIUM / LOW
Upstream reference: [which artifact and which specific element — e.g., "Architecture depth allocation: must-land item 'six decision gates'"]

**Severity definitions:**
- **HIGH:** Non-negotiable compliance failure. Scarcity instruction not implemented, must-land content absent, evidence presented beyond its strength rating. Must fix before proceeding.
- **MEDIUM:** Compliance gap that weakens the chapter but does not violate a hard requirement. Treatment level mismatch, minor cross-reference omission, style deviation.
- **LOW:** Minor gap. Could go either way.

**Consolidation rule:** If more than 12 individual findings are identified, consolidate related findings into grouped entries under their check number. The Priority Fixes list becomes the primary directive; individual findings become supporting detail.

### Priority Fixes

After all findings, list the top 5 changes that would most improve the chapter's upstream compliance, in priority order. For each, reference the specific finding(s) it addresses.

### Scarcity Compliance Summary

A standalone table summarizing scarcity register compliance for quick operator review:

| # | Component | Editorial Instruction | Implemented? | Implementing Passage |
|---|-----------|----------------------|-------------|---------------------|
| [register #] | [component ID] | [HEDGE/SCOPE CAVEAT/PROXY FRAMING] | YES / NO / PARTIAL | [quote or "not found"] |

If no scarcity items fall within this chapter's scope, state: "No scarcity items in scope for this chapter."

## Calibration Notes

- **Short chapters (<400 words):** Some structural checks (H3 coverage, narrative arc) may apply at reduced scope. Do not penalize brevity if the architecture's target word count is itself short.
- **Cited vs. uncited versions:** Both are valid inputs. If evaluating the cited version, footnotes and citation markers are not evaluated for prose quality — they are traceability artifacts. Focus on the reader-facing prose.
- **Multiple scarcity items:** A chapter covering multiple scarcity items must implement each one independently. One blanket caveat does not satisfy item-specific editorial instructions unless the architecture explicitly consolidates them.
- **Analytical findings:** A chapter that presents an ANALYTICAL finding without distinguishing it from evidence-backed claims is a HIGH finding (evidence fidelity violation), not a style issue.
- **Cross-references to future sections:** If this chapter references a section not yet written, check the reference against the architecture's cross-reference map. The reference should match the planned content, even if the target section doesn't exist yet.
