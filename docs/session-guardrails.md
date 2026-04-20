# Session Guardrails

> **When to read this file:** For the full trigger enumeration, exempted-command list, and tuning procedure behind the four advisory flags. The flag names and one-line purposes live in workspace CLAUDE.md; details live here.

Four advisory flags surface session-risk signals in chat so the operator can decide whether to proceed. These are self-enforcement rules — no hook, no hard gate, no named confirmation phrase. When a trigger fires, emit the named flag in a single line and wait for the operator's one-word response (e.g., "proceed", "narrow", "clear", "/clarify").

Flag tags are stable, parseable strings: `[HEAVY]`, `[SCOPE]`, `[AMBIGUOUS]`, `[COST]`. Use them verbatim so future telemetry can count fire rates.

**Exempted commands** (for `[HEAVY]` and `[COST]` only — these commands are intentionally context-heavy or multi-subagent by design, and flagging their internal execution is flag-fatigue without signal):
`/token-audit`, `/repo-dd`, `/audit-repo`, `/analyze-workflow`, `/cleanup-worktree`, `/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project`, and research-workflow pipeline commands (`run-preparation`, `run-execution`, `run-cluster`, `run-analysis`, `run-synthesis`). When executing inside one of these commands, do not fire `[HEAVY]` on its internal reads/greps/subagent spawns, and do not fire `[COST]` on its internal fan-out.

## `[HEAVY]` — pre-heavy-tool-call and pre-delegation

Fire *before* the tool call, not after. Triggers:
- `Read` with no `limit` on a file known to exceed 500 lines
- `Grep` with a broad pattern, no `glob`/`type` filter, and no `head_limit` below 100
- `Bash` that enumerates a large directory (`ls -R`, recursive `find`, unfiltered `git log`)
- Spawning ≥3 subagents in parallel in a single turn
- A subagent brief that inlines >3 large files or whose expected output exceeds ~10k tokens

Skip outside the exemption list when the action is clearly routine (targeted Grep, single known small file Read, one Explore subagent on a scoped question).

Flag format: `[HEAVY] About to {action}. Signal: {which trigger}. Estimated cost: ~{tokens or "large"}. Proceed, narrow, or skip?`

## `[SCOPE]` — scope-creep against the exit condition

Fire when work is drifting past the exit condition set at `/prime`. Triggers:
- Operator introduces a new task mid-session ("also do X", "while you're at it")
- You propose work outside the exit condition's scope
- A mid-session scope extension has already happened once (second extension = flag harder)

`[SCOPE]` only fires when an exit condition is logged in `ai-resources/logs/session-notes.md` for the current session. If `/prime` was not run (ad-hoc work), `[SCOPE]` is inactive — do not invent an exit condition to flag against.

Flag format: `[SCOPE] Exit condition was "{X from session notes}". New request: "{Y}". Update exit condition, defer to new session, or accept drift?`

## `[AMBIGUOUS]` — missing load-bearing specifics at task-naming

Fire at `/prime` step 6 or any task-naming moment if the brief is missing:
- A defined output (target file, success condition, acceptance criterion)
- A count/scope bound on plural nouns ("fix the issues", "update the skills")
- Definitions for terms whose interpretation materially changes scope

Default recovery is `/clarify` — do not silently adopt an assumption without surfacing it.

Flag format: `[AMBIGUOUS] Brief missing: {bullet list}. Run /clarify, state my assumption and proceed, or narrow the brief?`

## `[COST]` — cost-escalation mid-session

Fire when the session has already consumed significant budget and more work is being queued. Deterministic triggers only (Claude cannot reliably self-measure token % from inside the model):
- Session has spawned ≥4 subagents (excluding subagents spawned inside exempted commands)
- Session has crossed ~20 turns
- Session has written ≥8 artifacts

`[COST]` handles *when to flag*; the "Pre-compact checkpoint" bullet in workspace CLAUDE.md handles *what to do* (scratchpad + `/clear` over `/compact`).

Flag format: `[COST] Session has spent {subagent count} subagents / {turn count} turns / {artifact count} artifacts. Checkpoint + /clear + restart, or continue?`

## Tuning

Log false positives and missed fires to `ai-resources/logs/improvement-log.md`. After 5–10 sessions, review and tighten or loosen thresholds, or extend the exemption list. If `[HEAVY]` proves unreliable as a self-enforcement rule, promote it to a `PreToolUse` hook in a dedicated session — do not add hooks preemptively.
