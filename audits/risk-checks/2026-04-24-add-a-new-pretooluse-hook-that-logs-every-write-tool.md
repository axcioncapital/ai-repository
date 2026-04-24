# Risk Check — 2026-04-24

## Change

add a new PreToolUse hook that logs every Write tool invocation to logs/tool-activity.log; the log is append-only; used for session replay and telemetry

## Referenced files

- None referenced

Note: No implementation files provided. Evaluation is based on the described intent (a PreToolUse hook matcher on `Write`, an append-only log file at `logs/tool-activity.log`, purpose = session replay and telemetry). Where specifics are unstated (hook script body, payload fields captured, rotation policy, scope path), dimensions flag the unresolved axis rather than assume a best case.

## Verdict

PROCEED-WITH-CAUTION

**Summary:** PreToolUse-per-Write adds unavoidable per-tool-call overhead and an append-only log that mutates with every session, which creates ongoing cost and reversibility drag; viable mitigations exist but must be specified before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- Matcher = `Write` fires on every Write tool call, not once per session. Write is a frequently-used tool across skills, commands, and ordinary prose work — `.claude/settings.json` currently has only one PreToolUse hook (`check-heavy-tool.sh`, matcher `Read|Grep|Bash`, evidence: `ai-resources/.claude/settings.json:69-81`). Adding a second PreToolUse matcher on `Write` is an additive per-tool-call cost, not an amortized per-session cost.
- Per-invocation cost depends on hook-script implementation, unspecified in the brief. The existing `check-heavy-tool.sh` spawns `python3` per call (evidence: `ai-resources/.claude/hooks/check-heavy-tool.sh:22`). A similar implementation would add a Python interpreter startup per Write — noticeable when Write is called in tight loops (e.g., `/create-skill`, `/migrate-skill`, research-workflow drafting).
- Hook outputs that populate `hookSpecificOutput.additionalContext` inject tokens into the transcript. If this hook emits context per-call (e.g., "[LOGGED] …"), token cost compounds across the session. If it writes silently to disk and exits 0 (recommended), token cost is zero and only wall-clock cost remains.
- Not an always-loaded file edit, so no CLAUDE.md / SKILL.md bloat — risk is on the tool-call axis only.

### Dimension 2: Permissions Surface
**Risk:** Low

- Current settings already grant `Write(logs/**)` and `Write(**/.claude/**)` broadly (evidence: `ai-resources/.claude/settings.json:19-38`), and `Bash(*)` (line 39) covers any shell-side append. No new permission entry is required for the hook to write `logs/tool-activity.log`.
- `defaultMode: "bypassPermissions"` (line 63) means the hook won't trigger permission prompts regardless.
- No deny rule is narrowed; no new tool family is introduced; no cross-repo or external capability is added.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: `ai-resources/.claude/settings.json` (add a PreToolUse entry) and a new `ai-resources/.claude/hooks/<name>.sh`. No existing hook script is modified.
- Grep enumeration for callers / dependents:
  - `grep -rln "tool-activity"` across the workspace returned zero hits — no existing skill, command, agent, or doc already assumes the log.
  - `grep -rln "PreToolUse"` under `ai-resources/` returned one match: `ai-resources/.claude/settings.json` itself. No skill or command programmatically inspects the PreToolUse array.
  - Existing PreToolUse hook (`check-heavy-tool.sh`) is independent and does not interact with the new hook.
- Contract change: none. The hook is observer-only from the agent's perspective (log-writer); no downstream skill currently consumes `logs/tool-activity.log`.
- Shared infra impact: the hook runs for every Claude Code session against this project directory — but only for this project. Not cross-project.

### Dimension 4: Reversibility
**Risk:** Medium

- `git revert` of the settings.json edit + hook script removes the hook cleanly, but `logs/tool-activity.log` is a side-effect file the commit never tracked. Revert leaves the log on disk; between landing and revert, any sessions that ran will have mutated it. This is exactly the "append-only log mutation revert can't cleanly undo" case in the rubric.
- Cleanup requires one extra step: `rm logs/tool-activity.log` (or truncate) after revert. Manageable, but not free.
- No state propagates beyond the local repo (no push, no external API). The log is local-disk-only.
- If the log is committed (brief doesn't specify whether `logs/tool-activity.log` is gitignored), revert behavior degrades further: historical log entries enter git history, and a rollback requires a rewrite, not just a revert. Brief should pin `.gitignore` treatment.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- Implicit dependency on `logs/` directory existence and write permission. `ai-resources/logs/` exists (verified via `ls`) so the immediate path is safe, but the hook will fail or silently swallow errors if run in a fresh clone where `logs/` has not been created yet. Specify creation-on-write or assert the invariant.
- Implicit dependency on the hook payload schema (tool_name, tool_input, transcript_path) that Claude Code passes to PreToolUse. The existing `check-heavy-tool.sh` already depends on this shape (evidence: `check-heavy-tool.sh:39-41`), so it is an established convention — but still a harness-level convention that could shift with a future Claude Code release.
- Functional overlap with telemetry already in the repo: `/usage-analysis` writes `logs/usage-log.md` at end-of-session (evidence: `ai-resources/CLAUDE.md` → Session Telemetry section). The new hook collects a different grain (per-tool-call) but the stated purpose — "session replay and telemetry" — overlaps the usage-log's role. The brief should state how `tool-activity.log` complements rather than duplicates `usage-log.md`, and whether `/usage-analysis` will ingest the new log.
- Silent auto-firing in unexpected contexts: the hook runs on every Write — including hook-internal Writes from other tooling, subagent Writes, and Writes inside exempted commands (e.g., `/token-audit`, `/create-skill`). The existing heavy-tool hook has an EXEMPT list for those commands (evidence: `check-heavy-tool.sh:25-30`). The new hook should decide explicitly whether to log during exempted commands — silent inclusion or silent exclusion are both surprising if undocumented.

## Mitigations

- **(Usage cost)** Implement the hook as a minimal shell append (`printf ... >> logs/tool-activity.log`) rather than spawning `python3`. Do NOT emit `hookSpecificOutput.additionalContext` — exit 0 silently so no tokens enter the transcript. Set `timeout: 2` in settings.json to cap per-call wall-clock exposure.
- **(Reversibility)** Add `logs/tool-activity.log` to `.gitignore` in the same commit so revert + `rm` fully restores state. Document the cleanup step (`rm logs/tool-activity.log`) inline in the hook script header so a future revert author sees it.
- **(Hidden coupling)** Explicitly document in the hook script header (a) the log format / field schema, (b) whether the hook logs during EXEMPT commands, and (c) how `tool-activity.log` relates to `usage-log.md` (complement vs. replace). If `/usage-analysis` will ingest it, pin that contract in `skills/session-usage-analyzer/SKILL.md` in the same PR. Add a `mkdir -p logs` guard at the top of the hook script so a fresh clone does not silently fail.

## Recommended redesign

_(Not required — verdict is PROCEED-WITH-CAUTION.)_

## Evidence-Grounding Note

All risk levels grounded in direct evidence: `ai-resources/.claude/settings.json` hook configuration (lines 19-38, 39, 63, 69-81), `ai-resources/.claude/hooks/check-heavy-tool.sh` implementation (lines 22, 25-30, 39-41), grep counts for `tool-activity` (zero hits) and `PreToolUse` (one hit, in settings.json), `ai-resources/CLAUDE.md` Session Telemetry section, and directory existence checks on `ai-resources/logs/`. No training-data fallback.
