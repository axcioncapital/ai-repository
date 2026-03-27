---
name: research-prompt-creator
description: >
  Transform an Execution Manifest, Research Plan, and Answer Specs into a
  Research Execution Prompts document — per-session execution prompts, session
  plan table, and operational notes, primarily for Research GPT sessions.
  Perplexity sessions may appear in the manifest but use simpler prompt
  formats; CustomGPT sessions follow Research GPT patterns. Session groupings and tool assignments come
  from the Execution Manifest (produced by execution-manifest-creator); this
  skill writes the prompts, not the routing. Trigger when an Execution
  Manifest exists and the operator needs execution prompts, or on requests
  like "create research prompts" or "write prompts for these sessions." This
  is Step 2.1 in Stage 2 of the Axcion Research Workflow. Do NOT use for
  research plan creation (research-plan-creator), answer spec generation
  (answer-spec-generator), execution routing (execution-manifest-creator),
  evidence compression, or direct research execution — this skill produces
  prompts for the operator to paste into the assigned execution tool.
---

# Research Prompt Creator

## Input Requirements

**Required:**
1. **Execution Manifest** — produced by `execution-manifest-creator`. Contains session groupings, tool assignments (Research GPT vs. Perplexity), dependencies, and parallel execution opportunities. Accept the manifest's routing and grouping decisions as given — do not re-cluster or re-route questions.
2. **Research Plan** — research questions with scope, key terms, source preferences, search terminology guidance
3. **Answer Specs** — per-question specifications defining required evidence components, evidence rules, and completion gates

All provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Proceed with `[inferred]` defaults only for non-critical gaps (e.g., missing source preferences). Halt for critical gaps (missing Execution Manifest, missing scope parameters, missing questions).

**Question-spec mismatch:** If the Execution Manifest references questions not found in the Answer Specs (or vice versa), flag as `[MISMATCH]`, list orphaned items, and ask whether to proceed with the matched subset or halt.

**Information boundary:** Accept session groupings, dependencies, and tool assignments from the Execution Manifest without modification. Base prompt construction decisions (priority allocation, depth signals, format choices) on the provided inputs. Domain knowledge is acceptable for search term selection, keyword seeding, and steering note context — these benefit from the model knowing the field.

## Platform Context

Research GPT (GPT-5.2-based) has characteristics that constrain prompt design:

- **No clarification step** — research starts immediately from the prompt. Prompt quality is the single biggest lever on output quality.
- **Keyword-driven search** — the model uses keywords from the prompt as search seeds. Embed domain-specific terms, proper nouns, and technical terminology explicitly.
- **Session capacity** — overloaded prompts produce shallow coverage on later questions. Session groupings come from the Execution Manifest; focus on writing prompts that work well within the given session sizes.
- **Structured output** — tables, headers, and format instructions are well-followed. Leverage this.
- **Context pack** — a compact project summary is embedded directly in each execution prompt for scope context. The prompt creator generates this from the Research Plan inputs (project background, section objective, content map — NOT individual question listings). Scope parameters live in the standalone scope block, not in the context pack.
- **Finite search budget** — execution tools have a limited number of searches per question or session. Generic seeds burn budget on shallow results, leaving nothing for harder components. Prompt design must account for this: prioritize high-specificity seeds for difficult components, and keep broad seeds to a minimum for well-documented topics.
- **Site restrictions** — the operator can restrict or prioritize specific sites per session via the ChatGPT UI.

## Planning Protocol

Before producing the full document, present:

1. **Session summary** — confirm the sessions from the Execution Manifest (questions, tool assignments, dependencies)
2. **Prompt strategy** — key decisions about prompt construction (epistemic framing, depth allocation, format choices)
3. **Key assumptions** — any inferences about priority or emphasis
4. **Flags** — ambiguities, conflicts, or gaps found in the inputs

Proceed to full document only after the operator confirms the plan.

## Workflow

### Step 1: Analyze Inputs

Read the Execution Manifest, Research Plan, and Answer Specs. Extract:

- Session groupings, tool assignments, and dependencies from the Execution Manifest
- All research questions with their IDs
- Scope parameters (geography, deal size range, fund size range, time frame, industry focus)
- Per-question evidence components and completion gates
- Source preferences and search terminology guidance

### Step 2: Construct Per-Session Prompts

Use the session groupings, tool assignments, and dependency ordering from the Execution Manifest. Do not re-cluster or re-route questions.

For each session, produce:

**2a. Session Header**
- Session letter (A, B, C...)
- Questions included (by ID and short title)
- Site restriction guidance (mode, sites, rationale) — or "Default (full web search)"
- Recency preference (e.g., "Prefer sources from 2023–present" or "No recency constraint")

**2b. Execution Prompt** (in a code fence — literal text for the operator to paste)

The prompt must be self-contained. It includes the following elements, in order:

**Always present:**
1. **Scope block** — a clearly labeled standalone block with all scope parameters as literal values (geography, deal size, fund size, time frame, industry focus). Placed at the top of the prompt so the model references it throughout.
2. **Context pack block** — a compact project summary embedded inline, delimited by `--- CONTEXT PACK ---` / `--- END CONTEXT PACK ---` markers. Placed after the scope block, before directives. Generate from the Research Plan: project background, section objective, and content map (areas and focus, NOT individual question listings). Do not duplicate scope parameters here — include a one-line reference to the standalone scope block (e.g., "Scope parameters are defined in the SCOPE block above"). The scope block is authoritative for all scope values.
3. **Per-question research directives** — translated from Answer Spec components into plain-language directives. Each directive header must include the Answer Spec component ID so downstream tools (research-extract-creator) can match outputs to specs. Format: `Directive 1 (Q1-A01) — [Short title]`. Load `references/prompt-construction-guide.md` for translation patterns, output format templates, and depth signal language. If this file is unavailable, use the translation principles and format templates described in the prompt construction rules below.

**Conditional:**
4. **Epistemic frame** — include when multiple directives share a research stance (e.g., "Focus on how this works in practice, not idealized models"). Set once as a session-level framing sentence; do not restate per directive. Omit when directives have no shared epistemic orientation.
5. **Output format instructions** — include for structured/quantitative directives (prescribe tables, columns). Omit for analytical/qualitative directives — state the deliverable and let the model choose format.
6. **Depth/priority signals** — include when questions within a session have unequal importance. Use operative effort signals (directive ordering, minimum search allocations) and sufficiency thresholds. Omit when all directives in a session have equal weight.

**Prompt construction rules:**

Rules are grouped by priority. Structural decisions shape the prompt architecture — if these are wrong, good writing won't compensate. Strategic choices govern research depth and focus. Writing craft ensures clarity and concision.

*Structural decisions (highest priority):*
- **Component ID labeling:** Every directive header must carry the Answer Spec component ID in parentheses — e.g., `Directive 1 (Q1-A01) — Activity inventory`. This is a hard requirement: `research-extract-creator` matches research outputs to Answer Spec components by these IDs. If a single directive covers multiple components, list all IDs: `Directive 3 (Q2-A01, Q2-A02)`. If the Answer Specs do not use the `Q[n]-A##` convention, preserve whatever ID scheme they use.
- **Scope block separation:** Pull scope parameters (geography, deal size, fund size, time frame, industry focus) into a clearly labeled standalone block at the top of the execution prompt, separate from the research directives. Directives reference the scope block rather than re-embedding parameters inline. Clean separation means the same scope block can be reused across sessions without rewriting.
- **Format prescription — match to directive type:** Prescribe specific output format (tables, column names) for structured/quantitative directives where the value is in the data shape. For analytical or qualitative directives (pattern analysis, narrative synthesis, value judgments), state the deliverable clearly but let the model choose the best format. Over-prescribing format on qualitative work forces the model to fit insights into structures that may not serve them.
- **Epistemic frame — set once, not per-directive:** If multiple directives share a research stance (e.g., "how this actually works in practice, not idealized models"), state it once as a session-level framing sentence near the top of the prompt. Per-directive restatements waste tokens and dilute the signal.

*Strategic choices (research quality):*
- **Claim anchoring:** When the inputs contain specific claims, figures, or benchmarks (e.g., a reported ratio, a percentage from an industry source), embed them in the directive as concrete anchors to validate. This focuses the model on targeted research against a specific claim rather than open-ended exploration. Extract validatable claims from the Research Plan, Answer Specs, or operator briefing and embed at least one per directive where available.
- **Sufficiency signals:** For each directive, include a brief threshold that tells the model when to stop digging and report what it has. Example: "If fewer than 3 independent sources exist for this topic, report what is available and characterize the evidence gap rather than continuing to search." Without these, the model cannot make good trade-offs when directives compete for attention within a session.
- **Depth/priority signals:** When questions within a session have unequal importance, effort signals must be operative, not just descriptive. Percentage allocations alone (e.g., "allocate ~60%") don't translate into search behavior — the execution tool front-loads effort on the first components it encounters and runs out of budget for later ones. Two mechanisms make effort signals operative: (1) order directives so the hardest or most important components appear first in the prompt, and (2) specify minimum dedicated searches per component (e.g., "Allocate at least 2 dedicated searches to Directive 3 regardless of results on earlier directives"). See `references/prompt-construction-guide.md` for operative allocation templates.
- **Per-component source quality floors:** Aggregate source targets (e.g., "≥10 sources per session") let the execution tool meet the target by stacking good sources on easy components while using a single low-quality source for critical ones. Set a per-component minimum in the prompt: no component's findings may rest on fewer than 2 independent sources. If a component has only 1 source after dedicated searching, the execution tool must classify it as thin and document the gap. See `references/prompt-construction-guide.md` for embedding templates.
- **Search seed tiering:** Seeds must match the difficulty of the question, not just the topic. Easy questions (well-documented topics, established frameworks) need broad topical seeds. Hard questions — those probing practitioner behavior, tacit knowledge, or operational detail — need narrow, high-specificity seeds targeting the source types where that evidence actually lives (practitioner surveys, GP letters, operational benchmarks). Include two tiers of seeds: broad seeds for topic coverage, and a second tier of narrow seeds explicitly labeled for the harder components. When the scope includes a geographic region, seeds must cover all constituent countries or markets, not just the most prominent ones. Use concrete source paths ("search for 'ILPA due diligence guidelines'"), not just institution names ("ILPA"). See `references/prompt-construction-guide.md` for seed tiering templates.
- **Proxy hierarchies for known data gaps:** When the scope includes specificity constraints likely to produce data gaps (niche geography, narrow market segment, recent phenomenon), include a prioritized proxy fallback chain in the prompt. The chain tells the execution tool what approximation to use and in what order when exact-match data is unavailable, and requires it to state which proxy level was used. Without explicit fallback instructions, the execution tool either returns nothing or silently approximates without flagging the substitution. Derive proxy hierarchies from the Research Plan's scope parameters and source preferences. See `references/prompt-construction-guide.md` for proxy chain templates.

*Writing craft (clarity and concision):*
- Translate Answer Spec components into research directives — never use Answer Spec terminology ("evidence component," "completion gate") in the prompt
- Use imperative verbs: "Find," "Compare," "Present," "Trace," "Identify"
- **Omit what the model already does:** Do not include instructions the model would follow naturally from a well-scoped directive — e.g., "cross-reference for consistency," "cite sources," or generic quality reminders. **Test:** if a sub-bullet is unpacking what the main instruction already means, cut it.

**2c. Steering Notes** (operator guidance, not pasted into the research tool)
- Anticipate likely thin-results areas with alternative search angles
- Specify acceptance criteria for scarcity vs. when to push harder
- Flag cross-session implications
- See `references/prompt-construction-guide.md` for steering note templates. If unavailable, cover: likely thin-results areas with alternative search angles, acceptance criteria for scarcity, and cross-session implications.

### Step 3: Assemble the Document

Produce a single markdown file with this structure:

```
# Research Execution Prompts — [Project Name]

## How to Use This Document
[Setup instructions, global settings]

## Session Plan
[Table: Session | Questions | Qs/Session | Cluster Logic | Dependencies]
[Parallel execution opportunities]

## Session [A]: [Descriptive Title]

### Settings
[Site restrictions, recency preferences]

### Execution Prompt
[Literal prompt text in code fence]

### Steering Notes
[Operator guidance]

## Session [B]: [Descriptive Title]
[Same structure]

...

## Post-Execution Notes
[Save instructions, cross-session review checklist, downstream flags]
```

See `references/prompt-construction-guide.md` for the Post-Execution Notes template. If unavailable, include: save naming convention, cross-session review checklist (contradictions, gap coverage, scope drift), and downstream flags for Research Plan assumption changes.

### Step 4: Run Self-Check

Before delivering the document, verify every item in the Self-Check list below. Fix any failures before presenting to the operator. If new conflicts or ambiguities emerge during prompt construction that were not flagged in the planning summary, pause and present them to the operator before continuing.

## Failure Behavior

- **Ambiguous Answer Spec component** — flag as `[AMBIGUITY]`, propose 1–2 interpretations, do not silently pick one
- **Unclear dependencies** — flag the uncertainty, propose conservative ordering (sequential over parallel), do not assume independence
- **Session count mismatch** — if the Execution Manifest contains more or fewer sessions than expected, flag it but proceed with what the manifest specifies
- **Scope conflict between Research Plan and Answer Specs** — flag as `[CONFLICT]` with both versions quoted, do not silently resolve
- **Missing source preferences** — generate defaults based on question domain, label as `[inferred]`
- **Missing reference file** (`references/prompt-construction-guide.md`) — proceed using the inline fallback guidance provided at each reference point in this skill. Do not halt.
- **Unknown execution tool** — if the Execution Manifest routes a session to a tool not covered by this skill's platform context, flag as `[UNSUPPORTED TOOL]`, produce a best-effort prompt using the Research GPT format, and note that the operator should review for platform compatibility.

If provided information is insufficient to make a confident decision, say so. It is acceptable to leave gaps and flag them rather than invent plausible-sounding defaults. If the operator's inputs contain an error or questionable assumption, flag it constructively.

## Self-Check

Before delivering, verify:

- Every research question from the Execution Manifest appears in exactly one session prompt
- Session plan table matches the Execution Manifest's groupings and dependencies
- Parallel execution opportunities from the manifest are reflected in the document
- Every Answer Spec evidence component is translated into a research directive in at least one prompt
- Every directive header includes the Answer Spec component ID (e.g., `Q1-A01`) for downstream traceability
- No prompt uses Answer Spec terminology — all directives are in plain research language
- Each prompt includes a per-component source quality floor instruction
- Each prompt has a labeled scope block with literal parameter values
- Each prompt includes the context pack block with `--- CONTEXT PACK ---` / `--- END CONTEXT PACK ---` delimiters, and the context pack does not duplicate scope parameters from the scope block
- Each session has specific steering notes (not generic)
- If scope parameters include known data gap risks, a proxy fallback chain is included in the prompt
- Site restriction guidance is included for every session (even if "Default")
- Post-execution notes section is present

## Output Protocol

**Default mode: Refinement**

Before producing the full document, present the planning summary defined in the Planning Protocol above (session summary, prompt strategy, key assumptions, flags). **Do not produce the full document until the operator approves the plan.** After approval, write the complete document to file.
