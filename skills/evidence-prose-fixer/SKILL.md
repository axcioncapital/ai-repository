---
name: evidence-prose-fixer
description: >
  Resolves fidelity flags from the Fact Verification Checker (CustomGPT) by
  producing targeted corrected prose passages. Use when a verification report
  with typed/severity-classified flags (Orphan Claim, Grade Inflation, Qualifier
  Drop, Causal Upgrade, Scope Creep, Missing Evidence) is provided alongside the
  chapter draft and evidence pack, and corrections are needed before document
  integration. Triggers on requests like "fix these flags," "apply corrections,"
  "remediate the verification report," "resolve distortions," "fix the chapter,"
  "next step after verification," or when a verification report is provided
  alongside a chapter draft with expectation of corrected prose. Do NOT use for
  verifying prose against evidence (that's the Fact Verification Checker
  CustomGPT), rewriting chapters from evidence (that's evidence-to-report-writer),
  evaluating prose quality (that's chapter-prose-reviewer), or evaluating
  structural fit (that's chapter-architecture-annotator).
---

## Role + Scope

Fidelity remediation. Produce targeted prose corrections that resolve flags from the Fact Verification Checker (CustomGPT) without degrading narrative quality.

**Hard constraints:**
- Do not rewrite unflagged prose.
- Do not introduce new claims not present in the evidence pack.
- Do not flatten prose into evidence-summary style. The chapter already passed prose quality review — preserve that work.
- Do not re-adjudicate flag classifications. Trust the verification report's typing and severity. **Exception:** If a flag's described issue clearly does not match its type label, apply the fix strategy matching the described issue and note the apparent misclassification in the Rationale field.

**Sibling skills:**
- Runs after the Fact Verification Checker CustomGPT (consumes its verification report).
- Does not replace `evidence-to-report-writer` (builds prose from evidence; this skill patches existing prose).
- Does not replace `chapter-prose-reviewer` (evaluates narrative quality; this skill preserves it).

## Inputs

### Input 1: Verification Report (required — blocking)

The structured flag list from the Fact Verification Checker (CustomGPT). Must include flag type, severity, quoted prose passage, evidence references, and issue description.

If missing: Do not proceed.

### Input 2: Chapter Draft (required — blocking)

The prose chapter containing the flagged passages. Needed to produce context-aware replacements that preserve surrounding narrative flow.

If missing: Do not proceed.

### Input 3: Evidence Pack (required — blocking)

The evidence table(s) covering the chapter's scope. Needed to write evidence-faithful corrections — specifically to check claim content, evidence grades, linkage types, qualifiers, and scope fit.

If missing: Do not proceed.

**Partial mismatch:** If a flag references evidence rows (Claim IDs) not found in the provided evidence pack, defer that flag to the Deferred Flags section with a note that the evidence basis could not be verified. Do not guess at corrections without evidence access.

### Input 4: Document Architecture Section Spec (optional)

The relevant section spec. Helps calibrate Scope Creep fixes — some synthesis beyond individual evidence rows may be architecturally intended.

If missing: Proceed, but note that Scope Creep fixes may be more conservative than necessary.

## Fix Strategies by Flag Type

### Orphan Claim

Remove unsupported assertions, or soften to clearly editorial framing when the claim serves a structural purpose.

Strategies in order of preference:
1. **Remove** if the claim is prescriptive, normative, or a credibility judgment with no evidence basis.
2. **Soften to editorial** if the claim is a meta-observation about the evidence base (e.g., "evidence is source-concentrated") and serves a structural purpose. Reframe as explicitly interpretive: "Reading across the evidence set suggests..." or "A notable limitation is..."
3. **Anchor to evidence** if a nearby evidence row partially supports the claim — narrow the claim to what the row actually says.

After removal, check whether the surrounding paragraph still flows. If removal creates a logical gap, add a minimal bridging sentence drawn from evidence.

**Tiebreaker — thesis orphans:** When an orphan claim serves as a paragraph or section thesis, prefer anchoring to evidence over removal. If no evidence row supports even a narrowed version, soften to editorial framing and flag in the Integration Note that the section's argument may need restructuring upstream.

### Grade Inflation

Add confidence signaling matched to the evidence grade. Prefer source-naming over generic hedging.

Calibration:
- **High-grade evidence** supports definitive statements and unhedged assertions. No change needed.
- **Medium-grade evidence** requires hedging. Preferred patterns:
  - Name the source: "Morgan Stanley defines..." rather than "Practitioners define..."
  - Source-type attribution: "Available practitioner definitions indicate..."
  - Tentative framing: "Evidence points toward...," "The data suggests..."
- **Low-grade evidence** requires explicit qualification: "Limited evidence suggests...," "One source reports..."

**Cross-source generalization fix:** When prose uses "consistently," "broadly," "similarly" across Medium-grade rows, either name the specific sources or replace with "available sources indicate" / "definitions reviewed here centre on."

### Qualifier Drop

Restore the qualifier from the evidence support snippet. Match epistemic precision without making prose clunky.

Compare the prose phrasing to the evidence row's support snippet word by word. Identify the specific qualifier that was dropped (e.g., "typically" -> "always," "suggests" -> "shows"). Reinsert the qualifier or its functional equivalent. If the original qualifier is awkward in context, use a synonym that preserves the same epistemic weight.

### Causal Upgrade

Decompose unified causal chains into enumerated characteristics. Shift from causal framing to co-occurrence where evidence linkage types don't support causation.

1. Check the Linkage Type column for each cited evidence row.
2. If linkage is Explicit for all elements in the chain: causal language may be appropriate; verify the chain itself (not just individual links) is evidenced.
3. If linkage is mixed (Explicit + N/A + Inferred): replace unified chain with enumerated elements: "Sources identify several linked elements: [a], [b], [c]."
4. Remove "recurring causal chain," "consistent across sources," or similar unifying language unless every link in the chain has Explicit linkage from multiple sources.

### Scope Creep

Narrow the claim to evidence scope. If synthesis is architecturally intended, add hedging rather than removing.

1. If architecture spec is available: check whether the synthesis is called for. If yes, add hedging ("Reading across these findings suggests...") rather than cutting.
2. If architecture spec is unavailable or the synthesis is not called for: narrow the claim to what individual evidence rows support. Replace generalizations with specific findings.
3. When prose aggregates disparate metrics (e.g., ticket value vs. EV vs. fund size), make the measurement bases explicit rather than presenting them as a unified range.

### Missing Evidence

Always defer to human. The skill does not decide editorial priorities.

Do not auto-insert content. Report the gap in the Deferred Flags section with: which evidence rows exist, what they cover, and a brief note on whether the omission seems intentional or accidental based on the chapter's apparent scope.

## Processing Order

Process flags by severity, highest first:

1. **Distortions** (must fix). After each fix, verify the replacement doesn't create a new narrative gap or introduce a new unsupported claim.
2. **Omissions** (should fix). Batch confidence-signaling fixes where the pattern is systematic (e.g., multiple Grade Inflation flags from the same hedging gap). This is more efficient and produces more consistent prose than fixing one at a time.
3. **Ambiguities** (refine if warranted). Apply light-touch fixes. If the prose is defensible as-is, note "no change needed" with a one-sentence justification rather than forcing a correction.

**Overlapping flags:** When multiple flags target the same or overlapping prose passages, group them and produce a single combined fix referencing all addressed flag numbers. Apply the highest-severity flag's strategy first, then layer in lower-severity corrections.

## Correction Principles

- **Minimum necessary change.** Edit the flagged passage. Do not rewrite surrounding paragraphs.
- **Preserve transitions.** If a fix changes how a paragraph opens or closes, ensure the transition to/from adjacent paragraphs still works.
- **Source-naming over generic hedging.** "Morgan Stanley defines PE as..." is better than "Some sources suggest PE is..." — more informative, less evasive.
- **Don't strip editorial voice.** Fidelity is not flatness. A well-hedged interpretive statement is fine. An unhedged assertion on Medium evidence is not.
- **When in doubt, hedge rather than remove.** Especially for Ambiguity-severity flags — a qualifier addition is less disruptive than a deletion.

If the provided information is insufficient to write a faithful correction (e.g., evidence row referenced in the flag is ambiguous), say so rather than guessing. Flag it for human review in the Deferred section.

## Output Format

```
CORRECTION REPORT
Section: [Chapter/section identifier]
Flags addressed: [count] of [total flags]
Flags deferred to human: [count]

---

FIX [n] — addresses Flag [n]
Type: [flag type] | Severity: [severity]

Original: "[quoted prose passage, <=50 words]"
Corrected: "[replacement passage — minimum replacement scope, typically the sentence
or clause, not the full paragraph; include surrounding context only when the fix
requires a transition adjustment]"
Rationale: [1-2 sentences — what changed and why]

---

[Repeat per fix]

DEFERRED FLAGS

Flag [n] — [flag type] | [severity]
Evidence rows: [Claim IDs]
Gap: [What evidence exists but isn't covered / what the issue is]
Recommendation: [Brief note on whether this seems intentional or warrants attention]

---

[Repeat per deferred flag]

INTEGRATION NOTE
[Warnings about narrative flow impacts from the corrections. Note any places where
adjacent sentences may need minor transition adjustments. Flag if a Distortion removal
collapsed a paragraph's thesis and a bridging sentence was added.]
```

## Bias Countering

- **Don't over-correct.** If prose is close to the evidence and the flag is Ambiguity severity, a small qualifier addition beats a rewrite.
- **Permit "no change needed."** For marginal Ambiguity flags where the prose is defensible, state this explicitly rather than manufacturing a correction.
- **Don't manufacture bridging content.** When removing an orphan claim, a simple deletion is better than inventing a new transition that might itself become an orphan claim. Only add bridging sentences when the gap genuinely breaks comprehension, and draw bridging content strictly from the evidence pack.
- **Avoid confidence-signaling pile-up.** When batching Grade Inflation fixes in a section, vary the hedging patterns (source-naming, tentative framing, attribution) to avoid repetitive "According to... According to... According to..." cadence.
