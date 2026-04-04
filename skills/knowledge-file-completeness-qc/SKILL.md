---
name: knowledge-file-completeness-qc
description: >
  Cross-checks a knowledge file against its source chapter prose for content completeness.
  Catches missing claims, diluted causal chains, omitted load-bearing evidence, and uncovered
  downstream implications that the structural QC (word count, format, artifact preservation)
  does not detect. Use after the structural QC pass in /produce-knowledge-file. Do NOT use
  for structural/format QC (that's the inline criteria in the command's Step 5), report prose
  QC (report-compliance-qc), or chapter editorial review (chapter-prose-reviewer).
---

# Knowledge File Completeness QC

Cross-checks a knowledge file against the source cited chapters it was derived from. The structural QC (Step 5 of `/produce-knowledge-file`) verifies format, word count, and artifact preservation. This skill verifies that the knowledge file **captured everything a Part 2 consumer needs** — no critical findings lost, no causal chains flattened, no load-bearing evidence dropped.

**Position:** Step 5b of `/produce-knowledge-file` — runs after the structural QC passes.

## Inputs

All required. Content is passed directly (not file paths).

1. **Knowledge file** — the output of the knowledge-file-producer skill
2. **Source cited chapters** — all `{section}-chapter-NN-cited.md` files the knowledge file was derived from
3. **Knowledge-file-producer skill** — for understanding what the producer was supposed to preserve vs. condense (the heuristics define what counts as a legitimate condensation vs. an omission)

## Core Principle: Condensation vs. Omission

Knowledge files condense by design — the skill targets 1,500–2,500 words from chapter prose that may run 5,000–10,000+. Not every detail belongs in the knowledge file. The test for whether an omission is a gap:

> **Would a Part 2 consumer make a different design decision if they had this information?**

Apply this test before flagging anything. Texture, supporting detail, and intermediate reasoning steps are legitimate condensation targets. Conclusions, load-bearing data points, causal chains that inform intervention design, and evidence calibration nuances are not.

## Evaluation Method

Work **chapter by chapter, sequentially**. For each chapter:

1. Read the chapter in full.
2. Identify every distinct analytical claim, finding, data point, and conclusion.
3. For each, check whether it appears in the knowledge file — verbatim, summarized, or subsumed by a broader statement.
4. For items that appear: check whether the knowledge file version preserves the analytical weight (causal direction, specificity, qualification).
5. For items that don't appear: apply the Part 2 consumer test before flagging.

After all chapters are processed, run the cross-cutting checks (Categories 4–6).

## Category 1: Missing Claims

Analytical claims, findings, or conclusions in the chapter prose with **no representation** in the knowledge file — not even in summarized form.

| Check | What to verify |
|-------|---------------|
| **Distinct findings** | Each named finding or conclusion in the chapters has a counterpart in the knowledge file |
| **Conditional or qualified findings** | Findings that apply only under specific conditions (e.g., "specialized investors develop richer heuristic sets") are captured, not just the general case |
| **Interaction effects** | Where chapters identify that two patterns interact or compound, the interaction itself — not just the individual patterns — appears in the knowledge file |

**Flagging standard:** Flag only if the missing claim passes the Part 2 consumer test. State which knowledge file section it should appear in.

## Category 2: Diluted Claims

Claims present in the knowledge file but with **lost nuance, qualification, causal chain, or specificity** compared to the chapter prose.

| Check | What to verify |
|-------|---------------|
| **Causal chains preserved** | Where chapters establish A → B → C → outcome, the knowledge file preserves the chain, not just "A correlates with outcome" |
| **Specificity maintained** | Where chapters name a specific mechanism (e.g., "absence of early permissioning gate"), the knowledge file doesn't flatten to a generic statement (e.g., "less formalized governance") |
| **Qualification preserved** | Where chapters distinguish strategic choice from forced adaptation, or institutional legitimacy from mere disclosure, the knowledge file preserves the distinction |

**Flagging standard:** Quote both versions side by side — the chapter passage and the knowledge file passage. Do not flag based on impression; show the specific dilution.

## Category 3: Missing Evidence

Specific data points, statistics, source attributions, or empirical references in the chapters that are **absent from the knowledge file**.

| Check | What to verify |
|-------|---------------|
| **Load-bearing data points** | Statistics or figures that directly inform where in the value chain a service should intervene, how to segment the market, or how to calibrate claims |
| **Stage-specific metrics** | Pipeline stage percentages, conversion rates at specific funnel points, cost concentrations at named stages — these are high-value for service positioning |
| **Independent confirmatory evidence** | Where chapters cite multiple independent sources converging on a finding, the knowledge file should preserve the convergence (number and type of sources), not just the conclusion |

**Flagging standard:** A knowledge file is not a bibliography — it doesn't need every data point. Apply the load-bearing test: would removing this figure change how Part 2 positions the service, segments the market, or calibrates a claim? If yes, flag it.

## Category 4: Evidence Calibration Accuracy

Cross-check the knowledge file's evidence calibration (table or inline markers) against the actual hedging language and source quality in the chapters.

| Check | What to verify |
|-------|---------------|
| **Rating-to-language match** | A "Strong" rating should correspond to multiple converging sources or empirical data in the chapters. A "Low" rating should correspond to explicit uncertainty language. |
| **Hedging fidelity** | Where chapters say "analytical construct" or "tentative estimate," the calibration rating should reflect this — not rate higher than the chapter's own confidence language warrants |
| **Proxy acknowledgment** | Where chapters use non-Nordic data as "structural proxy," the calibration should note the proxy basis, not rate as if the evidence is directly applicable |

**Flagging standard:** Flag only where the rating is directionally wrong (e.g., Moderate-Strong for something the chapter calls an "analytical construct"). Don't flag fine gradations (Moderate vs. Moderate-Strong) unless the difference would mislead a Part 2 consumer about how much weight to put on the finding.

## Category 5: Gap and Open Question Completeness

Compare the knowledge file's "Open Questions and Gaps" section against **all uncertainty language, hedging, and evidence scarcity notes** in the chapters.

| Check | What to verify |
|-------|---------------|
| **Scope of stated gaps** | Each gap is framed broadly enough to capture the full extent of uncertainty. If chapters hedge on pipeline data, fund-size effects, screening bandwidth, AND attrition patterns — all using non-Nordic proxy — the gap should say "non-Nordic proxy used across multiple dimensions," not just "no Nordic pipeline data" |
| **Unstated gaps** | Uncertainty language in chapters (e.g., "structural reasons to expect equal or greater prevalence" = inference, not measurement) that doesn't appear in the gaps list |
| **Scarcity register alignment** | If a scarcity register exists, its items should be reflected in the gaps section |

**Flagging standard:** Gaps shape what Part 2 treats as firm ground vs. working assumption. A narrowly framed gap may cause Part 2 to over-rely on evidence that the chapters themselves treated cautiously.

## Category 6: Downstream Implication Coverage

Two-directional check: verify listed implications, then scan for unlisted ones.

| Check | What to verify |
|-------|---------------|
| **Listed implications supported** | Each downstream implication in the knowledge file has clear support in the chapter content |
| **Unlisted implications present in prose** | Chapter findings that have obvious Part 2 design implications (service interaction model, market segmentation, positioning) but aren't surfaced in the downstream implications section |
| **Specificity of implications** | Implications should be specific enough to constrain Part 2 design. "This matters for service design" is not useful. "This determines whether the service interfaces with associates or partners" is. |

**Flagging standard:** The downstream implications section is the primary interface between the knowledge file and Part 2 work. Missing or vague implications directly degrade Part 2 quality.

## Severity Classification

Every finding receives one severity level:

| Severity | Definition | Examples |
|----------|-----------|----------|
| **CRITICAL** | Would change a Part 2 design decision — where the service intervenes, whom it serves, how it's positioned, or what claims it makes | Missing pipeline stage percentages that show where attrition concentrates; missing role-hierarchy implication for service interaction model |
| **MODERATE** | Loss of useful nuance for downstream work — Part 2 would still reach approximately the right answer, but with less precision or a weaker argument | Flattened causal chain (governance → missing gate → drift → low conversion); narrowly framed gap that understates evidence uncertainty |
| **MINOR** | Completeness gap with low downstream impact — adds texture or evidentiary weight but wouldn't change a design decision | Third independent source confirming an already-established finding; secondary cost examples outside the main cost nexus |

## Verdict

- **COMPLETE** — No CRITICAL or MODERATE findings. MINOR findings may exist and are noted.
- **GAPS FOUND** — One or more CRITICAL or MODERATE findings. Report count by severity.

## Output Format

```markdown
## Completeness QC: [Section Number] Knowledge File

### Verdict: [COMPLETE / GAPS FOUND]

| Severity | Count |
|----------|-------|
| CRITICAL | [n] |
| MODERATE | [n] |
| MINOR    | [n] |

### Findings

[For each finding:]

**Finding [N.N]**
- **Category:** [Missing Claim / Diluted Claim / Missing Evidence / Calibration Mismatch / Missing Gap / Missing Implication]
- **Location in chapters:** [Chapter number, section heading]
- **Severity:** [CRITICAL / MODERATE / MINOR]
- **What's missing or wrong:** [Specific description. For diluted claims: quote both versions.]
- **Why it matters for Part 2:** [One sentence connecting the gap to a specific downstream design decision]

### Notes
- [Any retracted findings — items initially flagged but determined on closer inspection to be legitimate condensation. Include these to show the evaluator's reasoning, not just conclusions.]
```

## Relationship to Structural QC (Step 5)

This skill does NOT re-check Step 5 criteria (word count, format compliance, artifact preservation, claim ID stripping). Assume those passed. If this skill notices a structural issue in passing, note it but don't formally score it — that's Step 5's job.

The two QC passes are complementary:
- **Step 5 (structural):** Does the knowledge file follow the rules for how it should be built?
- **Step 5b (completeness):** Does the knowledge file contain what Part 2 needs?
