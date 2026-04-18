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

5. After the status block, prompt for a session contract:

   > **What are we working on?**
   > And two quick declarations:
   > 1. **Exit condition** — "This session is done when ___." (e.g., "done when 2.5 draft passes QC")
   > 2. **Autonomy level** — What should I auto-proceed on vs. pause for? (e.g., "Auto-apply non-bright-line QC fixes. Pause on bright-line items.")

   If the operator skips the declarations, proceed without them — don't nag. But if provided,
   hold to the exit condition and autonomy level throughout the session. If scope shifts
   mid-session, flag that the exit condition may need updating.

6. Do NOT execute any pipeline command. Wait for operator direction.
