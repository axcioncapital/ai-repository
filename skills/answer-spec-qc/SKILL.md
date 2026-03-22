---
name: answer-spec-qc
description: Full quality review of Answer Specs before they enter execution as the binding research contract. Produces per-spec verdicts (APPROVED / REVISE / ESCALATE) with routing instructions. Use when Patrik provides Answer Specs alongside a Task Plan and Research Plan and asks to QC, verify, review, check, or validate the specs. Triggers on requests like "QC these answer specs," "check specs before execution," "verify answer specs," "run spec QC," or when Answer Specs are provided with expectation of quality review before Stage 2. Do NOT use for evidence pack verification (that's evidence-spec-verifier), for gap assessment across clusters (that's gap-assessment-gate), for generating or regenerating Answer Specs (that's answer-spec-generator), or for fixing specs — this skill flags problems and routes, it does not remediate.
---

# Answer Spec QC

Last checkpoint before Answer Specs become the binding research contract. Errors caught here are cheap; errors caught after execution require re-research.

**Position:** Step 1.8 — between `answer-spec-generator` (Step 1.7) and Stage 2 execution.

## Inputs

All three required. Pasted as markdown.

1. **Answer Specs** — one or more, from `answer-spec-generator`
2. **Task Plan** — upstream objective, scope, success criteria
3. **Research Plan** — research questions with scope, depth, tool assignments, completion criteria

Task Plan and Research Plan enable upstream alignment checks. Without them, only internal consistency is verifiable — which misses the highest-value failure mode (well-formed spec answering the wrong question).

**Freshness rule:** Inputs must be loaded directly, not carried over from a generation conversation. If the user appears to be continuing from answer-spec-generator output, flag: "These inputs should be loaded fresh to avoid context drift from generation. Please confirm these are clean copies."

**Missing input protocol:** If any required input is absent, state which input is missing, explain what checks are blocked without it, and ask the user to provide it before proceeding. If the user explicitly requests a partial review, run only Dimension 1 (Internal Consistency) and label the report as "Partial QC — upstream alignment and executability checks not performed."

**SOP dependency:** Dimension 1 and 3 reference the Research Executor SOP (§8 grading criteria, §11 source type enumeration). If the SOP is not available in context, flag affected checks as "SOP reference unavailable — check not performed" rather than guessing at SOP content.

## Input Validation

Before running check dimensions, verify:

1. Each Answer Spec contains identifiable components (Q[n]-A## format) and completion gates
2. Task Plan has a discernible objective and scope boundary
3. Research Plan contains questions matchable to each provided spec
4. **Orphan detection:** Flag any Research Plan question that has no corresponding Answer Spec. This is a batch-level finding reported in the Batch Summary, not a per-spec check.
5. If a spec lacks quantified completion gates entirely: flag as upstream spec issue — "Answer Spec for Q[n] has no measurable completion gates. Cannot verify executability without thresholds. Recommend returning to Step 1.7." Do not run Dimension 3 on that spec.
6. If the Task Plan objective is too broad or vague to meaningfully test contribution: flag as a meta-finding — "Task Plan objective is too broad to apply the contribution test with confidence. Dimension 2 results for this batch have reduced diagnostic value."
7. **Partial batches:** If the user indicates specs are a partial batch, defer orphan detection and coverage completeness checks. Note in the Batch Summary that these batch-level checks are pending remaining specs. Per-spec checks (all three dimensions) still run normally.

## Check Dimensions

Run all three dimensions per spec, in order. Findings accumulate across dimensions before verdict assignment.

### Dimension 1: Internal Consistency

Does the spec cohere as a standalone document?

| Check | What to look for |
|-------|-----------------|
| Gate integrity | Gates reference actual components by ID. No phantom references (gate mentions Q[n]-A## that doesn't exist in the spec). |
| Field completeness | All required fields populated with real content. Flag any TBD, placeholder, "[to be determined]", or empty fields. |
| Evidence rule coherence | Component-specific evidence rules don't contradict the preamble default rule. Rules don't duplicate SOP §8 grading criteria verbatim (redundancy creates interpretation conflicts). |
| Component ID formatting | IDs follow Q[n]-A## format. Descriptions present for each component. If IDs use a recognizable variant (e.g., Q1-A1, Q1.A01), map to expected format for QC purposes and note the deviation as a Minor finding. If the format is unrecognizable, flag as Moderate — executor may misparse. |
| Component cap compliance | Hybrid questions: ≤7 components for light/standard strictness, ≤9 for strict. Single-type questions: flag if component count seems excessive for the question's complexity. |
| Timeframe presence | If question is time-sensitive (contains temporal cues: "current," "recent," "trends," date references), spec includes a defined timeframe or temporal boundary. |
| Priority consistency | Components marked Required/Optional align with the question's core ask — Required components should map to the question's essential dimensions. |

### Dimension 2: Upstream Alignment

Does the spec serve the right purpose?

**Task Plan contribution test** (highest-value check): "If this spec were perfectly executed, would the resulting evidence contribute to the Task Plan objective?" Apply by:
1. Identifying the Task Plan's stated objective
2. Tracing the spec's components to a plausible contribution path
3. If no credible path exists → Critical finding

**Research Plan fidelity:**
- **Scope preservation:** Narrowing from Research Plan scope is acceptable if flagged in the spec. Widening is a finding (Moderate).
- **Intent preservation:** Components must actually answer the question asked. A spec that drifts to an adjacent-but-different question is a finding (Critical — wrong question).
- **Depth match:** Spec strictness should align with Research Plan depth indicators. Mismatches are a finding (Moderate).
- **Completion criteria translation:** Research Plan completion criteria should be faithfully translated into measurable gates. Weakened or dropped criteria are a finding (Moderate).

**Coverage completeness** (batch-level): Specs collectively cover all Research Plan questions assigned to the relevant tool. Missing coverage flagged under orphan detection in Input Validation.

### Dimension 3: Executability

Can the Research Executor actually do this?

| Check | What to look for |
|-------|-----------------|
| Gate measurability | Every completion gate resolves to pass/fail mechanically. Flag subjective gates: "sufficient," "adequate," "comprehensive," "good coverage." Each gate must express a countable threshold. |
| Scope actionability | Scope and timeframe are specific enough for the executor to generate search queries. Flag scope statements too abstract to operationalize. |
| Source threshold realism | Source requirements (e.g., "≥5 independent sources") are realistic for web-accessible sources on the topic. **Flag concerns with reasoning — do not auto-fail.** This is topic-dependent; Patrik decides. |
| Evidence rule clarity | Rules are unambiguous and use SOP §11 source type enumeration where applicable. Flag rules that leave classification judgment to the executor. |
| Cross-question dependencies | If evidence rules reference other questions' outputs, flag execution order requirements. |

## Finding Severity

| Severity | Definition | Verdict impact |
|----------|-----------|----------------|
| **Critical** | Executor failure guaranteed, or spec targets wrong objective. | → Requires root-cause analysis (see Verdict Assignment) |
| **Moderate** | Ambiguous, partially unexecutable, or misaligned — but fixable at spec level. | → REVISE |
| **Minor** | Formatting, style, or marginal concerns. | Noted. Does not block APPROVED. |

## Verdict Assignment

Assign after all three dimensions complete for a spec.

### APPROVED

No Critical or Moderate findings. Ready for Stage 2 execution.

### REVISE

One or more Moderate findings, or Critical findings whose root cause is within the spec itself. Fixable at spec level. Route to Step 1.7 (answer-spec-generator) with specific revision notes per finding. Critical-rooted REVISE findings should be marked as priority fixes.

### ESCALATE

One or more Critical findings where root-cause analysis determines the cause is upstream of the spec. Includes root-cause depth:

- **Question-level** → return to Step 1.5 (revise Research Plan question)
- **Scope-level** → return to Step 1.2 (narrow Task Plan scope)

**Root-cause analysis for Critical findings:** For each Critical finding, determine where the root cause lives: (a) if the spec itself could be rewritten to fix the problem (e.g., components don't match the question due to a generator error) → REVISE with Critical-priority fix note; (b) if the problem traces to a flawed Research Plan question or Task Plan scope → ESCALATE with depth tag.

**Critical design principle:** ESCALATE ≠ severity upgrade of REVISE. A spec with 5 Moderate findings is REVISE (fix the spec). A spec with 1 Critical finding tracing to a flawed Research Plan question is ESCALATE (fix the question). The distinction is *where the root cause lives*, not how many findings exist.

**Mixed verdicts:** If a spec has both spec-level findings (Moderate or Critical-rooted-in-spec) and upstream-rooted Critical findings, verdict is ESCALATE. The spec-level findings are noted but the upstream fix takes priority — spec-level fixes are pointless if the question itself is flawed.

## Output Format

### Batch Summary

```
# Answer Spec QC Report

**Specs reviewed:** [list Q IDs]
**Results:** [n] APPROVED / [n] REVISE / [n] ESCALATE
**Routing:** [n] ready for execution / [n] return to Step 1.7 / [n] return upstream

**Input validation notes:**
- [Orphan questions, meta-findings, or "None"]

**Stop condition:** QC complete. Results presented. No specs fixed or regenerated.
```

### Per-Spec Verdict Block

```
## Q[n] — [Verdict: APPROVED / REVISE / ESCALATE]

**Strictness:** [as stated in spec]
**Question type:** [as classified in spec]
**Components:** [count] ([count] Required / [count] Optional)

### Dimension 1: Internal Consistency
- [Finding severity] — [Description]
- (or "No findings.")

### Dimension 2: Upstream Alignment
- [Finding severity] — [Description]
- (or "No findings.")

### Dimension 3: Executability
- [Finding severity] — [Description]
- (or "No findings.")

### Verdict Rationale
[1–2 sentences explaining the verdict and primary driver]
```

### Routing Summaries

Grouped at end of report.

**REVISE specs:**
```
### Revision Notes: Q[n] → Step 1.7

**Findings requiring revision:**
1. [Finding] — [Specific fix instruction: what to change, not just what's wrong]
2. ...

**Unchanged elements:** [What's fine and should be preserved]
```

**ESCALATE specs:**
```
### Escalation Notes: Q[n] → Step [1.5 or 1.2]

**Root cause:** [What's wrong upstream]
**Root-cause depth:** [Question-level / Scope-level]
**Upstream target:** Step [1.5 / 1.2]
**What needs to change:** [Specific upstream fix before spec can be revised]
```

Deliver all verdict blocks in a single document. Batch summary at top, per-spec blocks in question order, routing summaries grouped at end.

## Output Protocol

Default to refinement mode: present (1) Batch Summary table with verdicts, (2) one-line verdict + primary finding per spec, (3) any input validation flags. Full per-spec dimension breakdowns and routing summaries only after user says `RELEASE ARTIFACT`. Final output is written to a file, not pasted in chat.

## Stop Condition

Present results and stop. Do not fix specs, regenerate specs, or initiate downstream work. If all specs are APPROVED, state readiness for Stage 2 execution. If any are REVISE or ESCALATE, state routing targets and reference the routing summaries.

## Integrity Rules

- Operate only from provided Answer Specs, Task Plan, and Research Plan. Do not supplement with knowledge about what specs "should" contain.
- Do not soften ESCALATE to REVISE to avoid upstream rework. If the root cause is upstream, it's upstream.
- Do not soften REVISE to APPROVED to avoid iteration. If a gate is unmeasurable, it's unmeasurable.
- If a finding's classification is genuinely ambiguous, present both interpretations and let the user decide.
- If provided inputs are insufficient to verify confidently (malformed spec, missing Task Plan sections), say so and identify what's missing rather than guessing.
- Source achievability concerns are flagged with reasoning for user decision — not auto-failed. The skill does not have enough topic context to make this call unilaterally.
- Accuracy over comprehensiveness — catching 3 real Critical/Moderate findings matters more than an exhaustive register of Minor formatting concerns.
