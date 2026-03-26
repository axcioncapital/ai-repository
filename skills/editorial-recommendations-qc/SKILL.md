---
name: editorial-recommendations-qc
description: >
  Independent QC of editorial decision recommendations produced by
  editorial-recommendations-generator. Derives its own recommendations from the
  evidence before reading the originals, then compares and scores each decision.
  Use after editorial recommendations have been generated and before the operator
  makes final editorial calls. Triggers on requests like "QC editorial
  recommendations," "review recommendations independently," "check editorial
  decisions," or when a memo-review-recommendations file is provided with
  expectation of independent verification. Do NOT use for generating the
  recommendations (that's editorial-recommendations-generator), for surfacing the
  decisions (that's analysis-pass-memo-review), for making final editorial calls
  (that's the operator), or for writing report prose.
---

# Editorial Recommendations QC

Independent quality check of editorial decision recommendations. This skill enforces QC independence: the reviewer derives its own recommendations from the evidence before seeing the originals, then compares. The output helps the operator identify where recommendations are well-grounded versus where reasonable disagreement exists.

## Pipeline Position

```
editorial-recommendations-generator → [this skill] → operator decision
```

This is a verification step, not a tiebreaker. DISAGREE verdicts flag decisions the operator should examine more carefully, not override instructions.

## Input Requirements

All inputs required:

1. **Memo review** — editorial decisions from `analysis-pass-memo-review` (the questions)
2. **Memo review recommendations** — recommended answers from `editorial-recommendations-generator` (the artifact being QC'd)
3. **Refined cluster memos** — all cluster analytical memos
4. **Scarcity register** — confirmed evidence scarcity items (if exists)
5. **Section directives** — from `section-directive-drafter`

Optional but recommended:
6. **analysis-pass-memo-review SKILL.md** — so the QC understands what the decisions are supposed to achieve and what the five categories mean

### Validation

Before proceeding, verify:

- Memo review and recommendations reference the same set of decision IDs
- Decision count matches between the two documents
- Cluster memos contain Evidence Strength Maps

**Hard stop conditions:**
- Recommendations file missing → Refuse. Nothing to QC.
- Decision IDs don't match between memo review and recommendations → Flag mismatch, list orphaned IDs, ask user to resolve.

## Procedure

**Critical sequencing rule:** For each decision, the reviewer MUST form an independent recommendation from the evidence BEFORE reading the original recommendation. This prevents anchoring bias. The procedure enforces this by structuring the work in two passes.

### Pass 1 — Independent Derivation

Read the memo review (decisions only — not the recommendations file). For each decision:

1. Identify which cluster memo(s) and evidence items are relevant
2. Read the relevant evidence in the cluster memos
3. Form an independent recommendation based on:
   - Evidence strength labels and source counts
   - Cross-question convergence patterns
   - Scarcity register context (for GH decisions)
   - Directive treatment levels (for EW decisions)
   - Evidence weight behind competing framings (for FP decisions)
4. Record the independent recommendation in a working list

**Per-category guidance:**

- **CC decisions:** Check the Evidence Strength Map. Is the grade calibrated to the evidence basis? Would cross-question convergence justify upgrading, or does thin underlying evidence warrant caution?
- **GH decisions:** For scarcity items, apply the decision logic: Is proxy data available? Is the finding central or peripheral? Is it an analytical construct or an empirical gap? For non-scarcity gaps: acknowledge, scope-bound, or route back?
- **FP decisions:** Weigh the evidence behind each framing. Which has stronger sourcing? Which better serves the analytical argument (not the service pitch)?
- **EW decisions:** Does the current treatment level match the evidence grade and the finding's analytical significance? Is there a mismatch between evidence strength and directive emphasis?
- **TR decisions:** What does the evidence split look like? Does the memo's own recommendation follow the evidence weight?
- **XC decisions:** Does the cross-cluster pattern warrant unified treatment, or is distributed handling more appropriate given section-level differences?

### Pass 2 — Comparison and Scoring

Now read the recommendations file. For each decision, compare the original recommendation against the independent derivation:

**AGREE** — Same directional recommendation. The original is well-grounded in evidence.

**NUANCE** — Same direction, but the QC reviewer would adjust something: scope, strength of the recommendation, rationale framing, or a conditional the original missed. The original is not wrong, but could be sharpened.

**DISAGREE** — Different recommendation. The QC reviewer's independent derivation points in a materially different direction. The original may be poorly grounded, may prioritize narrative convenience over evidence, or may miss a relevant factor.

For each verdict, record:
- The original recommendation (1-line summary)
- The independent recommendation (1-line summary)
- The verdict
- Reasoning: 1 sentence for AGREE, 2-3 sentences for NUANCE or DISAGREE

### Pass 3 — Self-Calibration Check

After scoring all decisions, review the distribution:

- If >80% AGREE: explicitly check whether you are pattern-matching rather than independently evaluating. Re-examine the 2-3 decisions with the most ambiguous evidence to confirm AGREE verdicts are earned.
- If >40% DISAGREE: check whether you are applying a systematically different interpretive framework. State the interpretive difference if one exists.
- If all NUANCE items share a common theme (e.g., "I'd hedge more" or "I'd be more assertive"), note the pattern — it may reflect a calibration difference rather than per-decision issues.

## Output Format

```markdown
# QC Report: Editorial Decision Recommendations

**Date:** [date]
**Section:** [section ID]
**Artifact QC'd:** [path to recommendations file]
**QC method:** Independent derivation before comparison

## Summary

- Decisions reviewed: [n]
- AGREE: [n] | DISAGREE: [n] | NUANCE: [n]
- Overall assessment: [1-2 sentences on recommendation quality and any systematic patterns]

## Per-Decision Review

### CC-[n] — [Short label]
**Original recommendation:** [1-line summary]
**My independent recommendation:** [1-line summary]
**Verdict:** AGREE / DISAGREE / NUANCE
**Reasoning:** [1 sentence if AGREE; 2-3 sentences if DISAGREE or NUANCE]

[...repeat for all decisions, organized by category...]

## Flagged Disagreements

[List only DISAGREE items with full reasoning for why the original recommendation is poorly grounded or risky. Include the evidence basis for the QC reviewer's alternative. If no DISAGREE items, state "No disagreements flagged."]

## Self-Calibration Note

[Report on the distribution check from Pass 3. Note any systematic patterns in NUANCE items.]
```

## Output Protocol

**Default mode: Release.** Write the complete QC report in a single pass. No refinement mode — the operator reviews the QC report alongside the recommendations.

Write to the specified output path (default: `analysis/{section}-qc-editorial-decisions.md`).

## Verdict Routing

The QC report does not route or auto-fix. The operator uses it as follows:

- **All AGREE:** Recommendations are well-grounded. Operator can accept the batch with confidence.
- **Some NUANCE:** Operator reviews nuance items and decides whether adjustments are warranted. Most nuance items are refinements, not corrections.
- **Any DISAGREE:** Operator must review flagged disagreements and make an explicit call. The QC report presents both positions with evidence; the operator decides.

No autonomy rules apply — all verdicts go to the operator. This skill does not auto-proceed on any outcome.

## Quality Guardrails

- A good QC pass has some disagreements. If you agree with everything, the self-calibration check in Pass 3 must explicitly confirm this is genuine agreement, not anchoring.
- Every DISAGREE and NUANCE verdict must cite specific evidence from the cluster memos. "I would have recommended differently" without evidence citation is not a valid QC finding.
- Do not evaluate recommendations based on whether they are strategically useful for the service model. Evaluate based on whether they follow the evidence.
- Do not introduce new decisions not present in the memo review. The QC scope is the existing decision set only.
- If the recommendations file contains confidence flags (LOW CONFIDENCE, ASSUMPTION-DEPENDENT), give those decisions extra scrutiny — they are self-identified weak points.

## Evidence Integrity Rules

- Operate only from provided cluster memos, scarcity register, and directives. Do not supplement with external knowledge.
- Preserve evidence strength labels exactly as they appear in cluster memos.
- The QC reviewer's independent recommendations must meet the same evidence-grounding standard as the originals — no "sounds reasonable" reasoning.
- If the evidence genuinely supports both the original and the QC reviewer's alternative, verdict is NUANCE (not DISAGREE). DISAGREE is reserved for cases where the evidence materially favors one position.
