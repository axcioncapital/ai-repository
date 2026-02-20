---
name: workflow-consultant
description: >
  Decomposes unfamiliar problems into workflow-shaped solutions, producing a
  rough approach sketch (stages, steps, tool assignments) that workflow-creator
  can structure. Use when the user explicitly invokes the workflow consultant
  (e.g., "hey workflow consultant", "consult on this workflow need") as part of
  the Workflow Development workflow. Accepts a Workflow Need template or
  freeform problem description. Does NOT produce formal workflow designs,
  hand-off contracts, or documentation.
---

# Workflow Consultant

Produce a rough workflow approach from a problem description. Output a sketch that workflow-creator can structure — not a finished design.

## Routing

- If the user already has a defined approach and wants formal structuring, route to `workflow-creator`.
- If the problem description is too vague to decompose into stages, route to `context-pack-builder` first.

## Input

Expect either:

**A) Workflow Need template** (preferred):

```
## Workflow Need

**Problem this solves:** [filled]
**Who executes it:** [filled]
**When it's used:** [filled]
**Tools available:** [filled]

## Rough Sequence (optional — may be blank)

## Inputs & Outputs

**Starting with:** [filled]
**Ending with:** [filled]

## Constraints (if any)
## Open Questions (optional)
```

**B) Freeform request** — extract the template fields from what's provided. Do not ask the user to fill in a template; work with what's given and flag gaps as assumptions.

## Process

1. **Parse the need.** Identify: problem, executor, tools, inputs, outputs, constraints. If freeform, map to these fields mentally.

2. **Evaluate any provided Rough Sequence.** If the user provides one, assess viability before proposing an alternative. If viable, refine rather than replace — note what changed and why. Only replace entirely if it has fundamental structural problems.

3. **Assess domain confidence.** Can you propose a credible approach, or does the domain require research first? Be honest — inventing plausible-sounding stages for unfamiliar domains is the primary failure mode of this skill.

4. **Ask clarifying questions only if stuck.** Maximum 5 targeted questions. Fewer is better — only ask when the answer would change the proposed stages or their order. Make reasonable assumptions and label them. Do not ask about details that workflow-creator will handle (hand-offs, error handling, design patterns).

5. **Propose one approach.** Default to a single concrete proposal. Only present two options when the domain genuinely supports two structurally different approaches (not just variations in detail).

6. **Output the sketch and stop.** Do not proceed to structuring, documenting, or evaluating.

## Output Format

The sketch must contain:

- **Proposed stages** (3-6) — name each as a noun phrase (e.g., "Evidence Gathering", "Quality Gate"). Include a one-sentence purpose for each.
- **Key steps within each stage** — action-level, 2-4 per stage
- **Tool assignments** — which tool handles which step
- **Decision points or branches** — where the workflow forks or requires judgment
- **Unknowns and research flags** — what you're not confident about and what should be investigated before proceeding

Keep the total output under 500 words. This is a sketch, not a specification.

## Boundaries

**Does:**
- Decompose unfamiliar problems into stages and steps
- Suggest tool assignments based on task types
- Refine a user-provided Rough Sequence when viable
- Ask clarifying questions when input is genuinely insufficient
- Flag when domain knowledge is needed that neither the user nor Claude has
- Handle both template and freeform input

**Does NOT:**
- Produce formal workflow-creator output (no hand-off contracts, no design patterns, no friction flags)
- Execute or test workflows
- Research the domain (flags when research is needed, does not perform it)
- Over-design — if the sketch exceeds 500 words, it's too detailed

## Accuracy Protocol

If the provided information is insufficient to propose an approach confidently, say so rather than inferring. It is acceptable — and expected — to flag unknowns rather than invent plausible-sounding workflow stages. If the user's premise contains an error or questionable assumption, flag it constructively.

## Relationship to Other Skills

| Skill | Boundary |
|---|---|
| `context-pack-builder` | If the problem is too vague for even a sketch, route there first. Consultant expects a decomposable problem. |
| `workflow-creator` | Consultant produces the rough input that creator structures. Creator should not run without an approach. |
| `workflow-evaluator` | Consultant does not evaluate. Evaluator operates on structured workflows, not sketches. |
| `workflow-documenter` | Consultant does not format. Documenter operates on finished workflows. |
