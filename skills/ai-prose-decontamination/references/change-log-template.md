# Change Log Template — ai-prose-decontamination

Produce a structured change log as output. When invoked within a pipeline, the calling agent writes this to `{prose_output_dir}/decontamination-log.md`. When invoked standalone, present it directly.

```
# Decontamination Change Log

Passes applied: 4
Total changes: [N]
Pass 1 (Ornamental Language): [N] changes
  — contrast-template overuse (1a): [N]
  — abstract-noun stacking (1b): [N]
  — flagged-word registry (1c): [N swaps / N carve-outs preserved] or [not provided]
  — other ornamental edits: [N]
Pass 2 (Repetition): [N] changes
  — pivot closings (2a): [N]
  — other repetition edits: [N]
Pass 3 (Over-Argumentation): [N] changes
Pass 4 (Rhythm): [N] changes
  — pseudo-maxim budget (4a): [N]
  — other rhythm edits: [N]

Style reference: [provided]
Prose quality standards: [provided / not provided]
Flagged-Word Registry: [provided / not provided]
Source fidelity spot-check: [passed / skipped (no source provided)]

## Bright-Line Flags

[Empty if no analytical claims or sourced statements were touched. If populated, list each flagged change with location, the proposed edit, and which bright-line check it triggers.]

## Changes

### Pass 1 — Ornamental Language

[P1-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [contrast-template (1a) | abstract-noun stacking (1b) | registry swap (1c) | other]
Before: "[quoted original]"
After: "[quoted replacement]"
Rationale: [one sentence — what AI pattern was removed]

### Pass 2 — Repetition

[P2-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [pivot closing (2a) | other]
Removed: "[quoted deleted text]"
Rationale: [one sentence — what it restated or what it gestured at]

### Pass 3 — Over-Argumentation

[P3-1] Location: [H2 section name], paragraph [N]
Before: "[quoted original passage]"
After: "[quoted compressed version]"
Rationale: [one sentence — what scaffolding was unnecessary]

### Pass 4 — Rhythm

[P4-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [pseudo-maxim (4a) | other]
Before: "[quoted original]"
After: "[quoted restructured version]"
Rationale: [one sentence — what rhythm problem was fixed]
```

**Consolidation rule:** If more than 20 changes in a single pass, consolidate into grouped entries with representative examples. Example: "P1-1 through P1-8: Replaced elevated constructions across 6 paragraphs" with 2–3 representative before/after pairs. Summary counts remain exact.
