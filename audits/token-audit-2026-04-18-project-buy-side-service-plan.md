# Token Audit — 2026-04-18

**Scope:** projects/buy-side-service-plan
**AUDIT_ROOT:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan
**Previous audit:** None
**Protocol:** `ai-resources/audits/token-audit-protocol.md` v1.2

---

## 0. Pre-Flight Summary

**0.1 — Baseline session metrics:** `/cost` and `/context` not available in this execution environment.

**0.2 — Session telemetry:** 1 historical entry found in `usage/usage-log.md` (2026-03-30, Efficient). Insufficient for trend analysis; Section 5 runs inline with structural focus.

**0.3 — `Read(pattern)` deny-rule check:** **Verdict: HIGH**
- Settings files: 2 (`.claude/settings.json`, `.claude/settings.local.json`)
- `Read(...)` deny entries: **0**
- Covered directories: none
- Missing expected coverage: `logs/`, `reports/`, `output/`, `final/`, `parts/`, `report/`, `analysis/`, `execution/` — all of which contain large generated content

Working notes: `ai-resources/audits/working/audit-working-notes-preflight-project-buy-side-service-plan.md`

**Scope note (symlinks):** Per operator direction 2026-04-18, symlinked skills under `reference/skills/` are EXCLUDED from Section 2 (they point to `ai-resources/skills/` and were audited in the 2026-04-18 ai-resources run). Symlinked commands and agents under `.claude/` are likewise shared resources from ai-resources — Section 3 measures only project-local commands/agents. This project's skill-layer token impact is captured in the ai-resources audit, not here.

---

## 1. CLAUDE.md Audit

**File:** `projects/buy-side-service-plan/CLAUDE.md`
**Line count:** 167
**Word count:** 1,748
**Estimated tokens:** 1,748 × 1.3 ≈ 2,272
**Heading count:** 24
**Subdirectory CLAUDE.md files found:** none

**Per-session cost:** ~2,272 tokens on every turn of every session. Over a typical 2–3 hour session with ~30–50 turns, that is ~68k–114k tokens spent purely on CLAUDE.md loading.

**Assessment:**

1. **Size check — PASS (borderline).** At 167 lines, under the 200-line recommendation. Margin is thin: the Service Development Workflow section (lines 74–159) is 86 lines by itself — if it grew, the file would cross the threshold quickly.
2. **Essentials-only test — MIXED.** Most content applies every session (cross-model rules, context isolation, citation conversion). Service Development Workflow (lines 74–159) applies only when drafting Parts 2–3 or Working Hypotheses — not during preparation, execution, analysis, or research pipeline sessions.
3. **Skill-eligible content — present.** Service Development Workflow (86 lines) is workflow-specific procedural guidance. Belongs in a loadable skill (e.g., `service-development-workflow`) triggered when drafting Part 2/3 content.
4. **Redundancy with skills — present.** Workflow Status Command (lines 27–29) and Collaboration Coach (lines 31–33) describe commands that have their own command files; the CLAUDE.md block repeats what the command files already explain on invocation.
5. **Redundancy with workspace CLAUDE.md — present.** File Verification (lines 68–72) and Commit Rules (lines 161–167) duplicate the workspace-level CLAUDE.md. The file itself acknowledges this ("repeated here because projects are sometimes opened without the parent workspace context loaded"). Workspace CLAUDE.md is already loaded via `additionalDirectories` in `.claude/settings.json` at line 172–174 — the duplication costs ~10 lines × every turn.
6. **Bright-Line Rule duplication (lines 53–62).** The same rule is also embedded as a block-message string in the PreToolUse hook for Edit (`.claude/settings.json` line 9). The rule fires enforcement via hook; the CLAUDE.md copy is explanatory but still adds ~10 lines per turn.
7. **Compaction instructions — ABSENT.** CLAUDE.md contains no `/compact` guidance or preservation rules. A long drafting session will rely on default auto-compaction, which is lossy for claim IDs, bibliography state, and approved-vs-draft tracking.
8. **Aspirational content — minimal.** Line 13 ("False precision is worse than acknowledged uncertainty") is a norm statement. Borderline but behavioral (shapes calibration of evidence language). LOW impact.

**Findings:**

| # | Finding | Severity | Lines affected | Recommendation |
|---|---------|----------|---------------|----------------|
| 1.1 | Service Development Workflow section is skill-eligible. Loaded every turn but only relevant to Part 2/3/Working Hypotheses drafting (~60% of sessions). | MEDIUM | 74–159 (~86 lines) | Extract to `service-development-workflow` skill under `ai-resources/skills/` (or project-local if content is truly project-specific). Leave a 2-line pointer in CLAUDE.md. Est. savings: ~900 tokens/turn when drafting non-Part 2/3 content. |
| 1.2 | Commit Rules (lines 161–167) and File Verification (lines 68–72) duplicate workspace-level CLAUDE.md which is already loaded via `additionalDirectories`. | MEDIUM | 68–72, 161–167 (~15 lines) | Remove the duplicated blocks. Rely on workspace CLAUDE.md, which is auto-loaded when `additionalDirectories` includes the workspace root. Est. savings: ~160 tokens/turn. |
| 1.3 | Workflow Status Command and Collaboration Coach descriptions (lines 27–33) duplicate content already in the respective command files. | MEDIUM | 27–33 (~7 lines) | Replace with one-line pointer each (e.g., "Commands: `/workflow-status`, `/coach`, `/analyze-workflow` — see `.claude/commands/`"). Est. savings: ~90 tokens/turn. |
| 1.4 | Missing compaction instructions — no guidance on what to preserve during `/compact`. | MEDIUM | N/A | Add a Compaction section naming preserve-on-compact items: active draft number, claim IDs in flight, QC gate status, current section being drafted, approved-vs-draft state. Est. savings: reduces post-compact rework cycles. |
| 1.5 | Bright-Line Rule block (lines 53–62) is partially redundant with the PreToolUse hook's block-reason string in `.claude/settings.json`. The hook enforces; CLAUDE.md explains. | LOW | 53–62 (~10 lines) | Keep CLAUDE.md block (explanation is useful when the hook blocks). No action recommended unless trimming aggressively. |
| 1.6 | Aspirational line "False precision is worse than acknowledged uncertainty" (line 13). | LOW | 13 | Keep — shapes evidence-language calibration. No action. |

**Summary of Section 1 estimated savings:** ~1,150 tokens/turn if findings 1.1, 1.2, 1.3 implemented. Over a 40-turn session, ~46,000 tokens saved. Fundamental cost floor (essential content) ~1,120 tokens/turn remains.

---

## 2. Skill Census

**Summary:** 0 findings.

No project-local skills exist under AUDIT_ROOT. All 22 directories in `reference/skills/` are symlinks to `ai-resources/skills/*` and are excluded per operator directive — they were audited in the 2026-04-18 ai-resources run (`ai-resources/audits/token-audit-2026-04-18-ai-resources.md`).

**Implication:** This project inherits the full token cost profile of the ai-resources skill library. Any optimization to a shared skill benefits this project automatically. Do not re-audit here.

Full notes: `ai-resources/audits/working/audit-working-notes-skills-project-buy-side-service-plan.md`
Summary: `ai-resources/audits/working/audit-summary-skills-project-buy-side-service-plan.md`

---

## 3. Command File Census

**Scope:** Project-local (non-symlinked) commands in `.claude/commands/`. The 26 symlinked commands are shared from `ai-resources/.claude/commands/` and were audited separately.

**Total local command files found:** 23
**Total lines across local commands:** 1,409
**Total words across local commands:** 11,631 → ~15,120 estimated tokens (only loaded when the specific command is invoked, not at session start)

**Size distribution:**
- Under 50 lines: 10 commands
- 50–100 lines: 10 commands
- 100–150 lines: 1 command (`audit-structure.md`, 145 lines)
- 150+ lines: 2 commands (`run-analysis.md` 181, `run-execution.md` 180)

**Top 5 largest local commands:**

| Rank | Command | Lines | Words | Est. tokens (self) | External loads |
|------|---------|-------|-------|-------------------:|----------------|
| 1 | `run-analysis.md` | 181 | 1,417 | ~1,842 | 5 ai-resources skills, stepwise (`gap-assessment-gate`, `section-directive-drafter`, `analysis-pass-memo-review`, `editorial-recommendations-generator`, `editorial-recommendations-qc`); appends to `/logs/qc-log.md` |
| 2 | `run-execution.md` | 180 | 2,024 | ~2,631 | 6 ai-resources skills, stepwise (`answer-spec-qc`, `execution-manifest-creator`, `research-prompt-creator`, `research-prompt-qc`, `research-extract-creator`, `research-extract-verifier`) |
| 3 | `audit-structure.md` | 145 | 1,014 | ~1,318 | Loads `reference/file-conventions.md` (142 lines, ~1,238 tokens) and `reference/stage-instructions.md` (127 lines, ~2,739 tokens) up front |
| 4 | `review.md` | 78 | 537 | ~698 | (not inspected; size low, not in cascade-load top tier) |
| 5 | `produce-knowledge-file.md` | 73 | 452 | ~588 | (not inspected; size low) |

**High-cost commands (loading >500 tokens of external context at invocation):**

| Command | What it loads | Estimated total cost at invocation | Notes |
|---------|--------------|-----------------------------------:|-------|
| `audit-structure.md` | self (~1,318) + file-conventions (~1,238) + stage-instructions (~2,739) | **~5,295 tokens** | Both reference files loaded up-front, not stepwise. HIGH single-invocation cost. |
| `run-execution.md` | self (~2,631) + 6 skills loaded stepwise (one at a time per step) | ~2,631 command only; each skill adds transiently | Stepwise-load pattern is efficient — skills don't accumulate in session unless the skill itself writes artifacts. |
| `run-analysis.md` | self (~1,842) + 5 skills stepwise | ~1,842 command only; stepwise | Same pattern as run-execution. Efficient. |

**Cascading-load analysis:**

- `run-execution` and `run-analysis` follow a clean stepwise pattern: the command tells the main agent to read skill N, follow it, then read skill N+1 — the old skill content is free to be evicted between steps. Good pattern; not a finding.
- `audit-structure` reads both `file-conventions.md` and `stage-instructions.md` at the top of the command as prerequisite reading for the entire run. Combined ~3,977 tokens loaded before any work starts. Since the command produces a single pass report, this is plausible — but `stage-instructions.md` is also pulled in via CLAUDE.md `@reference/stage-instructions.md` imports (lines 11, 25), creating potential double-load (see Finding 3.3 below).

**Redundant loading between CLAUDE.md and commands:**

- CLAUDE.md line 25 uses `@reference/stage-instructions.md`, `@reference/file-conventions.md`, `@reference/quality-standards.md`. Whether these `@` imports auto-expand on session start depends on Claude Code behavior; the CLAUDE.md body explicitly says "Only load these when actively working on the relevant stage or task" — a hint that the author intends lazy loading but expressed it via `@`, which is typically eager. Clarifying this is worth a finding.
- If `@` does auto-expand: combined reference files are 321 lines / 3,572 words → ~4,644 tokens added per-session-turn on top of CLAUDE.md itself (2,272 tokens). Total per-turn floor would approach ~6,900 tokens.
- If `@` is treated as pointer-only: no duplicate-load issue; only on-demand cost.

**Findings:**

| # | Finding | Severity | Evidence | Recommendation |
|---|---------|----------|----------|----------------|
| 3.1 | `audit-structure.md` front-loads `file-conventions.md` + `stage-instructions.md` (~3,977 tokens) at invocation. If the command is run against a targeted directory, it rarely needs all conventions at once. | MEDIUM | `.claude/commands/audit-structure.md:11-12` | Add a pre-scoping step: inspect the target dir first; load only the conventions section applicable to that stage/directory. Delegate the full-reference read to a subagent if a full pass is needed. Est. savings: ~2,500 tokens per invocation. |
| 3.2 | Ambiguous `@` semantics on three CLAUDE.md references. If eager, ~4,644 tokens auto-loaded every turn. If lazy, no waste. | MEDIUM (if eager) / N/A (if lazy) | `CLAUDE.md:11, 25` | Verify the `@` expansion behavior. If eager: replace `@` with plain path references (`reference/stage-instructions.md`) and rely on the "Only load when actively working" instruction. Est. savings: up to ~4,644 tokens/turn. |
| 3.3 | 23 local commands + 26 symlinked commands = 49 commands visible per session. Command-list metadata (names + descriptions) is lightweight, but invites option-paralysis and scanning overhead. | LOW | `.claude/commands/` inventory | Retire stale/duplicated commands. Example candidates: consolidate `review.md` + `content-review.md` + `service-design-review.md` if any two overlap (not audited deeply here). Est. savings: marginal tokens; main benefit is cognitive clarity. |
| 3.4 | No command loads the workspace-root CLAUDE.md or ai-resources CLAUDE.md explicitly — relies on `additionalDirectories` in settings.json line 172–174. Works correctly; no finding. | — | `.claude/settings.json:172-174` | No action. |

**Section 3 estimated savings:** ~2,500 tokens per `audit-structure` invocation (Finding 3.1) + up to ~4,644 tokens/turn if Finding 3.2 resolves to "eager load." Conservatively ~2,500 tokens per impacted turn.

---

## 4. Workflow Token Efficiency

**Workflows identified:** 2 (project has fewer than 5 active workflows — both audited per protocol)

1. **Research Pipeline (5-stage)** — Preparation → Execution → Analysis & Gap Resolution → Report Production → Final Production. Drives Part 1 content (1.1–1.4), currently complete. Source-of-truth: `reference/stage-instructions.md`.
2. **Service Development Workflow** — Parts 2–3 and Working Hypotheses drafting lifecycle: `parts/*/notes/` → `drafts/` → `approved/` with QC gates (`/review` → `/challenge` → `/service-design-review`). Documented in `CLAUDE.md` lines 74–159.

### 4.1 — Research Pipeline (5-Stage)

**Findings summary:** 23 total (5 HIGH incl. 1 boundary, 9 MEDIUM, 6 LOW incl. 1 boundary, 3 PASS).

**What works well (PASS):**
- Workflow start context: ~2,300 tokens auto-loaded (CLAUDE.md + SessionStart hook). No eager `@`-import expansion observed — reference files load on-demand. (This resolves the ambiguity flagged in Section 3 Finding 3.2 — verdict: `@` does NOT auto-expand in this setup.)
- Stepwise skill-loading pattern preserved across `/run-preparation`, `/run-execution`, `/run-analysis`, `/run-cluster`, `/run-synthesis`. 22 `/compact` markers across these five commands.
- Subagents return file-path-plus-summary (not full output into main session). Clean hand-off.
- Stage 3 → `/run-synthesis` uses an explicit fresh-session boundary.

**Key findings (HIGH):**

| # | Finding | Severity | Evidence | Recommendation |
|---|---------|----------|----------|----------------|
| 4.1.1 | No `Read(...)` deny rules (cross-ref from Section 0.3). Combined with `additionalDirectories` granting parent-workspace read, Claude Code can freely explore `/logs/`, `/output/` (164 KB+ modules), `/final/`, `/parts/*/drafts/`, old checkpoints during any Glob/Grep. | HIGH | `.claude/settings.json:150–175` | Add `Read(...)` denies for the listed dirs (addressed structurally in Section 6/7; listing here for workflow impact). |
| 4.1.2 | `produce-knowledge-file.md` does not delegate the production step. Step 2 reads all cited chapter files in main session; Step 3 applies the knowledge-file-producer skill inline. Full chapter prose materialized in main context. Only the QC step is delegated. | HIGH | `.claude/commands/produce-knowledge-file.md` (73 lines) | Delegate production to a subagent: the subagent reads the chapter files and runs the skill, writes the knowledge file to disk, returns path + one-line summary. Est. savings: thousands of tokens per knowledge-file production (chapter prose is typically 1k–3k lines combined). |
| 4.1.3 | `review.md` Step 1 reads 6–7 large files in main session before delegating to `qc-gate` (chapter prose + architecture spec + style reference + section directive + scarcity register + cluster memo + synthesis brief). Plausibly 1,000–2,000 lines materialized pre-delegation. | HIGH | `.claude/commands/review.md` (78 lines); protocol threshold ">3–4 large files → delegate" | Refactor Step 1 to pass file paths (not contents) to the qc-gate subagent; the subagent reads them independently. Est. savings: 15,000–30,000 tokens per `/review` invocation. |
| 4.1.4 | `run-cluster.md` Step 1 reads cluster extracts (some >250 lines) in main session before delegating. | HIGH (boundary) | `.claude/commands/run-cluster.md` | Same fix as 4.1.3 — pass paths, let subagent read. |
| 4.1.5 | `run-analysis.md` Step 1 reads all refined cluster memos in main session pre-delegation. | HIGH (boundary) | `.claude/commands/run-analysis.md` | Same fix — pass paths to subagent. |

**Other findings (MEDIUM/LOW):** Refinement multiplier ~14–16 delegated calls + up to 4 re-entry loops per section (MEDIUM); several LOW findings on minor compaction-marker placement. See full notes.

Full notes: `ai-resources/audits/working/audit-working-notes-workflow-research-pipeline-five-stage-buy-side.md`

### 4.2 — Service Development Workflow

**Findings summary:** 10 total (3 HIGH incl. 1 boundary, 5 MEDIUM, 2 LOW).

**What works well:**
- Subagent read pattern is clean: `section-drafter`, `strategic-critic`, `service-designer`, `qc-reviewer` all read source files directly via Read/Glob/Grep tools. No main-session content transfer for context files.

**Key findings (HIGH):**

| # | Finding | Severity | Evidence | Recommendation |
|---|---------|----------|----------|----------------|
| 4.2.1 | Three QC commands (`/review`, `/challenge`, `/service-design-review`) return full findings (3,000–8,000 tokens each) to main session instead of writing reports to disk. Per draft iteration: ~10,500–19,000 tokens accumulating across three layers. | HIGH | `.claude/commands/review.md`, `.claude/commands/challenge.md`, `.claude/commands/service-design-review.md` | Refactor all three to write findings file to `/logs/qc/{draft-id}-{reviewer}.md` and return only `{path} + top-3 issues one-line each`. Est. savings: 10,000–19,000 tokens per draft iteration. |
| 4.2.2 | Main session re-reads full draft file (up to 640 lines / ~18,800 tokens) after every `/draft-section` Phase 3 completion, even though the `section-drafter` subagent's Step 7 return summary already contains what the main session needs. | HIGH | `.claude/commands/draft-section.md`; draft sample: `parts/part-2-service/drafts/2.8-draft-04.md` (641 lines) | Remove the main-session re-read step. Trust the subagent summary; only re-read if operator explicitly asks for a full review. Est. savings: ~18,800 tokens per draft iteration. |
| 4.2.3 | `context/prose-quality-standards.md` is 753 lines / ~10,215 tokens — boundary-size file. Loaded during prose QC via `/review`. | HIGH (boundary) | `context/prose-quality-standards.md` | Assess whether the full file is needed per review, or whether a section-specific subset suffices. If subset: implement section-index or splitting. |

**Key findings (MEDIUM):**

- 4.2.4 `/draft-section` has no `/compact` breakpoints; with 9 iterations on section 2.8, cumulative token load in main session can exceed ~200,000 tokens without compaction. Add a compact-suggestion checkpoint every N iterations.
- 4.2.5 CLAUDE.md ↔ implementation mismatch: Part 1 references documented at `/report/chapters/` + `/final/modules/` but `section-drafter` subagent maps to `/output/knowledge-files/`; `/final/modules/` is empty. Either update CLAUDE.md pointers or migrate artifacts to documented paths. (Not a pure token finding — but causes wasted exploration reads when a session tries to resolve references.)

**Context file sizing (load-path attribution):**
- `context/prose-quality-standards.md`: 753 lines / ~10,215 tokens
- `context/doc-2-production-plan.md`: 340 lines / ~4,853 tokens
- `/context/` directory total: 1,797 lines / ~25,420 tokens (not loaded all at once; loaded via workflow steps as needed)

Full notes: `ai-resources/audits/working/audit-working-notes-workflow-service-development-buy-side.md`

**Section 4 estimated savings (combined):** ~30,000–50,000 tokens per full drafting iteration (Findings 4.1.3, 4.2.1, 4.2.2 combined), plus structural savings from delegating production (4.1.2).

---

## 5. Session Patterns & Configuration

**Session telemetry available:** Minimal (1 entry in `usage/usage-log.md` from 2026-03-30, rated Efficient). Insufficient for trend or pattern analysis. All findings below are structural — based on repo configuration, not observed usage data.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model | `opus[1m]` (set in `.claude/settings.local.json`) | Opus for reasoning-heavy turns; consider Sonnet default with Opus for planning/QC | **MEDIUM–HIGH.** Always-Opus (with 1M context window) applies to every turn of every session, including mechanical ones. Opus is ~5× cost of Sonnet per token. For a project that runs drafting + three QC cycles + fix-application loops repeatedly, the multiplier is large. Per-project override could default to Sonnet and name the specific turn types that need Opus. |
| Subagent model | Not independently specified (inherits `opus[1m]`) | Haiku for mechanical subagents (hook-triggered, checklist-style); Sonnet for QC/review subagents; Opus for synthesis | **MEDIUM.** Check-claim-ids.sh hook + log-write-activity.sh + detect-innovation.sh don't need Opus. Section 2 skill census, file-handling scans are Haiku-class tasks. |
| `MAX_THINKING_TOKENS` | Not set anywhere in repo or settings.local.json | 10,000 for routine tasks; higher only when explicitly needed | **MEDIUM.** Without a cap, extended thinking can consume tens of thousands of tokens per turn. Combined with always-Opus, the per-turn cost ceiling is uncapped. |
| `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` | `=1` (directed by `CLAUDE.md:66`, not observed enforced) | Context-dependent | **MEDIUM.** CLAUDE.md directs the operator to set this env var every session. Disabling adaptive thinking means every task gets full thinking budget. On mechanical turns (e.g., `/wrap-session`, log appends, `check-claim-ids` follow-ups), that's wasteful. The rule is correct for "analytical drafting" turns but applies uniformly. Refinement: move the instruction to a skill that's loaded only during drafting/analysis, rather than setting the flag universally. |
| Autocompact threshold (`CLAUDE_AUTOCOMPACT_PCT_OVERRIDE`) | Not set — uses Claude Code default | 80% | **LOW.** Default may be sufficient; no finding without telemetry. |
| `additionalDirectories` | `["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` (workspace root) | Keep, but pair with `Read(...)` denies | **MEDIUM.** Granting the whole workspace as an additional directory is correct for access to ai-resources skills and shared commands — but without `Read(...)` denies, the session can read ANY file in the workspace during exploration, including other projects' private content. |
| MCP servers active | Not observable from repo context (lives in `~/.claude/settings.json`) | Disable unused servers | Cannot assess from this audit. |

**Hooks inventory:**

Project has 15 hook configurations across 5 events (all in `.claude/settings.json`):

| Event | Count | Notes |
|-------|-------|-------|
| SessionStart | 3 | Load project context, check template drift, sync shared commands. Each runs on every session start. Combined latency + output adds to initial context. |
| PreToolUse | 2 | Edit (bright-line rule check — may emit a block message with ~300-token reason), Skill (friction-log auto-start) |
| PostToolUse | 6 | Write × 4 (auto-commit, check-claim-ids, log-write-activity, detect-innovation), Edit × 2 (log-write-activity, detect-innovation) |
| Stop | 3 | Checkpoint reminder, session-notes logging, improve/coach reminders |
| UserPromptSubmit | 1 | Decision logging (only fires on GATE/bright-line transcripts) |

Total hook count is high but most are lightweight shell scripts. The main token-relevant concern: PreToolUse Edit hook emits a ~300-token block message whenever the Edit target matches `/(report/chapters|final/modules)/`. When editing chapter prose, that message is returned into main session. Per hook design, that's fine — it's rare and load-bearing. No finding.

**Findings:**

| # | Finding | Severity | Evidence | Recommendation |
|---|---------|----------|----------|----------------|
| 5.1 | Always-Opus default (`settings.local.json:model = "opus[1m]"`) applies to every turn including mechanical ones. ~5× cost vs. Sonnet. | MEDIUM–HIGH | `.claude/settings.local.json` | Consider Sonnet default with Opus overrides for specific analytical commands (e.g., `/draft-section`, `/review`, `/challenge`). Or at minimum specify Haiku/Sonnet for mechanical subagent model. Est. savings: 60–80% of per-turn token-cost exposure on mechanical turns. |
| 5.2 | No `MAX_THINKING_TOKENS` cap anywhere. Combined with `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING=1`, thinking budget per turn is unbounded. | MEDIUM | no matches in grep | Set `MAX_THINKING_TOKENS=10000` as default env var in session-start hook for routine turns; override to higher values (e.g., 25,000) only for complex drafting/QC commands. |
| 5.3 | Minimal usage telemetry (1 historical entry). No trend data to calibrate findings or verify recommendations. | LOW | `usage/usage-log.md` | Run `/usage-analysis` after each session to build a telemetry baseline. Already have the command; just not used regularly. |
| 5.4 | `CLAUDE_CODE_DISABLE_ADAPTIVE_THINKING` directive in CLAUDE.md:66 is uniform-across-all-sessions when it should be conditional on task type. | LOW | `CLAUDE.md:66` | Convert to a skill-scoped rule that applies only during `/draft-section`, `/review`, `/challenge`, `/service-design-review` cycles. Mechanical turns get adaptive thinking. |

**Section 5 estimated savings:** Structural shift to Sonnet default with Opus overrides could reduce per-turn cost by 60–80% on the ~60% of turns that are mechanical. For a 40-turn session, that's equivalent to several thousand dollars of API cost saved across a project's lifetime (estimate, not measured — no telemetry).

---

## 6. File Handling Patterns

**`Read(pattern)` deny-rule status (from Step 0.3):** **HIGH**
- Covered directories: none
- Missing expected coverage: `logs/`, `reports/`, `output/`, `final/`, `parts/`, `report/`, `analysis/`, `execution/`

**Scale:**
- 620 in-scope files under AUDIT_ROOT
- 215 files >150 lines
- 152 files >200 lines
- ~828,000 words of unprotected generated-output + log + draft content → **~1.08M estimated tokens** of content that Glob/Grep can freely surface during exploration

**Findings summary:** 17 total (2 HIGH, 9 MEDIUM, 6 LOW).

**HIGH findings:**

| # | Finding | Evidence | Recommendation |
|---|---------|----------|----------------|
| 6.1 | No `Read(...)` deny rules in `.claude/settings.json`. 460+ generated/log/draft files freely surfaceable by Glob/Grep/Read during any exploration. | `.claude/settings.json` (permissions.deny contains only 3 Bash rules) | Add `Read(...)` denies for `logs/**`, `execution/**`, `analysis/**`, `report/**`, `output/**`, `parts/**/drafts/**`, `reports/**`, `usage/**`, `archive/**`. Single highest-leverage change in the repo. |
| 6.2 | `additionalDirectories` grants full workspace read access with no compensating project-level Read denies; exposure extends beyond the project to the entire Axcíon AI Repo. A careless Grep from this project could read any file in any other project. | `.claude/settings.json:172-174` | Either (a) narrow `additionalDirectories` to `ai-resources/` only (not the whole workspace), OR (b) keep workspace access but add workspace-level `Read(...)` denies that cover each project's private content. |

**MEDIUM findings (directory-level):**

| # | Directory | Scale | Concern | Recommendation |
|---|-----------|-------|---------|----------------|
| 6.3 | `logs/` | `session-notes.md` 31,008 words (2,458 lines), `decisions.md` 22,262 words, `session-notes-archive-part1.md` 20,449 words (archival), `friction-log.md` 9,191 words | Session history routinely Glob/Grep-accessible — a casual "check what we discussed about X" request can materialize tens of thousands of tokens | Add `Read("logs/**")` deny. Provide a purpose-built `/status` or `/recall` command for controlled retrieval. |
| 6.4 | `execution/` | 147 files — 916K words in raw-reports, 848K words in research-extracts | Stage 2 output; only relevant to active execution session | Add `Read("execution/**")` deny. Stage-specific commands can override per-invocation if needed. |
| 6.5 | `analysis/` | 145 files; includes ~14 `chapters/*-cluster-*-draft.md` | Stage 3 intermediate work | Add `Read("analysis/**")` deny. |
| 6.6 | `report/` | 113 files, 344K words in doc-2 checkpoints | Checkpointed intermediate state | Add `Read("report/**")` deny. Keep explicit read access to `report/chapters/approved/` if that's the canonical Part 1 read-path. |
| 6.7 | `output/` | 29 files incl. finished 20K-word deliverables | Final deliverables — read only when explicitly requested | Add `Read("output/**")` deny; expose via a named command or manual path. |
| 6.8 | `parts/part-2-service/drafts/` | 54 superseded drafts vs 9 approved canonicals (6:1 ratio) | Every draft iteration preserved; Glob can surface superseded versions | Add `Read("parts/**/drafts/**")` deny. Keep `parts/**/approved/**` readable. |
| 6.9 | `reports/` | Generated reports directory | Same pattern — unprotected historical outputs | Add `Read("reports/**")` deny. |
| 6.10 | `usage/` | Usage-analysis output | Low-volume today (1 entry), but grows over time | Add `Read("usage/**")` deny. |
| 6.11 | `analysis/chapters/*-cluster-*-draft.md` (~14 files) | Stale cluster drafts co-located with approved work | Consolidate once approved; remove stale drafts periodically. | |

**LOW findings (hygiene):**

| # | Finding | Recommendation |
|---|---------|----------------|
| 6.12 | Explicit `session-notes-archive-part1.md` in `logs/` | Move to `logs/archive/` (covered by deny). |
| 6.13 | `v2` versioned knowledge file | Retain only if the v1 is also useful; otherwise remove v1 or consolidate. |
| 6.14 | 54 superseded drafts retained alongside canonicals | Establish a quarterly prune policy or move to `parts/*/drafts/archive/`. |
| 6.15 | Dated revision note + dated session-review file | Move to `logs/archive/` or `logs/decisions/`. |
| 6.16 | Empty skeleton dirs: `final/modules/`, `research/`, `output/integrated/` | Either populate, remove, or add `.keep` files with a purpose comment. CLAUDE.md references `/final/modules/` as a canonical read path — if empty, the reference is wrong (cross-references Finding 4.2.5). |
| 6.17 | Top-20 largest files: 18 of 20 classify NO per protocol rule (archive/generated/draft/log); 2 of 20 are canonical approved artifacts (still unprotected) | Covered by Finding 6.1. |

**Section 6 estimated savings:** One `Read(...)` deny block in `.claude/settings.json` prevents accidental materialization of ~1.08M tokens of historical content. Per-session savings are scenario-dependent (a single Glob that hits `logs/` today can cost 10k–50k tokens); across the project's remaining lifetime, this is the single highest-leverage fix.

Full notes: `ai-resources/audits/working/audit-working-notes-file-handling-project-buy-side-service-plan.md`

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|-----------|--------|---------------------|----------------|
| `Read(pattern)` deny rules in `.claude/settings.json` covering stale/large directories | **Absent** | HIGH | See Finding 6.1. Add deny block covering all non-canonical output directories. |
| Custom compaction instructions in CLAUDE.md | **Absent** | MEDIUM | CLAUDE.md:141 mentions "context needs to be compacted" but offers no preserve-on-compact list. Add explicit compact-scope rules (see Finding 1.4). |
| Subagent output-to-disk pattern (vs. returning full output to main session) | **Partial** | HIGH | Workflow subagents (section-drafter, qc-gate) follow the pattern; the three QC-layer commands (`/review`, `/challenge`, `/service-design-review`) do NOT (see Finding 4.2.1). |
| Context window monitoring instructions | **Absent** | MEDIUM | CLAUDE.md has no mention of `/context`, `/cost`, or percentage-based checkpoints. Add a rule: "After every N turns or before any command that will invoke multiple subagents, note context state." |
| Session boundaries defined for workflows | **Partial** | MEDIUM | Stage 3 → `/run-synthesis` has an explicit fresh-session boundary. Stage 2 → Stage 3 and Stage 4 iteration cycles do not have explicit `/clear` recommendations. |
| Model selection guidance | **Partial** | MEDIUM | `settings.local.json` hardcodes `opus[1m]` globally. No per-command override hints. See Finding 5.1. |
| File read scoping (read lines X-Y vs. whole file) | **Partial** | LOW | Some skills use bounded reads; the project-local commands (e.g., `review.md`) read whole files. |
| Output length constraints | **Partial** | LOW | No global cap on subagent returns. The three QC commands especially lack output caps. |
| Effort level guidance (`/effort` or equivalent) | **Absent** | LOW | Not critical; adaptive thinking override at CLAUDE.md:66 partially compensates but unconditionally. |
| Hook-based output truncation | **Absent** | LOW | No hook caps Bash stdout or tool output. |
| Audit/output artifact isolation (dedicated folder + Read deny) | **Absent** | MEDIUM | `logs/`, `reports/`, `output/`, `execution/`, `analysis/`, `report/`, `parts/*/drafts/` are all un-isolated. See Section 6. |

**Section 7 summary:** 5 Absent + 5 Partial + 1 n/a. The dominant pattern is "the infrastructure exists but isn't enforced." Most findings trace back to the same two root causes: (a) no `Read(...)` deny block (Section 6), and (b) QC commands that don't follow the disk-write pattern that workflow subagents already use (Section 4).

---

## 8. Best Practices Comparison (April 2026)

| # | Practice | Status | Gap | Priority |
|---|----------|--------|-----|----------|
| 1 | CLAUDE.md under 200 lines | Partial | 167 lines (PASS on threshold), but 86 lines are skill-eligible (Finding 1.1). Under threshold but over "essentials-only" bar. | MEDIUM |
| 2 | `Read(pattern)` deny rules configured | Not implemented | 0 Read-denies. Per best-practice note, well-configured denies reduce per-request context by 40–70%. | **HIGH** |
| 3 | Skills use on-demand loading | Implemented | All skills symlinked from ai-resources and loaded stepwise via commands (see Section 4.1 PASS). | — |
| 4 | Subagents for heavy reads | Partial | Research pipeline delegates correctly in most places; `/review`, `/run-cluster`, `/run-analysis`, `produce-knowledge-file` do heavy reads in main session pre-delegation (Findings 4.1.2–4.1.5). | **HIGH** |
| 5 | Strategic `/compact` at breakpoints | Partial | 22 `/compact` markers across five research-pipeline commands (good). `/draft-section` iteration has no compact checkpoint (Finding 4.2.4). CLAUDE.md lacks a compact-preserve rule (Finding 1.4). | MEDIUM |
| 6 | `/clear` between unrelated tasks | Not implemented | No documented rule. | MEDIUM |
| 7 | Model selection per task type | Not implemented | Always-Opus default via `settings.local.json` (Finding 5.1). | **HIGH** |
| 8 | Extended thinking budget controlled | Not implemented | No `MAX_THINKING_TOKENS` cap (Finding 5.2). | MEDIUM |
| 9 | Unused MCP servers disabled | Not observable | MCP config lives in user-home settings, not observable from repo context. | — (cannot assess) |
| 10 | Output-to-disk pattern for subagents | Partial | Workflow subagents follow; three QC commands (`/review`, `/challenge`, `/service-design-review`) do not (Finding 4.2.1). | **HIGH** |
| 11 | Precise prompts over vague ones | Partial | Section drafting has the `Assumptions gate` (CLAUDE.md:113–120) which nudges precision, but there's no universal "precise-prompt" norm in CLAUDE.md. | LOW |
| 12 | Session notes pattern | Implemented | `/wrap-session` + `/prime` are present, with SessionStart hook loading latest checkpoint. Solid. | — |

**Priority distribution:** 4 HIGH, 4 MEDIUM, 2 LOW, 2 N/A.

Note: Priority reflects estimated token-savings impact, not simply implementation status (per protocol Section 8 note). Practice #2 (Read denies) is HIGH because the savings per turn are potentially very large. Practice #1 (CLAUDE.md size) is MEDIUM because the current file is already under the threshold; the skill-eligibility finding is about in-file efficiency, not compliance.

---

## 9. Optimization Plan

### 9.1 — Executive Summary

The buy-side-service-plan project has a **well-designed workflow architecture** (5-stage research pipeline, 3-layer QC for service drafting, checkpoint-based session continuity) whose **token-efficiency layer is underbuilt**. The project's skill layer is entirely symlinked from `ai-resources/` (audited separately) and is in good shape. The project-owned layer has four root-cause token drains:

1. **No `Read(...)` deny rules.** The single highest-leverage gap. With `additionalDirectories` granting the full workspace as readable, every Glob/Grep can materialize content from `logs/`, `execution/`, `analysis/`, `report/`, `output/`, `parts/*/drafts/`, `reports/`, and `usage/` — which together hold ~1.08M tokens of generated/archival content. One 20-line deny block in `.claude/settings.json` is the single highest-ROI fix in this audit.
2. **Three QC commands return full findings to main session.** `/review`, `/challenge`, `/service-design-review` each return 3,000–8,000 tokens per invocation. A single drafting cycle accumulates ~10,500–19,000 tokens just from QC returns. Refactoring them to the disk-write + path-return pattern (already used by workflow subagents elsewhere) removes this cost completely.
3. **Heavy main-session reads before delegating to subagents.** `/review`, `/run-cluster`, `/run-analysis`, `/produce-knowledge-file` all violate the protocol's ">3–4 large files → delegate" rule by reading files in the main session first. 15,000–30,000 tokens per invocation are wasted on this anti-pattern.
4. **Always-Opus default with uncapped thinking.** `settings.local.json` forces `opus[1m]` for every turn; no `MAX_THINKING_TOKENS` cap. Combined effect: every mechanical turn (log appends, hook responses, checklist verification) pays Opus pricing with unbounded thinking budget. Switching to Sonnet default with Opus overrides for analytical commands, paired with a thinking cap, roughly halves per-turn cost.

Implementing Findings 6.1, 4.2.1, and 4.2.2 together (estimated 4–6 hours of work) should reduce per-drafting-iteration tokens by ~50,000 and per-turn baseline by ~1,000–2,000 tokens. Finding 5.1 (model default) affects cost more than raw token count — estimated 50–60% cost reduction on mechanical turns.

### 9.2 — Prioritized Recommendations

#### HIGH-SAVINGS TIER

**R1 — Add `Read(...)` deny block to `.claude/settings.json`** (Quick win)
| Field | Content |
| --- | --- |
| Issue | No `Read(...)` deny rules; `additionalDirectories` exposes full workspace |
| Evidence | Sections 0.3, 6.1, 6.2, 7 (Missing Safeguard #1); Best Practice #2 |
| Waste mechanism | Glob/Grep can freely surface ~1.08M tokens of generated/archival content across 460+ files during any exploration |
| Estimated savings | **HIGH** — 10k–50k tokens per accidental exploration read; compounds across sessions |
| Implementation steps | Add to `permissions.deny` array in `.claude/settings.json`: `Read("logs/**")`, `Read("execution/**")`, `Read("analysis/**")`, `Read("report/**")`, `Read("output/**")`, `Read("parts/**/drafts/**")`, `Read("reports/**")`, `Read("usage/**")`, `Read("archive/**")`, `Read("**/*.archive.*")`, `Read("**/deprecated/**")`, `Read("**/old/**")`. Optionally narrow `additionalDirectories` to `ai-resources/` only. |
| Risk | Some commands may currently rely on reading these paths. Test `/status`, `/workflow-status`, `/usage-analysis`, `/prime` after applying. Whitelist explicit paths the commands need (e.g., `logs/decisions.md` via `Read("logs/decisions.md")` allow while denying `Read("logs/session-notes*")`). |
| Dependencies | None |
| Category | **Quick win** |

**R2 — Refactor three QC commands to disk-write + path-return pattern** (Structural change)
| Field | Content |
| --- | --- |
| Issue | `/review`, `/challenge`, `/service-design-review` return 3k–8k tokens of findings into main session each |
| Evidence | Finding 4.2.1 |
| Waste mechanism | Full QC reports accumulate in main session across a 3-layer review pass |
| Estimated savings | **HIGH** — 10,500–19,000 tokens per draft iteration |
| Implementation steps | For each of the three commands: (a) modify the agent to write findings to `logs/qc/{draft-id}-{reviewer}-{YYYY-MM-DD-HHMM}.md`; (b) return only `{path} + top-3 issues one-line each`; (c) main session reads the file only if operator requests; (d) update command docs. Pattern is already in use by `qc-gate` subagent elsewhere — borrow that implementation. |
| Risk | If the operator habitually acts on inline findings, a path-return breaks the ergonomic loop. Solution: make top-3 return optional and provide a `/show-review {draft-id}` command for on-demand full-findings load. |
| Dependencies | None |
| Category | Structural change (medium effort, high payoff) |

**R3 — Delegate heavy reads in `/review`, `/run-cluster`, `/run-analysis`, `/produce-knowledge-file`** (Structural change)
| Field | Content |
| --- | --- |
| Issue | Main session reads 6–7 large files before delegating to subagent in `/review`; similar patterns in run-cluster/run-analysis/produce-knowledge-file |
| Evidence | Findings 4.1.2, 4.1.3, 4.1.4, 4.1.5 |
| Waste mechanism | File content materialized in main session unnecessarily; subagent can read independently |
| Estimated savings | **HIGH** — 15,000–30,000 tokens per `/review` invocation |
| Implementation steps | For each command: move file reads into the subagent (pass paths, not contents). The subagent already has the tools; the main session just needs to pass the file list. Pattern: `Launch qc-gate subagent with input: paths=[...], protocol_path=..., output_path=...`. |
| Risk | Low. The subagent currently expects content; adjusting it to read paths is a straightforward change. Verify with a dry run on one section. |
| Dependencies | None |
| Category | Structural change |

**R4 — Switch default model to Sonnet; specify Opus per analytical command** (Structural change)
| Field | Content |
| --- | --- |
| Issue | `settings.local.json` hardcodes `opus[1m]` for every turn |
| Evidence | Finding 5.1; Best Practice #7 |
| Waste mechanism | Mechanical turns (log appends, hook responses, checklist verification, `/wrap-session`, `/prime`) pay Opus pricing |
| Estimated savings | **HIGH (cost, not tokens)** — 60–80% cost reduction on the ~60% of turns that are mechanical |
| Implementation steps | Change `.claude/settings.local.json` to `{ "model": "sonnet" }`. Add per-command model directives in Opus-required command files (drafting, QC, synthesis commands): e.g., a frontmatter line or a command-header directive. Document the pattern in CLAUDE.md. |
| Risk | Some analytical quality may degrade if a drafting command accidentally runs on Sonnet. Mitigation: explicit `model:` directive in every heavy command file, tested once. |
| Dependencies | None (but pairs well with R5) |
| Category | Structural change |

#### MEDIUM-SAVINGS TIER

**R5 — Cap `MAX_THINKING_TOKENS` to 10,000 default; override per command**
- Savings: MEDIUM. Evidence: Finding 5.2, Best Practice #8.
- Implement via SessionStart hook that exports `MAX_THINKING_TOKENS=10000`; specific analytical commands override with `35000` (research synthesis) or `25000` (draft-section Phase 3).
- Category: Quick win.

**R6 — Drop main-session draft re-read in `/draft-section` Phase 3**
- Savings: MEDIUM. Evidence: Finding 4.2.2.
- Trust the subagent's Step 7 return summary; only re-read on explicit operator request.
- Category: Quick win.

**R7 — Extract Service Development Workflow section from CLAUDE.md into a skill**
- Savings: MEDIUM. Evidence: Finding 1.1.
- 86 lines → 2-line pointer in CLAUDE.md. Skill loaded only during Part 2/3 drafting. Est. ~900 tokens/turn saved on non-drafting sessions.
- Category: Structural change.

**R8 — Remove duplicated workspace-level content from CLAUDE.md (Commit Rules, File Verification)**
- Savings: MEDIUM (small per-turn, compounds). Evidence: Finding 1.2.
- Workspace CLAUDE.md already loaded via `additionalDirectories`. Remove ~15 duplicate lines.
- Category: Quick win.

**R9 — Add `/compact` checkpoints to `/draft-section` iteration**
- Savings: MEDIUM. Evidence: Finding 4.2.4.
- Add a checkpoint suggestion every 3 iterations on the same section, or when session is >50% context full.
- Category: Quick win.

**R10 — Add custom compaction-preserve rules to CLAUDE.md**
- Savings: MEDIUM (prevents rework after compact). Evidence: Finding 1.4.
- 5–8 lines naming preserve-on-compact items: active draft number, claim IDs in flight, QC gate status, current section, approved-vs-draft state.
- Category: Quick win.

#### LOW-SAVINGS TIER

**R11** — Replace Workflow Status / Collaboration Coach descriptions in CLAUDE.md with one-line pointers (Finding 1.3). Quick win, ~90 tokens/turn.
**R12** — Pre-scope `audit-structure` command to only load relevant conventions section (Finding 3.1). Structural change, ~2,500 tokens per invocation.
**R13** — Migrate `/final/modules/` CLAUDE.md reference if directory is permanently empty (Finding 4.2.5 / 6.16). Quick win.
**R14** — Prune superseded drafts in `parts/*/drafts/` quarterly (Finding 6.14). Ongoing hygiene.

### 9.3 — Safeguard Proposals

**SG1 — `Read(...)` deny block** (implements R1). Create as a named block in `.claude/settings.json`. Review quarterly.

**SG2 — QC-findings-to-disk pattern** (implements R2). Add a project-level convention: "All QC and review commands write findings to `logs/qc/` and return only path + top-3 one-line summary."

**SG3 — Model-per-command directive** (implements R4). Add to CLAUDE.md a section: "Model selection: Sonnet default. Commands requiring Opus must declare `model: opus` in their YAML frontmatter." Enforce via a hook that checks command frontmatter and warns if Opus is invoked without directive.

**SG4 — Thinking-budget SessionStart hook** (implements R5). Shell script that exports `MAX_THINKING_TOKENS=10000` on session start. Commands that need more set it inline.

**SG5 — Compaction rule in CLAUDE.md** (implements R10). Explicit preserve-list so `/compact` doesn't drop load-bearing state.

**SG6 — Usage telemetry cadence** (implements R-ongoing from Finding 5.3). Operator runs `/usage-analysis` at end of each significant session. Build trend data to calibrate future findings.

### 9.4 — Implications for Future Opus 4.7 Upgrade

- Opus 4.7's per-token cost profile may differ from 4.6; switching the default model (R4) should be revisited post-upgrade. If 4.7 costs are closer to Sonnet, less aggressive overrides may be needed.
- Opus 4.7's larger context window reduces the penalty for `additionalDirectories` exposure, but the hygiene argument for `Read(...)` denies (R1) remains — exploration drift costs attention, not just tokens.
- Opus 4.7 may change extended-thinking defaults. R5 (thinking cap) should be re-audited against 4.7's new defaults.
- The stepwise skill-loading pattern and file-path-plus-summary subagent returns remain best practice regardless of model version — no migration friction.

### 9.5 — Assumptions and Gaps

**Assumptions:**
- Token estimation uses `words × 1.3` per protocol. ±30% proxy drift vs. real tokenizer is plausible. Findings within 15% of severity boundaries are flagged as boundary (see Section 10).
- "Always-Opus cost reduction" estimate (R4) uses current pricing ratios. Actual savings depend on API billing at time of implementation.
- "~1.08M tokens of unprotected content" (Section 6) is a ceiling, not a per-session number. Realized cost depends on how often Glob/Grep surfaces those paths in practice — and with no `Read(...)` denies, the probability rises over the project's lifetime.
- The `@` import syntax in CLAUDE.md is assumed lazy based on Section 4.1 subagent's start-context measurement (~2,300 tokens, consistent with CLAUDE.md only, not CLAUDE.md + 4,644 reference tokens). If later Claude Code versions change this to eager, Finding 3.2 becomes a real finding.

**Gaps:**
- No `/cost` or `/context` data available in this execution environment. Audit-own token cost cannot be measured (see Section 10).
- MCP server configuration lives in user-home settings, not observable from repo context. Best Practice #9 cannot be assessed.
- Only 1 historical `usage-log.md` entry — no trend data to calibrate structural findings against observed usage.
- Symlinked skills / commands / agents excluded per operator directive; their token impact is captured in `ai-resources/audits/token-audit-2026-04-18-ai-resources.md` but not cross-referenced at fine granularity here.
- `prose-quality-standards.md` (753 lines) size was measured but not deeply inspected for in-file optimization opportunities.

---

## 10. Self-Assessment

**1. Audit token cost:** `/cost` and `/context` not available in this execution environment. Audit-own token cost cannot be measured directly. Proxy observation: three heavy subagent calls (token-audit-auditor × 4 — one skill census that returned instantly, one research-pipeline audit ~104k tokens, one service-development audit ~83k tokens, one file-handling audit ~63k tokens) totaled ~275k tokens of subagent work, plus main-session composition and protocol reads. Main session likely ≥ 100k tokens total. Net audit cost: plausibly 350k–450k tokens.

**2. Protocol gaps encountered:**
- The protocol's Section 2/3/4/6 working-note filenames are fixed (`audit-working-notes-skills.md` etc.) — collides with a prior same-day audit at different scope. Workaround used: appended scope slug to every working-file name. **Recommend: canonicalize scope suffix in the protocol's filename scheme.**
- The `/token-audit` command does not support exclusion of symlinked content. Had to pass exclusion via explicit subagent-prompt instructions. **Recommend: add a protocol note (and optional command flag) for "exclude-symlinks-to-outside-audit-root" — this pattern will recur for any project that symlinks shared skills/commands.**
- Section 8 Best Practice #9 (MCP servers) cannot be assessed at project-scope because MCP config lives in user-home settings. Protocol correctly says "not observable from repo context" — no gap, but flagged for clarity.
- No protocol-level guidance on how to estimate *cost* vs. *tokens* when a model override like `opus[1m]` changes the cost multiplier without changing token count. Findings 5.1 and R4 rely on pricing assumptions external to the protocol.

**3. Confidence ratings per major section:**

| Section | Confidence | Basis |
|---------|-----------|-------|
| 0. Pre-flight | **HIGH** | Direct measurement of settings files; deny-rule count is exact. |
| 1. CLAUDE.md | **HIGH** | Direct measurement (wc, grep) + full file read. |
| 2. Skill census | **HIGH** | 0-finding result verified by two `find` queries (with and without `-type f`). |
| 3. Command census | **HIGH** (local commands); **MEDIUM** on Finding 3.2 (`@` eagerness) | Local measurements exact; `@` behavior inferred from Section 4 subagent's start-context measurement (indirect evidence). |
| 4. Workflows | **MEDIUM** | Based on subagent summaries (single data layer). Full-notes files have more detail; confidence rises if main session reads those. Token-estimate thresholds are proxy-based (±30%). Two HIGH findings tagged "boundary" reflect this. |
| 5. Session patterns | **MEDIUM** | Config side HIGH-confidence; telemetry side LOW (1 data point). Cost-multiplier estimates use external pricing assumptions. |
| 6. File handling | **HIGH** | 620 files scanned by subagent; counts and word totals are direct measurements. |
| 7. Missing safeguards | **HIGH** | Checklist directly verified against settings/CLAUDE.md. |
| 8. Best practices | **HIGH** on measurable items (1–4, 6, 8, 10); **LOW** on items 9 (not observable), 11–12 (structural inference only). |
| 9. Optimization plan | **MEDIUM** | Synthesis of above. Savings estimates carry the proxy-drift caveat; cost savings estimates (R4) depend on current pricing. |

**4. Threshold-boundary findings (±15% of severity classification):**

Flagged in subagent summaries:
- Section 4.1 (research pipeline): 1 HIGH boundary + 1 LOW boundary (per subagent summary line 4).
- Section 4.2 (service development): 1 HIGH boundary on `context/prose-quality-standards.md` at 753 lines — boundary on load-path attribution severity, not on the 500-line threshold.
- Section 6: subagent reported 0 of top-20 files within ±15% of severity boundaries.

These boundary findings may flip classification under a real tokenizer. Treat their severity ratings as indicative rather than definitive.



