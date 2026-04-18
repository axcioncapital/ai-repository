Run a full workspace health audit on this project.

Input: $ARGUMENTS (optional) — not currently used, reserved for future scope options.

---

### Step 1: Resolve Auditor Paths

1. Set TARGET to the current working directory.
2. Set SKILL_DIR by checking which of these paths exists (in order): `reference/skills/repo-health-analyzer/agents/` (deployed-project layout), then `skills/repo-health-analyzer/agents/` (ai-resources layout). Use the first path that resolves.
3. Verify the following 8 agent files exist under SKILL_DIR:
   - `repo-health-analyzer.md` (lead agent)
   - `file-org-auditor.md`
   - `claude-md-auditor.md`
   - `skill-auditor.md`
   - `command-auditor.md`
   - `settings-auditor.md`
   - `practices-auditor.md`
   - `context-health-auditor.md`

If any are missing, report which files are missing and stop.

---

### Step 2: Read Lead Agent Instructions

4. Read the lead agent definition from `{SKILL_DIR}/repo-health-analyzer.md`.

---

### Step 3: Launch Lead Agent

5. Spawn the repo-health-analyzer as an Agent subagent, passing:
   - The lead agent instructions (from the file body, below frontmatter)
   - Target directory path: `{TARGET}`
   - Audit scope: `FULL`
   - Auditor agent file paths: the 7 auditor file paths under `{SKILL_DIR}/`
6. Wait for the agent to complete.

---

### Step 4: Confirm Output

7. Verify the report was written to `{TARGET}/reports/repo-health-report.md`.
8. Read the Executive Summary and Scores table from the report.
9. Display the Executive Summary and Scores table to the operator.
10. If the overall score is RED, flag that critical findings need attention.