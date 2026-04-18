# Session Rituals — Patrik & Daniel

Quick reference for working with Claude Code in the Axcion AI workspace.

---

## Session Start

1. **`/prime`** — Orient the session. Reads workspace state, briefs you, waits for direction.
2. **Pull latest** — `git pull` (if `/prime` didn't already).
3. **Read the relevant SKILL.md** before starting any task that has a matching skill.
4. **Declare the exit condition** — State one line: "This session is done when X." Examples: "done when 2.5 is approved," "done when all pending improvements are actioned." Without this, sessions drift and bleed into each other.
5. **Set autonomy level** — State what Claude should auto-proceed on vs. pause for. Example: "Auto-apply all non-bright-line QC fixes. Show me bright-line items only. Auto-proceed through challenge unless verdict is EXPOSED or BROKEN."

### Start with outcomes, not commands

Instead of "/draft-section 2.5", say "I want section 2.5 drafted, QC'd, challenged, and reviewed today. Only stop for bright-line items and failed verdicts." Use plan mode at the session level — define the full arc, not just the first step.

### First session of the week: full project scan

Go beyond `/prime` (which shows the last session). Run a broader scan: "Read the content architecture. For each section, report: approved / in-progress / not started. List any open questions from the last 5 session entries. List any pending improvements older than 3 days." This gives you the weekly strategic view that daily heads-down sessions miss.

## Before Starting Work

- **`/clarify`** — Before executing an ambiguous request. Forces scope alignment first.
- **`/scope`** — Produce a scope summary of the conversation so far.

## During the Session

- **`/friction-log [what happened]`** — Log anything awkward, slow, or broken. Just describe it, don't diagnose.
- **`/note [observation]`** — Log a workflow observation as it happens.
- **`/triage`** — When Claude proposes changes or suggestions, run this before approving to get them prioritized.

### After approving any section: 60-second coherence scan

Before moving to the next section, ask: "Read all approved sections in the approved directory. In 5 sentences, flag any contradictions, redundancies, or assumptions that conflict across sections." Takes 60 seconds, catches cascade issues before they compound.

### Before giving feedback on a draft: state what's working first

Your feedback is specific and actionable — but if it's always corrections, the drafter only learns what to avoid, never what to keep. Before corrections, note what works: "The three-lens framework structure works, keep that. The evidence calibration on the retainer argument is exactly right." This builds a counterpart to correction-based learning — first drafts improve because the drafter preserves what works, not just avoids what doesn't.

### Use `/compact` strategically

After approving a section, compact before starting the next one. Apply the same pattern used in produce-prose (compacting after each phase) to drafting sessions.

## After Producing Work

- **`/qc-pass`** — Run a quality check on work just produced. Default after every creation or improvement.
- **`/refinement-pass`** — Run a refinement pass on work just produced (after QC passes).

## Pre-Compact Checkpoint (~50% context)

When context gets heavy, write a **session-state scratchpad** to the working directory:
- Current step, decisions made, partial findings, artifact file paths.
- Then `/clear` + restart (reading the scratchpad). Prefer this over `/compact`.

## Mid-Session Checkpoint (after 1 hour)

After 60 minutes of active work, pause for 2 minutes: "Summarize what we've done, what's pending, and what I should know if I start a fresh session right now." Write that to a checkpoint file. You can continue or stop — but the checkpoint is there. Long sessions produce good work but also context fatigue.

## Before Committing

- Review the diff Claude shows you.
- Commit messages: `new:`, `update:`, `batch:`, `fix:`.
- Never push without explicit approval.

## Session End

1. **The "what would I forget" question** — Before wrapping, ask: "What do I know now that I didn't when I started, and where does it live?" If the answer is "it's in my head" — write it down. Could be a domain insight, a workflow pattern, a decision rationale discussed but not logged. This is how domain-knowledge.md gets populated incrementally, not in one big synthesis session.
2. **`/wrap-session`** — Wraps the session, triggers logging.
3. **`/improve`** — Reviews friction log, finds patterns, proposes fixes. Choose **apply**, **log**, or **dismiss** for each.
4. **`/usage-analysis`** — Optional. Analyzes the session's token efficiency and logs a review. Good for spotting waste patterns over time.
5. **`/coach`** — Reviews collaboration patterns across sessions. Run periodically, not necessarily every session.

## Weekly: Improvement Flush

Pick one fixed time per week (e.g., Friday afternoon). Run a 30-minute session that does nothing but action pending improvements. No content work, no infrastructure building. Just: read the improvement log, apply or dismiss each item, verify the ones marked "applied" actually worked. This is the closed-loop ritual the improvement pipeline needs.

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
