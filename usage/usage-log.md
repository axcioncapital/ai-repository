# Usage Log

Token efficiency tracking. Each entry records one session's resource usage and waste patterns.

**Ratings:** Efficient | Acceptable | Wasteful

<!-- entries below -->

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
