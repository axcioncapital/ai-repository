---
name: token-audit-protocol
version: 1.2
source: |
  v1.1 authored by operator (Patrik) in conversation 2026-04-18.
  v1.2 corrections applied during build session to address independent QC findings.
rationale: |
  Tool-required canonical path. The token-audit-auditor subagent requires the protocol
  at {AUDIT_DIR}/token-audit-protocol.md. Per workspace CLAUDE.md Input File Handling,
  Exception (b) applies: "a downstream tool requires the file at a specific path and
  no symlink or path argument will satisfy it."
corrections_applied:
  - Sections 0.3, 6.2, 7 — .claudeignore check replaced with Read(pattern) deny-rule check
  - Section 5 — workspace-scope conditional delegation rule added
  - Token estimation header — ±30% proxy-drift caveat added, cross-referenced from threshold sections
  - Section 0.4 — output path updated to {AUDIT_DIR}/token-audit-YYYY-MM-DD[-{SCOPE_SLUG}].md (incremental-write language preserved verbatim)
---

# Token Usage Optimization Audit Protocol

## For: Claude Code Execution Against the Axcíon AI Repo

**Version:** 1.2
**Created:** April 2026
**Purpose:** This protocol tells you (Claude Code) exactly what to inspect, how to measure it, and how to report findings. Execute sections sequentially when feasible. If token or context limits prevent full completion, follow the priority order in the Execution Notes and clearly mark any omitted sections as "SKIPPED — token budget constraint." Do not ask the operator clarifying questions unless you hit a genuine blocker — this document should answer everything you need.

**Token estimation method (use consistently across all sections):** Estimate token count as word count × 1.3 unless a better measured proxy is available. Apply this to CLAUDE.md, skills, command files, loaded external files, and any other content entering context.

> **Caveat.** Word count × 1.3 is a proxy, not a real tokenizer. Drift of approximately ±30% vs. actual tokenization is plausible. Severity thresholds tied to this estimate (>300 lines HIGH, 200–300 MEDIUM, >500 token context cost HIGH) should be read as approximate. A finding within ±15% of a threshold boundary is ambiguous and deserves a note in Section 10 confidence rating.

---

## 0. Pre-Flight

Before starting any inspection work, do the following:

**0.1 — Record baseline session metrics**
Attempt to run `/cost` and `/context` at the start of this session. If either command succeeds, record the output in a working file at `{WORKING_DIR}/audit-working-notes-preflight.md`. If either command is unavailable or returns incomplete data, record "not available in this execution environment" and continue — this is non-blocking. You will reference these values later to calculate the audit's own token cost if available.

**0.2 — Check for session-usage-analyzer data**
Locate the `session-usage-analyzer` skill in the repo (`find . -name "SKILL.md" -path "*session-usage*"`). Read its SKILL.md to determine where it writes output files and what format they use. Then search those locations for any historical output. Accept `.md`, `.csv`, and `.json` files whose filename or content references session usage, cost, or token data. If historical data exists, note the file paths and date range in your working notes — you will use this in Section 5. If no data exists or the skill provides no output path information, note that and proceed. This is non-blocking.

**0.3 — Check for `Read(pattern)` deny-rule coverage**

*(v1.2 correction: v1.1 checked for a `.claudeignore` file. `.claudeignore` is not a documented Claude Code feature. The actual mechanism that prevents file-content loading into context is `permissions.deny` with `Read(pattern)` entries specifically — per claude-code-guide research, these block file discovery/reading across Glob, Grep, Read, and Edit tools. Generic `permissions.deny` entries such as `Write(...)` or `Bash(...)` do not answer the context-load question.)*

Perform the following:

1. Locate `.claude/settings.json` and `.claude/settings.local.json` under the audit root. Use `find {AUDIT_ROOT} -name "settings*.json" -path "*.claude*" -not -path "*/node_modules/*"`.
2. For each settings file found, parse the `permissions.deny` array.
3. Filter for entries matching the pattern `Read(...)` specifically. These are the context-load protection rules.
4. List which directory patterns are covered by those `Read(...)` denies.
5. Compare against this expected-coverage list for the token-audit context: `audits/`, `logs/`, `reports/`, `inbox/`, `archive/`, `output/` (if present), `drafts/`, and any directory whose name contains `deprecated` or `old`.
6. Severity for this finding (used later in Sections 6 and 7):
   - **HIGH** — No `Read(...)` deny rules exist at all. Claude Code may explore and read any file in the repo during Glob/Grep/Read operations, including stale or large archival content.
   - **MEDIUM** — Some `Read(...)` denies exist but coverage is missing for more than 2 of the expected directories.
   - **PASS** — Coverage complete (all expected-coverage directories have at least one matching `Read(...)` deny rule).

Record the finding verdict (HIGH / MEDIUM / PASS), the list of currently-covered directories, and the list of expected-but-missing directories in `{WORKING_DIR}/audit-working-notes-preflight.md`.

**0.4 — Set up the output file**
Create the audit report at `{AUDIT_DIR}/token-audit-YYYY-MM-DD[-{SCOPE_SLUG}].md`, where `AUDIT_DIR` is the audits directory passed by the command (`ai-resources/audits/` by convention) and `SCOPE_SLUG` is set when the audit is not at workspace scope. **You will build this file incrementally as you complete each section. Do not wait until the end to write the report** — write findings as you go so that if the session is interrupted, partial results are preserved.

---

## 1. CLAUDE.md Audit

**What to inspect:** The root `CLAUDE.md` file. Also check for any `.claude/CLAUDE.md` or subdirectory CLAUDE.md files.

**Measurements to collect:**

| Metric | How to measure |
| --- | --- |
| Total line count | `wc -l CLAUDE.md` |
| Approximate token count | `wc -w CLAUDE.md` (word count × 1.3 ≈ token count — *see token-estimation caveat in header; thresholds are approximate*) |
| Number of sections/headings | `grep -c "^#" CLAUDE.md` |
| Presence of subdirectory CLAUDE.md files | `find . -name "CLAUDE.md" -not -path "./.git/*"` |

**What to assess (read the file and answer each question):**

1. **Size check.** Is CLAUDE.md under 200 lines? (Anthropic's official recommendation is under 200 lines. Over 300 lines is a significant concern — every line is loaded every turn, every session.) *(See token-estimation caveat in header — thresholds are approximate.)*
2. **Essentials-only test.** For each section, ask: "Does this apply across all or most session types?" Content that applies only to a specific workflow or task type belongs in a skill, not CLAUDE.md. If a section would only matter during, say, research execution or skill creation but not other session types, flag it as a candidate for migration to a skill.
3. **Skill-eligible content.** Identify any blocks of instructions that apply only to specific workflows or task types. These should be skills (loaded on demand), not CLAUDE.md content (loaded every session).
4. **Redundancy with skills.** Check whether any CLAUDE.md content duplicates instructions already present in skill files. If so, flag the duplication.
5. **Compaction instructions.** Does CLAUDE.md include custom compaction instructions (telling Claude what to preserve during `/compact`)? If not, flag as a missing safeguard.
6. **Aspirational vs. behavioral.** Flag any content that is descriptive or aspirational rather than behavioral. "We value clean code" costs tokens but doesn't change behavior. "Always run linting before committing" changes behavior.

**Severity classification:**

- CLAUDE.md over 300 lines → HIGH
- CLAUDE.md 200–300 lines → MEDIUM
- Skill-eligible content still in CLAUDE.md → MEDIUM per block
- Duplicate content between CLAUDE.md and skills → MEDIUM
- Missing compaction instructions → MEDIUM
- Aspirational content → LOW per instance

**Report format for this section:**

```markdown
### 1. CLAUDE.md Audit

**File:** CLAUDE.md
**Line count:** [N]
**Estimated tokens:** [N words × 1.3]
**Subdirectory CLAUDE.md files found:** [list or "none"]

**Per-session cost:** This file costs approximately [N] tokens on every turn of every session. Over a typical 2–3 hour session with ~30–50 turns, that is [N × 30] to [N × 50] tokens spent purely on CLAUDE.md loading.

**Findings:**

| # | Finding | Severity | Lines affected | Recommendation |
|---|---------|----------|---------------|----------------|
| 1 | [description] | HIGH/MEDIUM/LOW | [line range] | [action] |
```

---

## 2. Full Skill Census

**What to inspect:** Every skill file in the repo. All of them — no sampling.

**Step 2.1 — Locate all skills**

```bash
find . -name "SKILL.md" -not -path "./.git/*" | sort
```

Record the full list. Count the total.

**Step 2.2 — Measure each skill**

For each SKILL.md file, collect:

| Metric | How to measure |
| --- | --- |
| File path | From the find command |
| Line count | `wc -l` |
| Word count | `wc -w` (proxy for token cost when loaded) |
| Has YAML frontmatter | Check for `---` block at top with `name:` and `description:` fields |
| Description quality | Read the `description:` field — is it trigger-rich (specific activation conditions) or vague? |

**Token budget management for this section:** Do NOT read the full content of every skill file. Instead:

1. Run a batch measurement script first to get line counts and word counts for all files in one pass
2. Read the first 20 lines of each file (the frontmatter + opening section) to assess description quality
3. Only read the full file for skills that are flagged as oversized (>150 lines) or that have vague descriptions

**Batch measurement (run this as a single command):**

```bash
find . -name "SKILL.md" -not -path "./.git/*" -print0 | sort -z | while IFS= read -r -d '' f; do
  lines=$(wc -l < "$f")
  words=$(wc -w < "$f")
  echo "$f | $lines lines | $words words"
done
```

**What to assess:**

1. **Oversized skills.** Flag any skill over 150 lines. Skills should be focused and concise. A 300-line skill is probably doing too much or being too verbose. *(See token-estimation caveat in header — thresholds are approximate.)*
2. **Vague descriptions.** A description is vague if it omits both trigger conditions (when to activate) and specific task type (what it does). Compare against this benchmark: "Reviews TypeScript and JavaScript code for security vulnerabilities, performance issues, and adherence to team coding standards when user asks for code review or mentions reviewing changes" — that's trigger-rich. "Helps with code" — that's vague. Flag any skill that lacks explicit trigger conditions or specific task scope.
3. **Missing frontmatter.** Flag any skill that lacks YAML frontmatter with `name:` and `description:`. Without this, Claude Code cannot match it efficiently, which may cause unnecessary file reads to determine relevance.
4. **Redundancy between skills.** Flag only where two skills' names and descriptions imply the same primary task, audience, and trigger context, or where one skill appears to be a narrower subset of another without a clear differentiator. Similar-sounding names alone are not sufficient — the descriptions must indicate overlapping activation conditions.
5. **Dead skills.** A skill is dead only if it has no references from CLAUDE.md, command files, or workflow docs AND shows naming/deprecation markers such as `old`, `deprecated`, `v1`, `archive`, or has a clearly superseding variant in the repo.

**For oversized skills only (>150 lines), additionally assess:**

- Can the skill be split into smaller, focused skills?
- Does it contain verbose examples that could be compressed?
- Does it repeat instructions available in CLAUDE.md or other skills?

**Severity classification:**

- Skill over 300 lines → HIGH (large token cost when loaded)
- Skill 150–300 lines → MEDIUM
- Vague description (unreliable triggering) → MEDIUM (causes either missed loads or unnecessary exploration reads)
- Missing frontmatter → MEDIUM
- Clear redundancy between skills → LOW (unless both are frequently loaded in the same session type)

**Report format for this section:**

```markdown
### 2. Skill Census

**Total skills found:** [N]
**Total lines across all skills:** [N]
**Total estimated tokens across all skills:** [N words × 1.3]

**Size distribution:**
- Under 50 lines: [N] skills
- 50–150 lines: [N] skills
- 150–300 lines: [N] skills
- Over 300 lines: [N] skills

**Top 10 largest skills:**

| Rank | Skill path | Lines | Words | Finding |
|------|-----------|-------|-------|---------|
| 1 | [path] | [N] | [N] | [note] |

**Description quality issues:**

| Skill | Issue | Severity |
|-------|-------|----------|
| [name] | [vague/missing/etc.] | MEDIUM |

**Redundancy flags:**

| Skills | Overlap description |
|--------|-------------------|
| [A] vs [B] | [what overlaps] |
```

---

## 3. Command File Census

**What to inspect:** All command files (slash commands). These are typically in `.claude/commands/` or a similar location.

**Step 3.1 — Locate all command files**

Search in this order:

1. Canonical slash-command directory: `ls -la .claude/commands/ 2>/dev/null`
2. Any other command directories: `find . -path "*/commands/*" -type f -not -path "./.git/*" | sort`
3. Files referenced as commands in CLAUDE.md or settings: `grep -i "command" CLAUDE.md 2>/dev/null`

Deduplicate results. Items from step 1 are definitive; items from steps 2–3 are secondary candidates — include them only if they are clearly structured as invocable commands.

**Step 3.2 — Measure each command file**

For each command file, collect:

- File path
- Line count
- Word count
- Whether it references/loads other files (grep for file paths, `cat`, `read`, or include patterns)

**What to assess:**

1. **Context loading cost.** Command files that `cat` or include large files effectively load those files into context when invoked. Flag any command that pulls in files over 100 lines. Estimate loaded file tokens as word count × 1.3 (use this method consistently across all sections).
2. **Redundant loading.** Do any commands load context that CLAUDE.md already provides? That would be double-loading.
3. **Cascading loads.** Do any commands invoke skills or read files that in turn read more files? Rank commands by complexity score (number of external file references + number of nested invocations + command line count) and map the full load chain for the top 5.

**Report format:**

```markdown
### 3. Command File Census

**Total command files found:** [N]

| Command | Lines | Words | Loads external files? | Estimated context cost |
|---------|-------|-------|-----------------------|----------------------|
| [name] | [N] | [N] | [yes/no — list files] | [estimated tokens] |

**High-cost commands (loading >500 tokens of external context):**

| Command | What it loads | Estimated total cost | Recommendation |
|---------|--------------|---------------------|----------------|
```

---

## 4. Workflow Token Efficiency Audit

**What to inspect:** The active workflows in the repo.

**Definition:** A workflow is "active" if it is referenced in CLAUDE.md, invoked by a slash command, or documented in a top-level workflow/process file. If more than 5 candidates exist, rank by frequency of reference across CLAUDE.md, command files, and workflow documentation, then audit the top 5. If fewer than 4 are clearly identifiable, audit all that you find and note the count.

**Step 4.1 — Identify active workflows**

Search for workflow documentation:

```bash
find . -name "*workflow*" -not -path "./.git/*" | sort
grep -r "workflow" CLAUDE.md --include="*.md" | head -20
```

Also check for any files explicitly named as workflows or processes.

**Step 4.2 — For each workflow, map the token flow**

For each identified workflow, answer the following. **If no session telemetry is available, label all "typical" estimates as structural inferences derived from workflow instructions and file-loading patterns, not observed data.**

1. **What gets loaded at workflow start?** (CLAUDE.md + any command/skill invocations)
2. **How many subagent calls does the workflow design involve?** (Each subagent has its own context, but its return adds to the main session)
3. **What is the estimated output volume?** (Large outputs from subagents that return to the main session are a key cost driver)
4. **How many QC/refinement cycles does this workflow design for?** (This is the refinement multiplier from the context pack)
5. **Where do files get read?** Map every file-read operation in the workflow. A read is "necessary" if it is directly required to produce the workflow's stated output. A read is "delegable" if it can be performed and summarized in a subagent without requiring iterative reasoning in the main session. Flag files over 100 lines being read in the main session when they are delegable.
6. **Where do files get written?** Large outputs written to context rather than to disk are wasteful.

**What to assess:**

1. **Subagent return volume.** Are subagents returning full outputs into the main session, or writing to disk and returning only summaries? Full returns are a major token drain.
2. **Unnecessary reads in main session.** Are large files being read in the main session when they could be delegated to subagents?
3. **Missing `/compact` opportunities.** Are there natural breakpoints in the workflow where `/compact` should be triggered but isn't enforced?
4. **Refinement multiplier.** For each workflow, estimate how many total sessions (main + QC + refinement subagents) a typical run requires. If the answer is consistently >3, the workflow's first-pass quality may need investigation.

**Severity classification:**

- Subagent returning >200 lines to main session → HIGH *(See token-estimation caveat in header — thresholds are approximate.)*
- Large file reads in main session that could be delegated → HIGH
- No compaction instructions or breakpoints defined → MEDIUM
- Consistent need for >3 refinement cycles → MEDIUM (may indicate instruction quality issue rather than token waste per se, but the token cost is real)

**Report format:**

```markdown
### 4. Workflow Token Efficiency

**Workflows identified:** [list]

#### Workflow: [Name]

**Context loading chain:**
1. CLAUDE.md loads (~[N] tokens)
2. Command [X] invoked → loads [files] (~[N] tokens)
3. Skill [Y] triggered → adds (~[N] tokens)
**Total estimated start-of-workflow context:** ~[N] tokens

**File reads during execution:**
| File | Size | Read in main/subagent | Necessary / Delegable? |
|------|------|-----------------------|------------------------|

**Subagent pattern:**
| Subagent purpose | Returns to main? | Return size estimate |
|-----------------|------------------|---------------------|

**Findings:**
| # | Finding | Severity | Waste mechanism | Recommendation |
|---|---------|----------|----------------|----------------|
```

---

## 5. Session Patterns & Historical Data

**Workspace-scope note (v1.2 addition).** If executing at workspace scope and more than 3 `session-usage-analyzer` log files are discovered in Step 0.2, delegate Section 5 to `token-audit-auditor` per the protocol's general rule ("tasks requiring >3–4 file reads go to subagent"). At narrower scopes (ai-resources, single project), Section 5 runs inline in main session.

**What to inspect:** Any data produced by `session-usage-analyzer` plus the structural patterns visible from the repo.

**If session-usage-analyzer data exists:**
Read the most recent 3–5 session reports. Extract:

- Average session duration
- Average token consumption per session
- Which skills/commands were invoked most frequently
- Whether compaction was used and at what percentage
- Any patterns in what caused sessions to end (hit limit, completed task, quality degradation)

**If no historical data exists:**
Skip to structural analysis. Note in the report: "No session telemetry available. All findings in this section are based on structural analysis of the repo configuration, not observed usage data."

**Structural analysis (do regardless of telemetry availability):**

1. **Model configuration.** Check repo-local config files first, then attempt user-home settings as secondary. If user-home settings are inaccessible, record "not observable from repo context" rather than "not set."

   ```bash
   find . -name "settings.json" -not -path "./.git/*" -exec cat {} \;
   cat ~/.claude/settings.json 2>/dev/null || echo "User-home settings inaccessible"
   ```

2. **Autocompact threshold.** Check whether `CLAUDE_AUTOCOMPACT_PCT_OVERRIDE` is set anywhere.

3. **Extended thinking configuration.** Check whether `MAX_THINKING_TOKENS` is set. The default can be tens of thousands of tokens per request.

   ```bash
   grep -r "MAX_THINKING_TOKENS" . --include="*.json" --include="*.md" 2>/dev/null
   grep -r "THINKING" . --include="*.json" --include="*.md" 2>/dev/null
   ```

4. **MCP servers.** Check what MCP servers are configured. Each active server adds tool definitions to context.

   ```bash
   cat ~/.claude/settings.json 2>/dev/null | grep -A5 "mcp" || echo "MCP config not observable from repo context"
   ```

5. **Hooks.** Check for any hooks (pre-tool, post-tool, stop hooks) that may affect token usage. Ignore commented-out lines. If uncertain whether a setting is active or an example, note the ambiguity.

   ```bash
   find . -path "*.claude/hooks*" -not -path "./.git/*" 2>/dev/null
   find . -name "hooks.json" -not -path "./.git/*" 2>/dev/null
   ```

**Report format:**

```markdown
### 5. Session Patterns & Configuration

**Session telemetry available:** [yes/no]
[If yes, summarize key findings from session-usage-analyzer data]

**Configuration audit:**

| Setting | Current value | Recommended | Impact |
|---------|--------------|-------------|--------|
| Default model | [value, "not set", or "not observable from repo context"] | Sonnet (switch to Opus only for complex reasoning) | [estimated impact] |
| Subagent model | [value, "not set", or "not observable from repo context"] | Haiku for mechanical tasks | [estimated impact] |
| MAX_THINKING_TOKENS | [value, "not set", or "not observable from repo context"] | 10000 for routine tasks | [estimated impact] |
| Autocompact threshold | [value, "not set", or "not observable from repo context"] | 80% | [estimated impact] |
| MCP servers active | [list or "not observable from repo context"] | Disable unused servers | [estimated impact] |

**Hooks:**
[List any hooks found and their token implications]
```

---

## 6. File Handling Patterns

**What to inspect:** How files are read and written across the repo's workflows.

**Step 6.1 — Identify large files in the repo**

Scan by both word count and line count, and include all human-readable file types (not just .md and .json):

```bash
find . -not -path "./.git/*" -not -path "*/node_modules/*" \( -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.csv" -o -name "*.yaml" -o -name "*.yml" \) -exec wc -w {} \; | sort -rn | head -20
find . -not -path "./.git/*" -not -path "*/node_modules/*" \( -name "*.md" -o -name "*.json" -o -name "*.txt" -o -name "*.csv" -o -name "*.yaml" -o -name "*.yml" \) -exec wc -l {} \; | sort -rn | head -20
```

Merge both lists (deduplicate). This catches both verbose files and dense files.

**Step 6.2 — Re-use the Read(pattern) deny-rule finding from Step 0.3**

The `Read(pattern)` deny-rule coverage check was performed in Step 0.3. Re-use that finding here. Do not re-run the check.

**What to assess:**

1. **Unignored large files.** Are there large files (>200 lines) that Claude Code might read during exploration but shouldn't? (Data files, logs, archives, generated content, prior reports, working notes from previous sessions.) Cross-reference against the covered-directories list from Step 0.3 — any large file in a directory NOT covered by a `Read(...)` deny rule is a finding.
2. **Output files in the repo.** Are outputs from previous sessions (reports, analyses, context packs, audit artifacts) sitting in the repo where Claude Code might read them unnecessarily? Check whether their parent directory is covered by a `Read(...)` deny rule.
3. **Workspace hygiene.** Identify temporary, draft, or deprecated files using these markers: filename contains `draft`, `tmp`, `old`, `deprecated`, `archive`, or dated variants (e.g., `v1`, `2024-`); file is in a folder named `archive`, `deprecated`, or `old`; file contains explicit deprecation labels; or a clearly superseding version exists in the repo.

**Classification rule for "Should Claude read this?":**

- **Yes** = canonical instructions, active workflows, live skills, active commands, configuration files
- **No** = archives, generated outputs, logs, drafts, superseded documents, prior reports, bulk reference material not needed for routine task execution

**Severity classification:**

- No `Read(...)` deny rules at all (from Step 0.3) → HIGH
- Missing `Read(...)` deny coverage for >2 expected directories → MEDIUM
- Large data/output files in directories not covered by a `Read(...)` deny → MEDIUM per directory
- Deprecated/temporary files cluttering the repo → LOW

**Report format:**

```markdown
### 6. File Handling Patterns

**Read(pattern) deny-rule status (from Step 0.3):** [HIGH / MEDIUM / PASS]
Covered directories: [list]
Missing expected coverage: [list]

**Large files in repo (top 20 by word count + line count, merged):**

| File | Words | Should Claude read this? | Parent dir covered by Read() deny? |
|------|-------|--------------------------|-----------------------------------|

**Recommendations:**
| # | Finding | Severity | Recommendation |
|---|---------|----------|----------------|
```

---

## 7. Missing Safeguards

**What to inspect:** The repo as a whole, looking for protective mechanisms that should exist but don't.

**Checklist — check each item and report as Present / Partial / Absent:**

- **Present** = fully implemented and clearly documented
- **Partial** = some version exists but incomplete, inconsistent, or not enforced
- **Absent** = not found anywhere in the repo

When checking for specific commands (e.g., `/context`, `/cost`, `/effort`), equivalent behavioral guidance counts even if the literal command name is absent.

| Safeguard | How to check | Status |
| --- | --- | --- |
| `Read(pattern)` deny rules in `.claude/settings.json` covering stale/large directories | Re-use Step 0.3 finding (HIGH=Absent, MEDIUM=Partial, PASS=Present) |  |
| Custom compaction instructions in CLAUDE.md | `grep -i "compact" CLAUDE.md` |  |
| Subagent output-to-disk pattern (vs. returning full output to main session) | Check workflow/skill instructions for "write to file" or "return summary" patterns |  |
| Context window monitoring instructions | Check CLAUDE.md for any mention of `/context`, `/cost`, context limits, or equivalent guidance |  |
| Session boundaries defined for workflows | Check whether workflows specify when to `/clear` or start new sessions |  |
| Model selection guidance | Check CLAUDE.md and skills for model switching rules |  |
| File read scoping (e.g., "read lines X-Y" vs. "read entire file") | Check skill instructions for file read patterns |  |
| Output length constraints | Check skills for instructions limiting output verbosity |  |
| Effort level guidance | Check for any `/effort` configuration or equivalent instructions |  |
| Hook-based output truncation | Check for hooks that cap tool output size |  |
| Audit/output artifact isolation | Check whether generated outputs (reports, working notes, audit files) are stored in a dedicated folder covered by a `Read(...)` deny rule, or are placed in the repo root where future sessions may accidentally read them |  |

**Report format:**

```markdown
### 7. Missing Safeguards

| Safeguard | Status (Present/Partial/Absent) | Severity if missing | Recommendation |
|-----------|-------------------------------|---------------------|----------------|
| Read(pattern) deny rules | [Present/Partial/Absent] | HIGH | [action] |
| Custom compaction instructions | [Present/Partial/Absent] | MEDIUM | [action] |
| ... | | | |
```

---

## 8. Best Practices Comparison

**What to do:** Compare the repo's current configuration against the April 2026 best practices listed below. For each practice, assess whether the repo implements it, partially implements it, or doesn't implement it at all.

**Current best practices (April 2026):**

1. **CLAUDE.md under 200 lines.** Move specialized instructions to skills. Only include what applies to every session.
2. **`Read(pattern)` deny rules configured in `.claude/settings.json`.** Exclude build artifacts, data files, logs, and anything Claude doesn't need. Well-configured deny rules can reduce per-request context by 40–70%.
3. **Skills use on-demand loading.** Skill content stays dormant until invoked. The skill list (names + descriptions) loads at session start, but full content only loads when matched. Description quality matters — vague descriptions cause either missed triggers or unnecessary exploration.
4. **Subagents for heavy reads.** Anything requiring reading more than 3–4 large files should be delegated to a subagent. Subagent results should be written to disk, not returned in full to the main session.
5. **Strategic `/compact` at breakpoints.** Compact at natural task boundaries, not just when auto-compaction triggers. Custom compaction instructions preserve what matters.
6. **`/clear` between unrelated tasks.** Stale context from a previous task compounds cost on every subsequent message.
7. **Model selection per task type.** Sonnet for ~80% of tasks. Opus for complex reasoning, architecture decisions. Haiku for mechanical subagent work. The `opusplan` mode (plan with Opus, execute with Sonnet) is a strong default for planning-heavy sessions.
8. **Extended thinking budget controlled.** `MAX_THINKING_TOKENS` set to 10,000 for routine tasks; higher only for complex reasoning. Default budget can be tens of thousands of tokens per request.
9. **Unused MCP servers disabled.** Each enabled MCP server adds tool definitions to context on every request.
10. **Output-to-disk pattern for subagents.** Subagents write full output to files; return only file path + one-sentence summary to main session.
11. **Precise prompts over vague ones.** "Fix the JWT validation in src/auth/validate.ts line 42" is dramatically cheaper than "fix the auth bug." *(Structural assessment only — assess based on any prompt guidance found in CLAUDE.md, skills, or workflow docs. No systematic evidence collection in earlier sections.)*
12. **Session notes pattern.** At session end, summarize key decisions and next steps to a file. Start next session by loading that file instead of relying on conversation history or memory. *(Structural assessment only — assess based on any session handoff patterns found in CLAUDE.md or workflow docs.)*

**Note:** Section 8 status ratings are descriptive (what is/isn't implemented). Section 9 priority rankings must be based on estimated token savings and risk, not simply on implementation status. A practice can be "not implemented" but low-priority if its impact in this repo is small.

**Report format:**

```markdown
### 8. Best Practices Comparison

| # | Practice | Status | Gap description | Priority |
|---|----------|--------|-----------------|----------|
| 1 | CLAUDE.md under 200 lines | [Implemented / Partial / Not implemented] | [details] | [HIGH/MEDIUM/LOW] |
| 2 | Read(pattern) deny rules configured | ... | ... | ... |
```

---

## 9. Compile the Optimization Plan

**What to do:** Synthesize all findings from Sections 1–8 into a prioritized optimization plan. This is the final deliverable.

**Structure the plan as follows:**

### 9.1 — Executive Summary

2–3 paragraphs: What the audit found, what the biggest token drains are, and what the estimated total impact of implementing all recommendations would be.

### 9.2 — Prioritized Recommendations

Rank all recommendations from all sections by estimated savings impact (HIGH → MEDIUM → LOW). Within each tier, put quick wins first.

**Estimated savings tier definitions:**

- **HIGH** = affects every session or imposes a large per-session cost (>1,000 tokens per turn, or >10,000 tokens per session in unnecessary loading/output)
- **MEDIUM** = affects specific workflows or imposes moderate cost (500–1,000 tokens per turn, or 3,000–10,000 tokens per session)
- **LOW** = occasional occurrence or small per-instance cost (<500 tokens per turn)

When estimating, consider: how frequently the waste occurs (every turn vs. once per session vs. occasionally), how large the waste is per occurrence, and how avoidable it is with a reasonable fix.

Each recommendation must follow this schema:

| Field | Content |
| --- | --- |
| **Issue** | What the problem is |
| **Evidence** | What was observed in the repo (file, workflow, pattern) — cite specific files and line counts |
| **Waste mechanism** | How this causes token waste (unnecessary reads, verbose output, drift-induced rework, etc.) |
| **Estimated savings** | HIGH / MEDIUM / LOW with brief rationale |
| **Implementation steps** | Specific actions Claude Code can execute — exact commands, file edits, or configuration changes |
| **Risk** | What could break if implemented incorrectly |
| **Dependencies** | Other recommendations this depends on or conflicts with |
| **Category** | Quick win (implement immediately, low risk) / Structural change (requires design work) |

### 9.3 — Safeguard Proposals

Concrete mechanisms to prevent waste recurrence. Each must be implementable — not general advice. For each safeguard, specify exactly what to create/configure and where.

### 9.4 — Implications for Future Opus 4.7 Upgrade

Brief section (3–5 bullet points max) noting which optimizations are prerequisites for or will interact with a potential Opus 4.7 migration. Do not design the migration — just flag the dependencies.

### 9.5 — Assumptions and Gaps

List any findings that rely on assumptions from the context pack (see the Assumptions section in the context pack) and any unknowns that the audit could not resolve. Be honest about what you could not measure vs. what you observed directly.

---

## 10. Self-Assessment

At the end of the audit, record:

1. **Audit token cost.** If `/cost` is available, run it again and calculate how many tokens this audit session consumed. If `/cost` is unavailable, note that and skip. When available, this is a useful reference for calibrating future investigation costs.
2. **Protocol gaps.** Note anything in this protocol that was unclear, missing, or that you had to improvise around. This feedback helps improve the protocol for future audits.
3. **Confidence level.** For each major section, rate your confidence in the findings using these definitions:
    - **HIGH** = based on direct file/config evidence that you read and measured
    - **MEDIUM** = structurally inferred from multiple repo signals (e.g., file sizes, naming patterns, cross-references) but not directly observed in execution
    - **LOW** = sparse or indirect evidence only; estimate based on limited data
4. **Threshold-boundary findings.** List any findings that fell within ±15% of a severity-classification threshold (per the token-estimation caveat in the header). These are low-confidence and may flip classification under a real tokenizer.

---

## Execution Notes

**Subagent delegation:** You should delegate heavy-read sections to subagents to keep the main session context clean. Recommended delegation pattern:

- **Section 2 (skill census):** Delegate the batch measurement + deep reads of oversized skills to a subagent. The subagent runs the measurement commands, reads the flagged files, and writes two files: a full findings file (`audit-working-notes-skills.md`) and a short summary file (`audit-summary-skills.md`, max 30 lines). Return only the summary file path and a one-line confirmation to the main session. The main session reads only the summary file to compile the report section. Read the full notes file only if the summary raises a discrepancy that needs deeper review.
- **Section 4 (workflow audit):** Delegate each workflow's file-read mapping to a separate subagent. Each writes a full notes file (`audit-working-notes-workflow-[name].md`) and a summary file (`audit-summary-workflow-[name].md`, max 20 lines). Main session reads summaries only.
- **Section 5 (session patterns — conditional):** Run inline by default. If at workspace scope and more than 3 `session-usage-analyzer` log files are discovered in Step 0.2, delegate to a subagent per the Workspace-scope note at the start of Section 5.
- **Section 6 (file handling):** Delegate the large-file scan to a subagent if the repo has many files. Same two-file pattern.
- **General rule:** Any task that requires reading more than 3–4 files should go to a subagent. Subagents always write both a full notes file and a short summary file to disk. The main session reads only the summary. Do not return full findings into the main session context.

**Token budget for this audit:** This protocol is designed to be executable in a single extended session with subagent delegation for heavy sections. The main token risks are:

- Section 2 (skill census) — mitigated by subagent delegation + batch measurement + selective deep reads
- Section 4 (workflow audit) — mitigated by per-workflow subagent delegation

**If you hit context limits mid-audit:** The incremental report-writing approach (building the audit report file as you go) ensures partial results are preserved. If you need to continue in a new session, the working notes files and partial report provide handoff context.

**Priority order if time/tokens are limited:** If you cannot complete all sections, prioritize in this order:

1. Section 1 (CLAUDE.md) — highest per-turn impact
2. Section 6 (file handling) + Section 7 (missing safeguards) — quick, high-value
3. Section 2 (skill census) — batch measurements first, deep reads if budget allows
4. Section 5 (configuration) — quick checks
5. Section 3 (command files) — moderate value
6. Section 4 (workflow audit) — most token-intensive to investigate. **Minimum fallback:** if constrained, audit at least the top 2 workflows by reference frequency and mark the section as partial.
7. Section 8 (best practices) — synthesis of above
8. Section 9 (optimization plan) — final assembly

**Critical constraint from the context pack:** "Don't burn excessive tokens investigating token waste." Follow the batch-then-selective-deep-read pattern throughout. Measure first, read deeply only where measurements indicate a problem.
