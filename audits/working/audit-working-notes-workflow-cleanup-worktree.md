# Section 4 — Workflow Token Efficiency Audit: /cleanup-worktree

**Audit root:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
**Workflow scope note from main session:** A recent 2026-04-17 session run reported consuming "~10%+ of daily usage limit — primarily three subagent passes at ~220k tokens combined."
**Token estimation method:** word count × 1.3 (per protocol header). See header caveat: ±30% drift vs. actual tokenizer. Findings within ±15% of a threshold boundary tagged `(boundary)`.

---

## Workflow: /cleanup-worktree

### Context loading chain (workflow start → plan complete)

Per command file (`ai-resources/.claude/commands/cleanup-worktree.md`) Steps 3 and Step 6–9, the main session loads the following into its own context before any subagent spawns:

| # | Load event | Source | Lines | Words | Est. tokens (w × 1.3) |
|---|------------|--------|-------|-------|----------------------|
| 1 | Workspace CLAUDE.md (always) | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md | 136 | 2162 | ~2,811 |
| 2 | ai-resources CLAUDE.md (always, mounted via --add-dir) | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md | 104 | 834 | ~1,084 |
| 3 | Command file invoked | `.claude/commands/cleanup-worktree.md` | 145 | 1974 | ~2,566 |
| 4 | Step 3.6 — read SKILL.md in full | `skills/worktree-cleanup-investigator/SKILL.md` | 241 | 3133 | ~4,073 |
| 5 | Step 3.7 — read decision-taxonomy.md | `skills/worktree-cleanup-investigator/references/decision-taxonomy.md` | 230 | 2027 | ~2,635 |
| 6 | Step 3.8 — read execution-protocol.md | `skills/worktree-cleanup-investigator/references/execution-protocol.md` | 310 | 3766 | ~4,896 |

**Subtotal (mandatory pre-plan loads, main session only):** ~18,065 tokens across 1166 lines / 13,896 words.

**Plus per-dirty-path:**
- Per Step 4.10 (investigation protocol): `Read` every dirty path file (or `git show HEAD:<path>` for deletions). Per the Example section of SKILL.md, a "10–20 dirty-path session" is the reference scale. For 14 dirty paths with average ~40 lines each (estimate, not measured), add ~560 lines ≈ ~4–8k tokens of file-content reads into main session.
- Per Step 4.10: `find-template.sh` output for every `.claude/*` path (script output is short — negligible).
- Per Step 5.12: Plan file built via Write, then Read back for Section 7 / 8 bookkeeping (Write doesn't self-load, but plan text ~1500–3000 tokens persists in context).

**Total estimated start-of-workflow context (main session) before first subagent:** ~22,000–26,000 tokens for a 10–14 dirty-path session.

**Note:** The three reference files (SKILL.md + 2 reference docs) total 781 lines / 8,926 words ≈ ~11,600 tokens loaded into main session per the command's Step 3 (explicitly "Read … in full"). This is the dominant fixed cost.

### Subagent invocations (per workflow run)

Per command file Steps 6, 7, 9 (and reinforced by SKILL.md Workflow step 4/5/7 and execution-protocol.md sections 3/4/6):

| # | Subagent | Mandatory? | Invoked at | Input passed | Return |
|---|----------|-----------|------------|--------------|--------|
| 1 | qc-gate / qc-reviewer (first QC) | Yes | Step 6 | Plan file content (verbatim), original operator request, git status snapshot, evaluation criteria | Full QC report — "Do not summarize it" (Step 6.17 explicit) |
| 2 | triage-reviewer | Yes | Step 7 | QC report from #1 + plan file content + main agent's proposed responses per finding | Triage output: must-fix, should-fix, history-only, first-class alternatives |
| 3 | qc-gate / qc-reviewer (second QC) | Yes ("MANDATORY" per Step 9 header + SKILL.md bias counter 3) | Step 9, after revision | Revised plan + first QC report + operator request + git status | Clean / MINOR / BLOCKING verdict. Loops to Step 8 revision if BLOCKING. Max 2 revision cycles → loop 3 stops. |

**Return-to-main volumes:**

- **First QC report:** "Capture the subagent's full QC report. Do not summarize it." (Command Step 6.17, execution-protocol §3). A qc-reviewer output per the agent's Output Format template is typically ~30–100 lines with 5 criteria sections + verdict. Estimate: 500–1,500 tokens when plan is complex.
- **Triage output:** Tables of Do/Park findings. Estimate: 200–800 tokens.
- **Second QC report:** Same format as first. Estimate: 500–1,500 tokens.

**Subagent context cost (each subagent's own context, not returned to main):** Each QC and triage subagent receives the full plan file content verbatim (execution-protocol §3: "the subagent is the first independent reader of the plan"). Per Step 6.15/Step 7.19 contract, the plan is passed "verbatim, do not pass the path alone — context isolation rule." A plan covering 10–14 dirty paths with 8 required sections is large — estimate 3,000–6,000 tokens per plan file. Each QC subagent also loads its own agent definition (qc-reviewer.md: 89 lines / 501 words ≈ ~651 tokens; triage-reviewer.md: 72 lines / 473 words ≈ ~615 tokens) plus any files it chooses to grep/read for verification.

**Operator-reported 2026-04-17 telemetry (from context pack):** "three subagent passes at ~220k tokens combined" = ~73k tokens per subagent context on average. That is consistent with each subagent loading the plan verbatim + the QC-reviewer or triage-reviewer agent spec + files it reads for verification (CLAUDE.md checks, referenced-file existence checks per qc-reviewer "Context Gathering" block).

### File reads during execution (post-ExitPlanMode, Steps 11–12)

| Read event | In main / subagent | Necessary / Delegable |
|------------|--------------------|------------------------|
| Per Step 11.29a: execution-time re-verification guards (`diff`, `ls -la`, `git ls-files --error-unmatch`, re-read migration destination) | Main | Necessary — guards must fire immediately before destructive op, cannot be delegated |
| Per Step 11.30: post-commit verification reads each committed file from filesystem | Main | Necessary (per project CLAUDE.md rule "verify via filesystem not git"), but reads are short and scoped to just-committed paths |

No additional subagent calls during execution phase.

### QC loop structural analysis

Per command Step 9.26:
- BLOCKING → loop back to Step 8 revise → spawn NEW Step 9 second QC subagent
- Max 2 full revision cycles; cycle 3 = abort and surface to operator.

**Worst case within spec:** 2 revision cycles = 1 triage + up to 3 second-QC-pass subagents (initial + revision cycle 1 second QC + revision cycle 2 second QC) + 1 first QC = **up to 5 subagent invocations** per cleanup session.

**Typical case per originating-session narrative (SKILL.md "Example" + Bias Counter 3):** 3 subagent calls (1 first QC + 1 triage + 1 second QC), no revision loops. Matches the 2026-04-17 telemetry report of "three subagent passes."

### Estimated output volume (subagent → main) — summary

| Stage | Return size est. |
|-------|------------------|
| First QC report (verbatim, no summary permitted) | 500–1,500 tokens |
| Triage output | 200–800 tokens |
| Second QC report (verbatim) | 500–1,500 tokens |
| **Total returned to main session per 3-pass cycle** | **~1,200–3,800 tokens** |

### Compaction / session-boundary analysis

Command file explicitly declares Step 11.11 must run "behind hard gates for irreversible operations" but **contains no instruction to run `/compact` at any natural breakpoint** between plan-writing, QC passes, triage, revision, second QC, or execution. The command is a single end-to-end sequence from Step 1 to Step 12.

SKILL.md "Runtime Recommendations" says: "Duration: A 10–20 dirty-path session typically runs 45–90 minutes." No compaction guidance in the recommendations block, only a "Session scope" note forbidding bundling cleanup with content production.

Workspace CLAUDE.md has a general "Pre-compact checkpoint" rule ("When context usage approaches ~50%, write a session-state scratchpad") but this is workflow-agnostic — the cleanup workflow does not specialize or reference it.

### File-read delegability analysis

Per Section 4 assessment question 2 — are large files being read in the main session when they could be delegated?

- SKILL.md (241 lines), decision-taxonomy.md (230 lines), execution-protocol.md (310 lines) are all read in full in the **main session** per command Steps 3.6–3.8. Execution-protocol.md **exceeds 300 lines**.
- Per SKILL.md "Runtime Recommendations → Context budget": "Reference files are lean — read them on demand, not upfront. `decision-taxonomy.md` is needed for classification; `execution-protocol.md` is needed when writing the plan and during execution."
- The command file (Steps 3.7, 3.8) overrides that on-demand guidance by requiring both reference files be read up-front at Step 3, **before any dirty-path investigation begins**. This contradicts the SKILL.md Runtime Recommendation.
- Decision-taxonomy.md is used by the main session during Step 4.10 classification, so it is arguably necessary in the main session. execution-protocol.md is used for (a) plan schema (Step 5), (b) QC subagent contract (Steps 6–7), (c) execution mechanics (Step 11). Sections 1–6 are needed pre-ExitPlanMode; Sections 7–13 are needed post-ExitPlanMode — a natural split point.
- SKILL.md itself contains 33 lines of frontmatter/intro + "When to Use/NOT to Use" tables (~40 lines) + "Invocation Contract" (~16 lines) + "Workflow" (~18 lines) + "Reference Files" (~12 lines) + "Bundled Scripts" (~24 lines) + "Bias Counters" (~40 lines) + "Known Pitfalls" (~25 lines) + "Failure Behavior" (~14 lines) + "Runtime Recommendations" (~15 lines) + "Validation Loop" (~12 lines) + "Example" (~22 lines) + "Cross-References" (~7 lines). The Example section (~22 lines) and Known Pitfalls / Bias Counters (~65 lines combined) duplicate guidance already in the command file's Step 3–11 text.

Dirty-path file reads (Step 4.10) are necessarily in the main session because classification requires the main agent's reasoning to apply the decision taxonomy per path. Not delegable to a subagent without restructuring the investigation stage.

### Refinement multiplier

Per command Step 9 + execution-protocol §6 + SKILL.md Bias Counter 3:
- 1 first QC (mandatory)
- 1 triage (mandatory)
- 1 second QC (mandatory)
- Up to 2 additional "loop back to revision → re-run second QC" cycles before abort

**Baseline pass count:** 3 subagents per cleanup session. Consistent with operator-reported 2026-04-17 run ("three subagent passes at ~220k tokens combined").

---

## Findings

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|----------------|----------|
| 1 | Each of the 3 mandatory subagents receives full plan file verbatim (execution-protocol §3 "pass it verbatim" + command Step 6.15 "do not pass the path alone"). Plan for 10–14 dirty-path session ≈ 3,000–6,000 tokens × 3 subagents = 9,000–18,000 tokens of plan-content re-loading across the subagent fleet. | HIGH | Full-artifact return/repass into each subagent's own context — Section 4 assessment q1 ("subagents returning >200 lines" threshold applied in reverse: plan is passed-in, not returned-out, but the protocol's cost framing is identical). 2026-04-17 telemetry ("~220k tokens across three subagent passes = ~73k/subagent") confirms each subagent carries substantial context. | command file Step 6.15; execution-protocol.md §3 "inputs the subagent receives: (a) the plan file content … pass it verbatim"; §4 same contract for triage; §6 same contract for second QC |
| 2 | Main session loads 3 files totalling 781 lines / 8,926 words (~11,600 tokens) up-front at Steps 3.6–3.8 before the operator's dirty paths have even been classified. execution-protocol.md (310 lines, >300-line HIGH threshold) is the largest single load. | HIGH | Unnecessary main-session reads — SKILL.md's own "Runtime Recommendations → Context budget" says reference files are "read … on demand, not upfront" and that execution-protocol.md is needed "when writing the plan and during execution" (i.e., post-investigation, post-ExitPlanMode). Command Step 3 overrides this by forcing both refs to load immediately after SKILL.md. | command file Steps 3.7, 3.8 explicit "Read … — required for"; contradicts SKILL.md "Context budget" paragraph. execution-protocol.md line count 310 (boundary-adjacent to HIGH at >300 lines) |
| 3 | First QC report must be captured "Do not summarize it" (command Step 6.17) — full QC report enters main session context. Same for second QC report via Step 9.25. Typical qc-reviewer output format ≈ 500–1,500 tokens per report. At 2 QC passes + 1 triage = up to ~3,800 tokens returned into main session across the 3 subagent calls. | HIGH | Subagent output returned in full to main session rather than written to disk and referenced by path — directly matches Section 4 assessment q1 ("subagent returning >200 lines to main session") for each of the two QC reports independently. | command file Step 6.17 "Capture the subagent's full QC report. Do not summarize it."; Step 9.25 by reference to Step 6 isolation contract; execution-protocol.md §3 final line "Capture the full QC report … as a structured artifact — do not summarize it. Revisions in the next step must trace back to specific QC findings." |
| 4 | No `/compact` breakpoints defined anywhere in the 12-step command despite the workflow being explicitly estimated at "45–90 minutes" for a 10–20 dirty-path session with 3+ subagent calls and multiple file reads. SKILL.md lacks compaction guidance in its Runtime Recommendations block. | MEDIUM | Missing compaction breakpoints — Section 4 severity classification "No compaction instructions or breakpoints defined → MEDIUM". Natural break candidates are (a) after Step 5 plan write before Step 6 first QC; (b) after Step 9 second QC clears before Step 10 ExitPlanMode; (c) after each major commit in Step 11. | command file Steps 1–12 contain no `/compact` references (grep-verified); SKILL.md "Runtime Recommendations" (lines 182–189) has no compaction guidance |
| 5 | Execution-protocol.md is 310 lines (3,766 words ≈ 4,896 tokens). Threshold: >300 lines = HIGH per Section 2 skill-size classification. `(boundary)` — 310 is within +15% of the 300 HIGH boundary (15% of 300 = 45, so 255–345 is boundary zone). | HIGH `(boundary)` | Size drives the per-main-session-read cost in finding #2 and the per-subagent-repassed cost where subagents choose to read it for verification. | wc -l on the file: 310 lines. The file is a reference, not a SKILL.md itself, but Section 4's file-read cost analysis applies identically. |
| 6 | Bias Counter 3 ("Second QC pass is mandatory") + Step 9.26 loop permit up to 2 additional revision cycles = up to 5 total subagent passes in worst case before abort. Typical case is 3 passes. Operator telemetry from 2026-04-17 ("~10%+ of daily usage limit … three subagent passes at ~220k tokens combined") falls within MEDIUM severity ("Consistent need for >3 refinement cycles → MEDIUM" — typical case is at the boundary, not over, but cycling to 5 passes on a BLOCKING finding is within spec). | MEDIUM | Mandatory multi-pass QC with permitted revision loops. Token cost is real; rationale is safety (bias counters enumerate the specific failures each pass caught). Section 4 severity classification: "may indicate instruction quality issue rather than token waste per se, but the token cost is real." | command file Step 9.26; SKILL.md Bias Counter 3 "not optional"; originating-session narrative in SKILL.md "Why:" blocks. |
| 7 | Plan file is written to `~/.claude/plans/cleanup-worktree-<YYYY-MM-DD-HHMM>.md` (Step 5.12) — outside AUDIT_ROOT. The plan persists across sessions. No instruction for how past plans are managed; no cleanup or retention rule. Plans accumulate as read-accessible files. Not directly a Section 4 token-waste finding in the current run, but any future main session that mounts the user-home .claude dir could glob/read stale plans. | LOW | Workspace hygiene adjacent — outside strict Section 4 scope, noting for completeness. | command file Step 5.12 path |
| 8 | SKILL.md contains duplicate content with the command file: (a) Bias Counters section (~40 lines) enumerates 4 counters that command Step 4.11 re-states inline ("Apply all four bias counters … explicitly: (1) never fabricate … (2) always run find-template.sh … (3) the second QC pass is mandatory … (4) hard gates require named confirmation"); (b) Workflow overview (~18 lines) re-states what the command's Steps 1–12 already enumerate. Since command file AND SKILL.md both load in full at workflow start, this is duplication loaded into main session context. | MEDIUM | Redundant loading — Section 3 assessment q2 applied to Section 4 context: "Do any commands load context that CLAUDE.md already provides? Double-loading." Same mechanism between command file and its referenced skill. | cleanup-worktree.md Step 4.11 (4 bias counters listed) vs. SKILL.md "Bias Counters" section lines 112–146 (same 4 counters, expanded). cleanup-worktree.md Steps 4–11 vs. SKILL.md "Workflow" block lines 60–77 (numbered overlap). |

---

## Assessment questions (per Section 4, directly answered)

1. **Subagent return volume.** HIGH finding — both QC reports must be returned verbatim ("do not summarize"), and the triage output is returned in its entirety. No write-to-disk-return-summary pattern in the workflow. See finding #3.

2. **Unnecessary reads in main session.** HIGH finding — execution-protocol.md (310 lines, needed for execution-phase mechanics) is read up-front at Step 3 rather than deferred until post-ExitPlanMode. SKILL.md's own Runtime Recommendations say to read it "on demand." See finding #2.

3. **Missing `/compact` opportunities.** MEDIUM finding — no breakpoints defined in a 45–90 minute workflow with 3+ subagent calls. See finding #4.

4. **Refinement multiplier.** Baseline 3 subagent passes per session; up to 5 permitted before abort. Operator-reported typical case (2026-04-17) = 3 passes consuming ~220k tokens combined. See finding #6.

---

## Protocol gaps

- Section 4's "subagent returning >200 lines to main session → HIGH" is framed for returned outputs. The cleanup-worktree workflow's dominant subagent cost is not returns, but verbatim plan-content passed INTO each of 3 subagents (per isolation contract). I applied the HIGH severity to this pattern by analogy (finding #1) because the token cost is symmetric — a full plan passed into a subagent is as token-expensive as a full report returned out. Noted here per instructions.
- Section 4 is silent on how to score workflows that delegate responsibly (isolation contracts require full-plan passing by design for safety). The 2026-04-17 telemetry represents a safety-by-design token cost, not a waste pattern in the traditional sense — but it is a real token cost. I have tagged the findings accordingly but Section 9 synthesis will need to weigh the safety trade-off.

---

## Boundary-adjacent findings (±15% of threshold)

- Finding #5: execution-protocol.md at 310 lines is within the 255–345 boundary zone for the >300 HIGH threshold. Under real tokenization with ±30% drift, it could read as 4,200 or 5,600 tokens depending on actual compression. Confidence LOW on severity.
- Finding #6: typical-case 3 subagent passes sits exactly at the ">3 refinement cycles → MEDIUM" boundary. Classification is sensitive to whether the threshold is strict-greater or gte.

---

## Evidence files referenced

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/cleanup-worktree.md (145 lines, 1974 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/worktree-cleanup-investigator/SKILL.md (241 lines, 3133 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/worktree-cleanup-investigator/references/decision-taxonomy.md (230 lines, 2027 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md (310 lines, 3766 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md (136 lines, 2162 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md (104 lines, 834 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md (89 lines, 501 words)
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md (72 lines, 473 words)
- Operator-provided telemetry: 2026-04-17 session run consumed "~10%+ of daily usage limit — primarily three subagent passes at ~220k tokens combined"
