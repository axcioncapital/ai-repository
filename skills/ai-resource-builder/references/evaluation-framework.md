# AI Resource Evaluation Framework

## Table of Contents

1. [How to Use This Document](#how-to-use-this-document)
2. [Phase 1: Behavioral Analysis](#phase-1-behavioral-analysis)
3. [Phase 2: Convention Gate](#phase-2-convention-gate)
4. [Output Format](#output-format)
5. [Severity Definitions](#severity-definitions)
6. [Worked Example](#worked-example)

## How to Use This Document

This is a standalone evaluation framework. It is passed directly to evaluation subagents that have no other context about the resource being evaluated.

**Input requirements.** Include when available:
- Resource name (or infer from YAML `name` field -> first H1 -> filename -> "Untitled resource")
- Target platform (Claude/ChatGPT/other) — platform-specific constraints may apply
- Dependencies or referenced assets
- Intended runtime context (standalone, embedded in project, API use)

For multi-file input, delimit with `--- file: path ---` between each file.

**Workflow:**
1. Identify resource type (Skill, Prompt, or Project Instruction). If ambiguous, default to best-fit and note it.
2. Run Phase 1: Behavioral Analysis (eight-layer evaluation)
3. Run Phase 2: Convention Gate (structural and metadata checks)
4. Produce combined report using the Output Format

---

## Phase 1: Behavioral Analysis

Evaluate each layer by asking four questions:
1. **Present?** Can you identify content serving this layer?
2. **Complete?** Does it address the completeness criteria?
3. **Consistent?** Does it conflict with other layers?
4. **Appropriate?** Over- or under-engineered for the resource type?

### The Eight Layers

| Layer | What It Does | Signs It's Weak | Completeness Criteria |
|-------|--------------|-----------------|----------------------|
| **Purpose** | Establishes role and primary intent | Model optimizes for wrong outcome or generic helpfulness; resource tries to accomplish too many things | Single primary goal + intended user + success outcome |
| **Context Boundary** | Controls where model draws information from | Model invents plausible-sounding data not in source material | Allowed sources, disallowed sources, tool/browsing policy, citation requirements |
| **Interpretation** | Handles ambiguity in user input | Misunderstands informal or incomplete requests | How to handle vague/incomplete input, when to ask vs assume |
| **Reasoning Constraints** | Epistemic stance, confidence calibration, bias counters, pushback triggers | Over-helpful, falsely confident, avoids necessary pushback | Confidence thresholds, when to express uncertainty, what biases to counter |
| **Decision** | Action principles, priority rules, tiebreakers | Inconsistent judgment across similar cases | Decision hierarchy, priority rules, tiebreaker logic |
| **Constraints** | Hard rules and boundaries | Violates intended limits, produces off-spec outputs | Explicit boundaries, refusals, scope limits |
| **Failure Behavior** | What to do when uncertain or blocked | Hallucinates rather than admitting uncertainty | Behavior for: missing input, uncertainty, conflicting constraints, blocked paths |
| **Output Contract** | Exact format and structure of output | Unpredictable response formats | Format, structure, required fields, length guidance |

### Scoring Rubric

| Status | Meaning | When to Use |
|--------|---------|-------------|
| ✓ Present | Layer is explicit and testable | Content clearly serves this layer and meets completeness criteria |
| ⚠️ Weak | Layer is implied or incomplete | Content partially addresses layer, or too vague to test |
| ✗ Missing | Layer is absent or unidentifiable | No content serves this layer |
| N/A | Layer does not apply | Only for: Interpretation (non-conversational), Decision (minimal single-purpose prompts) |

### Single-Responsibility Check

A resource violates single-responsibility when it tries to accomplish multiple unrelated goals:
- Evaluate + rewrite + generate tests + deploy in one resource
- Combines unrelated domains (e.g., email drafting + code review)
- Multiple audiences with conflicting needs

**Exception:** Explicitly scoped multi-phase workflows with clear phase boundaries.

Flag violations as **Critical** under Purpose layer.

### Priority Matrix

Calibrates evaluation intensity by resource type. Severity flows from layer priority.

| Layer | Skill | Project Instructions | Prompt |
|-------|-------|---------------------|--------|
| Purpose | Critical | Critical | Important |
| Context Boundary | Critical | Important | Important if standalone; Optional if embedded |
| Interpretation | Important if user-facing; Optional if programmatic | Important | Optional |
| Reasoning Constraints | Important | Important | Important if advisory/analytical; Optional if formatting |
| Decision | Important | Critical | Optional |
| Constraints | Critical | Important | Optional |
| Failure Behavior | Critical | Important | Important — default to "state assumptions and proceed" |
| Output Contract | Critical | Optional | Important |

**Severity assignment:**
- **Critical** layer missing/weak -> Critical issue
- **Important** layer missing/weak -> Major issue
- **Optional** layer missing -> Minor or no issue

### Type-Specific Criteria

After eight-layer evaluation, check these implementation details.

#### Skills

| Category | What to Check |
|----------|---------------|
| **Trigger clarity** | Description specific enough to trigger correctly? Includes "when to use" AND "when not to use"? |
| **Scope boundaries** | Clear what's in/out of scope? Could conflict with other skills? |
| **Workflow completeness** | All steps defined? Missing decision points? |
| **Resource references** | Bundled resources (scripts, references, assets) properly referenced? |
| **Progressive disclosure** | SKILL.md lean? Should content move to references/? |

#### Prompts

| Category | What to Check |
|----------|---------------|
| **Input specification** | Clear what input the prompt expects? Formats, constraints? |
| **Output specification** | Desired output defined? Format, length, structure? |
| **Context assumptions** | Assumes context that won't be present? |
| **Variable handling** | Placeholders/variables clear? Default values needed? |
| **Standalone usability** | Works without additional explanation? |

#### Project Instructions

| Category | What to Check |
|----------|---------------|
| **Role clarity** | Model's role in this project clear? |
| **Scope definition** | Project scope explicit? In-scope vs out-of-scope? |
| **Constraint specificity** | Constraints actionable or vague guidance? |
| **Integration** | How does this interact with skills? Potential conflicts? |
| **Methodology references** | Referenced skills/workflows available and correct? |

---

## Phase 2: Convention Gate

These checks catch structural and convention issues that behavioral analysis cannot detect. They are binary: Pass, Fail, or N-A.

**Applicability:**
- C1-C9: Skills only (prompts and project instructions skip these)
- C10-C14: Skills primarily; C14 also applies to prompts
- C15-C19: Skills with bundled resources only

### Metadata Conventions

| # | Check | Pass Criteria |
|---|-------|---------------|
| C1 | Name format | `name` is kebab-case, matches folder name, uses namespace prefix if applicable |
| C2 | Description front-loading | First 250 characters contain the primary trigger phrases |
| C3 | Description constraints | Third person voice, specific (not generic), under 1024 characters |
| C4 | Negative triggers | If skill's domain overlaps with another skill, description includes "Do NOT use for" exclusions |
| C5 | Body length | SKILL.md body under 500 lines |

### Frontmatter Configuration

| # | Check | Pass Criteria |
|---|-------|---------------|
| C6 | Invocation control | `disable-model-invocation` decision documented if skill has side effects |
| C7 | Tool restrictions | `allowed-tools` decision documented if scope matters |
| C8 | Paths field | `paths` field considered (included or explicitly ruled out) |
| C9 | Runtime config | Agent/effort/model preferences considered and documented in runtime recommendations |

### Structural Conventions

| # | Check | Pass Criteria |
|---|-------|---------------|
| C10 | Reference depth | All reference files are one level deep from SKILL.md |
| C11 | Reference TOC | Reference files over 100 lines include a table of contents |
| C12 | Time-sensitive content | No time-sensitive info in body, or isolated in collapsible section with date stamp |
| C13 | Runtime recommendations | Section present documenting model, context, and performance notes |
| C14 | Examples present | For output-dependent resources, concrete input/output examples are included |

### Bundled Resource Quality

| # | Check | Pass Criteria |
|---|-------|---------------|
| C15 | Execute vs. read | For every bundled script, SKILL.md clarifies whether to execute or read as reference |
| C16 | Script error handling | Bundled scripts handle errors explicitly (no silent failures) |
| C17 | No magic constants | Scripts and instructions contain no unexplained numeric thresholds or constants |
| C18 | Dependencies verified | External dependencies (packages, tools, APIs) listed and confirmed available |
| C19 | Progress tracking | Instruction-only skills (no scripts/tools) use checklist-based progress tracking for complex workflows |

### Convention Gate Severity

- Failed metadata conventions (C1-C5) → Major issue (these affect discoverability and compliance)
- Failed frontmatter configuration (C6-C9) → Minor issue (these affect runtime behavior but not correctness)
- Failed structural conventions (C10-C14) → Major issue (these affect usability)
- Failed bundled resource quality (C15-C19) → Major issue (these affect reliability)

---

## Output Format

Number all issues sequentially across both phases. User can reply with just numbers (e.g., "1, 4, 7") to indicate which to address.

```
## Evaluation: [Resource Name]

**Resource type:** [Skill / Prompt / Project Instruction]
**Target platform:** [If specified, else "—"]
**Classification note:** [If ambiguous, explain. Otherwise: "—"]

### Layer Coverage (Phase 1)

| Layer | Status | Notes |
|-------|--------|-------|
| Purpose | ✓ / ⚠️ / ✗ | [Brief note] |
| Context Boundary | ✓ / ⚠️ / ✗ | [Brief note] |
| Interpretation | ✓ / ⚠️ / ✗ / N/A | [Brief note] |
| Reasoning Constraints | ✓ / ⚠️ / ✗ | [Brief note] |
| Decision | ✓ / ⚠️ / ✗ / N/A | [Brief note] |
| Constraints | ✓ / ⚠️ / ✗ | [Brief note] |
| Failure Behavior | ✓ / ⚠️ / ✗ | [Brief note] |
| Output Contract | ✓ / ⚠️ / ✗ | [Brief note] |

### Convention Gate (Phase 2)

| # | Check | Status | Notes |
|---|-------|--------|-------|
[Applicable items only — skip N-A items]

### Issues Found

**1. [Severity: Critical / Major / Minor]** — [Layer or Convention #]
- **Issue:** [Description]
- **Location:** [Where in the resource]
- **Fix:** [Specific suggestion]

[Continue sequential numbering across both phases]

### Summary
- Critical: [n]
- Major: [n]
- Minor: [n]
- Convention gate: [n]/[n] passed
- Total issues: [n]
```

If no issues found, show all layers as ✓ Present and state: "No issues identified. Resource appears ready for testing."

---

## Severity Definitions

- **Critical** — Will cause incorrect behavior or failures. Must fix before use. Includes: missing Critical-priority layers, single-responsibility violations, contradictions between layers.
- **Major** — Likely to cause problems in common scenarios. Should fix. Includes: missing Important-priority layers, incomplete coverage, weak failure behavior, failed structural conventions.
- **Minor** — Edge cases, style, improvements. Nice to fix. Includes: missing Optional layers, over-engineering, minor inconsistencies, failed frontmatter configuration items.

---

## Worked Example

**Input:**
```
You are a helpful assistant. Answer the user's questions about our product catalog.
```

**Evaluation:**

**Resource type:** Prompt
**Target platform:** —
**Classification note:** —

### Layer Coverage (Phase 1)

| Layer | Status | Notes |
|-------|--------|-------|
| Purpose | ⚠️ Weak | "Helpful assistant" is generic; no success criteria |
| Context Boundary | ✗ Missing | No specification of allowed sources |
| Interpretation | N/A | Minimal prompt |
| Reasoning Constraints | ✗ Missing | No guidance on confidence or uncertainty |
| Decision | N/A | Single-purpose prompt |
| Constraints | ✗ Missing | No boundaries defined |
| Failure Behavior | ✗ Missing | No guidance when uncertain |
| Output Contract | ✗ Missing | No format specified |

### Convention Gate (Phase 2)

Skipped — resource is a prompt, not a skill.

### Issues Found

**1. Critical** — Context Boundary
- **Issue:** No specification of where to draw product information from.
- **Location:** Entire prompt
- **Fix:** Add: "Use only the product catalog provided in context. Do not invent product details."

**2. Critical** — Failure Behavior
- **Issue:** No guidance when product isn't in catalog.
- **Location:** Entire prompt
- **Fix:** Add: "If a product is not in the catalog, say so. Do not guess."

**3. Major** — Purpose
- **Issue:** "Helpful assistant" is generic; model may over-help outside scope.
- **Location:** Opening sentence
- **Fix:** "You are a product catalog assistant. Help users find products using only the provided catalog."

### Summary
- Critical: 2
- Major: 1
- Minor: 0
- Convention gate: N/A (prompt)
- Total issues: 3

---

## Evaluation Principles

- **Be specific** — "Purpose layer is weak" is not sufficient. Identify exactly what's missing.
- **Every issue needs a fix** — Concrete, implementable suggestion.
- **Severity from the matrix** — Use the priority matrix, not gut feel.
- **Test failure modes** — For any ⚠️/✗ in Failure Behavior, propose a default pattern.
