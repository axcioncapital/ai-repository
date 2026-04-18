---
model: opus
---

Improve an existing skill: $ARGUMENTS

Execute this pipeline when Patrik points to an existing skill and provides feedback or improvement ideas.

**Style:** Keep responses concise. Use short sentences and minimal formatting. Do not present triage results as tables — use a brief summary per item. When presenting pipeline step outputs, lead with decisions and flags, not exhaustive analysis.

**Pause points:** Only pause for Patrik's input at Step 1 (confirm understanding) and Step 7 (review results). All other steps execute continuously.

## Step 0: Baseline Snapshot

Before making any changes, verify the current version of the skill is committed to git. If there are uncommitted changes to the file, ask Patrik whether to commit them first or stash them. The final diff in Step 7 must show a clean comparison between the pre-improvement version and the final version — no mixed changes.

## Step 1: Understand the Feedback

Read the skill Patrik points to. Then read `skills/ai-resource-builder/SKILL.md` for the improvement methodology (see the Improve Workflow section).

Before doing anything else, present:

1. **Your understanding** of each suggestion — restate what Patrik is asking for in your own words
2. **Triage results** — for each suggestion, assess clarity, logic, compatibility, and complexity per the improver methodology
3. **Clarifying questions** — anything ambiguous or that could be interpreted multiple ways
4. **Potential problems** — breaking changes, scope concerns, anything that could go wrong. Apply the four breaking-change triggers in SKILL.md Improve Workflow Step 2: output-schema changes, core-constraint removal, required-section renames, default changes downstream resources depend on.
5. **Downstream impact** — read any skills referenced by or referencing this skill (check the cross-references section in CLAUDE.md) and flag whether the proposed changes would break interfaces or assumptions in connected skills

If any suggestions conflict with each other, flag the conflict explicitly.

**Decision point:** If the feedback is pushing the skill beyond its original scope — adding unrelated responsibilities, combining different domains, requiring 2+ new sections — flag that this may warrant a new skill rather than an improvement. Do not scope-creep an existing skill. The ai-resource-builder methodology includes a complexity threshold for this — apply it.

**Stop here and wait for Patrik's response.** Do not proceed until he confirms or adjusts.

## Step 2: Apply Changes

After Patrik confirms understanding, apply all changes that passed triage directly to the skill file. No approval gate — if it passed triage, implement it.

If scripts were modified or created, test each one by running it. A script passes if it: (a) executes without errors, and (b) produces output consistent with what SKILL.md says it should do. If a script runs but produces unexpected output, flag it — don't mark it as tested.

## Step 3: Iteration Suggestions

Review the modified skill and generate 2–4 iteration suggestions per the ai-resource-builder improvement methodology.

For each suggestion, check whether it conflicts with a change just applied in Step 2. Apply non-conflicting suggestions automatically. Skip any that would modify or reverse a Step 2 change, and note what was skipped and why.

## Step 4: Evaluate (Subagent)

**The main agent** reads `skills/ai-resource-builder/references/evaluation-framework.md` from the repo. Then spawn a subagent, passing it ONLY:

- The evaluation framework contents (that you just read)
- The modified SKILL.md (and any bundled resources)

The subagent's task: "Apply the evaluation framework (behavioral analysis + convention gate). Return the full evaluation report."

The subagent must NOT receive the original feedback, the improvement conversation, or any other context. It evaluates the skill cold.

Capture the subagent's evaluation report.

**Evaluation quality gate:** If the evaluation report contains no issues across both phases (behavioral analysis and convention gate), or provides only surface-level assessments without specific findings, flag this as a potentially shallow evaluation and note it in the Step 7 results.

## Step 5: Auto-Fix (Severity-Calibrated Iteration)

### 5a: Triage

Before fixing anything, classify every issue from the evaluation report:

- **BLOCKING** — Will cause incorrect behavior or prevent the skill from working. Must fix.
- **IMPORTANT** — Degrades quality in common scenarios. Should fix.
- **MINOR** — Edge cases, style, polish. Note for Patrik's review, do not fix.

### 5b: Fix (Pass 1)

For BLOCKING and IMPORTANT issues only:

1. Apply the smallest change that resolves each issue. Do not rewrite surrounding content, reorder sections, or "improve" adjacent text.
2. Log each fix: what was changed, why, and which issue it resolves.
3. For each fix, explicitly check: does this fix create a mismatch between the YAML description and the body? If a trigger condition, exclusion, or output format was changed, update the YAML description to match.

### 5c: Regression Check (Pass 2)

After all fixes are applied:

1. Re-read the fixed skill end-to-end
2. Check specifically for regressions introduced by the fixes:
   - Contradictions (e.g., tightening a trigger that now conflicts with an exclusion)
   - Broken content the evaluator approved (e.g., removing text that was marked as a strength)
   - New BLOCKING or IMPORTANT issues that didn't exist before the fixes
3. If regressions found, fix them and log the secondary fix

### 5d: Stall Detection

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
3. Flag the stall for Patrik in Step 7 results

### 5e: Post-Edit QC (Subagent)

After Pass 1, the regression check, and any stall handling, run an independent post-edit QC pass before proceeding to Step 6.

Spawn a fresh subagent, passing it ONLY:

- The evaluation framework contents (already read in Step 4)
- The fixed SKILL.md (and any modified bundled resources)
- The fix ledger from Step 5b (what was changed, why, which issue each fix resolved)

The subagent's task: "Verify that each logged fix resolved its target issue, check for regressions introduced by the fixes, and confirm the edited passages read cleanly in context. Do not re-run the full evaluation — focus on the fixed state."

The subagent must NOT receive the original feedback, the improvement conversation, or the original evaluator's report beyond the fix ledger.

Capture the post-edit QC report. If it surfaces unresolved BLOCKING/IMPORTANT issues or regressions, loop back into Step 5b for one additional fix pass (then re-run 5e once). If issues persist after that pass, log a stall per 5d and surface to Patrik in Step 7.

**Skip 5e only for:** single-edit fix passes, or formatting-only changes with no content risk (matches CLAUDE.md carve-out).

## Step 6: Verify Against Embedded Spec and Original Feedback

Read the skill's own YAML description and body. Check:

1. **Trigger claims** — Does the description say "use when X"? Does the body actually handle X?
2. **Exclusion claims** — Does the description say "do NOT use for Y"? Does the body reinforce this boundary?
3. **Output claims** — Does the skill promise a specific output format? Does the body produce it?
4. **Input claims** — Does the skill say it expects certain inputs? Does the body handle missing/malformed inputs?
5. **Cross-references** — Does the skill reference other skills or files? Do those references resolve?
6. **Fix alignment** — Review the auto-fix log from Step 5. For each fix that changed functionality, verify the YAML description still accurately describes what the skill does.
7. **Feedback resolution** — Review Patrik's original feedback from Step 1. For each item, verify: was it addressed in the final version? Rate each as Resolved / Partially resolved / Unresolved. If any item is Unresolved, flag it prominently.

Flag any mismatches between what the skill claims and what it actually does.

## Step 7: Present Results

Show Patrik:

1. **The skill** — complete final version after all changes and auto-fixes
2. **Evaluation report** — the subagent's full output (with shallow-evaluation flag if triggered)
3. **Fixes applied** — what Critical/Major issues were found, how they were resolved, whether secondary fixes were needed, and the post-edit QC verdict from Step 5e
4. **Feedback resolution** — status of each original feedback item (Resolved / Partially resolved / Unresolved)
5. **Remaining issues** — any Minor issues, spec verification mismatches, or shallow-evaluation concerns
6. **The diff** — complete diff from the baseline version (Step 0) to the final version

Ask for Patrik's review. He may request changes, approve as-is, or ask for another iteration.

## Step 8: Commit

Only after Patrik explicitly approves:

1. Stage modified files
2. Commit following the convention in CLAUDE.md (currently: `update: {skill-name} — {what changed}`)
3. Wait for Patrik's go-ahead before pushing.
