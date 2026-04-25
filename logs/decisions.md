# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

## 2026-04-25 — Working-tree drift prevention: design choices

**Context:** Plan called for five core fixes (F1–F5) plus five opportunistic guardrails (G1–G5). During execution, three judgment calls reshaped scope.

1. **F2 design pivot — operator disclosure over pgrep.**
   Rationale: `/risk-check` returned RECONSIDER on the original mechanical-abort design. Live test on this machine: `pgrep -fl 'claude' | grep -v $$` returned 12 matches in a single Claude Code session because Claude Code spawns helper/subagent processes and VSCode caches multiple binary versions. A no-override mechanical abort would have made `/cleanup-worktree` unusable. Recommended redesign (Option 1 in the risk-check report): a Step 1 disclosure prompt asking the operator directly. This aligns with the existing CLAUDE.md "Concurrent-session staging discipline" pattern (which is already operator-disclosure-based) and removes the false-positive class entirely.
   Alternative considered: narrowing the pgrep regex (parent-PID walking, env-var override). Rejected — expanded scope beyond a single-file edit.

2. **G5 dropped as redundant.**
   Rationale: F3 already documents the concurrent-session rule in the workspace CLAUDE.md "Concurrent-session staging discipline" section. Adding `/cleanup-worktree` to Autonomy Rules pause-triggers would have duplicated the rule in a different section without load-bearing semantics. The F3+G5 risk-check report explicitly flagged "commit to one shape; prefer extending existing pause-trigger over adding bullet #10" — operator chose the cleaner path of dropping G5 entirely.

3. **F5 severity ADVISORY (plan said HIGH).**
   Rationale: The existing detection-rulebook taxonomy classifies HIGH as "Delete prompts or future Edit prompts." The gitignore-vs-deny mismatch is hygiene — it pollutes `git status` but produces no live or future permission prompt. ADVISORY fits the existing severity structure. The plan's HIGH classification was an overcall; aligned to the rulebook's actual semantics.
   Alternative considered: keeping HIGH per plan. Rejected — would have set a precedent of severity-based-on-perceived-importance rather than rulebook semantics, making the classification bucket fuzzy.

4. **Stopped after core five; deferred G1/G3/G4.**
   Rationale: Operator pushed back on overcomplication mid-session ("Why are you overcomplicating this operation?"). The core five fixes cover both failure classes from the 2026-04-24 incident (session-end hygiene + canonical-state drift). G items are nice-to-have additions (new SessionStart hook, marker-file mechanism, weekly checkup line) that add capability rather than addressing the incident's root causes. Deferred to a future session if the core five turn out to be insufficient.

5. **Reduced /risk-check ceremony for small edits.**
   Rationale: After running `/risk-check` on F2 and F3+G5, recognized that running it on every CLAUDE.md paragraph and hook validation extension is heavy ceremony for low-risk edits. Skipped `/risk-check` on F4 (small extension to existing hook validation) and F5 (new check class added to existing auditor — no new structural infrastructure). Reserves `/risk-check` for genuinely structural changes (new hooks, new commands, new permission rules). Self-check + post-edit testing was sufficient for the small extensions.

**Implication.** The plan-vs-execution gap surfaced two patterns worth carrying forward: (a) `/risk-check` should be invoked when scope is genuinely structural, not on every item that touches a hook or CLAUDE.md; (b) plan-stage severity classifications should be cross-checked against existing rulebook taxonomies before landing.

## 2026-04-25 — /risk-check trigger model: per-change → two-gate

**Context.** Operator flagged that `/risk-check` was firing too often during active work and burning tokens. Under the prior rule, any structural class touched (hook edit, permission change, cross-cutting CLAUDE.md edit, new command/skill, new symlink, automation with shared-state effects) required `/risk-check` *before each landing*. Multi-class sessions fired the gate 3–5 times.

**Decision.** Adopt a two-gate model:
- **Plan-time gate** — once after plan approval, if the plan touches any structural class. `$ARGUMENTS` describes the *design*. Catches design risk before tokens are spent on execution.
- **End-time gate** — once before commit, batched across every in-class change the session actually made. `$ARGUMENTS` describes the *executed* change set. Catches drift, emergent coupling, scope creep.
- **Skip rules.** Sessions without an explicit plan (auto-mode quick fixes, single-file edits) run only the end-time gate. Sessions touching no class skip both.

**Rationale.** The two gates preserve `/risk-check`'s two distinct value propositions (design-risk catch + execution-drift catch) while bounding firings to ≤2 per session. Per-change pattern was the failure mode the operator flagged.

**Alternatives considered.**
- *Single end-time gate only.* Simpler but loses early design-risk catch — you can build for tokens against a design that should have been redesigned.
- *Threshold trigger* (only fire when N+ structural changes accumulate). Adds bookkeeping to operator/main agent; less predictable than session boundaries.
- *Status quo.* Rejected — was the trigger for this redesign.

**Mitigations applied (per end-time `/risk-check` on this very change set).**
- Workspace CLAUDE.md pause-trigger #9 trimmed to ~95 words (matched prior baseline length). Always-loaded surcharge would otherwise have partially undone the policy's token-saving motivation.
- `/wrap-session` Step 13b added as the tactile end-time prompt at the natural session boundary.

**Cross-session note.** This decision and the concurrent session's decision #5 ("Reduced `/risk-check` ceremony for small edits") are complementary, not contradictory: that decision narrows the *trigger classes* (skip on small low-risk extensions to existing files); this decision changes the *firing cadence* within those classes (≤2 firings per session, at session boundaries).

**Files changed.**
- `../CLAUDE.md` (workspace root) — pause-trigger #9 reworded then trimmed.
- `ai-resources/docs/audit-discipline.md` — added "When to fire (two-gate model)" subsection.
- `ai-resources/.claude/commands/risk-check.md` — added "Two intended call sites per session" block.
- `ai-resources/.claude/commands/wrap-session.md` — added Step 13b end-time gate reminder (swept into concurrent session's wrap commit `26d9c7f`).

## 2026-04-25 — Commission Batch 2: /friday-act + tier-differentiated /friday-checkup output

**Context.** Executing approved Batch 2 of the commission plan (5-batch rollout starting with /risk-check in Batch 1, completed 2026-04-24). Plan called for the largest single batch: a new Session-2 command (`/friday-act`) plus a data-contract change to `/friday-checkup`'s output. Operator granted full autonomy mid-session for routine decisions.

**Decision 1 — Plan-time /risk-check skipped; end-time only.**

The new two-gate /risk-check policy (landed earlier 2026-04-25) calls for plan-time gate "once after the plan is approved, if the plan touches any required class." Strict reading would have fired plan-time again on Batch 2. Skipped because the original commission plan went through full QC + triage + post-edit-QC in the 2026-04-24 design session; firing plan-time again on a plan that is months-old in design-time would be redundant and inflate tokens. End-time gate alone caught the executed change set.

- Alternatives considered: (a) fire plan-time anyway as strict policy compliance; (b) fire mid-session per-change as the old policy did. Both rejected — (a) for redundancy with prior QC, (b) because the new two-gate model exists specifically to retire that pattern.
- **Implication.** When executing a multi-batch plan across sessions, the plan-time gate "expires" after the original design QC. End-time gate per session is the durable discipline. Worth surfacing this nuance in `audit-discipline.md` if future sessions hit the same ambiguity (deferred — not a blocker today).

**Decision 2 — Tactical-fix queue scoped to standard items only at MVP.**

`/friday-checkup` Step 7 has two distinct sections: `## Prioritized findings` (rolled-up HIGH/CRITICAL findings from sub-reports) and `## Tactical follow-ups` (the renamed Operator-follow-ups list with risk grading). `/friday-act` parses Tactical follow-ups as its fix queue. As written, Tactical follow-ups contains only the standard items (resolve-improvements, cleanup-worktree, quarterly /repo-dd × N) — NOT the rolled-up findings.

The plan text ("Weekly: tactical follow-ups list + risk level per item — feeds /friday-act as tactical-fix queue") is ambiguous about whether sub-report findings should also feed the queue. Chose narrow MVP interpretation: standard items only; sub-report findings remain in `## Prioritized findings` for the operator to read manually.

- Alternatives considered: (a) auto-promote HIGH/CRITICAL prioritized findings into Tactical follow-ups at /friday-checkup Step 7; (b) have /friday-act parse both sections and merge for the action loop.
- Rationale for narrow MVP: clean separation between summary view (Prioritized findings) and action queue (Tactical follow-ups); the operator can defer all standard items and address findings as separate sessions, which is the dominant path today. Richer ingestion can be added once Batch 3+ usage shows the queue feels too narrow.
- **Implication.** First real `/friday-act` invocation should surface whether the narrow queue is workable. If not, fold sub-report findings into Tactical at Step 7 — small follow-up edit, no /risk-check class change.

**Decision 3 — No /wrap-session edit; lean on Step 13a dirt check.**

`/friday-act` writes per-session blocks to `logs/maintenance-observations.md`. Could have either (a) added the file to /wrap-session's always-staged list, (b) had /friday-act commit its own changes, or (c) left it dirty for /wrap-session Step 13a to surface for explicit operator disposition.

Chose (c). Operator's plan explicitly called for /wrap-session NOT to be modified. Step 13a is the catch-all for dirty paths produced by other commands; it asks per-path disposition. /friday-act's artifact lands in a known location with predictable cadence; operator can dispose `c` (commit) by default each Friday.

- Alternatives rejected: (a) violates plan; (b) unnecessary commit responsibility on /friday-act when wrap-session already has the discipline.
- **Implication.** Maintenance-observations.md will surface in /wrap-session dirt check after every Friday-act run. If that's noisy in practice, revisit by adding to always-staged list (small one-line edit).

**Decision 4 — Three /risk-check Mediums accepted; mitigations applied.**

End-time /risk-check returned PROCEED-WITH-CAUTION with three Medium-risk dimensions (Blast radius / Reversibility / Hidden coupling) and three paired mitigations. Applied:
- Hidden coupling: added one-line schema-contract cross-reference at /friday-act Step 2 → friday-checkup.md Step 7's data-contract paragraph.
- Blast radius: no-op (10-day staleness guard + loud schema-mismatch abort cover the legacy 2026-04-24 audit). Explicitly attested in commit body.
- Reversibility: attestation only (/wrap-session Step 13a already catches the append; no code change needed).

The "no-op acceptable" mitigation from the report is a valid disposition under the verdict semantics — the report itself states no-op is acceptable given loud-failure behavior. Documented the choice in commit body so the audit trail is intact.

## 2026-04-25 — Zero permission prompts as account-level policy

**Context:** Operator hit a permission prompt this session when editing `.claude/commands/*.md` files (auto mode classifier prompted because `.claude/**` paths aren't in the allowlist). Stated explicit, repeated directive: never wants to be hit by a permission prompt again, regardless of risk.

**Decision:** Configure user-level `~/.claude/settings.json` for maximally permissive operation:
1. `defaultMode: "bypassPermissions"` (was `bypassPermissions` originally — was briefly changed to `"auto"` in error and reverted).
2. `deny: []` — removed `Bash(rm -rf *)` and `Bash(sudo *)` entries; deny entries hard-block rather than prompt, but still produce friction equivalent to a prompt.
3. Added top-level `autoMode.allow` block with `$defaults` + 3 natural-language rules: allow all file edits/reads, allow all bash commands, never prompt under any circumstance. Defense-in-depth in case `/auto` activates by accident.

**Rationale:** Operator's explicit cost-benefit: harness permission prompts are net friction for a solo expert operator who is present at the terminal during work. The "smart autonomy" promise of auto mode is undermined by a classifier too coarse to distinguish "operator's actual work editing Claude Code config" from "sensitive system file." Compensating controls retained: CLAUDE.md model-side Autonomy Rules (force-push, branch delete, external writes still pause) and git as recovery mechanism. Operator explicitly accepted the residual risk (no harness brake on destructive bash; bigger prompt-injection blast radius; account-wide scope across all projects).

**Alternatives considered:**
- **Keep auto mode as default + run `/fewer-permission-prompts` at wrap** — operator rejected; relies on wrap discipline and only patches paths that have already prompted, doesn't prevent the first prompt.
- **`acceptEdits` mode** — middle ground; still prompts on bash commands. Rejected as not zero-prompt.
- **Per-path Edit allowlist for `.claude/**`** — narrower fix, but would still leave bash prompts and other surface. Rejected as insufficient for the stated zero-prompt goal.

**Memory written:** `~/.claude/projects/.../memory/feedback_zero_permission_prompts.md` — codifies the policy and the behavioral rule (don't suggest `/auto`, `/plan`, or deny-list additions in future sessions). Old `feedback_permission_prompts.md` deleted as superseded.
