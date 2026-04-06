---
name: repo-health-analyzer
description: >
  Use when the user runs /audit-repo or asks for a workspace health check, repo audit,
  or structural review of the Axcíon AI workspace.
  Analyzes file organization, CLAUDE.md health, skill inventory, commands & subagents,
  settings & permissions, and 2026 best practices.
  Produces a scored health report with prioritized recommendations.
  Do NOT use for individual skill evaluation (use ai-resource-builder instead)
  or workflow quality checks (use workflow-evaluator instead).
---

# Repo Health Analyzer

Workspace-level health check that audits the Axcíon AI repo structure, configuration, and conventions. Produces a scored report with findings at Critical/Important/Minor severity levels.

## Architecture

- **Slash command:** `/audit-repo` (see `command.md`)
- **Lead agent:** `agents/repo-health-analyzer.md` (Opus — orchestrates auditors, synthesizes report)
- **Wave 1 auditors** (Sonnet — mechanical analysis, run sequentially in Pass 1):
  - `file-org-auditor` — File organization & structure
  - `claude-md-auditor` — CLAUDE.md health
  - `skill-auditor` — Skill inventory & overlap detection
  - `command-auditor` — Commands & subagents
  - `settings-auditor` — Settings & permissions
- **Wave 2 auditor** (Opus — cross-section reasoning, runs after Wave 1):
  - `practices-auditor` — 2026 best practices check

## Execution

Run `/audit-repo` from the workspace root. First run produces a full audit. Subsequent runs use delta mode (only changed files) unless overridden with "full audit" in arguments.

Report is written to `reports/repo-health-report.md`.

## Findings Flow

Each auditor writes a JSON findings file to `reports/.audit-temp/`. The lead agent reads all findings and synthesizes the final markdown report. Temp files are deleted after synthesis.

## Failure Behavior

- **Not run from workspace root:** Flag to the operator — auditors expect the Axcíon workspace structure. Do not attempt to audit an arbitrary directory.
- **Auditor fails or returns empty findings:** Log the failure in the report under the relevant section. Continue with remaining auditors — do not halt the full audit for one failed section.
- **No CLAUDE.md files found:** The claude-md-auditor reports this as a Critical finding. Other auditors continue independently.
- **Skill directory missing or empty:** The skill-auditor reports this as a Critical finding. Other auditors continue.
- **Reports directory does not exist:** Create it before writing the report.

## Runtime Recommendations

- **Model:** Lead agent uses Opus (cross-section reasoning). Wave 1 auditors use Sonnet (mechanical analysis). Wave 2 uses Opus.
- **Context:** Each auditor runs as a subagent with its own context. The lead agent receives findings summaries, not raw file contents.
- **Invocation:** Via `/audit-repo` command. Can also be triggered by asking for "workspace health check" or "repo audit."
