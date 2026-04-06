---
name: prose-formatter
description: >
  Applies mechanical formatting to prose documents without changing any words.
  Six operations: bold/italic standardization, list conversion, table insertion,
  paragraph length management, horizontal rules, and spacing normalization.
  Use when a prose document is complete and needs visual hierarchy for
  readability — especially dense analytical or strategic documents with no
  existing formatting. Triggers on requests like "format this document,"
  "apply formatting pass," "add visual hierarchy," "formatting standards."
  Do NOT use for prose editing, rewriting, or structural reorganization —
  this skill changes markup only, never words.
---

## Role + Scope

Mechanical formatting. Apply visual hierarchy to prose documents through emphasis markup, list conversion, reference tables, paragraph management, and spacing standardization. Zero prose changes — every word in the output must match the input exactly, with only markdown formatting added or adjusted.

**Hard constraints:**
- Do not change any words, phrases, or sentences.
- Do not reorder paragraphs or sections.
- Do not add editorial content, commentary, or meta-descriptions.
- Do not change headings (text or level).
- When converting prose enumerations to lists, preserve the exact wording of each item.
- When inserting tables, retain the original prose in full above the table.

**Sibling skills:**
- Runs after prose production is complete (after `evidence-to-report-writer`, `decision-to-prose-writer`, or equivalent).
- Does not replace `chapter-prose-reviewer` (evaluates narrative quality; this skill does not evaluate).
- Does not replace `specifying-output-style` (defines voice and document spec; this skill applies mechanical formatting within those parameters).

## Inputs

### Input 1: Prose Document (required — blocking)

The complete prose document to format. Must be final or near-final prose — formatting a draft mid-iteration wastes effort.

If missing: Do not proceed.

### Input 2: Style Reference (optional)

A style reference or document specification covering voice, emphasis conventions, or formatting preferences specific to this document set. If provided, the style reference's rules take precedence over this skill's defaults where they conflict.

If missing: Proceed using this skill's default rules.

## Operations

Execute operations in the order listed. Each operation is applied across the full document before moving to the next. Operation 6 (spacing) always runs last.

Progress: [ ] Op 1: Bold/Italic [ ] Op 2: Lists [ ] Op 3: Tables [ ] Op 4: Paragraphs [ ] Op 5: Rules [ ] Op 6: Spacing [ ] Change log

**Competing operations:** If a passage qualifies for both list conversion (Op 2) and table insertion (Op 3), prefer the table when items have 2+ parallel attributes. Use a list when items share only one attribute. When uncertain, defer and flag.

---

### Operation 1: Bold/Italic Standardization

**What to bold:**
- Key terms on first use within each major section (H2 boundary). "First use" means the first occurrence where the term carries analytical weight — not every mention.
- Decision-critical numbers: specific percentages, monetary thresholds, or quantities that anchor an argument (e.g., "**3% sourcing adoption rate**," "**EUR 5-25M**").
- Analytical conclusions stated as standalone claims — the sentence that delivers the section's finding. Bold the core phrase, not the entire sentence.

**What to italicize:**
- Document, report, or study titles referenced in prose.
- Defined terms on first use when the term is being introduced with a specific meaning.
- Light de-emphasis for parenthetical qualifications or asides, where italic signals "this is a caveat, not the main point."

**What NOT to format:**
- No decorative bolding — never bold whole sentences, section summaries, or rhetorical phrases.
- No bold on headings (markdown heading syntax handles emphasis).
- No bold on proper nouns unless they are also key terms on first use.
- No italic on foreign words that are standard in the domain (e.g., no italic on "ad hoc" in a PE context).
- No emphasis stacking (bold + italic on the same phrase).

**Judgment call:** When uncertain whether a term qualifies as a "key term," err toward not bolding. Under-emphasis is less distracting than over-emphasis.

**Example:**
Before: `The 3% sourcing adoption rate across Nordic mid-market PE funds suggests that systematic sourcing remains rare.`
After: `The **3% sourcing adoption rate** across Nordic mid-market PE funds suggests that systematic sourcing remains rare.`

---

### Operation 2: Bullet & List Conversion

**When to convert:**
- Prose enumerations of 3+ genuinely parallel items. "Parallel" means the items share the same grammatical role and the same relationship to the lead-in statement.
- Steps or sequences described inline that would be clearer as numbered items.

**When NOT to convert:**
- Analytical argument chains where the prose builds a cumulative case — even if they enumerate 3+ elements. If removing one item would break the argument's logic, it is a chain, not a list.
- Enumerations where the prose between items carries analytical commentary that would be lost in list form.
- Two-item enumerations — leave as prose.

**List rules:**
- Bullets for unordered parallel items. Numbered lists for steps, ranked items, or ordered sequences only.
- Maximum ~6 items per list. Longer lists should be split into sub-groups with sub-headings or converted back to prose.
- No nested bullets beyond one level. If deeper nesting is needed, restructure.
- Every list must have a lead-in sentence ending in a colon.
- Parallel grammatical structure enforced within each list — all items start with the same part of speech and follow the same syntactic pattern.
- Preserve the exact wording of each enumerated item when converting from prose to list.

**Example:**
Before: `The service covers three core activities: CIM brief production, deal screening support, and portfolio monitoring.`
After:
```
The service covers three core activities:
- CIM brief production
- Deal screening support
- Portfolio monitoring
```

---

### Operation 3: Table Insertion

**When to insert:**
- 3+ items compared across 2+ attributes in prose. The prose describes a comparison that a reader would naturally want to scan across items.
- The prose is retained in full. The table is inserted directly beneath the relevant prose paragraph as a reference summary layer.

**When NOT to insert:**
- Simple lists (items with a single attribute — use Operation 2 instead).
- Comparisons where the analytical value is in the prose narrative, not in the attribute comparison. If the table would strip out the reasoning that makes the comparison valuable, skip it.
- Single-attribute rankings or orderings.

**Table rules:**
- Table title/caption on the line immediately above the table, formatted as: `*Table: [descriptive title]*`
- Header row always present.
- Text columns: left-aligned. Numeric columns: right-aligned.
- Keep tables concise — 3-5 columns maximum. If more attributes are needed, split into multiple tables.
- Use "---" for cells where an attribute does not apply, rather than leaving blank.

**Disguised tables:** If prose contains a comparison pattern (e.g., "X has A, B, C; Y has D, E, F") but auto-conversion would lose analytical nuance, flag it in the change log as a "table candidate — deferred for review" rather than converting.

---

### Operation 4: Paragraph Length Management

**Threshold:** ~150 words.

**Split policy:**
- **Auto-split** paragraphs that exceed the threshold AND contain a clear topic shift — a point where the paragraph moves from one sub-argument to another. The split point is where a reader would naturally pause.
- **Flag for review** paragraphs that exceed the threshold but form a single sustained argument with no natural break. These are listed in the change log as "long paragraph — flagged, single-argument structure."
- **Never split** mid-sentence or mid-clause.

**Merge policy:**
- Flag orphan single-sentence paragraphs (unless they serve as deliberate emphasis — a standalone conclusion or transition). Flagged, not auto-merged.

**Word count note:** Count is approximate. A paragraph at 155 words with no natural break is fine. A paragraph at 145 words with a clear topic shift is a split candidate. Use judgment, not a hard cutoff.

---

### Operation 5: Horizontal Rules & Section Breaks

**Rules:**
- Insert `---` (horizontal rule) between major H2 sections as a visual separator.
- No `---` between H3 subsections within the same H2.
- No `---` immediately after an H1 title (unless the document already uses this pattern consistently).
- One blank line before and after every `---`.

---

### Operation 6: Spacing Normalization (runs last)

**Rules:**
- One blank line between paragraphs (not zero, not two).
- One blank line between a heading and its first paragraph.
- No trailing whitespace on any line.
- No double spaces within sentences.
- No blank lines within a list or table.
- One blank line before and after lists, tables, and horizontal rules.
- Consistent line break handling: if the document uses hard-wrapped lines, preserve that pattern. If it uses one-line paragraphs, preserve that.

---

## Output

The skill produces two artifacts:

### Artifact 1: Formatted Document

The complete document with all six operations applied. Written to the same directory as the input, following the project's versioning convention (new file, not overwriting). Expected length: input length plus ~5-10% from added markup (lists, tables, horizontal rules). Word count should match the input exactly — only markup changes.

### Artifact 2: Change Log

A structured log of every change made, organized by operation. Format:

```
FORMATTING CHANGE LOG
Document: [filename]
Date: [date]
Operations applied: 1-6

---

OPERATION 1: Bold/Italic
- Line [n]: Bolded "[term]" (key term, first use in section)
- Line [n]: Italicized "[title]" (document title reference)
[...]

OPERATION 2: Lists
- Lines [n-m]: Converted 4-item prose enumeration to bulleted list
  Lead-in: "[lead-in sentence]"
- FLAGGED: Lines [n-m] — ambiguous structure, not converted
[...]

OPERATION 3: Tables
- After line [n]: Inserted comparison table ([title])
  Columns: [col1], [col2], [col3]
- DEFERRED: Lines [n-m] — disguised table, flagged for review
[...]

OPERATION 4: Paragraph Length
- Line [n]: Split paragraph at "[first words of new paragraph]..." (~180 words -> ~95 + ~85)
- FLAGGED: Line [n] — ~170 words, single-argument structure, no split
[...]

OPERATION 5: Horizontal Rules
- Between lines [n] and [m]: Added ---
[...]

OPERATION 6: Spacing
- [count] trailing whitespace removals
- [count] double-space corrections
- [count] blank-line adjustments
[...]
```

## Failure Behavior

- **Missing prose document (Input 1):** Halt. Do not proceed — there is nothing to format.
- **Prose is clearly mid-draft (incomplete sections, placeholder text):** Flag to the operator. Formatting a draft mid-iteration wastes effort. Proceed only if the operator confirms.
- **Style reference conflicts with default rules:** Style reference takes precedence. Apply the style reference's rule and log the override in the change log with a note: "Default overridden by style reference."
- **Ambiguous formatting candidates:** When uncertain whether content should be converted (e.g., borderline list candidate, disguised table), do not convert. Flag in the change log as deferred for review.
- **Document already heavily formatted:** Apply only incremental corrections (spacing normalization, consistency fixes). Do not reformat existing emphasis or list structures unless they violate the style reference.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires the full document in context. For very long documents (>8k words), process one H2 section at a time to maintain accuracy.
- **Sequence:** Runs after prose-compliance-qc. Runs before h3-title-pass. The operator manages this sequence.

## Bias Countering

- **Under-format rather than over-format.** Dense prose with selective emphasis is more readable than prose with bold on every third line. When in doubt, skip the emphasis.
- **Lists are not always better than prose.** A well-written paragraph that enumerates four items with analytical commentary between them is often superior to a bulleted list that strips the commentary. Convert only when the list form genuinely improves scanability without losing analytical content.
- **Tables supplement, never replace.** The temptation to convert a rich prose comparison into a clean table is strong. Resist it — insert the table as a reference layer beneath the prose, never as a replacement.
- **Respect the author's paragraph structure.** Long paragraphs may be long for a reason — the argument demands sustained attention. Flag rather than split when the structure is deliberate.
