# Risk Check — 2026-04-25

## Change

Commission Batch 2: new command ai-resources/.claude/commands/friday-act.md (Session 2 of Friday cadence — consumes /friday-checkup report; tier-differentiated decision shape; inline /risk-check gate; appends per-session block to logs/maintenance-observations.md including 7-axis posture targets); edits to ai-resources/.claude/commands/friday-checkup.md Step 6/7 (adds three tier-differentiated output sections: Tactical follow-ups with risk levels weekly+, Policy-level observations monthly+, Architectural retrospective quarterly only — data contract for /friday-act); new log file ai-resources/logs/maintenance-observations.md (seeded with header schema). No CLAUDE.md edits. No hook edits. No permission changes. No new symlinks. Maintenance-observations.md is append-only via /friday-act.

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-act.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/friday-checkup.md — exists
- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/logs/maintenance-observations.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Operator-invoked, non-auto-firing additions with no permission/hook/CLAUDE.md changes; the chief residual risk is a renamed `friday-checkup` section heading that creates a hard-parse contract between the two commands and one stale prior-week artifact.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Low

- New commands are operator-invoked only — no auto-load. `friday-act.md` line 222: "Auto-firing without consent is not permitted." `friday-checkup.md` is also operator-invoked (already established prior).
- No hook registration in any of the three referenced files (grep `friday-checkup`/`friday-act`/`maintenance-observations` returned no `.sh` hook files).
- Commission states explicitly: "No CLAUDE.md edits. No hook edits." — no addition to always-loaded files.
- `maintenance-observations.md` is 18 lines, only read at `/friday-act` invocation time; not auto-imported.
- Token cost is pay-as-used and bounded by Friday cadence (≤ once/week).

### Dimension 2: Permissions Surface
**Risk:** Low

- Commission states explicitly: "No permission changes."
- `/friday-act` Step 21 appends to `logs/maintenance-observations.md` and Step 3.f executes fixes via existing autonomy rules — no new tool family invoked. Inline `/risk-check` invocation goes through the existing Skill tool surface.
- No `allow` / `ask` / `deny` edits in any settings file referenced by the change.

### Dimension 3: Blast Radius
**Risk:** Medium

- Direct file touches: 3 (one new command, one edited command, one new log).
- Cross-references found via grep across `ai-resources/`:
  - `friday-checkup` referenced in 9 markdown files (CLAUDE.md, audits/friday-checkup-2026-04-24.md, .claude/commands/friday-checkup.md, .claude/commands/risk-check.md, logs/coaching-data.md, logs/usage-log.md, logs/innovation-registry.md, logs/session-notes.md, logs/decisions.md). Most are historical/log mentions; none parse the report's section headings except the new `/friday-act`.
  - `friday-act` / `maintenance-observations` referenced in 10 files — all are forward-looking commission-related artifacts, no live parser other than `/friday-act` itself.
- **Contract change:** `friday-checkup.md` Step 7 renames the report's `## Operator follow-ups` heading. Evidence:
  - `audits/friday-checkup-2026-04-24.md` line 40: literal `## Operator follow-ups` heading. This is the single existing report under the old contract; `/friday-act` Step 11 parses `## Tactical follow-ups` verbatim and Step 12 aborts on schema mismatch.
  - `logs/decisions.md` line 89 quotes `"Operator follow-ups"` as the historical naming — descriptive log entry, not a live parser.
- New contract is documented at the change site: `friday-checkup.md` lines 238–243 enumerate section presence by tier and state "`/friday-act` parses these section headings verbatim. Do not rename them."
- No caller of `/friday-checkup` requires modification. Only the human reader of the prior report sees the rename, and the next `/friday-checkup` run regenerates a fresh report under the new contract.

### Dimension 4: Reversibility
**Risk:** Medium

- Two of the three artifacts (`friday-act.md`, `maintenance-observations.md`) are new files — `git revert` removes them cleanly.
- `friday-checkup.md` Step 6/7 edits revert cleanly via `git revert` since the change is in the working tree but not yet committed.
- **One non-clean cleanup vector:** `maintenance-observations.md` is declared append-only (commission line: "Maintenance-observations.md is append-only via /friday-act"; file line 16: "Do not hand-edit prior session blocks"). Once `/friday-act` runs and appends a block, a future revert of the command would leave orphan session blocks behind — but this is a forward risk, not present at this gate (no blocks have been appended yet).
- `wrap-session.md` Step 13a working-tree dirt check (confirmed via grep on .claude/commands/wrap-session.md line 60) will catch the unstaged `maintenance-observations.md` append for explicit operator disposition, so future appends won't silently propagate.
- The renamed section heading in `friday-checkup.md` requires no manual cleanup; the next `/friday-checkup` run regenerates the report.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **Schema-parse contract** between `/friday-checkup` Step 7 (writer) and `/friday-act` Step 11 (parser). `friday-act.md` line 44–48 parses three exact heading strings: `## Tactical follow-ups`, `## Policy-level observations`, `## Architectural retrospective`. Any future heading rename in `friday-checkup.md` will silently break `/friday-act` (it aborts with "schema mismatch" — at least the failure is loud). Contract is documented in `friday-checkup.md` lines 238–243; coupling is explicit, not hidden.
- **Tier presence rules:** `/friday-act` Step 11 expects `## Policy-level observations` iff `TIER ∈ {monthly, quarterly}` and `## Architectural retrospective` iff `TIER = quarterly`. `friday-checkup.md` Step 7 honors these rules (lines 219, 232: "Omit the heading entirely if TIER ∈ {weekly, monthly}"). Tier-presence contract is two-sided and consistent.
- **Stale prior artifact:** `audits/friday-checkup-2026-04-24.md` was written under the old contract (`## Operator follow-ups`). If the operator points `/friday-act` at that file via `$ARGUMENTS`, Step 12 aborts with "Tactical follow-ups missing from {REPORT_PATH}". Behavior is loud, not silent; recovery is to run a fresh `/friday-checkup`. But the 10-day staleness guard in Step 1.7 will catch this independently for the 2026-04-24 report once 10 days elapse.
- **`/risk-check` inline invocation contract:** `/friday-act` Step 3.c invokes `/risk-check` via the Skill tool. `risk-check.md` already accepts inline invocation per `audit-discipline.md` line 45 ("operator-invoked … or inline-invoked by other commands such as `/friday-act`"). Coupling is documented at both ends.
- **Coaching-log overlap:** `friday-act.md` Notes (line 224) explicitly disambiguates the seven autonomy axes from coaching-log's five session-pattern dimensions; the boundary is named, not silent.

## Mitigations

- **Blast radius (Medium):** Before landing, regenerate or annotate `audits/friday-checkup-2026-04-24.md` so an operator who points `/friday-act` at it gets a clear pointer. Lightest viable action: leave it as-is (it will fall outside the 10-day staleness guard within a week, and `/friday-act` aborts loudly on schema mismatch). Alternative: append a note to that report's preamble that the `## Operator follow-ups` section is now legacy under the prior contract. No-op also acceptable given the loud-failure behavior.
- **Reversibility (Medium):** Before the first `/friday-act` run lands an append to `maintenance-observations.md`, confirm `/wrap-session` Step 13a will capture the dirt for explicit disposition (already confirmed via grep on wrap-session.md line 60 — no further action needed; tracked here for explicit attestation).
- **Hidden coupling (Medium):** No additional action required; the parse contract is documented in `friday-checkup.md` lines 238–243 with the exact directive "`/friday-act` parses these section headings verbatim. Do not rename them." The coupling is explicit and self-warning. Optional: add a one-line cross-reference comment at the top of `/friday-act` Step 2 pointing back to that contract paragraph in `friday-checkup.md`.

## Recommended redesign

(omitted — verdict is PROCEED-WITH-CAUTION)

## Evidence-Grounding Note

All risk levels grounded in direct evidence (file/line references, grep counts, verbatim quotes from CHANGE_DESCRIPTION or referenced files). No training-data fallback was used on fetch/read failures.
