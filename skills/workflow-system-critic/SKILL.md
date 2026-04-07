---
name: workflow-system-critic
description: >
  Evaluates a workflow system analysis artifact and produces prioritized
  findings on infrastructure coherence — skill interface compatibility,
  pipeline continuity, document-system drift, orphaned components, rule
  enforcement gaps, and hook coherence. Use after workflow-system-analyzer
  has produced an analysis artifact. Accepts an optional depth flag for
  friction correlation and deployed project drift analysis. Produces a
  structured critique report with severity-classified findings and ranked
  recommendations. Do NOT use for evaluating workflow document quality
  or architecture patterns (workflow-evaluator), creating workflows
  (workflow-creator), or analyzing individual skills (ai-resource-builder).
---

# Workflow System Critic

Evaluate a workflow's deployed infrastructure for coherence, compatibility, and completeness. Work from a structured analysis artifact — not from raw infrastructure files.

## Inputs

You receive:

1. **ANALYSIS_ARTIFACT_PATH** — path to the analysis artifact produced by workflow-system-analyzer
2. **STAGE_INSTRUCTIONS_PATH** — path to the workflow's definition document (may be "None" if not found)
3. **WORKFLOW_CLAUDE_MD_PATH** — path to the workflow's own CLAUDE.md
4. **CRITIQUE_OUTPUT_PATH** — where to save the critique report
5. **DEPTH** — "standard" or "deep"
6. **DEPLOYED_PROJECT_PATHS** — list of paths to deployed projects using this workflow (may be empty; only relevant for deep mode)

## Execution

Read the analysis artifact in full. Then apply six evaluation checks (standard) or nine (deep).

### Check 1: Skill Interface Compatibility

For each skill in the Skill Interface Registry (the Skill Interface Registry section of the analysis):

1. **Existence check.** If the skill is marked MISSING, this is a finding. Check if near-matches were found — a near-match suggests a typo (Critical), while no near-match suggests the skill was removed or never existed (Critical).

2. **Input compatibility.** Compare the skill's expected inputs (from the registry) against what the referencing command actually provides. Look for:
   - Command passes a file path but skill expects inline content (or vice versa)
   - Command passes output from step N but skill expects output from a different step
   - Command doesn't explicitly pass an input the skill requires
   - Skill has dependencies (reference files, scripts) that the command doesn't account for

3. **Output compatibility.** Compare the skill's output format against what the next command in the pipeline expects to receive. Look for:
   - Skill produces a format different from what downstream commands read
   - Skill writes to a path different from where downstream commands look

4. **Tool mismatch.** If the skill assumes a specific tool (e.g., Claude Chat), but the command runs in a different tool (e.g., Claude Code), flag it.

Severity:
- Missing skill: **Critical**
- Skill name typo (near-match exists): **Critical**
- Input/output format mismatch: **High**
- Missing dependency not accounted for: **High**
- Tool mismatch: **Medium**

### Check 2: Pipeline Continuity

Review the Hand-off Chain table in the Pipeline Trace section of the analysis:

1. **Broken hand-offs.** Any entry with status `UNCONNECTED` — command N writes to path X, but command N+1 reads from path Y with no apparent connection. This means artifacts produced by one stage may not be found by the next.

2. **Likely but unverified hand-offs.** Any entry with status `LIKELY` — directory matches but filename patterns differ. May work if the consuming command uses glob patterns, but is a risk.

3. **Missing coverage.** Compare the Stage-to-Command Mapping table against the workflow definition. Any stage with no implementing command, or a stage with `Coverage Notes` indicating partial coverage.

4. **Orphaned commands.** Review the Unmapped Commands table. Classify each as:
   - Utility command (e.g., `/status`, `/prime`, `/improve`) — expected, not a finding
   - Pipeline command with no stage — potential finding if it appears to implement workflow logic

Severity:
- Broken hand-off in the main pipeline path: **Critical**
- Stage with no implementing command: **High**
- Likely-but-unverified hand-off: **Medium**
- Orphaned pipeline-like command: **Low**

### Check 3: Document-System Drift

Compare the Cross-Reference Matrix section of the analysis against the workflow definition and CLAUDE.md:

1. **DOCUMENT-ONLY skills.** Skills declared in stage-instructions.md but not referenced by any command. This means the workflow document promises a skill is used, but no command actually invokes it. The skill's work may be done inline (acceptable but fragile) or may be skipped entirely (problematic).

2. **COMMAND-ONLY skills.** Skills used by commands but not mentioned in the workflow document. The workflow document doesn't reflect reality. This is a documentation gap, not a runtime risk.

3. **DOCUMENT-ONLY gates.** Gates declared in the workflow document but not implemented in any command. The workflow promises an operator review point that won't actually happen.

4. **COMMAND-ONLY gates.** Gates in commands not described in the workflow document. Operator will encounter unexpected pauses.

Severity:
- Document-only gate (promised review that doesn't happen): **High**
- Document-only skill (promised processing that may not happen): **High**
- Command-only gate (unexpected pause): **Medium**
- Command-only skill (documentation gap): **Low**

### Check 4: Rule Enforcement Gaps

Review the Rule Enforcement table in the Cross-Reference Matrix section of the analysis:

1. **Behavioral-only rules with high consequences.** Rules in CLAUDE.md that are `behavioral-only` (no hook enforcement, no command reference) AND where violating the rule would cause significant harm (data loss, wrong output, skipped review). These are fragile — they rely entirely on Claude following instructions.

2. **Hook-enforced rules with implementation gaps.** Rules where a hook exists but:
   - The hook's matcher pattern might not catch all relevant operations
   - The hook checks a condition but doesn't actually block (warns instead of failing)

Not every behavioral-only rule needs a hook. Focus on rules where violation has high blast radius. Rules about formatting, style, or preferences are fine as behavioral-only.

Severity:
- High-consequence rule with no enforcement: **High**
- Hook that warns but doesn't block for a critical rule: **Medium**
- Documentation-quality rule that's behavioral-only: not a finding

### Check 5: Orphaned Components

Review all sections of the analysis for components that exist but serve no apparent purpose:

1. **Hooks with unconsumed output.** From the Hook Mapping section: hooks that write to files no command reads. The hook runs but its output is never used.

2. **Unregistered hook scripts.** From Component Inventory: hook scripts in the hooks directory that have no corresponding settings.json entry. They exist but never fire.

3. **Skills referenced but never called.** Skills that appear in the registry but no command references them (possible if the skill was removed from commands but left in the registry from an earlier version).

4. **Agents never spawned.** Agent definitions that no command references.

Severity:
- Unregistered hook script: **Medium** (silent failure — the hook was likely intended to run)
- Hook with unconsumed output: **Medium** (wasted computation, possible dead feature)
- Unused agent definition: **Low**
- Unreferenced skill in registry: **Low**

### Check 6: Hook Coherence

Review the Hook Mapping section and the Settings Entries table in the Component Inventory:

1. **Missing hook scripts.** Settings.json references a script file that doesn't exist. The hook will fail at runtime.

2. **Timeout accumulation.** Calculate cumulative timeout for a single write operation — sum of all PostToolUse Write hook timeouts. Flag if total exceeds 10 seconds (operations will feel slow) or 30 seconds (operations may time out).

3. **Duplicate coverage.** Multiple hooks checking the same condition on the same trigger. May cause conflicting behavior or redundant processing.

Severity:
- Missing hook script: **Critical**
- Cumulative timeout > 30s: **High**
- Cumulative timeout > 10s: **Medium**
- Duplicate coverage: **Low**

### Deep-Only Checks

Skip these if DEPTH is "standard".

### Check 7: Friction Correlation (Deep Only)

Read friction logs and improvement logs from deployed projects at DEPLOYED_PROJECT_PATHS. For each deployed project, check:
- `logs/friction-log.md`
- `logs/improvement-log.md`
- `logs/session-notes.md`

For each friction entry found:
1. Does the friction description map to a specific infrastructure gap found in Checks 1-6? If so, the friction is explained by the gap — link them.
2. Does the friction describe a problem not captured by Checks 1-6? If so, this is a new finding — classify it as a previously-undetected infrastructure issue.
3. Are there recurring friction patterns (same type, 3+ occurrences)? These indicate systemic issues.

Severity:
- Recurring friction traceable to infrastructure gap: **High**
- One-time friction traceable to infrastructure gap: **Medium**
- Friction with no infrastructure explanation: **Low** (may be operator-side or environmental)

### Check 8: Deployed Project Drift (Deep Only)

For each deployed project, compare its `.claude/` directory against the workflow template:

1. **Command drift.** Diff each command file in the deployed project against the template version. Record: `identical`, `diverged` (with change summary), or `project-only` (command exists in project but not template) / `template-only` (command exists in template but not project).

2. **Hook/settings drift.** Same comparison for hooks and settings.json.

3. **Skill symlink integrity.** Check skill symlinks in the deployed project. Do they point to valid targets? Are the targets the current version of the skill?

Severity:
- Broken skill symlink: **Critical**
- Template-only command (deployed project missing a command the template has): **High**
- Diverged command (deployed project modified a template command): **Medium**
- Project-only command (project added a command not in template): **Low** (may be intentional)

### Check 9: Skill Staleness (Deep Only)

For each skill referenced by the workflow, check whether the SKILL.md file has been modified more recently than the deployed project's creation date (use git log for both). If a skill was updated after deployment, the deployed project may be using outdated skill behavior.

Severity:
- Skill with breaking changes (interface changed) since deployment: **High**
- Skill updated since deployment (content changes): **Medium**

## Findings Format

Each finding must contain:

```markdown
### [{priority}] {short title}
- **Check:** {which check found this — e.g., "Check 2: Pipeline Continuity"}
- **Location:** {file path(s) involved}
- **Evidence:** {what the analysis artifact shows — quote specific table entries}
- **Impact:** {what goes wrong because of this}
- **Recommendation:** {specific action — not "consider reviewing" but "add X to Y" or "rename A to B"}
```

## Output Format

Save the critique report to CRITIQUE_OUTPUT_PATH:

```markdown
# Workflow System Critique: {workflow name}

**Date:** YYYY-MM-DD
**Based on:** {ANALYSIS_ARTIFACT_PATH filename}
**Depth:** Standard / Deep

---

## Findings

### Critical ({count})
[findings]

### High ({count})
[findings]

### Medium ({count})
[findings]

### Low ({count})
[findings]

---

## Deep Assessment
[Only if depth = deep. Otherwise: "Not run. Use `/analyze-workflow {path} deep` to include."]

### Friction Correlation
[findings from Check 7]

### Deployed Project Drift
[findings from Check 8]

### Skill Staleness
[findings from Check 9]

---

## Summary

- Critical: {count}
- High: {count}
- Medium: {count}
- Low: {count}
- Total: {count}

**Top 3 recommendations by impact:**

1. **{action}** — {what goes wrong without it}
2. **{action}** — {what goes wrong without it}
3. **{action}** — {what goes wrong without it}
```

If fewer than 3 findings exist, list only what applies. If no findings at any severity level, state: "No {severity} findings. Checked: {list what was examined}."

## Failure Handling

- **Missing or empty artifact.** If the analysis artifact file does not exist or is empty, abort with: "Cannot proceed — analysis artifact not found or empty at {path}. Run Phase 1 first."
- **Missing sections in artifact.** If an expected section is missing (e.g., the artifact has Sections 1-3 but not 4-5 due to partial analysis), skip checks that depend on the missing section. Add a note at the top of the critique report: "Checks skipped due to incomplete artifact: {list checks and missing sections}."
- **Missing friction logs (deep mode).** If a deployed project's `logs/friction-log.md` or `logs/improvement-log.md` does not exist, note "No friction logs found at {project path}" and skip Check 7 for that project. This is expected — not all projects have friction logging active.
- **Invalid deployed project paths (deep mode).** If a path in DEPLOYED_PROJECT_PATHS does not exist or lacks a `.claude/` directory, skip Checks 7-9 for that path and note: "Skipped — path invalid or not a workflow project: {path}."
- **Section references.** This skill references analysis sections by title (e.g., "Skill Interface Registry", "Hand-off Chain", "Cross-Reference Matrix"). If the analyzer changes its section titles, match by content pattern rather than exact title — look for the table headers that define each section.

## Runtime Recommendations

- **Model:** Opus 4.6 (judgment-intensive evaluation requires strong reasoning)
- **Context budget:** Standard mode is lightweight — the analysis artifact is a compressed representation, so context usage is moderate. Deep mode with multiple deployed projects can be heavy; process one project at a time for Checks 7-9 and write findings incrementally.
- **When to use standard vs. deep:** Standard is appropriate for routine checks and after infrastructure changes. Deep is appropriate for periodic health reviews or when friction patterns suggest infrastructure issues.

## Example Finding

A realistic example of a completed finding entry:

```markdown
### [High] Skill interface mismatch: cluster-analysis-pass expects research extracts inline, command passes file paths
- **Check:** Check 1: Skill Interface Compatibility
- **Location:** `run-cluster.md` (line referencing cluster-analysis-pass), `skills/cluster-analysis-pass/SKILL.md`
- **Evidence:** Skill Interface Registry shows cluster-analysis-pass expects "inline research extract content" as input. Component Inventory shows run-cluster passes file paths: `/execution/research-extracts/{section}/`. The command reads files and passes content via sub-agent — but the hand-off is implicit, not documented in the command.
- **Impact:** If the command's file-reading step is skipped or modified, the skill receives paths instead of content, producing empty or malformed analysis.
- **Recommendation:** Add explicit file-reading instructions to run-cluster.md before the cluster-analysis-pass invocation, documenting that the command must read extract files and pass content, not paths.
```

## Rules

- **Work from the artifact.** Do not re-read infrastructure files. The analysis artifact is your source of truth for Checks 1-6. Exception: deep-mode checks (7-9) require reading friction logs and deployed project files directly.
- **Be specific.** Every finding must name exact files and reference exact table entries from the analysis.
- **Distinguish confidence levels.** If you're certain about a finding, state it plainly. If a finding depends on interpretation (e.g., "this might be intentional"), mark it with "?" suffix on the severity and explain.
- **No false positives over missed findings.** If uncertain, include the finding with a caveat rather than suppressing it. The operator can dismiss findings; they cannot discover ones you hid.
- **Respect the boundary with workflow-evaluator.** Do not evaluate the workflow document's design patterns, mastery criteria, or documentation quality. Those are workflow-evaluator's domain. You evaluate whether the deployed system matches and supports what the document declares.
