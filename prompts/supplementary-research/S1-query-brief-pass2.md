# S.1-P2 — Draft Supplementary Query Brief (Pass 2)

> **Sub-workflow step:** S.1 — Draft Supplementary Query Brief (Pass 2)
> **Execution environment:** Claude (project)
> **Required inputs:** Updated Research Extracts (post-pass 1 merge); Answer Specs for all affected questions; Pass 1 Query Brief; Pass 1 raw Perplexity output
> **Output:** Two-section Query Brief: Section A (diagnosis + revised analysis) + Section B (paste-ready Execution Sheet with different search strategies)

---

Here are the Research Extracts still showing THIN or MISSING coverage verdicts after supplementary pass 1, along with the pass 1 materials. Your job is to diagnose why pass 1 didn't close the remaining gaps and produce a revised Perplexity Query Brief with different search strategies.

**Step 1: Diagnose pass 1**

For each group from the pass 1 Query Brief that still has open gaps:

- List which components (Question ID + component name) remain THIN or MISSING and their verdict from the updated Research Extract.
- Review what pass 1 attempted: queries run, source types returned, what came close vs. what missed entirely.
- Classify the failure reason per component:
  - **Wrong query angle** — relevant sources likely exist but pass 1 queries didn't surface them
  - **Source type mismatch** — results were topically relevant but wrong source type for the coverage requirement
  - **Confirmed scarcity** — multiple reasonable query angles tried, evidence likely doesn't exist in accessible web sources

Components classified as **confirmed scarcity** exit here. List them under **ROUTE OUT — Confirmed Scarcity** with the evidence: queries attempted, what was returned, why you believe further searching won't help. These become Known Gaps in the Research Extract's Gaps section.

**Step 2: Analyze and draft revised queries**

For remaining groups (this becomes Section A of the output):

- Maintain or re-group based on shared source universe (groups may have changed if some components closed in pass 1).
- Review existing source types now in evidence (original Deep Research sources + pass 1 supplementary sources). Identify source types that are plausible for this topic but still absent from evidence. These become the targeting basis.
- Draft 3–5 Perplexity queries per group ranked by expected yield. Each query must be:
  - Self-contained (Perplexity has no cross-query memory and no knowledge of prior research)
  - Non-overlapping with other queries in this brief AND with pass 1 queries
  - Using a **different search strategy** than pass 1 — different source types, terminology, framing, or angle
  - Written as the literal text to paste into Perplexity — include source targeting directly in the query wording
- Per query, note: success signal (what a good result looks like), which components it could satisfy, and how the strategy differs from pass 1.

**Step 3: Budget check**

Total queries across all groups must not exceed 12. If over budget:

- Prioritize by verdict severity: MISSING > THIN
- Within the same severity, prioritize components where existing claims are weakest (all Low strength, single source)
- List cut queries under **DEFERRED** with the reasoning

**Step 4: Produce output in two sections**

Structure the output as follows:

---

**Section A: Diagnosis and Analysis** (reasoning and context — for reference)

Pass 1 diagnosis:
- Per group: what was attempted, what failed, failure classification per component
- ROUTE OUT — Confirmed Scarcity (components exiting as Known Gaps)

Revised query analysis:
- Per group: components covered, existing source types (original + pass 1), target source types for pass 2, per-query success signals and component mapping, how each query's strategy differs from pass 1

---

**Section B: Execution Sheet** (paste-ready — for workflow use)

A numbered list of every query, in execution order, formatted as code blocks. Nothing else in this section — no analysis, no explanations between queries. Just the queries.

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

...and so on through all queries.

After the last query, include:

```
DEFERRED (if any):
- [Query text] — Reason: [why it was cut]
```

---

The operator works from Section B during execution. Section A is reference material for reviewing results and for documenting confirmed scarcity in Research Extracts.

**Inputs required:**

- Updated Research Extracts (post-pass 1 merge, with current coverage verdicts)
- Answer Specs for all affected questions
- Pass 1 Query Brief (needed to diagnose what was already tried)
- Pass 1 raw Perplexity output (needed to assess what was returned)

[paste updated Research Extracts]

[paste Answer Specs]

[paste pass 1 Query Brief]

[paste pass 1 raw Perplexity output]
