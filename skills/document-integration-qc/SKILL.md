---
name: document-integration-qc
description: >
  Runs a structured QC pass on one report module at a time, checking editorial
  quality. Produces a QC report per module with findings organized by check
  category — narrative structure, consistency, redundancy/contradiction, and
  completeness. Each finding includes location, description, severity
  (SUBSTANTIVE / NON-SUBSTANTIVE), and recommended fix. Drafts transition
  passages where needed. Use when Patrik provides a report module (prose) and
  says "run QC on this module," "document integration QC," "QC pass," or
  similar. Do NOT use for rewriting prose (evidence-prose-fixer), for
  evidence-level verification (evidence-spec-verifier), or for architectural
  review (chapter-architecture-annotator).
---

# document-integration-qc

Runs a QC pass on one report module at a time. Output is a **QC report** — not corrected prose. Transition passage drafts are the only full-prose output permitted.

## Inputs

| Input | Required | Notes |
|---|---|---|
| Current module prose | Yes | One module per run |
| Module identifier + position | Yes | e.g., "Module 3 of 6 — Market Dynamics" |
| Document architecture / glossary | Optional | Aids completeness checks |

If no module identifier is provided, ask for it before proceeding.

Apply only the document's own conventions as the baseline for consistency checks. Do not impose external style guide preferences unless a style guide is provided as input.

## Reasoning Constraints

- Flag issues only when clearly evidenced in the prose. Do not invent findings to appear thorough.
- Do not soften severity to avoid seeming critical. If the evidence supports SUBSTANTIVE, use it.
- If a section passes a check cleanly, state that explicitly — do not manufacture minor observations to fill a category.

## Check Categories

**Front-gate:** If the module contains fewer than ~100 words or has no discernible section structure, note this limitation at the top of the QC report and apply only the checks that remain meaningful. Completeness and basic Consistency checks still apply; Narrative Structure and Redundancy & Contradiction may not.

Run in this order.

### 1. Narrative Structure

- Does each major section end with an implication, not just a fact?
- Are transitions between sections adequate?
- **Action:** Draft transition passages (1–3 sentences) wherever transitions are weak or missing. Label these as `[TRANSITION DRAFT]`.
- For modules under ~300 words, skip the section-ending implication check and note: *"Module too short for section-arc analysis."*

### 2. Consistency

- Tone and register — within this module.
- Sentence structure and complexity — check for drift.
- Formatting conventions — heading levels, list styles, emphasis patterns consistent throughout.

### 3. Redundancy & Contradiction

- Same conclusion reached in multiple sections without cross-reference.
- Same statistic, date, or claim stated differently across sections.
- Same concept explained in multiple sections without acknowledgment.

### 4. Completeness

- Undefined terms or acronyms (check against glossary if provided; flag candidates if not).
- Scanability opportunities (headers, callouts, list conversion).
- Numbering, date format, and abbreviation consistency.

## Finding Format

Each finding uses this structure:

- **ID:** `[Category Abbreviation]-[N]` — e.g., `NS-1`, `CON-2`, `RC-1`, `COMP-3`
- **Location:** Section name or paragraph reference
- **Description:** What the issue is
- **Severity:** `SUBSTANTIVE` or `NON-SUBSTANTIVE`
- **Recommended Fix:** 1–3 sentences describing the fix. Do not rewrite the passage. If a finding cannot be adequately described without a full passage rewrite, flag it as `ESCALATE — requires prose-level fix` and route to `evidence-prose-fixer`.

## Severity Definitions

| Severity | Definition |
|---|---|
| SUBSTANTIVE | Affects reader comprehension, analytical accuracy, or report credibility. Must be resolved before integration. |
| NON-SUBSTANTIVE | Style, formatting, or polish. Recommended but not blocking. |

## Output Format

```
# QC Report — Module [N]: [Title]

## 1. Narrative Structure
[Finding ID] | Location | Description | Severity | Recommended Fix
...

## 2. Consistency
...

## 3. Redundancy & Contradiction
...

## 4. Completeness
...

## Transition Drafts
[TRANSITION DRAFT — Section X to Y]
[draft text]
```

## Output Protocol

Before producing the full QC report, present:
- A brief summary of the module's structure (sections identified)
- Which checks will apply (noting any front-gate limitations)
- Any clarifying questions that would materially change the assessment

Produce the full QC report only after user says `RELEASE ARTIFACT`.
