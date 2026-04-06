# Session Rituals — Patrik & Daniel

Quick reference for working with Claude Code in the Axcion AI workspace.

---

## Session Start

1. **`/prime`** — Orient the session. Reads workspace state, briefs you, waits for direction.
2. **Pull latest** — `git pull` (if `/prime` didn't already).
3. **Read the relevant SKILL.md** before starting any task that has a matching skill.

## Before Starting Work

- **`/clarify`** — Before executing an ambiguous request. Forces scope alignment first.
- **`/scope`** — Produce a scope summary of the conversation so far.

## During the Session

- **`/friction-log [what happened]`** — Log anything awkward, slow, or broken. Just describe it, don't diagnose.
- **`/note [observation]`** — Log a workflow observation as it happens.
- **`/triage`** — When Claude proposes changes or suggestions, run this before approving to get them prioritized.

## After Producing Work

- **`/qc-pass`** — Run a quality check on work just produced. Default after every creation or improvement.
- **`/refinement-pass`** — Run a refinement pass on work just produced (after QC passes).

## Pre-Compact Checkpoint (~50% context)

When context gets heavy, write a **session-state scratchpad** to the working directory:
- Current step, decisions made, partial findings, artifact file paths.
- Then `/clear` + restart (reading the scratchpad). Prefer this over `/compact`.

## Before Committing

- Review the diff Claude shows you.
- Commit messages: `new:`, `update:`, `batch:`, `fix:`.
- Never push without explicit approval.

## Session End

1. **`/wrap-session`** — Wraps the session, triggers logging.
2. **`/improve`** — Reviews friction log, finds patterns, proposes fixes. Choose **apply**, **log**, or **dismiss** for each.
3. **`/usage-analysis`** — Optional. Analyzes the session's token efficiency and logs a review. Good for spotting waste patterns over time.
4. **`/coach`** — Reviews collaboration patterns across sessions. Run periodically, not necessarily every session.

## After Significant Workspace Changes

- **`/repo-dd`** — Factual audit only (Steps 1-6).
- **`/repo-dd deep`** — Factual audit + operational assessment with judgment (Steps 1-13).
- **`/repo-dd full`** — Everything including pipeline testing (Steps 1-14).
- **`/audit-repo`** — Lighter workspace health audit (subset of repo-dd).

## On-Demand — As Needed

- **`/request-skill`** — Skill gap surfaces during work? Capture the need to `inbox/`.
- **`/create-skill`** — Build a new skill through the canonical pipeline.
- **`/improve-skill`** — Modify an existing skill through the canonical pipeline.
- **`/migrate-skill`** — Convert an existing Chat prompt into a Claude Code skill.
- **`/graduate-resource`** — Promote a project-level resource to the shared library.
- **`/new-project`** — Create a new project through the project pipeline.
- **`/deploy-workflow`** — Deploy a workflow template to a new project.
- **`/sync-workflow`** — Compare a deployed project's tooling against its canonical template. Shows what's drifted and lets you choose what to update.
- **`/session-guide`** — Generate a session-by-session execution guide for a project.
- **`/update-claude-md`** — Add or update a rule in the project CLAUDE.md.
