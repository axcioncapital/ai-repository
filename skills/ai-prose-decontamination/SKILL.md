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

*Before:*
> Scope is defined by where the service can remove genuine cost or friction within the fund's existing chain. It is not defined by what Axcíon can build or by what the market appears to want.

Two sentences of pure contrast. The second refuses general alternatives the reader wasn't going to assume — rhetorical crispness rather than sharpening.

*After:*
> Scope is defined by where the service can remove genuine cost or friction within the fund's existing chain. The chain — not Axcíon's capability set or market demand signals — determines what qualifies as scope.

One contrast clause embedded in a single sentence, naming the refused alternatives in passing.

**Note:** Contrast used specifically to defend against objections the reader has not raised is handled by Pass 3 (phantom objections), not here. This sub-pattern addresses contrast as cadence; Pass 3 addresses contrast as false opposition.

### Sub-pattern 1b: Abstract-noun stacking

AI prose reaches for nominalized compounds — three or more abstract nouns stacked before the main verb — where a verb-driven sentence naming the actor and the action would carry the same meaning. Nouns stack because they feel analytical; verbs get lost because verbs require naming who does what.

**Compression test.** For any three-noun compound ("dominant cost nexus," "judgment-externalization tension," "sourcing-to-screening coupling point"), ask: can I name who does what? If yes, rewrite with an active verb and the actor. If the compound is load-bearing document vocabulary — a recurring object the document names and operates on — keep it and ensure first-use definition.

**Shapes that flag:**
- Noun-of-noun: "cost nexus," "coupling point"
- Adjective-nominal-preposition-nominal: "dominant cost concentration," "pre-CIM processing burden"
- Hyphenated prestige compounds: "deal-stage-calibrated acceptability," "sourcing-to-screening coupling point"

None is automatically wrong. Each is a candidate for compression review.

*Before:*
> Shallow matching at the sourcing-to-screening coupling point is the smallest coherent intervention.

Four abstract nouns before the main verb. The reader parses four compressions before reaching the claim.

*After:*
> Shallow matching is the document's term for flagging deals at the point where sourcing hands off to screening. It is the smallest intervention that still does useful work.

"Shallow matching" stays (the document names and operates on it). "Sourcing-to-screening coupling point" unpacks into a verb-driven clause. "Smallest coherent intervention" becomes "smallest intervention that still does useful work."

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

*Before:*
> The question this opens is operational: what form the service takes, and at which point in the chain it intervenes first.

The final sentence tells the reader what the next section will address. The reader already knows — they are about to read it. The section's own conclusion is displaced by the pivot.

*After:*
> The economic case for augmentation rests on these three dimensions operating together. None of them individually would justify the service; their combination is what makes the structural position viable.

The final sentence lands the section's conclusion. The next section still follows; the transition belongs in the next section's opening, not in this section's closing.

**Distinction from summary-closings.** Pass 2's main list already flags "paragraph-closing sentence that summarises the paragraph's own argument." Pivot closings are different: they do not restate the section, they gesture past it. Both are cut, but the diagnostic is distinct — a summary restates; a pivot announces what comes next.

**What to do with the cross-reference content.** If the pivot sentence carries information the reader would otherwise lack ("permanent exclusions are specified in the boundaries section"), move that sentence into the body of the section where the information is operationally relevant, not at the end where it displaces the landing.

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

*Before:*
> The structural gap that justifies external buy-side support narrows as internal coverage approaches self-sufficiency. This is because larger funds increasingly internalize advisory functions through strategic finance teams, dedicated sector coverage, and in-house origination capability. The net result is that funds above EUR 2B are less likely to benefit from the service.

*After:*
> Funds above EUR 2B increasingly internalise advisory functions — strategic finance teams, dedicated sector coverage, in-house origination. The structural gap narrows as internal coverage approaches self-sufficiency.

Two sentences instead of three. Same information. The reader didn't need the middle sentence explaining *why* internalising advisory functions reduces the gap — that's self-evident.

### Sub-pattern 3b: Stacking qualifications

When every claim gets a caveat, a boundary condition, and an evidence-quality note in the same sentence or paragraph. Spread these across the text. Not every claim needs all three simultaneously.

*Before:*
> These figures derive from a single-vendor benchmark (SPS) and should be treated as indicative rather than precise. The dual-channel coverage trap means this gap is not addressable through incremental effort: the intermediated channel excludes by sell-side process design, and the proprietary channel cannot compensate at scale.

*After:*
> The median fund sees roughly 18% of relevant transactions — a figure from a single-vendor benchmark, directionally consistent with other evidence but not precise. The gap is structural: the intermediated channel excludes by sell-side process design, and the proprietary channel cannot compensate at scale.

The qualification is woven in rather than isolated as its own sentence. The finding lands without being pre-emptively weakened.

### Sub-pattern 3c: Defending against phantom objections

Addressing counterarguments or alternative interpretations that the reader has not raised and would not raise.

*Before:*
> This is not deferral. It is scheduled resolution with empirical inputs on the positive path and a defined decision trigger on the negative path. Designing the conversion mechanism now, before any fund has experienced the service, would produce a theoretical construct that Year 1 data would require revising.

*After:*
> The conversion mechanism is designed during Year 1 using operational data. Positive-path activation when monitoring shows sufficient conversion indicators. Negative-scenario trigger at month 9. Fallback position defined.

The reader didn't think it was deferral until the prose insisted it wasn't. The defence created the doubt it was trying to prevent. State the mechanism and move on.

---

## Pass 4: Break the AI Rhythm

After passes 1–3, the prose should be leaner. This pass addresses the remaining AI tell: uniform sentence length that produces flat, metronomic prose.

**Detection pattern:** Check each paragraph. If no sentence is under 10 words, the paragraph lacks rhythmic variation. If every sentence falls between 12 and 20 words, the prose is flat.

**Action:** Find the paragraph's key finding, conclusion, or pivot. Compress it into a short sentence (3–8 words). Let the longer sentences around it carry the explanation. The short sentence creates emphasis through contrast, not through bold or italics.

*Before:*
> The entire client acquisition logic depends on cold outreach to funds with no prior Axcion relationship. The evidence base is the thinnest of any critical assumption. The headwinds compound: informal networks command structural presence, the 3% sourcing adoption rate documents cultural resistance, and the augmentation framing constraint means the pitch cannot imply the fund's existing approach is deficient.

*After:*
> Cold outreach is the weakest bet in the model. The entire client acquisition logic depends on it, the evidence base is the thinnest of any critical assumption, and the headwinds compound: informal networks have structural presence, only 3% of sourcing is outsourced, and the pitch cannot imply the fund's existing approach is deficient.

"Cold outreach is the weakest bet in the model" — eight words that land the point. The longer sentence that follows develops it.

**Frequency target:** At least one sentence under 10 words per paragraph of four or more sentences. Two consecutive paragraphs without rhythmic variation is a problem.

**What short sentences are NOT:** Not labels ("This matters."), not fragments ("A critical point."), not fillers ("The implications are clear."). Short sentences are compressed findings or pivots — they carry meaning, not emphasis markers.

**Prose quality standards alignment:** When prose quality standards are provided, apply Standard 3's frequency target and short-sentence definition. Standard 3 governs; Pass 4 implements.

### Sub-pattern 4a: Pseudo-maxim budget

AI prose generates short, hard-edged declarative sentences that sound like principles carved in stone: "Capability does not create entitlement." "Year 1 is the empirical test." "The judgment burden cannot." Each one, taken alone, can be effective. Taken together — several in a single section — they become a rhythm, and the prose starts sounding like it was optimized for quotability rather than argument.

**What counts as a maxim.** A short (under 12 words), declarative, hard-edged sentence that functions as an aphorism — a generalization intended to land with independent authority rather than as one step in an argument. Diagnostic: the sentence could plausibly stand alone on a slide without its paragraph.

**Budget: maximum one maxim per section,** reserved for the point the surrounding argument cannot carry on its own.

**Counting.** Count maxim sentences per section (use heading boundaries, not paragraph boundaries — the budget is a section-level quota). If a section has two or more, flag. Choose the one that genuinely earns its place and rewrite the others as ordinary sentences inside their paragraphs.

*Before (three maxims in a single section):*
> (…argument…) Capability does not create entitlement. (…more argument…) Quality failure is terminal. Design accordingly. (…later in the same section…) Year 1 is the empirical test.

Three maxims in one section. The first carries genuine analytical weight (a positioning refusal the rest of the document builds on). The second pair (*Quality failure is terminal. Design accordingly.*) restates in aphoristic form a point the surrounding paragraph already makes. *Year 1 is the empirical test.* could land as a pivot (normal Pass 4 rhythm) but becomes noise when two maxims have already fired in the same section.

*After:*

Keep *Capability does not create entitlement.* as the section's one earned maxim. Rewrite the others as ordinary sentences: "A quality failure is unrecoverable, so the service is designed to avoid any pathway that could produce one." "The Year 1 design treats each interaction as a test of whether the assumptions hold."

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

Produce a structured change log as output. When invoked within a pipeline, the calling agent writes this to `{prose_output_dir}/decontamination-log.md`. When invoked standalone, present it directly.

```
# Decontamination Change Log

Passes applied: 4
Total changes: [N]
Pass 1 (Ornamental Language): [N] changes
  — contrast-template overuse (1a): [N]
  — abstract-noun stacking (1b): [N]
  — flagged-word registry (1c): [N swaps / N carve-outs preserved] or [not provided]
  — other ornamental edits: [N]
Pass 2 (Repetition): [N] changes
  — pivot closings (2a): [N]
  — other repetition edits: [N]
Pass 3 (Over-Argumentation): [N] changes
Pass 4 (Rhythm): [N] changes
  — pseudo-maxim budget (4a): [N]
  — other rhythm edits: [N]

Style reference: [provided]
Prose quality standards: [provided / not provided]
Flagged-Word Registry: [provided / not provided]
Source fidelity spot-check: [passed / skipped (no source provided)]

## Bright-Line Flags

[Empty if no analytical claims or sourced statements were touched. If populated, list each flagged change with location, the proposed edit, and which bright-line check it triggers.]

## Changes

### Pass 1 — Ornamental Language

[P1-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [contrast-template (1a) | abstract-noun stacking (1b) | registry swap (1c) | other]
Before: "[quoted original]"
After: "[quoted replacement]"
Rationale: [one sentence — what AI pattern was removed]

### Pass 2 — Repetition

[P2-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [pivot closing (2a) | other]
Removed: "[quoted deleted text]"
Rationale: [one sentence — what it restated or what it gestured at]

### Pass 3 — Over-Argumentation

[P3-1] Location: [H2 section name], paragraph [N]
Before: "[quoted original passage]"
After: "[quoted compressed version]"
Rationale: [one sentence — what scaffolding was unnecessary]

### Pass 4 — Rhythm

[P4-1] Location: [H2 section name], paragraph [N]
Sub-pattern: [pseudo-maxim (4a) | other]
Before: "[quoted original]"
After: "[quoted restructured version]"
Rationale: [one sentence — what rhythm problem was fixed]
```

**Consolidation rule:** If more than 20 changes in a single pass, consolidate into grouped entries with representative examples. Example: "P1-1 through P1-8: Replaced elevated constructions across 6 paragraphs" with 2–3 representative before/after pairs. Summary counts remain exact.

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

## Worked Example: All Four Passes Applied

The following shows a full section transformed through all four passes. Study the changes — the patterns here repeat throughout any AI-produced prose.

### Original (AI pipeline output)

> The position Axcion occupies is **buy-side advisory partner**. This is a deliberate structural choice, not a marketing label.
>
> The distinction from an intermediary is mandate architecture. An intermediary connects parties. Its economic interest is in the connection itself. A partner's economic interest is in the fund's outcome quality. The **retainer structure**, where compensation is independent of deal completion, enforces this distinction economically. The permanent exclusions enforce it architecturally: no investment committee preparation (the fund's sovereign activity), no concurrent sell-side mandates creating buy-side conflicts, no market intelligence until trust prerequisites are earned through demonstrated deal-cycle performance.
>
> The distinction from a service provider is depth of integration. A service provider delivers a defined output to a specification. A partner operates alongside the deal team at progressively deeper chain stages as trust permits. The **co-sourcing model**, embedded support alongside the deal team rather than independent execution, is the operating model at the delegation ceiling. This requires senior-caliber delivery and PE-process literacy as a binary entry requirement.
>
> The partner claim has a temporal dimension. Year 1 delivers the structural alignment that makes the claim credible: mandate authority aligned with the buyer, conflict-free architecture, fee calibration to the underserved segment, and confidentiality rigor. These are architectural features in place from the first client conversation. The depth-of-integration dimension is earned through deal-cycle performance, consistent with what the trust research established: that performance in deal-specific activities dominates relationship history as the trust advancement mechanism. Axcion can legitimately claim structural partner alignment from Year 1 while being clear that operational partnership depth, the co-sourcing model, the criteria refinement through revealed preferences, the progressive access to deeper chain stages, develops over time as the phase-dependent trust dynamic plays out.
>
> The partner trajectory is not promised. It is earned per deal cycle. The service promises structural alignment and performance at the current chain depth. What it earns, over time, is expanded access.

### After All Four Passes

> Axcion is a buy-side advisory partner. Not an intermediary, not a service provider — a partner. The distinction is structural.
>
> An intermediary's economic interest is in the connection itself. A partner's interest is in the fund's outcome. The retainer structure enforces this: compensation is independent of deal completion. The permanent exclusions reinforce it — no IC preparation, no concurrent sell-side mandates, no market intelligence before trust is earned through deal-cycle performance.
>
> A service provider delivers a defined output to a specification. A partner operates alongside the deal team, going deeper as trust permits. At the delegation ceiling, the operating model is co-sourcing: embedded support alongside the deal team, not independent execution. This requires PE-process literacy as a binary entry requirement.
>
> The partner claim has two layers. The structural layer is in place from the first conversation: mandate authority aligned with the buyer, conflict-free architecture, fee calibration to the segment, confidentiality rigor. The depth layer is earned. Deal-cycle performance is what advances trust — not relationship history, not time served. Year 1 delivers the structure. Depth follows performance.
>
> The trajectory is not promised. It is earned per deal cycle.

### What Changed and Why

**Pass 1 (ornamental language):**
- "This is a deliberate structural choice, not a marketing label" — cut. The prose demonstrates the distinction; it doesn't need to insist it's deliberate.
- "the fund's sovereign activity" — cut. The parenthetical explanation is ornamental.
- "consistent with what the trust research established: that performance in deal-specific activities dominates relationship history as the trust advancement mechanism" — rewritten as "Deal-cycle performance is what advances trust — not relationship history, not time served." Same finding, half the words, no appeal to authority.
- "as the phase-dependent trust dynamic plays out" — cut entirely. Jargon wrapping a simple idea the preceding sentences already expressed.
- "senior-caliber delivery and PE-process literacy as a binary entry requirement" — "PE-process literacy as a binary entry requirement." Senior-caliber is implied by binary entry requirement.

**Pass 2 (repetition):**
- "The retainer structure... enforces this distinction economically. The permanent exclusions enforce it architecturally" — collapsed. Both sentences say "this feature enforces the distinction." Keep both features, remove the repeated framing.
- "These are architectural features in place from the first client conversation." — cut. The list speaks for itself.
- Final paragraph: "The service promises structural alignment and performance at the current chain depth. What it earns, over time, is expanded access." — cut. "The trajectory is not promised. It is earned per deal cycle" is the strongest formulation.

**Pass 3 (over-argumentation):**
- "Axcion can legitimately claim structural partner alignment from Year 1 while being clear that operational partnership depth... develops over time" — rewritten as "Year 1 delivers the structure. Depth follows performance." The reader doesn't need the legitimacy argument.

**Pass 4 (rhythm):**
- "Not an intermediary, not a service provider — a partner." — short, direct. Sets up the structural explanation.
- "The distinction is structural." — four words. Lands the reframe before longer sentences develop it.
- "The depth layer is earned." — five words. Pivots from what's given to what's built.
- "Year 1 delivers the structure. Depth follows performance." — two short sentences closing the argument. Each under seven words.
