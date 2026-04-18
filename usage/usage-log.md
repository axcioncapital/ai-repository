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
