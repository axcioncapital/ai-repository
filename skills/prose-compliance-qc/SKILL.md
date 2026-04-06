---
name: prose-compliance-qc
description: >
  Final compliance gate for prose documents. Use when prose has completed the
  refinement pass and needs compliance verification before H3 titles, or on
  requests like "run compliance QC," "check this prose against specs." Runs
  four scans: skill anti-patterns, style spec, architecture/source fidelity,
  cross-spec tensions. Produces verdict with priority fixes.
  Do NOT use for: Part 1 report compliance (report-compliance-qc), editorial
  quality review (chapter-prose-reviewer), or cross-module integration
  (document-integration-qc).
---

# Prose Compliance QC

Compare prose output against three reference specs and surface gaps, violations, or cross-spec tensions. This is a final compliance gate, not a diagnostic review. Assume the prose has already been through chapter-prose-reviewer and any resulting fixes have been applied.

**Position:** Phase 4 of `/produce-prose`, after the refinement pass (Phase 3) and before H3 title generation (Phase 5).

## Inputs

All required unless noted. Content is passed directly (not file paths).

### 1. Prose Draft (required)

The prose document to evaluate. This is the post-refinement version, meaning any fixes from the chapter-prose-reviewer pass have already been applied.

### 2. Chapter-Prose-Reviewer Skill (required)

The full content of `chapter-prose-reviewer/SKILL.md`. Used as an anti-pattern checklist for Scan 1, not as an execution engine. The QC does not run the reviewer; it uses the reviewer's named checks (ss1-ss5) as a reference list for its own pass/fail sweep.

### 3. Style Spec (required, blocking)

The style specification governing tone, voice, audience, formatting conventions, and prohibited patterns. If missing, halt and request before evaluating.

### 4. Document Architecture Section Spec (optional)

The relevant section(s) from a document architecture. When provided, enables Full mode for Scan 3.

Must include (when available):
- Section thesis (one sentence)
- Target word count
- Must-land content
- What comes before and after this section
- Cross-reference requirements

**If not provided:** Scan 3 runs in Degraded mode. Input 5 (Source Decision Document) becomes required.

### 5. Source Decision Document (required when Input 4 is absent)

The approved decision document that was transformed into the prose draft. Enables Part 2-specific fidelity checks in Scan 3 Degraded mode.

**If both Input 4 and Input 5 are absent:** Halt. At least one of these must be provided for Scan 3 to run.

## Instructions

Run four scans in order, then produce the consolidated output.

Progress: [ ] Scan 1: Anti-patterns [ ] Scan 2: Style spec [ ] Scan 3: Architecture/fidelity [ ] Scan 4: Cross-spec tensions [ ] Output

---

## Scan 1: Skill Anti-Pattern Compliance

Sweep the prose against every named check in ss1-ss5 of the chapter-prose-reviewer skill (Input 2). For each check, assign one of:

- **CLEAR** — no instances found
- **VIOLATION** — quote the passage, name the check, state the problem in one sentence

Do not produce a full flag report. This is a pass/fail sweep. Only quote prose for violations.

Group results by evaluation section. List CLEAR checks as a single line per section:

```
ss1: [list of clear checks] — CLEAR
ss2: Evidence-summary pattern, Missing frame — CLEAR; Claim parade — VIOLATION [details]
```

Expand only violations.

### ss1 checks to sweep (Architecture)
- Thesis delivery
- Must-land content
- Word count (only if architecture spec provided)
- Cross-references

### ss2 checks to sweep (Structure and Argument)
- Evidence-summary pattern
- Missing frame
- Claim parade
- Missing "so what" (structural)
- Transition gaps
- Emphasis mismatch
- Catalogue structure
- Flat conclusion

### ss3 checks to sweep (Style Spec Compliance)
- Tone and voice
- Audience calibration
- Formatting conventions
- Prohibited patterns

### ss4 checks to sweep (Prose Quality)
- Source-first sentences
- Attribution stacking
- Claim-source-claim-source rhythm
- Parenthetical data dumps
- Empty sophistication
- Rhetorical filler
- Concept stacking
- Undefined terms

### ss5 checks to sweep (Completeness and Fidelity)
- Unsupported claims
- Hedging calibration
- Defensive comprehensiveness
- Uninterpreted evidence

---

## Scan 2: Style Spec Compliance

Check every constraint stated in the style spec (Input 3). This is a mechanical check: if the spec says it, the prose must comply.

For each constraint:
- **COMPLIANT** — no violations found
- **VIOLATION** — quote the passage, state the specific constraint it breaks

Work through the spec systematically. Do not skip constraints because they seem minor.

Group COMPLIANT items together; expand only violations.

Pay particular attention to:
- **Prohibited patterns** — the spec may ban specific constructions, punctuation, or rhetorical moves (e.g., em dashes, announcement sentences, rhetorical questions)
- **Audience calibration** — terms undefined for the stated audience, or over-explanation for expert audiences
- **Voice register** — shifts in formality, hedging level, or assertiveness that break the stated voice
- **Sentence function test** — if the spec defines what every sentence must do (e.g., "state a design choice, explain reasoning, acknowledge uncertainty, or describe fund experience"), check for sentences that fail this test

---

## Scan 3: Architecture or Source Fidelity Compliance

This scan operates in two modes depending on whether Input 4 (architecture spec) is provided.

### Full Mode (Input 4 provided)

Check the prose against the document architecture section spec on four dimensions:

**Thesis delivery:** Is the section thesis from the architecture evident to the reader? Not buried, not implied. A reader should encounter it without needing to know what the section is trying to say.

**Must-land content:** Does the must-land finding receive the most prominent treatment? Could a reader skim the section and still encounter it? If it is buried mid-paragraph or subordinated to a less important point, flag it.

**Word count:** Is the prose within plus or minus 15% of the architecture target? If over, identify what could be compressed. If under, identify where depth is missing.

**Cross-references:** Are required cross-references to adjacent modules present, correctly pointed, and functional (the referenced content actually exists)?

### Degraded Mode (Input 4 absent, Input 5 provided)

Run Part 2-specific fidelity checks using the source decision document:

**Source fidelity:** Every design choice documented in the source's Decisions section (or argued in the body) appears in the prose output. Compare systematically: extract each decision from the source, verify it is present in the prose. Flag any dropped decisions.

**Scaffolding elimination:** No process artifacts remain in the prose:
- No metadata headers (Status, Session date, Dependencies, Feeds into, Co-dependent with, Draft version)
- No cross-reference codes (WH[N], OQ-[X]-[Y], DP[N], section numbers used as references like "2.4" or "1.4")
- No numbered decision summary lists
- No dependency tables
- No standalone Open Questions sections
- No dependency flag labels

**Uncertainty preservation:** Evidence calibration notes and acknowledged uncertainties from the source document survive in the prose. Check:
- Statements marked as "directional," "untested hypothesis," or "moderate confidence" in the source retain appropriate qualification in the prose
- Conditional gates and quality thresholds are preserved (these are substantive design decisions, not scaffolding)
- Open questions that represent genuine strategic uncertainties are integrated where relevant (not dropped)

**Internal cross-references:** Do references within the prose point to real content? A sentence that says "as established in the commercial model design" should correspond to content that actually appears in the referenced prose document.

---

## Scan 4: Cross-Spec Tensions

Review all violations found in Scans 1 through 3. Flag any case where fixing one violation would create or worsen another.

Common tension patterns:
- Cutting prose for word count compliance removes content needed for source fidelity or must-land prominence
- Adding contextual explanation for audience calibration pushes the section over word count or introduces scaffolding-like structure
- Simplifying language for audience accessibility weakens the analytical register required by the voice spec
- Removing a flagged anti-pattern (e.g., a catalogue structure) would leave a gap in the argument that the source document requires
- Restoring a dropped design choice (source fidelity) requires reintroducing process language the scaffolding elimination check flags

For each tension, state the competing requirements and suggest a resolution path. If no clean resolution exists, flag it as an escalation item for the operator.

If no cross-spec tensions are found, state "No cross-spec tensions identified."

---

## Output Format

### Per-Spec Verdicts

| Spec | Verdict | Violation Count |
|------|---------|-----------------|
| Skill anti-patterns | COMPLIANT / ISSUES FOUND | [n] |
| Style spec | COMPLIANT / ISSUES FOUND | [n] |
| Architecture / Source fidelity | COMPLIANT / ISSUES FOUND | [n] |

### Mode Note

State which mode Scan 3 ran in (Full or Degraded) and which inputs were provided.

### Findings

List all violations from all three scans in a single consolidated list, ordered by severity (HIGH, MEDIUM, LOW).

Each finding:

```
**[#] — [Short label]**
Source scan: Skill / Style / Architecture (or Source Fidelity)
Quoted passage: "[exact quote]"
Violation: [one sentence — what spec requirement it breaks]
Severity: HIGH / MEDIUM / LOW
```

**Severity definitions:**
- **HIGH** — the prose fails a stated requirement from one of the three specs
- **MEDIUM** — the prose weakens compliance without outright failing
- **LOW** — minor, borderline, or debatable

### Cross-Spec Tensions

List tensions, or "No cross-spec tensions identified."

Each tension:
```
**Tension [#]: [Short label]**
Competing requirements: [Spec A requires X] vs. [Spec B requires Y]
Resolution path: [suggested approach]
Escalation: [Yes/No — Yes if no clean resolution]
```

### Priority Fixes

Top 5 changes that would most improve compliance, in priority order. For each, reference the finding number(s) it addresses and note if a cross-spec tension affects the fix.

### Example Output (abbreviated)

```
### Per-Spec Verdicts

| Spec | Verdict | Violation Count |
|------|---------|-----------------|
| Skill anti-patterns | ISSUES FOUND | 2 |
| Style spec | COMPLIANT | 0 |
| Architecture / Source fidelity | ISSUES FOUND | 1 |

### Mode Note
Scan 3 ran in Degraded mode (source decision document provided, no architecture spec).

### Findings

**1 — Catalogue structure in service boundaries**
Source scan: Skill (ss2)
Quoted passage: "The service does not include: (a) deal origination, (b) LP fundraising, (c) portfolio company operations, (d) regulatory compliance, (e) tax advisory..."
Violation: Five-plus item enumeration without analytical framing (catalogue structure check)
Severity: MEDIUM

**2 — Rhetorical filler in introduction**
Source scan: Skill (ss4)
Quoted passage: "It is worth noting that the pricing model plays a critical role..."
Violation: Empty sophistication — "it is worth noting" adds no information
Severity: LOW

**3 — Dropped design choice from source**
Source scan: Source Fidelity
Quoted passage: [absent — Decision 4 from source not represented]
Violation: Source decision document contains Decision 4 (minimum commitment period) which does not appear in the prose
Severity: HIGH

### Cross-Spec Tensions
No cross-spec tensions identified.

### Priority Fixes
1. Restore Decision 4 (minimum commitment period) from source document [Finding 3]
2. Add analytical framing around the service boundaries list [Finding 1]
3. Remove "it is worth noting" construction [Finding 2]
```

---

## Relationship to the Bright-Line Rule

This skill identifies problems. It does NOT apply fixes. Any fixes resulting from findings are subject to the bright-line rule:

1. Does the fix change more than one paragraph? Pause for operator approval.
2. Does the fix change, remove, or reframe an analytical claim? Pause for operator approval.
3. Does the fix alter a statement attributed to a source or carrying a claim ID? Pause for operator approval.

The proposed fix direction in each finding and in the Priority Fixes list should be a direction ("qualify this claim," "restore the missing design choice from the source"), not a rewritten passage.

---

## Failure Behavior

- **Missing style spec (Input 3):** Halt. Do not evaluate — style compliance is a primary dimension and cannot be skipped.
- **Both architecture spec and source document absent (Inputs 4 and 5):** Halt. Scan 3 requires at least one of these to run.
- **Chapter-prose-reviewer skill not provided (Input 2):** Halt. Scan 1 depends on the reviewer's named checks as its reference list.
- **Prose draft appears to be pre-refinement (raw output, not yet through chapter-prose-reviewer):** Flag this to the operator. Proceed if instructed, but note in the output that findings may include issues the refinement pass would have caught.
- **Cross-reference target not available for verification:** Flag the specific reference as unverifiable. Do not guess whether the target content exists — state what is missing and mark the finding as conditional.

## Runtime Recommendations

- **Model:** No specific requirement — works with any Claude model.
- **Context:** Requires all inputs in context simultaneously. For long prose documents, the full draft plus all reference specs must fit in the context window.
- **Sequence:** Runs after decision-to-prose-writer (or evidence-to-report-writer) and chapter-prose-reviewer refinement. Runs before prose-formatter and h3-title-pass.

## Calibration Notes

- If the provided information is insufficient to evaluate a specific constraint confidently (e.g., a cross-reference to a document that is not provided), say so rather than guessing. Flag what is missing and which findings are affected.
- For Part 2 prose in Degraded mode, the source fidelity check is the primary compliance dimension. A prose document that passes style and anti-pattern checks but drops design choices from the source is not compliant.
- If the prose scores zero violations across all three scans, state "No findings" under each scan. Do not manufacture feedback for excellent work.
