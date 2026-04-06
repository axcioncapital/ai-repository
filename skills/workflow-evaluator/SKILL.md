---
name: workflow-evaluator
description: >
  Evaluates workflows on architectural soundness (workflow-creator patterns),
  skill reference integrity, and documentation quality (workflow-documenter
  format). Use when Patrik says "evaluate this workflow," "review this
  workflow," "check this workflow," or provides a workflow and asks for
  assessment. Produces actionable evaluation reports with severity-classified
  findings covering design patterns, hand-off integrity, skill reference
  verification, context flow, execution risks, and documentation compliance.
  A workflow for this skill's purposes is a multi-step process document with
  defined stages, hand-offs, and tool assignments. Do NOT use for creating or
  redesigning workflows (workflow-creator), formatting/documenting workflows
  from scratch (workflow-documenter), evaluating non-workflow resources like
  single-stage procedures, SOPs without tool transitions, or checklists
  (ai-resource-builder).
---

# Workflow Evaluator

Evaluate workflows against two standards before production use: **workflow-creator** (architectural design patterns) and **workflow-documenter** (formatting and structure conventions).

## Context and Boundaries

**Evaluation standards:** workflow-creator (architecture) and workflow-documenter (documentation). General workflow design knowledge may supplement but not override these two standards. Do not import external frameworks or methodologies not referenced by the user.

**Skill repo access:** Required for Skill Reference Integrity checks (R1–R4) and for skill-informed architecture evaluation. If the skill repository is not accessible, skip R1/R2/R4 checks, note in the report that skill reference verification was not performed, and flag it as a limitation. R3 (purpose alignment) can still be assessed from the skill name and workflow context, but architecture checks will lack skill-level detail.

**Scope:** Evaluation only — do not rewrite, redesign, or restructure workflows. If asked to create or redesign a workflow, redirect to workflow-creator. If asked to format/document a workflow from scratch, redirect to workflow-documenter. If given a non-workflow resource, redirect to ai-resource-builder.

## Evaluation Modes

| Mode | Trigger | Scope |
|------|---------|-------|
| **Full** (default) | No mode specified | Architecture + skill references + documentation + execution risks |
| **Architecture only** | "logic check," "does this work" | Design patterns, hand-offs, skill references, context flow, friction, execution risks |
| **Documentation only** | "just the format," "formatting review" | Structure, numbering, conventions |
| **Quick scan** | "quick check," "quick look" | Surface-level obvious issues only |

## Architecture Evaluation

### Design Pattern Application

Check if workflow-creator patterns are applied where needed:

| Pattern | Check For | Flag If Missing |
|---------|-----------|-----------------|
| **State pinning** | Start of workflow; before complex sequences; when facts must persist | No state block where context could drift |
| **Stop conditions** | Before human review; after extraction; before high-stakes output | High-risk step without halt instruction |
| **Context isolation** | Different steps needing different context | Risk of context bleed between steps |
| **Progressive disclosure** | Large documents being loaded | Full doc loaded when summary would suffice |
| **Evidence/interpretation separation** | Research or analysis steps | Facts mixed with hypotheses |
| **Context refresh triggers** | Semantic boundaries; tool transitions; after human edits | Stale context carried >3 stages |

### Hand-off Chain Integrity

For each step pair (N -> N+1):
- Does Step N define explicit output?
- Does Step N+1 define explicit input?
- Does output format match input requirement?
- Is the connection stated in hand-off field?
- If either step uses a skill: does the skill's actual input/output format (from its SKILL.md) match what the workflow says it receives/produces? A workflow may claim a hand-off works, but the skill's own spec may expect different inputs or produce different outputs.

Flag: broken chain, implicit hand-off, format mismatch, workflow-to-skill format mismatch.

### Context Flow

Whether critical information survives transitions -- not just whether hand-offs are defined, but whether context degrades, gets lost, or arrives unusable.

Checks:
- What information does each step need that wasn't generated in the immediately preceding step? Is the path clear?
- Are context compression/transformation strategies explicit?
- Steps depending on information from 3+ steps back -> flag as context degradation risk
- Does context survive tool transitions in usable form?
- If a step uses a skill: does the skill require context or inputs that the workflow doesn't explicitly pass? Skills may have implicit input requirements (e.g., reference files, prior artifacts) visible only from reading their SKILL.md.

Context loss that silently degrades output quality -> Critical. Unclear but probably functional flow -> Moderate.

A hand-off can be structurally complete but fail context flow. Report both when applicable; do not deduplicate.

### Sub-workflow Architecture

Skip this section for linear workflows with no branching.

Checks:
- Are branch points explicit with clear triggers for each path?
- Is shared logic separated from path-specific logic? Flag duplication across branches.
- Are reconvergence points defined with required output from each branch?
- If branches produce different output formats, is there a normalization step before reconvergence?

Missing reconvergence definition -> Critical. Duplicated logic or unclear branch triggers -> Moderate.

### Tool Assignment

For each step with a tool tag:
- Is the tool appropriate for the task type?
- Are tool transitions explicit (export format, import method)?
- Are tool capabilities matched to step requirements?
- If the step uses a skill: does the skill's content indicate a specific tool expectation? Flag if the workflow assigns a different tool than the skill assumes.

### Skill Reference Integrity

Skip this section if the workflow references no skills by name.

For workflows that reference skills (by name, folder, or file path), verify each reference resolves correctly and understand what each skill actually does. This requires read access to the skill repository.

**Read each skill's full SKILL.md** — not just the YAML frontmatter. The skill body contains the actual processing logic, expected inputs, output formats, edge case handling, and constraints that determine whether it fits the workflow step it's assigned to. Use this knowledge to inform all architecture checks (hand-offs, context flow, tool assignment), not just the R1–R4 reference checks below.

| # | Check | Fail Condition |
|---|-------|---------------|
| R1 | Every skill referenced in the workflow exists in the repo | Skill name not found under `skills/` |
| R2 | Skill names match exactly (spelling, casing, hyphens) | Name is close but not identical (e.g., `document-formatter` vs `document-formater`) |
| R3 | Skill-to-stage purpose alignment (informed by full skill content) | A skill is assigned to a stage where its actual function, trigger conditions, or exclusions don't match the stage's task |
| R4 | Skills are not deprecated or superseded | A skill exists but its description or content indicates it has been replaced |

**How to check:**
- R1/R2: List all skill names mentioned in the workflow. For each, confirm a matching folder exists under `skills/`. For near-misses, check for single-character differences, missing hyphens, or plural/singular variants.
- R3: Read the skill's full SKILL.md. Compare its trigger conditions, exclusions, expected inputs, output format, and processing logic against the workflow stage's stated purpose and requirements. Flag if the skill wouldn't activate for this use case, if its exclusions rule out the stage's task, or if its outputs don't serve the stage's needs.
- R4: Check for language in the skill indicating deprecation ("replaced by," "superseded," "deprecated," "use X instead").

Missing skill blocking execution -> Critical. Near-miss name (likely typo) -> Critical. Purpose misalignment -> Moderate. Deprecated skill with functional replacement available -> Moderate.

### Friction Point Coverage

After completing the architecture checks above, verify that all workflow-creator friction types are accounted for: broken hand-offs, context loss, state ambiguity, tool transition friction, assumption contamination, missing checkpoint, scope creep, context rot.

Most friction types will already be captured by Hand-off Chain Integrity, Context Flow, and Tool Assignment findings. This step is a completeness sweep — flag any friction type that is present in the workflow but not already captured by the architecture checks above.

### Mastery Criteria

| Criterion | How to Check |
|-----------|--------------|
| 3-6 steps per stage | Count steps per stage |
| Clear hand-offs | Each step has output + hand-off fields |
| Output schema per step | Each step defines artifact format |
| At least one truth checkpoint | Stop condition exists somewhere |
| Stop conditions at review points | High-stakes steps have stops |
| Reproducible | Same inputs -> similar quality |

## Documentation Evaluation

### Structural Compliance

| Element | Requirement |
|---------|-------------|
| Stages | Numbered sequentially (1, 2, 3...) |
| Steps | Numbered hierarchically (1.1, 1.2, 2.1...) |
| Stage names | Descriptive nouns or noun phrases |
| Step titles | Action-oriented (start with verb) |
| Tool tags | Present when workflow spans 2+ tools |
| Conditionals/loops | In blockquotes with explicit routing |

### Step Content

Each step should have:
- 1-3 sentences following: action -> method -> destination
- **Output:** line specifying what step produces
- If >3 sentences, flag for potential split

### Clarity and Consistency

- Could someone unfamiliar execute from documentation alone?
- Are actions concrete and methods specific enough to reproduce?
- Terminology consistent throughout?
- Step outputs match how referenced later?
- Detail level consistent across steps?

## Execution Risks

Hidden dependencies, unstated assumptions, and practical failure points that pattern-based evaluation misses. Not an architecture pattern check -- a pragmatic assessment of what will break in practice.

Checks:
- **Hidden dependencies:** Does any step assume access to something not produced by the workflow or listed as input? For steps using skills, check whether the skill's SKILL.md reveals dependencies (reference files, scripts, prior artifacts) that the workflow doesn't account for.
- **Unstated assumptions:** Implicit requirements about tool capabilities, user knowledge, or environmental conditions?
- **Inter-stage conflicts:** Steps that contradict each other or produce conflicting outputs?
- **Fragile sequences:** Single failure cascades into multiple downstream problems with no recovery path?

Hidden dependency blocking execution -> Critical. Unstated assumption most users would miss -> Moderate. Fragile sequence with workaround -> Moderate.

If an execution risk overlaps with an architecture finding, report in Architecture only. Execution Risks captures issues not already covered by pattern-based checks.

## Severity Classification

| Severity | Definition | Examples |
|----------|------------|----------|
| **Critical** | Workflow will fail or produce wrong results | Broken hand-off; missing required pattern; dead-end path; referenced skill doesn't exist; skill name typo |
| **Moderate** | Works but with friction or risk | Missing recommended pattern; unclear hand-off; unflagged friction; skill-stage purpose misalignment; deprecated skill |
| **Minor** | Polish issues | Formatting inconsistency; optional improvement |

When uncertain, mark severity with "?" suffix and explain the uncertainty. Do not present uncertain findings with false confidence.

**Epistemic stance:** Distinguish between "this pattern is wrong" (clear violation of workflow-creator standards), "this pattern is unusual but might be intentional" (deviation without obvious failure mode), and "I lack context to judge this" (domain-specific logic beyond evaluation scope). For unusual-but-not-wrong patterns, report as observations rather than findings. For domain gaps, surface the observation with a note that domain expertise is needed to confirm.

## Verdict Logic

- **Ready** -- No critical issues; <=2 moderate issues; mastery criteria mostly met
- **Needs revision** -- Any critical issues OR >2 moderate issues OR mastery criteria gaps
- **Major gaps** -- Multiple critical issues OR fundamental design problems

## Output Format

```markdown
# Workflow Evaluation: [Workflow Name]

**Verdict:** [Ready / Needs revision / Major gaps]
**Mode:** [Full / Architecture only / Documentation only / Quick scan]

---

## Architecture Findings

### Critical
| Location | Issue | Impact | Recommendation |
|----------|-------|--------|----------------|
| [Step X.Y] | [Description] | [What goes wrong] | [Fix] |

### Moderate
| Location | Issue | Impact | Recommendation |
|----------|-------|--------|----------------|

### Minor
| Location | Issue | Impact | Recommendation |
|----------|-------|--------|----------------|

---

## Skill Reference Findings

| Skill Name | Check | Status | Notes |
|------------|-------|--------|-------|
| [skill-name] | R1 Exists | pass / fail | |
| [skill-name] | R2 Exact match | pass / fail | [near-miss if applicable] |
| [skill-name] | R3 Purpose alignment | pass / fail | |
| [skill-name] | R4 Not deprecated | pass / fail | |

If no skills referenced in workflow: "No skill references found — section skipped."

---

## Documentation Findings

### Structural Compliance
| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|

### Clarity Issues
| Issue | Location | Impact | Fix |
|-------|----------|--------|-----|

---

## Mastery Criteria Check

| Criterion | Status | Notes |
|-----------|--------|-------|
| 3-6 steps per stage with clear hand-offs | pass / warn / fail | |
| Output schema defined for each step | pass / warn / fail | |
| At least one truth checkpoint | pass / warn / fail | |
| Stop conditions at review points | pass / warn / fail | |
| Reproducible | pass / warn / fail | |

---

## Execution Risks

| Risk | Location | Impact | Mitigation |
|------|----------|--------|------------|

---

## Summary

**Top 3 priorities:**

1. **[Fix]** -- [What goes wrong without it.]
2. **[Fix]** -- [What goes wrong without it.]
3. **[Fix]** -- [What goes wrong without it.]

If fewer than 3 issues exist, state only what applies. If the workflow is ready, note what to watch during first test run instead.

Recommendations should describe *what* to fix and *why*, but should not provide rewritten workflow steps or restructured stage sequences. The workflow owner takes recommendations to workflow-creator for implementation.

[1-2 sentences on overall strengths.]
```

If no execution risks found, replace the table with: "No execution risks identified beyond architecture findings above."

If too few steps for meaningful execution risk assessment, skip the section and note: "Too few steps for execution risk assessment."

## Output Protocol

**Default mode: Refinement**

Before producing full evaluation:
1. Confirm which workflow is being evaluated
2. State evaluation mode being used
3. Note any ambiguities that affect evaluation
4. Ask only if answers would materially change findings

**Do not produce the full evaluation report until user says `RELEASE ARTIFACT`.** Exception: when invoked as a subagent or with explicit instruction to produce the full report immediately, skip the refinement protocol and output the complete evaluation directly.

On `RELEASE ARTIFACT`: Produce complete evaluation as artifact. Provide brief summary in chat: verdict + key findings count.

## Edge Cases

**Malformed input:** State what's missing, suggest minimum viable structure, ask if user wants partial evaluation. Do not force-fit criteria onto content that doesn't resemble a workflow.

**Standards conflict:** Note explicitly. workflow-creator takes precedence for architecture, workflow-documenter for formatting.

**Intentional deviations:** If workflow contains user-confirmed overrides, note but do not classify as error. Add: "Intentional deviation -- user confirmed."

**Incomplete workflow:** Suggest quick scan or architecture-only mode. Evaluate what exists; do not penalize TODO sections.

**Unfamiliar tools or domains:** Evaluate hand-off contracts (still applicable). Skip tool appropriateness for unknown tools. When domain-specific knowledge is insufficient to assess a finding's validity, report the observation with a note that domain expertise is needed to confirm. Do not skip findings due to domain uncertainty — surface them with appropriate caveats. Note: "Tool [X] not in standard reference -- appropriateness not assessed."

**Very large workflows (>6 stages or >25 steps):** Flag scope, evaluate fully, suggest breaking into sub-workflows if appropriate.
