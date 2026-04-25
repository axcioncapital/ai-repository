---
model: sonnet
---

Request a new or improved skill: $ARGUMENTS

Use this command from any project workspace when you identify a skill gap. This command does NOT create the skill — it captures the need as a structured brief and routes it to the canonical creation pipeline.

## Step 1: Understand the Need

Based on Patrik's description, clarify:

1. **What capability is needed** — what should the skill do?
2. **Why it's needed** — what triggered this? What task exposed the gap?
3. **When it would trigger** — in what situations should this skill activate?
4. **What it should NOT do** — boundaries and exclusions

If the description is too vague to write a useful brief, ask clarifying questions before proceeding. Do not guess.

## Step 2: Check for Existing Skills

Search `ai-resources/skills/` for skills that might already cover this need:

1. Read YAML frontmatter (name + description) of all skills
2. Identify any that overlap with the requested capability
3. Present findings:
   - **Exact match:** "This already exists — see `skills/{name}/`. Do you want to improve it instead?" → Route to `/improve-skill`
   - **Partial overlap:** "These skills cover adjacent ground: [list]. The gap is: [specific delta]." → Continue to Step 3 with the delta as the brief focus
   - **No match:** Continue to Step 3

## Step 3: Write the Resource Brief

Write a structured brief to `ai-resources/inbox/{brief-name}.md`:

```markdown
# Resource Brief: {skill-name}

**Requested:** {date}
**Origin:** {project workspace name} — {what task surfaced the need}

## Capability
{What the skill should do — 2-3 sentences}

## Trigger Conditions
{When this skill should activate}

## Exclusions
{What this skill should NOT do}

## Context
{Why this is needed — the project context, the gap it fills, any related skills}

## Existing Skills Reviewed
{List of skills checked in Step 2 and why they don't cover this need}
```

Use lowercase-hyphenated naming for the brief file (e.g., `service-blueprint-drafter.md`).

## Step 4: Confirm and Hand Off

Show Patrik the brief content. Then ask: "Ready to create this skill? I'll run `/create-skill` with this brief."

On confirmation, proceed directly to `/create-skill`. The brief in `inbox/` serves as the resource brief that `/create-skill` Step 1 expects. Pass the brief file path so `/create-skill` can read it.

No session switch needed — `ai-resources/` is connected via `--add-dir`, so the full creation pipeline runs from the current workspace.
