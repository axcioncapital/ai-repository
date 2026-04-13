# Repo Due Diligence Audit — 2026-04-12

Repo: Axcion AI Workspace (multi-repo)
Commits: ai-resources `566c7d5` (+ 14 modified tracked + 5 untracked) | workflows `20e98d5` (+ 1 modified + 18 deleted files + 3 untracked) | buy-side-service-plan `6548d7d` (+ 10 modified + 5 deleted + 11 untracked) | global-macro-analysis `6561c4f` (+ 4 modified + 1 untracked) | nordic-pe `1c2bfa8` (+ 4 modified) | projects/project-planning — NOT a git repo | projects/obsidian-pe-kb — NOT a git repo | workspace root — NOT a git repo
Previous audit: 2026-04-11 (compared against `repo-due-diligence-2026-04-11.md`)
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

**ai-resources/.claude/commands/ (27 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| analyze-workflow.md | ai-resources/.claude/commands/ | .claude/agents/workflow-analysis-agent.md, .claude/agents/workflow-critique-agent.md |
| audit-repo.md | ai-resources/.claude/commands/ | skills/repo-health-analyzer/agents/ (8 agent files) |
| clarify.md | ai-resources/.claude/commands/ | None (inline prompt) |
| coach.md | ai-resources/.claude/commands/ | logs/session-notes.md, logs/coaching-data.md |
| create-skill.md | ai-resources/.claude/commands/ | skills/ai-resource-builder/SKILL.md, skills/ai-resource-builder/references/evaluation-framework.md |
| deploy-workflow.md | ai-resources/.claude/commands/ | workflows/*/SETUP.md, .claude/settings.json |
| friction-log.md | ai-resources/.claude/commands/ | logs/friction-log.md |
| graduate-resource.md | ai-resources/.claude/commands/ | .claude/commands/*, .claude/agents/*, .claude/hooks/*, inbox/, logs/innovation-registry.md |
| improve-skill.md | ai-resources/.claude/commands/ | skills/ai-resource-builder/SKILL.md, skills/*/SKILL.md, logs/improvement-log.md |
| improve.md | ai-resources/.claude/commands/ | logs/friction-log.md, logs/improvement-log.md, CLAUDE.md, settings.json |
| migrate-skill.md | ai-resources/.claude/commands/ | skills/ai-resource-builder/SKILL.md |
| new-project.md | ai-resources/.claude/commands/ | pipeline-stage-* agents, session-guide-generator agent |
| note.md | ai-resources/.claude/commands/ | logs/workflow-observations.md |
| prime.md | ai-resources/.claude/commands/ | logs/session-notes.md, logs/innovation-registry.md, inbox/, logs/decisions.md |
| project-consultant.md | ai-resources/.claude/commands/ | projects/global-macro-analysis/CLAUDE.md, pipeline/session-guide.md, macro-kb/_meta/taxonomy.md, macro-kb/_meta/index.json |
| qc-pass.md | ai-resources/.claude/commands/ | None (inline prompt) |
| refinement-deep.md | ai-resources/.claude/commands/ | None (orchestrates qc-pass + refinement-pass + triage) |
| refinement-pass.md | ai-resources/.claude/commands/ | None (inline prompt) |
| repo-dd.md | ai-resources/.claude/commands/ | audits/questionnaire.md, audits/repo-due-diligence-*.md, logs/ |
| request-skill.md | ai-resources/.claude/commands/ | inbox/, skills/ |
| scope.md | ai-resources/.claude/commands/ | None (inline prompt) |
| session-guide.md | ai-resources/.claude/commands/ | session-guide-generator agent, CLAUDE.md |
| sync-workflow.md | ai-resources/.claude/commands/ | CLAUDE.md, .claude/settings.json, ai-resources/workflows/*/ |
| triage.md | ai-resources/.claude/commands/ | None (inline prompt) |
| update-claude-md.md | ai-resources/.claude/commands/ | CLAUDE.md |
| usage-analysis.md | ai-resources/.claude/commands/ | usage/usage-log.md, skills/session-usage-analyzer/SKILL.md |
| wrap-session.md | ai-resources/.claude/commands/ | logs/session-notes.md, logs/decisions.md, logs/innovation-registry.md |

DELTA: +1 command from previous audit (26 -> 27). New: `project-consultant.md` (untracked in git, targets global-macro-analysis KB). Also modified: new-project.md (3 commits on 2026-04-11 and 1 on 2026-04-12 fixing project exclusion list and relative symlinks).

**ai-resources/workflows/research-workflow/.claude/commands/ (26 commands)**

Unchanged count from previous audit. All files (not symlinks) dated 2026-04-03 through 2026-04-12. Files: audit-repo.md, audit-structure.md, create-context-pack.md, friction-log.md, improve.md, inject-dependency.md, intake-reports.md, note.md, prime.md, produce-knowledge-file.md, produce-prose.md, qc-pass.md, refinement-pass.md, review.md, run-analysis.md, run-cluster.md, run-execution.md, run-preparation.md, run-report.md, run-synthesis.md, status.md, update-claude-md.md, usage-analysis.md, verify-chapter.md, workflow-status.md, wrap-session.md. produce-prose.md modified 2026-04-12 (3 commits).

DELTA: No count change (26 -> 26). produce-prose.md received 3 updates since previous audit (2026-04-11 refine and 2026-04-12 x2 — auto-continue from architecture QC, merge formatting phases).

**Root workspace .claude/commands/ (34 commands)**

Local files (kept non-symlinked): document-workflow.md, improve-workflow.md, new-project.md (symlink to ai-resources), new-workflow.md, run-qc.md, status.md, update-md.md, validate.md, wrap-session.md.

New symlinks synced from ai-resources (all dated 2026-04-12 19:04, 2026-04-12 11:51, or 2026-04-11 18:50):
analyze-workflow.md, audit-repo.md (-> skills/repo-health-analyzer/command.md), clarify.md, coach.md, create-skill.md, deploy-workflow.md, friction-log.md, graduate-resource.md, improve-skill.md, improve.md, migrate-skill.md, new-project.md, note.md, prime.md, project-consultant.md, qc-pass.md, refinement-deep.md, refinement-pass.md, repo-dd.md, request-skill.md, scope.md, session-guide.md, sync-workflow.md, triage.md, update-claude-md.md, usage-analysis.md.

DELTA: +25 commands from previous audit (9 -> 34). The new root `.claude/hooks/sync-shared-resources.sh` (described in 1.2) auto-symlinks ai-resources commands/agents into root `.claude/` on SessionStart, producing this expansion.

**workflows/.claude/commands/ (1 command)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | workflows/.claude/commands/ | symlink -> ../../../ai-resources/skills/repo-health-analyzer/command.md |

DELTA: No change

**projects/global-macro-analysis/.claude/commands/ (34 commands)**

Local (13): kb-audit.md, kb-cross-theme.md, kb-gap-audit.md, kb-ingest.md, kb-populate.md, kb-query.md, kb-registry-query.md, kb-reindex.md, kb-review.md, kb-stale.md, kb-synthesize.md, kb-theme-health.md, kb-triage-stats.md.

Symlinks to ai-resources (21, all relative `../../../../ai-resources/.claude/commands/`): analyze-workflow, audit-repo, clarify, coach, create-skill, friction-log, improve-skill, improve, migrate-skill, note, prime, qc-pass, refinement-deep, refinement-pass, repo-dd, request-skill, scope, triage, update-claude-md, usage-analysis, wrap-session.

DELTA: No net change (34 -> 34). Same inventory as previous audit.

**projects/buy-side-service-plan/.claude/commands/ (45 commands)**

Local files (22): audit-repo.md, audit-structure.md, challenge.md, content-review.md, create-context-pack.md, draft-section.md, execution/improvement-analyst local, improve.md, inject-dependency.md, intake-reports.md, prime.md, produce-knowledge-file.md, review.md, run-analysis.md, run-cluster.md, run-execution.md, run-preparation.md, run-report.md, run-synthesis.md, save-session.md, service-design-review.md, status.md, usage-analysis.md, verify-chapter.md, workflow-status.md, wrap-session.md.

Symlinks to ai-resources (22, mixed relative and absolute): analyze-workflow.md, clarify.md, coach.md, create-skill.md, graduate-resource.md, improve-skill.md, migrate-skill.md, note.md, produce-prose.md (-> research-workflow template), project-consultant.md, qc-pass.md, refinement-deep.md, refinement-pass.md, repo-dd.md, request-skill.md, scope.md, session-guide.md, sync-workflow.md, triage.md, update-claude-md.md.

DELTA: +8 commands from previous audit (37 -> 45). New symlinks (all dated 2026-04-12 18:10): create-skill, graduate-resource, improve-skill, migrate-skill, project-consultant, repo-dd, request-skill, session-guide.

**projects/nordic-pe-landscape-mapping-4-26/.claude/commands/ (6 commands + 1 sub-project)**
- note.md (symlink), prime.md, review.md, session-guide.md (symlink), status.md, wrap-session.md
- step-1-long-list: triage.md (1 command)

DELTA: No change.

**projects/project-planning/.claude/commands/ (31 commands) — NEW PROJECT**

Local (6): plan-draft.md, plan-evaluate.md, plan-refine.md, spec-draft.md, spec-evaluate.md, spec-refine.md.

Symlinks (25, mixed relative/absolute to ai-resources): analyze-workflow, audit-repo, clarify, coach, create-skill, friction-log, graduate-resource, improve-skill, improve, migrate-skill, note, prime, project-consultant, qc-pass, refinement-deep, refinement-pass, repo-dd, request-skill, scope, session-guide, sync-workflow, triage, update-claude-md, usage-analysis, wrap-session.

DELTA: NEW — entire project is new since previous audit. Not a git repo (no .git/ directory).

**projects/obsidian-pe-kb/vault/.claude/commands/ (27 commands) — NEW PROJECT**

Local (2): kb-ingest.md, kb-integrity-check.md.

Symlinks (25, all absolute to ai-resources): analyze-workflow, audit-repo, clarify, coach, create-skill, friction-log, graduate-resource, improve-skill, improve, migrate-skill, note, prime, project-consultant, qc-pass, refinement-deep, refinement-pass, repo-dd, request-skill, scope, session-guide, sync-workflow, triage, update-claude-md, usage-analysis, wrap-session.

DELTA: NEW — entire project is new since previous audit. Not a git repo.

**workflows/active/research-workflow/project-template/.claude/commands/ (3 commands)**
- audit-repo.md, friction-log.md, improve.md

DELTA: No change.

**Total commands across workspace: 234**
- ai-resources: 27 + research-workflow template: 26 = 53
- Root workspace: 34
- workflows/.claude: 1
- workflows/active/research-workflow/project-template: 3
- global-macro-analysis: 34
- buy-side-service-plan: 45
- project-planning: 31 (NEW)
- obsidian-pe-kb: 27 (NEW)
- nordic-pe: 7 (6 + 1 sub-project)

DELTA: +91 commands from previous audit (143 -> 234). Drivers: +2 new projects (project-planning +31, obsidian-pe-kb +27), +25 root workspace symlinks from sync-shared-resources hook, +8 buy-side symlinks from auto-sync, +1 ai-resources project-consultant.

### 1.2 Hooks

**9 settings.json files found across workspace:**

| Location | Hooks Present |
|----------|--------------|
| Root .claude/settings.json | SessionStart (load session notes + sync-shared-resources.sh), Stop (wrap-session reminder) |
| ai-resources/.claude/settings.json | Stop (innovation triage reminder) |
| ai-resources/workflows/research-workflow/.claude/settings.json | PreToolUse (Skill: friction-log, Edit: bright-line), PostToolUse (Write: auto-commit + log + detect-innovation, Edit: log + detect-innovation), SessionStart (checkpoint + drift check + auto-sync-shared), Stop (checkpoint reminder + wrap-session), UserPromptSubmit (decision logging) |
| projects/buy-side-service-plan/.claude/settings.json | PreToolUse (Edit: bright-line, Skill: friction-log), PostToolUse (Write: auto-commit + claim-ids + log, Edit: log), SessionStart (checkpoint + drift check + auto-sync-shared), Stop (checkpoint + wrap + improve-reminder + coach-reminder), UserPromptSubmit (decision logging) |
| projects/global-macro-analysis/.claude/settings.json | PreToolUse (Write: theme-folder-guard, Edit: theme-folder-guard) |
| projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | PostToolUse (Write: auto-commit + log, Edit: log), SessionStart (load notes), Stop (wrap reminder) |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | Permissions only (WebFetch, WebSearch) — no hooks |
| projects/project-planning/.claude/settings.json | SessionStart (auto-sync-shared) only |
| projects/obsidian-pe-kb/vault/.claude/settings.json | SessionStart (auto-sync-shared); permissions allow Read/Glob/Grep/limited Bash/Write/Edit in wiki/templates/CLAUDE.md; deny Write/Edit in raw/ |

DELTA: +3 settings.json files (6 -> 9). New: global-macro-analysis (previously had no settings.json — now has PreToolUse hooks for theme-folder write/edit guard implementing Hard Rules 1 and 3), project-planning (NEW project), obsidian-pe-kb (NEW project). Root workspace settings.json added a new sync-shared-resources.sh hook to SessionStart (previously only load-session-notes). Previous audit incorrectly listed ai-resources/.claude/settings.local.json, which no longer exists.

**3 settings.local.json files found** (buy-side, obsidian-pe-kb, workflows). No hook overrides.

DELTA: -1 settings.local.json (ai-resources removed, +1 obsidian-pe-kb).

**Hook scripts on disk (19 total):**

| Script | Location | Called By |
|--------|----------|----------|
| sync-shared-resources.sh | .claude/hooks/ (root) | Root settings.json SessionStart |
| auto-sync-shared.sh | ai-resources/.claude/hooks/ | SessionStart (research-workflow, buy-side, project-planning, obsidian-pe-kb — via walk-up loop) |
| check-template-drift.sh | ai-resources/.claude/hooks/ | SessionStart (research-workflow, buy-side — via walk-up loop) |
| detect-innovation.sh | ai-resources/.claude/hooks/ | PostToolUse (research-workflow Write/Edit) |
| pre-commit | ai-resources/.claude/hooks/ | Git pre-commit (not actively wired as a git hook — file exists) |
| check-claim-ids.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write) |
| detect-innovation.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PreToolUse (Skill) |
| log-write-activity.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| check-claim-ids.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write) |
| coach-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | Stop |
| detect-innovation.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Edit) — present on disk but not referenced in current settings.json |
| friction-log-auto.sh | projects/buy-side-service-plan/.claude/hooks/ | PreToolUse (Skill) |
| improve-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | Stop |
| log-write-activity.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write/Edit) |
| detect-innovation.sh | projects/project-planning/.claude/hooks/ | Not referenced in settings.json (orphaned) |
| auto-commit.sh | projects/nordic-pe-landscape-mapping-4-26/.claude/hooks/ | PostToolUse (Write) |
| log-write-activity.sh | projects/nordic-pe-landscape-mapping-4-26/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (untracked template) |
| log-write-activity.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (untracked template) |

DELTA: -2 hook scripts from previous audit (21 -> 19). Removed: projects/global-macro-analysis/.claude/hooks/detect-innovation.sh (the hooks/ directory no longer exists in global-macro-analysis). Added: .claude/hooks/sync-shared-resources.sh at workspace root, projects/project-planning/.claude/hooks/detect-innovation.sh. buy-side detect-innovation.sh remains on disk but is no longer referenced by the current settings.json (previous audit listed it as PostToolUse Edit hook).

### 1.3 Template Files

| Path | Used By | Last Commit Date |
|------|---------|-----------------|
| ai-resources/skills/answer-spec-generator/references/component-templates.md | answer-spec-generator skill | Pre-2026-01-06 |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | execution-manifest-creator skill | Pre-2026-01-06 |
| ai-resources/skills/research-extract-creator/references/extract-template.md | research-extract-creator skill | Pre-2026-01-06 |
| ai-resources/workflows/research-workflow/CLAUDE.md | /deploy-workflow (contains {{PLACEHOLDERS}}) | 2026-04-03 |
| ai-resources/workflows/research-workflow/SETUP.md | /deploy-workflow (deployment checklist) | 2026-04-03 |
| ai-resources/workflows/research-workflow/ (entire directory) | /deploy-workflow — copies as project template | 2026-04-11 |
| workflows/templates/workflow-need.md | /new-workflow, /document-workflow (via processes/create-new-workflow.md) | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/atomic-entry-template.md | /kb-review, /kb-populate | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/synthesis-template.md | /kb-synthesize | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/theme-file-template.md | /kb-theme-health | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/decision-memo-template.md | Decision memos | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/source-registry-template.md | Source registry | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/changelog-format.md | /kb-review | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/batch-manifest-schema.yaml | /kb-ingest, /kb-review | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/index-schema.json | /kb-reindex | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/processing-workflow/priming-template.md | External (chat/NotebookLM) | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/processing-workflow/triage-tiers.md | External (chat/NotebookLM) | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/processing-workflow/substance-extraction-checkpoint.md | External (chat/NotebookLM) | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/processing-workflow/conversation-template.md | External (chat/NotebookLM) | 2026-04-11 |
| projects/obsidian-pe-kb/vault/templates/master-index-template.md | /kb-ingest | Untracked (no git repo) |
| projects/obsidian-pe-kb/vault/templates/wiki-article-template.md | /kb-ingest | Untracked |
| projects/obsidian-pe-kb/vault/templates/wiki-index-template.md | /kb-ingest | Untracked |
| projects/project-planning/pipeline/ref-project-plan.md | /plan-draft (structural reference) | Untracked (no git repo) |
| projects/project-planning/pipeline/ref-tech-spec.md | /spec-draft (structural reference) | Untracked |

DELTA: +6 template files (3 obsidian-pe-kb templates + 2 project-planning reference templates + 1 workflows/templates/workflow-need.md which was previously flagged as a missing reference but actually exists in workflows repo committed 2026-04-11). The previous audit listed `templates/workflow-need.md` as missing — on disk verification confirms it exists at `workflows/templates/workflow-need.md` (commit 20e98d5).

### 1.4 Scripts

| Path | Purpose | Called By |
|------|---------|----------|
| ai-resources/scripts/repo-audit.sh | Shell-based repo health audit | Manual execution |
| ai-resources/scripts/skill-inventory.sh | Lists skills with metadata | Manual execution |

All other .sh files are hook scripts (listed in 1.2).

DELTA: No change.

### 1.5 Skills

66 skill directories in `ai-resources/skills/` (excluding CATALOG.md). All 66 have a SKILL.md file. None are missing SKILL.md.

Full skill list: ai-prose-decontamination, ai-resource-builder, analysis-pass-memo-review, answer-spec-generator, answer-spec-qc, architecture-designer, architecture-qc, chapter-prose-reviewer, chapter-review, citation-converter, claude-code-workflow-builder, cluster-analysis-pass, cluster-memo-refiner, cluster-synthesis-drafter, context-pack-builder, curiosity-hub-article-writer, decision-to-prose-writer, document-integration-qc, editorial-recommendations-generator, editorial-recommendations-qc, evidence-prose-fixer, evidence-spec-verifier, evidence-to-report-writer, execution-manifest-creator, formatting-qc, fund-triage-scanner, gap-assessment-gate, h3-title-pass, implementation-project-planner, implementation-spec-writer, intake-processor, journal-thinking-clarifier, journal-wiki-creator, journal-wiki-improver, journal-wiki-integrator, knowledge-file-completeness-qc, knowledge-file-producer, project-implementer, project-tester, prompt-creator, prose-compliance-qc, prose-formatter, repo-health-analyzer, report-compliance-qc, research-extract-creator, research-extract-verifier, research-plan-creator, research-prompt-creator, research-prompt-qc, research-structure-creator, section-directive-drafter, session-guide-generator, session-usage-analyzer, spec-writer, specifying-output-style, supplementary-evidence-merger, supplementary-query-brief-drafter, supplementary-research-qc, task-plan-creator, workflow-consultant, workflow-creator, workflow-documenter, workflow-evaluator, workflow-system-analyzer, workflow-system-critic, workspace-template-extractor.

Project-specific skills (outside ai-resources/skills/):
- `ai-resources/workflows/research-workflow/reference/skills/knowledge-file-producer/SKILL.md` — copy in template
- `ai-resources/workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md` — copy in template
- `projects/global-macro-analysis/skills/intake-processor/` — symlink to ai-resources/skills/intake-processor
- `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner/` — symlink to ai-resources/skills/fund-triage-scanner

DELTA: +3 skills in ai-resources (63 -> 66). New since previous audit: ai-prose-decontamination (2026-04-11), fund-triage-scanner (2026-04-11 — graduated from project), intake-processor (2026-04-11 — graduated from project). The project-specific skill directories in global-macro-analysis and nordic-pe now contain symlinks pointing back into ai-resources, resolving the previous audit's "project-owned skills" contradiction.

### 1.6 Uncategorized Items

| Path | Description |
|------|-------------|
| ai-resources/prompts/supplementary-research/S0-extract-failed-components.md | Supplementary research prompt |
| ai-resources/prompts/supplementary-research/S1-query-brief-pass1.md | Supplementary research prompt |
| ai-resources/prompts/supplementary-research/S1-query-brief-pass2.md | Supplementary research prompt |
| ai-resources/prompts/supplementary-research/S3-qc-supplementary-results.md | Supplementary research prompt |
| ai-resources/prompts/supplementary-research/S4-merge-instructions.md | Supplementary research prompt |
| ai-resources/logs/decisions.md | Session decision log |
| ai-resources/logs/innovation-registry.md | Innovation detection log |
| ai-resources/logs/session-notes.md | Session notes |
| ai-resources/logs/coaching-data.md | Coaching pipeline data |
| ai-resources/reports/repo-health-report.md | Generated health report |
| ai-resources/skills/CATALOG.md | Curated skill index |
| ai-resources/docs/session-rituals.md | Session ritual documentation |
| ai-resources/docs/operator-principles.md | Operator principles doc (untracked) |
| ai-resources/inbox/repo-review-brief.md | Incoming review brief |
| ai-resources/style-references/internal-material.md | Style reference template (added 2026-04-11 with formatting-qc skill) |
| workflows/processes/create-new-workflow.md | Workflow creation process doc |
| workflows/processes/document-existing-process.md | Workflow documentation process doc |
| workflows/processes/improve-existing-workflow.md | Workflow improvement process doc |
| workflows/reports/repo-health-report.md | Generated health report |
| workflows/active/research-workflow/project-template/ | Template in workflows repo (untracked) |
| projects/global-macro-analysis/pipeline/ (11 files) | Pipeline artifacts from project creation |
| projects/global-macro-analysis/macro-kb/_decisions/ (files) | Decision memos |
| projects/global-macro-analysis/macro-kb/_sources/registry.md | Source registry |
| projects/global-macro-analysis/macro-kb/_meta/ (config files) | KB metadata |
| projects/buy-side-service-plan/memory/feedback_validate_assumptions_before_drafting.md | Buy-side memory note (untracked) |
| projects/project-planning/pipeline/ (11 files) | Planning pipeline artifacts (architecture.md, context-pack.md, decisions.md, implementation-log.md, implementation-spec.md, pipeline-state.md, project-plan.md, ref-project-plan.md, ref-tech-spec.md, repo-snapshot.md, test-results.md) |
| projects/project-planning/output/, logs/ | Project-planning workspace dirs |
| projects/project-planning/.claude/shared-manifest.json | Manifest declaring local vs shared files for auto-sync |
| projects/obsidian-pe-kb/pipeline/ | Obsidian pipeline dir |
| projects/obsidian-pe-kb/vault/_setup-notes.md | Vault setup notes |
| projects/obsidian-pe-kb/vault/raw/, wiki/ | Vault content areas |
| projects/obsidian-pe-kb/vault/.claude/shared-manifest.json | Manifest for auto-sync |
| logs/innovation-registry.md, logs/session-notes.md, logs/decisions.md | Root workspace logs (untracked) |
| reports/last-audit-commit.txt, reports/repo-health-report.md | Root workspace reports |
| 16 .DS_Store files | macOS metadata (across the workspace) |

DELTA: +1 ai-resources/docs/operator-principles.md (untracked). +1 ai-resources/reports/ (untracked). +1 ai-resources/style-references/internal-material.md. +1 entire `projects/project-planning/` workspace. +1 entire `projects/obsidian-pe-kb/` workspace. +1 buy-side memory/ directory. +1 workflows/templates/workflow-need.md (now counted under templates). global-macro-analysis reports/.audit-temp/ directory from previous audit no longer exists. global-macro-analysis and nordic-pe project-owned skills graduated to ai-resources (now symlinked in their project directories).

### 1.7 Symlinks

Total: 200 symlinks found in workspace (excluding .git/). All targets exist and are accessible — no broken symlinks found.

Breakdown by location:
- Root workspace .claude/commands/: 25 symlinks (1 pointing to skills/repo-health-analyzer/command.md, 24 pointing to ai-resources/.claude/commands/)
- Root workspace .claude/agents/: 19 symlinks (17 pointing to ai-resources/.claude/agents/, 1 pointing to skills/repo-health-analyzer/agents/repo-health-analyzer.md, 6 in auditors/ pointing to skills/repo-health-analyzer/agents/)
- workflows/.claude/commands/: 1 symlink (audit-repo.md -> skills/repo-health-analyzer/command.md)
- projects/buy-side-service-plan/.claude/commands/: 20 symlinks (mix of relative and absolute)
- projects/buy-side-service-plan/.claude/agents/: 6 symlinks
- projects/buy-side-service-plan/reference/skills/: 22 symlinks (mix of absolute and relative)
- projects/global-macro-analysis/.claude/commands/: 21 relative symlinks
- projects/global-macro-analysis/.claude/agents/: 8 relative symlinks
- projects/global-macro-analysis/skills/: 1 symlink (intake-processor -> ai-resources/skills/intake-processor)
- projects/nordic-pe-landscape-mapping-4-26/.claude/commands/: 2 symlinks (note.md, session-guide.md)
- projects/nordic-pe-landscape-mapping-4-26/reference/skills/: 1 symlink (repo-health-analyzer)
- projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/: 1 symlink (fund-triage-scanner)
- projects/project-planning/.claude/commands/: 25 symlinks (mix of relative and absolute)
- projects/project-planning/.claude/agents/: 9 symlinks
- projects/obsidian-pe-kb/vault/.claude/commands/: 25 absolute symlinks
- projects/obsidian-pe-kb/vault/.claude/agents/: 9 absolute symlinks

DELTA: +122 symlinks from previous audit (78 -> 200). Drivers: +44 in new root workspace .claude/ tree (25 commands + 19 agents added by sync-shared-resources hook on 2026-04-12 19:04), +34 in new obsidian-pe-kb project (25 commands + 9 agents, all absolute paths, dated 2026-04-12 22:07), +34 in new project-planning project (25 commands + 9 agents, dated 2026-04-11 19:47 and 2026-04-12 18:07), +8 new symlinks in buy-side (create-skill, graduate-resource, improve-skill, migrate-skill, project-consultant, repo-dd, request-skill, session-guide, all dated 2026-04-12 18:10 and absolute). No broken symlinks found — checked by `find -type l ! -exec test -e {} \;` which returned zero results.

### 1.8 Agent Definitions

| Location | Count | Files |
|----------|-------|-------|
| ai-resources/.claude/agents/ | 17 | collaboration-coach.md, execution-agent.md, improvement-analyst.md, pipeline-stage-2.md, pipeline-stage-2-5.md, pipeline-stage-3a.md, pipeline-stage-3b.md, pipeline-stage-3c.md, pipeline-stage-4.md, pipeline-stage-5.md, qc-reviewer.md, refinement-reviewer.md, repo-dd-auditor.md, session-guide-generator.md, triage-reviewer.md, workflow-analysis-agent.md, workflow-critique-agent.md |
| ai-resources/workflows/research-workflow/.claude/agents/ | 4 | execution-agent.md, improvement-analyst.md, qc-gate.md, verification-agent.md |
| projects/buy-side-service-plan/.claude/agents/ | 15 | collaboration-coach.md (symlink), execution-agent.md, improvement-analyst.md, qc-gate.md, qc-reviewer.md, refinement-reviewer.md (symlink), repo-dd-auditor.md (symlink), research-synthesizer.md, section-drafter.md, service-designer.md, strategic-critic.md, triage-reviewer.md (symlink), verification-agent.md, workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| projects/global-macro-analysis/.claude/agents/ | 8 | collaboration-coach.md (symlink), improvement-analyst.md (symlink), qc-reviewer.md (symlink), refinement-reviewer.md (symlink), repo-dd-auditor.md (symlink), triage-reviewer.md (symlink), workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| projects/nordic-pe-landscape-mapping-4-26/.claude/agents/ | 1 | qc-gate.md |
| projects/project-planning/.claude/agents/ | 11 | collaboration-coach.md (symlink), execution-agent.md (symlink), improvement-analyst.md (symlink), plan-evaluator.md, qc-reviewer.md (symlink), refinement-reviewer.md (symlink), repo-dd-auditor.md (symlink), spec-evaluator.md, triage-reviewer.md (symlink), workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| projects/obsidian-pe-kb/vault/.claude/agents/ | 9 | collaboration-coach.md (symlink), execution-agent.md (symlink), improvement-analyst.md (symlink), qc-reviewer.md (symlink), refinement-reviewer.md (symlink), repo-dd-auditor.md (symlink), triage-reviewer.md (symlink), workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| root .claude/agents/ | 19 | output-validator.md + 18 symlinks (17 to ai-resources/.claude/agents/, 1 to skills/repo-health-analyzer/agents/repo-health-analyzer.md) |
| root .claude/agents/auditors/ | 6 | claude-md-auditor.md, command-auditor.md, file-org-auditor.md, practices-auditor.md, settings-auditor.md, skill-auditor.md (all symlinks) |
| workflows/active/research-workflow/project-template/.claude/agents/ | 1 | improvement-analyst.md |

DELTA: +39 from previous audit (52 -> 91). Drivers: +20 from project-planning + obsidian-pe-kb (NEW projects, 11 + 9 agents), +17 from root .claude/agents/ expansion (sync hook added symlinks on 2026-04-12 19:04 — was 2 + 6 auditors, now 19 + 6), +3 in buy-side (execution-agent, improvement-analyst, qc-gate added/de-symlinked — previous audit counted 12, now 15), -1 in global-macro-analysis (execution-agent no longer present — was 9, now 8).

Section summary: 347 items catalogued / 19 deltas from previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Files

| File | Lines | Sections | Section Headings |
|------|-------|----------|-----------------|
| (root)/CLAUDE.md | 98 | 12 | What This Workspace Is For, Projects, Axcion's Tool Ecosystem, Skill Library, AI Resource Creation Rules, Design Judgment Principles, QC Independence Rule, Completion Standard, Working Principles, Autonomy Rules, File verification and git commits, Delivery |
| ai-resources/CLAUDE.md | 95 (working tree, 94 committed) | 8 | What This Repo Contains, How I Work, Skill Format Standard, Model Preference, Development Workflow, General Session Rules, Cross-References, Git Rules |
| workflows/CLAUDE.md | 23 (unchanged file) + modifications | 4 | (tree) unchanged |
| ai-resources/workflows/research-workflow/CLAUDE.md | 85 | Template with {{PLACEHOLDERS}} | (template) |
| projects/buy-side-service-plan/CLAUDE.md | 157 (working tree; 146 committed) | 12 | Project Context, Operator Profile, Workflow Overview, Workflow Status Command, Collaboration Coach, Cross-Model Rules, Context Isolation Rules, Citation Conversion Rule, Bright-Line Rule (All Fix Steps), Adaptive Thinking Override, File Verification and Git Commits, Service Development Workflow |
| projects/nordic-pe-landscape-mapping-4-26/CLAUDE.md | 69 (working tree; 67 committed) | 10 | What This Is, Project Roadmap, Project Structure, How to Work in This Project, Cross-Model Delegation Rules, Context Isolation Rules, QC Gate Pattern, Logging Conventions, Project-Specific Skills, Current Status |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/CLAUDE.md | 30 | 5 | (step-specific, unchanged) |
| projects/global-macro-analysis/CLAUDE.md | 77 (working tree; 71 committed) | 8 | What This Is, Overview, Command Scope Table, Hard Rules, Operator Gates, Intake Processing Rules, Key File Paths, Operational Notes |
| projects/project-planning/CLAUDE.md | 55 | 8 | Purpose, How It Works, Commands, Output Convention, Reference Documents, Skill References, Versioning, Relationship to /new-project |
| projects/obsidian-pe-kb/vault/CLAUDE.md | ~180 | 10 | Purpose, Folder structure, Operating modes, Decomposition rules (ingestion mode), Update vs. create rules, Conflict resolution, Index maintenance (atomic), Link syntax inside wiki articles, Tag taxonomy, For new users (Daniel) |

DELTA: +2 new CLAUDE.md files (project-planning, obsidian-pe-kb/vault). Root CLAUDE.md: 97 -> 98 lines (+1, now mentions project-specific pipeline commands like kb-* and plan-*/spec-* allowed locally). ai-resources: 94/95 unchanged in commit, working tree matches previous audit. global-macro-analysis: 62 -> 71 committed (+9, working tree now 77). nordic-pe: 67 -> 69 (+2 uncommitted). buy-side: 157 unchanged from previous audit (still 146 committed).

### 2.2 Dead References

| CLAUDE.md File | Referenced Item | Status | Git History |
|---------------|----------------|--------|-------------|
| (none) | N/A | N/A | N/A |

None found — checked all 10 CLAUDE.md files against filesystem. All referenced paths resolve. The previous audit's flagged `templates/workflow-need.md` reference has been resolved: the workflows/templates/workflow-need.md file exists on disk (commit 20e98d5 dated 2026-04-11 in workflows repo), and the current root workspace `/new-workflow` and `/document-workflow` commands no longer contain a direct reference to `templates/workflow-need.md` (grep returned zero matches in root .claude/commands/). The reference still exists in `workflows/processes/create-new-workflow.md` line 14, which resolves correctly.

DELTA: -1 dead reference resolved (templates/workflow-need.md now exists on disk).

### 2.3 Contradictions

**Contradiction 1 (from previous audit): RESOLVED**

Previous audit flagged 2 project-owned skills (fund-triage-scanner, intake-processor) not in ai-resources/skills/. Both have since been graduated to ai-resources/skills/ (committed 2026-04-11 in commit 0aa7cb1). The project directories now contain symlinks back into ai-resources:
- `projects/global-macro-analysis/skills/intake-processor` -> `../../../ai-resources/skills/intake-processor` (symlink)
- `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner` -> `../../../../ai-resources/skills/fund-triage-scanner` (symlink)

**Updated skill ownership text in root CLAUDE.md (line 35) reads:**
> "Shared AI resources belong in ai-resources/. Reusable skills, commands, and agent definitions — anything that could plausibly serve more than one project — belong in ai-resources/. Project workspaces consume shared resources via symlink or copy; they never own them. Project-specific pipeline commands and evaluator agents (e.g., the kb-* commands in global-macro-analysis, the plan-*/spec-* commands in project-planning) are allowed to live locally in the project's own .claude/ when they are tightly coupled to that project's pipeline and not intended for reuse."

This text explicitly allows project-local pipeline commands, aligning the rule with the presence of kb-*, plan-*/spec-*, draft-section, challenge, content-review, and other project-local commands.

No active contradictions found — checked all 10 CLAUDE.md files for conflicting statements against each other and against actual filesystem state.

DELTA: Previous contradiction (project-owned skills) resolved. No new contradictions.

### 2.4 Conventions Not Followed

| Convention | Source | Violation |
|-----------|--------|-----------|
| Commit message format: `new:`, `update:`, `fix:`, `batch:` | ai-resources/CLAUDE.md line 90 | buy-side auto-commit hook uses `update: $stage — $bn` format (matches `update:` prefix, partially conforms) |

Conventions verified as followed:
- Skill folder naming (lowercase, hyphenated) — all 66 skills comply (checked `ls ai-resources/skills/`)
- SKILL.md file naming — all 66 skills have exactly `SKILL.md` (verified by loop checking each directory)
- YAML frontmatter with `name` and `description` — all 66 skills comply (checked head -5 of each SKILL.md)
- No auxiliary files in skill directories — none found (no README, CHANGELOG)
- Body under 500 lines — all comply (max: answer-spec-generator at 485 lines, research-plan-creator at 464, ai-resource-builder at 463)

DELTA: -2 violations resolved (fund-triage-scanner and intake-processor now in ai-resources/).

### 2.5 Partial Feature References

| Feature | What Exists | What's Missing |
|---------|------------|----------------|
| buy-side detect-innovation.sh hook | Script on disk at projects/buy-side-service-plan/.claude/hooks/detect-innovation.sh | Not referenced in current settings.json (orphaned — previous audit had it wired to PostToolUse Edit, current settings.json has no such hook) |
| project-planning detect-innovation.sh | Script on disk at projects/project-planning/.claude/hooks/detect-innovation.sh | Not referenced in settings.json (orphaned — settings.json only has SessionStart auto-sync) |
| project-consultant command | Defined at ai-resources/.claude/commands/project-consultant.md (untracked); symlinked from buy-side, project-planning, obsidian-pe-kb, global-macro-analysis, root | Not yet committed in ai-resources repo — exists only in working tree |

DELTA: Previous audit's global-macro-analysis detect-innovation.sh orphan is resolved (hooks/ directory no longer exists in global-macro). New orphans: buy-side detect-innovation.sh (settings.json lost the Edit hook reference), project-planning detect-innovation.sh. New partial feature: project-consultant.md untracked in ai-resources but referenced by symlinks in 4 projects.

Section summary: 3 issues flagged / 4 deltas from previous audit

---

## Section 3: Dependency References

### 3.1 Command-to-File Reference Map

Verification summary:

| Result | Count |
|--------|-------|
| All referenced files exist | 232 commands |
| Referenced file missing | 0 |
| References are dynamic (created at runtime) | ~12 commands (logs, session notes, checkpoints, staging) |
| Symlinked commands (verified via target) | 124 commands |

Checked: all explicit file references in every command file across the workspace. The previous audit's 2 failed references (`/document-workflow` and `/new-workflow` -> `templates/workflow-need.md`) are now resolved since the file exists AND the command text no longer references that specific path.

DELTA: +89 commands verified (due to +2 new projects + root sync expansion). 2 previously-failing references resolved.

### 3.2 Command Chains

**Research Workflow Pipeline (sequential, multi-session):**
```
/run-preparation -> /run-execution -> /run-cluster -> /run-analysis -> /run-synthesis -> /run-report -> /verify-chapter -> /produce-knowledge-file
```
(`/produce-prose` is a parallel prose-production path within /run-report stage)

**KB Workflow Pipeline (global-macro-analysis):**
```
/kb-ingest -> /kb-review -> /kb-synthesize
```
Supporting commands: /kb-query, /kb-stale, /kb-audit, /kb-reindex, /kb-populate, /kb-registry-query, /kb-gap-audit, /kb-theme-health, /kb-cross-theme, /kb-triage-stats

**Obsidian PE KB Ingestion (obsidian-pe-kb/vault):**
```
/kb-ingest -> /kb-integrity-check
```

**Project Planning Pipeline (project-planning):**
```
/plan-draft -> /plan-refine -> /plan-evaluate  (plan workflow)
/spec-draft -> /spec-refine -> /spec-evaluate  (spec workflow, downstream of plan)
Artifacts in output/{project-name}/ feed /new-project
```

**Skill Management Pipeline:**
```
/request-skill -> /create-skill (or /improve-skill, /migrate-skill)
```

**Project Setup Pipeline:**
```
/new-project -> pipeline-stage-2 -> pipeline-stage-2-5 -> pipeline-stage-3a -> pipeline-stage-3b -> pipeline-stage-3c -> pipeline-stage-4 -> pipeline-stage-5 -> /session-guide
```

**Session Lifecycle:**
```
/prime (start) -> [work] -> /wrap-session (end)
```

**Audit Pipeline:**
```
/repo-dd (factual) -> /repo-dd deep -> /repo-dd full
```

**Workflow Analysis Pipeline:**
```
/analyze-workflow (two-phase: analysis agent -> critique agent)
```

**Refinement Pipeline:**
```
/refinement-deep (orchestrates /qc-pass + /refinement-pass + /triage)
```

DELTA: +2 chains (Obsidian PE KB Ingestion, Project Planning Pipeline).

### 3.3 Files Referenced by Multiple Commands/Hooks

| File | Referenced By |
|------|--------------|
| logs/session-notes.md | /wrap-session, /prime, /coach, SessionStart hooks (root, buy-side, nordic-pe, global-macro none, project-planning none), Stop hooks, /usage-analysis, /repo-dd |
| logs/innovation-registry.md | /wrap-session, /prime, /graduate-resource, Stop hooks (ai-resources, buy-side, research-workflow template), /repo-dd |
| logs/friction-log.md | /friction-log, /improve, /wrap-session, /repo-dd |
| logs/decisions.md | /wrap-session, /prime, /repo-dd, UserPromptSubmit hooks |
| CLAUDE.md | /update-claude-md, /sync-workflow, /improve, /workflow-status, SessionStart hooks |
| .claude/settings.json | /deploy-workflow, /sync-workflow |
| skills/ai-resource-builder/SKILL.md | /create-skill, /improve-skill, /migrate-skill |
| skills/ai-resource-builder/references/evaluation-framework.md | /create-skill, /improve-skill |
| macro-kb/_meta/taxonomy.md | /kb-ingest, /kb-populate, /kb-synthesize, /kb-query, /kb-reindex |
| macro-kb/_meta/index.json | /kb-review, /kb-reindex, /kb-query, /kb-stale, /kb-synthesize, /project-consultant |
| macro-kb/_sources/registry.md | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| macro-kb/_staging/ | /kb-ingest (writes), /kb-populate (writes), /kb-review (reads) |
| pipeline/ref-project-plan.md | /plan-draft, /plan-refine, /plan-evaluate |
| pipeline/ref-tech-spec.md | /spec-draft, /spec-refine, /spec-evaluate |
| wiki/_master-index.md | /kb-ingest (obsidian), /kb-integrity-check, all vault query operations |
| auto-sync-shared.sh | SessionStart in research-workflow template, buy-side, project-planning, obsidian-pe-kb |

DELTA: +4 entries (ref-project-plan.md, ref-tech-spec.md, wiki/_master-index.md, auto-sync-shared.sh). /project-consultant added to macro-kb/_meta/index.json consumers.

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | logs/session-notes.md | 9 | /wrap-session, /prime, /coach, /usage-analysis, /repo-dd, SessionStart x3, Stop x1 |
| 2 | CLAUDE.md (per repo) | 6 | /update-claude-md, /sync-workflow, /improve, /workflow-status, SessionStart hooks, /repo-dd |
| 3 | logs/innovation-registry.md | 6 | /wrap-session, /prime, /graduate-resource, /repo-dd, Stop hooks x2 |
| 4 | macro-kb/_meta/taxonomy.md | 5 | /kb-ingest, /kb-populate, /kb-synthesize, /kb-query, /kb-reindex |
| 5 | macro-kb/_meta/index.json | 5 | /kb-review, /kb-reindex, /kb-query, /kb-stale, /kb-synthesize (+ /project-consultant reads) |
| 6 | auto-sync-shared.sh | 4 | SessionStart in research-workflow, buy-side, project-planning, obsidian-pe-kb |
| 7 | logs/friction-log.md | 4 | /friction-log, /improve, /wrap-session, /repo-dd |
| 8 | logs/decisions.md | 4 | /prime, /wrap-session, /repo-dd, UserPromptSubmit hooks |
| 9 | report/chapters/ (directory) | 4 | /run-report, /verify-chapter, /review, /produce-knowledge-file |
| 10 | analysis/cluster-memos/ (directory) | 4 | /run-cluster, /run-analysis, /run-synthesis, /review |

DELTA: auto-sync-shared.sh is new in top 10 (4 SessionStart invocations across projects). Dropped: skills/ai-resource-builder/SKILL.md (3 references, now outside top 10).

Section summary: 0 issues flagged / 4 deltas from previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

Standard pattern (all 66 ai-resources skills): folder with SKILL.md containing YAML frontmatter (`name`, `description`), optional `references/` subdirectory, optional `agents/` subdirectory.

| Check | Result |
|-------|--------|
| All have SKILL.md | Yes (66/66) |
| All have YAML frontmatter | Yes (66/66) |
| All have `name` field | Yes (66/66) |
| All have `description` field | Yes (66/66) |
| Skills with references/ | 8 of 66 (ai-resource-builder, answer-spec-generator, citation-converter, claude-code-workflow-builder, execution-manifest-creator, research-extract-creator, research-plan-creator, research-prompt-creator) |
| Skills with agents/ | 1 of 66 (repo-health-analyzer) |
| Skills with scripts/ | 0 of 66 |
| Skills with unexpected subdirectories | 0 of 66 |

All project-specific skill symlinks resolve back into ai-resources/skills/ and conform to the standard pattern.

DELTA: +3 skills (all conform to standard pattern).

### 4.2 Slash Command Definition Pattern

Commands are markdown files in `.claude/commands/` directories. No standard template enforced — commands vary in structure.

| Pattern Variant | Count | Examples |
|----------------|-------|---------|
| Inline prompt (< 10 lines) | 6 | clarify.md, qc-pass.md, refinement-pass.md, scope.md, note.md, triage.md |
| Procedural with skill references | 12 | run-preparation.md, run-execution.md, create-skill.md |
| Agent delegation | 4 | new-project.md, session-guide.md, audit-repo.md, analyze-workflow.md |
| Utility/logging | 6 | wrap-session.md, friction-log.md, usage-analysis.md |
| Multi-step pipeline | 1 | repo-dd.md |
| Session orientation | 1 | prime.md |
| Orchestrator | 1 | refinement-deep.md |
| KB operations (scope-enforced) | 15 | kb-* commands in global-macro (13) + obsidian-pe-kb kb-ingest, kb-integrity-check (2) |
| Planning/spec workflow | 6 | plan-draft, plan-refine, plan-evaluate, spec-draft, spec-refine, spec-evaluate |
| Advisor with execution | 1 | project-consultant.md |

DELTA: +3 pattern variants counts. +2 KB operations (obsidian-pe-kb adds 2 local kb commands), +6 Planning/spec variant (new project-planning project), +1 Advisor with execution (project-consultant).

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resources/skills/ai-resource-builder/SKILL.md for format standards.

DELTA: No change.

### 4.4 Naming Convention Inconsistencies

| Check | Result |
|-------|--------|
| Skill folders: lowercase, hyphenated | All 66 comply |
| Command files: lowercase, hyphenated .md | All comply |
| Agent files: lowercase, hyphenated .md | All comply |
| Hook scripts: lowercase, hyphenated .sh | All comply except `pre-commit` (standard git convention) |

Symlink path convention inconsistency:
- Root workspace .claude/: all 44 new symlinks use relative paths (`../../ai-resources/...`)
- buy-side command symlinks: mixed — 12 relative (`../../../../ai-resources/`) and 8 absolute (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/...`)
- buy-side reference skill symlinks: 21 absolute paths, 1 relative (knowledge-file-producer)
- buy-side agent symlinks: mostly absolute
- global-macro-analysis: all 30 symlinks relative (commands + agents + intake-processor)
- nordic-pe: 2 absolute (session-guide.md, note.md in commands; repo-health-analyzer in reference/skills), 1 symlink
- project-planning: mixed — most commands relative (`../../../../ai-resources/`), 6 absolute (graduate-resource, session-guide, sync-workflow added 2026-04-12 18:07)
- obsidian-pe-kb: all 34 symlinks use absolute paths (/Users/patrik.lindeberg/...)

DELTA: +1 new pattern (obsidian-pe-kb all-absolute). buy-side inconsistency persists. Relative-vs-absolute mixing now across 5 projects.

### 4.5 Directory Structure Violations

| Violation | Location |
|-----------|----------|
| `style-references/` directory at ai-resources root | Not listed in ai-resources/CLAUDE.md "Other directories:" section (lines 7-13) — directory exists with `internal-material.md` committed 2026-04-11 |

`prompts/`, `reports/`, `logs/`, `audits/`, `docs/`, `scripts/`, `inbox/` are all documented in ai-resources/CLAUDE.md.

DELTA: +1 new violation (`style-references/` created 2026-04-11 but not documented in ai-resources/CLAUDE.md).

### 4.6 Command Syntax and Path Resolution

| Check | Pass | Fail |
|-------|------|------|
| Command files parseable as markdown | 234 | 0 |
| Referenced file paths resolve | 234 | 0 |

Previous audit's 2 failed references (`/document-workflow`, `/new-workflow` -> `templates/workflow-need.md`) are resolved: the file now exists at workflows/templates/workflow-need.md, and the current root commands do not contain a direct reference to that path (grep returned 0 matches in root .claude/commands/).

DELTA: +91 commands verified. 2 previously-failing references resolved.

### 4.7 Duplicate or Built-in Command Names

Commands appearing in 3+ locations:

| Name | Locations |
|------|-----------|
| audit-repo | ai-resources, research-workflow template, root (symlink), workflows (symlink), buy-side, global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| wrap-session | ai-resources, research-workflow template, root (symlink), buy-side, global-macro (symlink), nordic-pe, project-planning (symlink), obsidian-pe-kb (symlink) |
| update-claude-md | ai-resources, research-workflow template, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| friction-log | ai-resources, research-workflow template, root (symlink), buy-side, global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| improve | ai-resources, research-workflow template, root (symlink), buy-side, global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| note | ai-resources, research-workflow template, root (symlink), buy-side (symlink), global-macro (symlink), nordic-pe (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| usage-analysis | ai-resources, research-workflow template, root (symlink), buy-side, global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| prime | ai-resources, research-workflow template, root (symlink), buy-side, global-macro (symlink), nordic-pe, project-planning (symlink), obsidian-pe-kb (symlink) |
| qc-pass | ai-resources, research-workflow template, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| refinement-pass | ai-resources, research-workflow template, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| refinement-deep | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| analyze-workflow | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| clarify | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| coach | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| scope | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| triage | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| create-skill | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| improve-skill | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| migrate-skill | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| request-skill | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| graduate-resource | ai-resources, root (symlink), buy-side (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| repo-dd | ai-resources, root (symlink), buy-side (symlink), global-macro (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| project-consultant | ai-resources (untracked), root (symlink), buy-side (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| session-guide | ai-resources, root (symlink), buy-side (symlink), nordic-pe (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| sync-workflow | ai-resources, root (symlink), buy-side (symlink), project-planning (symlink), obsidian-pe-kb (symlink) |
| kb-ingest | global-macro (local), obsidian-pe-kb (local — different content, different scope) |
| status | research-workflow template, root, buy-side, global-macro-analysis (missing — local kb commands no status) |

No command names conflict with built-in Claude Code commands — checked against: /help, /clear, /compact, /cost, /doctor, /init, /login, /logout, /memory, /model, /permissions, /review, /terminal-setup, /vim, /fast.

Note: `/review` exists as a workflow command (buy-side, research-workflow template, nordic-pe) and as a built-in Claude Code command. The custom command takes precedence when defined.

Note: `/kb-ingest` is defined locally in BOTH global-macro-analysis (macro KB) AND obsidian-pe-kb/vault. Each is a distinct, project-scoped implementation with different file targets — no conflict because each runs only in its own project workspace.

DELTA: Many more duplicates due to +2 new projects (project-planning + obsidian-pe-kb) and root workspace sync-shared-resources expansion. Unique command names appearing in 3+ locations: 27 (was 17). NEW duplicate: kb-ingest appears as project-local command in both global-macro-analysis and obsidian-pe-kb (different content, different scope).

Section summary: 3 issues flagged / 6 deltas from previous audit

---

## Section 5: Context Load

### 5.1 Context Loaded Per Session

| Entry Point | CLAUDE.md Lines | SessionStart Hook Load | Estimated Total |
|-------------|----------------|----------------------|----------------|
| ai-resources | 98 (root) + 95 (ai-resources) = 193 | ~60 lines (session notes + sync-shared output) | ~253 lines |
| global-macro-analysis | 98 (root) + 77 (global-macro) = 175 | ~60 lines | ~235 lines |
| buy-side-service-plan | 98 (root) + 157 (buy-side) = 255 | ~60 lines (checkpoint) + drift check + auto-sync | ~320 lines |
| nordic-pe | 98 (root) + 69 (nordic-pe) = 167 | ~30 lines (last session notes) | ~197 lines |
| nordic-pe/step-1 | 98 (root) + 69 (nordic-pe) + 30 (step-1) = 197 | ~30 lines (inherited from nordic-pe) | ~227 lines |
| workflows | 98 (root) + 23 (workflows) = 121 | ~60 lines (from root hook) | ~181 lines |
| project-planning | 98 (root) + 55 (project-planning) = 153 | ~10 lines (auto-sync output only) | ~163 lines |
| obsidian-pe-kb/vault | 98 (root) + ~180 (obsidian) = ~278 | ~10 lines (auto-sync output only) | ~288 lines |
| root workspace | 98 (root only) | ~60 lines (session notes + sync output) | ~158 lines |

DELTA: +2 entry points (project-planning ~163, obsidian-pe-kb ~288). Root CLAUDE.md: 97 -> 98 lines (+1). global-macro-analysis: 62 committed -> 77 working tree (+15). nordic-pe: 67 committed -> 69 working tree (+2). buy-side unchanged since previous audit.

### 5.2 CLAUDE.md Sections Not Referenced by Operations

| Section | File | Lines | Referenced By |
|---------|------|-------|-------------|
| Design Judgment Principles | Root CLAUDE.md | ~11 | None found |
| Autonomy Rules | Root CLAUDE.md | ~10 | None found |
| Working Principles | Root CLAUDE.md | ~9 | None found |
| Delivery | Root CLAUDE.md | ~3 | None found |
| How I Work | ai-resources/CLAUDE.md | ~3 | None found |

These sections function as behavioral guidance loaded into every session.

DELTA: No change.

### 5.3 CLAUDE.md Growth History

**Root/CLAUDE.md:** Unknown — root workspace is not a git repository, so no commit history is available.

**ai-resources/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-12 | 95 |
| 566c7d5 | 2026-04-12 | 94 |
| 3b93c57 | 2026-04-12 | 94 |
| f284902 | 2026-04-11 | 94 |
| dc6fe4d | 2026-04-06 | 94 |
| 241dfb4 | 2026-04-06 | 92 |
| b5f497e | 2026-04-05 | 86 |

DELTA: +2 commits since previous audit (all touching CLAUDE.md indirectly — no committed change to CLAUDE.md content itself; 566c7d5 and 3b93c57 modify CLAUDE.md per working tree diff). Working tree still 1 line ahead of committed.

**buy-side-service-plan/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-12 | 157 |
| 14f845d | 2026-04-05 | 146 |
| 1a07fcb | 2026-04-04 | 146 |
| 40cfb4c | 2026-04-04 | 146 |

DELTA: No change in committed state (still 14f845d 2026-04-05 at 146 lines, working tree 157). Still 11 uncommitted lines.

**global-macro-analysis/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-12 | 77 |
| 6561c4f | 2026-04-11 | 71 |
| cab5304 | 2026-04-11 | 62 |

DELTA: +1 commit (6561c4f adds 9 lines for workflow-analysis findings, brings committed count to 71). Working tree now 6 lines ahead (77 vs 71).

**nordic-pe-landscape-mapping-4-26/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-12 | 69 |
| 4be04a5 | 2026-04-06 | 67 |
| fc833e8 | 2026-04-02 | N/A |

DELTA: No commit changes since previous audit. Working tree now 2 lines ahead.

**project-planning/CLAUDE.md:** Not a git repo — 55 lines, file dated 2026-04-11.

**obsidian-pe-kb/vault/CLAUDE.md:** Not a git repo — ~180 lines, file dated 2026-04-12.

Section summary: 0 issues flagged / 5 deltas from previous audit

---

## Section 6: Drift & Staleness

### 6.1 Stale Files Still Referenced by Active Operations

Files not modified in the last 90 days (before 2026-01-12) that are still referenced:

| File | Last Commit Date | Referenced By |
|------|-----------------|--------------|
| ai-resources/skills/answer-spec-generator/references/component-templates.md | Pre-2026-01-06 | answer-spec-generator SKILL.md |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | Pre-2026-01-06 | execution-manifest-creator SKILL.md |
| ai-resources/skills/research-extract-creator/references/extract-template.md | Pre-2026-01-06 | research-extract-creator SKILL.md |

Files between 90 and 60 days old:
- ai-resources/scripts/repo-audit.sh — 2026-02-20 (Manual execution)
- ai-resources/scripts/skill-inventory.sh — 2026-02-20 (Manual execution)
- ai-resources/.claude/hooks/pre-commit — 2026-02-20 (not actively wired; on disk)

Files between 30 and 60 days old:
- ai-resources/skills/ai-resource-builder/references/examples.md — 2026-04-05 (within window now — not stale by 90-day rule)
- ai-resources/skills/ai-resource-builder/references/writing-standards.md — 2026-04-05
- ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md — 2026-04-05
- ai-resources/prompts/supplementary-research/*.md (5 files) — 2026-03-24

DELTA: -3 stale items (ai-resource-builder references/examples.md, writing-standards.md, operational-frontmatter.md are all dated 2026-04-05 and within 90-day window as of 2026-04-12). Previous audit listed these as pre-2026-01-06 which was incorrect — git log -1 shows them at 2026-04-05.

### 6.2 TODO/FIXME/PLACEHOLDER Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| projects/buy-side-service-plan/context/style-guide.md | 3 | TODO | "TODO: Populate after your first content draft. Your writing style will emerge from doing the work, then you codify it here." |

Other occurrences are intentional or belong to documentation/audit artifacts:
- `ai-resources/skills/workflow-evaluator/SKILL.md` line 312: "TODO" used as description of incomplete workflow states (not an action marker)
- `ai-resources/skills/implementation-spec-writer/SKILL.md` lines 50, 254, 257: {{PLACEHOLDER}} syntax for template resolution
- `ai-resources/skills/workspace-template-extractor/SKILL.md` lines 31, 100: {{PLACEHOLDER}} as feature
- `ai-resources/.claude/commands/deploy-workflow.md` line 151: {{PLACEHOLDER}} as documented replacement target
- `ai-resources/workflows/research-workflow/SETUP.md` lines 26, 135: {{PLACEHOLDER}} as feature
- `projects/buy-side-service-plan/logs/session-notes-archive-part1.md`: contains TODO strings inside quoted session content

Searched all files across workspace for: TODO, FIXME, PLACEHOLDER, HACK, XXX, STUB.

DELTA: No change.

### 6.3 Empty or Stub Files

**Empty directory markers (.gitkeep):** 63 files across workspace.

DELTA: No change.

**Files with fewer than 5 lines of real content:**

| File | Lines | Content |
|------|-------|---------|
| projects/buy-side-service-plan/report/chapters/1.3/1.3-module-00-methodology.md | 3 | Stub |
| projects/buy-side-service-plan/logs/execution-log.md | 1 | Empty |
| projects/buy-side-service-plan/context/style-guide.md | 4 | Header + TODO |
| projects/buy-side-service-plan/context/domain-knowledge.md | 4 | Header + placeholder |
| projects/nordic-pe-landscape-mapping-4-26/logs/decisions.md | 1 | Empty |
| projects/nordic-pe-landscape-mapping-4-26/logs/qc-log.md | 1 | Empty |
| projects/nordic-pe-landscape-mapping-4-26/logs/workflow-observations.md | 1 | Empty |
| projects/nordic-pe-landscape-mapping-4-26/reports/last-audit-commit.txt | 1 | Commit hash |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/input/fund-list.csv | 1 | Header row only |
| projects/global-macro-analysis/macro-kb/_meta/changelog.json | 1 | Empty array |
| projects/global-macro-analysis/macro-kb/_meta/index.json | 1 | Empty array |
| projects/global-macro-analysis/macro-kb/_meta/changelog.md | 3 | Header only |
| projects/global-macro-analysis/pipeline/decisions.md | 4 | Header only |
| projects/nordic-pe-landscape-mapping-4-26/pipeline/decisions.md | 4 | Header only |
| ai-resources/workflows/research-workflow/logs/innovation-registry.md | 4 | Header only |
| workflows/reports/last-audit-commit.txt | 1 | Commit hash |

DELTA: -2 items (global-macro-analysis reports/.audit-temp/*.json temp files no longer exist — directory removed). +2 items newly visible (pipeline/decisions.md in global-macro-analysis and nordic-pe; innovation-registry.md template). ai-resources/.claude/settings.local.json no longer exists (removed).

Section summary: 12 items flagged / 5 deltas from previous audit

---

## Audit Summary

| Section | Items Catalogued / Issues Flagged | Deltas From Previous Audit |
|---------|----------------------------------|---------------------------|
| 1. Inventory | 347 items catalogued | 19 deltas |
| 2. CLAUDE.md Health | 3 issues flagged | 4 deltas |
| 3. Dependency References | 0 issues flagged | 4 deltas |
| 4. Consistency Checks | 3 issues flagged | 6 deltas |
| 5. Context Load | 0 issues flagged | 5 deltas |
| 6. Drift & Staleness | 12 items flagged | 5 deltas |

Total issues/items flagged across health sections: 18
Total deltas from previous audit: 43
