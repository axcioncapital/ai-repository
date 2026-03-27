---
name: supplementary-query-brief-drafter
description: >
  Drafts Perplexity query briefs for supplementary research on THIN or MISSING
  extract components. Analyzes existing evidence, identifies absent source types,
  and produces grouped, paste-ready queries (max 12) with success signals,
  minimum yield thresholds, and contingency flags for overlapping queries.
  Supports pass 1 (initial) and pass 2 (revised strategy after pass 1 failure
  diagnosis).

  Step 2.S1 in Stage 2 Subworkflow 2.S. Use when Research Extracts have approved
  but show THIN or MISSING coverage verdicts that the operator has confirmed
  warrant supplementary research. Triggered by "/run-supplementary" or operator
  requests like "draft supplementary queries," "prepare Perplexity queries for
  thin components," "run step 2.S1," or similar.

  Do NOT use for initial research execution (that's Stage 2 Steps 2.0–2.2 via
  Research Execution GPT). Do NOT use for extract creation or verification
  (Steps 2.3–2.4). Do NOT use for Stage 3 gap resolution (Subworkflow 3.S).
---

# Supplementary Query Brief Drafter

Draft targeted Perplexity search queries to resolve THIN or MISSING coverage in approved Research Extracts. Produces a two-section output: Section A (analysis and reasoning) and Section B (paste-ready execution sheet).

**Workflow position:** Step 2.S1 in Subworkflow 2.S. Receives failed component list from Step 2.S0. Output feeds operator execution in Perplexity at Step 2.S2.

## Calibration

Not every THIN verdict requires supplementary research — some reflect genuine evidence scarcity that no amount of Perplexity queries will resolve. Focus queries on components where plausible but untapped source types exist. If a component's gap is structural (the data simply isn't published), say so in the analysis rather than drafting low-yield queries. Each query's minimum yield threshold should reflect this judgment — set realistic thresholds based on what evidence plausibly exists, not what would be ideal.

## Input

Three items, provided together:

1. **Failed Component Extraction** — structured list from Step 2.S0 (components with THIN or MISSING verdicts, grouped by Question ID)
2. **Research Extracts** — for all affected questions (needed to identify existing source types and avoid duplicate sourcing)
3. **Answer Specs** — for all affected questions (needed to understand what a complete answer requires)

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them
- Verify component IDs in the failed extraction match components in the Answer Specs
- If mismatched: state the mismatch, request correction, do not proceed

## Pass 1 — Initial Query Brief

### Step 1: Triage and Group

- Remove any items where the THIN/MISSING verdict reflects a documentation or extraction issue rather than an evidence gap (e.g., evidence exists in the Deep Research report but was missed during extraction). List them separately under **ROUTE OUT — Re-extraction Items** with the step to return to (Step 2.3).
- Group remaining gaps by shared source universe — components likely resolved by the same searches go together, regardless of Question ID. Name each group by the source universe it targets (e.g., "Nordic PE practitioner sources," "Academic PE fund lifecycle research").

If all components are routed out (re-extraction or structural scarcity) and zero groups remain, produce Section A only with the routing decisions. Skip Section B and file creation. Report in chat that no supplementary queries are warranted and list where each component was routed.

### Step 2: Analyze and Draft

For each group, work through this analysis (this becomes Section A of the output):

- State which components (Question ID + component name) the group covers and the coverage verdict (THIN or MISSING) from the Research Extract.
- Review the existing claims in the Research Extracts for these components. List the source types already represented (e.g., "US-focused academic surveys, practitioner training sites, industry reports from Bain/McKinsey").
- Identify source types that are plausible for this topic but absent from existing evidence. These become the targeting basis.
- Draft 3–5 Perplexity queries ranked by expected yield. Each query must be:
  - **Single-intent** — one clear question per query. If you find yourself using "and" or "additionally" to connect distinct questions, split them. A query like "What frameworks exist for X, and what academic research supports Y?" is two queries. Perplexity latches onto the easiest sub-question and gives shallow coverage on the rest.
  - Self-contained (Perplexity has no cross-query memory and no knowledge of prior research)
  - Non-overlapping with other queries in the group. After drafting, check for **source overlap** across groups: if two queries target the same institutions, databases, or publication types, flag the second as **contingent** — execute only if the first doesn't return that source type. Mark contingent queries in both Section A and Section B.
  - Written as the literal text to paste into Perplexity — include source targeting directly in the query wording
  - **Context prefix must match the target source universe.** If the group targets practitioner content (blogs, podcasts, LinkedIn commentary, conference talks), frame the query accordingly — do not default to "professional advisory report" framing, which biases Perplexity toward formal publications. Match the register to what you're looking for: informal framing for informal sources, academic framing for academic sources.
- Per query, note:
  - **Success signal** — what a good result looks like (source type, specificity, geographic relevance)
  - **Minimum yield threshold** — the minimum evidence that would move the component's verdict. Be concrete: "At least 2 independent sources with quantitative data" or "One practitioner account with specific deal examples." If a query returns results below this threshold, the component remains at its current verdict — the operator should not re-run the same angle.
  - Which components it could satisfy

### Step 3: Budget Check

Total queries across all groups must not exceed 12. Contingent queries count toward the budget but are tracked separately — note the effective range (e.g., "10–12 queries depending on contingency outcomes"). If over budget:

- Prioritize by verdict severity: MISSING > THIN
- Within the same severity, prioritize components where existing claims are weakest (all Low strength, single source)
- Prefer cutting a non-contingent query over a contingent one (contingent queries are already conditional spend)
- List cut queries under **DEFERRED** with the reasoning

### Step 4: Produce Output

Structure the output in two sections:

---

**Section A: Analysis** (reasoning and context — for reference)

For each group:
- Group name and source universe
- Components covered (IDs + verdicts)
- Existing source types in evidence
- Target source types (absent but plausible)
- Per-query: success signal, minimum yield threshold, component mapping, and contingency flags

---

**Section B: Execution Sheet** (paste-ready — for workflow use)

A numbered list of every query, in execution order, formatted as code blocks. Contingent queries are marked so the operator can skip them if the dependency query already returned the target source type.

Format:

```
Group: [Group name]
```

```
Query 1:
[Literal text to paste into Perplexity]
```

```
Query 2:
[Literal text to paste into Perplexity]
```

```
Query 3 [CONTINGENT — skip if Query 1 returns [source type]]:
[Literal text to paste into Perplexity]
```

```
Group: [Next group name]
```

```
Query 4:
[Literal text to paste into Perplexity]
```

...and so on through all queries.

After the last query, include:

```
DEFERRED (if any):
- [Query text] — Reason: [why it was cut]
```

---

The operator works from Section B during execution. Section A is reference material for reviewing results and mapping them back to components.

## Pass 2 — Revised Query Brief

Use this variant when pass 1 didn't close remaining gaps. Requires additional inputs:

4. **Pass 1 Query Brief** — needed to diagnose what was already tried
5. **Pass 1 raw Perplexity output** — needed to assess what was returned
6. **Updated Research Extracts** — post-pass 1 merge, with current coverage verdicts

### Step 1: Diagnose Pass 1

For each group from the pass 1 Query Brief that still has open gaps:

- List which components (Question ID + component name) remain THIN or MISSING and their verdict from the updated Research Extract.
- Review what pass 1 attempted: queries run, source types returned, what came close vs. what missed entirely.
- Classify the failure reason per component:
  - **Wrong query angle** — relevant sources likely exist but pass 1 queries didn't surface them
  - **Source type mismatch** — results were topically relevant but wrong source type for the coverage requirement
  - **Confirmed scarcity** — multiple reasonable query angles tried, evidence likely doesn't exist in accessible web sources

Components classified as **confirmed scarcity** exit here. List them under **ROUTE OUT — Confirmed Scarcity** with the evidence: queries attempted, what was returned, why you believe further searching won't help. These become Known Gaps in the Research Extract's Gaps section and entries in the scarcity register.

### Step 2: Analyze and Draft Revised Queries

For remaining groups (this becomes Section A of the output):

- Maintain or re-group based on shared source universe (groups may have changed if some components closed in pass 1).
- Review existing source types now in evidence (original Deep Research sources + pass 1 supplementary sources). Identify source types that are plausible for this topic but still absent from evidence. These become the targeting basis.
- Draft 3–5 Perplexity queries per group ranked by expected yield. Each query must be:
  - **Single-intent** — one clear question per query. Do not bundle sub-questions. This is even more important in pass 2 where precision matters — broad queries already failed in pass 1.
  - Self-contained (Perplexity has no cross-query memory and no knowledge of prior research)
  - Non-overlapping with other queries in this brief AND with pass 1 queries. Check for **source overlap** across groups and with pass 1 queries — if two queries target the same institutions or publication types, flag the second as **contingent**.
  - Using a **different search strategy** than pass 1 — different source types, terminology, framing, or angle
  - Written as the literal text to paste into Perplexity — include source targeting directly in the query wording
  - **Context prefix must match the target source universe.** Do not reuse the same framing as pass 1 if pass 1's framing biased results toward the wrong source types.
- Per query, note:
  - **Success signal** — what a good result looks like
  - **Minimum yield threshold** — the minimum evidence that would move the component's verdict (same format as pass 1). In pass 2, thresholds should be tighter — if pass 1 already added some evidence, specify what's still missing, not what's needed from scratch.
  - Which components it could satisfy, and how the strategy differs from pass 1

### Step 3: Budget Check

Same as pass 1 — max 12 queries total. Same prioritization rules.

### Step 4: Produce Output

Structure as two sections:

---

**Section A: Diagnosis and Analysis** (reasoning and context — for reference)

Pass 1 diagnosis:
- Per group: what was attempted, what failed, failure classification per component
- ROUTE OUT — Confirmed Scarcity (components exiting as Known Gaps)

Revised query analysis:
- Per group: components covered, existing source types (original + pass 1), target source types for pass 2, per-query success signals with minimum yield thresholds, component mapping, contingency flags, and how each query's strategy differs from pass 1

---

**Section B: Execution Sheet** (paste-ready — for workflow use)

Same format as pass 1. After the last query, include:

```
DEFERRED (if any):
- [Query text] — Reason: [why it was cut]
```

```
CONFIRMED SCARCITY:
- [Component ID] — [1-line summary of why further search won't help]
```

---

## Output Protocol

Write the query brief to `/execution/supplementary/{section}-query-brief-pass-[1/2].md`. Provide a brief summary in chat: number of groups, number of queries, any components routed out (re-extraction or confirmed scarcity).

## Scope Boundaries

- Do not execute queries — drafting only
- Do not supplement evidence from training data
- Do not modify Research Extracts — that's Step 2.S4
- Do not assess whether supplementary research is needed — that decision is upstream (operator + Step 2.S0)
