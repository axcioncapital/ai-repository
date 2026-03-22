---
name: gap-assessment-gate
description: Assesses evidence sufficiency across cluster analytical memos and routes gaps for resolution before committing to document architecture. Use when all cluster analytical memos are complete and the user needs a go/no-go decision on whether evidence supports the planned report sections. Triggers on requests like "assess gaps," "run gap gate," "are we ready to write," "check evidence sufficiency," or when cluster memos are provided with expectation of a proceed/hold recommendation. Takes cluster analytical memos (from cluster-analysis-pass) as primary input, with Coverage Trackers as optional supplement. Do NOT use before cluster analysis is complete, for individual question gap checking (that's the Evidence Pack QC step), for identifying what to research initially (that's research-plan-creator), or for post-draft quality review.
---

# Gap Assessment Gate

Aggregate gap and evidence-strength information from all cluster analytical memos. Classify each gap by severity, assign a resolution path, and produce a proceed/hold recommendation. This is the last gate before document architecture — once past this step, the report's scope is implicitly locked.

## Input Requirements

Expect:

1. **Cluster analytical memos** (required) — one per cluster, each containing at minimum Section 3 (Evidence Strength Map) and Section 5 (Gaps That Matter) per the cluster-analysis-pass output format
2. **Coverage Trackers** (optional, recommended) — from the original Evidence Packs, one per research question. Compact tables showing component coverage, gate status, and grade distribution. Used to verify gap classifications.

Validate before proceeding:
- Confirm with the user how many cluster memos are expected. If fewer are provided, ask whether the remaining clusters were intentionally excluded or are still pending. Do not proceed until the set is confirmed complete.
- Each memo contains identifiable gap information and evidence strength indicators
- If a memo lacks a Gaps That Matter section, confirm with the user whether this means "no gaps" or "section was omitted"

If Coverage Trackers are absent, note that classification confidence is reduced for borderline cases and proceed.

## Gap Classification

Classify each gap surfaced across all cluster memos:

| Category | Definition | Action Required |
|----------|-----------|-----------------|
| **Blocking** | Evidence too thin to write a credible section. A reader would notice. | Yes — Path A or B |
| **Weakening** | Section writable but relies heavily on "Suggests" or "Preliminary signal" evidence. Hedging required. | Yes — default Path B |
| **Acceptable** | Gap is real but doesn't undermine the section. Acknowledge and move on. | No |

### Terminology

- **Component**: A distinct analytical element tracked in the Evidence Strength Map (e.g., a market segment, a regulatory factor, a competitive dynamic). Each component maps to one or more rows in the cluster memo's evidence table.
- **Dimension**: A sub-aspect evaluated for each component (e.g., market size, growth rate, competitive intensity). Dimensions are the columns or evaluation criteria within the Evidence Strength Map.

### Classification Rules

Apply using Evidence Strength Map labels from cluster memos:

| Condition | Classification |
|-----------|---------------|
| Component has zero "Establishes" findings AND fewer than 2 independent "Suggests" findings | Blocking |
| Component's entire evidence base is "Preliminary signal" | Blocking |
| Component has at least 1 "Establishes" finding but remaining dimensions rely on "Preliminary signal" | Weakening |
| Component has "Suggests"-level evidence across all dimensions but no "Establishes" | Weakening |
| Gap flagged in multiple cluster memos (cross-cluster pattern) | Escalate one level (Acceptable → Weakening, Weakening → Blocking) |
| Gap is peripheral to the section's core argument | Acceptable regardless of evidence level |

**Tiebreaker:** If Coverage Trackers are available, check gate status — ✗ confirms Blocking, ⚠ confirms Weakening, ✓ means the gap is contextual rather than evidentiary (likely Acceptable).

## Routing Logic

### Path A — Stage 2 Loop-back

The gap requires a new or revised research question executed through the full evidence workflow (Answer Spec → Evidence Pack → QC → Compression → re-integration into cluster memo).

Use when:
- Gap is analytical or complex, not answerable by a few factual lookups
- Multiple independent sources needed for credibility
- New Claim ID structure required to integrate properly

### Path B — Perplexity Supplementary

Targeted factual retrieval outside the formal evidence workflow.

Use when:
- Gap is a specific data point, statistic, definition, or benchmark
- 1–3 targeted searches would likely resolve it
- Independence requirements are low (single authoritative source sufficient)
- Finding can be appended to the cluster memo without restructuring

### Default Routing

- Blocking gaps → Assess Path A vs. Path B per criteria above
- Weakening gaps → Path B, unless the weakness is systemic across the cluster (same dimension thin in multiple questions), then escalate to Path A
- Acceptable gaps → No action, document only

### Proceed / Hold Decision Rule

- **Proceed** — Zero Blocking gaps remain
- **Proceed (conditional)** — Zero Blocking gaps, but Weakening gaps exist with Path B briefs assigned. Note Path B completion as a pre-condition.
- **Hold** — Any Blocking gap exists, regardless of routing assignment

## Procedure

1. Extract all gaps from cluster memos (Section 5 of each)
2. Cross-reference against Evidence Strength Maps (Section 3) — a gap flagged as "missing" but with "Suggests"-level evidence elsewhere in the cluster may be Weakening rather than Blocking
3. Check for cross-cluster gap patterns: same gap in multiple clusters = systemic weakness, default to Path A
4. If Coverage Trackers provided, verify borderline classifications against gate statuses
5. For each gap: assign classification, routing path, one-sentence rationale
6. For Path B gaps: draft a supplementary research brief (see Path B Brief format below)
7. For Path A gaps: specify the new/revised research question and recommended tool assignment
8. Compile Gap Assessment Report

## Gap Assessment Report Format

```
# Gap Assessment Report

## Summary
- Total gaps identified: [n]
- Blocking: [n] | Weakening: [n] | Acceptable: [n]
- Routing: [n] Path A, [n] Path B, [n] no action
- Recommendation: [Proceed to Document Architecture / Hold for supplementary research]

## Gap Register

| # | Cluster | Gap Description | Category | Path | Rationale |
|---|---------|----------------|----------|------|-----------|

## Path A Actions
Per Path A gap:
- New/revised research question
- Recommended tool (GPT-5 or Perplexity)
- Dependencies on existing questions
- Estimated scope (new question vs. revision of existing)

## Path B Briefs
Per Path B gap:
- Cluster: [cluster name]
- Target: [1 sentence — the specific datapoint, statistic, or definition needed]
- Source type expected: [e.g., Data Provider, Trade Publication, Company Filing]
- Search queries (up to 3)
- Completion criteria: [what "filled" looks like]
- Integration target: [which cluster memo receives the finding]

## Cross-Cluster Patterns
Systemic gaps appearing across multiple clusters. Listed separately because they indicate evidence design issues, not just individual question shortfalls.

## Accepted Gaps
Gaps classified as Acceptable, with brief rationale for why they don't undermine report credibility.
```

## Output Protocol

Default to refinement mode: present the Gap Register table and routing recommendations in chat first. This lets the user adjust classifications or override routing paths before the full report is generated.

Produce the complete Gap Assessment Report only after user says `RELEASE OUTPUT`. Write the final report to a file in the active working directory, not inline in chat.

## Evidence Integrity Rules

- Operate only from provided memos and Coverage Trackers. Do not supplement with external knowledge about what evidence "should" exist.
- Do not downgrade gap severity to avoid triggering Path A. If the evidence is thin, say so.
- If a gap's classification is genuinely ambiguous, present both interpretations and let the user decide.
- Accuracy over comprehensiveness — it is better to flag 3 real Blocking gaps than to produce an exhaustive register of marginal concerns.
- If a cluster memo uses evidence strength labels that don't match the expected terminology (Establishes / Suggests / Preliminary signal), map them to the closest equivalent and note the mapping in the Gap Register. If mapping is ambiguous, flag to the user before classifying.
- If the provided information is insufficient to classify confidently, say so rather than inferring. Gaps in output are acceptable; invented classifications are not.
