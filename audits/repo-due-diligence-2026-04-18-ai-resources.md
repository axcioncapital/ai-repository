# Repo Due Diligence Audit — 2026-04-18
Repo: ai-resources repo
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources
Commit: b66e5ee
Previous audit: None

---

## Section 1: Inventory

### 1.1 Slash Commands

All commands are defined in `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/`. 29 commands total.

| Command | File | Referenced Files |
|---|---|---|
| analyze-workflow | analyze-workflow.md | `{AI_RESOURCES}/audits/`, `{WORKFLOW_PATH}/reference/stage-instructions.md`, various workflow agents |
| audit-repo | audit-repo.md | `reference/skills/repo-health-analyzer/agents/` (8 agent files, project-relative path) |
| clarify | clarify.md | None |
| cleanup-worktree | cleanup-worktree.md | `ai-resources/skills/worktree-cleanup-investigator/SKILL.md`, `scripts/find-template.sh` (in skill bundle) |
| coach | coach.md | `logs/session-notes.md`, `logs/coaching-log.md`, `logs/coaching-log-archive.md`, `collaboration-coach` agent |
| create-skill | create-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `logs/improvement-log.md`, `qc-reviewer` agent |
| deploy-workflow | deploy-workflow.md | `ai-resources/.claude/hooks/auto-sync-shared.sh`, `check-template-drift.sh`, `reference/skills/` (project-relative), `workflows/{TEMPLATE}/` |
| friction-log | friction-log.md | `logs/friction-log.md` |
| graduate-resource | graduate-resource.md | `logs/innovation-registry.md`, `ai-resources/skills/` |
| improve-skill | improve-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `logs/improvement-log.md`, `qc-reviewer` agent |
| improve | improve.md | `logs/friction-log.md`, `logs/improvement-log.md`, `improvement-analyst` agent |
| migrate-skill | migrate-skill.md | `skills/ai-resource-builder/SKILL.md`, `skills/ai-resource-builder/references/evaluation-framework.md`, `qc-reviewer` agent |
| new-project | new-project.md | `ai-resources/.claude/agents/pipeline-stage-*.md`, `session-guide-generator` agent, `ai-resources/.claude/hooks/auto-sync-shared.sh`, multiple project CLAUDE.md canonical blocks |
| note | note.md | `logs/friction-log.md`, `logs/workflow-observations.md` |
| prime | prime.md | `logs/session-notes.md`, `logs/innovation-registry.md`, `logs/decisions.md` |
| project-consultant | project-consultant.md | `projects/global-macro-analysis/` (multiple paths, workspace-relative) |
| qc-pass | qc-pass.md | `qc-reviewer` agent |
| refinement-deep | refinement-deep.md | `refinement-reviewer` agent |
| refinement-pass | refinement-pass.md | `refinement-reviewer` agent |
| repo-dd | repo-dd.md | `audits/questionnaire.md`, `repo-dd-auditor` agent, `dd-extract-agent`, `dd-log-sweep-agent`, log files, `session-guide-generator` agent |
| request-skill | request-skill.md | `ai-resources/skills/` (search) |
| scope | scope.md | None |
| session-guide | session-guide.md | `session-guide-generator` agent |
| sync-workflow | sync-workflow.md | `reference/skills/` (project-relative), workflow template files |
| token-audit | token-audit.md | `{WORKSPACE}/ai-resources/audits/`, `token-audit-auditor` agent, `token-audit-auditor-mechanical` agent |
| triage | triage.md | `triage-reviewer` agent |
| update-claude-md | update-claude-md.md | CLAUDE.md (current project) |
| usage-analysis | usage-analysis.md | `usage/usage-log.md`, `ai-resources/skills/session-usage-analyzer/SKILL.md`, `session-usage-analyzer` skill |
| wrap-session | wrap-session.md | `logs/session-notes.md`, `logs/decisions.md`, `logs/coaching-data.md`, `logs/improvement-log.md`, `logs/innovation-registry.md`, `usage/usage-log.md`, `logs/friction-log.md`, `session-usage-analyzer` skill |

Section summary: 29 commands catalogued / no previous audit for delta.

---

### 1.2 Hooks

**Registered in `.claude/settings.json` (project-level):**

| Trigger | Type | What It Does | Files Referenced |
|---|---|---|---|
| Stop | command (inline bash) | Checks `logs/innovation-registry.md` for pending innovations; emits systemMessage prompting `/wrap-session` | `logs/innovation-registry.md` |

**Registered in `~/.claude/settings.json` (global user-level):**

| Trigger | Matcher | Type | What It Does | Files Referenced |
|---|---|---|---|---|
| PostToolUse | Write | command | Runs `detect-innovation.sh` to detect when commands/agents/hooks are created | `.claude/hooks/detect-innovation.sh` |
| PostToolUse | Edit | command | Same as above | `.claude/hooks/detect-innovation.sh` |
| Stop | — | command | Plays system sound (`afplay /System/Library/Sounds/Pop.aiff`) | None |
| Notification | — | command | Plays system sound | None |

**Hook scripts present in `.claude/hooks/` but not registered in any settings.json:**

| Script | Declared Role | Why Not Registered |
|---|---|---|
| `auto-sync-shared.sh` | SessionStart hook for projects | Called from project settings.json, not ai-resources own settings. Invoked by `/new-project` and `/deploy-workflow` during project setup. |
| `check-template-drift.sh` | SessionStart hook for projects | Same — designed for deployed projects, not ai-resources itself. Referenced in `/deploy-workflow` instructions. |
| `pre-commit` | Pre-commit git hook | Not a Claude Code hook — intended for `.git/hooks/pre-commit`. Not registered in any settings.json. |
| `check-skill-size.sh` | Called by `pre-commit` | Called from `pre-commit` hook script, not registered in settings.json directly. |

Section summary: 5 hooks catalogued (1 in project settings.json, 4 in global settings.json) / no previous audit for delta.

---

### 1.3 Template Files

| File Path | Used By | Last Commit Date |
|---|---|---|
| `skills/execution-manifest-creator/references/manifest-template.md` | `execution-manifest-creator` skill | 2026-03-25 |
| `skills/answer-spec-generator/references/component-templates.md` | `answer-spec-generator` skill | 2026-03-26 |
| `skills/research-prompt-creator/references/prompt-construction-guide.md` | `research-prompt-creator` skill | 2026-03-29 |
| `skills/ai-resource-builder/references/operational-frontmatter.md` | `ai-resource-builder` skill | 2026-04-05 |
| `skills/ai-resource-builder/references/examples.md` | `ai-resource-builder` skill | 2026-04-05 |
| `skills/ai-resource-builder/references/review-principles.md` | `ai-resource-builder` skill | 2026-04-09 |
| `skills/ai-resource-builder/references/evaluation-framework.md` | `ai-resource-builder` skill, `/create-skill`, `/improve-skill`, `/migrate-skill` | 2026-04-09 |
| `skills/ai-resource-builder/references/writing-standards.md` | `ai-resource-builder` skill | 2026-04-05 |
| `skills/claude-code-workflow-builder/references/feature-patterns.md` | `claude-code-workflow-builder` skill | 2026-02-21 |
| `skills/citation-converter/references/instruction-a.md` | `citation-converter` skill | 2026-03-22 |
| `skills/citation-converter/references/instruction-b.md` | `citation-converter` skill | 2026-03-22 |
| `skills/research-extract-creator/references/extract-template.md` | `research-extract-creator` skill | 2026-03-24 |
| `skills/research-plan-creator/references/example-output.md` | `research-plan-creator` skill | 2026-03-22 |
| `skills/worktree-cleanup-investigator/references/execution-protocol.md` | `worktree-cleanup-investigator` skill | 2026-04-18 |
| `skills/worktree-cleanup-investigator/references/decision-taxonomy.md` | `worktree-cleanup-investigator` skill | 2026-04-13 |
| `skills/repo-health-analyzer/agents/` (8 files) | `/audit-repo` command via `repo-health-analyzer` skill | 2026-04-01 (command.md); agent files vary |
| `audits/questionnaire.md` | `/repo-dd` command (`repo-dd-auditor` agent) | 2026-04-18 |
| `workflows/research-workflow/reference/file-conventions.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/stage-instructions.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/quality-standards.md` | research-workflow deployed projects | 2026-04-18 |
| `workflows/research-workflow/reference/style-guide.md` | research-workflow deployed projects | 2026-04-18 |

Section summary: 21 template/reference files catalogued / no previous audit for delta.

---

### 1.4 Scripts

| File Path | What It Does | What Calls It |
|---|---|---|
| `scripts/repo-audit.sh` | Full workspace health audit script | None found — checked all `.claude/commands/`, `CLAUDE.md`, `skills/` |
| `scripts/skill-inventory.sh` | Skill inventory generation script | None found — checked all `.claude/commands/`, `CLAUDE.md`, `skills/` |
| `.claude/hooks/auto-sync-shared.sh` | Symlinks ai-resources commands/agents into projects on SessionStart | Referenced in `/new-project` and `/deploy-workflow` command instructions; invoked from project settings.json |
| `.claude/hooks/check-template-drift.sh` | Detects drift between project tooling and canonical workflow template | Referenced in `/deploy-workflow` command; designed for project-level SessionStart |
| `.claude/hooks/detect-innovation.sh` | PostToolUse hook detecting new commands/agents/hooks and appending to innovation-registry.md | Registered in `~/.claude/settings.json` (global) |
| `.claude/hooks/pre-commit` | Pre-commit validation: checks SKILL.md frontmatter, naming conventions, prohibited files; calls `check-skill-size.sh` | Git pre-commit hook (`.git/hooks/`); not a Claude Code hook |
| `.claude/hooks/check-skill-size.sh` | Informational warning when staged SKILL.md exceeds 300 lines | Called by `.claude/hooks/pre-commit` |
| `skills/worktree-cleanup-investigator/scripts/find-template.sh` | Searches ai-resources for canonical template matching a given file path | `/cleanup-worktree` command and `worktree-cleanup-investigator` skill |

Section summary: 8 scripts catalogued / no previous audit for delta.

---

### 1.5 Skills

**Total skill directories:** 67 (in `skills/` directory, excluding `CATALOG.md` and `.gitkeep`).

All 67 skill directories contain a `SKILL.md` file. None are missing a `SKILL.md`.

Section summary: 67 skills catalogued, all have SKILL.md / no previous audit for delta.

---

### 1.6 Uncategorized Items

| Item | Category Assignment |
|---|---|
| `skills/CATALOG.md` | Skill catalog index file — not a skill, template, or command. Standalone inventory document. |
| `skills/repo-health-analyzer/command.md` | Skill-bundled command definition. Non-standard: this skill includes a command.md alongside its agents/ subdirectory. |
| `skills/repo-health-analyzer/agents/` (8 .md files) | Skill-bundled agent definitions. Stored inside skill directory rather than `.claude/agents/`. |
| `inbox/codex-second-opinion-brief.md` | Active resource brief in intake queue (not yet fulfilled). Last commit 2026-04-18. |
| `inbox/repo-review-brief.md` | Active resource brief in intake queue. Last commit 2026-04-06. |
| `inbox/archive/worktree-cleanup-brief.md` | Archived fulfilled brief. Last commit 2026-04-18. |
| `inbox/.gitkeep` | Empty placeholder file. |
| `audits/working/` | 22 working-notes files from recent audit runs (token-audit, repo-dd). Operational artifacts from subagent runs. |
| `audits/repo-dd-deep-2026-04-06.md` | Deep audit report. |
| `audits/repo-due-diligence-2026-04-06.md` | Prior audit report. |
| `audits/repo-due-diligence-2026-04-11.md` | Prior audit report. |
| `audits/repo-due-diligence-2026-04-12.md` | Prior audit report. |
| `audits/token-audit-2026-04-18-ai-resources.md` | Token audit report. |
| `audits/token-audit-2026-04-18-project-buy-side-service-plan.md` | Token audit report. |
| `audits/token-audit-protocol.md` | Protocol document for token audits. |
| `audits/workflow-analysis-*.md` (4 files) | Workflow analysis reports. |
| `audits/workflow-critique-*.md` (2 files) | Workflow critique reports. |
| `logs/coaching-data.md` | Session coaching profile log. |
| `logs/decisions.md` | Decision journal. |
| `logs/friction-log.md` | Friction event log. |
| `logs/improvement-log.md` | Improvement tracking log. |
| `logs/innovation-registry.md` | Innovation detection registry. |
| `logs/session-notes.md` | Session wrap notes. |
| `usage/usage-log.md` | Token usage telemetry log. |
| `reports/repo-health-report.md` | Generated repo health report (from `/audit-repo`). |
| `docs/operator-principles.md` | Process documentation. |
| `docs/session-rituals.md` | Process documentation. |
| `style-references/internal-material.md` | Style reference for formatting/prose-compliance skills. |
| `prompts/supplementary-research/` (5 .md files) | Standalone prompts for GPT supplementary research workflow. |
| `workflows/research-workflow/` | Research workflow template (full directory tree). |
| `.gitignore` | Standard git file. |

Section summary: 31 uncategorized items catalogued / no previous audit for delta.

---

### 1.7 Symlinks

None found — checked entire AUDIT_ROOT using `find -type l`. No symlinks exist anywhere in the `ai-resources` repository.

Section summary: 0 symlinks found / no previous audit for delta.

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Size and Structure

**Line count:** 83 lines  
**Sections:** 11

| Section Heading |
|---|
| What This Repo Contains |
| How I Work |
| Skill Creation and Improvement |
| Model Preference |
| Subagent Contracts |
| Session Telemetry |
| General Session Rules |
| Git Rules |
| Commit Rules |
| Compaction |
| Session Boundaries |

Section summary: 0 issues flagged / no previous audit for delta.

---

### 2.2 Dead References in CLAUDE.md

**One discrepancy found:**

- **Line 44:** "Output goes to `usage/usage-log.md`" — this path is correct and the file exists. However, earlier in CLAUDE.md's revision history (pre 2026-04-18 commit `b66e5ee`), this read `logs/usage-log.md`. The fix was applied in commit `b66e5ee` ("fix: CLAUDE.md — /usage-analysis writes to usage/, not logs/"). Current state is accurate.

No other dead references found — checked all paths mentioned: `skills/ai-resource-builder/SKILL.md` (exists), `usage/usage-log.md` (exists), `/create-skill` and `/improve-skill` (exist as commands), `workspace CLAUDE.md` (exists).

Section summary: 0 issues flagged / no previous audit for delta.

---

### 2.3 Contradictions in CLAUDE.md

**One contradiction found:**

| Location | Statement A | Statement B |
|---|---|---|
| Line 20 ("How I Work") | "I review and approve all changes before they are committed or pushed." | Line 56 ("Git Rules"): "Always show me the diff before committing" |
| — | — | Line 66 ("Commit Rules"): "**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step." |

The "How I Work" section and "Git Rules" bullet say changes require review before committing. The "Commit Rules" section says to commit directly without asking permission. These instructions are in direct conflict on whether pre-commit review is required.

Section summary: 1 issue flagged / no previous audit for delta.

---

### 2.4 Conventions Defined but Not Followed

**One partial non-compliance found:**

- **CLAUDE.md `skills/` convention:** The file states each skill lives in its own folder under `skills/`. The `skills/repo-health-analyzer/` directory contains additional subdirectories (`agents/`) and a `command.md` file beyond the standard SKILL.md pattern. This is the only skill with a bundled command and agent definitions inside the skill directory.

- **CATALOG.md:** CLAUDE.md documents `skills/` as the canonical skill library but does not mention a CATALOG.md maintenance convention. CATALOG.md exists but is not current: 7 skills created after 2026-04-06 (the catalog's last update date) are absent from it: `ai-prose-decontamination`, `formatting-qc`, `fund-triage-scanner`, `intake-processor`, `workflow-system-analyzer`, `workflow-system-critic`, `worktree-cleanup-investigator`.

Section summary: 2 issues flagged / no previous audit for delta.

---

### 2.5 Partially-Existing Features

**Three partially-existing features found:**

| Feature | What Exists | What Is Missing |
|---|---|---|
| `/note` command → `logs/workflow-observations.md` | `note.md` command exists and references `logs/workflow-observations.md` | `logs/workflow-observations.md` does not exist in the repo |
| `/coach` command → `logs/coaching-log.md` | `coach.md` command exists and references `logs/coaching-log.md` | `logs/coaching-log.md` does not exist in the repo |
| `repo-dd.md` log sweep → `logs/coaching-log.md`, `logs/workflow-observations.md` | `repo-dd.md` lists both files as targets for the dd-log-sweep-agent | Neither file exists |

Section summary: 3 issues flagged / no previous audit for delta.

---

### 2.6 Task-Type-Specific Instructions in CLAUDE.md

**No violations found.**

The "Skill Creation and Improvement" section (lines 22–24, 3 lines) contains only a pointer to `skills/ai-resource-builder/SKILL.md` — it does not embed methodology. This conforms to the scoping rule.

The "Subagent Contracts" section (lines 32–40, 9 lines) defines operational behavioral rules (summary caps, notes-to-disk convention) applicable to all commands in this repo — not task-type-specific methodology. This is cross-session infrastructure content appropriate for CLAUDE.md.

None of the 11 sections embed skill-creation methodology, workflow-stage instructions, evaluation frameworks, or file-format conventions for a single artifact type.

Section summary: 0 issues flagged / no previous audit for delta.

---

## Section 3: Dependency References

### 3.1 Command File References and Existence Check

| Slash Command | Referenced File | File Exists |
|---|---|---|
| create-skill | `skills/ai-resource-builder/SKILL.md` | Y |
| create-skill | `skills/ai-resource-builder/references/evaluation-framework.md` | Y |
| create-skill | `logs/improvement-log.md` | Y |
| improve-skill | `skills/ai-resource-builder/SKILL.md` | Y |
| improve-skill | `skills/ai-resource-builder/references/evaluation-framework.md` | Y |
| improve-skill | `logs/improvement-log.md` | Y |
| migrate-skill | `skills/ai-resource-builder/SKILL.md` | Y |
| migrate-skill | `skills/ai-resource-builder/references/evaluation-framework.md` | Y |
| cleanup-worktree | `skills/worktree-cleanup-investigator/SKILL.md` | Y |
| cleanup-worktree | `skills/worktree-cleanup-investigator/scripts/find-template.sh` | Y |
| usage-analysis | `skills/session-usage-analyzer/SKILL.md` | Y |
| usage-analysis | `usage/usage-log.md` | Y |
| wrap-session | `logs/session-notes.md` | Y |
| wrap-session | `logs/decisions.md` | Y |
| wrap-session | `logs/coaching-data.md` | Y |
| wrap-session | `logs/improvement-log.md` | Y |
| wrap-session | `logs/innovation-registry.md` | Y |
| wrap-session | `usage/usage-log.md` | Y |
| wrap-session | `logs/friction-log.md` | Y |
| wrap-session | `skills/session-usage-analyzer/SKILL.md` | Y |
| note | `logs/friction-log.md` | Y |
| note | `logs/workflow-observations.md` | **N** |
| coach | `logs/session-notes.md` | Y |
| coach | `logs/coaching-log.md` | **N** |
| prime | `logs/session-notes.md` | Y |
| prime | `logs/innovation-registry.md` | Y |
| prime | `logs/decisions.md` | Y |
| improve | `logs/friction-log.md` | Y |
| improve | `logs/improvement-log.md` | Y |
| repo-dd | `audits/questionnaire.md` | Y |
| repo-dd | `logs/coaching-log.md` (sweep target) | **N** |
| repo-dd | `logs/workflow-observations.md` (sweep target) | **N** |
| audit-repo | `reference/skills/repo-health-analyzer/agents/` (project-relative) | **N in ai-resources; Y in deployed projects** |
| graduate-resource | `logs/innovation-registry.md` | Y |
| graduate-resource | `ai-resources/skills/` | Y |
| friction-log | `logs/friction-log.md` | Y |
| new-project | `ai-resources/.claude/hooks/auto-sync-shared.sh` | Y |
| deploy-workflow | `ai-resources/.claude/hooks/auto-sync-shared.sh` | Y |
| deploy-workflow | `ai-resources/.claude/hooks/check-template-drift.sh` | Y |
| session-guide | `session-guide-generator` agent | Y |

Section summary: 4 issues flagged (2 missing log files, 1 path context-dependent, 1 duplicate of above) / no previous audit for delta.

---

### 3.2 Command Chain Relationships

| Chain | Description |
|---|---|
| `/request-skill` → `/create-skill` | `request-skill` writes a brief to `inbox/` and prompts operator to run `/create-skill` with it |
| `/friction-log` → `/improve` | `/friction-log` appends events to `logs/friction-log.md`; `/improve` reads that file to analyze friction and produce improvement items |
| `/improve` → (manual) `/create-skill` or `/improve-skill` | `/improve` logs items to `logs/improvement-log.md`; operator picks items to apply via skill commands |
| `/create-skill` / `/improve-skill` → `logs/improvement-log.md` | Both write escalation entries to improvement log on failure |
| `/wrap-session` → `/usage-analysis` (inline) | `/wrap-session` runs the full usage-analysis flow inline before committing |
| `/wrap-session` → `/graduate-resource` | `/wrap-session` identifies `triaged:graduate` items in innovation-registry and reminds operator to run `/graduate-resource` |
| `/wrap-session` → `/improve` (suggestion) | If friction events logged today, `/wrap-session` suggests running `/improve` |
| `/coach` → `collaboration-coach` agent | `/coach` spawns `collaboration-coach` agent to analyze session-notes.md patterns |
| `/prime` → session context | `/prime` reads last session note, innovation registry, and decisions log to orient the session |
| `/repo-dd` → `repo-dd-auditor`, `dd-extract-agent`, `dd-log-sweep-agent` | Pipeline with three subagents |
| `/analyze-workflow` → `workflow-analysis-agent`, `workflow-critique-agent` | Two-agent pipeline |
| `/token-audit` → `token-audit-auditor`, `token-audit-auditor-mechanical` | Two-agent parallel audit |
| `/new-project` → `pipeline-stage-2` through `pipeline-stage-5`, `session-guide-generator` | Six-stage sequential pipeline |
| `/session-guide` → `session-guide-generator` agent | Direct agent delegation |
| `/qc-pass` → `qc-reviewer` agent | Direct delegation |
| `/triage` → `triage-reviewer` agent | Direct delegation |
| `/refinement-pass`, `/refinement-deep` → `refinement-reviewer` agent | Direct delegation |
| `/audit-repo` → `repo-health-analyzer` skill (8-agent system) | Lead agent orchestrates 7 sub-auditors |

Section summary: 18 chain relationships mapped / no previous audit for delta.

---

### 3.3 Files Referenced by Multiple Commands, Hooks, or Scripts

| File | Referenced By |
|---|---|
| `logs/improvement-log.md` | `/create-skill`, `/improve-skill`, `/improve`, `/wrap-session`, `repo-dd` (sweep target) — 5 references |
| `logs/session-notes.md` | `/wrap-session`, `/prime`, `/coach`, `repo-dd` (sweep target) — 4 references |
| `logs/friction-log.md` | `/friction-log`, `/improve`, `/note`, `/wrap-session`, `repo-dd` (sweep target) — 5 references |
| `logs/innovation-registry.md` | `Stop` hook (inline), `/wrap-session`, `/prime`, `/graduate-resource`, `repo-dd` (sweep target) — 5 references |
| `logs/decisions.md` | `/wrap-session`, `/prime`, `repo-dd` (sweep target) — 3 references |
| `logs/coaching-log.md` | `/coach`, `repo-dd` (sweep target) — 2 references (file does not exist) |
| `logs/workflow-observations.md` | `/note`, `repo-dd` (sweep target) — 2 references (file does not exist) |
| `skills/ai-resource-builder/references/evaluation-framework.md` | `/create-skill`, `/improve-skill`, `/migrate-skill` — 3 references |
| `skills/ai-resource-builder/SKILL.md` | `/create-skill`, `/improve-skill`, `/migrate-skill` — 3 references |
| `usage/usage-log.md` | `/usage-analysis`, `/wrap-session` — 2 references |

Section summary: 10 multi-referenced files identified / no previous audit for delta.

---

### 3.4 Files Ranked by Downstream Reference Count (Top 10)

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | `logs/improvement-log.md` | 5 | `/create-skill`, `/improve-skill`, `/improve`, `/wrap-session`, `repo-dd` sweep |
| 2 | `logs/friction-log.md` | 5 | `/friction-log`, `/improve`, `/note`, `/wrap-session`, `repo-dd` sweep |
| 3 | `logs/innovation-registry.md` | 5 | Stop hook, `/wrap-session`, `/prime`, `/graduate-resource`, `repo-dd` sweep |
| 4 | `logs/session-notes.md` | 4 | `/wrap-session`, `/prime`, `/coach`, `repo-dd` sweep |
| 5 | `skills/ai-resource-builder/SKILL.md` | 3 | `/create-skill`, `/improve-skill`, `/migrate-skill` |
| 6 | `skills/ai-resource-builder/references/evaluation-framework.md` | 3 | `/create-skill`, `/improve-skill`, `/migrate-skill` |
| 7 | `logs/decisions.md` | 3 | `/wrap-session`, `/prime`, `repo-dd` sweep |
| 8 | `logs/coaching-log.md` | 2 | `/coach`, `repo-dd` sweep |
| 9 | `logs/workflow-observations.md` | 2 | `/note`, `repo-dd` sweep |
| 10 | `usage/usage-log.md` | 2 | `/usage-analysis`, `/wrap-session` |

Section summary: 10 items listed / no previous audit for delta.

---

### 3.5 Symlinks in .claude/commands/ or .claude/agents/ Without Permission Coverage

None found — checked `find .claude/commands/ -type l` and `find .claude/agents/ -type l`. No symlinks exist in either directory. Question is not applicable.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 3.6 Projects Referencing ai-resources Without Adequate additionalDirectories Coverage

5 projects in the workspace reference ai-resources (via auto-sync hook and CLAUDE.md):

| Project | How It References ai-resources | additionalDirectories Entry | Coverage |
|---|---|---|---|
| `buy-side-service-plan` | SessionStart hook, symlinked commands/agents | Workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` | Covered — workspace root is ancestor of ai-resources |
| `global-macro-analysis` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `nordic-pe-landscape-mapping-4-26` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `obsidian-pe-kb` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |
| `project-planning` | SessionStart hook, symlinked commands/agents | Workspace root | Covered |

All 5 projects list the workspace root in `permissions.additionalDirectories`. The workspace root is an ancestor of `ai-resources/`, providing coverage. No projects are missing the required entry.

Section summary: 0 issues flagged / no previous audit for delta.

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Pattern Consistency

All 67 skills have YAML frontmatter (starting with `---`) containing at minimum `name:` and `description:` fields. All use the lowercase-hyphenated directory naming convention.

**Structural deviations identified:**

| Item | Expected Pattern | Actual State |
|---|---|---|
| `skills/repo-health-analyzer/` | SKILL.md only (or with references/ and scripts/) | Contains `command.md` and `agents/` subdirectory with 8 agent definition files — non-standard for a skill directory |
| 40 skills predating 2026-04-06 | Current template includes "Failure Behavior" section | Variable: spot-checked `cluster-synthesis-drafter` (0 failure mentions), `gap-assessment-gate` (0 failure mentions) vs. `analysis-pass-memo-review` (1 mention), `evidence-spec-verifier` (4 mentions). Template added failure behavior section on 2026-04-06; pre-template skills vary |
| 8 skills exceeding 300 lines | Convention: under 300 lines (per `check-skill-size.sh`) | `answer-spec-generator` 485, `ai-prose-decontamination` 484, `research-plan-creator` 464, `ai-resource-builder` 463, `evidence-to-report-writer` 332, `prose-compliance-qc` 330, `session-guide-generator` 320, `workflow-evaluator` 316 |

Section summary: 3 issues flagged / no previous audit for delta.

---

### 4.2 Slash Command Definition Pattern Consistency

All 29 commands are markdown files in `.claude/commands/`. No command uses a non-.md extension.

**Structural deviations identified:**

| Item | Expected Pattern | Actual State |
|---|---|---|
| `cleanup-worktree.md` | Most commands start with prose or a heading | Starts with YAML frontmatter (`---`, `friction-log: true`, `---`). Only command with frontmatter. |
| `improve-skill.md` | Consistent invocation line | Starts with `Improve an existing skill: $ARGUMENTS` (inline invocation line without heading) |
| `wrap-session.md` | Consistent invocation line | Starts with inline invocation sentence including `$ARGUMENTS` |
| `create-skill.md` | Consistent heading pattern | Starts with `# Create Skill Pipeline` (h1 heading) |
| `deploy-workflow.md` | Consistent pattern | Starts with `Usage: /deploy-workflow [project-name]` (usage line) |
| `new-project.md` | Consistent pattern | Starts with `# /new-project — Project Pipeline Orchestrator` (h1 heading) |

Commands use varied opening patterns (plain prose, h1 heading, usage line, YAML frontmatter). No single enforced pattern exists.

Section summary: 1 issue flagged (format inconsistency across commands, no enforced standard) / no previous audit for delta.

---

### 4.3 Skill Template Comparison

**5 most recently modified skills:** `worktree-cleanup-investigator` (2026-04-18), `ai-prose-decontamination` (2026-04-17), `formatting-qc` (2026-04-17), `h3-title-pass` (2026-04-17), `architecture-designer` (2026-04-17).

All 5 have: YAML frontmatter with `name:` and `description:`, a body with `##` section headings, explicit role and scope definitions.

**ai-resource-builder template last modified:** 2026-04-06 (failure behavior section added).

**40 skills with creation date predating 2026-04-06 template update:**

analysis-pass-memo-review (2026-03-22), answer-spec-generator (2026-03-26), answer-spec-qc (2026-03-22), chapter-prose-reviewer (2026-03-29), chapter-review (2026-04-03), citation-converter (2026-03-22), claude-code-workflow-builder (2026-02-21), cluster-analysis-pass (2026-03-29), cluster-memo-refiner (2026-03-29), cluster-synthesis-drafter (2026-03-22), context-pack-builder (2026-02-20), curiosity-hub-article-writer (2026-02-20), document-integration-qc (2026-03-22), editorial-recommendations-generator (2026-03-26), editorial-recommendations-qc (2026-03-26), evidence-prose-fixer (2026-03-22), evidence-spec-verifier (2026-03-22), evidence-to-report-writer (2026-03-29), execution-manifest-creator (2026-03-27), gap-assessment-gate (2026-03-22), implementation-spec-writer (2026-04-03), journal-thinking-clarifier (2026-02-21), journal-wiki-creator (2026-02-21), journal-wiki-improver (2026-02-21), journal-wiki-integrator (2026-02-21), knowledge-file-completeness-qc (2026-04-04), knowledge-file-producer (2026-04-03), project-implementer (2026-04-03), research-extract-creator (2026-03-25), research-extract-verifier (2026-03-24), research-plan-creator (2026-03-24), research-prompt-creator (2026-03-29), research-prompt-qc (2026-03-29), specifying-output-style (2026-03-22), task-plan-creator (2026-03-22), workflow-consultant (2026-02-20), workflow-creator (2026-02-20), workflow-documenter (2026-02-20), workflow-evaluator (2026-04-05), workspace-template-extractor (2026-03-31).

Spot-checks confirm some of these pre-template skills are missing the "Failure Behavior" section: `cluster-synthesis-drafter` (0 failure mentions), `gap-assessment-gate` (0 failure mentions). Others have it: `evidence-spec-verifier` (4 mentions). Conformance is non-uniform across the 40 pre-template skills.

Section summary: 2 issues flagged (pre-template skills, variable conformance) / no previous audit for delta.

---

### 4.4 Naming Convention Inconsistencies

**One naming inconsistency found:**

| Item | Convention | Deviation |
|---|---|---|
| `skills/CATALOG.md` | All files under `skills/` are expected to be in per-skill subdirectories | `CATALOG.md` is a flat file at `skills/` root, not in a subdirectory |
| All 67 skill directories | Lowercase-hyphenated names | All comply |
| All 29 commands | Lowercase-hyphenated `.md` names | All comply |
| All 21 agents | Lowercase-hyphenated `.md` names | All comply |

Section summary: 1 issue flagged / no previous audit for delta.

---

### 4.5 Directory Structure Violations

**CLAUDE.md-declared structure:**

| Directory | Declared Purpose | Actual State |
|---|---|---|
| `skills/` | Canonical skill library | Contains 67 skill dirs + `CATALOG.md` (flat file) + `.gitkeep` |
| `prompts/` | Standalone prompts for cross-tool workflows | Contains `supplementary-research/` subdirectory only |
| `reports/` | Generated audit and health reports | Contains `repo-health-report.md` only |
| `logs/` | Session notes, decisions, innovation registry | Contains 6 files (coaching-data, decisions, friction-log, improvement-log, innovation-registry, session-notes). Missing: `coaching-log.md`, `workflow-observations.md` (referenced by commands) |
| `audits/` | Due diligence and audit artifacts | Contains 13 report files + `working/` subdirectory with 22 working-notes files + `questionnaire.md` |
| `docs/` | Process documentation | Contains `operator-principles.md` and `session-rituals.md` |
| `scripts/` | Utility scripts for repo maintenance | Contains `repo-audit.sh` and `skill-inventory.sh` |
| `style-references/` | Style reference materials | Contains `internal-material.md` only |
| `usage/` | Not declared in CLAUDE.md | Contains `usage-log.md`. Directory exists and is referenced by commands/CLAUDE.md but not listed in "What This Repo Contains" section |
| `inbox/` | Intake queue for resource briefs | Contains 2 active briefs + `archive/` subdirectory + `.gitkeep` |
| `workflows/` | Deployable workflow templates | Contains `research-workflow/` template only |

**Violations:**
1. `usage/` directory is not listed in the CLAUDE.md "What This Repo Contains" section, despite being a documented, referenced directory.
2. `logs/coaching-log.md` referenced by `/coach` command does not exist.
3. `logs/workflow-observations.md` referenced by `/note` command does not exist.

Section summary: 3 issues flagged / no previous audit for delta.

---

### 4.6 Command Syntax and File Path Resolution Check

| Command | Syntax Valid | All Referenced Paths Resolve |
|---|---|---|
| analyze-workflow | Y | Y (uses template variables like `{AI_RESOURCES}`) |
| audit-repo | Y | Conditional — `reference/skills/repo-health-analyzer/agents/` resolves in deployed projects but not in ai-resources itself |
| clarify | Y | Y |
| cleanup-worktree | Y | Y (`skills/worktree-cleanup-investigator/SKILL.md` exists; `scripts/find-template.sh` exists in skill bundle) |
| coach | Y | Partial — `logs/coaching-log.md` does not exist (created on first run) |
| create-skill | Y | Y |
| deploy-workflow | Y | Y (auto-sync-shared.sh and check-template-drift.sh exist) |
| friction-log | Y | Y |
| graduate-resource | Y | Y |
| improve-skill | Y | Y |
| improve | Y | Y |
| migrate-skill | Y | Y |
| new-project | Y | Y (all referenced agent files exist) |
| note | Y | Partial — `logs/workflow-observations.md` does not exist (created on first run) |
| prime | Y | Y |
| project-consultant | Y | All referenced paths are workspace-relative (outside AUDIT_ROOT scope) |
| qc-pass | Y | Y |
| refinement-deep | Y | Y |
| refinement-pass | Y | Y |
| repo-dd | Y | Y (questionnaire.md exists; log sweep targets coaching-log.md and workflow-observations.md are missing but repo-dd treats them as optional) |
| request-skill | Y | Y |
| scope | Y | Y |
| session-guide | Y | Y |
| sync-workflow | Y | Y (project-relative paths for deployed contexts) |
| token-audit | Y | Y |
| triage | Y | Y |
| update-claude-md | Y | Y |
| usage-analysis | Y | Y |
| wrap-session | Y | Y |

Section summary: 2 issues flagged (audit-repo context-dependent path, 2 missing log file targets) / no previous audit for delta.

---

### 4.7 Duplicate or Built-in Command Name Conflicts

No duplicate command names found among the 29 commands.

Known Claude Code built-ins checked: `/clear`, `/compact`, `/help`, `/exit`, `/quit`, `/memory`, `/config`, `/add-dir`. None of the 29 commands match these names.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 4.8 Agent Model Tier Compliance

Compared against Agent Tier Table in workspace CLAUDE.md → "Model Tier" → "Agents" (as of 2026-04-18):

| Agent File | Declared Tier | Expected Tier (Table) | Status |
|---|---|---|---|
| collaboration-coach.md | opus | opus | Match |
| dd-extract-agent.md | haiku | haiku | Match |
| dd-log-sweep-agent.md | haiku | haiku | Match |
| execution-agent.md | sonnet | sonnet | Match |
| improvement-analyst.md | opus | opus | Match |
| pipeline-stage-2-5.md | opus | opus | Match |
| pipeline-stage-2.md | opus | opus | Match |
| pipeline-stage-3a.md | sonnet | sonnet | Match |
| pipeline-stage-3b.md | opus | opus | Match |
| pipeline-stage-3c.md | opus | opus | Match |
| pipeline-stage-4.md | inherit | inherit | Match — table notes "Candidate: declare sonnet (deferred 2026-04-18)" |
| pipeline-stage-5.md | sonnet | sonnet | Match |
| qc-reviewer.md | opus | opus | Match |
| refinement-reviewer.md | opus | opus | Match |
| repo-dd-auditor.md | sonnet | sonnet | Match |
| session-guide-generator.md | sonnet | sonnet | Match |
| token-audit-auditor-mechanical.md | haiku | haiku | Match |
| token-audit-auditor.md | opus | opus | Match |
| triage-reviewer.md | opus | opus | Match |
| workflow-analysis-agent.md | opus | opus | Match |
| workflow-critique-agent.md | opus | opus | Match |

All 21 agents are in the table. All declared tiers match the table. `pipeline-stage-4` remains at `inherit` per the deferred migration noted in the table.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 4.9 Project Settings Comparison Against Canonical Baseline

N/A — no `projects/` directory exists within AUDIT_ROOT (`ai-resources`). Projects reside at the workspace level (`/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/`), which is outside AUDIT_ROOT scope.

Section summary: N/A — out of scope for ai-resources repo.

---

## Section 5: Context Load

### 5.1 Context Load at Session Start

When a new session starts in the `ai-resources` repo, the following files are auto-loaded:

| File | Line Count | Load Mechanism |
|---|---|---|
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (workspace) | 282 lines | Loaded because workspace root is in `additionalDirectories` (`~/.claude/settings.json`) |
| `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (project) | 83 lines | Loaded as project CLAUDE.md |

**Estimated total context at session start: ~365 lines** (two CLAUDE.md files). No other files are auto-loaded via settings.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command or Hook

| Section | Approximate Lines | Assessment |
|---|---|---|
| What This Repo Contains | 14 | Orienting context only. Not directly invoked by any command. Describes directory layout. |
| How I Work | 3 | Identity/working style context. Not referenced by commands. |
| General Session Rules | 5 | Behavioral rules (don't create unrequested files, complete tasks before extensions, pull latest). Not referenced by any specific command. |
| Session Boundaries | 3 | Referenced as a canonical block in `/new-project` (for project CLAUDE.md content). Also a behavioral rule for the operator. |

The "What This Repo Contains", "How I Work", and "General Session Rules" sections are not referenced or invoked by any command or hook. They load on every turn as context overhead.

Section summary: 3 sections identified as unreferenced by commands/hooks / no previous audit for delta.

---

### 5.3 CLAUDE.md Line Count History (Last 5 Modifying Commits)

| Commit Hash | Date | Line Count |
|---|---|---|
| b66e5ee | 2026-04-18 | 83 lines |
| 9d3cecc | 2026-04-18 | 83 lines |
| c2ec47c | 2026-04-18 | 92 lines |
| 5b4ab39 | 2026-04-18 | 92 lines |
| 4cdb9a4 | 2026-04-18 | 74 lines |

All 5 modifying commits are from 2026-04-18. The file grew from 74 → 92 lines (additions from new sections), then was trimmed to 83 lines (skill-chain content removed per R13 closeout per commit `9d3cecc`).

Section summary: 0 issues flagged / no previous audit for delta.

---

## Section 6: Drift & Staleness

### 6.1 Files Not Modified in Last 90 Days But Referenced by Active Commands

90-day cutoff: 2026-01-17. Checked all files referenced by commands.

All script files under `scripts/` (last modified 2026-02-20) and `.claude/hooks/` are more recent than the 90-day cutoff. All `skills/` SKILL.md files are more recent than 2026-01-17 (oldest found was `context-pack-builder` at 2026-02-20). All reference/template files are more recent.

None found — checked all command-referenced files. The oldest references found (`claude-code-workflow-builder/references/feature-patterns.md` at 2026-02-21, `context-pack-builder/SKILL.md` at 2026-02-20) are within 90 days of 2026-04-18.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 6.2 TODO, FIXME, PLACEHOLDER Marker Comments

| File | Line | Marker | Context |
|---|---|---|---|
| `.claude/commands/new-project.md` | 262 | "placeholder" | In prose context: "generic placeholder if absent" — describing behavior, not a marker in the code |
| `.claude/commands/repo-dd.md` | 286 | "placeholder" | "SETUP.md exists and contains placeholder definitions" — describing check for placeholder presence, not a task marker |
| `.claude/commands/repo-dd.md` | 298 | "placeholder" | "Replace the Section 4 placeholder with the pipeline testing results" — operational instruction in the command |
| `.claude/commands/deploy-workflow.md` | Multiple | "placeholder" | All occurrences are in the context of `{{PLACEHOLDER}}` substitution instructions — operational content, not task markers |
| `skills/implementation-spec-writer/SKILL.md` | 50, 254, 257 | "PLACEHOLDER" | In context of `{{PLACEHOLDER}}` markers for template substitution — operational content |
| `skills/workflow-evaluator/SKILL.md` | 312 | "TODO" | "do not penalize TODO sections" — refers to workflow content under evaluation, not a task marker in the skill itself |
| `skills/workspace-template-extractor/SKILL.md` | 31, 100 | "placeholder" | In context of `{{PLACEHOLDER}}` markers — operational content |
| `workflows/research-workflow/SETUP.md` | 26, 135 | "PLACEHOLDER" | In context of `{{PLACEHOLDER}}` substitution instructions — operational content |

No file contains standalone `TODO:`, `FIXME:`, or `PLACEHOLDER:` markers indicating incomplete or deferred work. All occurrences are in operational content describing behavior or substitution patterns.

Section summary: 0 issues flagged / no previous audit for delta.

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

| File | State |
|---|---|
| `skills/.gitkeep` | Empty placeholder file — intentional |
| `inbox/.gitkeep` | Empty placeholder file — intentional |
| `workflows/research-workflow/**/.gitkeep` (multiple) | Empty placeholder files — intentional, preserve directory structure in git |
| `workflows/research-workflow/usage/.gitkeep` | Empty placeholder — intentional |
| `workflows/research-workflow/logs/.gitkeep` | Empty placeholder — intentional |

All empty files are `.gitkeep` files used to preserve directory structure. No stub SKILL.md files or boilerplate-only content files found.

Section summary: 0 issues flagged / no previous audit for delta.

---

## Audit Summary

**Total findings: 19**

| Category | Count |
|---|---|
| Discrepancy (item exists but is inconsistent with spec or another item) | 6 |
| Missing item (referenced file or content that does not exist) | 5 |
| Violation (rule or convention defined and not followed) | 5 |
| Clean check (no issues found) | 3 |

**Findings by section:**

| Section | Finding | Type |
|---|---|---|
| 2.3 | CLAUDE.md contradiction: "Git Rules" line 56 ("always show diff before committing") vs "Commit Rules" line 66 ("commit directly, do not ask permission") | Discrepancy |
| 2.4 | CATALOG.md out of date: 7 skills created after 2026-04-06 not listed | Missing item |
| 2.4 | `skills/repo-health-analyzer/` contains `command.md` and `agents/` subdir — non-standard skill directory structure | Violation |
| 2.5 | `logs/workflow-observations.md` does not exist; referenced by `/note` command | Missing item |
| 2.5 | `logs/coaching-log.md` does not exist; referenced by `/coach` command and `repo-dd` log sweep | Missing item |
| 3.1 | `audit-repo` references `reference/skills/repo-health-analyzer/agents/` — resolves in deployed projects but not in ai-resources itself | Discrepancy |
| 4.1 | 40 skills predate 2026-04-06 template update; conformance to "Failure Behavior" section is non-uniform | Discrepancy |
| 4.1 | 8 skills exceed 300-line convention: answer-spec-generator (485), ai-prose-decontamination (484), research-plan-creator (464), ai-resource-builder (463), evidence-to-report-writer (332), prose-compliance-qc (330), session-guide-generator (320), workflow-evaluator (316) | Violation |
| 4.2 | Commands use varied opening patterns (no enforced format standard) | Discrepancy |
| 4.4 | `skills/CATALOG.md` is a flat file at `skills/` root, not in a subdirectory | Violation |
| 4.5 | `usage/` directory not listed in CLAUDE.md "What This Repo Contains" section | Violation |
| 4.7 | No duplicate or built-in command conflicts | Clean check |
| 4.8 | All 21 agents match the Agent Tier Table | Clean check |
| 5.2 | "What This Repo Contains", "How I Work", "General Session Rules" sections not referenced by any command/hook — load context overhead on every turn | Discrepancy |
| 6.1 | No stale referenced files found | Clean check |
| 6.2 | No task-marker TODO/FIXME/PLACEHOLDER comments found | Clean check (noted above) |
| 6.3 | No empty stub files beyond intentional .gitkeep | Clean check |

**Previous audit:** None — no delta notes applicable.
