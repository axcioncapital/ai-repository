# Repo Due Diligence Audit — 2026-04-06

Repo: Axcion AI Workspace (multi-repo)
Commits: ai-resources `241dfb4` | buy-side-service-plan `b2e8e4a` | nordic-pe `4be04a5`
Previous audit: 2026-04-06 (earlier run, commit `a17640c`)
Scope: Full workspace — ai-resources, projects/buy-side-service-plan, projects/nordic-pe-landscape-mapping-4-26, workflows, root .claude/

---

## Section 1: Inventory

### 1.1 Slash Commands

**ai-resources/.claude/commands/ (24 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | ai-resources/.claude/commands/ | skills/repo-health-analyzer/agents/ (8 agent files) |
| clarify.md | ai-resources/.claude/commands/ | None (inline prompt) |
| coach.md | ai-resources/.claude/commands/ | logs/session-notes.md, logs/coaching-log.md |
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

DELTA: +3 commands from previous audit (prime.md, repo-dd.md, triage.md)

**ai-resources/workflows/research-workflow/.claude/commands/ (23 commands)**

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

DELTA: -4 from previous audit (27 → 23). Previous audit counted 4 additional commands (content-production, gap-research, supplementary-research, enrichment) that are no longer present or were miscounted.

**Root workspace .claude/commands/ (8 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| audit-repo.md | .claude/commands/ | symlink → ai-resources/skills/repo-health-analyzer/command.md |
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
| audit-repo.md | workflows/.claude/commands/ | symlink → ai-resources/skills/repo-health-analyzer/command.md |

DELTA: No change

**Project commands (deployed instances):**
- buy-side-service-plan: 22 commands
- nordic-pe-landscape-mapping-4-26: 6 commands
- nordic-pe step-1-long-list: 1 command (triage.md)

### 1.2 Hooks

**6 settings.json files found across workspace:**

| Location | Trigger | Action | Script/Command Referenced |
|----------|---------|--------|--------------------------|
| Root .claude/settings.json | SessionStart | Load last session notes (60 lines) | Inline — reads `logs/session-notes.md` |
| Root .claude/settings.json | Stop | Remind about /wrap-session | Inline — checks `logs/session-notes.md` mtime |
| ai-resources/.claude/settings.json | Stop | Check innovation registry for untriaged items | Inline — reads `logs/innovation-registry.md` |
| research-workflow template settings.json | PreToolUse (Skill) | Auto-start friction log | `.claude/hooks/friction-log-auto.sh` |
| research-workflow template settings.json | PreToolUse (Edit) | Bright-line rule check on report prose | Inline — checks path pattern |
| research-workflow template settings.json | PostToolUse (Write) | Auto-commit stage artifacts | Inline — git add + commit |
| research-workflow template settings.json | PostToolUse (Write) | Check Claim ID coverage | `.claude/hooks/check-claim-ids.sh` |
| research-workflow template settings.json | PostToolUse (Write) | Log write activity | `.claude/hooks/log-write-activity.sh` |
| research-workflow template settings.json | PostToolUse (Write) | Detect innovation | `.claude/hooks/detect-innovation.sh` |
| research-workflow template settings.json | PostToolUse (Edit) | Log write activity + detect innovation | `.claude/hooks/log-write-activity.sh`, `.claude/hooks/detect-innovation.sh` |
| research-workflow template settings.json | SessionStart | Load checkpoint context + drift check | Inline + `ai-resources/.claude/hooks/check-template-drift.sh` |
| research-workflow template settings.json | Stop | Innovation triage reminder | Inline — checks `logs/innovation-registry.md` |
| research-workflow template settings.json | UserPromptSubmit | Supplementary research notification | Inline — checks execution/supplementary/ |
| buy-side-service-plan settings.json | PreToolUse (Edit) | Bright-line rule check | Inline |
| buy-side-service-plan settings.json | PreToolUse (Skill) | Friction log auto-start | `.claude/hooks/friction-log-auto.sh` |
| buy-side-service-plan settings.json | PostToolUse (Write) | Auto-commit + Claim ID + log + improve reminder + coach reminder | 5 hooks: inline auto-commit, `check-claim-ids.sh`, `log-write-activity.sh`, `improve-reminder.sh`, `coach-reminder.sh` |
| buy-side-service-plan settings.json | PostToolUse (Edit) | Log + detect innovation | `log-write-activity.sh`, `detect-innovation.sh` |
| buy-side-service-plan settings.json | SessionStart | Load checkpoint + drift check | Inline + `check-template-drift.sh` |
| buy-side-service-plan settings.json | Stop | Innovation triage reminder | Inline |
| buy-side-service-plan settings.json | UserPromptSubmit | Supplementary research notification | Inline |
| nordic-pe settings.json | PostToolUse (Write) | Auto-commit + log write | `auto-commit.sh`, `log-write-activity.sh` |
| nordic-pe settings.json | PostToolUse (Edit) | Log write | `log-write-activity.sh` |
| nordic-pe settings.json | SessionStart | Load last session notes (30 lines) | Inline — reads `logs/session-notes.md` |
| nordic-pe settings.json | Stop | Wrap session reminder | Inline |
| step-1-long-list settings.json | (none) | Permissions only (WebFetch, WebSearch) | N/A |

**3 settings.local.json files found** (ai-resources, buy-side, workflows). All empty or minimal — no hook overrides.

DELTA: No change

**Hook scripts on disk (16 total):**

| Script | Location | Called By |
|--------|----------|----------|
| check-template-drift.sh | ai-resources/.claude/hooks/ | SessionStart (research-workflow, buy-side) |
| detect-innovation.sh | ai-resources/.claude/hooks/ | PostToolUse (buy-side Edit) |
| pre-commit | ai-resources/.claude/hooks/ | Git pre-commit |
| check-claim-ids.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write) |
| detect-innovation.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PreToolUse (Skill) |
| log-write-activity.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | PostToolUse (Write/Edit) |
| check-claim-ids.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write) |
| coach-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write) |
| detect-innovation.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Edit) |
| friction-log-auto.sh | projects/buy-side-service-plan/.claude/hooks/ | PreToolUse (Skill) |
| improve-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write) |
| log-write-activity.sh | projects/buy-side-service-plan/.claude/hooks/ | PostToolUse (Write/Edit) |
| auto-commit.sh | projects/nordic-pe/.claude/hooks/ | PostToolUse (Write) |
| log-write-activity.sh | projects/nordic-pe/.claude/hooks/ | PostToolUse (Write/Edit) |
| friction-log-auto.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (untracked template) |

DELTA: -2 from previous audit (18 → 16). Previous audit counted `log-write-activity.sh` in `workflows/active/research-workflow/project-template/` (still exists, now 16th entry) and an additional script that may have been consolidated.

### 1.3 Template Files

| Path | Used By | Last Commit Date |
|------|---------|-----------------|
| ai-resources/skills/answer-spec-generator/references/component-templates.md | answer-spec-generator skill | Pre-2026-01-06 |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | execution-manifest-creator skill | Pre-2026-01-06 |
| ai-resources/skills/research-extract-creator/references/extract-template.md | research-extract-creator skill | Pre-2026-01-06 |
| ai-resources/workflows/research-workflow/CLAUDE.md | /deploy-workflow command (contains {{PLACEHOLDERS}}) | 2026-04-03 |
| ai-resources/workflows/research-workflow/SETUP.md | /deploy-workflow command (deployment checklist) | 2026-04-03 |
| ai-resources/workflows/research-workflow/ (entire directory) | /deploy-workflow — copies as project template | 2026-04-03 |

`templates/workflow-need.md` is referenced by `/document-workflow` and `/new-workflow` commands but does not exist on disk. Checked git history — no record of this file ever existing.

DELTA: No change

### 1.4 Scripts

| Path | Purpose | Called By |
|------|---------|----------|
| ai-resources/scripts/repo-audit.sh | Shell-based repo health audit | Manual execution |
| ai-resources/scripts/skill-inventory.sh | Lists skills with metadata | Manual execution |

All other .sh files are hook scripts (listed in 1.2).

DELTA: No change

### 1.5 Skills

60 skill directories in `ai-resources/skills/` (excluding CATALOG.md). All 60 have a SKILL.md file. None are missing SKILL.md.

1 additional project-specific skill: `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner/SKILL.md`

DELTA: No change

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
| ai-resources/reports/repo-health-report.md | Generated health report |
| ai-resources/skills/CATALOG.md | Curated skill index |
| ai-resources/docs/session-rituals.md | Session ritual documentation |
| ai-resources/inbox/repo-review-brief.md | Incoming review brief |
| workflows/processes/create-new-workflow.md | Workflow creation process doc |
| workflows/processes/document-existing-process.md | Workflow documentation process doc |
| workflows/processes/improve-existing-workflow.md | Workflow improvement process doc |
| workflows/reports/repo-health-report.md | Generated health report |
| workflows/active/research-workflow/project-template/ | Untracked template in development |

DELTA: +2 items (docs/session-rituals.md, inbox/repo-review-brief.md). -1 item (tests/.gitkeep removed by audit remediation commit `241dfb4`).

### 1.7 Symlinks

| Symlink Path | Target | Target Exists |
|-------------|--------|--------------|
| (root)/skills | ai-resources/skills | Y |
| (root)/.claude/commands/audit-repo.md | ai-resources/skills/repo-health-analyzer/command.md | Y |
| workflows/.claude/commands/audit-repo.md | ../../../ai-resources/skills/repo-health-analyzer/command.md | Y |
| projects/buy-side-service-plan/reference/skills/analysis-pass-memo-review | ai-resources/skills/analysis-pass-memo-review | Y |
| projects/buy-side-service-plan/reference/skills/answer-spec-generator | ai-resources/skills/answer-spec-generator | Y |
| projects/buy-side-service-plan/reference/skills/answer-spec-qc | ai-resources/skills/answer-spec-qc | Y |
| projects/buy-side-service-plan/reference/skills/chapter-prose-reviewer | ai-resources/skills/chapter-prose-reviewer | Y |
| projects/buy-side-service-plan/reference/skills/citation-converter | ai-resources/skills/citation-converter | Y |
| projects/buy-side-service-plan/reference/skills/cluster-analysis-pass | ai-resources/skills/cluster-analysis-pass | Y |
| projects/buy-side-service-plan/reference/skills/cluster-memo-refiner | ai-resources/skills/cluster-memo-refiner | Y |
| projects/buy-side-service-plan/reference/skills/cluster-synthesis-drafter | ai-resources/skills/cluster-synthesis-drafter | Y |
| projects/buy-side-service-plan/reference/skills/context-pack-builder | ai-resources/skills/context-pack-builder | Y |
| projects/buy-side-service-plan/reference/skills/document-integration-qc | ai-resources/skills/document-integration-qc | Y |
| projects/buy-side-service-plan/reference/skills/evidence-prose-fixer | ai-resources/skills/evidence-prose-fixer | Y |
| projects/buy-side-service-plan/reference/skills/evidence-spec-verifier | ai-resources/skills/evidence-spec-verifier | Y |
| projects/buy-side-service-plan/reference/skills/evidence-to-report-writer | ai-resources/skills/evidence-to-report-writer | Y |
| projects/buy-side-service-plan/reference/skills/gap-assessment-gate | ai-resources/skills/gap-assessment-gate | Y |
| projects/buy-side-service-plan/reference/skills/knowledge-file-completeness-qc | ai-resources/skills/knowledge-file-completeness-qc | Y |
| projects/buy-side-service-plan/reference/skills/knowledge-file-producer | ../../../../ai-resources/skills/knowledge-file-producer | Y |
| projects/buy-side-service-plan/reference/skills/repo-health-analyzer | ai-resources/skills/repo-health-analyzer | Y |
| projects/buy-side-service-plan/reference/skills/research-plan-creator | ai-resources/skills/research-plan-creator | Y |
| projects/buy-side-service-plan/reference/skills/research-structure-creator | ai-resources/skills/research-structure-creator | Y |
| projects/buy-side-service-plan/reference/skills/section-directive-drafter | ai-resources/skills/section-directive-drafter | Y |
| projects/buy-side-service-plan/reference/skills/task-plan-creator | ai-resources/skills/task-plan-creator | Y |
| projects/nordic-pe/.claude/commands/session-guide.md | ../../../../ai-resources/.claude/commands/session-guide.md | Y |
| projects/nordic-pe/reference/skills/repo-health-analyzer | ../../../../ai-resources/skills/repo-health-analyzer | Y |

26 symlinks total. All targets exist and are accessible.

DELTA: +1 from previous audit (25 → 26). Exact source of discrepancy unclear — likely a symlink was added or one was miscounted previously.

### 1.8 Agent Definitions

| Location | Count | Files |
|----------|-------|-------|
| ai-resources/.claude/agents/ | 15 | collaboration-coach.md, execution-agent.md, improvement-analyst.md, pipeline-stage-2.md, pipeline-stage-2-5.md, pipeline-stage-3a.md, pipeline-stage-3b.md, pipeline-stage-3c.md, pipeline-stage-4.md, pipeline-stage-5.md, qc-reviewer.md, refinement-reviewer.md, repo-dd-auditor.md, session-guide-generator.md, triage-reviewer.md |
| ai-resources/workflows/research-workflow/.claude/agents/ | 4 | execution-agent.md, improvement-analyst.md, qc-gate.md, verification-agent.md |
| projects/buy-side-service-plan/.claude/agents/ | 7 | qc-gate.md, qc-reviewer.md, research-synthesizer.md, section-drafter.md, service-designer.md, strategic-critic.md, verification-agent.md |
| projects/nordic-pe/.claude/agents/ | 1 | qc-gate.md |
| root .claude/agents/ | 1 | output-validator.md |
| root .claude/agents/auditors/ | 6 | claude-md-auditor.md, command-auditor.md, file-org-auditor.md, practices-auditor.md, settings-auditor.md, skill-auditor.md (all symlinks to ai-resources) |

DELTA: NEW QUESTION — not tracked in previous audit. 34 agent definitions total across workspace.

Section summary: 152 items catalogued / 8 deltas from previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Files

| File | Lines | Sections | Section Headings |
|------|-------|----------|-----------------|
| (root)/CLAUDE.md | 98 | 13 | Axcion AI Workspace, What This Workspace Is For, Projects, Axcíon's Tool Ecosystem, Skill Library, AI Resource Creation Rules, Design Judgment Principles, QC Independence Rule, Completion Standard, Working Principles, Autonomy Rules, File verification and git commits, Delivery |
| ai-resources/CLAUDE.md | 92 | 9 | Axcion AI Resource Repository, What This Repo Contains, How I Work, Skill Format Standard, Model Preference, Development Workflow, Creation, Improvement, Quality Check, General Session Rules, Cross-References, Git Rules |
| workflows/CLAUDE.md | 23 | 3 | Workflow Development Workspace, Directory Structure, Relationship to ai-resources |
| ai-resources/workflows/research-workflow/CLAUDE.md | ~120 | Template with {{PLACEHOLDERS}} — not a live CLAUDE.md |
| projects/buy-side-service-plan/CLAUDE.md | 146 | 12 | (project-specific sections including Workflow Overview, Cross-Model Rules, Bright-Line Rule, Strategic Evaluation) |
| projects/nordic-pe/CLAUDE.md | 63 | 8 | (project-specific sections) |
| projects/nordic-pe/step-1-long-list/CLAUDE.md | 30 | 4 | (step-specific sections) |

DELTA: ai-resources/CLAUDE.md grew from 86 → 92 lines (+6 lines, commit `241dfb4` added docs/ and reports/ to "What This Repo Contains" section).

### 2.2 Dead References

| CLAUDE.md File | Referenced Item | Status | Git History |
|---------------|----------------|--------|-------------|
| (root)/CLAUDE.md | `templates/workflow-need.md` (via /document-workflow and /new-workflow commands) | Does not exist | No record found — never committed |
| (root)/CLAUDE.md | `skills` symlink described as convenience shortcut | Exists but unused — no command, hook, or script references it | N/A |

All other file references verified as existing. Checked: all skill paths, reference paths, command paths, hook script paths, and process documentation paths across all 7 CLAUDE.md files.

DELTA: No change from previous audit

### 2.3 Contradictions

**Contradiction 1: Skill ownership vs. actual practice**

Root CLAUDE.md line 35: "Do not create AI resources in project workspaces. Skills, commands, and agent definitions belong in `ai-resources/`."

Root CLAUDE.md line 27: "Project workspaces reference skills via copy or symlink — they do not own them."

Actual state: `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner/SKILL.md` is a project-owned skill not present in `ai-resources/skills/`.

No other contradictions found — checked all 7 CLAUDE.md files for conflicting statements.

DELTA: -1 contradiction resolved. Previous audit flagged report-compliance-qc copy divergence as Contradiction 2. Commit `241dfb4` synced the canonical version with the copies — all three instances are now identical.

### 2.4 Conventions Not Followed

| Convention | Source | Violation |
|-----------|--------|-----------|
| Commit message format: `new:`, `update:`, `fix:`, `batch:` | ai-resources/CLAUDE.md line 82 | buy-side auto-commit hook uses `Auto-commit [stage]: filename` format instead |
| Skills belong in ai-resources | Root CLAUDE.md line 35 | fund-triage-scanner exists only in project workspace |

Conventions verified as followed:
- Skill folder naming (lowercase, hyphenated) — all 60 skills comply
- SKILL.md file naming — all 60 skills have exactly `SKILL.md`
- YAML frontmatter with `name` and `description` — all 60 skills comply
- No auxiliary files in skill directories — none found
- Body under 500 lines — all comply (max: answer-spec-generator at 485)

DELTA: -1 violation resolved. report-compliance-qc copy divergence fixed by commit `241dfb4`.

### 2.5 Partial Feature References

| Feature | What Exists | What's Missing |
|---------|------------|----------------|
| /document-workflow command | Command file at root .claude/commands/document-workflow.md; process doc at workflows/processes/document-existing-process.md | `templates/workflow-need.md` referenced by command |
| /new-workflow command | Command file at root .claude/commands/new-workflow.md; process doc at workflows/processes/create-new-workflow.md | `templates/workflow-need.md` referenced by command |

None found beyond these — checked all commands against their referenced files.

DELTA: No change

Section summary: 4 issues flagged / 2 deltas from previous audit (2 issues resolved)

---

## Section 3: Dependency References

### 3.1 Command-to-File Reference Map

See Section 1.1 for full mapping. Verification summary:

| Result | Count |
|--------|-------|
| All referenced files exist | 57 commands |
| Referenced file missing | 2 commands (/document-workflow, /new-workflow — both reference `templates/workflow-need.md` which does not exist) |
| References are dynamic (created at runtime) | ~8 commands (logs, session notes, checkpoints) |

DELTA: +3 commands verified (prime, repo-dd, triage — all references resolve)

### 3.2 Command Chains

**Research Workflow Pipeline (sequential, multi-session):**

```
/run-preparation → /run-execution → /run-cluster → /run-analysis → /run-synthesis → /run-report → /verify-chapter → /produce-knowledge-file
```

Stage outputs become next stage inputs:
- `/run-preparation` outputs → `preparation/task-plans/`, `preparation/research-plans/`, `preparation/answer-specs/`
- `/run-execution` reads preparation outputs → writes `execution/manifest/`, `execution/research-prompts/`, `execution/raw-reports/`, `execution/research-extracts/`
- `/run-cluster` reads execution extracts → writes `analysis/cluster-memos/`
- `/run-analysis` reads cluster memos → writes `analysis/section-directives/`
- `/run-synthesis` reads cluster memos + directives → writes `analysis/chapters/`
- `/run-report` reads analysis chapters → writes `report/chapters/`
- `/verify-chapter` reads report chapters → writes verification results to `logs/qc-log.md`
- `/produce-knowledge-file` reads report chapters → writes `output/knowledge-files/`

**Skill Management Pipeline:**
```
/request-skill → /create-skill (or /improve-skill, /migrate-skill)
```

**Project Setup Pipeline:**
```
/new-project → pipeline-stage-2 → pipeline-stage-2-5 → pipeline-stage-3a → pipeline-stage-3b → pipeline-stage-3c → pipeline-stage-4 → pipeline-stage-5 → /session-guide
```

**Session Lifecycle:**
```
/prime (start) → [work] → /wrap-session (end)
```

**Audit Pipeline:**
```
/repo-dd (factual) → /repo-dd deep (+ operational assessment) → /repo-dd full (+ pipeline testing)
```

DELTA: +1 chain (Audit Pipeline via new /repo-dd command)

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
| reference/stage-instructions.md | /audit-structure, /workflow-status |
| reference/file-conventions.md | /audit-structure |
| execution/research-extracts/ | /run-cluster, /run-analysis |
| analysis/cluster-memos/ | /run-cluster, /run-analysis, /run-synthesis, /review |
| analysis/section-directives/ | /run-synthesis, /review |
| report/chapters/ | /run-report, /verify-chapter, /review, /produce-knowledge-file |

DELTA: /prime and /repo-dd added to multiple reference lists (both are new commands)

### 3.4 Files Ranked by Downstream References (Top 10)

| Rank | File | Reference Count | Referenced By |
|------|------|----------------|--------------|
| 1 | logs/session-notes.md | 10 | /wrap-session, /prime, /coach, /usage-analysis, /repo-dd, SessionStart ×3, Stop ×2 |
| 2 | logs/innovation-registry.md | 6 | /wrap-session, /prime, /graduate-resource, /repo-dd, Stop hooks ×3 |
| 3 | CLAUDE.md (per repo) | 6 | /update-claude-md, /sync-workflow, /improve, /workflow-status, SessionStart hooks, /wrap-session |
| 4 | logs/friction-log.md | 4 | /friction-log, /improve, /wrap-session, /repo-dd |
| 5 | logs/decisions.md | 4 | /prime, /wrap-session, /repo-dd, /wrap-session (root) |
| 6 | report/chapters/ (directory) | 4 | /run-report, /verify-chapter, /review, /produce-knowledge-file |
| 7 | analysis/cluster-memos/ (directory) | 4 | /run-cluster, /run-analysis, /run-synthesis, /review |
| 8 | skills/ai-resource-builder/SKILL.md | 3 | /create-skill, /improve-skill, /migrate-skill |
| 9 | skills/ai-resource-builder/references/evaluation-framework.md | 2 | /create-skill, /improve-skill |
| 10 | .claude/settings.json | 2 | /deploy-workflow, /sync-workflow |

DELTA: session-notes.md: 9 → 10 refs (+/repo-dd). innovation-registry.md: 5 → 6 refs (+/prime, +/repo-dd). friction-log.md: 3 → 4 refs (+/repo-dd). decisions.md: promoted into top 10 (+/prime, +/repo-dd).

Section summary: 0 issues flagged / 4 deltas from previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

Standard pattern (all 60 skills): folder with SKILL.md containing YAML frontmatter (`name`, `description`), optional `references/` subdirectory.

| Check | Result |
|-------|--------|
| All have SKILL.md | Yes (60/60) |
| All have YAML frontmatter | Yes (60/60) |
| All have `name` field | Yes (60/60) |
| All have `description` field | Yes (60/60) |
| Skills with references/ | 8 of 60 |
| Skills with scripts/ | 0 of 60 |
| Skills with assets/ | 0 of 60 |
| Skills with unexpected subdirectories | 0 of 60 |

No deviations found — checked all 60 skill directories.

DELTA: No change

### 4.2 Slash Command Definition Pattern

Commands are markdown files in `.claude/commands/` directories. No standard template enforced — commands vary in structure from single-line prompts (clarify.md, qc-pass.md) to multi-section procedural documents (create-skill.md, run-report.md).

| Pattern Variant | Count | Examples |
|----------------|-------|---------|
| Inline prompt (< 10 lines) | 6 | clarify.md, qc-pass.md, refinement-pass.md, scope.md, note.md, triage.md |
| Procedural with skill references | 12 | run-preparation.md, run-execution.md, create-skill.md |
| Agent delegation | 3 | new-project.md, session-guide.md, audit-repo.md |
| Utility/logging | 6 | wrap-session.md, friction-log.md, usage-analysis.md |
| Multi-step pipeline | 1 | repo-dd.md |
| Session orientation | 1 | prime.md |

DELTA: +2 pattern variants (multi-step pipeline for repo-dd.md, session orientation for prime.md)

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via the `/create-skill` command which references `skills/ai-resource-builder/SKILL.md` for format standards and `skills/ai-resource-builder/references/evaluation-framework.md` for quality criteria. These are procedural instructions, not structural templates.

DELTA: No change

### 4.4 Naming Convention Inconsistencies

| Check | Result |
|-------|--------|
| Skill folders: lowercase, hyphenated | All 60 comply |
| Command files: lowercase, hyphenated .md | All comply |
| Agent files: lowercase, hyphenated .md | All comply |
| Hook scripts: lowercase, hyphenated .sh | All comply except `pre-commit` (no .sh extension — standard git convention) |

One mixed pattern in symlinks: 21 of 23 project skill symlinks use absolute paths (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/skills/...`). 2 use relative paths (`../../../../ai-resources/skills/...`). Both work but the convention is inconsistent.

DELTA: No change

### 4.5 Directory Structure Violations

Standard directory structure per CLAUDE.md: `skills/`, `workflows/`, `.claude/commands/`, `.claude/agents/`, `.claude/hooks/`, `inbox/`, `logs/`, `scripts/`.

| Violation | Location |
|-----------|----------|
| `prompts/` directory exists at ai-resources root | Not defined in any CLAUDE.md as a standard directory. Contains 5 supplementary research prompt files. |
| `reports/` directory exists at ai-resources root | Documented in CLAUDE.md as of commit `241dfb4`. Contains repo-health-report.md. |
| `docs/` directory exists at ai-resources root | Documented in CLAUDE.md as of commit `241dfb4`. Contains session-rituals.md. |

DELTA: -1 violation. `tests/` directory removed by commit `241dfb4`. `reports/` and `docs/` now documented in CLAUDE.md (reduced from violations to documented directories). `prompts/` remains undocumented.

### 4.6 Command Syntax and Path Resolution

| Check | Pass | Fail |
|-------|------|------|
| Command files parseable as markdown | 60 | 0 |
| Referenced file paths resolve | 58 | 2 |

Failed path resolution:
- `/document-workflow` references `templates/workflow-need.md` — does not exist
- `/new-workflow` references `templates/workflow-need.md` — does not exist

DELTA: +3 commands verified (prime, repo-dd, triage — all pass)

### 4.7 Duplicate or Built-in Command Names

Commands with the same name at multiple levels:

| Name | Locations |
|------|-----------|
| audit-repo | ai-resources, research-workflow template, root (symlink), workflows (symlink) |
| wrap-session | ai-resources, research-workflow template, root |
| update-claude-md | ai-resources, research-workflow template |
| friction-log | ai-resources, research-workflow template |
| improve | ai-resources, research-workflow template |
| note | ai-resources, research-workflow template |
| usage-analysis | ai-resources, research-workflow template |
| status | research-workflow template, root |
| prime | ai-resources, research-workflow template |

No command names conflict with built-in Claude Code commands — checked against: /help, /clear, /compact, /cost, /doctor, /init, /login, /logout, /memory, /model, /permissions, /review, /terminal-setup, /vim, /fast.

Note: `/review` exists as a workflow command and as a built-in Claude Code command. The custom command takes precedence when defined in a project's `.claude/commands/`.

DELTA: +1 duplicate name (prime now exists in both ai-resources and research-workflow template)

Section summary: 3 issues flagged / 4 deltas from previous audit (2 issues resolved)

---

## Section 5: Context Load

### 5.1 Context Loaded Per Session

| Entry Point | CLAUDE.md Lines | SessionStart Hook Load | Estimated Total |
|-------------|----------------|----------------------|----------------|
| ai-resources | 98 (root) + 92 (ai-resources) = 190 | ~60 lines (last session notes from root hook) | ~250 lines |
| buy-side-service-plan | 98 (root) + 146 (buy-side) = 244 | ~60 lines (checkpoint) + drift check output | ~310 lines |
| nordic-pe | 98 (root) + 63 (nordic-pe) = 161 | ~30 lines (last session notes) | ~191 lines |
| nordic-pe/step-1 | 98 (root) + 63 (nordic-pe) + 30 (step-1) = 191 | ~30 lines (inherited from nordic-pe) | ~221 lines |
| workflows | 98 (root) + 23 (workflows) = 121 | ~60 lines (last session notes from root hook) | ~181 lines |

Note: Memory files at `~/.claude/projects/*/memory/` also load but are user-level, not repo-level.

DELTA: ai-resources CLAUDE.md grew 86 → 92 lines. Total context for ai-resources entry point: ~244 → ~250 lines (+6).

### 5.2 CLAUDE.md Sections Not Referenced by Operations

| Section | File | Lines | Referenced By |
|---------|------|-------|-------------|
| Design Judgment Principles | Root CLAUDE.md | ~11 | None found — checked all commands, hooks, and agents |
| Autonomy Rules | Root CLAUDE.md | ~10 | None found |
| Working Principles | Root CLAUDE.md | ~9 | None found |
| Delivery | Root CLAUDE.md | ~3 | None found |
| How I Work | ai-resources/CLAUDE.md | ~3 | None found |

These sections function as behavioral guidance loaded into every session. They are not operationally referenced but influence Claude's behavior through context.

DELTA: No change

### 5.3 CLAUDE.md Growth History

**ai-resources/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| 241dfb4 | 2026-04-06 | 92 |
| b5f497e | 2026-04-05 | 86 |
| f8da9aa | 2026-02-20 | 86 |
| c767d81 | 2026-02-20 | 82 |
| 675a96c | 2026-02-18 | 72 |

DELTA: +1 commit (241dfb4, +6 lines documenting docs/ and reports/ directories)

**buy-side-service-plan/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| 14f845d | 2026-04-05 | 146 |
| 1a07fcb | 2026-04-04 | 142 |
| 40cfb4c | 2026-04-04 | 140 |
| 698ff9f | 2026-04-04 | 128 |
| 639f499 | 2026-04-04 | 121 |

DELTA: No change

**nordic-pe/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| fc833e8 | 2026-04-02 | 63 |
| 37ee677 | 2026-04-02 | 32 |

DELTA: No change

**workflows/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| a96feec | 2026-04-03 | 23 |

DELTA: No change

Section summary: 0 issues flagged / 2 deltas from previous audit

---

## Section 6: Drift & Staleness

### 6.1 Stale Files Still Referenced by Active Operations

Files not modified in the last 90 days (before 2026-01-06) that are still referenced:

| File | Last Commit Date | Referenced By |
|------|-----------------|--------------|
| ai-resources/skills/ai-resource-builder/references/evaluation-framework.md | Pre-2026-01-06 | /create-skill, /improve-skill |
| ai-resources/skills/ai-resource-builder/references/examples.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/writing-standards.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/scripts/repo-audit.sh | Pre-2026-01-06 | Manual execution |
| ai-resources/scripts/skill-inventory.sh | Pre-2026-01-06 | Manual execution |
| ai-resources/.claude/hooks/pre-commit | Pre-2026-01-06 | Git pre-commit |
| ai-resources/skills/CATALOG.md | Pre-2026-01-06 | Referenced as skill index |
| ai-resources/prompts/supplementary-research/*.md (5 files) | Pre-2026-01-06 | Research workflow supplementary stage |

Note: `evaluation-framework.md` and `writing-standards.md` have uncommitted modifications in the working tree (git status shows them as modified but unstaged). Their last *committed* state is pre-2026-01-06.

DELTA: No change

### 6.2 TODO/FIXME/PLACEHOLDER Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| projects/buy-side-service-plan/context/style-guide.md | 3 | TODO | "TODO: Populate after your first content draft." |

All other occurrences are intentional template syntax (`{{PLACEHOLDER}}`) in workflow template files or documentation references. Searched all files across workspace for: TODO, FIXME, PLACEHOLDER, HACK, XXX, STUB.

DELTA: No change

### 6.3 Empty or Stub Files

**Empty directory markers (.gitkeep only):**
- ai-resources: 27 files (previously 28 — `tests/.gitkeep` removed by commit `241dfb4`)
- buy-side-service-plan: 27 files
- nordic-pe: 1 file
- Total: 55 .gitkeep files

DELTA: -1 .gitkeep file (tests/.gitkeep removed)

**Files with fewer than 5 lines of real content:**

| File | Lines | Content |
|------|-------|---------|
| ai-resources/.claude/settings.local.json | 1 | Empty object `{}` |
| ai-resources/workflows/research-workflow/.gitignore | 1 | Single ignore rule |
| ai-resources/workflows/research-workflow/logs/innovation-registry.md | 3 | Table header only |
| projects/buy-side-service-plan/.claude/settings.local.json | 3 | Minimal local overrides |
| projects/buy-side-service-plan/.gitignore | 2 | Two ignore rules |
| projects/buy-side-service-plan/context/domain-knowledge.md | 3 | Header + placeholder text |
| projects/buy-side-service-plan/context/style-guide.md | 3 | Header + TODO marker |
| projects/buy-side-service-plan/logs/execution-log.md | 1 | Empty |
| projects/buy-side-service-plan/report/chapters/1.3/1.3-module-00-methodology.md | 2 | Stub |
| projects/nordic-pe/.gitignore | 2 | Two ignore rules |
| projects/nordic-pe/logs/decisions.md | 1 | Empty |
| projects/nordic-pe/logs/qc-log.md | 1 | Empty |
| projects/nordic-pe/logs/workflow-observations.md | 1 | Empty |
| projects/nordic-pe/pipeline/decisions.md | 3 | Header only |
| projects/nordic-pe/reports/last-audit-commit.txt | 1 | Commit hash |
| projects/nordic-pe/step-1-long-list/input/fund-list.csv | 1 | Header row only |
| workflows/reports/last-audit-commit.txt | 1 | Commit hash |
| ai-resources/inbox/.gitkeep | 0 | Empty |

DELTA: -1 item (tests/.gitkeep removed). Total stub files: 18 (was 19).

Section summary: 10 items flagged / 2 deltas from previous audit (1 item resolved)
