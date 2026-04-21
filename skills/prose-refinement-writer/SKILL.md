---
name: prose-refinement-writer
description: >
  Refines already-drafted prose for two specific weaknesses: unclear logical
  relationships between adjacent sentences, and underdeveloped hardest claims
  in a paragraph. Preserves voice; avoids AI-register smoothing. Use when:
  refining prose produced by decision-to-prose-writer or any other draft-
  generating step. Do NOT use for: initial prose writing (use
  decision-to-prose-writer), voice/rhythm cleanup (use ai-prose-decontamination),
  evidence-fidelity fixes (use evidence-prose-fixer), or word/phrase tightening
  (use document-optimizer).
---

# Prose Refinement Writer

Apply a targeted refinement pass to already-drafted prose. Address two specific weaknesses — unclear logical shifts between adjacent sentences, and underdeveloped "hardest claim" sentences — without importing the smoothing patterns that make prose pattern-match as AI-generated.

This is a **targeted intervention, not a rewrite**. In any given paragraph, most sentences remain untouched. Expect to change roughly one or two sentences per paragraph on average — sometimes none, occasionally three. If you find yourself rewriting most sentences in a paragraph, stop and re-read this instruction.

## When to Use — and When Not To

**Use this skill when:**
- The input is already-drafted narrative prose (not a decision document or outline).
- The draft's voice is broadly correct — conceptually dense, declarative, structurally confident, authored-feeling — and the problem is sentence-to-sentence clarity or claim development.
- The draft has been through (or is about to go through) voice-level cleanup, but readability weaknesses remain that voice cleanup cannot address.

**Do NOT use this skill for:**

| Failure mode | Correct skill |
|---|---|
| Converting a decision document, outline, or structured input into narrative prose | `decision-to-prose-writer` |
| Removing AI-register voice tells at the rhythm/word level (pseudo-maxims, pivot closings, Flagged-Word Registry application) | `ai-prose-decontamination` |
| Patching verification-flagged fidelity distortions (orphan claims, grade inflation, qualifier drop, scope creep) | `evidence-prose-fixer` |
| Tightening approved prose at the word/phrase level | `document-optimizer` |

### Demarcation from the closest adjacent skills

**`ai-prose-decontamination`** removes AI-register *tells* through pattern-level cleanup — tricolons, pseudo-maxims, pivot closings, banned-word instances. It operates on voice. This skill treats those same patterns as **constraints on its own fixes**, not as its primary job: it addresses *logical-linkage* and *claim-depth* gaps, and it avoids introducing AI-register tells while doing so. If the draft's only problem is voice residue, route to decontamination, not here.

**`document-optimizer`** *tightens* approved prose at the word/phrase level. This skill sometimes *adds* one follow-up sentence to develop a hardest claim. If both skills run on the same draft, **refinement-writer runs first** (clarifies relationships, develops claims), then document-optimizer (tightens the result). The reverse order wastes the optimizer's pass and risks re-expansion.

## Input Contract

This skill expects:

1. **The drafted prose** (required). Narrative text with whatever structure the source document uses — numbered sections, labeled blocks, asymmetric paragraphs.
2. **A style reference or governing voice description** (optional but strongly preferred). If provided, use it to calibrate what "the right voice" means for this document — it constrains what counts as legitimate preservation vs. smoothing.
3. **A scope note** (optional). If the caller specifies a section or paragraph subset, limit the refinement pass to that scope.

If the input is not already-narrative prose (e.g., it's a decision document or an outline), **stop and flag** — this skill does not handle structural conversion.

## What to Preserve from the Base Draft

These are features of the voice, not bugs. Do not smooth them out.

- **Numbered section and subsection structure.** Readers will cite these in conversation. Do not renumber, collapse, or reflow a section hierarchy.
- **Labeled blocks as discrete enumerated items.** If the draft uses labeled blocks — Rules, Tests, Principles, Constraints, or any other enumerated structure — leave them enumerated. Do not fold them into flowing prose.
- **Asymmetric paragraph lengths.** If one paragraph needs four sentences and another needs nine, leave them uneven. Even paragraph lengths flatten emphasis.
- **Declarative sentences that stop rather than land.** Paragraphs that end mid-thought or on a functional instruction are correct for many document types. Do not add summary sentences that wrap paragraphs into tidy conclusions.
- **Colon-constructions that name a mechanism or concept** (e.g., "The competence trap is the mechanism:"). These read as thinking. Keep them. Generally skip them in paragraphs that already contain a labeled rule or test — but this is a judgment rule, not a quota. A definitional colon and an operational colon in the same paragraph can both be load-bearing; keep both if they are.
- **Sentence-level decisiveness.** The voice's authority comes from sentences — short and long alike — that carry their conceptual load cleanly and stop without trailing qualification. Preserve this. Do not treat "short" as the operative feature; some of the strongest sentences are extended and conceptually dense.

## Fix 1 — Unclear Logical Relationships Between Adjacent Sentences

Revise when a sentence changes **level**, **actor**, or **causal claim** relative to the one before it without marking that shift:

- A **level shift** is moving from a general principle to a specific operational implication, or the reverse.
- An **actor shift** is moving from one subject (the fund, the service, the market) to another without signaling the handoff.
- A **causal shift** is moving from a claim to its consequence, cause, or contrast without linking them.

When one of those shifts is present and unmarked, clarify. **The fix should almost never be a sentence-initial transition phrase.**

### Preference order for the fix (descending)

1. **Restructure the sentence** so the logical link is built into the syntax — subordinate clause, relative clause, reordering. This is the most durable fix because the relationship lives in the sentence's architecture, not in a grafted-on marker.
2. **Insert a brief relationship-marking clause** inside the sentence that names the relationship ("which holds where," "in the sense that," "except when," "though only"). This is often the right tool when the link is conceptual rather than syntactic. A mid-sentence marker is legitimate when it names a *specific* relationship — scope, exception, condition, or degree. It is illegitimate when it merely signals "a connection exists here" without specifying which; in that case, use step 1 (restructure) instead. The banned-openers prohibition applies mid-sentence too if the phrase is scaffolding rather than content.
3. **Use a semicolon** instead of a period where the two sentences are tightly linked.
4. **Use a short mid-sentence connector** ("and," "but," "because," "where," "while").
5. **Only as a last resort, add a short sentence-initial connector** — and even then, prefer plain ones ("The principle also," "Need and acceptability are not the same variable") over discourse markers.

### Banned sentence openers

The pattern to avoid is sentence-initial discourse management — words that signal "let me now explain the logical relationship" before the sentence does the work. The list below is illustrative, not exhaustive; **lateral substitutions** ("Equally important," "It bears noting," "Of particular relevance") violate the same rule. If a sentence-initial marker announces logical scaffolding rather than carrying content, it's the wrong tool.

- Moreover
- Furthermore
- Importantly
- Notably
- Crucially
- Significantly
- That said
- In addition
- Additionally

If you find yourself reaching for one of these (or a close equivalent), the underlying sentences need to be rewritten, not decorated.

## Fix 2 — Underdeveloped Hardest Claim in a Paragraph

In many drafts, the densest claim in a paragraph gets the shortest treatment because the writer has already moved on. Identify the **target sentence** — the one whose meaning, mechanism, or downstream implication a reader would most likely pause on — and, if appropriate, add one follow-up sentence.

### Identifying the target sentence

It is a judgment call. The target sentence is usually the one that:

- Makes the most consequential claim in the paragraph, or
- Introduces a new concept the reader has not seen before, or
- Asserts something without visible support.

It is **not always the most abstract sentence**. When in doubt, ask which sentence a skeptical reader would most likely challenge first.

### Valid follow-up sentence types

A valid follow-up adds exactly one of:

- **A mechanism** — *how* the thing works.
- **A consequence** — *what follows* from it.
- **A concrete instance** — *an example* of it operating.
- **A boundary or qualification** — what the claim excludes, when it doesn't apply, where the scope ends. This is often the right move for claims that are sharp but potentially overreaching.

### Invalid follow-up: restatement

If the second sentence doesn't add new information, do not add it. A claim that can't be developed with one of the four valid follow-up types doesn't need a follow-up — it needs to stand alone.

### Banned openers for follow-up sentences

- In other words
- Put differently
- That is to say
- Said another way
- To put it plainly

These openers signal restatement, which is the invalid form. Even if the follow-up sentence after one of these does add information, the opener itself is the failure mode — cut it.

## Worked Examples

### Example 1 — Fix 1, unmarked contrast shift (restructure-based fix)

**Before:**
> The principle applies to all new contributors. Enforcement is a different question: teams may tolerate drift when velocity pressure is high.

**After:**
> The principle applies to all new contributors, though enforcement is a different question — teams may tolerate drift when velocity pressure is high.

The shift between "the principle applies" (rule) and "enforcement is different" (exception) was unmarked. The fix restructured the two sentences into one, making the contrast syntactic ("though") rather than grafted-on. No sentence-initial discourse marker was used.

### Example 2 — Fix 2, hardest claim with concrete-instance follow-up

**Before:**
> Feedback loops close slowly in distributed teams. The structure is the cause, not the discipline.

**After:**
> Feedback loops close slowly in distributed teams. The structure is the cause, not the discipline — two linked reviewers five time zones apart cannot shorten the loop by agreeing to respond faster.

The target sentence is the second one: it makes the consequential claim (structure, not discipline), and a skeptical reader would challenge it first. The follow-up adds a concrete instance — the five-time-zones case — that shows the mechanism rather than restating the claim.

### Example 3 — Change log entry

One entry per changed sentence (or sentence group when a fix spans adjacent sentences), matching the Output Contract format:

```
§2.3, paragraph 1, sentences 1–2
- Fix type: Fix 1 (logical-linkage)
- Before: "The principle applies to all new contributors. Enforcement is a different question: teams may tolerate drift when velocity pressure is high."
- After: "The principle applies to all new contributors, though enforcement is a different question — teams may tolerate drift when velocity pressure is high."
- Rationale: unmarked contrast shift between principle and enforcement; restructured with "though" so the contrast lives in the syntax.
```

## Patterns to Actively Avoid

These are AI-register tells that creep in under the banner of readability. Watch for them during the refinement pass.

**Tricolons.** Lists of three that feel balanced and rhythmic. The problem is patterned symmetry and rhetorical balancing, not the existence of three items. Avoid repeated balanced triplets unless the items are genuinely parallel and analytically necessary. As a backstop, **no more than one tricolon per section**. When in doubt, use two items or restructure as prose.

**Tidy summary sentences at paragraph ends.** The impulse to land every paragraph on a closing line that ties it up. Good drafts resist this. Do not reintroduce it during refinement.

**"X is not Y" constructions as a rhythm.** The form is sharp in isolation and becomes a tic when clustered. Avoid using this construction more than once in any three-paragraph span, and watch for rhetorical sameness even when the form itself varies — "A, not B" / "Not A but B" / "A is not the same as B" are the same move. Each is fine on its own; three in close proximity is the failure mode.

**Evening out paragraph lengths.** Leave the draft's length variance alone. Do not expand short paragraphs to "balance" a section.

**Rewriting labeled blocks into flowing prose.** Enumerated items exist as discrete units on purpose. Do not turn them into paragraphs.

**Parenthetical qualifier stacks.** Sentences with multiple parentheticals in series read as hedging and feel AI-generated. If a sentence needs three qualifiers, break it into two sentences.

## The Paired Quotability Test

After revising any paragraph, apply both tests in sequence:

1. **Standalone quotability.** Pick one sentence from the paragraph and ask: *could a reader cite this in a meeting as a standalone claim?* Voice-correct prose passes this often — its sentences are built to stand alone. AI-smoothed prose fails it — its sentences are built to flow into the next one.
2. **Paragraph coherence.** Then read the full paragraph and ask: *does each sentence, including the quotable one, still make clear sense in the paragraph's flow?* A sentence that is aphoristic in isolation but disconnected from its paragraph has been over-hardened.

**Both tests must pass.** If the revised paragraph loses quotability, the refinement has over-smoothed — revert that paragraph's changes. If it passes standalone quotability but fails paragraph coherence, the refinement has over-hardened — soften the connection back in.

Downstream reviewers (or the invoking command) may run this test independently on the skill's output as a validation gate. The skill applies the test during refinement; external validation is a separate concern.

## Scope of Changes

**Target:** roughly one or two sentences changed per paragraph on average — sometimes none, occasionally three.

If the pass finds itself needing to change most sentences in a paragraph, that is a signal the paragraph's problem is structural, not a logical-linkage or claim-depth issue this skill is designed to fix. Stop, flag the paragraph in the change log, and leave it for the operator to route elsewhere (re-drafting, evidence-fix, or editorial review).

No hard upper bound on sentences changed per paragraph — the three-sentence figure is a guideline, not a gate. But treat a paragraph where half or more of the sentences need refinement work as a signal to escalate rather than continue refining.

## Output Contract

Return two artifacts:

### 1. The revised prose

The full prose text with all refinement changes applied. Preserve all formatting, section numbering, labeled blocks, and paragraph-level structure from the input. Only sentence-level changes are in scope.

### 2. A minimal change log

One entry per changed sentence, or per sentence group when a single fix spans adjacent sentences (e.g., a Fix 1 restructure that merges two sentences into one). Each entry contains:

- **Location** — section/paragraph reference (e.g., "§2.1, paragraph 3, sentence 2" or "§2.3, paragraph 1, sentences 1–2").
- **Fix type** — `Fix 1 (logical-linkage)` or `Fix 2 (claim-development)`.
- **Before** — the original sentence, quoted.
- **After** — the revised sentence, quoted.
- **One-line rationale** — which shift was unmarked (level/actor/causal) for Fix 1, or which follow-up type was added (mechanism/consequence/instance/boundary) for Fix 2.

Flag separately, under an `Escalations` section of the change log, any paragraph where:

- The refinement pass hit the "half or more sentences need changes" signal and was stopped (see Scope of Changes).
- A target sentence was identified but no valid follow-up type applied — the claim needs to stand alone and the paragraph was left unchanged.
- The paired quotability test failed on a revision attempt and the revision was reverted.

Do not return a diagnostic report beyond this log. Downstream reviewers handle deeper quality assessment; this skill's output is refinement + accountability for what was changed.

### Delivery shape

Default: return both artifacts in the assistant message as two clearly labeled sections — `## Revised Prose` followed by `## Change Log`. If the caller specified a file output for the prose (e.g., a pipeline command passing an output path), write the revised prose to that path and the change log to a sibling file with suffix `.changelog.md`. If the caller specified only a change-log path, write the change log there and return the revised prose in the assistant message.

## Failure Behavior

- **Input is not already-narrative prose** (decision document, outline, structured specification): stop and flag. This skill does not handle structural conversion. Route to `decision-to-prose-writer` or the appropriate upstream skill.
- **Input's voice is fundamentally wrong** (wrong register, wrong audience, pervasive AI-register tells): stop and flag. Refinement does not repair a fundamentally miscalibrated draft. Route to voice-level cleanup (`ai-prose-decontamination`) or re-drafting.
- **A paragraph has no identifiable target sentence** (all sentences roughly equal in weight, none stands out as the hardest claim): leave the paragraph unchanged under Fix 2. It may still be eligible for Fix 1 changes.
- **Every candidate follow-up sentence would be a restatement:** do not add one. The claim stands alone. Note this paragraph in the change log's Escalations section.
- **The paired quotability test fails on every revision attempt for a paragraph:** revert all changes in that paragraph and flag it in Escalations. The paragraph's problem is outside this skill's scope.
- **The style reference or governing voice description is missing:** proceed with conservative defaults — preserve everything on the preserve list, apply fixes only where the shift or underdevelopment is unambiguous, skip judgment calls that would benefit from voice calibration. Note the missing input in the change log header.

## Bias Countering

- **Accept that no change is often correct.** A draft that already passes the paired quotability test on every paragraph does not need refinement. Return the original prose with an empty change log and say so.
- **Do not force fixes to justify invocation.** If a paragraph has no unmarked shift and no underdeveloped target sentence, leave it alone. Legitimate refinement work is identifying which paragraphs *actually* need the two fixes, not applying them uniformly.
- **When the instruction conflicts with taste, follow the instruction.** The preserve list, banned openers, and pattern-avoidance rules are load-bearing. If a "better-sounding" fix would violate one of them, it is the wrong fix — find a different approach or leave the sentence alone.
- **Flag disagreement rather than silently override.** If the operator or downstream reviewer asks for a change that would violate the preserve list or avoid list, flag the conflict in the change log with a one-line note. Apply the change if insisted on, but the note persists.
- **Preserve evidence integrity.** Do not alter claims, citations, numbers, or sourced statements during refinement. This skill changes how sentences connect and how claims are developed — not what they assert. If a fix would require restating a sourced claim, leave the sentence unchanged and flag it.

## Runtime Recommendations

- **Model tier: Opus.** Refinement is judgment work — identifying the target sentence for Fix 2, detecting unmarked logical shifts for Fix 1, and applying the paired quotability test all require the kind of reasoning that degrades at lower tiers. Do not downgrade to Sonnet or Haiku.
- **Context:** the input prose, the style reference (when provided), and this SKILL.md. No heavy tool use — refinement is a read-think-write operation.
- **Performance notes:** one pass per document or section. The change log is the audit trail; downstream reviewers use it rather than re-reading the full before/after diff.
- **Scope discipline:** treat each paragraph independently. Do not let a refinement in one paragraph motivate a "matching" change in another — that is uniformity pressure, which the skill exists to resist.

## Validation

After completing a refinement pass:

- [ ] The revised prose preserves all section numbering, labeled blocks, and paragraph-level structure from the input.
- [ ] No banned sentence opener (Fix 1 list or Fix 2 list) appears in any changed sentence.
- [ ] No paragraph had more than the "occasional three" sentences changed without being flagged in Escalations.
- [ ] Every changed sentence has a corresponding change-log entry.
- [ ] Every paragraph eligible for refinement passed the paired quotability test (or was reverted and flagged).
- [ ] No sourced claim or citation was altered.
- [ ] If no style reference was provided, the change log header notes this.
