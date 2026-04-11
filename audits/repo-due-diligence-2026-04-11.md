# Repo Due Diligence Audit — 2026-04-11

Repo: Axcion AI Workspace (multi-repo)
Commits: ai-resources `f284902` (+ 7 uncommitted modified files) | buy-side-service-plan `fe09197` (+ uncommitted changes) | nordic-pe `4be04a5` (+ uncommitted changes) | global-macro-analysis `0c5e445` | workflows `8f3fb40` (+ uncommitted changes incl. deleted files)
Previous audit: 2026-04-06 (commit ai-resources `241dfb4`)
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

**ai-resources/.claude/commands/ (26 commands)**

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

DELTA: +2 commands from previous audit (24 -> 26). New: analyze-workflow.md, refinement-deep.md.

**ai-resources/workflows/research-workflow/.claude/commands/ (26 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | workflows/research-workflow/.claude/commands/ | reference/skills/repo-health-analyzer/agents/ |
| audit-structure.md | workflows/research-workflow/.claude/commands/ | reference/file-conventions.md, reference/stage-instructions.md |
| create-context-pack.md | workflows/research-workflow/.claude/commands/ | ai-resources/skills/context-pack-builder/SKILL.md, preparation/task-plans/*, execution/context-packs/ |
| friction-log.md | workflows/research-workflow/.claude/commands/ | logs/friction-log.md |
| improve.md | workflows/research-workflow/.claude/commands/ | logs/friction-log.md, logs/improvement-log.md, CLAUDE.md |
| inject-dependency.md | workflows/research-workflow/.claude/commands/ | execution/research-prompts/*, execution/raw-reports/ |
| intake-reports.md | workflows/research-workflow/.claude/commands/ | execution/research-prompts/*/session-plan.md, execution/raw-reports/ |
| note.md | workflows/research-workflow/.claude/commands/ | logs/workflow-observations.md |
| prime.md | workflows/research-workflow/.claude/commands/ | logs/session-notes.md, checkpoints/ |
| produce-knowledge-file.md | workflows/research-workflow/.claude/commands/ | report/chapters/, report/architecture/, reference/skills/knowledge-file-producer/SKILL.md |
| produce-prose.md | workflows/research-workflow/.claude/commands/ | report/chapters/, skills (produce-prose pipeline) |
| qc-pass.md | workflows/research-workflow/.claude/commands/ | None (inline prompt) |
| refinement-pass.md | workflows/research-workflow/.claude/commands/ | None (inline prompt) |
| review.md | workflows/research-workflow/.claude/commands/ | report/chapters/, report/architecture/, analysis/section-directives/, logs/qc-log.md |
| run-analysis.md | workflows/research-workflow/.claude/commands/ | skills: gap-assessment-gate, section-directive-drafter, analysis-pass-memo-review, editorial-recommendations-generator, editorial-recommendations-qc |
| run-cluster.md | workflows/research-workflow/.claude/commands/ | skills: cluster-analysis-pass, cluster-memo-refiner; execution/research-extracts/, analysis/cluster-memos/ |
| run-execution.md | workflows/research-workflow/.claude/commands/ | skills: execution-manifest-creator, research-prompt-creator, research-extract-creator, research-extract-verifier |
| run-preparation.md | workflows/research-workflow/.claude/commands/ | skills: task-plan-creator, research-plan-creator, answer-spec-generator, answer-spec-qc |
| run-report.md | workflows/research-workflow/.claude/commands/ | skills: research-structure-creator, evidence-to-report-writer, chapter-prose-reviewer, report-compliance-qc, citation-converter |
| run-synthesis.md | workflows/research-workflow/.claude/commands/ | skills: cluster-synthesis-drafter; analysis/cluster-memos/, analysis/section-directives/ |
| status.md | workflows/research-workflow/.claude/commands/ | preparation/, execution/, analysis/, report/, final/, logs/ |
| update-claude-md.md | workflows/research-workflow/.claude/commands/ | CLAUDE.md |
| usage-analysis.md | workflows/research-workflow/.claude/commands/ | usage/usage-log.md, skills/session-usage-analyzer/SKILL.md |
| verify-chapter.md | workflows/research-workflow/.claude/commands/ | report/chapters/, reference/sops/, skills/evidence-prose-fixer/SKILL.md |
| workflow-status.md | workflows/research-workflow/.claude/commands/ | reference/stage-instructions.md, skills/workflow-evaluator/SKILL.md |
| wrap-session.md | workflows/research-workflow/.claude/commands/ | logs/session-notes.md, logs/decisions.md, logs/innovation-registry.md |

DELTA: +3 commands from previous audit (23 -> 26). New: produce-prose.md, qc-pass.md, refinement-pass.md.

**Root workspace .claude/commands/ (9 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | .claude/commands/ | symlink -> ai-resources/skills/repo-health-analyzer/command.md |
| document-workflow.md | .claude/commands/ | processes/document-existing-process.md, templates/workflow-need.md |
| improve-workflow.md | .claude/commands/ | processes/improve-existing-workflow.md |
| new-workflow.md | .claude/commands/ | processes/create-new-workflow.md, templates/workflow-need.md |
| run-qc.md | .claude/commands/ | skills/workflow-evaluator/SKILL.md |
| status.md | .claude/commands/ | workflows/active/, workflows/archive/ |
| update-md.md | .claude/commands/ | CLAUDE.md |
| validate.md | .claude/commands/ | output-validator agent |
| wrap-session.md | .claude/commands/ | logs/session-notes.md, logs/decisions.md |

DELTA: No change

**workflows/.claude/commands/ (1 command)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | workflows/.claude/commands/ | symlink -> ai-resources/skills/repo-health-analyzer/command.md |

DELTA: No change

**projects/global-macro-analysis/.claude/commands/ (34 commands)**

| Name | Defined At | Type | Referenced Files |
|------|-----------|------|-----------------|
| analyze-workflow.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| audit-repo.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| clarify.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| coach.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| create-skill.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| friction-log.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| improve-skill.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| improve.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| kb-audit.md | global-macro-analysis/.claude/commands/ | local | macro-kb/ (full read), macro-kb/_meta/audit-report.md (write) |
| kb-cross-theme.md | global-macro-analysis/.claude/commands/ | local | theme files, synthesis files |
| kb-gap-audit.md | global-macro-analysis/.claude/commands/ | local | _sources/registry.md, theme files, synthesis files |
| kb-ingest.md | global-macro-analysis/.claude/commands/ | local | _inbox/, _meta/taxonomy.md, skills/intake-processor/SKILL.md, _meta/confidence-rubric.md -> _staging/ |
| kb-populate.md | global-macro-analysis/.claude/commands/ | local | _meta/taxonomy.md, theme synthesis + entries -> _staging/ |
| kb-query.md | global-macro-analysis/.claude/commands/ | local | _meta/index.json, _meta/taxonomy.md, synthesis files |
| kb-registry-query.md | global-macro-analysis/.claude/commands/ | local | _sources/registry.md |
| kb-reindex.md | global-macro-analysis/.claude/commands/ | local | All theme folders -> _meta/index.json |
| kb-review.md | global-macro-analysis/.claude/commands/ | local | _staging/ -> theme folders, _meta/index.json, _meta/changelog.* |
| kb-stale.md | global-macro-analysis/.claude/commands/ | local | _meta/index.json, synthesis metadata |
| kb-synthesize.md | global-macro-analysis/.claude/commands/ | local | Theme entries, _history/, _meta/taxonomy.md, _meta/index.json, _meta/prompts/synthesis-prompt.md -> _synthesis.md, _history/ |
| kb-theme-health.md | global-macro-analysis/.claude/commands/ | local | Theme files |
| kb-triage-stats.md | global-macro-analysis/.claude/commands/ | local | _sources/registry.md |
| migrate-skill.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| note.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| prime.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| qc-pass.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| refinement-deep.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| refinement-pass.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| repo-dd.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| request-skill.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| scope.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| triage.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| update-claude-md.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| usage-analysis.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |
| wrap-session.md | global-macro-analysis/.claude/commands/ | symlink -> ai-resources | ai-resources command |

DELTA: NEW — entire project is new since last audit. 13 local kb-* commands + 21 symlinked ai-resources commands.

**projects/buy-side-service-plan/.claude/commands/ (37 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| analyze-workflow.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| audit-repo.md | buy-side/.claude/commands/ | local — references repo-health-analyzer agents |
| audit-structure.md | buy-side/.claude/commands/ | reference/file-conventions.md, reference/stage-instructions.md |
| challenge.md | buy-side/.claude/commands/ | local — project-specific |
| clarify.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| coach.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| content-review.md | buy-side/.claude/commands/ | local — project-specific |
| create-context-pack.md | buy-side/.claude/commands/ | local — research workflow command |
| draft-section.md | buy-side/.claude/commands/ | local — project-specific |
| friction-log.md | buy-side/.claude/commands/ | local — research workflow command |
| improve.md | buy-side/.claude/commands/ | local — research workflow command |
| inject-dependency.md | buy-side/.claude/commands/ | local — research workflow command |
| intake-reports.md | buy-side/.claude/commands/ | local — research workflow command |
| note.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| prime.md | buy-side/.claude/commands/ | local — research workflow command |
| produce-knowledge-file.md | buy-side/.claude/commands/ | local — research workflow command |
| produce-prose.md | buy-side/.claude/commands/ | symlink -> research-workflow template |
| qc-pass.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| refinement-deep.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| refinement-pass.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| review.md | buy-side/.claude/commands/ | local — research workflow command |
| run-analysis.md | buy-side/.claude/commands/ | local — research workflow command |
| run-cluster.md | buy-side/.claude/commands/ | local — research workflow command |
| run-execution.md | buy-side/.claude/commands/ | local — research workflow command |
| run-preparation.md | buy-side/.claude/commands/ | local — research workflow command |
| run-report.md | buy-side/.claude/commands/ | local — research workflow command |
| run-synthesis.md | buy-side/.claude/commands/ | local — research workflow command |
| save-session.md | buy-side/.claude/commands/ | local — project-specific |
| scope.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| service-design-review.md | buy-side/.claude/commands/ | local — project-specific |
| status.md | buy-side/.claude/commands/ | local — research workflow command |
| triage.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| update-claude-md.md | buy-side/.claude/commands/ | symlink -> ai-resources |
| usage-analysis.md | buy-side/.claude/commands/ | local — research workflow command |
| verify-chapter.md | buy-side/.claude/commands/ | local — research workflow command |
| workflow-status.md | buy-side/.claude/commands/ | local — research workflow command |
| wrap-session.md | buy-side/.claude/commands/ | local — research workflow command |

DELTA: +15 commands from previous audit (22 -> 37). New commands include analyze-workflow, produce-prose (symlink), refinement-deep, and others added via symlink sync or manually.

**projects/nordic-pe-landscape-mapping-4-26/.claude/commands/ (6 commands + 1 sub-project)**
- note.md, prime.md, review.md, session-guide.md, status.md, wrap-session.md
- step-1-long-list: triage.md (1 command)

DELTA: No change

**workflows/active/research-workflow/project-template/.claude/commands/ (3 commands)**
- audit-repo.md, friction-log.md, improve.md

DELTA: No change

**Total commands across workspace: 143**

### 1.2 Hooks

**7 settings.json files found across workspace:**

| Location | Hooks Present |
|----------|--------------|
| Root .claude/settings.json | SessionStart (load session notes), Stop (wrap-session reminder) |
| ai-resources/.claude/settings.json | Stop (innovation triage reminder) |
| ai-resources/workflows/research-workflow/.claude/settings.json | PreToolUse (Skill: friction-log, Edit: bright-line), PostToolUse (Write: auto-commit + log + detect-innovation, Edit: log + detect-innovation), SessionStart (checkpoint + drift check + auto-sync-shared), Stop (checkpoint reminder + wrap-session), UserPromptSubmit (decision logging) |
| projects/buy-side-service-plan/.claude/settings.json | PreToolUse (Edit: bright-line, Skill: friction-log), PostToolUse (Write: auto-commit + claim-ids + log, Edit: log), SessionStart (checkpoint + drift check + auto-sync-shared), Stop (checkpoint + wrap + improve-reminder + coach-reminder), UserPromptSubmit (decision logging) |
| projects/nordic-pe/.claude/settings.json | PostToolUse (Write: auto-commit + log, Edit: log), SessionStart (load notes), Stop (wrap reminder) |
| projects/nordic-pe/step-1-long-list/.claude/settings.json | Permissions only (WebFetch, WebSearch) — no hooks |
| projects/global-macro-analysis — NO settings.json | N/A |

DELTA: +3 hooks in research-workflow template settings.json (auto-sync-shared added to SessionStart). global-macro-analysis has no settings.json file — no hooks configured for this project.

**3 settings.local.json files found** (ai-resources, buy-side, workflows). No hook overrides.

DELTA: No change

**Hook scripts on disk (21 total):**

| Script | Location | Called By |
|--------|----------|----------|
| auto-sync-shared.sh | ai-resources/.claude/hooks/ | SessionStart (research-workflow, buy-side) |
| check-template-drift.sh | ai-resources/.claude/hooks/ | SessionStart (research-workflow, buy-side) |
| detect-innovation.sh | ai-resources/.claude/hooks/ | PostToolUse (research-workflow Write/Edit) |
| pre-commit | ai-resources/.claude/hooks/ | Git pre-commit |
| check-claim-ids.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write) |
| detect-innovation.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PreToolUse (Skill) |
| log-write-activity.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| check-claim-ids.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write) |
| coach-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | Stop |
| detect-innovation.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Edit) |
| friction-log-auto.sh | projects/buy-side-service-plan/.claude/hooks/ | PreToolUse (Skill) |
| improve-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | Stop |
| log-write-activity.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write/Edit) |
| detect-innovation.sh | projects/global-macro-analysis/.claude/hooks/ | Not called — no settings.json configures it |
| auto-commit.sh | projects/nordic-pe/.claude/hooks/ | PostToolUse (Write) |
| log-write-activity.sh | projects/nordic-pe/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (untracked template) |
| log-write-activity.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (untracked template) |

DELTA: +3 from previous audit (16 -> 21, including correction). New: auto-sync-shared.sh (ai-resources), detect-innovation.sh (global-macro-analysis — orphaned, no settings.json references it), log-write-activity.sh (project-template). Previous audit undercounted project-template hooks.

### 1.3 Template Files

| Path | Used By | Last Commit Date |
|------|---------|-----------------|
| ai-resources/skills/answer-spec-generator/references/component-templates.md | answer-spec-generator skill | Pre-2026-01-06 |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | execution-manifest-creator skill | Pre-2026-01-06 |
| ai-resources/skills/research-extract-creator/references/extract-template.md | research-extract-creator skill | Pre-2026-01-06 |
| ai-resources/workflows/research-workflow/CLAUDE.md | /deploy-workflow (contains {{PLACEHOLDERS}}) | 2026-04-03 |
| ai-resources/workflows/research-workflow/SETUP.md | /deploy-workflow (deployment checklist) | 2026-04-03 |
| ai-resources/workflows/research-workflow/ (entire directory) | /deploy-workflow — copies as project template | 2026-04-11 |
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

`templates/workflow-need.md` is referenced by `/document-workflow` and `/new-workflow` commands but does not exist on disk. No record in git history.

DELTA: +12 new template files (all in global-macro-analysis/macro-kb/_meta/templates/).

### 1.4 Scripts

| Path | Purpose | Called By |
|------|---------|----------|
| ai-resources/scripts/repo-audit.sh | Shell-based repo health audit | Manual execution |
| ai-resources/scripts/skill-inventory.sh | Lists skills with metadata | Manual execution |

All other .sh files are hook scripts (listed in 1.2).

DELTA: No change

### 1.5 Skills

63 skill directories in `ai-resources/skills/` (excluding CATALOG.md). All 63 have a SKILL.md file. None are missing SKILL.md.

3 additional project-specific skills outside ai-resources:
- `projects/global-macro-analysis/skills/intake-processor/SKILL.md`
- `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner/SKILL.md`
- `ai-resources/workflows/research-workflow/reference/skills/knowledge-file-producer/SKILL.md` (copy in template)
- `ai-resources/workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md` (copy in template)

DELTA: +3 skills in ai-resources (60 -> 63). New: formatting-qc (2026-04-11), workflow-system-analyzer (2026-04-07), workflow-system-critic (2026-04-07). +1 project-specific skill (intake-processor in global-macro-analysis).

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
| ai-resources/inbox/repo-review-brief.md | Incoming review brief |
| workflows/processes/create-new-workflow.md | Workflow creation process doc |
| workflows/processes/document-existing-process.md | Workflow documentation process doc |
| workflows/processes/improve-existing-workflow.md | Workflow improvement process doc |
| workflows/reports/repo-health-report.md | Generated health report |
| workflows/active/research-workflow/project-template/ | Untracked template in development |
| projects/global-macro-analysis/pipeline/ (11 files) | Pipeline artifacts from project creation |
| projects/global-macro-analysis/macro-kb/_decisions/ (5 files) | Decision memos |
| projects/global-macro-analysis/macro-kb/_sources/registry.md | Source registry |
| projects/global-macro-analysis/macro-kb/_meta/ (multiple config files) | KB metadata |
| projects/global-macro-analysis/reports/.audit-temp/ (2 JSON files) | Stale audit temp files |
| logs/innovation-registry.md | Root workspace innovation registry (untracked) |

DELTA: +1 item (coaching-data.md). +1 entire project (global-macro-analysis with all its artifacts). +1 root-level untracked file (logs/innovation-registry.md).

### 1.7 Symlinks

| Symlink Path | Target | Target Exists |
|-------------|--------|--------------|
| (root)/.claude/commands/audit-repo.md | ../../ai-resources/skills/repo-health-analyzer/command.md | Y |
| (root)/.claude/agents/repo-health-analyzer.md | ../../ai-resources/skills/repo-health-analyzer/agents/repo-health-analyzer.md | Y |
| (root)/.claude/agents/auditors/claude-md-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/claude-md-auditor.md | Y |
| (root)/.claude/agents/auditors/command-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/command-auditor.md | Y |
| (root)/.claude/agents/auditors/file-org-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/file-org-auditor.md | Y |
| (root)/.claude/agents/auditors/practices-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/practices-auditor.md | Y |
| (root)/.claude/agents/auditors/settings-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/settings-auditor.md | Y |
| (root)/.claude/agents/auditors/skill-auditor.md | ../../../ai-resources/skills/repo-health-analyzer/agents/skill-auditor.md | Y |
| workflows/.claude/commands/audit-repo.md | ../../../ai-resources/skills/repo-health-analyzer/command.md | Y |
| projects/buy-side/reference/skills/analysis-pass-memo-review | absolute path -> ai-resources/skills/analysis-pass-memo-review | Y |
| projects/buy-side/reference/skills/answer-spec-generator | absolute path -> ai-resources/skills/answer-spec-generator | Y |
| projects/buy-side/reference/skills/answer-spec-qc | absolute path -> ai-resources/skills/answer-spec-qc | Y |
| projects/buy-side/reference/skills/chapter-prose-reviewer | absolute path -> ai-resources/skills/chapter-prose-reviewer | Y |
| projects/buy-side/reference/skills/citation-converter | absolute path -> ai-resources/skills/citation-converter | Y |
| projects/buy-side/reference/skills/cluster-analysis-pass | absolute path -> ai-resources/skills/cluster-analysis-pass | Y |
| projects/buy-side/reference/skills/cluster-memo-refiner | absolute path -> ai-resources/skills/cluster-memo-refiner | Y |
| projects/buy-side/reference/skills/cluster-synthesis-drafter | absolute path -> ai-resources/skills/cluster-synthesis-drafter | Y |
| projects/buy-side/reference/skills/context-pack-builder | absolute path -> ai-resources/skills/context-pack-builder | Y |
| projects/buy-side/reference/skills/document-integration-qc | absolute path -> ai-resources/skills/document-integration-qc | Y |
| projects/buy-side/reference/skills/evidence-prose-fixer | absolute path -> ai-resources/skills/evidence-prose-fixer | Y |
| projects/buy-side/reference/skills/evidence-spec-verifier | absolute path -> ai-resources/skills/evidence-spec-verifier | Y |
| projects/buy-side/reference/skills/evidence-to-report-writer | absolute path -> ai-resources/skills/evidence-to-report-writer | Y |
| projects/buy-side/reference/skills/gap-assessment-gate | absolute path -> ai-resources/skills/gap-assessment-gate | Y |
| projects/buy-side/reference/skills/knowledge-file-completeness-qc | absolute path -> ai-resources/skills/knowledge-file-completeness-qc | Y |
| projects/buy-side/reference/skills/knowledge-file-producer | relative path -> ../../../../ai-resources/skills/knowledge-file-producer | Y |
| projects/buy-side/reference/skills/repo-health-analyzer | absolute path -> ai-resources/skills/repo-health-analyzer | Y |
| projects/buy-side/reference/skills/report-compliance-qc | absolute path -> ai-resources/skills/report-compliance-qc | Y |
| projects/buy-side/reference/skills/research-plan-creator | absolute path -> ai-resources/skills/research-plan-creator | Y |
| projects/buy-side/reference/skills/research-structure-creator | absolute path -> ai-resources/skills/research-structure-creator | Y |
| projects/buy-side/reference/skills/section-directive-drafter | absolute path -> ai-resources/skills/section-directive-drafter | Y |
| projects/buy-side/reference/skills/task-plan-creator | absolute path -> ai-resources/skills/task-plan-creator | Y |
| projects/buy-side/.claude/commands/analyze-workflow.md | absolute path -> ai-resources/.claude/commands/analyze-workflow.md | Y |
| projects/buy-side/.claude/commands/clarify.md | absolute path -> ai-resources/.claude/commands/clarify.md | Y |
| projects/buy-side/.claude/commands/coach.md | absolute path -> ai-resources/.claude/commands/coach.md | Y |
| projects/buy-side/.claude/commands/note.md | absolute path -> ai-resources/.claude/commands/note.md | Y |
| projects/buy-side/.claude/commands/produce-prose.md | relative path -> ../../../../ai-resources/workflows/research-workflow/.claude/commands/produce-prose.md | Y |
| projects/buy-side/.claude/commands/qc-pass.md | absolute path -> ai-resources/.claude/commands/qc-pass.md | Y |
| projects/buy-side/.claude/commands/refinement-deep.md | absolute path -> ai-resources/.claude/commands/refinement-deep.md | Y |
| projects/buy-side/.claude/commands/refinement-pass.md | absolute path -> ai-resources/.claude/commands/refinement-pass.md | Y |
| projects/buy-side/.claude/commands/scope.md | absolute path -> ai-resources/.claude/commands/scope.md | Y |
| projects/buy-side/.claude/commands/triage.md | absolute path -> ai-resources/.claude/commands/triage.md | Y |
| projects/buy-side/.claude/commands/update-claude-md.md | absolute path -> ai-resources/.claude/commands/update-claude-md.md | Y |
| projects/buy-side/.claude/agents/collaboration-coach.md | absolute path -> ai-resources/.claude/agents/collaboration-coach.md | Y |
| projects/buy-side/.claude/agents/refinement-reviewer.md | absolute path -> ai-resources/.claude/agents/refinement-reviewer.md | Y |
| projects/buy-side/.claude/agents/triage-reviewer.md | absolute path -> ai-resources/.claude/agents/triage-reviewer.md | Y |
| projects/buy-side/.claude/agents/workflow-analysis-agent.md | absolute path -> ai-resources/.claude/agents/workflow-analysis-agent.md | Y |
| projects/buy-side/.claude/agents/workflow-critique-agent.md | absolute path -> ai-resources/.claude/agents/workflow-critique-agent.md | Y |
| projects/nordic-pe/.claude/commands/session-guide.md | absolute path -> ai-resources/.claude/commands/session-guide.md | Y |
| projects/nordic-pe/reference/skills/repo-health-analyzer | absolute path -> ai-resources/skills/repo-health-analyzer | Y |
| projects/global-macro/.claude/commands/analyze-workflow.md | relative -> ../../../../ai-resources/.claude/commands/analyze-workflow.md | Y |
| projects/global-macro/.claude/commands/audit-repo.md | relative -> ../../../../ai-resources/.claude/commands/audit-repo.md | Y |
| projects/global-macro/.claude/commands/clarify.md | relative -> ../../../../ai-resources/.claude/commands/clarify.md | Y |
| projects/global-macro/.claude/commands/coach.md | relative -> ../../../../ai-resources/.claude/commands/coach.md | Y |
| projects/global-macro/.claude/commands/create-skill.md | relative -> ../../../../ai-resources/.claude/commands/create-skill.md | Y |
| projects/global-macro/.claude/commands/friction-log.md | relative -> ../../../../ai-resources/.claude/commands/friction-log.md | Y |
| projects/global-macro/.claude/commands/improve-skill.md | relative -> ../../../../ai-resources/.claude/commands/improve-skill.md | Y |
| projects/global-macro/.claude/commands/improve.md | relative -> ../../../../ai-resources/.claude/commands/improve.md | Y |
| projects/global-macro/.claude/commands/migrate-skill.md | relative -> ../../../../ai-resources/.claude/commands/migrate-skill.md | Y |
| projects/global-macro/.claude/commands/note.md | relative -> ../../../../ai-resources/.claude/commands/note.md | Y |
| projects/global-macro/.claude/commands/prime.md | relative -> ../../../../ai-resources/.claude/commands/prime.md | Y |
| projects/global-macro/.claude/commands/qc-pass.md | relative -> ../../../../ai-resources/.claude/commands/qc-pass.md | Y |
| projects/global-macro/.claude/commands/refinement-deep.md | relative -> ../../../../ai-resources/.claude/commands/refinement-deep.md | Y |
| projects/global-macro/.claude/commands/refinement-pass.md | relative -> ../../../../ai-resources/.claude/commands/refinement-pass.md | Y |
| projects/global-macro/.claude/commands/repo-dd.md | relative -> ../../../../ai-resources/.claude/commands/repo-dd.md | Y |
| projects/global-macro/.claude/commands/request-skill.md | relative -> ../../../../ai-resources/.claude/commands/request-skill.md | Y |
| projects/global-macro/.claude/commands/scope.md | relative -> ../../../../ai-resources/.claude/commands/scope.md | Y |
| projects/global-macro/.claude/commands/triage.md | relative -> ../../../../ai-resources/.claude/commands/triage.md | Y |
| projects/global-macro/.claude/commands/update-claude-md.md | relative -> ../../../../ai-resources/.claude/commands/update-claude-md.md | Y |
| projects/global-macro/.claude/commands/usage-analysis.md | relative -> ../../../../ai-resources/.claude/commands/usage-analysis.md | Y |
| projects/global-macro/.claude/commands/wrap-session.md | relative -> ../../../../ai-resources/.claude/commands/wrap-session.md | Y |
| projects/global-macro/.claude/agents/collaboration-coach.md | relative -> ../../../../ai-resources/.claude/agents/collaboration-coach.md | Y |
| projects/global-macro/.claude/agents/execution-agent.md | relative -> ../../../../ai-resources/.claude/agents/execution-agent.md | Y |
| projects/global-macro/.claude/agents/improvement-analyst.md | relative -> ../../../../ai-resources/.claude/agents/improvement-analyst.md | Y |
| projects/global-macro/.claude/agents/qc-reviewer.md | relative -> ../../../../ai-resources/.claude/agents/qc-reviewer.md | Y |
| projects/global-macro/.claude/agents/refinement-reviewer.md | relative -> ../../../../ai-resources/.claude/agents/refinement-reviewer.md | Y |
| projects/global-macro/.claude/agents/repo-dd-auditor.md | relative -> ../../../../ai-resources/.claude/agents/repo-dd-auditor.md | Y |
| projects/global-macro/.claude/agents/triage-reviewer.md | relative -> ../../../../ai-resources/.claude/agents/triage-reviewer.md | Y |
| projects/global-macro/.claude/agents/workflow-analysis-agent.md | relative -> ../../../../ai-resources/.claude/agents/workflow-analysis-agent.md | Y |
| projects/global-macro/.claude/agents/workflow-critique-agent.md | relative -> ../../../../ai-resources/.claude/agents/workflow-critique-agent.md | Y |

78 symlinks total. All targets exist and are accessible.

DELTA: +52 from previous audit (26 -> 78). +30 in global-macro-analysis (21 commands + 9 agents). +22 in buy-side (11 commands + 5 agents, added via auto-sync-shared).

### 1.8 Agent Definitions

| Location | Count | Files |
|----------|-------|-------|
| ai-resources/.claude/agents/ | 17 | collaboration-coach.md, execution-agent.md, improvement-analyst.md, pipeline-stage-2.md, pipeline-stage-2-5.md, pipeline-stage-3a.md, pipeline-stage-3b.md, pipeline-stage-3c.md, pipeline-stage-4.md, pipeline-stage-5.md, qc-reviewer.md, refinement-reviewer.md, repo-dd-auditor.md, session-guide-generator.md, triage-reviewer.md, workflow-analysis-agent.md, workflow-critique-agent.md |
| ai-resources/workflows/research-workflow/.claude/agents/ | 4 | execution-agent.md, improvement-analyst.md, qc-gate.md, verification-agent.md |
| projects/buy-side-service-plan/.claude/agents/ | 12 | collaboration-coach.md (symlink), qc-gate.md, qc-reviewer.md, refinement-reviewer.md (symlink), research-synthesizer.md, section-drafter.md, service-designer.md, strategic-critic.md, triage-reviewer.md (symlink), verification-agent.md, workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| projects/global-macro-analysis/.claude/agents/ | 9 | collaboration-coach.md (symlink), execution-agent.md (symlink), improvement-analyst.md (symlink), qc-reviewer.md (symlink), refinement-reviewer.md (symlink), repo-dd-auditor.md (symlink), triage-reviewer.md (symlink), workflow-analysis-agent.md (symlink), workflow-critique-agent.md (symlink) |
| projects/nordic-pe/.claude/agents/ | 1 | qc-gate.md |
| root .claude/agents/ | 2 | output-validator.md, repo-health-analyzer.md (symlink) |
| root .claude/agents/auditors/ | 6 | claude-md-auditor.md, command-auditor.md, file-org-auditor.md, practices-auditor.md, settings-auditor.md, skill-auditor.md (all symlinks) |
| workflows/active/research-workflow/project-template/.claude/agents/ | 1 | improvement-analyst.md |

DELTA: +18 from previous audit (34 -> 52). +2 in ai-resources (workflow-analysis-agent.md, workflow-critique-agent.md). +5 in buy-side (new symlinks). +9 in global-macro-analysis (all new, all symlinks). +1 in root (repo-health-analyzer.md symlink).

Section summary: 211 items catalogued / 15 deltas from previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Files

| File | Lines | Sections | Section Headings |
|------|-------|----------|-----------------|
| (root)/CLAUDE.md | 97 | 12 | What This Workspace Is For, Projects, Axcion's Tool Ecosystem, Skill Library, AI Resource Creation Rules, Design Judgment Principles, QC Independence Rule, Completion Standard, Working Principles, Autonomy Rules, File verification and git commits, Delivery |
| ai-resources/CLAUDE.md | 95 (working tree; 94 committed) | 11 | What This Repo Contains, How I Work, Skill Format Standard, Model Preference, Development Workflow (Creation, Improvement, Quality Check), General Session Rules, Cross-References, Git Rules |
| workflows/CLAUDE.md | 23 | 3 | Workflow Development Workspace, Directory Structure, Relationship to ai-resources |
| ai-resources/workflows/research-workflow/CLAUDE.md | ~120 | Template with {{PLACEHOLDERS}} |
| projects/buy-side-service-plan/CLAUDE.md | 157 (working tree; 146 committed) | 12 | (project-specific) |
| projects/nordic-pe/CLAUDE.md | 67 | 8 | (project-specific) |
| projects/nordic-pe/step-1-long-list/CLAUDE.md | 30 | 4 | (step-specific) |
| projects/global-macro-analysis/CLAUDE.md | 62 | 6 | Global Macro Analysis, Command Scope Table, Hard Rules, Intake Processing Rules, Key File Paths, Operational Notes |

DELTA: +1 new CLAUDE.md (global-macro-analysis). Root: 98 -> 97 lines (-1). ai-resources: 92 -> 95 lines (+3 uncommitted). buy-side: 146 -> 157 lines (+11 uncommitted).

### 2.2 Dead References

| CLAUDE.md File | Referenced Item | Status | Git History |
|---------------|----------------|--------|-------------|
| (root)/CLAUDE.md | `templates/workflow-need.md` (via /document-workflow and /new-workflow commands) | Does not exist | No record found — never committed |

All other file references verified as existing. Checked: all skill paths, reference paths, command paths, hook script paths across all 8 CLAUDE.md files. All paths in global-macro-analysis/CLAUDE.md resolve correctly (taxonomy.md, index.json, confidence-rubric.md, synthesis-prompt.md, registry.md, _decisions/, intake-processor/SKILL.md).

DELTA: -1 dead reference resolved. Previous audit flagged `skills` symlink as unused — it still exists but this was informational, not a dead reference.

### 2.3 Contradictions

**Contradiction 1: Skill ownership vs. actual practice**

Root CLAUDE.md line 34: "Do not create AI resources in project workspaces. Skills, commands, and agent definitions belong in `ai-resources/`."

Root CLAUDE.md line 26: "Project workspaces reference skills via copy or symlink — they do not own them."

Actual state: 2 project-owned skills not present in `ai-resources/skills/`:
- `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner/SKILL.md`
- `projects/global-macro-analysis/skills/intake-processor/SKILL.md`

No other contradictions found — checked all 8 CLAUDE.md files for conflicting statements.

DELTA: Contradiction persists and now includes 1 additional project-owned skill (intake-processor).

### 2.4 Conventions Not Followed

| Convention | Source | Violation |
|-----------|--------|-----------|
| Commit message format: `new:`, `update:`, `fix:`, `batch:` | ai-resources/CLAUDE.md line 90 | buy-side auto-commit hook uses `update: $stage — $bn` format (partially follows convention but deviates from `new:/update:/fix:/batch:` taxonomy) |
| Skills belong in ai-resources | Root CLAUDE.md line 34 | fund-triage-scanner exists only in project workspace |
| Skills belong in ai-resources | Root CLAUDE.md line 34 | intake-processor exists only in project workspace |

Conventions verified as followed:
- Skill folder naming (lowercase, hyphenated) — all 63 skills comply
- SKILL.md file naming — all 63 skills have exactly `SKILL.md`
- YAML frontmatter with `name` and `description` — all 63 skills comply
- No auxiliary files in skill directories — none found
- Body under 500 lines — all comply (max: answer-spec-generator at 485)

DELTA: +1 violation (intake-processor in global-macro-analysis)

### 2.5 Partial Feature References

| Feature | What Exists | What's Missing |
|---------|------------|----------------|
| /document-workflow command | Command file at root .claude/commands/document-workflow.md; process doc at workflows/processes/document-existing-process.md | `templates/workflow-need.md` referenced by command |
| /new-workflow command | Command file at root .claude/commands/new-workflow.md; process doc at workflows/processes/create-new-workflow.md | `templates/workflow-need.md` referenced by command |
| global-macro-analysis detect-innovation.sh | Hook script at projects/global-macro-analysis/.claude/hooks/detect-innovation.sh | No settings.json — hook is never triggered |

DELTA: +1 (orphaned detect-innovation.sh in global-macro-analysis)

Section summary: 5 issues flagged / 5 deltas from previous audit

---

## Section 3: Dependency References

### 3.1 Command-to-File Reference Map

See Section 1.1 for full mapping. Verification summary:

| Result | Count |
|--------|-------|
| All referenced files exist | 95 commands |
| Referenced file missing | 2 commands (/document-workflow, /new-workflow — both reference `templates/workflow-need.md` which does not exist) |
| References are dynamic (created at runtime) | ~12 commands (logs, session notes, checkpoints, staging) |
| Symlinked commands (verified via target) | 34 commands |

All 13 kb-* commands in global-macro-analysis verified — all referenced paths (taxonomy.md, index.json, confidence-rubric.md, synthesis-prompt.md, intake-processor/SKILL.md, _inbox/, _staging/, _sources/registry.md) exist.

DELTA: +34 commands verified (global-macro-analysis commands all resolve)

### 3.2 Command Chains

**Research Workflow Pipeline (sequential, multi-session):**
```
/run-preparation -> /run-execution -> /run-cluster -> /run-analysis -> /run-synthesis -> /run-report -> /verify-chapter -> /produce-knowledge-file
```

**KB Workflow Pipeline (global-macro-analysis):**
```
/kb-ingest -> /kb-review -> /kb-synthesize
```
Supporting commands (read-only, can run independently): /kb-query, /kb-stale, /kb-audit, /kb-reindex, /kb-populate (feeds into /kb-review), /kb-registry-query, /kb-gap-audit, /kb-theme-health, /kb-cross-theme, /kb-triage-stats

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
/repo-dd (factual) -> /repo-dd deep (+ operational assessment) -> /repo-dd full (+ pipeline testing)
```

**Workflow Analysis Pipeline:**
```
/analyze-workflow (two-phase: analysis agent -> critique agent)
```

**Refinement Pipeline:**
```
/refinement-deep (orchestrates /qc-pass + /refinement-pass + /triage)
```

DELTA: +3 chains (KB Workflow Pipeline, Workflow Analysis Pipeline, Refinement Pipeline)

### 3.3 Files Referenced by Multiple Commands/Hooks

| File | Referenced By |
|------|--------------|
| logs/session-notes.md | /wrap-session, /prime, /coach, SessionStart hooks (root, buy-side, nordic-pe), Stop hooks (root, buy-side, nordic-pe), /usage-analysis, /repo-dd |
| logs/innovation-registry.md | /wrap-session, /prime, /graduate-resource, Stop hooks (ai-resources, buy-side, research-workflow template), /repo-dd |
| logs/friction-log.md | /friction-log, /improve, /wrap-session, /repo-dd |
| logs/decisions.md | /wrap-session, /prime, /repo-dd |
| CLAUDE.md | /update-claude-md, /sync-workflow, /improve, /workflow-status, SessionStart hooks |
| .claude/settings.json | /deploy-workflow, /sync-workflow |
| skills/ai-resource-builder/SKILL.md | /create-skill, /improve-skill, /migrate-skill |
| skills/ai-resource-builder/references/evaluation-framework.md | /create-skill, /improve-skill |
| macro-kb/_meta/taxonomy.md | /kb-ingest, /kb-populate, /kb-synthesize, /kb-query, /kb-reindex |
| macro-kb/_meta/index.json | /kb-review, /kb-reindex, /kb-query, /kb-stale, /kb-synthesize |
| macro-kb/_sources/registry.md | /kb-registry-query, /kb-gap-audit, /kb-triage-stats |
| macro-kb/_staging/ | /kb-ingest (writes), /kb-populate (writes), /kb-review (reads) |

DELTA: +4 entries (taxonomy.md, index.json, registry.md, _staging/ — all from global-macro-analysis)

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | logs/session-notes.md | 10 | /wrap-session, /prime, /coach, /usage-analysis, /repo-dd, SessionStart x3, Stop x2 |
| 2 | logs/innovation-registry.md | 6 | /wrap-session, /prime, /graduate-resource, /repo-dd, Stop hooks x3 |
| 3 | CLAUDE.md (per repo) | 6 | /update-claude-md, /sync-workflow, /improve, /workflow-status, SessionStart hooks, /wrap-session |
| 4 | macro-kb/_meta/taxonomy.md | 5 | /kb-ingest, /kb-populate, /kb-synthesize, /kb-query, /kb-reindex |
| 5 | macro-kb/_meta/index.json | 5 | /kb-review, /kb-reindex, /kb-query, /kb-stale, /kb-synthesize |
| 6 | logs/friction-log.md | 4 | /friction-log, /improve, /wrap-session, /repo-dd |
| 7 | logs/decisions.md | 4 | /prime, /wrap-session, /repo-dd, /wrap-session (root) |
| 8 | report/chapters/ (directory) | 4 | /run-report, /verify-chapter, /review, /produce-knowledge-file |
| 9 | analysis/cluster-memos/ (directory) | 4 | /run-cluster, /run-analysis, /run-synthesis, /review |
| 10 | skills/ai-resource-builder/SKILL.md | 3 | /create-skill, /improve-skill, /migrate-skill |

DELTA: +2 entries in top 10 (taxonomy.md and index.json from global-macro — both at 5 references)

Section summary: 0 issues flagged / 4 deltas from previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

Standard pattern (all 63 ai-resources skills): folder with SKILL.md containing YAML frontmatter (`name`, `description`), optional `references/` subdirectory.

| Check | Result |
|-------|--------|
| All have SKILL.md | Yes (63/63) |
| All have YAML frontmatter | Yes (63/63) |
| All have `name` field | Yes (63/63) |
| All have `description` field | Yes (63/63) |
| Skills with references/ | 8 of 63 |
| Skills with agents/ | 1 of 63 (repo-health-analyzer) |
| Skills with scripts/ | 0 of 63 |
| Skills with unexpected subdirectories | 0 of 63 |

Project-specific skills (intake-processor, fund-triage-scanner) also follow the standard pattern — both have SKILL.md with YAML frontmatter containing `name` and `description`.

DELTA: +3 skills (all conform to standard pattern)

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
| KB operations (scope-enforced) | 13 | kb-ingest.md, kb-review.md, kb-synthesize.md, etc. |

DELTA: +2 pattern variants (Orchestrator for refinement-deep.md, KB operations for 13 kb-* commands)

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resources/skills/ai-resource-builder/SKILL.md for format standards.

DELTA: No change

### 4.4 Naming Convention Inconsistencies

| Check | Result |
|-------|--------|
| Skill folders: lowercase, hyphenated | All 63 comply |
| Command files: lowercase, hyphenated .md | All comply |
| Agent files: lowercase, hyphenated .md | All comply |
| Hook scripts: lowercase, hyphenated .sh | All comply except `pre-commit` (standard git convention) |

Symlink path convention inconsistency:
- buy-side skill symlinks: mostly absolute paths (20 of 22), 2 relative paths
- buy-side command/agent symlinks: mostly absolute paths, 1 relative (produce-prose.md)
- global-macro-analysis: all relative paths (30 of 30)
- root workspace: all relative paths (8 of 8)
- nordic-pe: 1 absolute (session-guide.md), 1 absolute (repo-health-analyzer)

DELTA: global-macro-analysis uses consistent relative symlinks, unlike the mixed pattern in buy-side

### 4.5 Directory Structure Violations

| Violation | Location |
|-----------|----------|
| `prompts/` directory exists at ai-resources root | Not defined in any CLAUDE.md as a standard directory — documented in ai-resources/CLAUDE.md "What This Repo Contains" section as of recent commits but not in standard directory structure list |

`reports/` and `docs/` are documented in ai-resources/CLAUDE.md.

DELTA: No change (`prompts/` remains the only undocumented-but-described directory)

### 4.6 Command Syntax and Path Resolution

| Check | Pass | Fail |
|-------|------|------|
| Command files parseable as markdown | 143 | 0 |
| Referenced file paths resolve | 141 | 2 |

Failed path resolution:
- `/document-workflow` references `templates/workflow-need.md` — does not exist
- `/new-workflow` references `templates/workflow-need.md` — does not exist

DELTA: +83 commands verified (global-macro kb-* commands, buy-side new commands, research-workflow new commands — all pass)

### 4.7 Duplicate or Built-in Command Names

Commands with the same name at multiple levels:

| Name | Locations |
|------|-----------|
| audit-repo | ai-resources, research-workflow template, root (symlink), workflows (symlink), buy-side, global-macro (symlink) |
| wrap-session | ai-resources, research-workflow template, root, buy-side, global-macro (symlink), nordic-pe |
| update-claude-md | ai-resources, research-workflow template, buy-side, global-macro (symlink) |
| friction-log | ai-resources, research-workflow template, buy-side, global-macro (symlink) |
| improve | ai-resources, research-workflow template, buy-side, global-macro (symlink) |
| note | ai-resources, research-workflow template, buy-side (symlink), global-macro (symlink), nordic-pe |
| usage-analysis | ai-resources, research-workflow template, buy-side, global-macro (symlink) |
| prime | ai-resources, research-workflow template, buy-side, global-macro (symlink), nordic-pe |
| qc-pass | ai-resources, research-workflow template, buy-side (symlink), global-macro (symlink) |
| refinement-pass | ai-resources, research-workflow template, buy-side (symlink), global-macro (symlink) |
| status | research-workflow template, root, buy-side |
| analyze-workflow | ai-resources, buy-side (symlink), global-macro (symlink) |
| clarify | ai-resources, buy-side (symlink), global-macro (symlink) |
| coach | ai-resources, buy-side (symlink), global-macro (symlink) |
| scope | ai-resources, buy-side (symlink), global-macro (symlink) |
| triage | ai-resources, buy-side (symlink), global-macro (symlink) |
| refinement-deep | ai-resources, buy-side (symlink), global-macro (symlink) |

No command names conflict with built-in Claude Code commands — checked against: /help, /clear, /compact, /cost, /doctor, /init, /login, /logout, /memory, /model, /permissions, /review, /terminal-setup, /vim, /fast.

Note: `/review` exists as a workflow command (buy-side, research-workflow template, nordic-pe) and as a built-in Claude Code command. The custom command takes precedence when defined.

DELTA: Many more duplicates due to symlink propagation to global-macro-analysis and new buy-side symlinks. Count of unique command names appearing in 3+ locations: 17 (was 9).

Section summary: 3 issues flagged / 6 deltas from previous audit

---

## Section 5: Context Load

### 5.1 Context Loaded Per Session

| Entry Point | CLAUDE.md Lines | SessionStart Hook Load | Estimated Total |
|-------------|----------------|----------------------|----------------|
| ai-resources | 97 (root) + 95 (ai-resources) = 192 | ~60 lines (last session notes from root hook) | ~252 lines |
| global-macro-analysis | 97 (root) + 62 (global-macro) = 159 | ~60 lines (last session notes from root hook) | ~219 lines |
| buy-side-service-plan | 97 (root) + 157 (buy-side) = 254 | ~60 lines (checkpoint) + drift check + auto-sync | ~320 lines |
| nordic-pe | 97 (root) + 67 (nordic-pe) = 164 | ~30 lines (last session notes) | ~194 lines |
| nordic-pe/step-1 | 97 (root) + 67 (nordic-pe) + 30 (step-1) = 194 | ~30 lines (inherited from nordic-pe) | ~224 lines |
| workflows | 97 (root) + 23 (workflows) = 120 | ~60 lines (last session notes from root hook) | ~180 lines |

DELTA: +1 entry point (global-macro-analysis at ~219 lines). Root CLAUDE.md: 98 -> 97 lines (-1). ai-resources CLAUDE.md: 92 -> 95 lines (+3 uncommitted). buy-side CLAUDE.md: 146 -> 157 lines (+11 uncommitted). nordic-pe: 63 -> 67 lines (+4 uncommitted).

### 5.2 CLAUDE.md Sections Not Referenced by Operations

| Section | File | Lines | Referenced By |
|---------|------|-------|-------------|
| Design Judgment Principles | Root CLAUDE.md | ~11 | None found |
| Autonomy Rules | Root CLAUDE.md | ~10 | None found |
| Working Principles | Root CLAUDE.md | ~9 | None found |
| Delivery | Root CLAUDE.md | ~3 | None found |
| How I Work | ai-resources/CLAUDE.md | ~3 | None found |

These sections function as behavioral guidance loaded into every session.

DELTA: No change

### 5.3 CLAUDE.md Growth History

**ai-resources/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-11 | 95 |
| f284902 | 2026-04-11 | 94 |
| dc6fe4d | 2026-04-06 | 92 |
| 241dfb4 | 2026-04-06 | 92 |
| b5f497e | 2026-04-05 | 86 |
| f8da9aa | 2026-02-20 | 86 |

DELTA: +2 commits. f284902 (94 lines, same content as earlier commits at 94). Working tree has 1 uncommitted line (wrap-session reminder in Git Rules).

**buy-side-service-plan/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-11 | 157 |
| fe09197 | 2026-04-11 | 146 |
| 14f845d | 2026-04-05 | 146 |

DELTA: +11 uncommitted lines in working tree.

**global-macro-analysis/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| cab5304 | 2026-04-11 | 62 |

DELTA: NEW — first commit of this CLAUDE.md was 2026-04-11.

Section summary: 0 issues flagged / 4 deltas from previous audit

---

## Section 6: Drift & Staleness

### 6.1 Stale Files Still Referenced by Active Operations

Files not modified in the last 90 days (before 2026-01-11) that are still referenced:

| File | Last Commit Date | Referenced By |
|------|-----------------|--------------|
| ai-resources/skills/ai-resource-builder/references/examples.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/writing-standards.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/scripts/repo-audit.sh | 2026-02-20 | Manual execution |
| ai-resources/scripts/skill-inventory.sh | 2026-02-20 | Manual execution |
| ai-resources/.claude/hooks/pre-commit | 2026-02-20 | Git pre-commit |
| ai-resources/prompts/supplementary-research/*.md (5 files) | 2026-03-24 | Research workflow supplementary stage |

Note: `evaluation-framework.md` was updated 2026-04-09 (commit d7f5c60) and is no longer stale. CATALOG.md was updated 2026-04-06 and is no longer stale.

DELTA: -2 stale items. evaluation-framework.md updated 2026-04-09. CATALOG.md updated 2026-04-06. Both are now within the 90-day window.

### 6.2 TODO/FIXME/PLACEHOLDER Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| projects/buy-side-service-plan/context/style-guide.md | 3 | TODO | "TODO: Populate after your first content draft." |

Other occurrences are intentional: `workflow-evaluator/SKILL.md` line 312 uses "TODO" as a description of incomplete workflow states (not an action marker). Template {{PLACEHOLDER}} syntax in workflow templates is by design. Searched all files across workspace for: TODO, FIXME, PLACEHOLDER, HACK, XXX, STUB.

DELTA: No change

### 6.3 Empty or Stub Files

**Empty directory markers (.gitkeep):** 63 files across workspace (ai-resources + buy-side + nordic-pe + global-macro-analysis)

DELTA: +8 .gitkeep files (55 -> 63), primarily from global-macro-analysis project creation.

**Files with fewer than 5 lines of real content:**

| File | Lines | Content |
|------|-------|---------|
| ai-resources/.claude/settings.local.json | 0 | Empty file |
| projects/buy-side-service-plan/.claude/settings.local.json | 3 | Minimal local overrides |
| projects/buy-side-service-plan/report/chapters/1.3/1.3-module-00-methodology.md | 3 | Stub |
| projects/buy-side-service-plan/logs/execution-log.md | 1 | Empty |
| projects/buy-side-service-plan/context/style-guide.md | 3 | Header + TODO |
| projects/buy-side-service-plan/context/domain-knowledge.md | 3 | Header + placeholder |
| projects/nordic-pe/logs/decisions.md | 1 | Empty |
| projects/nordic-pe/logs/qc-log.md | 1 | Empty |
| projects/nordic-pe/logs/workflow-observations.md | 1 | Empty |
| projects/nordic-pe/reports/last-audit-commit.txt | 1 | Commit hash |
| projects/nordic-pe/step-1-long-list/input/fund-list.csv | 1 | Header row only |
| projects/global-macro-analysis/macro-kb/_meta/changelog.json | 1 | Empty array |
| projects/global-macro-analysis/macro-kb/_meta/index.json | 1 | Empty array |
| projects/global-macro-analysis/macro-kb/_meta/changelog.md | 3 | Header only |
| projects/global-macro-analysis/reports/.audit-temp/claude-md-findings.json | unknown | Stale temp file |
| projects/global-macro-analysis/reports/.audit-temp/file-org-findings.json | unknown | Stale temp file |
| workflows/reports/last-audit-commit.txt | 1 | Commit hash |

DELTA: +4 items (global-macro changelog.json, index.json, changelog.md, .audit-temp files)

Section summary: 9 items flagged / 4 deltas from previous audit (2 items resolved)
