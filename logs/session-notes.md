# Session Notes

> Archive: [session-notes-archive-2026-04.md](session-notes-archive-2026-04.md)

## 2026-04-24 — Friday checkup (monthly tier, ai-resources scope)

### Summary

Ran `/friday-checkup` with operator-override to monthly tier, then narrowed scope from the initial 4-scope selection (ai-resources + workspace + obsidian-pe-kb + project-planning) to ai-resources only after the 233-min runtime estimate surfaced. Completed all auto-run checks inside the ai-resources scope: `/audit-repo`, `/improve`, `/coach`, `/token-audit`. `/audit-claude-md` was spec-skipped because it only runs on ai-resources when workspace scope is also selected. Consolidated findings into a single review-only report. Surfaced a spec gap in `/audit-claude-md` coverage.

### Files Created

- `audits/friday-checkup-2026-04-24.md` — consolidated review-only report (7 prioritized findings across HIGH/MEDIUM/LOW, per-scope summary, 6 operator follow-ups)
- `audits/repo-health-ai-resources-2026-04-24.md` — cadence snapshot of /audit-repo output
- `audits/token-audit-2026-04-24-ai-resources.md` — 11-section token audit report (351 lines)
- `audits/working/audit-working-notes-skills.md` + `audit-summary-skills.md` — Section 2 subagent outputs (69 skills audited)
- `audits/working/audit-working-notes-file-handling.md` + `audit-summary-file-handling.md` — Section 6 subagent outputs
- `audits/working/audit-working-notes-workflow-research-workflow.md` + `audit-summary-workflow-research-workflow.md` — Section 4 subagent outputs
- `reports/repo-health-report-2026-04-06.md` — prior canonical report auto-archived by /audit-repo

### Files Modified

- `reports/repo-health-report.md` — updated by /audit-repo (Overall GREEN, 0 Critical / 0 Important / 11 Minor)
- `audits/working/audit-working-notes-preflight.md` — overwritten for 2026-04-24 (was 2026-04-18)
- `logs/coaching-log.md` — first baseline coaching entry appended

### Decisions Made

- **Tier override to monthly** (auto-detected was weekly; today is Friday day-24, outside monthly's first-week window). Routine operator direction.
- **Scope narrowed to ai-resources only** after 233-min runtime estimate for the original 4-scope plan. 51-min estimate accepted via `proceed with long run` gate.
- No analytical decisions logged to `decisions.md` this session — all calls were operational.

### Next Steps

- Push: today's commits (this wrap + any follow-on work).
- Review the consolidated `audits/friday-checkup-2026-04-24.md`; pick HIGH items to act on first. Highest-ROI quick win: token-audit H2 (expand `Read(pattern)` deny rules in `ai-resources/.claude/settings.json`).
- Follow up on `/audit-claude-md` spec gap: the monthly branch currently skips ai-resources when workspace isn't also selected. Consider revising so ai-resources-only runs still audit the ai-resources CLAUDE.md directly.
- Optional: run `/cleanup-worktree` once the audit session's own files are reviewed/committed.
- Carryover next-steps from 2026-04-23: push `/summary` skill commits (`9f62fe6`, `7463f44`); first real test of `/summary` on an actual long document.

### Open Questions

- None.

## 2026-04-24 — /qc-pass guardrails: three-layer scope-aware rubric for mechanical infra work

### Summary

Designed and shipped three layered guardrails to the `/qc-pass` flow so QC stops net-negatively affecting mechanical work on repo-infrastructure files (permission settings, SKILL.md tweaks, command/agent edits, CLAUDE.md fixes, prompt changes). Dogfooded the new auto-loop mechanical-mode skip rule on the implementation's own post-edit QC pass — mechanical-mode GO with all M-checks Clear correctly skipped triage on first real use.

### Files Created

- None. Plan lives at `~/.claude/plans/let-s-fix-qc-pass-command-quiet-comet.md` (outside repo).

### Files Modified

- `ai-resources/.claude/agents/qc-reviewer.md` — wholesale rewrite: Rubric Selection section, Mechanical mode M1/M2/M3 checklist, Finding tagging via section placement (Findings = in-scope, Notes = out-of-scope), Findings+Notes output structure, legacy 3-input fallback with derived-scope annotation. Incidentally added dimension 6 (Sibling Redundancy) back into Output Format template — pre-existing bug absorbed by restructure.
- `ai-resources/.claude/agents/triage-reviewer.md` — wholesale rewrite: dimension 0 scope relationship, Parked-by-scope default output table, scope-tag overrides Do bar unless out-of-scope fix prevents in-scope break.
- `ai-resources/.claude/commands/qc-pass.md` — added scope input (Step 2 fourth item), mechanical-mode hint logic (Step 3), Step 4a scope visibility note for operator re-invoke.
- `CLAUDE.md` (workspace root) — Mechanical-mode QC (second gear) bullet in QC Independence Rule; Auto-Loop step 1 rewrite with findings/notes gating and mechanical-mode GO skip.

Commits: ai-resources `d50480f` (batch: /qc-pass guardrails); workspace `fe362ad` (update: CLAUDE.md — mechanical-mode bullet + Auto-Loop scope gating).

Archive activity (wrap-session): `ai-resources/logs/session-notes.md` trimmed by archive script to keep 10 most recent entries; `ai-resources/logs/session-notes-archive-2026-04.md` auto-updated with 4 older April entries.

### Decisions Made

- **Mechanical-mode scope definition:** operator directive broadened from "JSON/settings only" to "everything involved in repo infrastructure" — settings files, command/agent defs, SKILL.md, CLAUDE.md, hooks, prompts, analogous infra. Implemented as target universe in qc-reviewer Rubric Selection.
- **Scope declaration flow:** hybrid derive-and-display. Main agent derives scope from artifact + last turn, reviewer echoes in output header, operator corrects by re-invoking `/qc-pass` if mis-derived. Rejected: caller form-fill (adds friction where false-positive problem lives) and silent derivation (errors hidden).
- **Mechanical-mode detection:** qc-reviewer auto-detects from diff + scope + optional `mechanical-mode: suggested` hint. `forced-off` override exists; no `forced-on` override (dangerous direction — would let caller narrow rubric on design work).
- **Design shape:** three-layer (scope + rubric + triage) over simpler tag-only alternative (operator chose after QC surfaced alternative). Three-layer addresses both net-negative outcomes AND noise volume; tag-only addresses only net-negative.
- **Ripple-edit scope:** narrowed by operator after QC found three additional qc-reviewer invokers — `refinement-deep.md`, `cleanup-worktree.md`, three workflow commands. Operator directed: do not touch these; rely on legacy 3-input fallback (derive-scope) in qc-reviewer. Deferred to follow-up migration.

QC-fix items applied (triaged "Do"):
- Output Format tag-placement disambiguation — tags implicit by section placement, not inline.
- Auto-Loop step 1 skip condition extended to cover mechanical-mode GO with all M-checks Clear (in addition to existing "all Notes" skip).

### Next Steps

- Push both repos: `ai-resources` at `d50480f`; workspace at `fe362ad`.
- First real-world test: on the next mechanical `/qc-pass` invocation, confirm rubric selection, tag placement, and auto-loop skip behave as designed.
- Follow-up migration (separate session): update `refinement-deep.md`, `cleanup-worktree.md`, and workflow commands (`qc-pass.md`, `produce-formatting.md`, `produce-prose-draft.md`) to the 4-input contract. Low urgency — legacy fallback keeps them correct in the meantime.
- Carryover from 2026-04-23: push `/summary` skill commits (`9f62fe6`, `7463f44`); first real test of `/summary` on an actual long document.

### Open Questions

- None.

## 2026-04-24 — Act on Friday-checkup HIGH findings (H2 + M1 + H1)

### Summary

Addressed three of the Friday-checkup report's prioritized items this session: H2 (expand `Read(pattern)` deny coverage), M1 (set `MAX_THINKING_TOKENS=10000`), and H1 (rework three research-workflow prose-pipeline subagent returns to output-to-disk per the Subagent Contracts). Plan was reviewed at ExitPlanMode after two self-check fixes (qc-reviewer Write-tool prerequisite, `mkdir -p` ownership). Ran the full QC → Triage Auto-Loop on Part B: first qc-reviewer pass GO-with-minor-items → triage promoted 3 Do items → fixes applied → second qc-reviewer pass REVISE on two stale step-number back-references I missed → mechanical fix applied (QC-skip criteria met). Two commits landed: `1df2a1c` (Part A settings) and `556313e` (Part B H1 refactor). Both pre-push. H3 (skill splits), M2, M3, and LOW items deferred per operator direction.

### Files Created

- None. Plan at `~/.claude/plans/snuggly-popping-allen.md` (outside repo; user-level plans dir).

### Files Modified

- `ai-resources/.claude/settings.json` — expanded `deny` list with 5 new patterns (`Read(audits/working/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`); added `env.MAX_THINKING_TOKENS=10000`. Conservative scope — deliberately did NOT add broad `Read(audits/**)` or `Read(reports/**)` which would block reading today's canonical reports. (Operator also added explicit `Edit/Write(.claude/settings.json)` and `Edit/Write(**/.claude/settings.json)` allow rules mid-session after a harness prompt fired on the first settings edit despite `bypassPermissions` being on.)
- `ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md` — Phase 2 step 0: added `mkdir -p "{prose_output_dir_abs}/working"`. Phase 3 step 5 subagent task: output-to-disk pattern (writes unified findings to `working/phase-3-qc-{section}.md`) + ≤20-line structured return spec. Phase 3 step 6 fix-agent handoff: receives working-file path instead of inline findings. Phase 3 step 7 handoff note: summary + absolute working-file path, full findings stay on disk. Phase 6 step 2: reads working file before operator surfacing.
- `ai-resources/workflows/research-workflow/.claude/commands/produce-formatting.md` — Phase 2 step 5 (renumbered from initial `4a`): added `mkdir -p` call. Phase 2 subagent: output-to-disk (writes to `working/formatting-phase-2-{section}.md`) + ≤20-line return. Phase 3 subagent: output-to-disk (writes to `working/formatting-phase-3-qc-{section}.md`), now reads Phase 2 working file by path for deferred-items context. Phase 4 steps 2–3: reads both working files before operator surfacing.
- `ai-resources/.claude/agents/qc-reviewer.md` — added `Write` tool to frontmatter tools list (between `Read` and `Glob`). Prerequisite for H1 — qc-reviewer is used in both produce-* Phase 3 contexts and needed disk-write capability to comply with the Subagent Contracts output-to-disk rule. Additive change; existing callers (via `/qc-pass`, `/refinement-pass`) unaffected unless brief explicitly asks for a write.
- `ai-resources/logs/session-notes.md` — this entry.

### Decisions Made

- **H2 scope narrowed from token-audit's aggressive recommendation.** Audit recommended `Read(audits/**)` and `Read(reports/**)` broadly. Chose conservative additions that protect known-stale patterns (`audits/working/**`, `logs/*-archive-*.md`, `inbox/archive/**`, `**/deprecated/**`, `**/old/**`) without blocking canonical reports the operator needs to read during review sessions. See decisions.md.
- **`qc-reviewer` Write tool grant.** Caught during plan self-check: Phase 3 subagents are `qc-reviewer` type, which previously had `Read/Glob/Grep` only — no disk-write capability. Required a frontmatter addition to enable the H1 refactor. Blast radius: additive, no existing caller exercises Write unless asked.
- **mkdir responsibility assigned to main session.** `Write` tool doesn't auto-create parent directories; qc-reviewer has Write but not Bash. Placing `mkdir -p` in the main session's Phase 2 (both commands) inverts the responsibility pattern from `token-audit-auditor` but provides a cleaner split.
- **20-line subagent return cap (down from 30).** Post-QC triage promoted this per the CLAUDE.md Subagent Contracts "Tighter cap (20 lines) when per-unit invocations proliferate (one subagent per workflow, per chapter, per file)" rule. Per-section invocation counts as per-chapter.

QC-fix items applied (triaged "Do", not separate decisions):
- Renumbered produce-formatting Phase 2 mkdir step from `4a` to `5` (and shifted subsequent steps), matching the clean-integer convention used in produce-prose-draft Phase 2 step 0.
- Normalized `{prose_output_dir}` → `{prose_output_dir_abs}` in the produce-prose-draft Phase 3 handoff-note path reference.
- Tightened the 30-line cap to 20 lines across all three subagent return specs.
- Second-pass QC-revise fix: updated two stale `step 4a` back-references in produce-formatting.md lines 50 and 95 to `step 5` (missed by the initial renumber).

### Next Steps

- **Push** the two commits from this session (`1df2a1c` settings, `556313e` H1 refactor), plus the carryover `/summary` skill commits from 2026-04-23 (`9f62fe6`, `7463f44`). Operator confirmation required per Autonomy Rules pause-trigger #2.
- **Validate H1 on a real chapter.** The refactor is template-only. On the next real `/produce-prose-draft` or `/produce-formatting` invocation, confirm: (a) `{prose_output_dir}/working/` dir created; (b) subagent writes structured findings file; (c) return summary ≤20 lines; (d) Phase 4 / Phase 6 reads successfully surface the findings to operator.
- **Propagate H1 to deployed project workflows via `/sync-workflow`** when the operator decides — standard workflow-template update pattern.
- **H3 skill splits** (`ai-resource-builder` 401L / 3 modes, `answer-spec-generator` 485L / 5 modes, plus `research-plan-creator` 464L, `evidence-to-report-writer` 332L, `workflow-evaluator` 316L, `ai-prose-decontamination` 314L) — staged across future sessions. Recommend starting with the two multi-mode skills where the per-invocation bloat is highest.
- **M2** (orchestrator compression for `new-project.md` 476L, `deploy-workflow.md` 321L via protocol-file pattern) and **M3** (`/clear` guidance between produce-* commands) — deferred.
- **`/audit-claude-md` spec gap** from the Friday-checkup's "Plan QC gap" note: ai-resources-only runs currently skip the ai-resources CLAUDE.md. Revise the monthly branch so ai-resources-only runs still audit it directly.
- **`/cleanup-worktree`** — working tree still has ~30 dirty entries from last two sessions' audit artifacts (friday-checkup report, repo-health snapshots, token-audit report, working notes, plus some agent/command edits from today's /qc-pass session). Run after reviewing these artifacts.
- **Carryover from 2026-04-23:** first real test of `/summary` on an actual long document.

### Open Questions

- None.

## 2026-04-24 — Repo maintenance cadence — commission v4 review + 5-batch plan

### Summary

Reviewed operator-supplied v4 commission for a "durable weekly Friday repo maintenance cadence." Core finding: the commission substantially underestimates existing repo infrastructure (`/friday-checkup`, reminder hook, `improvement-log.md`, `/triage`, `/coach`, `audit-discipline.md`, symlink policy) — faithful implementation would create parallel structures. Pared the commission to eight genuine gaps and drafted a 5-batch implementation plan sequenced per the commission's own risk-analysis-first constraint. Plan ran through /qc-pass → /triage (7 Do + 3 parked items applied) → post-edit /qc-pass (GO with minor findings) → inline fixes before approval.

### Files Created

- `/Users/patrik.lindeberg/.claude/plans/here-s-an-idea-i-memoized-bumblebee.md` — approved implementation plan (outside repo; input for future execution sessions). Contains Part A critique, 5-batch build plan, Critical Files list, 10 flagged assumptions, 5 Decision Gates, Verification per batch, Skipping list, Handoff notes for fresh sessions.

### Files Modified

- None in repo. Planning-only session — plan file lives at `~/.claude/plans/`, outside the repo.

### Decisions Made

Strategic / scoping (material):
- **Commission ≠ set plan.** Treated commission as intent; cut parallel-structure asks; reused existing infrastructure aggressively.
- **Merge original Batches 2 + 3** (`/friday-act` + tier-differentiated output) due to shared data contract. Plan now has 5 batches, not 6.
- **Seven autonomy axes → `/friday-act` output, not coaching-log.** Commission's axes are forward-looking weekly targets; coaching-log is backward-looking session ratings. Different purpose — kept separate.
- **Freshness derived from `audits/friday-checkup-*.md` listing, not a parallel stamp file.** Single source of truth; applies plan's own "don't parallel existing infrastructure" argument.

Design (architectural):
- **`/risk-check` as new slash command** (not hook, not `/triage` extension). Operator-invoked manually or inline-invoked by other commands; no auto-invocation hook.
- **Stage 1 repo architecture = static `docs/repo-architecture.md` + `/route-change` command** (not an agent, not auto-wired into `/create-skill`).
- **`/route-change` auto-wire into `/create-skill` = OFF until proven useful** (preserves existing pipeline; change only if Batches 1–4 show misplaced resources).

Process:
- **QC → triage auto-loop applied fully.** First QC returned REVISE with 6 findings; triage returned 7 Do / 9 Park; operator directed "proceed per triage + add parked 2/3/6"; post-edit QC returned GO with minor findings; operator chose option (b) inline fixes; plan approved post-handoff-notes.
- **Commit discipline: one commit per batch, 5 commits total.** Each internally coherent, independently revertible.

### Next Steps

- **Open fresh session to execute Batch 1** (`/risk-check` + `risk-check-reviewer` agent + `docs/audit-discipline.md` edit + workspace `CLAUDE.md` edit). Full session on its own — new command + new agent + decision gate for top-3-commands-affected analysis before landing CLAUDE.md edit.
- **Session opening ritual:** `/prime` → read plan file → confirm Batch 1 assumption sign-offs (assumptions 1, 3, 4, 9) → begin deliverables.
- **Pacing:** plan's Handoff notes specify don't attempt more than 2 batches per session. Batch 1 alone is a full session; Batches 2 and 5 are comparable.
- **Dogfood ordering:** `/risk-check` doesn't exist during Batch 1 — can't self-invoke. Real dogfood starts Batch 2.

### Open Questions

- None. Plan explicitly flags 10 assumptions and 5 decision gates for operator sign-off at batch opening; those are expected prompts, not blockers.

## 2026-04-24 — Built /audit-critical-resources command + subagent

### Summary

Developed a new slash command `/audit-critical-resources` and its `critical-resource-auditor` subagent from a context pack the operator provided. The command audits user-nominated resources (skills, commands, agents, CLAUDE.md) across seven quality dimensions — brokenness, currency vs. Anthropic docs, architectural fit, token/efficiency, guardrail integrity, cross-resource consistency, epistemic hygiene — and produces a fix-session-ready markdown report. Went through plan mode with two QC/triage cycles on the plan, then post-build QC/triage on the built files. Operator then designated 12 commands and 3 directly-referenced skills as the initial critical set; populated the manifest accordingly.

### Files Created

- `.claude/commands/audit-critical-resources.md` — orchestrator command; manifest-driven with args override, `--dry-run` and `--full-repo-context` flags, 10-step procedure from preflight through commit
- `.claude/agents/critical-resource-auditor.md` — Opus subagent; audits one resource across all 7 dimensions; writes full findings to working-notes with Synthesis Input Block for main-session cross-resource pass; returns ≤30-line summary ending with `WORKING_NOTES: <path>` marker
- `audits/critical-resources-manifest.md` — initial designation: 12 commands (`/prime`, `/wrap-session`, `/create-skill`, `/improve-skill`, `/friday-checkup`, `/friction-log`, `/qc-pass`, `/refinement-pass`, `/cleanup-worktree`, `/repo-dd`, `/new-project`, `/token-audit`) + 3 skills (`session-usage-analyzer`, `ai-resource-builder`, `worktree-cleanup-investigator`)
- `~/.claude/plans/let-s-develop-this-nifty-pillow.md` — plan file (outside repo; Claude Code plan-mode artifact)

### Files Modified

None in the repo this session — all outputs were new files.

### Decisions Made

On the command's design (operator-confirmed via AskUserQuestion at planning):
- Input format: manifest file + args override (over inline-only or registry-scan)
- Overlap policy: run all 7 dimensions independently — self-contained report; does not delegate to `/token-audit`, `/audit-claude-md`, or `/repo-dd` for overlapping dimensions
- Parallelism: one subagent per resource, parallel across resources; cross-resource synthesis runs in main session reading each working-notes file's `## Synthesis Input Block`

On the critical set:
- "Associated skills" scoped to skills the commands reference directly by path (3 skills). Subagents spawned by critical commands and invoked sibling commands were explicitly NOT included — operator can extend later if desired.

QC-driven fixes applied during build (not analytical decisions):
- Plan cycle 1: URL-provenance disambiguation, cross-resource synthesis input contract (Synthesis Input Block schema), Step 5 staging-path enumeration, manifest parse rules
- Plan cycle 2: semantic URL re-verification at build-time, `WORKING_NOTES: <path>` last-line marker on subagent summary
- Post-build: Step 6 YAML-block wording, slug-algorithm trailing-dash fix, subagent meta-comment stripping instruction

### Next Steps

- Push two unpushed commits on `main`: `07b367f` (command+subagent) and `b18dccc` (manifest)
- Verify manifest parses with `/audit-critical-resources --dry-run` before the first real audit
- Run the first audit: `/audit-critical-resources` (no args) — generates baseline report at `audits/audit-critical-resources-2026-04-24.md`
- Consider whether to extend the critical set to include: subagents spawned by critical commands (e.g., `qc-reviewer`, `repo-dd-auditor`, `token-audit-auditor`, `claude-md-auditor`), and commands that critical commands invoke (e.g., `/audit-repo`, `/improve`, `/coach` invoked by `/friday-checkup`)

### Open Questions

None.

## 2026-04-24 — Model-tier classifier hook at workspace root

### Summary

Designed and built a UserPromptSubmit hook that addresses Patrik's recurring overspend pattern: session default stays on Opus for quality, but Sonnet-tier work (mechanical, factual, orchestration) silently runs on Opus because the downshift is forgotten until weekly usage review. The hook fires once per session on the first free-form (non-slash-command) prompt and injects a system-reminder telling Claude to classify the task against the workspace Model Tier rule and recommend `/model sonnet` when clearly Sonnet-tier. Opus remains the default; only the recommendation is automated. Scope is workspace-level, applying to every Axcíon project.

### Files Created

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh` — executable bash hook. Reads stdin JSON via jq for `.prompt` and `.session_id`; skips if prompt begins with `/`; skips if `/tmp/claude-model-classifier/$session_id` marker exists; otherwise creates the marker and emits `hookSpecificOutput.additionalContext` with the classification instruction. Pipe-tested against four scenarios (slash command, first free-form fire, repeat fire, missing payload) — all pass; emitted JSON validates via `jq -e`.

### Files Modified

- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/settings.json` — added `UserPromptSubmit` hook entry registering the new script alongside existing `SessionStart` / `Stop` / `PreCompact` / `PostCompact` / `SubagentStop` entries. Operator/linter also added three blanket permission entries (`Read(**)`, `Write(**)`, `Edit(**)`) during the session — left intact per the intentional-change system reminder.

### Decisions Made

- **Keep Opus as session default (not flip to Sonnet):** operator stated quality degrades when Sonnet is the default; automated-recommendation approach preferred over blanket downshift.
- **Active interrupt over passive cue:** operator only notices spend at weekly usage review, so statusline or static SessionStart reminders would be ignored; a hook that injects a system-reminder before work starts is the forcing function.
- **Claude-based classifier (not keyword-matching, not static text):** keyword-matching is brittle; static reminders become noise; a single short Opus classification turn at session open is cheap relative to the Sonnet savings across the rest of the session.
- **Skip slash-command prompts in the trigger:** Patrik's typical first prompt is `/prime` (orientation); work commands with their own `model:` frontmatter already override session default. Firing only on free-form prompts lands the recommendation at the right point in the session.
- **Scope: workspace-level, not project-level:** the hook belongs in workspace-root `.claude/settings.json` so it applies to every Axcíon project equally, not only ai-resources.

### Next Steps

- Open `/hooks` once or restart the CLI next session to pick up the mid-session hook registration — the settings watcher only monitors files that existed at session start.
- On the next session's first free-form prompt, verify the hook fires and the classification recommendation is sensible. Test with a clearly Sonnet-tier task (e.g., "rename X to Y across these files") to confirm the `/model sonnet` recommendation surfaces.
- Workspace-root commit `0e4d6af` is local-only (no git remote configured on the workspace-root repo). Operator may want to add a remote for off-machine backup of workspace-level configuration.
- Unrelated: the workspace-root repo has many untracked files and modifications from prior sessions — consider a separate cleanup pass when convenient.

### Open Questions

None. (Remote-addition decision deferred to operator.)

## 2026-04-24 — Built /permission-sweep durable permission-prompt audit + remediation

### Summary

Designed and shipped a new command system that diagnoses structural Claude Code permission-prompt failure modes across every settings file in the workspace and (with explicit operator approval) applies surgical remediations. Addresses the recurring Edit/Delete prompts that resisted six reactive patch commits since 2026-04-20. Four structural root causes were identified and translated into a 13-rule detection rulebook driven by a single source-of-truth template doc. Prevention wired into /new-project (canonical template emitted per project) and /friday-checkup (weekly dry-run). Four clean commits on main, pushed to origin.

### Files Created

- `docs/permission-template.md` — single source of truth for canonical permission shapes at each layer (user / workspace / ai-resources / project) + the 13-rule detection rulebook. Referenced by /permission-sweep and /new-project.
- `.claude/agents/permission-sweep-auditor.md` — Sonnet subagent (subagent-contract compliant: writes full notes to disk, returns ≤30-line summary) that walks all settings files and applies the rulebook.
- `.claude/commands/permission-sweep.md` — three-phase command (diagnose → operator approval gate per autonomy pause-trigger #8 → surgical jq remediation). Flags: `--dry-run`, `--fix-narrow`, `--skip-user-level`.
- `.claude/hooks/check-permission-sanity.sh` — SessionStart nudge that fires when defaultMode:bypassPermissions is missing or shadowed by settings.local.json. Tested against 5 known cases; all pass/nudge correctly.

### Files Modified

- `.claude/commands/new-project.md` — Post-Pipeline Enrichment step 2: CANONICAL_PERMS now includes `defaultMode: bypassPermissions`, `Edit(**/.claude/**)` + `Write(**/.claude/**)` dotfile-path globs, and `Bash(rm *)`. Added check-permission-sanity.sh as a second SessionStart hook alongside auto-sync-shared.sh.
- `.claude/commands/friday-checkup.md` — weekly tier Step 5 subsection F: runs `/permission-sweep --dry-run` once per checkup (workspace-wide, not per-scope); CRITICAL findings roll into consolidated Friday report.
- `.claude/settings.json` — self-heal: added `Bash(*)`, `Bash(rm *)`; expanded deny to include `Bash(rm -rf *)`, `Bash(sudo *)`, `Bash(git push*)` as universal safety floor.
- `CLAUDE.md` — new "Permission Management" section pointing at the template doc and `/permission-sweep`.

### Decisions Made

**/permission-sweep command design:**
- Named `/permission-sweep` (not `/diagnose-permissions` or `/fix-permissions`). Rationale: "audit" is overloaded in the workspace (3+ existing /audit-* commands); "sweep" signals durable-cleanup intent and pairs naturally with /fewer-permission-prompts (structural vs. empirical).
- Single command with three phases, not two separate commands. Rationale: pause-trigger #8 requires operator approval between diagnose and remediate anyway; splitting forces the operator to remember the pairing; one command, one mental model.
- Subagent does diagnosis only; remediation via jq stays in main session. Rationale: subagent contract requires summary return; remediation needs pause-trigger #8 gate in main session.
- Composes with `/fewer-permission-prompts` rather than replacing it. Rationale: different detection modes (structural rulebook vs. empirical transcript scan); conflating them would bloat a tightly-scoped skill.

**Canonical template:**
- Added `Bash(rm *)` to canonical project allow. Rationale: fixes the Delete/Remove prompts operator reported; `Bash(rm -rf *)` stays on deny (narrow vs. destructive tradeoff accepted).
- SessionStart sanity hook NOT added to ai-resources/.claude/settings.json. Rationale: ai-resources already has `defaultMode: bypassPermissions`, so the hook would pass silently — operator rejected the addition as noise.

### Next Steps

- Run `/permission-sweep` in a fresh session. It will scan all 16 settings files, report findings in plain language, and (on approval) apply remediations. This is the step that actually fixes the currently-active Edit/Delete prompts across other projects.
- After remediation, `/clear` and test in a few projects: Edit a file, delete a file — expected silent behavior.
- Optional follow-ups (not blocking):
  - Cross-reference line in `fewer-permission-prompts` SKILL.md (no SKILL.md folder yet; defer until that skill graduates to ai-resources/skills/).
  - Narrow `/audit-repo`'s settings-auditor to defer to `/permission-sweep`.

### Open Questions

None. Permission-sweep is ready to run.

## 2026-04-24 — Fix working tree (cleanup pass)

## 2026-04-24 — Commission v4 Batch 1 — /risk-check command + agent + audit-discipline + workspace CLAUDE.md edit

Plan: `/Users/patrik.lindeberg/.claude/plans/here-s-an-idea-i-memoized-bumblebee.md`
Scope: Batch 1 only (not Batches 2–5).

### Summary

Built `/risk-check` as a pre-execution gate for structural change classes (hook edits, permission changes, cross-cutting CLAUDE.md edits, new commands/skills, new symlinks, automation with shared-state effects). The command takes a free-text change description, delegates to an Opus subagent (`risk-check-reviewer`) with fresh context, and produces a verdict — GO / PROCEED-WITH-CAUTION / RECONSIDER — across five risk dimensions (usage cost, permissions surface, blast radius, reversibility, hidden coupling). Landed the authoritative class list and verdict semantics in `docs/audit-discipline.md`, and added a new pause-trigger #9 to workspace `CLAUDE.md` Autonomy Rules. QC cycle: REVISE → 3 Do fixes applied (OMIT-contract validation, `AI_RESOURCES` path ordering, mitigation-count alignment) → post-edit QC GO. Functional verification ran on a synthetic PreToolUse logging hook, producing PROCEED-WITH-CAUTION with three paired mitigations.

### Files Created

- `ai-resources/.claude/commands/risk-check.md` — the `/risk-check` command (Opus); 6 steps, 21 items; input validation → path setup → subagent spawn → structural validation (enforces OMIT contract + `max(1, NUM_HIGH)` mitigation count per verdict) → operator summary → no-auto-commit semantics
- `ai-resources/.claude/agents/risk-check-reviewer.md` — supporting subagent (Opus); 9 steps; evaluates 5 dimensions with heuristic Low/Medium/High thresholds; synthesizes verdict; writes structured report; returns ≤20-line summary with `REPORT:` last-line marker
- `ai-resources/audits/risk-checks/2026-04-24-add-a-new-pretooluse-hook-that-logs-every-write-tool.md` — dogfood report from functional verification (PROCEED-WITH-CAUTION; 3 Medium dimensions; 3 paired mitigations)

### Files Modified

- `ai-resources/docs/audit-discipline.md` — added `## Risk-check change classes` section (authoritative class list + verdict semantics + invocation semantics + overlap with top-3 analysis); extended the "When to read this file" line
- `CLAUDE.md` (workspace root, separate repo) — added pause-trigger #9 to `## Autonomy Rules` listing the risk-check change classes and verdict honor rule; explicit note that #8 and #9 can both apply to audit-derived permission changes
- `ai-resources/logs/session-notes.md` — this entry

### Decisions Made

Pre-execution (operator-confirmed at batch opening):
- Assumption sign-offs per plan handoff notes: accepted defaults for `/friday-act` name, `audits/risk-checks/` subdirectory, change classes list, coaching-log untouched

Design (during build):
- Subagent-writes-report pattern (main session reads returned summary + validates structure) — matches ai-resources CLAUDE.md Subagent Contracts convention
- Command does NOT auto-commit the report — operator bundles it with the change commit if wanted. Separates the pre-execution gate from the change itself.
- No auto-firing hook for `/risk-check` (no SessionStart / Stop / PreToolUse). Operator-invoked or inline-invoked by other commands (e.g., `/friday-act` in Batch 2). Rationale: auto-firing would over-escalate on ordinary edits.

Harness-level configuration (pause-trigger #8 gate — completed):
- Top-3-commands-affected analysis for workspace `CLAUDE.md` edit: `/create-skill`, `/new-project`, `/friday-checkup` (+`/friday-act` when Batch 2 lands). None blocked or degraded — edit is additive.

QC-driven fixes (routine auto-loop, applied after triage):
- Enforce OMIT contract in command Step 4 (verdict GO → neither optional section has content; PROCEED-WITH-CAUTION → no Recommended redesign; RECONSIDER → no Mitigations)
- Resolve `AI_RESOURCES` path-ordering (moved path extraction from Step 1 to Step 2 after `AI_RESOURCES` is defined)
- Mitigation-count alignment: command now requires `max(1, NUM_HIGH)` mitigation bullets for PROCEED-WITH-CAUTION, mirroring the agent's "≥1 per High dimension" generation rule
- Park: agent's unused `Bash` tool grant (low consequence); slug-truncation edge case documentation (fallback already works)

Commit split:
- Two commits — `ai-resources` (`178f127`) and workspace parent (`03ec193`) — because the batch spans two repos. Each commit references the other in its body. Plan's "one commit per batch" adjusted to "one commit per batch per repo."

### Next Steps

- **Push** `ai-resources` `178f127` and workspace parent `03ec193` (both on `main`) — requires operator approval.
- **Batch 2** in a fresh session: `/friday-act` command + tier-differentiated `/friday-checkup` output (weekly tactical / monthly policy / quarterly architectural). Plan handoff notes say this is the largest batch — full session on its own. Inline `/risk-check` invocation on risky fixes is the primary dogfood hook.
- **First real `/risk-check` invocation** in a new session will resolve the named `risk-check-reviewer` subagent_type directly (agent registration happens at session start; this session used `general-purpose` with the agent body inlined for verification).
- **Pacing:** plan handoff says don't attempt more than 2 batches per session. Batch 2 alone is a full session.

### Open Questions

- None. Remaining batches (2–5) have their own sign-off gates at the top of each batch per plan handoff notes.

## 2026-04-25 — Working-tree drift prevention (5 fixes landed)

### Summary

Followup to the 2026-04-24 cleanup-worktree session, which uncovered four benign-but-symptomatic issues tracing to two structural gaps: session-end hygiene (uncommitted edits and unstaged finished files surviving across sessions) and canonical-state drift (settings.json deny entries silently regressing; denied scratchpad directory not gitignored). Operator also flagged that they ran /cleanup-worktree while a concurrent Claude Code session was active and asked for a programmatic guardrail. Designed and landed five preventative fixes (F1–F5); G1/G3/G4 deferred as opportunistic.

### Files Created

- `audits/risk-checks/2026-04-25-f2-add-a-concurrent-session-detection-and-abort-to-cleanup.md` — risk-check report on F2 (verdict RECONSIDER → operator-disclosure redesign)
- `audits/risk-checks/2026-04-25-f3-g5-two-bundled-edits-to-workspace-claude-md.md` — risk-check report on F3+G5 (verdict PROCEED-WITH-CAUTION; G5 dropped per recommendation)
- `audits/working/qc-f2-cleanup-worktree-disclosure-2026-04-25.md` — post-edit QC report for F2 (gitignored)

### Files Modified

- `.claude/commands/cleanup-worktree.md` — F2: mandatory operator-disclosure prompt at Step 1; refuses to run if another Claude Code session is active (commit d2d1b15)
- `../CLAUDE.md` (workspace root) — F3: extends "Concurrent-session staging discipline" to name /cleanup-worktree and /permission-sweep as the dangerous commands (commit bcf45a9 in workspace-root repo)
- `.claude/hooks/check-permission-sanity.sh` — F4: SessionStart hook now asserts safety-floor deny entries Bash(rm -rf *) and Bash(sudo *); nudges if missing (commit 5a45d37)
- `docs/permission-template.md` — F5: adds Rule 14 to detection rulebook (gitignore-vs-deny parity for Read denies); ADVISORY severity (commit 8fd7435)
- `.claude/agents/permission-sweep-auditor.md` — F5: rule count 13→14 in three places (commit 8fd7435)
- `.claude/commands/wrap-session.md` — F1+G2: new Step 13a working-tree dirt check; surfaces dirty paths not produced this session, asks per-path disposition (commit/defer-WIP/ignore), nudges toward /cleanup-worktree if any deferred (commit 064e371)
- `logs/session-notes.md` — wrap entry appended; auto-archived by check-archive.sh (3 older entries moved out)
- `logs/session-notes-archive-2026-04.md` — archive file extended with 3 older April entries by check-archive.sh
- `logs/decisions.md` — wrap entry appended (5-point design-choices)
- `logs/coaching-data.md` — wrap entry appended

### Decisions Made

- **F2 redesign — operator disclosure over pgrep.** /risk-check returned RECONSIDER on the original mechanical-pgrep design (pgrep returned 12 matches in a single Claude Code session due to helper processes). Adopted the recommended redesign (option 1 in the report): a Step 1 disclosure prompt aligned with the existing CLAUDE.md "Concurrent-session staging discipline" pattern.
- **G5 dropped as redundant.** F3 already documents the rule in the discipline section; adding /cleanup-worktree to Autonomy Rules pause-triggers would duplicate without adding load-bearing semantics. Risk-check report flagged this redundancy.
- **F5 severity ADVISORY (plan said HIGH).** Existing rulebook taxonomy: HIGH = Delete/Edit prompts; this is hygiene (no live or future prompt). ADVISORY fits the existing severity structure.
- **Stop after the core five.** G1 (stale-edit SessionStart hook), G3 (cleanup-worktree marker file), G4 (friday-checkup stale-work item) deferred. Core five cover both failure classes from the 2026-04-24 incident; G items are nice-to-have additions.
- **Reduced /risk-check ceremony mid-session.** Operator pushback on overcomplication. After F3+G5 risk-check, skipped /risk-check on F4 and F5 — both small extensions to existing files (validation lines added to a hook, new check class added to an auditor), not new structural infrastructure.

### Next Steps

- **Push when ready** — workspace-root has commit `bcf45a9`; ai-resources has commits `d2d1b15`, `c52807e`, `5a45d37`, `8fd7435`, `064e371`. Two repos to push.
- Optionally pick up G1 / G3 / G4 in a future session if the core five turn out to be insufficient.
- F1 (wrap-session dirt check) is being exercised right now — this is the first invocation of /wrap-session after F1 landed. If anything in Step 13a feels off, log it as friction.

### Open Questions

- None.
