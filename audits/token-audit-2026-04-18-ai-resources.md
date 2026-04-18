# Token Audit — 2026-04-18
Scope: ai-resources repo
AUDIT_ROOT: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Previous audit: None

## 0. Pre-Flight Summary

**Telemetry:**
- `/cost` + `/context`: not available in this execution environment.
- `session-usage-analyzer` skill present at `skills/session-usage-analyzer/SKILL.md`; no historical output files exist (`workflows/research-workflow/usage/` contains only `.gitkeep`). Section 5 runs on structural analysis only.

**`Read(pattern)` deny-rule check (Section 0.3):**

| Field | Value |
|---|---|
| Verdict | **HIGH** |
| Settings files scanned | 2 (`.claude/settings.json` at repo root; `workflows/research-workflow/.claude/settings.json`) |
| Covered directories via `Read(...)` deny | NONE |
| Missing expected coverage | `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, `*deprecated*`, `*old*` |

Full working notes: `audits/working/audit-working-notes-preflight.md`

## 1. CLAUDE.md Audit

**Files inspected:**

| File | Lines | Words | Est. tokens (×1.3) | Headings |
|---|---|---|---|---|
| `CLAUDE.md` (root) | 104 | 834 | ~1,084 | 13 |
| `workflows/research-workflow/CLAUDE.md` (template with `{{PLACEHOLDERS}}`) | 105 | 1,155 | ~1,502 | 15 |

**Per-session cost (root CLAUDE.md only, loaded every turn):** ~1,084 tokens/turn. Over a 30–50 turn session: ~32,500–54,200 tokens spent on ai-resources CLAUDE.md loading. (The workflow-template CLAUDE.md is NOT loaded in ai-resources sessions — it's a template rendered only into deployed projects; so it is a per-project cost, not a per-ai-resources-session cost.)

**Workspace note:** ai-resources sessions also carry the parent workspace `CLAUDE.md` (not measured under this scope but known from session context to be substantially larger — driving total per-turn CLAUDE.md cost well above 1,084 tokens). This is tracked as a workspace-scope concern, not a finding against ai-resources specifically.

**Findings:**

| # | Finding | Severity | Lines affected | Recommendation |
|---|---------|----------|----------------|----------------|
| 1.1 | Skill-eligible content loaded every session. "Skill Format Standard" (lines 22–38), "Development Workflow / Creation" (lines 48–57), "Development Workflow / Improvement" (lines 59–67), "Quality Check" (lines 69–71), and "Cross-References" (lines 79–86) apply only when creating or modifying AI resources — not to every session type (e.g., audits, wrap-session, triage). These ~40 lines (~350 words, ~455 tokens) cost roughly 13,650–22,750 tokens per 30–50 turn session when the session never touches skill creation. | MEDIUM | 22–38, 48–71, 79–86 | Migrate this content into `ai-resource-builder/SKILL.md` (or a dedicated `skill-development-workflow` skill) which already governs skill creation methodology. Leave a 1-line pointer in CLAUDE.md: "Skill creation and improvement rules: see `ai-resource-builder` skill." |
| 1.2 | Duplicate content between CLAUDE.md and `ai-resource-builder` skill. "Skill Format Standard" (conventions: lowercase-hyphenated folders, SKILL.md exact name, description triggers, body under 500 lines) duplicates what `ai-resource-builder/SKILL.md` governs. Double-loaded when ai-resource-builder is invoked. | MEDIUM | 22–38 | Consolidate into the skill. Same fix as finding 1.1. |
| 1.3 | Redundancy between "Development Workflow" section and `/create-skill` + `/improve-skill` command files. Both prescribe the same 7–8 step creation/improvement sequences. | MEDIUM | 48–71 | Let the commands own the sequences. Remove from CLAUDE.md. |
| 1.4 | Missing custom compaction instructions. CLAUDE.md does not include any `/compact` guidance telling Claude what to preserve during auto-compaction. The workspace CLAUDE.md has a "Pre-compact checkpoint" principle but ai-resources CLAUDE.md does not extend it with ai-resources-specific preservation rules (e.g., preserve `inbox/` brief paths, preserve active skill-creation-pipeline state). | MEDIUM | N/A (missing) | Add a 3–5 line "Compaction" section: what to preserve in ai-resources sessions (active skill brief path, pipeline stage, pending QC subagent outputs). |
| 1.5 | Aspirational multi-tool-ecosystem framing. "These resources operate across a multi-tool ecosystem — not just Claude. Skills may reference or interact with GPT-5…" (line 16). Descriptive context, does not change turn-by-turn behavior. | LOW | 16 | Optional: trim to a one-line pointer or move to a project-description/README (if needed). Savings small but per-turn. |
| 1.6 | `How I Work` section relies on inherited workspace-level user profile already available via memory (`user_role.md` in auto-memory) and workspace CLAUDE.md. Duplication cost is small but measurable. | LOW | 18–20 | Optional: shorten to one line or remove; rely on memory + workspace CLAUDE.md. |
| 1.7 | Workflow-template CLAUDE.md at 105 lines/1,155 words is above the recommended 200-line threshold when deployed per-project, BUT — since it's a template with `{{PLACEHOLDERS}}`, rendered once per deploy — the per-deployed-session cost lands on the project, not ai-resources. Still large by current best-practice standards. | LOW (in-scope) | N/A | Flag for template-review session. Consider trimming on deploy-time render. |

**Summary:** Root CLAUDE.md passes the 200-line size check but carries ~40 lines of skill-creation-specific instruction that could be moved to skill or command files, plus a missing-compaction-instructions gap. Estimated recoverable per-session cost: ~455 tokens/turn when the session doesn't involve skill creation (roughly 70–80% of sessions by rough estimate from session notes), or ~13,650–18,200 tokens per typical session.

## 2. Skill Census

**Total skills (SKILL.md files):** 69 (67 unique + 2 duplicated between `skills/` and `workflows/research-workflow/reference/skills/`)
**Total lines across all skills:** 14,171
**Total words across all skills:** 120,956
**Total estimated tokens (×1.3):** ~157,243

**Size distribution:**
- Under 50 lines: 0 skills
- 50–150 lines: 25 skills
- 150–300 lines: 35 skills
- Over 300 lines: 9 skills (including 1 boundary case at exactly 300)

**Findings:**

| # | Finding | Severity | Count | Recommendation |
|---|---------|----------|---|---------------|
| 2.1 | 8 skills exceed 300 lines (HIGH threshold). Largest: `ai-prose-decontamination.md` (484 L / 6,417 W / ~8,342 tokens), `answer-spec-generator.md` (485 L), `research-plan-creator.md` (464 L), `ai-resource-builder.md` (463 L). | HIGH | 8 | For each: assess whether to split into narrower skills, compress verbose examples, or convert examples to on-demand references. Largest wins on the longest files — `ai-prose-decontamination` and `answer-spec-generator` are the priority. |
| 2.2 | 36 skills sit in the 150–300 line MEDIUM band. 7 of those are within ±15% of the 300-line HIGH threshold (boundary findings — see Section 10 confidence rating). | MEDIUM | 36 | Triage pass: flag the 7 boundary-cases for possible upgrade to HIGH if a real tokenizer confirms they cross the threshold. |
| 2.3 | 2 pairs of duplicate SKILL.md files exist at both `skills/` and `workflows/research-workflow/reference/skills/`: `knowledge-file-producer` and `report-compliance-qc`. | LOW | 2 pairs | Already flagged in decision log (2026-04-06 canonical vs. deployed divergence). Not a per-turn cost — loaded only when invoked. Revisit if additional duplicates appear. |
| 2.4 | **Non-findings of note:** All 69 files have valid frontmatter (name + description). All descriptions include activation triggers and "Do NOT use for" exclusions. No vague descriptions. No folder-level deprecation markers. 15 skills have 0 inbound references but none qualify as "dead" per the protocol's strict criteria. | PASS | — | Frontmatter quality is uniformly strong. This is a non-trivial baseline achievement — most repos audited against this protocol would have vague descriptions to fix. |

Full working notes: `audits/working/audit-working-notes-skills.md` (not re-read by main session).

**Summary:** Skill library totals ~157k tokens if fully loaded (none are — on-demand loading is the point), but the 8 HIGH skills (>300 lines each) collectively represent ~45k tokens that load into context when those skills are invoked. The largest 2 (`ai-prose-decontamination`, `answer-spec-generator`) dominate. Skill-body trimming is the largest lever in this category.

## 3. Command File Census

**Total command files found:** 54
- ai-resources shared (`.claude/commands/`): 30
- research-workflow template (`workflows/research-workflow/.claude/commands/`): 24

**Size distribution (combined):**
- Under 50 lines: 20 commands (trivial orchestration / delegation wrappers)
- 50–150 lines: 22 commands
- 150–300 lines: 8 commands
- Over 300 lines: 4 commands (`new-project.md`, `deploy-workflow.md`, `repo-dd.md` — ai-resources; `produce-prose-draft.md` at 207 lines qualifies as dense rather than over-300)

**Top 10 largest commands (by line count × word count):**

| Rank | Command | Lines | Words | Est. tokens (×1.3) |
|---|---|---|---|---|
| 1 | `new-project.md` (ai-resources) | 351 | 3,552 | ~4,618 |
| 2 | `deploy-workflow.md` (ai-resources) | 317 | 1,770 | ~2,301 |
| 3 | `repo-dd.md` (ai-resources) | 301 | 2,626 | ~3,414 |
| 4 | `produce-prose-draft.md` (workflow) | 207 | 3,313 | ~4,307 |
| 5 | `token-audit.md` (ai-resources) | 193 | 1,422 | ~1,849 |
| 6 | `run-analysis.md` (workflow) | 181 | 1,417 | ~1,842 |
| 7 | `run-execution.md` (workflow) | 180 | 2,024 | ~2,631 |
| 8 | `sync-workflow.md` (ai-resources) | 160 | 936 | ~1,217 |
| 9 | `cleanup-worktree.md` (ai-resources) | 145 | 1,974 | ~2,566 |
| 10 | `audit-structure.md` (workflow) | 145 | 1,014 | ~1,318 |

**Cascading-load map for top 5 by main-session context cost when invoked:**

| Command | Main-session loads | Subagent-only loads | Est. main-session context cost |
|---|---|---|---|
| `/cleanup-worktree` | command (145 L) + `worktree-cleanup-investigator/SKILL.md` (241 L, 3,133 W) + `references/decision-taxonomy.md` (230 L, 2,027 W) + `references/execution-protocol.md` (310 L, 3,766 W) | none | **~14,170 tokens** (skill + 2 refs loaded to main; this is the largest single main-session command cost) |
| `/token-audit` | command (193 L, 1,422 W) + protocol read into working memory per Step 12 (632 L, ~5,600 W) | `token-audit-auditor` agent invoked per heavy section (agent: 87 L) | **~9,100 tokens** (protocol held in context for whole run) |
| `/new-project` | command (351 L, 3,552 W) + `pipeline/pipeline-state.md` reads (small, per-step) | 6 pipeline-stage subagents — each loads inputs in its own context | **~4,618 tokens** (main session stays orchestrator; stage artifacts land on disk) |
| `/repo-dd` | command (301 L, 2,626 W) + small triage-subagent summary read | `repo-dd-auditor` subagent loads `audits/questionnaire.md` (~174 L, ~1,300 W) in its own context | **~3,414 tokens** (subagent delegation keeps questionnaire out of main) |
| `/deploy-workflow` | command (317 L, 1,770 W) only; copying happens via inline bash | none | **~2,301 tokens** |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 3.1 | `/cleanup-worktree` loads 926 lines of skill content (~14,170 tokens) directly into the main session every time it's invoked. The 2026-04-17 session notes explicitly flagged this: "~10%+ of the daily usage limit — primarily three subagent passes at ~220k tokens combined." | HIGH | Split `worktree-cleanup-investigator` into a lean SKILL.md (core decision logic) + on-demand reference loads. Reference files should only load when the investigator hits a specific decision branch (e.g., "read decision-taxonomy.md when classifying non-standard paths"). Alternatively, delegate the whole investigation to a subagent that loads the skill in its own context and returns a summary — mirrors the `/token-audit` and `/repo-dd` patterns. |
| 3.2 | `/token-audit` Step 12 reads the full 632-line protocol into main session memory for the duration of the audit (~7,280 tokens held for 10+ steps). This is the current audit; observable directly. | MEDIUM | Consider per-section protocol reads: main session reads only the boundary table + the currently-executing section's instructions. Subagents already get the protocol path and read it fresh. Re-entering main session reads the next section only. Estimated savings: 50–70% of Step 12 cost. Trade-off: more Read calls, but each is narrower. |
| 3.3 | `/new-project` at 351 lines (~4,618 tokens) is the largest single command file. However, it stays in main session only as an orchestrator — the pipeline stages delegate via subagent, so the main-session floor is bounded. Not a waste mechanism per se, but its size is close to the skill-inversion threshold: at 3,552 words it reads more like a playbook than a command. | LOW | Monitor. If it grows further, consider splitting the post-pipeline enrichment (`additionalDirectories` grant, CLAUDE.md commit-rule insertion, canonical permissions merge) into a separate `/new-project-enrich` command. |
| 3.4 | 20 commands are under 50 lines. Most are thin launchers (`qc-pass.md`, `refinement-pass.md`, `triage.md`, `note.md`, `clarify.md`, `scope.md`, `update-claude-md.md`). Efficient — no issue. | PASS (informational) | No action. |
| 3.5 | `/repo-dd` and `/token-audit` share a delegation pattern (subagent reads protocol + returns summary) that could be extracted as a reusable idiom if a third diagnostic command is built. Not a finding yet — flag for future-pattern review. | LOW (informational) | No action now. Revisit if a third audit-pattern command appears (e.g., `/cost-audit`, `/config-audit`). |
| 3.6 | Command overlap: 8 command names exist in both ai-resources and research-workflow template (`audit-repo`, `friction-log`, `improve`, `note`, `prime`, `qc-pass`, `refinement-pass`, `update-claude-md`, `usage-analysis`, `wrap-session`). Per decision log, workflow-template copies are intentional local forks. Not a waste mechanism for ai-resources sessions (only ai-resources copies load), but drift risk is real. | LOW | Out-of-scope for this audit; tracked via `/wrap-session` drift check per the 2026-04-06 decision. |

**Summary:** `/cleanup-worktree` is the single largest main-session context cost per invocation (~14,170 tokens). Everything else is well-bounded. Main lever: the cleanup-worktree skill-reference loading pattern.

## 4. Workflow Token Efficiency

**Workflows audited:** 4 (ranked by reference frequency and main-session cost) — `research-workflow` (template), `/new-project`, `/cleanup-worktree`, `/repo-dd`. Each was delegated to a fresh-context `token-audit-auditor` subagent; the main session reads only summaries here. Full notes live in `audits/working/audit-working-notes-workflow-*.md`.

### Workflow: research-workflow

**Scope:** 5-stage template (Preparation → Execution → Analysis → Report Production → Final Production) deployed via `/deploy-workflow`. Loaded into the project session when a research project uses it. Not loaded in ai-resources sessions unless the template itself is being inspected (as in this audit).

**Context-loading chain at workflow start (deployed project, main-session per-turn cost):**
- CLAUDE.md chain (workspace + ai-resources + workflow): 345 lines / ~5,396 tokens.
- If `@`-referenced stage-instructions/file-conventions/quality-standards/style-guide auto-load: ~11,017 tokens.
- Per-invocation command overhead: 264–4,307 tokens (largest: `produce-prose-draft.md` at 207 L / 3,313 W).
- 34 skills loaded into main session across the pipeline (largest: `ai-prose-decontamination` 484 L / ~8,342 tokens; 4 skills >300 lines).
- Subagent count per section run: 40+ launches (preparation 6 + execution 7–15 + 3a 12 per 6 clusters + 3b 8+ + synthesis 6 + report 24 for 6 chapters).

**Total findings:** 20 — HIGH: 10, MEDIUM: 7, LOW: 3.

**Top HIGH findings:**

| # | Finding |
|---|---|
| 4W-1 | `run-report.md` Step 4.0 loads 6 file categories (all chapter drafts, scarcity register, all section directives, all refined cluster memos, all research extracts, editorial recommendations) into main session before any delegation — 30+ files for a 6-cluster project. |
| 4W-2 | Workflow's context-isolation rule ("sub-agents receive content, not file paths" — workflow CLAUDE.md line 53) forces every delegated step to read all inputs into main session first. Systemic driver of Stage 3b/4 token cost. |
| 4W-3 | Subworkflow 3.S (gap-supplementary) and 2.S (supplementary research) steps S.0/S.1/S.3/S.4 run inline in main session and each read 3–5 files — violates the "3–4 files → subagent" delegation rule. |
| 4W-4 | `run-report.md` Step 4.2a return includes "chapter draft content" → full prose (~1,000–3,000 tokens) returns to main session per chapter. |
| 4W-5 | No custom `/compact` preservation instructions in workflow CLAUDE.md (operator Option B pre-compact checkpoint principle not mirrored here). |
| 4W-6–10 | Additional HIGH findings in full working notes. |

**MEDIUM / LOW summary:** 7 MEDIUM findings (compaction gaps, refinement multiplier 12–20+ passes per section, large inline reads in run-analysis and run-synthesis). 3 LOW findings (minor pipeline artifacts).

**Verdict:** The research-workflow template has the highest aggregate HIGH count because its context-isolation rule is prescriptive about the wrong variable — forcing file-content (not file-path) into subagents forces the main session to load everything first. The rule was written for a different era (before subagent-reads-from-disk became reliable). A systematic fix to the isolation rule would cascade savings across the entire 5-stage pipeline.

Full working notes: `audits/working/audit-working-notes-workflow-research-workflow.md`.

### Workflow: `/new-project`

**Context loading at workflow start:** ~8,513 tokens (workspace CLAUDE.md 2,811 + ai-resources CLAUDE.md 1,084 + orchestrator 4,618).
**Subagent spawns per run:** 6–8 (pipeline-stage-2, 2-5, 3a, 3b, 3c, 4, 5, and optional session-guide-generator).
**Heavy reads:** all delegated to subagents; no large reads in main session.
**QC / compaction gates:** none defined in orchestrator between stages.

**Findings:**

| # | Finding | Severity |
|---|---------|----------|
| 4N-1 | Orchestrator 351 lines / ~4,618 tokens loaded per invocation. Near 300-line HIGH threshold but stays orchestrator-only. | MEDIUM (boundary) |
| 4N-2 | No `/compact` or `/clear` breakpoints between stages (0 matches in orchestrator). | MEDIUM |
| 4N-3 | Stage 6 (session-guide) re-scans ai-resources that Stage 3a already inventoried — duplicate scan across subagents that could share a state file. | MEDIUM |
| 4N-4 | No subagent output-size cap (returns are 1-line summaries in practice, but not contractually required). | MEDIUM |
| 4N-5 | No QC subagent wired between stages — each stage's output flows to the next without an independent review pass. | MEDIUM |
| 4N-6 | Stage 3a repo scan is unbounded (scales with ai-resources size). As ai-resources grows, this stage's token cost grows linearly. | MEDIUM |
| 4N-7 | Orchestrator reloaded each continuation session when pipeline is resumed mid-run. | LOW |
| 4N-8 | 2 pipeline skills over/near 300 lines (`session-guide-generator` 320, `implementation-spec-writer` 294 boundary). | LOW |

**Verdict:** Structurally healthy pipeline (no HIGH findings). Main levers are adding compaction breakpoints and capping subagent returns.

### Workflow: `/cleanup-worktree`

**Baseline context load (pre-plan, main session):** ~18,065 tokens across 6 mandatory files (1,166 lines / 13,896 words). Plus per-dirty-path reads (~4–8k tokens for 10–14 paths).
**Subagent passes per run:** 3 mandatory (1st QC + triage + 2nd QC); up to 5 permitted before abort. Operator 2026-04-17 telemetry: ~220k tokens across 3 subagent passes (~73k per subagent).

**Findings:**

| # | Finding | Severity |
|---|---------|----------|
| 4C-1 | Each of 3 mandatory subagents receives the full plan file verbatim per isolation contract (execution-protocol §3, command Step 6.15). Plan × 3 repasses = 9–18k tokens of plan-content duplication across the subagent fleet. | HIGH |
| 4C-2 | Main session loads `execution-protocol.md` (310 L) + `decision-taxonomy.md` (230 L) + `SKILL.md` (241 L) = 781 lines / ~11,600 tokens up-front at Step 3 before any path classification begins. **Contradicts SKILL.md's own "read on demand" guidance.** | HIGH |
| 4C-3 | Both QC reports must be captured "Do not summarize it" (Step 6.17, Step 9.25) — full verbatim returns to main session. ~3,800 tokens returned across 3 subagent calls. No write-to-disk pattern. | HIGH |
| 4C-4 | `execution-protocol.md` at 310 lines is at the 300-line HIGH threshold (boundary — ±15%). | HIGH (boundary) |
| 4C-5 | No `/compact` breakpoints in a 45–90 min workflow. | MEDIUM |
| 4C-6 | `SKILL.md` duplicates Bias Counters and Workflow overview already stated in command Step 4.11 / Steps 1–12 (double-loaded). | MEDIUM |
| 4C-7 | `/cleanup-worktree quick` tier (skip 2nd QC when plan has zero hard gates) proposed in 2026-04-17 session notes but not yet implemented. | MEDIUM |
| 4C-8 | Reference files marked "read on demand" but in practice always loaded up-front per Step 3. | LOW |

**Verdict:** 3 HIGH findings concentrated in the main-session pre-load + subagent plan-duplication + verbatim-QC-return pattern. This is the single most expensive workflow in the repo. Directly addressable.

### Workflow: `/repo-dd`

**Start-of-workflow context (ai-resources scope, structural est.):**
- Standard tier: ~19,400–25,500 tokens
- Deep tier: ~46,400–55,500 tokens
- Full tier: deep + marginal per-test cost

**Findings:**

| # | Finding | Severity |
|---|---------|----------|
| 4R-1 | Triple re-read of the completed DD audit report (6,111–8,948 tokens) across Steps 10, 14, and 33 adds 12–18k redundant main-session tokens per run. | HIGH |
| 4R-2 | Deep-tier log reads (Steps 48–51) consume ~20,000+ tokens in main session; `session-notes.md` alone is 9,304 W / ~12,095 tokens. Delegable to a subagent per the protocol's ">3–4-file rule." | HIGH |
| 4R-3 | Step 33 "Read DD_REPORT fully" in deep tier is a delegable triage-extraction task; a subagent could return ~1,500–2,500 tokens instead of the full 6–9k. | HIGH |
| 4R-4 | No `/compact` between standard and deep tiers. | MEDIUM |
| 4R-5 | `audits/questionnaire.md` correctly delegated to subagent — no main-session load. | PASS |
| 4R-6 | `repo-dd-auditor` runs on Opus despite being a factual (not judgment) audit. Sonnet would be sufficient. | MEDIUM |
| 4R-7 | No triage/refinement subagent output-size cap; returns are free-form. | MEDIUM |
| 4R-8 | Full-tier pipeline-testing step re-enters entire audit artifacts; size unbounded. | MEDIUM |
| 4R-9 | Three coexisting DD reports (04-06, 04-11, 04-12) in `audits/` — succession is implicit (dates); previous reports not marked `archived` or moved. Adds to uncovered-directory file count. | LOW |
| 4R-10 | `/repo-review` was split from `/repo-dd` per 2026-04-06 decision to separate facts-only from judgment. Split is holding; no evidence of drift. | LOW (PASS) |

**Verdict:** 3 HIGH findings all in the main-session re-read pattern for the DD artifact. Fix: one-time triage-extraction subagent that reads the report and returns a structured delta + flag list, consumed downstream.

## 5. Session Patterns & Configuration

**Session telemetry available:** No. `session-usage-analyzer` has no historical output (empty `workflows/research-workflow/usage/` directory). All findings in this section are structural inferences from repo configuration, not observed usage.

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model | `opus[1m]` (Claude Opus 4.6, 1M context) — set in user-home `~/.claude/settings.json` | Sonnet for ~80% of tasks; Opus for complex reasoning; Haiku for mechanical subagents | HIGH cost — Opus 4.6 is ~5× the cost of Sonnet and ~15× Haiku per token. Universal Opus default is the single largest per-session cost driver. Current tradeoff: Opus quality is load-bearing for many Axcíon workflows (bright-line-rule discipline, QC independence, skill-writing). Operator should decide whether to introduce per-task model overrides. |
| Subagent model | Inherits user-home default (`opus[1m]`) | Haiku for mechanical subagents (measurement, grep, file-listing); Opus only for judgment subagents (QC, refinement, skill-design review) | HIGH — this audit's 6 subagents all run on Opus by inheritance. Section 2 (skill-census) and Section 6 (file-scan) are mechanical-measurement tasks that Haiku would handle at ~15× less cost. Judgment subagents (workflow-audit Section 4) genuinely need Opus. |
| `effortLevel` | `high` (user-home) | `medium` for routine tasks; `high` only for complex sessions | MEDIUM — high effort triggers more extended thinking. No in-repo guidance switches this per task. Currently high on every session. |
| `MAX_THINKING_TOKENS` | Not set (anywhere searched) | 10,000 for routine; raise only for complex reasoning | MEDIUM — default budget can be tens of thousands per request. No guidance in CLAUDE.md or skills sets this. Combined with `effortLevel: high`, this compounds per-request cost. |
| `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` | Not set | 80% | LOW-MEDIUM — default auto-compact behavior applies. Workspace CLAUDE.md has a pre-compact-checkpoint principle but no auto-compact threshold override. |
| MCP servers active | None configured in user-home `~/.claude/settings.json` | N/A | PASS — no unused MCP servers adding tool-definitions to context. |
| `additionalDirectories` | `["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]` (user-home) | Present per the 2026-04-13 decision to grant workspace visibility | PASS — correct per-project-enrichment pattern; ai-resources sessions inherit global grant. |
| `permissions.allow` (user-home) | Broad: `Bash(*)`, all Claude Code tools, `ToolSearch` | Narrow where possible; scope Bash denies per tool (not just the 3 `git push`/`rm -rf`/`sudo` patterns) | LOW — permissive `Bash(*)` with narrow denies is a safety concern, not a token concern. |
| `permissions.deny` — `Read(...)` entries | NONE (per Section 0.3) | Add `Read(audits/**)`, `Read(logs/**)`, `Read(reports/**)`, `Read(inbox/**)`, `Read(archive/**)` | HIGH — re-stated from Section 0.3 for visibility in Section 7. |

**Hooks active in ai-resources sessions:**

| Hook | Trigger | Token cost per fire | Assessment |
|---|---|---|---|
| `detect-innovation.sh` (user-home + ai-resources) | PostToolUse Write/Edit | Small (shell script; writes to `innovation-registry.md` if match) | Acceptable — mechanical write detection. |
| Pop sound (`afplay`) | Stop, Notification | Zero token cost (audio only) | PASS. |
| Innovation check + wrap-session prompt (ai-resources Stop) | Stop | Small system-message injection | Acceptable — terse reminder, no context bloat. |
| `auto-sync-shared.sh`, `check-template-drift.sh` | Defined under `ai-resources/.claude/hooks/` but NOT registered in ai-resources `.claude/settings.json` — they are invoked by workflow-template project sessions via upward-walk scripts (per workflow settings) | N/A in ai-resources sessions | No token impact for ai-resources scope. |

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 5.1 | Opus 4.6 is the universal default across all sessions AND all subagents. No per-task model override exists in the repo. This is the single largest per-token cost multiplier relative to best-practice April 2026 guidance (Sonnet for ~80% of tasks, Haiku for mechanical subagents). | HIGH | Document a model-selection policy in CLAUDE.md OR add per-agent `model` frontmatter fields. Start with mechanical subagents: `token-audit-auditor` sections 2, 5, 6 (measurement-heavy, low-judgment) → Haiku. `repo-dd-auditor` Section 3 factual audit → Sonnet. Judgment agents (workflow-critique, qc-reviewer, refinement-reviewer, ai-prose-decontamination passes) stay on Opus. |
| 5.2 | `MAX_THINKING_TOKENS` is not set anywhere. Combined with user-home `effortLevel: high`, every session runs with the maximum default extended-thinking budget. For routine diagnostic or orchestration work (e.g., this audit's Sections 3, 5, 7, 8), the thinking budget is wasted. | MEDIUM | Set `MAX_THINKING_TOKENS=10000` in user-home env. For genuinely complex reasoning sessions, override per-session. |
| 5.3 | `effortLevel: high` is the default. No per-task effort-level guidance exists in any skill or command. | MEDIUM | Add `effortLevel: medium` as the baseline in user-home `settings.json`; document in CLAUDE.md that high is reserved for specific complex tasks. |
| 5.4 | `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` not set. Default auto-compact behavior applies. Workspace CLAUDE.md has a pre-compact-checkpoint principle but does not set an explicit threshold. | LOW | Set override to 80% to give earlier warning + more headroom for the pre-compact-checkpoint ritual. |
| 5.5 | No session-usage-analyzer historical data exists despite the skill + `/usage-analysis` command being deployed. Without telemetry, optimization impact is structurally inferred, not observed. | MEDIUM (process) | Run `/usage-analysis` at the end of every substantive session going forward. Start building a baseline. Re-audit token budget in ~10 sessions with real data. |
| 5.6 | No MCP servers configured — PASS. Confirming for visibility. | PASS | No action. |

**Summary:** The model-default lever (Opus 4.6 universal + `effortLevel: high` + no thinking-token cap) is the largest structural cost multiplier in the setup. Fixing the `Read(...)` deny rules (Section 0.3 / 6 / 7) addresses context-load waste; fixing the model/effort/thinking defaults addresses per-request cost directly.

## 6. File Handling Patterns

**`Read(pattern)` deny-rule status (re-used from Step 0.3):** **HIGH**.
- Covered directories: NONE.
- Missing expected coverage: `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/`, `drafts/`, `*deprecated*`, `*old*`.

**Large files detected (top by word count × line count, in uncovered directories):**

| Directory | File count | Total lines | Total words | Notable largest |
|---|---|---|---|---|
| `audits/` | 9 archival files | ~3,730 | ~36,650 | 3 prior DD reports alone: 2,372 L / 17,908 W. Largest single: `repo-due-diligence-2026-04-12.md` (~9,000 W). |
| `logs/` | (several) | 800 L (session-notes.md) | 9,304 W (session-notes.md) + 5,461 W (decisions.md) | `session-notes.md` is the largest single file in the repo. |
| `inbox/` | 3 briefs | — | 4,320 W | — |
| `reports/` | 1 | — | 1,340 W | `repo-health-report.md` (2026-04-06 audit output). |
| `audits/working/` | this audit's in-progress notes | — | ~3,256 W | Self-contributing notes from the current session. |

**Deprecated / draft / tmp markers found:** None. One filename substring match (`produce-prose-draft.md`) is a live command, not a draft artifact.

**Findings:**

| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
| 6.1 | No `Read(...)` deny rules anywhere under AUDIT_ROOT. Claude Code may freely read all archival / log / output content during Glob, Grep, Read, or Edit operations. | HIGH | Add `Read(audits/**)`, `Read(logs/**)`, `Read(reports/**)`, `Read(inbox/**)`, `Read(archive/**)` to `ai-resources/.claude/settings.json` `permissions.deny` array. |
| 6.2 | `audits/` contains 9 archival files totaling ~36,650 words in an uncovered directory. | MEDIUM | Covered by 6.1 fix. Optional: move prior DD reports into `audits/archive/2026-Q1/` subfolder to make the deny rule more ergonomic. |
| 6.3 | `logs/` contains `session-notes.md` (9,304 W — largest single file in repo) and `decisions.md` (5,461 W) in an uncovered directory. | MEDIUM | Covered by 6.1 fix. Separately: consider compacting session-notes.md (800 lines) to keep only the last N sessions in-file; archive older entries. `/prime` only needs the last entry. |
| 6.4 | `inbox/` contains 3 skill request briefs (4,320 W) that have already been consumed (per 2026-04-13 decision on worktree-cleanup-brief). Not covered by deny rule. | MEDIUM | Covered by 6.1 fix. Add a post-consumption convention (flagged in 2026-04-17 plan follow-up #5) — e.g., move consumed briefs to `inbox/consumed/`. |
| 6.5 | `reports/repo-health-report.md` (1,340 W) in an uncovered directory. | MEDIUM | Covered by 6.1 fix. |
| 6.6 | `audits/working/` accumulates in-progress notes (currently contributing ~3,256 W from this audit alone). Directory is reused across runs. Not covered. | MEDIUM | Covered by 6.1 fix. Separately: consider `audits/working/` being cleaned on audit completion, or a `.gitignore` entry. |
| 6.7 | 3 coexisting DD reports (04-06, 04-11, 04-12) succeed each other by date but no explicit deprecation marker. A future session reading `audits/*.md` would pull in all three. | LOW | Either move older versions to `audits/archive/` or add a brief in-file note marking the older versions as superseded. |

**Summary:** The single `Read(...)` deny fix from finding 6.1 addresses 6 of the 7 findings. The uncovered-directory risk is a real context-load cost — a poorly-targeted Grep or Glob during exploratory work can pull in 20,000+ tokens of archival content.

## 7. Missing Safeguards

| # | Safeguard | Status | Severity if missing | Evidence | Recommendation |
|---|-----------|--------|---------------------|----------|----------------|
| 7.1 | `Read(pattern)` deny rules in `.claude/settings.json` covering stale/large directories | **Absent** | HIGH | Section 0.3 verdict: HIGH. Neither `ai-resources/.claude/settings.json` nor the research-workflow template settings contain any `Read(...)` deny entries. | Add `Read(audits/**)`, `Read(logs/**)`, `Read(reports/**)`, `Read(inbox/**)`, `Read(archive/**)` to `ai-resources/.claude/settings.json`. Retrofit to deployed projects via `/deploy-workflow` enrichment. |
| 7.2 | Custom compaction instructions in CLAUDE.md | **Absent** (at ai-resources scope) | MEDIUM | `grep -i "compact" ai-resources/CLAUDE.md` returns nothing. Workspace CLAUDE.md has a "Pre-compact checkpoint" principle but ai-resources does not extend it with scope-specific preservation rules. | Add a 3–5 line Compaction section to ai-resources CLAUDE.md: what to preserve (active skill brief path, pipeline stage, pending QC subagent outputs). |
| 7.3 | Subagent output-to-disk pattern | **Present** | — | Multiple skills implement this correctly: `token-audit-auditor` (two-file notes+summary pattern), `session-usage-analyzer`, `evidence-spec-verifier`, `research-extract-verifier`, `supplementary-research-qc`, `workflow-system-analyzer`. | No action. |
| 7.4 | Context-window monitoring instructions (`/context`, `/cost`, `/effort`) | **Absent** (at ai-resources scope) | MEDIUM | No mentions of `/context`, `/cost`, or `/effort` in ai-resources CLAUDE.md. Workspace CLAUDE.md has pre-compact checkpoint guidance; no explicit monitoring command calls. | Add a one-paragraph reference in ai-resources CLAUDE.md pointing to `/context` for in-session checks and `/usage-analysis` for post-session review. |
| 7.5 | Session boundaries defined for workflows | **Partial** | MEDIUM | Research workflow template defines per-stage gates and `/compact` markers in commands. Ai-resources sessions have `/prime` (start) and `/wrap-session` (end), but no explicit `/clear` guidance between unrelated tasks. | Add to CLAUDE.md: "When switching from one substantive task to another unrelated one in the same terminal, prefer `/clear` over continuing in a dirty context." Consider also a `/restart` convention. |
| 7.6 | Model selection guidance | **Partial** | MEDIUM | CLAUDE.md says "default to Opus 4.6 unless justified" (prescriptive but unidirectional). 3 agents have explicit `model: sonnet` (`pipeline-stage-3a`, `pipeline-stage-5`, `execution-agent`). 5 agents use `model: inherit` (i.e., Opus). 10 agents explicitly pin `model: opus`. No Haiku anywhere. | Publish a model-tier table in CLAUDE.md: Haiku for mechanical-subagent tasks (measurement, scan, format); Sonnet for factual/structured tasks; Opus for judgment. Apply to `token-audit-auditor` (split Haiku sections 2/5/6, Opus section 4), `repo-dd-auditor` (Sonnet), and consider Haiku for `session-guide-generator`. |
| 7.7 | File read scoping ("read lines X–Y" vs. "read entire file") | **Absent** | MEDIUM | No skill instructions prescribe partial reads (offset/limit) or scope the initial read to frontmatter + relevant section only. `session-usage-analyzer` flags "context bloat" in its efficiency framework but doesn't prescribe the fix. | Add to CLAUDE.md or ai-resource-builder: "Read files with explicit offset/limit when you only need a section. Frontmatter + section X is almost always cheaper than the whole file." |
| 7.8 | Output length constraints | **Partial** | LOW | Several skills have specific word/line targets (`ai-prose-decontamination` rhythm rules; `ai-resource-builder` 500-line limit; `session-usage-analyzer` output template). No global output-length policy in CLAUDE.md for non-artifact responses (e.g., conversational replies). | Add to ai-resources CLAUDE.md: baseline conversational-reply target (e.g., "keep end-of-turn summaries to 1–2 sentences unless more is warranted"). Note: workspace CLAUDE.md may already have this. |
| 7.9 | Effort-level guidance | **Absent** | MEDIUM | `effortLevel: high` is set in user-home; no per-task switching rules exist in any skill or command. Every session runs high-effort by default. | Set `effortLevel: medium` as the baseline; document in CLAUDE.md that high is reserved for complex reasoning sessions (gap assessment, architecture synthesis, deep QC). |
| 7.10 | Hook-based output truncation | **Absent** | LOW | No hooks cap tool-output size. Hooks in this repo are all lightweight shell scripts (innovation-detection, sync, drift check, wrap-session prompt). Tool outputs are not post-processed. | Low priority. Consider a `PostToolUse` hook that truncates `Read` output above a threshold only if specific commands surface the need. |
| 7.11 | Audit/output artifact isolation | **Partial** | MEDIUM | Dedicated folders exist (`audits/`, `logs/`, `reports/`, `inbox/`) and are used correctly by the pipelines. BUT none are covered by `Read(...)` deny rules (per 7.1). Prior audit reports (`audits/repo-due-diligence-2026-04-12.md` is 64KB) sit where a future session may accidentally read them during Glob/Grep exploration. | Same action as 7.1 — the deny-rule fix resolves both. |

**Summary of gaps:** 5 Absent (7.1, 7.2, 7.4, 7.7, 7.9), 3 Partial (7.5, 7.6, 7.8, 7.11 — 4 counted), 1 Present (7.3), 1 Low (7.10). The 5 Absent entries are all in "the things we talk about but haven't wired into settings or CLAUDE.md" category — cheap to fix.

## 8. Best Practices Comparison

Rated against the April 2026 best practices defined in the protocol. Status is descriptive; priority is based on estimated token savings + risk (per the protocol's Section 8 note).

| # | Practice | Status | Gap description | Priority |
|---|----------|--------|-----------------|----------|
| 1 | CLAUDE.md under 200 lines | **Implemented** | Root CLAUDE.md is 104 lines. Under the 200 threshold. Still carries ~40 lines of skill-creation-specific content per Section 1 findings. | LOW (in-scope). Full implementation would migrate findings 1.1–1.3 content to skills. |
| 2 | `Read(pattern)` deny rules configured | **Not implemented** | Per Sections 0.3, 6, 7.1 — no `Read(...)` denies exist anywhere. | HIGH — largest quick-win. Blocks accidental loads of 64KB audit reports, large pipeline logs, inbox briefs. |
| 3 | Skills use on-demand loading | **Implemented** | 69 skills with valid trigger-rich descriptions (Section 2.4 non-findings). Activation is trigger-based, not always-loaded. | PASS. |
| 4 | Subagents for heavy reads | **Implemented** | `/repo-dd`, `/token-audit`, `/new-project`, and research-workflow all delegate heavy reads to subagents with the two-file disk pattern (Section 7.3). `/cleanup-worktree` is the exception — loads the whole investigator skill + 2 refs into main. | MEDIUM — the `/cleanup-worktree` fix is finding 3.1. |
| 5 | Strategic `/compact` at breakpoints | **Partial** | Research workflow template uses `▸ /compact` markers at natural boundaries. ai-resources sessions do not — no guidance about when to compact. | MEDIUM — add boundaries for multi-step ai-resources sessions (skill creation pipeline, repo-dd, this audit itself). |
| 6 | `/clear` between unrelated tasks | **Not implemented** | No guidance on `/clear` in CLAUDE.md. Finding 7.5. | MEDIUM. |
| 7 | Model selection per task type | **Partial** | 3 sonnet / 10 opus / 5 inherit (= opus) / 0 haiku at the agent level. User-home universal default = Opus. Finding 7.6. | **HIGH** — per-request cost compounding. Haiku for mechanical subagents is the single biggest unused lever. |
| 8 | Extended thinking budget controlled | **Not implemented** | `MAX_THINKING_TOKENS` unset. Finding 5.2. | MEDIUM. |
| 9 | Unused MCP servers disabled | **Implemented** | No MCP servers configured. | PASS. |
| 10 | Output-to-disk pattern for subagents | **Implemented** | Correct two-file pattern used across the major diagnostic and research skills (Section 7.3). | PASS. |
| 11 | Precise prompts over vague ones | **Partial (structural assessment)** | No explicit guidance in CLAUDE.md about prompt precision. Individual skills are well-scoped. Operator prompts are the unobservable variable — no systemic guidance either way. | LOW — informational. |
| 12 | Session notes pattern | **Implemented** | `/wrap-session` + `logs/session-notes.md` + `/prime` reads the latest entry. Strong pattern. | PASS. |

**Summary:** 5 Implemented, 1 PASS-by-absence (MCP), 4 Partial, 2 Not implemented. The two "Not implemented" items (practices 2 and 8) both have straightforward structural fixes. Practice 7 (model selection) is the highest-priority Partial because of compounding per-request cost.

## 9. Optimization Plan

**Scope note:** At the Option B checkpoint, the operator dropped Tier B (research-workflow structural findings). This plan covers Tiers A (structural safeguards), C (`/cleanup-worktree`), D (`/repo-dd`), E (skill content), F (CLAUDE.md hygiene). Tier B findings remain in Sections 4 and 8 for future reference.

### 9.1 Executive Summary

This audit found that the ai-resources repo is structurally healthy in most respects — strong skill-library discipline (69 skills, uniformly good frontmatter, trigger-rich descriptions), a working subagent output-to-disk pattern across major diagnostic commands, good session-notes + prime/wrap-session ritual, and no unused MCP servers. CLAUDE.md is under the 200-line recommendation.

The token waste concentrates in three patterns. First, **no `Read(pattern)` deny rules exist anywhere**, so every Glob/Grep/Read operation can traverse 36k+ words of archival content (prior DD reports, session logs, consumed inbox briefs). Second, **model defaults are uniformly Opus 4.6 at `effortLevel: high` with no `MAX_THINKING_TOKENS` cap** — the single largest per-request cost multiplier. Third, **two diagnostic commands (`/cleanup-worktree` and `/repo-dd`) violate their own delegation patterns**: `/cleanup-worktree` pre-loads a 781-line skill+refs bundle despite SKILL.md's explicit "read on demand" guidance, triples the plan content across three subagent passes, and receives verbatim QC reports into the main session; `/repo-dd` re-reads the DD audit artifact three times and sweeps `logs/` inline in main session.

Implementing the HIGH-tier recommendations below (9.2) reduces typical-session context-load cost by an estimated 30–50% on a mixed workload, and reduces specific high-cost command invocations (`/cleanup-worktree`, `/repo-dd deep`) by 40–60%. The three quick wins (R1, R2a-partial, R9) can be implemented in under 30 minutes of fix-session time and carry near-zero risk.

### 9.2 Prioritized Recommendations

Ranked by estimated savings tier (HIGH → MEDIUM → LOW). Within each tier, quick wins first.

---

#### HIGH tier

**R1. Add `Read(pattern)` deny rules to `ai-resources/.claude/settings.json`**

| Field | Content |
|---|---|
| **Issue** | No `Read(...)` deny rules exist anywhere under AUDIT_ROOT. |
| **Evidence** | §0.3, §6.1, §7.1. 2 settings files scanned, 0 `Read(...)` entries. `audits/` holds 9 files totaling ~36,650 words; `logs/session-notes.md` is 9,304 W; `inbox/` holds 3 consumed briefs at 4,320 W. |
| **Waste mechanism** | Any Glob, Grep, or exploratory Read during normal work can inadvertently load 10k–30k tokens of archival content into main session. Risk compounds in long sessions. |
| **Estimated savings** | HIGH — affects every session that does any exploration. Conservative estimate: 2–5k tokens per affected turn × ~5 affected turns per session = 10k–25k tokens per session. |
| **Implementation steps** | Edit `ai-resources/.claude/settings.json`. Add under `permissions.deny`: `"Read(audits/**)"`, `"Read(logs/**)"`, `"Read(reports/**)"`, `"Read(inbox/**)"`, `"Read(archive/**)"`. Preserve existing hook block. |
| **Risk** | Low. Workflows that need to read these directories still can — the deny rule only blocks reads via Glob/Grep/Read *tool* discovery, not programmatic writes. But `/prime`, `/wrap-session`, `/repo-dd`, and `/token-audit` all read from these directories, so verify explicitly: these commands read via explicit paths (not Glob), so deny rules should not break them. Test `/prime` immediately after applying. |
| **Dependencies** | None. Independent quick-win. |
| **Category** | **Quick win** (10 minutes). |

**R2. Add per-agent model frontmatter to reduce mechanical-subagent cost (scoped roll-out)**

| Field | Content |
|---|---|
| **Issue** | Universal Opus 4.6 default across all agents including mechanical-measurement subagents. |
| **Evidence** | §5.1, §7.6, §8.7. Current agent fleet: 10 `model: opus`, 5 `model: inherit` (= Opus), 3 `model: sonnet`, 0 Haiku. Opus is ~5× Sonnet and ~15× Haiku per token. |
| **Waste mechanism** | Every subagent invocation pays Opus prices even when the work is mechanical (file measurement, directory scan, grep sweep). This audit itself: 6 subagents each running on Opus. Section 2 (skill census) and Section 6 (file handling) are measurement work Haiku handles well. |
| **Estimated savings** | HIGH — per-request cost multiplier. For a typical ai-resources session with 3–4 mechanical subagent invocations, savings compound: Section-2-style subagent on Haiku costs ~1/15 of Opus; 80k tokens becomes ~5k effective cost. Annualized across all audit/scan work: substantial. |
| **Implementation steps** | Start narrow — do NOT flip judgment agents. Phase 1 (narrow, low risk): (a) `token-audit-auditor` — add section-aware model selection: mechanical sections (2, 5, 6) → `model: haiku`, judgment sections (4) → keep `model: opus`. Implementation: either split into two agent files or use conditional logic in the agent body. (b) `repo-dd-auditor` — change to `model: sonnet` (factual audit, not judgment). Phase 2 (later, after phase 1 validates): consider `session-guide-generator` → Sonnet, `pipeline-stage-5` (validation) → already Sonnet (PASS). Phase 3 (longer-term): document a model-tier table in CLAUDE.md so new agents start with explicit tier. |
| **Risk** | Medium if rushed. Haiku may miss nuance on edge cases even in mechanical work; validate Phase 1 with a repeat of this audit (Haiku sections 2/5/6) vs. the current Opus run. If the Haiku run misses a finding the Opus run caught, revert. Never downgrade judgment agents (qc-reviewer, refinement-reviewer, triage-reviewer, workflow-critique-agent, collaboration-coach, improvement-analyst, pipeline-stage-3b). |
| **Dependencies** | Independent. Recommend Phase 1 only in the first fix session. |
| **Category** | **Structural change** (Phase 1: ~30 min; Phases 2–3: follow-up sessions). |

**R3. Implement `/cleanup-worktree` on-demand reference loading**

| Field | Content |
|---|---|
| **Issue** | `/cleanup-worktree` main session loads SKILL.md (241 L) + decision-taxonomy.md (230 L) + execution-protocol.md (310 L) = 781 L / ~11,600 tokens up-front at Step 3, despite SKILL.md's own "read on demand" guidance. |
| **Evidence** | §3.1, §4C-2. Session notes 2026-04-17 recorded ~10% of daily usage limit consumed by a single `/cleanup-worktree` run. |
| **Waste mechanism** | Main session holds all three files for the entire 45–90 min workflow even when most paths don't hit edge cases that require the taxonomy or execution-protocol deep-dive. |
| **Estimated savings** | HIGH — typical `/cleanup-worktree` invocation reclaims 6k–9k tokens of held-context when only SKILL.md is needed for the happy path. |
| **Implementation steps** | (a) Refactor SKILL.md Step 3 to load only SKILL.md itself; (b) Add conditional-load markers to SKILL.md ("If this path matches pattern X, read decision-taxonomy.md §N"; "If the plan requires hard-gate reasoning, read execution-protocol.md §M"); (c) Update `.claude/commands/cleanup-worktree.md` to remove the upfront bulk-load at Step 3 and follow the conditional-load instructions; (d) Keep references in the directory structure — they just load later/narrower. |
| **Risk** | Medium. Edge-case paths may hit decision branches that need the taxonomy/protocol. If the conditional loading misses, the skill will surface it as a prompt-for-load message. Validate with a test invocation on a clean worktree. |
| **Dependencies** | Pairs with R4, R5 (same workflow). Bundle all three into one `/improve-skill worktree-cleanup-investigator` session. |
| **Category** | **Structural change** (~1 hour, includes SKILL.md edits + command.md edits + test). |

**R4. `/cleanup-worktree` — subagents read plan from disk, not receive verbatim**

| Field | Content |
|---|---|
| **Issue** | Each of 3 mandatory subagents receives the full plan file verbatim per isolation contract. Plan × 3 = 9–18k tokens of duplicate content across the subagent fleet. |
| **Evidence** | §4C-1. `execution-protocol.md §3` + command Step 6.15 prescribe verbatim-plan transfer. |
| **Waste mechanism** | The workspace CLAUDE.md "Input File Handling" rule explicitly says subagents should receive paths, not content, when the content already lives on disk. The skill's isolation contract predates that rule and violates it. |
| **Estimated savings** | HIGH — per-cleanup invocation, 6k–12k tokens saved (subagents read once each instead of main session passing content × 3). |
| **Implementation steps** | (a) Rewrite execution-protocol.md §3 to pass `PLAN_PATH` to each subagent, not plan content; (b) Update each subagent launcher in the command to pass path + instruction to read at that path; (c) Verify each subagent's system prompt expects `PLAN_PATH` input and reads it. |
| **Risk** | Low. Path-passing is the standard pattern elsewhere in the repo (repo-dd-auditor, token-audit-auditor already do this). |
| **Dependencies** | Part of R3 bundle. |
| **Category** | **Structural change** (~30 min). |

**R5. `/cleanup-worktree` — QC subagents write to disk, return summary only**

| Field | Content |
|---|---|
| **Issue** | Both QC reports are captured "Do not summarize it" — full verbatim returns to main session. ~3,800 tokens × 3 subagent calls = ~11,400 tokens returned. |
| **Evidence** | §4C-3. Step 6.17 and Step 9.25 of the command. |
| **Waste mechanism** | The "do not summarize" instruction was to preserve evidence fidelity — but that's what write-to-disk + summary-return achieves. The main session doesn't need the raw report in context; it needs to know what to do next. |
| **Estimated savings** | HIGH — per invocation: ~11k tokens saved on QC return (main session reads the saved report path only if a finding warrants deeper review). |
| **Implementation steps** | (a) Edit command Steps 6.17 and 9.25 to instruct: "Write QC report to `{WORKING_DIR}/cleanup-qc-pass-N.md`; return summary file path + 20-line summary"; (b) Update subagent system prompt to write + return summary. |
| **Risk** | Low. Mirrors the `token-audit-auditor` and `repo-dd-auditor` patterns already validated in this repo. |
| **Dependencies** | Part of R3 bundle. |
| **Category** | **Structural change** (~20 min). |

**R6. `/repo-dd` — one-time DD-report triage-extraction subagent**

| Field | Content |
|---|---|
| **Issue** | Triple re-read of the completed DD audit report (6,111–8,948 tokens) across Steps 10, 14, and 33 — 12–18k redundant main-session tokens per run. |
| **Evidence** | §4R-1. |
| **Waste mechanism** | The DD report is built once, then referenced three times downstream (triage, refinement, deep tier). Each reference re-reads the full file because the main session didn't preserve a structured extraction. |
| **Estimated savings** | HIGH — 12k–18k tokens per `/repo-dd` invocation. |
| **Implementation steps** | After Step 10 (report built), launch a triage-extraction subagent that reads DD_REPORT and writes `{AUDIT_DIR}/working/dd-extract.md` containing: finding list (severity, category, one-line summary), trigger-specific sections needed by Steps 14 and 33. Steps 14 and 33 read `dd-extract.md` instead of DD_REPORT. |
| **Risk** | Low. Fresh-context triage extraction is a well-understood pattern. |
| **Dependencies** | Pairs with R7 (same workflow). |
| **Category** | **Structural change** (~30 min). |

**R7. `/repo-dd` deep tier — delegate log sweep to subagent**

| Field | Content |
|---|---|
| **Issue** | Deep-tier log reads (Steps 48–51) consume ~20k+ tokens in main session; `session-notes.md` alone is ~12k tokens. |
| **Evidence** | §4R-2. |
| **Waste mechanism** | The deep tier reads `logs/session-notes.md`, `logs/decisions.md`, `logs/innovation-registry.md`, and friction logs into main session for judgment — but the judgment is specifically about cross-log patterns, which a subagent can extract. |
| **Estimated savings** | HIGH — 15k–20k tokens per `/repo-dd deep` invocation. |
| **Implementation steps** | Add a deep-tier log-sweep subagent: reads logs, writes `{AUDIT_DIR}/working/log-sweep.md` with structured patterns (recent-decision impact on open findings, recurring friction themes, innovation-triage backlog age); main session reads the sweep only. |
| **Risk** | Low. Similar pattern to R6. |
| **Dependencies** | Independent of R6 but naturally paired. |
| **Category** | **Structural change** (~30 min). |

**R8. Compress the 2 largest skills (`ai-prose-decontamination`, `answer-spec-generator`)**

| Field | Content |
|---|---|
| **Issue** | 8 skills exceed 300 lines; the largest 2 (484 L and 485 L) dominate the HIGH-tier skill list. |
| **Evidence** | §2.1. `ai-prose-decontamination.md` at 484 L / 6,417 W / ~8,342 tokens; `answer-spec-generator.md` at 485 L. |
| **Waste mechanism** | Both skills are invoked in the research-workflow pipeline (per-chapter / per-question). Each invocation loads the full body into the subagent or main session context. |
| **Estimated savings** | HIGH when skill is invoked (8k+ tokens saved per invocation if compressed by ~30%); aggregate depends on invocation frequency. Deferrable if research-workflow is dormant this cycle. |
| **Implementation steps** | Run `/improve-skill ai-prose-decontamination` and `/improve-skill answer-spec-generator` sessions. Targets: (a) move verbose examples to `references/examples.md` (on-demand load); (b) compress prescriptive narrative into checklists/tables; (c) preserve the core detection patterns and output schemas verbatim. Goal: each skill under 300 L. |
| **Risk** | Medium. These are quality-critical skills — the 2026-04-17 session specifically flagged ai-prose-decontamination as having cross-pipeline implications. Compression must preserve behavioral semantics exactly. Validate via a before/after run on a known chapter. |
| **Dependencies** | Independent. Two separate `/improve-skill` sessions. |
| **Category** | **Structural change** (~1 hour per skill). |

---

#### MEDIUM tier

**R9. Set `MAX_THINKING_TOKENS=10000` + `effortLevel: medium` in user-home settings**

| Field | Content |
|---|---|
| **Issue** | Every session runs with `effortLevel: high` and uncapped thinking budget. |
| **Evidence** | §5.2, §5.3, §7.9, §8.8. |
| **Waste mechanism** | Extended thinking on routine diagnostic/orchestration work burns thinking tokens on problems that don't need them. |
| **Estimated savings** | MEDIUM — per-request impact varies; can be 20–40% of total request cost on routine sessions. |
| **Implementation steps** | Edit `~/.claude/settings.json`: set `"effortLevel": "medium"` and add `"env": {"MAX_THINKING_TOKENS": "10000", "DISABLE_AUTOUPDATER": "1"}` (preserving the existing autoupdater setting). Override per-session for complex work. |
| **Risk** | Low. Specific complex tasks (gap assessment, architecture synthesis) may benefit from the current `high` default — document per-task override pattern in CLAUDE.md. |
| **Dependencies** | None. |
| **Category** | **Quick win** (5 minutes). |

**R10. Add Compaction + Session-Boundary guidance to `ai-resources/CLAUDE.md`**

| Field | Content |
|---|---|
| **Issue** | No custom `/compact` preservation rules in ai-resources CLAUDE.md; no explicit `/clear` guidance for session boundaries. |
| **Evidence** | §1.4, §7.2, §7.5, §8.5, §8.6. |
| **Waste mechanism** | Auto-compact preserves default content, which may drop active skill-brief context or pending QC state. `/clear` not enforced at task boundaries means stale context compounds. |
| **Estimated savings** | MEDIUM — prevents specific context-loss events and reduces cross-task compounding. |
| **Implementation steps** | Add ~5-line Compaction section to ai-resources CLAUDE.md: preserve the active inbox brief path, current pipeline stage identifier, any pending subagent output file paths. Add ~2-line Session Boundary section: "When switching between unrelated tasks in the same terminal, prefer `/clear` over continuing in dirty context." |
| **Risk** | Minimal. Additive content. |
| **Dependencies** | None. |
| **Category** | **Quick win** (15 minutes). |

**R11. `/cleanup-worktree` — add `/compact` breakpoints + `quick` tier (skip 2nd QC when plan has zero hard gates)**

| Field | Content |
|---|---|
| **Issue** | No compaction markers in a 45–90 min workflow; 2nd QC pass runs even when plan has zero hard gates. |
| **Evidence** | §4C-5, §4C-7 (operator follow-up flagged in 2026-04-17 session notes). |
| **Waste mechanism** | Long workflow without breakpoints risks auto-compact mid-workflow; 2nd QC on a zero-hard-gate plan is mostly duplicate work. |
| **Estimated savings** | MEDIUM — when quick tier triggers, saves one full subagent pass (~73k tokens per 2026-04-17 telemetry). |
| **Implementation steps** | (a) Add `▸ /compact` markers in command after Step 3 (pre-plan) and after Step 9 (post-triage); (b) Add a branch: "If plan Section 4 hard-gate count is zero, skip 2nd QC (Step 9.X onward)"; (c) Log the skip in session notes. |
| **Risk** | Medium. Skipping 2nd QC reduces assurance; ensure the skip is explicit in the plan and the operator sees "2nd QC skipped per quick-tier rule" before committing. |
| **Dependencies** | Part of R3 bundle (cleanup-worktree improvement session). |
| **Category** | **Structural change** (~20 min). |

**R12. `/repo-dd` — switch `repo-dd-auditor` from Opus to Sonnet**

| Field | Content |
|---|---|
| **Issue** | Factual audit agent runs on Opus. |
| **Evidence** | §4R-6, §7.6. |
| **Waste mechanism** | Opus pricing on structured fact-extraction work Sonnet handles well. |
| **Estimated savings** | MEDIUM — per `/repo-dd` invocation, ~5× Opus→Sonnet savings on the subagent portion. |
| **Implementation steps** | Edit `.claude/agents/repo-dd-auditor.md` frontmatter: change `model: opus` to `model: sonnet`. |
| **Risk** | Low. Mirror of R2 Phase 1. Validate by running one `/repo-dd` on a small project and comparing against prior audit. |
| **Dependencies** | None (independent of R6, R7). |
| **Category** | **Quick win** (5 minutes + validation run). |

**R13. Migrate skill-creation content from `ai-resources/CLAUDE.md` to `ai-resource-builder/SKILL.md`**

| Field | Content |
|---|---|
| **Issue** | ~40 lines of skill-creation-specific instruction (Skill Format Standard, Development Workflow creation/improvement sequences, Cross-References) load every turn but apply only to skill-creation sessions. |
| **Evidence** | §1.1, §1.2, §1.3, §F1. |
| **Waste mechanism** | Per-turn load of ~455 tokens × 30–50 turns × (1 - skill-creation-session-share). |
| **Estimated savings** | MEDIUM per-session when session is not skill-creation (estimated 70% of sessions). |
| **Implementation steps** | (a) Move skill-format conventions, creation sequence, improvement sequence, and research-workflow cross-references pipeline into `ai-resource-builder/SKILL.md` (already governs this domain); (b) Leave a 1-line pointer in CLAUDE.md: "Skill creation and improvement rules: see `ai-resource-builder` skill."; (c) Verify `/create-skill` and `/improve-skill` commands read the relevant SKILL.md. |
| **Risk** | Low. Content is being moved to the canonically-correct location. |
| **Dependencies** | None. |
| **Category** | **Structural change** (~30 min). |

**R14. Run `/usage-analysis` at end of every substantive session going forward to build telemetry baseline**

| Field | Content |
|---|---|
| **Issue** | `session-usage-analyzer` skill exists but no output has ever been produced. Optimization impact remains structurally inferred, not measured. |
| **Evidence** | §5.5, §0.2. |
| **Waste mechanism** | Without telemetry, future audits cannot measure the impact of R1–R13. |
| **Estimated savings** | LOW for the session that runs it; HIGH for future audit confidence. |
| **Implementation steps** | Add to `/wrap-session` command: prompt for `/usage-analysis` as a mandatory closing step (operator can dismiss with one-letter confirmation if session was trivial). Re-audit token budget in ~10 sessions with real data. |
| **Risk** | Minimal. One extra routine step per session. |
| **Dependencies** | None. |
| **Category** | **Quick win** (5 minutes + sustained discipline). |

---

### 9.3 Safeguard Proposals

Concrete prevention mechanisms:

1. **`Read(pattern)` deny rules** — per R1. Once in place, prevents the class of "accidental large-file loads" this audit found. Apply same pattern at workspace root too.

2. **Agent-frontmatter model-tier audit** — after R2 phase 1, add a `/repo-dd` questionnaire item (Q-NEW) that checks: "For each agent definition in `.claude/agents/`, does the model field match the agent's task type per the tier table?" Flag mismatches.

3. **Subagent return-size cap** — add a convention to the token-audit protocol: subagent summaries cap at 30 lines, return only a path to the full notes. Codify as a required Section 4 check in future `/token-audit` runs.

4. **Skill-size gate** — wire a pre-commit hook under `ai-resources/.claude/hooks/` that measures any new/modified SKILL.md and warns if >300 lines. Not blocking, just informational.

5. **Session-boundary convention** — per R10. Document `/clear` as the default between unrelated tasks. Consider a `SessionStart` hook system-message reminder if the prior session ended >2 hours ago.

6. **Skill-creation-content migration convention** — after R13, add a `/repo-dd` item: "Does CLAUDE.md contain task-type-specific instructions that should be in a skill? List candidates." Prevents re-accumulation.

7. **Mandatory `/usage-analysis` at wrap** — per R14. Builds measurement baseline for future audits.

### 9.4 Implications for Future Opus 4.7 Upgrade

- **R2 (model selection) changes shape under Opus 4.7.** If Opus 4.7 pricing shifts relative to Sonnet/Haiku, the tier thresholds move. Re-audit the model-tier table after any pricing change.
- **R8 (skill compression) is not Opus-version-dependent.** Compression remains valuable regardless of model-price curve.
- **R1 (`Read(pattern)` deny) is Opus-version-independent.** Apply regardless.
- **`MAX_THINKING_TOKENS` (R9) may need re-tuning** if Opus 4.7 has different extended-thinking characteristics.
- **R4/R5 (subagent path-passing, write-to-disk-with-summary) compound well with Opus 4.7.** Larger default context windows in newer Opus make verbatim-passing even more wasteful in relative terms.

### 9.5 Assumptions and Gaps

**Assumptions this plan rests on:**
- Word count × 1.3 proxy for token count; real tokenizer drift plausibly ±30% (per protocol caveat).
- `/cost` and `/context` unavailable in this session; baseline measurements are absent. R14 remediates for future runs.
- Session-usage-analyzer has never run; usage patterns inferred from session notes (2026-04-17 cleanup-worktree record is the only concrete number cited).
- Opus pricing relative to Sonnet/Haiku as of April 2026; changes invalidate R2 tier quantification.

**Gaps this audit did not measure:**
- Per-command actual invocation frequency (which commands are used 10×/month vs 1×/quarter) — affects savings annualization. Section 5 structural data insufficient.
- Per-skill actual invocation frequency. Section 2 measured size but not use-rate.
- Research-workflow aggregate savings (Tier B dropped at operator direction; its Section 4 findings remain unclosed).
- Interaction between `effortLevel: medium` (R9) and specific skill output quality — e.g., does `ai-prose-decontamination` on medium-effort still catch surface-voice patterns reliably? Needs a test.
- Whether `Read(pattern)` deny rules break any existing command that reads via Glob. R1 calls out `/prime`, `/wrap-session`, `/repo-dd`, `/token-audit` as test targets — test explicitly.

## 10. Self-Assessment

### 10.1 Audit Token Cost

`/cost` and `/context` were unavailable in this execution environment (slash commands not exposed as agent tools). Precise audit-run cost cannot be measured. Structural estimate based on subagent usage reports from the 6 delegated agents:

| Subagent | Reported total_tokens | Duration |
|---|---|---|
| Section 2 — skill census | 87,510 | 196 s |
| Section 4 — research-workflow | 109,798 | 295 s |
| Section 4 — new-project | 71,170 | 193 s |
| Section 4 — cleanup-worktree | 80,287 | 197 s |
| Section 4 — repo-dd | 63,850 | 180 s |
| Section 6 — file handling | 57,812 | 162 s |
| **Sum of subagents** | **470,427** | |

The main session adds the protocol read (~7,280 tokens), per-section inline work (Sections 0, 1, 3, 5, 7, 8, 9, 10 — primarily file measurement + report composition), and the ~15k–20k tokens of the final report itself. Rough total audit cost: **~500k–550k tokens** across main + subagents. This audit validates its own premise that subagent delegation is essential — a monolithic audit without delegation would have held ~400k+ tokens in a single context.

### 10.2 Protocol Gaps

Items where the protocol was unclear, missing, or required improvisation:

1. **Scope-ambiguity for "workflow"**. Section 4 definition ("referenced in CLAUDE.md, invoked by a slash command, or documented in a workflow/process file") produced 6–7 candidates; protocol then caps at 5. The research-workflow is also a *template* rendered into other projects — its audit is structurally different from audit of an ai-resources-local workflow. Protocol doesn't distinguish template vs local scope. Improvised: audited the template as if it were active, flagged the scope distinction in Section 4 workflow subsection.

2. **Cross-section finding de-duplication**. Same finding appears in multiple sections (e.g., HIGH `Read(...)` deny absence appears in §0.3, §6.1, §7.1). Protocol doesn't instruct on whether to count each as a separate finding or deduplicate. Improvised: cite the primary section in each re-use, treated as one theme in Section 9.

3. **Option-B pause point not formalized**. Operator pause between Sections 1–8 and Section 9 (shortlist confirmation) is a useful checkpoint but not named in the protocol. Protocol has minimum-fallback priority order (Section 9 last) but no natural synthesis pause. Could be formalized as an optional checkpoint in v1.3.

4. **Workspace CLAUDE.md scope-spillover**. When auditing ai-resources, sessions also carry the parent workspace `CLAUDE.md` — but auditing it is out of scope. Protocol doesn't instruct on how to flag workspace-level findings from an ai-resources-scope audit. Improvised: noted as a workspace-scope concern without full-measurement.

5. **Agent-model audit methodology**. Section 5 asks for "subagent model" as a single setting. Reality: individual agents have frontmatter model fields. Protocol doesn't scaffold the fleet-level audit of agent frontmatter. Improvised: grep'd all agent files for `^model:` and categorized.

6. **Section 0.1 `/cost` and `/context` unavailability**. Protocol assumes these may be "unavailable" but doesn't explicitly handle the agent-execution case (not just terminal-absent). Clarifying note in v1.3: slash commands invokable only from interactive sessions, not agent tool calls.

### 10.3 Confidence by Section

| Section | Confidence | Rationale |
|---|---|---|
| 0. Pre-flight | **HIGH** | Direct settings.json parse; binary check on Read() entries. |
| 1. CLAUDE.md | **HIGH** | Direct file read; line/word counts measured. |
| 2. Skill census | **HIGH** | Subagent executed batch measurement + frontmatter checks per protocol. 69 files measured. |
| 3. Command census | **HIGH** | Direct batch measurement. |
| 4. Workflow audit | **MEDIUM** | Structural inference about subagent return sizes and cascading loads; no session telemetry available. Token estimates within ±30% drift caveat. |
| 5. Session patterns | **MEDIUM** | Configuration directly observed; usage telemetry absent (inference flagged). |
| 6. File handling | **HIGH** | Direct measurement of large files; Read(...) deny check binary. |
| 7. Missing safeguards | **HIGH** | Each item grounded in direct repo observation. |
| 8. Best practices | **HIGH** | Ratings cross-reference prior-section findings; no new inference. |
| 9. Optimization plan | **MEDIUM** | Recommendations grounded in HIGH-confidence findings, but estimated savings use the ±30% tokenizer-drift proxy and lack actual telemetry baseline. R14 (start usage-analysis discipline) remediates for v2. |

### 10.4 Threshold-Boundary Findings

Findings within ±15% of a severity-classification threshold (per token-estimation caveat). These are low-confidence and may flip classification under a real tokenizer:

| Finding | Threshold | Actual | Distance |
|---|---|---|---|
| §2 — 7 skills in 150–300 MEDIUM band near 300 | 300 L HIGH boundary | 255–299 L | within ±15% |
| §4C-4 — `execution-protocol.md` | 300 L HIGH boundary | 310 L | +3% (just over) |
| §4N-1 — `new-project.md` orchestrator | 300 L HIGH boundary | 351 L | +17% (clear over) |
| §4N-8 — `session-guide-generator` 320 L; `implementation-spec-writer` 294 L | 300 L HIGH boundary | 320 L (+7%), 294 L (−2%) | both within ±15% |
| §1 — root `CLAUDE.md` size check | 200 L recommendation | 104 L | −48% (clear under) |

**Action for boundary findings:** Re-measure with `tiktoken` or the actual Claude tokenizer in a future audit to resolve classification. Not critical for the recommendation plan — Section 9 recommendations don't hinge on these boundary cases being HIGH vs MEDIUM.
