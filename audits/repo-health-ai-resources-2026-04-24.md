# Workspace Health Report

**Date:** 2026-04-24
**Mode:** Full Audit
**Overall:** GREEN

---

## Executive Summary

The `ai-resources/` workspace is in strong health across all 7 audit areas. Zero Critical and zero Important findings — only 11 Minor improvement opportunities, none of which block daily work. The highest-ROI action is a 2-minute cleanup of 4 byte-identical command drift files in `workflows/research-workflow/.claude/commands/` (note, qc-pass, refinement-pass, update-claude-md): delete them so `auto-sync-shared.sh` can recreate them as symlinks, which will also close a latent staleness risk where future ai-resources updates silently skip those copies.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | GREEN | 0 | 0 | 3 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | GREEN | 0 | 0 | 2 |
| 2026 Best Practices | GREEN | 0 | 0 | 1 |
| Context Health | GREEN | 0 | 0 | 4 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

No important findings.

### Improvement Opportunities

- **[Skill Inventory] 8 skills lack explicit trigger phrases in description**
  Descriptions on these skills do not contain any of: "use when", "trigger", "run when", "invoke when", "when you", "when to" (case-insensitive). Skills: architecture-qc, decision-to-prose-writer, formatting-qc, knowledge-file-completeness-qc, report-compliance-qc, research-prompt-qc, session-usage-analyzer, workflow-system-critic.
  *Location:* `ai-resources/skills/*/SKILL.md` (frontmatter description)
  *Recommendation:* When editing these skills, add a `Use when:` or `TRIGGER when:` clause in the description to aid automated routing.

- **[Skill Inventory] 6 skills lack explicit exclusion phrases in description**
  Descriptions on these skills do not contain any of: "do not", "don't", "not for", "never", "avoid", "exclude". Skills: analysis-pass-memo-review, editorial-recommendations-generator, workflow-consultant, workflow-creator, workflow-documenter, workspace-template-extractor.
  *Location:* `ai-resources/skills/*/SKILL.md` (frontmatter description)
  *Recommendation:* When editing these skills, add a `SKIP when:` or `Do not use for:` clause.

- **[Skill Inventory] 6 skills exceed 300 lines**
  answer-spec-generator (485), research-plan-creator (464), ai-resource-builder (401), evidence-to-report-writer (332), workflow-evaluator (316), ai-prose-decontamination (314). None exceed 500 lines.
  *Location:* `ai-resources/skills/{answer-spec-generator,research-plan-creator,ai-resource-builder,evidence-to-report-writer,workflow-evaluator,ai-prose-decontamination}/SKILL.md`
  *Recommendation:* Consider splitting repeated procedural detail into `references/` subfiles. Tuning opportunity, not a defect.

- **[Commands & Subagents] 4 project-scope command files are byte-identical drift**
  The project copies under `workflows/research-workflow/.claude/commands/` match the `ai-resources/.claude/commands/` source byte-for-byte. The shared-manifest.json declares them under `commands.shared` (should be symlinks auto-synced by `auto-sync-shared.sh`), but they exist as real files and block the hook (which skips targets that already exist). Files: `note.md`, `qc-pass.md`, `refinement-pass.md`, `update-claude-md.md`.
  *Location:* `workflows/research-workflow/.claude/commands/{note,qc-pass,refinement-pass,update-claude-md}.md`
  *Recommendation:* Delete each drift copy; next SessionStart hook will recreate as symlinks. (Alternatively: `rm <file> && ln -s ../../../../.claude/commands/<name>.md <file>` for each.)

- **[Settings & Permissions] Hardcoded absolute path in root settings.json permissions**
  Root `.claude/settings.json` lines 13-14 use the full absolute workspace path in Edit/Write allow patterns. If the workspace moves, these rules silently stop matching.
  *Location:* `.claude/settings.json:13-14`
  *Recommendation:* Replace absolute-path entries with relative globs (lines 15-34 already cover subdirectories with relative globs), or accept as deliberate broad allow.

- **[Settings & Permissions] deny rule references non-existent archive/ directory**
  Both settings.json files contain `deny: Read(archive/**)`. Directory does not exist. Likely defensive.
  *Location:* `.claude/settings.json`, `workflows/research-workflow/.claude/settings.json`
  *Recommendation:* Either create `archive/` or delete the deny rule. Leaving as-is is also acceptable.

- **[2026 Best Practices] High skill-to-command ratio (69:61)**
  Substantial skill coverage; many skills are internally invoked by pipeline commands rather than exposed as slash commands. Noted as maturity signal, not a defect.
  *Location:* `ai-resources/skills/` vs `ai-resources/.claude/commands/` + `workflows/*/.claude/commands/`
  *Recommendation:* No action. Re-check annually: if new skills land without routing exposure, consider whether skill-library design is outpacing invocation surface.

- **[Context Health] Recent high-impact change: .claude/settings.json modified**
  Commits `4f22f2c` (broad Edit/Write allow) and `d456c20` (friday-checkup SessionStart hook). Hook script present and executable; JSON parses.
  *Location:* `.claude/settings.json`
  *Recommendation:* Spot-check: confirm Friday reminder fires on next Friday session; confirm broader Edit/Write allow is intentional (duplicates earlier narrower rules — simplification candidate).

- **[Context Health] Recent high-impact change: 4 skills updated with new-project Stage 2 removal**
  Commit `692531c` deleted `pipeline-stage-2.md` and `pipeline-stage-2-5.md` agents, updated architecture-designer, implementation-project-planner, implementation-spec-writer, spec-writer SKILL.md, and new-project.md command. No lingering references to deleted agents outside logs/audits.
  *Location:* `.claude/commands/new-project.md`, 4 skill SKILL.md files
  *Recommendation:* Run `/new-project` end-to-end on a throwaway project to confirm reworked Stage 2 path.

- **[Context Health] Recent high-impact change: /summary skill newly added**
  Commits `9f62fe6` and `7463f44` added `skills/summary/SKILL.md` and `.claude/commands/summary.md`.
  *Location:* `.claude/commands/summary.md`, `skills/summary/SKILL.md`
  *Recommendation:* Informational — new skill, expected volatility for first few uses.

- **[Context Health] Recent high-impact change: session-guide-generator rewrite**
  Commit `b0ec8aa` rewrote the agent, skill, and command together. session-guide-generator is deliberately excluded from auto-sync per baked-in hook exclusions.
  *Location:* `.claude/agents/session-guide-generator.md`, `skills/session-guide-generator/SKILL.md`, `.claude/commands/session-guide.md`
  *Recommendation:* Informational — spot-check next `/session-guide` run confirms state-aware view renders as intended.

## Detailed Analysis

### File Organization

All expected directories present under ai-resources/: `CLAUDE.md`, `.claude/{commands,agents,hooks,settings.json}`, `skills/`, `workflows/`, `audits/`, `logs/`, `docs/`, `reports/`, `prompts/`, `scripts/`, `style-references/`, `inbox/`. All 69 skill folders are kebab-case and contain `SKILL.md`. `CATALOG.md` at `skills/` root is a file (not a folder) and not counted as orphaned. No symlinks currently exist inside the target tree.

**Key metrics:** 69 skill directories · 0 symlinks · 0 broken symlinks · 2 CLAUDE.md files.

### CLAUDE.md Health

| Path | Lines | Est. Tokens | Imports | Total w/ imports |
|------|------:|------------:|--------:|-----------------:|
| `CLAUDE.md` | 88 | ~1,137 | 0 | 88 |
| `workflows/research-workflow/CLAUDE.md` | 128 | ~1,813 | 4 | 506 |

Both well under the 200-line/4k-token Important threshold. research-workflow CLAUDE.md uses `@import` effectively (4 reference files, all resolve). No secrets detected. Both files have orientation sections. No contradictions between root and nested.

### Skill Inventory

- **Total:** 69 skills (all with SKILL.md + valid frontmatter: name + description)
- **Size:** average 204 lines; 6 over 300; 0 over 500
- **Orphans:** 0 (every skill name appears somewhere outside its own directory)
- **Overlap:** 0 pairs exceed 60% Jaccard similarity on description keywords; top pair is `execution-manifest-creator` × `research-prompt-creator` at 38.7%
- **Description quality:** 8 skills missing explicit trigger phrases; 6 missing exclusions (Minor items listed above)

### Commands & Subagents

- **Commands:** 61 total (34 in `ai-resources/.claude/commands/` + 27 in `workflows/research-workflow/.claude/commands/`)
- **Agents:** 24 total (20 in `ai-resources/.claude/agents/` + 4 in `workflows/research-workflow/.claude/agents/`) — all with complete frontmatter (name, description, tools, model)
- **Symlinks:** 0 (all materialized as real files)
- **Name collisions:** 9 basename collisions across scopes. 5 are intentional divergent overrides (audit-repo, friction-log, improve, prime, wrap-session — correctly listed under `commands.local` in shared-manifest.json). 4 are byte-identical drift (Minor finding above).
- **Dead references:** 0

### Settings & Permissions

Both `.claude/settings.json` files parse as valid JSON. Root settings has 44 allow entries, 1 deny, 3 hooks (PreToolUse, Stop, SessionStart). Research-workflow settings has 14 allow entries, 7 deny, 11 hooks across 5 event types. All 9 referenced hook scripts exist on disk and are executable:

- `check-heavy-tool.sh`, `check-stop-reminders.sh`, `friday-checkup-reminder.sh` (root)
- `friction-log-auto.sh`, `log-write-activity.sh`, `detect-innovation.sh` (workflow)
- `check-template-drift.sh`, `auto-sync-shared.sh`, `logs/scripts/check-archive.sh` (cross-referenced from workflow settings, all resolve)

### 2026 Best Practices

- `@import` pattern adopted in research-workflow CLAUDE.md
- Subagent isolation compliant (QC, analyst, auditor patterns all use fresh context)
- Context isolation compliant (e.g., audit-claude-md.md explicitly passes content not path)
- Filesystem-first verification: `git status`/`git diff` correctly *not* used for verification anywhere in commands/skills (the only operational use is in worktree-cleanup-investigator for classification, which is legitimate)
- Agent tiering: Haiku × 3 (mechanical), Sonnet × 8 (structured), Opus × 13 (judgment). All 24 agents declare model explicitly.
- Maturity signals: auto-sync hook, Friday-cadence hook, subagent summary contracts, error-driven CLAUDE.md evolution

### Context Health

- 25 skill backtick-refs in research-workflow reference files — all resolve
- 61 commands scanned — 0 dead skill/agent references in operational instructions
- 9 hook scripts referenced from settings — 100% resolve and executable
- Recent high-impact changes (last 10 commits): settings.json × 2, commands × 4, skills × 6, agents × 4 added/modified plus 2 agents deleted. All downstream references verified clean — in particular, the deleted `pipeline-stage-2.md` and `pipeline-stage-2-5.md` have zero lingering references outside logs/audits.

## Prioritized Recommendations

1. **Delete 4 drift command files in research-workflow** — `rm workflows/research-workflow/.claude/commands/{note,qc-pass,refinement-pass,update-claude-md}.md`. Next SessionStart hook recreates them as symlinks. Closes a latent staleness vector. Effort: L. Area: Commands.
2. **Smoke-test `/new-project` end-to-end** — Stage 2 removal is recent and touched 4 skills + 2 agent deletions; run once on a throwaway project to confirm nothing downstream broke. Effort: M. Area: Context.
3. **Replace absolute-path permission entries in root `settings.json`** — Swap lines 13-14 for relative globs or remove (narrower entries below already cover the space). Guards against future workspace relocation. Effort: L. Area: Settings.
4. **Add trigger/exclusion phrases to 14 skill descriptions** — Next time each of the 8 skills missing triggers or 6 missing exclusions gets edited, tack on a `Use when:` / `Do not use for:` clause. Batch by opportunity; not urgent. Effort: L each. Area: Skills.
5. **Decide on `archive/` directory** — Either create it (if planned) or delete the defensive `deny: Read(archive/**)` rule. Effort: L. Area: Settings.
6. **Consider reference-splitting for 3 largest skills** — answer-spec-generator (485), research-plan-creator (464), ai-resource-builder (401) are candidates for splitting procedural detail into `references/`. Tuning, not a defect. Effort: M each. Area: Skills.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
