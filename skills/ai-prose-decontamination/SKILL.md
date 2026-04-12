---
name: ai-prose-decontamination
description: >
  Four-pass sequential decontamination of AI writing patterns from prose.
  Removes ornamental language, repetition, over-argumentation, and uniform
  rhythm. Use when prose has passed substantive review and needs voice
  decontamination before formatting, or on requests like "decontaminate this,"
  "remove AI patterns," "clean up the AI voice," "decontamination pass."
  Do NOT use for: prose quality review (chapter-prose-reviewer), compliance
  checking (prose-compliance-qc), formatting (prose-formatter), or rewriting
  content (decision-to-prose-writer / evidence-to-report-writer).
---

## Role + Scope

**Role:** Prose decontaminator. Remove AI writing patterns from substantively correct prose. Produce clean, direct prose that reads like a knowledgeable human wrote it.

**Hard constraint:** This skill does not change the argument structure, the sequence of sections, or the analytical conclusions. It changes how things are said, not what is said. If a decontamination edit would alter an analytical claim or modify a sourced statement, flag it in the bright-line flags output instead of applying it.

**Stateless:** Each invocation is independent. Evaluate the prose as-is.

## Why AI Prose Fails

AI-generated prose optimises for the appearance of rigour rather than the efficiency of communication. It reaches for the elevated word, restates points for completeness, builds logical scaffolds around claims the reader would accept directly, and delivers every sentence at the same pace and weight. The result is prose that is substantively correct but exhausting to read — it sounds like a document performing intelligence rather than a person conveying it.

Four failure modes produce this effect. This skill corrects them in sequence.

---

## Inputs

### 1. Prose File (required — blocking)

The document to decontaminate. This should be post-review prose — substantive correctness has already been verified. If the prose has not been through review, the decontamination pass will still run, but analytical errors in the source will pass through unchanged.

### 2. Style Reference (required — blocking)

The style specification governing tone, voice, audience, and editorial standards. The style reference is the authority on what register is appropriate for this document. Pass 1 checks the style reference before flagging elevated language — if the style reference permits a construction, it stays.

**If missing:** Do not proceed. Flag and request before running any passes.

### 3. Prose Quality Standards (recommended — not blocking)

The prose quality standards document for this project. When provided, aligns the decontamination passes with existing standards — particularly Standard 1 (no self-annotation), Standard 3 (sentence rhythm), and Standard 5 (no preambles). When absent, the four passes use their own internal logic. Note the absence in the change log header.

### 4. Source Document (optional)

The original document that was converted to prose (decision document, evidence prose, etc.). When provided, run a lightweight fidelity spot-check after Pass 4 completes: verify that no design choices, analytical claims, or evidence citations were inadvertently dropped during decontamination. When absent, skip the spot-check and note it in the change log.

---

## Before You Start

**Leave clean prose alone.** If a paragraph already reads like a knowledgeable human wrote it — direct, varied in rhythm, free of ornament — do not edit it. The goal is to fix what's wrong, not to process every sentence. Over-editing clean prose degrades it.

**Priority rule.** When passes conflict — when simplifying language would reduce analytical precision, or when removing argumentation would lose a distinction the reader needs — clarity and precision win over compression and style. Specifically: do not simplify a phrase if the simpler version loses a meaningful distinction. Do not compress an argument if the compression drops reasoning the reader needs to make a decision. Passes 1 and 2 take priority over Passes 3 and 4 when trade-offs arise.

**Run all four passes in order.** Later passes assume earlier ones are complete. Each pass runs against every paragraph, but changes are made only where the detection pattern triggers. Running a pass is not the same as making changes — a pass that finds nothing wrong in a paragraph produces no edits for that paragraph.

**Sequential execution.** Each pass operates on the output of the previous pass. Complete each pass fully before starting the next. Do not plan ahead across passes.

**Style reference authority.** Before flagging any construction in Pass 1, check the style reference. If the style reference explicitly permits or requires a register level, that level is not ornamental — it is intentional. The style reference overrides Pass 1's default simplification impulse.

---

## Pass 1: Kill Ornamental Language

AI prose reaches for the elevated construction when the plain one says the same thing. Find every instance where a simpler word or shorter phrase would carry the same meaning, and replace.

**Detection pattern:** If a phrase would sound strange spoken aloud to a colleague, the register is too high.

Examples of what to replace:

| AI version | Human version |
|---|---|
| constitutes a fundamental reassessment trigger | forces a rethink |
| the economic rationale translates this structural case into fund-level terms across three dimensions | three things matter for the fund |
| this serves as an empirical validation target | this is what Year 1 tests |
| demonstrates a structural incompatibility | doesn't work |
| the service retains relevance for the unmet dimension | the service still helps with what's missing |
| operationalized throughout the service design | built into the service |
| is directionally consistent with | aligns with |
| the diagnostic is the four-condition combination test | the test is whether the existing advisor delivers all four |
| the residual risk is to uniqueness of positioning, not to service viability | the risk is that the positioning narrows, not that the service fails |
| the knowledge gap is a validation target with a defined response protocol, not an unresolved vulnerability | early conversations will test this directly |

**What to preserve:**

- Technical PE terminology that has precise meaning (enterprise value, carried interest, LPAC). Domain-specific terms are not ornamental — they are accurate.
- Analytical distinctions that would be lost by simplification. If "directionally consistent with" distinguishes between full confirmation and partial alignment, and that distinction matters in context, keep it. If it's just a fancier way of saying "aligns with," replace it.
- Constructions the style reference explicitly permits or requires.

The target is McKinsey-internal, not simplified. Clear and direct, not dumbed down. Simplify language without reducing analytical specificity.

**The test:** Read the sentence aloud. If it sounds like a person explaining something to a smart colleague, keep it. If it sounds like a document performing intelligence, simplify.

---

## Pass 2: Remove Repetition

AI prose makes a point, restates it in different words, then summarises what was just said. The reader understood it the first time.

**Detection pattern:** If a sentence can be deleted and the paragraph still makes the same point with the same clarity, delete it.

**What counts as repetition:**
- The same claim expressed in two phrasings within the same paragraph
- A summary sentence at the end of a paragraph that restates what the paragraph just developed
- A framing sentence that previews what the next sentence says directly
- A paragraph-closing sentence that summarises the paragraph's own argument ("The net result is..." "The practical consequence is..." "Each pressure amplifies the others.")

**What does NOT count as repetition:**
- A claim followed by evidence supporting it (that's development)
- A claim followed by its mechanism or implication (that's progression)
- A claim restated in a later section for a different analytical purpose (that's cross-referencing)
- Deliberate restatement for emphasis where the point is consequential enough to warrant it — for instance, a design principle restated at the moment it governs a specific decision. If the restatement changes context or application, it is emphasis, not redundancy. If it merely re-words the same claim at the same level of abstraction, it is redundancy.

**Action:** For each repeated point, keep the strongest formulation. Delete the others. One formulation per idea. If two phrasings are equally strong, keep the shorter one.

---

## Pass 3: Deflate Over-Argumentation

AI prose builds elaborate logical scaffolds around claims that don't need them. It defends against objections the reader hasn't raised. It proves things the reader would have accepted on a direct statement. The result is prose that feels like being cross-examined rather than informed.

**Detection pattern:** If a paragraph spends more words building the case than the finding itself is worth to the reader, the argumentation is disproportionate.

**What to compress:** Argumentation that defends against obvious or unraised objections. Logical scaffolding around findings the reader has no reason to resist. Multi-sentence build-ups to conclusions the reader would accept as direct statements.

**What to retain:** Reasoning that supports a non-obvious conclusion, a decision the reader needs to evaluate, or a risk assessment where the logic chain matters. If the reader needs to see *how* you got there — not just *where* — the argumentation earns its space.

**Boundary rule:** If the scaffolding contains a distinct analytical claim, qualification, or evidence citation, it is not scaffolding — it is argument. Compress only when the surrounding sentences already establish the logical relationship that the scaffolding makes explicit.

**Three specific sub-patterns to fix:**

**Proving the obvious.** When a finding is well-evidenced and the reader has no reason to resist it, state it directly with its citation. Do not build the case from first principles.

*Before:*
> The structural gap that justifies external buy-side support narrows as internal coverage approaches self-sufficiency. This is because larger funds increasingly internalize advisory functions through strategic finance teams, dedicated sector coverage, and in-house origination capability. The net result is that funds above EUR 2B are less likely to benefit from the service.

*After:*
> Funds above EUR 2B increasingly internalise advisory functions — strategic finance teams, dedicated sector coverage, in-house origination. The structural gap narrows as internal coverage approaches self-sufficiency.

Two sentences instead of three. Same information. The reader didn't need the middle sentence explaining *why* internalising advisory functions reduces the gap — that's self-evident.

**Stacking qualifications.** When every claim gets a caveat, a boundary condition, and an evidence-quality note in the same sentence or paragraph. Spread these across the text. Not every claim needs all three simultaneously.

*Before:*
> These figures derive from a single-vendor benchmark (SPS) and should be treated as indicative rather than precise. The dual-channel coverage trap means this gap is not addressable through incremental effort: the intermediated channel excludes by sell-side process design, and the proprietary channel cannot compensate at scale.

*After:*
> The median fund sees roughly 18% of relevant transactions — a figure from a single-vendor benchmark, directionally consistent with other evidence but not precise. The gap is structural: the intermediated channel excludes by sell-side process design, and the proprietary channel cannot compensate at scale.

The qualification is woven in rather than isolated as its own sentence. The finding lands without being pre-emptively weakened.

**Defending against phantom objections.** Addressing counterarguments or alternative interpretations that the reader has not raised and would not raise.

*Before:*
> This is not deferral. It is scheduled resolution with empirical inputs on the positive path and a defined decision trigger on the negative path. Designing the conversion mechanism now, before any fund has experienced the service, would produce a theoretical construct that Year 1 data would require revising.

*After:*
> The conversion mechanism is designed during Year 1 using operational data. Positive-path activation when monitoring shows sufficient conversion indicators. Negative-scenario trigger at month 9. Fallback position defined.

The reader didn't think it was deferral until the prose insisted it wasn't. The defence created the doubt it was trying to prevent. State the mechanism and move on.

---

## Pass 4: Break the AI Rhythm

After passes 1–3, the prose should be leaner. This pass addresses the remaining AI tell: uniform sentence length that produces flat, metronomic prose.

**Detection pattern:** Check each paragraph. If no sentence is under 10 words, the paragraph lacks rhythmic variation. If every sentence falls between 12 and 20 words, the prose is flat.

**Action:** Find the paragraph's key finding, conclusion, or pivot. Compress it into a short sentence (3–8 words). Let the longer sentences around it carry the explanation. The short sentence creates emphasis through contrast, not through bold or italics.

*Before:*
> The entire client acquisition logic depends on cold outreach to funds with no prior Axcion relationship. The evidence base is the thinnest of any critical assumption. The headwinds compound: informal networks command structural presence, the 3% sourcing adoption rate documents cultural resistance, and the augmentation framing constraint means the pitch cannot imply the fund's existing approach is deficient.

*After:*
> Cold outreach is the weakest bet in the model. The entire client acquisition logic depends on it, the evidence base is the thinnest of any critical assumption, and the headwinds compound: informal networks have structural presence, only 3% of sourcing is outsourced, and the pitch cannot imply the fund's existing approach is deficient.

"Cold outreach is the weakest bet in the model" — eight words that land the point. The longer sentence that follows develops it.

**Frequency target:** At least one sentence under 10 words per paragraph of four or more sentences. Two consecutive paragraphs without rhythmic variation is a problem.

**What short sentences are NOT:** Not labels ("This matters."), not fragments ("A critical point."), not fillers ("The implications are clear."). Short sentences are compressed findings or pivots — they carry meaning, not emphasis markers.

**Prose quality standards alignment:** When prose quality standards are provided, apply Standard 3's frequency target and short-sentence definition. Standard 3 governs; Pass 4 implements.

---

## After All Four Passes

### Fidelity Spot-Check (conditional)

If the source document was provided as Input 4, run a lightweight check:

1. Scan the decontaminated prose for each major design choice, analytical claim, and evidence citation from the source document
2. Confirm each is still present in the decontaminated version (may be reworded but must be substantively present)
3. If any are missing, check whether they were removed by a decontamination pass or were absent before decontamination began
4. Report result: PASSED (all present), or list specific items that may have been dropped with the pass that removed them

If the source document was not provided, note "Source fidelity spot-check: skipped (no source document provided)" in the change log.

### Write Output

Write the decontaminated prose to the output path (overwrite the input file). Then produce the change log.

---

## Constraints

- Do not change the argument structure, the sequence of sections, or the analytical conclusions.
- Do not remove evidence calibration (phrases noting evidence quality or source limitations). These are honest, not ornamental.
- Do not remove technical PE terminology. Domain terms are precise, not fancy.
- Do not simplify a phrase if the simpler version loses a meaningful analytical distinction. Clarity means precision, not just brevity.
- Do not add new content, new claims, or new analysis.
- Do not remove cross-references to other sections or modules.
- Preserve all footnotes and citations in their original positions.
- Every change must be traceable to one of the four passes. No opportunistic improvements.
- If a paragraph is already clean — direct, rhythmically varied, free of ornament — leave it unchanged.

---

## Change Log Format

Produce a structured change log as output. When invoked within a pipeline, the calling agent writes this to `{prose_output_dir}/decontamination-log.md`. When invoked standalone, present it directly.

```
# Decontamination Change Log

Passes applied: 4
Total changes: [N]
Pass 1 (Ornamental Language): [N] changes
Pass 2 (Repetition): [N] changes
Pass 3 (Over-Argumentation): [N] changes
Pass 4 (Rhythm): [N] changes

Style reference: [provided]
Prose quality standards: [provided / not provided]
Source fidelity spot-check: [passed / skipped (no source provided)]

## Bright-Line Flags

[Empty if no analytical claims or sourced statements were touched. If populated, list each flagged change with location, the proposed edit, and which bright-line check it triggers.]

## Changes

### Pass 1 — Ornamental Language

[P1-1] Location: [H2 section name], paragraph [N]
Before: "[quoted original]"
After: "[quoted replacement]"
Rationale: [one sentence — what AI pattern was removed]

### Pass 2 — Repetition

[P2-1] Location: [H2 section name], paragraph [N]
Removed: "[quoted deleted text]"
Rationale: [one sentence — what it restated]

### Pass 3 — Over-Argumentation

[P3-1] Location: [H2 section name], paragraph [N]
Before: "[quoted original passage]"
After: "[quoted compressed version]"
Rationale: [one sentence — what scaffolding was unnecessary]

### Pass 4 — Rhythm

[P4-1] Location: [H2 section name], paragraph [N]
Before: "[quoted original]"
After: "[quoted restructured version]"
Rationale: [one sentence — what rhythm problem was fixed]
```

**Consolidation rule:** If more than 20 changes in a single pass, consolidate into grouped entries with representative examples. Example: "P1-1 through P1-8: Replaced elevated constructions across 6 paragraphs" with 2–3 representative before/after pairs. Summary counts remain exact.

---

## Worked Example: All Four Passes Applied

The following shows a full section transformed through all four passes. Study the changes — the patterns here repeat throughout any AI-produced prose.

### Original (AI pipeline output)

> The position Axcion occupies is **buy-side advisory partner**. This is a deliberate structural choice, not a marketing label.
>
> The distinction from an intermediary is mandate architecture. An intermediary connects parties. Its economic interest is in the connection itself. A partner's economic interest is in the fund's outcome quality. The **retainer structure**, where compensation is independent of deal completion, enforces this distinction economically. The permanent exclusions enforce it architecturally: no investment committee preparation (the fund's sovereign activity), no concurrent sell-side mandates creating buy-side conflicts, no market intelligence until trust prerequisites are earned through demonstrated deal-cycle performance.
>
> The distinction from a service provider is depth of integration. A service provider delivers a defined output to a specification. A partner operates alongside the deal team at progressively deeper chain stages as trust permits. The **co-sourcing model**, embedded support alongside the deal team rather than independent execution, is the operating model at the delegation ceiling. This requires senior-caliber delivery and PE-process literacy as a binary entry requirement.
>
> The partner claim has a temporal dimension. Year 1 delivers the structural alignment that makes the claim credible: mandate authority aligned with the buyer, conflict-free architecture, fee calibration to the underserved segment, and confidentiality rigor. These are architectural features in place from the first client conversation. The depth-of-integration dimension is earned through deal-cycle performance, consistent with what the trust research established: that performance in deal-specific activities dominates relationship history as the trust advancement mechanism. Axcion can legitimately claim structural partner alignment from Year 1 while being clear that operational partnership depth, the co-sourcing model, the criteria refinement through revealed preferences, the progressive access to deeper chain stages, develops over time as the phase-dependent trust dynamic plays out.
>
> The partner trajectory is not promised. It is earned per deal cycle. The service promises structural alignment and performance at the current chain depth. What it earns, over time, is expanded access.

### After All Four Passes

> Axcion is a buy-side advisory partner. Not an intermediary, not a service provider — a partner. The distinction is structural.
>
> An intermediary's economic interest is in the connection itself. A partner's interest is in the fund's outcome. The retainer structure enforces this: compensation is independent of deal completion. The permanent exclusions reinforce it — no IC preparation, no concurrent sell-side mandates, no market intelligence before trust is earned through deal-cycle performance.
>
> A service provider delivers a defined output to a specification. A partner operates alongside the deal team, going deeper as trust permits. At the delegation ceiling, the operating model is co-sourcing: embedded support alongside the deal team, not independent execution. This requires PE-process literacy as a binary entry requirement.
>
> The partner claim has two layers. The structural layer is in place from the first conversation: mandate authority aligned with the buyer, conflict-free architecture, fee calibration to the segment, confidentiality rigor. The depth layer is earned. Deal-cycle performance is what advances trust — not relationship history, not time served. Year 1 delivers the structure. Depth follows performance.
>
> The trajectory is not promised. It is earned per deal cycle.

### What Changed and Why

**Pass 1 (ornamental language):**
- "This is a deliberate structural choice, not a marketing label" — cut. The prose demonstrates the distinction; it doesn't need to insist it's deliberate.
- "the fund's sovereign activity" — cut. The parenthetical explanation is ornamental.
- "consistent with what the trust research established: that performance in deal-specific activities dominates relationship history as the trust advancement mechanism" — rewritten as "Deal-cycle performance is what advances trust — not relationship history, not time served." Same finding, half the words, no appeal to authority.
- "as the phase-dependent trust dynamic plays out" — cut entirely. Jargon wrapping a simple idea the preceding sentences already expressed.
- "senior-caliber delivery and PE-process literacy as a binary entry requirement" — "PE-process literacy as a binary entry requirement." Senior-caliber is implied by binary entry requirement.

**Pass 2 (repetition):**
- "The retainer structure... enforces this distinction economically. The permanent exclusions enforce it architecturally" — collapsed. Both sentences say "this feature enforces the distinction." Keep both features, remove the repeated framing.
- "These are architectural features in place from the first client conversation." — cut. The list speaks for itself.
- Final paragraph: "The service promises structural alignment and performance at the current chain depth. What it earns, over time, is expanded access." — cut. "The trajectory is not promised. It is earned per deal cycle" is the strongest formulation.

**Pass 3 (over-argumentation):**
- "Axcion can legitimately claim structural partner alignment from Year 1 while being clear that operational partnership depth... develops over time" — rewritten as "Year 1 delivers the structure. Depth follows performance." The reader doesn't need the legitimacy argument.

**Pass 4 (rhythm):**
- "Not an intermediary, not a service provider — a partner." — short, direct. Sets up the structural explanation.
- "The distinction is structural." — four words. Lands the reframe before longer sentences develop it.
- "The depth layer is earned." — five words. Pivots from what's given to what's built.
- "Year 1 delivers the structure. Depth follows performance." — two short sentences closing the argument. Each under seven words.
