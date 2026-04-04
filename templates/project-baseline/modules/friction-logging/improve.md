Run an improvement analysis on recent workflow friction.

1. Read `/logs/friction-log.md` and identify the most recent session block.
2. Read `/logs/workflow-observations.md` for any related observations.
3. Analyze friction events for patterns:
   - Repeated friction in the same area
   - Friction that could be eliminated by automation (hooks, commands)
   - Friction caused by missing information or unclear instructions
4. Present findings ranked by impact:
   - **Category:** (tooling, process, context, unclear instructions)
   - **Friction source:** What caused it
   - **Root cause:** Why it happened
   - **Proposal:** Concrete fix with effort estimate (trivial / small / medium)
   - **Recurrence:** First time or repeat pattern
5. Ask {{OPERATOR_NAME}} which proposals to apply, log, or skip.
6. Apply approved fixes and log the changes to `/logs/workflow-observations.md`.
