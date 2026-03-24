---
name: research-extract-verifier
description: >
  Adversarial verification of Research Extracts against raw Deep Research reports.
  Identifies extraction failures — missed claims, distorted claims, wrong strength
  assignments, unjustified coverage verdicts, and synthesis-evidence mismatches.
  Produces per-extract verdicts (APPROVED / FLAG — RE-EXTRACT) with specific
  re-extraction instructions routing back to Step 2.3.

  Step 2.4 in Stage 2. Use when Patrik provides a raw Deep Research report, the Research
  Extracts produced from it, and the corresponding Answer Specs, and asks to "verify
  extracts," "QC the extracts," "check extraction quality," "run extract verification,"
  "run step 2.4," "run 2.4," or similar requests to validate extraction accuracy before
  downstream processing.

  Do NOT use for fixing extracts (this skill flags and routes only — fixing happens at
  Step 2.3 via research-extract-creator). Do NOT use for source citation verification
  against URLs (that's Stage 5 fact verification). Do NOT use for evaluating whether
  research questions are well-formed (that's upstream). Do NOT use for editorial
  judgments about which findings matter most (that's cluster-analysis-pass). Do NOT use
  for supplementing evidence from training data or external knowledge.
---

# Research Extract Verifier

Verify Research Extracts against the raw Deep Research reports they were extracted from. Identify extraction failures and produce per-extract verdicts with re-extraction instructions. This skill verifies — it does not fix.

**Workflow position:** Step 2.4 in Stage 2. Receives extracts from Step 2.3. APPROVED extracts flow downstream. Flagged extracts route back to Step 2.3.

## Calibration

Do not invent issues. If the extract accurately reflects the report, say so. Do not inflate severity to appear thorough — an APPROVED verdict on a clean extract is the correct outcome. If evidence for a finding is ambiguous, mark it as uncertain rather than asserting a failure.

## Input

Three items per session, provided together:

1. **Raw Deep Research report** — source material for one session (2-4 questions)
2. **Research Extracts** — produced from that report at Step 2.3, one per question
3. **Answer Specs** — for the questions covered in this session

### Input Validation

Before proceeding:
- If fewer than three input items are provided, state which are missing and request them. Do not begin verification with incomplete inputs.
- Verify extract session letters match the raw report
- Verify Answer Spec question IDs match extract question IDs
- If the raw report covers questions for which no extract was provided, note the missing extracts by question ID and flag as requiring extraction at Step 2.3
- If mismatched: state the mismatch, request correction, do not proceed

## Verification Checks

Run five checks per extract, in order.

### Check 1 — Missed Claims

Read the raw report section by section. For each Answer Spec component, identify substantive claims (factual assertions with source attribution addressing a component) not captured in the extract. Ignore transitional sentences, framing language, and restatements.

Per missed claim, state:
- The claim and its report location (section heading + position)
- Which Answer Spec component it maps to
- Whether including it would change the coverage verdict for that component

### Check 2 — Distorted Claims

For each claim in the extract, compare against the corresponding report content using the Source Locator field.

Flag distortions where meaning shifted. Common patterns:
- Hedged to definitive
- Associational to causal
- Scoped findings generalized beyond scope
- Multiple findings collapsed, losing nuance
- Quantitative figures or ranges altered

Per distortion: state what the report says, what the extract says, how they differ.

### Check 3 — Strength Signal Verification

Assess whether each claim's H/M/L strength assignment matches its evidence basis:

- **H (High):** Multiple independent credible sources; primary/institutional data; direct evidence
- **M (Medium):** Single credible source or multiple with shared editorial origin; indirect but reasonable evidence
- **L (Low):** Single source of uncertain quality; inferential; tangential; vendor/advocacy without corroboration

Flag mismatches. State current assignment, evidence basis visible in the report, and correct assignment. Also flag independence counts that appear wrong (e.g., shared primary data counted as independent). If the raw report provides insufficient source metadata to assess strength, mark the claim as unverifiable for Check 3 and note in the issue table.

### Check 4 — Coverage Verdict Verification

Verify each component's coverage verdict against thresholds:

- **COVERED:** >=2 claims with >=1 at High, OR >=3 claims at Medium with >=2 independent sources
- **THIN:** 1 claim at any strength, OR 2+ claims all Low, OR only shared-editorial-origin sources
- **MISSING:** No claims for this component

Check both directions:
- **Too generous:** marked COVERED but doesn't meet threshold
- **Too conservative:** marked THIN/MISSING but claims meet COVERED — especially after accounting for missed claims from Check 1

### Check 5 — Component Synthesis Accuracy

For each Component Synthesis paragraph, verify it reflects the listed claims:
- Does it overstate evidence strength?
- Does it introduce unsupported framing?
- Does it omit a key finding the claims support?
- Is it consistent with the coverage verdict?

## Verdict Logic

**APPROVED** — No issues, or only trivial issues not affecting downstream quality (e.g., minor synthesis wording that doesn't change meaning).

**FLAG — RE-EXTRACT** — One or more issues affecting downstream quality. Any single threshold triggers FLAG:
- Any missed claim that would change a coverage verdict
- Any distortion changing the meaning of a claim used in a Component Synthesis
- Any strength assignment off by more than one level (e.g., L when H is justified)
- Any coverage verdict not meeting the threshold rubric
- >=2 minor issues on the same extract (individually non-blocking but collectively indicating systematic quality problems)

### Borderline Cases

When a finding is uncertain (e.g., unclear if a report claim is substantive or transitional, unclear if two sources share editorial origin):
- Mark with "?" in the issue table
- State the uncertainty in the Impact column
- Do not let uncertain findings alone trigger FLAG — only flag if the uncertain finding, if real, would cross a threshold

## Re-extraction Instructions

Every FLAG verdict must include instructions specific enough for `research-extract-creator` to act without reading the full QC report. Each instruction identifies:
- Which claim or component is affected
- What went wrong (missed, distorted, mis-graded, verdict wrong)
- What correct extraction looks like

Good: "Q3-C04 distorts the source — report says 'primarily in large-cap contexts' but extract generalizes to all PE. Re-extract with scope qualifier preserved."

Bad: "Check Q3 again."

When multiple checks flag issues on the same component, consolidate into a single re-extraction instruction that addresses all issues together. If issues span >=3 checks on one extract, recommend full re-extraction of that extract rather than per-issue patching.

## Output Format

Per Research Extract:

```
## [Question ID] — [Question Short Title]

**Verdict: APPROVED / FLAG — RE-EXTRACT**

### Issues found (if any):

| Check | Issue | Location | Impact | Re-extraction instruction |
|-------|-------|----------|--------|--------------------------|
| [1-5] | [Description] | [Component + Claim ID or report section] | [What it affects downstream] | [Specific instruction for re-extraction] |

### Checks passed:
[List which of the 5 checks passed clean]
```

After all extracts:

```
## Session Summary

- Extracts reviewed: [count]
- APPROVED: [count] — [list Question IDs]
- FLAG — RE-EXTRACT: [count] — [list Question IDs]

Re-extraction priority: [order flagged extracts by severity — most downstream impact first]
```

## Output Protocol

Write the verification report to a markdown file in the project's working directory. Use the naming convention `extract-verification-{session-letter}.md`. Provide a brief summary in chat with the verdict for each extract and the file path.

## Failure Behavior

- **Report too short/vague to verify against:** State this, produce best-effort verification on what's verifiable, note which checks couldn't run and why.
- **Extract references content not in the provided report:** Flag as potential hallucination. Automatic FLAG regardless of other checks.
- **Source Locator missing or too vague:** Flag claim as unverifiable for Check 2. If >50% of claims in an extract have unverifiable source locators, flag the entire extract for re-extraction with a note to improve locator specificity.

## Scope Boundaries

- Do not fix extraction errors — flag and route only
- Do not supplement evidence from training data or external knowledge
- Do not make editorial judgments about finding importance
