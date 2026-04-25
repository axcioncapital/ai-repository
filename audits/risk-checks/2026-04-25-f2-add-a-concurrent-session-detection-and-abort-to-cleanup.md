# Risk Check — 2026-04-25

## Change

F2 — Add a concurrent-session detection and abort to /cleanup-worktree.

Proposed change: Extend Step 1 (Verify prerequisites) of `.claude/commands/cleanup-worktree.md` (around line 16). Add a check that uses pgrep (or equivalent) to detect other Claude Code processes running on the same machine. If any are detected, list their PIDs and abort with a message instructing the operator to wrap or kill the other session(s) before re-running. No override flag.

Why: On 2026-04-24 the operator ran /cleanup-worktree while a concurrent Claude Code session was active on the same repo. /cleanup-worktree commits and untracks files; running it concurrently risks clobbering the other session's work. The operator did not know this was risky and asked for a programmatic guardrail. The plan is at /Users/patrik.lindeberg/.claude/plans/make-a-plan-for-wiggly-volcano.md (item F2).

Scope: single file edit (`.claude/commands/cleanup-worktree.md`), one new step in Step 1's prerequisites block. No hook edits, no settings changes, no new permissions.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/cleanup-worktree.md — exists
- /Users/patrik.lindeberg/.claude/plans/make-a-plan-for-wiggly-volcano.md — exists

## Verdict

RECONSIDER

**Summary:** Single-file edit with low usage cost and small blast radius — but the proposed detection mechanism is structurally broken on this machine: `pgrep -fl 'claude' | grep -v $$` returns 12 matches in what is plausibly a single Claude Code session, so a no-override mechanical abort would block every invocation; this is a High Reversibility risk (operator-facing breakage, no override) with no viable in-scope mitigation that preserves the stated "no override flag, mechanical abort" contract.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- Change is pay-as-used: `/cleanup-worktree` is operator-invoked, not an always-loaded file. The proposed prereq step adds ~5–10 lines to `.claude/commands/cleanup-worktree.md` (currently 163 lines) — only paid when the command runs, which is a low-frequency dedicated session ("Cleanup is a dedicated session, not a sidebar" — `cleanup-worktree.md:162`).
- No `@import`, no auto-load hook, no SessionStart trigger introduced. Plan F2 explicitly states "No hook edits, no settings changes, no new permissions" (CHANGE_DESCRIPTION).
- Subagent briefs spawned by the command (`qc-reviewer`, `triage-reviewer`) do not receive the new Step 1 content; they read `PLAN_PATH` per `cleanup-worktree.md:65,77`.

### Dimension 2: Permissions Surface
**Risk:** Low

- No allow/deny entry added or removed. `Bash(*)` is already in the ai-resources allow list (`.claude/settings.json` line 41), so `pgrep` invocation requires no new permission.
- No tool family newly authorized. No scope escalation (project → user) or cross-repo capability.
- CHANGE_DESCRIPTION explicitly: "No hook edits, no settings changes, no new permissions."

### Dimension 3: Blast Radius
**Risk:** Low

- Single file directly touched: `ai-resources/.claude/commands/cleanup-worktree.md`.
- Callers grep across `ai-resources/` references to `cleanup-worktree`: 18 matches across docs, audits, logs, the SKILL.md, and the `friday-checkup` command. None call into Step 1 programmatically — references are documentation/log mentions ("Consider `/cleanup-worktree` next session"), not a contract dependency.
- The skill file `skills/worktree-cleanup-investigator/SKILL.md:60` notes: "The `/cleanup-worktree` command re-numbers these as Steps 1–11" — adding a sub-numbered prereq inside Step 1 (e.g., 1.4) does not change the workflow-ordinal mapping the skill describes.
- No contract changes to subagent input schemas, report headings, or hook output shape.

### Dimension 4: Reversibility
**Risk:** High

- Git revert on a single .md file is mechanically clean. **However**, the change ships a no-override mechanical abort — and direct test on this machine shows `pgrep -fl 'claude' | grep -v $$` returns **12 matches** (verbatim count from `pgrep -fl 'claude' 2>&1 | grep -v "$$" | wc -l` run in this evaluation environment), of which **12** are `anthropic.claude-code` native-binary processes. These are not separate user-facing sessions — Claude Code routinely spawns helper/subagent processes, and VSCode caches multiple binary versions (2.1.118 and 2.1.119 both visible in the live process list).
- Consequence: with the change as specified, every invocation of `/cleanup-worktree` on this machine would mechanically abort with no override flag — the command becomes unusable. The operator's recovery path is to manually edit `.claude/commands/cleanup-worktree.md` mid-incident or `git revert` the change.
- The plan file (`make-a-plan-for-wiggly-volcano.md:39`) acknowledges the false-positive scenario but waves it off: "If a false positive ever blocks the operator (unlikely), they can edit the check." Direct evidence shows this is not unlikely — it is the default.
- "Reversibility" here is not just "can git revert restore the prior state" (yes) but "can the operator recover quickly when the check misfires under field conditions" — and the answer is no without a code edit, because the no-override contract removes the runtime escape hatch.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Implicit dependency on a stable definition of "what counts as another Claude Code session." The pgrep pattern `'claude'` is broad enough to match the current process's own subagent helpers, VSCode-extension cached binaries, and any other tool with `claude` in its argv (e.g., a future `claude-cli` variant). The plan does not specify a narrower regex (e.g., distinguishing the session's own PID family via parent-PID walking).
- Hidden coupling to host environment: behavior differs between macOS (BSD pgrep, supports `-fl`) and Linux (procps pgrep, also supports `-fl` but with subtly different argv quoting). Plan says "or equivalent macOS pattern" but does not commit to one.
- Functional overlap with the existing CLAUDE.md "Concurrent-session staging discipline" rule (workspace `CLAUDE.md:177–179`) which already governs the same failure class via operator disclosure. The new mechanical check and the existing operator-disclosure rule will both attempt to handle "concurrent session present" — one programmatic, one declared. If they disagree (operator has not disclosed but pgrep fires; or operator has disclosed but pgrep does not see it because the other session is on a different host or in a hung state), the contract for which wins is not documented at the change site.
- Sibling proposal G3 in the same plan (`make-a-plan-for-wiggly-volcano.md:98–100`) introduces a marker-file mechanism with explicit "defense in depth alongside F2 (handles the case where pgrep misses a session, e.g., it's idle in a hung state)" — i.e., the plan itself acknowledges F2's coverage is incomplete.

## Recommended redesign

- **Replace mechanical abort with operator-disclosure prompt + soft warning.** Instead of running pgrep in Step 1, prompt the operator at Step 1: "Is any other Claude Code session active on this repo or machine? (yes / no)". If yes, abort with the same message. If no, proceed. This aligns with the existing workspace `CLAUDE.md:177–179` pattern (operator-disclosure-driven), removes the pgrep false-positive class entirely, preserves zero permission/hook surface, and keeps the change a single-file edit.
- **If a programmatic check is still desired, narrow the detection contract before landing.** Specify the exact pgrep regex (e.g., excluding the current process's own subagent tree by walking parent PIDs, or matching only `--session-id` argv patterns), commit to macOS-specific behavior in the change, and provide an environment-variable override (e.g., `CLEANUP_WORKTREE_SKIP_SESSION_CHECK=1`) so a misfire does not require editing the command file mid-incident. This mitigates Reversibility to Medium and Hidden Coupling to Low — but expands scope beyond "single file edit, one new step" and warrants a re-scoped plan item, not the F2 as currently written.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from `cleanup-worktree.md`, plan file, ai-resources `settings.json`, and workspace `CLAUDE.md`; live pgrep output captured during evaluation (12 `anthropic.claude-code` matches in a plausibly single-session environment); grep counts for cross-references to the touched command. No training-data fallback was used.
