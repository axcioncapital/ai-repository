# Future Enhancements — Evaluation

**Date:** 2026-04-22
**Context:** During the `/new-project` pipeline redesign (delete Stages 2 & 2.5 in favor of discovery from the `projects/project-planning/` workspace), the operator surfaced three "Future Enhancement" items from earlier project notes and asked whether any should be added now. This note records the per-item verdict.

---

## Item 1 — Active Repo Organization Agent

**Original note:** "Create a unix / file organization agent that knows how to correctly organize our repo so AI can pull right files at the right time. Knows how to KEEP THE REPO ORGANIZED. File trees."

**Current coverage:** `/audit-repo` (repo-health-analyzer) audits file organization via the `file-org-auditor` subagent and flags problems in its report. It does not move files, rename them, or enforce conventions — it produces a report and recommendations that the operator acts on manually.

**Gap:** An active agent that restructures the repo — moves files, enforces naming conventions, maintains organization over time. This goes beyond auditing into automated maintenance. Could be a separate slash command (`/organize-repo`) or an extension to the repo-health-analyzer skill that offers "fix now" actions for organizational findings.

**Verdict: DEFER.**

**Rationale:** `/audit-repo` already surfaces organizational problems. Automating the fix is premature because we don't yet have recurrence data — we don't know which organizational issues repeat across audits vs. which are one-off cleanup tasks. Automating one-off fixes adds maintenance burden with no payoff; automating recurring fixes pays back quickly. The decision hinges on data we don't have yet.

**When to build:** After 2–3 `/audit-repo` runs have produced reports. Read the reports side-by-side and identify issues that recur. If ≥3 organizational findings repeat across audits, build a targeted fix for those specific patterns — not a general-purpose organization agent. Starting general-purpose risks over-engineering; starting from observed recurrence keeps the scope tight.

**Implementation hints (when triggered):**
- Extend the existing `file-org-auditor` subagent in `skills/repo-health-analyzer/agents/` with a companion "fix-now" mode, OR create `skills/repo-organizer/` with a dedicated SKILL.md.
- Prefer targeted fixes (move archive files to `archive/`, normalize log filenames) over general restructuring.
- All moves should be reversible — log each action to a session note; no silent cleanup.

---

## Item 2 — Convenience Optimization Lens in Improvement Analyst

**Original note:** "Should optimize for convenience too (easier for me to execute without intervention)."

**Current coverage:** The `improvement-analyst` agent at `ai-resources/.claude/agents/improvement-analyst.md` classifies friction by root cause (missing CLAUDE.md rule, skill gap, automation opportunity, convention gap) and prioritizes by impact-to-effort ratio.

**Gap:** "This works but requires too many manual steps" isn't an explicit finding type. The analyst might catch it under "automation opportunity," but there's no dedicated lens for *convenience* — which is subtly different from automation. Convenience includes reducing commands to type, combining steps, better defaults, and reducing cognitive load — not necessarily full automation.

**Verdict: BUILD — bundle with the next edit to `improvement-analyst.md`.**

**Rationale:** This is a small classification-taxonomy addition (adding `convenience` alongside existing finding types). Isolated, low-risk, fills a real gap the operator named explicitly. No point deferring — it's cheaper to add now than to remember to add it later. The trigger is opportunistic: next time any session touches `improvement-analyst.md` for another reason, add this in the same commit.

**When to build:** Bundled with any future edit to `improvement-analyst.md`. If no such edit happens within 4 weeks, promote to a dedicated change.

**Implementation hints:**
- Add `convenience` to the classification scheme in `improvement-analyst.md`.
- Define it clearly against "automation opportunity":
  - *Automation opportunity* = a repeated task that could be done without operator involvement.
  - *Convenience* = a task the operator still does, but with fewer steps, better defaults, or lower cognitive load.
- Add a finding-template example showing the distinction.

---

## Item 3 — Active Execution Guidance Workflow (Spec D Evolution)

**Original note:** "Create a workflow that knows how to do this in claude code that helps us follow best practice."

**Current coverage:** The operator's earlier notes describe Spec D as a static execution-guidance *manual* — a document that lists checklists and tips. A manual doesn't enforce anything.

**Gap:** An active workflow would *enforce* the checks a manual only *describes*. Example: a manual says "check X before proceeding"; a workflow *checks X for you and stops if it fails*. Candidates: verifying clean git status before a pipeline run, confirming CLAUDE.md is within the lean threshold, validating context-window freshness.

**Verdict: DEFER until Spec D exists as a manual.**

**Rationale:** The original notes make the sequencing explicit: build the manual first (Phase 4 of the spec program), then decide what to automate. Building an active workflow before the manual exists means codifying theoretical checks — we don't yet know which checks actually matter in day-to-day execution vs. which sound important but never trigger. Starting from the manual's real-world content gives a grounded automation scope.

**When to build:** After Spec D has been drafted as a manual and used for 2–3 weeks. Look at which manual checks the operator consults most (or skips most) — those are the automation candidates. Skipped-but-important checks argue for hard enforcement; consulted-frequently checks argue for soft surfacing (status-line reminders, hooks).

**Implementation hints:**
- Likely home: `ai-resources/.claude/hooks/` for enforcement hooks, or a new slash command like `/execution-preflight` for on-demand validation.
- Keep the manual alongside the workflow — the manual explains *why*, the workflow enforces *what*.

---

## Summary

| # | Item | Verdict | Trigger |
|---|------|---------|---------|
| 1 | Active Repo Organization Agent | DEFER | After 2–3 `/audit-repo` runs reveal recurring findings |
| 2 | Convenience Lens in Improvement Analyst | BUILD (opportunistic) | Bundle with next edit to `improvement-analyst.md`; escalate if no such edit within 4 weeks |
| 3 | Active Execution Guidance Workflow | DEFER | After Spec D exists as a manual and has been used for 2–3 weeks |

No immediate action required. Item 2 should be noted for the next person (or session) touching `improvement-analyst.md`.
