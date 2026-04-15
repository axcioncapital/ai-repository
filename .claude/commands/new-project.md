# /new-project — Project Pipeline Orchestrator

You are the orchestrator for Axcíon's project pipeline. This pipeline takes a user-provided context pack and produces a fully configured Claude Code setup through a series of staged gates.

## Scope Validation

This pipeline is for **any Axcíon project that requires Claude Code** — whether that's building AI resources (skills, workflows, agents), setting up a research project, configuring a new workspace, or any other project where Claude Code is the execution environment. Before doing anything else, check whether the user's input describes work that will be built or run through Claude Code. If not, stop and explain that this pipeline is for Claude Code-based projects.

**CWD guard:** Check if the current working directory is the `ai-resources` repo itself (i.e., the CWD contains a `skills/` directory and a `CLAUDE.md` with "Axcion AI Resource Repository" at the root level). If so, stop and tell the user:

> "This command should be run from a project repo or the Axcíon AI workspace root, not from ai-resources directly. Open your target repo and run `/new-project` from there."

**Note:** Running from the Axcíon AI workspace root (the parent directory that contains `ai-resources/`, `projects/`, etc.) is valid — the guard only blocks running from inside `ai-resources/` itself.

## Pre-Flight Validation

Before starting the pipeline, verify all required agent files exist in `ai-resources/.claude/agents/`:
- `pipeline-stage-2.md`, `pipeline-stage-2-5.md`, `pipeline-stage-3a.md`, `pipeline-stage-3b.md`, `pipeline-stage-3c.md`, `pipeline-stage-4.md`, `pipeline-stage-5.md`, `session-guide-generator.md`

Check with: `ls ai-resources/.claude/agents/pipeline-stage-*.md ai-resources/.claude/agents/session-guide-generator.md 2>&1`

If ANY file is missing, list all missing files and stop. Do not start the pipeline.

## Context Pack Requirement

The user must provide a context pack before the pipeline can start. The context pack can be:
- A file path to an existing context pack (e.g., `context-pack.md`)
- Pasted directly into the conversation

**If no context pack is provided, stop and ask for one.** Do not proceed without it.

## First Run vs. Continuation

**Determine which mode you're in:**

1. Look for `projects/*/pipeline/pipeline-state.md` files first. If none found, fall back to `projects/*/pipeline-state.md` (legacy layout).
2. If no pipeline state files exist → **First Run**
3. If pipeline state files exist → **Continuation** (if multiple projects have pipeline state files, ask the user which project to resume). Note whether the state file is in `pipeline/` (new layout) or at root (legacy layout) — use the same layout for all subsequent artifact paths in that project.

### First Run

1. **Ask for the project name.** Use lowercase-with-hyphens format (e.g., `context-aware-skill-router`).

2. **Ask for the GitHub repository link.** The user should provide the URL of the project's GitHub repo (e.g., `https://github.com/axcion-ai/project-name`).

3. **Create the project directory** at `projects/{project-name}/` and the pipeline artifact subdirectory at `projects/{project-name}/pipeline/`.

4. **Copy the user's context pack** to `projects/{project-name}/pipeline/context-pack.md`.

5. **Create `projects/{project-name}/pipeline/decisions.md`** with this template:

```markdown
# Decisions — {project-name}

| # | Stage | Decision | Rationale | Decided By |
|---|-------|----------|-----------|------------|
```

6. **Create `projects/{project-name}/pipeline/pipeline-state.md`** to track pipeline progress:

```markdown
# Pipeline State — {project-name}

## Metadata
- **GitHub:** {github-url}

| Stage | Status | Artifact |
|-------|--------|----------|
| 2 — Project Plan | in_progress | — |
| 2.5 — Technical Spec | pending | — |
| 3a — Repo Snapshot | pending | — |
| 3b — Architecture Design | pending | — |
| 3c — Implementation Spec | pending | — |
| 4 — Implementation | pending | — |
| 5 — Testing | pending | — |
| 6 — Session Guide | pending | — |
```

7. **Tell the user** what was created and that Stage 2 is starting.

8. **Spawn the Stage 2 subagent** (`pipeline-stage-2`) with the context pack as input. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

### Continuation

1. Read the pipeline state file for the project.
2. Find the stage that is `in_progress`, or the first `pending` stage whose predecessor is `completed` (or `skipped`).
3. Announce: "Resuming pipeline at [stage name]. Last completed: [previous stage]."
4. Spawn the corresponding stage subagent. Include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"

**Agent name mapping:** Stages 2–5 use the `pipeline-stage-{N}` naming convention. Stage 6 (Session Guide) uses the `session-guide-generator` agent instead.

## Gate Protocol

After each stage subagent completes:

1. Update `pipeline-state.md`: set the current stage to `completed` and record the artifact path.
2. Wait for the user's command:
   - **`NEXT`** → Set the next stage to `in_progress` in `pipeline-state.md`. Spawn the next stage subagent.
   - **`SKIP`** → Valid after Stage 2 (skips Stage 2.5 — marks it `skipped` in `pipeline-state.md`, sets Stage 3a to `in_progress`) and after Stage 5 (skips Stage 6 — marks it `skipped`, announces pipeline complete). Not valid at other stages. Stage 2's complexity assessment informs whether skipping 2.5 is advisable.
   - **`ABORT`** → Mark all remaining `pending` stages as `cancelled` in `pipeline-state.md`. Announce abort. Do not delete project artifacts.

## Post-Stage 5 Behavior

After Stage 5 completes successfully, announce:

> "Pipeline core stages complete. Say NEXT to generate a Session Guide (Stage 6 — a step-by-step execution playbook for running this project), SKIP to finish the pipeline without one, or ABORT to cancel."

If the user says NEXT, spawn the `session-guide-generator` agent. If SKIP, mark Stage 6 as `skipped` and announce the pipeline is complete. After Stage 6 completes (or is skipped), announce: "Pipeline complete. All artifacts saved to projects/{project-name}/."

Then remind the operator:

> **Next steps:** Run `/repo-dd` and `/analyze-workflow` against the new project to establish a baseline audit and infrastructure inventory.

## Error Handling

If a stage subagent reports failure:
- Do NOT update the stage to `completed` in `pipeline-state.md`
- Report the failure to the user
- Offer options: retry the stage, abort the pipeline, or fix manually and resume

## Post-Pipeline Enrichment

After the pipeline completes (all stages done or final stage skipped), set the project up for **ongoing** sync with ai-resources. The mechanism is the SessionStart hook `ai-resources/.claude/hooks/auto-sync-shared.sh`, which symlinks every command/agent in `ai-resources/.claude/{commands,agents}/` into the project on session start, except files declared as project-local in the manifest and a small baked-in meta exclusion list. New commands added to ai-resources after this point flow into the project automatically — no re-enrichment needed.

### What to install

If a `.claude/shared-manifest.json` already exists in the project (created by a workflow template via `/deploy-workflow`), do nothing — the workflow template already wired everything up. Skip to the "Report" step.

Otherwise, install the three pieces:

1. **`projects/{name}/.claude/shared-manifest.json`** — declares project-owned files. Identify which commands and agents this project created locally during the pipeline (pipeline-specific commands, project-specific evaluator agents, etc.) and list them under `commands.local` / `agents.local`. Anything not listed will be auto-synced from ai-resources. Template:

   ```json
   {
     "_doc": "Lists project-owned files under .local. The auto-sync hook symlinks every other file from ai-resources/.claude/{commands,agents}/ on session start.",
     "commands": { "local": [ ... ] },
     "agents": { "local": [ ... ] }
   }
   ```

2. **`projects/{name}/.claude/settings.json`** — wire the SessionStart hook **and** ensure the project inherits a tool-permissions baseline so the operator does not get approval prompts on routine Edit/Write/Grep calls.

   **Requires `jq` on PATH.** If `jq` is not available, stop and report the missing dependency — do not attempt string-level JSON manipulation.

   **Canonical permissions block** (mirrors the `allow` / `deny` arrays from the operator's user-level `~/.claude/settings.json`). Note: `additionalDirectories` is **not** included in this canonical block because each project's entry is computed dynamically at enrichment time — see step 3 below, which adds the ai-resources workspace root via a separate jq merge so projects with existing `permissions.allow` arrays (which skip this canonical merge) still receive the grant.

   ```json
   {
     "allow": [
       "Bash(*)",
       "Read",
       "Edit",
       "Write",
       "MultiEdit",
       "Agent",
       "Skill",
       "TodoWrite",
       "Glob",
       "Grep",
       "WebFetch",
       "WebSearch",
       "NotebookEdit",
       "ToolSearch"
     ],
     "deny": [
       "Bash(git push*)",
       "Bash(rm -rf *)",
       "Bash(sudo *)"
     ]
   }
   ```

   **Auto-sync SessionStart hook entry** (added to `hooks.SessionStart`):

   ```json
   {
     "type": "command",
     "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\" ] && { \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\"; exit; }; done",
     "timeout": 10,
     "statusMessage": "Syncing shared commands from ai-resources..."
   }
   ```

   The hook is invoked **directly from ai-resources** — do not copy `auto-sync-shared.sh` into the project's hooks directory.

   **Predicate for "already has a permissions allowlist":** parsed JSON has `.permissions.allow` *and* that array is non-empty. If true, leave `permissions` alone (protects projects that intentionally have a narrower block). Otherwise, merge the canonical block in.

   **Merge procedure:**

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for permissions merge"; exit 1; }

   SETTINGS="projects/{name}/.claude/settings.json"
   mkdir -p "$(dirname "$SETTINGS")"
   [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

   CANONICAL_PERMS='{"allow":["Bash(*)","Read","Edit","Write","MultiEdit","Agent","Skill","TodoWrite","Glob","Grep","WebFetch","WebSearch","NotebookEdit","ToolSearch"],"deny":["Bash(git push*)","Bash(rm -rf *)","Bash(sudo *)"]}'

   AUTO_SYNC_HOOK='{"type":"command","command":"d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '"'"'/'"'"' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\" ] && { \"$d/ai-resources/.claude/hooks/auto-sync-shared.sh\"; exit; }; done","timeout":10,"statusMessage":"Syncing shared commands from ai-resources..."}'

   jq --argjson perms "$CANONICAL_PERMS" --argjson hook "$AUTO_SYNC_HOOK" '
     (if (.permissions.allow // []) | length > 0 then . else .permissions = $perms end)
     | .hooks = (.hooks // {})
     | .hooks.SessionStart = (.hooks.SessionStart // [])
     | if (.hooks.SessionStart | any(.hooks? // [.] | .[]? | .command == $hook.command))
       then .
       else .hooks.SessionStart += [{"hooks":[$hook]}]
       end
   ' "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
   ```

   Report in the step output:
   - whether `permissions` was added, already present, or skipped
   - whether the SessionStart hook was added or already present

3. **Grant ai-resources filesystem visibility** — Claude Code sandboxes each project to its own directory by default. Shared skills under `ai-resources/skills/` and symlinks into `ai-resources/.claude/{commands,agents}/` are unreachable until the workspace root is added to `permissions.additionalDirectories` in the project's `.claude/settings.json`. This step performs that grant.

   The walk to locate the workspace root mirrors the idiom in `ai-resources/.claude/hooks/auto-sync-shared.sh` (walk upward until an ancestor contains `ai-resources/`). Use an absolute path, not a relative one — Claude Code resolves `additionalDirectories` relative to session CWD, which varies by how the project is opened.

   **Load-bearing jq semantics:** for projects where step 2 skipped the permissions merge (because `.permissions.allow` was already non-empty) OR for projects where step 2 added the canonical block without `additionalDirectories`, jq's `=` operator on the leaf path `.permissions.additionalDirectories` synthesizes any missing parent objects automatically. This is the only reason a single idempotent jq call is sufficient here — if jq is ever replaced with another tool (Python, Node, yq), that tool must do the same parent-object auto-creation.

   ```bash
   command -v jq >/dev/null || { echo "ERROR: jq required for additionalDirectories merge"; exit 1; }

   SETTINGS="projects/{name}/.claude/settings.json"
   [ -f "$SETTINGS" ] || echo '{}' > "$SETTINGS"

   d="$(cd projects/{name} && pwd)"
   WORKSPACE=""
   while [ "$d" != "/" ]; do
     d=$(dirname "$d")
     [ -d "$d/ai-resources" ] && WORKSPACE="$d" && break
   done
   [ -n "$WORKSPACE" ] || { echo "WARN: ai-resources not found in any ancestor — skipping additionalDirectories grant"; }

   if [ -n "$WORKSPACE" ]; then
     jq --arg dir "$WORKSPACE" \
       '.permissions.additionalDirectories = ((.permissions.additionalDirectories // []) + [$dir] | unique)' \
       "$SETTINGS" > "$SETTINGS.tmp" && mv "$SETTINGS.tmp" "$SETTINGS"
   fi
   ```

   Report in the step output:
   - whether `additionalDirectories` was added, already present, or skipped (walk failed)
   - the absolute workspace path that was added

4. **`projects/{name}/CLAUDE.md`** — ensure the project CLAUDE.md contains the canonical `## Commit Rules` section. This guarantees that projects opened without the parent workspace CLAUDE.md loaded still see the "commit directly, do not ask for permission" rule.

   **Policy:**
   - If `projects/{name}/CLAUDE.md` does not exist → create a minimal one with a project title (use the project name), a one-line description pulled from the pipeline's context pack if available (otherwise a generic placeholder), and the canonical `## Commit Rules` block below.
   - If `projects/{name}/CLAUDE.md` exists and already contains a `## Commit Rules` heading → leave it alone. Report "Commit Rules already present, skipping."
   - If `projects/{name}/CLAUDE.md` exists but has no `## Commit Rules` heading → append the canonical block to the end of the file (preserving the existing content verbatim, preceded by a blank line).

   **Canonical Commit Rules block** (copy verbatim):

   ```markdown
   ## Commit Rules

   **Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

   Do not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

   This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
   ```

   **Canonical Input File Handling block** (copy verbatim):

   ```markdown
   ## Input File Handling

   Input files — context packs, reference documents, source data, prior artifacts the operator drops into the working directory — are read-only references. Use them by path, do not copy or rewrite them.

   - **Default to `Read`.** When the operator points you at an input file (whether it lives in the project folder, an `inputs/` sibling, or an absolute path elsewhere on the filesystem), use the `Read` tool against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands (`cp`, `cat >`, `tee`, redirection, `install`, etc.) against a file whose content originated outside the current session.
   - **Do not materialize chat content.** If an input's content enters the conversation (pasted, quoted, or summarized), that does not make the chat copy canonical. The file on disk remains the source of truth.
   - **Do not co-locate inputs with outputs for "provenance."** If provenance matters, record the absolute path of the input in the artifact's frontmatter or a `sources.md` file — do not duplicate the bytes.
   - **Outputs are different.** Artifacts your command is *designed to produce* (plans, specs, drafts, reports) are written normally via `Write` into `output/{project}/`. This rule governs inputs only.
   - **Exception: legitimate copying.** Copy an input only when (a) the operator explicitly asks for an archival snapshot or reproducibility freeze, or (b) a downstream tool requires the file at a specific path and no symlink or path argument will satisfy it. In both cases, record the absolute source path in the copy's frontmatter or in a sibling `SOURCE.md`, and state in your turn-summary that you copied rather than referenced.

   This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
   ```

   **Procedure:**

   ```bash
   CLAUDE_MD="projects/{name}/CLAUDE.md"

   if [ ! -f "$CLAUDE_MD" ]; then
     cat > "$CLAUDE_MD" <<'EOF'
# {project-title}

{one-line description from context pack, or a placeholder}

## Input File Handling

Input files — context packs, reference documents, source data, prior artifacts the operator drops into the working directory — are read-only references. Use them by path, do not copy or rewrite them.

- **Default to `Read`.** When the operator points you at an input file (whether it lives in the project folder, an `inputs/` sibling, or an absolute path elsewhere on the filesystem), use the `Read` tool against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands (`cp`, `cat >`, `tee`, redirection, `install`, etc.) against a file whose content originated outside the current session.
- **Do not materialize chat content.** If an input's content enters the conversation (pasted, quoted, or summarized), that does not make the chat copy canonical. The file on disk remains the source of truth.
- **Do not co-locate inputs with outputs for "provenance."** If provenance matters, record the absolute path of the input in the artifact's frontmatter or a `sources.md` file — do not duplicate the bytes.
- **Outputs are different.** Artifacts your command is *designed to produce* (plans, specs, drafts, reports) are written normally via `Write` into `output/{project}/`. This rule governs inputs only.
- **Exception: legitimate copying.** Copy an input only when (a) the operator explicitly asks for an archival snapshot or reproducibility freeze, or (b) a downstream tool requires the file at a specific path and no symlink or path argument will satisfy it. In both cases, record the absolute source path in the copy's frontmatter or in a sibling `SOURCE.md`, and state in your turn-summary that you copied rather than referenced.

This rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.

## Commit Rules

**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.

Do not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).

This rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.
EOF
     # Substitute {project-title} and description with real values
   else
     # Ensure Input File Handling section (idempotent append)
     if grep -q '^## Input File Handling' "$CLAUDE_MD"; then
       echo "Input File Handling already present in $CLAUDE_MD — skipping"
     else
       printf '\n## Input File Handling\n\nInput files — context packs, reference documents, source data, prior artifacts the operator drops into the working directory — are read-only references. Use them by path, do not copy or rewrite them.\n\n- **Default to `Read`.** When the operator points you at an input file (whether it lives in the project folder, an `inputs/` sibling, or an absolute path elsewhere on the filesystem), use the `Read` tool against that path. Never invoke `Write`, `Edit`, `MultiEdit`, or shell file-creation commands (`cp`, `cat >`, `tee`, redirection, `install`, etc.) against a file whose content originated outside the current session.\n- **Do not materialize chat content.** If an input'"'"'s content enters the conversation (pasted, quoted, or summarized), that does not make the chat copy canonical. The file on disk remains the source of truth.\n- **Do not co-locate inputs with outputs for "provenance."** If provenance matters, record the absolute path of the input in the artifact'"'"'s frontmatter or a `sources.md` file — do not duplicate the bytes.\n- **Outputs are different.** Artifacts your command is *designed to produce* (plans, specs, drafts, reports) are written normally via `Write` into `output/{project}/`. This rule governs inputs only.\n- **Exception: legitimate copying.** Copy an input only when (a) the operator explicitly asks for an archival snapshot or reproducibility freeze, or (b) a downstream tool requires the file at a specific path and no symlink or path argument will satisfy it. In both cases, record the absolute source path in the copy'"'"'s frontmatter or in a sibling `SOURCE.md`, and state in your turn-summary that you copied rather than referenced.\n\nThis rule mirrors the canonical `Input File Handling` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.\n' >> "$CLAUDE_MD"
     fi

     # Ensure Commit Rules section (idempotent append)
     if grep -q '^## Commit Rules' "$CLAUDE_MD"; then
       echo "Commit Rules already present in $CLAUDE_MD — skipping"
     else
       printf '\n## Commit Rules\n\n**Commit directly. Do not ask for permission.** After completing approved work, stage the relevant files and commit in a single step using a heredoc commit message. Do not run `git status`, `git diff`, or `git status --short` as pre-commit checks or post-commit verification — the filesystem is the source of truth for what you just changed.\n\nDo not push. Pushing is a manual operator step. After committing, remind the operator to push and to run `/wrap-session` if the work is complete. Never commit files that may contain secrets (`.env`, credentials, tokens).\n\nThis rule mirrors the canonical `Commit behavior` section in the workspace-level `CLAUDE.md`. It is repeated here because projects are sometimes opened without the parent workspace context loaded.\n' >> "$CLAUDE_MD"
     fi
   fi
   ```

   Report in the step output:
   - created new CLAUDE.md / appended Input File Handling / appended Commit Rules / already present (per section)

5. **Initial sync** — run the hook once now so the project starts with all shared commands/agents already linked, instead of waiting for the next session start:

   ```bash
   CLAUDE_PROJECT_DIR="projects/{name}" bash ai-resources/.claude/hooks/auto-sync-shared.sh
   ```

### Report

Report what was created: manifest path, settings.json modifications (permissions block, SessionStart hook, `additionalDirectories` grant), CLAUDE.md state (created / appended / already present), and the list of files the initial sync symlinked. Do not commit — the operator reviews the enrichment alongside the pipeline output. From this point on, any new command added to `ai-resources/.claude/commands/` will be available in this project on the next session start automatically, and skills under `ai-resources/skills/` are reachable via the filesystem grant.

## Key Rules

- Never advance a stage without user confirmation (`NEXT`)
- Never modify decisions.md without user confirmation
- Always announce which stage is running and what it expects as input
- When spawning any subagent, always include in the spawn prompt: "Project directory: projects/{project-name}/ — Pipeline directory: projects/{project-name}/pipeline/"
- The `pipeline/pipeline-state.md` file is the source of truth for pipeline progress — always read it before taking action, always update it after state changes. All pipeline artifacts (context-pack, project-plan, architecture, specs, logs, test-results) live in `pipeline/`. Only the project's working files live at the project root.
- If the project involves creating new skills, inform the user that skill creation must use the `/create-skill` command from ai-resources. Ensure ai-resources is connected via `--add-dir` so the command is available.
