---
model: opus
---

Audit user-nominated critical resources across seven quality dimensions; produce a fix-ready findings report saved to `ai-resources/audits/`. Read-only — the command does not edit any resource. Fixes happen in a separate operator-directed session.

Input: $ARGUMENTS (optional) — space-separated resource paths (relative to `ai-resources/` or absolute). If empty, reads the manifest at `audits/critical-resources-manifest.md`.

Flags (anywhere in `$ARGUMENTS`):
- `--dry-run` — list what would be audited and the pinned doc URLs, then exit without spawning subagents.
- `--full-repo-context` — expand cross-resource synthesis to scan the full repo for reverse references to nominated resources. Off by default.

Examples:
- `/audit-critical-resources` — audit every resource in the manifest
- `/audit-critical-resources skills/summary/SKILL.md .claude/commands/audit-repo.md` — audit two specific resources (args override manifest)
- `/audit-critical-resources --dry-run` — preview what would run

Pinned Anthropic documentation URLs (used for Dimension 2 currency checks; hardcoded below):
- Skills: `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview`
- Slash commands (unified with skills per Claude Code 2026 docs): `https://code.claude.com/docs/en/skills`
- CLAUDE.md memory: `https://code.claude.com/docs/en/memory`

---

### Step 1: Path Setup

1. Set `WORKSPACE` = Axcíon AI workspace root (parent of `ai-resources/`).
2. Set `AI_RESOURCES` = `{WORKSPACE}/ai-resources/`.
3. Set `AUDIT_DIR` = `{AI_RESOURCES}/audits/`.
4. Set `WORKING_DIR` = `{AUDIT_DIR}/working/`. Create if missing (`mkdir -p`).
5. Set `MANIFEST_PATH` = `{AUDIT_DIR}/critical-resources-manifest.md`.
6. Set `DATE` = today in `YYYY-MM-DD`.
7. Set `REPORT_PATH` = `{AUDIT_DIR}/audit-critical-resources-{DATE}.md`.
8. Verify the subagent definition exists at `{AI_RESOURCES}/.claude/agents/critical-resource-auditor.md`. Abort if missing.

---

### Step 2: Parse Flags and Resource List

9. From `$ARGUMENTS`, extract:
   - `DRY_RUN` = true if `--dry-run` present
   - `FULL_REPO_CONTEXT` = true if `--full-repo-context` present
   - `RAW_ARGS` = remaining tokens after removing flags

10. If `RAW_ARGS` is empty:
    - If `MANIFEST_PATH` does NOT exist, abort with this message:
      ```
      No resources provided and no manifest at {MANIFEST_PATH}.

      Create the manifest with one resource path per line. Example:

        # Critical resources to audit
        skills/summary/SKILL.md
        skills/ai-resource-builder/SKILL.md
        .claude/commands/audit-repo.md

      Parse rules: blank lines and `#` comments are skipped. A leading `- ` bullet
      is stripped. Paths may be relative to ai-resources/ or absolute.

      Or pass resources as arguments:
        /audit-critical-resources skills/summary/SKILL.md
      ```
    - Read `MANIFEST_PATH`. Apply these parse rules:
      - Skip blank lines and lines whose first non-whitespace character is `#` or `>`.
      - Trim leading/trailing whitespace.
      - Strip a leading `- ` (markdown bullet) if present.
      - Expand `~` to the home directory.
      - Resolve relative paths against `{AI_RESOURCES}`.
    - Set `RESOURCE_LIST` = the resulting absolute paths.
11. Otherwise (args provided):
    - Each token in `RAW_ARGS` is a resource path. Resolve relative paths against `{AI_RESOURCES}`, expand `~`.
    - Set `RESOURCE_LIST` = resulting absolute paths.

12. Validate every path in `RESOURCE_LIST` exists on disk. On any unresolvable path, abort with per-path error. Do NOT silently skip.

13. Classify each resource's type:
    - Matches `**/skills/*/SKILL.md` → `skill`
    - Matches `**/.claude/commands/*.md` → `command`
    - Filename is `CLAUDE.md` → `config`
    - Matches `**/.claude/agents/*.md` → `agent`
    - Otherwise → `other`

14. Set `N` = count of resources in `RESOURCE_LIST`.

---

### Step 3: Dry-Run Gate

15. If `DRY_RUN` is true:
    - Print:
      - Header: `/audit-critical-resources --dry-run`
      - `Resources to audit (N = {N}):` followed by one line per resource: `  - {path} — {type}`
      - `Pinned Anthropic documentation URLs:` with the three URLs from the frontmatter above
      - `--full-repo-context: {on/off}`
      - `No subagents spawned. Exit.`
    - Exit. Do not proceed to subagent spawning.

---

### Step 4: Heavy-Load Flag

16. Emit `[HEAVY]` to chat with a one-line note: "spawning {N} critical-resource-auditor subagents in parallel."

---

### Step 5: Spawn Per-Resource Auditors in Parallel

17. For each resource in `RESOURCE_LIST`, compute `RESOURCE_SLUG` per resource type (deterministic — no trailing dashes, no leading dots):
    - **skill** (`**/skills/{name}/SKILL.md`) → `skills-{name}` (e.g., `skills/summary/SKILL.md` → `skills-summary`)
    - **command** (`**/.claude/commands/{name}.md`) → `commands-{name}` (e.g., `.claude/commands/audit-repo.md` → `commands-audit-repo`)
    - **agent** (`**/.claude/agents/{name}.md`) → `agents-{name}` (e.g., `.claude/agents/qc-reviewer.md` → `agents-qc-reviewer`)
    - **config** (`**/CLAUDE.md`) → `claude-md-{parent-dir-name}`; if at workspace root, use `claude-md-root`
    - **other** → lowercased relative path with `/` replaced by `-`, any leading `.` stripped, trailing `.md` stripped, trailing `-` trimmed

    Then set `WORKING_NOTES_PATH` = `{WORKING_DIR}/audit-critical-resources-working-notes-{RESOURCE_SLUG}-{DATE}.md`.

18. Spawn one `critical-resource-auditor` subagent per resource, in parallel (single message, multiple Agent tool calls). Pass each subagent these inputs:
    - `RESOURCE_PATH` — absolute
    - `RESOURCE_TYPE` — skill | command | config | agent | other
    - `RESOURCE_SLUG`
    - `DOC_URL_SKILLS` = `https://platform.claude.com/docs/en/agents-and-tools/agent-skills/overview`
    - `DOC_URL_COMMANDS` = `https://code.claude.com/docs/en/skills`
    - `DOC_URL_CLAUDE_MD` = `https://code.claude.com/docs/en/memory`
    - `WORKSPACE_CLAUDE_MD_PATH` = `{WORKSPACE}/CLAUDE.md`
    - `REPO_CLAUDE_MD_PATH` = `{AI_RESOURCES}/CLAUDE.md`
    - `WORKING_NOTES_PATH`
    - `NOMINATED_LIST` — every resource in this run formatted as `{path} [{type}]`, one per line
    - `DATE`

19. Collect each subagent's ≤30-line summary. Parse the last line of each summary to extract the `WORKING_NOTES: <absolute-path>` marker. Add each parsed path to `STAGING_LIST`.

20. If any subagent's summary lacks the `WORKING_NOTES:` last-line marker, re-invoke that one subagent with the same inputs. If the re-invocation still omits the marker, abort with a loud error naming the subagent and the malformed summary. Do NOT proceed to synthesis with missing notes.

---

### Step 6: Cross-Resource Synthesis (Main Session)

21. For each path in `STAGING_LIST`, Read only the `## Synthesis Input Block` section (do NOT read the finding bodies). Parse the single YAML block within that section; it contains three top-level keys: `outbound_refs`, `trigger_claims`, `behavioral_claims`. If any notes file is missing this section or the YAML is malformed, mark the Cross-Resource Findings section as `INCOMPLETE — missing or malformed Synthesis Input Block for {path}` and continue with the remaining notes.

22. Compute cross-resource findings:
    a. **Trigger overlaps.** Compare `trigger_claims` text across resources. Flag pairs whose trigger/purpose text is semantically similar enough that a user could invoke either for the same need. Severity: Substantive.
    b. **Broken inter-resource references.** For each `outbound_refs` item that targets another resource in `NOMINATED_LIST`, verify the target path still resolves and the referenced name still matches the target's current name. Severity: Blocking if target missing; Substantive if renamed/moved.
    c. **Contradictions.** Compare `behavioral_claims` across resources that would run in the same context. Flag pairs that promise different behavior on the same concern. Severity: Substantive.
    d. **Composition gaps.** Resources that claim to interact (one's `outbound_refs` names another, or its `behavioral_claims` implies invocation) but whose contracts don't match in shape. Severity: Substantive.

23. If `FULL_REPO_CONTEXT` is true, additionally:
    - For each resource in `NOMINATED_LIST`, grep `{AI_RESOURCES}` and `{WORKSPACE}` (excluding `.git/` and `audits/working/`) for references to the resource by its filename or slash-command name.
    - For each hit in a file outside `NOMINATED_LIST`, record the referencing file and a short context quote.
    - If the referencing file references an outdated aspect of the resource (renamed, moved, or contract-changed since the reference was written), flag it as Substantive "reverse-reference drift."

24. Hold cross-resource findings in a main-session buffer (not a file); they will be rendered into the report in Step 7.

---

### Step 7: Assemble Final Report

25. Write `REPORT_PATH` with this exact structure (the template is enforceable; Step 8 validates it):

    ```
    # Critical Resource Audit — {DATE}

    ## Audit Summary

    - Resources audited: {N}
    {one bullet per resource: `  - {path} — {type}`}
    - Total findings: Blocking: X / Substantive: Y / Minor: Z
    - Currency check status: {succeeded / partial / failed — with reason}
    - `--full-repo-context`: {on / off}

    ## Per-Resource Findings

    {For each resource, copy the contents under its working-notes file's `## Per-Resource Findings` heading (i.e., the `### {Resource Name}` block with **Type** / **Path** / `#### Dimension 1…7` subsections). Concatenate all such blocks here, preserving the order from RESOURCE_LIST.}

    ## Cross-Resource Findings

    ### Trigger Overlaps
    {findings from 22a; each: the resources involved, the overlapping trigger text, severity, recommendation. If none, write "No trigger overlaps detected."}

    ### Broken Inter-Resource References
    {findings from 22b; each: source resource, target resource, ref text, current state, severity}

    ### Contradictions
    {findings from 22c; each: resources involved, conflicting claims (verbatim), the scenario where they diverge, severity}

    ### Composition Gaps
    {findings from 22d; each: resources involved, claimed interaction, contract mismatch, severity}

    {If --full-repo-context was set, add:}

    ### Reverse-Reference Drift
    {findings from 23; each: nominated resource, referencing file outside nominated set, nature of drift, severity}

    ## Unverified / Incomplete Checks

    {For each per-resource working-notes file, any dimension marked INCOMPLETE (e.g., currency fetch failed): list "Resource: {path}; Dimension: {N}; Reason: {text}".}
    {Plus any cross-resource subsection marked INCOMPLETE in Step 21.}
    {If none, write "All checks completed."}
    ```

26. Extracting per-resource sections: for each working-notes path in `STAGING_LIST` (ordered to match `RESOURCE_LIST`), read the file, locate the `## Per-Resource Findings` heading, and copy the body (everything up to the next `## ` heading) into the final report's `## Per-Resource Findings` section. The subagent writes this body such that its first child is a `### {Resource Name}` block — concatenation gives the correct final shape.

---

### Step 8: Structural Validation

27. Read `REPORT_PATH` back. Verify:
    - `## Audit Summary` is present
    - Every resource in `RESOURCE_LIST` has a `### ` heading under `## Per-Resource Findings`
    - Each resource section contains seven `#### Dimension ` headings (1–7, in order)
    - `## Cross-Resource Findings` is present
    - `## Unverified / Incomplete Checks` is present

28. If any check fails:
    - Missing per-resource section → re-invoke that resource's subagent once and re-extract; if it still fails, emit a placeholder `### {resource} — SECTION RENDERING FAILED` so the operator sees the gap explicitly.
    - Missing Audit Summary / Cross-Resource / Unverified sections → regenerate those sections from main-session state (no subagent re-invoke needed).
    - Re-validate. Do NOT emit an incomplete report without the explicit failure placeholder.

---

### Step 9: Commit

29. Compute `M` = total finding count (Blocking + Substantive + Minor) across the report.

30. Stage explicit paths only (per `ai-resources/CLAUDE.md` Concurrent-session staging discipline — no directory globs, no `git add .`):
    - `git add {REPORT_PATH}`
    - For each path in `STAGING_LIST`: `git add {path}`

31. Commit with message:
    ```
    audit: critical-resources — {DATE} [{N} resources, {M} findings]
    ```

32. Do NOT push. Remind the operator to push and to run `/wrap-session` when work is complete.

---

### Step 10: Present Summary to Operator

33. Display in chat:
    - Path to `REPORT_PATH`
    - `N` resources audited
    - Finding count by severity: Blocking / Substantive / Minor
    - Top 5 Blocking findings (one line each): `{resource} · Dimension {N} · {one-phrase rationale}`
    - Any dimension marked incomplete (with reason) — flag these as requiring re-audit once blockers resolve
    - Reminder: "Fixes happen in a separate session. Open a fresh session and paste the report to execute fixes without re-auditing."
