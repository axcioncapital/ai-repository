Run the full repo due diligence pipeline: audit the workspace, compare to the previous audit, triage findings, and fix what's approved. Optionally continue into a deep operational assessment.

Input: $ARGUMENTS (optional) — depth control:
- (empty): factual audit only (Steps 1-6)
- "deep": factual audit + operational assessment with judgment and recommendations (Steps 1-6, then 7-13)
- "full": factual audit + operational assessment + pipeline testing (Steps 1-6, then 7-14)

---

### Step 1: Preparation

1. Set WORKSPACE to the Axcion AI workspace root (parent of `ai-resources/`).
2. Set AUDIT_DIR to `ai-resources/audits/`.
3. Read the questionnaire from `{AUDIT_DIR}/questionnaire.md`.
4. Check for the most recent previous audit in `{AUDIT_DIR}/` by looking for files matching `repo-due-diligence-*.md` (exclude `*-partial.md`). Set PREVIOUS_AUDIT to that file path, or "None" if no previous audit exists.
5. Set REPORT_PATH to `{AUDIT_DIR}/repo-due-diligence-YYYY-MM-DD.md` using today's date.
6. Get the current HEAD short hash for each git repo in the workspace (ai-resources, any repos under projects/, workflows/).

---

### Step 2: Execute Questionnaire

7. Run the questionnaire against the full workspace — all git repos, all levels (.claude/ directories, skills, commands, hooks, workflows, projects).
8. Follow every rule in the questionnaire's Instructions section exactly:
   - Be specific: file names, line counts, exact paths, exact counts.
   - Say "None found — checked [describe what was compared or searched]" when a check turns up clean.
   - Say "Unknown — cannot determine from repo contents" only if you genuinely can't answer.
   - If a question asks you to list things, list all of them — don't summarize or truncate.
9. If PREVIOUS_AUDIT is not "None", include DELTA notes under each answer using the format specified in the questionnaire.
10. For questions that reference "the current repo" — interpret this as the full workspace (all repos under WORKSPACE).
11. If Q4.3 is not applicable (no skill creation templates exist), mark it as: `N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.`
12. Save the completed audit to REPORT_PATH.
13. The audit report must contain facts only — no recommendations, no suggested fixes, no commentary.

---

### Step 3: Triage Findings

14. Read the completed audit report.
15. Extract every finding that describes a discrepancy, missing item, violation, contradiction, or deviation.
16. Categorize each finding into exactly one of:

**AUTO-FIX** — The fix is unambiguous and self-contained. It touches exactly one file, requires no judgment about intent, and cannot cascade into other references. Examples: creating a missing directory with .gitkeep, fixing a broken symlink where the intended target is obvious. If the fix *might* require checking downstream references or choosing between approaches, it is OPERATOR, not AUTO-FIX.

**OPERATOR** — Everything that requires a decision, including anything where the "right" fix is ambiguous. This is the default category. When in doubt, classify as OPERATOR. Examples: resolving contradictions between CLAUDE.md files, migrating a skill to a different location, choosing whether to update or remove a stale file, fixing a diverged copy where it's unclear which version is correct.

**INFO** — Findings that are purely inventory or measurement. No action implied. Examples: total skill count, context load line counts, CLAUDE.md growth trends, clean checks that found nothing.

---

### Step 4: Present Findings [Operator Gate]

17. Display a summary table:

```
AUTO-FIX:  X items
OPERATOR:  Y items
INFO:      Z items
```

18. List each AUTO-FIX item with:
    - What the finding is (one line)
    - What the fix would be (one line)

19. List each OPERATOR item with:
    - What the finding is (one line)
    - What decision is needed (one line)

20. If there are no AUTO-FIX or OPERATOR items (all findings are INFO): state "Clean audit — no actionable findings" and skip to Step 6.

21. **Wait for operator approval before proceeding.** The operator may:
    - Approve all auto-fixes and select which operator items to fix
    - Approve some and defer others
    - Defer all fixes to a fresh session (the audit report is already saved)
    - Request changes to the triage categorization

---

### Step 5: Apply Fixes

22. Apply each approved fix.
23. After each fix, verify the change by reading the modified file.
24. Keep a running log of changes made (file path, what changed).
25. If context usage is high, inform the operator — they can choose to stop and continue fixes in a fresh session using the audit report as reference.

---

### Step 6: Commit

26. Stage the audit report file (always — even if no fixes were applied, a clean audit is baseline data).
27. If fixes were applied in Step 5, stage those files too.
28. Commit with message format: `audit: repo-dd — YYYY-MM-DD [brief scope note]`
    - Example: `audit: repo-dd — 2026-04-06 full workspace, 3 fixes applied`
    - Example: `audit: repo-dd — 2026-04-06 full workspace, clean`
29. Do NOT push.
30. If $ARGUMENTS does not contain "deep" or "full", stop here. Present the audit summary to the operator.

---

## Deep Operational Assessment

Steps 7-14 run only when $ARGUMENTS contains "deep" or "full". They produce a separate report file that references the factual audit. Evidence and interpretation stay in separate files.

---

### Step 7: Deep Assessment Preparation

31. Set DD_REPORT to the audit report just saved at REPORT_PATH.
32. Set DEEP_REPORT_PATH to `{AUDIT_DIR}/repo-dd-deep-YYYY-MM-DD.md` using today's date.
33. Read DD_REPORT fully. Extract Section 3.4 (downstream reference ranking), Section 5 (context load), Section 1.2 (hooks), and Section 2 (CLAUDE.md health) into working memory.
34. Discover log files across the workspace. For each repo under WORKSPACE (ai-resources, each project under projects/, workflows/), check for:
    - `logs/friction-log.md`
    - `logs/improvement-log.md`
    - `logs/session-notes.md`
    - `logs/coaching-log.md`
    - `logs/workflow-observations.md`
    Record which files exist and which do not. Absence is a finding, not an error — do not warn for missing logs.

---

### Step 8: Feature Criticality Assessment

35. Extract the top-10 downstream reference ranking from DD_REPORT Section 3.4.
36. For each item in the ranking, classify as:
    - **Load-bearing** — failure breaks multiple commands, pipelines, or session lifecycle flows. Criteria: referenced by 3+ commands/hooks, OR sits in a sequential pipeline where absence blocks downstream stages, OR is the sole source of truth for a shared convention.
    - **Supporting** — failure degrades but does not block. Criteria: referenced by 1-2 commands, has workarounds, or produces optional outputs.
    - **Peripheral** — failure affects only itself. Criteria: no downstream references, or referenced only by its own command.
37. Build an operational dependency graph beyond file references. Trace these chains:
    - Research pipeline: /run-preparation through /produce-knowledge-file
    - Project setup pipeline: /new-project through /session-guide
    - Session lifecycle: /prime → [work] → /wrap-session
    - Skill management: /request-skill → /create-skill → /improve-skill
    - Workflow management: /deploy-workflow → /sync-workflow
    For each chain, identify the single point of failure — the component whose breakage has the widest blast radius.
38. Check for untracked dependencies — features that are load-bearing by convention but not by file reference. Examples: CLAUDE.md behavioral sections that shape every session, symlink conventions that deployments depend on, commit message formats that hooks parse.
39. Cross-reference with DD_REPORT Section 2 (CLAUDE.md health) for contradictions or dead references in load-bearing files. A contradiction in a load-bearing file is Critical; in a peripheral file, Low.
40. Record all findings for Section 1 of the deep report with priority ratings (Critical / High / Medium / Low).

---

### Step 9: Context Management Assessment

41. Extract Section 5.1 (context load per entry point) and Section 5.2 (unreferenced CLAUDE.md sections) from DD_REPORT.
42. For each entry point, assess context efficiency:
    - Calculate the ratio of operationally-referenced lines (sections referenced by commands/hooks) to total lines.
    - Flag entry points where less than 60% of loaded context is operationally referenced.
43. Identify CLAUDE.md sections that could move to on-demand references. Candidates are sections that:
    - Are not referenced by any command, hook, or agent definition
    - AND are not behavioral modifiers that need to be present in every session (judgment call — state your reasoning)
    - AND exceed 5 lines
    For each candidate, state: section name, line count, current file, and whether it could be loaded via a skill reference or command preamble instead.
44. Assess hook density per entry point. For each settings.json with hooks:
    - Count hooks per trigger type (PreToolUse, PostToolUse, SessionStart, Stop, UserPromptSubmit)
    - Estimate cumulative timeout per write operation (sum of PostToolUse Write hook timeouts)
    - Flag configurations where a single Write operation triggers 3+ hooks
45. For each hook, assess usage evidence:
    - Read the hook script (if external) and determine what it produces
    - Check whether its output is consumed by any command or read by the operator
    - Flag hooks whose output goes to files that are never read by commands (potential dead hooks)
46. Identify context that loads but is rarely used. Check:
    - SessionStart hooks that load content — is that content referenced in patterns visible in session-notes.md?
    - CLAUDE.md sections about features not mentioned in the last 30 days of session notes
47. Record all findings for Section 2 of the deep report with priority ratings.

---

### Step 10: Friction and Improvement Synthesis

48. Read all discovered friction logs from Step 7 sub-step 34. For repos with no friction log, record: "{repo} — no friction log. Friction logging not active."
49. Read all discovered improvement logs. For repos with no improvement log, record: "{repo} — no improvement log."
50. Read all discovered session notes. Extract:
    - Recurring themes in "Open Questions" sections
    - Patterns in "Next Steps" that appear session after session (indicating stalled work)
    - Any mentions of friction, workarounds, or "had to manually" in summaries
51. Read all discovered coaching-log.md and workflow-observations.md files.
52. Synthesize across all sources. Identify:
    - **Recurring friction** — the same type of friction appearing 3+ times across any combination of logs and session notes. State the pattern and its frequency.
    - **Unresolved improvements** — entries in improvement logs with status "logged" or "pending" older than 14 days. Suggestions acknowledged but never acted on.
    - **Friction without improvement** — friction log entries that have no corresponding improvement log entry. Pain points logged but never analyzed.
    - **Improvement without verification** — improvement log entries with status "applied" that have no subsequent session notes confirming the fix worked.
    - **Cross-repo patterns** — friction patterns appearing in multiple repos, suggesting a systemic issue rather than a project-specific one.
53. For each pattern found, draft a specific recommendation:
    - What the friction is (evidence: file path, entry text, frequency)
    - Root cause assessment (tool gap, process gap, context gap, or operator habit)
    - Recommended action (create a skill, add a hook, modify a command, change a CLAUDE.md rule, or accept as inherent)
    - Effort estimate (quick fix: <1 session, moderate: 1 session, significant: multi-session)
54. Record all findings for Section 3 of the deep report with priority ratings.

---

### Step 11: Deep Report Generation

55. If context usage is high after completing Step 10, inform the operator — they can choose to save the report with sections completed so far and finish in a fresh session.

56. Write the deep report to DEEP_REPORT_PATH with this structure:

    ```
    # Repo Deep Review — YYYY-MM-DD
    Workspace: Axcion AI
    Based on: repo-dd audit YYYY-MM-DD
    Scope: {repos assessed}
    ```

    **Section 1: Feature Criticality**
    - 1.1 Load-Bearing Features (table: Feature | Reference Count | Blast Radius | Risk Notes)
    - 1.2 Operational Dependency Chains (structured list per chain, single point of failure marked)
    - 1.3 Untracked Dependencies (table: Dependency | Type | Why It Matters)

    **Section 2: Context Management**
    - 2.1 Context Load Summary (table: Entry Point | CLAUDE.md Lines | Hook Load | Total | Efficiency Ratio)
    - 2.2 Migration Candidates (table: Section | File | Lines | Recommendation | Reasoning)
    - 2.3 Hook Density Assessment (table: Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict)
    - 2.4 Dead or Low-Value Context (table: Item | Type | Evidence of Non-Use)

    **Section 3: Friction and Improvement Synthesis**
    - 3.1 Recurring Friction Patterns (table: Pattern | Frequency | Repos Affected | Root Cause | Recommendation)
    - 3.2 Improvement Pipeline Health (table: Metric | Value — covering logged, applied, verified, stalled counts)
    - 3.3 Specific Recommendations (numbered list with priority, effort, and action)

    **Section 4: Pipeline Testing**
    - Placeholder: "Not run. Use `/repo-dd full` to include pipeline testing."

    **Summary**
    - Critical findings: {count and one-line each}
    - High findings: {count}
    - Medium findings: {count}
    - Low findings: {count}
    - Top 3 recommendations by impact

57. Every finding in the deep report must have:
    - A priority rating: Critical / High / Medium / Low
    - Evidence citation: file path(s), log entry text, or metric values
    - A specific recommendation (not "consider reviewing" — state what to do)
58. Cross-check: no finding should duplicate a factual audit finding without adding new interpretation. The deep review adds judgment; the audit provides facts.
59. If any section has zero findings, state: "No issues identified. Checked: {describe what was examined}."
60. Save the deep report.

---

### Step 12: Pipeline Testing [Operator Gate]

61. If $ARGUMENTS does not contain "full", skip to Step 13.
62. **Test 1: Symlink resolution.** Check every symlink recorded in DD_REPORT Section 1.7. For each: does the target exist? Is it readable? Is the content non-empty? Record pass/fail per symlink.
63. **Test 2: Template sync.** For each file that exists as both a canonical version (in ai-resources/skills/ or ai-resources/workflows/) and a deployed copy (in projects/), compare content. Record: identical, diverged (with line diff count), or missing copy.
64. **Test 3: /deploy-workflow preconditions.** Verify without executing:
    - Template directory exists at workflows/research-workflow/
    - SETUP.md exists and contains placeholder definitions
    - Placeholder patterns (search for `{{`) are present in template files
    - Skill symlink source directory (ai-resources/skills/) exists and is non-empty
    Record: all preconditions met / list failures.
65. **Test 4: /new-project preconditions.** Verify without executing:
    - All pipeline-stage-* agent files exist in ai-resources/.claude/agents/
    - session-guide-generator agent file exists
    Record: all preconditions met / list failures.
66. **Test 5: /sync-workflow preconditions.** Verify without executing:
    - At least one deployed project exists under projects/
    - Template directory at workflows/research-workflow/.claude/ contains commands, agents, or hooks directories
    Record: all preconditions met / list failures.
67. Read the deep report at DEEP_REPORT_PATH. Replace the Section 4 placeholder with the pipeline testing results. Update the Summary finding counts to include any pipeline test failures. Save.

---

### Step 13: Commit Deep Report

68. Stage the deep report file at DEEP_REPORT_PATH.
69. Commit with message format: `audit: repo-dd-deep — YYYY-MM-DD [brief scope note]`
    - Example: `audit: repo-dd-deep — 2026-04-06 full workspace, 12 findings`
    - Example: `audit: repo-dd-deep — 2026-04-06 full workspace + pipeline tests, 8 findings`
70. Do NOT push.
71. Present the Summary section of the deep report to the operator as final output.
