# Workflow System Critique: research-workflow

**Date:** 2026-04-07
**Based on:** workflow-analysis-research-workflow-2026-04-07.md
**Depth:** Standard

---

## Findings

### Critical (0)

No Critical findings. Checked: skill existence (all 33 found), hook script existence (all registered scripts present), hand-off chain connectivity (16 of 17 connected), settings.json matcher validity.

### High (4)

### [High] H-1: Stage 5 has no implementing command — 8 steps unreachable via automation
- **Check:** Check 2: Pipeline Continuity
- **Location:** stage-instructions.md (Stage 5, Steps 5.1-5.8), Section 3.1 Stage-to-Command Mapping (row "Stage 5: Final Production")
- **Evidence:** Stage-to-Command Mapping shows Stage 5 with "No implementing command" and Coverage Notes: "No `/run-final` command exists. Stage 5 is defined in stage-instructions.md but has no dedicated command." Hand-off Chain shows the final entry status as "UNCONNECTED -- no Stage 5 command." Raw Observations 6.1 confirms the gap.
- **Impact:** The entire final production phase (integration QC, formatting, merge, compilation, glossary, front matter) must be performed manually or ad hoc. The pipeline breaks after Stage 4. Two operator gates defined in Stage 5 (Step 5.4 review, final review) have no command to enforce them.
- **Recommendation:** Create a `/run-final` command implementing Steps 5.1-5.8, referencing `document-integration-qc` and `citation-converter` skills. Wire it to read from `report/chapters/{section}/` (the output of run-report).

### [High] H-2: document-integration-qc skill is DOCUMENT-ONLY — declared but never invoked by any command
- **Check:** Check 3: Document-System Drift
- **Location:** Section 5.1 Skill References (row "document-integration-qc"), stage-instructions.md Stage 5 Step 5.1
- **Evidence:** Cross-Reference Matrix shows document-integration-qc with status "DOCUMENT-ONLY" — present in stage-instructions.md (Stage 5, Step 5.1) but referenced by no command. Raw Observations 6.1 notes it appears in the qc-gate agent's criteria routing table but not in any command file.
- **Impact:** The integration QC step promised by the workflow document does not execute. Cross-chapter consistency, duplicate content, and structural coherence go unchecked by any automated gate.
- **Recommendation:** Include `document-integration-qc` invocation in the `/run-final` command (see H-1). If Stage 5 is intentionally deferred, document this explicitly in CLAUDE.md.

### [High] H-3: Two Stage 5 operator gates are DOCUMENT-ONLY — promised reviews that never fire
- **Check:** Check 3: Document-System Drift
- **Location:** Section 5.2 Gates (rows "Operator reviews v1.4 drafts" and "Final operator review"), stage-instructions.md Stage 5
- **Evidence:** Gates table shows two entries with status "DOCUMENT-ONLY": the Step 5.4 operator review of v1.4 drafts and the final operator review. Both are declared in stage-instructions.md but have no implementing command.
- **Impact:** The workflow document promises two review checkpoints that will not occur. The operator expects to review v1.4 drafts and give final approval, but no command will pause for these gates. Deliverables could be finalized without the promised reviews.
- **Recommendation:** These gates should be implemented in the `/run-final` command (see H-1). Until then, add a note to CLAUDE.md's Workflow Overview section that Stage 5 requires manual execution.

### [High] H-4: "Research Execution GPT produces evidence" rule is behavioral-only with high blast radius
- **Check:** Check 4: Rule Enforcement Gaps
- **Location:** Section 5.3 Rule Enforcement (row "Research Execution GPT produces evidence -- Claude does not substitute its own research"), CLAUDE.md Cross-Model Rules section
- **Evidence:** Rule Enforcement table shows enforcement level "behavioral-only" — no hook, no command-level enforcement. The rule is stated in CLAUDE.md but relies entirely on Claude following the instruction.
- **Impact:** If Claude substitutes its own knowledge for research evidence in Stage 2, the entire evidence chain is compromised. Downstream analysis, synthesis, and report production would build on unverified claims. This is the highest-consequence rule in the workflow.
- **Recommendation:** Add a PreToolUse hook or command-level guard that checks whether Stage 2 artifact writes contain proper source attribution (claim IDs, source references). A lightweight heuristic — checking for the presence of claim ID patterns — would catch the most obvious violations without blocking legitimate work.

### Medium (4)

### [Medium] M-1: check-claim-ids.sh exists but is not registered in settings.json
- **Check:** Check 5: Orphaned Components
- **Location:** Section 1.4 Settings Entries (check-claim-ids.sh absent), Section 4 Hook Mapping (row "check-claim-ids.sh"), Raw Observations 6.2
- **Evidence:** Hook Mapping shows check-claim-ids.sh with "Not registered in settings.json. Only invoked manually by verify-chapter command (Step 1b)." The script exists in `.claude/hooks/` but has no settings.json trigger. All other hook scripts (friction-log-auto.sh, log-write-activity.sh, detect-innovation.sh) are registered.
- **Impact:** The hook was likely intended to fire automatically on writes to report/chapter paths, catching [CITATION NEEDED] tags as they are written rather than only during manual verify-chapter runs. Citation gaps in chapter prose may go undetected until a late-stage manual review.
- **Recommendation:** Register check-claim-ids.sh as a PostToolUse Write hook with a matcher targeting `report/chapters/` and `final/modules/` paths. Set timeout to 5s consistent with other hooks. If manual-only invocation is intentional, document the rationale in a comment in settings.json.

### [Medium] M-2: qc-reviewer and refinement-reviewer agents referenced by commands but no agent files exist
- **Check:** Check 5: Orphaned Components (inverse: phantom agent references)
- **Location:** Section 6 Raw Observations 6.4, Section 1.1 Commands (rows "qc-pass" and "refinement-pass")
- **Evidence:** Raw Observations 6.4: "qc-reviewer (referenced by qc-pass) -- no qc-reviewer.md agent file exists. The closest is qc-gate.md." and "refinement-reviewer (referenced by refinement-pass) -- no refinement-reviewer.md agent file exists."
- **Impact:** The qc-pass and refinement-pass commands reference agent definitions that do not exist. If these commands spawn subagents using those names, the agent definition will not load and the subagent may run without the intended configuration (model, tools, instructions). The commands may still function if they inline the agent instructions, but the missing file creates ambiguity about intended behavior.
- **Recommendation:** Either create `qc-reviewer.md` and `refinement-reviewer.md` agent files in `.claude/agents/`, or update the commands to reference the existing `qc-gate.md` agent if that is the intended definition.

### [Medium] M-3: Cumulative hook timeout per Write to pipeline path is 25 seconds
- **Check:** Check 6: Hook Coherence
- **Location:** Section 4 Hook Coverage Summary, Section 1.4 Settings Entries
- **Evidence:** Hook Coverage Summary states: "Cumulative timeout per Write operation to a pipeline path: 25ms (15s auto-commit + 5s log-write-activity + 5s detect-innovation)." Note: the analysis labels this "25ms" but the individual values sum to 25 seconds (15s + 5s + 5s). This appears to be a unit error in the analysis text.
- **Impact:** Every Write to a pipeline path (preparation/, execution/, analysis/, report/) triggers three PostToolUse hooks with a combined timeout ceiling of 25 seconds. While hooks typically complete faster than their timeout ceiling, the potential for delays near the 30-second threshold exists, particularly if git auto-commit encounters lock contention or large diffs.
- **Recommendation:** Monitor actual execution times. If auto-commit consistently completes within 5s, reduce its timeout from 15s to 10s. The 25s cumulative is below the 30s critical threshold but worth tracking.

### [Medium] M-4: "Sub-agents receive content, not file paths" rule is behavioral-only
- **Check:** Check 4: Rule Enforcement Gaps
- **Location:** Section 5.3 Rule Enforcement (row "Sub-agents receive content, not file paths"), CLAUDE.md Context Isolation Rules section
- **Evidence:** Rule Enforcement table shows enforcement level "behavioral-only" — no hook enforcement, no command-level reference cited.
- **Impact:** If a command passes file paths instead of content to a subagent, the subagent may fail to read files it lacks tool access to, or may produce empty/malformed output. The rule protects against a class of silent failures in delegated steps.
- **Recommendation:** Add explicit file-reading and content-passing instructions as a standard pattern in pipeline command templates. This is a documentation/template fix rather than a hook — hook enforcement would require intercepting Agent tool calls, which is not practical.

### Low (4)

### [Low] L-1: 8 COMMAND-ONLY skills not documented in stage-instructions.md
- **Check:** Check 3: Document-System Drift
- **Location:** Section 5.1 Skill References (rows with status "COMMAND-ONLY")
- **Evidence:** Cross-Reference Matrix shows 8 skills with status "COMMAND-ONLY": context-pack-builder, knowledge-file-producer, session-usage-analyzer, workflow-evaluator, evidence-prose-fixer, chapter-review, repo-health-analyzer, architecture-qc. Additionally, report-compliance-qc is COMMAND-ONLY.
- **Impact:** The workflow document does not reflect these skills. Most are utility/support skills (not pipeline-critical), but architecture-qc and report-compliance-qc are used by run-report as part of the Stage 4 pipeline. Their absence from stage-instructions.md means the document understates the QC coverage in Stage 4.
- **Recommendation:** Add architecture-qc (Step 4.1b) and report-compliance-qc (Step 4.5) to stage-instructions.md. The remaining utility skills do not need stage-instructions entries but could be listed in a "Support Skills" appendix if desired.

### [Low] L-2: Advisory hooks (checkpoint check, session wrap check, template drift check) have unconsumed output
- **Check:** Check 5: Orphaned Components
- **Location:** Section 4 Hook Coverage Summary
- **Evidence:** Hook Coverage Summary lists 3 hooks with "unconsumed output": inline checkpoint check, inline session wrap check, inline template drift check. All produce systemMessage output only.
- **Impact:** Minimal. These are advisory by design — they remind the operator of best practices via systemMessage. The output is consumed by the operator's attention, not by any downstream command. This is not a true orphaned component.
- **Recommendation:** No action needed. This is the correct pattern for advisory hooks.

### [Low] L-3: Duplicate functionality across intake-reports, inject-dependency, and run-execution
- **Check:** Check 2: Pipeline Continuity
- **Location:** Section 6 Raw Observations 6.3, Section 3.1 Stage-to-Command Mapping (Stage 2 support rows)
- **Evidence:** Raw Observations 6.3: "intake-reports and run-execution (Steps 2.2a and 2.2b) contain overlapping functionality. inject-dependency also overlaps with run-execution Step 2.2a. These appear to be standalone convenience alternatives."
- **Impact:** Low risk. The overlap is intentional (convenience commands for partial execution). No conflicting behavior is indicated. The only risk is maintenance drift — if run-execution's filing logic is updated, the standalone commands may fall out of sync.
- **Recommendation:** Add a cross-reference comment in each standalone command noting that it overlaps with run-execution Steps 2.2a/2.2b and should be updated in tandem.

### [Low] L-4: Prompt files in ai-resources/prompts/supplementary-research/ not inventoried as skills
- **Check:** Check 1: Skill Interface Compatibility (peripheral)
- **Location:** Section 6 Raw Observations 6.8
- **Evidence:** Raw Observations 6.8: "run-analysis command's Subworkflow 3.S references prompt files in ai-resources/prompts/supplementary-research/: S0-extract-failed-components.md, S1-query-brief-pass1.md, S1-query-brief-pass2.md, S3-qc-supplementary-results.md, S4-merge-instructions.md. These are separate from the skill files."
- **Impact:** These prompts are consumed by the workflow but are not tracked in the skill registry. If they are moved, renamed, or deleted, the run-analysis command will silently fail to find them. No interface compatibility check covers them.
- **Recommendation:** Either convert these prompts to skills (if they contain reusable procedural logic) or add them to the analysis artifact as a "Non-Skill Dependencies" section so they are tracked for drift.

---

## Deep Assessment

Not run. Use `/analyze-workflow {path} deep` to include.

---

## Summary

- Critical: 0
- High: 4
- Medium: 4
- Low: 4
- Total: 12

**Top 3 recommendations by impact:**

1. **Create a `/run-final` command for Stage 5** -- without it, the last 8 steps of the pipeline (integration QC, formatting, merge, compilation) have no automation, and two operator review gates will not fire.
2. **Register check-claim-ids.sh in settings.json as a PostToolUse Write hook** -- citation gap detection currently only runs during manual verify-chapter invocations, leaving report prose unmonitored during normal writes.
3. **Create missing agent definition files (qc-reviewer.md, refinement-reviewer.md) or update commands to reference existing agents** -- two utility commands reference agent definitions that do not exist, causing ambiguous subagent behavior.
