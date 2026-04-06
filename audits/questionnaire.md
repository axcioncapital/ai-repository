# Repo Due Diligence Questionnaire (v2.0)

## Instructions for Claude Code

This is a standardized audit questionnaire. Run it against the current repo and produce a factual report. Do not suggest fixes, improvements, or next steps — just report what you find.

### Rules

- Be specific: file names, line counts, exact paths, exact counts
- Say "None found — checked [describe what was compared or searched]" when a check turns up clean — don't skip the question, and show your work so the audit proves its search depth
- Say "Unknown — cannot determine from repo contents" only if you genuinely can't answer
- If a question asks you to list things, list all of them — don't summarize or truncate
- If a previous audit exists in `audits/`, note any changes from the most recent one under each answer using the format: `DELTA: [what changed since last audit]`. If no previous audit exists, skip delta notes. If a question did not exist in the previous audit, note "NEW QUESTION — no delta available."

### Session Size

This questionnaire is designed to run in a single session. If you are approaching context limits, save a partial output as `audits/repo-due-diligence-YYYY-MM-DD-partial.md` and state which sections remain.

### Output

Save the completed audit as: `audits/repo-due-diligence-YYYY-MM-DD.md`

At the top of the output file, include:

```
# Repo Due Diligence Audit — [DATE]
Repo: [repo name]
Commit: [current HEAD short hash]
Previous audit: [date of most recent previous audit, or "None"]
```

---

## Section 1: Inventory

*Purpose: Establish what currently exists in the repo so nothing is invisible.*

1.1. List every slash command currently defined. For each, state: name, where it is defined, and what files/templates it references.

1.2. List every hook currently configured. Check `.claude/settings.json`, `.claude/settings.local.json`, and any other settings files. For each hook, state: trigger type, what it does, and what files it references.

1.3. List every template file in the repo. For each, state: file path, what slash command or process uses it (if any), and the date of the most recent git commit touching this file.

1.4. List every script (bash, python, or other) in the repo that is not a template or skill. For each, state: file path, what it does, and what calls it.

1.5. How many skills are currently in the repo? List any that do not have a SKILL.md file.

1.6. List any files or directories that exist in the repo but are not accounted for by the categories above (skills, templates, scripts, slash commands, hooks, CLAUDE.md, audits, standard git files). These are your "uncategorized" items.

1.7. List all symlinks in the repo and any directories connected via symlink. For each, state: the symlink path, its target path, and whether the target currently exists and is accessible.

## Section 2: CLAUDE.md Health

*Purpose: Verify that the project's persistent context is accurate, non-contradictory, and free of dead references.*

2.1. How many lines is CLAUDE.md? How many distinct sections does it have? List the section headings.

2.2. List any references in CLAUDE.md to files, paths, commands, or features that do not exist in the repo. For each, check git history and note whether the item was renamed, moved, or deleted.

2.3. List any sections in CLAUDE.md that appear to contradict each other. Quote the conflicting statements.

2.4. List any conventions or patterns defined in CLAUDE.md that are not followed by actual files in the repo. State the convention and which files violate it.

2.5. List any features described in CLAUDE.md where at least one referenced file exists but at least one other referenced file does not (e.g., a command is defined but its template is missing, a hook is described but the script it calls doesn't exist). State what exists and what's missing.

## Section 3: Dependency References

*Purpose: Map which files reference which, so you can see where a single break would cascade.*

3.1. For each slash command, list every file it references (templates, scripts, other files). For each referenced file, confirm whether it exists.

3.2. List any slash commands whose output becomes input to another slash command or process. Map those chains.

3.3. List any files in the repo that are referenced by more than one slash command, hook, or script. State what references them.

3.4. List all files ranked by number of downstream references (count of slash commands, hooks, scripts, and other files that reference them). Show the top 10.

## Section 4: Consistency Checks

*Purpose: Detect pattern drift between what the repo says should happen and what actually exists.*

4.1. Do all skills in the repo follow the same structural pattern? Identify any that deviate and describe how.

4.2. Do all slash commands follow the same definition pattern? Identify any that deviate and describe how.

4.3. Compare each skill template to the 5 most recently modified skills. List any structural differences between what the template would produce and what actually exists. Also list any skills whose creation date predates the most recent template modification and note whether they conform to the current template.

4.4. List any naming convention inconsistencies across skills, templates, or commands.

4.5. If the repo defines a standard directory structure or file organization pattern, list any violations of that pattern.

4.6. For each slash command, verify that its definition follows the expected syntax and that all referenced file paths resolve. List any that fail either check.

4.7. List any slash command names that are duplicated or that match built-in Claude Code commands.

## Section 5: Context Load

*Purpose: Understand how much context each session starts with and whether any of it is dead weight.*

5.1. Estimate the total context loaded when a new session starts in this repo (CLAUDE.md + any auto-loaded files). Report in approximate line count.

5.2. List any CLAUDE.md sections that are not referenced by any slash command, hook, or operational instruction elsewhere in CLAUDE.md. State the section heading and approximate line count.

5.3. From git history, report the line count of CLAUDE.md at each of the last 5 commits that modified it, with dates.

## Section 6: Drift & Staleness

*Purpose: Find things that technically work but may have quietly fallen out of date or been left incomplete.*

6.1. List any files that have not been modified in the last 90 days (by git commit date) but are still referenced by active commands, hooks, or CLAUDE.md. State the file, its last commit date, and what references it.

6.2. List any TODO, FIXME, PLACEHOLDER, or similar marker comments in any file. State file path and line number.

6.3. List any empty files, stub files, or files that contain only boilerplate with no real content.

---

## Output Format

Structure the output as a single markdown document with each section as a heading and each answer numbered to match the questions above.

Use tables where listing multiple items. For consistency across audit runs, use these standard column sets:

- **File listings:** Path | Purpose | Referenced By | Last Commit Date
- **Reference maps:** Slash Command | Referenced File | File Exists (Y/N)
- **Drift/issue items:** Item | Expected State | Actual State

For each section, end with a summary line using the appropriate template:

- Inventory section (1): `Section summary: [X items catalogued / Z deltas from previous audit]`
- Health and consistency sections (2, 3, 4, 5, 6): `Section summary: [X issues flagged / Z deltas from previous audit]`

Do not add commentary, recommendations, or suggested next steps anywhere in the document.
