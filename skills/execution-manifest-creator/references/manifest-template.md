# Execution Manifest Template

Use this template for the output. Adapt section counts to match the actual routing results — omit the Research GPT Sessions section entirely if all questions route to CustomGPT, and omit the CustomGPT Research Queue if all route to Research GPT.

---

```markdown
# Execution Manifest: [Section ID] — [Section Title]

## Routing Summary

| Question ID | Question Short Title | Route | Routing Rationale |
|-------------|---------------------|-------|-------------------|
| Q1 | [Title] | Research GPT | [1-line reason specific to this question] |
| Q2 | [Title] | CustomGPT | [1-line reason specific to this question] |
| ... | ... | ... | ... |

**Distribution:** [X] questions → Research GPT, [Y] questions → CustomGPT

## Research GPT Sessions

**Sessions: [count]**

| Session | Questions | Cluster Logic | Dependencies | Tool |
|---------|-----------|---------------|--------------|------|
| A | Q1, Q2 | [Why grouped — source overlap, conceptual chain, or analytical lens] | None | Research GPT |
| B | Q3, Q5 | [Why grouped] | After Session A | Perplexity |
| C | Q6, Q7 | [Why grouped] | None | Research GPT |

**Parallel opportunities:** [Which sessions can run simultaneously]

## CustomGPT Research Queue

| Question ID | Question Short Title | Batch | Notes |
|-------------|---------------------|-------|-------|
| Q4 | [Title] | 1 | [Execution notes — specific sources to target, known constraints] |
| Q10 | [Title] | 1 | [Notes] |
| Q11 | [Title] | 2 | [Notes] |

**Execution approach:** Run in the Research CustomGPT with web access. Batch 2–3 questions per run. Paste the Answer Specs for the batch. Each question should produce a sourced research report that Claude can extract from downstream.

## Operator Notes

[Any flags, uncertainties, or recommendations for the operator — e.g., borderline routing decisions that may need override, anticipated thin-results areas, suggestions for execution order between Research GPT and CustomGPT paths]
```
