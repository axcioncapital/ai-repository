# Quality Control Standards — {{PROJECT_TITLE}}

> **When to read this file:** When running QC checks, applying fixes to prose, or handling evidence gaps. Not needed for every turn.

## Core QC Principles

- QC checks are deterministic and binary (PASS/FAIL)
- QC is separated from remediation — identify problems in one step, fix in a separate step
- Every finding carries severity classification (BLOCKING / NON-BLOCKING) and a proposed fix
- Cross-model verification: no model reviews its own output

## Bright-Line Rule

Defined in the main CLAUDE.md. Applies at: Step 4.2, Step 5.2, Step 5.7, and `/verify-chapter`. Before ANY fix to report prose, check:

1. Multi-paragraph scope? → PAUSE
2. Analytical claim alteration? → PAUSE
3. Sourced statement modification? → PAUSE

If ANY true → do not apply without operator approval. Log to `/logs/decisions.md`.

## Claim ID Invariant

Every discrete factual assertion that can appear in report prose MUST have a Claim ID before it enters any downstream artifact (cluster memo, section directive, chapter draft, or report prose). The pipeline has one primary ID assignment point (Step 2.3) and two supplementary entry points that must enforce the same standard:

- **Step 2.S4 (supplementary evidence merge into extracts):** The `supplementary-evidence-merger` skill assigns IDs as `Q[n]-C[##]` continuing the extract sequence. Block-level findings must be decomposed into individual claims first.
- **Step 3.S3 (gap-fill merge into cluster memos):** Gap-fill evidence must be written to a lightweight extract file (`GF[cluster]-C[##]` IDs) before merging into memos.

**Test:** If a claim can be cited independently in report prose, it needs an ID. No `[CITATION NEEDED]` tags should reach Stage 4 prose except for genuine analytical inferences that synthesize across multiple claims without a single supporting source.

**QC check:** At Step 3.7 (synthesis), the chapter drafter must flag any finding it cannot trace to a Claim ID. At Step 4.2 (report writing), the writer must not produce `[CITATION NEEDED]` for any assertion that has a traceable source — if the source is known but the ID is missing, the step is blocked until the ID is assigned upstream.

## Evidence Scarcity Handling

When supplementary research exhausts maximum passes (2 per question in Stage 2, 2 per question in Stage 3) without resolving a gap, the item is classified as **confirmed evidence scarcity** and added to `/execution/scarcity-register/{section}/{section}-scarcity-register.md` (Stage 2) or updated in place (Stage 3).

### Scarcity Register Entry Format

- **Question ID:** [e.g., Q3]
- **Missing component:** [what the Answer Spec required that could not be evidenced]
- **Research attempted:** [summary of supplementary passes and what was found]
- **Editorial instruction:** One of:
  - HEDGE — qualify claims with uncertainty language
  - SCOPE CAVEAT — note the limitation explicitly
  - PROXY FRAMING — use available adjacent evidence with transparent proxy disclosure
- **Downstream routing:** Which cluster memo and section directive must incorporate this instruction

### Scarcity Downstream Rules

- Stage 3 section directives MUST reference scarcity register entries for their cluster
- Stage 4 report prose MUST implement the editorial instruction specified in the register
- The scarcity register is a required input for `section-directive-drafter` and `evidence-to-report-writer`
