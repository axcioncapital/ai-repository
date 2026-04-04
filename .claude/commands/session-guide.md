# /session-guide — Session Guide Generator

Generate a step-by-step execution guide for running a configured project across multiple Claude Code sessions. The guide includes per-session objectives, commands, checkpoints, troubleshooting, and feedback tips.

## Artifact Discovery

Before generating, identify the project's key documents:

1. **Read CLAUDE.md** in the current working directory (if it exists). This often describes the project structure, references key files, and explains what's been built.

2. **Scan for project artifacts.** Look for markdown files that could serve as project specs, plans, or architecture docs. Check the CWD root and common locations like `docs/`, `projects/`, `specs/`. Look for files with names suggesting project documentation — specs, plans, briefs, architecture docs, readmes.

3. **Present what you found** and ask the user to confirm:
   - "I found these documents: {list with brief description of each}. Which one is the **main project spec or plan**? Any others I should read as reference?"
   - The user's answer identifies the primary input and any supporting docs.

4. **If nothing useful is found**, ask the user to either point to the relevant files or describe the project:
   - What does this project deliver?
   - What Claude Code components are involved? (skills, commands, agents)
   - What does success look like?
   - What's already configured?

## Scope Selection

Before generating, ask the user what they want a session guide for:

1. **Full project** — cover the entire execution arc from setup to final QC
2. **Specific phase or section** — e.g., "just the batch processing part" or "only the pilot and validation"

Present the project's natural phases (derived from the identified documents) and let the user choose. Example:

> "This project has these phases: Setup → Pilot → Batch Processing (×12) → Final QC. Want a guide for the full arc, or just a specific phase?"

## Existing Guide Detection

If `session-guide.md` already exists in the project directory, note this and let the agent handle versioning (overwrite vs. version).

## Execution

Spawn the `session-guide-generator` agent with:
- "Project directory: {project-path}/"
- The confirmed artifact paths: "Primary document: {path}. Reference docs: {paths}."
- The user's scope selection (full or specific phases)
- If no documents were found: the user's project description instead

## Output

The session guide will be saved to `{project-directory}/session-guide.md` (or versioned filename). Present it in chat for the user to review.
