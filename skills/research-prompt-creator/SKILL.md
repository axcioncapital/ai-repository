---
name: research-prompt-creator
description: >
  Transform an Execution Manifest, Research Plan, and Answer Specs into a
  Research Execution Prompts document — per-session execution prompts, session
  plan table, and operational notes for GPT Deep Research. Session groupings and
  tool assignments come from the Execution Manifest (produced by
  execution-manifest-creator); this skill writes the prompts, not the routing.
  Trigger when an Execution Manifest with Deep Research sessions exists and the
  operator needs execution prompts, or on requests like "create research
  prompts" or "write prompts for these sessions." This is Step 2.2 in Stage 2
  of the Axcion Research Workflow. Do NOT use for research plan creation
  (research-plan-creator), answer spec generation (answer-spec-generator),
  execution routing (execution-manifest-creator), evidence compression, or
  direct research execution — this skill produces prompts for the operator to
  paste into GPT Deep Research.
---

# Research Prompt Creator

## Input Requirements

**Required:**
1. **Execution Manifest** — produced by `execution-manifest-creator`. Contains session groupings, tool assignments (GPT vs. Perplexity Deep Research), dependencies, and parallel execution opportunities. Accept the manifest's routing and grouping decisions as given — do not re-cluster or re-route questions.
2. **Research Plan** — research questions with scope, key terms, source preferences, search terminology guidance
3. **Answer Specs** — per-question specifications defining required evidence components, evidence rules, and completion gates

All provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Proceed with `[inferred]` defaults only for non-critical gaps (e.g., missing source preferences). Halt for critical gaps (missing Execution Manifest, missing scope parameters, missing questions).

**Question-spec mismatch:** If the Execution Manifest references questions not found in the Answer Specs (or vice versa), flag as `[MISMATCH]`, list orphaned items, and ask whether to proceed with the matched subset or halt.

**Information boundary:** Accept session groupings, dependencies, and tool assignments from the Execution Manifest without modification. Base prompt construction decisions (priority allocation, depth signals, format choices) on the provided inputs. Domain knowledge is acceptable for search term selection, keyword seeding, and steering note context — these benefit from the model knowing the field.

## Platform Context

GPT Deep Research (GPT-5.2-based, early 2026) has characteristics that constrain prompt design:

- **No clarification step** — research starts immediately from the prompt. Prompt quality is the single biggest lever on output quality.
- **Keyword-driven search** — the model uses keywords from the prompt as search seeds. Embed domain-specific terms, proper nouns, and technical terminology explicitly.
- **Session capacity** — overloaded prompts produce shallow coverage on later questions. Session groupings come from the Execution Manifest; focus on writing prompts that work well within the given session sizes.
- **Structured output** — tables, headers, and format instructions are well-followed. Leverage this.
- **File attachments** — the Research Plan should always be attached for scope context.
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
1. **Attachment reference** — explicit mention of the attached Research Plan and its purpose
2. **Scope block** — a clearly labeled standalone block with all scope parameters as literal values (geography, deal size, fund size, time frame, industry focus). Placed before the directives so the model references it throughout.
3. **Per-question research directives** — translated from Answer Spec components into plain-language directives. Load `references/prompt-construction-guide.md` for translation patterns, output format templates, and depth signal language. If this file is unavailable, use the translation principles and format templates described in the prompt construction rules below.

**Conditional:**
4. **Epistemic frame** — include when multiple directives share a research stance (e.g., "Focus on how this works in practice, not idealized models"). Set once as a session-level framing sentence; do not restate per directive. Omit when directives have no shared epistemic orientation.
5. **Output format instructions** — include for structured/quantitative directives (prescribe tables, columns). Omit for analytical/qualitative directives — state the deliverable and let the model choose format.
6. **Depth/priority signals** — include when questions within a session have unequal importance. Use concrete effort allocation percentages and sufficiency thresholds. Omit when all directives in a session have equal weight.

**Prompt construction rules:**

Rules are grouped by priority. Structural decisions shape the prompt architecture — if these are wrong, good writing won't compensate. Strategic choices govern research depth and focus. Writing craft ensures clarity and concision.

*Structural decisions (highest priority):*
- **Scope block separation:** Pull scope parameters (geography, deal size, fund size, time frame, industry focus) into a clearly labeled standalone block at the top of the execution prompt, separate from the research directives. Directives reference the scope block rather than re-embedding parameters inline. Clean separation means the same scope block can be reused across sessions without rewriting.
- **Format prescription — match to directive type:** Prescribe specific output format (tables, column names) for structured/quantitative directives where the value is in the data shape. For analytical or qualitative directives (pattern analysis, narrative synthesis, value judgments), state the deliverable clearly but let the model choose the best format. Over-prescribing format on qualitative work forces the model to fit insights into structures that may not serve them.
- **Epistemic frame — set once, not per-directive:** If multiple directives share a research stance (e.g., "how this actually works in practice, not idealized models"), state it once as a session-level framing sentence near the top of the prompt. Per-directive restatements waste tokens and dilute the signal.

*Strategic choices (research quality):*
- **Claim anchoring:** When the inputs contain specific claims, figures, or benchmarks (e.g., a reported ratio, a percentage from an industry source), embed them in the directive as concrete anchors to validate. This focuses the model on targeted research against a specific claim rather than open-ended exploration. Extract validatable claims from the Research Plan, Answer Specs, or operator briefing and embed at least one per directive where available.
- **Sufficiency signals:** For each directive, include a brief threshold that tells the model when to stop digging and report what it has. Example: "If fewer than 3 independent sources exist for this topic, report what is available and characterize the evidence gap rather than continuing to search." Without these, the model cannot make good trade-offs when directives compete for attention within a session.
- **Depth/priority signals:** When questions within a session have unequal importance, use concrete effort allocation (e.g., "Allocate approximately 60% of research effort to Directive 2") rather than only qualitative labels like "highest priority" or "lower priority." Qualitative labels alone tend to produce "do last and run out of time" rather than intentionally lighter coverage.
- Include domain-specific keywords and technical terms as search seeds

*Writing craft (clarity and concision):*
- Translate Answer Spec components into research directives — never use Answer Spec terminology ("evidence component," "completion gate") in the prompt
- Use imperative verbs: "Find," "Compare," "Present," "Trace," "Identify"
- **Omit what the model already does:** Do not include instructions the model would follow naturally from a well-scoped directive — e.g., "cross-reference for consistency," "cite sources," or generic quality reminders. **Test:** if a sub-bullet is unpacking what the main instruction already means, cut it.

**2c. Steering Notes** (operator guidance, not pasted into Deep Research)
- Anticipate likely thin-results areas with alternative search angles
- Specify acceptance criteria for scarcity vs. when to push harder
- Flag cross-session implications
- See `references/prompt-construction-guide.md` for steering note templates. If unavailable, cover: likely thin-results areas with alternative search angles, acceptance criteria for scarcity, and cross-session implications.

### Step 3: Assemble the Document

Produce a single markdown file with this structure:

```
# Research Execution Prompts — [Project Name]

## How to Use This Document
[Setup instructions, attachment reminder, global settings]

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

## Failure Behavior

- **Ambiguous Answer Spec component** — flag as `[AMBIGUITY]`, propose 1–2 interpretations, do not silently pick one
- **Unclear dependencies** — flag the uncertainty, propose conservative ordering (sequential over parallel), do not assume independence
- **Session count mismatch** — if the Execution Manifest contains more or fewer sessions than expected, flag it but proceed with what the manifest specifies
- **Scope conflict between Research Plan and Answer Specs** — flag as `[CONFLICT]` with both versions quoted, do not silently resolve
- **Missing source preferences** — generate defaults based on question domain, label as `[inferred]`
- **Missing reference file** (`references/prompt-construction-guide.md`) — proceed using the inline fallback guidance provided at each reference point in this skill. Do not halt.

If provided information is insufficient to make a confident decision, say so. It is acceptable to leave gaps and flag them rather than invent plausible-sounding defaults. If the operator's inputs contain an error or questionable assumption, flag it constructively.

## Self-Check

Before delivering, verify:

- Every research question from the Execution Manifest appears in exactly one session prompt
- Session plan table matches the Execution Manifest's groupings and dependencies
- Parallel execution opportunities from the manifest are reflected in the document
- Every Answer Spec evidence component is translated into a research directive in at least one prompt
- No prompt uses Answer Spec terminology — all directives are in plain research language
- Each prompt has a labeled scope block with literal parameter values
- Each prompt includes an attachment reference for the Research Plan
- Each session has specific steering notes (not generic)
- Site restriction guidance is included for every session (even if "Default")
- Post-execution notes section is present

## Output Protocol

**Default mode: Refinement**

Before producing the full document, present the planning summary defined in the Planning Protocol above (session summary, prompt strategy, key assumptions, flags). **Do not produce the full document until the operator approves the plan.** After approval, write the complete document to file.
