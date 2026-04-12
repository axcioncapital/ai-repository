# Workflow System Analysis: global-macro-analysis

**Date:** 2026-04-11
**Workflow path:** `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis`
**Components:** 34 commands (13 project-native, 21 symlinked), 9 agents (all symlinked), 0 hooks, 14 settings entries, 3 skill references (3 found, 0 missing)

---

## Section 1: Component Inventory

### 1.1 Commands (34 total)

#### Project-Native Commands (13 total)

| Command | Skills Referenced | Agents Spawned | Gates | Reads | Writes |
|---------|------------------|----------------|-------|-------|--------|
| kb-ingest | intake-processor | none | 1 (operator confirm/edit/reject) | `_inbox/`, `_meta/taxonomy.md`, `skills/intake-processor/SKILL.md`, `_meta/confidence-rubric.md` | `_staging/` only |
| kb-review | none | none | 1 (operator review corrections) | `_staging/` (manifest + entries) | theme folders, `_meta/index.json`, `_meta/changelog.md`, `_meta/changelog.json` |
| kb-synthesize | none (uses synthesis-prompt.md) | none | 0 | theme entries, `_history/`, `_meta/taxonomy.md`, `_meta/index.json`, `_meta/prompts/synthesis-prompt.md` | `<theme>/_synthesis.md`, `<theme>/_history/` |
| kb-populate | none | none | 0 | `_meta/taxonomy.md`, theme synthesis + entries, web | `_staging/` only |
| kb-query | none | none | 0 | `_meta/index.json`, `_meta/taxonomy.md`, synthesis files, entries | Nothing (read-only) |
| kb-audit | none | none | 0 | Everything in `macro-kb/` | `_meta/audit-report.md` |
| kb-reindex | none | none | 0 | All theme folders (entry frontmatter) | `_meta/index.json` |
| kb-stale | none | none | 0 | `_meta/index.json`, synthesis frontmatter | Nothing (read-only) |
| kb-registry-query | none | none | 0 | `_sources/registry.md` | Nothing (read-only) |
| kb-gap-audit | none | none | 0 | `_sources/registry.md`, `_theme-file.md`, `_synthesis.md` | Nothing (read-only) |
| kb-theme-health | none | none | 0 | `_theme-file.md` files | Nothing (read-only) |
| kb-cross-theme | none | none | 0 | `_theme-file.md`, `_synthesis.md` | Nothing (read-only) |
| kb-triage-stats | none | none | 0 | `_sources/registry.md` | Nothing (read-only) |

#### Symlinked Commands (21 total, all from `ai-resources/.claude/commands/`)

| Command | Symlink Target | Skills Referenced | Agents Spawned | Gates |
|---------|---------------|------------------|----------------|-------|
| analyze-workflow | ai-resources | workflow-system-analyzer, workflow-system-critic | workflow-analysis-agent, workflow-critique-agent | 1 (operator gate Step 6) |
| audit-repo | ai-resources | repo-health-analyzer | repo-health-analyzer (lead agent) | 0 |
| clarify | ai-resources | none | none | 1 (wait for user response) |
| coach | ai-resources | none | collaboration-coach | 0 |
| create-skill | ai-resources | ai-resource-builder | subagent (unnamed, for evaluation) | 2 (Step 1 operator confirm, Step 6 operator review) |
| friction-log | ai-resources | none | none | 0 |
| improve-skill | ai-resources | ai-resource-builder | subagent (unnamed, for evaluation) | 2 (Step 1 operator confirm, Step 7 operator review) |
| improve | ai-resources | none | improvement-analyst | 1 (operator direction on findings) |
| migrate-skill | ai-resources | ai-resource-builder | subagent (unnamed, for evaluation) | 2 (Step 1 operator confirm, Step 6 operator review) |
| note | ai-resources | none | none | 0 |
| prime | ai-resources | none | none | 1 (wait for operator direction) |
| qc-pass | ai-resources | none | qc-reviewer | 0 |
| refinement-deep | ai-resources | none | qc-reviewer, refinement-reviewer, triage-reviewer | 0 |
| refinement-pass | ai-resources | none | refinement-reviewer | 0 |
| repo-dd | ai-resources | none | repo-dd-auditor | 1 (Step 4 operator gate) |
| request-skill | ai-resources | none | none | 1 (Step 4 confirm and hand off) |
| scope | ai-resources | none | none | 1 (wait for approval) |
| triage | ai-resources | none | triage-reviewer | 0 |
| update-claude-md | ai-resources | none | none | 1 (wait for approval) |
| usage-analysis | ai-resources | session-usage-analyzer | subagent (unnamed) | 0 |
| wrap-session | ai-resources | none | none | 0 |

### 1.2 Agents (9 total, all symlinked from `ai-resources/.claude/agents/`)

| Agent | Model | Tools | Invoked By |
|-------|-------|-------|------------|
| collaboration-coach | opus | Read, Glob, Grep | /coach |
| execution-agent | sonnet | Read, Bash | Not invoked by any deployed command |
| improvement-analyst | opus | Read, Glob, Grep | /improve |
| qc-reviewer | opus | Read, Glob, Grep | /qc-pass, /refinement-deep |
| refinement-reviewer | opus | Read, Glob, Grep | /refinement-pass, /refinement-deep |
| repo-dd-auditor | opus | Read, Write, Bash, Glob, Grep | /repo-dd |
| triage-reviewer | opus | Read, Glob, Grep | /triage, /refinement-deep |
| workflow-analysis-agent | opus | Read, Write, Bash, Glob, Grep | /analyze-workflow |
| workflow-critique-agent | opus | Read, Write, Glob, Grep | /analyze-workflow |

### 1.3 Hooks (0 total)

No `.claude/hooks/` directory exists in this project.

### 1.4 Settings Entries (14 total)

Settings file: `.claude/settings.json`

| Category | Entry | Value |
|----------|-------|-------|
| permissions.allow | Bash(*) | allowed |
| permissions.allow | Read | allowed |
| permissions.allow | Edit | allowed |
| permissions.allow | Write | allowed |
| permissions.allow | Agent | allowed |
| permissions.allow | Glob | allowed |
| permissions.allow | Grep | allowed |
| permissions.allow | Skill | allowed |
| permissions.allow | TodoWrite | allowed |
| permissions.allow | WebFetch | allowed |
| permissions.allow | WebSearch | allowed |
| permissions.allow | NotebookEdit | allowed |
| permissions.allow | ToolSearch | allowed |
| permissions.deny | Bash(git push*), Bash(rm -rf *), Bash(sudo *) | denied |

No hooks are configured in settings.json. No trigger/matcher/timeout entries.

### 1.5 Skills Directory

Project skills directory: `skills/` (1 entry)

| Skill | Type | Target |
|-------|------|--------|
| intake-processor | symlink | `../../../ai-resources/skills/intake-processor` |

---

## Section 2: Skill Interface Registry

### Referenced Skills (3 total, 3 found, 0 missing)

Skills referenced across all commands (project-native and symlinked):

| Skill | Exists | Inputs | Outputs | Tool | Dependencies | Referenced By |
|-------|--------|--------|---------|------|-------------|---------------|
| intake-processor | Yes (symlink in project + canonical in ai-resources) | Raw notes (pasted or from `_inbox/`), taxonomy.md, confidence-rubric.md | Staged entry files + batch manifest YAML to `_staging/` | Claude Code | `_meta/taxonomy.md`, `_meta/confidence-rubric.md`, `_meta/templates/atomic-entry-template.md` | kb-ingest |
| ai-resource-builder | Yes (in ai-resources/skills/) | Resource brief or existing skill + feedback | SKILL.md + bundled resources | Claude Code | `references/evaluation-framework.md` | create-skill, improve-skill, migrate-skill |
| session-usage-analyzer | Yes (in ai-resources/skills/) | Session summary, usage log | Log entry markdown | Claude Code | none | usage-analysis |

Additional skills referenced by symlinked commands but not present in project `skills/`:
- repo-health-analyzer: referenced by /audit-repo, exists at `ai-resources/skills/repo-health-analyzer/`
- workflow-system-analyzer: referenced by /analyze-workflow (via workflow-analysis-agent), exists at `ai-resources/skills/workflow-system-analyzer/`
- workflow-system-critic: referenced by /analyze-workflow (via workflow-critique-agent), exists at `ai-resources/skills/workflow-system-critic/`

### Missing Skills

None. All referenced skills resolve to existing files.

---

## Section 3: Pipeline Trace

### 3.1 Stage-to-Command Mapping

No workflow definition document found (`reference/stage-instructions.md`, `stage-instructions.md`, or stage definitions in CLAUDE.md`). Pipeline trace based on command analysis and CLAUDE.md's "Two integrated subsystems" description.

**Subsystem A: Knowledge Base**

| Stage | Implementing Command(s) | Coverage Notes |
|-------|------------------------|----------------|
| 1. Raw input acceptance | /kb-ingest | Accepts file from `_inbox/` or pasted text |
| 2. Decomposition + routing | /kb-ingest | Delegates to intake-processor skill |
| 3. Staging review | /kb-review | Only path from staging to theme folders |
| 4. Synthesis generation | /kb-synthesize | Regenerates from atomic entries |
| 5. External population | /kb-populate | Web search, stages to `_staging/` |
| 6. Querying | /kb-query | Read-only search |
| 7. Maintenance | /kb-audit, /kb-reindex, /kb-stale | Structural integrity, index rebuild, freshness check |

**Subsystem B: Research Workflow**

| Stage | Implementing Command(s) | Coverage Notes |
|-------|------------------------|----------------|
| 1. Theme monitoring | /kb-theme-health | Theme file quality dashboard |
| 2. Gap identification | /kb-gap-audit | Coverage gaps across registry + themes |
| 3. Cross-theme analysis | /kb-cross-theme | Surface connections and contradictions |
| 4. Source tracking | /kb-registry-query, /kb-triage-stats | Registry queries and processing stats |

### 3.2 Hand-off Chain

| From Command | Output Path(s) | To Command | Input Path(s) | Status |
|-------------|----------------|------------|----------------|--------|
| kb-ingest | `_staging/` (entries + batch manifest) | kb-review | `_staging/` (manifest + entries) | CONNECTED |
| kb-populate | `_staging/` (entries + batch manifest) | kb-review | `_staging/` (manifest + entries) | CONNECTED |
| kb-review | theme folders (filed entries), `_meta/index.json`, `_meta/changelog.*` | kb-synthesize | theme entries, `_meta/index.json` | CONNECTED |
| kb-review | theme folders (sets `stale: true` on synthesis) | kb-stale | synthesis frontmatter (`stale` field) | CONNECTED |
| kb-synthesize | `<theme>/_synthesis.md` | kb-query | synthesis files | CONNECTED |
| kb-synthesize | `<theme>/_synthesis.md` | kb-cross-theme | synthesis files | CONNECTED |
| kb-synthesize | `<theme>/_synthesis.md` | kb-gap-audit | synthesis files | CONNECTED |
| kb-reindex | `_meta/index.json` | kb-query, kb-stale | `_meta/index.json` | CONNECTED |
| kb-audit | `_meta/audit-report.md` | (operator reads) | N/A | TERMINAL |

### 3.3 Unmapped Commands

These commands exist in the project but are not part of the KB pipeline. They are shared utility/infrastructure commands from ai-resources:

| Command | Apparent Purpose |
|---------|-----------------|
| analyze-workflow | Workflow infrastructure analysis (meta-tool) |
| audit-repo | Workspace health audit |
| clarify | Restate and clarify user requests |
| coach | Collaboration pattern analysis |
| create-skill | Skill creation pipeline |
| friction-log | Log friction events |
| improve-skill | Skill improvement pipeline |
| improve | Session friction analysis |
| migrate-skill | Migrate Chat skills to Code |
| note | Log workflow observations |
| prime | Session orientation |
| qc-pass | Independent QC review |
| refinement-deep | Deep review (QC + refinement + triage) |
| refinement-pass | Independent refinement review |
| repo-dd | Repo due diligence audit |
| request-skill | Request new skill |
| scope | Scope summary |
| triage | Independent triage of suggestions |
| update-claude-md | Update CLAUDE.md rules |
| usage-analysis | Token efficiency analysis |
| wrap-session | Session wrap-up and logging |

---

## Section 4: Hook Mapping

No hooks configured. No `.claude/hooks/` directory. No hook entries in `settings.json`.

### Hook-Command Interaction

N/A -- no hooks deployed.

### Hook Coverage Summary

- Hooks with consumed output: 0
- Hooks with unconsumed output: 0
- Cumulative timeout per write operation: 0ms

---

## Section 5: Cross-Reference Matrix

### 5.1 Skill References

| Skill | In CLAUDE.md | In Commands | Status |
|-------|-------------|-------------|--------|
| intake-processor | Yes (referenced in "Intake Processing Rules" and "Key File Paths") | Yes (kb-ingest) | ALIGNED |
| ai-resource-builder | No (not mentioned in project CLAUDE.md) | Yes (create-skill, improve-skill, migrate-skill) | COMMAND-ONLY |
| session-usage-analyzer | No | Yes (usage-analysis) | COMMAND-ONLY |
| repo-health-analyzer | No | Yes (audit-repo) | COMMAND-ONLY |
| workflow-system-analyzer | No | Yes (analyze-workflow, via agent) | COMMAND-ONLY |
| workflow-system-critic | No | Yes (analyze-workflow, via agent) | COMMAND-ONLY |

Note: COMMAND-ONLY status for ai-resource-builder, session-usage-analyzer, repo-health-analyzer, workflow-system-analyzer, and workflow-system-critic is expected -- these are shared utility skills from ai-resources, not project-specific skills. The project CLAUDE.md correctly documents only the project-specific skill (intake-processor).

### 5.2 Gates

| Gate Description | In CLAUDE.md | In Commands | Status |
|-----------------|-------------|-------------|--------|
| Staging-only writes for intake | Yes (Hard Rule 1) | Yes (kb-ingest, kb-populate: "NEVER writes to theme folders") | ALIGNED |
| kb-review as only path to theme folders | Yes (Hard Rule 1) | Yes (kb-review: "ONLY command that moves files into theme folders") | ALIGNED |
| Operator confirm/edit/reject after ingest | Not explicit as a gate in CLAUDE.md | Yes (kb-ingest Step 6) | COMMAND-ONLY |
| Operator review corrections in kb-review | Not explicit as a gate in CLAUDE.md | Yes (kb-review Step 5) | COMMAND-ONLY |

### 5.3 Rule Enforcement

| Rule (from CLAUDE.md) | Enforced by Hook | Referenced in Command | Enforcement Level |
|-----------------------|------------------|-----------------------|-------------------|
| Staging-only writes for intake (Hard Rule 1) | No | Yes (kb-ingest, kb-populate) | command-referenced |
| Synthesis files are disposable (Hard Rule 2) | No | Yes (kb-synthesize archives before overwriting) | command-referenced |
| Atomic entry content is append-only (Hard Rule 3) | No | Yes (kb-review: "content is never modified") | command-referenced |
| 3-page hard limit on theme file Current Picture (Hard Rule 4) | No | Yes (kb-theme-health flags approaching limit) | command-referenced |
| Scope enforcement on every command (Hard Rule 5) | No | Yes (each command declares its read/write scope) | command-referenced |
| Test with real-ish input before expanding (Hard Rule 6) | No | No | behavioral-only |
| No automated extraction (Hard Rule 7) | No | No | behavioral-only |
| Entry boundary rule (one entry per coherent idea) | No | Yes (kb-ingest delegates to intake-processor skill) | command-referenced |
| Primary theme rule (route by decision-making impact) | No | Yes (intake-processor skill) | command-referenced |
| Uncertain routing (flag as theme: uncertain) | No | Yes (intake-processor skill) | command-referenced |

---

## Section 6: Drift Analysis

### 6.1 Source Workflow Comparison

The global-macro-analysis project is NOT derived from the `research-workflow` template. It has its own project-specific command set (13 `kb-*` commands). The research-workflow template contains 26 commands focused on a multi-stage research pipeline (preparation, execution, analysis, report production). None of the research-workflow commands overlap with the `kb-*` commands.

### 6.2 Shared Command Sync Status

All 21 symlinked commands point to `ai-resources/.claude/commands/` via relative symlinks (`../../../../ai-resources/.claude/commands/{name}.md`). Since these are symlinks (not copies), they are always in sync with their source -- no content drift is possible.

| Symlink | Target Exists | Symlink Valid |
|---------|--------------|---------------|
| analyze-workflow.md | Yes | Yes |
| audit-repo.md | Yes | Yes |
| clarify.md | Yes | Yes |
| coach.md | Yes | Yes |
| create-skill.md | Yes | Yes |
| friction-log.md | Yes | Yes |
| improve-skill.md | Yes | Yes |
| improve.md | Yes | Yes |
| migrate-skill.md | Yes | Yes |
| note.md | Yes | Yes |
| prime.md | Yes | Yes |
| qc-pass.md | Yes | Yes |
| refinement-deep.md | Yes | Yes |
| refinement-pass.md | Yes | Yes |
| repo-dd.md | Yes | Yes |
| request-skill.md | Yes | Yes |
| scope.md | Yes | Yes |
| triage.md | Yes | Yes |
| update-claude-md.md | Yes | Yes |
| usage-analysis.md | Yes | Yes |
| wrap-session.md | Yes | Yes |

### 6.3 Agent Sync Status

All 9 agent symlinks point to `ai-resources/.claude/agents/`. All targets exist and symlinks are valid.

### 6.4 Skill Sync Status

The single project skill (`intake-processor`) is a symlink to `ai-resources/skills/intake-processor`. Target exists and symlink is valid.

---

## Section 7: Reference Integrity

### 7.1 Broken Paths

None found. All symlinks resolve. All referenced skill paths exist.

### 7.2 Missing Files

| Reference | Expected At | Status |
|-----------|------------|--------|
| `macro-kb/_meta/taxonomy.md` | Referenced by 6 commands | Not verified (runtime dependency) |
| `macro-kb/_meta/index.json` | Referenced by 5 commands | Not verified (runtime dependency) |
| `macro-kb/_meta/confidence-rubric.md` | Referenced by kb-ingest | Not verified (runtime dependency) |
| `macro-kb/_meta/prompts/synthesis-prompt.md` | Referenced by kb-synthesize | Not verified (runtime dependency) |
| `macro-kb/_meta/templates/atomic-entry-template.md` | Referenced by intake-processor skill | Not verified (runtime dependency) |
| `macro-kb/_sources/registry.md` | Referenced by 3 commands | Not verified (runtime dependency) |

Note: These are runtime data dependencies, not infrastructure references. Their existence depends on whether the KB has been bootstrapped.

### 7.3 Orphaned Components

| Component | Type | Notes |
|-----------|------|-------|
| execution-agent | Agent (symlinked) | Not invoked by any command in this project. Part of the shared agent library; used by the research-workflow pipeline, not the KB system. |

### 7.4 Commands Without Agent or Skill Dependencies

The 13 `kb-*` commands are largely self-contained. Only `kb-ingest` references a skill (intake-processor). None of the `kb-*` commands spawn agents. This is consistent with the project's design principle of keeping the operator in the judgment loop (Hard Rule 7: "No automated extraction").
