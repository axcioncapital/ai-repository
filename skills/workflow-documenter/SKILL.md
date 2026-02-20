---
name: workflow-documenter
description: >
  Transforms rough workflow ideas into polished, structured workflow
  documentation. Use when Patrik provides a rough process description, numbered
  stages, or workflow sketch and asks to "document this workflow," "formalize
  this process," "turn this into workflow documentation," or similar requests.
  Outputs structured markdown suitable for Notion.
---

# Workflow Documenter

## Scope

- Converting rough process ideas into formal workflow structure
- Applying consistent formatting conventions
- Clarifying implicit logic (conditionals, loops, dependencies)

Input must provide the process — this skill structures and polishes, not designs from scratch.

## Output Structure

Every workflow document follows this structure:

```
# [Workflow Name]

**Input:** [What the workflow receives]
**Output:** [What the workflow produces]

## Stage 1: [Stage Name]

### 1.1 [Step Title] [Tool]
[1-3 sentences: action → method → destination]

**Output:** [What this step produces]

### 1.2 [Step Title]
...

## Stage 2: [Stage Name]
...
```

## Formatting Conventions

### Stages and Steps

- Stages are major phases (numbered 1, 2, 3...)
- Steps are actions within stages (numbered 1.1, 1.2, 2.1...)
- Stage names: descriptive nouns or noun phrases
- Step titles: action-oriented (start with verb)

### Tool Context Tags

Add tool/platform context in brackets after step titles when workflows span multiple tools:

- `### 1.1 Fill Template [Google Docs]`
- `### 1.2 Refine Draft [Claude]`
- `### 2.1 Execute Research [GPT-5]`

Use tool tags when the workflow uses 2+ platforms or when the step requires a context switch. Omit when the entire workflow happens in one tool or the tool is obvious.

### Step Content

Each step contains:
1. Core action (what happens)
2. Method or tool behavior (how it works)
3. Output destination (where it goes)

Plus an **Output:** line specifying what the step produces.

If a step needs more than 3 sentences, split it into multiple steps.

### Conditionals and Loops

Use blockquotes for conditions, loops, and routing logic:

```markdown
> **Condition:** If the draft fails QC, return to Step 2.1.

> **Loop:** Repeat Steps 3.1-3.3 for each section until all sections pass review.

> **Note:** Skip this step if no external data sources are required.
```

Make routing explicit: "If X → return to Step Y", "Exit loop when Z", "If A, proceed to Stage 3; otherwise continue to Step 2.4".

### QC vs Remediation

- QC steps identify problems (do not fix)
- Remediation steps fix problems (separate from QC)

### Tables

Use tables for checklists, structured reference information, and criteria lists. Keep cell content short and headers clear.

## Workflow

### Step 1: Parse Input

Identify from the rough input:
- Major phases (become Stages)
- Actions within each phase (become Steps)
- Conditional logic or loops
- Input and output of the overall workflow

### Step 2: Structure

Organize into the standard format:
- Create Input/Output declarations
- Number stages sequentially
- Number steps hierarchically (1.1, 1.2, 2.1...)
- Name each stage and step clearly

### Step 3: Write Step Content

For each step:
- Write 1-3 sentences following: action → method → destination
- Specify the output
- Add tool tag if workflow spans multiple tools

### Step 4: Add Control Flow

Insert blockquotes for:
- Conditions that affect routing
- Loops and their exit criteria
- Notes about when steps apply or don't apply

### Step 5: Produce Output

Deliver the complete workflow documentation as markdown.

## Writing Standards

**Tone:** Imperative, action-oriented.
- "Transform the..." not "The user transforms the..."
- "Review the..." not "This step involves reviewing..."

**Sentence length:** Under 25 words where possible. What to do, not why.
