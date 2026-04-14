---
name: worktree-cleanup-investigator
description: >
  Investigates dirty git working trees and plans safe cleanup. Use when the
  operator says "clean up the working tree", "investigate the dirty files",
  "I don't remember what I did in previous sessions", or invokes
  /cleanup-worktree. Plans per-file classifications, runs independent QC and
  triage on the plan, executes behind hard gates for irreversible operations.
  Do NOT use for single-file commits (use regular commit flow), workspace
  health audits (use /audit-repo), structural reviews (use /repo-dd), or
  during active content-production sessions. Skill is Axcion-scoped.
disable-model-invocation: true
---

# Worktree Cleanup Investigator

Convert ad-hoc working-tree cleanup into a structured, auditable flow. Investigate every dirty path, produce a per-file classification plan, run independent QC and triage on the plan, then execute behind hard gates for every irreversible operation. This skill encodes the safety properties that manually-run cleanup sessions repeatedly skip under time pressure.

## When to Use This Skill

Trigger on any of these operator statements:

- "clean up the working tree"
- "investigate the dirty files"
- "I don't remember what I did in previous sessions"
- "the working tree is messy"
- `/cleanup-worktree` (once the command ships)
- `/wrap-session` discovers drift that predates the current session
- `git status` shows 10+ dirty paths and the operator has lost track of provenance

## When NOT to Use This Skill

| Situation | Use instead |
|---|---|
| Single-file commit, operator knows what they changed | Regular commit flow |
| Workspace-level health audit (file org, skill inventory, settings) | `/audit-repo` / `repo-health-analyzer` |
| Structural or judgment audit of repo contents | `/repo-dd` |
| Active content-production session needs to commit the current turn's work | Regular commit flow |
| Creating or modifying a skill | `/create-skill` / `/improve-skill` |
| Pushing to remote | Manual — push stays manual per project rules |

This skill is for dedicated cleanup sessions where the dirt predates the current session and the operator needs a structured pass over it — not for routine commits or for audits that don't touch git state.

## Invocation Contract

This skill has a fixed invocation contract. Deviations are safety failures.

**MUST enter plan mode at the start.** No mutations occur until after the plan is written, QC'd twice, and approved via `ExitPlanMode`.

**MUST produce a written plan file with the required schema.** The plan goes to `~/.claude/plans/<session-name>.md` (or wherever the current harness writes plans) and MUST contain the eight sections defined in `references/execution-protocol.md` → "Plan file schema": (1) original operator request, (2) git status snapshot, (3) per-path classification table, (4) hard-gate inventory, (5) commit split, (6) execution-time re-verification checklist, (7) bias-counter checklist, (8) revision history. The schema exists so two QC subagents and one triage subagent can read the plan as a stable contract. In-memory plans do not count — subagents need a file to read. A plan missing any section fails the first QC pass structurally.

**MUST run two independent QC subagents.** One after the initial plan (`qc-pass`-style review), one after the revision. Triage runs between the two QC passes. Single-QC flows miss fabrications introduced by revisions.

**MUST gate every irreversible operation.** Every `rm`, type change, or `git rm --cached` paired with filesystem removal requires a hard gate with a named confirmation phrase and explicit abort scope. See `references/execution-protocol.md` → section 7.

**MUST NOT push.** Pushing remains a manual operator step. End with a push reminder and a reminder to run `/wrap-session`.

## Workflow

```
1. Read `git status` and list every dirty path.
2. Investigate each path (read file, check status code, run find-template.sh
   if applicable, check .gitignore interactions, identify canonical-destination
   content).
3. Enter plan mode. Write the plan file with per-file classifications, commit
   split, and hard-gate inventory.
4. Run first QC subagent over the plan.
5. Run triage subagent over QC findings + proposed responses.
6. Revise the plan to address must-fix findings.
7. Run second QC subagent over the revised plan. (MANDATORY — not optional.)
8. ExitPlanMode. Operator approves.
9. Execute commits in the order specified by the plan, running the hard-gate
   protocol at every irreversible operation and the execution-time
   re-verification guards immediately before each destructive command.
10. Post-commit verification via filesystem (not git).
11. Report the commits landed. Remind operator to push and run /wrap-session.
```

Detailed mechanics for steps 3–10 live in `references/execution-protocol.md`. Per-path classification rules live in `references/decision-taxonomy.md`.

## Reference Files

Read these on demand — do not load all references at the start.

| File | Read When |
|---|---|
| `references/decision-taxonomy.md` | Classifying any dirty path. Contains the seven per-file decisions (commit, untrack, delete, gitignore, convert-to-symlink, keep-as-local-fork, migrate-then-delete), the decision tree, evidence requirements per decision, and a combining-decisions table for paths that need multiple actions. |
| `references/execution-protocol.md` | Writing the plan, running QC/triage, or executing commits. Contains plan-mode enforcement, investigation protocol, QC and triage subagent contracts, hard-gate protocol, execution-time re-verification guards, copy-to-symlink procedure, migrate-then-delete sequence, commit split guidance, post-commit verification, and push/wrap-session handling. |

Both reference files include tables of contents. Use grep to jump to specific sections rather than reading linearly.

## Bundled Scripts

### `scripts/find-template.sh` — EXECUTE, do not read

Given a project-relative path to a file that may be a copy of a shared `ai-resources` template, the script checks ALL `ai-resources` subdirectories where that category of file might live and reports:

- `IDENTICAL <template-path>` (exit 0) — byte-identical, convert to symlink
- `DIVERGED <template-path>` (exit 1) — template exists but differs, investigate whether intentional fork
- `NO_TEMPLATE_FOUND` (exit 2) — no matching template anywhere
- `ERROR <message>` (exit 3) — mount missing, file missing, usage error

**Run this script for every `.claude/commands/*.md`, `.claude/agents/*.md`, and `.claude/hooks/*` in `git status`.** Do NOT manually check `ai-resources` subdirectories — the script exists specifically to eliminate a false-negative class (missing one subdirectory caused three files to be misclassified as "not in ai-resources" in the session that prompted this skill).

**Usage:**
```bash
scripts/find-template.sh .claude/commands/run-report.md
```

The script walks up from the current working directory looking for an `ai-resources/` sibling, so it works from any project that mounts ai-resources via `--add-dir`. If the script exits with code 3 (`ERROR`), abort the cleanup session entirely — the skill depends on `ai-resources/` being accessible.

## Bias Counters

The skill is for another Claude instance that will face the same failure modes as the session that prompted this skill. The following counters exist because each one was a real error in that session.

### Never fabricate file details

When claiming anything about a file's content (dates, references, rationale, provenance, intent), the claim must come from reading the file. If you say "this file references an April 7 incident," the date must be in the file — not inferred from your memory of the session or from plausible guessing.

**Why:** The originating session's second QC pass caught a fabricated "Apr 7 session incident" reference in a plan revision. The main agent had inserted it to explain a deletion. The original file contained no such date. A single QC pass would have missed it because the fabrication was in revision text the first QC never saw.

**How to apply:** Before making any factual claim about a file in the plan or in a revision, re-read the file. "Re-read" means actually opening it with `Read`, not relying on a summary from an earlier turn. The cost of re-reading is trivial; the cost of a fabricated detail landing in a commit message or plan is not.

### Check ALL ai-resources subdirectories

For any `.claude/commands/*.md`, the template may live in `ai-resources/.claude/commands/` OR `ai-resources/workflows/*/.claude/commands/` (or both). Missing one location produces a false "not in ai-resources" verdict.

**Why:** The originating session's first QC pass caught this: three files (`run-report.md`, `status.md`, `verify-chapter.md`) were classified as "project-native, not in ai-resources" when they were byte-identical copies of workflow-template versions. The investigation had checked only one ai-resources subdirectory.

**How to apply:** Always run `scripts/find-template.sh` for `.claude/commands/*.md`, `.claude/agents/*.md`, and `.claude/hooks/*` paths. The script mechanically checks every `ai-resources` subdirectory — it is the root-cause fix for the class of error text instructions produced.

### Second QC pass is mandatory, not optional

After plan revision, run a second independent QC subagent. This is not a formality.

**Why:** Revisions introduce new content that the first QC never saw. Both failure classes caught in the originating session (the fabricated date and an under-specified abort scope) were in revision text, not in the original plan.

**How to apply:** Step 7 of the workflow is mandatory. If the second QC finds new BLOCKING issues, loop back to revision. After two full revision cycles without convergence, surface the loop to the operator — there is something structurally wrong with the plan.

### Hard gates require named confirmation phrases

Silence, "ok," "proceed," or generic acknowledgment are NOT sufficient to clear a hard gate. The operator must type a phrase naming the operation ("delete memory," "convert run-report.md to symlink").

**Why:** Generic affirmatives are the confirmation mode the operator defaults to under time pressure. Named phrases force explicit acknowledgment of the specific operation being authorized, which is the property that makes the gate protective.

**How to apply:** When writing hard gates in the plan, always specify the required phrase. When executing, reject any response that is not the named phrase — even if the operator's intent is obvious. If the operator resists the named-phrase requirement, hold the gate and explain why it exists rather than relaxing it.

## Known Pitfalls

### The script-versus-text-instruction failure mode

Any instruction that says "check both `ai-resources/.claude/commands/` AND the workflow subdirectories" is a text instruction that fails silently when the agent forgets to check one location. The script `find-template.sh` is the fix: it mechanically enforces the check. Do NOT rewrite the check as text; use the script.

### The "obvious deletion" trap

Files that look obviously disposable (scratchpads, old memory entries, stale logs) are the files most likely to carry load-bearing content the agent hasn't noticed. Before classifying anything as `delete`, read the file in full and identify what would be lost. If anything substantive would be lost, reclassify as `migrate-then-delete` and find a canonical destination for the content first.

### The revision-introduces-new-bugs trap

Revising a plan to address QC findings introduces new text that has not been independently reviewed. The second QC pass exists specifically to catch bugs in revisions — never skip it to "move faster." The cost of one extra subagent call is a tiny fraction of the cost of a botched commit.

### The working-tree-drift trap

Investigation-time diffs can go stale between plan authoring and execution — especially if the session is long or the plan gets approved days after it was written. Always re-run the relevant check (`diff`, `ls`, `git ls-files`) immediately before any destructive operation. The execution-time re-verification guards in `references/execution-protocol.md` section 8 make this explicit per operation type.

### The ambitious-commit-split trap

Bundling every cleanup into a single "chore: worktree cleanup" commit makes the commit unreviewable. Fragmenting into one commit per file makes the history noisy. The right grain is 3–5 topically coherent commits: symlink conversions together, migrate-then-delete pairs split across migration/deletion commits, session data accumulated in a single commit. See `references/execution-protocol.md` section 11.

## Failure Behavior

| Situation | What to do |
|---|---|
| `ai-resources/` not mounted (find-template.sh exits 3) | Abort the cleanup session entirely. The skill depends on ai-resources access. Surface to operator and end the session. |
| Operator declines a hard gate | Apply the gate's abort scope exactly as specified in the plan. Do NOT improvise — the abort scope is what prevents the commit from stranding in an inconsistent state. |
| Second QC pass finds new BLOCKING issues | Revise again. After two full revision cycles without convergence, stop the pipeline and surface the loop to the operator. |
| Execution-time re-verification guard fires (diff non-empty, inventory mismatch, etc.) | Stop the current commit. Surface the guard failure to the operator. Do NOT silently fall back to a safer operation — the guard failure is new information the plan did not account for. |
| Operator says "skip QC, just run it" | Do not comply. The QC+triage layer is the load-bearing safety property of this skill. If the operator insists, surface the risk explicitly and only proceed if they confirm they accept responsibility for a cleanup without independent review — and log this explicitly in the plan's history section. |
| File content is ambiguous — can't tell if it's legitimate work or accidental drift | Ask the operator. "Keep as commit" vs. "untrack" vs. "delete" depends on intent you cannot recover from the file alone. |
| Git state is already partially broken (rebase in progress, merge conflict, detached HEAD) | Stop. This skill assumes a clean git-state baseline. Resolve the underlying state first, then restart the cleanup session. |

## Runtime Recommendations

- **Model:** Use the full reasoning budget. Cleanup sessions are analytical work — adaptive thinking produces shallower investigations and misses stale-copy detections.
- **Mode:** Plan mode from the start. The workflow is not compatible with eager execution.
- **Context budget:** Reference files are lean — read them on demand, not upfront. `decision-taxonomy.md` is needed for classification; `execution-protocol.md` is needed when writing the plan and during execution.
- **Subagent isolation:** QC and triage subagents receive ONLY the plan file, the operator request, and the `git status` output. They do NOT receive the creation conversation. Independence is what catches fabrications.
- **Session scope:** One cleanup session handles one accumulated drift. Do not bundle cleanup with content production — the safety contract and the creative-flow contract conflict.
- **Duration:** A 10–20 dirty-path session typically runs 45–90 minutes with investigation, plan, two QC passes, triage, revision, operator approval, and execution. Budget accordingly.

### Invocation Control Configuration

- **`disable-model-invocation: true`** is set in the frontmatter. This skill performs irreversible filesystem and git mutations and MUST NOT fire as a side effect of an unrelated request. It requires explicit operator trigger via one of the documented trigger phrases or the `/cleanup-worktree` command. Autonomous model invocation is disabled to prevent false triggers on adjacent phrases ("I need to clean up this section") that are not dedicated cleanup sessions.
- **`allowed-tools` is not configured.** The skill needs `Read`, `Glob`, `Grep`, `Bash` (for `git` commands and `find-template.sh`), `Edit`, and `Write` — the same tool set pre- and post-`ExitPlanMode`. A static tool restriction cannot enforce "plan mode only permits Edit/Write on the plan file itself." Plan-mode discipline is therefore enforced procedurally by the workflow (steps 1–8 are read-only except for plan-file writes) and by the hard-gate protocol during execution (steps 9–11). Adding `allowed-tools` would not add a safety property the workflow does not already enforce, but it would prevent the execution phase from running at all.
- **`paths` is not configured.** The skill operates on the entire repo working tree and must be invokable from any project directory — path scoping would prevent cleanup of drift in project subdirectories.

## Validation Loop

After completing a cleanup session, verify these properties before declaring done:

- [ ] Every dirty path in the original `git status` is accounted for by a decision in the plan — no path was silently ignored.
- [ ] Two independent QC passes ran against the plan (second one after revision).
- [ ] Triage ran between the two QC passes.
- [ ] Every hard gate in the plan was executed interactively and received its named confirmation phrase (or its abort scope was applied on decline).
- [ ] Every destructive operation re-ran its execution-time guard immediately before executing.
- [ ] Every migration in a `migrate-then-delete` pair was committed BEFORE its corresponding deletion.
- [ ] Post-commit verification read each committed file from the filesystem and confirmed content matches intent.
- [ ] Working tree is clean (`git status` shows no unintended remainders).
- [ ] Operator was reminded to push manually and to run `/wrap-session`.
- [ ] No push occurred from inside the skill.

If any box is unchecked, the cleanup is not complete — surface the remainder to the operator and either finish the missing step or log it explicitly as deferred.

## Example

**Operator:** "Clean up the working tree, I don't remember what I did across the last three sessions."

**Skill invocation:**
1. Run `git status` — 14 dirty paths surface.
2. Enter plan mode.
3. For each path: read the file, run `find-template.sh` if applicable, note the git status code, check `.gitignore` interactions.
4. Three `.claude/commands/*.md` files return `IDENTICAL` from `find-template.sh` → classified as `convert-to-symlink`.
5. One `memory/old_feedback.md` file contains a Why paragraph not present elsewhere → classified as `migrate-then-delete` with destination `CLAUDE.md` (Assumptions gate section).
6. `.DS_Store` is tracked but matched by `.gitignore` → classified as `untrack` paired with `gitignore` (add `.DS_Store` pattern if missing).
7. Remaining 9 paths are new content, session data, and a new plan → classified as `commit` across 3 topical commits.
8. Write plan to `~/.claude/plans/cleanup-2026-04-13.md` with 5 commits total, 2 hard gates (the deletion in the migrate-then-delete, and the three symlink conversions).
9. Run first QC subagent. QC flags: (a) under-specified abort scope on the migrate-then-delete gate; (b) missing verification that the memory migration is faithful.
10. Run triage subagent over QC findings. Triage confirms both are must-fix; also surfaces that the symlink conversions should re-run their diffs at execution time (execution-time guard was implied but not written in the plan).
11. Revise plan: add explicit abort scope to the deletion gate ("if declined: skip rm, skip gitignore append, still execute DS_Store untrack"); add the migration-faithfulness check; add execution-time diff re-verification for each symlink conversion.
12. Run second QC subagent over revised plan. Clears with one MINOR finding (phrasing preference in a commit message). Proceed.
13. `ExitPlanMode`. Operator approves.
14. Execute commits in order. Migration commit lands first. Hard gate fires before the deletion — operator types "delete old_feedback.md". Deletion commit lands. Symlink conversions re-run diffs immediately before `rm` (all three return empty). Symlink commit lands. Untrack + gitignore commit lands. Content commits land.
15. Post-commit verification: read each committed file, confirm symlinks resolve, confirm deletions succeeded, confirm `.gitignore` contains new pattern.
16. Report: 5 commits landed. Remind operator to push and run `/wrap-session`.

## Cross-References

- **`/cleanup-worktree`** — the slash command that invokes this skill. The command file at `ai-resources/.claude/commands/cleanup-worktree.md` encodes the invocation contract (enter plan mode, pass operator request to the skill, enforce the QC/triage sequence). The skill can be invoked directly, but `/cleanup-worktree` is the preferred entry point because it ensures the plan-mode entry happens before any investigation.
- **`ai-resource-builder`** — evaluates and improves this skill. Not invoked by cleanup sessions.
- **`/audit-repo`** — workspace-level health audit; adjacent but different. A cleanup session may follow an audit that surfaced drift, but the two skills do not invoke each other.
- **`/wrap-session`** — logs session work. Always run after cleanup completes. This skill reminds the operator but does NOT invoke `/wrap-session` directly.
