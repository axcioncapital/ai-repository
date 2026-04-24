# Token Audit — 2026-04-24
Scope: ai-resources repo
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: token-audit-2026-04-18-ai-resources.md

---

## 0. Pre-Flight Summary

- **Baseline metrics (`/cost`, `/context`):** not available in this execution environment.
- **Session telemetry:** available — `logs/usage-log.md` (122 lines, 2026-04-21→22) and older `usage/usage-log.md` (227 lines, 2026-04-18, orphaned pre-migration copy). Section 5 inline (2 files ≤3 threshold).
- **Read(pattern) deny-rule verdict: MEDIUM** (improved from 2026-04-18 HIGH). Main `.claude/settings.json` now has `Read(archive/**)`; still missing audits/, logs/, reports/, inbox/, deprecated/, old/. See Section 6 and 7 for propagation.

---

## 1. CLAUDE.md Audit

**File:** `CLAUDE.md` (ai-resources root)
**Line count:** 88 (well under 200-line target)
**Estimated tokens:** 853 words × 1.3 ≈ **1,109 tokens**
**Subdirectory CLAUDE.md files found:** `workflows/research-workflow/CLAUDE.md` (128 lines, 1,360 words ≈ 1,768 tokens — only loaded when working under that subdirectory, not across ai-resources-wide sessions)

**Per-session cost:** Main CLAUDE.md costs ~1,109 tokens on every turn. Across a typical 30–50 turn session, that is ~33,000–55,000 tokens spent on CLAUDE.md loading alone.

**Assessment:**

| # | Dimension | Verdict |
|---|-----------|---------|
| 1 | Size (<200 lines target) | PASS — 88 lines |
| 2 | Essentials-only | PASS — every section is cross-session scoped |
| 3 | Skill-eligible content | PASS — points to skills rather than duplicating them (Skill Creation → ai-resource-builder SKILL.md; friday-checkup details → command file) |
| 4 | Redundancy with skills | PASS — no duplicated skill methodology; Commit Rules intentionally mirrors workspace CLAUDE.md (documented) |
| 5 | Compaction instructions | PASS — explicit `## Compaction` block (lines 77–84) lists what to preserve |
| 6 | Aspirational content | PASS — all instructions are behavioral, not aspirational |

**Findings:**

No HIGH or MEDIUM findings. CLAUDE.md is in strong shape — tight, behavioral, compaction-aware.

**LOW — maintenance-cadence pointer verbosity (line 52):** The `## Maintenance Cadence` block is five lines describing what `/friday-checkup` does. Most of that detail is already in the command file. A one-line "Run `/friday-checkup` each Friday — see `.claude/commands/friday-checkup.md`" would save ~40 words (~50 tokens/turn). Optional trim.

---

## 2. Skill Census

**Total skills:** 69 (67 canonical + 2 workflow-reference copies)
**Total lines:** 14,334 | **Total words:** 126,050 | **Estimated tokens:** ~164,000

**Size distribution:**
- Under 50 lines: 0%
- 50–150 lines: 35%
- 150–300 lines: 57%
- Over 300 lines: 9% (6 skills)

**Findings:**

| # | Severity | Finding |
|---|---|---|
| 1 | HIGH | Six oversized skills >300 lines: `answer-spec-generator` (485L), `research-plan-creator` (464L), `ai-resource-builder` (401L), `evidence-to-report-writer` (332L), `workflow-evaluator` (316L), `ai-prose-decontamination` (314L). Combined ~19,000 tokens when any one loads — compounds if multi-mode. |
| 2 | MEDIUM | Multi-mode bloat in `ai-resource-builder` (3 modes) and `answer-spec-generator` (5 modes): load all modes together even though any single invocation uses one. Split-per-mode would save ~1,500–2,000 tokens/session. |
| 3 | LOW | `knowledge-file-producer` and `report-compliance-qc` exist in both `skills/` and `workflows/research-workflow/reference/skills/` (intentional workflow self-containment, but creates maintenance risk). |
| 4 | LOW | 2 of 69 skills have vague descriptions lacking explicit trigger conditions. |

**Quality metrics:** Frontmatter complete: 100%. Descriptions trigger-rich: 97%. Dead skills: 0. Semantic redundancy: 0.

**Boundary note:** 4 skills within ±15% of the 300-line threshold — confidence on the exact 6-skill HIGH count is MEDIUM.

Full notes: `audits/working/audit-working-notes-skills.md`.

---

## 3. Command File Census

**Total command files found:** 61 (34 in `ai-resources/.claude/commands/` + 27 in `workflows/research-workflow/.claude/commands/`)
**Combined word count:** 47,557 words (~61,800 tokens if ever all loaded — they are not; commands load only when invoked)

**Top 10 largest commands (ai-resources scope):**

| Rank | Command | Lines | Est. tokens | Note |
|---|---|---|---|---|
| 1 | `new-project.md` | 476 | ~1,050 | Orchestrator — invokes 5 pipeline-stage subagents; commensurate length |
| 2 | `deploy-workflow.md` | 321 | (boundary) | Multi-step orchestrator |
| 3 | `repo-dd.md` | 314 | (boundary) | Due-diligence pipeline |
| 4 | `friday-checkup.md` | 218 | ~560 | This very command — multi-tier cadence orchestrator |
| 5 | `token-audit.md` | 197 | — | 17-step protocol wrapper |
| 6 | `cleanup-worktree.md` | 162 | — | |
| 7 | `sync-workflow.md` | 160 | — | |
| 8 | `improve-skill.md` | 157 | — | |
| 9 | `analyze-workflow.md` | 130 | — | |
| 10 | `audit-claude-md.md` | 127 | — | |

**Findings:**

| # | Severity | Finding |
|---|---|---|
| 1 | MEDIUM | Three commands >300 lines (`new-project` 476, `deploy-workflow` 321, `repo-dd` 314) — each ~800–1,100 tokens when invoked. Commands are on-demand loads so per-session cost is bounded, but verbose orchestrators are candidates for the protocol-file pattern (short command wrapper + external protocol doc). `token-audit` already uses this pattern (command = 197 lines, protocol = 633 lines loaded separately). Consider same for `new-project` and `deploy-workflow`. |
| 2 | LOW | `repo-dd.md` at 314 is a boundary case (±15% of 300-line threshold) — confidence MEDIUM. |
| 3 | LOW | No cascading cat/include patterns observed — commands invoke skills/agents, which is the correct pattern. |

**Redundant loading:** None observed. Commands do not re-load CLAUDE.md content.

---

## 4. Workflow Token Efficiency

**Workflows identified under ai-resources:**
- **research-workflow** (primary, multi-stage: preparation → execution → synthesis → production → QC). Located at `workflows/research-workflow/`. Active — referenced in CLAUDE.md pointer, invoked via `/run-*` and `/produce-*` commands.
- Slash-command orchestrators (one-shot, not multi-stage workflows): `/new-project`, `/create-skill`, `/friday-checkup`, `/repo-dd`, `/token-audit`, `/audit-repo`. Captured in Section 3 (command census).

Detailed per-workflow audit run only for `research-workflow` (the one true multi-stage workflow under this scope).

### Workflow: research-workflow (prose sub-pipeline focus)

**Scope audited:** `/produce-architecture`, `/produce-prose-draft`, `/produce-formatting` (the April 2026 three-command split of the former produce-prose.md).

**Findings count:** 18 (7 HIGH, 8 MEDIUM, 3 LOW; 4 boundary-tagged)

**Top HIGH findings:**

| # | Finding | Waste mechanism |
|---|---|---|
| 1 | `/produce-prose-draft` Phase 3 subagent returns a unified findings list to main session (chapter-prose-reviewer + prose-compliance-qc 4 scans + 13 prose-quality checks + expanded detection tests). Explicitly preserved across `/compact` per line 113. Est. 60–200+ lines per invocation. | Large subagent returns violate output-to-disk pattern; `/compact` preservation extends the life of that context. |
| 2 | Ten SKILL.md files (~29,400 tokens) loaded in main session across the three commands before being passed to subagents. The pattern already used for `style-reference.md` / `prose-quality-standards.md` (subagent reads by path) is not applied to skill files. | Full skill loads consumed in main context when a path+delegation pattern would save ~29k tokens per invocation. |
| 3 | `/produce-formatting` Phase 2 subagent returns full H3 decisions table + formatting change log + MTC pre-scan + SPLIT verdicts to main session. Required for Phase 4 operator surfacing, but 50–200+ lines. | Large structured return adds to main-session context on every formatting pass. |
| 4 | `/produce-formatting` Phase 3 two-stage QC return — 60–200+ lines. | Same pattern as #1/#3. |
| 5 | Source document re-read 3× in prose-draft main session. | Redundant reads instead of a single read + scoped subagent handoffs. |
| 6 | `/produce-prose-draft` Phase 4 reads all completed prose sections in main session (6–18k tokens). | Main-session aggregation of content that could be summarized in a subagent. |
| 7 | `/produce-architecture` Phase 3 re-reads all section drafts in main session. | Same pattern — section drafts should be delegated. |

**MEDIUM themes:** command file size (produce-prose-draft 203 lines / ~4,500 tokens); inline Tier 1/2/3 + Standards 10–13 detection tests duplicating `prose-quality-standards.md`; no `/clear` between commands; `@`-reference always-load of `stage-instructions`; findings-list preservation across `/compact`; 7–9 subagent launches per section end-to-end.

**LOW:** architecture.md small re-reads; out-of-scope note on run-execution.md size.

Full notes: `audits/working/audit-working-notes-workflow-research-workflow.md`.

---

## 5. Session Patterns & Configuration

**Session telemetry available: YES** — logs/usage-log.md (4 entries, 2026-04-21→22) plus orphan usage/usage-log.md (10+ entries, 2026-04-18).

**Verdict distribution (recent 4 sessions):** 2 Acceptable / 1 Efficient / 1 Wasteful. Small-N — directional only.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---|---|---|---|
| Default model | not set in settings.json; CLAUDE.md states "Opus 4.6 for subagents" | Declared per-agent via YAML (already canonical rule — see workspace CLAUDE.md Model Tier → Agents). Main session model is set via harness, not settings. | PASS — policy is in place; agent files declare `model:` explicitly per the Agent Tier Table. |
| Subagent model | Per-agent frontmatter | Haiku for mechanical; Sonnet structured; Opus judgment | PASS — token-audit-auditor-mechanical (Haiku), token-audit-auditor (Opus) conform. |
| MAX_THINKING_TOKENS | Not set | 10,000 for routine; higher only for complex reasoning | MEDIUM — unchanged from 2026-04-18. Default budget can burn tens of thousands of tokens per request. No guidance in CLAUDE.md sets this. |
| Autocompact threshold | Not set | 80% | LOW — default behavior applies. Workspace CLAUDE.md pre-compact-checkpoint principle exists but no explicit threshold override. |
| MCP servers active | Not observable from repo context | Disable unused | — |
| defaultMode | `bypassPermissions` | Accepted tradeoff (documented 2026-04-23 decision) — `deny` list retains destructive-op floor | PASS |

**Hooks active (settings.json):**
- `PreToolUse` matcher `Read|Grep|Bash` → `check-heavy-tool.sh` (5s timeout). Flags heavy reads/greps/bash invocations.
- `Stop` → `check-stop-reminders.sh` (5s timeout). End-of-session reminder chain.
- `SessionStart` → `friday-checkup-reminder.sh`. Fires Friday-reminder if today's checkup report missing.

**Hook scripts present but not wired into settings.json:** `auto-sync-shared.sh`, `check-skill-size.sh`, `check-template-drift.sh`, `detect-innovation.sh`, `pre-commit`. Several are invoked manually (e.g., `check-archive.sh` at wrap) or by git hooks (`pre-commit`). Not a finding — intentional separation.

**Findings:**

| # | Severity | Finding |
|---|---|---|
| 1 | MEDIUM | `MAX_THINKING_TOKENS` not set — unchanged from 2026-04-18 audit. Still a MEDIUM carryover. |
| 2 | LOW | Orphan `usage/usage-log.md` (227 lines) sits unclean alongside canonical `logs/usage-log.md`. Candidate for archive or deletion. |
| 3 | LOW | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` not set. Default may suffice; no finding-with-teeth without telemetry. |

---

## 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3): MEDIUM**
Covered directories: `archive/`
Missing expected coverage: `audits/`, `logs/`, `reports/`, `inbox/`, `deprecated/`, `old/`

**Findings (6 total — 0 HIGH, 4 MEDIUM, 2 LOW):**

| # | Severity | Finding |
|---|---|---|
| 1 | MEDIUM | `Read(pattern)` deny-rule coverage incomplete. Only 1 of 8 expected directories covered (`archive/`); missing `audits/`, `logs/`, `reports/`, `inbox/`, `drafts/`, and glob patterns. |
| 2 | MEDIUM | `audits/` directory contains 13 large files (9 prior reports + 4 working notes) totaling ~8,000+ lines / ~76,000 estimated tokens, unprotected. A single `Glob`/`Grep` could load ~100k tokens. |
| 3 | MEDIUM | `logs/session-notes.md` (437 lines / 5,362 words ≈ 6,970 tokens) is the largest single file in repo; stored in unprotected `logs/` directory. |
| 4 | MEDIUM | `audits/working/` (in-progress audit notes), `reports/` (generated output), `logs/` archives — all unprotected. |
| 5 | LOW | Archive-marked files at root of `logs/` despite archive naming convention — candidate for `Read(logs/*-archive-*.md)` pattern (already used in workflow settings). |
| 6 | LOW | Superseded repo-due-diligence versions (04-06, 04-11, 04-12) coexist in `audits/` without explicit deprecation. |

No HIGH findings. No deprecated/draft directories found.

Full notes: `audits/working/audit-working-notes-file-handling.md`.

---

## 7. Missing Safeguards

| Safeguard | Status | Severity if missing | Recommendation |
|---|---|---|---|
| `Read(pattern)` deny rules covering stale/large directories | Partial | HIGH | Add `Read(audits/**)`, `Read(reports/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`. |
| Custom compaction instructions in CLAUDE.md | Present | MEDIUM | None — `## Compaction` block lists what to preserve. |
| Subagent output-to-disk pattern | Present | MEDIUM | Codified in CLAUDE.md `## Subagent Contracts` (30-line summary cap; notes to disk). Research-workflow prose sub-pipeline (Section 4) violates this in places — fix per Section 9. |
| Context window monitoring instructions | Absent | MEDIUM | No `/context`, `/cost`, or equivalent guidance in CLAUDE.md. Workspace CLAUDE.md has `[COST]` Session Guardrail — partial coverage. |
| Session boundaries defined for workflows | Present | MEDIUM | `## Session Boundaries` prefers `/clear` between unrelated tasks. Research-workflow sub-pipeline does not prescribe `/clear` between produce-architecture → produce-prose-draft → produce-formatting (Section 4 MEDIUM finding). |
| Model selection guidance | Present | LOW | Opus 4.6 default in CLAUDE.md; Agent Tier Table canonical in workspace. |
| File read scoping (Read lines X-Y) | Partial | LOW | No explicit scoping rule in CLAUDE.md; followed ad-hoc in skill bodies. |
| Output length constraints | Present | LOW | 30-line summary cap on subagent contracts. |
| Effort level guidance | Absent | LOW | No `/effort` configuration or equivalent. |
| Hook-based output truncation | Absent | LOW | `check-heavy-tool.sh` flags but does not truncate. |
| Audit/output artifact isolation | Partial | MEDIUM | `audits/working/` exists; `audits/` and `reports/` not covered by `Read(...)` deny (see Section 6). |

---

## 8. Best Practices Comparison

| # | Practice | Status | Gap | Priority |
|---|---|---|---|---|
| 1 | CLAUDE.md under 200 lines | Implemented | 88 lines, well under | — |
| 2 | `Read(pattern)` deny rules configured | Partial | 1 of 8 expected dirs covered | HIGH |
| 3 | Skills use on-demand loading | Implemented | Standard Claude Code skill mechanism; descriptions 97% trigger-rich | — |
| 4 | Subagents for heavy reads | Implemented | Codified in `## Subagent Contracts`; observed in research-workflow prose pipeline with violations | MEDIUM |
| 5 | Strategic `/compact` at breakpoints | Partial | Compaction instructions present in CLAUDE.md; workflows don't prescribe `/compact` points | MEDIUM |
| 6 | `/clear` between unrelated tasks | Implemented | `## Session Boundaries` rule; research-workflow sub-pipeline lacks internal `/clear` guidance | LOW |
| 7 | Model selection per task type | Implemented | Agent Tier Table canonical | — |
| 8 | `MAX_THINKING_TOKENS` controlled | Not implemented | Not set anywhere | MEDIUM |
| 9 | Unused MCP servers disabled | Not observable | Cannot audit from repo context | — |
| 10 | Output-to-disk for subagents | Partial | Codified; research-workflow violations (Section 4 HIGH findings 1, 3, 4) | HIGH |
| 11 | Precise prompts over vague | Implemented (structural assessment) | Skills contain trigger-rich descriptions; no systematic prompt audit done | — |
| 12 | Session notes pattern | Implemented | `/wrap-session` writes session-notes.md; `/prime` reads at start | — |

---

## 9. Optimization Plan

### 9.1 Executive Summary

The ai-resources repo has improved materially since 2026-04-18 — `Read(archive/**)` was added (bumping the 0.3 verdict from HIGH → MEDIUM), CLAUDE.md is tight (88 lines, 1,109 tokens), and the subagent output-to-disk contract is codified. The top remaining cost drivers are: (1) large-subagent returns in the research-workflow prose sub-pipeline that violate the contract, (2) six oversized skills >300 lines (~19k tokens when any one loads), and (3) incomplete `Read(pattern)` deny coverage for `audits/`, `logs/`, `reports/`, `inbox/`. Highest per-turn impact fixes: expand Read() deny rules (touches every turn when broad Glob/Grep runs) and rework the research-workflow prose-pipeline subagent returns (touches every prose chapter produced). Lower-effort wins: split multi-mode skills (`ai-resource-builder`, `answer-spec-generator`) and delete the orphan `usage/usage-log.md`.

### 9.2 Prioritized Recommendations

#### HIGH

**H1 — Rework research-workflow prose-pipeline subagent returns to output-to-disk pattern.**

| Field | Content |
|---|---|
| Issue | Three HIGH findings in Section 4 (produce-prose-draft Phase 3, produce-formatting Phase 2, produce-formatting Phase 3) return 60–200+ line findings lists into main session; Phase 3 returns are explicitly preserved across `/compact`. |
| Evidence | `audits/working/audit-working-notes-workflow-research-workflow.md`. |
| Waste mechanism | Subagent returns repeatedly balloon main-session context per chapter produced. `/compact` preservation extends the life of that context. Estimate: ~10,000–30,000 tokens per chapter that could live in working files instead. |
| Estimated savings | HIGH — affects every prose chapter produced. |
| Implementation | Route each of the three subagent returns to `working/<phase>-findings.md`; return only path + 1-line verdict. Align with `## Subagent Contracts` in CLAUDE.md (30-line summary cap). |
| Risk | Requires operator-surfacing logic to read the working file at approval gates. |
| Dependencies | None. |
| Category | Structural change. |

**H2 — Expand `Read(pattern)` deny coverage in `ai-resources/.claude/settings.json`.**

| Field | Content |
|---|---|
| Issue | Only `Read(archive/**)` set; `audits/`, `reports/`, `logs/` archives, `inbox/archive/` unprotected. |
| Evidence | Section 0.3, Section 6 Finding 2 (13 large files in `audits/` = ~76k tokens). |
| Waste mechanism | Broad Glob/Grep passes during Explore/plan phases can pull prior audit reports into context. |
| Estimated savings | HIGH — affects every turn that runs broad search. |
| Implementation | Add: `Read(audits/**)`, `Read(reports/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`. Keep `logs/session-notes.md` and `logs/decisions.md` readable (do not deny `logs/**` wholesale). |
| Risk | Broad `logs/**` deny would block Prime and coach reads. Use narrow patterns only. |
| Dependencies | None. |
| Category | Quick win (2 min edit, immediate compound benefit). |

**H3 — Split multi-mode skills into mode-specific files.**

| Field | Content |
|---|---|
| Issue | `ai-resource-builder` (401 lines, 3 modes) and `answer-spec-generator` (485 lines, 5 modes) load all modes when invoked for any single mode. |
| Evidence | Section 2 Finding 2. |
| Waste mechanism | ~1,500–2,000 tokens of unused mode content loaded per invocation. |
| Estimated savings | HIGH per invocation (MEDIUM in aggregate depending on frequency). |
| Implementation | Split each into per-mode SKILL.md with shared `common.md` if needed. `/create-skill` pipeline supports this pattern. |
| Risk | Callers reference the skill by name — update callers. |
| Dependencies | Coordinate with any workflow that invokes these skills. |
| Category | Structural change. |

#### MEDIUM

**M1 — Set `MAX_THINKING_TOKENS` in settings.json.** Quick win: add `"env": {"MAX_THINKING_TOKENS": "10000"}` to `.claude/settings.json`. Estimated savings: MEDIUM per session for non-judgment work. Risk: Opus judgment agents may need higher — raise per-agent if needed. (Carryover from 2026-04-18.)

**M2 — Compress verbose orchestrator commands via protocol-file pattern.** `new-project.md` (476L) and `deploy-workflow.md` (321L) are candidates for the wrapper + external protocol split already used by `/token-audit` (197L + 633L protocol). Savings: ~500–1,000 tokens per invocation. Category: Structural.

**M3 — Add `/clear` guidance between research-workflow commands.** `produce-architecture` → `produce-prose-draft` → `produce-formatting` do not prescribe a session boundary. Add a one-line "run `/clear` before `/produce-prose-draft`" block to command frontmatter or CLAUDE.md. Savings: MEDIUM (prevents cross-command context compounding).

#### LOW

**L1 — Delete orphan `usage/usage-log.md` (227L).** Migration artifact; canonical is `logs/usage-log.md`. Simple `rm` + commit.

**L2 — Add narrow archive pattern to main settings.** `Read(logs/*-archive-*.md)` (already in workflow settings) would catch session-note archives without blocking canonical logs.

**L3 — Trim `## Maintenance Cadence` block in CLAUDE.md** to a one-line pointer. Saves ~50 tokens/turn.

**L4 — Archive superseded repo-dd reports** (04-06, 04-11, 04-12) to `audits/archive/` — depends on Read(archive/**) coverage.

### 9.3 Safeguard Proposals

- **Auto-wire `Read(...)` denies on new directories.** When `/new-project` or `/create-skill` creates a new artifact directory (drafts/, output/, etc.), propose adding a corresponding `Read(...)` deny to the settings file as part of the pipeline.
- **Refactor research-workflow prose sub-pipeline to output-to-disk.** Codify as a retrofit task — Phase 3 / Formatting Phases 2 and 3 subagents write to `working/` and return paths only.
- **Per-agent `maxThinkingTokens` declarations.** Add a convention in the Agent Tier Table for when thinking budgets should be raised above the 10k default.

### 9.4 Implications for Future Opus 4.7 Upgrade

- Savings from H1/H2 compound with Opus 4.7 because thinking tokens become cheaper per-value, not cheaper per-token — removing noise from context still matters.
- `MAX_THINKING_TOKENS` (M1) should be re-tuned post-upgrade; Opus 4.7 extended-thinking budget may differ.
- Multi-mode skill splits (H3) make model-routing per mode easier (e.g., mechanical-mode on Haiku vs. judgment-mode on Opus).
- The `/compact` preservation rules in prose-draft Phase 3 (H1) should be reviewed post-upgrade — newer auto-compaction may subsume some of the explicit preservation.

### 9.5 Assumptions and Gaps

- Token estimates via word × 1.3 proxy; ±30% drift possible. Boundary-flagged findings (4 in skills; 1 in commands) could flip severity under real tokenization.
- `/cost` and `/context` unavailable in this execution environment — no direct measurement of audit-session token cost.
- Telemetry dataset small (4 sessions in logs/usage-log.md) — verdict-distribution signals are directional only.
- MCP server inventory not observable from repo context.

---

## 10. Self-Assessment

**Audit token cost:** Not measurable (`/cost` unavailable).

**Protocol gaps encountered:**
- Section 4 "workflows" ambiguity: the ai-resources repo has one true multi-stage workflow (research-workflow) and several slash-command orchestrators (`/new-project`, `/create-skill`, `/friday-checkup`, `/repo-dd`, `/token-audit`, `/audit-repo`). The protocol's "top 5 by reference frequency" rule treats both as equivalent. Handled by auditing research-workflow via subagent and folding the slash-command orchestrators into Section 3 (commands). Document this resolution in protocol v1.3.
- Section 5 Workspace-scope rule says delegate if >3 telemetry files; with 2 usage-logs at ai-resources scope, ran inline. Rule worked as written.

**Per-section confidence:**

| Section | Confidence | Note |
|---|---|---|
| 0. Pre-flight | HIGH | Direct file/config measurement. |
| 1. CLAUDE.md | HIGH | Direct read + measurement. |
| 2. Skill census | MEDIUM | Mechanical measurement HIGH; 4 boundary cases within ±15% of 300-line threshold. |
| 3. Command census | HIGH | Direct line counts; no cascading-load evidence needed beyond file-grep. |
| 4. Workflow audit | MEDIUM | Structural inferences from command text; no session telemetry. |
| 5. Session patterns | MEDIUM | Config observations HIGH; telemetry small-N (4 sessions). |
| 6. File handling | HIGH | Direct file-size inspection; deny-rule parse via jq-equivalent. |
| 7. Missing safeguards | HIGH | Direct grep on CLAUDE.md + settings.json. |
| 8. Best practices | MEDIUM | Synthesis of above. |
| 9. Optimization plan | MEDIUM | Savings estimates are directional. |

**Threshold-boundary findings:** 4 skills within ±15% of 300-line threshold (Section 2); `repo-dd.md` at 314 lines (Section 3).

**Improvement vs. 2026-04-18 baseline:**
- `Read(pattern)` verdict improved HIGH → MEDIUM (Read(archive/**) added).
- Telemetry now available (was absent 2026-04-18).
- CLAUDE.md still tight and compaction-aware.
- `MAX_THINKING_TOKENS` still unset — unchanged MEDIUM carryover.
- Subagent output-to-disk contract now codified in CLAUDE.md — unchanged from 2026-04-18.
