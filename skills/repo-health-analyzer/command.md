Usage: /audit-repo [full audit]

Run a health check on the current directory. Analyzes file organization, CLAUDE.md health, skill inventory, commands & subagents, settings & permissions, and 2026 best practices. Produces a scored report with findings and recommendations.

The report is written to `reports/` inside the directory being analyzed.

First run: full audit. Subsequent runs: delta mode (only changed files) unless "full audit" is specified.

Arguments from invocation: $ARGUMENTS

---

## Step 1: Determine target and skill location

**Target directory (TARGET):** The directory being analyzed. Use the current working directory.

**Skill location (SKILL_ROOT):** The repo-health-analyzer skill files. Walk up from TARGET looking for `ai-resources/skills/repo-health-analyzer/`. If not found locally, check the Axcíon workspace root (the directory containing `ai-resources/`, `projects/`, `workflows/`). Set `SKILL_ROOT` to the resolved `ai-resources/skills/repo-health-analyzer/` path.

Display:
```
Target: {TARGET}
Skill source: {SKILL_ROOT}
```

## Step 2: Determine audit scope

Check if `$ARGUMENTS` contains the phrase "full audit" (case-insensitive).

**If "full audit" is specified OR `{TARGET}/reports/last-audit-commit.txt` does not exist:**

Set scope to FULL. All 6 auditors will run.

**If `last-audit-commit.txt` exists and "full audit" is NOT specified:**

Run delta mode:

1. Read `{TARGET}/reports/last-audit-commit.txt`. It contains lines like:
   ```
   {repo-name}: {hash}
   ```

2. Find all `.git` directories at or below TARGET (check TARGET itself, and immediate subdirectories). For each git repo found, run:
   ```bash
   cd {repo-path} && git diff --name-only {saved-hash}..HEAD 2>/dev/null
   ```
   Collect the union of all changed file paths (relative to TARGET).

3. Map changed files to auditor areas:
   - Files under `*/skills/` or matching `*SKILL.md` → skill-auditor
   - Files under any `.claude/commands/` or `.claude/agents/` → command-auditor
   - Files matching `**/settings.json` or `**/settings.local.json` → settings-auditor
   - Any file movement, addition, or deletion → file-org-auditor
   - `**/CLAUDE.md` → claude-md-auditor (but this always runs anyway)

4. Build the auditor run list:
   - **Always run:** claude-md-auditor, practices-auditor
   - **Run if relevant files changed:** file-org-auditor, skill-auditor, command-auditor, settings-auditor
   - **Skip** auditors with no relevant changes

5. Display the scope decision:
   ```
   Audit mode: DELTA (changes since {short-hash})
   Changed files: {count}
   Auditors to run: {list}
   Auditors skipped: {list}
   ```

## Step 3: Prepare output directory

Create `{TARGET}/reports/` if it doesn't exist.
Create `{TARGET}/reports/.audit-temp/` if it doesn't exist.

## Step 4: Spawn lead agent

Read the lead agent definition at `{SKILL_ROOT}/agents/repo-health-analyzer.md`.

Spawn the lead agent as a subagent, passing:

1. The lead agent instructions (the body of the agent file, below the frontmatter)
2. The target directory path: `{TARGET}`
3. The audit scope: FULL or DELTA with:
   - Changed files list (if delta)
   - Which auditors to run vs. skip
4. The auditor agent file paths:
   - `{SKILL_ROOT}/agents/file-org-auditor.md`
   - `{SKILL_ROOT}/agents/claude-md-auditor.md`
   - `{SKILL_ROOT}/agents/skill-auditor.md`
   - `{SKILL_ROOT}/agents/command-auditor.md`
   - `{SKILL_ROOT}/agents/settings-auditor.md`
   - `{SKILL_ROOT}/agents/practices-auditor.md`

Wait for the lead agent to complete.

## Step 5: Verify and display results

1. Read `{TARGET}/reports/repo-health-report.md`
2. Display the Executive Summary and Scores table to the user
3. Tell the user: "Full report saved to `{TARGET}/reports/repo-health-report.md`"

## Step 6: Update delta tracking

After successful report generation, update `{TARGET}/reports/last-audit-commit.txt`:

Find all `.git` directories at or below TARGET. For each:
```bash
cd {dir} && git rev-parse HEAD 2>/dev/null
```

Write one line per repo found:
```
{repo-name}: {hash}
```

If TARGET itself is a git repo, use the directory name as the repo name.

## Notes

- The report is written to `{TARGET}/reports/`, keeping it with the thing being analyzed.
- Previous reports are archived with a date suffix by the lead agent.
- The `reports/.audit-temp/` directory is transient and cleaned up by the lead agent after synthesis. If it still exists after the audit, something went wrong — check the temp files for partial findings.
- Delta mode is a performance optimization, not a correctness guarantee. When in doubt, run a full audit.
- This command does not commit any files. The operator decides what to commit.
