# Risk Check — 2026-04-25

## Change

change /risk-check trigger semantics from per-change to two-gate (plan-time + end-time) across three files: (1) workspace CLAUDE.md Autonomy Rules pause-trigger #9 reworded to fire at session boundaries instead of before each landing, (2) ai-resources/docs/audit-discipline.md § Risk-check change classes — added "When to fire (two-gate model)" subsection defining plan-time vs end-time payloads and skip rules for unplanned/no-touch sessions, (3) ai-resources/.claude/commands/risk-check.md — added "Two intended call sites per session" block above invocation semantics. Class list, verdict semantics, and risk-check-reviewer subagent unchanged. Motivation: per-change firing was multiplying tokens without proportionate signal during active work sessions.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/audit-discipline.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/risk-check.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** A net token-saving policy change (the whole point) but the rewrite expands the always-loaded workspace CLAUDE.md pause-trigger #9 from a single line to ~10 lines of policy detail, partially undermining the savings; one paired mitigation is required to lock in the net-positive token outcome.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change is *motivated* by reducing usage cost — quote: "per-change firing was multiplying tokens without proportionate signal during active work sessions." This is the right direction in principle: a session that previously fired `/risk-check` 3–5 times will now fire it 1–2 times.
- However, the workspace CLAUDE.md edit (always-loaded on every turn of every session) expanded pause-trigger #9 from a one-paragraph rule into a substantially longer paragraph: now 7 sentences spanning ~10 lines (CLAUDE.md:101) covering plan-time/end-time semantics, skip rules for unplanned and no-touch sessions, and verdict handling. Rough estimate: +120–180 tokens added to every-turn load.
- The two-gate runtime savings only accrue on sessions that actually trigger `/risk-check` (structural-change sessions, a minority of sessions). The CLAUDE.md token cost accrues on every turn of every session in the workspace.
- Net-positive token outcome is plausible but not guaranteed; depends on the ratio of structural-change sessions to total sessions. For a workspace where `/risk-check` fires only on a small fraction of sessions, the always-loaded surcharge could exceed the runtime savings.
- The audit-discipline.md and risk-check.md edits do NOT load on every turn — they load only when the relevant command/doc is read. Their token cost is pay-as-used and does not contribute to ongoing usage cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- No `permissions.allow`, `permissions.ask`, or `permissions.deny` entries added, removed, or modified.
- No new tool invocation patterns introduced. The change is purely policy-text editing across three markdown files.

### Dimension 3: Blast Radius
**Risk:** Low

- Three files modified, all already in scope of the existing `/risk-check` system. No new files created, no contracts to subagents changed.
- Grep across `ai-resources/.claude/` for `/risk-check` and `risk-check`: only `risk-check.md` (command) and `risk-check-reviewer.md` (agent) reference the command directly. No other commands inline-invoke `/risk-check`.
- `/friday-act` is named in both risk-check.md:30 and audit-discipline.md:45 as an inline-invoker but does not exist as a command file (`ls ai-resources/.claude/commands/ | grep -i friday` returns only `friday-checkup.md`). This is a pre-existing gap, not introduced by this change.
- `risk-check-reviewer` agent definition explicitly out of scope per the change description ("subagent unchanged") and confirmed: the agent definition contains no per-change-versus-two-gate logic — it evaluates whatever payload arrives in `CHANGE_DESCRIPTION`, regardless of whether the payload describes a single change or a batched set.
- The change description explicitly notes the executed `$ARGUMENTS` payload may now describe "every in-class change the session actually made" (audit-discipline.md:31). The reviewer agent already supports multi-change payloads (free-text input). No contract change required.

### Dimension 4: Reversibility
**Risk:** Low

- All three edits are inline policy-text changes within existing files. `git revert` of the landing commit fully restores prior state with no sibling files or generated artifacts to clean up.
- No log mutations, no append-only state changes, no external writes. The only side-effect of the change is that future operator behavior (when to invoke `/risk-check`) shifts; reverting the file change reverts the policy.
- One soft cleanup item if reverted: any in-flight session note or audit report that was written under the new two-gate model will reference policy semantics that no longer exist, but those are historical records and don't require active cleanup.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- The two-gate model relies on operator discipline to actually fire the gates at the right session moments (post-plan-approval, pre-commit). Unlike per-change firing — which is naturally prompted by the act of editing a file in a flagged class — gate-based firing has no obvious tactile trigger. Coupling is implicit on the operator's session rituals.
- The end-time gate is described as "before commit, batched across every in-class change the session actually made" (audit-discipline.md:31). This silently couples to whatever mechanism produces the payload — typically the operator's recall of what the session touched, or a session-note "Files Modified" list. No explicit machinery enforces the batching; if the operator forgets a touched file, the end-time `$ARGUMENTS` is incomplete and the reviewer cannot evaluate what it doesn't see.
- The "skip both gates if the session touched no class" rule (audit-discipline.md:33) places the classification burden on the operator/main agent during execution. A change that *seems* outside the listed classes but actually touches one (e.g., an "innocent" edit that turns out to be cross-cutting CLAUDE.md content) gets no gate at all under the new policy, where the per-change model would have caught it the moment the file was touched.
- `/wrap-session` and `/friday-checkup` are not updated by this change to remind the operator about the end-time gate. Existing wrap/checkup commands have no awareness of the new gate placement. (Not verified beyond the in-scope files; flagged as a coupling-likelihood signal.)
- Documentation is consistent across the three edited files — plan-time/end-time semantics, skip rules, and "not per-change" framing match between CLAUDE.md, audit-discipline.md, and risk-check.md. No conflicting wording detected.

## Mitigations

- **Dimension 1 (Medium): Trim workspace CLAUDE.md pause-trigger #9 back toward one-paragraph density.** Move the full plan-time/end-time/skip-rule prose to `audit-discipline.md` (where it is already authoritative) and leave only a 2–3 sentence summary plus the existing `Authoritative class list and verdict semantics: ...` pointer in CLAUDE.md. Target: net token reduction in always-loaded content versus the prior pause-trigger #9 wording, not net increase. This locks in the policy-change motivation rather than partially reversing it via the always-loaded surcharge.
- **Dimension 5 (Medium): Add an end-time gate reminder to `/wrap-session`.** A single line ("If the session touched a `/risk-check` class, run the end-time gate before committing — see `audit-discipline.md` § When to fire") gives the operator a tactile prompt at the natural session-boundary moment, reducing the coupling on operator memory. This is the smallest viable enforcement mechanism for the new gate placement and should land in the same commit (or as a fast-follow) so the policy doesn't ship without its trigger.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file paths and line numbers from the three referenced files, verbatim quotes from CLAUDE.md:101, audit-discipline.md:31/33/45, and risk-check.md:30, plus grep counts across `ai-resources/.claude/` and `ai-resources/`. No training-data fallback used.
