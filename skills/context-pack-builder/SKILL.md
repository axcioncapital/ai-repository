---
name: context-pack-builder
description: >
  Transforms vague assignment descriptions into precise, AI-ready context packs
  with epistemic labeling (facts/assumptions/unknowns). Use when: (1) starting
  medium-complexity tasks that need clear intent before execution, (2) the user
  says "define the task," "clarify what we're doing," "build a context pack,"
  or provides rough notes about a task they want AI to execute. This is Step 1
  of a two-step workflow — establishes intent and scope before material
  gathering. Do NOT use for simple single-turn requests, mechanical tasks, or
  when the user has already provided a complete specification.
---

# Context Pack Builder

Reconstruct clear intent from vague, fragmentary input. Produce context packs that allow another Claude instance (with no prior context) to execute a task without asking clarifying questions.

A context pack captures: what success looks like, what to produce, what's in and out of scope, and how to judge quality.

## Input Expectation

Expect vague, incomplete input — the skill exists precisely for this. Reconstruct intent from fragments; do not complain about missing information.

**Critical boundary:** Work only with information the user provides. Do not infer business context, stakeholders, constraints, or details that aren't stated or clearly implied. When uncertain, ask — don't invent.

## Context Pack Template

```markdown
## Context Pack: [Assignment Title]

### Objective
[What does success look like? Specific, measurable where possible. No vague verbs.]

### Background
[Why does this matter? What triggered this task? Business context.]

### Scope
- **In scope:** [What's included — be explicit]
- **Out of scope:** [What's explicitly excluded — prevents scope creep]

### Deliverable(s)
[Concrete output(s): format, length, structure. "A 2-page memo" not "some kind of summary."]

### Audience
[Who consumes this? Internal/external? Their expertise level? What do they care about?]

### Facts (Confirmed)
[Verified information from reliable sources. Ground truth. Include source references.]
- [Fact 1] (source: [document/page])
- [Fact 2] (source: [document/page])

### Assumptions (To Validate)
[Reasonable beliefs that require confirmation. Flag if output depends on these.]
- [Assumption 1] — needs validation because: [reason]
- [Assumption 2] — needs validation because: [reason]

Do not treat assumptions as facts. If output relies on an assumption, flag it explicitly.

### Unknowns
[Missing information or data gaps.]
- [Unknown 1] — impact if missing: [blocking / can proceed with flag]
- [Unknown 2] — impact if missing: [blocking / can proceed with flag]

### Inputs Available
[Specific documents, notes, or data provided. The executing AI should reference only these.]
- [Document 1]: [brief description]
- Or: "No source documents provided — use general knowledge only"

### Constraints
[Non-negotiables, limitations, rules, deadlines, sensitivities]

### Quality Criteria
[How to judge if output is good. What would make the user reject it?]
```

Include this instruction in every context pack:

> **Epistemic discipline:** Treat Facts as ground truth. Flag any output that relies on Assumptions. Do not fill Unknowns with fabricated information — acknowledge the gap instead.

## Epistemic Labeling

The Facts/Assumptions/Unknowns separation is the core discipline of this skill. Enforce it rigorously.

### Classify Information Immediately

| User Says | Classification | Action |
|-----------|----------------|--------|
| "Revenue is $47M" | Needs verification | Ask: "Is this confirmed? What's the source?" |
| "I think the margin is around 18%" | Assumption | Place in Assumptions, flag for validation |
| "I don't know their customer concentration" | Unknown | Place in Unknowns, assess if blocking |
| "Per the CIM, page 7..." | Fact | Place in Facts with source reference |

### Probe for Missing Clarity

If the user dumps information without labeling, ask:
- "Which of these are verified facts vs. your working assumptions?"
- "Are there things you don't know that might affect this task?"
- "What source documents will the executing AI have access to?"

### Validate Before Finalizing

- [ ] Every item in Facts has a source
- [ ] Assumptions are labeled with why they need validation
- [ ] Unknowns are assessed for blocking impact
- [ ] Inputs Available lists exactly what the executing AI can reference

### Evidence Table (High-Stakes Packs)

For accuracy-critical tasks, add this to the context pack:

```markdown
### Grounding Requirement
Before generating narrative output, produce an evidence table:

| Claim | Source Snippet |
|-------|----------------|
| [Statement you will make] | [Exact quote from Inputs, or "not in sources"] |

Any claim marked "not in sources" must be flagged as an assumption or removed.
```

## Workflow

### Step 1: Extract & Map Gaps

Parse whatever the user provides. Map to the template structure.

- Identify what's present vs. missing
- Categorize gaps: blocking (cannot proceed) vs. inferrable (reasonable assumption)
- Classify information epistemically: fact, assumption, or unknown

**Output:** Gap summary showing template coverage and epistemic status.

**STOP.** Present gap summary. Wait for acknowledgment.

### Step 2: Prioritized Clarifying Questions

Maximum 10-15 questions, batched in a single numbered list.

| Priority | Type | Ask If... |
|----------|------|-----------|
| P1 | Blocking | Cannot proceed without answer |
| P2 | Direction-changing | Answer significantly alters approach |
| P3 | Scope-defining | Prevents wasted effort on wrong things |
| Skip | Nice-to-know | Answer doesn't meaningfully change output |

**Quality test:** "If the user answers this differently, does the output change meaningfully?" If no — don't ask.

High-value questions to consider:

| Question | Why It Matters |
|----------|----------------|
| "What's the actual deliverable — document, decision, recommendation?" | Defines output type |
| "Who will act on this output?" | Shapes framing and depth |
| "What decision does this support?" | Clarifies purpose |
| "What would make you reject the output?" | Defines quality bar |
| "Is there a deadline or time constraint?" | Affects scope and depth |
| "Are there political sensitivities?" | Prevents landmines |
| "Which of these are verified facts vs. working assumptions?" | Enables epistemic labeling |
| "What source documents will the executing AI have access to?" | Defines Inputs Available |

**STOP.** Wait for answers before proceeding.

### Step 3: Fill Gaps

Integrate answers. For remaining minor gaps, make reasonable inferences labeled as assumptions.

| Safe to Assume | Must Ask |
|----------------|----------|
| Professional tone | Who the decision-maker is |
| Markdown format | Deadlines or time constraints |
| Internal audience unless stated otherwise | Political sensitivities |
| Standard business context for M&A work | Budget or resource constraints |
| English language | External stakeholder involvement |
| Single deliverable unless multiple stated | Compliance or legal requirements |

**Rule:** If an assumption would change the deliverable's direction, audience, or scope — ask. If it's formatting or tone — assume and label.

**If blocking gaps remain:** List what's needed and **STOP**.

### Step 4: Refine & Validate

Tighten language. Remove ambiguity.

- Replace vague verbs ("help with," "look into") with specific actions
- Make scope boundaries explicit and actionable
- Ensure deliverable is concrete (format, length, structure)

**Validation — the "Fresh Claude Test":**

> Could another Claude instance, with only this context pack and no conversation history, execute the task without asking clarifying questions?

- [ ] Objective is specific and measurable
- [ ] Deliverable is concrete
- [ ] Scope boundaries are actionable
- [ ] Quality criteria exist
- [ ] No vague verbs remain unexplained
- [ ] Facts have sources
- [ ] Assumptions are labeled
- [ ] Unknowns are assessed for blocking impact
- [ ] Inputs Available lists what the executing AI can reference

**Output:** Refined context pack draft.

**STOP.** Present draft for user approval.

## Failure Handling

**User declines to answer blocking questions:** Proceed with explicit assumptions labeled as:

> **[UNVERIFIED ASSUMPTION — HIGH RISK]:** [Your assumption here]

Flag these prominently. The user accepts responsibility for outputs based on unverified assumptions.

## Output Protocol

**Default mode: Refinement**

Work through the workflow steps, stopping at each gate. Do not produce the final context pack until all steps are completed and the user has approved the refined draft.

**Release mode:** When user says `RELEASE ARTIFACT`, produce the complete context pack as a markdown artifact. Do not paste full content in chat. Provide a one-sentence summary of what was created.

## Quality Criteria

A context pack passes when it is:

1. **Executable** — another Claude instance could execute without asking questions
2. **Bounded** — clear what's in and out of scope
3. **Measurable** — success criteria exist
4. **Concrete** — deliverable is specific (format, length, structure)
5. **Epistemically clear** — facts, assumptions, and unknowns are separated and labeled
