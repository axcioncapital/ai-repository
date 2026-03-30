---
name: cluster-memo-refiner
description: >
  Refines cluster analytical memos produced by cluster-analysis-pass. Runs six
  structured checks targeting common first-pass weaknesses — shallow
  cross-question synthesis, missed escalation patterns, strength map
  inaccuracies, generic takeaways, under-developed tensions, and missing
  dependency chains. Use when initial cluster memos are produced and need
  quality refinement before editorial review. Triggers on requests like "refine
  these memos," "run refinement checks," "improve the cluster analysis," or
  when cluster-analysis-pass output is provided and the user requests quality
  refinement before editorial review. Takes cluster analytical memos (from
  cluster-analysis-pass) and optionally compressed synthesis briefs as input.
  Do NOT use before initial memos exist, for writing report prose, for gap
  assessment (that's gap-assessment-gate), or as a substitute for operator
  editorial review.
---

# Cluster Memo Refiner

Run six structured refinement checks against cluster analytical memos. Report findings per check, then produce revised memos with changes marked. This is a quality pass between initial memo generation and operator editorial review.

## Input Requirements

**Required:** Cluster analytical memos (one per cluster, from cluster-analysis-pass). Each must contain Key Findings, Evidence Strength Map, Cross-Question Tensions, Gaps That Matter, and So What sections.

**Optional (recommended):** Compressed synthesis briefs — the underlying briefs that fed the cluster analysis. Needed for Check 3 to verify grade labels against source grades.

**Validate before proceeding:**
- At least 1 memo provided with identifiable evidence strength indicators and findings with source tags
- If compressed briefs are absent, note that Check 3 runs at reduced confidence (memo-internal references only)
- If a memo is missing a required section, flag which checks cannot run against that memo and proceed with remaining checks. Do not invent content for missing sections.
- If any Key Finding tagged `[SOURCE-GROUNDED]` cannot be traced to Claim IDs from the underlying briefs, flag as incomplete traceability. Severity: non-blocking (the refiner can still run its six checks), but the flag must appear in the output for operator awareness.

## Refinement Checks

Run all six checks against every memo. Report findings per check per memo before producing revisions.

### Check 1 — Cross-Question Synthesis Depth

**Target:** Findings that are single-question summaries dressed up as themes.

**Procedure:**
- For each Key Finding, count how many questions contribute to it
- Flag findings drawing from only one question
- For each flagged finding: can it merge into a broader multi-question theme, or is it genuinely question-specific?

**Actions:**
- Merge single-source findings into broader themes where evidence supports it
- Genuinely question-specific findings: relabel as question-specific and subordinate under a related theme, or retain standalone if significant enough (note reasoning)

**Output:** List of single-source findings with disposition (merged / relabeled / retained with reasoning)

### Check 2 — Escalation Patterns

**Target:** Findings that become more significant when combined across questions than they appear individually.

**Procedure:** Read findings across all questions as a set. Look for combinations where:
- Two findings from different questions imply a third conclusion neither surfaces alone
- A pattern in one question explains an anomaly in another
- Cumulative weight of related findings exceeds the significance of any individual finding

**Actions:**
- Add escalation patterns as new findings tagged [ANALYTICAL]
- Note contributing questions for each
- Place at appropriate rank in Key Findings (cross-question convergence often ranks high)

**Output:** Escalation patterns identified, with contributing questions and proposed placement

### Check 3 — Evidence Strength Map Accuracy

**Target:** Labels silently upgraded beyond what evidence supports.

**Procedure:**
- "Establishes" — verify High-grade evidence with multiple independent sources (check briefs if available, else memo-internal references)
- "Suggests" — verify Medium-grade or mixed-grade evidence
- "Preliminary signal" — verify Low-grade or single-source evidence

**Actions:**
- Downgrade labels where evidence doesn't support the current level
- Do not upgrade labels — flag for user attention if evidence seems stronger than label
- Note labels where compressed briefs would be needed to verify confidently

**Output:** Labels checked with pass/fail, downgrades applied, uncertain labels flagged

### Check 4 — "So What" Specificity

**Target:** Generic takeaways that don't drive editorial decisions.

**Procedure:** Test each So What recommendation against:
- Fail: "This topic is important" / "Consider X" / "X is a key factor"
- Pass: "Recommend foregrounding X because the evidence establishes Y, while downweighting Z which only reaches Suggests-level"

**Actions:**
- Rewrite generic takeaways using pattern: "Recommend [action] because [evidence reason]"
- If evidence doesn't support a specific recommendation, state that explicitly rather than forcing a vague one

**Output:** Before/after for each rewritten recommendation

### Check 5 — Tension Development

**Target:** Under-developed or missing tensions.

**Procedure — three sub-checks:**
1. **Completeness:** For each existing tension — is the stronger position named? Evidence support cited? Handling recommendation concrete (resolve in favor of / present both / flag as open)?
2. **Concreteness:** Are handling recommendations actionable? "Present both sides" is acceptable; "consider further" is not.
3. **Missing tensions:** Tensions visible across questions that the initial pass missed — particularly questions framing the same concept differently, reaching different conclusions about the same dimension, or where scope boundaries create artificial agreement.

**Actions:**
- Strengthen existing tensions with missing evidence support or handling recommendations
- Add newly identified tensions with full treatment (conflicting positions, evidence assessment, handling recommendation)

**Output:** Per existing tension: pass/fail on completeness and concreteness. New tensions listed with full treatment.

### Check 6 — Dependency Chains

**Target:** Findings where one only makes sense in light of another, implying narrative ordering constraints.

**Procedure:** Scan findings across the cluster for logical dependencies:
- Finding A assumes context from finding B
- Finding C only becomes meaningful after finding D is established
- Dependencies can be within-cluster (ordering within a section) or between-cluster (ordering between sections)

**Actions:**
- List dependency pairs with direction (A depends on B)
- Classify each as within-cluster or between-cluster
- Between-cluster dependencies: flag for downstream use, do not resolve

**Output:** Dependency pairs with classification

## Revision Protocol

After reporting all check findings:

1. Produce revised memos incorporating all refinements
2. Mark every change with `[REFINED]` inline (e.g., "[REFINED] Merged into theme: Core Mechanics")
3. Preserve all original content not flagged by any check
4. Do not make changes beyond what the six checks identify — no general editorial improvements, rewording for style, or additions from external knowledge

The `[REFINED]` markers serve as a diff mechanism for operator review. Remove after review is complete.

If check recommendations conflict (e.g., Check 1 wants to merge a finding but Check 6 identifies it as a dependency anchor), flag the conflict with both check numbers and reasoning. Present both options to the user rather than resolving silently.

## Completion Criteria

A memo passes refinement when all of the following hold:

1. **Check 1 — Synthesis:** No single-source findings remain without documented disposition (merged / relabeled / retained with reasoning)
2. **Check 2 — Escalation:** Cross-question combinations evaluated; any identified escalation patterns added and tagged [ANALYTICAL]
3. **Check 3 — Strength labels:** All evidence strength labels verified or flagged as uncertain; no unsupported upgrades remain
4. **Check 4 — So What:** Every recommendation either matches the "Recommend [action] because [evidence reason]" pattern or explicitly states insufficient evidence
5. **Check 5 — Tensions:** All existing tensions have named positions, cited evidence, and concrete handling recommendations; no "consider further" without specifics
6. **Check 6 — Dependencies:** All identified dependency pairs listed with direction and classification

If any criterion is not met, the memo requires another refinement pass on the failing check(s) before proceeding to editorial review.

## Output Protocol

**Default mode: Refinement**

Present check findings as a structured report (per check, per memo) before producing revised memos. Structure the findings report as one section per memo, with sub-sections per check — this groups all issues for a single memo together for easier operator review.

Do not produce revised memos until the user says `RELEASE ARTIFACT`. This lets the user override specific check results before revisions are applied.

When the user says `RELEASE ARTIFACT`, write the revised memos to files rather than outputting them in chat. Use the working directory or a path the user specifies.

## Guardrails

**Evidence integrity:**
- Operate only from provided memos and briefs — do not supplement with external knowledge or training data
- Do not upgrade evidence strength labels without operator approval; downgrades are permissible when evidence doesn't support the current label
- New findings from Check 2 must be tagged [ANALYTICAL] — model-identified patterns, not source-grounded claims
- If a check result is ambiguous (e.g., borderline between Suggests and Establishes), present both interpretations and let the user decide
- If provided information is insufficient to assess confidently, say so rather than inferring

**Process integrity:**
- If provided materials don't match expected cluster memo format, flag the mismatch and ask for clarification rather than attempting to adapt the checks
- Run all six checks against every memo; report "no issues found" for clean checks
- Report findings before producing revisions
- Mark all changes with [REFINED]; tag new findings as [ANALYTICAL]
- Preserve original content not flagged by checks
- Flag between-cluster dependencies for downstream use
- Do not make editorial decisions — this refines analytical quality, not editorial direction
