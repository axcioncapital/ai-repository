---
name: workflow-system-analyzer
description: >
  Inventories and traces a workflow's deployed infrastructure — commands,
  agents, hooks, settings, skill references — and produces a structured
  analysis artifact. Use when analyzing how a workflow's infrastructure
  components connect, when preparing input for the workflow-system-critic
  skill, or when building a component inventory for a workflow. Produces
  facts and mappings only — no judgment, no findings, no recommendations.
  Do NOT use for evaluating workflow document quality (workflow-evaluator),
  creating workflows (workflow-creator), or analyzing repo-level health
  (repo-health-analyzer).
---

# Workflow System Analyzer

Systematically read every infrastructure file in a workflow's `.claude/` directory, extract structured data from each, trace the pipeline, and produce a structured analysis artifact. Facts only — no interpretation.

## Inputs

You receive:

1. **WORKFLOW_PATH** — absolute path to the workflow directory (e.g., `.../workflows/research-workflow`)
2. **AI_RESOURCES_PATH** — absolute path to the ai-resources repo root
3. **ANALYSIS_OUTPUT_PATH** — where to save the analysis artifact

## Execution

Work through five layers in order. After each layer, write a checkpoint summary to the analysis artifact file (append mode) so that progress is preserved if context runs out.

### Layer 1: Component Inventory

Discover and catalog all infrastructure files.

**Commands:** List all `.md` files in `{WORKFLOW_PATH}/.claude/commands/`. For each command file, read it and extract:
- Frontmatter fields (any YAML between `---` markers at the top)
- Skill references — scan the body for skill names (patterns: `apply \`skill-name\``, `skills/skill-name`, `skill-name` SKILL.md, `skill-name` logic)
- Agent references — scan for subagent launches (patterns: `Launch the \`agent-name\``, `subagent`, `delegate`)
- Gates — scan for `GATE:`, `[Operator]`, `Wait for operator`, `pause`
- Input/output paths — scan for filesystem paths the command reads from or writes to

**Agents:** List all `.md` files in `{WORKFLOW_PATH}/.claude/agents/`. For each, extract:
- Frontmatter: name, description, model, tools
- What invokes this agent (cross-reference with command inventory)

**Hooks:** List all files in `{WORKFLOW_PATH}/.claude/hooks/`. For each script, read it and extract:
- What it checks or does (brief summary)
- What files it reads
- What files it writes to or appends to
- Exit conditions (what causes it to fail/block)

**Settings:** Read `{WORKFLOW_PATH}/.claude/settings.json` if it exists. For each hook entry, extract:
- Trigger type (PreToolUse, PostToolUse, UserPromptSubmit, etc.)
- Matcher pattern
- Command path
- Timeout
- Whether it maps to a hook script in the hooks directory

**Output tables:**

```markdown
## Section 1: Component Inventory

### 1.1 Commands ({count} total)
| Command | Skills Referenced | Agents Spawned | Gates | Frontmatter Flags |
|---------|------------------|----------------|-------|-------------------|

### 1.2 Agents ({count} total)
| Agent | Model | Tools | Invoked By |
|-------|-------|-------|------------|

### 1.3 Hooks ({count} total)
| Hook Script | Reads | Writes | Blocks When |
|-------------|-------|--------|-------------|

### 1.4 Settings Entries ({count} total)
| Trigger | Matcher | Script | Timeout | Script Exists |
|---------|---------|--------|---------|---------------|
```

### Layer 2: Skill Interface Extraction

Compile a registry of every skill referenced by any command in Layer 1.

For each unique skill name found:
1. Check if `{AI_RESOURCES_PATH}/skills/{skill-name}/SKILL.md` exists.
2. If it exists: read the full SKILL.md. Extract:
   - **Trigger conditions** — when should this skill be used
   - **Exclusions** — when should this skill NOT be used
   - **Expected inputs** — what the skill expects to receive (files, content, parameters)
   - **Output format** — what the skill produces
   - **Tool expectations** — which tool the skill assumes it runs in (Claude Code, Claude Chat, etc.)
   - **Dependencies** — other files the skill references (reference files, scripts, other skills)
3. If it does not exist: record as `MISSING — no SKILL.md found at expected path`.
4. Check for near-misses: if a skill is missing, grep `{AI_RESOURCES_PATH}/skills/` for similar names (single-character differences, missing hyphens, plural/singular variants). Record any near-matches.

**Context management:** Process skills in batches of 3-4. After each batch, write the extracted registry entries to the analysis artifact and discard the raw SKILL.md content from working memory.

**Output table:**

```markdown
## Section 2: Skill Interface Registry

### Referenced Skills ({count} total, {found} found, {missing} missing)
| Skill | Exists | Inputs | Outputs | Tool | Dependencies | Referenced By |
|-------|--------|--------|---------|------|-------------|---------------|
```

For missing skills, add a separate table:

```markdown
### Missing Skills
| Skill Name | Referenced By | Near-Matches |
|------------|--------------|-------------|
```

### Layer 3: Pipeline Trace

Map the workflow's stage-based pipeline to its implementing commands.

1. Read the workflow definition document. Check these locations in order:
   - `{WORKFLOW_PATH}/reference/stage-instructions.md`
   - `{WORKFLOW_PATH}/stage-instructions.md`
   - `{WORKFLOW_PATH}/CLAUDE.md` (look for stage definitions in the body)
   If none found, record: "No workflow definition document found. Pipeline trace based on command analysis only."

2. For each stage defined in the workflow document, identify which command(s) implement it. Match by:
   - Command names that include stage keywords (e.g., `/run-preparation` for Stage 1: Preparation)
   - Command bodies that reference the stage by name or number
   - Command bodies that reference the same skills as the stage definition

3. For each consecutive command pair in the pipeline, trace the filesystem hand-off:
   - What paths does command N write to? (from Layer 1 extraction)
   - What paths does command N+1 read from?
   - Do the paths match? Record: `CONNECTED` (exact match), `LIKELY` (directory matches but filename pattern differs), or `UNCONNECTED` (no apparent match).

4. Identify commands not mapped to any stage (orphaned commands — may be utility commands, which is fine, just record them).

**Output:**

```markdown
## Section 3: Pipeline Trace

### 3.1 Stage-to-Command Mapping
| Stage | Step(s) | Implementing Command(s) | Coverage Notes |
|-------|---------|------------------------|----------------|

### 3.2 Hand-off Chain
| From Command | Output Path(s) | To Command | Input Path(s) | Status |
|-------------|----------------|------------|----------------|--------|

### 3.3 Unmapped Commands
| Command | Apparent Purpose |
|---------|-----------------|
```

### Layer 4: Hook Mapping

Map how hooks interact with commands and the pipeline.

For each hook registered in settings.json (Layer 1):
1. Which trigger type fires it?
2. Which command operations would match its matcher pattern?
3. What does the hook script do when triggered? (from Layer 1 hook analysis)
4. Does the hook's output (if any) get consumed by any command? Cross-reference hook write paths with command read paths from Layer 1.

**Output:**

```markdown
## Section 4: Hook Mapping

### Hook-Command Interaction
| Hook | Trigger | Fires During | Output | Output Consumed By |
|------|---------|-------------|--------|--------------------|

### Hook Coverage Summary
- Hooks with consumed output: {count}
- Hooks with unconsumed output: {count} (list them)
- Cumulative timeout per write operation: {sum}ms
```

### Layer 5: Cross-Reference Matrix

Compare what the workflow document declares against what the infrastructure implements.

1. **Skill cross-reference:** List every skill mentioned in the workflow definition document (stage-instructions.md). List every skill referenced in commands. Produce a comparison:
   - Skills in document AND in commands: `ALIGNED`
   - Skills in document but NOT in any command: `DOCUMENT-ONLY`
   - Skills in commands but NOT in document: `COMMAND-ONLY`

2. **Gate cross-reference:** List every gate declared in the workflow definition document. List every gate implemented in commands. Produce a comparison:
   - Gates in document AND in commands: `ALIGNED`
   - Gates in document but NOT in any command: `DOCUMENT-ONLY`
   - Gates in commands but NOT in document: `COMMAND-ONLY`

3. **Rule-enforcement cross-reference:** Read the workflow's CLAUDE.md. Identify behavioral rules (sections that say "must," "always," "never," "do not"). For each rule, check:
   - Is it enforced by a hook? (hook script checks for the condition)
   - Is it referenced in a command? (command body mentions the rule)
   - Is it neither? (rule exists only as a behavioral instruction to Claude)

**Output:**

```markdown
## Section 5: Cross-Reference Matrix

### 5.1 Skill References
| Skill | In Document | In Commands | Status |
|-------|-------------|-------------|--------|

### 5.2 Gates
| Gate Description | In Document | In Commands | Status |
|-----------------|-------------|-------------|--------|

### 5.3 Rule Enforcement
| Rule (from CLAUDE.md) | Enforced by Hook | Referenced in Command | Enforcement Level |
|-----------------------|------------------|-----------------------|-------------------|
```

Enforcement levels: `hook-enforced` (automated check), `command-referenced` (mentioned but not automated), `behavioral-only` (relies on Claude following instructions).

## Output Format

Save the complete analysis artifact to ANALYSIS_OUTPUT_PATH as a single markdown file with this header:

```markdown
# Workflow System Analysis: {workflow name}

**Date:** YYYY-MM-DD
**Workflow path:** {WORKFLOW_PATH}
**Components:** {N} commands, {N} agents, {N} hooks, {N} settings entries, {N} skill references ({N} found, {N} missing)
```

Followed by Sections 1-5 as specified above.

## Failure Handling

- **Missing components.** If a directory or file doesn't exist (no hooks directory, no settings.json, no stage-instructions.md), record its absence in the relevant table and continue. Do not error out.
- **Ambiguous data.** When data is ambiguous (e.g., a skill reference could match multiple skills, or a command references a skill by two variant names), record all candidates and mark the entry as `AMBIGUOUS`. Do not resolve ambiguity — that is the critique phase's job.
- **Conflicting data.** When two sources contradict (e.g., settings.json says a hook has a 5s timeout but the script has a different embedded timeout), record both values. Do not choose between them.
- **Unreadable files.** If a file exists but cannot be parsed (e.g., malformed JSON in settings.json, binary file in hooks directory), record it as `UNREADABLE — {reason}` and continue.
- **Context exhaustion.** If context runs low after any layer, save the partial analysis artifact with a note at the end: `## INCOMPLETE — Layers {N-M} not completed due to context limits`. Return to the main agent with a partial status.

## Runtime Recommendations

- **Model:** Opus 4.6 (judgment-free but context-intensive; Opus handles large structured outputs reliably)
- **Context budget:** For a workflow with ~25 commands and ~15 skills, expect ~60-70% context usage. The batching strategy (commands in groups of 5-6, skills in groups of 3-4) keeps peak usage manageable.
- **Checkpoint strategy:** Write each completed section to the output file immediately. This means a partial artifact is still useful if context runs out.

## Example Output (Partial)

A realistic excerpt from Section 1.1 and Section 2:

```markdown
### 1.1 Commands (22 total)
| Command | Skills Referenced | Agents Spawned | Gates | Frontmatter Flags |
|---------|------------------|----------------|-------|-------------------|
| run-preparation | task-plan-creator, research-plan-creator, answer-spec-generator, answer-spec-qc | none | 3 (Task Plan review, Research Plan review, Answer Spec approval) | friction-log: true |
| run-execution | execution-manifest-creator, research-prompt-creator, research-prompt-qc, research-extract-creator, research-extract-verifier | qc-gate | 2 (Manifest review, Extract approval) | friction-log: true |
| prime | none | none | 0 | none |

### Referenced Skills (18 total, 17 found, 1 missing)
| Skill | Exists | Inputs | Outputs | Tool | Dependencies | Referenced By |
|-------|--------|--------|---------|------|-------------|---------------|
| task-plan-creator | Yes | Task plan draft (@ reference) | task-plan-v1.md | Claude Code | none | run-preparation |
| answer-spec-qc | Yes | Answer specs + research plan | QC verdict file | Claude Code | evaluation-framework.md | run-preparation |
| document-formatter | MISSING | — | — | — | Near-match: prose-formatter | run-report |
```

## Rules

- **Facts only.** Record what exists and how it connects. Do not assess quality, flag issues, or suggest improvements.
- **Be exhaustive.** List every component. Do not summarize or truncate.
- **Be precise.** Exact file names, exact paths, exact counts.
- **Preserve context.** Write checkpoint output after each layer. If context runs low, follow the failure handling protocol above.
