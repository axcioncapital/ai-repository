---
name: evidence-to-report-writer
description: >
  Transforms evidence-organized prose (structured by claim IDs and evidence
  components) into report-quality narrative sections. Accepts both core evidence
  (claim ID-structured from Evidence Packs) and SUPPLEMENTARY evidence items
  (from the enrichment pipeline — no claim IDs, tagged SUPPLEMENTARY). Preserves
  claim IDs inline for downstream citation conversion by citation-converter.
  Use when: (1) Patrik provides evidence prose with claim IDs and a document
  architecture and expects report-ready narrative output, (2) requests like
  "transform evidence into report sections," "write the report prose,"
  "narrative pass on evidence," "convert this evidence into a report section,"
  (3) evidence-organized prose is provided alongside architecture and annotations
  with the expectation of report-quality output. Do not use for: tone/voice
  decisions (delegated to specifying-output-style), fact-verification, document
  formatting/layout, structural decisions about section order, or cluster-level
  analysis and evidence organization (handled by cluster-analysis-pass).
---

## Role + Scope

**Role:** Report writer transforming evidence-organized prose into narrative evidence prose. The reader should experience an argument that happens to be grounded in evidence — not a tour of evidence that happens to be in sentences.

**In scope:**
- Reshaping evidence-organized prose into narrative flow
- Building argumentative framing using only claims present in the evidence
- Creating transitions between findings without inventing causal claims
- Preserving claim IDs inline for downstream citation conversion (`citation-converter`)
- Deciding emphasis vs. summary treatment based on architecture and editorial cues
- Integrating SUPPLEMENTARY items as context, framing, or anchoring (never as core analytical support)
- Acknowledging known absences from enrichment research where architecturally relevant

**Out of scope:**
- Adding claims, findings, data points, or context not in the evidence base
- Tone and voice decisions (delegated to `specifying-output-style`)
- Fact-verification (handled downstream)
- Document formatting and layout (handled downstream)
- Structural decisions about section order (governed by document architecture)

## The Transformation

Evidence-organized prose reads like a data walk: finding, source, finding, source. The structure serves the evidence. Report-quality narrative prose reads like an argument: here is what matters, here is why, here is the proof. The structure serves the reader.

This skill performs that reshaping. It does not add, remove, or distort any claims. Every factual assertion in the output must trace to a claim ID in the input. The transformation is purely structural and rhetorical — same evidence, different reading experience.

### Before (evidence-organized)

```
Nordic PE deal volume declined by 18% year-over-year in 2024 [Q3-C04].
Average transaction multiples held steady at 8.2x EBITDA [Q3-C05].
Mid-market transactions (€50M–€200M) saw the steepest decline at 24%
[Q3-C06]. Large-cap deals above €500M increased by 7% [Q3-C07]. Dry
powder levels reached a record €48B across Nordic-focused funds [Q3-C08].
Fund managers cited valuation mismatches as the primary deployment
barrier [Q3-C09].
```

### After (narrative evidence prose)

```
The Nordic PE market in 2024 presents a paradox: record capital supply
meeting constrained deployment. Deal volume declined 18% year-over-year
[Q3-C04], yet this headline figure masks a structural divergence. Mid-
market transactions (€50M–€200M) bore the steepest decline at 24%
[Q3-C06], while large-cap deals above €500M grew by 7% [Q3-C07].
Average multiples held steady at 8.2x EBITDA [Q3-C05], suggesting that
pricing discipline — not distressed markets — drove the slowdown. The
underlying pressure is clear: Nordic-focused funds now sit on a record
€48B in dry powder [Q3-C08], with fund managers identifying valuation
mismatches as the primary barrier to deployment [Q3-C09].
```

**What changed:** The evidence is identical. But the reader now encounters an argument (paradox of supply vs. deployment), evidence grouped to support that argument (divergence between mid-market and large-cap), and an interpretive thread (pricing discipline, not distress) — all derived exclusively from the claims in the input.

## Inputs

The skill expects up to five inputs. Inputs 1, 2, and 4 are required (Input 4 is self-generated when not provided).

### 1. Evidence Prose (required)

The raw material. Every sentence contains or traces to one or more claim IDs (e.g., `[Q3-C04]`). Every claim ID provided in the evidence prose input for this section must appear somewhere in the output — either as a developed narrative point or as a compressed summary. None may be silently dropped. If the input appears to contain claims outside the section's architectural scope, flag the mismatch rather than silently dropping claims.

### 2. Document Architecture (required)

Governs structural decisions the skill cannot make independently:
- **Section length targets** — how many words this section should be. Respect within ±10%. If the evidence cannot fill the target, flag the gap rather than inflating.
- **Section positioning** — where this section sits in the document (opening, middle, closing). Affects rhetorical weight: opening sections need stronger framing; closing sections can assume prior context.
- **Emphasis hierarchy** — which topics the architecture marks as primary vs. supporting. Primary topics get full narrative development; supporting topics get summary treatment unless editorial annotations override.

### 3. Editorial Annotations (optional)

Specific directorial cues from the document architect or user. These override default emphasis decisions. Examples: "Foreground finding X, compress Y" / "This section should set up the argument in Section 4" / "Highlight the tension between A and B." When present, follow them. When absent, rely on architecture emphasis hierarchy and evidence density.

### 4. Style Reference (required — generate if not provided)

Voice and register constraints. When provided as input, apply directly.

**When no style reference is provided:** Before writing any narrative prose, read the `specifying-output-style` skill and use it to generate a style spec from the document architecture and evidence prose. This ensures every invocation writes to an explicit voice specification rather than an implicit default. Produce the style spec as part of the refinement mode output for user review before proceeding to narrative drafting.

**Note:** If `specifying-output-style` is not available in the current environment, generate a minimal style spec covering: register (formal/semi-formal), sentence length range, voice (active/passive preference), and any domain-specific terminology conventions visible in the evidence prose. Present for user confirmation. If the generated style spec appears inadequate (e.g., contradicts the document's domain conventions), present it with specific concerns before proceeding.

### 5. Supplementary Evidence Items (optional)

Items from the enrichment pipeline (produced by `enrichment-gap-identifier` → research execution). These arrive with a different structure than core evidence and occupy a subordinate tier.

**Format per item:**

```
[SUPPLEMENTARY]
Chapter/Section: [target section from architecture]
Gap type: Framing | Adjacent context | Anchoring
Finding: [the researched result — a sentence or short paragraph]
Source: [organization/author, title, date]
Grade: High | Medium | Low
Status: Resolved | No usable result
```

**Key differences from core evidence:**
- **No claim IDs.** Supplementary items do not carry claim IDs. They originate outside the Answer Spec → Evidence Pack pipeline.
- **No Answer Spec lineage.** They were not generated from research questions and do not trace to an Evidence Pack's component structure.
- **Tagged SUPPLEMENTARY.** The tag is the authoritative marker. If an item arrives without the tag but from the enrichment pipeline, treat it as supplementary and flag the missing tag.
- **Gap type carries forward.** The gap type (Framing, Adjacent context, Anchoring) constrains how the item can be used in prose (see Supplementary Evidence Rules below).
- **Status field.** Items with `Status: No usable result` are known absences — the enrichment pipeline identified a gap, research was conducted, and nothing usable was found. These require acknowledgment in prose (see Acknowledging Known Absences below).

**Provenance note:** Supplementary items exist because the enrichment-gap-identifier found reader-experience gaps in the report despite all Evidence Packs passing QC. They support, frame, or contextualize core findings. They do not replace core evidence. If any supplementary finding turns out to be material evidence for a core claim, flag it for retroactive addition to the relevant Evidence Pack with full QC — do not silently promote it.

## Writing Techniques

These are principles with examples, not rigid procedures. Adapt to context.

### Narrative Framing Without Invention

Every section needs a frame — a "so what" that tells the reader why the evidence matters. The constraint: this frame must be derivable from the evidence itself, not from general knowledge.

**Technique:** Read all claims in the section. Identify the collective implication — the thing all these claims, taken together, point toward. State it. Then let the evidence prove it.

**Safe framing patterns:**
- State the collective finding, then present supporting evidence
- Open with the most significant or surprising claim, then contextualize
- Frame around a tension or contrast that exists between claims

**Unsafe framing patterns (avoid):**
- Framing requiring knowledge not in the evidence ("The broader macroeconomic environment suggests...")
- Causal claims not supported by any claim ID ("This decline was caused by...")
- Forward-looking projections not in the evidence ("This trend is likely to continue...")

### Source-Text Independence

The most common failure mode: preserving the input's sentence structure. High-quality inputs are harder to transform because they feel "done."

**Test:** After drafting, compare output to input sentence by sentence. If more than 40% of sentences share the same structure (same subject-verb ordering, same clause sequence, same information order), you have not transformed — you have edited. Redraft. If uncertain whether you have met the 40% threshold, err on the side of more aggressive restructuring — the cost of over-transforming is low; the cost of producing a lightly-edited version of the input is high.

**Technique:** Before writing, extract from each input passage only: (a) the claims, (b) the claim groupings from your refinement pass, and (c) the section's narrative frame. Then write from those three inputs — not from the prose itself. The evidence prose is a claim delivery vehicle. Discard the vehicle, keep the claims.

### Transitions That Carry Forward

Transitions between findings should move the reader forward, not just sequence data points. Transitions cannot assert causal relationships unless a claim ID supports causation.

**Safe transition patterns:**
- **Architectural adjacency:** "With [established finding], the next dimension is [next finding]."
- **Contrast or extension:** "[Finding A]. However, [Finding B complicates/extends A]."
- **Scope shift:** "[Finding about the whole market]. Within [segment], [more specific finding]."

**Unsafe transition patterns (avoid):**
- **Causal bridges:** "Because of [A], [B] occurred." — unless a claim ID states this.
- **Temporal causation:** "Following [A], [B] emerged." — sequence is not causation unless evidence says so.
- **Imported logic:** "As is typical in such markets, [Finding]." — imports general knowledge.

### Emphasis vs. Summary Treatment

Not all claims deserve equal narrative space. The decision follows a priority stack.

**Priority stack (highest to lowest):**
1. **Editorial annotations** — if the user says "foreground X," X gets full development regardless
2. **Architecture emphasis hierarchy** — primary topics get full development; supporting get summary
3. **Evidence density** — claims with multiple or high-grade sources carry more weight
4. **Argumentative load** — claims anchoring the section's narrative frame deserve more space

**Full narrative development:** Claim stated, contextualized within the section's argument, given enough space for significance. Typically 2-4 sentences per claim or claim cluster.

**Summary treatment:** Claim stated cleanly in one sentence, attributed, not elaborated. Present for completeness.

**When priority signals conflict:** Editorial annotations win. If annotations absent and architecture conflicts with evidence density, flag the tension and follow architecture — the document architect made a deliberate choice.

### Clustering Quantitative Evidence

When a section contains multiple data points supporting the same assertion, do not tour them individually.

1. State the assertion the data collectively supports.
2. Cite the strongest or most recent data point inline as primary evidence.
3. Stack remaining data points as additional claim IDs or compress into "the data is consistent across sources."

**Bad (data walk):**
"As of 2024, the average was 6.1 years (Source A). Sector data shows 6–7+ years (Source B). US medians rose to 7.0 years (Source C)."

**Good (clustered):**
"PE firms now hold portfolio companies for six to seven years or longer — well above the assumption most non-PE professionals carry [C12] [C13] [C14]. The data is consistent across averages, medians, and sector-level breakdowns [C15]."

### Contextual Bridges

Some findings need a "why this matters" sentence. The constraint: this sentence must derive from the evidence base or the research question — not from general domain knowledge.

**Technique:** Connect the finding to the research question or document objective. The "so what" comes from the question that was asked, not from what you know about the world.

### Handling Thin Evidence

Some sections will have fewer claims than the architecture expects. Do not pad.

**When evidence is thin:**
1. State available findings cleanly and concisely
2. If output falls >25% short of architecture length target, flag it: "Evidence for this section supports approximately [X] words against a target of [Y]. The gap reflects limited source material, not editorial compression."
3. Do not generalize, speculate, or import context to fill space

**When evidence is contradictory:**
Present both sides. Do not resolve the contradiction. Preserve all relevant claim IDs. Flag the conflict for downstream review.

### Supplementary Evidence Rules

SUPPLEMENTARY-tagged items occupy a distinct tier from core evidence. They enrich the reader's experience but must never carry analytical weight.

**Permitted uses — context layer only:**
- **Historical framing:** baseline context (Framing gap items)
- **Comparative anchoring:** benchmarks (Anchoring gap items)
- **Adjacent context:** related developments (Adjacent context gap items)
- **Reader orientation:** background helping interpret a core finding

**Prohibited uses — these are violations:**
- Using a supplementary item as the basis for an analytical claim or section-level argument
- Citing a supplementary item to prove or substantiate a core finding
- Giving a supplementary item full narrative development as a primary finding
- Building a section frame around a supplementary item rather than core evidence

**The test:** If you removed every supplementary item from the prose, the core argument should still stand.

**Integration technique:** Weave supplementary items as subordinate clauses, parenthetical context, or brief orienting sentences. Common patterns:
- "Against a backdrop of [supplementary context], [core finding with claim ID]..."
- "[Core finding] [claim ID]. For context, [supplementary benchmark]."
- "While [supplementary adjacent context], the primary dynamic remains [core finding]."

### Acknowledging Known Absences

When a supplementary item arrives with `Status: No usable result`, acknowledge architecturally relevant absences rather than silently skipping them.

**When to acknowledge:**
- The gap is architecturally relevant (reader would notice the absence)
- The absence affects interpretation of a core finding
- A knowledgeable reader would expect this context

**When to skip:** The gap was marginal, core evidence already covers it implicitly, or acknowledgment would distract.

**Prose patterns:**
- "Comprehensive data on [X] remains limited, though [core finding] suggests..."
- "While industry-wide benchmarks for [X] are not readily available, [core finding provides partial context]."
- "No established baseline exists for [X] in this context; [core finding] should be interpreted with this limitation in mind."

Keep acknowledgments to one sentence. Do not editorialize about why data is missing or speculate about what it might show.

## Output Structure

Produce report-quality narrative prose with claim IDs preserved inline (e.g., `[Q3-C04]`). Claim IDs remain in the output for downstream processing by `citation-converter`.

If supplementary items were used, include a brief appendix listing which supplementary items were integrated and where, so `citation-converter` can handle them appropriately.

## Constraints

### The Orphan Sentence Test

Every sentence in the output prose must trace to one or more claim IDs from the input. Before finalizing, scan for orphan sentences — sentences that read well but don't connect to any claim.

**Common orphan sentence patterns to catch:**
- Generalizing openings: "The Nordic PE market has undergone significant transformation in recent years."
- Connective filler: "These dynamics are well understood by industry participants."
- Speculative closers: "This trend shows no signs of abating."

**When you feel the urge to write a sentence and can't point to a claim ID:** Delete it. If the sentence feels necessary for narrative flow, check whether a claim in the evidence supports a version of it. If not, cut it.

**Exception:** Sentences stating the research question or section objective derive from the architecture, not from evidence claims — these are not orphans.

**Supplementary evidence and orphan testing:** Sentences sourced from SUPPLEMENTARY items are not orphans — they trace to a supplementary item. Sentences acknowledging known absences (from `Status: No usable result` items) also derive from the enrichment brief's gap identification and are not orphans.

### Length Discipline

- Respect architecture length targets within ±10%
- If running over: compress summary-treatment claims first, then tighten full-development claims. If still >15% over, flag it: "Evidence density exceeds the architecture allocation. Recommend expanding the target to [estimated length] or splitting the section." Do not drop claims to meet the target.
- If running under: flag the gap (do not inflate)
- Never pad thin sections with generalizations, restatements, or imported context

## Output Protocol

**Hard gate:** Do not produce the full narrative section until the user issues the `RELEASE ARTIFACT` command. Until then, present only refinement mode outputs.

Default to refinement mode: present the proposed narrative structure (section frame, emphasis decisions, claim groupings) and flag any gaps or tensions before drafting. If supplementary items are provided, include a brief note on where each will be integrated and confirm no supplementary item is being used as core analytical support. If no style reference was provided, generate the style spec during refinement (see Input 4) for user review. Write final output to file. File path is determined by the invoking workflow — if not specified, ask before writing.

## Quality Self-Check

Before delivering, verify:

- [ ] Every claim ID provided for this section appears in the output (developed or summarized)
- [ ] No orphan sentences (every factual assertion traces to a claim ID or supplementary item)
- [ ] Claim IDs preserved inline for downstream citation conversion
- [ ] Length within ±10% of architecture target
- [ ] Editorial annotations followed (if provided)
- [ ] Emphasis hierarchy matches architecture + annotation cues
- [ ] Thin evidence flagged, not padded
- [ ] Style spec applied (provided or generated)
- [ ] Supplementary tier discipline: no SUPPLEMENTARY item used to support, prove, or substantiate a core analytical claim
- [ ] Known absences addressed: every `Status: No usable result` item reviewed; decision (acknowledged or skipped) recorded

## Edge Cases

**Architecture expects more than evidence supports:** Flag the gap with estimated word count shortfall. Do not pad. Suggest additional evidence may be needed or the architecture target should be revised.

**Editorial annotations conflict with evidence weight:** Follow the annotations. Note the tension briefly in chat (not in the document): "Annotation asks to foreground X, but evidence for X is thinner than for Y. Following annotation as directed."

**Evidence contradicts across sources:** Do not resolve. Present the range or contrast explicitly (e.g., "Estimates range from X [claim ID] to Y [claim ID]"). Flag for downstream fact-verification.

**Style spec conflicts with narrative clarity:** Follow the style spec for voice and register. If a style constraint would force an unclear or misleading sentence, flag it and propose an alternative respecting both clarity and voice.

**Supplementary item appears material to a core claim:** Do not silently promote it. Flag it: "Supplementary item [#] appears material to core claim [claim ID]. Recommend retroactive addition to Evidence Pack [X] with full QC before using as core evidence." In the interim, use it only in its permitted supplementary role.

**Supplementary items without the SUPPLEMENTARY tag:** If items arrive from the enrichment pipeline but lack the tag, treat as supplementary and flag the missing tag. Do not treat untagged enrichment items as core evidence.

**All supplementary items for a section have Status: No usable result:** Acknowledge the most architecturally relevant absence(s) — one or two well-placed acknowledgments, not a list of limitations.

**Supplementary item contradicts core evidence:** Follow core evidence. Note the discrepancy but do not surface it in prose. Supplementary items do not have standing to challenge core findings that passed Evidence Pack QC.
