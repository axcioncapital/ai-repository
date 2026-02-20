---
name: ai-resource-evaluator
description: >
  Evaluates AI resources (skills, prompts, project instructions) against an
  eight-layer quality framework to identify structural weaknesses before
  deployment. Use when: (1) evaluating a newly created skill, prompt, or
  project instruction, (2) reviewing an existing resource for quality issues,
  (3) checking a resource before deployment. Designed for same-chat evaluation
  of drafts.
---

# AI Resource Evaluator

Evaluate AI resources against the eight-layer framework to identify structural weaknesses before deployment.

## Input Requirements

Include when available:
- Resource name (or infer from YAML `name` field → first H1 → filename → "Untitled resource")
- Target platform (Claude/ChatGPT/other) — platform-specific constraints may apply
- Dependencies or referenced assets
- Intended runtime context (standalone, embedded in project, API use)

For multi-file input, delimit with `--- file: path ---` between each file.

## Workflow

1. **Identify resource type** — Skill, prompt, or project instruction. If ambiguous, default to best-fit and note it.
2. **Apply eight-layer evaluation** — Check each layer using the priority matrix and scoring rubric. For Failure Behavior, mentally test: What happens if required input is missing? If the model is uncertain? If constraints conflict?
3. **Apply type-specific criteria** — Check implementation details specific to that resource type
4. **Report findings** — Present numbered issues with severity and suggested fixes

## The Eight Layers

Evaluate each layer by asking:
1. **Present?** Can you identify content serving this layer?
2. **Complete?** Does it address the completeness criteria?
3. **Consistent?** Does it conflict with other layers?
4. **Appropriate?** Over- or under-engineered for the resource type?

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

## Priority Matrix

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
- **Critical** layer missing/weak → Critical issue
- **Important** layer missing/weak → Major issue
- **Optional** layer missing → Minor or no issue

## Type-Specific Criteria

After eight-layer evaluation, check these implementation details.

### Skills

| Category | What to Check |
|----------|---------------|
| **Trigger clarity** | Description specific enough to trigger correctly? Includes "when to use" AND "when not to use"? |
| **Scope boundaries** | Clear what's in/out of scope? Could conflict with other skills? |
| **Workflow completeness** | All steps defined? Missing decision points? |
| **Resource references** | Bundled resources (scripts, references, assets) properly referenced? |
| **Progressive disclosure** | SKILL.md lean? Should content move to references/? |

### Prompts

| Category | What to Check |
|----------|---------------|
| **Input specification** | Clear what input the prompt expects? Formats, constraints? |
| **Output specification** | Desired output defined? Format, length, structure? |
| **Context assumptions** | Assumes context that won't be present? |
| **Variable handling** | Placeholders/variables clear? Default values needed? |
| **Standalone usability** | Works without additional explanation? |

### Project Instructions

| Category | What to Check |
|----------|---------------|
| **Role clarity** | Model's role in this project clear? |
| **Scope definition** | Project scope explicit? In-scope vs out-of-scope? |
| **Constraint specificity** | Constraints actionable or vague guidance? |
| **Integration** | How does this interact with skills? Potential conflicts? |
| **Methodology references** | Referenced skills/workflows available and correct? |

## Output Format

Number all issues sequentially. User can reply with just numbers (e.g., "1, 4, 7") to indicate which to address.

**Resource name inference:** YAML `name` field → first H1 → filename → "Untitled resource".

```
## Evaluation: [Resource Name]

**Resource type:** [Skill / Prompt / Project Instruction]
**Target platform:** [If specified, else "—"]
**Classification note:** [If ambiguous, explain. Otherwise: "—"]

### Layer Coverage

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

### Issues Found

**1. [Severity: Critical / Major / Minor]** — [Layer or Category]
- **Issue:** [Description]
- **Location:** [Where in the resource]
- **Fix:** [Specific suggestion]

[Continue sequential numbering]

### Summary
- Critical: [n]
- Major: [n]
- Minor: [n]
- Total issues: [n]
```

If no issues found, show all layers as ✓ Present and state: "No issues identified. Resource appears ready for testing."

## Severity Definitions

- **Critical** — Will cause incorrect behavior or failures. Must fix before use. Includes: missing Critical-priority layers, single-responsibility violations, contradictions between layers.
- **Major** — Likely to cause problems in common scenarios. Should fix. Includes: missing Important-priority layers, incomplete coverage, weak failure behavior.
- **Minor** — Edge cases, style, improvements. Nice to fix. Includes: missing Optional layers, over-engineering, minor inconsistencies.

## Worked Example

**Input:**
```
You are a helpful assistant. Answer the user's questions about our product catalog.
```

**Evaluation:**

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

**1. Critical** — Context Boundary: No specification of where to draw product information from. Fix: "Use only the product catalog provided in context. Do not invent product details."

**2. Critical** — Failure Behavior: No guidance when product isn't in catalog. Fix: "If a product is not in the catalog, say so. Do not guess."

**3. Major** — Purpose: "Helpful assistant" is generic; model may over-help outside scope. Fix: "You are a product catalog assistant. Help users find products using only the provided catalog."

Summary: Critical: 2, Major: 1, Minor: 0, Total: 3

## Evaluation Principles

- **Be specific** — "Purpose layer is weak" is not sufficient. Identify exactly what's missing.
- **Every issue needs a fix** — Concrete, implementable suggestion.
- **Severity from the matrix** — Use the priority matrix, not gut feel.
- **Test failure modes** — For any ⚠️/✗ in Failure Behavior, propose a default pattern.
