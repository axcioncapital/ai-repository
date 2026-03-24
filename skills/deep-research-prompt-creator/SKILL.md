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

**Information boundary:** Base all clustering, dependency, and prompt decisions exclusively on the provided inputs. Do not supplement with assumed domain knowledge.

## Platform Context

GPT Deep Research (GPT-5.2-based, early 2026) has characteristics that constrain prompt design:

- **No clarification step** — research starts immediately from the prompt. Prompt quality is the single biggest lever on output quality.
- **Keyword-driven search** — the model uses keywords from the prompt as search seeds. Embed domain-specific terms, proper nouns, and technical terminology explicitly.
- **Session capacity** — overloaded prompts produce shallow coverage on later questions. Keep sessions to 2–4 questions.
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

Group questions into sessions of 2–4 questions each. Clustering criteria (priority order):

1. **Source base overlap** — questions that draw from the same literature, databases, or source types (strongest signal)
2. **Conceptual chain** — Question B's scope references Question A's definitions or outputs
3. **Analytical lens** — questions applying the same framework to different aspects

**Session sizing:**
- 2–4 questions per session. Never exceed 4.
- A single question with 4+ complex evidence components may warrant its own session.
- Two questions with near-identical source bases but no conceptual link still group together — source overlap dominates.

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

The prompt must be self-contained. It includes:

1. **Attachment reference** — explicit mention of the attached Research Plan and its purpose
2. **Scope framing** — key scope parameters embedded as literal values, not abstract references
3. **Per-question research directives** — translated from Answer Spec components into plain-language directives. Load `references/prompt-construction-guide.md` for translation patterns, output format templates, and depth signal language.
4. **Output format instructions** — tables for structured data, short paragraphs for analysis, inline citations required
5. **Depth/priority signals** — which questions to prioritize if trade-offs are needed

**Prompt construction rules:**
- Translate Answer Spec components into research directives — never use Answer Spec terminology ("evidence component," "completion gate") in the prompt
- Embed scope parameters as literal values ("Focus on Nordic PE funds with EUR 50M–500M AUM" not "Use the scope defined in the Research Plan")
- Use imperative verbs: "Find," "Compare," "Present," "Trace," "Identify"
- Specify output shape per question: "as a table with columns...," "in 2–3 paragraphs," "as a numbered list"
- Include domain-specific keywords and technical terms as search seeds
- Include depth/priority signals when questions within a session have unequal importance

**4c. Steering Notes** (operator guidance, not pasted into Deep Research)
- Anticipate likely thin-results areas with alternative search angles
- Specify acceptance criteria for scarcity vs. when to push harder
- Flag cross-session implications
- See `references/prompt-construction-guide.md` for steering note templates

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

See `references/prompt-construction-guide.md` for the Post-Execution Notes template.

## Failure Behavior

- **Ambiguous Answer Spec component** — flag as `[AMBIGUITY]`, propose 1–2 interpretations, do not silently pick one
- **Unclear dependencies** — flag the uncertainty, propose conservative ordering (sequential over parallel), do not assume independence
- **Session overload (>4 questions)** — split and explain the rationale
- **Scope conflict between Research Plan and Answer Specs** — flag as `[CONFLICT]` with both versions quoted, do not silently resolve
- **Missing source preferences** — generate defaults based on question domain, label as `[inferred]`

If provided information is insufficient to make a confident decision, say so. It is acceptable to leave gaps and flag them rather than invent plausible-sounding defaults. If the operator's inputs contain an error or questionable assumption, flag it constructively.

## Self-Check

Before delivering, verify:

- Every research question appears in exactly one session
- No session exceeds 4 questions
- All hard dependencies are reflected in the session plan table
- Parallel execution opportunities are explicitly identified
- Every Answer Spec evidence component is translated into a research directive in at least one prompt
- No prompt uses Answer Spec terminology — all directives are in plain research language
- Scope parameters are embedded as literal values in each prompt
- Each prompt includes an attachment reference for the Research Plan
- Each session has specific steering notes (not generic)
- Site restriction guidance is included for every session (even if "Default")
- Post-execution notes section is present

## Output Protocol

**Default mode: Refinement**

Before producing the full document, present the planning summary defined in the Planning Protocol above (session clustering, dependency map, key assumptions, flags). **Do not produce the full document until the operator approves the plan.** After approval, write the complete document to file.
