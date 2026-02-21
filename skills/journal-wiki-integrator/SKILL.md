---
name: journal-wiki-integrator
description: >
  Integrates new thinking into an existing wiki article, producing a coherent
  updated document where old and new material are indistinguishable. Use when
  Patrik provides new notes alongside an existing wiki article and asks to
  "integrate this," "update the article," "add this to my [theme] article,"
  "weave this in," or says "I have new thinking on [theme]" and provides both
  new material and the current article. Inputs: (1) new material (clarified
  notes or well-formed notes), (2) existing article (full text with headings).
  Output: complete updated article in markdown, ready to replace the existing
  Notion page. Do NOT use when no existing article exists (use Journal Wiki
  Creator instead). Do NOT use for rewriting GPT drafts (use
  curiosity-hub-article-writer). Do NOT use for improving Claude's own outputs
  through diagnosis (use document-iteration).
---

# Journal Wiki Integrator

Weave new thinking into an existing wiki article. Read the article's current structure, classify where new material belongs, and produce an updated article that reads as a coherent whole. A reader should not be able to tell which content is original and which was added later.

This is the most critical skill in the Living Knowledge Base workflow. It handles the hard problem: integration over time.

## Inputs

Two inputs required:

1. **New material** — clarified notes (from Journal Thinking Clarifier) or well-formed notes provided directly
2. **Existing article** — the current wiki article from Notion (full text with headings)

If the new material is too vague to integrate, do not attempt integration. Redirect to Journal Thinking Clarifier: "These notes have some ambiguity that would be worth clarifying before integration, specifically [X]. Want to run through the clarifier first?"

If no existing article is provided, this is not an integration task. Redirect to Journal Wiki Creator.

If new material is empty or a single sentence with no actionable content, ask for clarification rather than attempting integration.

If the user asks to integrate in a way that conflicts with skill guardrails (e.g., "just append this at the end"), state the conflict and recommend the standard integration approach. Do not silently override or silently comply.

## Process

### Step 1: Integration Analysis (mandatory)

Before producing anything, analyze and present:

**1. Classification of new material.** For each distinct idea in the new notes, state:
- Which existing section it belongs to (by heading), OR
- That it requires a new section (with proposed heading and placement)
- Whether it **supersedes** existing content (the article says X, the new notes say Y)

**2. Structural impact.** One of:
- **Minor:** New material slots into existing sections, no restructuring needed
- **Moderate:** One or two new sections needed, or one section needs splitting
- **Major:** Article structure no longer works, significant reorganization needed

**3. Supersession list.** Explicitly list any existing content that the new material replaces or contradicts. State what the article currently says and what the new thinking says.

If structural impact is Major, stop and present restructuring options. Do not attempt major restructuring without confirmation.

Wait for Patrik to confirm the integration plan before proceeding.

### Step 2: Integration Execution

After confirmation, produce the complete updated article.

**Weave, don't append.** New material appears within the appropriate section, written in the same voice as the surrounding text. Do not add new paragraphs at the end of sections. Integrate into the paragraph flow.

**Silently replace outdated thinking.** When new notes supersede existing content (confirmed in Step 1), rewrite the relevant passages to reflect current thinking. No "Updated:" labels, no strikethrough, no change annotations.

**Preserve what doesn't change.** Sections and paragraphs not affected by the new material remain untouched. Do not rephrase, restructure, or "improve" existing content that is not being integrated with.

**Maintain voice consistency.** Match the existing article's tone, sentence patterns, and level of development. If the article uses bold for key positions, continue that. If it uses short paragraphs, match that. Each wiki article has its own voice. Do not impose a standard voice across articles.

**Grow sections naturally.** When adding material makes a section too long (more than 6 paragraphs), split into sub-sections (H3 under the existing H2).

### Handling Specific Scenarios

**New material extends an existing idea:**
Add to the relevant section. Integrate into the paragraph flow, not as a new paragraph at the end.

**New material opens a new sub-topic within an existing theme:**
Add as a new H3 under the relevant H2. Place it in logical order relative to sibling sections.

**New material requires a completely new section:**
Add as a new H2. Place it where it makes structural sense, not always at the end. Add brief transition from the preceding section if needed.

**New material contradicts existing content:**
Replace the outdated content per the supersession list confirmed in Step 1. If the contradiction is a refinement rather than a full replacement, adjust existing language to reflect the refined position.

**New material makes an existing section irrelevant:**
Remove the section. If the section contained ideas that are still partially valid, condense what remains into the most relevant surviving section.

**Notes span multiple existing articles:**
Flag this and ask which article to integrate into. Suggest splitting the notes if they clearly address different themes.

**New material references concepts not in the article:**
If the notes assume context or sections that don't exist in the current article, flag this in the integration analysis. Ask whether to create new context within the article or skip those references.

**Existing article is poorly structured:**
If the article lacks clear heading structure, note this and offer to restructure as part of integration. Treat as Major structural impact.

## Writing Standards

Match the existing article's conventions. Do not impose new formatting. Specifically:

- Match existing paragraph length patterns
- Match existing bold/emphasis usage
- Match existing tone (a "quotes" article reads differently from a "life purpose" article)
- No em dashes
- Sentences under 25 words where possible

## Output Protocol

**Step 1 output:** Integration plan (classification, structural impact, supersession list). Wait for confirmation.

**Step 2 output:** Complete updated article as a markdown artifact. Accompany with a brief summary: sections added, sections modified, content superseded.

Produce the complete article, not a diff or partial update.

## Guardrails

Do not:
- Append new material at the end of the article or sections
- Add ideas not present in the new notes
- Rephrase or "improve" existing content that is not being integrated with
- Add "Updated on [date]" or change tracking markers
- Restructure the article beyond what the new material requires
- Proceed with Major structural impact without explicit confirmation
- Create a "Recent additions" or "New thoughts" section

Always:
- Present the integration analysis before producing output
- Preserve the existing article's voice and style
- List all superseded content explicitly before replacing it
- Produce the complete article (not a diff or partial update)
- Maintain the heading hierarchy conventions of the existing article

## Bias Counters

If the new notes contain claims that seem unsupported or that contradict the existing article without clear reasoning, flag them rather than silently integrating. It is acceptable to leave gaps rather than integrate vague material. If the new material implies a stronger conclusion than the evidence supports, note the gap rather than weaving it in as established thinking.

## Relationship to Other Skills

- **Upstream:** Journal Thinking Clarifier (typical), or direct input if notes are already clear
- **Peer:** Journal Wiki Creator (for new articles; this skill handles existing ones)
- **Not a replacement for:** document-iteration (that skill improves Claude outputs through diagnosis; this skill integrates new content into existing personal articles)
