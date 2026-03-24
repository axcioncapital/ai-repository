---
name: research-extract-creator
description: >
  Produce structured Research Extracts from a raw Deep Research report and its
  corresponding Answer Specs — one extract per research question. Each extract
  contains a claims inventory with source attribution, evidence strength ratings,
  coverage verdicts per Answer Spec component, component syntheses, and
  gap/conflict documentation. Use when Patrik provides a Deep Research session
  output alongside Answer Specs and says "extract this," "create research
  extracts," "process this Deep Research output," "run extraction," or when a raw
  Deep Research report is provided with Answer Specs and the expectation of
  structured extracts. This is Step 2.3 of Stage 2 in the Axcion Research
  Workflow. Do NOT use for evidence verification against specs
  (evidence-spec-verifier), cluster-level analysis (cluster-analysis-pass),
  report prose writing (evidence-to-report-writer), or supplementary research
  decisions (operator's review at Step 2.4).
---

# Research Extract Creator

## Inputs

Both provided by the operator in a single message:

1. **Raw Deep Research report** — one session's output covering 2–4 research questions. Contains sourced findings in prose/table format with inline citations and URLs, structured by question-level sections.
2. **Answer Specs** — for the specific questions covered in this session. Each spec lists required components and completion gates.

If either input is missing, ask for it before proceeding. If Answer Specs don't match any question sections in the report, flag the mismatch and ask for clarification.

## Output

One Research Extract per research question, written to a single markdown file. Use the template in `references/extract-template.md`.

Write output to the project's working directory using the naming convention: `research-extract-[session identifier].md` (e.g., `research-extract-A.md`). If no session identifier is provided, ask.

## Extraction Logic

### Claim Extraction

- Read the Deep Research report section by section.
- For each Answer Spec component, identify all claims in the report that address it.
- Restate each claim in own words — do not copy verbatim from the report.
- Assign Claim IDs: `[Question ID]-C[sequential number]` (e.g., Q1-C01, Q1-C02).
- A single paragraph or table row may yield multiple claims if it contains distinct factual assertions.
- A single claim may map to multiple components — list under the primary component, cross-reference in the secondary.

### Source Attribution

- Carry over source names and URLs exactly as cited in the Deep Research report.
- Do not verify, modify, or enrich source citations — take them at face value.
- Record the source locator: section heading and approximate position (paragraph number, table label, bullet position) in the Deep Research report.

### Evidence Strength (per claim)

| Rating | Criteria |
|--------|----------|
| **H** | Multiple independent credible sources; primary or institutional data; direct evidence from a primary or institutional source |
| **M** | Single credible source, or multiple sources with shared editorial origin; indirect but reasonable evidence |
| **L** | Single source of uncertain quality; inferential; tangential relevance; vendor/advocacy source without corroboration |

### Independence Counting

- Count editorially independent sources supporting each claim.
- Syndicated content, derivative reports citing the same primary data, and secondary sources restating the same original finding count as one.
- If independence is unclear, note the uncertainty rather than guessing.

### Coverage Verdicts (per Answer Spec component)

| Verdict | Threshold |
|---------|-----------|
| **COVERED** | ≥2 claims with ≥1 at H strength, OR ≥3 claims at M strength with ≥2 independent sources across them |
| **THIN** | 1 claim at any strength, OR 2+ claims but all L strength, OR only sources with shared editorial origin |
| **MISSING** | No claims extracted for this component |

### Component Synthesis

Per component, write 2–3 sentences summarizing what the evidence collectively shows. State what is established (H-grade claims), what is suggested (M), and what remains uncertain (L or gaps). This is analytical framing — what the evidence means, not a claim recap. The synthesis must be derivable from the claims listed below it. Do not introduce framing the claims don't support.

### Gaps

Identify which Answer Spec components lack sufficient evidence. Classify each gap:

- **Not addressed** — Deep Research didn't search for it
- **Searched but not found** — report acknowledges scarcity
- **Found but weak** — evidence exists but below COVERED threshold

Note whether the gap matters for downstream narrative.

### Conflicts

Where sources cited in the report disagree: state both positions, assess which has stronger support based on source credibility and independence, and recommend handling (resolve, present both, flag as open).

## Failure Behavior

- **Component not covered in report** → mark MISSING in Coverage Verdicts. Component Synthesis: "No evidence found in the Deep Research report for this component." Do not synthesize from training data or infer from adjacent evidence.
- **Evidence is thin** → extract claims that exist, mark THIN, write Component Synthesis reflecting the limited evidence. Do not complete the component with plausible-sounding filler.
- **Ambiguous source citation** (URL missing, source name unclear) → carry through with a caveat in Notes: "[Source citation unclear in original report]". Do not fabricate source metadata.
- **Contradictory claims** → capture both as separate claims in the Claims Inventory and document in the Conflicts section. Do not silently resolve by picking one.
- **Ambiguous question mapping** (report section unclear which question it addresses) → map to the most likely question, note ambiguity in the claim's Notes field, flag in Extraction Metadata.

If the provided information is insufficient to extract confidently, say so rather than inferring. Leave gaps rather than invent plausible-sounding details.

## Scope Boundaries

This skill extracts and structures — it does not verify sources, supplement evidence from training data, make editorial judgments about report inclusion, or compress/summarize content.

## Output Protocol

No refinement mode. Produce all Research Extracts for the session in a single file. The operator reviews extracts at Step 2.4 and requests re-extraction if needed.
