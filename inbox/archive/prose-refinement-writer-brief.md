# Build Brief: `prose-refinement-writer` Skill

**Requested skill name:** `prose-refinement-writer`
**Requesting project:** None — workspace-originated (see Deliberate deviation below).
**Date:** 2026-04-21

## Purpose

A new shared skill in `ai-resources/skills/` that applies a targeted refinement pass to already-drafted prose. It addresses two residual weaknesses in the `produce-prose-draft` pipeline's output without importing the smoothing patterns that make prose pattern-match as AI-generated. It sits adjacent to (but does not overlap) the existing prose-chain skills: decision-to-prose-writer, chapter-prose-reviewer, prose-compliance-qc, ai-prose-decontamination, evidence-prose-fixer, and document-optimizer.

## Where This Came From

The operator tested the current `produce-prose-draft` four-skill chain on a real document — a buy-side market analysis of Nordic mid-market PE, ~3,500 words ("Document 1"). The output had the right voice (conceptually dense, declarative, structurally confident, authored-feeling) but showed two specific readability weaknesses that none of the existing chain skills target:

1. **Unclear logical relationships between adjacent sentences** — level shifts, actor shifts, and causal shifts left unmarked.
2. **Underdeveloped hardest claim in a paragraph** — the densest claim gets the shortest treatment because the writer has already moved on.

The operator wrote a full refinement-writer instruction to address these weaknesses while preserving the base draft's strengths and actively avoiding AI-register tells. That instruction is the source material for this skill and is reproduced verbatim below.

## Document 1 Reference

Document 1 was shared in-conversation during this session and is available on request if `/create-skill` Step 1 wants to read it to form its own characterization of the weaknesses. **Do not persist a fixture file in this brief intake step.** Rationale:

- The `/create-skill` Step 3 evaluator reads the produced SKILL.md cold against the framework — it does not ingest fixtures.
- Persisting operator-pasted in-conversation content to disk without an explicit save instruction conflicts with the workspace File Write Discipline rule.
- The brief-intake `inbox/` directory is for briefs, not test artifacts — mixing lifecycles adds no value.

If a fixture turns out to be useful for regression testing later, it belongs under `skills/prose-refinement-writer/references/` after the skill directory exists.

## Pipeline Fit

Document 1 is confirmed as current-pipeline (post-Phase 5) output. The new skill therefore deploys in one of three ways — operator decision required during `/create-skill` Step 1 planning:

- **(a) After decontamination** — refinement runs last, taking a decontaminated draft and addressing residual logical-linkage and claim-depth weaknesses.
- **(b) Before decontamination** — refinement runs on post-Phase 3/4 prose, and decontamination cleans up any voice-level residue afterward.
- **(c) Decontamination reorganized** — decontamination's existing passes are split, with some work absorbed into the new skill and some retained, rather than adding a net-new phase.

This choice affects wiring in `produce-prose-draft.md` (a follow-up session, not part of the skill-creation work). It does not affect the skill's content.

## Known Adjacencies (Scope Demarcation)

The skill must not duplicate any of these existing scopes. `/create-skill` Step 3 evaluator should check for overlap.

- **`ai-prose-decontamination`** — voice-level cleanup (tone, rhythm, repetition, four-pass AI-register removal). Does not evaluate sentence-to-sentence logical linkage or claim depth. The new skill operates on a different axis of prose quality.
- **`decision-to-prose-writer`** — structural converter that transforms decision documents into narrative prose. Does not iterate on already-narrative text. The new skill takes already-narrative prose as input.
- **`evidence-prose-fixer`** — patches verification-flagged fidelity distortions (orphan claims, grade inflation, qualifier drop, scope creep). Does not address general prose-quality concerns independent of evidence alignment.
- **`document-optimizer`** — tightens approved prose at the word/phrase level (referenced in sibling skills' exclusion lists). Does not reshape sentence-to-sentence logical linkage or develop underdeveloped claims. Closest scope proximity; the new skill's body should explicitly demarcate the boundary.

## Deliberate Deviation From `/request-skill`

The normal intake path is `/request-skill` from a project session. This brief is authored directly in `ai-resources/inbox/` because the request originates at the workspace level — there is no project session to run `/request-skill` from. The brief still lands in `inbox/` where `/create-skill` expects it; the only step skipped is the project-session origination, which does not apply.

---

## Refinement-Writer Instruction (Operator's Verbatim Text)

The following is the operator's complete instruction. It is load-bearing — the specific language around banned openers, valid follow-up types, and the paired quotability test should be preserved (not paraphrased) when `/create-skill` produces SKILL.md.

---

# Prose Writer Instruction: Refining Document 1 Without Drifting Toward AI Register

## Purpose

The base draft (Document 1) has the right voice: conceptually dense, declarative, structurally confident, authored-feeling. It reads like a practitioner who has been staring at the argument long enough to name things and move on. Your job is to address two specific readability weaknesses — occasional sentence-stacking without connection, and underdeveloped key claims — without importing the smoothing patterns that make prose pattern-match as AI-generated.

The failure mode to guard against is not fluency itself. Legitimate clarification work often produces more fluent prose and is welcome. The failure mode is *visible rhetorical management* — the patterned smoothing that announces itself as smoothing: tricolons, tidy summary sentences, uniform paragraph lengths, sentence-initial discourse markers. These make prose more fluent and more obviously machine-written at the same time.

## What to Preserve from the Base Draft

These are features, not bugs. Do not smooth them out.

- **Numbered H2 structure** and numbered subsections. Readers will cite these in conversation.
- **Labeled blocks for Rules and Tests** as discrete, enumerated items — not folded into flowing prose.
- **Asymmetric paragraph lengths.** If Principle 3 needs four sentences and Principle 7 needs nine, leave them uneven. Even paragraph lengths flatten emphasis.
- **Declarative sentences that stop rather than land.** Paragraphs that end mid-thought or on a functional instruction are correct for a governance document. Do not add summary sentences that wrap paragraphs into tidy conclusions.
- **Colon-constructions** that name a mechanism or concept ("The competence trap is the mechanism:"). These read as thinking. Keep them. Rarely more than one per paragraph, and generally skip them in paragraphs that already contain a labeled rule or test — but this is a judgment rule, not a quota. A definitional colon and an operational colon in the same paragraph can both be load-bearing; keep both if they are.
- **Sentence-level decisiveness.** The voice's authority comes from sentences — short and long alike — that carry their conceptual load cleanly and stop without trailing qualification. Preserve this. Do not treat "short" as the operative feature; some of the strongest sentences in the base draft are extended and conceptually dense.

## What to Fix — and How

### Fix 1: Unclear logical relationships between adjacent sentences

Revise when a sentence changes level, actor, or causal claim relative to the one before it without marking that shift. A level shift is moving from a general principle to a specific operational implication (or the reverse). An actor shift is moving from one subject (the fund, the service, the market) to another without signaling the handoff. A causal shift is moving from a claim to its consequence, cause, or contrast without linking them.

When one of those shifts is present and unmarked, clarify. The fix should almost never be a sentence-initial transition phrase.

**Prefer, in descending order:**

1. **Restructure the sentence** so the logical link is built into the syntax — subordinate clause, relative clause, reordering.
2. **Insert a brief relationship-marking clause** inside the sentence that names the relationship ("which holds where," "in the sense that," "except when," "though only"). This is often the right tool when the link is conceptual rather than syntactic.
3. **Use a semicolon** instead of a period where the two sentences are tightly linked.
4. **Use a short mid-sentence connector** ("and," "but," "because," "where," "while").
5. **Only as a last resort, add a short sentence-initial connector** — and even then, prefer plain ones ("The principle also," "Need and acceptability are not the same variable") over discourse markers.

**Banned as sentence openers.** The pattern to avoid is sentence-initial discourse management — words that signal "let me now explain the logical relationship" before the sentence does the work. The closed list below is non-exhaustive; lateral substitutions ("Equally important," "It bears noting," "Of particular relevance") violate the same rule. If a sentence-initial marker announces logical scaffolding rather than carrying content, it's the wrong tool.

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

### Fix 2: Underdeveloped hardest claim in a paragraph

In the base draft, the densest claim in a paragraph sometimes gets the shortest treatment because the writer has already moved on. Identify the **target sentence** — the one whose meaning, mechanism, or downstream implication a reader would most likely pause on — and, if appropriate, add one follow-up sentence.

Identifying the target sentence is a judgment call. It is usually the sentence that makes the most consequential claim, introduces a new concept, or asserts something without visible support. It is not always the most abstract sentence. When in doubt, ask which sentence a skeptical reader would most likely challenge first.

**A valid follow-up sentence adds one of:**

- **A mechanism** (*how* the thing works)
- **A consequence** (*what follows* from it)
- **A concrete instance** (*an example* of it operating)
- **A boundary or qualification** that narrows the claim — what it excludes, when it doesn't apply, where the scope ends. This is often the right move for claims that are sharp but potentially overreaching.

**An invalid follow-up sentence is a restatement.** Cut it. If the second sentence doesn't add new information, do not add it. Banned openers for follow-up sentences:

- In other words
- Put differently
- That is to say
- Said another way
- To put it plainly

A claim that can't be developed with one of the four valid follow-up types doesn't need a follow-up — it needs to stand alone.

## Patterns to Actively Avoid

These are AI-register tells that creep in under the banner of readability. Watch for them.

**Tricolons.** Lists of three that feel balanced and rhythmic ("confidentiality, PE-process literacy, and deal-stage-calibrated acceptability"). The problem is patterned symmetry and rhetorical balancing, not the existence of three items. Avoid repeated balanced triplets unless the items are genuinely parallel and analytically necessary. As a backstop, no more than one tricolon per section. When in doubt, use two items or restructure as prose.

**Tidy summary sentences at paragraph ends.** The impulse to land every paragraph on a closing line that ties it up. The base draft correctly resists this. Do not reintroduce it.

**"X is not Y" constructions** as a rhythm. The form is sharp in isolation and becomes a tic when clustered. Avoid using this construction more than once in any three-paragraph span, and watch for rhetorical sameness even when the form itself varies ("A, not B" / "Not A but B" / "A is not the same as B" are the same move). Examples from the base draft that work in isolation: "Need and acceptability are not the same variable." "Capability does not create entitlement." "Failure is a business model problem, not a go-to-market execution problem." Each is fine on its own; three in close proximity is the failure mode.

**Evening out paragraph lengths.** Leave the draft's length variance alone. Do not expand short paragraphs to "balance" a section.

**Rewriting labeled blocks into flowing prose.** The Five Coherence Tests and Five Expansion Constraints exist as enumerated items on purpose. Do not turn them into paragraphs.

**Parenthetical qualifier stacks.** Sentences with multiple parentheticals in series read as hedging and feel AI-generated. If a sentence needs three qualifiers, break it into two sentences.

## The Quotability Test (Paired)

After revising any paragraph, apply both of these tests in sequence:

1. **Standalone quotability.** Pick one sentence from the paragraph and ask: *could a reader cite this in a meeting as a standalone claim?* The base draft passes this test often — its sentences are built to stand alone. AI-smoothed prose fails it — its sentences are built to flow into the next one.
2. **Paragraph coherence.** Then read the full paragraph and ask: *does each sentence, including the quotable one, still make clear sense in the paragraph's flow?* A sentence that is aphoristic in isolation but disconnected from its paragraph has been over-hardened.

Both tests must pass. If the revised paragraph loses quotability, you have over-smoothed — revert. If it passes standalone quotability but fails paragraph coherence, you have over-hardened — soften the connection back in.

## Scope of Changes

This is a targeted intervention, not a rewrite. In any given paragraph, most sentences should remain untouched. Expect to change roughly one or two sentences per paragraph on average — sometimes none, occasionally three. If you find yourself rewriting most sentences in a paragraph, stop and re-read this instruction.
