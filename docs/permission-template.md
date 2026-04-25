# Permission Templates — Canonical Shapes

This document is the **single source of truth** for Claude Code permission configurations across the workspace. Referenced by `/permission-sweep` (diagnose + remediate) and `/new-project` (Post-Pipeline Enrichment step 2).

If the templates below change, `/permission-sweep` picks up the new shapes on the next run. `/new-project` uses the project-level template inline — update both if the project shape changes.

---

## Why these shapes exist (the four root causes)

Between 2026-04-18 and 2026-04-24, six reactive patch commits fixed permission prompts one case at a time. Four structural root causes were identified:

1. **`settings.local.json` files wholly shadow the sibling `settings.json`'s `defaultMode`** — they do not merge. A local file without `defaultMode` silently disables the parent's `bypassPermissions`.
2. **`**` glob does not match dotfile path components by default.** `Edit(foo/**)` does not cover `foo/bar/.claude/baz`. Explicit `Edit(**/.claude/**)` is required.
3. **Project-level `.claude/settings.json` files without `defaultMode` inherit unpredictably** across harness versions.
4. **Bare tool grants (`Edit`, `Write`, `MultiEdit`, `Bash(*)`) must accompany scoped patterns.** Scoped patterns alone leave gaps for absolute-path edits.

Each template below addresses these causes at its appropriate layer.

---

## Layer A — User-level (`~/.claude/settings.json`)

Applies: every Claude Code session on this machine, regardless of project.

Canonical shape (liberal — this is your personal machine):

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Edit(**)", "Write(**)", "Bash(*)",
      "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` — acts as the universal floor when all narrower layers fail to cover a case.
- Bare `Edit(**)` and `Write(**)` — covers absolute paths globally.
- `Bash(*)` — covers arbitrary shell commands.
- Deny floor: `rm -rf` and `sudo` only. Narrow `rm` is allowed (Delete/Remove prompts are fixed at this layer).

---

## Layer B — Workspace root (`.claude/settings.json` at `Axcion AI Repo/`)

Applies: sessions opened at the workspace root (not inside a project or `ai-resources/`).

Canonical shape:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(sudo *)",
      "Bash(git reset --hard *)", "Bash(git checkout *)"
    ]
  }
}
```

**Key assertions:**
- `defaultMode: "bypassPermissions"` — primary gate.
- Dotfile-path glob: `Edit(**/.claude/**)` and `Write(**/.claude/**)` — covers nested `.claude/` directories across all projects (root cause #2).
- Absolute-path fallback: `Edit(/Users/.../**)` — covers edits via absolute paths regardless of session CWD.
- `Bash(rm *)` in allow — fixes Delete/Remove prompts. `rm -rf` still denied.
- Additional denies for destructive git ops (workspace-root-specific safeguards).

---

## Layer B′ — Workspace `settings.local.json`

Applies: local-only overrides at the workspace root (gitignored).

Canonical shape — **must include `defaultMode` explicitly**:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Edit", "Write", "MultiEdit", "Bash(*)"
    ]
  }
}
```

**Key assertion:** If a `settings.local.json` declares any `permissions` block, it MUST include `defaultMode: "bypassPermissions"` (root cause #1). Otherwise, the local file shadows the parent's bypass and prompts resume.

**Alternative:** Omit the `permissions` key entirely. If the local file has no `permissions` block, the sibling `settings.json` applies unmodified. This is the cleanest form unless local-only overrides are genuinely needed.

---

## Layer C — `ai-resources/.claude/settings.json`

Applies: sessions opened inside `ai-resources/` (skill/command/agent development).

Canonical shape:

```json
{
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Edit(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
      "Read(archive/**)", "Read(audits/working/**)",
      "Read(logs/*-archive-*.md)", "Read(inbox/archive/**)",
      "Read(**/deprecated/**)", "Read(**/old/**)"
    ]
  }
}
```

**Key assertions:**
- Must have `Bash(*)` in allow (root cause #4 — ai-resources previously had only narrow bash grants).
- Same dotfile-path and absolute-path patterns as workspace root.
- `Bash(rm *)` in allow.
- `Bash(git push*)` in deny — force explicit operator step for push.
- Read-denies on archival paths (preserves token-audit discipline).

---

## Layer D — Project-level (`projects/{name}/.claude/settings.json`)

Applies: sessions opened inside a project directory.

**Emitted by `/new-project` Post-Pipeline Enrichment step 2.** When updating this template, also update the `CANONICAL_PERMS` jq merge in `ai-resources/.claude/commands/new-project.md`.

Canonical shape:

```json
{
  "model": "sonnet",
  "permissions": {
    "defaultMode": "bypassPermissions",
    "allow": [
      "Bash(*)", "Read", "Edit", "Write", "MultiEdit",
      "Agent", "Skill", "TodoWrite", "Glob", "Grep",
      "WebFetch", "WebSearch", "NotebookEdit", "ToolSearch",
      "Edit(**/.claude/**)", "Write(**/.claude/**)",
      "Bash(rm *)"
    ],
    "deny": [
      "Bash(git push*)", "Bash(rm -rf *)", "Bash(sudo *)",
      "Read(archive/**)", "Read(**/*.archive.*)",
      "Read(**/deprecated/**)", "Read(**/old/**)"
    ],
    "additionalDirectories": [
      "/Users/patrik.lindeberg/Claude Code/Axcion AI Repo"
    ]
  }
}
```

**Key assertions:**
- `model: "sonnet"` at top level (workspace Model Tier default).
- `defaultMode: "bypassPermissions"` (root causes #1, #3).
- Dotfile-path glob `Edit(**/.claude/**)` (root cause #2).
- `Bash(rm *)` in allow — fixes Delete/Remove prompts.
- `additionalDirectories` granting workspace root — required for ai-resources symlinks to resolve.

---

## Layer D′ — Project `settings.local.json`

Same rule as Layer B′: if present and declares `permissions`, must include `defaultMode: "bypassPermissions"`. Otherwise omit `permissions` entirely.

---

## Intentional-narrow exceptions

Some projects intentionally have narrow permissions for data safety. These are **not errors** and must not be "healed" by `/permission-sweep`.

**Current known exception:** `projects/obsidian-pe-kb/vault/.claude/settings.json`

Shape (illustrative — preserve actual file contents):

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep", "Bash(ls:*)",
      "Edit(wiki/**)", "Edit(templates/**)",
      "Edit(_setup-notes.md)", "Edit(CLAUDE.md)",
      "Edit(_integrity-report-*.md)"
    ],
    "deny": [
      "Write(raw/**)", "Edit(raw/**)",
      "Bash(rm:*)", "Bash(mv raw/**)", "Bash(git push:*)"
    ]
  }
}
```

**Detection heuristic:** a file is INTENTIONAL-NARROW if BOTH are true:
1. The `allow` list contains specific path-scoped entries (e.g., `Edit(wiki/**)`) and NO bare `Edit`/`Write` entry.
2. The `deny` list contains specific path-scoped denies (e.g., `Write(raw/**)`) paired to the allow scopes.

When `/permission-sweep` encounters a file matching this heuristic, it tags findings as `INTENTIONAL-NARROW` and **skips remediation** unless invoked with `--fix-narrow`.

---

## Hook wiring for prevention

Every project's `.claude/settings.json` should wire the SessionStart sanity check alongside `auto-sync-shared.sh`. Canonical hook block (appended to `hooks.SessionStart`):

```json
{
  "type": "command",
  "command": "d=\"$CLAUDE_PROJECT_DIR\"; while [ \"$d\" != '/' ]; do d=$(dirname \"$d\"); [ -x \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\" ] && { \"$d/ai-resources/.claude/hooks/check-permission-sanity.sh\"; exit; }; done",
  "timeout": 5,
  "statusMessage": "Permission sanity check..."
}
```

The hook is invoked directly from ai-resources — do not copy `check-permission-sanity.sh` into the project's hooks directory.

---

## Detection rulebook (used by `/permission-sweep`)

### CRITICAL — cause live Edit/Delete prompts

1. `settings.local.json` missing `defaultMode: bypassPermissions` where parent `settings.json` has it (or parent is one of Layers A–D and the local file contains a `permissions` block).
2. Project/workspace `settings.json` missing `defaultMode` entirely.
3. Broad glob `Edit(X/**)` or `Write(X/**)` without dotfile-path companion (`Edit(**/.claude/**)` or `Edit(X/**/.claude/**)`).
4. Missing bare-tool entries (`Edit`, `Write`, `MultiEdit`) alongside scoped patterns.
5. Missing `Bash(*)` in files that allow narrow bash commands only (e.g., `Bash(git add *)` without catch-all).

### HIGH — Delete prompts or future Edit prompts

6. No `Bash(rm *)` in allow (Delete/Remove failure mode, separate from Edit).
7. Deny-shadows-allow (same tool-path pattern on both lists). Flag but don't auto-fix — sometimes intentional.
8. Missing or stale `additionalDirectories` in project files (should include workspace root absolute path).
9. Absolute-path allow entries with stale workspace paths (path no longer exists on disk).

### MEDIUM — coverage gaps

10. MCP tools (`mcp__*`) not covered by any allow entry in files that otherwise have a tool allowlist.
11. User-level vs workspace divergence in critical rules (flags the divergence; operator decides which wins).

### ADVISORY — hygiene

12. `settings.local.json` tracked by git (should be gitignored per Claude Code convention).
13. Typos / duplicate entries / syntax form inconsistencies (`Bash(foo *)` vs `Bash(foo:*)` — prefer the former).
14. `Read(<dir>/**)` deny entry where `<dir>` is a single concrete directory (not a glob pattern like `**/...`) and `<dir>/` does not appear in the appropriate `.gitignore` (same repo as the settings file). Audit/scan commands writing into denied scratchpad directories pollute `git status` when the directory is not gitignored — e.g., `Read(audits/working/**)` paired with `audits/working/` in `ai-resources/.gitignore`. Canonical fix: add `<dir>/` to the `.gitignore` at the same repo root as the settings file declaring the deny.

---

## Update protocol

When these templates change:

1. Update this file.
2. Update the `CANONICAL_PERMS` and `AUTO_SYNC_HOOK` / `SANITY_HOOK` literals in `ai-resources/.claude/commands/new-project.md` (Post-Pipeline Enrichment step 2).
3. Run `/permission-sweep --dry-run` across all scopes to surface which existing files drift from the new template.
4. Apply corrections via `/permission-sweep` with approval.
5. Commit as one change per step (template → pipeline → sweep run → remediation) so each can be reviewed independently.
