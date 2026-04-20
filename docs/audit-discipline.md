# Applying Audit Recommendations

> **When to read this file:** Before applying a permission change, model-default change, or frontmatter change derived from an audit (`/token-audit`, `/repo-dd`, `/audit-repo`, `/audit-claude-md`, or similar).

Audits produce recommendations based on static file counts, structural patterns, and reference-spec comparison. They do not model runtime command behavior. Recommendations are not specs — applying them verbatim can silently break live workflows.

Before applying a permission change (`permissions.allow` / `permissions.deny`), model-default change, or frontmatter change derived from an audit:

1. List the top-3 commands most affected by the change (command names + the paths they routinely Read or invoke).
2. For each listed command, confirm that the planned change does not block or degrade its normal behavior. Evidence: inspect the command body, or run the command once in a smoke-test session if behavior is unclear.
3. If a conflict surfaces, narrow the change to preserve the command's behavior and note the narrowing in the commit message.

This is a bright-line rule — do not skip even when the audit tags a recommendation as "quick win" or "low risk." The friction of checking is low; the cost of silently breaking an active command is high.
