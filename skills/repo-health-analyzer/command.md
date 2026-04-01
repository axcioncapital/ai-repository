Usage: /audit-repo [full audit]

Run a workspace health check. Analyzes file organization, CLAUDE.md health, skill inventory, commands & subagents, settings & permissions, and 2026 best practices. Produces a scored report with findings and recommendations.

First run: full audit. Subsequent runs: delta mode (only changed files) unless "full audit" is specified.

Arguments from invocation: $ARGUMENTS

---

## Step 1: Determine workspace root

The workspace root is the directory containing `CLAUDE.md`, `.claude/`, `ai-resources/`, `projects/`, and `workflows/`. From the current directory, walk up until you find this structure. If you're already at the root, use the current directory.

Set `ROOT` to the resolved workspace root path.

## Step 2: Determine audit scope

Check if `$ARGUMENTS` contains the phrase "full audit" (case-insensitive).

**If "full audit" is specified OR `{ROOT}/reports/last-audit-commit.txt` does not exist:**

Set scope to FULL. All 6 auditors will run.

**If `last-audit-commit.txt` exists and "full audit" is NOT specified:**

Run delta mode:

1. Read `{ROOT}/reports/last-audit-commit.txt`. It contains lines like:
   ```
   ai-resources: {hash}
   workflows: {hash}
   root: {hash}
   ```

2. For each repo that has a `.git` directory, run:
   ```bash
   cd {repo-path} && git diff --name-only {saved-hash}..HEAD 2>/dev/null
   ```
   Collect the union of all changed file paths (relative to workspace root).

3. If the root itself is a git repo, also check from root.

4. Map changed files to auditor areas:
   - Files under `ai-resources/skills/` → skill-auditor
   - Files under any `.claude/commands/` or `.claude/agents/` → command-auditor
   - Files matching `**/settings.json` or `**/settings.local.json` → settings-auditor
   - Any file movement, addition, or deletion → file-org-auditor
   - `**/CLAUDE.md` → claude-md-auditor (but this always runs anyway)

5. Build the auditor run list:
   - **Always run:** claude-md-auditor, practices-auditor
   - **Run if relevant files changed:** file-org-auditor, skill-auditor, command-auditor, settings-auditor
   - **Skip** auditors with no relevant changes

6. Display the scope decision:
   ```
   Audit mode: DELTA (changes since {short-hash})
   Changed files: {count}
   Auditors to run: {list}
   Auditors skipped: {list}
   ```

## Step 3: Prepare output directory

Create `{ROOT}/reports/` if it doesn't exist.
Create `{ROOT}/reports/.audit-temp/` if it doesn't exist.

## Step 4: Spawn lead agent

Read the lead agent definition at `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/repo-health-analyzer.md`.

Spawn the lead agent as a subagent, passing:

1. The lead agent instructions (the body of the agent file, below the frontmatter)
2. The workspace root path: `{ROOT}`
3. The audit scope: FULL or DELTA with:
   - Changed files list (if delta)
   - Which auditors to run vs. skip
4. The auditor agent file paths:
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/file-org-auditor.md`
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/claude-md-auditor.md`
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/skill-auditor.md`
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/command-auditor.md`
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/settings-auditor.md`
   - `{ROOT}/ai-resources/skills/repo-health-analyzer/agents/practices-auditor.md`

Wait for the lead agent to complete.

## Step 5: Verify and display results

1. Read `{ROOT}/reports/repo-health-report.md`
2. Display the Executive Summary and Scores table to the user
3. Tell the user: "Full report saved to `reports/repo-health-report.md`"

## Step 6: Update delta tracking

After successful report generation, update `{ROOT}/reports/last-audit-commit.txt`:

For each directory that contains a `.git` folder (check `ai-resources/`, `workflows/`, and workspace root):
```bash
cd {dir} && git rev-parse HEAD 2>/dev/null
```

Write the results:
```
ai-resources: {hash-or-"none"}
workflows: {hash-or-"none"}
root: {hash-or-"none"}
```

## Notes

- The report file `reports/repo-health-report.md` is the primary output. Previous reports are archived with a date suffix by the lead agent.
- The `reports/.audit-temp/` directory is transient and cleaned up by the lead agent after synthesis. If it still exists after the audit, something went wrong — check the temp files for partial findings.
- Delta mode is a performance optimization, not a correctness guarantee. When in doubt, run a full audit.
- This command does not commit any files. The operator decides what to commit.
