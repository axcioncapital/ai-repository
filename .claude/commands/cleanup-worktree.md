---
friction-log: true
---

Investigate dirty paths in the git working tree, plan a safe cleanup with independent QC and triage, and execute behind hard gates for irreversible operations.

Input: $ARGUMENTS (optional) — any operator notes about what triggered the cleanup, what to prioritize, or which files to handle specially. Treated as the "original operator request" recorded in the plan file Section 1. If empty, use the operator's invocation statement as the request.

**This command is not a trivial wrapper.** It encodes the invocation contract for `worktree-cleanup-investigator`: mandatory plan mode, two independent QC subagents with triage between them, hard gates with named confirmation phrases, execution-time re-verification guards, post-commit filesystem verification. Deviating from the sequence is a safety failure. Read the skill's SKILL.md and the two reference files before executing any step that follows.

---

## Step 1: Verify prerequisites

1. Confirm `ai-resources/` is mounted — required because `worktree-cleanup-investigator` depends on `find-template.sh` walking up from CWD to find the `ai-resources` sibling. If `ai-resources/` is not accessible from the current working directory, STOP and surface to the operator — do not attempt a text-based fallback for template detection.
2. Confirm git state is clean-baseline — run `git status` and check for in-progress rebase, merge conflict, or detached HEAD. If any of those apply, STOP and instruct the operator to resolve the underlying state first.
3. Locate the skill: `ai-resources/skills/worktree-cleanup-investigator/SKILL.md`. If missing, STOP — the command cannot run without the skill.

## Step 2: Enter plan mode

4. Enter plan mode immediately. All subsequent steps up through Step 9 run in plan mode. No mutations to the working tree, the index, the filesystem, or `.gitignore` occur before `ExitPlanMode` is called in Step 10.
5. Read-only operations permitted throughout: `Read`, `Glob`, `Grep`, `Bash` for `git status`, `git diff`, `git log`, `cat`, `ls`, and `scripts/find-template.sh`. Every other tool is off-limits until plan mode exits.

## Step 3: Load the skill

6. Read `ai-resources/skills/worktree-cleanup-investigator/SKILL.md` in full.
7. Read `ai-resources/skills/worktree-cleanup-investigator/references/decision-taxonomy.md` — required for per-path classification.
8. Read `ai-resources/skills/worktree-cleanup-investigator/references/execution-protocol.md` — required for the plan schema, QC/triage contracts, hard-gate protocol, and execution mechanics.

## Step 4: Investigate dirty paths

9. Run `git status --porcelain=v1` and capture the full output.
10. For each dirty path in the output, apply the investigation protocol from `execution-protocol.md` section 2:
    - Read the file content (`Read` — actually open it, do not classify from filename). For deleted paths (status codes `D` or `AD`, where the file no longer exists on disk), use `git show HEAD:<path>` to recover the last-tracked content. Do not skip the read step for deletions — classification still requires inspecting what was deleted.
    - Note the git status code.
    - **Run `find-template.sh` for every path that could plausibly have a canonical template elsewhere in `ai-resources/`.** This includes (but is not limited to) `.claude/commands/*.md`, `.claude/agents/*.md`, `.claude/hooks/*`, and any path whose directory structure mirrors a known `ai-resources/` subdirectory (skills/, prompts/, workflows/, scripts/, docs/). Never check subdirectories manually — the script mechanically walks all ai-resources locations and is the root-cause fix for the false-negative class. If the script exits with code 3 (ERROR), STOP and surface to operator.
    - Check `.gitignore` interactions.
    - Check for canonical-destination content (CLAUDE.md, user-scoped memory, reference files) if the file carries rules, rationale, or operational knowledge.
    - Assign a decision from `decision-taxonomy.md`.
11. Apply all four bias counters from the skill explicitly: (1) never fabricate file details — re-read files before making any factual claim; (2) always run `find-template.sh` — never check ai-resources subdirectories manually; (3) the second QC pass is mandatory — do not skip it even under time pressure; (4) hard gates require named confirmation phrases — "ok" / "proceed" / "sure" do NOT clear a gate.

## Step 5: Write the plan file

12. Write the plan to `~/.claude/plans/cleanup-worktree-<YYYY-MM-DD-HHMM>.md`, following the eight-section schema defined in `execution-protocol.md` → "Plan file schema":
    1. Original operator request (from $ARGUMENTS or the invocation statement)
    2. Git status snapshot (raw output from Step 4 step 9)
    3. Per-path classification table (path, status, decision, evidence, gate?, commit group)
    4. Hard-gate inventory (one block per gate: operation, files affected, confirmation phrase, abort scope, justification)
    5. Commit split (ordered list: #, subject, paths, depends on, gate reference)
    6. Execution-time re-verification checklist (one line per destructive operation)
    7. Bias-counter checklist (declared acknowledgment)
    8. Revision history (initially empty)
13. A plan missing any section is structurally invalid. Before proceeding, verify all eight sections are present AND cross-check that every irreversible operation is gated: scan Sections 3 (per-path classification) and 5 (commit split) for any decision of `delete`, `convert-to-symlink` (type change via `rm` + `ln -s`), `migrate-then-delete` (the delete step), or `git rm --cached` paired with filesystem removal. Every such operation MUST appear as a hard-gate block in Section 4. An ungated irreversible operation is a structural failure — fix before the first QC pass, not after.
14. Populate Section 7 (bias-counter checklist) with an enumerated acknowledgment of all four bias counters: (1) "Counter 1 — files re-read before classification on YYYY-MM-DD HH:MM (no claims from filename alone)"; (2) "Counter 2 — find-template.sh run for paths: \<list>"; (3) "Counter 3 — second QC pass scheduled in Step 9"; (4) "Counter 4 — confirmation phrases declared in Section 4 hard-gate blocks". Section 7 is the audit artifact the QC subagents verify against. An empty Section 7 is a structural failure.

## Step 6: First QC pass (independent subagent)

14. Spawn a QC subagent. Subagent type: `qc-gate` if available in the current project's `.claude/agents/`, else `general-purpose` with the qc-gate skill content embedded.
15. Inputs the subagent receives:
    - The plan file content (read it and pass it verbatim, do not pass the path alone — context isolation rule)
    - The original operator request (Section 1 of the plan)
    - The git status snapshot (Section 2 of the plan)
    - The evaluation criteria: structural completeness (all 8 sections present), factual accuracy (claims about files match file content), gate coverage (every irreversible operation has a hard-gate block), abort-scope completeness (every gate specifies what other sub-steps survive a decline)
16. Inputs the subagent does NOT receive: this conversation, the creation context, any private reasoning about why decisions were made.
17. Capture the subagent's full QC report. Do not summarize it.

## Step 7: Triage pass (independent subagent)

18. Spawn a triage subagent. Subagent type: `triage-reviewer`.
19. Inputs:
    - The QC report from Step 6
    - The plan file content
    - Your proposed responses to each QC finding (one per finding: "will fix", "will clarify", "history-only", or "disagree — defend")
20. Inputs NOT received: the creation conversation.
21. Capture the triage output: must-fix findings, should-fix findings, history-only findings, and any first-class alternatives the triage reviewer surfaces.

## Step 8: Plan revision

22. Revise the plan file to address every must-fix finding from triage and any should-fix findings the operator confirms. Use `Edit` on the plan file only. Do not touch any other file.
23. Append to Section 8 (Revision history) of the plan: each finding, the proposed response, and the exact plan edit that addressed it. The second QC pass will read this section to verify faithfulness.
24. Re-apply the "never fabricate file details" bias counter to the revision. New content introduced by the revision must be independently verifiable — re-read any file you make factual claims about.

## Step 9: Second QC pass (MANDATORY)

25. Spawn a second QC subagent with the same isolation contract as Step 6. Additional input: the first QC report from Step 6 (so the subagent can verify revisions addressed findings faithfully rather than deflecting them).
26. Exit criteria:
    - BLOCKING issues found → loop back to Step 8 (revise again). Maximum 2 full revision cycles. On cycle 3, STOP and surface the loop to the operator — there is something structurally wrong with the plan or the approach.
    - Only MINOR issues found → proceed with issues logged in the plan's Section 8.
    - Clean → proceed.

## Step 10: ExitPlanMode and operator approval

27. Call `ExitPlanMode` with the revised plan as the argument. The harness will present the plan to the operator.
28. Wait for explicit operator approval. Do not proceed to execution without it.

## Step 11: Execute commits in order

29. For each commit in Section 5 (Commit split) of the plan, execute in order:
    a. For each destructive operation in this commit, run the execution-time re-verification guard from Section 6 of the plan — immediately before the destructive command, not at investigation time. If the guard fires (diff non-empty, inventory mismatch, git ls-files verdict wrong, etc.), STOP the current commit, surface the guard failure to the operator, and ask how to proceed. Do NOT silently fall back.
    b. For each hard-gate block referenced by this commit (Section 4 of the plan), run the hard-gate protocol:
       - Display the content being destroyed.
       - State the irreversibility.
       - Require the named confirmation phrase verbatim. Generic affirmatives ("ok", "proceed", "sure") DO NOT clear the gate.
       - If the operator declines, apply the abort scope from the gate block exactly as specified. Do not improvise.
    c. After all destructive operations in this commit pass their gates and guards, execute the operations.
    d. Stage the changes with `git add` (specific paths, not `-A`).
    e. Commit with the subject line specified in the plan's Commit split.

30. After each commit lands, run post-commit verification from the filesystem (not `git status` or `git diff`):
    - Read each committed file and confirm content matches intent.
    - For each symlink conversion, `readlink` the symlink and `cat` through it to confirm the target resolves.
    - For each deletion, confirm the path no longer exists on disk.
    - For each `.gitignore` edit, re-read `.gitignore` and confirm the new pattern is present.

## Step 12: Report and wrap

31. Report to the operator:
    - Number of commits landed with hashes and subject lines
    - Hard-gate confirmation phrases received (verbatim, for audit)
    - Any residual unresolved issues from MINOR findings that were logged but not fixed
    - Reminder: "Push manually when ready. Then run `/wrap-session` to log this session's work and decisions."
32. DO NOT push. DO NOT run `/wrap-session` from inside this command. Both are separate manual operator steps.

---

## Failure escalation

If any step fails in a way not covered by the plan's abort scope:

- **`find-template.sh` exits 3 (ERROR)** — abort the cleanup session entirely. The skill depends on `ai-resources/` being accessible.
- **Second QC pass loops on cycle 3 without convergence** — stop. Surface the loop to the operator. Something structural is wrong with the plan.
- **Hard gate declined and abort scope is ambiguous** — stop the commit. Ask the operator to clarify which sub-steps should still execute.
- **Execution-time re-verification guard fires** — stop the commit. Do not fall back to a safer operation. Surface the guard failure.
- **Working tree becomes dirty from an unexpected source mid-execution** — stop. Something outside the cleanup flow is making changes. Investigate before continuing.
- **Operator requests to skip QC, skip triage, or shorten the review sequence** — REFUSE. Both QC passes and the triage pass are the load-bearing safety property of this command. Surface the refusal explicitly ("the second QC pass is mandatory per the skill's invocation contract") and continue the protocol as written. If the operator insists after the explanation, surface the risk in writing, only proceed if they confirm they accept responsibility for a cleanup without independent review, and log the exception explicitly in the plan's Section 8 (revision history) so the decision is auditable.

## Not this command's job

- **Pushing to remote.** Push stays manual per project rules.
- **Running `/wrap-session`.** Separate command, separate invocation.
- **Workspace health audit.** Use `/audit-repo`.
- **Structural or judgment audit of repo contents.** Use `/repo-dd`.
- **Creating or modifying skills.** Use `/create-skill` or `/improve-skill`.
- **Single-file commits.** Regular commit flow.
- **Running during an active content-production session.** Cleanup is a dedicated session, not a sidebar.
