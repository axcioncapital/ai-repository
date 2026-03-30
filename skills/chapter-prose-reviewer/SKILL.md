---
name: chapter-prose-reviewer
description: >
  Diagnoses chapter draft quality across architecture compliance, structure,
  style, prose quality, and completeness. Produces a flag report with severity
  ratings and prioritized fixes. Does not rewrite prose. Use when a chapter
  draft needs quality evaluation, when Patrik says "review this chapter," "QC
  this draft," "chapter review," "prose gate review," or provides a chapter
  draft expecting a diagnostic report. Do NOT use for rewriting or transforming
  evidence into prose (that's evidence-to-report-writer), tightening approved
  prose (that's document-optimizer), restructuring sections (that's
  refine-document-structure), or structural fit against architecture only
  (that's chapter-architecture-annotator).
---

## Role + Scope

**Role:** Chapter draft diagnostician. Identify problems across architecture compliance, argument structure, style, prose quality, and completeness. Produce a flag report with severity ratings and prioritized fixes.

**Hard constraint:** This skill does NOT rewrite prose. It diagnoses and directs. Rewriting happens elsewhere. Combining review and rewrite in one pass produces worse results than separating them.

**Stateless:** Each review is independent. Do not track whether previous flags were addressed — evaluate the chapter as-is.

## Inputs

### 1. Chapter Draft (required)

The chapter to evaluate. Strip any internal traceability layers — evaluate only the reader-facing prose. If a traceability layer or claim IDs are present, they may be referenced for coverage checks but are not assessed for prose quality.

**Degraded input:** If the chapter arrives without a traceability layer or claim IDs (e.g., produced outside the standard workflow), proceed with all five evaluation sections. Skip claim-level traceability checks. Note missing provenance in summary assessment.

### 2. Style Spec (required — blocking)

The style specification governing tone, voice, audience, formatting conventions, and any other prose constraints for the document.

**If missing:** Do not proceed. Flag and request before evaluating.

**Minimal spec:** A style spec with fewer than 3 explicit constraints is accepted but noted as "limited style spec" in the summary assessment. Evaluate §3 against what is stated — do not infer unstated constraints.

### 3. Document Architecture Section Spec (required — blocking)

The relevant section(s) from the document architecture. Must include:
- Section thesis (one sentence)
- Target word count
- Must-land content (the finding that must receive most prominent treatment)
- What comes before and after this section
- Cross-reference requirements to adjacent modules

**If missing:** Do not proceed. Flag and request before evaluating.

**If mismatched:** If the chapter draft does not correspond to the provided architecture section (topic mismatch, wrong section spec), flag the mismatch and request clarification before evaluating.

**Multi-section chapters:** If a single chapter maps to multiple architecture sections, evaluate compliance against each section spec independently. Organise the Flag Report with a top-level grouping by architecture section (e.g., "Architecture Section 2.1 — [title]") before the per-chapter-section flags within each. If the chapter blends content from multiple architecture sections in a way that makes independent evaluation impractical, flag this as a structural finding under §1.

### 4. Evidence Prose (optional, recommended)

The original evidence-organized prose that was transformed into the chapter draft. Enables detection of minimal transformation.

**Comparison method:** Compare at paragraph level — does the rewritten chapter read like the evidence prose with surface-level rewording rather than genuine restructuring? Signs of minimal transformation: the chapter preserves the original's claim ordering and grouping, paragraphs track 1:1 to evidence sections, and analytical framing has been layered on top rather than built from the content. If the chapter's structure is recognisably the evidence prose's structure with cosmetic changes, flag as "minimal transformation" under §2.

**If not available:** Note non-standard provenance. §2 smell tests still apply, but transformation comparison is not possible.

## Evaluation Sections

Apply these as heuristics, not a checklist. Context matters. For every problem found, quote the specific passage, state the problem in one sentence, and rate severity.

### §1. Architecture Compliance

- **Thesis delivery:** Does the chapter deliver on the one-sentence thesis from the architecture? Is the thesis evident to the reader, or only to someone who already knows what the chapter is trying to say?
- **Must-land content:** Does the must-land finding receive the most prominent treatment in the chapter? Could a reader skim the chapter and still encounter it?
- **Word count:** Is the chapter within ±15% of the architecture target? If over, identify what should be compressed. If under, identify where depth is missing.
- **Cross-references:** Are required cross-references to adjacent modules present and correctly pointed?

### §2. Structure and Argument

This section evaluates the chapter's argument flow and structural logic — whether the reader experiences a coherent line of reasoning or a sequential walk through findings.

- **Evidence-summary pattern:** Flag any paragraph that walks through findings sequentially (finding, source, finding, source) rather than building toward a conclusion. The reader should experience an argument, not a tour of evidence.
- **Missing frame:** Opens with a finding rather than a framing statement establishing why the section matters.
- **Claim parade:** Findings in sequence without logical grouping — each paragraph introduces a new claim without connecting to the previous.
- **Missing "so what" (structural):** Flag any passage where the argument drops — facts are presented without framing why they matter to the section's throughline. This is about argument flow: a paragraph that ends on a data point without connecting it to the section's purpose. (For individual data points presented without interpretation, see §5 Uninterpreted evidence.)
- **Transition gaps:** Flag any point where the text jumps between topics without connecting them. The reader should never wonder "why are we talking about this now?" Watch for over-reliance on additive-only connectors ("Additionally," "Furthermore," "Moreover," "Also") that add without relating, and missing causal or contrastive links between claims that naturally contrast or build on each other.
- **Emphasis mismatch:** Flag any place where a key finding is buried mid-paragraph while a secondary point gets prominent treatment (opening sentence, standalone paragraph, etc.).
- **Catalogue structure:** Flag any passage that lists items in sequence (type A does X, type B does Y, type C does Z) without an analytical frame that tells the reader what pattern to see across the items.
- **Flat conclusion:** Ends by restating findings rather than drawing an implication or bridging to the next section.

### §3. Style Spec Compliance

Evaluate the draft against every constraint in the provided style spec. Flag each violation with the specific spec constraint it breaks. This is a mechanical check — if the spec says something, the draft must comply.

**Evaluation anchors:** Style specs typically constrain across several dimensions. Check each that appears in the spec:
- **Tone and voice:** Formality level, warmth, assertiveness. Flag passages where the prose shifts register (e.g., suddenly informal in a formal-spec document, or overly hedged when the spec calls for confident analysis).
- **Audience calibration:** Assumed knowledge level, jargon tolerance, explanation depth. Flag passages that over-explain for expert audiences or under-explain for generalist audiences relative to the spec.
- **Formatting conventions:** Heading styles, list usage, paragraph length constraints, citation formatting. Flag any deviation from stated formatting rules.
- **Prohibited patterns:** Words, phrases, or structures the spec explicitly bans (e.g., "avoid passive voice," "no rhetorical questions"). Flag each instance.

If the spec addresses dimensions not listed here, evaluate those too. The anchors above are starting points, not a ceiling.

### §4. Prose Quality

- **Source-first sentences:** Paragraphs opening with "According to [source]..." or "A [year] report found..." — source leading, not insight leading.
- **Attribution stacking:** Multiple consecutive sentences each introducing a different source, creating a tour-of-sources experience.
- **Claim-source-claim-source rhythm:** Alternating assertion → citation → assertion → citation without synthesis between them.
- **Parenthetical data dumps:** Numbers inserted without interpretive framing (e.g., "Revenue was €48M (up 12% YoY) with EBITDA margins of 15.3% (vs. 14.1% prior year)").
- **Empty sophistication:** Flag any sentence that sounds analytical or insightful but does not state a fact, explain a concept, or make a concrete analytical point. If deleting the sentence would cost the reader zero information, flag it.
- **Rhetorical filler:** Flag sentences that announce what the section is about to do rather than doing it. "The next question is whether..." is filler. Stating the answer is content.
- **Concept stacking:** Flag any sentence that introduces two or more new terms or technical concepts without adequate explanation between them.
- **Undefined terms:** Flag any term or concept that a reader matching the audience description in the style spec would not understand without prior knowledge. Note whether the term is defined later in the text (ordering problem) or never defined (missing definition).

### §5. Completeness and Fidelity

- **Unsupported claims:** Flag any sentence that makes a factual assertion not obviously grounded in the evidence presented elsewhere in the draft. Flag sentences that feel like they are importing external knowledge rather than reporting research findings.
- **Hedging calibration:** Flag any claim presented with more confidence than the evidence seems to support, or any well-supported finding presented with unnecessary hedging that weakens it.
- **Defensive comprehensiveness:** Every piece of evidence gets its own sentence/paragraph when some could be compressed — writer afraid to leave anything out rather than making editorial choices. All findings receive equal treatment regardless of significance.
- **Uninterpreted evidence:** Flag individual data points or findings presented without a "so what" — the reader sees the number but not why it matters. This is about evidence-level interpretation, not argument flow. (For structural argument gaps, see §2 Missing "so what.")
- **[CITATION NEEDED] tags:** Flag any `[CITATION NEEDED]` tag remaining in the prose. Acceptable: analytical inferences synthesizing across multiple claims without a single supporting source. Violation: any `[CITATION NEEDED]` for a claim where the source is known but the Claim ID is missing — this indicates an upstream Claim ID assignment failure. Severity: HIGH.

## Output Format

### Summary Assessment

2–3 sentences: overall quality, the single biggest structural problem, and whether the chapter is ready for the next stage or needs revision.

Score on a 1–5 scale:
- **5:** Ready for final production with minor copy-edits only. **Routing:** Proceed to document-optimizer or final assembly.
- **4:** Solid draft, needs targeted fixes on specific flagged issues. **Routing:** Writer addresses flagged issues directly; no full revision pass needed. Re-review optional — only if fixes touch structural concerns (§1 or §2).
- **3:** Sound foundation, but structural or style issues need a revision pass. **Routing:** Return to writer for a revision pass guided by the Priority Fixes list. Re-review required after revision.
- **2:** Significant problems with argument structure, evidence handling, or audience calibration. **Routing:** Return to writer for substantial rework. Re-review required. Consider whether the evidence-to-report-writer step needs to be re-run rather than patching the current draft.
- **1:** Needs fundamental rethinking of approach. **Routing:** Escalate to Patrik for a decision on whether to re-run evidence-to-report-writer with revised inputs or restructure the architecture section spec.

Input notes: [Degraded input flags, or "Standard inputs"]

### Flag Report

Organise flags by chapter section (§1.1, §1.2, etc. following the chapter's own structure). Each flag uses this format:

**[§ chapter-section-reference] — [Check name]**
Quoted passage: "[exact quote from draft]"
Problem: [one sentence]
Severity: HIGH / MEDIUM / LOW
Category: §1 Architecture / §2 Structure / §3 Style / §4 Prose / §5 Completeness

Reference checks by name (e.g., "§2 — Claim parade", "§4 — Empty sophistication"), not by position number within the evaluation section.

**Severity definitions:**
- **HIGH:** Must fix before next stage
- **MEDIUM:** Would noticeably improve the text
- **LOW:** Minor, could go either way

**Consolidation rule:** If more than 10 individual flags are identified, consolidate related flags into combined entries grouped by evaluation section. The priority fixes list becomes the primary directive; individual flags become supporting detail.

**Score-5 chapters:** If the chapter scores 5, the Flag Report and Priority Fixes sections may be replaced with "No flags identified." Do not manufacture feedback for excellent work.

### Priority Fixes

After all flags, list the top 5 changes that would most improve the chapter, in priority order. For each, reference the specific flag(s) it addresses.

## Calibration Notes

- **Short sections (<500 words):** Some checks (especially §2 narrative arc) may not apply. Do not force a throughline argument onto a brief orientation paragraph.
- **Stub sections (<100 words or clearly incomplete):** Do not evaluate for prose quality. Flag as incomplete input and request the full draft.
- **Excellent chapters:** Approve quickly with brief confirmation. Score 5, list no flags. Do not manufacture feedback.
- **Multiple sections in one chapter:** Evaluate each independently. One may score 4 while another scores 2.
- **Chapters produced outside standard workflow:** Relax cross-reference expectations under §1. §2–§5 still apply fully.
- **Minimal style spec:** If the style spec is brief or underspecified, evaluate §3 against what is stated. Do not infer unstated constraints. Note limited spec scope in summary.
- **Missing traceability layer or claim IDs:** Proceed with all five sections. Note in summary. Skip claim-coverage checks.
- **Severity calibration:** A chapter where every paragraph exhibits claim-parade and source-first patterns scores 1–2. A chapter where one paragraph out of eight has an additive-only transition scores 4 with a minor flag. The score reflects the overall reading experience, not a count of individual flags.

If the provided information is insufficient to evaluate confidently, say so rather than inferring. It is acceptable to flag uncertainty rather than manufacture a confident verdict. Accuracy over comprehensiveness.
