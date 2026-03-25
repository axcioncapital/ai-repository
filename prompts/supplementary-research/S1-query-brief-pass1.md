# S.1 — Draft Supplementary Query Brief

> **Sub-workflow step:** S.1 — Draft Supplementary Query Brief (Pass 1)
> **Execution environment:** Claude (project)
> **Required inputs:** Research Extracts for all affected questions (with THIN/MISSING verdicts); Answer Specs for all affected questions
> **Output:** Two-section Query Brief: Section A (analysis and reasoning) + Section B (paste-ready Execution Sheet of Perplexity queries)

---

Here are the Research Extracts with THIN or MISSING coverage verdicts, confirmed by the operator as warranting supplementary research. Your job is to produce a Perplexity Query Brief — a set of self-contained search queries that resolve the identified gaps.

**Step 1: Triage and group**

- Remove any items where the THIN/MISSING verdict reflects a documentation or extraction issue rather than an evidence gap (e.g., evidence exists in the Deep Research report but was missed during extraction). List them separately under **ROUTE OUT — Re-extraction Items** with the step to return to (Step 2.3).
- Group remaining gaps by shared source universe — components likely resolved by the same searches go together, regardless of Question ID. Name each group by the source universe it targets (e.g., "Nordic PE practitioner sources," "Academic PE fund lifecycle research").

**Step 2: Analyze and draft**

For each group, work through this analysis (this becomes Section A of the output):

- State which components (Question ID + component name) the group covers and the coverage verdict (THIN or MISSING) from the Research Extract.
- Review the existing claims in the Research Extracts for these components. List the source types already represented (e.g., "US-focused academic surveys, practitioner training sites, industry reports from Bain/McKinsey").
- Identify source types that are plausible for this topic but absent from existing evidence. These become the targeting basis.
- Draft 3–5 Perplexity queries ranked by expected yield. Each query must be:
  - Self-contained (Perplexity has no cross-query memory and no knowledge of prior research)
  - Non-overlapping with other queries in the group
  - Written as the literal text to paste into Perplexity — include source targeting directly in the query wording (e.g., "Focus on Nordic PE association reports and European mid-market advisory publications")
- Per query, note: success signal (what a good result looks like), and which components it could satisfy.

**Step 3: Budget check**

Total queries across all groups must not exceed 12. If over budget:

- Prioritize by verdict severity: MISSING > THIN
- Within the same severity, prioritize components where existing claims are weakest (all Low strength, single source)
- List cut queries under **DEFERRED** with the reasoning

**Step 4: Produce output in two sections**

Structure the output as follows:

---

**Section A: Analysis** (reasoning and context — for reference)

For each group:
- Group name and source universe
- Components covered (IDs + verdicts)
- Existing source types in evidence
- Target source types (absent but plausible)
- Per-query: success signal and component mapping

---

**Section B: Execution Sheet** (paste-ready — for workflow use)

A numbered list of every query, in execution order, formatted as code blocks. Nothing else in this section — no analysis, no explanations, no component IDs between queries. Just the queries.

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
Group: [Next group name]
```

```
Query 3:
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

**Inputs required:**

- Research Extracts for all affected questions (paste below — needed to identify existing source types and avoid duplicate sourcing)
- Answer Specs for all affected questions (paste below — needed to understand what a complete answer requires)

[paste Research Extracts]

[paste Answer Specs]
