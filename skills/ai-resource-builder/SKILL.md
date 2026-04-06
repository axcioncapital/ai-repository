---
name: ai-resource-builder
description: >
  Creates, evaluates, and improves AI resources (skills, prompts, project
  instructions). Use when: (1) building a new skill or prompt from scratch,
  (2) evaluating a resource for quality against the eight-layer framework,
  (3) improving an existing resource from feedback or bug reports.
  Do NOT use for: workflow design (use workflow-creator), non-AI documents,
  or executing/running skills.
---

# AI Resource Builder

Create, evaluate, and improve AI resources. Enforces Axcion's structure, progressive disclosure, and quality standards.

## Mode Selection

Identify which mode applies, then follow that workflow.

| Mode | Trigger | Jump to |
|------|---------|---------|
| **Create** | Building a new skill, prompt, or project instruction from scratch | Create Workflow |
| **Evaluate** | Reviewing an existing resource for quality without modifying it | Evaluate Workflow |
| **Improve** | Modifying an existing resource based on feedback or bug reports | Improve Workflow |

If the user provides feedback on an existing resource, use **Improve** even if they say "make it better." If they want a quality report without changes, use **Evaluate**. If ambiguous, ask.

## Skill Architecture

### Folder Structure

```
skill-name/
├── SKILL.md          # Required — main instructions
├── scripts/          # Optional — executable code for deterministic tasks
├── references/       # Optional — documentation loaded on demand
└── assets/           # Optional — files used in output (templates, icons)
```

Only create subdirectories that will contain files. No README inside skill folders.

### Size Budget

Keep SKILL.md body under 500 lines (YAML frontmatter counts). When approaching the limit, split into reference files and link from SKILL.md with guidance on when to read them.

### Progressive Disclosure

Three-level loading system:

1. **Metadata** (name + description) — always in Claude's context (~100 words)
2. **SKILL.md body** — loaded when skill triggers (<5k words)
3. **Bundled resources** — loaded as needed by Claude

Rules:
- **One level deep.** All reference files link directly from SKILL.md. Never chain references (SKILL.md -> ref-A.md -> ref-B.md).
- **TOC for long files.** Any reference file over 100 lines must include a table of contents.
- **Execute vs. read.** For every bundled script, SKILL.md must clarify whether Claude should execute it or read it as reference. Default to execute.

### Bundled Resources

| Type | When to Include | Example |
|------|----------------|---------|
| **scripts/** | Same code rewritten repeatedly; deterministic reliability needed | `scripts/rotate_pdf.py` |
| **references/** | Documentation Claude should reference while working | `references/schema.md` |
| **assets/** | Files used in output, not loaded into context | `assets/template.pptx` |

Keep SKILL.md lean. Move detailed schemas, examples, and reference material to reference files. For files >10k words, include grep search patterns in SKILL.md. Avoid duplication between SKILL.md and reference files.

**Script bundling signal:** If Claude independently generates the same helper script across multiple tasks, that's a strong signal to bundle it in `scripts/` and reference it from SKILL.md.

### Naming

- **Folder name:** kebab-case only. No spaces, underscores, or capitals.
- **Preferred form:** gerund (verb + -ing) or noun phrase: `processing-pdfs`, `pdf-processing`.
- **Namespace prefixes** for domain grouping at scale: `research-*`, `doc-*`, `mg-*`.
- **Folder name must match** the `name` field in frontmatter.
- **Avoid:** vague names (`helper`, `utils`), reserved words (`anthropic-*`, `claude-*`, `skill`).

## Frontmatter Standards

### Name Field

Max 64 characters. Lowercase letters, numbers, and hyphens only. Must match folder name.

### Description Field

The description is the primary trigger mechanism. Claude decides whether to load a skill based on this field alone.

**Critical: 250-character truncation.** In the `/skills` listing, descriptions are capped at 250 characters. Anything past 250 characters is silently cut. Front-load the key use case and trigger phrases within the first 250 characters.

Rules:
- **Third person.** "Analyzes spreadsheets..." not "I can help you analyze..."
- **Structure:** `[What it does] + [When to use it]` — front-loaded within 250 chars.
- **Be "pushy."** Claude tends to under-trigger skills. Make descriptions assertive: "Builds data dashboards. Use when user mentions dashboards, metrics, or data display."
- **Include negative triggers** when the skill risks over-triggering or conflicts with another skill: "Do NOT use for simple data exploration (use data-viz instead)."
- **Max 1024 characters** total, but aim for under 200 when possible.

Good description:
> Creates, evaluates, and improves AI resources (skills, prompts, project instructions). Use when building new skills, reviewing resource quality, or applying feedback to existing resources. Do NOT use for workflow design or non-AI documents.

Bad description:
> A helpful tool for working with various types of AI resources including but not limited to skills and prompts.

For the full operational frontmatter field table (allowed-tools, paths, context, effort, model, hooks, and more), read `references/operational-frontmatter.md`.

**Companion hooks principle:** If a check is binary (pass/fail), runs the same way every time, and doesn't need Claude's reasoning — it should be a hook, not a skill instruction. Examples: linting after code generation, blocking commits with sensitive files.

## Create Workflow

### Step 1: Understand the Resource

Clarify concrete examples of how the skill will be used. Ask targeted questions:

- What functionality should the skill support?
- What would a user say that should trigger this skill?
- Can you give examples of typical usage?
- What should it NOT do? (Exclusions matter as much as inclusions)

Avoid overwhelming — start with the most important questions and follow up as needed. Conclude when there is a clear sense of the functionality the skill should support.

Skills operate in a multi-tool ecosystem. They may interact with GPT-5 (via API/CustomGPT), Perplexity (via API), Notion, and NotebookLM. Account for cross-tool workflows where applicable.

### Step 2: Plan Bundled Resources

Analyze each concrete example:

1. How would you execute this from scratch?
2. What scripts, references, or assets would help when doing this repeatedly?

| Example Task | Analysis | Resource |
|-------------|----------|----------|
| "Rotate this PDF" | Same rotation code rewritten each time | `scripts/rotate_pdf.py` |
| "Build me a todo app" | Same frontend boilerplate each time | `assets/hello-world/` template |
| "How many users logged in?" | Need to rediscover table schemas each time | `references/schema.md` |

### Step 3: Initialize Structure

Create the directory with only the subdirectories that will contain files:

```
skill-name/
├── SKILL.md
├── scripts/      (if needed)
├── references/   (if needed)
└── assets/       (if needed)
```

### Step 4: Write the Resource

The skill is written for another Claude instance. Include information that is beneficial and non-obvious to Claude. Challenge each piece: "Does Claude really need this?" and "Does this justify its token cost?"

#### 4a. Start with Bundled Resources

Implement scripts, references, and assets first. Test added scripts by running them. This prevents SKILL.md from referencing nonexistent files.

#### 4b. Write the Frontmatter

Apply the rules from the Frontmatter Standards section. After writing the description, verify the first 250 characters contain the primary trigger phrases.

#### 4c. Write the Body

Use imperative/infinitive form. Explain the *why* behind instructions — Claude works better with reasoning than rote commands.

**Degrees of freedom** — match specificity to the task's fragility:

- **High freedom** (text instructions): Multiple valid approaches, context-dependent. "Analyze the code and suggest improvements based on what you observe."
- **Medium freedom** (pseudocode): Preferred pattern exists, some variation. A parameterized function signature with comments.
- **Low freedom** (exact scripts): Fragile operations, consistency critical. "Run `scripts/migrate.py --verify --backup`. Do not modify the command."

Think of Claude exploring a path: a narrow bridge needs guardrails (low freedom), an open field allows many routes (high freedom).

#### 4d. Counter Default Biases

For any skill that generates text, analysis, or recommendations, include bias-countering instructions adapted to the domain:

```
If the provided information is insufficient to answer confidently, say so
rather than inferring. It is acceptable — and expected — to leave gaps rather
than invent plausible-sounding details. If the user's premise contains an
error or questionable assumption, flag it constructively. Prioritize accuracy
over comprehensiveness.
```

Core principles: permit "I don't know," accept gaps, encourage pushback on flawed premises, accuracy over comprehensiveness.

#### 4e. Apply Output Gating (when applicable)

For skills that produce substantial outputs (documents, plans, reports, code files), embed output gating to prevent premature generation.

**Apply when:** Substantial text outputs requiring user review before finalization.
**Do not apply when:** Script-based operations, inline answers, or very short outputs.

Embed this pattern:

```markdown
## Output Protocol
**Default mode: Refinement**
Before producing final output, provide:
- Structural outline with section headers
- Key assumptions being made
- Questions only if answers would significantly change the output

**Do not produce the full output until user says `RELEASE ARTIFACT`.**
```

#### 4f. Apply Two-Step Prompting (when applicable)

For skills handling heavy outputs (>600 words) or ambiguous tasks, embed a plan-then-execute pattern.

**Apply when:** Heavy outputs or ambiguous tasks with multiple valid interpretations.
**Do not apply when:** Well-defined inputs/outputs, short outputs, deterministic operations.

The pattern: (1) **Plan** — present approach, assumptions, and material questions; (2) **Execute** — produce deliverable after user confirms.

**Ask only questions that materially change the output:**

| Bad (Trivial) | Good (Material) |
|---|---|
| "What format would you like?" | "Should I weight X risk higher than Y given the dependency you mentioned?" |
| "How long should this be?" | "Source A claims 20% but Source B says 12% — which is authoritative?" |
| "Do you want me to include risks?" | "Should I flag this exposure as a dealbreaker or acceptable?" |

Output gating and two-step prompting can co-exist: two-step handles planning, output gating handles release.

#### 4g. Include Required Sections

See the Required Sections Checklist below. Ensure each applicable section is present.

### Step 5: Validate

1. Run the Evaluate Workflow on the draft
2. Fix any Critical or Major issues
3. Test the skill on real tasks
4. Iterate: notice struggles, update SKILL.md or resources, test again

## Evaluate Workflow

### Step 1: Identify Resource Type and Inputs

Determine: Skill, prompt, or project instruction. If ambiguous, default to best-fit and note it.

Include when available: resource name, target platform, dependencies, intended runtime context.

### Step 2: Apply Eight-Layer Evaluation

For each layer, ask four questions: (1) Present? (2) Complete? (3) Consistent with other layers? (4) Appropriate for this resource type?

| Layer | What It Checks | Key Weakness Signal |
|-------|---------------|---------------------|
| **Purpose** | Role and primary intent | Optimizes for wrong outcome; tries too many things |
| **Context Boundary** | Where model draws information | Invents data not in source material |
| **Interpretation** | Handling ambiguity in input | Misunderstands informal requests |
| **Reasoning Constraints** | Confidence calibration, bias counters | Over-helpful, falsely confident |
| **Decision** | Action principles, tiebreakers | Inconsistent judgment across similar cases |
| **Constraints** | Hard rules and boundaries | Violates intended limits |
| **Failure Behavior** | What to do when uncertain/blocked | Hallucinates rather than admitting uncertainty |
| **Output Contract** | Format and structure of output | Unpredictable response formats |

### Scoring

| Status | Meaning |
|--------|---------|
| ✓ Present | Explicit and testable |
| ⚠️ Weak | Implied or incomplete |
| ✗ Missing | Absent or unidentifiable |
| N/A | Does not apply (Interpretation for non-conversational; Decision for minimal prompts) |

**Severity flows from layer priority:**
- Critical-priority layer missing/weak → Critical issue
- Important-priority layer missing/weak → Major issue
- Optional-priority layer missing → Minor or no issue

### Single-Responsibility Check

Flag as Critical under Purpose when a resource tries to accomplish multiple unrelated goals, combines unrelated domains, or serves multiple audiences with conflicting needs. Exception: multi-phase workflows with clear phase boundaries.

### Step 3: Report

For the full evaluation framework including the priority matrix, type-specific criteria, and convention gate, read `references/evaluation-framework.md`. The subagent evaluation step in the pipeline commands uses that standalone reference file.

Condensed output format:

```
## Evaluation: [Resource Name]
Resource type: [Skill / Prompt / Project Instruction]

### Layer Coverage
| Layer | Status | Notes |
|-------|--------|-------|
[8 rows]

### Issues Found
**1. [Severity: Critical / Major / Minor]** — [Layer]
- Issue: [Description]
- Location: [Where]
- Fix: [Specific suggestion]

### Summary
Critical: [n] | Major: [n] | Minor: [n]
```

## Improve Workflow

### Inputs

1. **Existing resource** — the current skill, prompt, or project instructions
2. **Improvement suggestions** — bug reports, enhancement ideas, or behavioral fixes

If the existing resource is unparseable or incomplete, ask for a clean version.

### Step 1: Confirm Understanding

Restate what resource is being modified and what each suggestion asks for.

For vague or informal feedback, surface interpretations as hypotheses ("I think you're saying...") and confirm. If suggestions contradict each other, surface the conflict.

**Hard gate:** Wait for user confirmation before proceeding.

### Step 2: Triage Each Suggestion

| Check | Question | If Fails |
|-------|----------|----------|
| **Clarity** | Specific enough to act on? | Ask clarifying question |
| **Logic** | Solves a real problem? | Flag as dubious, propose alternative |
| **Compatibility** | Conflicts with existing behavior? | Flag contradiction, ask user to resolve |
| **Complexity** | Requires 2+ new sections or major restructuring? | Recommend new skill instead |

**Breaking change detection** — flag any change that:
- Alters output schema or required fields
- Removes or overrides a core constraint
- Renames required sections or headings
- Changes defaults that downstream resources depend on

**Pushback calibration:** If a flagged suggestion is insisted upon after explanation, implement it but note the concern in the change summary.

### Step 3: Propose Changes

For each suggestion that passes triage:

```
**Change [#]:** [Short label]
- Location: [Exact section/heading]
- Current: "[Brief quote]"
- Proposed: "[New text]"
- Rationale: [Link to feedback]
- Unchanged: [What stays the same]
```

### Step 4: Approve and Implement

Wait for explicit approval. Implement only the approved subset. Preserve original structure unless a change specifically requires restructuring.

### Step 5: Iteration Suggestions

Generate 2-4 improvements identified during modification that the user did not request.

Rules:
- Must go beyond the original feedback
- Focus on issues surfaced by the modifications
- Include at least one targeting failure behavior or edge cases
- Stay within the resource's existing scope

User picks numbers to apply, or skips. One additional round max.

### Step 6: Quality Check

Scan the modified resource for:

| Issue | Detection |
|-------|-----------|
| **Contradictions** | New instruction conflicts with existing? MUST/NEVER conflicts? |
| **Ambiguity** | Vague terms introduced without definitions? |
| **Regression** | Existing functionality still works? Each step has clear output? |
| **Scope bloat** | Resource exceeding its stated purpose? |

If issues found: flag specifically, propose alternative, prompt user before finalizing.

### Step 7: Deliver

Present the change summary first. Wait for user confirmation before delivering the full updated resource.

### Complexity Threshold

Flag as "too complex for improvement" when implementing requires:
- Adding 2+ new sections
- Restructuring existing sections significantly
- Combining unrelated behaviors

If changes span 3+ sections significantly but don't require new sections, flag as "substantial refactor" and confirm modification is the right approach vs. creating a new skill.

## Required Sections Checklist

Every well-formed resource should include these sections. Mark N/A with brief justification when a section genuinely does not apply.

| Section | Purpose | Applies To |
|---------|---------|------------|
| **Known Pitfalls** | Failure modes specific to the domain or Claude's behavior | All resources |
| **Validation Loop** | How to verify the resource produces correct output | Skills with complex outputs |
| **Runtime Recommendations** | Model, effort, context, companion hooks guidance | Skills |
| **Examples** | Input/output pairs showing desired behavior | Output-dependent resources |
| **Failure Behavior** | What to do when blocked, uncertain, or missing input | All resources |
| **Bias Countering** | Instructions to counter default model tendencies | Analytical/generative resources |

These sections are the implementation mechanism for several evaluation layers (Failure Behavior, Output Contract, Reasoning Constraints). Designing with them in mind produces resources that score well on evaluation.

## Writing Standards

### Degrees of Freedom

Match specificity to the task's fragility and variability:

- **High freedom** (text instructions): Multiple valid approaches. Use for analysis, recommendations, style guidance.
- **Medium freedom** (pseudocode/parameterized): Preferred pattern with some variation. Use for workflow steps, data processing.
- **Low freedom** (exact scripts, few params): Fragile operations requiring strict consistency. Use for API calls, migrations, deployments.

### Anti-Railroading

If you find yourself writing ALWAYS or NEVER in all caps, or enforcing super-rigid structures, reframe and explain the reasoning instead. Claude works better understanding *why* a constraint matters than following rote rules.

**Skill obsolescence risk:** As models improve, skills that over-specify can degrade output. The skill constrains Claude to follow steps written for a less capable version. Periodically compare skill output vs. no-skill output. If raw Claude wins, simplify or retire the skill.

### Capability vs. Preference Skills

- **Capability skills** extend what the base model can do (complex PDF extraction, specialized transforms). Need more procedural detail but may become obsolete as models improve.
- **Preference skills** encode how you want work done (your formatting, review process, brand voice). Durable because preferences don't change when models do. Most skills worth building are preference skills.

### Bias Countering

For analytical/generative skills: permit "I don't know," accept gaps over invention, encourage pushback on flawed premises, prioritize accuracy over comprehensiveness.

### Time-Sensitive Information

Don't embed information that will become outdated. If historical context is useful, isolate it in a collapsible "old patterns" section with a date stamp.

### Skills vs. MCP Servers

Skills provide procedural knowledge (how to use tools). MCP servers provide tool access (connecting to external systems). They are complementary. When an MCP server primarily provides guidance rather than tool connectivity, a skill may serve the same purpose with the advantage of transparency.

### Skill Composition

When skills form natural chains (research -> analysis -> document production):
- Design compatible output formats between pipeline stages
- Keep each skill independently invocable — even in a pipeline, each should work standalone
- Don't build monolithic orchestrator skills that just call other skills in sequence

## Anti-Patterns

| Anti-Pattern | Why It Fails | Instead |
|---|---|---|
| Over-specifying with rigid MUSTs/NEVERs | Makes output rigid, degrades as models improve | Explain the *why*, use flexible templates |
| Vague descriptions | Skill never triggers | Include specific trigger phrases and file types |
| Trigger phrases past 250 characters | Claude never sees them — descriptions truncated | Front-load key use case within first 250 chars |
| No negative triggers on overlapping skills | Wrong skill fires | Add "Do NOT use for..." to delineate boundaries |
| Not using `paths` field | Every skill burns context every session | Scope skills to relevant directories |
| Deeply nested references (>1 level) | Claude partially reads or misses content | Keep all references one level from SKILL.md |
| Mixing multiple jobs in one skill | Hard to trigger, hard to maintain | One skill, one job |
| Skills >500 lines without splitting | Context bloat, important rules lost | Split into reference files |
| Deterministic checks in skill body | Not guaranteed to run, wastes reasoning | Convert to hooks |
| "Voodoo constants" in scripts | Claude can't determine the right value | Document why every constant is what it is |
| Inconsistent terminology | Confuses Claude's understanding | Pick one term per concept |
| Keeping dead skills | Consume description budget, risk false triggers | Retire skills that haven't triggered in weeks |
| Offering too many options | Confuses Claude, wastes tokens | Provide a default with an escape hatch |
| Teaching Claude what it already knows | Token waste, may constrain better default behavior | Only add non-obvious context |

## Reference Files

Read these on demand. Do not load all references at the start of a session.

| File | Read When |
|------|-----------|
| `references/evaluation-framework.md` | Running a full evaluation, or the pipeline commands need to pass a standalone framework to a subagent. Contains the complete 8-layer definitions, priority matrix, type-specific criteria, convention gate, and combined output format. |
| `references/operational-frontmatter.md` | Configuring frontmatter fields beyond `name` and `description`. Contains the full field table: allowed-tools, paths, context, effort, model, hooks, disable-model-invocation, and more. |

All references link directly from this file. References do not link to other references.

## Runtime Recommendations

- **Create mode:** Expect to iterate. First pass produces a draft; run Evaluate on it before declaring done.
- **Evaluate mode:** Works best on complete drafts. Partial resources get partial evaluations — note what could not be assessed.
- **Improve mode:** Always work on a copy. Present the change summary before the full modified resource.
- **Context budget:** When operating on a resource with multiple reference files, prioritize loading SKILL.md and the most relevant reference rather than all references.

## Validation

After completing any mode, run these checks:

- [ ] Does the output resource stay under the 500-line limit?
- [ ] Does the frontmatter front-load the first 250 characters with trigger phrases?
- [ ] Are all required sections present or explicitly marked N/A?
- [ ] Does the resource avoid the anti-patterns listed above?
- [ ] Has failure behavior been defined?
- [ ] If creating: self-evaluate using the condensed 8-layer check before delivering.
