# Risk Check — 2026-04-25

## Change

F3 + G5 — Two bundled edits to workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`).

**F3:** Extend the "Concurrent-session staging discipline" section (lines 177–179). Add one paragraph: `/cleanup-worktree` and `/permission-sweep` MUST NOT run while a concurrent Claude Code session is active on the same repo. Both act on shared state (git working tree, settings.json) and can clobber the other session's work. `/cleanup-worktree` enforces this via a mandatory operator-disclosure prompt at Step 1 (added in F2, commit d2d1b15); `/permission-sweep` relies on operator discipline.

**G5:** Update the "Autonomy Rules" pause-trigger list — add `/cleanup-worktree` to the operator-must-authorize list when a concurrent session is disclosed. Specifically extend the existing pause-triggers (one of triggers 1–9) or add a new bullet noting that the concurrent-session disclosure prompt's "yes" answer is a pause-trigger that always defers to operator judgment (no auto-decline-and-proceed).

Why: Closing the gap surfaced by the 2026-04-24 incident — operator ran /cleanup-worktree with a concurrent session active and didn't know it was risky. F2 added the programmatic prompt; F3+G5 documents the rule in the always-loaded CLAUDE.md so it's visible to the operator (and to Claude in any future session). The plan is at /Users/patrik.lindeberg/.claude/plans/make-a-plan-for-wiggly-volcano.md (items F3 and G5).

Scope: single file edit (workspace CLAUDE.md). No new conventions — extends existing sections. No hook edits, no settings changes, no new permissions. Two minor additions, bundled because they share the same risk-check class (cross-cutting CLAUDE.md).

## Referenced files

- /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md — exists
- /Users/patrik.lindeberg/.claude/plans/make-a-plan-for-wiggly-volcano.md — exists

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Single-file edit to always-loaded workspace CLAUDE.md with low permissions/blast/reversibility risk, but two Medium dimensions (Usage Cost from always-loaded token additions; Hidden Coupling from G5's intent to graft onto an already-numbered Autonomy Rules pause-trigger list) — both have viable paired mitigations the operator must apply before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- The change targets workspace CLAUDE.md (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`), which loads on every turn in every session under this workspace root. Token cost is paid per-session for the lifetime of the rule.
- F3's specified paragraph (verbatim from plan line 51): "`/cleanup-worktree` and `/permission-sweep` MUST NOT run while a concurrent Claude Code session is active on the same repo. Both commands act on shared state (git working tree, settings.json) and can clobber the other session's work. `/cleanup-worktree` will mechanically abort if it detects concurrent sessions; `/permission-sweep` relies on operator discipline." — approximately 60–75 tokens. Note: CHANGE_DESCRIPTION's wording adjusts "mechanically abort if it detects" to "enforces this via a mandatory operator-disclosure prompt at Step 1 (added in F2, commit d2d1b15)" — slightly longer (~15 tokens more) but still under 100 tokens for F3.
- G5 wording is not specified verbatim; CHANGE_DESCRIPTION says "extend the existing pause-triggers (one of triggers 1–9) or add a new bullet". Plausible bullet length: 30–50 tokens. Bundled F3 + G5 estimated total: ~100–150 tokens of always-loaded content.
- Aggregate falls within the Medium calibration band ("adds ~50–150 tokens to always-loaded files"). Workspace CLAUDE.md currently 187 lines (`wc -l` confirms); the additions are a roughly ~3–5% size increase — non-trivial but not High.
- No `@import`, no auto-load hook registration, no subagent brief expansion. The cost is purely additive prose in the always-loaded file.

### Dimension 2: Permissions Surface
**Risk:** Low

- No allow/deny entry added or removed. CHANGE_DESCRIPTION explicit: "No hook edits, no settings changes, no new permissions."
- No tool family newly authorized; no glob widening; no scope escalation. The change is purely documentation/rule prose in CLAUDE.md.
- No introduction of any tool invocation pattern.

### Dimension 3: Blast Radius
**Risk:** Low

- Single file directly touched: workspace `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md`.
- Cross-references to "Concurrent-session staging discipline" and concurrent-session topics across `ai-resources/`: 8 hits (`reports/setup-improvement-scan-2026-04-21.md`, `audits/claude-md-audit-2026-04-20-project-buy-side-service-plan.md`, `audits/risk-checks/2026-04-25-f2-add-a-concurrent-session-detection-and-abort-to-cleanup.md`, `usage/usage-log.md`, `logs/session-notes-archive-2026-04.md`, `logs/coaching-data.md`, `logs/improvement-log-archive.md`, `logs/usage-log.md`). All are documentation/log mentions — no programmatic contract dependency on the section's exact content.
- Cross-references to "Autonomy Rules" / "pause-trigger" across `ai-resources/`: 13 hits including `docs/audit-discipline.md`, `logs/decisions.md`, `logs/session-notes.md`, `workflows/research-workflow/CLAUDE.md`, multiple audits. The most contract-relevant is `docs/audit-discipline.md`, which authoritatively defines `Risk-check change classes` (referenced from pause-trigger #9). G5 adds an item to the pause-trigger list — this is the kind of change that may need a corresponding line in `audit-discipline.md` if the new bullet is treated as a separate trigger; CHANGE_DESCRIPTION acknowledges flexibility here ("extend the existing pause-triggers ... or add a new bullet").
- Cross-references to `cleanup-worktree`: 17 hits across docs, audits, logs, the SKILL.md `skills/worktree-cleanup-investigator/SKILL.md`, the F2 risk-check report, the risk-check command, etc. None of these depend on the workspace CLAUDE.md's wording — they reference the command itself.
- Cross-references to `permission-sweep`: 6 hits across CLAUDE.md (ai-resources), `docs/permission-template.md`, logs, innovation-registry, recent audit. Same pattern — no contract dependency on workspace CLAUDE.md's section text.
- No contract changes (no subagent input schema, no report headings, no hook output shape, no slash-command syntax). Change is documentary.

### Dimension 4: Reversibility
**Risk:** Low

- Single-file edit to a tracked file. `git revert` cleanly restores prior state with no sibling files, no log mutations, no external state propagation.
- The change does not register any automation that could fire between landing and a potential revert.
- No operator-muscle-memory shift required — the rule documents an existing F2 mechanical guardrail and an existing operator-discipline expectation for `/permission-sweep`, neither of which is a new behavior the operator must internalize.
- Potential mild caveat: once the rule is in always-loaded CLAUDE.md, future sessions will have read it; reverting later means later sessions will not see it. This is normal for rule documentation and does not elevate the risk above Low.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- G5 grafts onto the existing "Autonomy Rules" pause-trigger numbered list (workspace CLAUDE.md lines 90–101: triggers 1–9). CHANGE_DESCRIPTION offers two implementation shapes: "extend the existing pause-triggers (one of triggers 1–9) or add a new bullet". The two shapes have different downstream coupling implications:
  - Extending an existing trigger (e.g., trigger 9) keeps the numbering stable and avoids touching `audit-discipline.md`'s authoritative class list (referenced from trigger 9: "Authoritative class list and verdict semantics: `ai-resources/docs/audit-discipline.md` § Risk-check change classes").
  - Adding a new bullet (trigger 10) introduces a new numbered item that several documents reference by number (search hits in `docs/audit-discipline.md`, `logs/decisions.md`, `logs/session-notes.md`, etc., all reference "pause-trigger #N" or similar). Some references mention specific numbers (e.g., the just-amended `Commit behavior` section already says "Pushing requires explicit operator confirmation per Autonomy Rules pause-trigger #2", line 171). New trigger #10 itself does not invalidate those references but the choice between "extend existing" vs. "add new bullet" is load-bearing for whether downstream files need touching.
- F3 functionally overlaps with the new F2 mechanical prompt in `/cleanup-worktree` (commit d2d1b15) — two systems will both attempt to enforce "no concurrent session for /cleanup-worktree": F2's runtime prompt and F3's CLAUDE.md rule. CHANGE_DESCRIPTION names the overlap correctly ("`/cleanup-worktree` enforces this via a mandatory operator-disclosure prompt at Step 1") and resolves it (the rule cites F2 as the enforcement mechanism), so the overlap is documented at the change site — but only if F3's wording faithfully reflects F2's *current* behavior. Plan line 51 still says "will mechanically abort if it detects" which contradicts F2 as landed (F2 ships an operator-disclosure prompt, not pgrep mechanical detection — see `audits/risk-checks/2026-04-25-f2-add-a-concurrent-session-detection-and-abort-to-cleanup.md` Verdict RECONSIDER and the recommended-redesign that F2 ultimately followed). CHANGE_DESCRIPTION's wording is correct (says "operator-disclosure prompt"); plan file line 51 is stale. The operator must apply CHANGE_DESCRIPTION's wording, not the plan's.
- `/permission-sweep` half of the rule has no programmatic enforcement — purely operator discipline. The CLAUDE.md prose names this asymmetry, but it creates a coupling expectation: any future automation added to `/permission-sweep` (e.g., a sibling F2-style prompt) will need this CLAUDE.md sentence updated. Low-stakes, but is hidden coupling — the future work is not flagged in any maintenance hook or audit.
- Pause-trigger #8 (line 99) and #9 (line 101) already define the structural-change/audit-derived authorization pattern. G5's intent ("operator-must-authorize when concurrent session is disclosed") is materially different — it's a runtime-disclosure pause, not a structural-change pause. Adding it to the same list risks category-blurring unless the bullet is worded distinctly enough that the rule doesn't read as redundant with #9.

### INCOMPLETE flags

- Dimension 1 estimate is bracketed because G5's exact wording is not specified in CHANGE_DESCRIPTION (only the intent and two implementation shapes). The Medium classification holds across both shapes; if the operator chooses a longer wording (>150 added tokens), the dimension elevates to High.
- Dimension 5 cannot conclusively distinguish between the two G5 shapes (extend trigger 1–9 vs. add new bullet) because CHANGE_DESCRIPTION leaves the choice open. The operator must commit to one shape before landing.

## Mitigations

- **Dimension 1 (Usage Cost):** Cap the bundled F3 + G5 wording at ~120 tokens of added prose. Specifically: keep F3's added paragraph ≤ 75 tokens (one sentence naming the rule, one short sentence naming F2 as the enforcement mechanism, one short sentence on `/permission-sweep`'s operator-discipline status); cap G5 at ≤ 50 tokens (one bullet line). Reject longer drafts. Rationale: the change is documentary prose that pays per-turn cost in every workspace session — every token over the cap is permanent overhead.
- **Dimension 5 (Hidden Coupling):** Before landing, commit explicitly to one G5 shape and apply both halves consistently:
  - **Preferred:** extend an existing trigger rather than adding bullet #10 — append a sub-clause to trigger #1 ("Destructive git ops on shared state ... including `/cleanup-worktree` when a concurrent session is disclosed") or add the disclosure-acknowledged case as a sub-bullet under an existing trigger. This keeps the numbered list stable and avoids any churn in references like the `Commit behavior` section (line 171) that cite pause-triggers by number.
  - **If a new bullet is chosen:** verify that no document references "pause-triggers 1–9" as a closed set (none found in this evaluation, but the operator should grep one more time at land-time) and add a one-line cross-reference in `ai-resources/docs/audit-discipline.md` if the new trigger is structurally distinct from triggers #8/#9.
- **Dimension 5 (Hidden Coupling) — content fidelity:** Use CHANGE_DESCRIPTION's wording for F3 ("operator-disclosure prompt at Step 1 (added in F2, commit d2d1b15)"), NOT plan line 51's wording ("will mechanically abort if it detects"). The plan line is stale relative to F2 as actually landed. Verify the F3 prose against the current `.claude/commands/cleanup-worktree.md` Step 1 before writing.

## Evidence-Grounding Note

All risk levels grounded in direct evidence: file/line references from workspace `CLAUDE.md` (lines 90–101, 171, 177–179), the plan file `make-a-plan-for-wiggly-volcano.md` (lines 47–55, 106–108), the prior F2 risk-check report (which documents F2's redesign from pgrep-mechanical to operator-disclosure-prompt), and the F2 landing commit `d2d1b15` ("update: /cleanup-worktree — add concurrent-session disclosure prompt"). Cross-reference counts from `rg -l` searches across `ai-resources/` (8 hits for concurrent-session, 13 for autonomy-rules/pause-trigger, 17 for cleanup-worktree, 6 for permission-sweep). Workspace CLAUDE.md size from `wc -l` (187 lines). Two INCOMPLETE flags filed where CHANGE_DESCRIPTION did not specify load-bearing details (G5 exact wording, G5 shape between extend-existing vs. add-new-bullet) — mitigations require the operator to resolve both before landing. No training-data fallback was used.
