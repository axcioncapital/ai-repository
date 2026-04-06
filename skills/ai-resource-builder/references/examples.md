# Worked Examples

Condensed examples showing the expected flow and output for each mode.

## Create Mode Example

**Input:** Resource brief requesting a skill that formats research findings into structured evidence packs.

**Step 1 output (understanding):**
> The skill formats raw research findings into structured evidence packs with source citations, confidence ratings, and cross-references. Triggers when user has research output and needs it packaged for analysis. Exclusions: does not conduct research, does not evaluate evidence quality. Proposed structure: SKILL.md only, no bundled resources (pure instruction skill).

**Step 4 output (SKILL.md frontmatter):**
```yaml
---
name: evidence-pack-formatter
description: >
  Formats raw research findings into structured evidence packs with source
  citations, confidence ratings, and cross-references. Use when: research
  output needs packaging for downstream analysis or report writing.
  Do NOT use for: conducting research, evaluating evidence quality, or
  writing final reports (use evidence-to-report-writer instead).
---
```

**Step 5 output (validation):** Ran Evaluate Workflow. One Major issue found (Failure Behavior: no guidance for conflicting sources). Fixed by adding: "When sources conflict, present both with confidence ratings rather than choosing one."

## Evaluate Mode Example

**Input:** A prompt reading "You are a helpful assistant. Answer the user's questions about our product catalog."

**Output:** See the worked example in `references/evaluation-framework.md` — it evaluates this exact prompt against all 8 layers, finding 2 Critical and 1 Major issue.

## Improve Mode Example

**Input:** Existing skill `cluster-analysis-pass` with feedback: "It doesn't handle single-source clusters well — just skips them."

**Step 1 output (understanding):**
> Patrik is reporting that the skill silently skips clusters containing only one source, rather than flagging them or handling them explicitly. This is a Failure Behavior gap — the skill doesn't define what to do in this edge case.

**Step 2 triage:** Clarity: clear. Logic: valid — single-source clusters are common in small datasets. Compatibility: no conflict. Complexity: single change to one section.

**Step 3 output (change proposal):**
```
**Change 1:** Handle single-source clusters
- Location: ## Cluster Processing, after step 3
- Current: "For each cluster, cross-reference sources and identify agreement/disagreement patterns."
- Proposed: "For each cluster, cross-reference sources. Single-source clusters: flag as 'unverified — single source' and include in output with the flag rather than skipping."
- Rationale: Edge case causing silent data loss
- Unchanged: Multi-source cluster processing logic
```
