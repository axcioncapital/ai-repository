---
name: prompt-creator
description: >
  Creates standalone, reusable prompts — task-activation instructions that tell
  Claude *what* to do for a specific situation. Triggers on: "create a prompt
  for," "write a prompt that," "help me prompt Claude to," or when a task
  description is provided with an explicit expectation of a reusable prompt as
  output. Do NOT use for: research execution prompts (use research-prompt-creator),
  SKILL.md creation or editing (use create-skill / improve-skill), CLAUDE.md
  rules or project instructions (use update-claude-md), or CustomGPT / Perplexity
  prompt formats (these follow tool-specific conventions in their respective skills).
---

# Prompt Creator

## Stance

Draft first, refine second. Produce a usable prompt in 1-2 turns. Deliver fast, flag uncertainty, improve through iteration. Do not gatekeep or block on missing details when intent is clear.

## Layer Boundaries

Prompts sit in a three-layer system. Understanding boundaries prevents duplication:

- **Project instructions:** Persistent context repeated every conversation
- **Skills:** Reusable workflows for a task type — *how* to do work
- **Prompts:** Specific task activation and inputs — *what* to do

**Rule:** If content is reusable across tasks and describes *how* to perform work, it belongs in a skill. Prompts describe *what* to do.

## Workflow

### Default Mode: Draft With Assumptions

Use for most requests. Prioritize velocity over certainty.

1. **Assess intent.** If ~70-80% of intent is clear, draft. Only ask when unsure *what* the user wants (not just details).

2. **Draft with flagged assumptions.** Produce a complete, usable prompt. Where details are missing, make reasonable assumptions and flag them:
   ```
   [ASSUMPTION: output format is bullet points — adjust if needed]
   ```
   Before drafting, consider whether bias-countering language should be included (see below) and whether the task is fuzzy enough for two-step structure.

3. **Deliver and offer refinement.** Present the prompt, note assumptions made and what might need adjustment, then: "Want me to adjust anything?"

### High-Stakes Mode: Confirm Before Drafting

Use only when:
- Output affects legal, financial, or client-facing deliverables
- Multiple competing interpretations exist and the wrong one wastes significant effort
- User explicitly asks for confirmation

Process: State understanding → list assumptions → ask "Proceed, or adjust?" → draft after confirmation.

**When in doubt, default to drafting.** Faster to revise a draft than answer questions.

## Handling Uncertainty

Ask when ambiguity changes *what* gets produced. Assume and flag when ambiguity is about *details*.

| Uncertainty type | Action |
|------------------|--------|
| What task to perform | Ask |
| Who the audience is (if it changes content) | Ask |
| Output format | Assume, flag |
| Exact length | Assume, flag |
| Which project/skills apply | Assume general best practices, flag |

## Environment Awareness

Prompts operate inside projects with skills. Before drafting, briefly consider whether a skill already handles tone, format, or workflow, and whether the project has constraints the prompt shouldn't repeat.

If you know the environment, exclude what's already handled. If you don't, draft with general best practices and note "adjust if skills already cover tone/format."

Do not block drafting to ask about environment.

## Prompt Length

Most prompts are 3-10 lines. If a prompt exceeds 15 lines, consider whether content should be a skill instead (reusable? describes *how*?). This is a signal, not a gate.

## Bias-Countering Language

Include in prompts for analysis, review, research, or any task where accuracy matters more than completeness. Adapt wording to fit the task but preserve three core behaviors: admit uncertainty, leave gaps rather than invent, push back on bad premises.

Template:
```
If the provided information is insufficient to answer confidently, say so rather than
inferring. It is acceptable — and expected — to leave gaps rather than invent plausible-sounding
details. If the user's premise contains an error or questionable assumption, correct it
constructively. Prioritize accuracy over comprehensiveness.
```

Omit for pure creative tasks or brainstorming.

## Two-Step Prompting

For fuzzy, ambiguous, or high-stakes tasks, instruct the target Claude to present its approach before producing the deliverable:

```
[Task description]

Before producing the final deliverable:
1. State your approach to this task
2. List questions that would materially change the output

Wait for confirmation before proceeding.

[Output spec]
```

Questions should materially change the output — not "What format?" or "How long?" but specifics like "Source A claims X but Source B says Y — which is authoritative?"

## Guardrails

- Do not block on missing details when intent is clear
- Do not require confirmation for simple requests
- Do not duplicate content that belongs in skills or project instructions
- Always produce a usable draft in 1-2 turns
- Always flag assumptions explicitly
- Always offer refinement after drafting

## Example

**Request:** "I need a prompt to summarize due diligence findings."

**Response:**

Here's a prompt for summarizing DD findings:

```
Summarize the due diligence findings from the attached materials.

Structure:
- Key findings (3-5 bullets, most significant issues first)
- Risk assessment (High / Medium / Low for each area reviewed)
- Recommended actions or follow-ups

Keep the summary to one page maximum.
```

**Assumptions made:**
- Audience is internal deal team [adjust if for client or IC]
- Format is structured bullets [adjust if narrative preferred]
- Scope is full DD package [adjust if specific workstream]

Want me to adjust anything?
