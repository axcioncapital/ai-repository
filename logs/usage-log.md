# Usage Log

<!-- entries below -->

### 2026-04-25 | Acceptable

**Task:** Designed and landed five preventative fixes (F1-F5) for working-tree drift and concurrent-session damage, including plan-mode design with 2 parallel Explore agents and 2 /risk-check gates that redirected F2 design and dropped G5.

| Metric | Value |
|--------|-------|
| Exchanges | ~16 |
| Files read | 13 (re-reads: 2) |
| Files written/edited | 10 |
| Tool calls | ~57 |
| Subagents | 5 |
| Rework cycles | 1 (F2 design pivot, pre-implementation) |

**Findings:**
- permission-template.md read in 3 partial passes (offsets 1, 100, 183) covering full 285-line file — single full read would have saved 2 round-trips (Re-reads / context handling, Moderate)
- permission-sweep-auditor.md edited 3 separate times for "13"→"14" substitutions — could have collapsed to 1-2 edits using replace_all or unique substring matching (Tool overhead, Minor)
- coaching-data.md tail re-read once at near-identical offsets (Re-reads, Minor — immaterial)
- F2 design pivot via /risk-check RECONSIDER reflects the gate working as intended, not artifact rework — no implementation tokens lost
- Stable vs. last 3 entries (all Acceptable): same rating, similar moderate-finding profile around partial-read patterns and small Edit-batching inefficiencies.

**Recommendation:** When a reference file is <300 lines and the task requires scanning most of it, default to one full Read rather than chained partial offsets — partial-read pattern only pays off above ~400 lines or when a single section is clearly load-bearing.

**Estimated savings:** Per-session ~1.5-2k tokens (2 redundant partial-read round-trips on permission-template.md ≈ ~1.2k tokens of duplicated structural overhead + 1 collapsible Edit cycle ≈ ~300-500 tokens). 10-20 session projection: ~15-40k tokens, assuming the partial-read pattern recurs in ~half of multi-file plan-mode sessions.

**Additional levers (ROI-ranked):**
- Batch consecutive same-file Edits when the substitution is a simple find/replace — replace_all=true on the unique pattern saves ~600-1000 tokens per occurrence vs. 3 sequential Edits; bigger than primary on edit-heavy sessions.
- Cap risk-check + qc-reviewer reports at summary-only re-reads in main session — already doing this for F3+G5; codify as default. ~400-800 tokens per subagent report avoided; smaller than primary because the discipline is already mostly observed.
- Skip TodoWrite reminders mid-execution on linear 5-step plans where progression is self-evident — ~200-400 tokens per session in tool overhead and re-narration; smaller than primary, mostly orchestration noise.
- Consolidate workspace + ai-resources commit narration into single chat summary when both repos take coordinated commits in same flow — ~200-300 tokens per multi-repo session; smallest lever.

### 2026-04-24 | Acceptable

**Task:** Executed Batch 1 of Commission v4 — built `/risk-check` command + `risk-check-reviewer` Opus subagent as a pre-execution gate, added class list + pause-trigger #9 across `docs/audit-discipline.md` and workspace CLAUDE.md. One QC → triage → fix → post-edit QC cycle; committed to two repos.

| Metric | Value |
|--------|-------|
| Exchanges | ~20 |
| Files read | ~18 (re-reads: 4 on session-notes.md, 3 on innovation-registry.md, 2 on decisions.md/coaching-data.md/improvement-log.md + settings.json across locations) |
| Files written/edited | 9 (2 new commands/agents, 1 subagent-authored audit, 6 edits) |
| Tool calls | ~50 |
| Subagents | 4 |
| Rework cycles | 1 (risk-check.md structural rewrite post-QC) |

**Findings:**
- risk-check.md rewritten via full Write (~122 lines) after QC REVISE when the 3 Do items were structural (path ordering, new subsections, item renumbering) — justified choice but pays full payload twice (initial + rewrite). (Rework, Moderate)
- risk-check-reviewer.md agent body (~215 lines / ~5k tokens) inlined into a `general-purpose` subagent prompt because new agents don't hot-register mid-session — significant one-off prompt duplication unique to creation-session dogfooding. (Tool overhead, Moderate)
- session-notes.md read 4x due to concurrent-session edits invalidating the file between Edit attempts — externally caused, but the re-reads still consume budget. (Re-reads, Moderate)
- innovation-registry.md touched 3x via separate bash grep + head + grep calls when a single Read would have sufficed for an ~80-line ledger — same tail-before-read anti-pattern noted in the prior entry. (Tool overhead, Minor)
- Stable relative to last 3 entries (Acceptable / Acceptable / Acceptable) — no regression, and the rework-via-full-Write pattern persists for the third session running, indicating a durable sub-pattern worth addressing structurally.

**Recommendation:** For creation-session dogfooding of new agents, skip the mid-session inline-body workaround — either run the new agent at the top of the next session (free registration, zero inlined-prompt tokens) or invoke it via a minimal stub brief that references the agent file path rather than pasting its full body. The ~5k-token prompt-duplication cost is the largest single avoidable item in this session.

**Estimated savings:** ~5k tokens per creation-session-with-dogfood by deferring the first real invocation to the next session (one ~215-line agent body × ~23 tokens/line ≈ 5k tokens saved). Over 10–20 agent-creation sessions: ~50–100k tokens, assuming half of new agents get dogfooded same-session today.

**Additional levers (ROI-ranked):**
- Avoid the double-Write-on-QC-rework pattern by writing risk-check.md initial draft to ~90% completeness with QC-anticipated structure already in place, then using targeted Edits for Do items — saves ~122 lines × ~20 tokens/line ≈ 2.5k tokens per rework cycle. Smaller than primary because rework is conditional on QC REVISE; primary is deterministic per creation session.
- Collapse innovation-registry / decisions / coaching-data / improvement-log wrap-step reads into a single orchestrated read pass rather than 4 separate tail/grep/read sequences — ~1–2k tokens per wrap across those ledger files. Smaller than primary because each individual file is small, but recurs every session.
- When concurrent-session activity is disclosed at session start, write session-notes.md entries as append-only EOF edits from the outset rather than attempting chronological insertion — avoids the 2–3 extra Reads caused by concurrent-edit races. ~1k tokens per affected session; smaller than primary because it only applies when a concurrent session is active.

### 2026-04-24 | Acceptable

**Task:** Planning-only session — iterated a 5-batch implementation plan for weekly Friday repo maintenance cadence through /clarify → /recommend → /qc-pass → /triage → post-edit /qc-pass. Plan file lives outside the repo; no code changes committed.

| Metric | Value |
|--------|-------|
| Exchanges | ~15 |
| Files read | 8 (re-reads: 1) |
| Files written/edited | 5 |
| Tool calls | ~44 |
| Subagents | 5 |
| Rework cycles | 2 |

**Findings:**
- Plan file rewritten via full Write twice (~300 lines each) when the second rewrite could have been done via surgical Edits — batch renumbering from merging Batches 2+3 drove the choice, but a full rewrite re-pays the entire file payload on the second write. (Rework, Moderate)
- innovation-registry.md read twice (Bash tail ~15 lines, then full Read of all 78 lines) after an Edit attempt required fresh content — classic tail-before-read anti-pattern where the tail output was discarded. (Re-reads, Minor)
- Five subagents spawned for a single planning artifact (2 Explore + 3 QC/triage) — protocol-compliant under the QC → Triage Auto-Loop, but the two Explore passes could arguably have been merged into one brief covering both Friday cadence and audit-command substrate. (Tool overhead, Moderate)
- ExitPlanMode rejected once because handoff notes were missing — one wasted plan-mode cycle that a self-check against the /recommend checklist would have caught before the first submission. (Rework, Minor)
- Stable relative to last 3 entries (Acceptable / Acceptable / Efficient) — same moderate-rework pattern as 2026-04-22, no regression.

**Recommendation:** When a plan file needs >2 non-adjacent changes including renumbering, prefer a single full rewrite via Write over mixing Write+Edit; when changes are <5 and localized, stay on Edit. The middle ground — first full rewrite then another batch of Edits on the same artifact — is the waste shape to avoid.

**Estimated savings:** ~2–3k tokens per planning session by avoiding the second full-rewrite Write (the v2→v3 inline edits could have stayed pure Edit). ~20–60k tokens over 10–20 plan-heavy sessions.

**Additional levers (ROI-ranked):**
- Merge the two Explore subagents into one combined brief covering cadence + audit-substrate discovery — subagent briefs and returned findings (~1300 words combined) would drop to a single ~800-word synthesis. ~3–5k tokens per multi-domain planning session; bigger than primary because subagent invocation overhead dominates full-rewrite cost.
- Read innovation-registry.md (and similarly sized ledger files ≤100 lines) once in full rather than tail-then-Read — Bash tail for files under ~200 lines is almost never worth it. ~500–1k tokens per affected session; smaller than primary because ledger files are small.
- Add a self-check gate before ExitPlanMode that verifies handoff notes, concurrent-session disclosure, and approval-readiness — prevents one-turn rejection cycles. ~300–800 tokens per avoided rejection; smaller than primary but reduces interactional friction.

### 2026-04-24 | Acceptable

**Task:** Ran /friday-checkup monthly-tier audit scoped to ai-resources (narrowed from 4 scopes). Executed /audit-repo, /improve, /coach, /token-audit in sequence; produced consolidated checkup report plus 11-section token-audit report.

| Metric | Value |
|--------|-------|
| Exchanges | ~15 |
| Files read | 16 (re-reads: 0) |
| Files written/edited | 8 |
| Tool calls | ~60 |
| Subagents | 6 |
| Rework cycles | 0 |

**Findings:**
- /coach subagent returned ~100 lines of full analysis to main session while a compact ~15-line entry was also written to `logs/coaching-log.md` — the full return adds ~4–8k tokens to main-session context for the remainder of the session, duplicating content already archived to disk. (Context bloat, Moderate)
- /token-audit report built via 1 Write + ~9 sequential Edit calls; protocol-driven design (incremental appends for interruption safety), but each Edit re-pays the file-write tool overhead. (Tool overhead, Minor)
- `audits/token-audit-protocol.md` read in full at 633 lines (~8.2k tokens) — single read, protocol-mandated as session-resident, so not avoidable under current design but dominates read-side cost. (Context bloat, Minor)
- Sections 2 and 6 of /token-audit correctly launched in parallel; Section 4 ran sequentially after. No dependency was documented between Section 4 and the others. (Missed parallelization, Minor)
- Stable relative to last 3 entries (Acceptable / Efficient / Wasteful / Acceptable) — no regression; same moderate-bloat pattern as 2026-04-22.

**Recommendation:** Update /coach skill so the coaching subagent writes its full analysis to disk (e.g., `logs/coaching-analysis-{date}.md`) and returns only the ~15-line compact entry to the main session, mirroring the token-audit subagent output-to-disk contract.

**Estimated savings:** ~4–8k tokens per /coach invocation (the ~100-line full return no longer lands in main context). Derivation: ~100 lines × ~60 tokens/line ≈ 6k tokens eliminated from downstream turns in the same session. Over a 10–20 session horizon with /coach running in each Friday checkup plus ad-hoc use (~8–15 invocations), projected savings ~50–120k tokens.

**Additional levers (ROI-ranked):**
- Launch /token-audit Section 4 in parallel with Sections 2 and 6 (all three are independent mechanical/research audits) — saves one sequential subagent round-trip, ~2–5k tokens of orchestration overhead per /token-audit run.
- Batch the /token-audit report construction: reduce the 1 Write + ~9 Edit pattern to 1 Write + 2–3 Edits by grouping sections written together (e.g., Sections 1–3 as one Edit, 4–7 as another). Saves ~6–9 tool-call round-trips per audit; minor per-session but compounds monthly.
- Consider whether `audits/token-audit-protocol.md` (633 lines) can be split into a short "session-resident" core (~150 lines of rules actually needed in-context) plus a reference appendix loaded only when a specific section needs it. Largest single read of the session; ~5–6k tokens recoverable per /token-audit run if split.

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

### 2026-04-25 | Acceptable

**Task:** Adopted two-gate trigger model for `/risk-check` (plan-time + end-time) replacing per-change firing — edited workspace `CLAUDE.md` pause-trigger #9 (×2, expand then trim), `audits/audit-discipline.md`, `risk-check.md`, `wrap-session.md`; ran self-applied `/risk-check` returning PROCEED-WITH-CAUTION with two paired mitigations applied.

| Metric | Value |
|--------|-------|
| Exchanges | 11 |
| Files read | 13 (re-reads: 0 for same content; 4 ledger files touched via head + tail-via-bash dual-call pattern) |
| Files written/edited | 9 |
| Tool calls | ~32 |
| Subagents | 1 |
| Rework cycles | 1 |

**Findings:**
- Workspace `CLAUDE.md` pause-trigger #9 written first as a ~10-line expansion, then trimmed to ~95 words after end-time `/risk-check` flagged the always-loaded surcharge — full payload paid twice on the same load-bearing section. (Rework, Moderate)
- Four ledger files (`session-notes.md`, `decisions.md`, `coaching-data.md`, `innovation-registry.md`) each touched via separate `Read` head + `Bash` tail sequences when a single full Read of files ≤100 lines would have sufficed — same tail-before-read anti-pattern flagged in 2026-04-24 entry, third session running. (Tool overhead, Moderate)
- Concurrent-session collision swept the `wrap-session.md` Step 13b edit into the other session's commit — externally caused, no extra reads triggered this session, but the staging-discipline check before the edit could have detected the active concurrent context earlier. (Tool overhead, Minor)
- Stable relative to last 3 entries (Acceptable / Acceptable / Acceptable) — no regression; the ledger-file tail-before-read pattern persists for the third session, reinforcing it as a structural sub-pattern.

**Recommendation:** When wrap-step touches the standard ledger set (session-notes, decisions, coaching-data, innovation-registry, improvement-log), do a single Read pass per file at append-point — no Bash tail precursor — for any ledger ≤200 lines. The tail call is almost never load-bearing for files this size and doubles the per-ledger tool overhead.

**Estimated savings:** ~1–2k tokens per wrap session (4 ledger files × ~300–500 tokens of avoided tail+head dual reads each). Over 10–20 wrap sessions: ~10–40k tokens. Smaller than typical creation-session levers but recurs every session that runs `/wrap-session`.

**Additional levers (ROI-ranked):**
- Anticipate the always-loaded surcharge before drafting `CLAUDE.md` pause-trigger or rule edits — set a target word budget (e.g., ≤100 words for a single pause-trigger entry) at the start, draft to fit, then run `/risk-check`. Saves ~2–3k tokens per always-loaded edit by avoiding the expand-then-trim cycle and the second `Edit` payload. Bigger than primary on policy-edit sessions; smaller frequency than the wrap-ledger pattern.
- When concurrent-session disclosure is known at session start, scope `wrap-session.md` and other shared infra edits earlier in the session so commit-boundary collisions are visible before the other session wraps — saves 1 lost edit + 1 lost commit-boundary attribution per affected session, ~1–2k tokens of recovery overhead. Smaller than primary because concurrent-session collisions are infrequent.
- Self-applied `/risk-check` worked — the gate caught the always-loaded surcharge that the main agent's draft missed. Worth codifying as a lever: for any always-loaded-content edit, make plan-time `/risk-check` mandatory rather than discretionary. Zero token savings (it's a quality lever, not a cost lever) but prevents the rework-cycle cost above.
