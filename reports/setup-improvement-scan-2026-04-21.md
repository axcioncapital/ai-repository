---
date: 2026-04-21
scan_roots:
  - ai-resources/logs/
  - Axcion AI Repo/logs/
  - projects/buy-side-service-plan/logs/ (incl. archives)
total_lines_scanned: ~12,347 (active + archive logs + recent audits)
subagents: 4 (Phase A parallel Explore)
working_notes:
  - audits/working/setup-scan-ai-resources-2026-04-21.md
  - audits/working/setup-scan-bssp-active-2026-04-21.md
  - audits/working/setup-scan-bssp-archives-a-2026-04-21.md
  - audits/working/setup-scan-bssp-archives-b-2026-04-21.md
---

# Setup Improvement Scan — 2026-04-21

Log synthesis across three roots to surface concrete, actionable improvements to the Claude Code setup. Operator-facing report; findings are fed into `/improve` manually per Patrik's decision.

## Executive summary

- **Inlined standards in subagent briefs is the single largest token leak** (~36K tokens/session on `/produce-prose-draft`, confirmed Wasteful by `/usage-analysis`). Cross-root signal.
- **Plan-QC is working but not mandatory** — every session that ran it caught real issues; sessions that skipped paid in rework (see `/create-skill` session 2026-04-21, ~8–12K wasted tokens). Cross-root signal.
- **Assumption-validation is the top recurring-rework root cause** — same failure mode hit twice (Pilot Service scope, Doc 3 sibling redundancy), ~3 hours wasted combined. No automation; discipline relies on judgment.
- **obsidian-pe-kb vault has a silent runtime blocker** — 43 symlinks to ai-resources will fail without `additionalDirectories` in `vault/.claude/settings.json`. Single-source but urgent.
- **wrap-session file-modification race** has a cheap fix (skip "Session ended without /wrap-session" auto-append when wrap is in flight). Recurring, quantified (~1–2 min/session overhead).
- **Six pending improvement-log items** in bssp are accumulating without execution or explicit deferral — no standing review mechanism.
- **CLAUDE.md compaction already landed** (294→163 lines workspace, 159→57 lines project, 72% per-turn token reduction). Older observations in the working-notes about CLAUDE.md bloat are stale — no action needed.
- **6 hooks deployed 2026-03-28 remain unvalidated** — SessionStart context-loader is the highest-value one and it's untested.

Cross-root findings (evidence in ≥2 distinct roots): SC-01, SC-02, SC-05, SC-09, SC-10, SC-16. That's 6, exceeding the ≥3 target. SC-08's "two incidents" are both in the bssp root and do not meet the cross-root bar despite the priority-table mark. SC-03, SC-04, and others marked `[single-source]` are included as findings on their own merit (quantified or runtime-blocking), not because they meet the cross-root bar.

---

## Findings by category

### 1. Harness config

#### SC-01 — Inlined reference content in subagent briefs
- **Observation:** `/produce-prose-draft` and similar commands inline `style-reference.md` and `prose-quality-standards.md` (~36K tokens per run) into subagent briefs. Subagents already have `Read` access; passing file paths yields identical behavior with zero token cost for the content.
- **Evidence sources:**
  - `ai-resources/logs/usage-log.md:35–64` (2026-04-21 "Wasteful" verdict)
  - `projects/buy-side-service-plan/logs/session-notes.md:64–96` (2026-04-20 test run)
  - `projects/buy-side-service-plan/logs/session-notes-archive-2026-04.md:47,249,62,265`
- **Proposed change:** Refactor subagent briefs in `ai-resources/.claude/commands/produce-prose-draft.md` (and any other command inlining reference files — audit `produce-architecture.md`, `produce-formatting.md`, any `run-*` commands) to pass file paths instead of inlined content. Add a rule to `ai-resources/docs/ai-resource-creation.md`: "Do not inline reference files >2K words in subagent briefs — pass paths and rely on Read."
- **Priority:** P0
- **Effort:** M (one command refactor, audit pattern across other commands)
- **Expected impact:** ~30K tokens/run saved on `/produce-prose-draft`; potentially similar on `run-*` commands. Unblocks Doc 2 §2.2–2.9 re-prose which is currently halted pending this fix.

#### SC-02 — Hook validation debt (SessionStart context-loader + 5 others)
- **Observation:** 6 hooks were written 2026-03-28 (auto-commit, bright-line guard, SessionStart context-loader, checkpoint reminder, session-wrap reminder, decision logging). Validation was deferred to "next working session" and, as of 2026-04-21, has not happened. Status of each hook is unknown.
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/session-notes-archive-part1.md:1654–1681`
  - Cross-referenced in `ai-resources/logs/decisions.md:254–256` (session-source env var stub, mandate-parser Phase 2 — indirect evidence that hook validation is pending across the stack)
- **Proposed change:** Create `/validate-hooks` skill (or a one-off validation session) that spawns a test project, triggers each hook type, and logs whether it fired. File location: new skill at `ai-resources/skills/hook-validator/SKILL.md`, or a one-shot workflow-test session. Document hook dependencies (e.g., `SessionStart context-loader` requires `additionalDirectories` to include `.claude/plans/`).
- **Priority:** P1
- **Effort:** M (skill or one-off validation; ~1 hour)
- **Note:** [cross-root] — ai-resources has similar hook-related deferrals (mandate-parser session-source stub).

#### SC-03 — wrap-session file-modification race on auto-append logs
- **Observation:** `/wrap-session` takes 5–10 minutes on dense sessions due to race conditions on `logs/session-notes.md` and `logs/decisions.md`. Background session-end hook appends "Session ended without /wrap-session" while wrap-session is in flight; Edit fails with "File has been modified since read"; retry loop ensues (~6 extra tool calls, 1–2 min overhead on dense wrap-sessions — not every session).
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/friction-log-archive-part1.md:1054–1089` (detailed friction entry 2026-04-13)
  - Mitigation options listed; no decision applied.
- **Proposed change:** Update session-end hook (likely in `ai-resources/.claude/hooks/`) to skip "Session ended without /wrap-session" append when `/wrap-session` is currently executing. Detect via lockfile or env var set at wrap-session entry. Option 5 in the friction entry is identified as cheapest.
- **Priority:** P1
- **Effort:** S (one hook edit + test on next wrap-session)
- **Expected impact:** Eliminates 1–2 min/session overhead for every substantive session.

#### SC-04 — obsidian-pe-kb vault missing `additionalDirectories` (runtime blocker)
- **Observation:** Vault `.claude/settings.json` has 43 symlinks to `ai-resources/` commands+agents but lacks `additionalDirectories` for the workspace root. Symlinks will fail silently at runtime; SessionStart hook referencing `ai-resources` will also fail. Manifests only when vault session first attempts a shared command.
- **Evidence sources:** `ai-resources/audits/working/dd-extract.md:15–17` (FINDING-5, FINDING-6). `[single-source]`
- **Proposed change:** Add `"additionalDirectories": ["../../"]` (or correct relative path to workspace root) to `projects/obsidian-pe-kb/vault/.claude/settings.json`. Verify in first real vault session. Also: update `/new-project` pipeline to include `additionalDirectories` in the settings template so future pipelines don't reproduce the gap.
- **Priority:** P0
- **Effort:** S (one settings-file edit + first-session verification)

#### SC-05 — Shared-command symlink parity + CLAUDE.md rule codification (narrower than originally scoped)
- **Observation:** **Partially resolved already.** The deploy-workflow symlink system is implemented (`deploy-workflow.md:41–85` — shared-manifest.json + SessionStart `auto-sync-shared.sh` hook creates missing symlinks on every session start). The 2026-04-06/07 friction that motivated this has been addressed. What remains:
  1. `/new-project` parity — check whether `/new-project` pipeline uses the same symlink mechanism as `/deploy-workflow`, or whether it has drifted.
  2. CLAUDE.md rule codification — if not already in workspace CLAUDE.md, add: "Shared generic commands = symlinks to ai-resources; template-specific commands (prime, wrap-session, run-*) = local copies."
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/decisions-archive-part1.md:1263–1267` (2026-04-06 decision — original scope)
  - `projects/buy-side-service-plan/logs/friction-log-archive-part1.md:306–319` (2026-04-07 discovery)
  - Current `ai-resources/.claude/commands/deploy-workflow.md:41–85` (shows the symlink system is in place — narrows this finding)
- **Proposed change:** Verify `/new-project` uses symlink parity with `/deploy-workflow`. If not, align. Confirm CLAUDE.md rule presence; add if missing.
- **Priority:** P2 (downgraded from P1 after verification that most of the original issue is resolved)
- **Effort:** S (verification + narrow edits)

---

### 2. Commands & agents

#### SC-06 — `/create-skill` QC-loop compliance gap
- **Observation:** Skill-creation sessions skip the workspace CLAUDE.md QC→Triage auto-loop after cold-evaluator findings and jump to post-edit QC. This triggers 3+ extra subagent spawns (triage + post-edit QC + regression Edit). 2026-04-21 prose-refinement-writer session: 6 rework cycles, 7 subagents. Estimated 8–12K tokens wasted per session; 10–20 skill-creation sessions/month = 80–240K cumulative.
- **Evidence sources:** `ai-resources/logs/usage-log.md:35–64` (explicit self-diagnosis of the compliance slip, lines 50–56). `[single-source]` but high-confidence — the entry names the exact rule violated.
- **Proposed change:** Add an explicit rule to the `/create-skill` command preamble in `ai-resources/.claude/commands/create-skill.md`: "After cold-evaluator findings, run the workspace CLAUDE.md QC→Triage auto-loop. Do not skip to post-edit QC." Alternative stronger fix: PreToolUse hook on `Agent` that checks session context and warns when triage is expected but not invoked.
- **Priority:** P1
- **Effort:** S (command preamble edit) — or M if hook enforcement
- **Expected impact:** Projected 80–240K tokens/month if consistently applied. **This is an extrapolation from a single session (prose-refinement-writer, 2026-04-21), not a measured monthly baseline** — assumes 10–20 skill-creation sessions/month, which is not verified in logs. Treat as an order-of-magnitude estimate.

#### SC-08 — Assumption-validation gap in section drafting
- **Observation:** When operator input could map to multiple service designs or scopes, `/draft-section` produces a plan on an unvalidated premise. Recurring failure: Pilot Service scope (2026-04-07, ~2h wasted) and Doc 3 sibling redundancy (2026-04-13, ~60–75m wasted). Common root cause: assumptions gate surfaces the concern but rationalizes past it instead of escalating to operator.
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/friction-log-archive-part1.md:285–298` (Pilot Service)
  - `projects/buy-side-service-plan/logs/friction-log-archive-part1.md:1092–1167` (Doc 3)
  - `projects/buy-side-service-plan/logs/improvement-log.md:12–59` (three of six pending items relate to this)
- **Proposed change:** Two-layer:
  1. CLAUDE.md rule (workspace or bssp-level depending on specificity) — "Assumptions Gate: escalate structural concerns, do not self-resolve." List what qualifies as structural (scope ambiguity, sibling redundancy, phase-spec staleness).
  2. Update the `qc-reviewer` subagent prompt at `ai-resources/.claude/agents/qc-reviewer.md` (or bssp variant) to include "sibling redundancy" as an evaluation dimension for multi-document projects.
- **Priority:** P1
- **Effort:** S–M (rule text + subagent prompt update)
- **Expected impact:** Prevents ~60–180 min wasted-work class of friction that has happened at least twice.

#### SC-09 — Unresolved improvement-log items accumulating
- **Observation:** bssp `logs/improvement-log.md` has 6 items logged "pending (operator to invoke)" with no execution timeline: `/improve-skill ai-prose-decontamination`, `/challenge` dependency-chain awareness, differentiation test at assumptions gate, sibling-doc QC criterion, escalation-over-rationalization rule, friction-log auto-append wiring. ai-resources improvement-log has 5 similar Prevention-Session follow-ups from 2026-04-18.
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/improvement-log.md:3–7,12–59`
  - `ai-resources/logs/improvement-log.md` (Pattern A in working notes)
- **Proposed change:** One of: (a) create `/improvement-summary` command that lists all pending items across both roots and prompts weekly/monthly review; (b) add a Stop-hook reminder if improvement-log has >3 pending items; (c) set a calendar trigger via the scheduling skill to review pending items monthly. Preference: (a) + (c) — the command gives on-demand visibility, the trigger creates the enforcement.
- **Priority:** P2
- **Effort:** M (new command ~30 lines + schedule setup)

---

### 3. Skills & CLAUDE.md rules

#### SC-10 — Plan-QC is high-value but not mandated in CLAUDE.md
- **Observation:** Every session that ran plan-QC before execution caught substantive issues (CLAUDE.md fix 2026-04-20 caught F5-7 silent drop + missing mkdir; Doc 2 S2 caught phase-integration risk; `/produce-prose-draft` test caught 4 substantive findings). Sessions that skipped it paid in rework (e.g., prose-refinement-writer plan required full rewrite after initial external QC — ~5–8K tokens). Plan-QC is already the de-facto practice but is not written into the workspace CLAUDE.md Plan Mode Discipline section.
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/session-notes.md:113–143, 175–220, 223–286`
  - `projects/buy-side-service-plan/logs/session-notes-archive-2026-04.md:63,79,134,266`
  - `ai-resources/logs/usage-log.md:60–62` (plan-rewrite bias from skipping self-check)
- **Proposed change:** Extend `Axcion AI Repo/CLAUDE.md` → "QC Independence Rule" section (already mentions plan-QC) with a concrete threshold: "Plan-QC is required when a plan affects >3 files, has >2 decision gates, or introduces new conventions. Below that threshold, plan-QC is optional but recommended." Also: add a pre-QC self-check step to Plan Mode Discipline — run a quick self-check against the QC rubric before spawning the external reviewer (5–8K tokens saved per plan when findings are caught pre-external).
- **Priority:** P1
- **Effort:** S (CLAUDE.md edit)

#### SC-11 — Concurrent-session staging discipline rule still pending formal codification
- **Observation:** Workspace CLAUDE.md already has a "Concurrent-session staging discipline" section (confirmed present at line 153 of `Axcion AI Repo/CLAUDE.md`). However, improvement-log.md notes the rule was "pending" in earlier sessions. Current state: **codified**. But the enforcement is operator-discipline only; there's no hook that checks for directory-wildcard `git add` when a concurrent-session lockfile is present.
- **Evidence sources:**
  - `ai-resources/logs/improvement-log.md:120–135`
  - `projects/buy-side-service-plan/logs/session-notes-archive-2026-04.md:81,136,198` (patterns of ad-hoc management)
- **Proposed change:** Optional automation layer — add a pre-commit or pre-git-add hook that detects `git add logs/` / `git add .` / `git add -A` and, if a sibling-session indicator is present (e.g., a `.claude/session.lock` file written by SessionStart), blocks the compound command and prompts explicit path enumeration. If no automation, this entry is just a "rule exists, working as designed" observation.
- **Priority:** P2
- **Effort:** M (hook development is non-trivial)

#### SC-12 — Skill-file direct edit routing needs enforcement hook
- **Observation:** Workspace CLAUDE.md + ai-resources CLAUDE.md both state that skill-file modifications route through `/improve-skill`. Currently enforced by discipline only. Four skill files (ai-prose-decontamination, chapter-prose-reviewer, prose-compliance-qc, decision-to-prose-writer) have pending improvements queued; risk of direct edits bypassing the `/improve-skill` QC gate.
- **Evidence sources:**
  - `projects/buy-side-service-plan/logs/decisions-archive-part1.md:17, 25, 1262`
  - `projects/buy-side-service-plan/logs/improvement-log.md:3–10` (2026-04-17 correct-process example)
- **Proposed change:** Add a PreToolUse hook (Edit/Write matcher) that matches `ai-resources/skills/*/SKILL.md` paths and blocks with a message: "Route skill-file changes through /improve-skill." Non-blocking alternative: warn-only.
- **Priority:** P2
- **Effort:** M (hook script + settings.json entry)

---

### 4. Log-file hygiene & token cost

File-size tally (current state, 2026-04-21):

| File | Lines | Status |
|---|---|---|
| `ai-resources/logs/session-notes.md` | 1,677 | Large; rotate candidate |
| `projects/buy-side-service-plan/logs/session-notes.md` | 473 | OK |
| bssp archives (4 files combined) | 7,333 | Archived — fine |
| `ai-resources/logs/decisions.md` | 389 | OK |
| `ai-resources/logs/coaching-data.md` | 246 | OK |
| Workspace CLAUDE.md | 163 | Compacted 2026-04-20 — fine |
| ai-resources CLAUDE.md | 84 | OK |
| bssp CLAUDE.md | 57 | OK |
| Combined CLAUDE.md pair per-turn | ~2,130 tokens | Within best-practice guidance |

**Key insight:** The CLAUDE.md compaction flagged in older audit notes (workspace was 294 lines / ~5.4K tokens) **has already landed** (now 163 lines / ~3K tokens). Any log entry flagging "CLAUDE.md oversized" is stale and should not generate new action.

#### SC-13 — ai-resources/logs/session-notes.md approaching archive threshold
- **Observation:** 1,677 lines. Near bssp's pre-archive session-notes threshold (bssp split into archive parts at ~2.5K lines). Not always-loaded, so no per-turn token cost — but `/prime` and session-readers do read portions of it, and the file is getting slow to scan.
- **Evidence sources:** file-size tally above, file exists at `ai-resources/logs/session-notes.md`
- **Proposed change:** Archive entries older than ~60 days to `logs/session-notes-archive-2026-Q1.md` (or similar date-scoped filename). Use the same pattern bssp used. Keep the archive file dormant — reference from main session-notes.md if needed.
- **Priority:** P2
- **Effort:** S (cut/paste operation; or write a one-time archive script)
- **Note:** Archive script fragility was flagged in bssp archives (Pattern 9) — if a script is used, handle date-range headers and check for duplicates before appending.

#### SC-14 — Prose edit churn in `/produce-prose` (50+ edits on single file)
- **Observation:** 2026-04-05 session shows 50+ edits on `2.8-core-service-definition.md` in 15 minutes. Each Edit re-reads the file. For 3K–5K word prose files, that's substantial token cost.
- **Evidence sources:** `projects/buy-side-service-plan/logs/session-notes-archive-part2.md:179–256, 339–356`. `[single-source]`
- **Proposed change:** Investigate whether `/produce-prose` (or its successor `/produce-prose-draft`) can batch edits (collect fixes, apply in single Write) or use a staging area (temp file → review → promote). Lower priority because this workflow is already under refinement (SC-01) and may be addressed incidentally.
- **Priority:** P2
- **Effort:** M (command refactor)

#### SC-15 — Auto-append and manual-append log separation
- **Observation:** `logs/session-notes.md` receives both auto-appends (session-end hook) and manual appends (`/wrap-session`). This creates the race-condition surface that SC-03 addresses tactically. A structural fix: separate files.
- **Evidence sources:** `projects/buy-side-service-plan/logs/friction-log-archive-part1.md:1054–1089` (race condition). Inferred structural fix.
- **Proposed change:** Optional architectural cleanup — route auto-appends to `session-notes.auto.md` and manual/wrap appends to `session-notes.md`. Only pursue if SC-03 (cheap fix) proves insufficient or if the race recurs after SC-03 lands.
- **Priority:** P2 (and contingent — do not pursue unless SC-03 fails)
- **Effort:** L (touches hook + wrap-session + reader conventions)

---

### 5. Cross-project conventions

#### SC-16 — Innovation registry canonical format not enforced; graduation pipeline slow
- **Observation:** Innovation registry is a pipe-delimited markdown table, but Prime and potentially other tools assume list or JSON. Additionally, bssp registry has 12+ items marked `triaged:graduate` or `triaged:graduate-candidate` (wiki, audit-claude-md, prose-quality-standards v3, produce-prose-draft improvements) with no formal schedule for moving them to `ai-resources/` canonical.
- **Evidence sources:**
  - `ai-resources/logs/friction-log.md:3–7` (format brittleness)
  - `projects/buy-side-service-plan/logs/innovation-registry.md:18–45, 41–46`
- **Proposed change:**
  1. Document in `ai-resources/CLAUDE.md` that innovation-registry is pipe-delimited markdown table (one canonical format). Audit all tools that read it (Prime Step 2 at minimum).
  2. Establish graduation schedule: quarterly review of all `triaged:graduate` items with target of 2–3 candidates/month moved to ai-resources canonical. Use `/graduate-resource` command (already exists in the skill library).
- **Priority:** P2
- **Effort:** S (format docs + grep fixes) + ongoing process discipline for graduation

---

## Considered and rejected

- **"Workspace CLAUDE.md is oversized"** — older audit notes flagged 294 lines / ~5.4K tokens. Current state is 163 lines / ~3K tokens. Compaction landed 2026-04-20. Not raising as a finding.
- **"Project CLAUDE.md bloated"** — bssp CLAUDE.md is 57 lines. Fine.
- **"Add concurrent-session rule to workspace CLAUDE.md"** — already present (workspace CLAUDE.md line 153). Potential automation layer raised as SC-11 but core rule exists.
- **"Add usage-log telemetry enforcement"** — already handled via Stop hook (2026-04-18 improvement-log entry); telemetry discipline is sustainable. No action.
- **"QC verdict summary table at top of qc-log.md"** — hygiene improvement only; bssp-active Pattern 10 proposal. Low leverage, defer.
- **Prime command fragility (originally SC-07 — innovation-registry grep pattern + git-status drift)** — both defects were fixed 2026-04-18 per bssp `improvement-log.md:137–148` (Status: applied). Verified in current `ai-resources/.claude/commands/prime.md` (lines 8–9 show corrected pipe-delimited grep; line 20 shows git-status freshness check; line 36 shows new working-tree output). Not raising as a finding — no action needed.
- **Deploy-workflow symlink remediation (SC-05, partial)** — the shared-command symlink system is already implemented per `deploy-workflow.md:41–85` (shared-manifest.json + SessionStart `auto-sync-shared.sh` hook). SC-05 remains in the findings list but is narrower than originally scoped — see SC-05 note below.
- **Scope-carve annotation section in workspace CLAUDE.md** (cross-root, archives-A Pattern 7 + bssp-active Pattern 13) — material finding surfaced by working notes but deliberately excluded from this scan. Rationale: documentation-addition proposals are outside this report's scope (setup/infrastructure changes). Raise via `/improve` or `/update-claude-md` if desired.
- **Citation-bibliography enforcement hook** (archives-A Pattern 10, single-source) — single-source and narrow. Defer to `/improve` if relevant.
- **Plan-mode QC batch-edit rule** (archives-A Pattern 2, single-source) — workflow-discipline tweak, not a setup change. Out of scope.
- **Permission-matcher form (space vs colon) verification** (ai-resources Pattern D, single-source) — narrow verification task, not a change proposal. Better raised as a one-off check.
- **Sibling-redundancy as standalone qc-reviewer prompt update** — subsumed in SC-08's proposed change #2; promoting to standalone would double-count.

## Operator decisions (2026-04-21)

Locked-in defaults; each can be course-corrected at `/improve` intake.

1. **SC-01 scope — audit all subagent-brief commands.** Not just `/produce-prose-draft`. Covers `produce-*`, `run-*`, and any command that constructs Agent-tool briefs. One sweep session.
2. **SC-09 format — both a `/improvement-summary` command AND a scheduled monthly trigger.** Command for ad-hoc visibility; trigger forces review without operator initiative.
3. **SC-11 — defer with revisit condition.** Park the concurrent-session automation hook. Revisit if a second real incident occurs; drop permanently if 60 days pass clean.
4. **SC-13 — month-based archiving.** Archive `ai-resources/logs/session-notes.md` at each month boundary to `session-notes-archive-YYYY-MM.md`, matching the bssp pattern.
5. **SC-12 — warn-only hook, not blocking.** Preserves the routing signal without adding permission-prompt friction.

## Priority summary

| ID | Category | Priority | Effort | Cross-root? |
|---|---|---|---|---|
| SC-01 | Token leak (inlined standards) | P0 | M | ✓ |
| SC-04 | obsidian-pe-kb runtime blocker | P0 | S | [single-source] |
| SC-02 | Hook validation debt | P1 | M | ✓ |
| SC-03 | wrap-session race | P1 | S | [single-source, quantified] |
| SC-06 | /create-skill QC-loop compliance | P1 | S | [single-source, projected] |
| SC-08 | Assumption-validation gap | P1 | S–M | ✗ (two bssp incidents, same root) |
| SC-10 | Plan-QC threshold in CLAUDE.md | P1 | S | ✓ |
| SC-05 | Shared-command symlink parity | P2 | S | ✓ (narrowed — mostly resolved) |
| SC-09 | Improvement-log accumulation | P2 | M | ✓ |
| SC-11 | Concurrent-session automation | P2 | M | [rule codified; automation optional] |
| SC-12 | Skill-file edit hook | P2 | M | [single-source] |
| SC-13 | session-notes.md archive | P2 | S | [single-source] |
| SC-14 | Prose edit churn | P2 | M | [single-source] |
| SC-15 | Auto/manual log separation | P2 (contingent) | L | [single-source] |
| SC-16 | Registry format + graduation | P2 | S + ongoing | ✓ |

Two P0s (SC-01, SC-04), five P1s, eight P2s. SC-07 removed (stale — fixes already applied 2026-04-18); see Considered and rejected.
