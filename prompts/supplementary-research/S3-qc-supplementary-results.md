# S.2-QC — QC Supplementary Research Results

> **Sub-workflow step:** S.3 — QC Supplementary Results
> **Execution environment:** Claude (project)
> **Required inputs:** Raw Perplexity output for all queries in this pass; Research Extracts for all affected questions; Query Brief Section A for this pass
> **Output:** Per-query MERGE/SKIP/PARTIAL verdicts + merge summary for operator review

---

You are reviewing raw Perplexity research results before they are merged into existing Research Extracts. Your job is to filter out results that don't add value — wrong target, low quality, or redundant — so only useful evidence reaches the merge step.

**Per query result, run three checks:**

**Check 1 — Gap closure assessment**

Does this result address the THIN or MISSING component it was targeting?

- Review the query's intended target (from the Query Brief's Section A: which components, which coverage gaps).
- Review the success signal defined for this query.
- Assess: would adding claims from this result change the coverage verdict? Specifically:
  - For MISSING components: does the result provide at least 1 credible claim for the component?
  - For THIN components: does the result provide additional independent sources or higher-strength evidence than what's already in the Research Extract?
- If the result is topically adjacent but doesn't address the specific component gap, it fails this check.

**Check 2 — Source quality screen**

Is the source credible enough to merit inclusion?

- **Source type:** Primary/institutional data, academic research, established industry publications → accept. Vendor marketing, SEO content, undated blog posts, anonymous forums → reject unless the claim is corroborated elsewhere in the results.
- **Recency:** Flag sources older than 5 years unless the claim is structural/definitional (not market data or practice descriptions).
- **Attribution clarity:** Can you identify the author, institution, or publication? If the source is unattributable, reject.
- **Bias indicators:** Is the source selling something related to the claim? If yes, flag as vendor/advocacy — acceptable only as Low-strength corroboration, not as primary evidence.

**Check 3 — Redundancy check**

Is this genuinely new evidence?

- Compare the result's key claims against the existing claims in the Research Extract for the targeted component.
- Redundant if: same factual assertion, same primary data source (even if accessed via a different URL or secondary publication), or same finding restated with different wording.
- Not redundant if: same topic but different data, different time period, different geography, different methodological approach, or an independent source arriving at the same conclusion (this adds independence, which has value).

**Produce a verdict per query result:**

| Query | Verdict | Rationale |
|-------|---------|-----------|
| [Query # from Execution Sheet] | MERGE / SKIP / PARTIAL | [1–2 sentences: what the result adds or why it doesn't] |

For PARTIAL verdicts, specify which claims from the result are worth merging and which should be skipped.

**After all verdicts, produce a merge summary:**

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

The operator reviews this summary and confirms before proceeding to the merge step.

**Inputs required:**

- Raw Perplexity output for all queries in this pass (paste below)
- Research Extracts for all affected questions (paste below — needed for redundancy checking and gap context)
- Query Brief Section A for this pass (paste below — needed for success signals and component mapping)

[paste Perplexity output]

[paste Research Extracts]

[paste Query Brief Section A]
