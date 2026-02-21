---
name: journal-wiki-creator
description: >
  Creates a new heading-based wiki article from clarified personal notes.
  Articles are structured as living documents with sections designed as logical
  seams for future integration, not as final conclusions. Use when Patrik asks
  to "create an article," "turn these notes into a wiki," "start a new article
  for [theme]," or provides clarified notes with the expectation of a new
  wiki-style article. Typical input themes: life purpose, business ideas,
  personal playbooks, income strategies, self-knowledge, quotes collections.
  Do NOT use when an existing article already covers the theme — use Journal
  Wiki Integrator instead. Do NOT use for research-based knowledge articles —
  use learning-wiki-creator instead.
---

# Journal Wiki Creator

Transform clarified personal notes into a heading-based wiki article for Notion. Input is typically output from Journal Thinking Clarifier, but can be any well-formed personal notes.

## Design Philosophy

Every article will receive new material over weeks and months. This changes how you structure:

- **Structure around sub-themes, not around today's notes.** Ask: "If Patrik returns with new thinking on this topic, where would it naturally slot in?"
- **Ideas, not conclusions.** These are developing thoughts. Confident enough to be useful, open enough to evolve. Avoid language that closes off development ("the answer is," "the only way," "in conclusion").
- **Patrik's voice, not yours.** Preserve his language, framing, and emphasis. Structure and connect his ideas. Do not rewrite them into generic self-help prose.

## Process

### Step 1 — Identify threads

Read the clarified notes and identify the distinct sub-themes. Most sets of notes contain 3-6 threads. If you find fewer than 3, the notes may be too narrow for a standalone article — flag this.

### Step 2 — Propose structure

Present to Patrik before drafting:

1. Proposed heading structure (H2 and H3 headings)
2. Which ideas map to which sections
3. Flags for thin sections (only one note supporting them)
4. Flags if the notes suggest a structure that doesn't fit the theme types below

**Do not produce the full article until Patrik confirms the structure** (e.g., `RELEASE ARTIFACT`, "go ahead," "write it").

### Step 3 — Write the article

After Patrik confirms or adjusts the structure:

- Produce the complete article as a markdown artifact
- Provide a brief summary alongside the artifact (not inside it): section count, word count, any thin sections noted
- Typical articles run 800-2000 words. If the notes only support significantly less, flag this in Step 2 rather than padding

## Theme-Type Structures

| Theme type | Structure approach |
|---|---|
| **Philosophical** (life purpose, self-knowledge) | Organize by facets or tensions. Capture what Patrik believes and why. |
| **Strategic** (5-year plan, 6-month playbook) | Organize by domain or time horizon. Include both vision and concrete next steps where the notes provide them. |
| **Tactical** (passive income, YouTube) | Organize by approach or channel. Capture both strategy and reasoning behind it. |
| **Collection** (quotes from leaders) | Organize by theme or source. Each quote gets context: why it matters to Patrik, how it connects to his thinking. |

If notes span multiple theme types, use the dominant theme for the primary structure and nest the secondary theme under an H2. If no theme dominates, propose a hybrid structure to Patrik and explain the tension. If notes don't fit any of the four types, design a structure from first principles and note the reasoning in Step 2.

## Section Content Standards

Each section should:

- Open with the core idea (1-2 sentences)
- Develop the thinking with reasoning, examples, or implications (2-4 paragraphs)
- Not repeat ideas from other sections
- Feel complete but not closed — room for the thinking to develop further

## Writing Standards

- Plain language, no jargon or self-help clichés
- Sentences under 25 words where possible
- Bold the key insight or position per section (1 per section maximum)
- No em-dashes
- No bullet points within prose sections (bullets only for genuine lists like quotes collections)
- Paragraphs of 2-4 sentences

## Heading Conventions

- H1 for the article title (one per article)
- H2 for major sections (aim for 3-6 per article)
- H3 for sub-topics within sections
- No "Conclusion" or "Summary" sections — these are living documents
- Heading hierarchy is the skeleton the Journal Wiki Integrator navigates later

## Guardrails

**Do not:**
- Add ideas or perspectives not present in the input notes
- Write generic self-improvement prose — every sentence must trace back to Patrik's actual thinking
- Create overly granular structures (more than 6 H2 sections signals over-splitting)
- Add metadata, tags, or Notion-specific formatting (Patrik handles that)

**If the provided notes are insufficient to build a section confidently, say so rather than inferring.** Leave gaps rather than invent plausible-sounding details. If a note contains a questionable assumption, flag it constructively. Accuracy over comprehensiveness.

**When notes contradict each other:** Present both positions and ask Patrik which reflects his current thinking, or whether the tension is intentional and both should appear. **When a note remains ambiguous:** Quote the specific passage and ask for clarification rather than interpreting.

## Relationship to Other Skills

- **Upstream:** Journal Thinking Clarifier (typical), or direct input
- **Downstream:** Article goes to Notion; future updates handled by Journal Wiki Integrator
- **Not a replacement for:** learning-wiki-creator (learned knowledge with buy-side examples and implementation checklists) or curiosity-hub-article-writer (rewriting GPT research drafts)
