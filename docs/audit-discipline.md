# Applying Audit Recommendations

> **When to read this file:** Before applying a permission change, model-default change, or frontmatter change derived from an audit (`/token-audit`, `/repo-dd`, `/audit-repo`, `/audit-claude-md`, or similar); OR before landing a structural change in any of the classes listed under `Risk-check change classes` below.

Audits produce recommendations based on static file counts, structural patterns, and reference-spec comparison. They do not model runtime command behavior. Recommendations are not specs — applying them verbatim can silently break live workflows.

Before applying a permission change (`permissions.allow` / `permissions.deny`), model-default change, or frontmatter change derived from an audit:

1. List the top-3 commands most affected by the change (command names + the paths they routinely Read or invoke).
2. For each listed command, confirm that the planned change does not block or degrade its normal behavior. Evidence: inspect the command body, or run the command once in a smoke-test session if behavior is unclear.
3. If a conflict surfaces, narrow the change to preserve the command's behavior and note the narrowing in the commit message.

This is a bright-line rule — do not skip even when the audit tags a recommendation as "quick win" or "low risk." The friction of checking is low; the cost of silently breaking an active command is high.

## Risk-check change classes

If a session touches a structural change in any of the following classes, run `/risk-check` at two session boundaries (not per-change — see *When to fire* below):

- Hook edits (`.claude/hooks/*.sh`)
- Permission changes (`settings.json` `allow` / `ask` / `deny` edits)
- CLAUDE.md edits that are cross-cutting (workspace-level or project-level always-loaded content that shapes every turn)
- New commands or skills
- New symlinks
- Automation with shared-state effects (scripts that auto-write to logs, cross-repo writes, auto-commit patterns)

For change classes outside this list, `/risk-check` is optional — operators can still invoke it when a change feels risky.

### When to fire (two-gate model)

- **Plan-time gate** — once, after the plan is approved, if the planned work touches any class above. The `$ARGUMENTS` payload describes the *design* (e.g., "edit hook X to add Y; allow Bash(rg:*) in workspace settings"). Catches design risk before tokens are spent on execution.
- **End-time gate** — once, before commit, batched across every in-class change the session actually made. The `$ARGUMENTS` payload describes the *executed* change set. Catches drift, emergent coupling, and scope creep that the plan-time gate didn't surface.

Sessions without an explicit plan (auto-mode quick fixes, single-file edits) skip the plan-time gate and run only the end-time gate. Sessions that touch no class skip both gates.

Each gate fires once per session. Mid-session re-invocation of `/risk-check` is operator-discretionary, not required by this rule. The point of the two-gate model is to avoid per-change firing — that pattern multiplied tokens without proportionate signal.

### Verdict semantics

- **GO** — proceed with the change as planned.
- **PROCEED-WITH-CAUTION** — proceed but apply the paired mitigations listed in the report before the change lands. Do NOT land the change without applying the mitigations. Note the mitigations in the commit message.
- **RECONSIDER** — redesign before proceeding. Re-invoke `/risk-check` after the redesign. Do NOT downgrade the verdict to push the change through.

### Invocation semantics

`/risk-check` is operator-invoked (manually typed slash command) or inline-invoked by other commands such as `/friday-act`. There is no auto-firing hook — this is a discipline enforced by this file, the workspace `CLAUDE.md` Autonomy Rules, and the commit review loop.

### Overlap with the top-3 analysis

An audit-derived permission change triggers BOTH requirements:

- the top-3-commands-affected analysis (above), AND
- `/risk-check` (this section).

These are complementary, not redundant: the top-3 analysis confirms the audit's recommendation does not break existing commands; `/risk-check` evaluates the broader risk posture (usage cost, permissions surface, blast radius, reversibility, hidden coupling) of the planned change as a whole.
