---
model: opus
---

Run the token-usage efficiency audit against the repo. Produces a prioritized optimization plan saved to `ai-resources/audits/`. Diagnostic-only — all fixes happen in a separate session.

Input: $ARGUMENTS (optional) — scope selector:
- empty → audit the current working directory
- `ai-resources` → audit `{WORKSPACE}/ai-resources`
- `workspace` → audit the full Axcíon workspace
- `project <name>` → audit `{WORKSPACE}/projects/<name>`

---

### Step 1: Scope Resolution

1. Set `WORKSPACE` to the Axcíon AI workspace root (parent of `ai-resources/`).
2. Parse $ARGUMENTS:
   - empty → set `AUDIT_ROOT` to the current working directory; `SCOPE_SLUG` = empty; `SCOPE_LABEL` = "current working directory"
   - `ai-resources` → `AUDIT_ROOT` = `{WORKSPACE}/ai-resources`; `SCOPE_SLUG` = `ai-resources`; `SCOPE_LABEL` = "ai-resources repo"
   - `workspace` → `AUDIT_ROOT` = `{WORKSPACE}`; `SCOPE_SLUG` = empty; `SCOPE_LABEL` = "Axcíon AI Workspace (full)"
   - `project <name>` → `AUDIT_ROOT` = `{WORKSPACE}/projects/<name>`; `SCOPE_SLUG` = `project-<name>`; `SCOPE_LABEL` = "projects/<name>"
3. If the parsed scope resolves to a non-existent directory, abort with: "AUDIT_ROOT does not exist: {path}. Aborting."

---

### Step 2: Path Setup

4. Set `AUDIT_DIR` = `{WORKSPACE}/ai-resources/audits/` (token-audit reports always land in the central audits directory regardless of scope).
5. Set `PROTOCOL_PATH` = `{AUDIT_DIR}/token-audit-protocol.md`.
6. Set `WORKING_DIR` = `{AUDIT_DIR}/working/`. Create it if missing (`mkdir -p`).
7. Set `REPORT_PATH`:
   - If `SCOPE_SLUG` is empty → `{AUDIT_DIR}/token-audit-YYYY-MM-DD.md` (with today's date)
   - Otherwise → `{AUDIT_DIR}/token-audit-YYYY-MM-DD-{SCOPE_SLUG}.md`
8. Find `PREVIOUS_AUDIT` — the most recent prior token-audit with the same scope:
   - If `SCOPE_SLUG` is empty, regex: `^token-audit-\d{4}-\d{2}-\d{2}\.md$`
   - Otherwise, regex: `^token-audit-\d{4}-\d{2}-\d{2}-{SCOPE_SLUG}\.md$`
   - Set to the newest matching file, or "None" if no prior scoped audit exists.

---

### Step 3: Input Sanity-Check

9. Verify `PROTOCOL_PATH` exists. If missing, abort with: "token-audit-protocol.md not found at {PROTOCOL_PATH}. Cannot proceed without the protocol. Aborting."
10. Verify `AUDIT_ROOT` is a directory. If not, abort with the message from Step 3 of Section 1.
11. Verify both token-audit subagent files exist: `{WORKSPACE}/ai-resources/.claude/agents/token-audit-auditor.md` (Section 4 — judgment, Opus) and `{WORKSPACE}/ai-resources/.claude/agents/token-audit-auditor-mechanical.md` (Sections 2, 5, 6 — mechanical measurement, Haiku). If either is missing, abort with: "token-audit subagent missing: {path}. Aborting." Both subagents are required.

---

### Step 4: Read the Protocol

12. Read `PROTOCOL_PATH` into working memory. Note the Section 0–10 boundaries and the Execution Notes delegation rules. Do not re-read the protocol later — hold it in context for the session.

---

### Step 5: Execute Section 0 (Pre-Flight) Inline

13. Create the audit report skeleton at `REPORT_PATH` with a header block:
    ```
    # Token Audit — YYYY-MM-DD
    Scope: {SCOPE_LABEL}
    AUDIT_ROOT: {AUDIT_ROOT}
    Previous audit: {PREVIOUS_AUDIT}
    ```
14. Execute Section 0.1: attempt `/cost` and `/context`. Record output (or "not available in this execution environment") in `{WORKING_DIR}/audit-working-notes-preflight.md`.
15. Execute Section 0.2: locate `session-usage-analyzer` skill, read its output-location info, search for historical data. Record paths and date range if found. Non-blocking.
16. Execute Section 0.3 (`Read(pattern)` deny-rule check) per the v1.2 protocol instructions:
    - Locate all `.claude/settings.json` and `.claude/settings.local.json` under `AUDIT_ROOT`
    - Parse `permissions.deny` arrays
    - Filter for `Read(...)` entries specifically
    - List covered directory patterns
    - Compare against expected-coverage list (`audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, directories containing `deprecated` or `old`)
    - Record verdict (HIGH / MEDIUM / PASS), covered dirs, missing-expected dirs in `{WORKING_DIR}/audit-working-notes-preflight.md`
17. Append a `## 0. Pre-Flight Summary` section to `REPORT_PATH` listing the Step 0.3 verdict and any telemetry discovered.

---

### Step 6: Execute Section 1 (CLAUDE.md) Inline

18. Execute Section 1 per the protocol: measure all CLAUDE.md files under `AUDIT_ROOT`; assess size, essentials-only fit, skill-eligible content, redundancy with skills, compaction instructions, aspirational content. Apply severity classifications.
19. Append the `## 1. CLAUDE.md Audit` section to `REPORT_PATH` using the protocol's report format. **Append, don't rewrite the file.**

---

### Step 7: Delegate Section 2 (Skill Census) to Subagent

20. Launch the `token-audit-auditor-mechanical` subagent with inputs:
    - `SECTION` = `2`
    - `AUDIT_ROOT` = (as resolved above)
    - `PROTOCOL_PATH` = (as resolved above)
    - `WORKING_DIR` = (as resolved above)
21. Wait for the subagent to return. The subagent writes `audit-working-notes-skills.md` + `audit-summary-skills.md` to `WORKING_DIR` and returns the summary file path only.
22. Read only `audit-summary-skills.md` (not the full notes). Do NOT read the full notes unless the summary surfaces a finding that requires deeper review.
23. Append `## 2. Skill Census` to `REPORT_PATH`, composed from the summary. Include a line referencing the full notes path for traceability.

---

### Step 8: Execute Section 3 (Command Census) Inline

24. Execute Section 3 per the protocol: locate all command files, measure, flag high-cost commands, map cascading loads for top 5.
25. Append `## 3. Command File Census` to `REPORT_PATH`.

---

### Step 9: Delegate Section 4 (Workflow Audit) Per Workflow

26. Identify active workflows (referenced in CLAUDE.md, invoked by slash command, or documented in a top-level workflow/process file). Rank by reference frequency. Audit the top 5; if fewer than 4 are clearly identifiable, audit all found and note the count.
27. For each identified workflow, launch `token-audit-auditor` with inputs:
    - `SECTION` = `4`
    - `AUDIT_ROOT` = (as resolved above)
    - `PROTOCOL_PATH` = (as resolved above)
    - `WORKING_DIR` = (as resolved above)
    - `WORKFLOW_NAME` = the workflow's name
    Each subagent writes `audit-working-notes-workflow-{kebab-case-name}.md` + `audit-summary-workflow-{kebab-case-name}.md`.
28. As each subagent returns, read only its summary file. Collect summaries into memory.
29. Append `## 4. Workflow Token Efficiency` to `REPORT_PATH` composing from all per-workflow summaries. Include full-notes paths.

---

### Step 10: Execute Section 5 (Session Patterns) — Conditional Delegation

30. Count `session-usage-analyzer` log files discovered in Step 0.2.
31. If count ≤ 3 OR scope is narrower than workspace: execute Section 5 inline. Apply the protocol's structural-analysis steps and the configuration audit.
32. If count > 3 AND scope is workspace: launch `token-audit-auditor-mechanical` with `SECTION=5` and the usual inputs. Read only the summary after it returns.
33. Append `## 5. Session Patterns & Configuration` to `REPORT_PATH`.

---

### Step 11: Delegate Section 6 (File Handling) to Subagent

34. Launch `token-audit-auditor-mechanical` with `SECTION=6` and the usual inputs.
35. Read only `audit-summary-file-handling.md` when the subagent returns.
36. Append `## 6. File Handling Patterns` to `REPORT_PATH`.

---

### Step 12: Execute Section 7 (Missing Safeguards) Inline

37. Execute Section 7's checklist. For the `Read(pattern)` deny-rule safeguard entry, re-use the finding recorded in Step 0.3 (do not re-run the check).
38. Append `## 7. Missing Safeguards` to `REPORT_PATH`.

---

### Step 13: Execute Section 8 (Best Practices Comparison) Inline

39. Execute Section 8's 12-item comparison against the April 2026 best practices defined in the protocol. Rate each Present / Partial / Not implemented. Assign priority per the protocol's rule (by estimated token-savings impact, not by implementation status).
40. Append `## 8. Best Practices Comparison` to `REPORT_PATH`.

---

### Step 14: Synthesize Section 9 (Optimization Plan) Inline

41. Compile the prioritized optimization plan per the protocol's 9.1–9.5 structure. This integration step stays in the main session — it cross-references findings from every prior section.
42. Apply the HIGH / MEDIUM / LOW savings-tier definitions from the protocol. Use the recommendation schema (Issue, Evidence, Waste mechanism, Estimated savings, Implementation steps, Risk, Dependencies, Category) for each item.
43. Append `## 9. Optimization Plan` to `REPORT_PATH`.

---

### Step 15: Write Section 10 (Self-Assessment) Inline

44. Execute Section 10 per the protocol: audit token cost (if `/cost` available), protocol gaps encountered, per-section confidence ratings (HIGH / MEDIUM / LOW per the protocol's definitions), and any threshold-boundary findings flagged by subagents.
45. Append `## 10. Self-Assessment` to `REPORT_PATH`.

---

### Step 16: Verify Report

46. Read `REPORT_PATH` back and confirm:
    - Sections 0 through 10 are all present as headings
    - Section 9 (Optimization Plan) has at least 9.1 Executive Summary and 9.2 Prioritized Recommendations
    - Every HIGH finding has an evidence citation (file path or measurement)
    - No section is empty
47. If verification fails on any item, flag the failure in the terminal output and leave the report file for manual inspection. Do not retry silently.

---

### Step 17: Commit

48. Stage `REPORT_PATH` and all files under `{WORKING_DIR}/*.md`.
49. Count total findings in the report (HIGH + MEDIUM + LOW across all sections).
50. Commit with message format:
    - If `SCOPE_SLUG` is empty: `audit: token-audit — YYYY-MM-DD [{SCOPE_LABEL}, N findings]`
    - Examples:
      - `audit: token-audit — 2026-04-18 [ai-resources repo, 23 findings]`
      - `audit: token-audit — 2026-04-18 [Axcíon AI Workspace (full), 41 findings]`
51. Do NOT push. Pushing remains a manual operator step.

---

### Step 18: Present Summary to Operator

52. Display:
    - Path to the report
    - Finding count by severity (HIGH / MEDIUM / LOW)
    - Top 3 HIGH findings (one line each)
    - A reminder: "Fixes happen in a separate session. To start, read the report and pick the HIGH items to act on first."
53. Remind the operator to push and to run `/wrap-session` when the work is complete.
