# Agent Tier Table

> **When to read this file:** When adding a new agent to `ai-resources/.claude/agents/`, retrofitting an existing agent's tier, or reviewing tier assignments. Not needed for every turn.

Every agent must declare `model:` explicitly in frontmatter — no implicit inherit. Tier by work type:

- **Haiku** — mechanical measurement, file census, format checks, line counts, permission-block inspection, simple pattern matching.
- **Sonnet** — structured factual work: questionnaire-driven audits, fact extraction, inventory walks, spec-following implementation, workflow-analysis.
- **Opus** — judgment work: QC, refinement, synthesis, triage, critique, architectural design, strategic evaluation.

## Agent tier assignments (ai-resources/.claude/agents/)

| Agent | Current tier | Notes |
|---|---|---|
| collaboration-coach | opus | Judgment (cross-session pattern analysis). Correct. |
| dd-extract-agent | haiku | Mechanical extraction for repo-dd. Correct. |
| dd-log-sweep-agent | haiku | Mechanical log scan for repo-dd. Correct. |
| execution-agent | sonnet | API-call dispatcher. Correct. |
| improvement-analyst | opus | Judgment (friction-pattern analysis). Correct. |
| pipeline-stage-3a | sonnet | Structured inventory scan. Correct. |
| pipeline-stage-3b | opus | Architectural design. Correct. |
| pipeline-stage-3c | opus | Analytical (implementation spec). Retrofitted from inherit. |
| pipeline-stage-4 | sonnet | Spec-following implementation. Retrofitted from inherit. |
| pipeline-stage-5 | sonnet | Verification checks. Correct. |
| qc-reviewer | opus | QC judgment. Correct. |
| refinement-reviewer | opus | Refinement judgment. Correct. |
| repo-dd-auditor | sonnet | Questionnaire-driven factual audit. Correct. |
| session-guide-generator | sonnet | Structured generation. Retrofitted from inherit. |
| token-audit-auditor | opus | Judgment sections (4). Correct. |
| token-audit-auditor-mechanical | haiku | Mechanical sections (2, 5, 6). Correct. |
| triage-reviewer | opus | Prioritization judgment. Correct. |
| workflow-analysis-agent | opus | Architectural analysis. Correct. |
| workflow-critique-agent | opus | Critique judgment. Correct. |

## Maintenance

When adding a new agent, place it in the table. When changing an agent's tier, update the table in the same commit.
