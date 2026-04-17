---
name: formatting-qc
description: >
  QC pass on a formatted prose module. Checks formatting integrity (did the
  formatter break anything), visual rhythm (wall-of-text and over-formatting
  detection), standalone coherence (orientation, closure, cross-references),
  and footnote integrity. Produces flagged items only — no rewriting. Use
  after prose-formatter and h3-title-pass have run, before final review.
  Do NOT use for prose quality review (chapter-prose-reviewer), compliance
  checking (prose-compliance-qc), or applying formatting (prose-formatter).
---

# Formatting QC

QC pass on one formatted prose module. Output is a **QC report** — flagged items only, grouped by check. No rewriting, no prose edits.

---

## Pipeline Position

```
prose-formatter → h3-title-pass → [this skill] → operator review
```

This is a verification gate. It confirms that formatting operations improved readability without introducing defects.

## Inputs

| Input | Required | Notes |
|---|---|---|
| Formatted module prose | Required | The post-formatting, post-H3 prose file |
| Formatting change log | Required | The change log produced by prose-formatter (lists every operation applied) |
| Style reference | Optional | If provided, check formatting consistency against it |
| Deferred items list | Optional | Items flagged as deferred during formatting — do not re-flag these |

If no formatted module is provided: halt. Nothing to QC.

## Reasoning Constraints

- Flag issues only when clearly evidenced. Do not invent findings to appear thorough.
- If a check passes cleanly, state that explicitly — do not manufacture observations to fill a category.
- Do not re-flag items marked as deferred in the formatting change log or a provided deferred items list.
- Do not suggest prose rewrites. Findings describe what is wrong with the formatting, not how to rewrite the content.

---

## Checks

Run in this order.

### 1. Formatting Integrity

Confirm that no formatting operation has introduced defects:

- **Prose flow:** No sentence fragments created by list conversion or paragraph splitting. No orphaned clauses or dangling references.
- **Bold/italic consistency:** Bold and italic applied per the same rules throughout. No decorative bolding (whole sentences, section summaries). No emphasis stacking (bold + italic on same phrase). Key terms bolded on first use within each H2 section, not repeatedly.
- **List consistency:** All lists have lead-in sentences. Parallel grammatical structure within each list. Bullets for unordered items, numbers for sequences/rankings only. No lists exceeding ~6 items without sub-grouping. No nested bullets beyond one level.
- **Table consistency:** Every table has a title/caption above it. Header row present. Text columns left-aligned, numeric columns right-aligned. Original prose retained above every inserted table. No tables replacing prose.
- **Paragraph splits:** No splits mid-sentence or mid-clause. Split points occur at natural topic shifts.
- **Horizontal rules:** Present between H2 sections, absent between H3 subsections within the same H2.

### 2. Visual Rhythm

Detect both under-formatting (walls of text) and over-formatting (structural clutter):

- **Under-formatted:** Flag any block of ~600+ consecutive words with no list, table, heading, horizontal rule, or other structural element. These are walls of text that formatting should have broken up.
- **Over-formatted:** Flag any passage where 3 or more structural elements (list, table, callout, horizontal rule) appear within ~300 words of each other. Dense structural elements compete for attention and reduce readability.
- **Heading density:** Flag H2 sections shorter than ~200 words (heading overhead not justified) or longer than ~2,000 words without H3 subdivision.

### 3. Standalone Coherence

Confirm the module works as a self-contained unit:

- **Orientation:** The module opens with adequate context for the reader — establishes what the section covers and why it matters. No cold starts that assume the reader just finished the preceding module.
- **Closure:** The module closes cleanly — with an implication, conclusion, or forward reference, not a trailing detail or orphaned observation.
- **Cross-references:** All references to other modules or sections are explicit (e.g., "as Section 2.1 establishes" rather than "as noted earlier" or "as discussed above"). Flag vague cross-references.
- **Undefined terms:** Flag terms or acronyms used without definition on first appearance in this module.

### 4. Footnote Integrity

- Footnote numbering is sequential and unbroken throughout the module (1, 2, 3... not 1, 3, 4 or 1, 2, 2).
- Every footnote marker in the body has a corresponding footnote entry.
- Every footnote entry has at least one marker in the body.
- Footnote content is substantive (not empty or placeholder).

If the module contains no footnotes, state "No footnotes present" and mark this check as N/A.

### 5. Mechanical Trigger Compliance

Verify that the prose-formatter's Mechanical Triggers produced the expected formatting outcomes. Each sub-check maps to a specific trigger and to a specific Doc 2 miss pattern that this check is designed to catch.

- **Named framework → list check (Trigger #1 + Operation 2 non-exception):** Flag any "N items named in sequence" inline enumeration that remains in prose form. Look for phrases like "N tests," "N components," "N properties," "N constraints," "N criteria," "N principles" followed by an enumeration that was not converted to a list.
- **Category comparison → table check (Trigger #2 + Operation 3 trigger a):** Flag any passage comparing N named categories across M reference criteria (e.g., provider types across mandate / conflict / fee / coverage) that is not tabulated, or where the comparison is carried entirely in prose without a reference table beneath.
- **Classification triad / coded-category set → table check (Operation 3 triggers b and c):** Flag scope-classification triads (In scope / Out of scope / Conditionally in) and coded category sets with repeated field structure (CB1–CB4, E1–E4, R1–R5) that were left as bold labels rather than tabulated.
- **Bold class-consistency check (Operation 1 class-consistency rule):** Flag uneven bolding of figures within the same semantic class (e.g., 54% bolded but 11% not, or €5–25M bolded but adjacent monetary ranges not). Either all figures of a class in a section are bolded, or none are — mixed is a finding.
- **Named-framework anchor check (Trigger #4 + Operation 1 named-framework rule):** Flag named enumerated frameworks (Test 1–N, Principle 1–N, R1–RN, CB1–CBN) where some anchors are bolded and others are not, or where no anchors are bolded despite being named items.
- **Multi-block subsection check (Trigger #3):** Flag any H3 subsection that carries multiple distinct formatting units (different topics, different formatting elements, bold labels doing heading work) without appropriate separation — no SPLIT verdict was proposed, no paragraph break separates the blocks, and the subsection visibly carries material that should have been split.
- **Multi-job paragraph check (Trigger #5):** Flag any paragraph carrying a framework + its exceptions + its implications (or an analogous framework + scenarios + triggers + qualification cluster) that was not split in Operation 4. The threshold is job-count, not word-count — a 120-word paragraph with three distinct jobs is a finding.

Each finding under this check is SUBSTANTIVE. The check is designed to catch the specific patterns the Mechanical Triggers were introduced to prevent; if a pattern is flagged here, the trigger did not fire or was overridden.

---

## Output Format

```
# Formatting QC Report — [Module Title]

## Summary
Checks passed: [N] / 5
Total findings: [N] (SUBSTANTIVE: [N], NON-SUBSTANTIVE: [N])

## 1. Formatting Integrity
[Finding ID] | Location | Description | Severity
...
[or: "All formatting integrity checks passed."]

## 2. Visual Rhythm
[Finding ID] | Location | Description | Severity
...
[or: "Visual rhythm within acceptable range throughout."]

## 3. Standalone Coherence
[Finding ID] | Location | Description | Severity
...
[or: "Module opens, closes, and cross-references cleanly."]

## 4. Footnote Integrity
[Finding ID] | Location | Description | Severity
...
[or: "No footnotes present — N/A." / "Footnote numbering sequential and complete."]

## 5. Mechanical Trigger Compliance
[Finding ID] | Location | Description | Severity
...
[or: "All Mechanical Triggers produced expected outcomes — no miss patterns detected."]
```

## Finding Format

Each finding:
- **ID:** `FI-[N]`, `VR-[N]`, `SC-[N]`, `FN-[N]`, `MTC-[N]` (by check category — Formatting Integrity, Visual Rhythm, Standalone Coherence, Footnote, Mechanical Trigger Compliance)
- **Location:** Section name, heading, or approximate word position
- **Description:** What the issue is. Be specific — name the element, quote the problematic text if short.
- **Severity:**
  - `SUBSTANTIVE` — affects readability, comprehension, or document credibility. Must be resolved before the module is finalized.
  - `NON-SUBSTANTIVE` — minor inconsistency or polish item. Recommended but not blocking.

## Severity Definitions

| Severity | Definition |
|---|---|
| SUBSTANTIVE | Broken prose flow, missing cross-references, walls of text that impede comprehension, sequential footnote errors, Mechanical Trigger miss patterns (named framework in prose, category comparison without table, bold class inconsistency, multi-block subsection, multi-job paragraph). Must fix. |
| NON-SUBSTANTIVE | Minor inconsistencies in emphasis patterns, slightly long sections without H3, cosmetic spacing issues. Recommended. |

## Failure Behavior

- **Missing formatted module:** Halt. Nothing to QC.
- **Missing change log:** Proceed, but note that deferred-item filtering cannot be applied. Flag this at the top of the report.
- **Module has no formatting at all:** Flag as a single SUBSTANTIVE finding: "Module appears unformatted. Confirm prose-formatter has been applied before running formatting QC."
