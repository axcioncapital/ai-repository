---
name: supplementary-research-qc
description: >
  QC gate for raw Perplexity supplementary research results. Filters results
  before merge into Research Extracts by running three checks per query result:
  gap closure assessment, source quality screen, and redundancy check. Produces
  per-query MERGE/SKIP/PARTIAL verdicts and a merge summary for operator review.

  Step 2.S3 in Stage 2 Subworkflow 2.S. Use when operator has executed Perplexity
  queries from the supplementary query brief and provides raw output for QC.
  Triggered by "QC supplementary results," "review Perplexity output," "run
  step 2.S3," or similar.

  Do NOT use for QC of Deep Research reports (that's research-extract-verifier).
  Do NOT use for merging evidence (that's supplementary-evidence-merger at
  Step 2.S4). Do NOT use for drafting queries (that's supplementary-query-brief-drafter).
---

# Supplementary Research QC

Review raw Perplexity research results before they are merged into existing Research Extracts. Filter out results that don't add value — wrong target, low quality, or redundant — so only useful evidence reaches the merge step.

**Workflow position:** Step 2.S3 in Subworkflow 2.S. Receives raw Perplexity output from Step 2.S2. MERGE/PARTIAL verdicts flow to Step 2.S4. SKIP verdicts are documented and dropped.

## Calibration

Be selective but not punitive. The purpose is to prevent bad evidence from entering extracts, not to set an impossibly high bar. A single credible Medium-strength claim that moves a component from MISSING to THIN, or from THIN closer to COVERED, has value.

## Input

Three items, provided together:

1. **Raw Perplexity output** — for all queries in this pass, organized by query number
2. **Research Extracts** — for all affected questions (needed for redundancy checking and gap context)
3. **Query Brief Section A** — for this pass (needed for success signals, component mapping, and the Already Searched inventory used in Check 3)

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them
- Verify query numbers in the Perplexity output match the Execution Sheet
- If queries are missing from the output, note which are absent and proceed with available results

## QC Checks

Run three checks per query result, in order.

### Check 1 — Gap Closure Assessment

Does this result address the THIN or MISSING component it was targeting?

- Review the query's intended target (from the Query Brief's Section A: which components, which coverage gaps).
- Review the success signal defined for this query.
- Assess: would adding claims from this result change the coverage verdict? Specifically:
  - For MISSING components: does the result provide at least 1 credible claim for the component?
  - For THIN components: does the result provide additional independent sources or higher-strength evidence than what's already in the Research Extract?
- If the result is topically adjacent but doesn't address the specific component gap, it fails this check.

### Check 2 — Source Quality Screen

Is the source credible enough to merit inclusion?

- **Source type:** Primary/institutional data, academic research, established industry publications → accept. Vendor marketing, SEO content, undated blog posts, anonymous forums → reject unless the claim is corroborated elsewhere in the results.
- **Recency:** Flag sources older than 5 years unless the claim is structural/definitional (not market data or practice descriptions).
- **Attribution clarity:** Can you identify the author, institution, or publication? If the source is unattributable, reject.
- **Bias indicators:** Is the source selling something related to the claim? If yes, flag as vendor/advocacy — acceptable only as Low-strength corroboration, not as primary evidence.

### Check 3 — Redundancy Check

Is this genuinely new evidence?

- Compare the result's key claims against the existing claims in the Research Extract for the targeted component.
- **Also compare against the Query Brief's Already Searched inventory** (in Section A, if present). A result that returns a source type listed as "searched but returned nothing useful" is not automatically redundant — but if the result returns the *same* source previously searched and still provides nothing beyond what was already known, flag it as a wasted retrieval.
- Redundant if: same factual assertion, same primary data source (even if accessed via a different URL or secondary publication), same finding restated with different wording, **or same source type that was already searched and returned nothing useful — unless the result provides materially different content from that source type than what prior searches returned.**
- Not redundant if: same topic but different data, different time period, different geography, different methodological approach, or an independent source arriving at the same conclusion (this adds independence, which has value).

## Verdict Logic

**MERGE** — Passes all three checks. Adds genuine new evidence to a targeted component.

**SKIP** — Fails any check decisively:
- Check 1 fail: doesn't address the targeted gap
- Check 2 fail: source not credible enough for inclusion
- Check 3 fail: fully redundant with existing evidence

**PARTIAL** — Some claims pass, others don't. Specify which claims to merge and which to skip.

## Output Format

### Per-Query Verdicts

| Query | Verdict | Rationale |
|-------|---------|-----------|
| [Query # from Execution Sheet] | MERGE / SKIP / PARTIAL | [1–2 sentences: what the result adds or why it doesn't] |

### Merge Summary

```
MERGE:
- Query [#]: [1-line summary of what it adds, which component it targets]
- Query [#]: ...

SKIP:
- Query [#]: [1-line reason]
- Query [#]: ...

PARTIAL:
- Query [#]: Merge [specific claims]. Skip [specific claims]. Reason: [1-line]
```

## Output Protocol

Write the QC report to `/execution/supplementary/{section}-supplementary-qc-pass-[1/2].md`. Provide a brief summary in chat: MERGE/SKIP/PARTIAL counts and the merge summary for operator review.

## Scope Boundaries

- Do not merge evidence into extracts — verdicts only (merging is Step 2.S4)
- Do not supplement evidence from training data
- Do not re-run or modify queries — assessment only
- Do not override operator decisions on which components warrant supplementary research
