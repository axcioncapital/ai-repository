---
name: evidence-spec-verifier
description: >
  Verifies completed Evidence Packs v1 against their originating Answer Specs for structural
  compliance. Checks component coverage, completion gate compliance, source independence, conflict
  identification, and gap documentation. Produces per-question verdicts (Pass / Conditional Pass /
  Fail) with re-research briefs for failures. Use when Patrik provides Evidence Pack(s) and Answer
  Specs and asks to verify, QC, check compliance, or run evidence-spec verification. Do NOT use for
  assessing research question coverage (gap-assessment-gate), evaluating evidence quality beyond
  structural rules, rewriting Evidence Packs, or any downstream synthesis work.
---

# Evidence-Spec Verifier

Verify Evidence Packs v1 against Answer Specs. Determine whether the executor delivered what the spec contractually required. Produce per-question verdicts with actionable routing.

## Inputs

1. **Evidence Pack(s) v1** (required) — one per question, each containing Evidence Table, Source Access Log, Coverage Tracker, Conflict Register, Known Gaps sections
2. **Answer Specs** (required) — one per Evidence Pack, containing components (Q-A##), evidence rules, and completion gates

**Freshness rule:** Inputs must be loaded directly, not carried over from execution context. If the user appears to be continuing an execution conversation, flag: "These inputs should be loaded fresh to avoid context drift from execution. Please confirm these are clean copies."

## Input Validation

Before running checks, verify:

- Each Evidence Pack has a corresponding Answer Spec (matched by Question ID)
- Each Answer Spec contains identifiable components and completion gates
- If an Answer Spec lacks quantified gates: flag as upstream spec issue — "Answer Spec for Q[n] has no measurable completion gates. Cannot verify compliance without thresholds. Recommend fixing the spec before QC." Do not proceed on that question.

**Structural expectations:** Evidence Packs must contain: Evidence Table, Source Access Log, Coverage Tracker (using ✓/⚠/✗/◯ status symbols), Conflict Register, Known Gaps. If sections use non-standard naming or status symbols, map to expected equivalents where unambiguous. If mapping is unclear, flag the specific discrepancy and ask before proceeding.

## Verification Checks

Run all five checks per question, in order.

### Check 1: Component Coverage

For each component (Q-A##) in the Answer Spec, read the Coverage Tracker status column.

Status symbols: ✓ = covered, ⚠ = partial, ✗ = missing, ◯ = not attempted.

**Finding rule:** Any REQUIRED component not showing ✓ is a finding. OPTIONAL components showing ⚠/✗/◯ are noted but do not trigger failure.

### Check 2: Completion Gate Compliance

Compare Coverage Tracker numeric counts against each gate's quantified thresholds.

Per gate:
1. Identify the metric (distinct claims, independent sources, grade distribution, dimensions covered)
2. Read the actual count from the Coverage Tracker
3. Binary comparison: met or not met

No interpretation. If the gate says "≥3 independent sources" and the tracker shows 2, it fails. Do not round, estimate, or give benefit of the doubt.

### Check 3: Independence Audit

Audit **all** sources counted as independent in the Coverage Tracker — full audit, not a spot-check.

Per source pair within a component, apply three independence tests:

1. **Same publisher/org?** → not independent
2. **Republish/syndication/pickup?** → not independent
3. **Same dataset, no new primary evidence?** → not independent

Cross-reference against Independence Notes in the Evidence Table's Notes column.

**Flag:**
- Sources counted as independent that fail any test above
- Missing Independence Notes where ≥2 sources support the same claim
- If reclassifying any source changes whether a completion gate is met → escalate to a gate compliance failure (Check 2)

**Blocked check:** If source metadata is insufficient to apply independence tests (missing publisher/organization), flag: "Independence audit blocked — Evidence Table lacks publisher/organization metadata for [source IDs]. Cannot verify independence. Treat affected sources as unverified for gate compliance." This does not automatically fail the gate but prevents a false Pass.

### Check 4: Conflict Register Review

Scan the Evidence Table for potential cross-source disagreements on numbers, dates, thresholds, definitions, or rankings within in-scope claims.

**Flag:**
- Contradictory claims in the Evidence Table with no corresponding Conflict Register entry
- Conflict Register entries without clear assessment or resolution approach
- Empty Conflict Register when Evidence Table contains claims from ≥3 independent sources on the same component (conflicts become statistically likely)

**Not a finding:** Empty Conflict Register with thin evidence (1–2 sources per component) — nothing to conflict with.

**Blocked check:** If source attribution is too thin to detect cross-source disagreements (claims without clear source tagging), flag: "Conflict detection blocked — insufficient source attribution for [component]. Cannot verify absence of conflicts."

### Check 5: Known Gaps Review

For each component where Coverage Tracker shows ⚠ or ✗:

- Verify a corresponding Known Gaps entry exists
- Check that it includes: what's missing, why, scarcity classification (if thin-results), queries attempted

**Flag:**
- Coverage Tracker shows ⚠/✗ but Known Gaps section is empty or doesn't address that component
- Known Gaps entries without scarcity classification when <2 sources were found
- Known Gaps entries that describe the gap but offer no next-best sources or search angles

## Verdict Categories

### Pass

All REQUIRED components ✓. All completion gates numerically met. No unresolved conflicts missing from the register. Independence holds under full audit.

### Conditional Pass

All REQUIRED components ✓ and all gates met, **but** one or more of:
- Genuinely ambiguous independence classification on a source pair (not clearly independent or dependent)
- Unresolved conflict that doesn't affect a REQUIRED component's core claim
- OPTIONAL component gaps

**Boundary rule:** If removing any ambiguously-classified source would cause a gate to fail → verdict is **Fail**, not Conditional Pass.

### Fail

Any of:
- REQUIRED component showing ✗ or ◯
- Any completion gate numerically unmet
- Independence audit reveals a gate is actually unmet after reclassification
- Known Gaps section missing for a component with ⚠/✗ status

## Output Format

### Batch Summary (top of document)

```
# Evidence-Spec Verification Report

**Questions verified:** [list Q IDs]
**Results:** [n] Pass / [n] Conditional Pass / [n] Fail
**Routing:** [n] ready for downstream / [n] require re-research

**Stop condition:** Verification complete. Results presented. No downstream synthesis initiated.
```

### Per-Question Verdict Block

```
### Q[n] — [Verdict: Pass / Conditional Pass / Fail]

**Component Status:**
- Q[n]-A01 [Component name]: ✓ / ⚠ / ✗ — [one-line status]
- Q[n]-A02 [Component name]: ✓ / ⚠ / ✗ — [one-line status]
- ...

**Gate Compliance:**
- [Gate description]: [actual] vs. [required] — Met / Not Met
- ...

**Issues Found:**
- [Severity: Critical / Moderate / Minor] — [Description]
- ...
(or "None" if clean)
```

### Re-Research Brief (Fail verdicts only)

```
### Re-Research Brief: Q[n]

**Failed gates:**
- [Gate]: [what's missing, quantified]

**Components needing additional evidence:**
- Q[n]-A[##]: [what specifically is needed — not "more sources" but "1 additional independent source supporting [specific claim dimension]"]

**Suggested search angles:**
- [Derived from Known Gaps analysis and failed component needs]
- [Up to 3 specific angles]

**Estimated scope:** [Targeted — 1–2 additional searches / Moderate — new search plan for this component / Substantial — component needs near-complete re-execution]
```

Deliver all question verdicts in a single document. Batch summary at top, per-question blocks in question order, re-research briefs grouped at the end.

## Output Protocol

Default to refinement mode: present the batch summary structure, initial findings per question, and any input validation issues first. Produce the full verification report only after user confirms. Write the final report to a file, not inline in chat. Provide a brief summary of what was produced.

## Stop Condition

Present results and stop. Do not proceed to synthesis, compression, or any downstream work. If all pass, state readiness for next stage. If any fail, state which questions need re-research and reference the briefs.

## Integrity Rules

- Operate only from provided Evidence Packs and Answer Specs. Do not supplement with knowledge about what evidence "should" exist.
- Do not soften a Fail to Conditional Pass to avoid triggering re-research. If a gate is unmet, it's unmet.
- If a check result is genuinely ambiguous, present both interpretations and let the user decide.
- If provided inputs are insufficient to verify confidently (malformed Evidence Pack, missing Coverage Tracker), say so and identify what's missing rather than guessing.
- Accuracy over comprehensiveness — catching 3 real gate failures matters more than an exhaustive register of marginal formatting concerns.
