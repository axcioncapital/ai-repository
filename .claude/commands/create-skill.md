Create a new skill: $ARGUMENTS

Follow the creation workflow defined in CLAUDE.md exactly. Here is the sequence:

## Step 1: Understand the Need

Discuss the skill with me before writing anything. Ask targeted questions to clarify:
- What functionality should the skill support?
- What triggers it? What should NOT trigger it?
- Typical usage examples

Do not overwhelm with questions — start with the most important ones and follow up as needed.

## Step 2: Plan the Structure

Based on the discussion, plan what goes in:
- SKILL.md (the core instructions)
- scripts/ (if deterministic/repeated code is needed)
- references/ (if detailed reference material is needed)
- assets/ (if output files are needed)

Present an outline of the SKILL.md structure for my review. Do NOT write the full file yet.

## Step 3: Write the Skill (after my approval of the outline)

Read `skills/skill-creator/SKILL.md` for the full skill-creation methodology, then:

1. Create the folder under `skills/` using lowercase-hyphenated naming
2. Write any bundled resources (scripts/, references/, assets/) first
3. If scripts were added, test each one by running it
4. Write the complete SKILL.md following the skill-creator methodology

## Step 4: Quality Check

Read `skills/ai-resource-evaluator/SKILL.md` and apply its eight-layer evaluation framework with the Skill priority matrix. Flag issues as Critical / Major / Minor with specific fixes.

Present findings. Fix only what I approve.

## Step 5: Finalize

Show me the final diff and wait for my go-ahead before committing.

Use commit message format: `new: skill-name — purpose`

---

IMPORTANT: Move through these steps one at a time. Wait for my input/approval at each checkpoint before proceeding to the next step.
