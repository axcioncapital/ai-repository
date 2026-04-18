# Improvement Log

### 2026-04-18 — Canonical project settings template for /new-project and research-workflow
- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R1 (both audits) and R4 (buy-side). Every new project ships without `Read(...)` denies and without a Sonnet default. The audit catches these findings on every project; preventing them at project-creation time would eliminate the recurrence.
- **Proposal:**
  - Update `/new-project` pipeline's post-enrichment stage to write `.claude/settings.json` with a sensible `permissions.deny` block. Minimum: `Read(archive/**)`. Research-workflow-derived projects should also get `Read(output/**)`, `Read(parts/**/drafts/**)`, `Read(usage/**)`, `Read(**/*.archive.*)`, `Read(**/deprecated/**)`, `Read(**/old/**)`.
  - Update the same stage to write `.claude/settings.local.json` with `{"model": "sonnet"}` as default.
  - Update the research-workflow template's `.claude/settings.json` at `ai-resources/workflows/research-workflow/.claude/settings.json` so `/deploy-workflow` propagates the canonical state.
  - Apply the "Applying Audit Recommendations" rule (workspace CLAUDE.md) when finalizing the deny list — list the top-3 commands each path affects and confirm no regression before committing the template.
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` (pipeline orchestrator)
  - `ai-resources/workflows/research-workflow/.claude/settings.json` (template)
  - Any pipeline-stage-N agent that writes project `.claude/settings.json`

### 2026-04-18 — Canonical project CLAUDE.md template (compaction + session-boundary defaults, no workspace-rule duplication)
- **Status:** applied 2026-04-18 (Prevention Session 2)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit R10 (ai-resources) + R8 (buy-side). Every new project CLAUDE.md ships without `## Compaction` and `## Session Boundaries` sections, and every new project that was created via `/new-project` under the 2026-04-13 decision includes duplicated workspace rules (File Verification, Commit Rules) that pay per-turn token cost.
- **Proposal:**
  - Update the CLAUDE.md template used by `/new-project` to include default `## Compaction` and `## Session Boundaries` sections (borrow wording from ai-resources/CLAUDE.md).
  - Reconcile with the 2026-04-13 decision (copy Commit Rules into every project CLAUDE.md). Option A: keep the short-form mirror but audit that the project-level copy doesn't drift. Option B: replace with a one-line pointer — "Commit and file-verification rules: see workspace CLAUDE.md." Requires verifying that Claude Code consistently loads the workspace CLAUDE.md via `additionalDirectories` before the operator experiences commit-asking friction again. The 2026-04-13 decision's rationale ("inheritance evidently does not surface the rule prominently enough") may still hold — if so, keep the short-form copy but add a drift-check to `/repo-dd` questionnaire.
  - Update the research-workflow template's CLAUDE.md at `ai-resources/workflows/research-workflow/CLAUDE.md` so deployed projects inherit.
  - Apply the new workspace CLAUDE.md "CLAUDE.md Scoping" rule when reviewing project templates: skill-methodology and workflow-methodology content that lives in project CLAUDE.md should be moved to the right home (SKILL.md or workflow reference docs).
- **Target files:**
  - `ai-resources/.claude/commands/new-project.md` and its pipeline stages
  - `ai-resources/workflows/research-workflow/CLAUDE.md` (template)
  - Any CLAUDE.md template referenced by `/deploy-workflow`

### 2026-04-18 — Extend Model Tier rule to cover agents; publish a tier table

- **Status:** applied 2026-04-18 (Prevention Session 1)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit §7.6 + §8 practice 7 + R2 Phase 1 (same-day fix session). Workspace `CLAUDE.md` "Model Tier" section (lines 185–193) governs **commands only**. The current agent fleet ships as 10 Opus / 5 inherit (= Opus) / 3 Sonnet / 0 Haiku — no rule prevents a new agent from defaulting to Opus when the work is mechanical. R2 Phase 1 (splitting `token-audit-auditor` into mechanical/judgment variants) is the kind of retrofit a rule would prevent. R12 (`repo-dd-auditor` Opus→Sonnet) is another.
- **Proposal:**
  - Extend workspace `CLAUDE.md` → Model Tier to include an Agents subsection mirroring the Commands one: *"New agent definitions must declare `model:` explicitly. Tier by work type: Haiku for mechanical measurement / file census / format checks; Sonnet for structured factual work (questionnaire-driven audits, fact extraction); Opus for judgment (QC, refinement, synthesis, triage, critique, workflow-stage-3b architecture)."*
  - Publish a concrete **Agent Tier Table** in the same section listing the current fleet with correct tier (18 agents per audit §5.1 / post-fix inventory: 10 Opus, 4 Sonnet — adding `repo-dd-auditor` after R12, 1 Haiku — adding `token-audit-auditor-mechanical` after R2 Phase 1, 3 inherit-from-default). Mark migration candidates.
  - Add a one-line maintenance note: *"When adding a new agent, place it in the table. When changing an agent's tier, update the table in the same commit."*
  - Add a one-line pointer to `ai-resources/CLAUDE.md`: "Agent model tiering: see workspace CLAUDE.md → Model Tier." No duplication.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` (Model Tier section — extend)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (one-line pointer)

### 2026-04-18 — Codify subagent-summary cap + /usage-analysis discipline in ai-resources CLAUDE.md

- **Status:** applied 2026-04-18 (Prevention Session 1)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention
- **Friction source:** 2026-04-18 token-audit §9.3 safeguards #3 (subagent return-size cap) and #7 (mandatory `/usage-analysis` at wrap) + R14. Neither is written down as a rule. §7.3 confirms the two-file output-to-disk pattern is in place, but no convention enforces the **summary length cap** (30 lines for Sections 2/5/6, 20 for Section 4 in `token-audit-auditor` — lives in one agent's body, not as a shared convention). R14 (telemetry baseline) depends on a discipline the operator must sustain; without it, future audits can't measure the impact of R1–R13.
- **Proposal:**
  - Add a short **Subagent Contracts** section to `ai-resources/CLAUDE.md`: summary files cap at 30 lines (20 when per-unit invocations proliferate, e.g., per-workflow or per-chapter); full notes path returned; main session reads summary only. Reference the existing implementations: `token-audit-auditor`, `token-audit-auditor-mechanical` (post-R2 Phase 1), `repo-dd-auditor`, `session-usage-analyzer`.
  - Add a **Session Telemetry** subsection stating that `/usage-analysis` should run at the end of every substantive session. Wire the prompt into `/wrap-session` (queued as R14 implementation) — operator can dismiss with one-letter confirmation if the session was trivial.
  - Do NOT extend this rule to project-level CLAUDE.md files — it's ai-resources-scope discipline, not per-project.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` (two new sections)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/wrap-session.md` (add `/usage-analysis` prompt at end)

### 2026-04-18 — Add three questionnaire items to /repo-dd

- **Status:** applied 2026-04-18 (Prevention Session 3)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention (detection)
- **Friction source:** 2026-04-18 token-audit §9.3 safeguards #2 (agent-tier drift) and #6 (CLAUDE.md task-type-instruction bloat). The audit itself had to do this work ad hoc; `/repo-dd` should catch drift on every cycle so a future `/token-audit` is rarely the first to see it. Adding a new-project-parity check closes the loop on the pending canonical-template entries above — projects created before the template lands need detection until they're retrofitted.
- **Proposal:** Add three items to `ai-resources/audits/questionnaire.md`:
  1. **Agent model tier drift:** for each `.claude/agents/*.md` under the audit scope, does the `model:` field match the Agent Tier Table in workspace CLAUDE.md? List mismatches.
  2. **CLAUDE.md task-type bloat:** does any CLAUDE.md file contain task-type-specific instructions (skill-methodology, workflow-methodology, creation sequences) that should be migrated to SKILL.md or workflow reference docs per workspace CLAUDE.md → "CLAUDE.md Scoping" rule? List candidates.
  3. **New-project settings parity:** for each project under `projects/`, does `.claude/settings.json` contain the canonical `Read(...)` deny list (minimum: `Read(archive/**)`)? Does `.claude/settings.local.json` declare `model: sonnet`? List projects missing either.
- **Dependency:** The canonical-template entries above (settings + CLAUDE.md) must land first for item 3 to have a stable reference. Entry A (Agent Tier Table) must land first for item 1 to have a reference.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/audits/questionnaire.md`
  - Downstream if needed: `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/agents/repo-dd-auditor.md` and `.claude/commands/repo-dd.md` for question-layout surfacing.

### 2026-04-18 — Pre-commit skill-size warning hook (informational, non-blocking)

- **Status:** applied 2026-04-18 (Prevention Session 3)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Audit-recurrence prevention (automation)
- **Friction source:** 2026-04-18 token-audit §2.1 + §9.3 safeguard #4. Eight skills exceed 300 lines; two exceed 480. Nothing warns at commit time that a SKILL.md is growing past the recommended threshold — bloat is only caught at the next audit, by which point compressing is a bigger session.
- **Proposal:**
  - Add a pre-commit hook under `ai-resources/.claude/hooks/` (e.g., `check-skill-size.sh`) that measures any staged `SKILL.md` file and emits an **informational** warning when line count > 300. Non-blocking — warning text only, exit 0.
  - Register it in `ai-resources/.claude/settings.json` alongside the existing hook block. Verify no path conflict with the existing `check-skill-validation.sh`-style hook.
  - Keep it lightweight: single bash script, `wc -l` on each staged SKILL.md, stderr warning, no external deps.
- **Risk:** Low. Informational output only; operator can ignore.
- **Target files:**
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/hooks/check-skill-size.sh` (new)
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/settings.json` (hook registration)

### Sequencing note (five entries combined)

Suggested three-session sequence:

- **Session 1 (rules, ~45 min):** Entry "Extend Model Tier rule to agents" + Entry "Codify subagent-summary cap + /usage-analysis discipline". Purely CLAUDE.md + one `/wrap-session` edit. Lowest risk, highest per-turn leverage.
- **Session 2 (templates, ~1–2 hrs):** Existing entries — canonical project settings template + canonical project CLAUDE.md template. Touches `/new-project` pipeline + research-workflow templates. Before implementing, re-read the 2026-04-13 decision ("Commit Rules propagate by explicit copy") to confirm whether the inheritance workaround is still needed.
- **Session 3 (detection + automation, ~45 min):** Entry "Add three questionnaire items to /repo-dd" + Entry "Pre-commit skill-size warning hook". Depends on Session 1 (Agent Tier Table) and Session 2 (canonical templates) landing first so the new questionnaire items have stable references.

### 2026-04-18 — /wrap-session directory-wildcard git add sweeps up concurrent-session files

- **Status:** applied 2026-04-18 (structural fix only in `wrap-session.md` step 12–13 — durable workspace CLAUDE.md concurrent-session rule remains pending)
- **Verified:** 2026-04-18 — confirmed by operator
- **Category:** Concurrency safety / command discipline
- **Friction source:** Prevention Session 1 (2026-04-18 night) wrap. `/wrap-session` step 13 specifies `git add logs/ skills/ prompts/ .claude/` — directory-level wildcards. A parallel `/improve-skill repo-dd-auditor` session was running in the same repo with uncommitted work under `.claude/agents/` and `.claude/commands/`. The wrap commit swept up 4 parallel-session files (`dd-extract-agent.md`, `dd-log-sweep-agent.md`, `.claude/commands/repo-dd.md`, `logs/innovation-registry.md`) under a commit message that described only the Prevention Session 1 work. Unwound via `git reset --soft HEAD~1` + selective `git restore --staged` + re-commit. Fix was clean (unpushed), but attribution slippage and toe-stepping both real. Operator had explicitly said at session start "don't step your toes here."
- **Root cause:** `/wrap-session` was written assuming one session is the sole writer of the directories it stages. Assumption holds for Axcíon's typical single-session workflow; breaks the moment two sessions run concurrently. Directory wildcards are "narrower than `git add -A`" but still not narrow enough to respect concurrency.
- **Proposal:**
  - **Structural fix:** update `/wrap-session` step 13 to stage explicit file paths derived from the Files Created / Files Modified sections the command just wrote into the session note. The command already enumerates its own artifacts — use that enumeration at commit time instead of directory wildcards. Default file set: `logs/session-notes.md logs/decisions.md logs/coaching-data.md` + any additional files listed in the Files Created/Modified sections.
  - **Durable rule:** add a short section to workspace `CLAUDE.md` (under Git Rules or Commit-boundary sequencing) stating: when the operator has disclosed a concurrent session on the same repo, `git add` must enumerate explicit file paths — directory wildcards (`git add logs/`, `git add .claude/`) are prohibited until the concurrent session wraps. Makes "don't step on toes" a checkable rule.
  - **Optional safeguard:** before staging in `/wrap-session`, run `git status --short` and cross-reference the modified-file list against the session's Files Modified section. If the status list contains files not in Files Modified, flag and ask the operator before staging. (Tension: workspace CLAUDE.md says "do not run `git status` as a pre-commit check." Carve an exception for the concurrency-detection case, or accept that the enumerate-explicit-paths fix alone is sufficient.)
- **Target files:**
  - `ai-resources/.claude/commands/wrap-session.md` — change step 13 staging command
  - `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — new Git Rules subsection on concurrent-session staging discipline
- **Dependency:** None. Can be implemented standalone; fits the Prevention Session sequence as a small bundle with the existing Session 2 (templates) or Session 3 (detection).
- **Risk:** Low. Structural fix is a 2-line change. Durable rule adds ~5 lines to workspace CLAUDE.md. Neither touches active-workflow code.
