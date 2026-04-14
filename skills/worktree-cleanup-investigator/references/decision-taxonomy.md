# Decision Taxonomy: Per-File Classifications

Every dirty path investigated under `worktree-cleanup-investigator` is assigned exactly one of seven decisions. This file defines each decision: when it applies, what evidence is required, and what execution steps follow. For the hard-gate protocol and commit split guidance, see `execution-protocol.md`.

## Table of Contents

- [Overview decision tree](#overview-decision-tree)
- [1. commit](#1-commit) — stage and keep
- [2. untrack](#2-untrack) — `git rm --cached`, leave on disk
- [3. delete](#3-delete) — remove from index and filesystem
- [4. gitignore](#4-gitignore) — add pattern to `.gitignore`
- [5. convert-to-symlink](#5-convert-to-symlink) — stale copy of a shared template
- [6. keep-as-local-fork](#6-keep-as-local-fork) — intentional divergence from a shared template
- [7. migrate-then-delete](#7-migrate-then-delete) — lift content, then delete
- [Combining decisions](#combining-decisions) — when a single path needs multiple actions

## Overview decision tree

```
For each dirty path:

  Is the path a shared-library candidate (.claude/commands/*.md,
  .claude/agents/*.md, .claude/hooks/*)?
  │
  ├── YES → run scripts/find-template.sh
  │        │
  │        ├── IDENTICAL → decision 5 (convert-to-symlink)
  │        ├── DIVERGED  → investigate divergence
  │        │               ├── intentional fork → decision 6 (keep-as-local-fork)
  │        │               └── stale copy      → decision 5 (convert-to-symlink)
  │        └── NO_TEMPLATE_FOUND → continue below
  │
  └── Is the path already matched by .gitignore but tracked?
      │
      ├── YES → decision 2 (untrack) — usually paired with decision 4 if the
      │          pattern isn't already in .gitignore
      │
      └── NO → Is the path content redundant with a canonical destination?
               │
               ├── YES, fully preserved elsewhere → decision 3 (delete)
               │   (hard-gate required)
               │
               ├── YES, rule preserved but WHY is lost → decision 7
               │   (migrate-then-delete)
               │
               └── NO, path is legitimately new/modified → decision 1 (commit)
```

## 1. commit

**Definition:** Stage and keep. The file is a legitimate tracked modification or a new file that belongs in the repo.

**When it applies:**
- Tracked file modified by real work (content, logs, plans, session data).
- Untracked file that is new project content (new chapter draft, new plan, new context file).
- Untracked symlink into shared ai-resources that needs to be registered in the repo.

**Evidence required:**
- Open the file and confirm its content makes sense as a deliberate change, not accidental drift.
- For logs and auto-accumulating files (friction log, coaching data, innovation registry), confirm the file is one of the known session-data paths — no content review needed.
- For new content, confirm the file's path and naming conform to project conventions.

**Execution:**
```
git add <path>
```
Stage with other topically related paths into a single commit. See `execution-protocol.md` → "Commit split" for grouping guidance.

**Risks:**
- Committing secrets accidentally (.env, credentials). Before staging, scan the filename and the first few lines for secret-shaped content. If anything looks sensitive, halt and ask the operator.
- Committing scratchpads or in-progress drafts that the operator intended to delete. When in doubt about intent, ask.

## 2. untrack

**Definition:** Remove from the git index but leave on disk. Equivalent to `git rm --cached`.

**When it applies:**
- File is tracked but already matched by a `.gitignore` pattern — it was committed before the ignore rule landed, and the repo has been carrying modifications to it as noise ever since. Common examples: `.DS_Store`, editor swap files, local settings.
- File should not be in the repo at all (secrets, generated artifacts) but is already tracked.

**Evidence required:**
- Confirm the path appears in `.gitignore` (directly or via pattern match).
- If not in `.gitignore`, this decision usually pairs with decision 4 (add the pattern to `.gitignore` in the same commit).

**Execution:**
```
git rm --cached <path>
```
File remains on disk. If the operator wants it deleted too, that's decision 3 instead.

**Risks:**
- Confusion about what `--cached` does. It removes the index entry only. If you run plain `git rm <path>`, it also deletes the file. Be explicit in the command.

## 3. delete

**Definition:** Remove from both the index and the filesystem. Irreversible within the commit.

**When it applies:**
- File contains content that should not exist on disk anywhere (secrets, confidential data accidentally saved).
- Legacy file whose content is fully preserved in a canonical location with no loss of substance.
- Stale artifact from a previous workflow that is no longer referenced anywhere.

**Evidence required:**
- **Read the file content first.** Never propose deletion without having read what's being deleted.
- Confirm that every piece of load-bearing content is preserved elsewhere. If anything is lost by the deletion, reclassify as decision 7 (migrate-then-delete).
- For files that were once canonical (rules, memory, historical records), be especially rigorous. "I can reconstruct it from git history" is insufficient justification — deletions are removed from working state, which is what future sessions read.

**Execution:** Gated by the **hard-gate protocol** in `execution-protocol.md`. Must display file content, state irreversibility, require explicit confirmation phrase ("delete X" or "proceed with deletion of X" — not "ok"), specify abort scope for other sub-steps in the same commit, then execute:
```
rm <path>              # for a file
rm -rf <dir>           # for a directory
```
If the file is tracked, follow with `git rm` or let git detect the deletion at `git add`.

**Risks:**
- Irreversible within the commit. The safety net is the hard gate and the abort scope, not git reflog (which doesn't cover filesystem deletions).
- Bias toward deletion under execution pressure. The hard gate is NOT optional, even if the content looks obviously disposable.

## 4. gitignore

**Definition:** Add a pattern to `.gitignore` to prevent the path from being tracked in future sessions.

**When it applies:**
- Path is a class of file that should never be committed (memory directories, scratchpads, local settings, OS artifacts).
- Paired with decision 2 (untrack) or decision 3 (delete) when the pattern is missing from `.gitignore`.
- Standalone when the pattern is missing and the file does not currently exist but might be recreated.

**Evidence required:**
- Confirm the pattern is not already in `.gitignore` (check both exact match and pattern match).
- Confirm the pattern scope is correct: `.DS_Store` matches all directories; `memory/` matches only top-level; `**/scratchpad.md` matches all subdirectories.

**Execution:** Edit `.gitignore`, append the pattern, stage the `.gitignore`:
```
# manual edit: append "memory/" to .gitignore
git add .gitignore
```
Never overwrite existing ignore rules; only append.

**Risks:**
- Overly broad patterns that accidentally ignore legitimate files. When in doubt, use a more specific pattern (`memory/`, not `memory*`).

## 5. convert-to-symlink

**Definition:** The local file is byte-identical to a shared ai-resources template. Replace the local file with a symlink into the template.

**When it applies:**
- `scripts/find-template.sh` returns `IDENTICAL <template-path>` for the file.
- The path is in `.claude/commands/`, `.claude/agents/`, or `.claude/hooks/`.
- The project's CLAUDE.md or operator guidance does NOT mark this specific file as an intentional local fork.

**Evidence required:**
- Script verdict: `IDENTICAL`.
- A re-run of the diff at execution time (not just at investigation time) returns empty. See `execution-protocol.md` → "Execution-time re-verification guards."
- No operator instruction to preserve the file as a local copy.

**Execution:** Follow the conversion protocol in `execution-protocol.md` → "Copy-to-symlink conversion." The per-file sequence is:
```
diff <local> <template>                    # MUST be empty — abort if not
rm <local>
ln -s <relative-template-path> <local>
# read the new symlink via filesystem to verify the target resolves
```
Relative path is typically four levels up (`../../../../ai-resources/...`) for project-level `.claude/commands/*` — but always compute it, don't hardcode.

**Risks:**
- Silently discarding working-tree modifications. The `rm` removes what was there. The re-verification guard exists to prevent this — if the diff is non-empty at execution time, abort.
- Broken symlinks. The post-`ln -s` filesystem read catches this.
- `ai-resources/` not mounted. If `find-template.sh` can't find `ai-resources/`, the script exits with code 3 — abort the cleanup session entirely, not just this file.

## 6. keep-as-local-fork

**Definition:** The file intentionally differs from a shared template. Commit the local version; do NOT convert to a symlink.

**When it applies:**
- `scripts/find-template.sh` returns `DIVERGED <template-path>` AND the divergence is deliberate.
- OR the project's CLAUDE.md or operator has explicitly designated this file as a local fork.
- Example from Axcion: `.claude/commands/prime.md` has project-specific scratchpad logic, references "Axcíon buy-side service model", and addresses the operator by name. It is a legitimate fork — not a stale copy.

**Evidence required:**
- Script verdict: `DIVERGED`.
- **Read the diff content.** If the differences are cosmetic or look like they could have been upstreamed, ask the operator whether this is a deliberate fork or an accidental divergence that should be reconciled with the template.
- **Ask the operator if there is any doubt.** "Keep as local fork" is the wrong choice when the correct answer is "upstream the changes to the template, then convert to symlink." Do not silently classify a divergence as intentional.

**Execution:**
```
git add <path>
```
Commit with other local forks or project-specific changes.

**Risks:**
- Misclassification. A stale copy that looks like it has "substantial differences" may actually be a forgotten upstreaming opportunity. Bias toward asking the operator when the divergence rationale is unclear.
- Preserving drift that should have been cleaned up. This decision perpetuates a divergence — only use it when divergence is the right answer.

## 7. migrate-then-delete

**Definition:** The file carries load-bearing content that is NOT preserved elsewhere. Lift the content to a canonical destination first, then delete the original.

**When it applies:**
- Deletion would lose substantive content (rules, rationale, historical records) that has no canonical home.
- A canonical destination exists or can be created: CLAUDE.md, user-scoped memory, another reference file, an inline section in a related artifact.
- The operator prefers zero-loss cleanup over faster cleanup.

**Evidence required:**
- **Read the file in full.** Never propose a migration for a file whose content you haven't read end-to-end.
- Identify what would be lost by a plain delete. Be specific: which paragraphs, which claims, which examples.
- Identify the canonical destination and why it's the right place. Usually: the file where the content's audience will actually find it (CLAUDE.md for always-loaded rules; user-scoped memory for personal collaboration notes; a reference file for methodology).
- Confirm the migration is faithful. The migrated content must capture the meaning of the original, not just the fact of its existence.

**Execution:** Two-step sequence, both gated:
1. **Migrate:** edit the canonical destination to absorb the content. The edit must be reviewable by the operator before step 2 proceeds.
2. **Delete:** follow the hard-gate protocol for decision 3, now with the justification that the content is preserved.

Often paired with decision 4 (gitignore the path so it doesn't get recreated).

**Risks:**
- Partial migration. If you migrate the rule but not the rationale, the deletion is still lossy. Always ask: "What does the destination now contain that the original had?"
- Treating migrate-then-delete as a formality. The migration edit is a real edit that affects the destination's readability and may conflict with existing content. Review it as if it were a standalone edit, not a transcription.

## Combining decisions

Some paths need more than one decision applied:

| Situation | Decisions | Example |
|---|---|---|
| Tracked file matched by `.gitignore`, pattern missing from `.gitignore` | untrack + gitignore | `.DS_Store` was committed before `.gitignore` rule landed; already ignored but still tracked |
| Untracked directory that's also a class that should be ignored | delete + gitignore | legacy `memory/` directory: delete the directory, add `memory/` to `.gitignore` to prevent recreation |
| Shared template copy that carries local-only "Why" rationale | migrate-then-delete + convert-to-symlink (in two commits) | a stale copy of a shared skill with a project-specific comment appended — lift the comment into the project's CLAUDE.md or reference file, then replace the local copy with a symlink |
| Tracked file now deprecated, but with content that belongs in another canonical file | migrate-then-delete + gitignore (optional) | legacy rule file whose rule is now in CLAUDE.md |

When a path needs multiple decisions, sequence them within a single commit where possible, and use the hard-gate protocol for any destructive sub-step. If the migration destination is in a separate commit than the deletion, commit the migration FIRST so the destination is in place before the deletion executes.
