# Workflow System Critique: global-macro-analysis

**Date:** 2026-04-11
**Based on:** workflow-analysis-global-macro-analysis-2026-04-11.md
**Depth:** Deep

---

## Findings

### Critical (0)

No critical findings. All skill references resolve, all symlinks are valid, no broken hand-offs.

### Important (2)

### [Important] Hard Rules 3 and 5 lack enforcement beyond command text

- **Check:** Check 4: Rule Enforcement Gaps
- **Location:** CLAUDE.md Hard Rules 3 ("Atomic entry content is append-only") and 5 ("Scope enforcement on every command")
- **Evidence:** Rule Enforcement table (Section 5.3 of analysis) shows both rules as `command-referenced` only -- no hook enforcement. Hard Rule 3 is especially high-consequence: if an Edit or Write operation modifies entry content fields (Claims, Questions Raised, Personal Notes) after creation, the append-only invariant is silently broken. Hard Rule 5 (scope enforcement) is structural -- a single command writing outside its declared scope could corrupt the KB.
- **Impact:** With `Bash(*)`, `Write`, and `Edit` all permitted in settings.json and no hooks to guard theme folder writes, a single misrouted write (by Claude or operator) could violate the append-only invariant or the staging-only-writes rule without any runtime warning. The blast radius is high because the system's data integrity model depends on these rules.
- **Recommendation:** Add a PreToolUse hook on Write and Edit that warns (or blocks) when the target path is inside a theme folder and the active command is not `kb-review`. This would enforce Hard Rules 1 and 3 at the infrastructure level rather than relying purely on behavioral compliance.

### [Important] Hard Rules 6 and 7 are behavioral-only with no command reference

- **Check:** Check 4: Rule Enforcement Gaps
- **Location:** CLAUDE.md Hard Rules 6 ("Test with real-ish input before expanding") and 7 ("No automated extraction")
- **Evidence:** Rule Enforcement table (Section 5.3) shows both as `behavioral-only` -- no hook, no command reference. Rule 7 is particularly consequential: it prohibits building "claim databases, automated synthesis updates, or anything that removes Patrik from the judgment loop." This is the project's core design philosophy.
- **Impact:** Rule 6 is low-risk (it's a process guideline). Rule 7, however, defines the entire system's posture. If a future command or skill inadvertently automates extraction, there is no infrastructure gate to catch it. The risk is latent -- it matters most when the system grows or when new commands are added.
- **Recommendation:** For Rule 7, add a comment block at the top of each command that produces entries (kb-ingest, kb-populate) explicitly restating the no-automated-extraction constraint. This keeps the rule visible at the point of highest risk without requiring hook infrastructure.

### Medium (3)

### [Medium] Orphaned agent: execution-agent symlinked but never invoked

- **Check:** Check 5: Orphaned Components
- **Location:** `.claude/agents/execution-agent.md` (symlinked from ai-resources)
- **Evidence:** Section 1.2 Agent table shows execution-agent as "Not invoked by any deployed command." Section 7.3 Orphaned Components confirms: "Part of the shared agent library; used by the research-workflow pipeline, not the KB system."
- **Impact:** No runtime impact (the agent simply sits unused). Minor clutter in the agent directory. Could cause confusion if someone assumes it's part of the KB pipeline.
- **Recommendation:** No action required -- this is a shared infrastructure artifact present in all projects that include the ai-resources agent symlinks. Acceptable as-is. If the project ever trims its agent directory to project-relevant agents only, this would be the candidate to remove.

### [Medium] Permissions are maximally broad -- Bash(*) allows unrestricted shell access

- **Check:** Check 5: Settings Coverage
- **Location:** `.claude/settings.json`
- **Evidence:** Settings Entries table (Section 1.4) shows `Bash(*)` is allowed, with only three deny patterns: `git push*`, `rm -rf *`, `sudo *`. All other tools (Write, Edit, Agent, WebFetch, WebSearch, NotebookEdit, ToolSearch) are also allowed.
- **Impact:** The broad Bash permission means Claude can execute arbitrary shell commands. Combined with the lack of hooks, there are no guardrails against accidental destructive operations beyond the three explicit denials. For a knowledge base system where data integrity is paramount (append-only entries, staging-only writes), this is a gap.
- **Recommendation:** Consider narrowing Bash permissions to specific patterns needed by the KB commands (e.g., `Bash(ls *)`, `Bash(cat *)`, `Bash(find *)`, `Bash(wc *)`) rather than the blanket `Bash(*)`. Alternatively, add the hook recommended in the first Important finding to compensate.

### [Medium] COMMAND-ONLY gates: operator review points not documented in CLAUDE.md

- **Check:** Check 3: Document-System Drift
- **Location:** CLAUDE.md (no gate documentation), `.claude/commands/kb-ingest.md` (Step 6), `.claude/commands/kb-review.md` (Step 5)
- **Evidence:** Gates table (Section 5.2) shows two COMMAND-ONLY gates: "Operator confirm/edit/reject after ingest" and "Operator review corrections in kb-review." These gates exist in the commands but are not declared in CLAUDE.md's Hard Rules or Operational Notes.
- **Impact:** Low runtime risk (the gates work regardless of documentation). However, anyone reading CLAUDE.md to understand the system's review model won't see that operator gates exist at the ingest and review steps. This matters for onboarding and for ensuring the gates survive future command rewrites.
- **Recommendation:** Add an "Operator Gates" subsection to CLAUDE.md documenting: (1) kb-ingest pauses for operator confirm/edit/reject after staging, (2) kb-review pauses for operator correction review before filing. This makes the review model visible in the system's governing document.

### Low (1)

### [Low] Source registry filename inconsistency in session notes vs. filesystem

- **Check:** Check 7: Friction Correlation (Deep Only)
- **Location:** `logs/session-notes.md` (line 33), `macro-kb/_sources/registry.md`
- **Evidence:** Session notes from 2026-04-10 refer to the file as `source-registry.md` and `source-registry-template.md`. The actual file on disk is `registry.md`. CLAUDE.md's Key File Paths section correctly references `macro-kb/_sources/registry.md`. The commands (kb-registry-query, kb-gap-audit, kb-triage-stats) all reference `_sources/registry.md`.
- **Impact:** No runtime impact -- the commands reference the correct filename. The session notes are historical and not consumed by any command. Could cause confusion if someone uses session notes to locate files manually.
- **Recommendation:** No action needed. The authoritative references (CLAUDE.md, commands) are correct. This is a documentation-only inconsistency in historical session notes.

---

## Deep Assessment

### Friction Correlation (Check 7)

No friction logs found at `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/global-macro-analysis/logs/`. The project has `session-notes.md` and `decisions.md` but no dedicated `friction-log.md` or `improvement-log.md`.

**Session notes review:** Two sessions are logged (2026-04-10 build, 2026-04-11 audit). The only friction-adjacent observation is the orphaned `detect-innovation.sh` hook (noted in Open Questions on 2026-04-10, resolved on 2026-04-11 by the repo-dd audit which deleted it). No recurring friction patterns detected.

**Assessment:** The project is 1 day old with 2 sessions logged. Insufficient operational history to detect friction patterns. Recommend re-running this check after 5+ operational sessions.

### Deployed Project Drift (Check 8)

This project is not derived from a workflow template -- it was built via the `/new-project` pipeline with custom commands. There is no template to drift from.

**Shared infrastructure sync:** All 21 symlinked commands, 9 symlinked agents, and 1 symlinked skill use relative symlinks pointing to `ai-resources/`. The analysis (Section 6.2, 6.3, 6.4) confirms all symlinks are valid and all targets exist. Since these are symlinks rather than copies, content drift is structurally impossible.

**Orphaned hook cleanup confirmed:** The session notes document that `detect-innovation.sh` was copied during build (2026-04-10) with no settings.json entry, then deleted by the repo-dd audit (2026-04-11). The `.claude/hooks/` directory no longer exists. This is resolved.

**Assessment:** No drift detected. The project's infrastructure is clean and well-synced.

### Skill Staleness (Check 9)

Only one project-relevant skill: `intake-processor`.

- **intake-processor:** Originally created as a project-local skill during the 2026-04-10 build session. Graduated to `ai-resources/skills/intake-processor/` on 2026-04-11 (repo-dd audit), with the project copy replaced by a symlink. The skill has not been modified since graduation. The project was deployed the same day the skill was created -- there is no version gap.

- **Shared utility skills** (ai-resource-builder, session-usage-analyzer, repo-health-analyzer, workflow-system-analyzer, workflow-system-critic): These are consumed via symlinked commands from ai-resources. They are always current by definition (symlink indirection).

**Assessment:** No staleness detected. The project and its sole skill were created simultaneously and the skill was graduated within 24 hours.

---

## Summary

- Critical: 0
- Important: 2
- Medium: 3
- Low: 1
- Total: 6

**Top 3 recommendations by impact:**

1. **Add a PreToolUse hook guarding theme folder writes** -- without it, the append-only invariant (Hard Rule 3) and staging-only-writes rule (Hard Rule 1) rely entirely on behavioral compliance, with no runtime safety net for the system's most critical data integrity rules.
2. **Document operator gates in CLAUDE.md** -- the two operator review points in kb-ingest and kb-review are invisible in the governing document, making the system's review model incomplete for anyone reading CLAUDE.md.
3. **Narrow Bash permissions or add compensating hooks** -- the current `Bash(*)` permission combined with zero hooks means there are no infrastructure-level guardrails for a system whose core design depends on strict write boundaries.
