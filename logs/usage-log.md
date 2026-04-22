# Usage Log

<!-- entries below -->

### 2026-04-22 | Acceptable

**Task:** Implemented 6 of 7 P0+P1 improvements from the 2026-04-21 setup-improvement-scan across three nested git repos, with one deferral (SC-02, unverifiable baseline) and one mid-execution adaptation (1→3 commits after nested-repo discovery).

| Metric | Value |
|--------|-------|
| Exchanges | 13 |
| Files read | ~21 (re-reads: 0) |
| Files written/edited | 15 |
| Tool calls | ~60 total |
| Subagents | 4 |
| Rework cycles | 1 (partial — caught pre-commit) |

**Findings:**
- Context bloat (Moderate): ~1,660 lines of working-notes + report files read upfront before plan-mode exploration — `setup-scan-bssp-archives-b-2026-04-21.md` (602 lines), plus four other scan/report files (248–280 lines each) all loaded in full. Validate whether full reads were needed or section-targeted reads would have sufficed.
- Rework (Minor, sub-moderate): 1 partial correction to produce-formatting.md Phase 3 subagent brief caught at verification before commit — not a completed-output rework cycle, but the plan's exploration missed the Phase 3 pass-list gap.
- Planning gap (Moderate, classified as Context bloat): Plan assumed single-repo commit scope; nested-repo boundaries (workspace / ai-resources / bssp) not verified during exploration, forcing mid-execution restructure from 1 to 3 commits.
- Trend vs. last 3 entries (Efficient / Acceptable / Wasteful): stable — matches the prior Acceptable entry (multi-phase edit with a structural gap), not a regression toward the Wasteful rework-heavy session.

**Recommendation:** When the task input is a scan/audit report, read the executive summary + prioritized-items section first, then selectively load working-notes only for items the executor will act on — avoid full-read of all working-notes files upfront.

**Estimated savings:** ~1,100 lines × ~12 tokens/line = ~13k tokens avoidable per scan-driven session (assuming ~33% of the 1,660 lines read were genuinely load-bearing for the 7 items acted on). Over a 10–20 session horizon of similar scan-driven implementation work: ~130k–260k tokens.

**Additional levers (ROI-ranked):**
- Verify repo boundaries during Phase 1 exploration (cheap `git rev-parse --show-toplevel` per target directory, ~200 tokens) to prevent commit-phase restructuring. Smaller than primary (single-digit k tokens saved per occurrence) but cheaper to implement — pure process addition.
- Single-Explore-agent consolidation where SC-items share file scope: the 3 parallel Explore agents returned 300–500 lines each (~1.2k–1.5k lines total); if two of the three could have been merged by scope (e.g., commands + CLAUDE.md share the workspace dir), estimated ~4–6k tokens saved. Smaller than primary because parallel Explore is a deliberate speed/coverage tradeoff, not waste.
- Defer SC-02-style items at scan-triage time, not implementation time: the git-history search for the 2026-03-28 baseline was sunk cost by the time deferral was decided. Adding a "verify baseline exists" gate to scan output would prevent ~1–2k tokens of dead-end verification per unverifiable item. Smaller than primary because the scan itself would need the gate logic added.
- No fourth lever — remaining inefficiencies are below the material-waste threshold.

### 2026-04-21 | Efficient

**Task:** Created `/recommend` slash command as operator-facing counterpart to `/clarify`. Single 15-line prompt-only command file, plan-mode-gated with qc-reviewer validation.

| Metric | Value |
|--------|-------|
| Exchanges | 14 |
| Files read | 8 (re-reads: 2) |
| Files written/edited | 4 |
| Tool calls | ~28 |
| Subagents | 1 |
| Rework cycles | 1 |

**Findings:**
- Plan file took 1 QC cycle (PARTIAL verdict → 2 substantive fixes → operator approval without second QC) — within the normal QC→Triage auto-loop envelope, not waste (Rework, Minor/expected).
- Two small-file tail re-reads (session-notes.md ~10 lines 2x, coaching-data.md partial 2x) for append-point verification before Edit — cheap and functional, not material (Re-reads, Minor).
- One failed git commit from workspace root (nested-repo confusion) retried from inside ai-resources — single cheap retry (Tool overhead, Minor).
- Mid-session scope expansion ("hint for when to use /recommend") retracted by operator before execution — zero artifact cost, clean retraction (no category).
- STOP interrupt mid-AskUserQuestion preparation prevented an unneeded 3-option prompt — avoided waste rather than caused it.
- Significant improvement vs. prior two entries (Wasteful 6 cycles / 7 subagents, then Acceptable 2 cycles / 5 subagents) — this session: 1 cycle / 1 subagent, tight scope throughout.

**Recommendation:** No action needed.

**Estimated savings:** N/A

**Additional levers (ROI-ranked):**
- Session shape is the target profile for single-file prompt-only command creation — one qc-reviewer pass on plan, no subagent output duplication to disk, targeted Edits rather than wholesale rewrites. Worth codifying as the reference envelope for `/create-skill`-adjacent command authoring.
- Marginal: the two small-file tail re-reads (~20 lines total) could be collapsed by reading once and pinning the append-point offset, but savings are <500 tokens/session — not worth the discipline overhead.
- Marginal: the failed-commit retry could be avoided by checking `git rev-parse --show-toplevel` before staging when working near nested-repo boundaries — ~300–500 tokens/session on affected sessions only, low frequency.

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

### 2026-04-21 | Acceptable

**Task:** Refactored produce-prose-draft.md Phases 2–5 to pass absolute paths instead of inlining two reference docs into subagent briefs; updated four skill input contracts and added a Context Isolation Rules carve-out. Separately audited settings.json files and fixed a nested-`.claude/**` glob gap firing permission prompts.

| Metric | Value |
|--------|-------|
| Exchanges | 15 |
| Files read | 17 (re-reads: 2) |
| Files written/edited | 12 |
| Tool calls | ~51 |
| Subagents | 5 |
| Rework cycles | 2 |

**Findings:**
- Plan artifact required 1 full rewrite + 2 minor post-edit fixes after REVISE verdict surfaced 1 HIGH governance + 1 HIGH commit-window + 4 MEDIUM issues — spec gaps at plan-authoring time (Rework, Moderate).
- Initial settings fix landed in workspace repo only; operator challenge ("fixed in EVERY project?") forced a second audit pass across all 10 settings.json files and a second commit to ai-resources — scope framed too narrowly on first pass (Rework, Moderate).
- produce-prose-draft.md (208 lines) read 2–3x across Phase 2/3/4/5 checks via partial reads — acceptable for a multi-phase edit but near the threshold (Re-reads, Minor).
- 7 project settings.json files read via batched Bash cat (~400 lines) during audit — broad context load, only 2 files ultimately edited (Context bloat, Minor).
- Permission prompt fired on `.claude/commands/produce-prose-draft.md` edit despite autonomy grant; narrated as if Claude was asking — auto-memory note existed but did not change behavior (Tool overhead, Minor).
- Rating represents improvement vs prior entry (2026-04-21 Wasteful, 6 rework cycles, 7 subagents) — fewer subagents, fewer rework loops, tighter scope.

**Recommendation:** When authoring plans that span multiple artifacts + harness config, run the `qc-reviewer` subagent on the plan draft BEFORE ExitPlanMode — not after operator challenge. Would have caught both the governance/commit-window gaps and the narrow-scope settings framing before any execution cost.

**Estimated savings:** Plan rework cycle (rewrite + 2 post-edit fixes + second QC subagent pass) ≈ 6–8k tokens per avoided rework. At ~1 planning session per working block, projects to ~60–150k tokens over 10–20 sessions.

**Additional levers (ROI-ranked):**
- Pin produce-prose-draft.md once at session start (208 lines × 2–3 reads = ~4–6k redundant tokens). Bigger than the typical re-read lever because this is a central command file touched across 4 phases — any multi-phase edit session will re-encounter it. Projects to ~40–80k over 10–20 sessions.
- Scope harness-config audits to a single subagent brief that enumerates ALL candidate files upfront rather than iterating after operator challenge (~3–5k tokens per audit by avoiding the second round). Smaller than the primary because harness-config audits are less frequent than planning sessions.
- Batch the four skill-contract edits into one Read + one Edit per file pattern (already mostly done this session, but one-file-at-a-time drift cost ~1–2k) — smallest lever, included for completeness since the pattern is reusable across future multi-skill contract updates.
