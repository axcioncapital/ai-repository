# Claude Code Feature Pattern Library

Pattern-matching rules for mapping workflow steps to Claude Code features. Each entry describes the workflow pattern that triggers the feature, not the feature itself — Claude already knows what these features are.

## Slash Commands

**Pattern:** Any workflow that gets triggered repeatedly with similar but not identical inputs.

**Mapping rule:** If a workflow is invoked as a named action with variable parameters (e.g., "create a skill for X," "run QC on Y"), it should be a slash command at `.claude/commands/{command-name}.md` with `$ARGUMENTS` for the variable parts.

**Not a match:** One-off workflows, workflows triggered by external events rather than user action.

## Subagents

Three distinct patterns, each with different use cases:

### Workflow Subagents
**Pattern:** Steps that can execute independently of other steps in the pipeline — no shared inputs, no ordering dependency.

**Mapping rule:** If two or more steps read different inputs and write different outputs, they can run as parallel subagents. Pass each subagent only the context it needs.

**Not a match:** Steps that depend on the output of a previous step. Steps where the order matters.

### QC Subagents
**Pattern:** Any evaluation step that assesses quality of output produced earlier in the same pipeline.

**Mapping rule:** Spawn a separate subagent that receives only the evaluator instructions and the artifact to evaluate — no drafting conversation, no design rationale, no user context. Context isolation prevents self-evaluation bias.

**Not a match:** Inline feedback during drafting (that's iteration, not evaluation). Checks that require knowledge of the user's intent beyond what's in the artifact.

### Verification Subagents
**Pattern:** High-stakes outputs where errors are costly and independent validation adds confidence.

**Mapping rule:** Spawn a subagent that re-derives the same conclusion from the same source material, independently. Compare the two outputs for divergence. Flag differences for human review.

**Not a match:** Low-stakes outputs. Outputs where re-derivation isn't meaningful (e.g., creative writing).

## Hooks

**Pattern:** Quality gates that check structural completeness, file presence, or format compliance — deterministic checks, not judgment calls.

**Mapping rule:** If a gate can be expressed as "don't proceed unless X exists / X has the right format / X contains required sections," it's a hook. Hooks are scripts (bash, python) that run at lifecycle events and block advancement on failure.

**Not a match:** Quality checks requiring AI judgment (tone, coherence, strategic alignment). Gates that need conversation context to evaluate.

## CLAUDE.md Conventions

**Pattern:** Context that must persist across sessions — project structure, file conventions, behavioral constraints, cross-references between resources.

**Mapping rule:** If a workflow relies on conventions, constraints, or contextual knowledge that would otherwise need to be restated at the start of every session, encode it in CLAUDE.md.

**Not a match:** Session-specific context. Instructions that only apply during one workflow run.

## File-Based Pipelines

**Pattern:** Multi-step processes where outputs feed into downstream steps.

**Mapping rule:** If the workflow has stages that produce artifacts consumed by later stages, define a directory structure where each stage reads from and writes to known locations. Workflow state lives in the file tree — what exists tells you where you are.

**Not a match:** Single-step processes. Workflows where all context stays in conversation.

## Headless Mode

**Pattern:** Workflow steps that run unattended — no human judgment needed during execution, output is a file or notification.

**Mapping rule:** If a step has well-defined inputs, deterministic execution, and produces a file artifact without needing mid-step human decisions, it can run headless. Configure permissions via `--allowedTools` to scope what the headless instance can do.

**Not a match:** Steps requiring human judgment mid-execution. Steps where the user needs to steer direction during the work.

## Plan Mode

**Pattern:** High-stakes or complex steps where misalignment between user intent and Claude's approach would be costly to fix after execution.

**Mapping rule:** If a step involves significant file modifications, architectural decisions, or irreversible changes, default to plan mode for that step. Claude presents its execution plan before acting; user approves before files are modified.

**Not a match:** Simple, low-risk steps. Steps where the action is fully specified and there's nothing to misalign on.

## Parallel Execution

**Pattern:** Batches of independent tasks that share no inputs or outputs.

**Mapping rule:** If multiple steps (or multiple runs of the same step on different inputs) have no dependencies between them, run them concurrently. This is a modifier on other features — parallel subagents, parallel headless instances.

**Not a match:** Steps with ordering dependencies. Steps that read each other's outputs.
