---
name: report-compliance-qc
description: >
  Compliance QC for individual report chapters during Stage 4 production. Checks structural
  compliance against report architecture, evidence handling rules, style reference conformance,
  and prose quality anti-patterns. Produces PASS/FAIL verdict with per-finding severity
  (BLOCKING/NON-BLOCKING). Use at Step 4.2c of /run-report after chapter prose review.
  Do NOT use for editorial quality review (that's chapter-prose-reviewer), cross-module
  integration checks (that's document-integration-qc), or evidence completeness against
  answer specs (that's evidence-spec-verifier).
---

# Report Compliance QC

Checks whether a chapter follows the rules for how report prose should be written — structurally, stylistically, and in terms of evidence handling. Runs after the chapter prose reviewer (Step 4.2b) has done its editorial pass, catching rule violations that editorial review may miss.

**Position:** Step 4.2c — between `chapter-prose-reviewer` (Step 4.2b) and chapter write/checkpoint (Step 4.2d).

## Inputs

All required unless noted. Content is passed directly (not file paths).

1. **Chapter draft** — the prose content produced at Step 4.2a
2. **Review findings** — the chapter-prose-reviewer output from Step 4.2b
3. **Report architecture** — from `/report/architecture.md`
4. **Style reference** — from `/report/style-reference.md`
5. **Scarcity register** — from `/execution/scarcity-register.md` (if it exists)
6. **Section directive** — the directive for this chapter from `/analysis/section-directives/`

**Missing input protocol:** If the section directive is not available, note that directive compliance was not checked and flag this as an issue — the directive should exist before report prose is produced. If the scarcity register doesn't exist, note that scarcity compliance was not applicable. All other inputs are required; if missing, halt and report which input is absent.

## Category 1: Structural Compliance

Checked against report architecture.

| Check | What to verify | Severity |
|-------|---------------|----------|
| **Scope match** | Chapter covers the scope assigned in `architecture.md` — no more, no less | BLOCKING |
| **Heading structure** | Chapter follows the heading hierarchy specified in the architecture | NON-BLOCKING |
| **Section boundaries** | No material that belongs in another chapter appears here | BLOCKING |
| **Cross-references** | Any cross-references to other chapters are accurate | NON-BLOCKING |

## Category 2: Evidence Handling Compliance

These are the anti-patterns that report prose must avoid. Defined here independently so compliance QC owns its own criteria.

| Check | What to verify | Severity |
|-------|---------------|----------|
| **No unsupported claims** | Every analytical claim traces to evidence in the synthesis briefs or cluster memos. Prose that introduces conclusions not present in the evidence base is a violation. | BLOCKING |
| **No dropped claim IDs** | If the chapter's source material contains claim IDs, the prose preserves traceability. Every substantive claim should be traceable. Claim IDs don't need to appear in prose, but gross omissions are flagged. | BLOCKING |
| **No editorializing beyond evidence** | Prose can interpret and frame evidence, but cannot introduce opinions, recommendations, or conclusions beyond what evidence supports. "Evidence says X, therefore Y" — acceptable. "Evidence says X, and we believe Z" — not acceptable unless Z is explicitly flagged as inference. | BLOCKING |
| **Scarcity register compliance** | If the scarcity register contains items relevant to this chapter, the prose MUST implement the specified editorial instruction (HEDGE / SCOPE CAVEAT / PROXY FRAMING). Missing implementation of a scarcity instruction is a violation. | BLOCKING |
| **Section directive compliance** | The prose delivers what the section directive specified. Missing elements are flagged — BLOCKING if the element is a core analytical point, NON-BLOCKING if supporting detail. | BLOCKING or NON-BLOCKING (per element) |

## Category 3: Style Compliance

Checked against the style reference.

| Check | What to verify | Severity |
|-------|---------------|----------|
| **Tone and register** | Chapter matches the style reference's specified voice and register | NON-BLOCKING |
| **Formatting conventions** | Chapter follows heading levels, paragraph length patterns, and emphasis usage from the style reference | NON-BLOCKING |
| **Terminology consistency** | Terms used consistently with the style reference and any project glossary | NON-BLOCKING |

## Category 4: Prose Quality Anti-Patterns

Intrinsic quality standards — no reference document needed.

| Check | What to verify | Severity |
|-------|---------------|----------|
| **No hedge stacking** | Multiple hedging qualifiers on the same claim ("it may potentially be somewhat likely"). One hedge per claim is sufficient. | NON-BLOCKING |
| **No circular reasoning** | A claim that restates its own premise as evidence ("X is important because of the significance of X"). | BLOCKING |
| **No false precision** | Specific numbers or percentages without sourcing, or precision exceeding what evidence supports. BLOCKING if precision implies a factual basis that doesn't exist; NON-BLOCKING if it's a phrasing issue. | BLOCKING or NON-BLOCKING |
| **No list-as-analysis** | A section that is primarily a bullet list where analytical narrative is expected. Lists are acceptable for genuinely enumerable items. | NON-BLOCKING |
| **No orphaned context** | A paragraph introduces a concept or framework and never connects it to the chapter's argument. | NON-BLOCKING |

## Verdict Assignment

Binary verdict per the project QC standard:

- **PASS** — No BLOCKING findings. NON-BLOCKING findings may exist and are noted.
- **FAIL** — One or more BLOCKING findings. Must be addressed before proceeding.

## Output Format

```
## Compliance QC: [Chapter Title]

### Verdict: [PASS / FAIL]

### Findings

[For each finding:]
- **Category:** [Structural / Evidence Handling / Style / Prose Quality]
- **Check:** [which specific check from the tables above]
- **Location:** [which section, heading, paragraph, or passage]
- **Severity:** [BLOCKING / NON-BLOCKING]
- **Description:** [what the problem is, specifically]
- **Proposed fix:** [direction for the fix — not a rewrite, consistent with the bright-line rule]

### Notes
- [If scarcity register doesn't exist or has no items for this chapter: "Scarcity compliance: not applicable — no scarcity items in scope."]
- [If section directive was not available: "Directive compliance: not checked — directive not provided. This is an issue; the directive should exist before report prose is produced."]
```

## Relationship to the Bright-Line Rule

Compliance QC identifies problems. It does NOT apply fixes. Any fixes resulting from compliance QC findings are subject to the bright-line rule:
1. Does the fix change more than one paragraph? -> PAUSE for operator approval.
2. Does the fix change, remove, or reframe an analytical claim? -> PAUSE for operator approval.
3. Does the fix alter a statement attributed to a source or carrying a claim ID? -> PAUSE for operator approval.

The proposed fix in each finding should be a direction ("qualify this claim with the HEDGE instruction from the scarcity register"), not a rewritten passage.
