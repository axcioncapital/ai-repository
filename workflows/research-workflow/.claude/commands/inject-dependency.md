Inject prior research output from completed sessions into dependent session prompts.

Usage: `/inject-dependency [session-letters]` — e.g., `/inject-dependency B,E` or `/inject-dependency A,B,C,D,E`

The session letters identify which sessions have been completed and whose findings should be injected downstream.

---

### Step 0: Resolve current section

1. Read `/logs/session-notes.md` to identify the current section and its execution mapping (waves, session-to-question assignments, dependency map).
2. The most recent session note entry for Stage 2 execution contains the wave plan and dependency structure.
3. Use the resolved section identifier for all file paths below.

### Step 1: Read the dependency map

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md`.
2. Cross-reference with the execution mapping from session notes.
3. Identify the dependency map — which sessions depend on which (hard and soft).
4. For each completed session letter provided, identify all downstream sessions that list it as a dependency.
5. Report: which downstream prompts will be updated, and which dependencies they require.

### Step 2: Extract key findings

For each completed session letter provided:

1. Read the raw report from `/execution/raw-reports/{section}/{section}-session-[letter]-raw-report.md`.
2. Extract a structured summary of key findings — the structural output that downstream sessions need for context. Focus on:
   - Provider categories identified and named examples
   - Key quantitative signals (market sizes, adoption rates, fee structures, prevalence data)
   - Chain activity coverage patterns
   - Domain-specific shortcomings and their mechanisms
   - Hypothesis verdicts (if applicable)
   - Nordic-specific findings vs proxy-level evidence
3. Keep each session summary to 8-12 bullet points. Be factual, not analytical — downstream sessions do their own analysis.

### Step 3: Build or update the PRIOR RESEARCH OUTPUT block

1. Check each downstream session prompt for an existing `--- PRIOR RESEARCH OUTPUT ---` block.
2. If no block exists: create one after `--- END CONTEXT PACK ---` and before the session body text. Use this format:

```
--- PRIOR RESEARCH OUTPUT ---
The following findings come from Sessions [letters] of this research. Use them as context when answering [downstream questions]. Do not re-research these topics — build on what is established.

Category [N] — [Provider category] (Session [letter], Q[N]):
- [bullet point findings]

[repeat per category]
--- END PRIOR RESEARCH OUTPUT ---
```

3. If a block already exists: update it in place — replace placeholder entries (e.g., `[To be added...]`) with actual findings, add new category sections for newly completed sessions, and update the header to reflect all sessions now included.
4. Do NOT modify anything outside the `--- PRIOR RESEARCH OUTPUT ---` / `--- END PRIOR RESEARCH OUTPUT ---` delimiters.

### Step 4: Write and report

1. Write the updated prompt file(s).
2. Commit with message: `Auto-commit [execution]: inject dependency [letters] into session-[downstream] prompt`
3. Report:
   - Which files were updated
   - Which category summaries were injected
   - Which downstream sessions are now ready for execution
   - Any sessions still blocked by missing dependencies
