# Section 4 — Workflow Token Efficiency Audit: repo-dd

**Audit root:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`
**Workflow scope:** `/repo-dd` (three tiers: standard / deep / full)
**Protocol version:** 1.2
**Telemetry available:** No. All "typical" estimates below are structural inferences from workflow instructions and file-loading patterns, not observed data.

---

## Context loading chain

### Tier: standard (no arg)

Steps 1-7 of `repo-dd.md`. Flow:

1. **Session start** — root `CLAUDE.md` (136 lines, 2,162 words ≈ 2,811 tokens) + ai-resources `CLAUDE.md` (104 lines, 834 words ≈ 1,084 tokens).
   - Combined CLAUDE.md load: ~3,895 tokens. Present on every turn of every session regardless of `/repo-dd` being invoked.
2. **`/repo-dd` command body** loads into main session when invoked: `.claude/commands/repo-dd.md` — 301 lines, 2,626 words ≈ **~3,414 tokens**.
3. **Step 2 does NOT read files** — only sets variables and searches for prior audit filenames via filesystem listing.
4. **Step 3 launches `repo-dd-auditor` subagent.** Subagent context (fresh):
   - Agent system prompt: `.claude/agents/repo-dd-auditor.md` — 75 lines, 762 words ≈ ~991 tokens.
   - Agent reads `audits/questionnaire.md` — 137 lines, 1,328 words ≈ ~1,726 tokens.
   - Agent walks AUDIT_ROOT and reads many files to answer 32 questions across 6 sections (see "Subagent pattern" below).
   - If `PREVIOUS_AUDIT ≠ "None"`, agent reads the prior audit report. Prior audits observed: 4,699 → 6,326 → 6,883 words (6,111–8,948 tokens each, growing trend).
5. **Step 3 step 10 — main agent reads the completed report** to verify it was written. Reports observed: 691–857 lines, 4,699–6,883 words ≈ **6,111 to 8,948 tokens**.
6. **Step 4 triage** — main agent re-reads the report it just read (Step 14: "Read the completed audit report"). Functionally a re-read of the same ~6–9k-token report.
7. **Step 5 operator gate** — no file loads.
8. **Step 6 fixes** — main agent reads each file being fixed (variable, depends on approvals).
9. **Step 7 commit** — git ops only.

**Total estimated start-of-workflow context for standard tier (main session only, excluding subagent):**

- CLAUDE.md (both layers): ~3,895 tokens
- `/repo-dd` command: ~3,414 tokens
- Subagent summary return (standard): ~100-300 tokens (per agent spec: total findings count, breakdown by type, report path)
- Main-session read of completed report: ~6,111-8,948 tokens (HIGH cost driver)
- Main-session re-read for triage (same report): functionally doubles the report cost to ~12,000-18,000 tokens across two reads

**Standard-tier main-session total: ~19,400-25,500 tokens** before any fixes are applied.

### Tier: deep (adds Steps 8-12)

Adds on top of standard tier:

10. **Step 33 (in Step 8): "Read DD_REPORT fully."** This is a THIRD read of the same 691-857-line audit report (~6,111-8,948 tokens). The protocol text says "Read DD_REPORT fully ... Extract Section 3.4 ... into working memory." This is a full-file read followed by extraction, not a scoped read.
11. **Step 34: discover log files.** Checks for `friction-log.md`, `improvement-log.md`, `session-notes.md`, `coaching-log.md`, `workflow-observations.md` per repo under AUDIT_ROOT. When AUDIT_ROOT = workspace, 11 log files are discovered across 5 projects + workspace root + ai-resources (see file inventory below).
12. **Step 48-51: read ALL discovered logs.** For ai-resources scope only, `logs/session-notes.md` alone is 800 lines / 9,304 words ≈ **~12,095 tokens**. Adding `decisions.md` (7,099 tokens) and `coaching-data.md` (1,125 tokens) and `innovation-registry.md` (605 tokens) → **~20,924 tokens** just from ai-resources logs. At workspace scope, add per-project logs (not measured here but likely 5,000-15,000 additional tokens each).
13. **Step 56: write deep report** to `DEEP_REPORT_PATH` — observed prior deep report: 245 lines, 2,674 words ≈ ~3,476 tokens written.

**Deep-tier additional main-session load (ai-resources scope, structural estimate):**

- Full DD_REPORT re-read at Step 33: ~6,111-8,948 tokens
- All log files: ~20,924 tokens (ai-resources alone)
- Deep report writing: output, not input

**Deep-tier main-session total: standard + ~27,000-30,000 additional tokens ≈ 46,400-55,500 tokens.** All in the main session (no subagent delegation for Steps 8-12).

### Tier: full (adds Step 13)

14. **Step 62: Test 1 — symlink resolution.** Re-reads DD_REPORT Section 1.7. No new content beyond what's already loaded.
15. **Step 63: Test 2 — template sync.** For each file that exists in both `ai-resources/skills/` or `ai-resources/workflows/` and `projects/X/`, compare content. At ai-resources scope this is minimal; at workspace scope with 5 projects and many symlinks this is substantial cross-project file reading.
16. **Step 64-66: Tests 3-5 — preconditions.** Existence checks via `ls` / `find` — minimal token cost.

---

## File reads during execution

Main-session file reads (ai-resources scope, standard tier):

| File | Size | Read in main/subagent | Necessary / Delegable? |
|------|------|-----------------------|------------------------|
| `CLAUDE.md` (root) | 136 lines / 2,162 words | Main (every session) | Necessary |
| `ai-resources/CLAUDE.md` | 104 lines / 834 words | Main (every session) | Necessary |
| `.claude/commands/repo-dd.md` | 301 lines / 2,626 words | Main (on invocation) | Necessary (workflow spec) |
| `audits/questionnaire.md` | 137 lines / 1,328 words | **Subagent** (correct) | Delegated |
| `.claude/agents/repo-dd-auditor.md` | 75 lines / 762 words | Subagent system prompt | Necessary for subagent |
| `audits/repo-due-diligence-YYYY-MM-DD.md` (completed report) | ~700-860 lines / ~4,700-6,900 words | **Main (Step 10)** | Partially delegable — main only needs verification + triage-level extraction |
| Same report again (Step 14 triage) | same | **Main, re-read** | Redundant with Step 10 read |
| Same report again (Step 33 deep, fully) | same | **Main, third read** | Delegable to a triage-extraction subagent |
| Previous audit report (if exists) | ~700-860 lines | **Subagent** (in Step 3 only) | Correctly delegated |
| `logs/session-notes.md` | 800 lines / 9,304 words | **Main (Steps 48-51, deep tier)** | Delegable — deep tier should delegate log synthesis to a subagent |
| `logs/decisions.md` | 124 lines / 5,461 words | Main (deep tier) | Delegable |
| `logs/coaching-data.md` | 95 lines / 865 words | Main (deep tier) | Borderline |
| `logs/innovation-registry.md` | 41 lines / 465 words | Main (deep tier) | Borderline |
| Per-project logs (workspace scope): 11 files total at workspace scope | Unmeasured but likely >5,000 lines aggregate | Main (deep tier) | Delegable |

Subagent-scope file reads (`repo-dd-auditor`):

- Walks AUDIT_ROOT exhaustively to answer 6 questionnaire sections (32 questions). Reads: all SKILL.md files (many — known skill count 40+ in ai-resources), all command files, all agent definitions, all hook scripts, both `CLAUDE.md` files, all symlinks, all templates, git history for commit dates.
- This is correctly delegated — the subagent's scope is exactly the "heavy-read" pattern the protocol recommends.

---

## Subagent pattern

| Subagent | Returns to main? | Return size estimate | Verdict |
|----------|------------------|---------------------|---------|
| `repo-dd-auditor` (Step 3) | Writes full report to `REPORT_PATH`; returns only "total findings count, breakdown by type, report file path" per agent spec | ~100-300 tokens (good) | **CORRECT output-to-disk pattern.** Summary return only. |
| (No subagent for Steps 4-6 triage) | Main session reads the on-disk report directly | ~6,111-8,948 tokens (full report) | **Missing delegation opportunity.** Triage-extraction could be delegated. |
| (No subagent for Steps 8-12 deep assessment) | N/A | Main session reads DD_REPORT + all logs ≈ 27,000-30,000+ tokens | **Missing delegation opportunity.** Per protocol "tasks requiring >3-4 file reads go to subagent." Step 34-51 reads 4+ log files. |
| (No subagent for Step 13 pipeline testing) | N/A | Small per-test cost; many small file-existence checks | Acceptable inline. |

**Subagent return volume verdict:** The one subagent (`repo-dd-auditor`) is well-designed. The workflow's main-session portion, however, reads the subagent's output artifact (the 6-9k-token audit report) up to three times (Steps 10, 14, 33) without any summarization or delegation.

---

## Refinement / QC cycles

- **Standard tier:** 0 designed refinement cycles. Step 5 is an operator gate, but not a QC refinement loop. The workflow does not call any independent QC pass on the audit report (contrast with `/create-skill` and `/improve-skill` which route through post-edit QC).
- **Deep tier:** 0 designed refinement cycles. Step 12 writes the deep report directly; no QC review before Step 14 commits.
- **Full tier:** 0 designed refinement cycles. Step 13 runs pipeline tests and inlines results into the existing deep report.

**Total typical runs (main + subagents):** standard = 1 main + 1 subagent = 2 sessions. Deep = 1 main + 1 subagent = 2 sessions. Full = 1 main + 1 subagent = 2 sessions. The "refinement multiplier" from the context pack does not apply here — the workflow does not design for multiple refinement cycles. This is a correct choice for an audit workflow, not a waste signal.

---

## Natural compaction breakpoints

| Breakpoint | Present in workflow? | Enforcement |
|------------|--------------------|-------------|
| After Step 3 (subagent returns, before main reads report) | No `/compact` prompt | Missing |
| After Step 7 commit (end of standard tier) | No `/compact` prompt if continuing to deep | Missing |
| After Step 12 deep report write, before Step 13 | No `/compact` prompt | Missing |
| Step 25 ("If context usage is high, inform the operator") | **Present** — Step 25 (fix-apply), Step 55 (deep report generation) | Partial — instructs operator-awareness but does not enforce `/compact` or `/clear` |

---

## Findings

| # | Finding | Severity | Waste mechanism | Evidence |
|---|---------|----------|----------------|---------|
| 1 | Triple re-read of the completed DD report by the main session across Steps 10, 14, and 33 | **HIGH** | Main-session token drain: same 691-857 line / ~6,111-8,948 token file is read up to three times in deep tier. Second and third reads add 12,000-17,900 tokens with no new information. | `repo-dd.md` line 59 ("read the saved report at REPORT_PATH to verify it was written"); line 65 ("Read the completed audit report"); line 140 ("Read DD_REPORT fully"). Observed report size: `repo-due-diligence-2026-04-12.md` = 824 lines / 6,883 words. |
| 2 | Main-session reading of log files in Steps 48-51 (deep tier) is delegable | **HIGH** | Per-protocol rule "tasks requiring >3-4 file reads go to subagent." Deep tier reads 4+ log files in main session; `session-notes.md` alone is 9,304 words ≈ 12,095 tokens. At workspace scope this cascades to 11 log files. | `repo-dd.md` lines 199-205 (Step 48-51); `logs/session-notes.md` = 800 lines / 9,304 words; workspace scope discovers 11 log files. |
| 3 | Step 33 deep-assessment full DD_REPORT re-read is delegable | **HIGH** | The main session re-reads the entire audit report to "extract Sections 3.4, 5, 1.2, and 2 into working memory." A triage-extraction subagent could read the report once and return only the four extracted sections (~1,500-2,500 tokens) vs. the full 6-9k. | `repo-dd.md` lines 140 ("Read DD_REPORT fully. Extract Section 3.4 ... Section 5 ... Section 1.2 ... Section 2 into working memory"). |
| 4 | No `/compact` or `/clear` breakpoints enforced between tiers | **MEDIUM** | Natural boundaries exist (end of Step 7 standard-tier commit; end of Step 12 deep-report write) but the workflow only "informs the operator" if context is high (Step 25, 55). No pre-tier compaction instruction. A deep+full run accumulates all prior tier context in one session. | `repo-dd.md` Step 25 ("If context usage is high, inform the operator"); Step 55 (same pattern). No `/compact` invocation. |
| 5 | Output verification in Step 10 reads the entire report instead of a lightweight existence/size check | **MEDIUM** | Step 10 says "read the saved report at REPORT_PATH to verify it was written." Verification of "was written" only requires existence + non-empty check via `ls` or `wc -l`. Full-content read is excessive for verification. | `repo-dd.md` line 59. |
| 6 | Deep-tier Section 3 (friction/improvement synthesis) reads many logs that could be paralleled across subagents | **MEDIUM** | Steps 48-52 read friction, improvement, session, coaching, and workflow-observations logs sequentially in main session and synthesize cross-repo patterns. At workspace scope this can cross 11+ files × multiple KB each. A synthesis subagent per log-type or per-repo would reduce main-session load. | `repo-dd.md` lines 199-217; log file inventory at workspace scope = 11 files. |
| 7 | No designed QC pass on the factual audit report before triage | **LOW** | The `repo-dd-auditor` is independent (fresh context), but there is no post-audit QC check (e.g., for hallucinated file paths) before the main session uses the report for triage and fix application. Not a token-waste finding per se but relates to the refinement-multiplier assessment. | `repo-dd.md` Steps 3-4; compare with `/create-skill` / `/improve-skill` which mandate post-edit QC. |
| 8 | `repo-dd.md` command file itself is 301 lines / 2,626 words ≈ ~3,414 tokens — loaded every time the command is invoked | **MEDIUM** | The command file combines three distinct tiers (standard, deep, full) into one file. Standard-tier sessions still load all deep+full instructions. A tier-conditional loading pattern (or splitting into `/repo-dd`, `/repo-dd-deep`, `/repo-dd-full`) would reduce invocation cost for the most-used tier. | `.claude/commands/repo-dd.md` = 301 lines / 2,626 words. Standard tier uses Steps 1-7; Steps 8-14 (Deep + Full) = lines 128-301 = 174 lines ≈ ~56% of file. |
| 9 | Previous-audit read in subagent is full-file with no line-range scoping | **LOW** | The `repo-dd-auditor` (per `.claude/agents/repo-dd-auditor.md` line 49) reads the full prior audit for DELTA extraction. Prior audit = 691-857 lines / ~6,111-8,948 tokens. A targeted read of only sections whose answers have plausibly changed is theoretically possible but would require structural changes to the questionnaire. Classed as LOW because subagent context is bounded and does not return to main. | `repo-dd-auditor.md` line 49; observed prior audits 691-857 lines. |

---

## Boundary-proximity flags

Per the protocol's ±15% boundary rule:

- None of the HIGH findings are within ±15% of a threshold boundary. Finding 1 (report read = ~6-9k tokens) and Finding 2 (logs = ~12k+ tokens per file) are well above the >200-lines / >500-token thresholds defining HIGH severity.
- Finding 3 involves the same report size as Finding 1 → also well above thresholds.
- Finding 8 (`repo-dd.md` = 301 lines) is a command-file size, not matched directly to the "skill >300 lines HIGH / 150-300 MEDIUM" rule (that rule targets skills, not commands). For command files the protocol's Section 3 uses ">500 tokens of loaded context" — 3,414 tokens is far above. No boundary proximity.

No findings in this audit are within the ±15% boundary-ambiguity band.

---

## Protocol gaps

- Section 4 refers repeatedly to "workflows" without explicitly distinguishing workflow-as-slash-command (like `/repo-dd`) from workflow-as-pipeline (like research-workflow/). This audit interprets `/repo-dd` as a slash-command-orchestrated workflow and treats each tier as a distinct execution mode.
- The "refinement multiplier" criterion (>3 refinement cycles = MEDIUM finding) maps poorly to factual-audit workflows that deliberately do not iterate. I interpreted this as non-applicable rather than flagging it.
- The protocol's threshold for "subagent returning >200 lines to main session = HIGH" is unambiguous for subagent returns but does not explicitly cover the case of the main session re-reading a subagent's disk-written output. I have treated re-reads of on-disk subagent output as equivalent to in-context returns for severity purposes.

---

## File inventory referenced by this audit

| Role | Path | Lines | Words | Est. tokens (words × 1.3) |
|------|------|-------|-------|---------------------------|
| Workspace CLAUDE.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` | 136 | 2,162 | ~2,811 |
| ai-resources CLAUDE.md | `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` | 104 | 834 | ~1,084 |
| Workflow command | `ai-resources/.claude/commands/repo-dd.md` | 301 | 2,626 | ~3,414 |
| Subagent spec | `ai-resources/.claude/agents/repo-dd-auditor.md` | 75 | 762 | ~991 |
| Questionnaire | `ai-resources/audits/questionnaire.md` | 137 | 1,328 | ~1,726 |
| Prior audit (newest) | `ai-resources/audits/repo-due-diligence-2026-04-12.md` | 824 | 6,883 | ~8,948 |
| Prior audit | `ai-resources/audits/repo-due-diligence-2026-04-11.md` | 857 | 6,326 | ~8,224 |
| Prior audit | `ai-resources/audits/repo-due-diligence-2026-04-06.md` | 691 | 4,699 | ~6,109 |
| Prior deep report | `ai-resources/audits/repo-dd-deep-2026-04-06.md` | 245 | 2,674 | ~3,476 |
| Log file (deep tier) | `ai-resources/logs/session-notes.md` | 800 | 9,304 | ~12,095 |
| Log file (deep tier) | `ai-resources/logs/decisions.md` | 124 | 5,461 | ~7,099 |
| Log file (deep tier) | `ai-resources/logs/coaching-data.md` | 95 | 865 | ~1,125 |
| Log file (deep tier) | `ai-resources/logs/innovation-registry.md` | 41 | 465 | ~605 |

**Summary totals by tier (ai-resources scope, main-session-only):**

- Standard tier total: ~19,400-25,500 tokens
- Deep tier total: ~46,400-55,500 tokens
- Full tier total: deep + small per-test cost

All estimates structural — no telemetry.
