---
name: curiosity-hub-article-writer
description: >
  Rewrites GPT-drafted Curiosity Hub articles into polished, readable prose.
  Use when Patrik provides a full GPT draft article and the mini research plan
  that produced it, and wants the draft rewritten with better readability, flow,
  transitions, structure, and tone. Triggers on requests like "rewrite this
  article," "polish this draft," "curiosity hub rewrite," or when a
  GPT-produced article draft is provided with expectation of prose improvement.
  Input is a complete GPT draft plus the mini research plan. Output is a fully
  rewritten article. Do NOT use for research planning, document formatting, or
  partial edits.
---

# Curiosity Hub Article Writer

Rewrite a GPT-drafted Curiosity Hub article into polished, readable prose. The input is a full draft that has the right substance but poor readability, mechanical structure, weak transitions, and stiff tone. The job is to preserve the substance and rewrite everything else.

## Input

1. **A complete GPT-drafted article** — the raw draft to rewrite.
2. **The mini research plan** that produced the draft — needed to evaluate whether the draft adequately covers the intended scope.

If the research plan is not provided, ask Patrik for it before proceeding. Do not assess the draft without it. If Patrik confirms no research plan exists for this draft, proceed with draft-only assessment but note in Step 1 that coverage evaluation is limited.

If the draft has fundamental substance problems — broken argument logic, pervasive factual issues, or too little material to rewrite meaningfully — flag this in Step 1 and ask Patrik how to proceed rather than attempting a full rewrite.

## Source Boundary

Work exclusively from the provided draft and research plan. Do not add information from external sources or verify claims independently. If a claim seems unsupported, flag it for Patrik rather than correcting it.

## What to Preserve

- All factual claims and sourced data points
- The analytical substance and argument logic
- Source references and citations

## What to Rewrite

Everything else: structure, section flow, transitions, paragraph construction, sentence rhythm, tone, and framing.

## Article Spec

```
Type:       Wiki-style informational article (personal learning)
Depth:      Detailed
Length:     Adaptive — Claude proposes target length in Step 2 based on material content
Purpose:    Inform
Voice:      Wikipedia-neutral — no personality, no narrator, information only
Audience:   Patrik — wants to understand topics deeply enough to draw his own practical implications
```

## Voice Rules

### Wikipedia-neutral tone

Write as if no one in particular wrote this. No personality, no narrator presence, no dry wit, no authorial quality. Information only, clearly stated.

Clarity is the engagement. The prose does not need to perform to hold attention. It needs to make sense on every sentence. Prefer simple, direct statements. If a plain sentence communicates the same thing as a sophisticated one, use the plain version.

Readability still matters. Short paragraphs, logical flow between ideas, and good structure serve comprehension, not style.

Bad: "changes happening behind the scenes"
Good: Name the actual changes.

Bad: "the weaponization of finance changed how reserve holders think about optionality"
Good: "After sanctions froze central bank assets, reserve holders started looking for ways to reduce their dependence on any single financial system."

### No narrator presence

Do not write as if you have a perspective or style. The prose should not sound like it was crafted by a particular writer. Remove rhetorical observations, framing that implies authorial judgement, and flourishes that draw attention to the writing itself.

Bad: "Finland's archipelago — over 40,000 islands stretching across the Baltic — presents a surveillance challenge that is easier to state than to solve."
Good: "Finland's archipelago contains over 40,000 islands across the Baltic Sea. This creates a surveillance challenge because the number of narrow channels and island passages makes comprehensive monitoring difficult."

### No dashes as punctuation

Do not use em dashes (—) or en dashes (–) as punctuation. Do not use hyphens between clauses. Replace with full stops, commas, colons, or restructure the sentence. Hyphens are allowed only inside compound words (e.g., "well-known", "real-time"). Any dash appearing between clauses is a violation.

Bad: "Finland's archipelago — over 40,000 islands — presents a unique challenge."
Good: "Finland's archipelago contains over 40,000 islands. This creates a unique challenge."

### No decorative sentences

Every sentence must pass the paraphrase test: if you cannot restate the sentence's meaning in completely different words while preserving the same specific information, the sentence is decorative. Cut it or rewrite it with concrete content.

Bad: "A second pressure is subtler but arguably stickier."
→ Cut entirely. It communicates no specific information.

Bad: "That is where the interesting tension lies."
→ Cut or replace with a plain description of what the tension actually is.

Bad: "The useful question, then, is not X. It is Y."
→ Describe what is happening and what is uncertain. Let the reader see the pattern.

### No editorial steering

Do not tell the reader what to find interesting, what question to ask, or how to frame the issue. Describe what is happening, what the evidence shows, and what remains uncertain. Trust the reader to arrive at conclusions.

Bad: "The more useful question is not whether..."
Good: Just lay out the facts and the uncertainty. The reader will see the question.

Bad: "This is where the story gets interesting."
Good: Skip it. Go straight to the content.

### Transitions orient, they do not perform

Transitions should tell the reader where the argument is going next. They should not sound insightful or add atmosphere.

Bad: "That leads to the next key question: if capital does leave at the margin, where can it realistically go?"
Good: "If capital moves, the limiting factor is the size and liquidity of the alternatives."

Bad: "That brings us to the next question."
Good: Just start the next idea. If the connection is clear, no transition is needed.

### Break abstract stacks into concrete things

When the GPT draft stacks multiple abstract nouns together, break them into things the reader can picture.

Bad: "building durable reasons, mandates, and infrastructure that make lower US exposure more likely"
Good: "institutions are changing their risk limits, hedging more against the dollar, and building financial routes that do not run through the US"

### Vary paragraph texture

Do not give every paragraph the same level of finish. Some paragraphs are just two or three short sentences stating facts. That is fine. Do not expand them into flowing prose. Varying paragraph length and density makes the article read as information, not as performance.

## Structure Rules

### Reorganize freely

Do not preserve the GPT draft's structure by default. If reorganizing sections improves the flow of the argument, do it. The goal is that each section leads naturally into the next, not that sections sit in separate boxes.

### Dissolve mechanical formatting

GPT drafts often use lettered labels (A, B, C, D), repetitive sub-headers, and formula transitions ("Why this is structural:"). Dissolve these into flowing prose. Ideas should connect through the logic of the argument, not through labeling.

### Use h2 headers for major topic shifts

H2 headers mark genuine shifts in the article's argument. A typical article needs roughly 4–7 h2 headers. These are structural markers, not subdivision tools.

### Use h3 subtitles for readability within sections

Within longer sections, use h3 subtitles to break up prose and help scanning. H3s should be descriptive — they tell the reader what the next stretch of text covers (e.g., "How reserve holders responded" rather than "Key reactions"). They are readability scaffolding, not the mechanical sub-header pattern warned against in Anti-Patterns. Use h3s when a section runs long enough that the reader would lose orientation without them. If a section is under ~400 words and flows well, skip the h3 — not every section needs one.

### Short paragraphs, but not choppy

Paragraphs should be short enough to read easily but long enough to develop a thought. 3–6 sentences is typical. Avoid single-sentence paragraphs except for genuine emphasis.

## Anti-Patterns to Catch

These patterns appear frequently in GPT drafts. Flag and fix all of them:

| Pattern | What it looks like | Fix |
|---|---|---|
| Checklist structure | A. Point one. B. Point two. C. Point three. | Dissolve into connected prose |
| Formula transitions | "Why this matters:" / "What this means:" / "That brings us to:" | Replace with natural flow or cut |
| Throat-clearing openings | "This is where the popular narrative often overreaches." | Start with the substance |
| Decorative insight | Sentences that sound smart but communicate nothing specific | Cut entirely |
| Abstract stacking | Multiple abstract nouns compressed into one phrase | Break into concrete, picturable things |
| Reader steering | "The useful question is..." / "The interesting tension is..." | Describe the evidence; let the reader see it |
| Echoed conclusions | Restating the same point at the end of each section | State it once, clearly |
| Narrator presence | Rhetorical observations, authorial framing, "easier to state than to solve" | Remove the voice. State the information plainly |
| Dashes as punctuation | Em dashes, en dashes, or hyphens used between clauses | Replace with full stops, commas, colons, or restructure |

## Process

### Step 1 — Assess the draft

Read the full GPT draft against the mini research plan. Identify:
- **Coverage gaps:** Research questions or angles from the plan that the draft missed or under-covered
- **Ungrounded additions:** Material in the draft that is not traceable to the research plan — flag for Patrik to confirm or cut
- The core argument and how it unfolds
- Structural problems (mechanical sections, poor flow between ideas)
- Tone problems (decorative language, editorial steering, abstract stacking)
- Content gaps or redundancies

### Step 2 — Propose the rewrite plan

Present to Patrik:
- Proposed structure (section flow, not just headers)
- What is being reorganized and why
- **Proposed target length** with rationale — based on how much material content the draft contains. If Claude believes content should be cut to improve the article, it must list what it would omit and why. Do not silently compress material to fit an arbitrary word count.
- What content is being cut as redundant or too thin
- Any substance questions (only if they would materially change the article)

### Step 3 — Write the full article

After Patrik confirms or adjusts the plan, produce the complete rewritten article.

After completing the rewrite, run a coherence self-check before presenting output:

1. Re-read each section
2. Apply the paraphrase test to every sentence: can you restate it in completely different words while preserving the same specific information? If not, rewrite it with concrete content or cut it
3. Check that each paragraph's claims follow logically from the previous paragraph
4. Fix any failures before proceeding

### Step 4 — Relevance check

Evaluate the completed article against the research plan. For every passage, check whether it directly serves a research plan question or sub-question.

Present a structured list:

**Passages not clearly tied to a research plan question:**
- [Section > passage description]: why it may be tangential

Ask Patrik: "Confirm keep or cut for each." Apply his decisions before delivering the final article. If all passages are clearly tied to research plan questions, state this and proceed to delivery.

## Output Protocol

Default to refinement mode: present the rewrite plan (Step 2) first. Produce the full article only after Patrik says `RELEASE ARTIFACT`. After writing, run the coherence self-check (Step 3) and present the relevance check (Step 4) before delivering the final article. Apply any cuts Patrik requests, then deliver as a markdown artifact.

## Bias Counters

- If the GPT draft makes a claim that seems unsupported or overstated, flag it rather than polishing it into better-sounding prose.
- If the draft's structure implies a stronger conclusion than the evidence supports, note the gap.
- Accuracy of substance matters more than smoothness of prose. Do not make weak arguments sound stronger by writing them better.
