Migrate a skill from Claude Chat to Claude Code: $ARGUMENTS

Execute this pipeline when Patrik provides skill content from Claude Chat (pasted text, project instructions, or artifact content) that needs to be migrated into a properly formatted SKILL.md in the skill library.

## Step 1: Analyze the Source

Read `skills/ai-resource-builder/SKILL.md` for the creation methodology and format standard.

Then analyze the pasted Chat skill content and present:

1. **Migration map** — what content maps to:
   - YAML frontmatter (name, description with triggers/exclusions)
   - SKILL.md body (procedural instructions)
   - references/ (lengthy reference material, examples, templates)
   - scripts/ (any executable code)
   - assets/ (any output templates or files)
2. **Content that needs rewriting** — flag anything that:
   - Is written for a human reader rather than for Claude (explanations of what Claude already knows, motivational framing, etc.)
   - Lacks explicit trigger conditions or exclusions
   - Uses Chat-specific patterns (artifact output, conversation-style instructions) that need Claude Code adaptation
   - Embeds large examples or reference material that should be split into references/
3. **Missing elements** — anything required by the skill format standard that the Chat version doesn't provide (failure behavior, output contract, scope boundaries, etc.)
4. **Proposed skill name** — lowercase, hyphenated folder name
5. **Potential problems** — conflicts with existing skills in the library, scope concerns

**Decision point:** If the Chat skill content is too vague, covers multiple unrelated responsibilities, or would need significant invention (not just reformatting) to become a valid skill, stop and say so. Migration means reshaping existing content, not creating new content from a sketch.

**Stop here and wait for Patrik's response.** Do not proceed until he confirms or adjusts.

## Step 2: Write the Skill

After Patrik approves the migration plan:

1. Create the skill directory at `skills/{skill-name}/`
2. Write the complete SKILL.md following ai-resource-builder methodology, applying the migration map from Step 1
3. Create any bundled resources (references/, scripts/, assets/) as identified
4. If scripts were created, test each one by running it

Key migration rules:
- Strip human-facing explanations that Claude doesn't need — keep only non-obvious procedural knowledge
- Construct a proper YAML description with explicit trigger conditions AND exclusions
- Convert any Chat artifact output patterns to file-based output
- If the Chat skill referenced conversation context or user messages in Chat-specific ways, adapt to Claude Code's file-based and tool-based interaction model
- Apply progressive disclosure — keep SKILL.md under 500 lines, move heavy content to references/

## Step 3: Evaluate (Subagent)

**The main agent** reads `skills/ai-resource-builder/references/evaluation-framework.md` from the repo. Then spawn a subagent, passing it ONLY:

- The evaluation framework contents (that you just read)
- The newly created SKILL.md (and any bundled resources)

The subagent's task: "Apply the evaluation framework (behavioral analysis + convention gate). Return the full evaluation report."

The subagent must NOT receive the original Chat skill content, the migration conversation, or any other context. It evaluates the skill cold, as a fresh Claude would encounter it.

Capture the subagent's evaluation report.

**Evaluation quality gate:** If the evaluation report contains no issues across all eight layers, or provides only surface-level assessments without specific findings, flag this as a potentially shallow evaluation and note it in the Step 6 results.

## Step 4: Auto-Fix

Review the evaluation report. For any **Critical** or **Major** issues:

1. Apply fixes directly to the skill file
2. Log each fix: what was changed and why
3. For each fix, explicitly check: does this fix create a mismatch between the YAML description and the body? If a trigger condition, exclusion, or output format was changed, update the YAML description to match.

Do NOT auto-fix Minor issues — note them for Patrik's review.

## Step 4b: Verify Fixes

After all auto-fixes are applied, do a lightweight re-check:

1. Re-read the fixed skill end-to-end
2. Check that fixes didn't introduce contradictions
3. Check that fixes didn't break something the evaluator approved

If new issues are found, fix them and log the secondary fix. Do not loop more than once — if issues persist after one round of secondary fixes, flag them for Patrik's review.

## Step 5: Verify Against Embedded Spec

Read the skill's own YAML description and body. Check:

1. **Trigger claims** — Does the description say "use when X"? Does the body actually handle X?
2. **Exclusion claims** — Does the description say "do NOT use for Y"? Does the body reinforce this boundary?
3. **Output claims** — Does the skill promise a specific output format? Does the body produce it?
4. **Input claims** — Does the skill say it expects certain inputs? Does the body handle missing/malformed inputs?
5. **Cross-references** — Does the skill reference other skills or files? Do those references resolve?
6. **Fix alignment** — Review the auto-fix log from Step 4. For each fix that changed functionality, verify the YAML description still accurately describes what the skill does.
7. **Migration fidelity** — Compare the final skill against the original Chat content. Flag any functional capability from the original that was lost or materially changed during migration (not formatting differences — actual behavior differences).

Flag any mismatches.

## Step 6: Present Results

Show Patrik:

1. **The skill** — final version after auto-fixes
2. **Evaluation report** — the subagent's full output (with shallow-evaluation flag if triggered)
3. **Fixes applied** — what Critical/Major issues were found, how they were resolved
4. **Migration fidelity** — any capabilities from the original Chat skill that were changed, split out, or dropped, and why
5. **Remaining issues** — any Minor issues, spec verification mismatches, or shallow-evaluation concerns
6. **The diff** — complete diff of all files created

Ask for Patrik's review. He may request changes, approve as-is, or ask for another iteration.

## Step 7: Commit

Only after Patrik explicitly approves:

1. Stage all new files
2. Commit following the convention in CLAUDE.md (currently: `new: {skill-name} — migrated from Chat`)
3. Wait for Patrik's go-ahead before pushing
