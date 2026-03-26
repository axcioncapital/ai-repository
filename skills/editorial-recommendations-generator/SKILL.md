---
name: editorial-recommendations-generator
description: >
  Generates recommended answers for editorial decisions surfaced by
  analysis-pass-memo-review. Produces one recommendation per decision, grounded
  in cluster memo evidence and scarcity register context. Use when editorial
  decisions have been surfaced and the operator wants AI-generated recommendations
  before making final calls. Triggers on requests like "generate recommendations
  for editorial decisions," "recommend answers for memo review decisions," or when
  a memo-review output is provided with expectation of recommended responses. Do
  NOT use for surfacing the decisions themselves (that's analysis-pass-memo-review),
  for QC'ing recommendations (that's editorial-recommendations-qc), for making
  final editorial calls (that's the operator), or for writing report prose.
---

# Editorial Recommendations Generator

Produce a recommended answer for each editorial decision surfaced by `analysis-pass-memo-review`. Every recommendation must be grounded in specific evidence from the cluster memos — no "sounds reasonable" reasoning.

## Pipeline Position

```
analysis-pass-memo-review → [this skill] → editorial-recommendations-qc → operator decision
```

The output is a recommendation set, not a decision set. The operator reviews recommendations (with QC report) and makes final calls.

## Input Requirements

All four required:

1. **Memo review** (required) — editorial decisions output from `analysis-pass-memo-review`, organized by category (CC, GH, FP, EW, TR, XC)
2. **Refined cluster memos** (required) — all cluster analytical memos that fed the memo review
3. **Scarcity register** (required if it exists) — confirmed evidence scarcity items with pending editorial instructions
4. **Section directives** (required) — from `section-directive-drafter`, providing context on how findings are allocated to sections

### Validation

Before proceeding, verify:

- Memo review contains identifiable decisions with category labels (CC-n, GH-n, FP-n, EW-n, TR-n, XC-n)
- Each decision references specific findings, gaps, or tensions from the cluster memos
- Cluster memos contain Evidence Strength Maps and Key Findings sections
- If scarcity register exists, verify it contains items with PENDING editorial instructions

**Hard stop conditions:**
- No memo review provided → Refuse. Direct user to `analysis-pass-memo-review`.
- Memo review contains no identifiable decisions → Flag as malformed input.
- Cluster memos appear unrefined (no evidence strength labels) → Flag concern, ask user to confirm.

## Procedure

### Step 1 — Inventory Decisions

Parse the memo review and build a flat inventory of decisions requiring recommendations. For each:
- Decision ID (e.g., CC-1, GH-3)
- Category (Confidence Calibration, Gap Handling, Framing/Positioning, Emphasis/Weighting, Tension Resolution, Cross-Cluster)
- The specific question posed
- Referenced findings, gaps, or tensions (by label)
- Stakes level (if indicated in the memo review)

Identify overlapping decisions (e.g., XC-2 overlaps EW-3) and note them. Produce a single recommendation for the canonical decision; cross-reference the duplicate.

### Step 2 — Scarcity Register Recommendations

For each scarcity register item with PENDING editorial instruction, recommend one of:

- **HEDGE** — when the finding plays a minor role and repeated softening language is acceptable
- **SCOPE CAVEAT** — when no proxy exists and a single upfront boundary statement is cleanest
- **PROXY FRAMING** — when usable proxy data exists and the finding needs quantitative scaffolding

Decision logic:
1. Is proxy data available from another geography or methodology? If yes → PROXY FRAMING is viable.
2. Is the finding central to the section's quantitative argument? If yes → PROXY FRAMING preferred over HEDGE (which weakens quantitative claims).
3. Is the gap about an analytical construct unique to this project? If yes → SCOPE CAVEAT (no proxy exists by definition).
4. Is the finding peripheral or assigned Brief/Summary treatment? If yes → HEDGE is sufficient.
5. Is the finding outside the active section's scope? If yes → HEDGE (minimal treatment).

Present as a structured table with columns: Item #, Scarcity Item, Recommendation, Rationale (1 sentence).

### Step 3 — Per-Category Recommendations

Work through each category in order. For each decision:

**CC (Confidence Calibration):**
- Check the Evidence Strength Map for the referenced finding
- Check whether cross-question convergence adds weight beyond the individual grade
- Recommend: present as-is / strengthen / soften
- Cite the specific evidence basis (grade, source count, convergence pattern)

**GH (Gap Handling):**
- For scarcity items: reference the Step 2 recommendation
- For non-scarcity gaps: assess whether the gap is within research scope, whether proxies exist, and how the directives allocate the finding
- Recommend: HEDGE / SCOPE CAVEAT / PROXY FRAMING (or acknowledge / scope-bound / route back for non-scarcity gaps)

**FP (Framing/Positioning):**
- Identify the evidence weight behind each competing framing
- Assess which framing better serves the report's analytical purpose (not the service model's marketing needs — the evidence should drive framing, not strategic convenience)
- Recommend: which framing to lead with, and whether to present both or commit to one
- If recommending "present both," specify which gets closing position and why

**EW (Emphasis/Weighting):**
- Check the finding's evidence grade, treatment level in the directive, and audience relevance
- Assess whether the current treatment level matches the finding's analytical significance
- Recommend: maintain current treatment / elevate / compress
- If elevating, specify the target treatment level and word count implication

**TR (Tension Resolution):**
- Review the evidence split for each side of the tension
- Check the memo's own recommendation
- Recommend: agree with memo / override (with direction)
- If overriding, cite the evidence basis

**XC (Cross-Cluster):**
- Assess whether the cross-cluster issue requires unified treatment or distributed handling
- Recommend: unified approach / distributed approach / hybrid
- For hedging consistency decisions: recommend whether a glossary or style guide is needed

### Step 4 — Confidence Flags

After all recommendations are drafted, review the full set and flag any recommendation where:
- The evidence is genuinely ambiguous (could reasonably go either way) → mark as **LOW CONFIDENCE**
- The recommendation depends on assumptions about audience or report purpose not stated in the inputs → mark as **ASSUMPTION-DEPENDENT**
- Two recommendations interact (changing one would change the other) → mark the **DEPENDENCY**

## Output Format

```markdown
# Editorial Decision Recommendations — Section [ID]

**Date:** [date]
**Source:** editorial-recommendations-generator
**Status:** PENDING QC — to be reviewed by editorial-recommendations-qc before operator approval

## Scarcity Register Editorial Instructions

| # | Item | Recommendation | Rationale |
|---|------|---------------|-----------|
| [n] | [scarcity item] | **[HEDGE/SCOPE CAVEAT/PROXY FRAMING]** | [1-sentence evidence-grounded rationale] |

---

## CC — Confidence Calibration

**CC-[n]: [Short label] → [Recommendation in bold.]** [1-2 sentence rationale citing specific evidence.]

[...repeat for each CC decision...]

---

## GH — Gap Handling

**GH-[n]: [Short label] → [Recommendation]** [Reference to scarcity table or 1-2 sentence rationale.]

[...repeat...]

---

## FP — Framing/Positioning

**FP-[n]: [Short label] → [Recommendation].** [2-3 sentence rationale for framing choice, citing evidence weights.]

[...repeat...]

---

## EW — Emphasis/Weighting

**EW-[n]: [Short label] → [Recommendation].** [1-2 sentence rationale citing evidence grade and directive treatment.]

[...repeat...]

---

## TR — Tension Resolution

**TR-[n]: [Short label] → [Agree/Override].** [1 sentence if agree; 2-3 sentences if override.]

[...repeat...]

---

## XC — Cross-Cluster

**XC-[n]: [Short label] → [Recommendation].** [1-2 sentence rationale.]

[...repeat...]

---

## Confidence Flags

[List LOW CONFIDENCE, ASSUMPTION-DEPENDENT, and DEPENDENCY flags with brief explanation for each. If none, state "No flags."]
```

## Output Protocol

**Default mode: Release.** This skill produces a complete recommendation set in a single pass. No refinement mode — the QC step provides the review function.

Write to the specified output path (default: `analysis/{section}-memo-review-recommendations.md`).

## Quality Guardrails

- Every recommendation must cite specific evidence from the cluster memos by finding label, evidence grade, or source reference. If a recommendation cannot be grounded in memo evidence, state this explicitly rather than reasoning from general knowledge.
- Do not recommend based on what would be strategically convenient for the service model. Recommendations must follow evidence weight, not narrative preference.
- If two options are genuinely equivalent given the evidence, say so and present both with trade-offs rather than arbitrarily picking one.
- Do not pad recommendations with hedging language to appear balanced. If the evidence clearly favors one option, recommend it directly.
- Recommendation count must match decision count exactly. Do not skip decisions or invent new ones.

## Evidence Integrity Rules

- Operate only from provided memos, scarcity register, and directives. Do not supplement with external knowledge.
- Preserve evidence strength labels exactly as they appear in cluster memos.
- If a scarcity register item's editorial instruction options don't fit the evidence situation, flag the mismatch rather than forcing a choice.
- Distinguish between "the evidence supports X" and "X would be rhetorically effective." Only the former grounds a recommendation.
