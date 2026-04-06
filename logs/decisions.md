# Decision Journal

### 2026-04-06 — Merged /repo-dd-deep into /repo-dd as depth levels
- **Context:** Built `/repo-dd-deep` as a standalone command for operational health review. Patrik asked whether the two commands could be combined for a "comprehensive audit."
- **Decision:** Extended `/repo-dd` with `$ARGUMENTS` depth control: (empty) = factual audit, "deep" = audit + judgment, "full" = audit + judgment + pipeline testing. Two separate report files preserve evidence/interpretation separation.
- **Rationale:** Eliminates two-session friction and the freshness dependency (deep review needed a recent audit as input). The separation principle is maintained at the report level, not the command level.
- **Alternatives considered:** (A) Combined command with separate reports (chosen), (B) Single combined report (rejected — blurs facts/judgment separation required by CLAUDE.md design principles).

### 2026-04-06 — Shared commands distributed via --add-dir, not copied into projects
- **Context:** Creating `/wrap-session` for ai-resources raised the question of how to make it available to all projects.
- **Decision:** Shared commands live in `ai-resources/.claude/commands/` and are available to all connected projects via `--add-dir`. Projects that need a specialized version override locally (local commands take precedence).
- **Rationale:** Single source of truth — updates propagate automatically. No sync burden. Research-workflow projects already override with their pipeline-specific version, proving the override pattern works.
- **Alternatives considered:** (a) Copy into each project at deploy time via `/deploy-workflow` — creates drift. (b) User-level commands in `~/.claude/commands/` — less portable, not version-controlled with the repo.

### 2026-04-06 — /repo-dd and /repo-review are separate commands
- **Context:** After running the first due diligence audit, Patrik wanted a command that also answers operational questions (feature criticality, context management health, friction synthesis, functional pipeline testing). These are judgment-based questions that don't fit the questionnaire's facts-only design.
- **Decision:** Keep `/repo-dd` as a structural audit (facts, no interpretation, comparable across runs). Build `/repo-review` separately for operational health assessment (judgment, recommendations, reads friction logs and tests pipelines).
- **Rationale:** Mixing factual audit with interpretive assessment would break the questionnaire's repeatability. A structural audit that says "this file is stale" is different from an operational review that says "this feature is your highest priority to fix." Different inputs, different outputs, different cadence.
- **Alternatives considered:** (a) Expand `/repo-dd` to include operational questions — rejected because it introduces judgment into a facts-only tool. (b) One command with two modes — adds complexity without benefit.

### 2026-04-06 — AUTO-FIX triage defaults to OPERATOR when ambiguous
- **Context:** The /repo-dd command includes a triage step that categorizes audit findings for fixing. The risk is Claude Code being too aggressive about what it auto-fixes.
- **Decision:** AUTO-FIX is strictly conservative: only unambiguous, single-file, no-cascade fixes. Everything else defaults to OPERATOR. The triage instruction explicitly says "when in doubt, classify as OPERATOR."
- **Rationale:** A conservative auto-fix list is more trustworthy than an ambitious one. Claude Code may misjudge whether a naming inconsistency is a simple rename or a cascading change. Better to surface more items for operator decision than to silently break references.
- **Alternatives considered:** (a) More permissive auto-fix with rollback — adds complexity, harder to verify. (b) No auto-fix at all — loses the convenience of fixing genuinely trivial items.

### 2026-04-06 — fund-triage-scanner stays as project-specific skill
- **Context:** Audit flagged `fund-triage-scanner` in nordic-pe as violating the "skills belong in ai-resources" rule.
- **Decision:** Keep it in the project. Document as intentional exception in nordic-pe CLAUDE.md.
- **Rationale:** The skill is single-use, tightly coupled to the nordic-pe triage pipeline, and not reusable across other projects. Graduating it would add clutter to the shared library with no benefit.
- **Alternatives considered:** (a) Graduate to ai-resources — rejected, no reuse case. (b) Delete it and inline the logic — rejected, it's a working skill that follows the standard format.

### 2026-04-06 — Canonical report-compliance-qc updated to match deployed copies
- **Context:** Audit found the canonical skill (ai-resources) had outdated single-file paths while buy-side and workflow template copies had correct section-specific paths. The copies were ahead of canonical.
- **Decision:** Update canonical to match the deployed copies. Replace buy-side physical copy with symlink to prevent future divergence.
- **Rationale:** The deployed copies had the correct paths for how the workflow actually works (section-scoped architecture files). The canonical version was simply never updated when the workflow evolved. Workflow template keeps its physical copy (needed for deploy-time copying) but is now in sync.

### 2026-04-06 — Exclusion-list approach for feature enrichment in project deployment
- **Context:** New features added to ai-resources (commands, agents, hooks) weren't reaching newly deployed projects because `/deploy-workflow` copies from a stale template snapshot.
- **Decision:** Use an exclusion list (repo-specific items blocked) rather than an inclusion list (shared items allowed). New features flow to projects by default.
- **Rationale:** Patrik constantly adds new features. An inclusion list requires manual updates every time. An exclusion list only needs updating when a new repo-specific tool is created, which is rare. The 9 excluded commands, pipeline agents, and 2 hooks are clearly ai-resources-only.
- **Alternatives considered:** (a) Inclusion list — rejected, requires constant maintenance. (b) Keep template manually updated — rejected, that's the discipline problem this fix solves. (c) Symlinks instead of copies — rejected, projects are standalone repos that may diverge intentionally.

### 2026-04-06 — Shared command drift check over dedicated sync command
- **Context:** Improvements made to shared commands in project workspaces (e.g., buy-side adding coaching data to wrap-session) don't automatically flow back to ai-resources. No mechanism existed to catch this drift.
- **Decision:** Add a lightweight drift check step to `/wrap-session` rather than building a dedicated `/sync-command` skill.
- **Rationale:** Piggybacks on an existing routine (session wrap) so it costs zero extra process. Only asks the question — doesn't force action. If this proves insufficient, a dedicated command can be built later.
- **Alternatives considered:** (a) Manual habit — rejected, relies on memory. (b) Dedicated `/sync-command` — deferred, over-engineering for a problem that may be fully solved by a prompt. (c) Automated diffing — rejected, too complex for the current volume of shared commands.
