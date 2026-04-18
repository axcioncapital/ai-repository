---
name: ai-prose-decontamination
description: >
  Four-pass sequential decontamination of AI writing patterns from prose.
  Removes ornamental language (including contrast-template overuse and
  abstract-noun stacking), repetition (including pivot-closings),
  over-argumentation, and uniform rhythm (including pseudo-maxim habit).
  Applies the document's Plain-Language / Flagged-Word Registry when the
  style reference includes one. Use when prose has passed substantive
  review and needs voice decontamination before formatting, or on
  requests like "decontaminate this," "remove AI patterns," "clean up the
  AI voice," "decontamination pass." Do NOT use for: prose quality review
  (chapter-prose-reviewer), compliance checking (prose-compliance-qc),
  formatting (prose-formatter), or rewriting content
  (decision-to-prose-writer / evidence-to-report-writer).
---

## Role + Scope

**Role:** Prose decontaminator. Remove AI writing patterns from substantively correct prose. Produce clean, direct prose that reads like a knowledgeable human wrote it.

**Hard constraint:** This skill does not change the argument structure, the sequence of sections, or the analytical conclusions. It changes how things are said, not what is said. If a decontamination edit would alter an analytical claim or modify a sourced statement, flag it in the bright-line flags output instead of applying it.

**Stateless:** Each invocation is independent. Evaluate the prose as-is.

## Why AI Prose Fails

AI-generated prose optimises for the appearance of rigour rather than the efficiency of communication. It reaches for the elevated word, restates points for completeness, builds logical scaffolds around claims the reader would accept directly, and delivers every sentence at the same pace and weight. The result is prose that is substantively correct but exhausting to read — it sounds like a document performing intelligence rather than a person conveying it.

Four failure modes produce this effect. This skill corrects them in sequence.

---

## Inputs

### 1. Prose File (required — blocking)

The document to decontaminate. This should be post-review prose — substantive correctness has already been verified. If the prose has not been through review, the decontamination pass will still run, but analytical errors in the source will pass through unchanged.

**If missing, unreadable, or empty:** Do not proceed. Stop and report. If the file has no H2 section headings, fall back to line-number location labels (e.g., `line 42`) in the change log, but note the absence of section structure in the change-log header — several sub-patterns (pivot closings, maxim budget) use section boundaries as their counting unit and produce weaker results without them.

### 2. Style Reference (required — blocking)

The style specification governing tone, voice, audience, and editorial standards. The style reference is the authority on what register is appropriate for this document. Pass 1 checks the style reference before flagging elevated language — if the style reference permits a construction, it stays.

**If missing:** Do not proceed. Flag and request before running any passes.

### 3. Prose Quality Standards (recommended — not blocking)

The prose quality standards document for this project. When provided, aligns the decontamination passes with existing standards — particularly Standard 1 (no self-annotation), Standard 3 (sentence rhythm), and Standard 5 (no preambles). When absent, the four passes use their own internal logic. Note the absence in the change log header.

### 4. Source Document (optional)

The original document that was converted to prose (decision document, evidence prose, etc.). When provided, run a lightweight fidelity spot-check after Pass 4 completes: verify that no design choices, analytical claims, or evidence citations were inadvertently dropped during decontamination. When absent, skip the spot-check and note it in the change log.

---

## Before You Start

**Leave clean prose alone.** If a paragraph already reads like a knowledgeable human wrote it — direct, varied in rhythm, free of ornament — do not edit it. The goal is to fix what's wrong, not to process every sentence. Over-editing clean prose degrades it.

**Priority rule.** When passes conflict — when simplifying language would reduce analytical precision, or when removing argumentation would lose a distinction the reader needs — clarity and precision win over compression and style. Specifically: do not simplify a phrase if the simpler version loses a meaningful distinction. Do not compress an argument if the compression drops reasoning the reader needs to make a decision. Passes 1 and 2 take priority over Passes 3 and 4 when trade-offs arise.

**Run all four passes in order.** Later passes assume earlier ones are complete. Each pass runs against every paragraph, but changes are made only where the detection pattern triggers. Running a pass is not the same as making changes — a pass that finds nothing wrong in a paragraph produces no edits for that paragraph.

**Sequential execution.** Each pass operates on the output of the previous pass. Complete each pass fully before starting the next. Do not plan ahead across passes.

**Style reference authority.** Before flagging any construction in Pass 1, check the style reference. If the style reference explicitly permits or requires a register level, that level is not ornamental — it is intentional. The style reference overrides Pass 1's default simplification impulse.

**Flagged-Word Registry (when present).** If the style reference contains a Plain-Language Register or Flagged-Word Registry section — a table of elevated vocabulary with plain-English alternatives and a named carve-out list — that registry is authoritative for Pass 1's vocabulary decisions. Pass 1 applies it procedurally (see Sub-pattern 1c below). When absent, Pass 1 uses its own detection logic and notes the absence in the change log.

---

## Pass 1: Kill Ornamental Language

AI prose reaches for the elevated construction when the plain one says the same thing. Find every instance where a simpler word or shorter phrase would carry the same meaning, and replace.

**Detection pattern:** If a phrase would sound strange spoken aloud to a colleague, the register is too high.

Examples of what to replace:

| AI version | Human version |
|---|---|
| constitutes a fundamental reassessment trigger | forces a rethink |
| the economic rationale translates this structural case into fund-level terms across three dimensions | three things matter for the fund |
| this serves as an empirical validation target | this is what Year 1 tests |
| demonstrates a structural incompatibility | doesn't work |
| the service retains relevance for the unmet dimension | the service still helps with what's missing |
| operationalized throughout the service design | built into the service |
| is directionally consistent with | aligns with |
| the diagnostic is the four-condition combination test | the test is whether the existing advisor delivers all four |
| the residual risk is to uniqueness of positioning, not to service viability | the risk is that the positioning narrows, not that the service fails |
| the knowledge gap is a validation target with a defined response protocol, not an unresolved vulnerability | early conversations will test this directly |

**What to preserve:**

- Technical domain terminology that has precise meaning in the document's field (e.g., for PE: enterprise value, carried interest, LPAC). Domain-specific terms are not ornamental — they are accurate. The examples in this table use PE vocabulary because the skill was developed on PE prose; apply the same test to whatever domain the current document belongs to.
- Analytical distinctions that would be lost by simplification. If "directionally consistent with" distinguishes between full confirmation and partial alignment, and that distinction matters in context, keep it. If it's just a fancier way of saying "aligns with," replace it.
- Constructions the style reference explicitly permits or requires.

The target is McKinsey-internal, not simplified. Clear and direct, not dumbed down. Simplify language without reducing analytical specificity.

**The test:** Read the sentence aloud. If it sounds like a person explaining something to a smart colleague, keep it. If it sounds like a document performing intelligence, simplify.

### Sub-pattern 1a: Contrast-template overuse

"Not X, but Y" / "X is Y, not Z" / "not a preference, but a constraint" is a legitimate move when it refuses a specific alternative the reader would plausibly assume or names a strategic trade-off. It becomes an AI tell when used as the default paragraph-to-paragraph rhythm — the reader is continuously reset by negations rather than carried forward, and the prose starts sounding like an argument with an invisible interlocutor.

**Frequency test.** Count contrast constructions per 1,500 words of prose, scaling the threshold proportionally: "not [X]", "rather than", "X, not Y", "X is [Y], not [Z]", "not a [Y], but a [Z]", and structural variants. For documents or sections significantly shorter or longer than 1,500 words, apply the rate, not the raw count.

- **Rate ≤ 2 per 1,000 words (≈ 0–3 per 1,500):** acceptable.
- **Rate 3–4 per 1,000 words (≈ 4–6 per 1,500):** review each one. Rewrite lower-impact instances as direct statements; reserve contrast for the places where it sharpens a genuinely difficult choice.
- **Rate ≥ 5 per 1,000 words (≈ 7+ per 1,500):** systemic. Rewrite the section to state points directly.

For very short passages (under 500 words), flag any paragraph running two or more contrasts that do not compound, regardless of document-level rate.

**Keep contrast when:** (a) it refuses a specific alternative the reader would plausibly assume; (b) it names a strategic trade-off with downstream consequences; (c) it corrects a misreading of a prior sentence.

**Cut contrast when:** (a) both sides are generalities ("need and acceptability are not the same variable"); (b) it is rhetorical ornament on something the reader already accepts; (c) two or more contrasts in the same paragraph do not compound.

*Before/after example, plus the note distinguishing this sub-pattern from Pass 3 phantom-objection contrast:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 1a).

### Sub-pattern 1b: Abstract-noun stacking

AI prose reaches for nominalized compounds — three or more abstract nouns stacked before the main verb — where a verb-driven sentence naming the actor and the action would carry the same meaning. Nouns stack because they feel analytical; verbs get lost because verbs require naming who does what.

**Compression test.** For any three-noun compound ("dominant cost nexus," "judgment-externalization tension," "sourcing-to-screening coupling point"), ask: can I name who does what? If yes, rewrite with an active verb and the actor. If the compound is load-bearing document vocabulary — a recurring object the document names and operates on — keep it and ensure first-use definition.

**Shapes that flag:**
- Noun-of-noun: "cost nexus," "coupling point"
- Adjective-nominal-preposition-nominal: "dominant cost concentration," "pre-CIM processing burden"
- Hyphenated prestige compounds: "deal-stage-calibrated acceptability," "sourcing-to-screening coupling point"

None is automatically wrong. Each is a candidate for compression review.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 1b).

**Load-bearing carve-out.** If the style reference names specific compressed terms as part of the document's operating vocabulary (e.g., "Minimum Viable Service," "augmentation framing"), those terms are exempt. All other compressions are subject to the default.

### Sub-pattern 1c: Flagged-Word Registry application

When the style reference contains a Plain-Language Register or Flagged-Word Registry section, follow this procedure for every vocabulary decision in Pass 1:

1. **Scan the full prose** for each flagged word or phrase listed in the registry.
2. **Check each instance against the carve-out list.** Carve-outs are exhaustive — if the registry does not list the word as a load-bearing carve-out, it is not exempt, regardless of how "precise" or "domain-appropriate" it feels.
3. **Swap non-carve-out instances** to one of the plain-English alternatives named in the registry. Choose the alternative that fits the sentence grammar and the claim being made.
4. **Preserve carve-out instances** unchanged.
5. **Log the result:** total instances scanned, swaps applied, carve-outs preserved, per-term if useful.

The registry expresses the document's reader-specific voice calibration. A reader profile optimized for non-native professional readers (for example) requires plainer vocabulary than a generic internal document, and the registry is how that calibration reaches Pass 1. When the style reference has no registry section, skip this sub-pattern and note "Flagged-Word Registry: not provided" in the change log.

**Grammar-break failure mode.** When a registry-listed plain alternative does not fit the sentence grammar (e.g., "coherence" → "fits together" cannot substitute directly in "the coherence of the design"), do not force the swap. Instead, recast the surrounding phrase to absorb the alternative ("the design fits together" instead of "the coherence of the design"), or, if recasting would distort the claim, choose a different plain alternative from the registry that grammatically fits. If none of the registry's alternatives work, flag the instance in the change log as "registry grammar-break: preserved original" and leave it unchanged. Do not invent a plain-English alternative that is not in the registry.

---

## Pass 2: Remove Repetition

AI prose makes a point, restates it in different words, then summarises what was just said. The reader understood it the first time.

**Detection pattern:** If a sentence can be deleted and the paragraph still makes the same point with the same clarity, delete it.

**What counts as repetition:**
- The same claim expressed in two phrasings within the same paragraph
- A summary sentence at the end of a paragraph that restates what the paragraph just developed
- A framing sentence that previews what the next sentence says directly
- A paragraph-closing sentence that summarises the paragraph's own argument ("The net result is..." "The practical consequence is..." "Each pressure amplifies the others.")

**What does NOT count as repetition:**
- A claim followed by evidence supporting it (that's development)
- A claim followed by its mechanism or implication (that's progression)
- A claim restated in a later section for a different analytical purpose (that's cross-referencing)
- Deliberate restatement for emphasis where the point is consequential enough to warrant it — for instance, a design principle restated at the moment it governs a specific decision. If the restatement changes context or application, it is emphasis, not redundancy. If it merely re-words the same claim at the same level of abstraction, it is redundancy.

**Action:** For each repeated point, keep the strongest formulation. Delete the others. One formulation per idea. If two phrasings are equally strong, keep the shorter one.

### Sub-pattern 2a: Pivot closings

Sections often end on sentences that gesture toward the next section's subject ("The question this opens is operational: what form the service takes…") rather than landing the current section's conclusion. The closing sentence signals "I am writing a structured document" rather than "here is what this section established." These are deletable-without-loss sentences — which is why they belong in Pass 2.

**Detection.** Read the last sentence of each section. Ask: does it describe what the next section will do, or what this section established? A sharper test: if the final sentence were removed, would the section still land? If yes, the sentence is scaffolding.

**Rule.** Sections end on their own conclusion. Cross-references to adjacent sections belong in the body prose (inside the section, where a transition can carry real information), not as the final sentence. The final sentence should be the strongest delivery of the section's finding.

*Before/after example, plus the distinction from summary-closings and what to do with cross-reference content:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 2a).

---

## Pass 3: Deflate Over-Argumentation

AI prose builds elaborate logical scaffolds around claims that don't need them. It defends against objections the reader hasn't raised. It proves things the reader would have accepted on a direct statement. The result is prose that feels like being cross-examined rather than informed.

**Detection pattern:** If a paragraph spends more words building the case than the finding itself is worth to the reader, the argumentation is disproportionate.

**What to compress:** Argumentation that defends against obvious or unraised objections. Logical scaffolding around findings the reader has no reason to resist. Multi-sentence build-ups to conclusions the reader would accept as direct statements.

**What to retain:** Reasoning that supports a non-obvious conclusion, a decision the reader needs to evaluate, or a risk assessment where the logic chain matters. If the reader needs to see *how* you got there — not just *where* — the argumentation earns its space.

**Boundary rule:** If the scaffolding contains a distinct analytical claim, qualification, or evidence citation, it is not scaffolding — it is argument. Compress only when the surrounding sentences already establish the logical relationship that the scaffolding makes explicit.

**Three specific sub-patterns to fix:**

### Sub-pattern 3a: Proving the obvious

When a finding is well-evidenced and the reader has no reason to resist it, state it directly with its citation. Do not build the case from first principles.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 3a).

### Sub-pattern 3b: Stacking qualifications

When every claim gets a caveat, a boundary condition, and an evidence-quality note in the same sentence or paragraph. Spread these across the text. Not every claim needs all three simultaneously.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 3b).

### Sub-pattern 3c: Defending against phantom objections

Addressing counterarguments or alternative interpretations that the reader has not raised and would not raise.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 3c).

---

## Pass 4: Break the AI Rhythm

After passes 1–3, the prose should be leaner. This pass addresses the remaining AI tell: uniform sentence length that produces flat, metronomic prose.

**Detection pattern:** Check each paragraph. If no sentence is under 10 words, the paragraph lacks rhythmic variation. If every sentence falls between 12 and 20 words, the prose is flat.

**Action:** Find the paragraph's key finding, conclusion, or pivot. Compress it into a short sentence (3–8 words). Let the longer sentences around it carry the explanation. The short sentence creates emphasis through contrast, not through bold or italics.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Pass 4 main example) for a worked example of compressing a paragraph's key finding into a sub-10-word lead sentence.

**Frequency target:** At least one sentence under 10 words per paragraph of four or more sentences. Two consecutive paragraphs without rhythmic variation is a problem.

**What short sentences are NOT:** Not labels ("This matters."), not fragments ("A critical point."), not fillers ("The implications are clear."). Short sentences are compressed findings or pivots — they carry meaning, not emphasis markers.

**Prose quality standards alignment:** When prose quality standards are provided, apply Standard 3's frequency target and short-sentence definition. Standard 3 governs; Pass 4 implements.

### Sub-pattern 4a: Pseudo-maxim budget

AI prose generates short, hard-edged declarative sentences that sound like principles carved in stone: "Capability does not create entitlement." "Year 1 is the empirical test." "The judgment burden cannot." Each one, taken alone, can be effective. Taken together — several in a single section — they become a rhythm, and the prose starts sounding like it was optimized for quotability rather than argument.

**What counts as a maxim.** A short (under 12 words), declarative, hard-edged sentence that functions as an aphorism — a generalization intended to land with independent authority rather than as one step in an argument. Diagnostic: the sentence could plausibly stand alone on a slide without its paragraph.

**Budget: maximum one maxim per section,** reserved for the point the surrounding argument cannot carry on its own.

**Counting.** Count maxim sentences per section (use heading boundaries, not paragraph boundaries — the budget is a section-level quota). If a section has two or more, flag. Choose the one that genuinely earns its place and rewrite the others as ordinary sentences inside their paragraphs.

*Before/after example:* See [`references/sub-pattern-examples.md`](references/sub-pattern-examples.md) (Sub-pattern 4a) for a worked example of trimming three maxims in a single section to one earned maxim.

**Distinction from normal short-sentence rhythm.** Pass 4's main guidance ("What short sentences are NOT") excludes labels, fragments, and fillers. The maxim budget adds one more constraint: short sentences that read as standalone aphorisms count against the budget even when they also serve rhythm. A short sentence that lands a finding, compresses a claim, or pivots a paragraph is normal rhythm and does not count. A short sentence that reads as a slide-ready generalization does count.

**Why this is a frequency standard.** Individual maxims can be good prose. The failure is the rhythm. A reader who encounters three aphorisms in a 1,500-word section stops taking the fourth seriously. Budget discipline preserves the authority of the one maxim that actually carries a point.

**Boundary case: the earned maxim is itself an analytical claim or a sourced statement.** The budget never touches the one maxim that earns its place. If the surviving maxim is itself an analytical claim or carries a sourced statement, preserve it intact — the bright-line rule already protects it. Rewriting the *other* maxims is what this sub-pattern does, and those rewrites are safe precisely because the excess maxims are rhetorical habit rather than analytical content. If a rewrite of a non-earned maxim would itself alter an analytical claim or a sourced statement, flag it in the bright-line-flags section of the change log instead of applying it.

---

## After All Four Passes

### Fidelity Spot-Check (conditional)

If the source document was provided as Input 4, run a lightweight check:

1. Scan the decontaminated prose for each major design choice, analytical claim, and evidence citation from the source document
2. Confirm each is still present in the decontaminated version (may be reworded but must be substantively present)
3. If any are missing, check whether they were removed by a decontamination pass or were absent before decontamination began
4. Report result: PASSED (all present), or list specific items that may have been dropped with the pass that removed them

If the source document was not provided, note "Source fidelity spot-check: skipped (no source document provided)" in the change log.

### Write Output

Write the decontaminated prose to the output path supplied by the calling agent. Then produce the change log.

**Output path discipline.** The caller specifies the output path. When the caller passes the same path as the input, the decontaminated prose overwrites the input file — this is the common pattern inside the `produce-prose-draft` pipeline, where the calling command owns the file-versioning contract. When invoked standalone, default to a new versioned path (e.g., `{prose}-decontaminated.md` or `{prose}.v{n+1}.md`) rather than overwriting; preserving the pre-decontamination file lets the operator compare before/after without going to git. Do not silently overwrite a file the caller did not explicitly name as the output path.

---

## Constraints

- Do not change the argument structure, the sequence of sections, or the analytical conclusions.
- Do not remove evidence calibration (phrases noting evidence quality or source limitations). These are honest, not ornamental.
- Do not remove technical domain terminology with precise meaning in the document's field, whether or not the style reference lists it explicitly (e.g., for PE: enterprise value, carried interest, LPAC). When the style reference does list domain terms as load-bearing, that listing is authoritative; absence of a listing does not mean the term is unprotected. Domain terms are precise, not fancy. (The examples throughout this skill use PE vocabulary because the skill was developed on PE prose; the rule is domain-agnostic — apply it using the terminology specific to the document under review.)
- Do not remove terms listed as load-bearing carve-outs in the style reference (e.g., named operating vocabulary like "Minimum Viable Service," "augmentation framing"). These are the document's named objects, not prose habits.
- Do not simplify a phrase if the simpler version loses a meaningful analytical distinction. Clarity means precision, not just brevity.
- Do not add new content, new claims, or new analysis.
- Do not remove cross-references to other sections or modules. Sub-pattern 2a (pivot closings) relocates cross-references into the section body rather than deleting them; the information stays, only the scaffolding sentence moves.
- Preserve all footnotes and citations in their original positions.
- Every change must be traceable to one of the four passes (and, where applicable, to a named sub-pattern — 1a, 1b, 1c, 2a, 4a). No opportunistic improvements.
- If a paragraph is already clean — direct, rhythmically varied, free of ornament — leave it unchanged.

---

## Change Log Format

Produce a structured change log as output. When invoked within a pipeline, the calling agent writes this to `{prose_output_dir}/decontamination-log.md`. When invoked standalone, present it directly. Use the full template at [`references/change-log-template.md`](references/change-log-template.md), which specifies the header layout, per-pass change entry format, bright-line flags section, and the consolidation rule for high-volume changes.

---

## Runtime Recommendations

- **Invocation:** Expected to be invoked explicitly (by an operator or a pipeline command such as `produce-prose-draft` Phase 5). Not auto-invoked on file writes. No `disable-model-invocation` setting needed because the skill is never a hook target.
- **Tools:** Requires Read, Write (or Edit) against the prose file and the change-log path. No `allowed-tools` restriction applied — the skill is tool-agnostic beyond this. A calling command may pass the file contents rather than a path; the skill logic is identical either way.
- **Paths:** No `paths` frontmatter restriction. The prose file path is supplied per invocation and varies by project.
- **Model:** Prefer Claude Opus 4.6 (`claude-opus-4-6`) or later for the main analytical work. A faster model (e.g., Sonnet) is acceptable when the calling command explicitly directs — `produce-prose-draft` Phase 5 currently delegates this skill to Sonnet because the four passes are pattern-based and analytical judgment is already established by prior phases.
- **Context budget:** Plan for the full prose file + style reference + prose-quality standards + source document (if provided) to be in context simultaneously, plus the skill body. For long prose files (15k+ words), consider running the four passes across separate turns to preserve rhythm judgment in Pass 4.
- **Execution pattern:** Runs cleanly as a subagent delegated by a pipeline command. Also runs standalone in the main thread. Either pattern is supported; subagent invocation gives cleaner context isolation when the calling session has other work in flight.
- **Sequencing within a pipeline:** This skill is the final voice-level authority before formatting. If the calling pipeline has earlier voice-adjustment phases (style sweep, chapter-prose-reviewer), decontamination takes precedence when its outputs conflict with earlier phases — formatting (which runs after) treats decontamination's output as the canonical prose.

---

## Worked Example

For an end-to-end transformation showing all four passes applied to a single section, see [`references/worked-example.md`](references/worked-example.md).
