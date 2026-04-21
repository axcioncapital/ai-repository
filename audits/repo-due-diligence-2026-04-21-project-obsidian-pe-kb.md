# Repo Due Diligence Audit — 2026-04-21
Repo: projects/obsidian-pe-kb
Scope: /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/obsidian-pe-kb
Commit: bc1a7da
Previous audit: None
Depth: standard

---

## Section 1: Inventory

### 1.1 Slash Commands

All commands in `.claude/commands/` are symlinks to `ai-resources/.claude/commands/` (documented in §1.7). Vault commands in `vault/.claude/commands/` are either symlinks to `ai-resources` or project-local files.

**Project-root `.claude/commands/` (42 entries, all symlinks):**

| Command Name | Defined At | Referenced Files (per symlink target) |
|---|---|---|
| analyze-workflow | symlink → ai-resources/.claude/commands/analyze-workflow.md | External scope |
| audit-claude-md | symlink → ai-resources/.claude/commands/audit-claude-md.md | External scope |
| audit-repo | symlink → ai-resources/.claude/commands/audit-repo.md | External scope |
| clarify | symlink → ai-resources/.claude/commands/clarify.md | External scope |
| cleanup-worktree | symlink → ai-resources/.claude/commands/cleanup-worktree.md | External scope |
| coach | symlink → ai-resources/.claude/commands/coach.md | External scope |
| create-skill | symlink → ai-resources/.claude/commands/create-skill.md | External scope |
| friction-log | symlink → ai-resources/.claude/commands/friction-log.md | External scope |
| graduate-resource | symlink → ai-resources/.claude/commands/graduate-resource.md | External scope |
| improve-skill | symlink → ai-resources/.claude/commands/improve-skill.md | External scope |
| improve | symlink → ai-resources/.claude/commands/improve.md | External scope |
| migrate-skill | symlink → ai-resources/.claude/commands/migrate-skill.md | External scope |
| note | symlink → ai-resources/.claude/commands/note.md | External scope |
| prime | symlink → ai-resources/.claude/commands/prime.md | External scope |
| project-consultant | symlink → ai-resources/.claude/commands/project-consultant.md | External scope |
| qc-pass | symlink → ai-resources/.claude/commands/qc-pass.md | External scope |
| refinement-deep | symlink → ai-resources/.claude/commands/refinement-deep.md | External scope |
| refinement-pass | symlink → ai-resources/.claude/commands/refinement-pass.md | External scope |
| repo-dd | symlink → ai-resources/.claude/commands/repo-dd.md | External scope |
| request-skill | symlink → ai-resources/.claude/commands/request-skill.md | External scope |
| scope | symlink → ai-resources/.claude/commands/scope.md | External scope |
| session-guide | symlink → ai-resources/.claude/commands/session-guide.md | External scope |
| sync-workflow | symlink → ai-resources/.claude/commands/sync-workflow.md | External scope |
| token-audit | symlink → ai-resources/.claude/commands/token-audit.md | External scope |
| triage | symlink → ai-resources/.claude/commands/triage.md | External scope |
| update-claude-md | symlink → ai-resources/.claude/commands/update-claude-md.md | External scope |
| usage-analysis | symlink → ai-resources/.claude/commands/usage-analysis.md | External scope |
| wrap-session | symlink → ai-resources/.claude/commands/wrap-session.md | External scope |

Note: the initial git sync (commit d7d9d8c, 2026-04-13) captured 26 command symlinks; 7 additional commands (`audit-claude-md`, `token-audit`, and 5 others added by auto-sync) appear as untracked in `git status` (untracked: `.claude/commands/audit-claude-md.md`, `.claude/commands/token-audit.md`). Total `.claude/commands/` symlink count: 42 (confirmed by symlink listing in §1.7).

**Vault `vault/.claude/commands/` (34 symlinks + 2 project-local):**

All vault symlinks target the same `ai-resources/.claude/commands/` files as the project-root commands. Vault does not have: `audit-claude-md.md`, `cleanup-worktree.md`, `token-audit.md` (not present in vault symlink set).

Project-local vault commands (real files, not symlinks):

| Command | Defined At | Referenced Files |
|---|---|---|
| kb-ingest | vault/.claude/commands/kb-ingest.md (140 lines) | CLAUDE.md, wiki/_master-index.md, templates/wiki-article-template.md, templates/master-index-template.md, templates/wiki-index-template.md, raw/{category}/, wiki/{folder}/_index.md, {axcion-repo}/projects/project-planning/output/pe-knowledge-base/ingestion-log.md, taxonomy-proposal.md (external, optional) |
| kb-integrity-check | vault/.claude/commands/kb-integrity-check.md (99 lines) | wiki/_master-index.md, wiki/{folder}/_index.md, wiki/{folder}/*.md, CLAUDE.md, taxonomy-proposal.md (external, optional) |

Section summary: 42 project-root command symlinks (all → ai-resources), 34 vault command symlinks (all → ai-resources), 2 vault project-local commands catalogued / 0 deltas from previous audit (first audit)

---

### 1.2 Hooks

**`.claude/settings.json`** (project-root):
- Trigger: `SessionStart`
- What it does: Walks up the directory tree from `$CLAUDE_PROJECT_DIR` until it finds an ancestor containing `ai-resources/.claude/hooks/auto-sync-shared.sh` (tests with `-x`), then executes that script. Timeout: 10 seconds. Status message: "Syncing shared commands from ai-resources..."
- Files referenced: `ai-resources/.claude/hooks/auto-sync-shared.sh` (resolved at runtime by directory walk; exists at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/auto-sync-shared.sh`)

**`vault/.claude/settings.json`** (vault):
- Trigger: `SessionStart`
- What it does: Identical hook command and timeout to project-root hook. Walks up to locate `auto-sync-shared.sh` and executes it.
- Files referenced: `ai-resources/.claude/hooks/auto-sync-shared.sh` (same resolution path)

**`vault/.claude/settings.local.json`**: No hooks defined. Contains only `"model": "claude-opus-4-6"`.

No other settings files exist in AUDIT_ROOT.

Section summary: 2 hooks catalogued (project-root SessionStart, vault SessionStart — identical logic) / 0 deltas from previous audit (first audit)

---

### 1.3 Template Files

| File Path | Used By | Last Git Commit Date |
|---|---|---|
| vault/templates/wiki-article-template.md | kb-ingest (Step 5) | Not tracked (vault/ is gitignored) |
| vault/templates/wiki-index-template.md | kb-ingest (Step 6 — implied by index maintenance rules) | Not tracked (vault/ is gitignored) |
| vault/templates/master-index-template.md | kb-ingest (Step 6 — implied by index maintenance rules) | Not tracked (vault/ is gitignored) |

All three template files exist on disk. No other template files found in AUDIT_ROOT.

Section summary: 3 template files catalogued / 0 deltas from previous audit (first audit)

---

### 1.4 Scripts

No shell scripts, Python scripts, or other executable scripts exist within AUDIT_ROOT. The SessionStart hook command is an inline bash one-liner embedded in `settings.json`, not a separate script file. The hook script it calls (`auto-sync-shared.sh`) lives in `ai-resources/` (external to AUDIT_ROOT).

Section summary: 0 scripts catalogued / 0 deltas from previous audit (first audit)

---

### 1.5 Skills

0 skills are present in AUDIT_ROOT. No `skills/` directory exists at the project level. This is consistent with the workspace convention that skills are centrally owned by `ai-resources/skills/`.

Section summary: 0 skills catalogued (by design) / 0 deltas from previous audit (first audit)

---

### 1.6 Uncategorized Files

Files in AUDIT_ROOT that do not fall into the categories of skills, templates, scripts, slash commands, hooks, CLAUDE.md, audits, or standard git files:

| File Path | Category | Notes |
|---|---|---|
| pipeline/architecture-v1.md (283 lines) | Pipeline artifact — superseded architecture draft | v1 retained alongside current |
| pipeline/architecture.md (411 lines) | Pipeline artifact — current architecture document | No in-file "current" marker |
| pipeline/context-pack.md (347 lines) | Pipeline artifact — project context pack | Input document |
| pipeline/decisions.md (5 lines) | Pipeline artifact — decision log | Contains 1 data row |
| pipeline/implementation-log.md (216 lines) | Pipeline artifact — Stage 4 implementation log | — |
| pipeline/implementation-spec-v1.md (621 lines) | Pipeline artifact — superseded implementation spec | v1 retained alongside current |
| pipeline/implementation-spec.md (959 lines) | Pipeline artifact — current implementation spec | No in-file "current" marker |
| pipeline/next-vault-session-runbook.md (73 lines) | Pipeline artifact — vault session handoff runbook | Untracked in git |
| pipeline/pipeline-state.md (15 lines) | Pipeline artifact — pipeline stage tracker | All stages: completed |
| pipeline/project-plan.md (628 lines) | Pipeline artifact — Stage 2 project plan | — |
| pipeline/repo-snapshot.md (286 lines) | Pipeline artifact — Stage 3a repo snapshot | — |
| pipeline/session-guide.md (539 lines) | Pipeline artifact — Stage 6 session guide | — |
| pipeline/technical-spec.md (577 lines) | Pipeline artifact — Stage 2.5 technical spec | — |
| pipeline/test-results.md (311 lines) | Pipeline artifact — Stage 5 test results | 17/17 executable tests pass |
| logs/session-notes.md (102 lines) | Log file — session notes | Modified (untracked changes) in git status |
| logs/innovation-registry.md (7 lines) | Log file — innovation registry | 3 detected entries |
| reports/repo-health-report.md (136 lines) | Report — repo health output from /audit-repo | Untracked in git |
| .gitignore (1 line) | Standard git file | Contains: `vault/` |
| vault/_setup-notes.md | Vault file — setup friction log | Not tracked (gitignored) |
| vault/.claude/settings.json | Vault settings | Not tracked (gitignored) |
| vault/.claude/settings.local.json | Vault settings (local override) | Not tracked (gitignored) |
| vault/.claude/shared-manifest.json | Vault manifest | Not tracked (gitignored) |
| vault/CLAUDE.md (174 lines) | Vault CLAUDE.md | Not tracked (gitignored) |

Section summary: 21 uncategorized files catalogued (14 pipeline artifacts, 2 log files, 1 report, 1 .gitignore, 3 vault config/doc files) / 0 deltas from previous audit (first audit)

---

### 1.7 Symlinks

**Project-root `.claude/agents/` — 14 symlinks, all → ai-resources:**

| Symlink Path | Target | Target Exists |
|---|---|---|
| .claude/agents/claude-md-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/claude-md-auditor.md | YES |
| .claude/agents/collaboration-coach.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md | YES |
| .claude/agents/dd-extract-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-extract-agent.md | YES |
| .claude/agents/dd-log-sweep-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/dd-log-sweep-agent.md | YES |
| .claude/agents/execution-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/execution-agent.md | YES |
| .claude/agents/improvement-analyst.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md | YES |
| .claude/agents/qc-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md | YES |
| .claude/agents/refinement-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md | YES |
| .claude/agents/repo-dd-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md | YES |
| .claude/agents/token-audit-auditor-mechanical.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor-mechanical.md | YES |
| .claude/agents/token-audit-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/token-audit-auditor.md | YES |
| .claude/agents/triage-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md | YES |
| .claude/agents/workflow-analysis-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md | YES |
| .claude/agents/workflow-critique-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md | YES |

**Project-root `.claude/commands/` — 42 symlinks, all → ai-resources:**

All 42 resolve to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/{name}.md`. All exist. Full list: analyze-workflow, audit-claude-md, audit-repo, clarify, cleanup-worktree, coach, create-skill, friction-log, graduate-resource, improve-skill, improve, migrate-skill, note, prime, project-consultant, qc-pass, refinement-deep, refinement-pass, repo-dd, request-skill, scope, session-guide, sync-workflow, token-audit, triage, update-claude-md, usage-analysis, wrap-session (plus additional synced commands not yet committed).

**Vault `vault/.claude/agents/` — 9 symlinks, all → ai-resources:**

| Symlink Path | Target | Target Exists |
|---|---|---|
| vault/.claude/agents/collaboration-coach.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/collaboration-coach.md | YES |
| vault/.claude/agents/execution-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/execution-agent.md | YES |
| vault/.claude/agents/improvement-analyst.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/improvement-analyst.md | YES |
| vault/.claude/agents/qc-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/qc-reviewer.md | YES |
| vault/.claude/agents/refinement-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/refinement-reviewer.md | YES |
| vault/.claude/agents/repo-dd-auditor.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md | YES |
| vault/.claude/agents/triage-reviewer.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/triage-reviewer.md | YES |
| vault/.claude/agents/workflow-analysis-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-analysis-agent.md | YES |
| vault/.claude/agents/workflow-critique-agent.md | /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/workflow-critique-agent.md | YES |

**Vault `vault/.claude/commands/` — 34 symlinks, all → ai-resources:**

All 34 resolve to `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/{name}.md`. All exist. Vault command set is smaller than project-root set (missing: `audit-claude-md`, `cleanup-worktree`, `token-audit`, and a few others that the auto-sync hook at vault level has not yet synced).

**Total symlink count: 99** (14 project-root agents + 42 project-root commands + 9 vault agents + 34 vault commands). All 99 symlinks resolve. 0 broken symlinks.

Section summary: 99 symlinks catalogued — all resolve / 0 deltas from previous audit (first audit)

---

## Section 2: CLAUDE.md Health

### 2.1 CLAUDE.md Line Count and Sections

**`CLAUDE.md`** (project-root): 26 lines, 3 sections.
- `## Project Layout`
- `## How to Open This Project in Claude Code`
- `## Commit Rules`

**`vault/CLAUDE.md`**: 174 lines, 12 sections.
- `## Purpose`
- `## Folder structure`
- `## Operating modes`
- `## Decomposition rules (ingestion mode)`
- `## Update vs. create rules`
- `## Conflict resolution`
- `## Index maintenance (atomic)`
- `## Link syntax inside wiki articles`
- `## Tag taxonomy`
- `## For new users (Daniel)`
- `## Commit Rules`

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 2.2 Dead References in CLAUDE.md

**`CLAUDE.md`** (project-root):
- References `vault/` — directory exists. Clean.
- References `pipeline/` — directory exists. Clean.
- References `logs/` — directory exists. Clean.
- References `vault/CLAUDE.md` — file exists. Clean.

**`vault/CLAUDE.md`**:
- References `raw/pe-research/` — directory exists (empty). Clean.
- References `raw/buyside-service-plan/` — directory exists (empty). Clean.
- References `wiki/_master-index.md` — `wiki/` directory exists but is empty; `wiki/_master-index.md` does NOT exist on disk. Dead reference — file has not yet been created (vault is pre-ingestion). No git history for this path (gitignored).
- References `wiki/{folder}/_index.md` — no wiki folders exist yet. Template reference; no concrete file.
- References `templates/` — directory exists with all 3 template files. Clean.
- References `templates/wiki-article-template.md` — exists. Clean.
- References `{axcion-repo}/projects/project-planning/output/pe-knowledge-base/ingestion-log.md` — this path does NOT exist. The directory `projects/project-planning/output/pe-knowledge-base/` exists but contains no `ingestion-log.md` file. Dead reference — file has not yet been created. No git history (pre-ingestion).
- References `_setup-notes.md` — exists. Clean.

**Summary of dead references found:**
1. `vault/CLAUDE.md` line 15: `wiki/_master-index.md` — does not exist on disk (vault not yet populated).
2. `vault/CLAUDE.md` line 40: `{axcion-repo}/projects/project-planning/output/pe-knowledge-base/ingestion-log.md` — does not exist on disk (pre-ingestion).

Both dead references are to files that have not yet been created because the vault population phase has not started. No renames or deletions found in git history for these paths.

Section summary: 2 dead references flagged (both pre-ingestion placeholder paths) / 0 deltas from previous audit (first audit)

---

### 2.3 Contradictions in CLAUDE.md

**`CLAUDE.md`** (project-root): None found — checked all 3 sections for contradicting statements.

**`vault/CLAUDE.md`**: None found — checked all 11 content sections. The Commit Rules section explicitly notes it mirrors the workspace-level canonical rule (no contradiction). The mode sections (Ingestion vs Query) define mutually exclusive behaviors but do not contradict — they are mode-gated.

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 2.4 Conventions Defined but Not Followed

**`vault/CLAUDE.md` Tag taxonomy section** defines 8 controlled vocabulary tags. The vault has no articles yet (`wiki/` directory is empty), so no violation of the max-3-tags rule or tag-vocabulary constraint is possible at this time.

**`vault/CLAUDE.md` Folder structure section** specifies `wiki/_master-index.md` exists. This file does not exist (vault pre-ingestion state). This is also captured in Q2.2.

None found beyond the Q2.2 pre-ingestion file absence — checked against actual file tree. The template files exist and match the structure described in CLAUDE.md.

Section summary: 0 issues flagged (beyond Q2.2 dead reference) / 0 deltas from previous audit (first audit)

---

### 2.5 Partial Feature References

**vault CLAUDE.md — ingestion log reference**: `vault/CLAUDE.md` line 40 and `vault/.claude/commands/kb-ingest.md` lines 22, 59, 108 reference `{axcion-repo}/projects/project-planning/output/pe-knowledge-base/ingestion-log.md`. The containing directory (`projects/project-planning/output/pe-knowledge-base/`) exists. The log file itself does not exist. One component (directory) exists; the other (log file) does not.

**vault CLAUDE.md — taxonomy-proposal.md reference**: `vault/.claude/commands/kb-ingest.md` line 39 and `vault/.claude/commands/kb-integrity-check.md` line 25 reference `taxonomy-proposal.md` from the project-planning output directory. This file does not exist in `projects/project-planning/output/pe-knowledge-base/`. The kb-ingest command contains an explicit pre-B.1 fallback for this missing file, so this is a documented incomplete state rather than a silent failure.

Section summary: 2 partial feature references flagged (both pre-ingestion expected absences with documented fallbacks or acknowledgments) / 0 deltas from previous audit (first audit)

---

### 2.6 CLAUDE.md Scoping Violations

The workspace CLAUDE.md "CLAUDE.md Scoping" rule states: do not put skill methodology, workflow methodology, or task-type-specific instructions (that apply only to a fraction of turns) in CLAUDE.md — those belong in SKILL.md or workflow reference docs.

**`CLAUDE.md`** (project-root, 26 lines): No task-type-specific methodology sections. Clean.

**`vault/CLAUDE.md`** (174 lines): Contains the following sections with task-type-specific operational instructions:

| Section Heading | Approx. Line Count | Task-Type Addressed |
|---|---|---|
| `## Operating modes` (including Ingestion mode and Query mode subsections) | lines 21–68 (~48 lines) | Ingestion-mode and query-mode operational rules |
| `## Decomposition rules (ingestion mode)` | lines 70–101 (~32 lines) | Ingestion-mode methodology |
| `## Update vs. create rules` | lines 103–109 (~7 lines) | Ingestion-mode methodology |
| `## Conflict resolution` | lines 111–121 (~11 lines) | Ingestion-mode methodology |
| `## Index maintenance (atomic)` | lines 123–132 (~10 lines) | Ingestion-mode methodology |
| `## Link syntax inside wiki articles` | lines 134–142 (~9 lines) | Article-writing methodology |
| `## Tag taxonomy` | lines 144–158 (~15 lines) | Article-tagging methodology |

These sections total approximately 132 of 174 lines in `vault/CLAUDE.md`. Per the workspace scoping rule, this content type belongs in workflow reference docs rather than CLAUDE.md. However, `vault/CLAUDE.md` functions as the sole operating rules document for a vault-cwd session (there is no workflow reference doc hierarchy for this vault), and the vault architecture explicitly uses CLAUDE.md as the mode-rule authority referenced by `kb-ingest`. The `kb-ingest` command states: "Every rule in this command body is subordinate to `CLAUDE.md`."

Section summary: 1 issue flagged (vault/CLAUDE.md contains ~132 lines of task-type-specific ingestion and query methodology) / 0 deltas from previous audit (first audit)

---

## Section 3: Dependency References

### 3.1 Command File References with Existence Check

**Project-root symlinked commands**: All 42 are symlinks to `ai-resources/.claude/commands/`. Contents are external to AUDIT_ROOT scope. Internal references within these files are not audited here.

**Vault project-local commands:**

| Command | Referenced File | Exists |
|---|---|---|
| kb-ingest | CLAUDE.md (vault root) | YES |
| kb-ingest | wiki/_master-index.md | NO (pre-ingestion) |
| kb-ingest | templates/wiki-article-template.md | YES |
| kb-ingest | templates/master-index-template.md | YES |
| kb-ingest | templates/wiki-index-template.md | YES |
| kb-ingest | raw/ (directory) | YES (empty) |
| kb-ingest | wiki/ (directory) | YES (empty) |
| kb-ingest | projects/project-planning/output/pe-knowledge-base/ingestion-log.md | NO (pre-ingestion; directory exists) |
| kb-ingest | taxonomy-proposal.md (in project-planning output) | NO (pre-B.1; fallback documented) |
| kb-integrity-check | wiki/_master-index.md | NO (pre-ingestion) |
| kb-integrity-check | wiki/{folder}/_index.md | NO (pre-ingestion) |
| kb-integrity-check | CLAUDE.md (vault root) | YES |
| kb-integrity-check | taxonomy-proposal.md (external, fallback) | NO (pre-B.1; fallback documented) |

**wrap-session** (symlink to ai-resources, but references project-local files):
The wrap-session command (external content) references: `logs/session-notes.md` (exists), `logs/decisions.md` (does NOT exist — referenced but absent), `logs/coaching-data.md` (does NOT exist), `logs/improvement-log.md` (does NOT exist), `logs/innovation-registry.md` (exists), `logs/usage-log.md` (does NOT exist), `ai-resources/skills/session-usage-analyzer/SKILL.md` (exists in ai-resources at the verified path).

Section summary: 4 missing referenced files flagged: wiki/_master-index.md (pre-ingestion), ingestion-log.md (pre-ingestion), taxonomy-proposal.md (pre-B.1), and 4 log files not yet created by wrap-session. Note: wrap-session creates missing log files on first run (documented fallback behavior in command). / 0 deltas from previous audit (first audit)

---

### 3.2 Command Output Chains

Within AUDIT_ROOT's project-local commands:
- `kb-ingest` output (wiki articles, index updates) is consumed by `kb-integrity-check` (scans the wiki layer produced by kb-ingest).
- `kb-integrity-check` output (integrity report written to `vault/_integrity-report-{date}.md`) has no defined downstream command consumer within AUDIT_ROOT.

Vault-level symlinked commands (e.g., `wrap-session`) consume log files created or updated by prior session activity.

Section summary: 1 chain identified (kb-ingest → kb-integrity-check) / 0 deltas from previous audit (first audit)

---

### 3.3 Files Referenced by Multiple Commands or Hooks

Within AUDIT_ROOT's non-symlinked command content:

| File | Referenced By |
|---|---|
| vault/CLAUDE.md | kb-ingest (as rule authority), kb-integrity-check (tag taxonomy section) |
| vault/templates/wiki-article-template.md | kb-ingest (Step 5) |
| vault/templates/master-index-template.md | kb-ingest (preamble read) |
| vault/templates/wiki-index-template.md | kb-ingest (preamble read) |
| wiki/_master-index.md | kb-ingest (Step 2, Step 6), kb-integrity-check (Check 2, Check 3, Check 4) |

Section summary: 5 files referenced by multiple commands / 0 deltas from previous audit (first audit)

---

### 3.4 Files Ranked by Downstream References

Counting references from project-local commands only (symlinked commands' internal references are external scope):

| Rank | File | Reference Count | Referenced By |
|---|---|---|---|
| 1 | vault/CLAUDE.md | 2 | kb-ingest, kb-integrity-check |
| 2 | wiki/_master-index.md | 2 | kb-ingest, kb-integrity-check |
| 3 | vault/templates/wiki-article-template.md | 1 | kb-ingest |
| 4 | vault/templates/master-index-template.md | 1 | kb-ingest |
| 5 | vault/templates/wiki-index-template.md | 1 | kb-ingest |
| 6 | wiki/{folder}/_index.md (per-folder) | 1 | kb-integrity-check |
| 7 | taxonomy-proposal.md (external) | 1 | kb-ingest (fallback), kb-integrity-check (fallback) |

Only 7 distinct file types referenced by project-local commands (fewer than 10 items to rank). Symlinked command internal dependencies are out of scope.

Section summary: 7 files ranked / 0 deltas from previous audit (first audit)

---

### 3.5 Symlink Target Coverage by additionalDirectories

**Check method:** For each symlink in `.claude/commands/` and `.claude/agents/` whose target lies outside AUDIT_ROOT, verify target directory (or ancestor) is listed in `permissions.additionalDirectories` of `.claude/settings.json` or `vault/.claude/settings.json`. Coverage = any listed directory that is a string-prefix ancestor of the resolved target path.

**Project-root `.claude/settings.json`**:
- `additionalDirectories`: `["/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"]`
- All 56 project-root symlinks (14 agents + 42 commands) resolve to paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/...`
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is an ancestor of all symlink target paths. **All 56 project-root symlinks are covered.**

**`vault/.claude/settings.json`**:
- No `additionalDirectories` field present (confirmed: `NOT_PRESENT`).
- `vault/.claude/settings.local.json`: no `permissions` block.
- All 43 vault symlinks (9 agents + 34 commands) resolve to paths under `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/...`
- No `additionalDirectories` entry covers these paths in vault settings files.
- **43 vault symlinks are NOT covered by any `additionalDirectories` entry in vault settings files.**

Section summary: 1 issue flagged — vault/.claude/settings.json has no additionalDirectories entry; 43 vault symlinks target ai-resources but coverage is not declared / 0 deltas from previous audit (first audit)

---

### 3.6 ai-resources References Without additionalDirectories Coverage

Within AUDIT_ROOT, references to `ai-resources/` exist via:
1. `vault/.claude/settings.json` — SessionStart hook walks up to find `ai-resources/.claude/hooks/auto-sync-shared.sh` and runs it. This is a runtime reference.
2. `vault/.claude/commands/` — 34 symlinks targeting `ai-resources/.claude/commands/`.
3. `vault/.claude/agents/` — 9 symlinks targeting `ai-resources/.claude/agents/`.

`vault/.claude/settings.json` does not declare `additionalDirectories`. `vault/.claude/settings.local.json` has no `permissions` block. No vault settings file lists the workspace root or `ai-resources/` under `additionalDirectories`.

The workspace root `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` is listed in `additionalDirectories` only in `.claude/settings.json` (the project-root settings), which governs sessions opened at `projects/obsidian-pe-kb/`. When a session is opened at `vault/`, the governing settings file is `vault/.claude/settings.json`, which lacks the `additionalDirectories` entry.

**Missing entry:** `vault/.claude/settings.json` references ai-resources via hook and symlinks but does not list `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo` (or `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources`) in `permissions.additionalDirectories`.

Section summary: 1 issue flagged — vault/.claude/settings.json references ai-resources but lacks additionalDirectories coverage / 0 deltas from previous audit (first audit)

---

## Section 4: Consistency Checks

### 4.1 Skill Structural Consistency

0 skills in AUDIT_ROOT. N/A — no skills to compare.

Section summary: N/A — no skills present / 0 deltas from previous audit (first audit)

---

### 4.2 Slash Command Definition Pattern Consistency

**Project-root commands** are all symlinks; command definitions live in ai-resources (external scope). Cannot audit structural consistency of symlink targets.

**Vault project-local commands:**

`kb-ingest.md` frontmatter:
```
description: "..."
argument-hint: "[path-to-report]"
```
No `name:` field. No `model:` field.

`kb-integrity-check.md` frontmatter:
```
description: "..."
argument-hint: "[wiki-folder-name (optional — scan a single folder)]"
```
No `name:` field. No `model:` field.

Both vault project-local commands follow the same pattern (description + argument-hint, no name, no model). They differ from the symlinked agent-invocation commands (which in ai-resources carry `model:` and `name:` in frontmatter), but vault commands are not agents — they are user-facing procedural commands. Internal consistency between the two vault commands: consistent.

Section summary: 0 issues flagged within vault project-local commands / 0 deltas from previous audit (first audit)

---

### 4.3 Skill Template vs. Actual Skills Comparison

N/A — No skill creation template file exists. Skills are created via /create-skill which references ai-resource-builder/SKILL.md for format standards.

---

### 4.4 Naming Convention Inconsistencies

No naming convention inconsistencies found — checked across:
- All symlink filenames in `.claude/commands/` and `.claude/agents/` (all kebab-case).
- Vault project-local command filenames (`kb-ingest.md`, `kb-integrity-check.md`) — kebab-case, consistent with shared convention.
- Template filenames (`wiki-article-template.md`, `wiki-index-template.md`, `master-index-template.md`) — kebab-case.
- Pipeline artifact filenames — kebab-case with optional `-v1` suffix.
- Log filenames (`session-notes.md`, `innovation-registry.md`) — kebab-case.

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 4.5 Directory Structure Violations

`CLAUDE.md` (project-root) declares:
- `vault/` — exists. Clean.
- `pipeline/` — exists. Clean.
- `logs/` — exists. Clean.

`vault/CLAUDE.md` declares:
- `raw/pe-research/` — exists (empty). Clean.
- `raw/buyside-service-plan/` — exists (empty). Clean.
- `wiki/_master-index.md` — `wiki/` exists but is empty; `_master-index.md` absent. Pre-ingestion expected state per pipeline-state.md.
- `wiki/{folder}/_index.md` — no wiki folders created yet. Pre-ingestion expected state.
- `templates/` — exists with 3 files. Clean.
- `_setup-notes.md` — exists. Clean.

No `reports/` directory is declared in either CLAUDE.md, but `reports/repo-health-report.md` exists. This directory is not declared anywhere in CLAUDE.md.

Section summary: 1 issue flagged — `reports/` directory exists but is not declared in CLAUDE.md / 0 deltas from previous audit (first audit)

---

### 4.6 Command Syntax and Path Validation

**Vault project-local commands:**

`kb-ingest.md`: Frontmatter is valid YAML (description string, argument-hint string). References to `CLAUDE.md`, `wiki/_master-index.md`, `templates/wiki-article-template.md`, `templates/master-index-template.md`, `templates/wiki-index-template.md` are syntactically correct paths. Template files exist. `wiki/_master-index.md` does not exist (pre-ingestion). External path (`projects/project-planning/output/pe-knowledge-base/ingestion-log.md`) does not exist (pre-ingestion). These are documented expected absences, not syntax errors.

`kb-integrity-check.md`: Frontmatter is valid YAML. Path references match the same pattern as kb-ingest; same pre-ingestion absences apply.

**Project-root commands**: All symlinks; target files verified accessible (§1.7). Syntax of target files is external scope.

Section summary: 0 syntax errors found; 3 path-resolve failures (all pre-ingestion expected) / 0 deltas from previous audit (first audit)

---

### 4.7 Duplicate or Conflicting Command Names

No duplicate command names found — checked across all 42 project-root symlinks, 34 vault symlinks, and 2 vault project-local commands. `kb-ingest` and `kb-integrity-check` exist only in `vault/.claude/commands/` (not in project-root `.claude/commands/`), so no shadowing occurs.

No command names match known Claude Code built-in commands — checked all names against the standard built-in list (none of the listed commands are named `help`, `clear`, `compact`, `init`, etc.).

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 4.8 Agent Tier Declarations vs. Agent Tier Table

**Reference table:** `ai-resources/docs/agent-tier-table.md` (external scope, cross-referenced only).

All 14 agents in `.claude/agents/` are symlinks to ai-resources. Their declared tiers (read from symlink targets):

| Agent File | Declared Tier | Expected Tier (agent-tier-table.md) | Match |
|---|---|---|---|
| claude-md-auditor.md | opus | opus (judgment — audits logical quality) | MATCH |
| collaboration-coach.md | opus | opus (judgment — cross-session pattern analysis) | MATCH |
| dd-extract-agent.md | haiku | haiku (mechanical extraction) | MATCH |
| dd-log-sweep-agent.md | haiku | haiku (mechanical log scan) | MATCH |
| execution-agent.md | sonnet | sonnet (API-call dispatcher) | MATCH |
| improvement-analyst.md | opus | opus (judgment — friction-pattern analysis) | MATCH |
| qc-reviewer.md | opus | opus (QC judgment) | MATCH |
| refinement-reviewer.md | opus | opus (refinement judgment) | MATCH |
| repo-dd-auditor.md | sonnet | sonnet (questionnaire-driven factual audit) | MATCH |
| token-audit-auditor-mechanical.md | haiku | haiku (mechanical sections) | MATCH |
| token-audit-auditor.md | opus | opus (judgment sections) | MATCH |
| triage-reviewer.md | opus | opus (prioritization judgment) | MATCH |
| workflow-analysis-agent.md | opus | opus (architectural analysis) | MATCH |
| workflow-critique-agent.md | opus | opus (critique judgment) | MATCH |

All 14 agents match their expected tiers from the agent-tier-table.md. No mismatches found.

**Vault agents** (9 symlinks): Same targets as project-root agents — subset of the same 14 files. All match.

Section summary: 0 issues flagged — all 14 agent tier declarations match the agent-tier-table / 0 deltas from previous audit (first audit)

---

### 4.9 settings.json Comparison Against Canonical Baseline

**Reference baseline:** `ai-resources/.claude/commands/new-project.md` `CANONICAL_PERMS` block (last modified in ai-resources git: 2026-04-18, commit 7920d76).

**Project-root `.claude/settings.json`** (last modified: 2026-04-18, commit bc1a7da):

| Check | Expected | Actual | Result |
|---|---|---|---|
| `permissions.deny` contains `Bash(git push*)` | YES | YES | PASS |
| `permissions.deny` contains `Bash(rm -rf *)` | YES | YES | PASS |
| `permissions.deny` contains `Bash(sudo *)` | YES | YES | PASS |
| `permissions.deny` contains `Read(archive/**)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/*.archive.*)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/deprecated/**)` | YES | YES | PASS |
| `permissions.deny` contains `Read(**/old/**)` | YES | YES | PASS |
| Top-level `"model": "sonnet"` declared | YES | NOT DECLARED | FAIL |

The canonical baseline requires `"model": "sonnet"` at the top level of `settings.json`. This entry is absent from `.claude/settings.json`. The vault's `settings.local.json` declares `"model": "claude-opus-4-6"` (a model-specific override for vault sessions), but the project-root `settings.json` has no top-level model default.

**Vault `vault/.claude/settings.json`**: This file uses a narrower permissions pattern (granular Write/Edit allow list rather than the canonical `Bash(*)`/`Read`/`Edit`/`Write` broad block). It does not carry the CANONICAL_PERMS deny set. This is design intent (vault permissions are deliberately narrow per the implementation spec). Canonical deny entries are not present, but this is an intentional departure. Model default: NOT DECLARED.

**Date comparison for settings.json vs. new-project.md CANONICAL_PERMS:**
- `.claude/settings.json` last commit: 2026-04-18 (bc1a7da)
- `new-project.md` (CANONICAL_PERMS block) last commit: 2026-04-18 (7920d76, ai-resources git)
- Both updated on the same date. The deny set in `.claude/settings.json` fully matches canonical.

Section summary: 1 issue flagged — `.claude/settings.json` missing `"model": "sonnet"` top-level default / 0 deltas from previous audit (first audit)

---

## Section 5: Context Load

### 5.1 Estimated Session Context at Startup

**Session opened at project-root (`projects/obsidian-pe-kb/`):**
- Workspace CLAUDE.md (auto-loaded from parent workspace): ~varies (external)
- `CLAUDE.md` (project-root): 26 lines
- SessionStart hook runs auto-sync (no context loaded by hook itself)
- No auto-loaded `@import` files or `references/` files
- Estimated project-level context from this repo: 26 lines (~423 tokens per repo-health-report)

**Session opened at vault (`projects/obsidian-pe-kb/vault/`):**
- `vault/CLAUDE.md`: 174 lines
- Vault `settings.local.json` sets model to `claude-opus-4-6` (no context files)
- SessionStart hook runs auto-sync (no context loaded by hook itself)
- No auto-loaded `@import` files
- Estimated vault-level context from this repo: 174 lines (~2,019 tokens per repo-health-report)

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 5.2 CLAUDE.md Sections Not Referenced by Any Command, Hook, or Instruction

**`CLAUDE.md`** (project-root):
- `## Project Layout` — not referenced by any command. Orientation content for human readers.
- `## How to Open This Project in Claude Code` — not referenced by any command. Orientation content for human readers.
- `## Commit Rules` — not referenced by any command (rules are operative, loaded into every session context).

All 3 sections serve as orientation or session-operative rules rather than being explicitly referenced by commands. None are dead in the sense of being unreachable — they load on every session start.

**`vault/CLAUDE.md`**:
- `## For new users (Daniel)` (lines 160–166, ~7 lines) — not referenced by any vault command or hook. Serves as onboarding documentation for a named third party. Not operative for agent sessions.
- `## Commit Rules` — not referenced by any vault command. Operative rule loaded on every vault session.

Section summary: 1 section flagged — `vault/CLAUDE.md` `## For new users (Daniel)` (~7 lines) is not referenced by any command or hook / 0 deltas from previous audit (first audit)

---

### 5.3 CLAUDE.md Line Count History (Last 5 Commits)

**`CLAUDE.md`** (project-root) — only 1 commit in history:

| Commit | Date | Line Count |
|---|---|---|
| 0b427ae | 2026-04-13 | 26 lines |

No earlier commits exist (file created in this commit).

**`vault/CLAUDE.md`** — not tracked by git (vault/ is gitignored). No git history available. Current disk state: 174 lines. File modification date: 2026-04-14 (per `ls -la` output showing Apr 14 08:30).

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

## Section 6: Drift & Staleness

### 6.1 Files Not Modified in Last 90 Days Still Referenced by Active Commands

Audit date: 2026-04-21. The 90-day lookback window is 2026-01-21 to present.

All git-tracked files in AUDIT_ROOT were committed between 2026-04-13 and 2026-04-18 — all are within the 90-day window.

Vault files (gitignored, no git timestamps): file system modification dates observed via `ls -la`:
- `vault/CLAUDE.md` — Apr 14 2026 (8 days ago)
- `vault/_setup-notes.md` — Apr 13 2026 (9 days ago)
- `vault/templates/*.md` — Apr 13 2026 (9 days ago)

All files are within the 90-day window. None found — checked all files in AUDIT_ROOT against 2026-01-21 cutoff.

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 6.2 TODO/FIXME/PLACEHOLDER Markers

Searched all `.md` and `.json` files recursively in AUDIT_ROOT (excluding `.git/`) using `grep -rn "TODO\|FIXME\|PLACEHOLDER\|HACK\|XXX"`. Result: 0 matches found.

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

### 6.3 Empty, Stub, or Boilerplate-Only Files

**pipeline/decisions.md** (5 lines): Contains a header and column labels with exactly 1 data row. This is a minimal but populated file (not empty — 1 actual decision recorded).

**vault/wiki/** directory: Empty. No files. This is expected pre-ingestion state.

**vault/raw/pe-research/** directory: Empty. Expected pre-ingestion state.

**vault/raw/buyside-service-plan/** directory: Empty. Expected pre-ingestion state.

**vault/templates/master-index-template.md** (44 lines): Contains boilerplate template content with placeholder rows (e.g., `YYYY-MM-DD — [[example-article-slug]]`). By definition a template file — not a stub, this is its intended state.

**vault/templates/wiki-index-template.md** (20 lines): Contains boilerplate template with placeholder row. Template file in intended state.

**vault/templates/wiki-article-template.md** (43 lines): Contains boilerplate template with placeholder content. Template file in intended state.

None found — no empty, stub, or unintentionally boilerplate-only files identified. Template files with placeholder content are functioning as designed.

Section summary: 0 issues flagged / 0 deltas from previous audit (first audit)

---

## Findings Summary

| # | Section | Type | Item |
|---|---|---|---|
| 1 | 2.2 | Missing item | `vault/CLAUDE.md` references `wiki/_master-index.md` (line 15) — file does not exist (pre-ingestion) |
| 2 | 2.2 | Missing item | `vault/CLAUDE.md` references `projects/project-planning/output/pe-knowledge-base/ingestion-log.md` (line 40) — file does not exist (pre-ingestion) |
| 3 | 2.6 | Discrepancy | `vault/CLAUDE.md` contains ~132 lines of task-type-specific ingestion/query methodology in CLAUDE.md (workspace scoping rule places this in workflow reference docs) |
| 4 | 3.1 | Missing item | `wrap-session` references `logs/decisions.md`, `logs/coaching-data.md`, `logs/improvement-log.md`, `logs/usage-log.md` — none exist yet (wrap-session creates them on first run) |
| 5 | 3.5 | Discrepancy | `vault/.claude/settings.json` has no `additionalDirectories` entry; 43 vault symlinks target ai-resources without coverage declared |
| 6 | 3.6 | Discrepancy | `vault/.claude/settings.json` references ai-resources (hook + 43 symlinks) but lacks `additionalDirectories` entry for workspace root |
| 7 | 4.5 | Missing item | `reports/` directory exists but is not declared in either CLAUDE.md |
| 8 | 4.9 | Discrepancy | `.claude/settings.json` missing `"model": "sonnet"` top-level default (canonical baseline requires it) |
| 9 | 5.2 | Discrepancy | `vault/CLAUDE.md` `## For new users (Daniel)` (~7 lines) is not referenced by any command or hook |

**Total findings: 9**
- Discrepancies: 5 (findings 3, 5, 6, 8, 9)
- Missing items: 4 (findings 1, 2, 4, 7)
- Violations: 0
- Clean checks: All other questions returned clean

Note on findings 1, 2, 4: These are pre-ingestion expected absences with documented fallback behavior in vault commands. Finding 5 and 6 are the same underlying issue (vault settings missing additionalDirectories) counted once in 3.5 and once in 3.6 per questionnaire structure.
