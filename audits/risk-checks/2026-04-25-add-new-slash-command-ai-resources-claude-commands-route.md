# Risk Check — 2026-04-25

## Change

add new slash command ai-resources/.claude/commands/route-change.md (lightweight non-mutating routing advisor; reads docs/repo-architecture.md + relevant CLAUDE.md files; no subagent, no audit output, no file writes) and new process doc ai-resources/docs/repo-architecture.md (hand-maintained Stage 1 architecture map; consulted by /route-change and operators; no automation, no hooks, no permissions changes)

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/route-change.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/repo-architecture.md — exists

## Verdict

GO

**Summary:** Two new isolated artifacts (one operator-invoked advisory command, one load-on-demand process doc) with no permission changes, no hooks, no auto-load wiring, no shared-state writes — clean append to the repo with all five dimensions Low.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- `route-change.md` declares `model: sonnet` (line 2) and is a slash command, not auto-loaded — pay-as-used per operator invocation.
- `repo-architecture.md` is a process doc under `docs/` (250 lines), explicitly load-on-demand per its own preamble: "Whenever you propose adding, moving, or restructuring an AI resource" (line 3). Not @-imported into any always-loaded CLAUDE.md.
- Grep confirms no `@imports` or auto-loads referencing either new file outside the two example mentions in `risk-check.md` line 11 (a literal example string) and `innovation-registry.md` line 87 (a detection log entry). No always-loaded file additions.
- No new hook, no SessionStart/Stop/PreToolUse registration. Workspace `.claude/settings.json` SessionStart/Stop entries are unchanged (verified by inspection).
- Command brief is 122 lines; subagent does not spawn (Step 5: "No Commit, No Execution"), so the brief loads only into the main session when the operator types `/route-change`.

### Dimension 2: Permissions Surface
**Risk:** Low

- Change description states "no permissions changes" verbatim.
- `route-change.md` performs only Read operations on existing in-repo paths (`docs/repo-architecture.md`, `CLAUDE.md` files at known layers, optionally a handful of named docs in `{AI_RESOURCES}/docs/`). All within the existing repo's already-allowed Read scope.
- No Bash invocation patterns, no Write, no Edit, no external API, no MCP, no cross-repo writes. Step 5 ("No Commit, No Execution") explicitly forbids file writes and pipeline invocations.
- No `settings.json` edits in this change.

### Dimension 3: Blast Radius
**Risk:** Low

- Files touched directly: 2 (both new — no edits to existing files).
- Grep across `ai-resources/` for `route-change`: 6 hits across `.claude/commands/route-change.md` (the file itself), `.claude/commands/risk-check.md` line 11 (literal example, no functional dependency), `docs/repo-architecture.md` (the new architecture doc, references its sibling), `logs/innovation-registry.md` line 87 (auto-detection log), `logs/session-notes.md`, `logs/session-notes-archive-2026-04.md` (session telemetry).
- Grep for `repo-architecture`: 6 hits — same set; the architecture doc is referenced by the new command and by session logs only. No existing command, agent, hook, or skill depends on it.
- Workspace-level grep (outside ai-resources): no hits — the change is contained to ai-resources.
- No contract change: this is greenfield. No caller exists yet to break.
- Auto-wiring is OFF (CHANGE description: "Auto-wiring into other pipelines is OFF"; route-change.md line 17: "This command is **not** auto-wired into `/create-skill` or any other pipeline. Operator-invoked only.").
- The auto-sync hook (`auto-sync-shared.sh`) will symlink `route-change.md` into every project's `.claude/commands/` on next SessionStart per the documented topology in `repo-architecture.md` lines 117–130. This is the standard distribution mechanism for new commands and is not an exceptional blast — it matches established pattern.

### Dimension 4: Reversibility
**Risk:** Low

- Both files are new, in the working tree only (not yet committed per the gate context). `git revert` of the eventual commit will fully remove them.
- No log mutations beyond the auto-detected entry in `logs/innovation-registry.md` line 87 (which is itself reversible by editing the line out — single-line append, not a structural change).
- No symlinks created in this change directly. The auto-sync hook will create symlinks into projects on next SessionStart, but those symlinks are auto-managed (regenerated/cleaned per hook logic) and removing the source file removes the symlink target — the hook's "existing files at the target are never overwritten" rule means stale symlinks would point to a missing source, but the hook itself is the cleanup mechanism on next sync after revert.
- No external pushes, no Notion writes, no API POSTs, no settings.json mutations.
- No automation registered (no hook, no cron).

### Dimension 5: Hidden Coupling
**Risk:** Low

- `route-change.md` declares its dependencies explicitly in Step 2 (lines 33–47): `repo-architecture.md`, the three-layer CLAUDE.md, and a named list of conditional docs (`permission-template.md`, `model-routing.md`, `agent-tier-table.md`, `audit-discipline.md`, `ai-resource-creation.md`). All are existing canonical sources — no implicit assumptions.
- `route-change.md` Step 3 item 11 explicitly delegates the risk-check class list to `audit-discipline.md` ("the canonical source — do not maintain an inline copy of the list here") — this is good coupling discipline, not hidden coupling.
- No silent auto-firing: the command runs only when the operator invokes it.
- No new contract introduced beyond the recommendation output schema in Step 4 (lines 85–110), which is documented at the change site.
- No functional overlap with existing commands. `/route-change` is advisory-only; `/create-skill`, `/improve-skill`, `/migrate-skill`, `/new-project` remain the mutating pipelines. The relationship is "consult before invoking" (line 15), not duplication.
- The architecture doc names itself as the contract for placement decisions (line 3) and lists its own update triggers (lines 225–235). Self-documenting.
- One minor note: the upward-walk fallback in Step 2 item 3 ("from the current working directory, walk upward until a directory named `ai-resources/` is found") is documented as "mirrors the upward-walk in `ai-resources/.claude/hooks/auto-sync-shared.sh`" — this is an explicit cross-reference to an existing convention, not silent coupling.

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references in `route-change.md` lines 2, 5, 15, 17, 33–47, 85–110; `repo-architecture.md` lines 3, 117–130, 225–235; grep counts across ai-resources and workspace; verbatim quotes from CHANGE_DESCRIPTION). No training-data fallback was used.
