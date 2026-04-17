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

### 3. Trigger #3 hit list (optional — from prose-formatter pre-scan)

When this skill runs in the merged Phase 2 sub-agent of `/produce-formatting`, the prose-formatter's Mechanical Triggers pre-scan produces a list of subsections that fired trigger #3 (one subsection contains multiple internal blocks). Operation 1 may also add pseudo-heading bold labels to this list during its pass. The list contains: subsection location, block boundaries (line references), one-line description of each block.

Consume this list in Step 1 as candidate SPLIT verdicts (see "Multi-block subsection detection" below). If the list is empty or not provided, proceed with the standard placement rules only.

Progress: [ ] Step 1: H3 placement [ ] Step 1b: Multi-block subsection detection [ ] Step 2: Refinement pass [ ] Operator review [ ] Apply refinements

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

### Multi-block subsection detection (Step 1b)

An existing H3 subsection may carry multiple distinct content blocks (different topics, different formatting units, e.g., sourcing logic + sequencing + a quoted speech act). When this happens, a bold label inside the subsection is often doing heading work — acting as a mini-heading for a self-contained passage. Mechanically, this is an under-specified heading structure: the material needs an H3 at the block boundary, not a bold label.

**When to propose a SPLIT:**
- A trigger #3 hit appears in the input list from the prose-formatter pre-scan (or was added by Operation 1's pseudo-heading detection).
- During your own placement pass, you observe an existing H3 subsection where a bold label introduces a visually separated block whose content differs materially from the surrounding prose (different topic, different formatting unit, different register — e.g., a client-facing quote).

**How to propose a SPLIT:**
- Identify the block boundary (the line immediately before the bold label or before the block's first paragraph).
- Draft a proposed H3 title for the new subsection per the Formatting Standard and Naming Quality rules above.
- Record the proposal for Step 2 as a SPLIT verdict (see Step 2 Output).

**Do NOT auto-apply a SPLIT.** Proposing a SPLIT is not the same as inserting an H3. The actual insertion waits for operator approval at command Phase 4. In Step 1, leave the prose unchanged for SPLIT candidates — only the verdict table records the proposal.

**Paired with pseudo-heading prohibition:** When a bold label in an H3 subsection is identified as a SPLIT candidate, the prose-formatter's Operation 1 should not bold the label (see prose-formatter's "No pseudo-heading bolding" rule). If the label is already bolded in the input prose, the SPLIT verdict's proposed H3 replaces the bold label rather than adding an H3 above a bold line. The rationale field in the verdict table records this.

### Step 1 Output

Write the modified prose file with H3s inserted. Do not rename or remove existing H3s in this step — that happens in Step 2. **Do not apply SPLIT verdicts in Step 1** — record proposals only; insertion happens post-handoff after operator approval.

## Step 2: Refinement Pass

Review every H3 in the file (both newly placed and pre-existing) against four checks. For each H3, produce a one-line verdict: **KEEP**, **RENAME** (with suggested replacement), **REMOVE** (with reason), or **SPLIT** (propose additional H3 at a block boundary within an existing subsection — see Step 1b).

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
| Current H3 | Verdict | Replacement / Reason / Proposed Insertion |
|---|---|---|
| First Topic | KEEP | — |
| Second Topic | RENAME | "Revised Title" — original too generic |
| Third Topic | REMOVE | splits a single-point argument |
| (Fourth Topic — existing) | SPLIT | Propose new H3 "Sourcing Logic" at line 142 (before the bold label "Sequencing"); existing subsection carries two distinct blocks |
```

**SPLIT verdict handling (operator-gated, not auto-applied):** Unlike KEEP/RENAME/REMOVE, SPLIT verdicts propose *new structure* rather than editing existing structure. SPLIT verdicts invoke the project bright-line rule (changes more than one paragraph, adds structural content). They are NOT applied mid-pipeline. Instead:

- Each SPLIT verdict records: (a) the H3 subsection to split, (b) the proposed insertion line reference, (c) the proposed new H3 title, (d) a one-line block-boundary rationale (why this location, what the two resulting blocks cover).
- SPLIT verdicts are surfaced in the calling command's handoff phase for operator review and approval.
- If the operator approves a SPLIT, the approved H3 is inserted as a post-handoff main-session edit, NOT a pipeline auto-apply. The operator's Phase 4 approval of the specific SPLIT satisfies the bright-line rule for the subsequent insertion — no additional bright-line pause is required.
- If the operator declines a SPLIT, the subsection is left unchanged. Log the declined SPLIT in the verdict table's disposition column for traceability.

**Gate:** Do not apply KEEP/RENAME/REMOVE refinements until the operator reviews the verdict table. The operator may override individual verdicts. Apply only approved changes. SPLIT verdicts are never applied in this step — they are always operator-gated per the handling rule above.

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
