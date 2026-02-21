---
name: claude-code-workflow-builder
description: >
  Adapts existing workflows for Claude Code execution. Takes a workflow designed
  for Claude Chat, multi-tool orchestration, or any process document and rewrites
  steps to leverage Claude Code features — subagents, hooks, slash commands,
  file-based pipelines, headless mode, and others. The workflow logic, structure,
  and decision points remain intact; the execution model changes.
  Use when: (1) an existing workflow needs to move to Claude Code, (2) a
  process document needs Claude Code implementation planning.
  Do NOT use for: designing new workflows from scratch (use workflow-creator),
  evaluating workflow quality (use workflow-evaluator), documenting workflows
  (use workflow-documenter), or building the implementation files themselves
  (slash commands, hook scripts) — this skill specifies what's needed, not
  builds it.
---

# Claude Code Workflow Builder

## Core Principle: Minimum Viable Adaptation

Default to leaving steps unchanged. Only adapt a step when a Claude Code feature provides a concrete improvement over the current execution method. The goal is the minimum feature set that implements the workflow — not maximum feature coverage.

Before adapting any step, answer: "What specifically gets better?" If the answer is vague ("it's more automated"), leave the step as-is.

## Procedure

### 1. Triage the Input

Input: a workflow document provided as text (pasted or from a file) in any structured format — markdown, numbered steps, or stage/step hierarchy. No specific template required.

Read the input workflow end-to-end. Before adapting anything:

1. **Verify completeness.** The workflow should have named stages/steps with described actions, inputs/outputs, and decision points. If the workflow is too skeletal to adapt (no concrete actions, just goals), say so and ask for a more operationalized version.

2. **Flag vague steps.** Identify any steps too abstract to map to implementation (e.g., "ensure quality," "validate results" without specifying what's checked). List these separately — they need operationalization before adaptation. Do not block on them; adapt the rest of the workflow and return to flagged steps after the user clarifies.

3. **Note tool assignments.** Record which steps are assigned to which tools. Steps assigned to non-Claude tools (GPT-5, Perplexity, Notion) stay as external handoffs — adaptation focuses on the orchestration around them, not replacing them.

### 2. Classify Each Step

For every step in the workflow, assign one classification:

| Classification | Description | Typical adaptation |
|---|---|---|
| **Automated execution** | Claude performs a defined task with clear inputs/outputs | Subagent, slash command, or headless mode |
| **Quality gate** | A check that blocks progression | Hook (if deterministic) or QC subagent (if judgment-based) |
| **Human judgment point** | Requires user decision, approval, or steering | Preserve as manual checkpoint — do not automate |
| **Tool handoff** | Work passes to a non-Claude tool | Preserve as external step; adapt the handoff mechanism |
| **Context setup** | Establishes conventions, loads information | CLAUDE.md section or file-based pipeline |
| **Artifact production** | Produces a document, file, or deliverable | File-based pipeline with defined output location |

**Disambiguation:** If a step fits multiple classifications, apply the most specific one. Priority: Human judgment point > Quality gate > Tool handoff > Artifact production > Context setup > Automated execution.

### 3. Map Adapted Steps to Features

For each step classified as adaptable, consult `references/feature-patterns.md` and select the Claude Code feature(s) that match the step's pattern. Apply these rules:

- **One feature per step is typical.** If a step maps to multiple features, check whether it's actually two steps merged together. (Parallel Execution is a modifier, not a standalone feature — it doesn't count against this guideline.)
- **Pattern match must be specific.** "This could use a subagent" isn't sufficient. State which subagent pattern (workflow, QC, or verification) and why.
- **No feature is mandatory.** If no pattern matches cleanly, leave the step unchanged.
- **Flag uncertainty.** When a classification or feature mapping is genuinely ambiguous, say so in the adaptation notes. Present the selected option with reasoning, and note what would resolve the ambiguity. Do not present uncertain mappings with the same confidence as clear ones.

### 4. Write the Adapted Workflow

Produce the adapted workflow with these structural requirements:

**Preserve the original structure.** Same stage numbering, same step numbering. The source and adapted versions must be directly comparable.

**For each step, include:**
- The original step description (or a clear summary)
- **Adaptation:** what changed and which Claude Code feature was applied — or "Unchanged" with a brief reason
- **Setup requirements** (if adapted): what implementation files or configuration the step needs (e.g., "requires slash command at `.claude/commands/run-qc.md`")

**For unchanged steps:** A one-line note on why (e.g., "Human judgment point — preserved as manual checkpoint" or "Already effective as-is — no Claude Code feature improves this step").

**Example:**

> **Stage 2, Step 3: Draft the skill file**
> *Original:* Claude drafts SKILL.md in a chat artifact based on the approved outline.
> *Adaptation:* Write directly to `skills/{name}/SKILL.md` instead of a chat artifact. **Feature:** File-based pipeline.
> *Setup:* CLAUDE.md section defining the `skills/` directory convention.
>
> **Stage 2, Step 4: User reviews the draft**
> *Original:* User reads the draft and provides feedback.
> *Adaptation:* Unchanged — human judgment point.

### 5. Compile the Setup Requirements

After the adapted workflow, add a consolidated **Setup Requirements** section listing every implementation artifact the workflow needs:

- **Slash commands** — file path and purpose
- **CLAUDE.md sections** — what conventions or context to add
- **Hook scripts** — trigger event, what it checks, expected behavior
- **Directory structure** — folders the file-based pipeline expects
- **Other configuration** — permissions, MCP servers, headless mode settings

This section duplicates information from inline step notes, intentionally. Inline notes give context while reading; the consolidated list serves as a build checklist.

### 6. Review the Adaptation

Before presenting the adapted workflow, self-check:

- Every source step is accounted for — adapted or explicitly unchanged
- Human judgment points are preserved, not automated
- No feature is used without a specific pattern match justifying it
- Setup requirements are complete — nothing referenced in steps but missing from the consolidated list
- Someone familiar with the original workflow can read this and immediately see what changed

## Handling Edge Cases

**Workflow references tools not in Claude Code:** Flag as a prerequisite. "Step 4 requires Slack notifications via MCP — verify the Slack MCP server is configured before running this workflow."

**Steps span multiple tools:** Adapt the Claude Code portion; preserve the external tool portion. The handoff point (what Claude Code produces and where the external tool picks up) should be explicit.

**Workflow is already partially in Claude Code:** Adapt only the unadapted steps. Note which steps were already using Claude Code features and whether they're well-implemented or could be improved.

**Feature-patterns.md is inaccessible:** Proceed using Claude's general knowledge of Claude Code features. Note that pattern matches are less precise without the reference file.

**No steps benefit from adaptation:** This is a valid finding. Present "This workflow does not benefit from Claude Code adaptation" with per-step reasoning for why each step was left unchanged. Do not force adaptations to justify the skill's use.

## What This Skill Does Not Do

- Design workflows — it receives completed workflows only
- Build implementation files — it specifies what's needed (slash commands, hooks, etc.), the user builds them
- Evaluate workflow quality — it assumes the workflow logic is sound
- Decide whether a workflow should move to Claude Code — it assumes that decision is made
