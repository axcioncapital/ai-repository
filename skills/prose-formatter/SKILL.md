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

Progress: [ ] Pre-scan (Mechanical Triggers) [ ] Op 1: Bold/Italic [ ] Op 2: Lists [ ] Op 3: Tables [ ] Op 4: Paragraphs [ ] Op 5: Rules [ ] Op 6: Spacing [ ] Change log

**Competing operations:** If a passage qualifies for both list conversion (Op 2) and table insertion (Op 3), prefer the table when items have 2+ parallel attributes. Use a list when items share only one attribute. When uncertain, defer and flag.

### Mechanical Triggers (pre-scan)

The triggers below are mandatory decisions, not interpretive calls. Run them as a pre-scan across the full document before Operation 1. When a pattern is detected, the mapped operation is applied. The "when uncertain, defer" fallback and the Bias Countering guidance do not override a fired trigger.

Record the pre-scan result as a trigger-hit list (trigger number, document location, brief description). The list is an input to the downstream operations and to the h3-title-pass step.

1. **Five or more parallel items in prose** → convert to list (Operation 2).
2. **Category comparison across repeated dimensions** (named categories compared against the same reference criteria) → insert table (Operation 3).
3. **One subsection contains multiple internal blocks** (different topics, different formatting units, bold labels doing heading work) → resolve as a SPLIT verdict in the h3-title-pass step of the same pass (see cross-skill handoff below).
4. **Bold appears only on labels but not on named frameworks** (Test 1–N, Principle 1–N, Rule R1–RN, Category CB1–CBN inline) → normalize per Operation 1's named-anchor rule.
5. **Paragraph carries framework + its exceptions + its implications** in one block → split (Operation 4).

**Cross-skill handoff (trigger #3):** The pre-scan runs first in the merged Phase 2 sub-agent. Trigger #3 hits produce a list of multi-block subsections with block boundaries identified (line references and a one-line description of each block). During the h3-title-pass operation later in the same pass, these hits become SPLIT verdict candidates. This is not an inter-agent flag — it is an in-pass handoff within one sub-agent call. The prose-formatter pre-scan output includes the list; the h3-title-pass operation consumes it.

Operation 1 may also detect pseudo-heading bold labels during its own pass (see Operation 1's "What NOT to format"). When that happens, the label is added to the trigger #3 hit list so h3-title-pass consumes it via the same handoff mechanism — collapsing pre-scan and Op-1 detection into a single handoff path.

---

### Operation 1: Bold/Italic Standardization

**What to bold:**
- Key terms on first use within each major section (H2 boundary). "First use" means the first occurrence where the term carries analytical weight — not every mention.
- Decision-critical numbers: specific percentages, monetary thresholds, or quantities that anchor an argument (e.g., "**3% sourcing adoption rate**," "**EUR 5-25M**").
- Analytical conclusions stated as standalone claims — the sentence that delivers the section's finding. Bold the core phrase, not the entire sentence.
- **Named framework anchors** — when a section names an enumerated framework inline (Test 1–N, Principle 1–N, Rule R1–RN, Category CB1–CBN, Deliverable 1–N), bold each named anchor (**Test 1**, **Test 2**, etc.), whether the framework is presented as prose or as a list. This prevents the "bold on labels but not on named frameworks" failure (Mechanical Trigger #4).

**Class-consistency rule:** If bolding one figure of a class (e.g., a percentage, a monetary value, a count, a duration) in a section, apply the same treatment to all figures of the same class in that section — or to none. Mixed bolding within a class (e.g., bolding **54%** in one sentence and leaving 11% unbolded two sentences later) is prohibited. When deciding which way to resolve the class, default to bolding only the decision-critical anchors per the "What to bold" rule above; downgrade the rest to plain.

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
- **No pseudo-heading bolding.** When a bold label introduces a visually separated block inside an H3 subsection, and the block contains materially different content from the surrounding blocks (different topic, different formatting unit, or the label is acting as a mini-heading for a self-contained passage such as a client-facing quote), do NOT apply bold to that label. Flag the label as a SPLIT candidate for the h3-title-pass step. If the label was not already identified in the Mechanical Triggers pre-scan (trigger #3), add it to the trigger #3 hit list now so h3-title-pass consumes it via the same handoff mechanism. This prevents double-formatting — where Operation 1 bolds a label that h3-title-pass then promotes to an H3, producing both bold and H3 on the same text.

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

**Non-exception (mandatory conversion — overrides the "chain" exception):** When prose states "N tests," "N components," "N properties," "N constraints," "N criteria," "N principles," or similar countable framework language and then enumerates them, this is a list, not a chain — even if the items appear to be connected by prose. Convert to a bulleted or numbered list. If N > 6, split into sub-groups under sub-headings per the list-maximum rule below, rather than producing a single list that exceeds 6 items. This is the explicit resolution of Mechanical Trigger #1 and the "Five Coherence Tests" / "six operational components" / "three structural properties" failure pattern.

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

**Mandatory insertion triggers (override defer default):**
- (a) **Named categories compared across reference criteria** — e.g., provider-type A vs. provider-type B vs. provider-type C compared across mandate authority, conflict architecture, fee calibration, and coverage. This is Mechanical Trigger #2 and is the explicit resolution of the §5 "positioning comparison in prose" failure pattern.
- (b) **Scope-classification triads** — In scope / Out of scope / Conditionally in scope, with items distributed across the three classifications. Use a compact 2-column table (classification, items) or a 3-column table (category, status, rationale) depending on whether per-item rationale exists in the prose.
- (c) **Coded category sets with repeated field structure** — e.g., CB1–CB4 (Client Fit Boundaries), E1–E4 (Permanent Structural Exclusions), R1–R5, or any numbered category set where each item is described using the same field schema. Use a compact table whose columns correspond to the repeated fields.

When any of triggers (a)–(c) fires, the existing "disguised tables — defer for review" fallback and the "when uncertain, defer and flag" default do NOT apply. The table is inserted. Reserve "defer" for table candidates that do not satisfy a named trigger.

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
- **Multi-job split (mandatory, fires regardless of word count)** — if a single paragraph carries a framework *and* its exceptions *and* its implications (or an analogous framework + scenarios + triggers + qualification cluster), split at the framework/exception boundary. The threshold does not apply — a 120-word paragraph that carries three distinct jobs still splits. This is Mechanical Trigger #5 and the explicit resolution of dense-scenario-block and comparison-heavy-block failure patterns.
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
Operations applied: Pre-scan + 1-6

---

OPERATION 0: Mechanical Triggers Pre-scan
- Trigger #1 (5+ parallel items → list): [FIRED at lines [n-m] — "[brief description]"] or [NOT FIRED]
- Trigger #2 (category comparison → table): [FIRED at lines [n-m] — "[brief description]"] or [NOT FIRED]
- Trigger #3 (multi-block subsection → SPLIT): [FIRED at lines [n-m] — "[subsection name, block boundaries]"] or [NOT FIRED]
- Trigger #4 (bold on labels not frameworks → normalize): [FIRED at lines [n-m] — "[framework name]"] or [NOT FIRED]
- Trigger #5 (paragraph carries framework + exceptions + implications → split): [FIRED at lines [n-m] — "[brief description]"] or [NOT FIRED]
- Op-1 pseudo-heading additions to trigger #3 hit list (if any): [Line [n]: "[label text]" — added to trigger #3 hit list] or [none]

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

The directives below apply **only when no Mechanical Trigger has fired** (see the Mechanical Triggers section at the top of Operations). When a trigger fires, the mapped operation is mandatory — these bias-countering defaults do not override it.

- **Under-format rather than over-format when the choice is interpretive.** Dense prose with selective emphasis is more readable than prose with bold on every third line. When in doubt and no Mechanical Trigger has fired, skip the emphasis. When a Mechanical Trigger fires, this default does not apply — apply the mapped operation.
- **Lists are not always better than prose when no Mechanical Trigger has fired (see Mechanical Triggers section above).** A well-written paragraph that enumerates four items with analytical commentary between them is often superior to a bulleted list — but when Mechanical Trigger #1 (5+ parallel items) or the Operation 2 named-framework non-exception fires, convert. The Mechanical Triggers section governs; this directive applies only when no trigger has fired. Commentary can remain as sentences introducing or following the list.
- **Tables supplement, never replace.** The temptation to convert a rich prose comparison into a clean table is strong. Resist it — insert the table as a reference layer beneath the prose, never as a replacement.
- **Respect the author's paragraph structure unless it carries multiple distinct jobs.** Long paragraphs may be long for a reason — the argument demands sustained attention. Flag rather than split when the structure is deliberate. However, when Mechanical Trigger #5 fires (framework + exceptions + implications in one paragraph), split regardless of word count.
