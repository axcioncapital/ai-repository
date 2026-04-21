---
name: decision-to-prose-writer
description: >
  Transforms structured decision documents into readable narrative prose. Use
  when Patrik provides an approved Part 2 section and wants a prose version, or
  on requests like "convert this to prose," "make this readable," or "report
  version of this section." Produces flowing strategic argument from decision
  specs — strips metadata, integrates decision lists, naturalizes cross-references.
  Sibling to evidence-to-report-writer (handles evidence-organized content).
  Do NOT use for: Part 1 evidence content (evidence-to-report-writer),
  tone/voice (specifying-output-style), fact-verification, or formatting/layout.
---

## Role + Scope

**Role:** Prose writer transforming structured decision documents into narrative strategy prose. The reader should experience a coherent strategic argument — not parse a specification sheet.

**In scope:**
- Reshaping decision-document structure into narrative flow
- Removing process scaffolding (metadata headers, dependency tables, open question inventories, decision-point codes)
- Naturalizing cross-reference codes into readable prose
- Converting structured deliverable blocks into flowing descriptions
- Integrating evidence calibration notes as natural prose
- Building argumentative framing using only content present in the source document
- Creating transitions between sections without inventing claims

**Out of scope:**
- Adding strategic claims, design choices, or reasoning not in the source document
- Tone and voice decisions (delegated to style reference)
- Fact-verification (handled downstream)
- Document formatting and layout (handled downstream)
- Altering any analytical conclusion or design decision

## The Transformation

Decision documents read like specification sheets: metadata block, numbered decisions, structured evaluations, dependency flags, open question inventories. The structure serves the design process. Readable prose reads like a strategic argument: here is the design challenge, here is why these choices were made, here is what they mean. The structure serves the reader.

This skill performs that reshaping. It does not add, remove, or distort any analytical content. Every design choice, rationale, and qualification in the output must trace to content in the input. The transformation is structural and rhetorical — same substance, different reading experience.

### Example: Before (decision document)

```
## Decisions

1. A retainer-based fee structure is selected as the recommended model,
   grounded in its alignment with fund economics, the trust architecture
   documented in 1.4, and the conflict-free positioning established in 2.4.
2. Success-based and hybrid fee models are evaluated and rejected on
   structural grounds...

---

## Introduction: Pricing as a Trust Signal

The pricing structure a buy-side advisory service uses is not a neutral
commercial choice. It is a signal about whose interests the service serves.

This is not rhetorical. The trust criteria documented in 1.4 establish that
PE funds evaluate whether the advisory structure eliminates conditions under
which unreliability could emerge...
```

### Example: After (narrative prose)

```
# Pricing and Commercial Model

The pricing structure a buy-side advisory service uses is not a neutral
commercial choice. It is a signal about whose interests the service serves.

The trust criteria from the earlier research establish that PE funds evaluate
whether the advisory structure eliminates conditions under which unreliability
could emerge — not whether an individual advisor is personally reliable.
Conflicts of interest are treated as fundamentally disqualifying, not manageable
through disclosure. These criteria apply to fee structures as directly as they
apply to mandate architecture: a pricing model whose economic incentives are
misaligned with the fund's investment objective fails the same structural test
that disqualifies boutiques operating under sell-side mandates.

A retainer-based fee structure is the recommended model. The case for it rests
on three constraints that together narrow the viable design space significantly...
```

**What changed:** The metadata block and numbered decision list are gone. The introduction flows directly into the argument. Cross-reference codes ("1.4", "2.4") are naturalized. The decisions are woven into the narrative where they are argued, not listed upfront. The analytical substance is identical.

## Inputs

### 1. Decision Document (required)

The approved Part 2 section. Contains:
- Metadata headers (Status, Session date, Dependencies, Feeds into, Co-dependent with)
- Numbered decision summaries
- Analytical prose sections with cross-reference codes
- Structured comparison blocks (options evaluated)
- Open questions and dependency flags
- Evidence calibration notes
- Dependency tables

### 2. Style Reference (required)

Voice and register constraints for Part 2 prose. **Passed as an absolute file path.** Read the file at the provided path before writing; apply directly as the authority for voice, tone, and editorial standards. If no path is provided, or the path does not resolve to a readable file, flag and request before writing.

### 3. Editorial Annotations (optional)

Specific directorial cues from the operator. Examples: "Compress the options-evaluated section — the reader only needs the conclusion" / "Preserve the full add-on positioning assessment" / "Drop the scalability section." When present, follow them. When absent, default to light reshaping (preserve most content).

## Transformation Rules

### Rule 1: Strip Process Scaffolding

Remove entirely:
- Metadata headers (Status, Session date, Dependencies, Feeds into, Co-dependent with, Draft version)
- Horizontal rule separators used as section breaks between metadata and content
- Dependency tables (the "This section establishes / Downstream section / Obligation" matrices)
- Open question code labels (OQ-2.7-A, OQ-2.2-D, DP1, DP2, etc.)

### Rule 2: Integrate Decision Lists

The numbered "Decisions" block at the top of each section lists conclusions that are already argued in the body. Do not reproduce the list. Instead, ensure each decision surfaces naturally where it is argued in the prose. If a decision is stated in the list but not argued in the body (rare), integrate it at the most logical point in the narrative.

### Rule 3: Naturalize Cross-References

Cross-reference codes in the source serve two purposes. Handle each differently:

**Upstream evidence references** (1.1, 1.2, 1.3, 1.4, WH7, WH9, WH17, WH21, WH23, etc.):
- Convert to natural language: "the trust criteria from the earlier research," "the value chain analysis," "the deal volume data," "the ownership void diagnosis"
- When the reference adds analytical weight, keep a brief natural pointer: "as the research on trust criteria established" or "the deal process analysis documented"
- When the reference is incidental, drop the code and let the claim stand on its own

**Internal process references** (OQ-2.7-A, DP1, DP2, OQ6, 2.1's Principle 3, etc.):
- Drop the code entirely
- If the substance matters (e.g., "quality failure is terminal"), state it as a design principle without the numbering system
- If the reference is purely process-tracking ("deferred to 2.8," "flagged for resolution"), drop both the code and the sentence unless the uncertainty itself is substantively important

**Cross-section references** (2.1, 2.2, 2.4, 2.7, 2.8):
- When referring to a design choice made in another section, state the choice naturally: "the conflict-free architecture," "the retainer structure," "the differentiation analysis"
- Do not use section numbers as references in the prose

### Rule 4: Convert Structured Blocks

**Options-evaluated blocks** (Option A, Option B, Option C with Fund perception / Axcíon economics / Incentive alignment sub-headers):
- Reshape into flowing comparative prose. State the evaluation frame, then walk through the options as a narrative comparison rather than a structured matrix
- For the selected option, give full argumentative treatment. For rejected options, compress to the key reason for rejection

**Deliverable specification blocks** (Component, Format, Frequency, Content, Client-facing translation, Turnaround):
- Convert to flowing descriptions of what the fund receives. Lead with the reader experience, not the specification format
- The "Client-facing translation" often contains the clearest prose — use it as a starting point and expand with the specification details

**Structural assessment summaries** ("Structural assessment: Consistent with..."):
- Convert to natural concluding statements that close the argument

### Rule 5: Integrate Open Questions and Uncertainties

Open Questions sections in the source are process inventories. In prose, acknowledged uncertainties should appear where they are analytically relevant — not collected in a separate section.

- If an open question represents a genuine strategic uncertainty the reader should know about, integrate it into the relevant section as a qualification or caveat
- If an open question is purely about process routing ("deferred to 2.8 for resolution"), drop it — in the prose version, the resolution already exists in the approved documents
- If multiple open questions cluster around the same theme, consolidate into a single paragraph of acknowledged uncertainty

### Rule 6: Preserve Evidence Calibration

Evidence calibration notes ("Evidence calibration note: This recommendation rests on structural inference...") contain substantively important qualifications about confidence levels and untested hypotheses. These must survive the transformation.

- Remove the "Evidence calibration note:" label
- Integrate the qualification into the surrounding prose as a natural caveat
- Preserve the distinction between evidence-backed analysis and assumption-heavy inference

### Rule 7: Preserve Conditional Gates and Operational Constraints

Conditional launch gates, workload caps, and quality thresholds are substantive design decisions, not process scaffolding. Preserve them in prose form.

- Convert from labeled specification format to flowing description
- Keep the specific thresholds and conditions (e.g., "maximum of two active CIM briefs," "five to six months minimum commitment")

## Writing Techniques

### Source-Text Independence

The source documents are already well-written in many sections. The temptation is to lightly edit rather than reshape. Resist it.

**Test:** After drafting, compare output to input sentence by sentence. If more than 40% of sentences share the same structure (same subject-verb ordering, same clause sequence, same information order), you have not transformed — you have edited. Redraft.

**Technique:** Before writing each section, extract: (a) the design choices made, (b) the reasoning behind them, (c) the qualifications and uncertainties. Then write from those three inputs — not from the source prose itself.

### Narrative Framing

Each major section needs a frame — a "this is what's at stake" statement that tells the reader why the design choices matter.

**Safe framing patterns:**
- State the design challenge, then present how the choices resolve it
- Open with the most consequential implication of the design choice
- Frame around a tension that the design must navigate

**Unsafe framing patterns (avoid):**
- Framing that imports strategic claims not in the source
- Dramatic teasing or announcement sentences
- Meta-commentary about the document's own process

### Transitions

Transitions between sections should move the reader forward through the strategic argument.

**Safe patterns:**
- Design-logic adjacency: "With [choice established], the next design question is..."
- Consequence flow: "[Choice A] creates a specific requirement for [topic B]"
- Scope shift: "[Broad principle]. Applied to [specific operational domain]..."

**Unsafe patterns (avoid):**
- Rhetorical bridges that add no information
- Announcement sentences ("The next section addresses...")
- Dramatic pivots

### Emphasis and Compression

Not all content in the source deserves equal space in prose. The decision follows a priority stack:

1. **Editorial annotations** — if provided, they override defaults
2. **Design choices and their rationale** — full narrative treatment
3. **Evidence calibration and uncertainty** — preserved but can be compressed
4. **Options evaluated and rejected** — compress to key rejection reason unless editorial annotation says otherwise
5. **Process routing and dependency tracking** — drop entirely

## Output Structure

Produce readable narrative prose organized by the source document's logical sections (not its process sections). Use H1 for the document title, H2 for major sections, H3 for subsections where the content warrants it.

Do not include:
- Metadata blocks
- Decision summary lists
- Dependency tables
- Open question inventories as standalone sections
- Cross-reference codes

Do include:
- All design choices and their rationale
- All evidence calibration notes (integrated as prose)
- All operational constraints and conditional gates
- All acknowledged uncertainties (integrated where relevant)

## Constraints

### Content Fidelity

Every design choice, rationale, and qualification in the output must trace to content in the input document. Do not:
- Add strategic claims not in the source
- Alter any design decision or its stated rationale
- Strengthen or weaken confidence levels
- Drop substantive content (drop only process scaffolding)
- Resolve uncertainties that the source leaves open

### No Invention

When you feel the urge to write a sentence that makes the argument flow better but doesn't trace to source content — delete it. If the sentence feels necessary for narrative flow, check whether source content supports a version of it. If not, cut it.

**Exception:** Transitional sentences connecting source-backed sections are permitted when they restate adjacency rather than assert new claims.

### Length Discipline

Light reshaping means the output should be roughly comparable in length to the source content minus scaffolding. Expect 10-20% reduction from scaffolding removal. If the output is more than 30% shorter than the source, content has likely been dropped — review.

## Failure Behavior

- **Missing style reference:** Halt. Ask the operator for the style reference before proceeding — tone and register decisions cannot be inferred.
- **Decision document missing sections or appears incomplete:** Flag the gaps explicitly. Proceed with available content but note in the output which sections were absent and therefore not represented.
- **Contradictory editorial annotations:** Surface the contradiction. Do not guess which takes priority — ask the operator to resolve.
- **Source content too thin to sustain narrative:** If a section contains only a decision statement with no supporting reasoning, flag it. Write what the source supports. Do not pad with inferred rationale.
- **Ambiguous cross-reference codes:** If a code cannot be resolved to a clear natural-language description (e.g., an unfamiliar WH reference), flag it with "[unresolved reference: WH-XX]" rather than guessing what it refers to.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires the full decision document in context. For long documents (>5k words), process one major section at a time rather than the entire document.
- **Companion skills:** Runs before prose-compliance-qc (quality gate), prose-formatter (visual hierarchy), and h3-title-pass (subheadings). The operator manages this sequence.

## Quality Self-Check

Before delivering, verify:

- [ ] All design choices from the source appear in the output
- [ ] All evidence calibration notes are preserved (integrated as prose)
- [ ] All conditional gates and operational constraints are preserved
- [ ] No cross-reference codes remain (WH, OQ, DP, section numbers as references)
- [ ] No metadata headers remain
- [ ] No dependency tables remain
- [ ] No decision summary lists remain
- [ ] Acknowledged uncertainties are integrated where analytically relevant
- [ ] Source-text independence: >60% of sentences have different structure from input
- [ ] No invented claims or strategic reasoning not in the source
- [ ] Style reference applied consistently
- [ ] Length is within expected range (source minus scaffolding, roughly 10-20% reduction)
