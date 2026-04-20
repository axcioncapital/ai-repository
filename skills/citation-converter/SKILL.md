---
name: citation-converter
description: >
  Converts report prose containing inline claim IDs into fully cited output
  with a per-H1-module `## Sources` block (Instruction A) or inline attribution (Instruction B),
  and produces a complete Citation Traceability Layer. Do NOT use for writing or
  rewriting prose (that's evidence-to-report-writer), for editorial decisions, or
  for fact-verification. Do NOT use when writing prose for the first time from
  evidence — evidence-to-report-writer can apply citations during initial writing.
  Use this skill only for standalone citation passes on already-written prose.
  Primary use case: applying citations to prose produced by evidence-to-report-writer
  with deferred citation conversion (claim IDs still inline).
---

## Role + Scope

Mechanical citation converter. Transform claim-ID-inline prose into publication-ready cited prose with a complete traceability appendix.

**In scope:** Converting inline claim IDs to formatted citations (Instruction A or B) · Applying citations to uncited prose by matching assertions to evidence pack claims (Fresh Citation mode) · Building Claim-to-Source Map, Supplementary Items Map, Known Absences, Completeness Check · Handling incomplete source metadata gracefully · Respecting exclusion tables for deliberately omitted claims.

**Out of scope:** Rewriting, restructuring, or editing prose · Adding or removing claims · Editorial emphasis · Generating prose · Fact-verification · Style or voice decisions.

## Prose Preservation Rule

Output prose must be character-identical to input except for four permitted change types:

1. Claim ID removal
2. Footnote insertion
3. Attribution insertion
4. Conflict/gap hedging language required by the citation instruction

Any other change — rewording, tightening, reordering, smoothing, compressing — is a violation. Do not "improve" the prose. Markdown heading markers and all structural formatting must be preserved exactly. Blank lines between paragraphs must be preserved. If inserting an inline attribution (Instruction B) cannot be done without rewording, append the attribution as a parenthetical or trailing clause rather than restructuring the original sentence.

## Modes

**Mode 1 — Claim-ID Conversion:** Prose contains inline claim IDs (e.g., `[Q8.1-C01]`). Map each to source metadata and apply the specified citation format.

**Mode 2 — Fresh Citation:** Prose lacks claim IDs. Match prose assertions to evidence pack claims by semantic similarity, then apply citations. Produce a Match Report with confidence ratings.

**Auto-detection:** If `[Qx.x-Cxx]` or `[Qx-Cxx]` patterns are found in input prose → Mode 1. Otherwise → Mode 2. If uncertain, ask.

## Inputs

1. **Prose Draft** (required) — The report prose to be cited. May contain inline claim IDs (Mode 1) or not (Mode 2).
2. **Evidence Pack / Synthesis Briefs** (required) — Source metadata for claims. Accepted formats: compressed synthesis briefs, gap-fill supplement metadata, full evidence packs. If the format is unrecognized, stop and ask the operator to clarify before proceeding.
3. **Citation Instruction** (required) — Either **A** (Internal Research — section-local `## Sources` block) or **B** (Client-Facing — inline attribution). Do not mix. If not specified, ask before proceeding. Do not default to either.
4. **Exclusion Table** (optional) — Claim IDs deliberately omitted from prose, with rationale. Not flagged as missing in the Completeness Check.
5. **Existing Traceability Layer** (optional) — If Source Registry and Claim-to-Source Map already exist from a prior run, accept and reuse. Skip Steps 1–2, run only Steps 3–4.
6. **Supplementary Evidence Items** (optional) — Items tagged `[SUPPLEMENTARY]` with gap type, finding, source, grade, and status. These appear in the Supplementary Items Map only, never in the main Claim-to-Source Map.

## Conversion Procedure

Process sequentially. Do not skip steps.

### Step 0 — Semantic Matching (Mode 2 only)

Run only when prose lacks claim IDs.

1. Extract every factual assertion from the prose — each sentence or clause that states a finding, number, comparison, or conclusion.
2. For each assertion, search the evidence pack for the best-matching claim.
3. Classify each match:
   - **High confidence:** Assertion closely mirrors a specific claim's text, numbers, or finding. Auto-cite.
   - **Medium confidence:** Assertion is consistent with a claim but paraphrased or combined. Auto-cite but flag in Match Report.
   - **Low confidence:** No clear single-claim match, or matches multiple claims ambiguously. Do not auto-cite. Flag for human review.
4. Present the Match Report to the operator and wait for approval before proceeding. Low-confidence matches must be resolved (confirmed, re-matched, or excluded) before citation conversion begins. This is a separate gate from the RELEASE ARTIFACT gate.
5. Assign temporary claim IDs to matched assertions so Steps 1–4 proceed normally.

### Step 1 — Build Source Registry (working artifact)

Build internally to enable Steps 2–3. Not included in final output — the Claim-to-Source Map and the per-module `## Sources` blocks (Instruction A) or inline Sources Consulted (Instruction B) cover its contents.

Extract all unique sources from the evidence pack. Assign sequential registry IDs (S01, S02, ...).

Record per source:

| Field | Rule |
|-------|------|
| Registry ID | Sequential: S01, S02, ... |
| Org/Author | From attribution line or source field |
| Title | From source metadata. If missing: construct as "[Org] — [topic context from claim]" |
| Date | From source metadata. If missing: "n.d." |
| Grade | High / Medium / Low from evidence metadata |
| Paywall | Yes / No. If unknown: omit |
| Supplementary? | Yes if from a SUPPLEMENTARY-tagged item. Otherwise No |

**Deduplication:** Same org + title + date = one registry ID. Different publications from the same org get separate IDs. When titles are constructed (not from metadata), deduplicate on org + date only. Two constructed titles from the same org with the same date (or both n.d.) share a registry ID unless claims clearly originate from different publications (e.g., different URLs in gap-fill metadata).

### Step 2 — Build Claim-to-Source Map

For each claim ID in the prose:

```
| Claim ID | Registry ID(s) | Grade | Summary |
|----------|---------------|-------|---------|
| Q8.1-C01 | S01, S03      | High, Medium | [brief claim summary] |
```

**Missing source metadata:** If a claim ID has no source details in the evidence pack, include it as: `Source: MISSING — requires remediation`. Flag in Completeness Check.

**Missing claim IDs threshold:** If >10% of claim IDs in prose have no corresponding entry in any provided evidence pack, stop and flag: "Evidence pack appears incomplete — [N] claim IDs unmatched. Verify correct packs are attached." Do not proceed until resolved.

**SUPPLEMENTARY items:** Not in this map. They go in the Supplementary Items Map only. Usage Type derives from the item's Gap Type: Framing → framing, Anchoring → anchoring, Adjacent context → adjacent context.

### Step 3 — Apply Citation Format

Read the relevant instruction reference before applying:
- Instruction A: read `references/instruction-a.md`
- Instruction B: read `references/instruction-b.md`

**Common rules (both instructions):**
- Work through the prose sequentially — do not jump around
- Follow the specified Instruction completely; do not mix A and B
- If a claim contains a specific number, name, or ranking → it needs attribution
- Every High or Medium grade claim must be traceable in the final output

### Step 4 — Completeness Check

Verify:

1. **Claim coverage:** Every claim ID from input prose appears in Claim-to-Source Map. Cross-reference exclusion table — excluded claims are expected absences.
2. **Citation trace:** Every High and Medium grade claim is traceable in cited prose.
3. **Supplementary coverage:** Every SUPPLEMENTARY item with `Status: Resolved` used in prose appears in Supplementary Items Map.
4. **Known absences:** Every SUPPLEMENTARY item with `Status: No usable result` has an entry in Known Absences with decision recorded.
5. **Clean prose:** No claim IDs remain (search for `[Q` pattern).
6. **No invented sources:** No source in Registry lacks an evidence pack entry (except MISSING-flagged).

List specific failures at the top of the Completeness Check section. If all pass: "All claims traced. All checks passed."

## Output Structure

Produce two separate markdown files:

**File 1 — Cited Prose** (`cited-prose-[section-name].md`)

The cited prose with claim IDs stripped and citations applied per the specified Instruction.

**File 2 — Traceability Layer** (`traceability-[section-name].md`)

```
## Internal: Citation Traceability Layer

### Claim-to-Source Map
| Claim ID | Registry ID(s) | Grade | Summary |

For multi-section processing, add a "Sections Used In" column. Optional for single-section runs.

### Supplementary Items Map
| Item # | Gap Type | Registry ID | Grade | Section Used In | Usage Type | Summary |
(If none: "No supplementary items in this conversion.")

### Known Absences
| Item # | Gap Type | Target Section | What Was Sought | Acknowledged in Prose? |
(If none: "No known absences.")

### Completeness Check
[Failures listed, or "All claims traced. All checks passed."]

### Sources (published) + Source Registry (internal)
[Per Instruction A: per-H1-module `## Sources` block with compact inline source index. See references/instruction-a.md for placement, label format, and numbering rules. The Source Registry is the working artifact — global Registry IDs (S01, S02, … continuing across modules) mapped to per-module local numbers.]
[Per Instruction B: Sources Consulted as inline attribution. See references/instruction-b.md.]

### Change Log
| Location | Change Type | Original Text | Modified Text | Rationale |
```

Change Type must be one of: `claim ID removal`, `source number insertion`, `attribution insertion`, `conflict/gap hedging`. Any other Change Type is a prose preservation violation.

**Fresh Citation mode adds:**

```
### Match Report
| Prose Assertion | Matched Claim ID | Confidence | Notes |
```

Write both files to the working directory or a path specified by the operator.

## Handling Incomplete Metadata

| Missing Field | Action |
|--------------|--------|
| Date | MM/YYYY where month is known, year-only otherwise, "c. YYYY" for approximations, "n.d." for unknown. Instruction B: omit year ("according to [Org]") |
| Title | Construct: "[Org] — [topic context from claim]" |
| URL | Include when available. If missing: omit. Do not invent |
| Paywall status | Omit flag. Do not guess |
| Grade | MISSING in Source Registry. Flag in Completeness Check |

Flag every constructed or missing metadata instance in Completeness Check.

## Scale Guidance

**Single invocation limit:** ~80 claim IDs and ~8,000 words of prose.

**Larger documents:** Process section by section. Pass the full Traceability Layer (File 2) plus the working Source Registry from the previous section as Input 5. The new section extends them — adding new Registry IDs, claim mappings, and Sources block entries while preserving existing ones. Source numbering resets at 1 for each H1 module in its published Sources block. The Source Registry (working artifact) accumulates Registry IDs across sections for traceability (S01, S02, … continuing globally — Registry IDs do NOT reset at module boundaries; only the published Sources block's local numbering resets). Each module's Sources block uses its own independent local numbering derived from first-appearance order in that module's prose.

**Approaching the limit:** Complete the current section cleanly. Flag remaining sections: "Sections [X–Y] pending — continue with this Traceability Layer as Input 5."

## Output Protocol

**Default mode: Refinement.** Before full conversion, present:

1. Claim-to-Source Map (complete)
2. Metadata gaps or flags
3. Fresh Citation mode: Match Report with confidence ratings
4. Confirmation of Instruction (A or B)

**Mode 2 sequencing:** The Match Report gate (Step 0) comes first. Present the Match Report and obtain operator approval before producing refinement deliverables 1–3 above.

Produce both files only after operator says `RELEASE ARTIFACT`.

## Quality Self-Check

Before delivering, verify:

- [ ] Every claim ID from input appears in output (cited or in exclusion table)
- [ ] No claim IDs remain in output prose
- [ ] Citation format matches specified Instruction — no mixing
- [ ] Sources numbering is per-module and per-unique-source — each module's block numbers in first-appearance order starting at 1; numbering resets at each H1 module boundary (A)
- [ ] Within a module's Sources block, duplicate labels are allowed (two distinct sources with the same compressed label at different local numbers); duplicate Registry IDs within one module are not (A)
- [ ] Sources block entries contain no quality flags or supplementary tags (A)
- [ ] Date format consistent in Source Registry (working artifact): MM/YYYY / year-only / "c. YYYY" / "n.d." (A). Dates do NOT appear in the published `## Sources` block — labels are org/author only (A)
- [ ] Sources block entries use compressed labels only — organization or author surname(s). No titles, italics, quotation marks, bold, URLs, publication dates, access dates, or paywall annotations (A)
- [ ] Source Mapping table (per-module) included in Traceability Layer when needed (A)
- [ ] Multi-source claims: space-separated superscripts (`¹ ² ³`), never middle-dot `˒` or commas (A)
- [ ] Each H1 module has its own `## Sources` block placed after its last content line, separated by `---` on its own line (A)
- [ ] When a module's last content is a table, `---` sits immediately after the table's final row with no blank line between (A)
- [ ] No global `## Bibliography` or `## References` block exists (A)
- [ ] Source numbering resets at each H1 module, starting at 1 in first-appearance order (A)
- [ ] Low-grade sources excluded from prose, present in Sources Consulted (B)
- [ ] Supplementary items in Supplementary Items Map only
- [ ] Known Absences table complete with decisions
- [ ] Completeness Check passes or failures listed
- [ ] No invented sources or metadata
- [ ] Change Log present with every modification listed; no unauthorized Change Types
- [ ] Prose preservation: output matches input except at Change Log locations
- [ ] Markdown headings and blank lines preserved
- [ ] Sources block entries are on a single line separated by ` · ` (space + U+00B7 middle dot + space); no blank lines between entries; no bold, italic, quotation marks, URLs, or dates in labels (A)
- [ ] Fresh Citation mode: Match Report included, low-confidence matches not auto-cited

## Edge Cases

- **Claim ID with no source metadata:** Include in cited prose. Mark `MISSING — requires remediation` in Claim-to-Source Map. Flag in Completeness Check. Do not invent attribution.
- **Cross-module citation:** A source cited in module A and also in module B gets its own entry in each module's Sources block at that module's local number (A). The compressed label is identical across modules; the local numbers differ. This is the normal case under the section-local model, not a duplication defect. If two distinct sources from the same org are both cited cross-module, both appear in each module's Sources block with identical labels but different local numbers — this is expected and not a defect. The Source Registry (working artifact) tracks the shared Registry ID across modules; note all modules each source is used in via the Source Mapping table.
- **Unused evidence pack entries:** Sources present in evidence but never cited in prose do not appear in any Sources block. They appear only in the Source Registry (working artifact).
- **Re-run / preserve-existing-superscripts:** If the input prose already contains superscript citations that resolve correctly against the new module-local source list (each in-prose superscript maps to an entry in that module's Sources block at the same local number), preserve them as-is. Renumber a module's citations only when (a) current numbering contradicts first-appearance order within the module, (b) uncited entries need to be dropped and doing so leaves gaps in the sequence, or (c) the module does not yet have a Sources block and one must be created.
- **Exclusion table provided:** Excluded IDs are expected absences. Record in Completeness Check.
- **Re-run with existing traceability layer:** Accept as Input 5. Skip Steps 1–2. Run Steps 3–4 only.
- **Supplementary item without tag:** Treat as supplementary, flag missing tag in Supplementary Items Map.
- **Conflicted claims:** Follow the Instruction's conflict rules. Do not resolve — present both sides.
- **Document exceeds limit:** Stop at clean section boundary. Output everything processed. Flag remaining sections.
- **>20% claims missing source metadata:** Flag the issue. Ask whether to proceed with heavy MISSING flags or wait for better metadata. Do not invent attributions.

If the provided evidence pack is insufficient to answer confidently about a source's identity or metadata, say so. Leave the gap visible rather than constructing plausible-sounding entries.
