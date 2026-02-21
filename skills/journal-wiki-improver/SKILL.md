---
name: journal-wiki-improver
description: >
  Improve an existing journal wiki article's prose quality, reasoning clarity,
  and coherence while preserving personal voice and exploratory tone. Use when
  Patrik provides a journal wiki article and asks to "improve this," "tighten
  this," "sharpen this," "make this better," "editorial pass," or says "this
  feels messy" / "this doesn't flow well" about an ideas database article.
  Input is a Notion journal wiki article (heading-based, personal voice,
  developing ideas). Output is the improved article in markdown — same
  structure, same ideas, better expression. Do NOT use for: integrating new
  material (use journal-wiki-integrator), professional/Axcion documents (use
  document-optimizer or document-iteration), or restructuring (flag and suggest
  refine-document-structure instead).
---

# Journal Wiki Improver

Improve an existing journal wiki article's prose without changing what it says or how it's organized. These are personal thinking articles — not professional documents. The calibration is different from document-optimizer.

## What to Preserve Absolutely

- **Personal voice and language.** If Patrik wrote "I want to build something massive," keep it. Do not upgrade to "I aspire to create a large-scale enterprise." His words, his register.
- **Developing quality.** Tentative language ("I'm starting to think," "this might mean") is often intentional. Do not sharpen uncertainty into false confidence.
- **Structure.** Do not reorder, merge, or split sections. Do not change heading hierarchy. Work within what exists.
- **Every idea.** Reduce how ideas are expressed, not which ideas are present.

## Improvement Targets

| Dimension | Good | Avoid |
|-----------|------|-------|
| Reasoning | "I believe X because Y" — positions have reasoning behind them | Adding reasoning Patrik didn't express |
| Clarity | Vague language replaced with specific language | Over-clarifying until it reads like a manual |
| Coherence | Sections flow logically, transitions connect them | Imposing rigid structure on exploratory thinking |
| Concision | No redundancy, every sentence earns its place | Cutting so aggressively the reflective quality is lost |
| Voice | Reads like Patrik thinking clearly | Corporate tone, self-help cliches, generic motivational language |

## Refinement Priorities

Address in this order:

1. **Reasoning gaps** — Position stated without the thinking behind it. If reasoning is implied, make it explicit. If genuinely missing, flag: `[Reasoning gap — why do you believe this?]`. Do not invent reasoning.
2. **Vague language** — Replace with specific language where specificity is inferable from context. If not inferable, flag: `[Vague — what specifically do you mean by X?]`
3. **Redundancy** — Remove repeated ideas, especially across sections. Keep the stronger version.
4. **Flow and transitions** — Add brief transition sentences where the jump between sections feels abrupt.
5. **Sentence-level tightening** — Remove filler, tighten verbose constructions. Light touch — don't rewrite sentences that work fine.

## Inline Flags

Some issues need Patrik's input. Flag these inline:

- `[Reasoning gap — why?]` — position without supporting reasoning
- `[Vague — what specifically?]` — language too imprecise to improve without guessing
- `[Tension — X says one thing, Y says another]` — internal contradiction (may be intentional)
- `[Thin — this section has one idea and feels underdeveloped]` — signal for future integration

Keep flags to 0-5 per article. If you'd flag more than 5, the article probably needs journal-wiki-integrator or a thinking clarifier, not this skill. Say so and stop.

## Workflow

### Step 1: Analyze

Assess the article's current state:

- Voice quality (does it sound like Patrik or like generic prose?)
- Reasoning density (are positions supported or just stated?)
- Redundancy level
- Flow quality between sections
- Overall coherence

Present a brief assessment (3-5 sentences) with the planned approach. State what you'll focus on and what you'll leave alone.

Wait for Patrik to confirm the approach before refining.

### Step 2: Refine

Execute improvements following the priority order. For each change, verify:

- The idea is preserved
- The voice is preserved
- The structure is unchanged

### Step 3: Deliver

Produce the complete improved article in markdown. Accompany with:

- **Word count change:** from X to Y (Z% change)
- **What changed:** 2-4 bullet summary of main improvements
- **Flags:** Any inline flags added, with brief context
- **What I left alone:** Areas that are rough but intentionally so (exploratory thinking, productive tensions)

## Writing Standards

- Match the existing article's tone — do not impose a new register
- Sentences under 25 words where possible
- No em-dashes
- Bold key insights (match existing bold patterns; only add new bold if a section has no emphasis at all)
- Paragraphs of 2-4 sentences

## Guardrails

**Do not:**

- Add ideas, perspectives, or reasoning not present or implied in the article
- Change structure (section order, heading hierarchy, section count)
- Replace personal language with professional or corporate language
- Sharpen tentative positions into definitive ones
- Remove exploratory or uncertain language unless genuinely redundant
- Merge or split sections

**Always:**

- Preserve Patrik's voice and word choices for key positions
- Present analysis before refining
- Flag what you can't fix without input
- Report what changed and what was left alone
- Produce the complete article, not a diff

## Edge Cases

**Article is already good.** Say so. Offer light tightening but note diminishing returns. Do not force changes to justify invocation.

**Article needs restructuring, not prose improvement.** If the core problem is structural (wrong section order, ideas in wrong sections, missing sections), flag this and recommend refine-document-structure. Do not attempt structural fixes.

**Article is very rough or early draft.** If the article needs substantial development rather than refinement, flag this. This skill tightens good writing — it doesn't develop thin writing. Recommend journal-wiki-creator or journal-wiki-integrator to add substance first.

**Input is not a journal wiki article.** If the input is a professional document, meeting notes, raw transcript, or other non-journal-wiki content, do not proceed. State what the input appears to be and suggest the appropriate skill (document-optimizer, document-iteration, or ask Patrik for clarification).

## Bias Countermeasures

If you cannot improve a passage without guessing at Patrik's intent, flag it rather than inferring. It is acceptable to leave rough passages intact rather than risk changing meaning. If a stated position seems contradictory, flag the tension rather than resolving it — the contradiction may be intentional or productive.

## Relationship to Other Skills

- **Peer:** document-optimizer (same function for Axcion professional docs)
- **Peer:** document-iteration (interactive diagnosis vs. direct improvement pass)
- **Complements:** journal-wiki-integrator (integrate new material first, then improve)
- **Not a replacement for:** journal-wiki-creator or journal-wiki-integrator (those add substance; this improves expression)
