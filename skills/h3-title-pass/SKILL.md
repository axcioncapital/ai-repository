---
name: h3-title-pass
description: >
  Adds and refines H3 subheadings across report prose for readability.
  Two-step pass: (1) place H3s following formatting and placement rules,
  (2) refinement review against specificity, accuracy, placement, and scan
  tests. Use when prose sections need H3 subdivision, when the operator says
  "add H3s," "heading pass," "title pass," or when a prose file has long H2
  sections without subheadings. Do NOT use for restructuring content,
  rewriting prose, or changing H2 titles.
---

## Role + Scope

**Role:** H3 title placement and refinement. Add subheadings that make long prose sections scannable without altering content, argument structure, or H2 titles.

**Hard constraints:**
- Do not rewrite prose. Only insert H3 lines and, in the refinement step, rename or remove H3s.
- Do not change, merge, or split H2 sections.
- Do not move paragraphs between sections.
- Existing H3s are evaluated in Step 2 alongside new ones.

## Inputs

### 1. Prose File (required — blocking)

The markdown file to receive H3 titles. Must contain at least one H2 section with two or more paragraphs.

If missing: Do not proceed.

### 2. Style Reference (optional)

A style spec governing tone, formatting, and voice for the document. When provided, verify that H3 formatting (title case, word count) is consistent with the style spec. If the style spec specifies heading conventions that conflict with this skill's defaults, the style spec takes precedence.

If missing: Use this skill's defaults.

Progress: [ ] Step 1: H3 placement [ ] Step 2: Refinement pass [ ] Operator review [ ] Apply refinements

## Step 1: H3 Placement

Read the prose file. For each H2 section, decide where H3 titles are needed and what they should say.

### Formatting Standard

- Title case: capitalise every word except articles and prepositions in the middle (e.g., "Dispersion and Persistence")
- Maximum six words
- Descriptive, not clever: the title tells you what the passage covers

### Naming Quality

The H3 should name the passage's *point or tension*, not just its topic. A good H3 tells you what the passage argues or reveals; a generic H3 merely labels the subject area.

Test: if the H3 could serve as a heading in any generic industry textbook without modification, it is too generic.

Examples:
- Too generic: "GP Economics" — Better: "GP Fees and Alignment"
- Too generic: "Performance Evidence" — Better: "Outperformance and Its Limits"
- Good as-is: "Dispersion and Persistence" (names the specific findings)
- Good as-is: "Defining the Mid-Market" (signals the instability problem)

### Placement Rule

Place an H3 when the passage that follows could not be accurately described by the H2 title alone.

Test: if someone scanning only H2 and H3 titles would get a correct table of contents for the section's argument, the H3s are placed right.

### Borderline Cases

When a placement or naming decision is genuinely ambiguous, default to placing the H3 and mark it REVIEW in the Step 2 verdict table. The operator decides on borderline cases — do not silently skip or silently keep.

### Do Not Place an H3

- Before a lede paragraph that frames the entire H2 section. The lede sits between the H2 and the first H3.
- When consecutive paragraphs are developing the same point.

### Minimum Block Size

One paragraph per H3 block, unless the topic is genuinely distinct from its neighbours.

### Resulting Pattern

```
## Section Title
[Optional: 1-2 paragraph lede framing the section]

### First Topic
[1+ paragraphs]

### Second Topic
[1+ paragraphs]
```

### Step 1 Output

Write the modified prose file with H3s inserted. Do not rename or remove existing H3s in this step — that happens in Step 2.

## Step 2: Refinement Pass

Review every H3 in the file (both newly placed and pre-existing) against four checks. For each H3, produce a one-line verdict: KEEP, RENAME (with suggested replacement), or REMOVE (with reason).

### Check 1 — Specificity Test

Could this H3 appear unchanged in any generic industry textbook? If yes, it is too generic. Rename to capture the passage's specific point or tension.

### Check 2 — Accuracy Test

Does the H3 describe what the passage actually argues, or what you expected it to argue? Re-read the paragraphs beneath it. If the H3 misnames the content, rename.

### Check 3 — Placement Test

Is the H3 placed before a lede paragraph that frames the whole H2 section? If yes, remove — the lede should sit between the H2 and the first H3. Is the H3 splitting paragraphs that develop a single point? If yes, remove.

### Check 4 — Scan Test

Read only the H2 and H3 titles in sequence. Does someone scanning these get an accurate table of contents for the section's argument? Flag any H3 that breaks the logical sequence or creates a misleading impression of the section's structure.

### Step 2 Output

Present a verdict table to the operator:

```
| Current H3 | Verdict | Replacement / Reason |
|---|---|---|
| First Topic | KEEP | — |
| Second Topic | RENAME | "Revised Title" — original too generic |
| Third Topic | REMOVE | splits a single-point argument |
```

**Gate:** Do not apply refinements until the operator reviews the verdict table. The operator may override individual verdicts. Apply only approved changes.

## Output Summary

After both steps complete and refinements are applied:
1. The modified prose file with final H3 titles
2. A brief count: H3s added, renamed, removed

## Failure Behavior

- **Missing prose file:** Halt. Do not proceed.
- **Prose file has no H2 sections:** Flag to the operator — this skill requires H2 structure to place H3s within. Do not invent H2s.
- **All H2 sections are short (single paragraph each):** No H3s needed. Report "No H3 placement warranted — all sections are single-paragraph" and stop.
- **Style reference conflicts with default formatting rules:** Style reference takes precedence. Apply the style spec's heading conventions and note the override.
- **Existing H3s use inconsistent formatting:** Normalize all H3s to the formatting standard in Step 1, then evaluate in Step 2 as usual.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires the full prose file in context. For very long documents, process one H2 section at a time.
- **Sequence:** Final step in the prose production pipeline. Runs after prose-formatter. The operator manages this sequence.
