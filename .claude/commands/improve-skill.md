Improve an existing skill: $ARGUMENTS

Follow the improvement workflow defined in CLAUDE.md exactly. Here is the sequence:

## Step 1: Read and Understand

Read the skill file specified above. If a path wasn't provided, ask me which skill to improve.

Then confirm your understanding of the skill's purpose and current structure before I share my feedback.

## Step 2: Gather Feedback

Ask me what I want changed or improved. If I already provided feedback above, confirm your understanding of it before proceeding.

## Step 3: Propose Changes (wait for my approval)

Present specific changes:
- **What** — the concrete modification
- **Where** — which section/lines
- **Why** — the reasoning

Do NOT apply changes yet. Wait for my approval.

## Step 4: Apply Changes

After my approval, apply the changes to the file.

If the skill is part of the research pipeline (`research-plan-creator → answer-spec-generator → cluster-analysis-pass → evidence-to-report-writer`), check downstream skills for impact and flag any concerns.

## Step 5: Quality Check

Read `skills/ai-resource-evaluator/SKILL.md` and apply its eight-layer evaluation framework with the Skill priority matrix on the modified version. Flag issues as Critical / Major / Minor with specific fixes.

Present findings and any iteration suggestions. Fix only what I approve.

## Step 6: Finalize

Show me the final diff and wait for my go-ahead before committing.

Use commit message format: `update: skill-name — what changed`

---

IMPORTANT: Move through these steps one at a time. Wait for my input/approval at each checkpoint before proceeding to the next step.
