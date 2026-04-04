---
name: knowledge-file-producer
description: >
  Produce a knowledge file from a completed research section for use in the
  Claude Chat project. Use when a section's cited chapter files need to be
  condensed into a Chat-consumable knowledge file. Triggers on
  "produce knowledge file," "knowledge file for [section]," or when the
  /produce-knowledge-file command invokes this skill. This skill handles the
  judgment about what to preserve and what to condense. Do NOT use for producing
  report prose (evidence-to-report-writer), research extracts
  (research-extract-creator), or analytical memos (cluster-analysis-pass).
---

## Role + Scope

Knowledge file producer for cross-tool handoff. Take cited chapter files from Claude Code's report production pipeline and produce a condensed knowledge file that the Claude Chat project can load as project knowledge for Part 2 strategic design sessions. One knowledge file per section, combining all chapters.

Condenser, not editor. The approved content represents final research output. Preserve its conclusions and structural artifacts — do not reinterpret, extend, or editorialize.

**In scope:**
- Deciding what to preserve verbatim vs. condense per the heuristics below
- Producing a knowledge file within the target word count
- Preserving evidence calibration markers and open questions
- Deriving downstream implications for Part 2 consumption

**Out of scope:**
- Modifying or reinterpreting approved findings
- Adding analysis beyond what the approved content contains
- Full evidence chain reproduction (stays in Code)
- Methodology documentation beyond evidence basis characterization

## Consumer Context

The knowledge file serves the Claude Chat project for the Buy-Side Service Model. Chat sessions use knowledge files for:
- **Part 2 strategic design sessions** — all Part 2 sections need Part 1 findings as context for design decisions
- **Part 1 scoping sessions** — downstream sections may need upstream findings (e.g., 1.2 scoping needs 1.1's chain structure)
- **Part 1 / Part 2 checkpoint gate** — all Part 1 knowledge files reviewed against Working Hypotheses before Part 2 begins

**Context window constraint:** Knowledge files coexist with other project knowledge in Chat (content architecture, project plan, Working Hypotheses, other section knowledge files). Target **1,500-2,500 words** per knowledge file. Enough to be useful, short enough to coexist.

## Core Rule: Enough for Design Decisions, Not Re-Litigation

The knowledge file must contain enough for Chat to make design decisions anchored to the section's findings. It should NOT contain enough to re-litigate the research or reproduce the full argument chain.

## Preservation vs. Condensation Heuristics

Apply these per artifact type found in the approved content:

### Structural Artifacts (tables, matrices, classification schemes, discrete item lists)
**Default: Preserve intact or near-intact.**

These are often more useful preserved than condensed. A value chain activity list condensed as "we identified 8 activities" is useless — Chat needs the actual list with classifications to anchor Part 2 design decisions.

Exception: If a table has 30+ rows of detailed data, condense to the most consequential rows. Use judgment — preserve the rows that drive downstream design decisions, condense the rows that are supporting detail.

### Analytical Conclusions (findings, interpretations, implications)
**Default: Condense to conclusion + key supporting logic.**

Chat doesn't need the full evidence chain. It needs the conclusion and enough reasoning to evaluate whether it's well-grounded.

Pattern: State the conclusion, then one sentence on why it holds (strongest evidence or reasoning). Drop intermediate steps and source-by-source detail.

### Methodology and Process Description
**Default: Condense briefly.**

Chat needs to know the evidence basis (observed / published / inferred) but not the full research methodology. One or two sentences in the header's "Evidence basis" field, plus any methodology notes that affect how findings should be weighted.

### Evidence Calibration Markers
**Default: Preserve.**

These carry directly into Part 2. Chat needs to know which findings are solid ground for design decisions and which are working assumptions. Preserve inline markers from the approved content. If the approved content uses a calibration system, reproduce it.

### Open Questions and Gaps
**Default: Preserve the list.**

These shape what Part 2 sessions need to be careful about. Include each open question/gap with enough context to understand why it matters for downstream work.

### Downstream Implications
**Default: Preserve or derive.**

Chat needs to know what design decisions this section's findings support or limit. If the approved content states downstream implications explicitly, preserve them. If not, derive them from the findings — this is the one area where the skill adds interpretation beyond what's in the source.

## Working Hypotheses Variant

Working Hypotheses are a different artifact type — assumptions and declarations of current thinking, not research findings. When producing a knowledge file for Working Hypotheses:

- **Preserve assumptions verbatim** — they are the structural artifact
- **Note revisability status** for each assumption (firm, provisional, to-be-tested)
- **Focus on constraints** — what each assumption constrains in Part 2 design work
- **Skip evidence calibration** — Working Hypotheses are pre-research by definition

This variant guidance is preliminary. Refine after the first WH knowledge file is produced and its adequacy is assessed.

## Output Format

Use this structure as default. Headings marked *optional* can be dropped or renamed if the section's content doesn't map naturally to them.

```markdown
# [Section Number]: [Section Title] — Knowledge File

**Source:** [cited chapter filename(s) from report/chapters/]
**Approved date:** [date]
**Supersedes:** [previous version date, if this is a revision — omit for first version]
**Evidence basis:** [brief characterization — e.g., "Mixed: chain structure grounded in published PE frameworks and direct experience; behavioral patterns largely inferred"]

## Key Findings
[The substantive conclusions — what this section established]

## Structural Artifacts *(optional)*
[Tables, matrices, classification schemes, lists — preserved or condensed as appropriate.
Drop this heading if the section has no discrete structural artifacts — fold them into Key Findings instead.]

## Evidence Calibration *(optional)*
[What is evidence-backed vs. assumption-heavy — preserved from the approved content.
Can be integrated into Key Findings as inline markers if a separate section feels forced.]

## Open Questions and Gaps
[Unresolved issues carried forward]

## Downstream Implications
[Specific implications for sections that consume this output — what design decisions this enables or constrains]
```

## What NOT to Include

- Full evidence chains or source-by-source attribution (stays in Code)
- Methodology details beyond what's needed to assess evidence strength
- Process notes about how the section was produced
- Draft iterations or revision history
- Content that duplicates what's already in the content architecture specification (Chat already has that as a knowledge file)
- Claim IDs or citation markup (Code-internal referencing system, not meaningful to Chat)

## Section-Specific Guidance

This section is intentionally empty. Add guidance here after each section is approved and the first knowledge file is produced. Each entry should document: what the approved artifact actually contained, what the downstream consumers specifically needed, and any adjustments to the general heuristics that were required.
