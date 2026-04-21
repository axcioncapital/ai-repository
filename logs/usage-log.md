# Usage Log

<!-- entries below -->

### 2026-04-21 | Wasteful

**Task:** Created new shared skill `prose-refinement-writer` via /create-skill to address unclear sentence-to-sentence logical shifts and underdeveloped hardest claims in produce-prose-draft output.

| Metric | Value |
|--------|-------|
| Exchanges | 15 |
| Files read | 10 (re-reads: 3) |
| Files written/edited | 7 |
| Tool calls | ~49 |
| Subagents | 7 |
| Rework cycles | 6 |

**Findings:**
- Artifact `prose-refinement-writer/SKILL.md` required 2 rework cycles (cold-evaluator fixes + workspace-QC-auto-loop recovery with regression fix) and plan file required 2 rework cycles (post-QC rewrite + Document-1 fold-in before ExitPlanMode) — 4 cycles across two artifacts (Rework, Major).
- Process compliance slip: skipped the workspace CLAUDE.md QC→Triage auto-loop after cold-evaluator findings, triggering operator challenge and 3 extra subagent spawns (triage + post-edit QC + regression Edit) to recover (Rework, Major).
- Plan file `fix-produse-prose-with-luminous-rain.md` (~85 lines) read 3x; `prose-refinement-writer/SKILL.md` (~267 lines) read 2x; `coaching-data.md` tail read 2x — re-reads on artifacts being actively edited (Re-reads, Moderate).
- Plan file edited multiple times via small Edits, then rewritten wholesale — several pre-rewrite edits were superseded (Tool overhead, Moderate).
- One Bash `find` used where Glob would have been cleaner tool choice (Tool overhead, Minor).
- No prior entries for comparison.

**Recommendation:** Before invoking /create-skill, confirm which QC loop governs the pipeline (workspace CLAUDE.md auto-loop vs. local Step 4a triage) so the correct flow runs the first time — prevents the recovery cascade that added 3 subagent spawns and a regression Edit this session.

**Estimated savings:** ~8–12k tokens per skill-creation session when the workspace QC auto-loop is followed the first time. Derivation: 3 avoided subagent spawns (triage + post-edit qc-reviewer + regression Edit cycle) at ~3–4k tokens each including brief + output = ~9–12k. Over 10–20 skill-creation sessions: ~80–240k tokens avoided, plus the corresponding rework turns.

**Additional levers (ROI-ranked):**
- Outline-first plan drafting before first QC: the plan needed a full rewrite after initial qc-reviewer (REVISE, 1 HIGH + 5 MEDIUM) — ~5–8k tokens saved per session by running a quick self-check against the QC rubric before spawning the external reviewer. Smaller than the primary because it only affects the plan artifact, not the skill artifact.
- Pin the plan file content after first read instead of re-reading 3x (~85 lines × 2 redundant reads ≈ 1–2k tokens) and same for SKILL.md (~267 lines × 1 redundant read ≈ 2–3k tokens) — total ~3–5k/session. Smaller than the primary because re-reads are on small-to-mid files.
- Consolidate small plan-file Edits into one batch after QC rather than iterative single-line Edits that get superseded by the wholesale rewrite — ~1–2k tokens saved per QC cycle. Smallest lever because each wasted Edit is cheap individually.
