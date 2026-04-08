# Workflow System Analysis: research-workflow

**Date:** 2026-04-07
**Workflow path:** /Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/workflows/research-workflow
**Components:** 25 commands, 4 agents, 4 hooks, 13 settings entries, 33 skill references (33 found, 0 missing)

---

## Section 1: Component Inventory

### 1.1 Commands (25 total)

| Command | Skills Referenced | Agents Spawned | Gates | Frontmatter Flags |
|---------|------------------|----------------|-------|-------------------|
| audit-repo | repo-health-analyzer (via agent files) | repo-health-analyzer (subagent) | 0 | none |
| audit-structure | none | none | 0 | none |
| create-context-pack | context-pack-builder | none | 0 | none |
| friction-log | none | none | 0 | none |
| improve | none | improvement-analyst | 1 (operator direction on findings) | none |
| inject-dependency | none | none | 0 | none |
| intake-reports | none | none | 1 (operator confirms session mapping) | none |
| note | none | none | 0 | none |
| prime | none | none | 0 (pauses for operator direction) | none |
| produce-knowledge-file | knowledge-file-producer | delegate-qc subagent | 1 (QC gate + operator review) | none |
| qc-pass | none | qc-reviewer (subagent) | 1 (operator direction) | none |
| refinement-pass | none | refinement-reviewer (subagent) | 1 (operator direction) | none |
| review | chapter-review | qc-gate | 0 (presents verdict, no blocking gate) | friction-log: true |
| run-analysis | gap-assessment-gate, section-directive-drafter, analysis-pass-memo-review, editorial-recommendations-generator, editorial-recommendations-qc | general-purpose sub-agent, qc-gate | 2 (gap assessment operator review, DISAGREE items pause) | friction-log: true |
| run-cluster | cluster-analysis-pass, cluster-memo-refiner | general-purpose sub-agent (delegate) | 1 (operator reviews refined memo) | friction-log: true |
| run-execution | answer-spec-qc, execution-manifest-creator, research-prompt-creator, research-prompt-qc, research-extract-creator, research-extract-verifier, supplementary-query-brief-drafter, supplementary-research-qc, supplementary-evidence-merger | qc-gate, general-purpose sub-agent | 4+ (manifest review, prompt QC, extract verification, supplementary gates) | friction-log: true |
| run-preparation | task-plan-creator, research-plan-creator, answer-spec-generator, answer-spec-qc | general-purpose sub-agent, qc-gate | 3 (Task Plan review, Research Plan review, Answer Spec review) | friction-log: true |
| run-report | research-structure-creator, architecture-qc, evidence-to-report-writer, chapter-prose-reviewer, report-compliance-qc, citation-converter | general-purpose sub-agent, qc-gate | 2+ (architecture review, per-chapter operator review) | friction-log: true |
| run-synthesis | cluster-synthesis-drafter | general-purpose sub-agent | 0 | friction-log: true |
| status | none | none | 0 | none |
| update-claude-md | none | none | 1 (operator approval before writing) | none |
| usage-analysis | session-usage-analyzer | subagent | 0 | none |
| verify-chapter | evidence-prose-fixer | execution-agent, general-purpose sub-agent | 1 (operator reviews corrections) | friction-log: true |
| workflow-status | workflow-evaluator | verification-agent | 0 | none |
| wrap-session | none | none | 0 | none |

### 1.2 Agents (4 total)

| Agent | Model | Tools | Invoked By |
|-------|-------|-------|------------|
| execution-agent | sonnet | Read, Bash | verify-chapter (GPT-5 API calls) |
| improvement-analyst | opus | Read, Glob, Grep | improve |
| qc-gate | sonnet | Read | run-preparation, run-execution, run-analysis, run-report, review, produce-knowledge-file |
| verification-agent | sonnet | Read, Glob, Grep | workflow-status |

### 1.3 Hooks (4 total)

| Hook Script | Reads | Writes/Appends | Blocks When |
|-------------|-------|----------------|-------------|
| check-claim-ids.sh | Tool input (file_path), the written file content | stderr warnings only | Never blocks (always exit 0). Emits severity-graded warnings for [CITATION NEEDED] tags in pipeline artifacts. |
| detect-innovation.sh | Tool input (file_path), logs/innovation-registry.md (dedup check) | logs/innovation-registry.md (appends detected entry) | Never blocks (always exit 0). Emits systemMessage for detected innovations. |
| friction-log-auto.sh | Tool input (skill name), .claude/commands/{skill}.md (checks frontmatter), logs/friction-log.md (dedup check) | logs/friction-log.md (appends session block) | Never blocks (always exit 0). |
| log-write-activity.sh | Tool input (file_path), logs/friction-log.md (finds Write Activity section) | logs/friction-log.md (appends write entry) | Never blocks (always exit 0). Recursion guard skips friction-log.md and improvement-log.md. |

### 1.4 Settings Entries (13 total)

| Trigger | Matcher | Script/Command | Timeout | Script Exists |
|---------|---------|----------------|---------|---------------|
| PreToolUse | Skill | friction-log-auto.sh | 5s | Yes |
| PreToolUse | Edit | Inline (bright-line rule check for report/chapters or final/modules paths) | 5s | N/A (inline) |
| PostToolUse | Write | Inline (auto-commit for preparation/execution/analysis/report paths) | 15s | N/A (inline) |
| PostToolUse | Write | log-write-activity.sh | 5s | Yes |
| PostToolUse | Write | detect-innovation.sh | 5s | Yes |
| PostToolUse | Edit | log-write-activity.sh | 5s | Yes |
| PostToolUse | Edit | detect-innovation.sh | 5s | Yes |
| SessionStart | (no matcher) | Inline (load latest checkpoint context) | 10s | N/A (inline) |
| SessionStart | (no matcher) | Inline (check-template-drift.sh from parent ai-resources) | 10s | N/A (inline, references external script) |
| SessionStart | (no matcher) | Inline (auto-sync-shared.sh from parent ai-resources) | 10s | N/A (inline, references external script) |
| Stop | (no matcher) | Inline (checkpoint recency check) | 5s | N/A (inline) |
| Stop | (no matcher) | Inline (session wrap check — warns if /wrap-session not run) | 5s | N/A (inline) |
| UserPromptSubmit | (no matcher) | Inline (logs operator decisions at gates to logs/decisions.md) | 5s | N/A (inline) |

**Permissions:**
- Allow: Bash(*), Read, Edit, Write, MultiEdit
- Deny: Bash(git push *), Bash(rm *), Bash(sudo *)

---

## Section 2: Skill Interface Registry

### Referenced Skills (33 total, 33 found, 0 missing)

| Skill | Exists | Inputs | Outputs | Tool | Referenced By |
|-------|--------|--------|---------|------|---------------|
| task-plan-creator | Yes | Task plan draft (@ reference) | task-plan-v1.md | Claude Code | run-preparation |
| research-plan-creator | Yes | Approved Task Plan | research-plan-v1.md | Claude Code | run-preparation |
| answer-spec-generator | Yes | Research Plan with questions | Answer spec files per cluster | Claude Code | run-preparation |
| answer-spec-qc | Yes | Answer Specs + Task Plan + Research Plan | Per-spec verdicts (APPROVED/REVISE/ESCALATE) | Claude Code | run-preparation, run-execution |
| execution-manifest-creator | Yes | Answer Specs + Research Plan | Execution manifest (routing table, sessions, waves) | Claude Code | run-execution |
| research-prompt-creator | Yes | Execution Manifest + Research Plan + Answer Specs | Per-session prompt files + session-plan.md | Claude Code | run-execution |
| research-prompt-qc | Yes | Prompts + Answer Specs + Research Plan | Per-session verdicts (PASS/FLAG) + batch verdict | Claude Code | run-execution |
| research-extract-creator | Yes | Raw research report + Answer Specs | One extract per question (claims, coverage, syntheses) | Claude Code | run-execution |
| research-extract-verifier | Yes | Raw report + Extracts + Answer Specs | Per-extract verdicts (APPROVED/FLAG-RE-EXTRACT) | Claude Code | run-execution |
| supplementary-query-brief-drafter | Yes | Failed components + Research Extracts + Answer Specs | Grouped Perplexity queries (max 12) | Claude Code | run-execution |
| supplementary-research-qc | Yes | Raw Perplexity output + Research Extracts + Query Brief | Per-query verdicts (MERGE/SKIP/PARTIAL) | Claude Code | run-execution |
| supplementary-evidence-merger | Yes | Research Extracts + QC-approved results + Answer Specs | Updated Research Extracts (replace originals) | Claude Code | run-execution |
| cluster-analysis-pass | Yes | Research Extracts for cluster + scarcity register | Cluster analytical memo | Claude Code | run-cluster |
| cluster-memo-refiner | Yes | Cluster analytical memo | Refined cluster memo (6-check pass) | Claude Code | run-cluster |
| gap-assessment-gate | Yes | All cluster memos + scarcity register | Gap assessment with Path A/B routing | Claude Code | run-analysis |
| section-directive-drafter | Yes | Refined cluster memo + scarcity register | Section directive per cluster | Claude Code | run-analysis |
| analysis-pass-memo-review | Yes | Refined cluster memos + section directives | Editorial decisions surfaced (questions, not answers) | Claude Code | run-analysis |
| editorial-recommendations-generator | Yes | Memo review + cluster memos + scarcity register + directives | Recommended answers for editorial decisions | Claude Code | run-analysis |
| editorial-recommendations-qc | Yes | Memo review + recommendations + cluster memos + scarcity register + directives | Per-decision verdicts (AGREE/DISAGREE/NUANCE) | Claude Code | run-analysis |
| cluster-synthesis-drafter | Yes | Refined memo + section directive + scarcity register | Chapter draft per cluster | Claude Code | run-synthesis |
| research-structure-creator | Yes | Chapter drafts (2+ chapters) | Unified document architecture specification | Claude Code | run-report |
| architecture-qc | Yes | Architecture + scarcity register + directives + editorial recs + chapter drafts | QC verdict (PASS/FAIL) with per-criterion findings | Claude Code | run-report |
| evidence-to-report-writer | Yes | Architecture + extracts + memo + directive + scarcity register + editorial recs + style reference | Chapter prose | Claude Code | run-report |
| chapter-prose-reviewer | Yes | Chapter draft + scarcity register | Review verdict + findings + recommended changes | Claude Code | run-report |
| report-compliance-qc | Yes | Chapter draft + review findings + architecture + style ref + scarcity register + directive | PASS/FAIL with per-item findings | Claude Code | run-report |
| citation-converter | Yes | Approved chapter prose | Cited version + Citation Traceability Layer | Claude Code | run-report |
| context-pack-builder | Yes | Task Plan | Context pack for GPT-5 | Claude Code | create-context-pack |
| knowledge-file-producer | Yes | Cited chapter files | Condensed knowledge file for Chat | Claude Code | produce-knowledge-file |
| session-usage-analyzer | Yes | Session summary + usage log | Formatted log entry | Claude Code (subagent) | usage-analysis |
| workflow-evaluator | Yes | Workflow definition + skill directory listing | Evaluation report with severity-classified findings | Claude Code (subagent) | workflow-status |
| evidence-prose-fixer | Yes | Verification report + chapter draft + evidence pack | Corrected prose passages with bright-line metadata | Claude Code | verify-chapter |
| chapter-review | Yes | Chapter prose + architecture + style ref + directive + scarcity register + memo + synthesis brief | Findings report with verdict (PASS/CONDITIONAL PASS/REVISE) | Claude Code | review |
| repo-health-analyzer | Yes | Target directory path | Scored health report | Claude Code (multi-agent) | audit-repo |

### Missing Skills

None.

---

## Section 3: Pipeline Trace

### 3.1 Stage-to-Command Mapping

| Stage | Step(s) | Implementing Command(s) | Coverage Notes |
|-------|---------|------------------------|----------------|
| Stage 1: Preparation | Steps 1.1-1.8 (Task Plan, Research Plan, Answer Specs, QC) | `/run-preparation` | Full coverage. All steps implemented. |
| Stage 2: Execution | Steps 2.0-2.4 (Manifest, Prompts, QC, Raw Reports, Extracts, Verification) | `/run-execution` | Full coverage. Includes Subworkflow 2.S (supplementary research). |
| Stage 2 (support) | Step 2.2b (report filing) | `/intake-reports` | Overlaps with run-execution Step 2.2b. Intake-reports is a standalone alternative. |
| Stage 2 (support) | Step 2.2a (dependency injection) | `/inject-dependency` | Overlaps with run-execution Step 2.2a. Standalone alternative for injection only. |
| Stage 3: Analysis (per-cluster) | Steps 3.1-3.3 (cluster analysis + refinement) | `/run-cluster` | Per-cluster command. Must run once per cluster. |
| Stage 3: Analysis (cross-cluster) | Steps 3.4-3.6d (gap assessment, directives, editorial review, recommendations, QC, approval) | `/run-analysis` | Full coverage including Subworkflow 3.S. |
| Stage 3: Synthesis | Step 3.7 (chapter drafting) | `/run-synthesis` | Separate command for fresh session context. |
| Stage 4: Report Production | Steps 4.1-4.6 (architecture, chapter prose, review, compliance QC, citations) | `/run-report` | Full coverage. Includes architecture QC (Step 4.1b). |
| Stage 4 (support) | Chapter review at any point | `/review` | Standalone chapter review, not part of sequential pipeline. |
| Stage 4 (support) | Fact verification | `/verify-chapter` | Uses GPT-5 API via execution-agent. Includes bright-line checks on corrections. |
| Stage 5: Final Production | Steps 5.1-5.8 (integration QC, formatting, merge, compile) | No implementing command | No `/run-final` command exists. Stage 5 is defined in stage-instructions.md but has no dedicated command. |

### 3.2 Hand-off Chain

| From Command | Output Path(s) | To Command | Input Path(s) | Status |
|-------------|----------------|------------|----------------|--------|
| run-preparation | preparation/task-plans/{section}-task-plan-v1.md | run-preparation (internal) | (same file, read back after gate) | CONNECTED |
| run-preparation | preparation/research-plans/{section}-research-plan-v1.md | run-preparation (internal) | (same file, read back after gate) | CONNECTED |
| run-preparation | preparation/answer-specs/{section}/ | run-execution | preparation/answer-specs/{section}/ | CONNECTED |
| run-execution | execution/manifest/{section}/{section}-execution-manifest.md | run-execution (internal) | (same file, read within command) | CONNECTED |
| run-execution | execution/research-prompts/{section}/ | Operator (manual execution) | N/A | CONNECTED (hand-off to operator) |
| intake-reports / run-execution | execution/raw-reports/{section}/ | run-execution (Step 2.3) | execution/raw-reports/ | CONNECTED |
| run-execution | execution/research-extracts/{section}/ | run-cluster | execution/research-extracts/{section}/ | CONNECTED |
| run-execution | execution/scarcity-register/{section}/ | run-cluster, run-analysis, run-synthesis, run-report | execution/scarcity-register/{section}/ | CONNECTED |
| run-cluster | analysis/cluster-memos/{section}/ (refined) | run-analysis | analysis/cluster-memos/{section}/ | CONNECTED |
| run-analysis | analysis/section-directives/{section}/ | run-synthesis | analysis/section-directives/{section}/ | CONNECTED |
| run-analysis | analysis/editorial-review/{section}/ | run-report | analysis/editorial-review/{section}/ | CONNECTED |
| run-synthesis | analysis/chapters/{section}/ | run-report | analysis/chapters/{section}/ | CONNECTED |
| run-report | report/architecture/{section}/ | run-report (internal) | (same file, read within command) | CONNECTED |
| run-report | report/chapters/{section}/ (cited) | produce-knowledge-file | report/chapters/{section}/ | CONNECTED |
| run-report | report/chapters/{section}/ | verify-chapter | report/chapters/{section}/ | CONNECTED |
| run-report | report/chapters/{section}/ | review | report/chapters/{section}/ | CONNECTED |
| run-report | report/chapters/{section}/ (cited) | (Stage 5 — no command) | N/A | UNCONNECTED — no Stage 5 command |

### 3.3 Unmapped Commands

| Command | Apparent Purpose |
|---------|-----------------|
| audit-repo | Utility: workspace health audit via repo-health-analyzer skill |
| audit-structure | Utility: file naming and placement audit against conventions |
| create-context-pack | Support: builds GPT-5 context packs from Task Plans |
| friction-log | Utility: manual friction event logging |
| improve | Utility: end-of-session friction analysis and improvement proposals |
| note | Utility: log workflow observations or friction events |
| prime | Utility: session orientation and state recovery |
| qc-pass | Utility: ad-hoc independent QC on any artifact |
| refinement-pass | Utility: ad-hoc independent refinement review on any artifact |
| status | Utility: compact project status summary |
| update-claude-md | Utility: add or update CLAUDE.md rules |
| usage-analysis | Utility: token efficiency analysis |
| workflow-status | Utility: structured workflow status view + QC health check |
| wrap-session | Utility: session wrap-up (session notes, decisions, innovation triage) |

---

## Section 4: Hook Mapping

### Hook-Command Interaction

| Hook | Trigger | Fires During | Output | Output Consumed By |
|------|---------|-------------|--------|--------------------|
| friction-log-auto.sh | PreToolUse (Skill matcher) | Any command invocation where the command file has `friction-log: true` in frontmatter | Appends session block to logs/friction-log.md | improve (reads friction-log.md), wrap-session (indirectly) |
| Inline bright-line check | PreToolUse (Edit matcher) | Any Edit operation on files in report/chapters/ or final/modules/ | Blocks with decision message | Operator (manual gate). Logs to logs/decisions.md via UserPromptSubmit hook |
| Inline auto-commit | PostToolUse (Write matcher) | Any Write to preparation/, execution/, analysis/, or report/ paths | Git auto-commit | None (git history only) |
| log-write-activity.sh | PostToolUse (Write and Edit matchers) | Any Write or Edit operation (except friction-log.md, improvement-log.md) | Appends write entry to logs/friction-log.md | improve (reads friction-log.md) |
| detect-innovation.sh | PostToolUse (Write and Edit matchers) | Any Write or Edit to .claude/commands/, .claude/agents/, or .claude/hooks/ | Appends entry to logs/innovation-registry.md + systemMessage | wrap-session (reads innovation-registry.md for triage) |
| check-claim-ids.sh | Not registered in settings.json | Invoked manually by verify-chapter command (Step 1b) | stderr warnings for [CITATION NEEDED] tags | verify-chapter (reads stderr output) |
| Inline checkpoint check | Stop | Session end | systemMessage if no recent checkpoint | Operator (advisory) |
| Inline session wrap check | Stop | Session end | systemMessage if /wrap-session not run today | Operator (advisory) |
| Inline decision logger | UserPromptSubmit | Any user prompt after a GATE/bright-line/PAUSE | Appends to logs/decisions.md | review, verify-chapter, run-report (read decisions.md indirectly) |
| Inline context loader | SessionStart | Session start | hookSpecificOutput with latest checkpoint context | Claude (session context) |
| Inline template drift check | SessionStart | Session start | Runs check-template-drift.sh from parent ai-resources | Claude (advisory) |
| Inline shared command sync | SessionStart | Session start | Runs auto-sync-shared.sh from parent ai-resources | Claude (command updates) |

### Hook Coverage Summary

- Hooks with consumed output: 4 (friction-log-auto.sh, log-write-activity.sh, detect-innovation.sh, inline context loader)
- Hooks with unconsumed output: 3 (inline checkpoint check, inline session wrap check, inline template drift check — all advisory/systemMessage only)
- check-claim-ids.sh: Not registered in settings.json. Only invoked manually by verify-chapter.
- Cumulative timeout per Write operation to a pipeline path: 25ms (15s auto-commit + 5s log-write-activity + 5s detect-innovation)
- Cumulative timeout per Edit operation: 15ms (5s bright-line check PreToolUse + 5s log-write-activity + 5s detect-innovation)

---

## Section 5: Cross-Reference Matrix

### 5.1 Skill References

| Skill | In stage-instructions.md | In Commands | Status |
|-------|--------------------------|-------------|--------|
| task-plan-creator | Yes (Stage 1) | run-preparation | ALIGNED |
| research-plan-creator | Yes (Stage 1) | run-preparation | ALIGNED |
| answer-spec-generator | Yes (Stage 1) | run-preparation | ALIGNED |
| answer-spec-qc | Yes (Stage 1) | run-preparation, run-execution | ALIGNED |
| execution-manifest-creator | Yes (Stage 2) | run-execution | ALIGNED |
| research-prompt-creator | Yes (Stage 2) | run-execution | ALIGNED |
| research-prompt-qc | Yes (Stage 2) | run-execution | ALIGNED |
| research-extract-creator | Yes (Stage 2) | run-execution | ALIGNED |
| research-extract-verifier | Yes (Stage 2) | run-execution | ALIGNED |
| supplementary-query-brief-drafter | Yes (Stage 2) | run-execution | ALIGNED |
| supplementary-research-qc | Yes (Stage 2) | run-execution | ALIGNED |
| supplementary-evidence-merger | Yes (Stage 2) | run-execution | ALIGNED |
| cluster-analysis-pass | Yes (Stage 3) | run-cluster | ALIGNED |
| cluster-memo-refiner | Yes (Stage 3) | run-cluster | ALIGNED |
| gap-assessment-gate | Yes (Stage 3) | run-analysis | ALIGNED |
| section-directive-drafter | Yes (Stage 3) | run-analysis | ALIGNED |
| analysis-pass-memo-review | Yes (Stage 3) | run-analysis | ALIGNED |
| editorial-recommendations-generator | Yes (Stage 3) | run-analysis | ALIGNED |
| editorial-recommendations-qc | Yes (Stage 3) | run-analysis | ALIGNED |
| cluster-synthesis-drafter | Yes (Stage 3) | run-synthesis | ALIGNED |
| research-structure-creator | Yes (Stage 4) | run-report | ALIGNED |
| evidence-to-report-writer | Yes (Stage 4) | run-report | ALIGNED |
| chapter-prose-reviewer | Yes (Stage 4) | run-report | ALIGNED |
| citation-converter | Yes (Stage 4) | run-report | ALIGNED |
| document-integration-qc | Yes (Stage 5, Step 5.1) | No command | DOCUMENT-ONLY |
| context-pack-builder | No | create-context-pack | COMMAND-ONLY |
| knowledge-file-producer | No | produce-knowledge-file | COMMAND-ONLY |
| session-usage-analyzer | No | usage-analysis | COMMAND-ONLY |
| workflow-evaluator | No | workflow-status | COMMAND-ONLY |
| evidence-prose-fixer | No | verify-chapter | COMMAND-ONLY |
| chapter-review | No | review | COMMAND-ONLY |
| repo-health-analyzer | No | audit-repo | COMMAND-ONLY |
| architecture-qc | No | run-report | COMMAND-ONLY |
| report-compliance-qc | No | run-report | COMMAND-ONLY |

### 5.2 Gates

| Gate Description | In stage-instructions.md | In Commands | Status |
|-----------------|--------------------------|-------------|--------|
| Operator reviews Task Plan | Yes (Stage 1) | run-preparation Step 1b PAUSE | ALIGNED |
| Operator reviews Research Plan before answer specs | Yes (Stage 1) | run-preparation Step 3 GATE | ALIGNED |
| Operator confirms answer specs approved before Stage 2 | Yes (Stage 1) | run-preparation Step 5 PAUSE | ALIGNED |
| Operator reviews execution manifest session architecture | Yes (Stage 2, Step 2.0) | run-execution Step 2.0 PAUSE | ALIGNED |
| Prompt QC pass before execution | Yes (Stage 2, Step 2.1b) | run-execution Step 2.1b | ALIGNED |
| All extracts APPROVED before Stage 3 | Yes (Stage 2, Step 2.4) | run-execution Step 2.4 | ALIGNED |
| Operator reviews query brief (2.S1) | Yes (Stage 2, Step 2.S1) | run-execution Step 2.S1 GATE | ALIGNED |
| Operator confirms merge summary (2.S3) | Yes (Stage 2, Step 2.S3) | run-execution Step 2.S3 GATE | ALIGNED |
| Operator reviews refined cluster memo | Yes (Stage 3, Step 3.3) | run-cluster Step 3 PAUSE | ALIGNED |
| Operator reviews gap assessment routing | Yes (Stage 3, Step 3.4) | run-analysis Step 2 PAUSE | ALIGNED |
| Operator reviews gap queries (3.S1) | Yes (Stage 3, Step 3.S1) | run-analysis Subworkflow 3.S S.1 GATE (implied) | ALIGNED |
| Operator confirms merge summary (3.S3) | Yes (Stage 3, Step 3.S3) | run-analysis Subworkflow 3.S S.3 PAUSE | ALIGNED |
| Operator reviews each chapter (Stage 4) | Yes (Stage 4) | run-report Step 4.2 PAUSE | ALIGNED |
| Operator reviews v1.4 drafts (Stage 5, Step 5.4) | Yes (Stage 5) | No command | DOCUMENT-ONLY |
| Final operator review (Stage 5) | Yes (Stage 5) | No command | DOCUMENT-ONLY |

### 5.3 Rule Enforcement

| Rule (from CLAUDE.md) | Enforced by Hook | Referenced in Command | Enforcement Level |
|-----------------------|------------------|-----------------------|-------------------|
| Research Execution GPT produces evidence — Claude does not substitute its own research | No | run-execution (implicit via skill delegation) | behavioral-only |
| Research Execution GPT verifies Claude's prose — Claude does not fact-check its own writing | No | verify-chapter (delegates to execution-agent for GPT-5 API) | command-referenced |
| Perplexity handles factual retrieval — Claude routes queries, does not guess answers | No | run-execution Subworkflow 2.S, run-analysis Subworkflow 3.S (operator runs Perplexity manually) | command-referenced |
| Steps tagged [Operator] — always pause for input | No | All pipeline commands implement PAUSE at [Operator] steps | command-referenced |
| Sub-agents receive content, not file paths | No | All pipeline commands pass content to sub-agents | behavioral-only |
| Verification Agent reads source files directly (exception) | No | verification-agent.md tools: Read, Glob, Grep | command-referenced |
| Sub-agents do not persist state between invocations | No | None | behavioral-only |
| Sub-agents do not inherit parent's session state | No | Pipeline commands pass working state explicitly | behavioral-only |
| Every cited chapter must include a complete bibliography | No | run-report (citation-converter skill handles this) | command-referenced |
| Never substitute "sources listed in other modules" | No | None explicitly | behavioral-only |
| Bright-Line Rule: 3 checks before ANY fix to report prose | Yes (PreToolUse Edit matcher — inline bright-line check on report/chapters and final/modules paths) | run-report Step 4.2f, verify-chapter Step 3b | hook-enforced |
| Bright-Line Rule: fix MUST NOT be applied without explicit operator approval if any check true | Yes (same hook — blocks with decision message) | run-report, verify-chapter | hook-enforced |
| Log bright-line decisions to /logs/decisions.md | Yes (UserPromptSubmit hook logs operator decisions at gates) | verify-chapter Step 3e, run-report Step 4.2f | hook-enforced |
| Verify files by reading filesystem, not git status/diff | No | None | behavioral-only |
| Commit fails with no staged changes — report once and move on | No | None | behavioral-only |

---

## Section 6: Raw Observations

### 6.1 Stage 5 Gap

Stage 5 (Final Production) is defined in stage-instructions.md with 8 steps (5.1-5.8) including document-integration-qc, formatting, merge, and compilation. No implementing command exists. The `document-integration-qc` skill exists in ai-resources/skills/ but is referenced only in the stage-instructions document and the qc-gate agent's criteria routing table, not in any command file.

### 6.2 check-claim-ids.sh Registration

The hook script `check-claim-ids.sh` exists in .claude/hooks/ but is not registered in settings.json. It is only invoked manually by the `verify-chapter` command (Step 1b) via an explicit bash call. The other three hook scripts are all registered in settings.json as PostToolUse hooks.

### 6.3 Duplicate Functionality

`intake-reports` and `run-execution` (Steps 2.2a and 2.2b) contain overlapping functionality for filing raw reports and injecting dependencies. `inject-dependency` also overlaps with `run-execution` Step 2.2a. These appear to be standalone convenience alternatives to the monolithic `run-execution` command.

### 6.4 Agent References Not Matching Agent Files

Several commands reference agent types that do not correspond to files in .claude/agents/:
- `qc-reviewer` (referenced by qc-pass) — no qc-reviewer.md agent file exists. The closest is qc-gate.md.
- `refinement-reviewer` (referenced by refinement-pass) — no refinement-reviewer.md agent file exists.

### 6.5 Commands with friction-log: true Frontmatter

8 commands have `friction-log: true`: review, run-analysis, run-cluster, run-execution, run-preparation, run-report, run-synthesis, verify-chapter. These are all pipeline commands. The friction-log-auto.sh hook reads this frontmatter and auto-creates friction log sessions.

### 6.6 Model Assignments

- execution-agent: sonnet (handles API calls)
- improvement-analyst: opus (analytical work)
- qc-gate: sonnet (evaluation)
- verification-agent: sonnet (independent verification)
- intake-reports command: states "This command MUST run on Opus" for verbatim raw report copying.

### 6.7 External Dependencies

Two SessionStart hooks reference scripts in the parent ai-resources repo:
- `check-template-drift.sh` at `{parent}/ai-resources/.claude/hooks/`
- `auto-sync-shared.sh` at `{parent}/ai-resources/.claude/hooks/`
These are discovered by walking up the directory tree from CLAUDE_PROJECT_DIR.

### 6.8 Subworkflow 3.S Prompt Files

The run-analysis command's Subworkflow 3.S references prompt files in `ai-resources/prompts/supplementary-research/`:
- S0-extract-failed-components.md
- S1-query-brief-pass1.md / S1-query-brief-pass2.md
- S3-qc-supplementary-results.md
- S4-merge-instructions.md

These are separate from the skill files and were not inventoried as skills.

### 6.9 Scarcity Register as Cross-Cutting Input

The scarcity register (`execution/scarcity-register/{section}/{section}-scarcity-register.md`) is consumed by 6 commands: run-cluster, run-analysis, run-synthesis, run-report, review, verify-chapter. It is produced by run-execution (Subworkflow 2.S) and updated by run-analysis (Subworkflow 3.S).

### 6.10 Context Management Patterns

Pipeline commands use three context management strategies:
1. Step checkpoints after each major step (target: under 500 tokens)
2. Explicit `/compact` markers at natural boundaries
3. Sub-agent delegation for heavy steps (marked [delegate] or [delegate-qc])
