---
name: skill-creator
description: >
  Guide for creating and iterating on Claude skills — modular packages that
  extend Claude's capabilities with specialized workflows, tools, and domain
  knowledge. Use when: (1) creating a new skill from scratch, (2) restructuring
  or improving an existing skill, (3) reviewing a skill for quality and
  convention compliance. Covers skill structure, frontmatter conventions,
  progressive disclosure, bundled resources, output gating, and two-step
  prompting patterns.
---

# Skill Creator

## Core Principles

### Concise is Key

The context window is a shared resource. Default assumption: Claude is already very smart. Only add context Claude doesn't already have. Challenge each piece of information: "Does Claude really need this?" and "Does this justify its token cost?"

Prefer concise examples over verbose explanations.

### Degrees of Freedom

Match specificity to the task's fragility and variability:

- **High freedom** (text instructions): Multiple valid approaches, context-dependent decisions
- **Medium freedom** (pseudocode/parameterized scripts): Preferred pattern exists, some variation acceptable
- **Low freedom** (specific scripts, few parameters): Fragile operations, consistency critical, specific sequence required

Think of Claude exploring a path: a narrow bridge needs guardrails (low freedom), an open field allows many routes (high freedom).

## Skill Structure

```
skill-name/
├── SKILL.md (required)
│   ├── YAML frontmatter: name + description (required)
│   └── Markdown body: procedural instructions (required)
└── Bundled Resources (optional)
    ├── scripts/    — Executable code for deterministic/repeated tasks
    ├── references/ — Documentation loaded into context as needed
    └── assets/     — Files used in output (templates, icons, fonts)
```

### SKILL.md

- **Frontmatter**: `name` and `description` only. Description is the primary trigger mechanism — include what the skill does and when to use it. All "when to use" information belongs here, not in the body.
- **Body**: Procedural instructions. Keep under 500 lines. Only loaded after the skill triggers.

### Bundled Resources

| Type | When to Include | Example |
|------|----------------|---------|
| **scripts/** | Same code rewritten repeatedly; deterministic reliability needed | `scripts/rotate_pdf.py` |
| **references/** | Documentation Claude should reference while working | `references/schema.md`, `references/api_docs.md` |
| **assets/** | Files used in output, not loaded into context | `assets/logo.png`, `assets/template.pptx` |

**References best practices:**

- Keep SKILL.md lean; move detailed reference material, schemas, and examples to reference files
- For files >10k words, include grep search patterns in SKILL.md
- Avoid duplication between SKILL.md and reference files
- Structure files >100 lines with a table of contents
- Keep references one level deep from SKILL.md — all reference files link directly from SKILL.md

### Progressive Disclosure

Three-level loading system:

1. **Metadata** (name + description) — always in context (~100 words)
2. **SKILL.md body** — loaded when skill triggers (<5k words)
3. **Bundled resources** — loaded as needed by Claude

Keep SKILL.md to essentials. When approaching 500 lines, split into reference files and link from SKILL.md with clear guidance on when to read them.

**Splitting patterns:**

- **High-level guide with references**: Core workflow in SKILL.md, link to detailed guides (`references/FORMS.md`, `references/EXAMPLES.md`) loaded on demand.
- **Domain-specific organization**: One reference file per domain or variant. E.g., `references/finance.md`, `references/sales.md` — Claude loads only the relevant domain.
- **Conditional details**: Basic content inline, advanced/optional features in separate files loaded when the user needs them.

## Skill Creation Process

Follow these steps in order, skipping only if there is a clear reason why they are not applicable.

### Step 1: Understand the Skill with Concrete Examples

Skip only when usage patterns are already clearly understood.

Clarify concrete examples of how the skill will be used. Ask targeted questions:

- What functionality should the skill support?
- What would a user say that should trigger this skill?
- Can you give examples of typical usage?

Avoid overwhelming users — start with the most important questions and follow up as needed. Conclude when there is a clear sense of the functionality the skill should support.

### Step 2: Plan Reusable Contents

Analyze each concrete example:

1. How would you execute this from scratch?
2. What scripts, references, or assets would help when doing this repeatedly?

**Examples of analysis to resource decisions:**

| Example Task | Analysis | Resource |
|-------------|----------|----------|
| "Rotate this PDF" | Same rotation code rewritten each time | `scripts/rotate_pdf.py` |
| "Build me a todo app" | Same frontend boilerplate each time | `assets/hello-world/` template |
| "How many users logged in today?" | Need to rediscover table schemas each time | `references/schema.md` |

### Step 3: Initialize the Skill

Skip if the skill already exists and you're iterating.

Create the directory structure with only the subdirectories that will contain files:

```
skill-name/
├── SKILL.md
├── scripts/      (if needed)
├── references/   (if needed)
└── assets/       (if needed)
```

### Step 4: Edit the Skill

Remember: the skill is being created for another instance of Claude to use. Include information that is beneficial and non-obvious to Claude.

#### Start with Bundled Resources

Implement scripts, references, and assets first. This may require user input (e.g., brand assets, API docs).

Test added scripts by running them. For many similar scripts, test a representative sample.

#### Write the Frontmatter

- `name`: The skill name
- `description`: Primary trigger mechanism. Include what the skill does AND specific triggers/contexts for when to use it. All "when to use" information goes here.

Example description for a `docx` skill:

> Comprehensive document creation, editing, and analysis with support for tracked changes, comments, formatting preservation, and text extraction. Use when Claude needs to work with professional documents (.docx files) for: (1) Creating new documents, (2) Modifying or editing content, (3) Working with tracked changes, (4) Adding comments, or any other document tasks

#### Write the Body

Use imperative/infinitive form. Include only information that is beneficial and non-obvious to Claude.

#### Counter Default Biases

For any skill that generates text content, analysis, or recommendations, include bias-countering instructions. Adapt this template to the skill's domain:

```
If the provided information is insufficient to answer confidently, say so rather than
inferring. It is acceptable—and expected—to leave gaps rather than invent plausible-sounding
details. If the user's premise contains an error or questionable assumption, flag it
constructively. Prioritize accuracy over comprehensiveness.
```

Core principles: permit "I don't know," accept gaps, encourage pushback on flawed premises, accuracy > comprehensiveness.

#### Apply Output Gating (when applicable)

For skills that produce substantial outputs (documents, plans, reports, code files), embed output gating to prevent premature generation and token waste.

**Apply when:** Skill produces substantial text outputs requiring user review before finalization.

**Do not apply when:** Skill runs scripts/tools without text deliverables, answers questions inline, or produces very short outputs (<50 lines).

Embed this pattern in the skill's SKILL.md:

```markdown
## Output Protocol

**Default mode: Refinement**

Before producing final output, provide:
- Structural outline with section headers
- Key assumptions being made
- Questions only if answers would significantly change the output
- Brief summary of what the final deliverable will contain

**Do not produce the full output until user says `RELEASE ARTIFACT`.**

When user says `RELEASE ARTIFACT`:
- Produce the complete deliverable as an artifact file
- Do not paste full content in chat — artifact only
- Provide a brief summary of what was created
```

Adapt the template to the skill type: document-producing skills emphasize outline and structure, plan/report skills emphasize key elements, code-producing skills emphasize approach and file structure.

#### Apply Two-Step Prompting (when applicable)

For skills handling heavy outputs (>600 words) or ambiguous tasks, embed a plan-then-execute pattern.

**Apply when:** Heavy outputs or ambiguous tasks (multiple valid interpretations, vague terms, key parameters unspecified).

**Do not apply when:** Well-defined inputs/outputs, short outputs, deterministic operations.

The pattern: (1) **Plan** — present approach, assumptions, and questions that would materially change the output; (2) **Execute** — produce deliverable after user confirms.

Embed this pattern in the skill's SKILL.md:

```markdown
## Planning Protocol

Before drafting, provide:
1. Your approach to this task
2. Key assumptions being made
3. Questions only if answers would materially change the output

Proceed to drafting after user confirms the approach.
```

**Ask only questions that materially change the output:**

| Bad (Trivial/Generic) | Good (Materially Changes Output) |
|---|---|
| "What format would you like?" | "Should I weight X risk higher than Y risk given the dependency you mentioned?" |
| "How long should this be?" | "Source A claims 20% but Source B suggests 12% — which should I treat as authoritative?" |
| "Do you want me to include risks?" | "Should I flag this exposure as a dealbreaker given your stated preference, or is it acceptable?" |
| "What tone should I use?" | "The projections assume 15% growth but historical CAGR is 8% — should I stress-test at historical rates?" |

Two-step prompting and output gating can co-exist: two-step handles the planning phase, output gating handles the release phase.

### Step 5: Iterate

1. Use the skill on real tasks
2. Notice struggles or inefficiencies
3. Identify how SKILL.md or bundled resources should be updated
4. Implement changes and test again
