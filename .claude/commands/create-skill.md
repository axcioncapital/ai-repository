# Create Skill Pipeline

Execute this pipeline when Patrik provides a resource brief for a new skill.

## Step 1: Understand the Need

Read the resource brief Patrik provides. Then read `skills/ai-resource-builder/SKILL.md` for the creation methodology (see the Create Workflow section).

Before doing anything else, present:

1. **Your understanding** of what the skill does, who it's for, and when it triggers
2. **Proposed structure** — what goes in SKILL.md vs. references/ vs. scripts/ vs. assets/
3. **Clarifying questions** — anything ambiguous or missing from the brief that would materially change the skill. Only ask questions where the answer changes the output.
4. **Potential problems** — conflicts with existing skills, scope concerns, anything that could go wrong

**Decision point:** If clarifying questions reveal the brief needs significant rework (e.g., scope points at two different skills, an existing skill already covers this need, or the brief is too vague to proceed), stop the pipeline and say so. Do not force a skill out of an unclear brief.

**Stop here and wait for Patrik's response.** Do not proceed until he confirms or adjusts.

## Step 2: Write the Skill

After Patrik approves the plan:

1. Create the skill directory at `skills/{skill-name}/`
2. Write the complete SKILL.md following ai-resource-builder methodology
3. Create any bundled resources (scripts/, references/, assets/) as planned
4. If scripts were created, test each one by running it. A script passes if it: (a) executes without errors, and (b) produces output consistent with what SKILL.md says it should do. If a script runs but produces unexpected output, flag it — don't mark it as tested.

## Step 3: Evaluate (Subagent)

**The main agent** reads `skills/ai-resource-builder/references/evaluation-framework.md` from the repo. Then spawn a subagent, passing it ONLY:

- The evaluation framework contents (that you just read)
- The newly created SKILL.md (and any bundled resources)

The subagent's task: "Apply the evaluation framework (behavioral analysis + convention gate). Return the full evaluation report."

The subagent must NOT receive the resource brief, the creation conversation, or any other context. It evaluates the skill cold, as a fresh Claude would encounter it.

Capture the subagent's evaluation report.

**Evaluation quality gate:** If the evaluation report contains no issues across both phases (behavioral analysis and convention gate), or provides only surface-level assessments without specific findings, flag this as a potentially shallow evaluation and note it in the Step 6 results.

## Step 4: Auto-Fix (Severity-Calibrated Iteration)

### 4a: Triage

Before fixing anything, classify every issue from the evaluation report:

- **BLOCKING** — Will cause incorrect behavior or prevent the skill from working. Must fix.
- **IMPORTANT** — Degrades quality in common scenarios. Should fix.
- **MINOR** — Edge cases, style, polish. Note for Patrik's review, do not fix.

### 4b: Fix (Pass 1)

For BLOCKING and IMPORTANT issues only:

1. Apply the smallest change that resolves each issue. Do not rewrite surrounding content, reorder sections, or "improve" adjacent text.
2. Log each fix: what was changed, why, and which issue it resolves.
3. For each fix, explicitly check: does this fix create a mismatch between the YAML description and the body? If a trigger condition, exclusion, or output format was changed, update the YAML description to match.

### 4c: Regression Check (Pass 2)

After all fixes are applied:

1. Re-read the fixed skill end-to-end
2. Check specifically for regressions introduced by the fixes:
   - Contradictions (e.g., tightening a trigger that now conflicts with an exclusion)
   - Broken content the evaluator approved (e.g., removing text that was marked as a strength)
   - New BLOCKING or IMPORTANT issues that didn't exist before the fixes
3. If regressions found, fix them and log the secondary fix

### 4d: Stall Detection

If the same issue persists after Pass 1 and the regression check (2 fix attempts):

1. Stop trying to fix the output
2. Log a structured escalation to `logs/improvement-log.md`:
   ```
   - **Category:** stall-escalation
   - **Issue:** [what the issue is]
   - **Attempts:** [what was tried in each pass]
   - **Likely fix layer:** [CLAUDE.md rule / skill instruction / command step / evaluation framework]
   - **Recommendation:** [specific instruction change that would prevent this issue from recurring]
   ```
3. Flag the stall for Patrik in Step 6 results

## Step 5: Verify Against Embedded Spec

Read the skill's own YAML description and body. Check:

1. **Trigger claims** — Does the description say "use when X"? Does the body actually handle X?
2. **Exclusion claims** — Does the description say "do NOT use for Y"? Does the body reinforce this boundary?
3. **Output claims** — Does the skill promise a specific output format? Does the body produce it?
4. **Input claims** — Does the skill say it expects certain inputs? Does the body handle missing/malformed inputs?
5. **Cross-references** — Does the skill reference other skills or files? Do those references resolve?
6. **Fix alignment** — Review the auto-fix log from Step 4. For each fix that changed functionality, verify the YAML description still accurately describes what the skill does.

Flag any mismatches between what the skill claims and what it actually does.

## Step 6: Present Results

Show Patrik:

1. **The skill** — final version after auto-fixes
2. **Evaluation report** — the subagent's full output (with shallow-evaluation flag if triggered)
3. **Fixes applied** — what Critical/Major issues were found, how they were resolved, and whether secondary fixes were needed
4. **Remaining issues** — any Minor issues, spec verification mismatches, or shallow-evaluation concerns
5. **The diff** — complete diff of all files created

Ask for Patrik's review. He may request changes, approve as-is, or ask for another iteration.

## Step 7: Commit

Only after Patrik explicitly approves:

1. Stage all new files
2. Commit following the convention in CLAUDE.md (currently: `new: {skill-name} — {one-line purpose}`)
3. Wait for Patrik's go-ahead before pushing
