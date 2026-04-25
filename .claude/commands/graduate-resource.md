---
model: sonnet
---

Graduate a project-level resource to the shared library: $ARGUMENTS

Use this command when you've built something useful in a project (a command, agent, hook, rule, or pattern) and want it available to all future projects.

## Input

The argument should be one of:
- A file path to the resource (e.g., `.claude/commands/optimize-repo.md`)
- A resource name (e.g., `optimize-repo`) — Claude will search `.claude/commands/`, `.claude/agents/`, `.claude/hooks/` for a match
- `inbox` — process the next unprocessed brief from `ai-resources/inbox/`

If no argument is provided, check `logs/innovation-registry.md` for entries with status `triaged:graduate` and offer those as candidates.

## Step 1: Locate and Read the Source

1. Find the source file. If the argument is a name, search in order: `.claude/commands/{name}.md`, `.claude/agents/{name}.md`, `.claude/hooks/{name}.sh`, `.claude/hooks/{name}.md`.
2. Read the source file completely.
3. Determine the resource type: `command`, `agent`, or `hook` (from the directory it lives in).
4. If reading from an inbox brief instead, read the brief and then read the source file it points to.

## Step 2: Check for Conflicts

Search `ai-resources/` for existing resources with similar names or purposes:
1. Check `.claude/commands/`, `.claude/agents/`, `.claude/hooks/` for name matches
2. Check `workflows/*/` for the same
3. If a match exists, present it: "A resource with this name already exists at {path}. Options: (a) update the existing one, (b) rename this one, (c) abort."

**Stop and wait for confirmation if there's a conflict.**

## Step 3: Classify Placement

Present to the operator:

1. **What it does** — 2-3 sentence summary from reading the file
2. **Dependencies** — what other files, skills, agents, or project-specific content it references
3. **Hardcoded references** — any project-specific paths, names, or content that need generalizing
4. **Recommended placement:**
   - **Shared** (`ai-resources/.claude/{commands|agents|hooks}/`) — if useful in any Claude Code project regardless of template
   - **Workflow template** (`ai-resources/workflows/research-workflow/.claude/{commands|agents|hooks}/`) — if useful only in projects deployed from a specific template
5. **Changes needed** — specific list of what needs to be generalized (e.g., "replace `buy-side-service-plan` with generic path", "remove reference to `parts/working-hypotheses/`")

**Stop and wait for the operator to confirm placement and approve the changes list.**

## Step 4: Generalize

Apply the approved changes:

1. Replace hardcoded project paths with `$CLAUDE_PROJECT_DIR` or relative references
2. Replace project-specific content references with generic equivalents or parameterized placeholders
3. Remove operator-name references (e.g., "Patrik") — use "the operator" instead
4. For commands: ensure the command works without project-specific files (or document required files in a comment at the top)
5. For hooks: ensure `$CLAUDE_PROJECT_DIR` is used consistently for path resolution
6. For agents: remove project-specific analytical lenses unless they're the core purpose

Write the generalized version to the target location determined in Step 3.

## Step 5: Quick Verification

Read the generalized file back and check:

1. **No project-specific references remain** — no hardcoded project names, paths, or domain content
2. **Dependencies resolve** — any referenced files, skills, or agents exist in ai-resources or are documented as requirements
3. **Self-contained** — a fresh Claude encountering this resource in a new project would understand it without context from the source project
4. **Functional** — for hooks, verify the script is executable and the logic is sound

If issues found, fix them. If unfixable without operator input, flag and stop.

## Step 6: Register in Settings (Hooks Only)

If the resource is a hook that should fire for all projects:

1. Check if it's already registered in `~/.claude/settings.json` (user-level)
2. If not, present the hook registration entry and ask the operator to confirm before adding it
3. If it should only fire for template projects, note that the workflow template's `settings.json` needs updating

Skip this step for commands and agents — they're discovered automatically via `--add-dir`.

## Step 7: Update Tracking

1. If the source project has an `logs/innovation-registry.md`, update the entry: status → `graduated`, Graduated To → the target path
2. If an inbox brief exists for this resource, delete it (it's been processed)
3. Commit the new resource in ai-resources:
   - Stage the new file(s)
   - Commit message: `new: {resource-type} {name} — {one-line purpose}` (e.g., `new: command optimize-repo — repository health optimization`)
   - Do not push — wait for the operator

## Key Rules

- Never graduate without operator confirmation on placement and changes
- Never modify the source project's copy — graduation creates a new file in ai-resources
- If the resource references skills, check they exist in `ai-resources/skills/` before graduating
- Keep the generalized version as close to the original as possible — don't "improve" it during graduation
