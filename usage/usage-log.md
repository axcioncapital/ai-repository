# Usage Log

Token efficiency tracking. Each entry records one session's resource usage and waste patterns.

**Ratings:** Efficient | Acceptable | Wasteful

<!-- entries below -->

### 2026-04-18 | Acceptable

**Task:** Applied R3+R4+R5+R11 audit bundle to worktree-cleanup-investigator skill via /improve-skill pipeline; fixed usage-log pointer in ai-resources CLAUDE.md.

| Metric | Value |
|--------|-------|
| Exchanges | 13 |
| Files read | 15 (re-reads: 0) |
| Files written/edited | 9 |
| Tool calls | ~57 total |
| Subagents | 1 |
| Rework cycles | 1 |

**Findings:**
- Self-caught regressions during Step 5c (3 regressions from Step 2 edits — duplicate ordinal, stale "two independent QC subagents" language at 2 sites) (Rework, Moderate) — fixed in-pass without second QC cycle
- 1 Edit-before-Read tool failure on CLAUDE.md required 1 recovery turn (Tool overhead, Minor)
- Single subagent at 65,605 tokens was largest cost item, but invocation was pipeline-mandated (Context bloat, Minor — unavoidable per contract)

**Recommendation:** Add a pre-Step-5 mini-checklist in ai-resource-builder that enumerates "ordinal uniqueness + terminology consistency across co-edited files" to pre-empt the regression pattern, rather than catching it at Step 5c QC.

**Trend:** Improvement vs. prior three 2026-04-18 entries (Wasteful → Acceptable → Acceptable → Acceptable) — no re-reads this session, rework contained to 1 self-caught cycle, stable at Acceptable.

### 2026-04-18 | Wasteful

**Task:** Prevention Session 1 — three governance-only edits to workspace CLAUDE.md (Model Tier + Agent Tier Table), ai-resources CLAUDE.md (Subagent Contracts + Session Telemetry), and /wrap-session step 12. Post-edit QC caught 2 findings; first wrap commit accidentally swept parallel-session files and required unwind.

| Metric | Value |
|--------|-------|
| Exchanges | 15 |
| Files read | 9 (re-reads: 1) |
| Files written/edited | 7 |
| Tool calls | ~40 |
| Subagents | 1 |
| Rework cycles | 3 |

**Findings:**
- session-notes.md touched 3 times via different tools/ranges (Re-reads, Minor) — pin content or extract needed sections on first read.
- Agent Tier Table published with 19 rows instead of 21; missing agents added only after QC (Rework, Moderate) — enumerate full set via single authoritative grep before drafting, not via prior `ls`.
- Commit-cleanup required unwind because `git add logs/ .claude/` swept parallel-session files (Rework, Major) — stage by explicit file path, never by directory wildcard when concurrent sessions may be active.
- `git reset --soft && git restore --staged && git commit` chain produced "nothing to commit" and had to be retried step-by-step (Rework, Minor) — execute multi-stage git recovery one step at a time.
- ~8 git inspection calls (status, log, show, show --stat) during commit cleanup (Tool overhead, Moderate) — necessary for concurrency diagnosis but indicates the staging approach itself was wrong.
- /wrap-session invoked twice due to mid-wrap concurrency incident (Rework, Moderate) — detect parallel-session file drift before the first wrap commit, not after.

**Recommendation:** Stage commits by explicit file path rather than directory wildcards — the single change that would have prevented the largest rework cycle in this session.

### 2026-04-18 | Acceptable

**Task:** Extended `/new-project` and `/deploy-workflow` canonical blocks and the research-workflow template so every new/deployed project ships with archival Read denies, top-level `"model": "sonnet"`, and Compaction + Session Boundaries sections. Closes R1/R4/R8/R10 audit-recurrence loop for future projects.

| Metric | Value |
|--------|-------|
| Exchanges | 8 |
| Files read | 10 (re-reads: 1 — `logs/decisions.md` read 2x) |
| Files written/edited | 7 |
| Tool calls | ~32 |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- Two QC cycles on the same change set — post-edit QC (auto) + operator-invoked `/qc-pass`, both returned GO. Second QC was redundant in outcome. (Rework, Moderate) — clarify upfront whether operator wants to rely on the auto post-edit QC or substitute a manual `/qc-pass`, not both.
- Full reads of two large command files (`new-project.md` ~350 lines, `deploy-workflow.md` ~317 lines) where the canonical blocks could have been located via Grep first, then partial-read. (Context bloat, Moderate) — Grep-then-partial-Read on large command files before full reads.
- One Edit retry on `new-project.md` due to non-unique `**Procedure:**` match string. (Rework, Minor) — include more surrounding context in `old_string` on first attempt for common markdown headers.
- Rating stable vs. the prior entry (Prevention Session 1 was Wasteful; this session improves on that — QC discipline tighter, no subagent fan-out).

**Recommendation:** On large shared command files, Grep for the target block before full-reading — partial reads keyed to Grep line numbers would have avoided ~600 lines of unused context this session.

### 2026-04-18 | Acceptable

**Task:** Prevention Session 3 — added 3 audit-recurrence-detection items to /repo-dd questionnaire, created standalone check-skill-size.sh informational pre-commit hook, and broadened ai-resources/.claude/settings.json permissions allowlist after operator caught /fewer-permission-prompts under-delivering.

| Metric | Value |
|--------|-------|
| Exchanges | 13 |
| Files read | 13 (re-reads: 4 — session-notes 2x, innovation-registry 3x, decisions 2x, settings.json 2x, pre-commit 2x) |
| Files written/edited | 8 |
| Tool calls | ~51 total |
| Subagents | 2 |
| Rework cycles | 3 |

**Findings:**
- File innovation-registry.md read 3 times — pin content or extract needed sections on first read; one re-read was forced by an auto-detect hook racing the edit, but the third read was avoidable (Re-reads, Moderate)
- Three rework cycles across distinct artifacts — /fewer-permission-prompts under-delivery required operator catch + recovery; clarify spec upfront or use outline-first approach for permission-scan output (Rework, Moderate)
- Several files read 2x (session-notes, decisions, settings.json, pre-commit) — pin content on first read where edits are anticipated (Re-reads, Minor)
- Trend vs prior 3 entries: stable — Acceptable matches Prevention Session 2 (Acceptable) and improves over Prevention Session 1 (Wasteful).

**Recommendation:** Pin content of logs/innovation-registry.md and other multi-edit-target files on first read to eliminate avoidable re-reads when the auto-detect hook fires between edits.


### 2026-04-18 | Acceptable

**Task:** Cleanup session executing 4 next-steps from Prevention Session 3 wrap — push (no-op, no remote), inbox triage (1 archived, 2 deferred), retrofit archival denies into 4 project settings.json files, and fix `/new-project` step 4 heredoc minor. Independent QC returned GO.

| Metric | Value |
|--------|-------|
| Exchanges | 14 |
| Files read | 11 (re-reads: 1 — new-project.md read 2x for variable hunt) |
| Files written/edited | 10 |
| Tool calls | ~34 |
| Subagents | 2 |
| Rework cycles | 0 |

**Findings:**
- new-project.md read twice — once for the step 4 edit, again for variable-convention hunt after Grep on `{name}` (Re-reads, Minor) — pin content or extract needed sections on first read; batch the Grep + targeted Read in the same turn.
- One Bash diagnostic re-attempt on git remote/origin queries before discovering workspace repo has no remote configured (Tool overhead, Minor) — check `git remote -v` once upfront before chaining remote-dependent commands.
- Sequential per-repo commit loop for 4 retrofit commits — necessary (each repo is its own git context, cannot parallelize commits) (Missed parallelization, Minor — informational only).
- Trend vs prior 3 entries: stable-to-improving — Acceptable matches the prior two Acceptable entries and improves over Prevention Session 1 (Wasteful); zero rework cycles this session is the strongest signal.

**Recommendation:** Batch Grep + targeted Read into a single turn when hunting for a convention or variable across a known file — eliminates the re-read pattern that has now appeared in 4 of the last 4 entries.


### 2026-04-18 | Acceptable

**Task:** Post-prevention cleanup 2 — executed items 1–6 from prior wrap's next-steps (innovation-registry triage, improvement-log status sync, inbox/archive docs, workspace concurrent-session rule, nordic settings.json normalization, friction-log init) and deferred repo-review brief after discovering overlap with `/audit-repo`.

| Metric | Value |
|--------|-------|
| Exchanges | ~15 |
| Files read | ~16 (re-reads: 0) |
| Files written/edited | 9 |
| Tool calls | ~45 |
| Subagents | 2 |
| Rework cycles | 0 |

**Findings:**
- ~3 Bash diagnostic calls spent chasing a false-positive "loose ends" signal caused by a stale Prime git-status snapshot (Tool overhead, Minor) — check `git log` against the Prime snapshot once upfront before treating flagged files as uncommitted work.
- Prime Step 2 innovation-registry grep used wrong pattern for markdown-table format, undercounting 5 detected items as 0 (Tool overhead, Minor) — captured to friction-log for future `/improve`; informational only.
- Six sequential Edits on improvement-log.md for status-line flips where each anchor's surrounding context differed (Missed parallelization, Minor — informational only) — sequential was correct here given non-uniform anchors.
- Trend vs. prior 3 entries: stable-to-improving — Acceptable matches the prior 2 Acceptable entries and improves over Prevention Session 1 (Wasteful); zero rework cycles and zero re-reads this session are the strongest signals, with the re-read pattern flagged in 4-of-4 prior entries now broken.

**Recommendation:** Reconcile Prime's git-status snapshot against `git log` once at session start before treating flagged files as loose ends — would have saved the ~3 diagnostic Bash calls this session.


### 2026-04-18 | Wasteful

**Task:** Agent model tier retrofit (Option B — 4 safe candidates of 5 acted on, pipeline-stage-4 deferred) + R13 closeout (move 8-line research-workflow skill chain from ai-resources/CLAUDE.md to workflows/research-workflow/CLAUDE.md). Three commits landed; two pushed to origin.

| Metric | Value |
|--------|-------|
| Exchanges | ~22 |
| Files read | ~14 (re-reads: 7 — session-notes.md 3×, CLAUDE.md workspace 2×, ai-resources/CLAUDE.md 2×, decisions.md 2×) |
| Files written/edited | 9 |
| Tool calls | ~34 total (Read ~9, Edit ~9, Bash ~10, Grep ~6) |
| Subagents | 2 |
| Rework cycles | 2 |

**Findings:**
- session-notes.md read 3× across the session — forced by intervening linter/auto-process modifications between Read and Edit (Re-reads, Major) — use `stat` on the file immediately before Edit to detect modification; if mtime has changed, re-read only the affected anchor region, not the full file.
- Two Edit retries due to "file modified since read" errors on CLAUDE.md workspace and session-notes.md (Rework, Moderate) — run `stat` before Edit on files known to be touched by hooks; would have eliminated both forced re-reads and their associated retries.
- Cross-repo commit sequencing error — ai-resources files staged but committed in wrong order; required a second git commit pass to capture missed files (Rework, Moderate) — commit the child repo (ai-resources) first, then the parent; sequence matters when staging spans repos in a single turn.
- Trend vs. prior 3 entries: regression — prior 3 entries were all Acceptable; this session drops to Wasteful, driven by the Major re-read finding on session-notes.md (linter-race pattern) and the two rework cycles.

**Recommendation:** Run `stat` on session-notes.md and any hook-adjacent file immediately before Edit — detects linter/auto-process modification and eliminates the forced re-read + retry cycle that drove this session's Major finding.

### 2026-04-18 | Acceptable

**Task:** Tier 3 token-audit hardening — created PreToolUse `[HEAVY]` warning hook with exempt-command bypass and replaced inline Stop hook with a script that adds usage-log telemetry-freshness check; QC-driven scope cuts dropped pipeline-stage-4 retrofit and switched Fix 2 from UserPromptSubmit to Stop-hook augmentation.

| Metric | Value |
|--------|-------|
| Exchanges | 8 |
| Files read | 14 (re-reads: 2 — session-notes.md 2× at different offsets, innovation-registry.md 2× cat-then-Read) |
| Files written/edited | 10 |
| Tool calls | ~38 total (Read ~12, Bash ~10, Edit ~8, Write ~3, Agent ~2, ToolSearch ~3) |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- Plan v1 → QC REVISE → plan v2 cycle prescribed 6 specific fixes including 2 scope cuts and 4 trigger-tightenings (Rework, Moderate) — clarify spec upfront or use outline-first approach; the QC cycle was high-value here (caught Fix 3 scope miss + Fix 2 hook-event mismatch), not avoidable waste.
- Two Edit-before-Read harness misses — session-notes.md required re-Read after offset slice; innovation-registry.md required Read-tool after prior cat-via-Bash (Tool overhead, Minor) — when an edit on a large append log is anticipated, use the Read tool (not Bash cat) on first pass to satisfy the Read-before-Edit harness rule.
- session-notes.md and innovation-registry.md each accessed 2× (Re-reads, Minor) — both forced by harness discipline rather than information gaps; pin first-read content when subsequent edits are likely.
- Trend vs. prior 3 entries: improvement — prior entry was Wasteful (linter-race re-reads); this session returns to Acceptable matching the two before that, with re-reads dropped from 7 to 2 and rework cycles dropped from 2 to 1.

**Recommendation:** When a session anticipates editing a large append-only log file (session-notes.md, innovation-registry.md, improvement-log.md), do the first read via the Read tool with a targeted offset rather than Bash cat — eliminates the Read-before-Edit harness retry that drove both Tool-overhead findings this session.


### 2026-04-18 | Acceptable

**Task:** Audited `/improve-skill` command and ai-resource-builder SKILL.md against workspace canonical rules; applied 4 fixes to improve-skill.md and added `model: opus` frontmatter to sibling create-skill and migrate-skill commands.

| Metric | Value |
|--------|-------|
| Exchanges | 8 |
| Files read | 11 (re-reads: 1 — session-notes.md read 2x) |
| Files written/edited | 8 |
| Tool calls | ~26 total |
| Subagents | 2 |
| Rework cycles | 1 |

**Findings:**
- Edit-before-Read harness miss on 2 files (create-skill.md, innovation-registry.md) forced a satisfying 3-line Read before re-attempting the Edit — same pattern flagged in the prior usage entry (Tool overhead, Moderate).
- Explore subagent returned a report exceeding its word-limit budget; content usable but the overrun represents subagent-contract drift (Context bloat, Minor).
- Directed rework on frontmatter tier (sonnet → opus) after operator pushback; 1 cycle, single-line Edit (Rework, Minor).
- Rating stability: matches the acceptable cadence of the last 3 entries (2 Acceptable, 1 Wasteful); no regression.

**Recommendation:** Address the recurring Edit-before-Read miss by treating Bash `head`/`cat` as insufficient to satisfy the Read-before-Edit contract — run a proper `Read` on any file before the first `Edit`, even when the head preview seems sufficient.


### 2026-04-18 | Acceptable

**Task:** Trimmed three oversized SKILL.md files (ai-prose-decontamination 484→314, ai-resource-builder 463→401, prose-compliance-qc 330→210) via pure-relocation refactor — moved teaching examples and templates to sibling references/ files; each refactored skill passed independent qc-reviewer.

| Metric | Value |
|--------|-------|
| Exchanges | ~14 |
| Files read | ~10 (re-reads: 2 — operational-frontmatter.md 2× at different offsets, innovation-registry.md 2× via Read + Bash tail) |
| Files written/edited | ~22 (7 new reference files, 3 SKILL.md edits, 1 reference edit, 4 log appends, 1 plan rewrite) |
| Tool calls | ~54 total (Read ~10, Edit ~14, Write ~10, Bash ~10, Agent ~5, Grep ~3, ToolSearch ~2) |
| Subagents | 6 |
| Rework cycles | 2 |

**Findings:**
- Six subagents spawned across the session (1 Explore, 1 plan-QC, 1 triage, 3 post-edit QC) — each gate-purposed and required by QC discipline; no waste, but crosses the `[COST]` threshold of ≥4 subagents and warrants a checkpoint flag mid-session (Tool overhead, Minor — informational).
- Plan v1 → plan v2 rework after qc-reviewer REVISE verdict with 4 findings; resolved by adopting pure-relocation framing (Rework, Moderate) — the QC cycle was high-value (caught semantic-edit drift before fix application), not avoidable waste; outline the relocation-vs-rewrite framing upfront in the plan to skip the cycle.
- Skill 2 reference file required a single-line revert after post-edit QC flagged an introduced framing sentence as deviation from verbatim relocation (Rework, Minor) — when the spec is "verbatim relocation," do not add transitional framing in the destination file; lift bytes only.
- innovation-registry.md accessed 2× (Read tool then Bash tail) and operational-frontmatter.md accessed 2× at different offsets — the registry pattern repeats from the prior 2 entries (Re-reads, Minor) — pin first-read content when subsequent edits or re-inspections are likely on append-only logs.
- One Bash sed attempt on innovation-registry.md failed (Edit-tool "file not read yet" error → sed quoting issue → recovered via Read + Edit) (Tool overhead, Minor) — same Edit-before-Read harness pattern flagged in the prior 3 entries; satisfy the harness contract via the Read tool rather than chasing it with Bash.
- Trend vs. prior 3 entries: stable — Acceptable matches the prior 2 Acceptable entries and the broader cadence; subagent count (6) is the highest in the trailing window but each was gate-purposed for QC discipline, not waste.

**Recommendation:** When a session anticipates ≥3 post-edit QC subagents (one per artifact), batch the artifact-level QC findings into a single triage pass at the end rather than triaging per-artifact — same QC coverage, ~1 fewer subagent in the session ledger and a single decision point for the operator.
