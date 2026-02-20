---
name: ai-resource-improver
description: >
  Safely improve existing AI resources (skills, prompts, project instructions)
  based on feedback. Use when: (1) modifying an existing resource with bug fixes
  or enhancements, (2) applying behavioral fixes from real-world usage. Validates
  suggestions, detects breaking changes, scans for contradictions, and flags
  overly complex changes that warrant a new skill instead.
---

# AI Resource Improver

Safely modify existing AI resources based on feedback while protecting against breaking changes, scope creep, and flawed suggestions.

## Inputs

1. **Existing resource** — the current skill, prompt, or project instructions to modify
2. **Improvement suggestions** — bug reports, enhancement ideas, or behavioral fixes

If the existing resource is unparseable or incomplete, ask the user to provide a clean version before proceeding.

## Workflow

### Step 1: Confirm Understanding

Restate what resource is being modified and what each suggestion asks for.

For vague or informal feedback, surface interpretations as hypotheses ("I think you're saying...") and confirm before proceeding. Do not implement based on unconfirmed interpretations.

If suggestions within a single message contradict each other, surface the conflict and ask the user to resolve it.

**Hard gate:** Wait for user confirmation before proceeding to Step 2.

### Step 2: Triage Each Suggestion

Evaluate each suggestion:

| Check | Question | If fails |
|-------|----------|----------|
| **Clarity** | Specific enough to act on? | Ask clarifying question |
| **Logic** | Solves a real problem? | Flag as dubious, explain why, propose alternative, ask user to confirm |
| **Compatibility** | Conflicts with existing or related resource behavior? | Flag contradiction, ask user to resolve |
| **Complexity** | Requires 2+ new sections or major restructuring? | Recommend creating a new skill instead |

**Breaking change detection** — flag any change that:
- Alters output schema or required fields
- Removes or overrides a core constraint
- Renames required sections or headings
- Changes defaults that downstream resources depend on

**Compatibility scope:** Check within the resource being modified. If changes involve shared concepts (e.g., output formats used across skills), flag potential cross-resource impacts. Note when related resources are not in context.

**Pushback calibration:** If a flagged suggestion is insisted upon after explanation, implement it but note the concern in the change summary. User has final authority.

Process suggestions sequentially, output a single consolidated proposal.

### Step 3: Propose Changes

For each suggestion that passes triage:

```
**Change [#]:** [Short label]
- Location: [Exact section/heading]
- Current: "[Brief quote of current text]"
- Proposed: "[New text or description of edit]"
- Rationale: [Link to feedback]
- Unchanged: [What stays the same]
```

Present all proposed changes in a single numbered list.

### Step 4: Get Approval

Wait for explicit approval before implementing. If user approves some changes and rejects others, implement only the approved subset.

### Step 5: Implement Changes

Apply all approved changes. Consolidate into one updated version.

Preserve original structure (headings, ordering, YAML frontmatter) unless a change specifically requires restructuring.

### Step 6: Iteration Suggestions

Generate 2-4 iteration suggestions — improvements identified during the modification that the user did not request.

```
**Iteration [#]:** [Short label]
- What: [Specific change]
- Why: [What it improves]
```

Rules:
- Must go beyond the original feedback
- Focus on issues surfaced by the modifications (e.g., a tone change creating inconsistency elsewhere)
- Include at least one suggestion targeting failure behavior or edge cases
- Stay within the resource's existing scope

User picks numbers to apply, or skips. Apply selected suggestions, then re-run this step once (max one additional round).

### Step 7: Quality Check

Scan the modified resource for:

| Issue | Detection method |
|-------|------------------|
| **Contradictions** | New instruction conflicts with existing? MUST/NEVER conflicts, precedence ambiguity |
| **Ambiguity** | Vague terms introduced without definitions? |
| **Regression** | Existing functionality still works? Each step has clear output? |
| **Scope bloat** | Resource exceeding its stated purpose? |

If issues found:
1. Flag the specific issue
2. Propose alternative implementation
3. Prompt: "This change causes [issue]. Revert, or try alternative?"

Do not finalize with unresolved quality issues.

### Step 8: Deliver

Present the change summary first. Wait for user to confirm before delivering the full updated resource.

1. **Change summary** — numbered list of modifications with rationale
2. **Updated resource** — complete, same format as input (delivered on user confirmation)

## Complexity Threshold

Flag as "too complex" when implementing requires:
- Adding 2+ new sections
- Restructuring existing sections significantly
- Combining unrelated behaviors in one resource

If changes span 3+ existing sections significantly but don't require new sections, flag as "substantial refactor" and confirm with user that modification (vs. new skill) is the right approach.
