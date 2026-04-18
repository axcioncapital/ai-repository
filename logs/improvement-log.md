# Improvement Log

### 2026-04-18 — Canonical project settings template for /new-project and research-workflow
- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R1 (both audits) and R4 (buy-side). Every new project ships without `Read(...)` denies and without a Sonnet default. The audit catches these findings on every project; preventing them at project-creation time would eliminate the recurrence.
- **Proposal:**
  - Update `/new-project` pipeline's post-enrichment stage to write `.claude/settings.json` with a sensible `permissions.deny` block. Minimum: `Read(archive/**)`. Research-workflow-derived projects should also get `Read(output/**)`, `Read(parts/**/drafts/**)`, `Read(usage/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.
  - Update the same stage to write `.claude/settings.local.json` with `{"model": "sonnet"}` as default.
  - Update the research-workflow template's `.claude/settings.json` at `ai-resources/workflows/research-workflow/.claude/settings.json` so `/deploy-workflow` propagates the canonical state.
  - Apply the "Applying Audit Recommendations" rule (workspace CLAUDE.md) when finalizing the deny list — list the top-3 commands each path affects and confirm no regression before committing the template.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` (pipeline orchestrator)
  - `ai-resources/workflows/research-workflow/.claude/settings.json` (template)
  - Any pipeline-stage-N agent that writes project `.claude/settings.json`

### 2026-04-18 — Canonical project CLAUDE.md template (compaction + session-boundary defaults, no workspace-rule duplication)
- **Status:** logged (pending)
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R10 (ai-resources) + R8 (buy-side). Every new project CLAUDE.md ships without `## Compaction` and `## Session Boundaries` sections, and every new project that was created via `/new-project` under the 2026-04-13 decision includes duplicated workspace rules (File Verification, Commit Rules) that pay per-turn token cost.
- **Proposal:**
  - Update the CLAUDE.md template used by `/new-project` to include default `## Compaction` and `## Session Boundaries` sections (borrow wording from ai-resources/CLAUDE.md).
  - Reconcile with the 2026-04-13 decision (copy Commit Rules into every project CLAUDE.md). Option A: keep the short-form mirror but audit that the project-level copy doesn't drift. Option B: replace with a one-line pointer — "Commit and file-verification rules: see workspace CLAUDE.md." Requires verifying that Claude Code consistently loads the workspace CLAUDE.md via `additionalDirectories` before the operator experiences commit-asking friction again. The 2026-04-13 decision's rationale ("inheritance evidently does not surface the rule prominently enough") may still hold — if so, keep the short-form copy but add a drift-check to `/repo-dd` questionnaire.
  - Update the research-workflow template's CLAUDE.md at `ai-resources/workflows/research-workflow/CLAUDE.md` so deployed projects inherit.
  - Apply the new workspace CLAUDE.md "CLAUDE.md Scoping" rule when reviewing project templates: skill-methodology and workflow-methodology content that lives in project CLAUDE.md should be moved to the right home (SKILL.md or workflow reference docs).
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` and its pipeline stages
  - `ai-resources/workflows/research-workflow/CLAUDE.md` (template)
  - Any CLAUDE.md template referenced by `/deploy-workflow`

### Sequencing note
- Tackle both items in a single session; they touch overlapping files (`/new-project` pipeline + research-workflow template). Expect ~1–2 hours with QC pass against a real next-project deployment.
- Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy to every project CLAUDE.md") to confirm whether the inheritance workaround is still needed or whether Claude Code's CLAUDE.md loading has improved enough to trust short-form pointers.
