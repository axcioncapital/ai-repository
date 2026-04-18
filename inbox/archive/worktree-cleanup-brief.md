# Resource Brief: worktree-cleanup-investigator

**Requested:** 2026-04-13
**Origin:** buy-side-service-plan project — session that spent substantial effort reconstructing a dirty-worktree cleanup flow from scratch, with two QC passes catching factual errors and under-specified safety gates that would have caused real harm if executed.

## Capability

A reusable command/skill pair (provisionally `/cleanup-worktree` + `worktree-cleanup-investigator`) that investigates every dirty path in `git status`, produces a per-file classification plan, runs independent QC and triage on the plan before execution, and executes the cleanup behind explicit safety gates for irreversible operations. Turns ad-hoc "I don't remember what I did across the last five sessions" cleanup into a structured, auditable flow.

Per-file classifications available:
- **commit** (keep and stage)
- **untrack** (`git rm --cached`, leave on disk)
- **delete** (filesystem `rm`, gated by hard pause)
- **gitignore** (add to `.gitignore`, possibly combined with delete)
- **convert-to-symlink** (stale copy of a shared `ai-resources` file)
- **keep-as-local-fork** (legitimately diverged from a shared template)
- **migrate-then-delete** (lift load-bearing content into a canonical location — CLAUDE.md, user-scoped memory, another file — then delete the legacy location)

## Trigger Conditions

Activate when the operator says any of:
- "clean up the working tree"
- "investigate the dirty files"
- "I don't remember what I did in previous sessions"
- "the working tree is messy"
- "/cleanup-worktree" (once the command ships)

Also appropriate when `git status` shows 10+ dirty paths and the operator has lost track of their provenance, or when a `/wrap-session` discovers drift that predates the current session.

## Exclusions

The skill does NOT:
- Push to remote (pushing stays manual per project rules)
- Handle single-file fixes or routine commits — use regular commit flow for those
- Do workspace health audits (use `/audit-repo` / `repo-health-analyzer`)
- Do structural / judgment audits (use `/repo-dd` / `/repo-review` once built)
- Create or modify skills (use `/create-skill` / `/improve-skill`)
- Run during the middle of a content-production session — it's for dedicated cleanup sessions

## Context

The session that surfaced this need executed all of the following manually:

1. **Investigation phase** — read every dirty path, classify each, diff modified files against `ai-resources` equivalents, check both `.claude/commands/` and `workflows/*/.claude/commands/` (missing one subdirectory caused a real false negative).
2. **Plan authoring** — per-file recommendations table, proposed commit split (5 topically coherent commits), verification criteria, safety gates for irreversible operations.
3. **First QC pass** (via `qc-pass`) — caught a factual error (claimed 3 files were "not in ai-resources" when they were in the workflow-template subdirectory); also caught under-specified abort conditions on the hard-gate.
4. **Triage pass** (via `triage`) — prioritized QC findings, flagged the "migrate-then-delete" option as a first-class alternative to lossy deletion, identified the hidden branch where stale copies should become symlinks, not committed as forks.
5. **Plan revision** — addressed all Do-rated findings.
6. **Second QC pass** — caught a fabricated detail in the revised plan (fictional "Apr 7 session incident" reference that wasn't actually in the file being summarized). Reinforced: always read the file you're summarizing; never infer provenance details.
7. **Execution** — per-file diff re-verification at execution time (guards against working-tree drift between investigation and execution), `rm` + `ln -s` conversion with post-symlink filesystem read verification, hard interactive pause before `rm -rf memory/`, migrate-then-delete for memory rationale (lifted the "Why" paragraph into CLAUDE.md), 5 commits, push.

Each of those steps is load-bearing. Without a canonical skill that encodes them, the next cleanup session will rebuild this flow with the same friction and probably miss one of the safety steps.

### Load-bearing rules the skill must encode

- **Symlink-not-copy rule enforcement.** For any `.claude/commands/*` or `.claude/agents/*` dirty path, check ALL `ai-resources` subdirectories where that category of file might live — at minimum `ai-resources/.claude/commands/` AND `ai-resources/workflows/*/.claude/commands/`. Missing one caused a false "not in ai-resources" verdict in the session that prompted this brief. If the local file is byte-identical to any template, it is a stale copy and must be converted to a symlink, not committed as a local fork.
- **Mandatory plan mode.** No mutations before the plan file is written and the operator approves via `ExitPlanMode`.
- **Independent QC before approval.** Run `qc-pass` as a subagent against the plan. The subagent receives the plan and the original operator request — not the creation conversation. Independence is what catches fabrications.
- **Independent triage after QC.** Run `triage-reviewer` as a subagent over the proposed responses to QC findings, not over the plan itself. Triage catches under-specified abort conditions and judges whether a proposed revision is necessary or history-quality-only.
- **Second QC pass after plan revision.** The first revision introduces new content; the new content must be independently re-verified. Today's session found a fabrication in the revision that the first QC couldn't catch.
- **Hard-gated irreversible operations.** Every `rm -rf`, `git rm --cached` (if the file is about to be deleted on disk too), type change that discards working-tree content, or `rm` + `ln -s` conversion must be gated by a mandatory interactive pause with an explicit confirmation phrase. Silence, "ok", "proceed", or generic acknowledgment are NOT sufficient — the phrase must name the operation ("delete memory", "convert to symlink", etc.).
- **Explicit abort scope for every hard gate.** Every pause must specify: if the operator declines, which OTHER sub-steps in the same commit still execute, and which subsequent commits are affected. Under-specified abort clauses are safety gaps even when the primary gate works.
- **Execution-time re-verification guards.** Before any `rm` that relies on a prior diff verdict, re-run the diff immediately. Guards against working-tree drift between investigation and execution, which may be in separate sessions.
- **Migrate-then-delete as a first-class option.** When about to delete a file that carries load-bearing content (rationale, provenance, operational knowledge), first ask: is the content preserved elsewhere? If not, can it be lifted into a canonical location (CLAUDE.md, user-scoped memory, another artifact) before deletion? Converting a lossy deletion into a zero-loss migration removes the primary objection to deletion.
- **Post-commit verification via filesystem, not git.** Per project CLAUDE.md: verify files you just wrote by reading them from the filesystem. For symlink conversions, read each symlink after staging to confirm the target resolves.
- **Commit split is topical, not fine-grained.** 3–5 commits for a session's worth of drift is usually right. Don't fragment for history-aesthetics alone — but don't bundle unrelated concerns either.
- **Don't push automatically.** Pushing stays manual per project rules. End with a reminder to push and `/wrap-session`.

### Lessons the skill must teach the running agent

1. **Check all ai-resources subdirectories, not just one.** Missing one caused a false "not in ai-resources" verdict on three files.
2. **Never fabricate details about files you're summarizing.** If you claim a file "references an Apr 7 incident," the date must come from the file, not your inference. Always re-read the file before making factual claims about it.
3. **Migrate-then-delete beats lossy deletion.** When the only objection to deleting a file is "we lose the Why," lift the Why into CLAUDE.md or the user-scoped memory first, then delete.
4. **Second QC pass catches what the first can't.** A plan revision introduces new text. The new text hasn't been independently reviewed. Running a second QC pass after revision is not optional.

## Existing Skills Reviewed

- `repo-health-analyzer` (triggered by `/audit-repo`) — does workspace health audits (file org, CLAUDE.md health, skill inventory, commands, settings, hooks). Does NOT investigate dirty worktree paths or plan commit sequences. No overlap.
- `workspace-template-extractor` — extracts a reusable project template from a mature workspace. Different purpose. No overlap.
- `session-guide-generator` — produces session guides. Different purpose. No overlap.
- `ai-resource-builder` — creates/improves skills. Different purpose. No overlap.
- Existing inbox brief `repo-review-brief.md` — proposes `/repo-review` as an operational health/judgment layer complementing `/repo-dd`. Reads friction logs, tests pipelines, assesses feature criticality. Does NOT handle dirty-worktree investigation or commit planning. Adjacent but non-overlapping — could call each other (this skill could flag "worktree drift is a recurring friction pattern, consider a quarterly `/repo-review`") but they are distinct commands.

None of the existing skills cover "investigate dirty worktree, plan cleanup commits, enforce symlink-not-copy, gate irreversible operations, execute safely." The gap is real and not addressable by improving an existing skill.

## Relationship to Other Commands

- **`/audit-repo`** — workspace-level health audit; does not touch git state.
- **`/audit-structure`** — folder-convention validator; does not touch git state.
- **`/wrap-session`** — commits session data at session end; assumes the working tree is otherwise clean and does not investigate accumulated drift.
- **`/repo-dd`** (existing) — factual audit of repo contents and git history; produces structured reports without commentary. This skill could optionally read the most recent `/repo-dd` output as input to avoid re-auditing what's already been audited.
- **`/repo-review`** (briefed, not yet built) — operational judgment layer; reads friction logs and assesses feature criticality. Adjacent but different.
- **`/commit`** (existing shared command) — routine single-session commit flow; assumes you already know what you're committing. This skill is for the case where you don't.

## Suggested Command Name

**`/cleanup-worktree`** is the preferred name — matches the existing hyphenated-verb-noun convention (`/audit-repo`, `/wrap-session`, `/draft-section`) and states intent clearly. Alternative: `/investigate-dirty-tree`, but it's longer and less action-oriented.
