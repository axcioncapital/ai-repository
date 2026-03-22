---
name: analysis-pass-memo-review
description: >
  Reviews cluster analysis memos and surfaces editorial decisions the operator
  must make before synthesis. Generates structured questions — not answers. Use
  when a cluster analysis memo (from `cluster-analysis-pass`) is complete and
  needs editorial review before feeding into document architecture or synthesis.
  Triggers on requests like "run analysis pass memo review," "analysis pass
  review," "review this cluster memo," "editorial review," "surface editorial
  decisions," "what decisions do I need to make on this memo," or when a
  completed cluster memo is provided with expectation of editorial guidance. Do
  NOT use for writing the memo itself (use `cluster-analysis-pass`), for
  answering the questions it generates, or for final report review.
---

# Analysis Pass Memo Review

Read a cluster analysis memo and surface the specific editorial decisions the operator needs to make before the memo feeds into synthesis. Generate questions — not answers. Each question must be specific to memo content and answerable in one sentence.

## Input

A cluster analysis memo (output of `cluster-analysis-pass`).

Validate before proceeding:
- Input follows the cluster-analysis-pass memo structure (Key Findings, Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, Convergence Patterns, "So What" section)
- If the input doesn't match this structure, state what's missing and ask for clarification rather than forcing the review framework onto incompatible content

If the operator provides additional context (target audience, report purpose, thesis), use it to sharpen Framing/Positioning and Emphasis/Weighting questions. If not provided, generate questions that surface audience/purpose as a decision the operator needs to make.

## Review Process

Work through these five categories in order. Skip a category only if the memo genuinely contains nothing relevant to it. A short list is a good sign, not a failure — do not pad.

Every question must reference specific findings, tensions, or gaps from the memo. No generic prompts.

### 1. CC — Confidence Calibration

Scan the Evidence Strength Map. For every finding graded "Suggests" or "Preliminary signal," ask whether downstream prose should:
- Present it with hedged language matching its grade
- Strengthen the framing because cross-question convergence warrants it
- Downgrade it further because context makes even hedged language misleading

Also flag any finding labeled "Establishes" where the underlying evidence is thinner than the label implies (e.g., one High-grade source doing all the heavy lifting). Flag every `[GRADE INFERRED]` marker for explicit operator decision.

Format: `CC-[n]: [Finding reference]: Graded [X] based on [evidence basis]. Present as-is, strengthen, or soften?`

### 2. GH — Gap Handling

For each entry in "Gaps That Matter," ask how the operator wants to handle it:
- **Acknowledge openly** — state the gap in prose so the reader knows the boundary
- **Scope-bound** — define the report's scope such that the gap falls outside it
- **Route back** — flag for supplementary research before proceeding

Also surface implicit gaps — things the memo doesn't flag but that a PE/M&A reader would expect to see covered given the cluster topic.

Format: `GH-[n]: [Gap reference]: Acknowledge, scope-bound, or route back?`
For implicit gaps: `GH-[n]: The memo doesn't address [X] — intentional or a gap to flag?`

### 3. FP — Framing/Positioning

Identify findings where the same data could support opposite narratives. Common M&A/PE pattern pairs:
- Regulatory change: barrier to entry vs. compliance burden
- Market consolidation: roll-up opportunity vs. declining margins signal
- Geographic concentration: defensible position vs. concentration risk
- Emerging trend: first-mover advantage vs. unproven market

For each, ask which framing serves the report's purpose and audience.

These are common examples, not an exhaustive list. For cluster topics outside these patterns, identify domain-relevant framing pairs where the same evidence supports opposing interpretations.

Format: `FP-[n]: [Finding reference]: Could be framed as [A] or [B]. Which framing fits your audience and thesis?`

### 4. EW — Emphasis/Weighting

Review the Key Findings ranking:
- Are any lower-ranked findings actually more decision-relevant for the audience?
- Are any top-ranked findings well-established but low-impact ("true but obvious")?
- Should any finding be foregrounded or deliberately compressed based on report purpose?

Check the "So What" recommendations — do the emphasis points align with the operator's intent?

Format: `EW-[n]: [Finding reference]: Currently ranked [position]. Foregrounded because [reason]. Does your audience weight this the same way?`

### 5. TR — Tension Resolution

For each entry in "Cross-Question Tensions," ask for a resolution direction:
- **Resolve** — pick the position with stronger evidence and present it as the finding
- **Present both** — show the tension explicitly as unresolved, with evidence weights
- **Reframe** — the tension is an artifact of framing; restate to dissolve it

If the memo recommends a handling approach, ask whether the operator agrees or wants to override.

Format: `TR-[n]: [Tension reference]: Memo recommends [X]. Evidence split is [summary]. Agree, or override to [alternative]?`

## Output Format

Group questions under the five category headers. Number sequentially within each category (CC-1, CC-2; GH-1, GH-2; etc.).

After all questions, append:

**Decision count:** [total questions generated]
**Highest-stakes decisions:** [list 3-5 questions where the answer most significantly changes downstream prose]

## Quality Guardrails

- Every question must reference specific memo content by finding label, gap name, or tension description. If a question could apply to any memo, it's too generic — cut it.
- If the memo is clean and most decisions are obvious, say so explicitly.
- Aim for 8-15 total decisions. If exceeding 20, reassess whether questions are genuinely decision-relevant or over-reading.
- If the memo's own labels seem miscalibrated (e.g., evidence marked "Establishes" that rests on a single source), flag the miscalibration rather than accepting labels at face value.
- If provided information is insufficient to generate meaningful questions for a category, say so rather than inventing plausible-sounding editorial dilemmas.
- If fewer than 3 questions are generated across all categories, note that the memo may be underdeveloped for editorial review and suggest the operator check whether the cluster-analysis-pass ran with sufficient input briefs.

## Integration

This sits between Step 3.1 (`cluster-analysis-pass`) and Step 3.3 (cluster synthesis) in the Research Workflow. The memo enters as-is; it exits with editorial decisions attached. The operator answers the questions inline or as appended editorial notes before passing the annotated memo downstream.
