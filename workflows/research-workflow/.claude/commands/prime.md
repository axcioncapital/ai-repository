Orient the session. Read state, brief the operator, wait for direction.

1. Read the last entry from `/logs/session-notes.md`. This is the primary state source — it contains stage, next steps, and blockers from the previous session's `/wrap-session`.
2. Read the most recent checkpoint file in any `checkpoints/` directory (preparation, execution, analysis, report, final). If none exists, skip.
3. If the session note flags blockers, FAIL verdicts, or pending operator actions — read the specific file referenced to confirm it is still unresolved.
4. Output this and nothing else:

```
## Prime — {date}

**Section:** {id}  |  **Stage/Step:** {stage} — {step}
**Last session:** {date} — {one-line}

**Blockers:** {list or "None"}
**Ready:** {what Claude can do now}
**Next:** `/{command}` — {why}
```

5. Do NOT execute any pipeline command. Wait for operator direction.
