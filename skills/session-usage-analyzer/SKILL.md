---
name: session-usage-analyzer
description: >
  Analyzes a Claude Code session summary for token efficiency and produces a
  structured log entry for the project's usage/usage-log.md. Invoked as a
  subagent by the calling session's wrap-up routine — receives a structured
  session summary and existing log contents, returns ONLY a formatted log entry.
  Do NOT invoke interactively or use for mid-session optimization. This is a
  post-session review tool.
---

## Role

Subagent evaluator. You receive a structured session summary and the current usage log from the calling agent. Analyze the session for token efficiency, identify waste patterns, and return a single log entry in the exact format specified below. No preamble, no commentary, no suggestions outside the entry.

## Input Requirements

The calling agent provides two inputs:

| Input | Required | Description |
|-------|----------|-------------|
| Session summary | Yes | Structured fields listed in the schema below |
| Usage log contents | Yes | Full text of `usage/usage-log.md`, or the string `NEW LOG` if the file does not exist |

If the session summary is missing required fields, write `not reported` in the corresponding metric row. Do not infer or estimate missing data.

## Session Summary Schema

The calling agent builds this summary by scanning the conversation history before invoking the subagent.

| Field | Description |
|-------|-------------|
| **Task** | Main work done this session (1-2 sentences) |
| **Date** | Session date (YYYY-MM-DD) |
| **Approximate exchanges** | Count of human-to-Claude turns |
| **Files read** | Every file read via any tool, with approximate line count. Flag any file read more than once |
| **Files written or edited** | Files created or modified |
| **Tool calls** | Tools used with rough counts (e.g., "Read x7, Edit x3, Bash x4") |
| **Subagents** | Count and brief description of each subagent spawned |
| **Rework instances** | Cases where output was produced, then rejected or corrected and redone |
| **Notable patterns** | Anything else relevant — long outputs, repeated operations, large context loads |

## Efficiency Analysis Framework

Evaluate the session against five waste categories. For each, check the signals against the session summary and classify severity.

| Category | Signals | Severity Logic | Recommendation Template |
|----------|---------|----------------|------------------------|
| **Re-reads** | Same file read 2+ times without edits between reads | Moderate if 2x; Major if 3x+ or file >500 lines | "File X read N times — pin content or extract needed sections on first read" |
| **Rework** | Output produced then rejected, corrected, or redone | Moderate if 1 cycle; Major if >1 cycle on same artifact | "Artifact X required N rework cycles — clarify spec upfront or use outline-first approach" |
| **Context bloat** | Large files read in full when partial read would suffice; files read but never referenced in output | Minor if 1 file; Moderate if 2-3; Major if >3 or unreferenced reads exceed 50% of total | "N files read but unused in output — validate need before reading" |
| **Tool overhead** | Repeated tool calls that could be batched; tool calls producing unused output; wrong tool for the job | Minor if 1-2 wasted calls; Moderate if 3-5; Major if >5 | "N tool calls produced unused results — batch operations or select correct tool" |
| **Missed parallelization** | Sequential subagent launches or tool calls that had no dependency between them | Minor — informational only | "N independent operations ran sequentially — parallelize where possible" |

### Overall Efficiency Rating

| Rating | Criteria |
|--------|----------|
| **Efficient** | 0 moderate or major findings |
| **Acceptable** | 1-2 moderate findings, 0 major |
| **Wasteful** | Any major finding OR 3+ moderate findings |

When the usage log contains previous entries, briefly note whether this session's rating represents improvement, regression, or stability compared to the last 3 entries. One sentence max, included in the Findings section.

## Output Format

Return exactly this template, filled in. No deviations.

```markdown
### {YYYY-MM-DD} — {HH:MM} | {Rating}

**Task:** {1-2 sentence summary}

| Metric | Value |
|--------|-------|
| Exchanges | {N} |
| Files read | {N} (re-reads: {N}) |
| Files written/edited | {N} |
| Tool calls | {N total} |
| Subagents | {N} |
| Rework cycles | {N} |

**Findings:**
{Bulleted list of observed waste patterns using the recommendation templates above. Include category name and severity in parentheses. If no findings: "None — session was efficient."}

**Recommendation:** {Single most impactful recommendation from findings. If Efficient: "No action needed."}

---
```

## Calling Agent Protocol

These instructions are for the main session agent that orchestrates the analysis. The subagent does not execute these steps.

### Building the Session Summary

1. Scan the full conversation history
2. For each field in the Session Summary Schema, extract the data
3. For files read: check whether the same file was read multiple times and whether edits occurred between reads
4. For rework: identify cases where you produced output that was subsequently rejected or required correction
5. Structure the summary as a labeled list matching the schema fields

### Invoking the Subagent

1. Read `usage/usage-log.md` from the project directory. If it does not exist, use the string `NEW LOG`
2. Read this skill file
3. Launch a subagent, passing: this skill's content, the session summary, and the log contents
4. Instruct the subagent: "Follow the skill instructions to produce a single new log entry. Return ONLY the log entry markdown."

### Writing the Entry

1. If `NEW LOG`: create `usage/usage-log.md` with the standard header (below), then append the entry after the header separator
2. If existing log: insert the new entry directly below the `---` separator that follows the file header (above all existing entries)
3. Confirm to the operator: "Usage analysis added to usage/usage-log.md" and print the entry

### Log File Header

Use this header when creating a new log file:

```markdown
# Usage Log

Token efficiency tracking. Each entry records one session's resource usage and waste patterns.

**Ratings:** Efficient | Acceptable | Wasteful

---
```

### Checking Entry Count

After writing, count the `###` headings in the log (excluding TREND entries). If >25, trigger the maintenance routine.

## Maintenance Routine

When the log exceeds 25 session entries, the calling agent re-invokes the subagent with the full log contents and the flag `MAINTENANCE: true`.

The subagent then:

1. Identify the oldest 15 non-TREND entries (by date)
2. Produce a **Trend Summary** entry:

```markdown
### TREND — {start date} to {end date}

| Rating | Count |
|--------|-------|
| Efficient | {N} |
| Acceptable | {N} |
| Wasteful | {N} |

**Dominant pattern:** {most common waste category across the 15 entries}
**Trend direction:** {Improving / Stable / Worsening} — {1 sentence evidence}
**Top recommendation:** {the single recommendation that appeared most frequently}

---
```

3. Return two blocks:
   - The trend summary entry (to insert at the top of the log after the header)
   - A list of the 15 date-stamps to archive

The calling agent then:
- Inserts the trend summary below the header separator
- Moves the 15 archived entries to `usage/archive/{YYYY-MM}.md` (grouped by month)
- Creates the archive directory if it does not exist

## Guardrails

- Do not invent metrics absent from the session summary. Missing data → `not reported`.
- Do not soften findings. If waste occurred, name it plainly with the category and severity.
- Do not add recommendations beyond the single most impactful one. Operators scan these logs — brevity is the priority.
- Do not comment on the quality of the session's output — only on token efficiency.
- Do not reference specific file contents or sensitive data in findings — refer to files by name only.

### Self-Check Before Returning

1. Does the entry match the output template exactly (all rows, all sections)?
2. Is the efficiency rating consistent with the finding severities?
3. Is there exactly one recommendation (or "No action needed" if Efficient)?
4. If previous entries exist, did you include the trend comparison sentence?
