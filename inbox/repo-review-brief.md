# Build Brief: /repo-review Command

## What This Is
A reusable command for periodic operational health assessment of the Axcion AI workspace. Complements `/repo-dd` (structural audit) with a judgment layer that `/repo-dd` deliberately excludes.

## Origin
Came out of a session (2026-04-06) where Patrik built `/repo-dd` and realized the questions he actually wanted answered were operational, not structural. The specific questions that prompted this:

## Questions This Command Should Answer

### 1. Feature Criticality
Which current features are most critical to "have right" for downstream effects?
- Research workflow pipeline (run-preparation → run-report chain)
- Skill creation pipeline (/create-skill, /improve-skill)
- Project setup pipeline (/new-project, /deploy-workflow)
- Other infrastructure (hooks, auto-commit, innovation detection)

The goal: identify which features are load-bearing (break one, break many) vs. peripheral (break one, only that one suffers). `/repo-dd` Section 3.4 (downstream reference ranking) provides raw data for this — but the *interpretation* of what's critical belongs here, not there.

### 2. Context Management Assessment
The workspace has accumulated significant infrastructure: 60+ skills, 57 commands, 24 hook configurations, 7 CLAUDE.md files. Questions to answer:
- Is the context load per session (currently 181–310 lines) actually degrading performance?
- Are there features that load into context but rarely get used in practice?
- Are there CLAUDE.md sections that could be moved to on-demand references instead of always-loaded?
- Is the hook density (especially buy-side with 5 PostToolUse Write hooks) adding latency?

### 3. Friction and Improvement Synthesis
- Read friction logs across all repos (`logs/friction-log.md` where they exist)
- Read improvement logs (`logs/improvement-log.md`)
- Read session notes for recurring pain points
- Synthesize: what patterns keep showing up? What's been suggested but not acted on?

### 4. Functional Pipeline Testing
Does the new project pipeline actually work end-to-end?
- `/deploy-workflow` — does it produce a valid, runnable project from the research-workflow template?
- `/new-project` — do all pipeline stages (2 through 5) execute without errors?
- `/sync-workflow` — does it correctly detect drift between deployed projects and the canonical template?
- Skill symlinks — do deployed projects correctly resolve skills from ai-resources?

Also check: are all templates synced? The audit found `report-compliance-qc` has diverged across 3 locations. Are there others?

## How It Differs from /repo-dd

| Dimension | /repo-dd | /repo-review |
|-----------|----------|-------------|
| Nature | Factual audit | Judgment + assessment |
| Output | Structured report, no commentary | Prioritized findings with recommendations |
| Frequency | After major updates | Quarterly or after development bursts |
| Inputs | Repo contents + git history | Repo + friction logs + session notes + live pipeline tests |
| Operator role | Reviews findings, approves fixes | Makes prioritization decisions |

## Design Considerations
- Should read `/repo-dd` output as input (don't re-audit what's already been audited)
- Friction log synthesis needs to handle the case where no friction logs exist yet
- Pipeline testing is destructive-ish (creates temp projects) — needs cleanup or worktree isolation
- The "criticality" assessment will require a dependency graph that goes beyond file references — it's about *operational* dependencies (if this breaks, what workflow stops working?)

## References
- Today's audit report: `ai-resources/audits/repo-due-diligence-2026-04-06.md`
- `/repo-dd` command: `ai-resources/.claude/commands/repo-dd.md`
- Questionnaire: `ai-resources/audits/questionnaire.md`
- Friction log locations: `logs/friction-log.md` in each repo that has one
- Session notes: `logs/session-notes.md` in each repo
