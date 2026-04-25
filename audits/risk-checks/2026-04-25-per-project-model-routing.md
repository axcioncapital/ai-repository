# Risk Check — 2026-04-25

## Change

Per-project model routing across the Axcion AI workspace.

Scope (per `/Users/patrik.lindeberg/.claude/plans/now-the-question-is-compressed-coral.md`):
- **Change 1** — Create `ai-resources/docs/model-routing.md` as the single canonical routing doc (three-tier rule, decision question, examples table, cost ratios, project-default architecture, escalation pattern).
- **Change 2** — Replace workspace-wide model default with per-project rule. Workspace `CLAUDE.md` Model Tier section rewritten; `ai-resources/CLAUDE.md` Model Preference replaced with project-level Model Selection (also fixes stale `claude-opus-4-6` → `claude-sonnet-4-6` for the ai-resources project).
- **Change 3** — Rewrite the JSON `additionalContext` payload inside `model-classifier.sh` (heredoc, anchor by content not line number). Hook structure unchanged.
- **Change 4** — Add `model: sonnet` frontmatter to the 22 ai-resources commands lacking it. Inspect 7 workspace-only commands separately (likely add `model: sonnet`; deletion only with explicit confirmation).
- **Change 5** — Add Model Escalation rule to workspace `CLAUDE.md` (parallels QC → Triage Auto-Loop; de-dups with it).
- **Change 6** — Add a one-line model brief step to `/prime`.
- **Change 7** — Add a Model Selection scaffolding step to `/new-project` (pre-flight identifier verification).

This is the plan-time `/risk-check` invocation (Autonomy Rules pause-trigger #9). Top-3-affected analysis (pause-trigger #8) is included in the plan body.

## Referenced files

- `/Users/patrik.lindeberg/.claude/plans/now-the-question-is-compressed-coral.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/CLAUDE.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/model-routing.md` — not yet present
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/.claude/hooks/model-classifier.sh` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/prime.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/new-project.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/.claude/commands/` — exists (22 files to receive `model: sonnet`)
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/ai-resources/docs/agent-tier-table.md` — exists
- `/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/projects/buy-side-service-plan/CLAUDE.md` — exists (precedent reference; not modified)

## Verdict

PROCEED-WITH-CAUTION

**Summary:** Coherent, well-scoped change set that resolves a real three-way default conflict; coupling and reversibility are bounded but two areas (the hook payload edit and project CLAUDE.md drift) require explicit paired mitigations before landing.

## Dimensions

### Dimension 1: Usage Cost
**Risk:** Medium

- **Workspace `CLAUDE.md` net change is approximately neutral.** Existing Model Tier section is ~7 lines (lines 149–157 verbatim). Replacement rule per Change 2 is ~3 lines. New Model Escalation section per Change 5 adds ~10–15 lines (trigger conditions, action, de-dup clause). Net add to always-loaded workspace CLAUDE.md: ~6–11 lines (~50–90 tokens). Below the 150-token "high" threshold but non-zero per-turn ongoing cost.
- **ai-resources `CLAUDE.md` net change is approximately neutral.** Lines 28–32 (Model Preference section, ~5 lines) replaced by a Model Selection section of comparable length (~5–7 lines per plan body). No net growth.
- **`model-routing.md` is referenced, not auto-loaded.** Plan structures it as a doc the hook nudge and CLAUDE.md sections *point at*, not as `@import`. Pay-as-used. No always-loaded cost.
- **Hook payload grows.** Current `additionalContext` string is ~600 chars. Replacement per Change 3 is ~1100 chars (Sonnet/Opus tier definitions, project-default mechanic, escalation hint, no-narration directive). Hook fires once per session on first free-form prompt only — bounded one-shot cost, not per-turn. Acceptable.
- **`/prime` adds one line of output.** Per-invocation cost only when `/prime` runs. Negligible.
- **22 commands gain a single `model: sonnet` line each.** Pay-as-used (only loaded when the slash command is invoked). No always-loaded cost.

### Dimension 2: Permissions Surface
**Risk:** Low

- **No `permissions.allow` / `permissions.deny` entries change.** Plan touches no settings files for permissions. Verified by reading the plan body — every settings reference is to `model: sonnet` at the top level of `settings.json` (Change 7 scaffolding for new projects only), not to `permissions.*`.
- **No new tool invocation pattern.** Bulk frontmatter edits use `Edit`/`MultiEdit` already covered by existing repo allow rules. The `/new-project` scaffolding update writes JSON via `jq` (already canonical in `new-project.md` line 295+).
- **No deny rule removed or narrowed.** Confirmed by reading the plan body end-to-end.

### Dimension 3: Blast Radius
**Risk:** Medium

- **22 ai-resources command files modified.** Verified by `for f in ai-resources/.claude/commands/*.md; do head -10 "$f" | grep -q "^model:" || echo $(basename $f); done` — the 22 files returned exactly match the plan's list (`audit-repo`, `clarify`, `cleanup-worktree`, `deploy-workflow`, `friction-log`, `friday-act`, `friday-checkup`, `graduate-resource`, `new-project`, `note`, `prime`, `qc-pass`, `recommend`, `refinement-pass`, `request-skill`, `scope`, `session-guide`, `sync-workflow`, `triage`, `update-claude-md`, `usage-analysis`, `wrap-session`).
- **Symlink propagation verified, not assumed.** `ls -la .claude/commands/{audit-claude-md,prime,new-project}.md` shows each as a symlink pointing to `../../ai-resources/.claude/commands/...`. Bulk frontmatter edit at the canonical location automatically propagates to the workspace `.claude/commands/` view.
- **7 workspace-only commands unaccounted for in the symlink propagation.** Verified by `comm -23 ws.txt ai.txt`: `document-workflow.md`, `improve-workflow.md`, `new-workflow.md`, `run-qc.md`, `status.md`, `update-md.md`, `validate.md`. The plan flags these explicitly (sub-step 4b) and gates deletion behind operator confirmation. Not a hidden caller — handled.
- **5 project CLAUDE.md files (out of 6) have NO Model Selection section.** Verified: `projects/corporate-identity/CLAUDE.md` has one (already), `projects/buy-side-service-plan/CLAUDE.md` has one. The other four (`global-macro-analysis`, `nordic-pe-landscape-mapping-4-26`, `obsidian-pe-kb`, `project-planning`) do NOT. Under per-project default, sessions in those four projects fall through to "workspace-root fallback = Sonnet" — which may or may not match the operator's intent for each project.
- **References to changed components are bounded.** `grep -rln "Model Tier"` returned 18 hits, but most are in `audits/`, `logs/`, and `usage/` (historical artifacts that won't be re-read). Active references: `ai-resources/CLAUDE.md`, `CLAUDE.md` (workspace), `ai-resources/.claude/commands/new-project.md`, `ai-resources/.claude/commands/deploy-workflow.md`, `.claude/hooks/model-classifier.sh`, `ai-resources/docs/permission-template.md`. Six active callers — all named in the plan's "Files modified" list except `permission-template.md` and `deploy-workflow.md`.
- **`permission-template.md` and `deploy-workflow.md` reference Model Tier but are NOT in the plan's modified-files list.** `grep -n "Model Tier" ai-resources/docs/permission-template.md ai-resources/.claude/commands/deploy-workflow.md` would confirm; these may carry stale "Default model is Sonnet" pointers that contradict the new per-project rule.
- **23 agents in `agent-tier-table.md` are unaffected.** Plan explicitly preserves agent frontmatter — agents already declare model explicitly. The table just gets a pointer to the new routing doc.

### Dimension 4: Reversibility
**Risk:** Medium

- **`git revert` cleans most of the change set.** The 22 frontmatter edits, the workspace/ai-resources CLAUDE.md edits, the `model-classifier.sh` heredoc replacement, the `/prime` and `/new-project` additions, the new `model-routing.md` file — all are tracked-file edits that revert cleanly.
- **The marker file in `/tmp/claude-model-classifier/` survives revert.** When a fresh session opens after the hook is reverted, the per-session marker logic still suppresses re-firing for already-classified sessions. This is a pre-existing property of the hook, not introduced by the change. Bounded: markers are scoped per-session and `/tmp` is volatile.
- **Existing `/tmp/claude-model-classifier/` markers from sessions opened with the OLD reminder text persist after the change lands.** Those sessions won't re-fire the hook. Acceptable — only future sessions are affected.
- **Project CLAUDE.md audits (Change 2 sub-step) are append-only.** If the operator adds a Model Selection section to a project CLAUDE.md and later wants to revert just the workspace/ai-resources side, the project additions remain. Manual cleanup required to fully roll back. One extra step.
- **No external state propagation.** No `git push`, no Notion write, no API call. All changes local-tree until operator pushes.
- **Hooks fire between change-land and any potential revert.** The new `model-classifier.sh` payload starts emitting on the first session after it lands. Sessions opened in that window receive the new classification reminder. Effect is advisory (Claude reads and decides), not state-mutating, so the blast is contained to in-session behavior.

### Dimension 5: Hidden Coupling
**Risk:** Medium

- **`model-classifier.sh` heredoc edit is contract-bound to a fragile JSON shape.** The current hook emits a single-line JSON payload inside `cat <<'EOF' ... EOF` (lines 45–47). The plan correctly flags "find the entire `cat <<'EOF'` block and replace the JSON line inside; do not anchor by line number." But the JSON itself must remain a single line — newlines inside `additionalContext` must use `\n` escapes, not literal LF, otherwise `jq` parsing in Claude Code fails silently and the hook emits nothing. The plan's New reminder text is presented in markdown blockquote form (with real newlines); when written to disk the editor MUST collapse to `\n`-escaped single-line JSON. This is a known foot-gun in the existing hook (header comment line 43 explicitly notes it).
- **Three different "defaults" coexist for some hours during landing.** Workspace CLAUDE.md says Sonnet; ai-resources CLAUDE.md says Opus 4.6; the hook reminder says "default stays Opus." Plan addresses all three in Changes 2 and 3, but the order matters: if Change 3 (hook) lands before Change 2 (CLAUDE.md), the hook reminder will reference a "project's declared default" that some projects don't yet declare, and operators may see contradictory guidance. The plan's "Changes 1 + 2 as one foundation commit" and "Change 3" as separate commit handles this — but only if the operator follows the order.
- **`/prime` step 5 prints a fixed status block; Change 6 inserts a model brief "after Step 4."** The current `prime.md` has a Step 4a (lines 19–24) added after Step 4. Change 6's "after Step 4" is ambiguous between "after step 4" and "after step 4a." Existing convention (4a is itself a sub-step appended after 4) suggests the new model brief should be Step 4b or moved to its own step 5 — but the plan does not specify. Minor; resolvable in implementation.
- **`/new-project` Change 7 adds Model Selection scaffolding "before Stage 3a spawn."** Existing `new-project.md` has the operator interaction at First Run steps 1, 5 (GitHub URL ask), 11 (announce), and 12 (Stage 3a spawn). The plan's pre-flight identifier verification (live source check against `buy-side-service-plan/CLAUDE.md`) is sound but adds one more operator question to the First Run path. The interplay with the existing 12-step First Run sequence is not specified — implementation needs to choose: insert as new step 5b, fold into step 11's announce, or insert as step 11.5.
- **5 of 6 project CLAUDE.md files lack a Model Selection section.** Verified by `grep -E "^## " projects/*/CLAUDE.md`: only `corporate-identity` and `buy-side-service-plan` have one. Under the new rule, `global-macro-analysis`, `nordic-pe-landscape-mapping-4-26`, `obsidian-pe-kb`, `project-planning` fall through to the workspace-root Sonnet fallback. The plan's "audit any other project CLAUDE.md files; if missing, add a Model Selection section using the operator-confirmed default" is the right action — but requires per-project operator input that isn't yet captured. Without it, those projects silently inherit Sonnet, which may not match operator intent for analytical projects (e.g., `global-macro-analysis`).
- **The `claude-opus-4-6` stale identifier is more widespread than the plan addresses.** `grep -rln "claude-opus-4-6"` returned 20 hits across `projects/buy-side-service-plan/logs/`, `projects/project-planning/pipeline/`, `projects/obsidian-pe-kb/pipeline/`, `projects/obsidian-pe-kb/vault/.claude/settings.local.json`, and `projects/project-planning/.claude/agents/{plan-evaluator,spec-evaluator}.md`. The plan fixes the identifier in `ai-resources/CLAUDE.md` only. Logs and pipeline artifacts are historical (acceptable to leave). But `projects/project-planning/.claude/agents/plan-evaluator.md` and `spec-evaluator.md` carry it as live agent frontmatter or instruction text — those callers will keep referencing a stale ID after this change lands. And `projects/obsidian-pe-kb/vault/.claude/settings.local.json` carries it as the project's actual model setting — outside this change's scope, but worth surfacing.
- **`permission-template.md` and `deploy-workflow.md` reference "Model Tier"** (per grep). Plan does not list them in the modified-files set. After the workspace `CLAUDE.md` "Model Tier" section is rewritten, any pointers in those files may reference a section name that has moved or shifted shape.

## Mitigations

- **Hidden Coupling — hook payload JSON shape:** Before committing Change 3, smoke-test the hook in a fresh session (verification step 1 in the plan, escalated from "verify" to a hard precondition before commit). Confirm the new `additionalContext` JSON parses (e.g., `bash .claude/hooks/model-classifier.sh < /tmp/test-input.json | jq -r '.hookSpecificOutput.additionalContext'`). If the heredoc edit accidentally introduces an unescaped newline, the hook silently fails and the change is invisible until a future session reveals it.

- **Blast Radius — additional callers not in modified-files list:** Before committing Change 2, run `grep -n "Model Tier\|Default model is Sonnet\|Default model is Opus" ai-resources/docs/permission-template.md ai-resources/.claude/commands/deploy-workflow.md` and inspect each hit. If either file carries a sentence that contradicts the new per-project rule, update it in the same commit as the workspace CLAUDE.md edit.

- **Hidden Coupling — 5 project CLAUDE.md files without Model Selection:** Treat the Change 2 "audit any other project CLAUDE.md files" sub-step as a hard blocker, not advisory. For each of `global-macro-analysis`, `nordic-pe-landscape-mapping-4-26`, `obsidian-pe-kb`, `project-planning` (corporate-identity already has one), explicitly ask the operator the project task-profile question (Heavy execution / Heavy judgment / Mixed) and write the Model Selection section before declaring Change 2 complete. Otherwise four projects silently land on the Sonnet fallback that may not match operator intent.

- **Reversibility — project CLAUDE.md edits are append-only:** Capture the exact append per project in the session note, so a manual rollback can locate and remove just those sections without re-reading the diff. Standard `wrap-session` discipline covers this; flag explicitly because the project-CLAUDE.md additions span 4+ separate files.

- **Hidden Coupling — `claude-opus-4-6` references in project-planning agents:** Inspect `projects/project-planning/.claude/agents/plan-evaluator.md` and `spec-evaluator.md` during Change 2's project-audit sub-step. If they declare `model: claude-opus-4-6` in frontmatter, the harness may either (a) auto-resolve to the current Opus or (b) warn. Either case warrants an explicit update to `claude-opus-4-7` aligned with the plan's "Verified facts" line on canonical identifiers.

- **Hidden Coupling — `/prime` and `/new-project` insertion point ambiguity:** When implementing Changes 6 and 7, write the exact line range targeted (e.g., "insert as Step 4b after current line 24" / "insert before current line 142") and verify with mechanical-mode QC that the surrounding step numbers and gate sequencing remain coherent. Not a redesign — just precision in the implementation step.

## Recommended redesign

Not applicable (verdict is PROCEED-WITH-CAUTION).

## Evidence-Grounding Note

All risk levels grounded in direct evidence: plan-file content (lines and verbatim quotes), CLAUDE.md line counts and section enumerations, `ls -la` symlink verification, `comm -23` workspace-only command enumeration, `grep -E "^## "` project CLAUDE.md section presence, `grep -rln` reference-counter sweeps for `model-routing`, `model-classifier`, `Model Selection`, `Model Tier`, and `claude-opus-4-6`. No training-data fallback. No INCOMPLETE dimensions.
