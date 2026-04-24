# Critical Resources Manifest

# Resources the operator has designated as critical. Audited by /audit-critical-resources.
# Parse rules (from .claude/commands/audit-critical-resources.md):
#   - Blank lines and lines starting with `#` or `>` are skipped
#   - Leading/trailing whitespace trimmed; leading `- ` bullet stripped
#   - Paths may be relative to ai-resources/ or absolute
#   - Unresolvable paths abort the audit (no silent skip)

# === Commands (12) ===

.claude/commands/prime.md
.claude/commands/wrap-session.md
.claude/commands/create-skill.md
.claude/commands/improve-skill.md
.claude/commands/friday-checkup.md
.claude/commands/friction-log.md
.claude/commands/qc-pass.md
.claude/commands/refinement-pass.md
.claude/commands/cleanup-worktree.md
.claude/commands/repo-dd.md
.claude/commands/new-project.md
.claude/commands/token-audit.md

# === Skills directly referenced by the above commands (3) ===

skills/session-usage-analyzer/SKILL.md          # used by /wrap-session
skills/ai-resource-builder/SKILL.md             # used by /create-skill and /improve-skill
skills/worktree-cleanup-investigator/SKILL.md   # used by /cleanup-worktree
