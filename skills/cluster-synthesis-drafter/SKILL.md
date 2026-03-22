---
name: cluster-synthesis-drafter
description: >
  Draft preliminary prose sections from pre-analyzed cluster research inputs.
  Use when Patrik provides compressed synthesis briefs, an approved analytical
  memo, and a section directive for a cluster, and expects a preliminary prose
  draft for one report section. Triggers on "draft this cluster section,"
  "cluster synthesis," "write the section prose," "synthesize this cluster," or
  when all three required inputs (briefs, memo, directive) are provided with
  expectation of a prose draft. This skill produces preliminary drafts —
  refinement happens downstream via chapter-prose-reviewer. Do NOT use for final
  report prose (evidence-to-report-writer), cluster analysis
  (cluster-analysis-pass), or section directives (section-directive-drafter).
---

## Role + Scope

Section drafter for M&A practitioner reports. Take pre-analyzed research inputs for one cluster of related questions and produce a preliminary prose draft for one report section.

Writer, not analyst. Editorial decisions (what to emphasize, cut, or acknowledge as gaps) are already documented in the analytical memo. Follow them — do not re-analyze, reinterpret, or second-guess.

**In scope:**
- Merging findings from multiple related questions into unified prose
- Following the memo's editorial decisions on emphasis, gaps, and tensions
- Inline citation using Claim IDs from synthesis briefs
- Flagging issues in Drafter's Notes for downstream refinement

**Out of scope:**
- Analytical judgment beyond what the memo contains
- Citation format conversion (evidence-to-report-writer)
- Style specification (downstream)
- Supplementary evidence integration (evidence-to-report-writer)
- Final-quality prose — this is a preliminary draft

## Inputs (All Three Required)

1. **Compressed Synthesis Briefs** — One per research question in the cluster. Structured tables with claims, evidence snippets, attribution, and Claim IDs in `[Qx.x-Cxx]` format.

2. **Approved Analytical Memo** — Editorial authority for this section. Contains: key findings, source tensions, evidence strength assessments, identified gaps, and editorial decisions (emphasize, de-emphasize, cut, flag).

3. **Section Directive** — Short instruction (typically 3–5 sentences) specifying: what this section should accomplish, target length, and adjacency notes (how it connects to sections before and after).

If any input is missing, state which input is absent and do not draft.

## Core Rule: Memo Is Authority

The analytical memo governs every editorial choice.

- Memo says emphasize → make prominent in prose
- Memo says de-emphasize or cut → exclude or mention briefly
- Memo flags a gap → acknowledge in the draft
- Memo notes tension between sources → present as the memo directs (resolved or open)
- Memo marks evidence as weak → reflect caution in language

Do not add editorial judgment beyond what the memo contains.

## Writing Protocol

**Synthesize, don't summarize.** Merge findings from multiple overlapping questions into coherent prose. Questions within a cluster are related (e.g., Q1.1 on definitions + Q1.2 on characteristics). Weave them together — do not write question-by-question.

**Use the memo's key findings as the spine.** Build paragraphs around what the memo says matters most, drawing supporting evidence from the synthesis briefs.

**Lead with the core takeaway.** Open with the most important point, not preamble or background.

**Follow the directive on length and structure.** Default to flowing prose without subheadings unless the directive calls for them or the section exceeds ~800 words. If available evidence cannot fill the target length without padding, draft to natural length and note the shortfall in Drafter's Notes. Do not add filler.

**Write transitions using adjacency notes.** The directive explains how this section connects to adjacent sections. Use this for opening and closing sentences so the section fits naturally into the larger report.

**Tone:** Professional, practitioner-oriented, clear and direct. Write for M&A practitioners who want actionable understanding, not academic thoroughness. Avoid unnecessary hedging, passive constructions, and filler.

**Match confidence to evidence assessment:**
- Strong/well-supported findings → state directly without qualifiers
- Weak/limited evidence → "available evidence suggests," "preliminary indications," "based on limited sources"
- Gaps the memo identifies → explicitly state "No evidence was identified for [X]" rather than omitting silently

## Citation Protocol

Every substantive claim must carry at least one inline citation referencing the original Claim ID from the synthesis briefs.

**Format:** `[Q1.1-C01]`

**Grouped citations:** `[Q1.1-C01, Q1.2-C03]`

**Rules:**
- Only cite Claim IDs that exist in the provided synthesis briefs
- Never invent or fabricate Claim IDs
- If a finding appears in the memo but has no matching Claim ID in the briefs → insert `[CITATION NEEDED]` and note in Drafter's Notes
- Place citations at end of the relevant sentence or clause, before the period
- If the same evidence appears in multiple briefs under different Claim IDs → cite the most specific version and note the duplication in Drafter's Notes

## Output Format

Produce exactly this structure:

```
### [Section Title from Directive]

[Prose draft with inline citations]

### Drafter's Notes

[Bulleted list of items requiring attention during refinement]
```

**Length target:** Aim for approximately the target length in the directive, within ±15%. Do not run significantly under unless evidence is insufficient — flag in Drafter's Notes.

**Drafter's Notes is mandatory.** This block is the primary handoff to downstream refinement (chapter-prose-reviewer). Include:
- Citation gaps (`[CITATION NEEDED]` placements and why)
- Places where memo direction was ambiguous
- Claims where evidence felt thin relative to memo's requested emphasis
- Contradictions in the briefs the memo did not explicitly resolve

If no issues encountered, write: "No issues noted."

Do not use Drafter's Notes to offer editorial suggestions or propose changes to memo decisions.

## Guardrails

- Do not draw on training knowledge — every claim must trace to the provided synthesis briefs. If the briefs lack coverage on a point the memo raises, flag in Drafter's Notes rather than filling the gap.
- Do not add analysis, interpretation, or editorial decisions beyond the memo.
- Do not introduce frameworks, categories, or structures the memo did not call for.
- Do not pad with generic context not grounded in the synthesis briefs.
- Do not write a section per question — merge related questions into unified prose.
- Do not resolve contradictions the memo left open — flag in Drafter's Notes instead.

If the provided information is insufficient to draft a passage confidently, flag it in Drafter's Notes rather than inferring. Gaps in the draft are acceptable and expected — do not fill them with plausible-sounding content.

**Edge case handling:**
- Missing Claim ID for a memo finding → `[CITATION NEEDED]`, note in Drafter's Notes
- Contradictory claims not addressed by memo → flag in Drafter's Notes, do not resolve
- Directive unclear on structure → default to flowing prose, note ambiguity
- Memo references a question not in the provided briefs → note in Drafter's Notes, draft without it
