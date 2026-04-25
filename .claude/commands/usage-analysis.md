# Usage Analysis

Analyze this session's token efficiency and append a review to the usage log.

## Step 1: Build the Session Summary

Scan the full conversation history in this session and produce a structured summary:

- **Task:** What was the main work done this session? (1-2 sentences)
- **Date:** Today's date (YYYY-MM-DD)
- **Approximate exchanges:** Count the human→Claude turns
- **Files read:** List every file that was read (via Read, cat, view, or any file-reading tool), with approximate line count. Flag any file read more than once.
- **Files written or edited:** List files created or modified
- **Tool calls:** List tools used and rough count (e.g., "Read x7, Edit x3, Bash x4")
- **Subagents:** Were any spawned? What did they do? For each subagent, note whether the main agent then re-output the subagent's content into a separate artifact (e.g., the main agent writes a verdict file with the same content the subagent already returned in its tool result) — this duplication is load-bearing for the savings estimate.
- **Largest files read:** For the 3 largest files read this session, record the approximate line count (or rough token estimate). This grounds the savings estimate for re-read and full-vs-partial-read recommendations.
- **Rework instances:** Any cases where output was produced, rejected or corrected, then redone?
- **Notable patterns:** Anything else relevant — long outputs, repeated operations, large context loads

## Step 2: Read the Existing Usage Log

Read `logs/usage-log.md` if it exists. This gives the subagent historical context for pattern detection.

If the file doesn't exist, note that this is the first review.

## Step 3: Delegate to Subagent

Read the skill file at `ai-resources/skills/session-usage-analyzer/SKILL.md`. Then launch a subagent, passing the skill content (not the file path), the session summary, and the log contents.

Instruct the subagent:

> You are analyzing a Claude Code session for token efficiency. Follow the skill instructions below to produce a single new log entry. Return ONLY the log entry markdown — no preamble, no explanation.

The subagent receives content only — it does not read files itself.

## Step 4: Write the Entry

Take the subagent's output and:

1. **Print the chat-only preamble first.** One or two lines max, summarizing the primary Recommendation and the top-ranked Additional lever with their rough savings figures. This gives the operator the headline immediately, before any file-write narration. The preamble appears in chat only; do NOT write it into the log file.

2. **Write to the log.** If `logs/usage-log.md` doesn't exist, create it with this header:

```markdown
# Usage Log

Token efficiency tracking. Each entry records one session's resource usage and waste patterns.

**Ratings:** Efficient | Acceptable | Wasteful

<!-- entries below -->
```

Then add the entry below the `<!-- entries below -->` marker. If the file already exists, insert the new entry directly below the `<!-- entries below -->` marker (above all existing entries).

3. **Confirm and print the full entry.** Say "Usage analysis added to logs/usage-log.md" and print the full entry below the confirmation.

## Step 5: Check Log Length

Count `###` headings in the log (excluding TREND entries). If more than 25, re-invoke the subagent with `MAINTENANCE: true` and the full log contents, then follow the maintenance routine in the skill file.