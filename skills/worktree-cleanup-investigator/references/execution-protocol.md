# Execution Protocol

Safety mechanics for executing a worktree cleanup. This file defines how the plan is produced, reviewed, revised, and executed — not what decisions the plan contains. For per-file classifications, see `decision-taxonomy.md`.

Every rule below exists because it was a load-bearing step in the session that prompted this skill. Skipping any of them removes a safety property that caught a real error during that session.

## Table of Contents

- [1. Plan mode enforcement](#1-plan-mode-enforcement)
- [2. Investigation protocol](#2-investigation-protocol)
- [3. First QC pass (independent subagent)](#3-first-qc-pass-independent-subagent)
- [4. Triage pass (independent subagent)](#4-triage-pass-independent-subagent)
- [5. Plan revision](#5-plan-revision)
- [6. Second QC pass (mandatory after revision)](#6-second-qc-pass-mandatory-after-revision)
- [7. Hard-gate protocol](#7-hard-gate-protocol)
- [8. Execution-time re-verification guards](#8-execution-time-re-verification-guards)
- [9. Copy-to-symlink conversion](#9-copy-to-symlink-conversion)
- [10. Migrate-then-delete sequence](#10-migrate-then-delete-sequence)
- [11. Commit split guidance](#11-commit-split-guidance)
- [12. Post-commit verification](#12-post-commit-verification)
- [13. Push and wrap-session](#13-push-and-wrap-session)

## 1. Plan mode enforcement

**Rule:** No mutation of the working tree, the index, the filesystem, or `.gitignore` occurs before the plan has been written to a file, reviewed, QC'd, triaged, revised, QC'd a second time, and explicitly approved by the operator via `ExitPlanMode`.

**Why:** The session that prompted this skill proved that ad-hoc "investigate and fix as you go" cleanup silently skips safety checks. A written plan is the artifact that QC and triage operate on. Without it, there is nothing to review independently.

**How to enforce:**
- Enter plan mode at the start of the session.
- Write the plan to `~/.claude/plans/<session-name>.md` (the harness default), following the schema below.
- Do NOT use `Edit`, `Write` (except to the plan file), `Bash` with mutating commands, or any destructive tool until `ExitPlanMode` is called AFTER the second QC pass clears.
- Read-only operations (`Read`, `Glob`, `Grep`, `Bash` for `git status`, `git diff`, `git log`, `cat`, `ls`, `find-template.sh`) are permitted throughout plan mode.

**Failure mode to guard against:** "I'll just fix this one obvious thing while I'm here." Every file that gets touched outside the plan is a file the QC subagent never reviewed.

### Plan file schema

The plan file is the contract that QC subagents, the triage subagent, and execution read from. It must contain all of the following sections, in this order. A missing section is a structural failure — the first QC pass should flag any plan that omits one.

**Section 1 — Original operator request.** Verbatim quote of the operator statement that triggered the cleanup session. QC subagents compare the plan back to this statement to check for scope creep.

**Section 2 — Git status snapshot.** The raw output of `git status --porcelain=v1` captured at investigation time. Every path in this snapshot must appear in section 3. Every path in section 3 must come from this snapshot.

**Section 3 — Per-path classification table.** One row per dirty path. Required columns:

| Column | Content |
|---|---|
| `path` | Project-relative path |
| `status` | Git status code: `M`, `A`, `??`, `D`, `T`, `R`, `AD`, etc. |
| `decision` | One of the seven decisions from `decision-taxonomy.md` |
| `evidence` | What was read/checked to arrive at this decision (file lines reviewed, script verdict, `.gitignore` match, canonical-destination check) |
| `gate?` | `yes` if the decision requires a hard gate, `no` otherwise |
| `commit group` | Commit number from section 5 this path belongs to |

Paths that need multiple decisions (see `decision-taxonomy.md` → Combining decisions) get one row per decision, with the `commit group` column specifying the order if the decisions split across commits.

**Section 4 — Hard-gate inventory.** One block per gate. Required fields per block:

| Field | Content |
|---|---|
| `operation` | The destructive command, written out (e.g., `rm -rf memory/`) |
| `files affected` | Every file or directory path destroyed by this operation |
| `confirmation phrase` | The exact phrase the operator must type to clear the gate (e.g., `delete memory`) |
| `abort scope` | If the operator declines: which sub-steps in the same commit still execute, which are skipped, and which subsequent commits are affected |
| `justification` | Why this operation is safe (content preserved elsewhere, byte-identical to template, etc.) |

**Section 5 — Commit split.** Ordered list of commits. Each commit block contains:

| Field | Content |
|---|---|
| `#` | Commit sequence number (1, 2, 3…) |
| `subject` | Commit message subject line (conventional commit format) |
| `paths` | List of paths included in this commit |
| `depends on` | Prior commit numbers this commit depends on (usually for migrate-then-delete pairs) |
| `gate` | Reference to the hard-gate block in section 4 that fires during this commit, or `none` |

**Section 6 — Execution-time re-verification checklist.** One line per destructive operation, pre-written, to be checked off during execution: "`diff <local> <template>` — must be empty" for each symlink conversion; "`ls -la <dir>` — must match inventory below" for each `rm -rf`; etc. Section 8 of this file enumerates the guard per operation type.

**Section 7 — Bias-counter checklist.** Pre-written acknowledgment that the bias counters from `SKILL.md → Bias Counters` have been applied: every file was read before classification, `find-template.sh` was run for every `.claude/*` path, no factual claim about a file is made without a corresponding file read. This section exists so the first QC pass has a declared baseline to verify against — not a promise, an audit artifact.

**Section 8 — Revision history.** Initially empty. After the first QC pass and the triage pass, the main agent appends a subsection listing: each QC/triage finding, the proposed response, and (after revision) the exact plan edit that addressed it. The second QC pass reads this section to verify revisions are faithful to the findings they claim to address.

## 2. Investigation protocol

**Rule:** Read every dirty path before classifying it. No classification from filename alone.

**Per-path investigation steps:**

1. **Read the file content.** Actually open it. For binary files, note the fact and the size.
2. **Check git status code.** `M` (modified tracked), `A` (added staged), `??` (untracked), `D` (deleted), `T` (type change), `R` (renamed). The code influences which decisions are even available.
3. **Check for shared-library candidacy.** If the path matches `.claude/commands/*.md`, `.claude/agents/*.md`, or `.claude/hooks/*`, run `scripts/find-template.sh <path>` and record the verdict.
4. **Check `.gitignore` interactions.** If the path is matched by an existing `.gitignore` pattern but still tracked, that's a candidate for untrack.
5. **Check for canonical-destination content.** If the file carries rules, rationale, or operational knowledge, identify whether that content lives elsewhere in canonical form.
6. **Assign the decision** from `decision-taxonomy.md` using the evidence collected above.

**Bias counter — never fabricate file details:** If you claim a file "references an incident from April 7," the date must come from the file. If you claim a file's content is "mostly boilerplate," you must have read enough to know. The second QC pass in the originating session caught a fabricated "Apr 7 session incident" reference in a revised plan — the original file contained no such date. Always re-read the file before making factual claims about it.

**Bias counter — check ALL ai-resources subdirectories:** `scripts/find-template.sh` mechanically handles this, but if manually checking, the rule is: for any `.claude/commands/*.md`, check both `ai-resources/.claude/commands/` AND every `ai-resources/workflows/*/.claude/commands/`. The originating session missed the second location and false-negatively classified three files as "not in ai-resources." The script exists to eliminate this class of error — use it.

## 3. First QC pass (independent subagent)

**Rule:** Once the plan is written, run an independent QC subagent against the plan file before any revision or execution.

**Subagent contract:**
- Subagent type: `qc-gate` or `qc-reviewer` (whichever is available in the current project).
- Inputs the subagent receives: (a) the plan file content, (b) the original operator request that triggered the cleanup, (c) the raw `git status` output the plan classifies.
- Inputs the subagent does NOT receive: the creation conversation, prior turns, Claude's private reasoning about why each decision was made.

**Why isolation matters:** The subagent is the first independent reader of the plan. If the main agent justifies a decision during the creation conversation, that justification does not appear in the plan — only the decision does. The subagent evaluates what is actually written, which is what will be executed.

**What the subagent is looking for:**
- Factual errors in file descriptions (claims the file contains X when it does not).
- Under-specified safety gates (e.g., "pause before deleting memory" without specifying what happens to other sub-steps if the operator declines).
- Missing hard-gate declarations for irreversible operations.
- Commit split mistakes (unrelated changes bundled; related changes split).
- Decision misclassifications that a reader with no context would question.

**Capture the full QC report** as a structured artifact — do not summarize it. Revisions in the next step must trace back to specific QC findings.

## 4. Triage pass (independent subagent)

**Rule:** After QC, run a triage subagent over the proposed *responses* to QC findings. Triage evaluates which findings must change the plan, which are history-quality-only, and whether any surface a first-class alternative that the main agent missed.

**Subagent contract:**
- Subagent type: `triage-reviewer`.
- Inputs: the QC report, the plan file, and the main agent's proposed responses (one per finding: "will fix," "will clarify," "history-only," etc.).
- Inputs NOT received: the creation conversation.

**What triage catches that QC misses:**
- **First-class alternatives the main agent didn't consider.** Example from the originating session: QC flagged "deleting `memory/` loses the rationale." Main agent proposed adding a Why paragraph to the plan to document the loss. Triage surfaced migrate-then-delete as the correct alternative — lift the rationale into CLAUDE.md first, then delete. The triage reviewer's independence is what let it spot that "document the loss" and "prevent the loss" were different things.
- **Under-specified abort scope on hard gates.** A hard gate that says "pause before deleting memory" without specifying what happens to the `.gitignore` edit and the `.DS_Store` untrack in the same commit is a safety gap even if the primary gate works.
- **Priority ordering.** QC finds everything; triage decides which findings block execution and which are deferrable to history notes.

**Outputs from triage:**
- Must-fix findings (block execution until resolved in revision).
- Should-fix findings (not blocking, but the revision should address them if the cost is low).
- History-only findings (the issue is real but does not need a plan change — a note in the decisions log is sufficient).
- Any first-class alternatives triage identifies.

## 5. Plan revision

**Rule:** After triage, revise the plan to address every must-fix finding and any should-fix findings the operator confirms. Revisions use `Edit` or `Write` on the plan file only. No other file mutations.

**What a good revision does:**
- Rewrites the specific sections flagged by QC/triage. Does not rewrite unrelated sections.
- Adopts first-class alternatives surfaced by triage when they are correct (e.g., migrate-then-delete replacing plain delete).
- Updates the hard-gate inventory if new gates are needed or existing gates need wider abort scope.
- Re-derives the commit split if reclassification changed which files belong together.

**What a revision must NOT do:**
- Silently address findings without logging what changed. Every revision should leave a trace (a revision note at the bottom of the plan, or a diff in a scratchpad) so the second QC pass can check whether the revision faithfully addressed the findings.
- Introduce new claims about files without re-reading them. The revision is new content. The bias counter "never fabricate file details" applies to the revision exactly as it applies to the original plan.

## 6. Second QC pass (mandatory after revision)

**Rule:** Run a second QC subagent over the revised plan. This pass is NOT optional.

**Why:** The revision introduces new content — new decision rationales, new abort scopes, sometimes new first-class alternatives. That new content has never been independently reviewed. The originating session's second QC pass caught a fabricated "Apr 7 session incident" that the main agent had inserted into the revision to explain a deletion. A single QC pass would have missed it because the fabrication was in text the first QC never saw.

**Subagent contract:**
- Same type as the first QC pass.
- Inputs: revised plan, original operator request, `git status` output, and (critically) the first QC report so the subagent can verify whether findings were addressed faithfully or merely deflected.
- Inputs NOT received: creation conversation, revision rationale from the main agent.

**Exit criteria:**
- If the second QC finds new BLOCKING issues: loop back to step 5 (revise again). After two full revision cycles without convergence, stop the pipeline and surface the loop to the operator — there is something structurally wrong with the plan or the approach.
- If the second QC finds only MINOR issues: proceed to `ExitPlanMode` with those issues logged.
- If the second QC clears: proceed to `ExitPlanMode`.

## 7. Hard-gate protocol

**Rule:** Every irreversible operation is gated by a mandatory interactive pause with an explicit confirmation phrase. Silence, "ok," "proceed," "sure," or generic acknowledgment are NOT sufficient.

**Irreversible operations that require a hard gate:**
- Any `rm <file>` or `rm -rf <dir>` that deletes working-tree content.
- Any type change (file → symlink) that discards working-tree content via `rm` + `ln -s`.
- Any `git rm --cached <file>` paired with a filesystem `rm` of the same file.
- Any edit that overwrites content being deleted (the migration step of migrate-then-delete).

**Gate structure (every gate has all five elements):**

1. **Display the file content being destroyed.** For small files, show the full content. For directories, list the files and show the content of any load-bearing ones.
2. **State the irreversibility explicitly.** "This deletes `memory/feedback_validate_assumptions_before_drafting.md` from disk. This is not recoverable via git reflog — reflog covers commits, not filesystem deletions."
3. **Require a named confirmation phrase.** The phrase must name the operation: "delete memory," "convert run-report.md to symlink," "rm the DS_Store untrack," etc. Generic phrases do not count — the operator must type the operation name.
4. **Specify the abort scope.** If the operator declines, list every sub-step in the current commit that still executes, every sub-step that gets skipped, and whether subsequent commits are affected. Example: "If you decline: skip `rm -rf memory/` AND skip the `memory/` `.gitignore` append. Still execute the `.DS_Store` untrack and the reduced commit. Commit 3 and onward are unaffected."
5. **Execute only after the phrase is received.** If the operator responds with anything other than the named phrase (including silence), the gate remains closed.

**Under-specified abort scope is a safety gap.** A gate that works but doesn't specify what other sub-steps survive a decline can strand the commit in an inconsistent state. Triage in the originating session flagged this as a first-class finding.

## 8. Execution-time re-verification guards

**Rule:** Before any destructive operation that relies on a verdict from the investigation phase, re-run the check that produced the verdict immediately before executing.

**Why:** Investigation happens at plan-authoring time. Execution happens later — sometimes in the same session, sometimes days later when the operator picks up the plan from `~/.claude/plans/`. The working tree can drift between the two. An investigation-time diff that returned empty may return non-empty at execution time because of intervening edits.

**Guards per destructive operation:**

| Operation | Re-verification guard |
|---|---|
| `rm` + `ln -s` (copy-to-symlink conversion) | Re-run `diff <local> <template>`. MUST be empty. Abort the conversion for this file if not. |
| `rm -rf <dir>` | Re-list directory contents via `ls -la`. MUST match the inventory in the plan. Abort if contents differ. |
| `rm <file>` after migrate-then-delete | Re-read the migration destination. MUST contain the migrated content. Abort if not. |
| `git rm --cached <file>` | Re-run `git ls-files --error-unmatch <file>`. MUST confirm the file is tracked. |

**Abort semantics:** If a guard fires, do NOT silently fall back to a safer operation. Stop the commit, surface the guard failure to the operator, and ask how to proceed. The guard failure is new information that the plan did not account for.

## 9. Copy-to-symlink conversion

**Procedure for converting a stale copy of a shared template to a symlink:**

```bash
# 1. Re-verify the diff immediately before the conversion
diff <local-path> <template-path>
# Must be empty. If not, abort this conversion — something changed since investigation.

# 2. Remove the local copy
rm <local-path>

# 3. Create the symlink with a RELATIVE path
ln -s <relative-template-path> <local-path>

# 4. Verify via filesystem (not git)
readlink <local-path>
# Must return the relative path you just created.

# 5. Verify the target resolves
cat <local-path> > /dev/null
# Must exit 0. If not, the symlink is broken — investigate.
```

**Relative path computation:** For a project-level `.claude/commands/<name>.md` → `ai-resources/.claude/commands/<name>.md`, the relative path is typically `../../../../ai-resources/.claude/commands/<name>.md` (four levels up from the symlink location). Always compute it based on the actual directory depth — do not hardcode.

**Post-symlink filesystem read is mandatory.** Not optional. The symlink can be syntactically valid but point at a nonexistent target (typo in relative path, wrong number of `../`). Reading through the symlink is the only test that catches both classes of failure.

**Commit handling:** A `type change (T)` for file → symlink appears in `git status`. Stage it normally with `git add`. Git records the type change and the symlink target in a single commit.

## 10. Migrate-then-delete sequence

**Two-step procedure, both gated:**

**Step A — Migrate:**

1. Read the file to be deleted in full.
2. Identify the load-bearing content that would be lost by a plain delete: which paragraphs, which claims, which examples. Be specific.
3. Identify the canonical destination: usually CLAUDE.md for always-loaded rules, user-scoped memory for collaboration notes, another reference file for methodology. The destination is "where the audience will actually find the content" — not "wherever is convenient."
4. Edit the destination to absorb the content. The edit must be faithful — it must capture the meaning of the original, not just the fact of its existence.
5. Re-read the destination to verify the migration landed and reads coherently in its new context.
6. Stage and commit the migration BEFORE the deletion step. Under no circumstances combine migration and deletion in a single commit — if the deletion fails mid-execution, the migration must already be durable in git history.

**Step B — Delete:**

1. Run the hard-gate protocol (section 7) with the explicit justification: "Content preserved in <destination> by commit <hash>."
2. Execute the `rm` per section 8 (execution-time re-verification).
3. Stage the deletion (git detects it automatically at `git add`).
4. Commit with a message that references the migration commit so the history chain is readable: `chore: remove <file> (content migrated in <short-hash>)`.

**Failure mode to guard against — partial migration:** Migrating the rule but not the rationale is still lossy. Before executing Step B, ask: "What does the destination now contain that the original had? What, specifically, is the delta?" If there is any non-trivial delta, the migration is incomplete — do not proceed.

**Failure mode to guard against — migration destination rot:** The destination file may have its own conventions, length limits, or audience assumptions. Before committing the migration, confirm the edited destination still reads coherently — the migrated content should feel like a first-class section of the destination, not a transplanted foreign body.

## 11. Commit split guidance

**Rule:** Group dirty paths into 3–5 topically coherent commits. Do not fragment for history-aesthetics alone. Do not bundle unrelated concerns.

**Good grouping criteria:**
- All symlink conversions in a single commit (they share the rationale "adopt shared ai-resources").
- All `.gitignore` additions paired with their untrack/delete operations (they share the rationale "stop tracking this class of file").
- All migrate-then-delete pairs split across two commits each (migration first, deletion second), but multiple unrelated migrations can be batched into a single migration commit and a single deletion commit if they share a theme.
- Session-data accumulation (friction log, coaching data, innovation registry) in a single "session: accumulate" commit.
- New project content (plans, documents, context files) in a single "docs:" or "plan:" commit per artifact type.

**Bad grouping:**
- One commit per file "so the history is granular." Five symlink conversions do not need five commits.
- All changes in one commit "to move faster." The commit becomes a grab-bag that no future reader can audit.
- Mixing destructive operations with additive content in the same commit. Deletes should be their own commit so they are easy to revert.

**Commit message convention (from CLAUDE.md):**
- `chore:` for symlink conversions, untracks, gitignore edits, file moves.
- `docs:` for CLAUDE.md and context file changes.
- `plan:` for new plan documents.
- `session:` for session-data accumulation (logs, coaching data).
- `fix:` for bug fixes in scripts or commands.
- `new:` for new skills, agents, or commands.

**Sequence matters.** Migration commits must precede their corresponding deletion commits. Symlink conversions should land before commits that reference the shared templates (so the symlinks resolve in the new commit's state).

## 12. Post-commit verification

**Rule:** After each commit, verify the commit landed correctly by reading the filesystem — not by running `git log` or `git status`.

**Per-commit checks:**
- For each file in the commit, read the path and confirm the content matches what was intended.
- For each symlink conversion, read through the symlink and confirm the target resolves.
- For each deletion, confirm the path no longer exists on disk.
- For each `.gitignore` edit, re-read `.gitignore` and confirm the new pattern is present.

**Why filesystem and not git:** Git status can be misleading after commits — it may show "clean" even when the files on disk don't match intent (edge cases around symlink type changes, line-ending normalization, etc.). The filesystem is authoritative for what the next session will see. See project CLAUDE.md: "Verify files you just wrote by reading them from the filesystem, not by running git status/diff."

## 13. Push and wrap-session

**Rule:** Do NOT push automatically. Pushing stays manual per project rules.

**End-of-session procedure:**
1. Confirm all planned commits landed via post-commit verification (section 12).
2. Run `git log --oneline -<N>` where N is the number of commits executed, and report the list to the operator.
3. Remind the operator: "Push manually when ready, then run `/wrap-session` to log this session's work and decisions."
4. Do NOT run `/wrap-session` from inside this skill. The cleanup session produces its own wrap-session entry, but that is a separate invocation — not a subroutine of cleanup execution.

**If the session is interrupted mid-execution:** Write a scratchpad to `logs/scratchpads/` containing: which commits landed, which commits are pending, which hard gates remain, and the path to the plan file. The next session can resume from the scratchpad without re-running investigation.
