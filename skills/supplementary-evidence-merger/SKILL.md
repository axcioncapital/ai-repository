---
name: supplementary-evidence-merger
description: >
  Merges QC-approved supplementary Perplexity research results into existing
  Research Extracts. Adds new claims with [SUPPLEMENTARY] tags, recalculates
  coverage verdicts, updates component syntheses, and maintains gap/conflict
  sections. Produces updated extracts that replace originals.

  Step 2.S4 in Stage 2 Subworkflow 2.S. Use when supplementary research QC
  (Step 2.S3) has produced MERGE/PARTIAL verdicts confirmed by the operator.
  Triggered by "merge supplementary evidence," "run step 2.S4," "update extracts
  with supplementary results," or similar.

  Do NOT use for initial extract creation (that's research-extract-creator at
  Step 2.3). Do NOT use for QC of supplementary results (that's
  supplementary-research-qc at Step 2.S3). Do NOT use for drafting queries
  (that's supplementary-query-brief-drafter at Step 2.S1).
---

# Supplementary Evidence Merger

Integrate QC-approved supplementary research results into existing Research Extracts. The updated extract is a complete, self-contained artifact that replaces the previous version — indistinguishable in structure from a single-pass extract, with `[SUPPLEMENTARY]` tags as the only markers of supplementary origin.

**Workflow position:** Step 2.S4 in Subworkflow 2.S. Receives MERGE/PARTIAL verdicts from Step 2.S3. Produces updated Research Extracts that replace originals in `/execution/research-extracts/`.

## Calibration

Do not overstate what supplementary evidence adds. If it moved a component from THIN to COVERED on the strength of two Medium sources, the synthesis should reflect moderate confidence, not strong confidence. Supplementary evidence fills gaps — it doesn't transform weak evidence bases into strong ones unless the evidence genuinely warrants it.

## Input

Three items, provided together:

1. **Research Extracts** — current versions for all affected questions
2. **QC-approved supplementary results** — the MERGE items from Step 2.S3 verdicts, with specific claims identified for merging
3. **Answer Specs** — for the affected questions (needed for coverage verdict recalculation)

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them
- Verify MERGE items reference valid query numbers from the QC report
- For PARTIAL items, verify the specific claims approved for merging are identified
- If mismatched: state the mismatch, request correction, do not proceed

## Merge Process

### Step 1: Add Supplementary Claims

For each MERGE item from the QC results:

- Create new claims under the appropriate Answer Spec component in the Research Extract.
- Assign Claim IDs that continue the existing sequence for that question (e.g., if the last existing claim is Q3-C08, new supplementary claims start at Q3-C09).
- For each new claim:
  - Write the claim statement in your own words (do not copy verbatim from Perplexity output)
  - **Sources:** carry over source name(s) and URL(s) from the Perplexity results
  - **Source locator:** "Supplementary research, Pass [1/2], Query [#]"
  - **Strength:** assign H/M/L per the standard rubric
  - **Independence:** count independent sources, including assessment of independence from sources already in the extract
  - **Notes:** include `[SUPPLEMENTARY]` tag. Add linkage type and caveats as normal.

For PARTIAL items from QC: merge only the specific claims approved. Skip the claims marked for exclusion.

### Step 2: Recalculate Coverage Verdicts

For each component that received new claims, recalculate the coverage verdict using the threshold rubric applied to the full claim set (original + supplementary):

- **COVERED:** >=2 claims with >=1 at High strength, OR >=3 claims at Medium strength with >=2 independent sources
- **THIN:** 1 claim at any strength, OR 2+ claims but all Low, OR only sources with shared editorial origin
- **MISSING:** No claims for this component

Update the Coverage Verdicts table. In the Notes column, indicate what changed: e.g., "THIN -> COVERED after supplementary pass 1 (added 2 Medium-strength claims from independent Nordic sources)."

### Step 3: Update Component Syntheses

For each component that received new claims, rewrite the Component Synthesis paragraph to reflect the combined evidence. The updated synthesis must:

- Integrate supplementary findings naturally — do not write a separate "supplementary findings" paragraph
- Accurately reflect the updated strength distribution across all claims (original + supplementary)
- Not overstate what the supplementary evidence adds

### Step 4: Update Gaps and Conflicts

- **Gaps:** remove or downgrade any gaps that were closed by supplementary evidence. If a gap moved from MISSING to THIN, update the gap entry to reflect remaining weakness rather than total absence.
- **Conflicts:** if supplementary evidence introduces a new source that conflicts with existing claims, add it to the Conflicts section with the standard format (both positions, relative support, recommended handling).

### Step 5: Update Extraction Metadata

Set `Supplementary research: Yes` and list which components were supplemented and in which pass.

## Output Format

Updated Research Extracts — one per affected question. Each is a complete, self-contained artifact that replaces the previous version. The only markers of supplementary evidence are:
- `[SUPPLEMENTARY]` tags on individual claims
- The metadata field noting supplementary research was performed

## Output Protocol

Write updated extracts to `/execution/research-extracts/`, replacing the originals. Provide a brief summary in chat: per question, which components changed verdict, claim count before/after, and any remaining THIN/MISSING components.

## Scope Boundaries

- Do not QC supplementary results — that's upstream (Step 2.S3)
- Do not draft queries or execute research — that's Steps 2.S1–2.S2
- Do not supplement evidence from training data or external knowledge
- Do not make editorial judgments about finding importance — integrate what QC approved
- Do not modify claims from the original extract — only add new supplementary claims and update syntheses/verdicts to reflect the combined evidence
