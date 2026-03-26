---
name: execution-manifest-creator
description: >
  Analyze a section's Answer Specs and Research Plan to route each research
  question to the optimal execution tool — Research GPT (primary) or
  Perplexity (secondary) for high-complexity questions, or a Research
  CustomGPT with web access for standard questions. Groups Research GPT
  questions into sessions. Produces an Execution Manifest the operator
  follows during research
  execution. Trigger when Answer Specs are complete and the operator needs to
  plan execution routing, or on requests like "create execution manifest,"
  "route these questions," or "plan the execution." This is the first step in
  Stage 2 of the Axcion Research Workflow — it runs before
  research-prompt-creator. Do NOT use for research plan creation
  (research-plan-creator), answer spec generation (answer-spec-generator),
  writing execution prompts (research-prompt-creator), or evidence
  extraction.
---

# Execution Manifest Creator

## Purpose

Route research questions to the right execution tool, group Research GPT questions into sessions, and produce a manifest the operator follows during execution. This preserves cross-model separation: GPT handles all evidence gathering (both paths), Claude handles synthesis, extraction, and QC.

## Input Requirements

**Required:**
1. **Answer Specs** — per-question specifications for all questions in the current research section
2. **Research Plan** — scope, source landscape context, key terms for the current section

Both provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Halt for critical gaps (missing Answer Specs, missing scope parameters). Proceed with best-effort routing for non-critical gaps (e.g., missing source preferences) and flag assumptions.

## Routing Criteria

Evaluate each question against these criteria to determine routing.

### Route to Research GPT when:

- **Source scarcity** — the topic has sparse, niche, or hard-to-find sources (e.g., Nordic mid-market PE practices, practitioner behavioral patterns, unpublished industry data). Research GPT's autonomous browsing across 30+ sources is needed to surface what exists.
- **Source breadth required** — the answer requires synthesizing many sources of different types (academic, practitioner, industry reports, vendor publications). A single search session won't cover it.
- **Exploratory scope** — the question is open-ended enough that the researcher doesn't know in advance which sources will be valuable. Research GPT's ability to pivot during execution is the advantage.
- **Cross-referencing needed** — the answer requires comparing claims across multiple source types to assess reliability (e.g., validating a specific data claim against original sources).

### Route to CustomGPT when:

- **Well-sourced topics** — abundant, accessible, high-quality sources exist (published frameworks, standard industry practices, established academic research). Standard web browsing surfaces the key sources efficiently.
- **Definitional or structural questions** — the answer is primarily about defining concepts, mapping structures, or describing established processes where a few authoritative sources suffice.
- **Known source landscape** — the Answer Spec or Research Plan identifies specific source types or publications likely to contain the answer. Targeted browsing is sufficient.
- **Synthesis over discovery** — the question primarily needs analytical synthesis of known material rather than discovery of unknown sources.
- **Low independence requirement** — the Answer Spec doesn't require high source independence counts — a few credible sources are sufficient for a COVERED verdict.

### Tie-breaking rules:

1. When a question could go either way, route to CustomGPT. Preserve Research GPT sessions for questions that genuinely need browsing depth.
2. If a question is borderline between Research GPT and CustomGPT, route to CustomGPT. Preserve Research GPT sessions for questions that genuinely need browsing depth.
3. Questions with MISSING-risk components (anticipated thin results) should stay on Research GPT — supplementary research is more expensive than getting depth on the first pass.

### Tool selection — Research GPT vs Perplexity:

- **Research GPT (default):** Better for broad exploratory research, longer reports, more source depth. Use unless a Perplexity-specific condition applies.
- **Perplexity:** Better when the source landscape is known and targeted, when Nordic/Scandinavian source bias is valuable, or when the question benefits from Perplexity's citation style.
- **Tie-breaker:** When conditions point in different directions, prefer Research GPT. Consider assigning Perplexity to a later session to diversify source coverage across the section.

## Session Grouping Logic (Research GPT only)

After routing, group Research GPT questions into sessions:

1. **Respect dependencies first:** If question B requires question A's findings, they must go in sequential sessions (A before B), not the same session. Map all dependencies before grouping — they are hard constraints that override clustering preferences.
2. **Target 2 questions per session.** Sessions of 1 or 3 are acceptable when dependency constraints or strong source overlap justify it. Avoid sessions larger than 3 — smaller sessions produce deeper coverage.
3. **Optimize by source overlap** (strongest signal), then conceptual chain, then analytical lens.

## CustomGPT Batching Logic

Group CustomGPT questions into batches of 2–3 questions per run:

1. Group by source overlap where possible (questions likely answered by the same literature).
2. No hard session cap — CustomGPT runs are independent of Research GPT sessions.
3. Recommend starting a new chat after 2–3 batches to prevent context degradation.

## Dependency: Research CustomGPT

The CustomGPT execution path requires a Research CustomGPT with web access. This is a lighter research tool that handles well-sourced, lower-complexity questions without the full research execution workflow. Research extraction and QC are handled downstream by `research-extract-creator`.

## Failure Behavior

- **All questions route to Research GPT** — that's fine. Produce a manifest with no CustomGPT queue. Verify session groupings follow the 2-question target.
- **All questions route to CustomGPT** — that's fine. Produce a manifest with no Research GPT sessions. The `research-prompt-creator` step is skipped entirely.
- **Routing rationale genuinely unclear** — route to CustomGPT with a note: "Borderline — rerouted to CustomGPT. Consider Research GPT if CustomGPT results are thin."
- **Answer Specs ambiguous about source requirements** — flag the ambiguity in the routing rationale, make a best-effort decision, and note the uncertainty.

## Accuracy Over Completeness

If the provided inputs are insufficient to route confidently, say so rather than inferring. It is acceptable to flag uncertainty in routing rationale rather than invent confident-sounding justifications. If the Answer Specs contain questionable assumptions about source availability, flag them constructively.

## Output Protocol

Produce the full Execution Manifest in a single pass using the template in `references/manifest-template.md`. No refinement mode — the operator reviews the manifest and can override individual routing decisions before execution begins.

The manifest's session groupings are authoritative for downstream steps. When the operator passes this manifest to `research-prompt-creator`, that skill accepts the session groupings as given input and writes prompts accordingly.

**Operator overrides:** If the operator overrides a routing decision, update the manifest accordingly — adjust session groupings and the routing summary table to reflect the change, then re-run the self-check. Do not regenerate from scratch unless the override changes the majority of routing decisions.

Deliver as markdown.

## Self-Check

Before delivering, verify:

- Every research question appears in exactly one route (Research GPT or CustomGPT)
- Research GPT sessions target 2 questions each (1 or 3 acceptable with justification)
- All dependencies between questions are reflected in session ordering
- Parallel execution opportunities are explicitly identified
- Routing rationale is specific to each question (not generic)
- The routing summary table matches the detailed session/queue sections
- CustomGPT batches are 2–3 questions each
