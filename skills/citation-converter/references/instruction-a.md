# Instruction A — Internal Research (Section-Local Sources Index)

## Source Numbering

- Source numbers correspond to **unique sources within the current H1 module**, not to individual claims and not to the document globally. Each distinct source cited in a module receives one local number in that module, assigned in order of first appearance in that module's prose starting at ¹.
- **Numbering resets at each H1 module boundary.** Module A's source numbering is independent of Module B's. The same source cited in both modules gets its own entry in each module's Sources block at that module's local number.
- Within a module, the first time a source supports a claim in the prose, it receives that module's next local number. Every subsequent claim in the same module backed by the same source reuses that local number.
- **Rendering:** Use Unicode superscript characters (¹²³⁴⁵⁶⁷⁸⁹⁰) for all source references, both inline and in Sources block entries. Do not use HTML `<sup>` tags — these render as literal text in markdown output.

## Placement Rules

- Superscript immediately after the punctuation that closes the cited unit: after the period when the full sentence is the cited claim, after the clause-ending punctuation (comma, semicolon, colon) when citing a mid-sentence clause. Never before punctuation.
- **Multi-source claims:** separate the relevant source numbers with regular spaces (e.g., `¹ ² ³`). Do NOT use middle-dot `˒`, commas, or any other separator between superscripts.
- Paywall status: recorded in the Source Registry (working artifact) only. Do NOT append `[preview only]` or any paywall annotation to the compressed label in the Sources block.

## Conflict and Gap Handling

- Conflicted claims: cite both sides, acknowledge discrepancy in prose
- Known gaps: state limitation in prose with appropriate hedging

## Supplementary Item Citation

- Supplementary sources are treated identically to any other source — they receive a source number following the same per-module, per-unique-source numbering rules
- No in-prose signal distinguishes supplementary from core sources; supplementary status is recorded only in the Traceability Layer (Supplementary Items Map)

## Sources (Per-Module Section-Local Block)

Produce ONE `## Sources` block per H1 module, placed immediately after that module's last content line (paragraph, table, or list), separated by `---` on its own line. Not a global block at the end of the document.

**Identifying the module unit.** "Module" means the top-level content section of the document. When the document's sole `#` (H1) heading is a document title (one H1 heading followed only by introductory prose, with the body organized under `##` (H2) headings), treat the H2 sections as the module unit — each H2 gets its own `## Sources` block. When the document has multiple `#` (H1) headings each introducing a substantive body of content, those H1s are the module unit. In either case, the Sources block placement and per-module numbering reset apply at the module-unit boundary, not at every subheading level.

### Block placement

- After the final content line of an H1 module, insert a blank line, then `---` on its own line, then a blank line, then the `## Sources` heading, then a blank line, then the single-line compact inline source index.
- When the module's last content element is a **table**, insert `---` on its own line immediately after the table's last row, with no blank line between the table and the `---`. (Tables have no explicit closing delimiter; without this rule the divider placement is ambiguous.)
- Begin the next H1 module after the Sources block.

### Block heading

- Use `## Sources` exactly. Do not use `Bibliography`, `References`, `Works Cited`, or any other heading name.

### Block content — compact inline source index

Format as a single line: `¹ Label · ² Label · ³ Label · …`

- **Separator:** ` · ` (regular space + U+00B7 middle dot + regular space) between entries. No commas. No pipes. No blank lines between entries. A Sources block is one continuous line, not a list.
- **Per-entry label:** organization name or author surname(s) only. Do NOT include article titles, quotation marks, italics, bold markers, URLs, publication dates, access dates, paywall annotations (`[preview only]`), or quality flags. Labels match the compressed style used in the project's reference example.
  - Single org: `McKinsey & Company`, `Bain & Company`, `Cambridge Associates`
  - Multi-author joint work: semicolon-separated surnames, e.g., `Harris; Jenkinson; Kaplan`
  - Org variants / successor entities: slash, e.g., `Invest Europe / EDC`
  - Proxies / sources-of-sources: parenthetical, e.g., `Copenhagen Economics (for SVCA)`, `S&P Global Market Intelligence (citing Preqin)`
  - Multi-source concatenation (one citation number backed by several distinct sources): semicolon-joined list, e.g., `SSE Dissertation; Sampford Advisors; Private Equity Professional`
- **Numbering:** entries listed in ascending local-number order. Numbering starts at 1 for each H1 module and is sequential within the block.
- **Duplicate labels within a module** are allowed. If two distinct sources both compress to the same org name (e.g., two separate McKinsey publications), list both entries at their respective local numbers — do not dedupe.
- **Unused entries dropped.** A source present in the evidence pack but never cited in a given module's prose does not appear in that module's Sources block. It remains in the Source Registry (working artifact) only.
- **Cross-module references.** When a citation in module B's prose references a source also cited in module A, module B's Sources block gets its own entry for that source at module B's local number. Module A's block keeps its own entry. The label is identical across modules; the local numbers differ.

### Re-run / preserve-existing-superscripts behavior

When the input prose already contains superscript citations that resolve correctly against the new module-local source list (each in-prose superscript maps to an entry in that module's Sources block at the same local number), preserve them as-is. Renumber a module's citations only when:

1. Current numbering contradicts first-appearance order within the module.
2. Uncited entries need to be dropped, and doing so leaves gaps in the sequence.
3. The module does not yet have a Sources block and one must be created.

This protects the "preserve existing source-number mapping unless renumbering is required by section-local source lists" rule during fix-pass or re-run scenarios.

## Source Mapping Table (per module)

Keep as an internal traceability aid in the Traceability Layer (working artifact). Include when not all Source Registry IDs appear in the current module, so reviewers can verify which sources are active in this module. The mapping is per-module under the new model. Format:

```
### Source Mapping (per module)
| Module | Local # | Registry ID | Label |
|---|---|---|---|
| Module 1 | 1 | S01 | Example Org |
| Module 1 | 2 | S07 | Other Author |
| Module 2 | 1 | S01 | Example Org |
```

The Source Registry accumulates Registry IDs globally (S01, S02, … continuing across modules; IDs do not reset at module boundaries). Only the per-module Sources block's local numbering resets.

## Final

Strip all claim IDs from output prose.
