# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

## 2026-04-21 — Permission settings: fix nested .claude/** glob gap

- **Context:** During refactor execution, harness permission prompts fired on edits to `ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md` despite the operator having granted autonomy. Investigation showed `Write(ai-resources/**)` failed to match because most glob engines don't traverse dotfile path components (`.claude`) via `**` by default, and `Write(.claude/**)` only matches root-level `.claude/`. The nested `.claude/` in `ai-resources/workflows/research-workflow/` fell in the gap.
- **Decision:** Add `Write(**/.claude/**)` / `Edit(**/.claude/**)` + bare-dir variants + an absolute-path catchall (`Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`) to both the workspace-level and ai-resources-level settings.json files. Leave intentionally scoped settings (obsidian-pe-kb/vault, nordic-pe-landscape-mapping-4-26/step-1-long-list) untouched.
- **Rationale:** Belt-and-suspenders. `**/.claude/**` handles the dotfile glob gap; the absolute-path catchall bypasses any remaining glob quirks for paths inside the workspace tree. Other project-level settings already use bare `Edit`/`Write` with no path-scoping, so the fix isn't needed there. Intentionally scoped settings protect raw data (vault) and web-only scopes (step-1-long-list) — those stay as-is by design.
- **Alternatives considered:**
  - Convert all path-scoped permission lists to bare `Edit`/`Write` across the tree (rejected: would lose intentional data-safety scoping in vault and step-1-long-list).
  - Add only the `**/.claude/**` patterns without absolute-path catchall (rejected: any other glob quirk we haven't identified would still bite).
  - Leave the issue (rejected: operator explicitly demanded the fix).
- **Follow-up:**
  - Settings changes take effect on next Claude Code session restart.
  - If prompts still fire in specific flows not caught by these patterns, add additional explicit rules per case.

## 2026-04-22 — Defer SC-02 (hook validation debt) from 2026-04-21 setup scan

- **Context:** Operator approved "All P0 + P1" from the 2026-04-21 setup scan, which includes SC-02: "6 hooks deployed 2026-03-28 remain unvalidated." Phase 1 exploration searched git history for a 2026-03-28 hook-deployment event and found nothing. Current hooks (`ai-resources/.claude/hooks/` + workspace `.claude/hooks/` + bssp `.claude/hooks/`) exist and are wired into their respective `settings.json` files; they appear functional.
- **Decision:** Do not implement SC-02 this session. Commit the plan with SC-02 flagged as deferred and note in commit messages + session summary. Recommend the operator raise via `/improve` for triage.
- **Rationale:** The scan's premise ("6 hooks deployed 2026-03-28 remain unvalidated") is the load-bearing piece of SC-02 — without knowing which hooks are in scope, "validation" has no target set. Current hooks could be validated wholesale, but that's a different task (broader hook audit) and consumes a session on its own. Proceeding on the 6-hook premise without evidence would either (a) waste effort validating hooks that weren't in the original list, or (b) miss hooks that were.
- **Alternatives considered:**
  - Validate all currently-deployed hooks (rejected: scope expansion; the operator approved the scan's items, not a general hook audit; would bloat this session's commit into incidental work).
  - Spot-check a random 6 (rejected: arbitrary selection without the original list is theatre — not validation).
  - Proceed by inferring the 6 from hook filenames containing "auto-commit / bright-line / context-loader / checkpoint / session-wrap / decision-logging" (rejected: several of those are inline `settings.json` commands, not named `.sh` files — inference is unreliable).
- **Follow-up:**
  - Operator raises via `/improve` with any external context on the original list.
  - If no external record survives, reframe as a broader hook-inventory + spot-check task and re-scope under a new SC-ID.

## 2026-04-22 — Flag vault `.claude/settings.json` as gitignored (SC-04 persistence risk)

- **Context:** SC-04 required adding `"additionalDirectories": ["../../../"]` to `projects/obsidian-pe-kb/vault/.claude/settings.json` to unblock the vault's 43 shared-command symlinks and SessionStart hook. Edit applied on disk. During the commit step, `git status` showed neither the vault repo nor the obsidian-pe-kb parent repo recognizing the change.
- **Finding:** `obsidian-pe-kb/.gitignore` contains `vault/` — parent ignores everything under vault. The vault repo itself also ignores `.claude/settings.json`. The edit persists on disk but is not version-controlled. If the vault is ever re-bootstrapped from a template, the `additionalDirectories` key will be lost unless the template includes it.
- **Decision:** Do not modify `.gitignore` rules this session. Flag the persistence question to the operator for design decision.
- **Rationale:** Two plausible intents behind the existing gitignore:
  - **(a) Local-only by design:** The vault's settings.json contains user-specific paths or preferences that shouldn't cross machines. If so, the template that seeds the vault should include `additionalDirectories` in its default so it's regenerated on bootstrap.
  - **(b) Gitignore is overly broad:** The vault's config is project-scoped and should be tracked. If so, the `.gitignore` entry can be removed / narrowed (e.g., `vault/.claude/settings.local.json` only).
- **Alternatives considered:**
  - Remove the gitignore entry and stage settings.json (rejected: policy-level change; the operator hasn't confirmed (b) is the intended design).
  - Commit the edit to ai-resources or project-planning as a "snapshot" note (rejected: puts the authoritative vault config in a non-canonical location; worse than leaving on-disk).
- **Follow-up:**
  - Operator decides between (a) and (b). Either path resolves the persistence concern.

## 2026-04-22 — SC-04 resolved: commit edit + seed template (both)

- **Context:** Prior session's wrap note flagged two mutually-exclusive fix options for the vault `settings.json` persistence risk — (a) update bootstrap template so `additionalDirectories` seeds at vault creation, or (b) narrow gitignore so the file tracks in git.
- **Decision:** Do both, but reframed. Phase 1 exploration proved the premise of option (b) was wrong — the file is already tracked (gitignore negation at `projects/obsidian-pe-kb/.gitignore:4`). The on-disk edit just needed committing. The canonical "template" is the tech spec at `pipeline/technical-spec.md` §4; that got the `additionalDirectories` seed plus a rationale entry.
- **Rationale:** Committing the existing edit fixes the immediate persistence risk. Updating the tech spec fixes the future-re-bootstrap risk. Orthogonal fixes; no reason to pick one.
- **Alternatives considered:**
  - Narrow gitignore (rejected: unnecessary — negation already works).
  - Build a new bootstrap seeder script (rejected: overbuilt; tech spec is the source of truth for this project, no shared template to centralize).
- **Follow-up:** None. Both edits committed in obsidian-pe-kb `3b148e3`.

## 2026-04-22 — SC-02 reframed from unverifiable baseline to full-inventory task

- **Context:** Setup scan at `reports/setup-improvement-scan-2026-04-21.md:50–58` claimed 6 hooks were deployed 2026-03-28 and remain unvalidated. Prior session could not verify the 6-hook list in git history and deferred the item.
- **Decision:** Reframe from "validate the specific 6 hooks from 2026-03-28" to "inventory every currently deployed hook (29 found) and verify each fires correctly." Log as `logged (pending)` in `improvement-log.md` for a future dedicated maintenance session.
- **Rationale:** Can't validate an unknowable baseline. The broader inventory is actionable — 29 hooks found, each with an identifiable trigger type, testable in a spawned session. Logging direct to the improvement-log (bypassing `/improve`) because `/improve` chains off `friction-log.md` and there is no matching friction entry; this is a scan-originated finding.
- **Alternatives considered:**
  - Invoke `/improve` (rejected: the command's Step 1 requires friction-log context which doesn't exist for this item).
  - Execute the 29-hook inventory in this same session (rejected: ~1 hour of scope creep; no active friction driving urgency).
  - Dismiss entirely (rejected: 29 unvalidated hooks is real latent risk; logging preserves the action).
- **Follow-up:** Pending session — inventory all 29 hooks, verify each fires; consider building `/validate-hooks` if the work benefits from reuse.

### 2026-04-22 — Delete `/new-project` Stages 2 and 2.5 outright (no fallback)

- **Context:** `/new-project` previously generated the context pack, project plan, and technical spec via internal Stages 1/2/2.5. The operator now produces those artifacts upstream in the `projects/project-planning/` workspace via `/plan-draft` / `/plan-refine` / `/plan-evaluate` (and spec cycle). The two workflows were producing duplicate artifacts with drift risk.
- **Decision:** Delete `pipeline-stage-2.md` and `pipeline-stage-2-5.md` outright. Replace with discovery-based retrieval from `projects/project-planning/output/{name}/`. Do not retain a fallback path for projects without pre-existing planning artifacts — `/new-project` now requires the planning workflow to run first.
- **Rationale:** Operator explicitly chose outright deletion over conditional fallback. "A dormant fallback path rots and drifts" — keeping Stage 2/2.5 behind a discovery check would mean maintaining two code paths, one of which would rarely execute and therefore get stale. The planning workspace is now the system of record; any new project requiring Claude Code setup should go through it first.
- **Alternatives considered:**
  - Keep Stage 2/2.5 as conditional fallback (rejected — maintenance burden for rarely-exercised path).
  - Leave Stage 2/2.5 active, add planning-workspace as optional seed (rejected — doesn't eliminate duplication).
- **Follow-up:** Legacy in-flight pipelines with Stage 2/2.5 in their `pipeline-state.md` require manual migration — operator resets the state file or re-runs `/new-project` from scratch. No auto-migration implemented; documented in Continuation section.

### 2026-04-22 — Defer Obsidian infrastructure layout enforcement

- **Context:** Operator's original prompt included an item to instruct `/new-project` to follow the `buy-side-service-plans/wiki/` "Obsidian infrastructure" layout for new projects so Claude retrieves existing material in a predictable structure. During clarification, the operator deferred the item entirely: "defer the obsidian layout for later when I have a better plan for it."
- **Decision:** Out of scope for this change. Documented as deferred in the plan's Context section and session note.
- **Rationale:** The operator doesn't yet have a clear layout spec. Codifying a template now risks enforcing the wrong convention and forcing retroactive migration later. Better to execute the smaller, well-scoped retrieval change first and re-plan the layout enforcement when the operator has a target layout in mind.
- **Alternatives considered:**
  - Codify the existing `buy-side-service-plans/wiki/` layout as a provisional template (rejected — operator flagged the wiki reference doesn't yet exist at the assumed path and the layout isn't fixed yet).
  - Design an Obsidian-style layout from scratch based on Obsidian conventions (rejected — premature without concrete project experience to validate against).
- **Follow-up:** Separate session when operator has a target layout. Likely scope: define a layout template, extend `/new-project` to scaffold new projects per the layout, decide whether to audit/retrofit existing projects.

### 2026-04-22 — Quarterly tier of `/friday-checkup` dropped from auto-run

- **Context:** Initial design called for three auto-run tiers (weekly / monthly / quarterly). Quarterly was to add `/repo-dd deep` per scope and `/analyze-workflow` per workflow on top of the monthly base.
- **Decision:** Drop the quarterly tier from auto-run entirely. On quarterly Fridays the orchestrator runs only the monthly auto-run set; `/repo-dd deep` per scope and `/analyze-workflow` per workflow are printed as an "Operator follow-ups" checklist in the consolidated report.
- **Rationale:**
  - Plan QC identified that invoking the `repo-dd-auditor` subagent directly (to avoid `/repo-dd`'s interactive triage gates) produces standard-tier factual-audit output only, not deep-tier data — silently downgrading the quarterly audit while labeling it as deep.
  - Monthly + quarterly runtime with 2–3 active projects estimates 3–5 hours, beyond one session's capacity and crosses `[COST]` / context-limit guardrails without a checkpoint mechanism.
  - The `workflows/` scope was silently added for the quarterly `/analyze-workflow` step without operator confirmation, violating the Assumptions Gate rule.
- **Alternatives considered:**
  - Keep the quarterly auto-run but spec the full `/repo-dd deep` pipeline correctly and design multi-session execution (rejected — high complexity, real-hour cost to the operator on every quarterly Friday, `workflows/` scope still needs operator sign-off each quarter).
  - Split into two separate commands — `/friday-checkup` (weekly+monthly) and `/quarterly-checkup` (heavy, acknowledged multi-session) (rejected as premature until the weekly cadence proves sticky; easier to add later than to remove).
- **Follow-up:** If the weekly cadence proves sticky and the operator wants quarterly automation too, revisit whether a dedicated `/quarterly-checkup` command with explicit multi-session scaffolding is worth building.

### 2026-04-22 — Friday reminder via SessionStart hook, not scheduled remote agent

- **Context:** Operator wanted the `/friday-checkup` cadence to be reminded automatically rather than relying on manual recall. Two options presented: (A) scheduled remote agent firing Friday 09:00 with a push notification; (B) SessionStart hook that fires when a Claude Code session opens, prints a one-line reminder on Fridays when no checkup report exists yet for today.
- **Decision:** Option B — SessionStart hook.
- **Rationale:** A push notification at a fixed hour is easy to dismiss and doesn't align with the operator's actual sit-down moment. A SessionStart reminder only fires when the operator is already at the terminal — exactly when they could act on it — and is silent once the day's checkup has run. Also simpler to maintain: no external scheduled agent to manage or monitor for failure.
- **Alternatives considered:**
  - Option A: Scheduled remote agent via `schedule` skill (rejected for the reasons above).
  - Modify `/prime` instead of adding a hook (rejected: `/prime` requires explicit operator invocation and would miss sessions where the operator skips it).
- **Follow-up:** Monitor whether the reminder actually fires and whether it's useful. If the operator dismisses it reliably without running the checkup, revisit the approach.

## 2026-04-23 — Session-guide output file: overwrite, not versioned

- **Context:** Rewriting `/session-guide` from up-front playbook generator to state-aware progress view. Operator will invoke it many times per project as state evolves. Three options for repeat-run file behavior were presented via AskUserQuestion (per Assumptions Gate): versioned files (v2, v3...), timestamped append to single file, overwrite.
- **Decision:** Overwrite on each run — no versioning, no timestamped history.
- **Rationale:** Notion is the distribution surface and retains its own history. Local file is a current-state render, not an archival artifact. Overwrite is the cleanest paste workflow (grab the whole file, drop it in Notion).
- **Alternatives considered:**
  - Versioned files: strictly matches workspace "create a new version file rather than overwriting" convention, but produces file clutter and burden to track which is current. Rejected.
  - Timestamped append: preserves local history inline, but each paste requires selecting the top block; file grows over time. Rejected for paste ergonomics.
- **Follow-up:** Documented as exception to the versioning convention in both the plan and the rewritten skill (the convention is phrased around iterating on a single artifact, not repeatedly regenerating a view from current state).

## 2026-04-23 — bypassPermissions as default mode

- **Context:** After completing the session-guide rewrite, operator ran `/fewer-permission-prompts` expecting to reduce permission-prompt friction. The skill's scan (Bash + MCP) found everything high-volume was already auto-allowed or on the allowlist. Clarification revealed the prompts the operator wants to eliminate are for *any* tool call that the harness would ask about — including `python3` heredocs, complex Bash pipelines, and Edit/Write on paths outside the existing globs. Operator directive: "don't want any fucking prompts."
- **Decision:** Set `permissions.defaultMode: "bypassPermissions"` in both `ai-resources/.claude/settings.json` and workspace-root `.claude/settings.json`. Every tool call auto-approves; `deny` list still blocks destructive operations.
- **Rationale:** The `/fewer-permission-prompts` skill's allowlist approach is narrow by design (refuses to allowlist interpreters, heredocs, etc. for security reasons). Operator's workflow priority is zero friction over fine-grained safety gating. `defaultMode: "bypassPermissions"` achieves that cleanly while retaining the `deny` floor (rm -rf, git push, git reset --hard, git checkout blocked unconditionally at workspace root).
- **Alternatives considered:**
  - Broad Bash wildcards (e.g., `Bash(python3:*)`): explicitly forbidden by the fewer-permission-prompts skill's safety rules — same blast radius as bypassPermissions but without the `deny` safety floor being visible in one place.
  - `defaultMode: "acceptEdits"`: only auto-approves file edits, not Bash. Wouldn't cover the python3/pipeline cases that prompted this.
  - Narrowly allowlisting python3/find/xargs: skill's rules prohibit interpreter allowlisting; would also require discovering and allowlisting each new pattern.
- **Security tradeoff accepted:** Prompt injection in tool results now runs with zero friction. System-wide file read/write (subject to OS user permissions). The `deny` list is the only backstop for destructive git/rm operations.
- **Follow-up:** If prompts still fire in sessions from `projects/*/` subdirectories, propagate the setting there. Workspace-root change is uncommitted pending operator decision on whether to persist via commit.

## 2026-04-23 — /summary skill: faithful-compression philosophy (Option A)

**Context:** Building a new `/summary` skill for stakeholder-facing document summarization. Operator asked whether the proposed format (TL;DR + source-structure-mirrored body) mirrored Howard Marks or Ray Dalio, surfacing a real design fork.

**Decision:** Option A — faithful compression. The summary preserves the source author's structure and all load-bearing claims; drops only rhetorical scaffolding. No editorial voice, no analytical reframing, no restructuring into a principle hierarchy.

**Rationale:**
1. The source document already did the thinking. Imposing a Marks or Dalio lens over the author's considered work second-guesses it and layers Claude's interpretation on top.
2. Stakeholders acting on the summary (e.g., Daniel receiving a 10-page plan digest) need access to the plan's actual decisions, numbers, and commitments — not a Claude-generated reframe.
3. Structure preservation gives round-trip traceability ("what does Section 4 actually say" lets the reader open the source and find it).
4. Operator's own wording — "information packed, **precise**" — signals fidelity over interpretation.
5. Marks/Dalio-style digests require summarizer authority; a Claude-generated version reads as generic AI synthesis with pretensions.

**Alternatives considered:**
- **Option B (Marks-style editorial digest):** one central thesis + developed prose argument. Rejected as wrong job for the stated use case.
- **Option C (Dalio-style principle extraction):** hierarchical distillation to principles + mechanisms. Rejected because most strategy/plan/proposal documents are not principle systems and force-fitting the schema distorts content.
- **`--style` flag covering all three:** rejected as scope creep. Skills that do three things do none well. If an editorial-digest need emerges, build a separate `/memo-from-document` skill.

**Implication:** The skill's fidelity rules (must-survive / can-drop / must-not-introduce) are load-bearing. Future `/improve-skill` work should preserve the faithful-compression contract; interpretive extensions belong in a separate skill.

## 2026-04-24 — /qc-pass guardrails: three-layer design over tag-only alternative

**Context:** QC pass was net-negatively affecting mechanical work on repo-infrastructure files — surfacing false-positive findings, out-of-scope observations, and triage over-escalation. Needed guardrails that prevent QC from introducing more problems than it fixes.

**Decision:** Implement a three-layer design — (L1) scope declaration upfront in `/qc-pass`; (L2) proportional rubric in `qc-reviewer` with mechanical-mode vs full, and `[In-scope]`/`[Out-of-scope]` placement tagging for full rubric; (L3) scope-aware triage in `triage-reviewer` with Out-of-scope → Park default. Plus CLAUDE.md updates for a "second gear" mechanical-mode bullet and an Auto-Loop skip condition when QC returns GO with only out-of-scope observations or mechanical-mode with all M-checks Clear.

**Rationale:** Operator confirmed all three failure modes (false positives, out-of-scope findings, triage over-escalation) happen in practice — no single layer addresses all three. Layer 2 prevents out-of-scope commentary from qc-reviewer. Layer 3 ensures any that leaks through defaults to Park, not Do. Layer 1 makes scope visible to the operator for correction via re-invoke. CLAUDE.md changes align the auto-loop behavior with the new tag system and add the mechanical-mode skip so clean mechanical QC doesn't burn a triage subagent.

**Alternatives considered:**
- **Tag-only (simpler):** just add scope declaration + placement tags + scope-aware triage — skip the mechanical-mode rubric selector. Surfaced by QC-reviewer as a plausible alternative. Addresses net-negative outcomes (the stated problem) but not noise volume on mechanical work. Operator chose the fuller design because full-rubric QC on mechanical edits still produces needless findings that the operator has to mentally filter, even if they park cleanly.
- **Skip QC entirely on mechanical work:** extend existing Post-edit QC skip criteria (currently ≤5 lines, mechanical substitution, validated elsewhere) to a broader auto-skip on any mechanical infra edit. Rejected: operator wanted QC to still run (it can catch M1/M2/M3 regressions), just with a narrower rubric that doesn't commentate on surrounding correct code.
- **Hybrid ship-later:** ship tag-only now, add mechanical-mode later if noise is still a problem. Rejected: operator preferred the complete fix in one pass.

**Implication:** Any future `/qc-pass` invoker must pass scope as a 4th input to get the new behavior. Legacy 3-input callers continue working via qc-reviewer's derive-scope fallback. Follow-up migration of `refinement-deep`, `cleanup-worktree`, and workflow commands is deferred but explicitly tracked in the session note.

## 2026-04-24 — Ripple-edit scope narrowed: no changes to other qc-reviewer invokers

**Context:** During `/qc-pass` on the plan, a grep revealed three more active qc-reviewer invokers beyond `/qc-pass` and `/refinement-deep`: `/cleanup-worktree` (top-level command) and three workflow-local commands (`qc-pass.md`, `produce-formatting.md`, `produce-prose-draft.md` in research-workflow). Presented three options: widen scope to top-level only, widen to everything, or defer all ripples.

**Decision:** Defer all ripples. Scope narrowed to exactly four files — `qc-reviewer.md`, `triage-reviewer.md`, `qc-pass.md`, workspace `CLAUDE.md`. Do not update `refinement-deep.md`, `cleanup-worktree.md`, or workflow commands in this pass. Rely on qc-reviewer's legacy-caller fallback (derive scope if not passed, mark `(derived — caller did not supply)` in header) to keep all invokers running correctly on the old 3-input contract.

**Rationale:** Operator preference for testability. Narrower change surface = easier to validate the guardrail's behavior in isolation before propagating. Legacy fallback is backwards-compatible by construction; no invoker breaks. If the three-layer design works as intended on real mechanical work, migrating the other invokers is mechanical and safe to do in a follow-up session.

**Alternatives considered:**
- **Widen to all top-level invokers (initially recommended):** add `refinement-deep.md` and `cleanup-worktree.md` in this pass; defer workflow commands. Rejected: operator wanted to test the core flow before propagating.
- **Widen to everything, including workflow commands:** maximum consistency in one pass. Rejected: larger change surface, harder to validate, and workflow commands have their own handoff contracts (`cleanup-worktree` uses PLAN_PATH + request + snapshot + criteria — not a trivial remap).

**Implication:** Follow-up session needs to migrate `refinement-deep.md`, `cleanup-worktree.md`, and the three workflow commands to the 4-input contract. Legacy fallback keeps these working in the meantime but the "derived" scope annotation in their QC output should be the signal that migration is due. No urgency — scope derivation works.

## 2026-04-24 — H2 deny-scope: conservative (known-stale patterns) over aggressive (broad parent dirs)

**Context:** Acting on Friday-checkup HIGH finding H2 — expand `Read(pattern)` deny coverage in `ai-resources/.claude/settings.json`. The token-audit's Implementation field recommended `Read(audits/**)`, `Read(reports/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.

**Decision:** Conservative subset — added `Read(audits/working/**)`, `Read(logs/*-archive-*.md)`, `Read(inbox/archive/**)`, `Read(**/deprecated/**)`, `Read(**/old/**)`. Deliberately excluded `Read(audits/**)` and `Read(reports/**)`.

**Rationale:** `bypassPermissions` is on, but `deny` rules still block — they cannot be bypassed. Adding `Read(audits/**)` would block reading today's friday-checkup report in review sessions; adding `Read(reports/**)` would block the canonical `reports/repo-health-report.md`. Both are active workflow files the operator touches routinely. The conservative set targets known-stale patterns (scratch dirs, archives, deprecated/old conventions) that never need direct reading — same defensive value without the workflow friction.

**Alternatives considered:**
- **Full token-audit recommendation (aggressive):** rejected — friction against canonical reports outweighs protection from broad-Glob pulls, especially since those pulls are rare.
- **No deny additions:** rejected — leaves large-file stores (`audits/working/` scratch notes, archived session notes, fulfilled briefs) unprotected against accidental pulls.
- **Narrow glob patterns by date** (e.g., `Read(audits/*-2026-*.md)`): rejected — blocks today's dated reports too; no clean way to match "historical dated" without also matching current dated.

**Follow-up:** If broad-Glob pulls of prior audit reports become a felt problem, revisit with a narrower pattern or a time-based exclusion rule. Operator can tune later.

## 2026-04-24 — qc-reviewer agent granted Write tool access (prerequisite for H1 refactor)

**Context:** H1 refactor of the research-workflow prose sub-pipeline needed subagents in produce-prose-draft Phase 3 and produce-formatting Phase 3 to write structured findings to disk per the Subagent Contracts codified in `ai-resources/CLAUDE.md`. Both phases use `qc-reviewer` as the subagent type — whose tools list was `Read, Glob, Grep`. No `Write`, so the output-to-disk pattern was blocked.

**Decision:** Add `Write` to the `qc-reviewer` frontmatter tools list. Single-line additive change.

**Rationale:** `qc-reviewer` is designed for fresh-context independence with no memory of the creation session. Adding Write does not change that — the subagent only exercises Write when the brief explicitly asks for it, and the main session routes Phase 3's write-to-path instruction through the brief. Existing callers (via `/qc-pass`, `/refinement-pass`, `refinement-deep`, `cleanup-worktree`) return findings inline and are unaffected. The alternative — switching these two Phase 3 invocations to `general-purpose` subagent type (which has all tools) — would have lost the explicit qc-reviewer typing and required rewriting the independence framing inline in each brief.

**Alternatives considered:**
- **Switch to general-purpose subagent** for the two Phase 3 spots: rejected — heavier command files, loses the "independent evaluator" typing semantics.
- **Have main session write the findings file** after qc-reviewer returns inline: rejected — the findings still pass through main-session context for one turn before being persisted and compacted. Partial benefit only.

**Implication:** qc-reviewer is now a canonical subagent-to-disk-capable reviewer. Future workflow designs that need independent review + persistent findings have a canonical pattern to follow.

## 2026-04-24 — Commission v4 (repo maintenance cadence) scoped as intent, parallel structures cut

**Context:** Operator supplied a "v4 commission" context-pack specifying a weekly Friday maintenance cadence: two-session structure, three tiers, three durability mechanisms, maintenance ledger with aging, risk-analysis command, symlink policy, deterministic-vs-interpretation split, seven autonomy axes, Stage 1 repo architecture. Operator framed it as "intent, not a set plan — review what we should implement, then your own plan."

**Decision:** Accept commission as intent only. Cut or downscope commission asks that duplicate existing infrastructure (`/friday-checkup`, `friday-checkup-reminder.sh`, `improvement-log.md`, `/triage`, `/coach`, `audit-discipline.md`, symlink policy in `docs/ai-resource-creation.md` + `auto-sync-shared.sh`). Keep commission hard constraints intact (Session 1/2 boundary, risk-analysis-first sequencing, Stage 2 out of scope, PROCEED-WITH-CAUTION requires mitigation). Final plan: 5 batches (not 6 — merged Batch 2+3 for shared data contract), scoped to 8 genuine gaps.

**Rationale:** Commission's "ledger as distinct artifact" duplicates `improvement-log.md`'s existing Status+Verified+archive schema. "Three durability mechanisms" is already partially present via the reminder hook; adding parallel systems for stale-state and recovery creates maintenance surface without additional robustness. "Deterministic-vs-interpretation split" is already honored by repo conventions (hooks + scripts + subagent tiering) — it's a discipline, not a deliverable. Faithful implementation would contradict operator's stated preference (memory: "prefers automated infrastructure over manual disciplines") and inflate operator load instead of reducing it. The commission's own "Epistemic Discipline" section says to "inspect the repo, not defer or fabricate" — which is what this downscoping does.

**Alternatives considered:**
- **Faithful literal implementation.** Rejected: creates 5+ parallel structures duplicating existing infrastructure; commission itself is labeled as intent.
- **Full rewrite of /friday-checkup + replace infrastructure wholesale.** Rejected: destroys working infrastructure; commission's quality criteria #1 ("Patrik can execute the first real Friday session") is already achievable today with /friday-checkup.
- **Minimal implementation (risk-check + /friday-act only, everything else cut).** Rejected: commission's durability and architecture substrate concerns are real gaps, not imaginary ones; cutting too much leaves the cadence fragile.

**Implication:** Five batches to execute across future sessions, one commit per batch. Plan file at `/Users/patrik.lindeberg/.claude/plans/here-s-an-idea-i-memoized-bumblebee.md` is the execution spec. Handoff notes in the plan specify assumption sign-offs, decision gates, dogfood ordering for `/risk-check`, and realistic pacing (no more than 2 batches per session).

## 2026-04-24 — Seven autonomy axes land in `/friday-act` output, not coaching-log

**Context:** Commission v4 specifies seven autonomy calibration axes (Guardrails / Optimization / Autonomy / Capability / Reliability / Observability / Operator load) to be "set by Session 2 for the following week." Existing `coaching-log.md` already rates five session-pattern dimensions (Iteration Efficiency, Decision Patterns, QC Disposition, Delegation Effectiveness, Workflow Evolution) with trend arrows.

**Decision:** Track the seven axes as weekly forward-looking posture targets (tighten / hold / loosen + one-line rationale) appended to `logs/maintenance-observations.md` within the `/friday-act` Step 6 closeout. Coaching-log stays at its current five dimensions — untouched. Default posture for any axis is `hold`; only explicitly-changed targets require a rationale line (operator can fast-skip to avoid seven mandatory prompts every Friday).

**Rationale:** The two systems have different time orientation and different verbs. Coaching-log is backward-looking session ratings (how did this session perform on dimension X?). Commission's axes are forward-looking posture targets (what should Autonomy look like next week?). Merging them into coaching-log would either (a) break trend-arrow history on the five existing dimensions by forcing a schema replacement, or (b) mix two conceptually distinct things in one rating slot. Neither is an improvement. Placing axes in the `/friday-act` output keeps them adjacent to the Friday decision context that actually sets them, and preserves coaching-log's integrity.

**Alternatives considered:**
- **Extend coaching-log schema to seven axes by replacement.** Rejected: breaks five-dimension trend comparability; mixes backward/forward orientation.
- **Extend coaching-log to twelve dimensions (5 existing + 7 commission).** Rejected: heavy schema; two conceptually distinct systems in one file masks purpose.
- **Create a net-new `autonomy-axes.md` tracking file.** Rejected: commission's framing is Session-2-sets-targets-for-following-week; natural home is the Session 2 artifact, not a parallel file that inflates log surface.

**Implication:** `/friday-act` Step 6 (to be built in Batch 2) is the enforcement point for this schema. `/coach` command and `coaching-log.md` are explicitly not modified — listed in the plan's "Not modified (despite commission language)" section. Axis set itself is subject to revision at first quarterly retrospective per commission.

## 2026-04-24 — /audit-critical-resources design decisions

**Context:** Built new slash command auditing user-nominated critical resources across seven quality dimensions, producing a fix-session-ready markdown report. Three load-bearing design choices surfaced during plan mode.

**Decision 1 — Input format:** manifest file (`audits/critical-resources-manifest.md`) read when invoked without args; inline args override.

- Alternatives considered: (a) inline `$ARGUMENTS` only, matching context pack assumption [A6]; (b) auto-discovery via a `CRITICAL=true` frontmatter marker on resources.
- Rationale: 15+ resources in the critical set → inline args would be long every invocation; auto-discovery requires marker adoption on every file first. Manifest is the lightest reusable-state option.

**Decision 2 — Overlap policy:** all 7 dimensions run independently; no delegation to `/token-audit`, `/audit-claude-md`, or `/repo-dd` for overlapping dimensions.

- Alternatives considered: (a) delegate Brokenness + Token/efficiency to existing audits and only run the 5 novel dimensions; (b) narrow to 5 truly novel dimensions permanently.
- Rationale: fix session benefits from a single self-contained report; cross-referencing multiple audits defeats the "paste the report into a fresh session" use case. Acknowledged cost: Brokenness + Token checks duplicate work done elsewhere.

**Decision 3 — Parallelism:** one subagent per resource running all 7 dimensions; cross-resource synthesis in the main session reading each working-notes file's `## Synthesis Input Block`.

- Alternatives considered: (a) one subagent per dimension spanning all resources; (b) hybrid (preflight + 3 bundled subagents + synthesis).
- Rationale: per-resource parallelism scales naturally with critical-set size; each subagent handles its resource end-to-end; a single synthesis pass is simpler than reconciling per-dimension outputs.

**Decision 4 — Interpretation of "associated skills are also critical":** scoped to skills the designated commands reference directly by path (3 skills: `session-usage-analyzer`, `ai-resource-builder`, `worktree-cleanup-investigator`).

- Alternatives considered: (a) include subagents spawned by critical commands; (b) include other commands invoked by critical commands transitively.
- Rationale: narrow-scope interpretation is conservative and auditable; transitive inclusions risk sweeping in too much for the initial audit. Operator was informed of the exclusions and can extend explicitly.

**Implication:** first run of `/audit-critical-resources` will audit 15 resources. If the critical set grows, the plan's existing `--full-repo-context` flag provides an escape hatch for reverse-reference checks without a manifest edit.

## 2026-04-24 — Model-tier classifier hook design

**Context:** Patrik routinely leaves the session default at Opus (chosen for quality) but forgets to run `/model sonnet` on Sonnet-tier work. The overspend is only noticed at weekly usage review, by which point the tokens are already spent. Asked for the "best overall solution" to this recurring pattern.

**Decision:** Build a `UserPromptSubmit` hook at workspace root that fires once per session on the first free-form (non-slash-command) prompt, injecting a system-reminder that tells Claude to classify the task against the workspace Model Tier rule and recommend `/model sonnet` if clearly Sonnet-tier. Default session model stays Opus; the hook only automates the recommendation, not the switch.

**Rationale:**

- Matches the actual failure mode (forget entirely → notice at weekly review): active interrupt at session start, not passive cue.
- Preserves the quality default (Opus). Hook defaults to Opus on ambiguity; only recommends downshift on clear Sonnet-tier signals.
- Uses Claude's own judgment rather than keyword matching (brittle) or static reminder text (operator ignores passive cues).
- Skips slash commands, so `/prime` and other orientation or work commands with their own `model:` frontmatter don't trigger spurious classifications.
- Cost: one short classification turn per session on Opus, saves many Opus turns when the work is actually Sonnet-tier.

**Alternatives considered:**

- Flip default to Sonnet and escalate to Opus manually — rejected: operator states quality degrades without Opus default.
- Static `SessionStart` reminder printing the tier rule — rejected: same failure mode as statusline; operator ignores passive cues.
- Statusline showing the current model — rejected: passive; operator misses it.
- Post-hoc usage alerts — rejected: too late; money already spent.
- Manual slash command at session open (e.g., `/classify`) — rejected: same forget-problem as manual `/model sonnet`.

**Implication:** Marker file at `/tmp/claude-model-classifier/$CLAUDE_SESSION_ID` prevents re-firing within a session. Scope is workspace-level, so the behavior applies uniformly across every Axcíon project.

## 2026-04-24 — /permission-sweep command shape and canonical template additions

**Context.** Operator reported recurring Edit/Delete permission prompts resisting six reactive patch commits since 2026-04-20 and asked for a durable diagnostic + remediation command with scope across all projects. Multiple design decisions had to be made during construction.

**Decisions:**

1. **Command name `/permission-sweep` (not `/diagnose-permissions`, `/permission-audit`, `/fix-permissions`).**
   Rationale: "audit" is overloaded (3+ existing /audit-* commands). "Sweep" signals a durable-cleanup pass reaching every file and pairs naturally with the already-listed `/fewer-permission-prompts` — structural vs. empirical division of labor reads off the names.
   Alternatives considered: `/diagnose-permissions` (too narrow — command also remediates), `/fix-permissions` (too narrow the other way — skips the diagnostic framing), `/permission-audit` (collides with naming convention).

2. **Single command with three phases (diagnose → approval → remediate), not two separate commands.**
   Rationale: Autonomy Rules pause-trigger #8 requires operator approval for harness-config changes, so diagnose/remediate cannot run headless as a chain anyway. Splitting into `/diagnose-permissions` + `/fix-permissions` forces the operator (non-developer) to remember the pairing. One command, one mental model.
   Alternatives considered: two separate commands (rejected — mental-model cost), pure SessionStart hook with auto-heal (rejected — violates pause-trigger #8), single monolithic subagent doing both (rejected — violates Subagent Contract and approval gate).

3. **Subagent does diagnosis only; remediation stays in main session via surgical jq merges.**
   Rationale: Subagent Contract requires a short summary return from file-scanning audits; remediation needs the pause-trigger #8 approval gate in main session; mixing both in a subagent would require the agent to re-prompt the operator, which is not a supported pattern.

4. **`Bash(rm *)` added to canonical project template allow list.**
   Rationale: Operator explicitly reported Delete/Remove prompts as one of the two failure modes. Narrow `rm` allows surfaces the Delete path without widening the truly dangerous case; `Bash(rm -rf *)` stays on deny. Tradeoff judged acceptable.
   Alternatives considered: leaving rm out entirely (rejected — Delete prompts persist), broad `Bash(*)` only without narrow rm (rejected — some harness checks match narrow tool-path patterns specifically).

5. **Sanity hook NOT added to `ai-resources/.claude/settings.json`.**
   Rationale: ai-resources already has `defaultMode: bypassPermissions`, so the hook would pass silently. Operator rejected the addition as noise. Hook remains in place for project-level wiring (where it catches the actual failure mode).

6. **Composes with `/fewer-permission-prompts` rather than replacing it.**
   Rationale: `/permission-sweep` fixes structural causes (deterministic rulebook, 13 rules); `/fewer-permission-prompts` fixes empirical causes (transcript-driven). Different detection modes. Bolting structural analysis onto a transcript scanner would bloat a tightly-scoped skill. Order of use: run `/permission-sweep` first; run `/fewer-permission-prompts` after if specific tool calls still prompt.

**Implication.** Prevention is wired into both `/new-project` (canonical template emitted per project at creation) and `/friday-checkup` (weekly `--dry-run` catches drift within a week). The operator should no longer hit this recurring pattern — baseline is durable.
