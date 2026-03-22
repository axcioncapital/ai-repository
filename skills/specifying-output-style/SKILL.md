---
name: specifying-output-style
description: >
  Analyzes a refined draft to crystallize what the document is actually trying
  to be. Produces a locked specification (type, depth, length, purpose, voice)
  that makes explicit what emerged organically during drafting — catching scope
  drift and locking parameters before final production. Use when: (1) a refined
  draft needs its output parameters locked before final production, (2) requests
  like "spec this document," "what is this draft trying to be," "lock the output
  spec," "document specification," (3) a draft is provided and parameters need
  to be crystallized. Do not use for: final document production, applying
  style/tone during writing, or structural editing of drafts.
---

## Role

Analyze a refined draft to infer what the document is actually trying to be. The spec makes explicit what emerged organically during drafting — catching scope drift and locking parameters before final production.

## Workflow

1. **Read the draft thoroughly** — understand the full argument, structure, and positioning before inferring the spec
2. **Identify what emerged** — note the subject matter, apparent purpose, intended audience, and how the document actually reads (not what was originally intended)
3. **Infer dimensions** — determine appropriate settings for each of the five dimensions based on what the draft is actually doing
4. **Check coherence** — verify the proposed combination is not problematic (see Coherence Check below)
5. **Flag drift** — if the draft pulls in conflicting directions (e.g., trying to both inform neutrally and persuade), surface this tension
6. **Propose specification** — present a complete specification block with brief rationale for key choices
7. **Confirm or adjust** — Patrik confirms, adjusts specific dimensions, or rejects. Iterate until the spec is locked.

This skill's output is the locked spec. Final production is triggered separately.

## Specification Block Format

Always output this exact structure:

```
DOCUMENT SPECIFICATION

Type:       [Strategic Plan / Proposal / Project Plan / Documentation / Other: describe]
Depth:      [Scan / Overview / Detailed / Exhaustive]
Length:     [Current: X words → Target: Y words (Brief/Standard/Substantial/Comprehensive)]
Purpose:    [Inform / Align / Decide / Document / Persuade]
Voice:      [Analytical / Directive / Deliberative] + optional modifiers

Context:    [Brief description of situation and background]
Audience:   [Who will read this, what do they already know]
Key output: [What should the reader know, believe, or do after reading]
```

For Context, Audience, and Key output: infer from the draft itself and any conversation context provided alongside it. If these cannot be reliably inferred from available information, ask Patrik before finalizing the spec. Do not invent audience or context details based on assumptions about the subject matter.

## Inference Logic

### Type

Look for structural signals in the draft:
- Explicit recommendations, asks, or calls to action → **Proposal**
- Time horizons, priorities, strategic objectives, "we will" language → **Strategic Plan**
- Timelines, milestones, responsibilities, deliverables, workstreams → **Project Plan**
- Process descriptions, how-to sections, reference-style structure → **Documentation**
- None of the above → **Other:** describe what it actually is (memo, briefing, one-pager, email, etc.)

### Depth

Look for how fully ideas are developed:
- Bullet points, topic identification only, no supporting reasoning → **Scan**
- Main arguments visible but rationale underdeveloped, gaps remain → **Overview**
- Full reasoning with evidence, examples, counterarguments acknowledged → **Detailed**
- Edge cases covered, alternatives analyzed, implementation specifics, stress-tested assumptions → **Exhaustive**

### Length

Compare current draft length against appropriate target:

1. Count current word count
2. Determine appropriate target based on purpose and depth:
   - Scan/Inform on single issue → **Brief** (500–1,000 words)
   - Overview/Align or focused Detailed → **Standard** (1,500–2,500 words)
   - Detailed/Decide with multi-part scope → **Substantial** (3,000–5,000 words)
   - Exhaustive/Document for long-term reference → **Comprehensive** (6,000–10,000+ words)
3. Report both: "Current: X words → Target: Y words (Category)"
4. If mismatch, note whether final production should expand or compress

### Purpose

Look for what the draft is trying to accomplish:
- Explains without asking for anything, neutral tone → **Inform**
- Presents a view but invites discussion, "considerations," open questions → **Align**
- Options with pros/cons, explicit recommendation, "we recommend" → **Decide**
- Captures how something works/was decided for future reference → **Document**
- Builds a case, anticipates objections, marshals evidence toward a position → **Persuade**

### Voice

Look for the draft's rhetorical stance:
- Balanced presentation, hedged claims, "on one hand / on the other" → **Analytical**
- Clear thesis upfront, confident assertions, action-oriented → **Directive**
- Multiple perspectives, unresolved tensions, "it depends" → **Deliberative**

**Modifiers** (add when observable):
- Every sentence advances the argument, no redundancy → **Dense**
- Room for explanation, context, breathing room → **Spacious**
- External audience or high-stakes → **Formal**
- Internal iteration, pragmatic tone → **Working**
- States conclusions with conviction → **Definitive**
- Acknowledges limitations openly → **Measured**

## Coherence Check

Before proposing, verify the combination is coherent. Problematic combinations to avoid:
- **Scan + Persuade** — cannot persuade without reasoning
- **Exhaustive + Brief** — mathematically impossible
- **Analytical + Persuade** — neutrality undermines advocacy
- **Deliberative + Document** — documentation requires resolution

If the draft suggests a problematic combination, flag this and propose the nearest coherent alternative.

## When Inference Is Uncertain

**Mixed signals within a dimension:** When a dimension shows competing signals (e.g., the draft reads as both Inform and Persuade), present the two strongest candidates with a one-line rationale for each and let Patrik choose. Do not force a single answer when the draft genuinely pulls in two directions.

**Draft too fragmentary:** If the draft is too early-stage to infer reliably (e.g., bullet-point outlines under 200 words), state which dimensions cannot be reliably inferred and ask for guidance rather than guessing. The skill expects a draft that has been through at least one round of structural and content refinement.

**No clear Type match:** When the draft does not fit Strategic Plan, Proposal, Project Plan, or Documentation, use "Other" and describe what it actually is. This skill is designed for business and strategic documents. For creative content, marketing copy, or highly technical specifications, the dimensions may not map cleanly — flag this to Patrik rather than forcing the framework.

## Output Format

Present the specification block, followed by a brief rationale (2–4 sentences) covering only dimensions where the choice was not self-evident or where an alternative was seriously considered. Do not justify obvious choices. When a dimension was a judgment call, note the alternative considered so Patrik can adjust.

If scope drift is detected, flag it before the specification block:

**Drift detected:** The draft appears to be pulling in two directions — [describe the tension]. The spec below resolves this by [how it resolves], but you may want to [alternative approach].

Example:

```
DOCUMENT SPECIFICATION

Type:       Proposal
Depth:      Detailed
Length:     Current: 2,800 words → Target: 3,500 words (Substantial)
Purpose:    Decide
Voice:      Directive, formal

Context:    Partnership proposal for Latin America expansion with Arturo
Audience:   Arturo (potential partner), assumes M&A advisory familiarity
Key output: Arturo understands the opportunity and is ready to discuss terms
```

**Rationale:** Directive voice appropriate since this advocates for a specific partnership structure. Detailed depth ensures the proposal stands alone without verbal explanation. Current draft is slightly under target — final production should expand the market opportunity section.
