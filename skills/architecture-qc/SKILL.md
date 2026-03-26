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

7. **All 6 specification components present:** Section hierarchy, depth allocation, cross-reference map, front/back matter decisions, traceability table, structural override log
8. **Traceability coverage:** Every content segment from the original chapters appears in the traceability table with an action and seam note where required
9. **H3 headings:** Are proposed H3 subdivisions logical and do they cover all content within each H2?
10. **Processing order:** Is the stated processing order consistent with the dependency map?

### C. Project-Specific Compliance

11. **Scarcity register coverage:** Does the architecture account for every item in the scarcity register? Cross-check each scarcity item ID against the architecture's traceability table or writer compliance checklist.
12. **Editorial recommendations honored:** Does the writer compliance checklist or traceability table reference the key editorial decisions from the approved recommendations? Check that each decision category (CC, FP, EW, GH, TR, XC) with approved recommendations appears.
13. **Section directives alignment:** Do the word count targets in the architecture match the word count ranges from the section directives? Compare each section's allocation against the directive's specified range.
14. **Style reference lock:** Does the architecture specify when the style reference locks and how subsequent chapters use it?

## Procedure

For each criterion (1–14):

1. Read the relevant section of the architecture
2. Cross-reference against the appropriate input (chapter drafts for traceability, scarcity register for criterion 11, editorial recommendations for criterion 12, section directives for criterion 13)
3. Assign a verdict: **PASS** or **FAIL**
4. Record a one-sentence finding. If FAIL, state what is missing or wrong.

After all 14 criteria are evaluated, determine the overall verdict.

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

- Criteria evaluated: 14
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

#### 7. All 6 specification components present
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

[...repeat for criteria 8–10...]

### C. Project-Specific Compliance

#### 11. Scarcity register coverage
**Verdict:** PASS / FAIL
**Finding:** [one sentence]

[...repeat for criteria 12–14...]

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
