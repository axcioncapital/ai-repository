---
name: deep-research-prompt-creator
description: >
  Transform a Research Plan and Answer Specs into a Deep Research Execution
  Prompts document — session clustering, per-session execution prompts, session
  plan table, and operational notes for GPT Deep Research. Trigger when both a
  Research Plan and Answer Specs are provided and the operator needs execution
  prompts, or on requests like "create deep research prompts" or "turn this plan
  into DR sessions." This is Step 2.1 in Stage 2 of the Axcion Research Workflow.
  Do NOT use for research plan creation (research-plan-creator), answer spec
  generation (answer-spec-generator), evidence compression, or direct research
  execution — this skill produces prompts for the operator to paste into GPT
  Deep Research.
---

# Deep Research Prompt Creator

## Input Requirements

**Required:**
1. **Research Plan** — research questions with scope, key terms, source preferences, search terminology guidance
2. **Answer Specs** — per-question specifications defining required evidence components, evidence rules, and completion gates

Both provided by the operator. Do not generate these.

**If inputs are incomplete:** Flag missing elements. Proceed with `[inferred]` defaults only for non-critical gaps (e.g., missing source preferences). Halt for critical gaps (missing scope parameters, missing questions).

**Question-spec mismatch:** If the Research Plan contains questions without corresponding Answer Specs (or vice versa), flag as `[MISMATCH]`, list orphaned items, and ask whether to proceed with the matched subset or halt.

**Information boundary:** Base structural decisions (clustering, dependencies, session sizing, priority allocation) exclusively on the provided inputs. Domain knowledge is acceptable for search term selection, keyword seeding, and steering note context — these benefit from the model knowing the field.

## Platform Context

GPT Deep Research (GPT-5.2-based, early 2026) has characteristics that constrain prompt design:

- **No clarification step** — research starts immediately from the prompt. Prompt quality is the single biggest lever on output quality.
- **Keyword-driven search** — the model uses keywords from the prompt as search seeds. Embed domain-specific terms, proper nouns, and technical terminology explicitly.
- **Session capacity** — overloaded prompts produce shallow coverage on later questions. Default to 2 questions per session; 3 is the hard ceiling.
- **Structured output** — tables, headers, and format instructions are well-followed. Leverage this.
- **File attachments** — the Research Plan should always be attached for scope context.
- **Site restrictions** — the operator can restrict or prioritize specific sites per session via the ChatGPT UI.

## Planning Protocol

Before producing the full document, present:

1. **Session clustering** — which questions go in which sessions and why
2. **Dependency map** — hard/soft dependencies and parallel execution opportunities
3. **Key assumptions** — any inferences about clustering or priority
4. **Flags** — ambiguities, conflicts, or gaps found in the inputs

Proceed to full document only after the operator confirms the plan.

## Workflow

### Step 1: Analyze Inputs

Read the Research Plan and Answer Specs. Extract:

- All research questions with their IDs
- Scope parameters (geography, deal size range, fund size range, time frame, industry focus)
- Per-question evidence components and completion gates
- Source preferences and search terminology guidance
- Explicit dependencies between questions

### Step 2: Cluster Questions into Sessions

Group questions into sessions. Default is 2 questions per session. Clustering criteria (priority order):

1. **Source base overlap** — questions that draw from the same literature, databases, or source types (strongest signal)
2. **Conceptual chain** — Question B's scope references Question A's definitions or outputs
3. **Analytical lens** — questions applying the same framework to different aspects

**Session sizing:**
- **2 questions per session is the default.** Never exceed 3.
- A single question with 4+ complex evidence components may warrant its own session.
- Two questions with near-identical source bases but no conceptual link still group together — source overlap dominates.

**Justification check for 3-question sessions:**
A session may include 3 questions only if all three conditions are met: (1) strong source base overlap across all three, (2) no mix of high-priority and lower-priority questions, and (3) all three questions have simple evidence requirements (1–2 components each). If any condition fails, split. Optimize for output quality per question, not minimum session count.

### Step 3: Map Dependencies

For each session pair, determine:

- **Hard dependency** — Session B cannot run until Session A completes (B references A's output). Mark: `Requires: Session [A]`
- **Soft dependency** — Session B benefits from A's results but can run with Research Plan defaults. Mark: `Benefits from: Session [A] (can run independently)`
- **No dependency** — mark: `None`

Identify all parallel execution opportunities.

### Step 4: Construct Per-Session Prompts

For each session, produce:

**4a. Session Header**
- Session letter (A, B, C...)
- Questions included (by ID and short title)
- Site restriction guidance (mode, sites, rationale) — or "Default (full web search)"
- Recency preference (e.g., "Prefer sources from 2023–present" or "No recency constraint")

**4b. Execution Prompt** (in a code fence — literal text for the operator to paste)

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

**4c. Steering Notes** (operator guidance, not pasted into Deep Research)
- Anticipate likely thin-results areas with alternative search angles
- Specify acceptance criteria for scarcity vs. when to push harder
- Flag cross-session implications
- See `references/prompt-construction-guide.md` for steering note templates. If unavailable, cover: likely thin-results areas with alternative search angles, acceptance criteria for scarcity, and cross-session implications.

### Step 5: Assemble the Document

Produce a single markdown file with this structure:

```
# Deep Research Execution Prompts — [Project Name]

## How to Use This Document
[Setup instructions, attachment reminder, global settings]

## Session Plan
[Table: Session | Questions | Cluster Logic | Dependencies]
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
- **Session overload (>3 questions)** — split and explain the rationale
- **Scope conflict between Research Plan and Answer Specs** — flag as `[CONFLICT]` with both versions quoted, do not silently resolve
- **Missing source preferences** — generate defaults based on question domain, label as `[inferred]`
- **Missing reference file** (`references/prompt-construction-guide.md`) — proceed using the inline fallback guidance provided at each reference point in this skill. Do not halt.

If provided information is insufficient to make a confident decision, say so. It is acceptable to leave gaps and flag them rather than invent plausible-sounding defaults. If the operator's inputs contain an error or questionable assumption, flag it constructively.

## Self-Check

Before delivering, verify:

- Every research question appears in exactly one session
- No session exceeds 3 questions; any 3-question session has explicit justification
- All hard dependencies are reflected in the session plan table
- Parallel execution opportunities are explicitly identified
- Every Answer Spec evidence component is translated into a research directive in at least one prompt
- No prompt uses Answer Spec terminology — all directives are in plain research language
- Each prompt has a labeled scope block with literal parameter values
- Each prompt includes an attachment reference for the Research Plan
- Each session has specific steering notes (not generic)
- Site restriction guidance is included for every session (even if "Default")
- Post-execution notes section is present

## Output Protocol

**Default mode: Refinement**

Before producing the full document, present the planning summary defined in the Planning Protocol above (session clustering, dependency map, key assumptions, flags). **Do not produce the full document until the operator approves the plan.** After approval, write the complete document to file.
