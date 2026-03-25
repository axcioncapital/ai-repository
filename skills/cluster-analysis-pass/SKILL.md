---
name: cluster-analysis-pass
description: >
  Produce a structured analytical memo from Research Extracts or compressed
  synthesis briefs for a single topic cluster. Use when: the user provides
  Research Extracts or synthesis briefs for a cluster and needs cross-question
  analysis synthesized into a decision-support memo. Triggers on cluster
  descriptions paired with Research Extracts or compressed briefs containing
  evidence grades. Do not use for: single-question summaries, raw source
  analysis, or final prose writing — this produces structured notes for a
  human editor, not reader-facing content.
---

# Cluster Analysis Pass

Produce a structured analytical memo from Research Extracts or compressed synthesis briefs for a single topic cluster. The memo is decision-support material for a human editor — structured notes, not prose.

## Input Requirements

Expect two inputs:

1. **Cluster description** — a one-line label (e.g., "Cluster 1: PE fundamentals — definition, characteristics, fund structures")
2. **Research Extracts or Compressed Synthesis Briefs** — one per research question (typically 3-6). Research Extracts contain per-component Claims Inventories with Component Synthesis paragraphs, evidence strength grades (H/M/L), source independence counts, and Coverage Verdicts. Compressed Synthesis Briefs contain findings with evidence grades and independence counts. Both formats provide the evidence signals needed for synthesis.

Validate before proceeding:
- At least 2 Research Extracts or briefs provided (cross-question synthesis requires multiple inputs)
- Inputs contain identifiable evidence grades (H/M/L or High/Medium/Low) and source independence counts
- A cluster description is present or can be inferred from input content
- If Research Extracts: Coverage Verdicts table present per extract (used for Gaps That Matter section)

If the cluster description appears mismatched with brief content (e.g., description says "fund structures" but briefs cover "deal sourcing"), flag the mismatch to the user before proceeding. State what the briefs actually cover and ask for confirmation.

If inputs are incomplete, state what is missing and request it. Do not infer missing evidence.

If briefs use inconsistent or absent grading schemes, note the inconsistency in the Evidence Strength Map section, map to the closest equivalent where possible, and flag uncertain mappings with `[GRADE INFERRED]`.

## Memo Structure

Organize the memo under these six sections. Every section is required; if a section has nothing to report, state that explicitly (e.g., "No significant tensions identified across this cluster's evidence"). Target total memo length: 400-800 words. Key Findings and Cross-Question Tensions should carry the most weight.

### 1. Cluster Summary
2-3 sentences framing what this cluster covers and the overall evidence picture. State the number of questions analyzed and the general grade distribution.

### 2. Key Findings
Thematic findings synthesized across questions — NOT a question-by-question recap. Group related findings from different questions under shared themes.

For each finding:
- State the finding
- Tag as `[SOURCE-GROUNDED]` (directly supported by brief evidence) or `[ANALYTICAL]` (pattern observed across briefs by the model)
- Note which questions contribute to this finding (by question number or short label)

Organize by importance to the cluster narrative, most significant first. Ranking heuristic: (1) evidence strength — High-grade findings first, (2) cross-question convergence — findings supported by more questions rank higher, (3) narrative significance — findings that frame or reframe other findings.

### 3. Evidence Strength Map
Classify findings using this mapping:

| Brief Grade | Memo Label | Meaning |
|---|---|---|
| High (strong evidence, multiple independent sources) | **Establishes** | Treat as firm ground in downstream narrative |
| Medium (moderate evidence, some corroboration) | **Suggests** | Present with appropriate hedging |
| Low (weak evidence, single source or thin support) | **Preliminary signal** | Acknowledge as tentative; flag if gap matters |

When a finding draws from multiple questions with mixed grades, state the range (e.g., "Supported by High-grade evidence on structure but only Low-grade evidence on performance impact").

### 4. Cross-Question Tensions
Identify contradictions, disagreements, or incompatible framings across questions within this cluster.

For each tension:
- State the conflicting positions and which questions they come from
- Assess which position has stronger evidence support (cite grade distribution and independence counts from the briefs)
- Recommend a handling approach: resolve in favor of stronger evidence, present both positions, or flag as open question

This section is the primary value-add. Individual question findings are already in the briefs — surface what becomes visible only when looking across questions.

### 5. Gaps That Matter
Known unknowns the downstream narrative should acknowledge rather than paper over.

For each gap:
- What is missing or underexplored
- Why it matters for the cluster's narrative purpose
- Whether it is a gap in the research (no evidence sought) or in the evidence (sought but not found)

Do not list every conceivable gap. Focus on gaps that would change editorial decisions or that a reader would notice.

### 6. So What
What a reader should take away from this cluster's evidence. Frame as editorial recommendations the user can override.

Use the pattern: "Recommend [action] because [evidence reason]" — not "X is important" or "Consider X."

Include:
- 1-2 headline takeaways for this cluster
- Recommended emphasis for the downstream narrative
- Any findings that should be foregrounded or deliberately de-emphasized, with reasoning

## Synthesis Instructions

### Organize by Theme, Not by Question

Do not mirror the brief structure. Multiple questions often contribute to the same theme, and single questions may contribute to multiple themes.

**Transformation example:**
- Brief Q1 covers "What is PE?" -> definition findings
- Brief Q2 covers "How do PE funds work?" -> structure findings
- Brief Q3 covers "What distinguishes PE from other asset classes?" -> differentiation findings

Bad memo structure: Section per question (Q1 findings, Q2 findings, Q3 findings).

Good memo structure: Themes like "Core mechanics" (draws from Q1 + Q2), "Competitive positioning" (draws from Q2 + Q3), "Definitional boundaries" (draws from Q1 + Q3).

### Reading Research Extracts

When input is Research Extracts (not Synthesis Briefs), use this reading path:

- **Component Synthesis paragraphs** are the primary synthesis input — these contain the analytical framing per Answer Spec component. Treat them as equivalent to the interpretive content in Synthesis Briefs.
- **Individual claims** (below each Component Synthesis) provide the evidence backing. Reference these for grade-checking, independence verification, and tension identification — but do not synthesize claim-by-claim.
- **Coverage Verdicts table** maps directly to the Gaps That Matter section. THIN and MISSING verdicts should surface as gaps unless the operator has noted they were resolved via supplementary research.
- **Conflicts section** provides pre-identified source disagreements. Cross-reference with Cross-Question Tensions — some conflicts within a single question may escalate to cross-question tensions when viewed alongside other extracts.

### Identifying Cross-Question Patterns

Actively look for:
- **Convergence** — multiple questions arriving at the same conclusion from different angles (strengthens confidence)
- **Tension** — questions producing contradictory or incompatible findings (requires editorial decision)
- **Dependency** — one question's findings only making sense in light of another's (suggests narrative ordering)
- **Escalation** — findings that become more significant when combined across questions than they appear individually

### Assessing Tension Strength

When briefs conflict, use grade distribution and independence counts to assess which position has stronger support:
- More High-grade sources on one side -> lean toward that position
- Equal grades but more independent sources -> lean toward the more independently corroborated position
- Equal grades and independence -> flag as genuinely unresolved

## Evidence Integrity Rules

- **Operate only from provided briefs.** Do not supplement with external knowledge, training data, or general reasoning about the topic. The evidence chain must stay intact from source to synthesis.
- **Label every claim.** Use `[SOURCE-GROUNDED]` for findings directly traceable to brief evidence and `[ANALYTICAL]` for patterns or connections the model identifies across briefs. Never present analytical observations as if they were source-grounded.
- **Preserve grade fidelity.** Do not upgrade evidence strength. A finding graded Medium in the brief stays "Suggests" in the memo — do not promote it to "Establishes" through aggregation unless multiple independent Medium-grade sources converge on the same specific claim.
- **Do not re-derive coverage verdicts.** If a Research Extract marks a component as COVERED, treat it as covered even if the claims underneath seem thin to you. The verdicts were reviewed by the operator. If you disagree, flag it in Gaps That Matter with a note, but do not override.
- If the provided briefs are insufficient to support a confident finding, say so. Leave gaps rather than invent plausible-sounding synthesis. If a brief's premise contains an error or questionable assumption, flag it constructively. Accuracy over comprehensiveness.

## Output Protocol

**Default mode: Refinement**

Before producing the full memo, present:
- Proposed thematic groupings
- Key tensions identified across briefs

Do not produce the full memo until the user confirms or redirects.

When the user says `RELEASE ARTIFACT`:
- Write the complete memo to a file in the working directory
- Provide a brief summary of what was produced

Target memo length: 400-800 words per cluster depending on complexity. Err toward lean — this feeds further steps, not the final reader.
