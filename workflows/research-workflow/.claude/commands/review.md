---
friction-log: true
---
Review a chapter against the research workflow's upstream artifacts.

Input: $ARGUMENTS should specify the chapter number (e.g., `01`, `02`) or file path.

---

### Step 1: Resolve Chapter and Load Inputs

1. Resolve the chapter file:
   - If a file path is provided, use it directly.
   - If a chapter number is provided, resolve to `/report/chapters/chapter-$ARGUMENTS.md`.
   - If a cited version exists (`chapter-$ARGUMENTS-cited.md`), ask the operator which version to review. Default to the base version if no cited version exists.

2. Determine which cluster this chapter belongs to by reading the architecture (`/report/architecture/{section}/{section}-architecture.md`) and matching the chapter number to a cluster.

3. Load the following inputs (read all files):
   - Chapter prose (resolved in step 1)
   - Architecture section spec: extract the relevant section from `/report/architecture/{section}/{section}-architecture.md` (the section hierarchy entry, depth allocation row, cross-reference map entries, traceability table rows, and writer compliance checklist items for this chapter)
   - Style reference: `/report/style-reference/{section}/{section}-style-reference.md`
   - Section directive: `/analysis/section-directives/{section}/{section}-cluster-NN-directive.md` (matched by cluster)
   - Scarcity register: `/execution/scarcity-register/{section}/{section}-scarcity-register.md`
   - Cluster memo: `/analysis/cluster-memos/{section}/{section}-cluster-NN-memo-refined.md` (matched by cluster)
   - Synthesis brief: `/analysis/chapters/{section}/{section}-cluster-NN-draft.md` (matched by cluster, if exists)

4. **Blocking-input check:** Verify that the architecture section spec, style reference, and section directive were all loaded successfully. If any of these three inputs is missing or empty, STOP and report which input is absent. Do not proceed to Step 2 without all three.

5. Identify which scarcity register items fall within this chapter's scope by cross-referencing the scarcity register against the architecture's traceability table and the directive's claim allocation.

---

### Step 2: Execute Review [delegate-qc]

6. Read `/ai-resources/skills/chapter-review/SKILL.md`.
7. Launch a **qc-gate** sub-agent. Pass it:
   - The skill content (as evaluation criteria)
   - The chapter prose
   - The architecture section spec (extracted content for this chapter only)
   - The style reference
   - The section directive
   - The scarcity register
   - The cluster memo
   - The synthesis brief (if available)
   - A note identifying which scarcity items are in scope for this chapter (from step 5)

   Task: Evaluate the chapter against all six checks defined in the skill. Produce the findings report, verdict, priority fixes, and scarcity compliance summary.

8. Write the review report to `/report/checkpoints/{section}/{section}-chapter-$ARGUMENTS-review.md`.
9. ▸ /compact — skill content, chapter prose, and upstream artifacts no longer needed; review report and verdict carry forward.

---

### Step 3: Log Verdict

10. Log the verdict to `/logs/qc-log.md` with this format:

```
## [date] — Chapter [NN] Review (/review)

**Chapter:** [chapter title from architecture]
**Verdict:** [PASS / CONDITIONAL PASS / REVISE]
**Findings:** [count by severity: N HIGH, N MEDIUM, N LOW]
**Scarcity compliance:** [N/N items implemented]
**Review report:** `report/checkpoints/{section}-chapter-NN-review.md`
```

11. Present the verdict and summary assessment to the operator. If REVISE, list the HIGH-severity findings. If CONDITIONAL PASS, list the MEDIUM-severity findings and ask whether to proceed or fix first.

---

### Notes

- This command can be run at any point during Stage 4 — after initial drafting, after revisions, before or after citation conversion.
- It does NOT apply fixes. Fixes are a separate step subject to the bright-line rule.
- It does NOT replace Stage 5's `document-integration-qc`, which checks cross-module integration (different scope).
- Multiple runs on the same chapter append new entries to the QC log rather than overwriting.
