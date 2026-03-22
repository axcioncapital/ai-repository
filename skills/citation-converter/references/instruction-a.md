# Instruction A — Internal Research (Footnotes)

## Footnote Numbering

- Footnote numbers correspond to **unique sources**, not to individual claims. Each distinct source (unique org + title + date combination) receives one footnote number, assigned sequentially starting at ¹.
- The first time a source supports a claim in the prose, it receives a new footnote number. Every subsequent claim backed by the same source reuses that number.
- **Rendering:** Use Unicode superscript characters (¹²³⁴⁵⁶⁷⁸⁹⁰) for all footnote references, both inline and in bibliography entry numbers. Do not use HTML `<sup>` tags — these render as literal text in markdown output.

## Placement Rules

- Superscript immediately after the punctuation that closes the cited unit: after the period when the full sentence is the cited claim, after the clause-ending punctuation (comma, semicolon, colon) when citing a mid-sentence clause. Never before punctuation.
- Multi-source claims: combine the relevant source numbers in a single superscript (e.g., ¹˒³)
- Paywalled sources: append `[preview only]` after the source entry in the bibliography

## Conflict and Gap Handling

- Conflicted claims: footnote both sides, acknowledge discrepancy in prose
- Known gaps: state limitation in prose with appropriate hedging

## Supplementary Item Citation

- Supplementary sources are treated identically to any other source in footnotes — they receive a source number following the same per-source numbering rules
- No in-prose signal distinguishes supplementary from core sources; supplementary status is recorded only in the Traceability Layer (Supplementary Items Map)

## Bibliography

- **Deduplication:** Each unique source appears once. Multiple footnotes citing the same source share one bibliography entry number.
- **Entry numbering:** Unicode superscript (e.g., ¹, ²⁷), not square brackets.
- **Entry format:**
  `²⁷ **Author/Org,** *"Source Title,"* MM/YYYY. URL`
  - Author: **Bold.**
  - Title: *Italic*, wrapped in quotation marks.
  - Date format: MM/YYYY where month is known. Year-only where only year is available. "c. YYYY" for approximations. "n.d." for unknown.
  - URL: Include when available from evidence metadata. Omit when missing — do not invent.
- No quality flags (primary/secondary/estimate) in bibliography — these remain in the Traceability Layer only.
- No supplementary tags in bibliography — these remain in the Traceability Layer only.
- Paywalled sources: append `[preview only]` after the date.
- Order: ascending by bibliography entry number.
- Each bibliography entry must be separated by a blank line so that markdown renderers treat them as distinct lines rather than a single wrapped paragraph.

## Footnote-to-Source Mapping Table

Include when not all bibliography entry numbers appear in the current section's prose (e.g., in multi-section documents where some sources are only cited in other sections), so readers can verify which sources are active in this section. Format:

```
### Footnote-to-Source Mapping
| Prose Footnote | Bibliography Entry |
|---|---|
| 1 | 1 |
| 2 | 1 |
| 3 | 2 |
```

## Final

Strip all claim IDs from output prose.
