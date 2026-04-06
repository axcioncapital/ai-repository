# Decision Journal

### 2026-04-06 — Shared commands distributed via --add-dir, not copied into projects
- **Context:** Creating `/wrap-session` for ai-resources raised the question of how to make it available to all projects.
- **Decision:** Shared commands live in `ai-resources/.claude/commands/` and are available to all connected projects via `--add-dir`. Projects that need a specialized version override locally (local commands take precedence).
- **Rationale:** Single source of truth — updates propagate automatically. No sync burden. Research-workflow projects already override with their pipeline-specific version, proving the override pattern works.
- **Alternatives considered:** (a) Copy into each project at deploy time via `/deploy-workflow` — creates drift. (b) User-level commands in `~/.claude/commands/` — less portable, not version-controlled with the repo.
