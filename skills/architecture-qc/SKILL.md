---
name: architecture-qc
description: >
  Independent QC of a report architecture specification produced by
  research-structure-creator. Evaluates the architecture against skill quality
  criteria, structural completeness, and project-specific compliance (scarcity
  register, editorial recommendations, section directives, style reference).
  Use after report architecture has been produced and before chapter prose
  production begins. Do NOT use for creating the architecture (that's
  research-structure-creator), for writing chapter prose (that's
  evidence-to-report-writer), or for reviewing prose quality.
---

# Architecture QC

Independent quality check of a report architecture specification. This skill evaluates whether the architecture is complete, structurally sound, and compliant with project inputs — before any chapter prose is written.

## Pipeline Position

```
research-structure-creator → [this skill] → operator review → evidence-to-report-writer
```

This is a verification gate. FAIL verdicts block chapter production until the architecture is fixed.

## Input Requirements

All inputs required:

1. **Report architecture** — the artifact under review (from `research-structure-creator`)
2. **Scarcity register** — confirmed evidence scarcity items with editorial instructions
3. **Section directives** — from `section-directive-drafter`, including word count targets
4. **Approved editorial recommendations** — from `editorial-recommendations-generator` (approved via QC)
5. **Chapter drafts** — original chapter drafts from `/analysis/chapters/` (to verify traceability coverage)

### Validation

Before proceeding, verify:

- Architecture file exists and is non-empty
- Scarcity register is loaded (or confirmed absent)
- Section directives contain word count ranges
- Editorial recommendations contain decision IDs

**Hard stop conditions:**
- Architecture file missing or empty → Refuse. Nothing to QC.
- Chapter drafts unavailable → Refuse. Cannot verify traceability without source material.

## Evaluation Criteria

### A. Skill Quality Criteria (from research-structure-creator)

1. **Seamless integration:** Does the unified document read as if planned from the start — no visible seams between content from different chapters?
2. **Content completeness:** Does every piece of original content have a home in the traceability table? Is anything silently dropped?
3. **Purpose-driven depth:** Is depth allocated proportional to the document's purpose, not just to how much was originally written?
4. **Explicit dependencies:** Are dependencies between sections made explicit so downstream writing can proceed in the correct order?
5. **Writer sufficiency:** Could a writer assemble the document from this spec without re-reading all original chapters?
6. **Must-land visibility:** Does the document's purpose show in every section's depth allocation and must-land content?

### B. Structural Completeness

7. **All 8 specification components present:** Section hierarchy, reader-question ownership table, depth allocation (with section function gate), cross-reference map, front/back matter decisions, traceability table, structural override log, structural self-audit
8. **Traceability coverage:** Every content segment from the original chapters appears in the traceability table with an action and seam note where required
9. **H3 headings:** Are proposed H3 subdivisions logical and do they cover all content within each H2?
10. **Processing order:** Is the stated processing order consistent with the dependency map?

### C. Project-Specific Compliance

11. **Scarcity register coverage:** Does the architecture account for every item in the scarcity register? Cross-check each scarcity item ID against the architecture's traceability table or writer compliance checklist.
12. **Editorial recommendations honored:** Does the writer compliance checklist or traceability table reference the key editorial decisions from the approved recommendations? Check that each decision category (CC, FP, EW, GH, TR, XC) with approved recommendations appears.
13. **Section directives alignment:** Do the word count targets in the architecture match the word count ranges from the section directives? Compare each section's allocation against the directive's specified range.
14. **Style reference lock:** Does the architecture specify when the style reference locks and how subsequent chapters use it?

### D. Document Function Integrity

15. **Job Sentence declared and singular; Future-State coverage honored:** Does the architecture contain a Job Sentence in *"This document exists to do X, not Y"* form, and does the document's actual content obey it? FAIL if:
    - The Job Sentence is missing or has no *"not Y"* clause, OR
    - Any section's content sits in the Y territory without being labeled Future-State, OR
    - Any Future-State-labeled section is not explicitly covered by the Job Sentence's *"not Y"* clause as staged evolution within scope, OR
    - **(Competing-jobs prong)** The document contains a terminal or major section whose dominant mode differs substantially from the declared (or, if the Job Sentence is missing, inferable) operating mode — e.g., a future-state planning section in a current-state operating blueprint, or a persuasion section in a specification document — and no Job Sentence scopes whether that mode is in or out of the document's job. This prong fires even when the scaffold (Job Sentence) is absent; absence does not mask the underlying dual-job pattern.
16. **Reader-question ownership is exclusive (table *and* content):** Two-prong test.
    - **Prong 1 (table):** The Reader-Question Ownership table lists each reader question with exactly one primary owner. No distributed ownership in the table itself.
    - **Prong 2 (content):** Read the scope-critical sections directly (not just the table). Verify (a) sections labeled Support do not do primary-answer work for any reader question, and (b) the primary-answer for each reader question is not materially re-performed in a non-adjacent section. At minimum, read the sections named in Support justifications plus any sections that touch scope-shaping (principles, service definition, boundaries/exclusions by typical convention). FAIL on either prong. The second prong catches clean-table-dirty-prose patterns.
17. **Mode coherence (with self-audit trail):** Does the section sequence hold a consistent mode, or are mode shifts justified by the Job Sentence? The creator's Structural Self-Audit (spec component 8) includes a Mode check with written findings — use those findings as your audit trail. Evaluate:
    - Is the Mode check documented in the spec (findings present, not silently skipped)?
    - Are all flagged mode transitions either justified as essential to the Job Sentence or resolved (eliminated / re-scoped)?
    - Is there any uncompensated detour the creator missed — particularly a specification → comparative → specification pattern — that passes unflagged in the self-audit?

    FAIL if the self-audit findings are absent, if a flagged transition remains unjustified and unresolved, or if an unflagged detour is discoverable by walking the section sequence independently.
18. **Linear usability / sequence integrity (with self-audit trail):** Can a reader consuming the document in order resolve questions about the core object without jumping across non-adjacent sections? The creator's Sequence check in component 8 addresses this — audit its findings the same way as Criterion 17. FAIL if the Sequence check is absent, if a flagged linear-usability issue remains unresolved, or if live questions about the core object (classification, exclusion, boundary, monitoring, reactivation) are scattered across distant sections such that linear reading fragments the object and the creator did not flag it.

## Procedure

For each criterion (1–18):

1. Read the relevant section of the architecture
2. Cross-reference against the appropriate input (chapter drafts for traceability, scarcity register for criterion 11, editorial recommendations for criterion 12, section directives for criterion 13; actual section content for criterion 16 prong 2; Structural Self-Audit findings for criteria 17 and 18)
3. Assign a verdict: **PASS** or **FAIL**
4. Record a one-sentence finding. If FAIL, state what is missing or wrong.

**Independent-walk rule for criteria 17 and 18:** When the Structural Self-Audit (spec component 8) is absent, the absence is itself a FAIL condition, but the evaluator must still perform the independent sequence walk directly as the primary check and record the diagnostic finding — do not stop at the absence. The absence-FAIL and the walk-FAIL are logged together when both apply.

After all 18 criteria are evaluated, determine the overall verdict.

## Finding Severity

- **Critical:** A FAIL that would cause downstream problems in chapter production (e.g., missing traceability entries, wrong word counts, scarcity items unaccounted for). Blocks proceeding.
- **Minor:** A FAIL on a criterion that can be fixed without structural rework (e.g., missing style reference lock note, incomplete cross-reference map). Note but does not block if isolated.

## Output Format

```markdown
# QC Report: Report Architecture

**Date:** [date]
**Section:** [section ID]
**Artifact QC'd:** [path to architecture file]

## Summary

- Criteria evaluated: 18
- PASS: [n] | FAIL: [n]
- Critical failures: [n]
- Overall verdict: PASS / FAIL

## Evaluation

### A. Skill Quality Criteria

#### 1. Seamless integration
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

#### 2. Content completeness
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

[...repeat for criteria 3–6...]

### B. Structural Completeness

#### 7. All 8 specification components present
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

[...repeat for criteria 8–10...]

### C. Project-Specific Compliance

#### 11. Scarcity register coverage
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

[...repeat for criteria 12–14...]

### D. Document Function Integrity

#### 15. Job Sentence declared and singular; Future-State coverage honored
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

#### 16. Reader-question ownership is exclusive (table and content)
**Verdict:** PASS / FAIL
**Finding:** [one sentence — specify which prong failed if FAIL]

#### 17. Mode coherence (with self-audit trail)
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

#### 18. Linear usability / sequence integrity (with self-audit trail)
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

## Items Requiring Fix

[List only FAIL items with what must be fixed. If no failures, state "No fixes required."]
```

## Output Protocol

**Default mode: Release.** Write the complete QC report in a single pass. The operator reviews the QC report alongside the architecture.

Write to the specified output path (default: `report/checkpoints/{section}-step-4.1b-architecture-qc.md`).

## Verdict Routing

- **Overall PASS (all criteria pass or only minor isolated failures):** Architecture is ready. Operator reviews and proceeds to chapter production.
- **Overall FAIL (any critical failure):** Architecture must be fixed before chapter production begins. List specific items to fix.

No auto-fix. All verdicts go to the operator. This skill does not modify the architecture.

## Stop Condition

Present results and stop. Do not fix the architecture, do not generate alternative structures, do not initiate chapter production.

## Evidence Integrity Rules

- Operate only from provided inputs. Do not supplement with external knowledge about what the architecture "should" contain.
- Cross-reference claims against actual input documents — do not assume scarcity items or editorial decisions from memory.
- If an input is missing (e.g., no scarcity register), mark the corresponding criterion as N/A rather than FAIL.
