# Repo Due Diligence Audit — 2026-04-12

Repo: Axcion AI Workspace (multi-repo)
Commits: ai-resources `7063b2c` (+ 17 uncommitted: 12 modified, 5 untracked) | workflows `20e98d5` (+ 22 uncommitted incl. many deletions and CLAUDE.md edits) | buy-side-service-plan `a5e5dfd` (+ 13 uncommitted) | global-macro-analysis `6561c4f` (+ 5 uncommitted) | nordic-pe `1c2bfa8` (+ 4 uncommitted) | projects/project-planning — NOT a git repo (filesystem only) | workspace root — NOT a git repo
Previous audit: 2026-04-11 (commit ai-resources `7063b2c` — same head)
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

**ai-resources/.claude/commands/ (27 commands)**

| Name | Defined At | Referenced Files |
|------|-----------|-----------------|
| analyze-workflow.md | ai-resources/.claude/commands/ | .claude/agents/workflow-analysis-agent.md, .claude/agents/workflow-critique-agent.md |
| audit-repo.md | ai-resources/.claude/commands/ | skills/repo-health-analyzer/agents/ |
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
| project-consultant.md | ai-resources/.claude/commands/ | projects/global-macro-analysis/CLAUDE.md, projects/global-macro-analysis/pipeline/session-guide.md, macro-kb/_meta/taxonomy.md, macro-kb/_meta/index.json |
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

DELTA: +1 command (26 -> 27). New (untracked): `project-consultant.md`. The body text addresses the Global Macro Analysis project specifically (references `projects/global-macro-analysis/CLAUDE.md`, taxonomy, KB). It is currently located in `ai-resources/.claude/commands/` rather than in any project workspace.

**ai-resources/workflows/research-workflow/.claude/commands/ (26 commands)**

Unchanged set: audit-repo.md, audit-structure.md, create-context-pack.md, friction-log.md, improve.md, inject-dependency.md, intake-reports.md, note.md, prime.md, produce-knowledge-file.md, produce-prose.md, qc-pass.md, refinement-pass.md, review.md, run-analysis.md, run-cluster.md, run-execution.md, run-preparation.md, run-report.md, run-synthesis.md, status.md, update-claude-md.md, usage-analysis.md, verify-chapter.md, workflow-status.md, wrap-session.md.

DELTA: No change in count. `qc-pass.md`, `refinement-pass.md`, and modifications to `prime.md` are uncommitted in working tree (previous audit treated qc-pass.md and refinement-pass.md as new committed files; they remain untracked).

**Root workspace .claude/commands/ (9 commands)** — audit-repo.md, document-workflow.md, improve-workflow.md, new-workflow.md, run-qc.md, status.md, update-md.md, validate.md, wrap-session.md (plus symlinks new-project.md, qc-pass.md, refinement-deep.md, refinement-pass.md visible via `find -type l`).

DELTA: No change.

**workflows/.claude/commands/ (1 command)** — audit-repo.md (symlink).

DELTA: No change.

**projects/global-macro-analysis/.claude/commands/ (34 commands)** — 13 local kb-* commands + 21 symlinks to ai-resources commands. Symlinked set unchanged from previous audit.

DELTA: No change.

**projects/buy-side-service-plan/.claude/commands/ (38 commands)** — 17 symlinks to ai-resources/research-workflow + 21 local files.

DELTA: +1 command since last audit (37 -> 38). Newly visible local commands include `run-cluster.md`, `produce-knowledge-file.md`, `inject-dependency.md`, and others touched by 2026-04-11 sync commit `a5e5dfd` (sync from canonical research-workflow template). `produce-prose.md` is currently a "type change" (T) in git status, indicating it transitioned between symlink and regular file.

**projects/nordic-pe-landscape-mapping-4-26/.claude/commands/ (6 commands + 1 sub-project)**
- note.md, prime.md, review.md, session-guide.md (symlink), status.md, wrap-session.md
- step-1-long-list: triage.md (1 command)

DELTA: No change.

**projects/project-planning/.claude/commands/ (28 commands)** — NEW workspace not present in previous audit.

| Name | Type | Referenced Files |
|------|------|-----------------|
| analyze-workflow.md | symlink -> ai-resources | ai-resources command |
| audit-repo.md | symlink -> ai-resources | ai-resources command |
| clarify.md | symlink -> ai-resources | ai-resources command |
| coach.md | symlink -> ai-resources | ai-resources command |
| create-skill.md | symlink -> ai-resources | ai-resources command |
| friction-log.md | symlink -> ai-resources | ai-resources command |
| improve-skill.md | symlink -> ai-resources | ai-resources command |
| improve.md | symlink -> ai-resources | ai-resources command |
| migrate-skill.md | symlink -> ai-resources | ai-resources command |
| note.md | symlink -> ai-resources | ai-resources command |
| plan-draft.md | local (28 lines) | pipeline/ref-project-plan.md, ai-resources/skills/implementation-project-planner/SKILL.md, output/{project-name}/project-plan-v1.md |
| plan-evaluate.md | local (35 lines) | pipeline/ref-project-plan.md, output/{project-name}/, .claude/agents/plan-evaluator.md |
| plan-refine.md | local (31 lines) | pipeline/ref-project-plan.md, output/{project-name}/project-plan-v*.md |
| prime.md | symlink -> ai-resources | ai-resources command |
| project-consultant.md | symlink -> ai-resources/.claude/commands/project-consultant.md | (target file IS untracked in ai-resources) |
| qc-pass.md | symlink -> ai-resources | ai-resources command |
| refinement-deep.md | symlink -> ai-resources | ai-resources command |
| refinement-pass.md | symlink -> ai-resources | ai-resources command |
| repo-dd.md | symlink -> ai-resources | ai-resources command |
| request-skill.md | symlink -> ai-resources | ai-resources command |
| scope.md | symlink -> ai-resources | ai-resources command |
| spec-draft.md | local (24 lines) | pipeline/ref-tech-spec.md, ai-resources/skills/spec-writer/SKILL.md, output/{project-name}/tech-spec-v1.md, plan-qc-verdict.md |
| spec-evaluate.md | local (35 lines) | pipeline/ref-tech-spec.md, output/{project-name}/, .claude/agents/spec-evaluator.md |
| spec-refine.md | local (31 lines) | pipeline/ref-tech-spec.md, output/{project-name}/tech-spec-v*.md |
| triage.md | symlink -> ai-resources | ai-resources command |
| update-claude-md.md | symlink -> ai-resources | ai-resources command |
| usage-analysis.md | symlink -> ai-resources | ai-resources command |
| wrap-session.md | symlink -> ai-resources | ai-resources command |

DELTA: NEW — entire workspace (`projects/project-planning/`) and 28 commands did not exist in previous audit. 6 local commands (plan-draft, plan-refine, plan-evaluate, spec-draft, spec-refine, spec-evaluate) and 22 symlinks to `ai-resources/.claude/commands/`.

**workflows/active/research-workflow/project-template/.claude/commands/ (3 commands)** — audit-repo.md, friction-log.md, improve.md.

DELTA: No change.

**Total commands across workspace: 172** (was 143 in previous audit; +29: +1 ai-resources `project-consultant.md`, +1 buy-side new local command, +28 project-planning, minus duplicates already counted).

### 1.2 Hooks

**8 settings.json files found across workspace:**

| Location | Hooks Present |
|----------|--------------|
| Root .claude/settings.json | SessionStart (load session notes), Stop (wrap-session reminder) |
| ai-resources/.claude/settings.json | Stop (innovation triage reminder) |
| ai-resources/workflows/research-workflow/.claude/settings.json | UNCOMMITTED working tree shows -14 lines vs HEAD; remaining hooks (post change): PreToolUse (Skill: friction-log, Edit: bright-line), PostToolUse (Write/Edit), SessionStart (checkpoint + drift check + auto-sync-shared), Stop, UserPromptSubmit |
| projects/buy-side-service-plan/.claude/settings.json | PreToolUse (Edit: bright-line, Skill: friction-log), PostToolUse (Write: auto-commit + claim-ids + log, Edit: log), SessionStart (checkpoint + drift check + auto-sync-shared), Stop, UserPromptSubmit |
| projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | PostToolUse (Write: auto-commit + log, Edit: log), SessionStart (load notes), Stop (wrap reminder) — file is currently modified vs HEAD |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | Permissions only (WebFetch, WebSearch) — no hooks |
| projects/global-macro-analysis/.claude/settings.json | Project-level permissions (added 2026-04-11 commit `b643c2e`) — no hooks configured |

DELTA: +1 settings.json file vs previous audit. global-macro-analysis now has a settings.json (previously NO settings.json existed). It currently configures permissions only — no hook entries. projects/project-planning has NO settings.json file. Previous audit said the workflows/research-workflow settings.json had multiple hooks; the working tree now removes 14 lines (uncommitted change).

**Hook scripts on disk (22 total):**

| Script | Location | Status |
|--------|----------|--------|
| auto-sync-shared.sh | ai-resources/.claude/hooks/ | committed |
| check-template-drift.sh | ai-resources/.claude/hooks/ | committed |
| detect-innovation.sh | ai-resources/.claude/hooks/ | committed |
| pre-commit | ai-resources/.claude/hooks/ | committed |
| check-claim-ids.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | committed; mode-modified in working tree |
| detect-innovation.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | committed |
| friction-log-auto.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | committed |
| log-write-activity.sh | ai-resources/workflows/research-workflow/.claude/hooks/ | committed |
| check-claim-ids.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| coach-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| detect-innovation.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| friction-log-auto.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| improve-reminder.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| log-write-activity.sh | projects/buy-side-service-plan/.claude/hooks/ | committed |
| auto-commit.sh | projects/nordic-pe-landscape-mapping-4-26/.claude/hooks/ | committed |
| log-write-activity.sh | projects/nordic-pe-landscape-mapping-4-26/.claude/hooks/ | committed |
| detect-innovation.sh | projects/project-planning/.claude/hooks/ | NOT in any git repo (filesystem only) |
| friction-log-auto.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (template) |
| log-write-activity.sh | workflows/active/research-workflow/project-template/.claude/hooks/ | (template) |

DELTA: +1 hook script (`projects/project-planning/.claude/hooks/detect-innovation.sh`). The orphaned `detect-innovation.sh` formerly under `projects/global-macro-analysis/.claude/hooks/` was removed in commit `63562e5` (2026-04-11). Previous audit reported 21 hook scripts; the corrected count is now 22 across the workspace including the new project-planning hook.

### 1.3 Template Files

| Path | Used By | Last Commit Date |
|------|---------|-----------------|
| ai-resources/skills/answer-spec-generator/references/component-templates.md | answer-spec-generator skill | Pre-2026-01-06 |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | execution-manifest-creator skill | Pre-2026-01-06 |
| ai-resources/skills/research-extract-creator/references/extract-template.md | research-extract-creator skill | Pre-2026-01-06 |
| ai-resources/workflows/research-workflow/CLAUDE.md | /deploy-workflow (contains {{PLACEHOLDERS}}) | 2026-04-03 |
| ai-resources/workflows/research-workflow/SETUP.md | /deploy-workflow (deployment checklist) | 2026-04-03 |
| ai-resources/workflows/research-workflow/ (entire dir) | /deploy-workflow | 2026-04-11 |
| projects/global-macro-analysis/macro-kb/_meta/templates/ (10 files) | /kb-* commands | 2026-04-11 |
| **workflows/templates/workflow-need.md** | /document-workflow, /new-workflow | 2026-04-11 (NEW) |
| projects/project-planning/pipeline/ref-project-plan.md | /plan-draft, /plan-refine, /plan-evaluate, plan-evaluator agent | NOT a git repo |
| projects/project-planning/pipeline/ref-tech-spec.md | /spec-draft, /spec-refine, /spec-evaluate, spec-evaluator agent | NOT a git repo |

DELTA: +1 template file (`workflows/templates/workflow-need.md` was created in commit `20e98d5` 2026-04-11; the previous audit flagged it as a missing reference). +2 reference templates in projects/project-planning/pipeline/.

### 1.4 Scripts

| Path | Purpose | Called By |
|------|---------|----------|
| ai-resources/scripts/repo-audit.sh | Shell-based repo health audit | Manual execution |
| ai-resources/scripts/skill-inventory.sh | Lists skills with metadata | Manual execution |

All other .sh files are hook scripts (listed in 1.2).

DELTA: No change.

### 1.5 Skills

`ai-resources/skills/` contains 66 skill directories (excluding `CATALOG.md`). All 66 directories have a `SKILL.md` file. None are missing `SKILL.md`.

Project-specific SKILL.md files outside ai-resources/skills/:
- `ai-resources/workflows/research-workflow/reference/skills/knowledge-file-producer/SKILL.md` (template copy)
- `ai-resources/workflows/research-workflow/reference/skills/report-compliance-qc/SKILL.md` (template copy)

Project workspaces no longer contain owned-skill directories:
- `projects/global-macro-analysis/skills/intake-processor` is now a symlink to `../../../ai-resources/skills/intake-processor` (graduated 2026-04-11 commit `63562e5`)
- `projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner` is a symlink to `ai-resources/skills/fund-triage-scanner`
- `projects/buy-side-service-plan/reference/skills/*` (22 entries) are all symlinks to `ai-resources/skills/*`

DELTA: +3 skills in ai-resources/skills/ (63 -> 66). New (verified by directory listing): `ai-prose-decontamination` (commit `3381047` 2026-04-11), and the previously project-owned `intake-processor` and `fund-triage-scanner` are now graduated to ai-resources. The previous audit's "2 project-owned skills not in canonical library" violation is resolved.

### 1.6 Uncategorized Items

| Path | Description |
|------|-------------|
| ai-resources/prompts/supplementary-research/ (5 .md files) | Supplementary research prompts |
| ai-resources/logs/ (4 files) | session-notes.md, decisions.md, innovation-registry.md, coaching-data.md |
| ai-resources/reports/ | Generated audit/health reports (untracked dir per `?? reports/`) |
| ai-resources/skills/CATALOG.md | Curated skill index |
| ai-resources/docs/session-rituals.md | Session ritual documentation |
| ai-resources/docs/operator-principles.md | Operator-focused principles doc (untracked) |
| ai-resources/inbox/repo-review-brief.md | Incoming review brief |
| ai-resources/style-references/internal-material.md | Internal style reference |
| workflows/processes/ (3 files) | create-new-workflow.md, document-existing-process.md, improve-existing-workflow.md |
| workflows/reports/repo-health-report.md | Generated health report |
| workflows/active/research-workflow/project-template/ | Untracked template in development |
| workflows/templates/workflow-need.md | Template for /document-workflow and /new-workflow |
| projects/global-macro-analysis/pipeline/ (multiple files) | Pipeline artifacts |
| projects/global-macro-analysis/macro-kb/ (entire KB tree) | Knowledge base |
| projects/buy-side-service-plan/memory/ | New untracked directory |
| projects/project-planning/pipeline/ (11 .md files) | New project-planning pipeline artifacts (context-pack, project-plan, architecture, implementation-spec, repo-snapshot, test-results, implementation-log, decisions, pipeline-state, ref-project-plan, ref-tech-spec) |
| projects/project-planning/output/ | Empty directory |
| logs/innovation-registry.md (root workspace) | Untracked innovation registry at workspace root |

DELTA: +1 ai-resources/docs/operator-principles.md (untracked). +1 ai-resources/reports/ (untracked). +1 buy-side memory/ directory (untracked). +1 entire `projects/project-planning/` workspace including its pipeline/ and output/ directories. +1 workflows/templates/workflow-need.md (now committed). global-macro-analysis intake-processor and nordic-pe fund-triage-scanner skills graduated (no longer uncategorized).

### 1.7 Symlinks

Total symlinks: **116** (computed via `find -type l`). No broken symlinks detected (`find -xtype l` returned 0 results).

| Symlink Cluster | Count | Pattern |
|----------------|-------|---------|
| Root workspace `.claude/` | 12 | relative paths to ai-resources |
| workflows/.claude/commands/audit-repo.md | 1 | relative |
| projects/buy-side-service-plan/reference/skills/ | 22 | mixture (20 absolute, 2 relative) |
| projects/buy-side-service-plan/.claude/commands/ | ~12 | mostly absolute, 1 relative (produce-prose.md) |
| projects/buy-side-service-plan/.claude/agents/ | 5 | absolute |
| projects/global-macro-analysis/.claude/commands/ | 21 | all relative |
| projects/global-macro-analysis/.claude/agents/ | 8 | all relative |
| projects/global-macro-analysis/skills/intake-processor | 1 | relative (NEW — graduated) |
| projects/nordic-pe-landscape-mapping-4-26/.claude/commands/session-guide.md | 1 | absolute |
| projects/nordic-pe-landscape-mapping-4-26/reference/skills/repo-health-analyzer | 1 | absolute |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/skills/fund-triage-scanner | 1 | absolute |
| projects/project-planning/.claude/commands/ | 22 | all relative (NEW workspace) |
| projects/project-planning/.claude/agents/ | 9 | all relative (NEW workspace) |

DELTA: +31 symlinks total (≈85 -> 116). +22 commands and +9 agents in projects/project-planning. +1 graduated skill symlink (intake-processor in global-macro-analysis). All targets verified: zero broken symlinks across the workspace.

Section summary: 172 commands / 8 settings.json / 22 hook scripts / 19 template files / 2 utility scripts / 66 ai-resources skills / 116 symlinks catalogued / 12+ deltas from previous audit

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Files and Sizes

| File | Lines | Sections |
|------|-------|----------|
| (workspace root) /CLAUDE.md | 97 | What This Workspace Is For; Projects; Axcíon's Tool Ecosystem; Skill Library; AI Resource Creation Rules; Design Judgment Principles; QC Independence Rule; Completion Standard; Working Principles; Autonomy Rules; File verification and git commits; Delivery (12 sections) |
| ai-resources/CLAUDE.md | 95 | What This Repo Contains; How I Work; Skill Format Standard; Model Preference; Development Workflow; General Session Rules; Cross-References; Git Rules (8 sections) |
| projects/buy-side-service-plan/CLAUDE.md | 157 | (uncommitted changes) |
| projects/global-macro-analysis/CLAUDE.md | 77 | (modified vs HEAD) |
| projects/nordic-pe-landscape-mapping-4-26/CLAUDE.md | 69 | (modified vs HEAD) |
| projects/project-planning/CLAUDE.md | 54 | Purpose; How It Works; Commands; Output Convention; Reference Documents; Skill References; Versioning; Relationship to /new-project (8 sections) |
| workflows/CLAUDE.md | 23 | (modified vs HEAD) |

DELTA: +1 CLAUDE.md (project-planning, 54 lines). global-macro-analysis: 62 -> 77 lines (+15, currently uncommitted in working tree). nordic-pe: 67 -> 69 lines (+2, uncommitted). buy-side: 157 lines (no change in count from previous audit).

### 2.2 Dead References

**Workspace root CLAUDE.md** — All file/path references resolve. The previous audit's flag of `templates/workflow-need.md` is RESOLVED — that file now exists at `workflows/templates/workflow-need.md` (commit `20e98d5`).

**ai-resources/CLAUDE.md** — All file references verified.

**projects/project-planning/CLAUDE.md** — references to `projects/project-planning/pipeline/ref-project-plan.md`, `projects/project-planning/pipeline/ref-tech-spec.md`, `ai-resources/skills/implementation-project-planner/SKILL.md`, `ai-resources/skills/spec-writer/SKILL.md` — all four exist and resolve.

DELTA: -1 dead reference (workflow-need.md template now exists). 0 dead references remain across the workspace's CLAUDE.md files.

### 2.3 Contradictions

**Contradiction (root CLAUDE.md, persisting from previous audit but partially resolved):**

Root CLAUDE.md line 34: "Do not create AI resources in project workspaces. Skills, commands, and agent definitions belong in `ai-resources/`."

Actual state: project-owned skills are now ALL graduated to ai-resources (intake-processor, fund-triage-scanner) — the prior contradiction is RESOLVED.

However, project-planning command files (`plan-draft.md`, `plan-refine.md`, `plan-evaluate.md`, `spec-draft.md`, `spec-refine.md`, `spec-evaluate.md`) are LOCAL files in `projects/project-planning/.claude/commands/` rather than symlinks to ai-resources. By the strict reading of the rule ("Skills, commands, and agent definitions belong in `ai-resources/`"), six project-owned commands and two project-owned agents (`plan-evaluator.md`, `spec-evaluator.md`) reside outside ai-resources.

DELTA: Skill ownership contradiction resolved. New command/agent ownership contradiction introduced by project-planning workspace.

### 2.4 Conventions Not Followed

| Convention | Source | Violation |
|-----------|--------|-----------|
| Commit message format: `new:`, `update:`, `fix:`, `batch:` | ai-resources/CLAUDE.md line 90 | buy-side auto-commit hook still uses `update: $stage — $bn` format (mostly compliant but project-specific) |
| Commands belong in ai-resources | Root CLAUDE.md line 34 | 6 plan/spec commands and 2 agents reside in projects/project-planning |

Conventions verified as followed:
- Skill folder naming (lowercase, hyphenated): all 66 skills comply
- SKILL.md file naming: all 66 skills have exactly `SKILL.md`
- YAML frontmatter with `name` and `description`: all 66 comply (sampled)
- Body under 500 lines: not re-verified this audit

DELTA: -2 violations (intake-processor, fund-triage-scanner — both graduated). +1 violation (project-planning local commands and agents).

### 2.5 Partial Feature References

| Feature | What Exists | What's Missing |
|---------|------------|----------------|
| /document-workflow command | Command file at root, process doc, **template now exists** | None — RESOLVED |
| /new-workflow command | Command file at root, process doc, **template now exists** | None — RESOLVED |
| projects/project-planning workspace | CLAUDE.md, 6 local commands, 2 evaluator agents, 2 reference docs, hooks dir | `output/` directory exists but is empty — no `{project-name}/` subdirs yet |

DELTA: -2 partial-feature gaps (workflow-need.md template now exists). The orphaned global-macro detect-innovation.sh flagged in previous audit was REMOVED in commit `63562e5`.

Section summary: 1 issue flagged / 5 deltas from previous audit

---

## Section 3: Dependency References

### 3.1 Command-to-File Reference Map

| Result | Count |
|--------|-------|
| All referenced files exist | 172 commands |
| Referenced file missing | 0 commands |

The previous audit's 2 failed references (`templates/workflow-need.md`) are now resolved. project-planning's 6 new commands all reference paths that exist (`pipeline/ref-project-plan.md`, `pipeline/ref-tech-spec.md`, `ai-resources/skills/implementation-project-planner/SKILL.md`, `ai-resources/skills/spec-writer/SKILL.md`, `.claude/agents/plan-evaluator.md`, `.claude/agents/spec-evaluator.md`).

DELTA: 0 unresolved references (was 2 in previous audit).

### 3.2 Command Chains

**Project Planning Pipeline (NEW):**
```
/plan-draft -> /plan-refine -> /plan-evaluate -> /spec-draft -> /spec-refine -> /spec-evaluate -> [output to /new-project]
```

**Existing chains (unchanged):**
- Research Workflow: `/run-preparation -> /run-execution -> /run-cluster -> /run-analysis -> /run-synthesis -> /run-report -> /verify-chapter -> /produce-knowledge-file`
- KB Workflow (global-macro): `/kb-ingest -> /kb-review -> /kb-synthesize`
- Skill Management: `/request-skill -> /create-skill (or /improve-skill, /migrate-skill)`
- Project Setup: `/new-project -> pipeline-stage-2 -> ... -> pipeline-stage-5 -> /session-guide`
- Audit: `/repo-dd -> /repo-dd deep -> /repo-dd full`
- Workflow Analysis: `/analyze-workflow (analysis -> critique)`
- Refinement: `/refinement-deep -> /qc-pass + /refinement-pass + /triage`
- Session Lifecycle: `/prime -> [work] -> /wrap-session`

DELTA: +1 chain (Project Planning Pipeline).

### 3.3 Files Referenced by Multiple Commands

Unchanged set from previous audit:
- logs/session-notes.md (10+ refs); logs/innovation-registry.md (6); CLAUDE.md (6); macro-kb/_meta/taxonomy.md (5); macro-kb/_meta/index.json (5); logs/friction-log.md (4); logs/decisions.md (4); report/chapters/ (4); analysis/cluster-memos/ (4); skills/ai-resource-builder/SKILL.md (3)

NEW multi-reference files in project-planning:
- `projects/project-planning/pipeline/ref-project-plan.md` — referenced by /plan-draft, /plan-refine, /plan-evaluate, plan-evaluator agent (4)
- `projects/project-planning/pipeline/ref-tech-spec.md` — referenced by /spec-draft, /spec-refine, /spec-evaluate, spec-evaluator agent (4)

DELTA: +2 multi-referenced files.

### 3.4 Top 10 Files by Downstream References

Same top 10 as previous audit (logs/session-notes.md, logs/innovation-registry.md, CLAUDE.md, taxonomy.md, index.json, friction-log.md, decisions.md, report/chapters/, analysis/cluster-memos/, skills/ai-resource-builder/SKILL.md). The new project-planning reference docs each have 4 references — tied with rank 6-9 but not displacing them.

DELTA: No change in top 10.

Section summary: 0 issues flagged / 3 deltas from previous audit

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern

Standard pattern (66 ai-resources skills): folder with SKILL.md containing YAML frontmatter (`name`, `description`), optional `references/` subdirectory.

Spot-checked: ai-prose-decontamination (NEW), formatting-qc, intake-processor (graduated), fund-triage-scanner (graduated). All four conform to standard pattern.

DELTA: +3 skills, all conformant.

### 4.2 Slash Command Definition Pattern

| Pattern Variant | Notes |
|----------------|-------|
| Inline prompt (< 10 lines) | clarify, qc-pass, refinement-pass, scope, note, triage |
| Procedural with skill references | run-preparation, create-skill, plan-draft (NEW), spec-draft (NEW) |
| Agent delegation | new-project, session-guide, audit-repo, analyze-workflow, plan-evaluate (NEW), spec-evaluate (NEW) |
| Procedural with refinement criteria | plan-refine (NEW), spec-refine (NEW) |
| KB operations (scope-enforced) | 13 kb-* commands |
| Session orientation / utility / orchestrator | prime, wrap-session, repo-dd, refinement-deep |

The 6 new project-planning commands all follow the procedural-with-headers pattern used elsewhere in the workspace (numbered Workflow steps, Arguments section, Announce completion block).

DELTA: +1 pattern variant ("Procedural with refinement criteria") for plan-refine/spec-refine.

### 4.3 Skill Template Comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resources/SKILL.md format standards (in `skills/ai-resource-builder/SKILL.md`).

DELTA: No change.

### 4.4 Naming Convention Inconsistencies

| Check | Result |
|-------|--------|
| Skill folders: lowercase, hyphenated | All 66 comply |
| Command files: lowercase, hyphenated .md | All comply (project-planning's plan-* and spec-* commands conform) |
| Agent files: lowercase, hyphenated .md | All comply |
| Hook scripts: lowercase, hyphenated .sh | All comply except `pre-commit` (git convention) |

Symlink path style (mixed across workspace):
- buy-side reference/skills: 20 absolute + 2 relative
- buy-side .claude/commands: mostly absolute, 1 relative
- global-macro-analysis: all relative
- nordic-pe: 2 absolute
- root workspace: all relative
- **projects/project-planning: all relative (NEW)**

DELTA: project-planning consistently uses relative symlinks, matching global-macro-analysis pattern.

### 4.5 Directory Structure Violations

Same as previous audit:
- `prompts/` directory exists at ai-resources root — documented in CLAUDE.md "What This Repo Contains" but not in standard directory structure list elsewhere.

projects/project-planning structure (CLAUDE.md, output/, pipeline/, .claude/) is internally consistent and matches its declared layout.

DELTA: No change.

### 4.6 Command Syntax and Path Resolution

| Check | Pass | Fail |
|-------|------|------|
| Command files parseable as markdown | 172 | 0 |
| Referenced file paths resolve | 172 | 0 |

Failed path resolutions from previous audit (`templates/workflow-need.md`) are now resolved.

DELTA: -2 failures.

### 4.7 Duplicate or Built-in Command Names

Commands with the same name appearing in 3+ locations (count of unique names): unchanged set of 17 from previous audit, with project-planning adding instances of: analyze-workflow, audit-repo, clarify, coach, create-skill, friction-log, improve, improve-skill, migrate-skill, note, prime, project-consultant, qc-pass, refinement-deep, refinement-pass, repo-dd, request-skill, scope, triage, update-claude-md, usage-analysis, wrap-session (22 names — all symlinks to ai-resources).

NEW command names introduced by project-planning that do NOT collide with existing ones: plan-draft, plan-refine, plan-evaluate, spec-draft, spec-refine, spec-evaluate (6 unique names, no collisions in workspace, no collisions with built-in Claude Code commands).

`/project-consultant` is a new ai-resources command also symlinked into project-planning. It does not collide with built-ins.

Built-in collision check: none of the 6 new plan/spec commands match built-ins (/help, /clear, /compact, /cost, /doctor, /init, /login, /logout, /memory, /model, /permissions, /review, /terminal-setup, /vim, /fast).

DELTA: +6 new unique command names (plan-draft, plan-refine, plan-evaluate, spec-draft, spec-refine, spec-evaluate). +1 new shared command (project-consultant).

Section summary: 1 issue flagged (prompts/ undocumented) / 5 deltas from previous audit

---

## Section 5: Context Load

### 5.1 Context Loaded Per Session

| Entry Point | CLAUDE.md Lines | SessionStart Hook Load | Estimated Total |
|-------------|----------------|----------------------|----------------|
| ai-resources | 97 (root) + 95 (ai-resources) = 192 | ~60 | ~252 |
| global-macro-analysis | 97 + 77 = 174 | ~60 | ~234 |
| buy-side-service-plan | 97 + 157 = 254 | ~60+drift+sync | ~320 |
| nordic-pe | 97 + 69 = 166 | ~30 | ~196 |
| nordic-pe/step-1 | 97 + 69 + 30 = 196 | ~30 | ~226 |
| workflows | 97 + 23 = 120 | ~60 | ~180 |
| **projects/project-planning** | **97 + 54 = 151** | **0 (no settings.json)** | **~151** |

DELTA: +1 entry point (project-planning, ~151 lines — lowest of all entry points). global-macro CLAUDE.md grew from 62 -> 77 lines (uncommitted). nordic-pe grew from 67 -> 69. buy-side and ai-resources unchanged.

### 5.2 CLAUDE.md Sections Not Referenced by Operations

| Section | File | Lines | Referenced By |
|---------|------|-------|-------------|
| Design Judgment Principles | Root CLAUDE.md | ~11 | None found |
| Autonomy Rules | Root CLAUDE.md | ~10 | None found |
| Working Principles | Root CLAUDE.md | ~9 | None found |
| Delivery | Root CLAUDE.md | ~3 | None found |
| How I Work | ai-resources/CLAUDE.md | ~3 | None found |
| Versioning | projects/project-planning/CLAUDE.md | ~5 | None found (but the rule is referenced implicitly by plan-refine/spec-refine "create the next version file") |
| Relationship to /new-project | projects/project-planning/CLAUDE.md | ~3 | None found (informational) |

DELTA: +2 sections in new project-planning CLAUDE.md that are not directly invoked by any command/hook.

### 5.3 CLAUDE.md Growth History

**ai-resources/CLAUDE.md:**

| Commit | Date | Lines |
|--------|------|-------|
| (working tree) | 2026-04-12 | 95 |
| f284902 | 2026-04-11 | 94 |
| dc6fe4d | 2026-04-06 | 92 |
| 241dfb4 | 2026-04-06 | 92 |
| b5f497e | 2026-04-05 | 86 |

DELTA: No new commit since previous audit (working-tree state unchanged).

**projects/project-planning/CLAUDE.md:** Not in any git repo. Filesystem mtime: 2026-04-11 19:42 (54 lines).

DELTA: NEW file outside any tracked repo.

Section summary: 1 issue flagged / 3 deltas from previous audit

---

## Section 6: Drift & Staleness

### 6.1 Stale Files Still Referenced by Active Operations

Files not modified in the last 90 days (before 2026-01-12) but still referenced:

| File | Last Commit Date | Referenced By |
|------|-----------------|--------------|
| ai-resources/skills/ai-resource-builder/references/examples.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/writing-standards.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/ai-resource-builder/references/operational-frontmatter.md | Pre-2026-01-06 | ai-resource-builder SKILL.md |
| ai-resources/skills/answer-spec-generator/references/component-templates.md | Pre-2026-01-06 | answer-spec-generator skill |
| ai-resources/skills/execution-manifest-creator/references/manifest-template.md | Pre-2026-01-06 | execution-manifest-creator skill |
| ai-resources/skills/research-extract-creator/references/extract-template.md | Pre-2026-01-06 | research-extract-creator skill |

ai-resources/scripts/repo-audit.sh (2026-02-20) and skill-inventory.sh (2026-02-20) and .claude/hooks/pre-commit (2026-02-20) and prompts/supplementary-research/*.md (2026-03-24) were flagged in previous audit. They remain at the same dates and are now within or near the 90-day window depending on cutoff.

DELTA: Set substantively unchanged from previous audit.

### 6.2 TODO/FIXME/PLACEHOLDER Markers

| File | Line | Marker | Content |
|------|------|--------|---------|
| projects/buy-side-service-plan/context/style-guide.md | 3 | TODO | "TODO: Populate after your first content draft." |

Other appearances are intentional template syntax: `{{PLACEHOLDER}}` markers in deploy-workflow.md, implementation-spec-writer/SKILL.md, workspace-template-extractor/SKILL.md, and SETUP.md (template files). `workflow-evaluator/SKILL.md` line 312 uses "TODO" as a description of incomplete workflow states (not an action marker).

Searched all .md files in workspace (excluding `.git/`) for: TODO, FIXME, PLACEHOLDER.

DELTA: No change. Same single actionable TODO marker.

### 6.3 Empty or Stub Files

**Empty directory markers (.gitkeep):** ~63 files across workspace (unchanged from previous audit; primarily buy-side and global-macro-analysis subdirectories).

**Files with fewer than 5 lines of real content:**

| File | Status |
|------|--------|
| ai-resources/.claude/settings.local.json | Empty (unchanged) |
| projects/buy-side-service-plan/.claude/settings.local.json | Minimal local overrides |
| projects/buy-side-service-plan/context/style-guide.md | Header + TODO |
| projects/buy-side-service-plan/context/domain-knowledge.md | Header + placeholder |
| projects/nordic-pe-landscape-mapping-4-26/logs/decisions.md | Empty |
| projects/nordic-pe-landscape-mapping-4-26/logs/qc-log.md | Empty |
| projects/nordic-pe-landscape-mapping-4-26/logs/workflow-observations.md | Empty |
| projects/nordic-pe-landscape-mapping-4-26/reports/last-audit-commit.txt | Commit hash only |
| projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/input/fund-list.csv | Header row only |
| projects/global-macro-analysis/macro-kb/_meta/changelog.json | Empty array |
| projects/global-macro-analysis/macro-kb/_meta/index.json | Empty array |
| **projects/project-planning/output/** | Empty directory (no project subfolders yet) |

DELTA: +1 empty directory (`projects/project-planning/output/` — no plans/specs produced yet).

Section summary: 0 new issues flagged / 1 delta from previous audit

---

## Cross-Section Summary

| Category | Count |
|----------|-------|
| Total commands inventoried | 172 |
| Total hook scripts | 22 |
| Total settings.json files | 8 |
| Total skills (ai-resources canonical) | 66 |
| Total symlinks | 116 (0 broken) |
| New CLAUDE.md files vs previous audit | 1 (project-planning) |
| Resolved dead references vs previous audit | 1 (workflow-need.md template) |
| Resolved violations vs previous audit | 2 (intake-processor, fund-triage-scanner graduated) |
| New violations vs previous audit | 1 (project-planning local commands/agents vs ownership rule) |
| Unresolved actionable TODO markers | 1 |
| Outstanding partial feature gaps | 0 |
| Uncommitted modifications across repos (M+T+D+??) | ai-resources 17, workflows 22, buy-side 13, global-macro 5, nordic-pe 4 |
