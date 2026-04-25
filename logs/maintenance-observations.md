# Maintenance Observations

Per-Friday-Act session block, append-only. Each block captures:

- **Disposition summary** — counts across tactical / policy / architectural retrospective.
- **Deferred items** — tactical or policy items the operator dispositioned away from execution.
- **Policy proposals** — proposed CLAUDE.md / audit-discipline.md edits captured by `/friday-act` Step 4 (monthly+); not auto-applied — schedule a follow-up session per proposal.
- **Architectural retrospective notes** — operator's free-form response to the substrate questions (quarterly only).
- **Operator observations** — free-form repo-health / friction / coupling observations the audits didn't surface.
- **Autonomy-axis posture targets (week ahead)** — seven axes (Guardrails / Optimization / Autonomy / Capability / Reliability / Observability / Operator load), default `hold`; only changed targets carry a one-line rationale.

Distinct from `coaching-log.md`: this file is forward-looking weekly posture + observations from the cadence; `coaching-log.md` is backward-looking session-pattern ratings.

Distinct from `friction-log.md`: friction-log is per-session events; this file is per-Friday-Act meta-observations about repo health.

Schema is whatever `/friday-act` writes — see `.claude/commands/friday-act.md` Step 5–6 for the canonical block shape. Do not hand-edit prior session blocks.

---
