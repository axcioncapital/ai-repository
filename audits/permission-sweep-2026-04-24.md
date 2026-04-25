# Permission Sweep Report — 2026-04-24

## Summary

- Scanned **16 settings files** across 5 layers (user, workspace root, ai-resources, projects, workflows).
- Findings: 12 CRITICAL, 20 HIGH, 2 MEDIUM, 5 ADVISORY, 1 INTENTIONAL-NARROW.
- Applied: 32 fixes across 11 files. Deferred: 0. Skipped INTENTIONAL-NARROW: 1.

## Findings applied

| # | File | Rule | Severity | Change |
|---|------|------|----------|--------|
| 1 | projects/buy-side-service-plan/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 2 | projects/buy-side-service-plan/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 3 | projects/buy-side-service-plan/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 4 | projects/project-planning/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 5 | projects/project-planning/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 6 | projects/project-planning/.claude/settings.json | 4 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 7 | projects/project-planning/.claude/settings.json | 8 | HIGH | Added `additionalDirectories` |
| 8 | projects/obsidian-pe-kb/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 9 | projects/obsidian-pe-kb/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 10 | projects/obsidian-pe-kb/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 11 | projects/global-macro-analysis/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 12 | projects/global-macro-analysis/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 13 | projects/global-macro-analysis/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 14 | projects/corporate-identity/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 15 | projects/corporate-identity/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 16 | projects/corporate-identity/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 17 | projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 18 | projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 19 | projects/nordic-pe-landscape-mapping-4-26/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 20 | projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 21 | projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | 5 | CRITICAL | Replaced 2-entry allow with full canonical Layer D list |
| 22 | projects/nordic-pe-landscape-mapping-4-26/step-1-long-list/.claude/settings.json | 8 | HIGH | Added `additionalDirectories` |
| 23 | ai-resources/workflows/research-workflow/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 24 | ai-resources/workflows/research-workflow/.claude/settings.json | 6 | HIGH | Added `Bash(rm *)` to allow |
| 25 | ai-resources/workflows/research-workflow/.claude/settings.json | 4/3 | HIGH | Added `Edit(**/.claude/**)` and `Write(**/.claude/**)` |
| 26 | ai-resources/workflows/research-workflow/.claude/settings.json | 8 | HIGH | Added `additionalDirectories` |
| 27 | workflows/.claude/settings.local.json | 1 | CRITICAL | Added `defaultMode: bypassPermissions` |
| 28 | workflows/.claude/settings.local.json | 7 | HIGH | Changed deny `Bash(rm *)` → `Bash(rm -rf *)` |
| 29 | ~/.claude/settings.json | 2 | CRITICAL | Added `defaultMode: bypassPermissions` inside `permissions` |
| 30 | .claude/settings.json (workspace root) | 5 | CRITICAL | Added `Bash(*)` to allow |
| 31 | .claude/settings.json (workspace root) | 6 | HIGH | Added `Bash(rm *)` to allow |

## Findings deferred (not approved this run)

None — operator approved `apply all`.

## Intentional-narrow files (excluded)

- `projects/obsidian-pe-kb/vault/.claude/settings.json` — path-scoped allow+deny pairs for wiki/raw directories. Re-run with `--fix-narrow` to include.

## Advisory items (not applied — hygiene only)

- Finding 35: `corporate-identity/.claude/settings.json` tracked in git — intentional for `settings.json`; no fix needed
- Finding 36: `ai-resources/.claude/settings.json` — colon-form Bash entries; normalize manually if desired
- Finding 38: `buy-side-service-plan/.claude/settings.local.json` — model value contains `[1m]` terminal artifact; operator should verify

## Full diagnostic notes

`ai-resources/audits/working/permission-sweep-2026-04-24.md`

## Prevention

- `check-permission-sanity.sh` SessionStart hook flags the primary root cause on session start.
- `/new-project` pipeline emits the canonical template for every new project.
- `/friday-checkup` weekly rotation runs `/permission-sweep --dry-run` to catch drift.
