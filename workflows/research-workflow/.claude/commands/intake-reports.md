Intake raw research reports from Research Execution GPT or Perplexity sessions. Files and names them, checks dependencies, then hands off to `/run-execution` for extract creation and verification.

This command owns Step 2.2b (filing) and Step 2.2a (dependency injection) only. It does NOT run Steps 2.3–2.4 or any downstream processing — those belong to `/run-execution`.

Usage: `/intake-reports` — then follow the prompts.

**Model requirement:** This command MUST run on Opus. Raw reports must be written verbatim — never summarized, truncated, or compressed. Lower-capability models (Haiku, Sonnet) have been observed to summarize instead of copying full content. If delegating any part of this command to a sub-agent, use `model: "opus"`.

---

### Step 1: Identify and File Reports

1. Read the session plan from `/execution/research-prompts/{section}/session-plan.md` to recover session letters, question assignments, and dependency map.
2. Check `/execution/raw-reports/{section}/` for any new raw report files the operator may have already placed there (files not yet matching the canonical naming pattern `{section}-session-[letter]-raw-report.md`).
3. If no files found and nothing pasted, ask the operator to either paste the report content or specify the file path(s).
4. For each report, identify which session it belongs to by matching content against the session plan's question assignments (topics addressed, question IDs, session identifiers).
5. Present the proposed mapping to the operator: list each report with its assigned session letter and questions covered.
6. After confirmation, write each report to `/execution/raw-reports/{section}/{section}-session-[letter]-raw-report.md` (skip if already correctly named and placed). When writing raw reports: copy the operator's pasted content verbatim. Do not summarize, truncate, or restructure. The raw report file must contain the complete output exactly as pasted.
7. Report:
   - Which files were written (with canonical names)
   - Which sessions are now complete
   - Which downstream sessions are unblocked per the dependency map
   - Which sessions are still missing

---

### Step 2: Dependency Injection (if needed)

Check the dependency map. If any newly completed session has downstream dependents that haven't run yet:

1. Read the raw report for each session with dependents.
2. Extract the key structural output (core model/framework/taxonomy) that downstream sessions need.
3. Draft a `PRIOR RESEARCH OUTPUT` block for injection.
4. Present to operator for review.
5. After approval, inject into the dependent session prompt files under `/execution/research-prompts/{section}/`.
6. Confirm which files were updated.

Skip this step if no dependencies exist for the completed sessions.

---

### Handoff

After filing and dependency injection are complete, report status and suggest next action:

- If all sessions are now filed and no dependencies remain: **"Ready for extract creation. Run `/run-execution` to continue with Steps 2.3–2.4."**
- If some sessions are still missing: **"Sessions [X, Y] still outstanding. Run `/intake-reports` again when they're ready. Sessions [A, B, C] can proceed — run `/run-execution` to create extracts for available sessions."**
- If dependency injection was performed: **"Session [F] prompt updated with prior research output. Execute Session [F] in Research Execution GPT, then run `/intake-reports` again to file that report."**
