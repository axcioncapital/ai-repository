# Repo Deep Review — 2026-04-06

Workspace: Axcion AI
Based on: repo-dd audit 2026-04-06 (commit `241dfb4`)
Scope: ai-resources, projects/buy-side-service-plan, projects/nordic-pe-landscape-mapping-4-26, workflows

---

## Section 1: Feature Criticality

### 1.1 Load-Bearing Features

| Feature | Reference Count | Blast Radius | Risk Notes | Priority |
|---------|----------------|--------------|------------|----------|
| logs/session-notes.md | 10 (7 commands + 3 hooks) | Every session loses continuity if corrupted | Format stability is unvalidated; append-only file with no schema enforcement | Critical |
| logs/innovation-registry.md | 6 (4 commands + 3 hooks) | Innovation detection becomes write-only; `/wrap-session` triage fails | detect-innovation.sh creates if missing, but format corruption breaks Stop hook grep | Critical |
| logs/decisions.md | 4 (3 commands + root wrap) | Decision audit trail lost; violates Design Judgment Principles | Only created on demand by `/wrap-session` — if never created, principle compliance is impossible | Critical |
| CLAUDE.md (root) | 6 refs + behavioral authority | Workspace-wide coherence degrades | No commands validate against it at runtime — enforcement is social contract only | High |
| ai-resources/CLAUDE.md | 6 refs + methodology authority | Skill creation pipeline loses anchor | Contains sole process contract for skill lifecycle (creation, improvement, graduation) | High |
| skills/ai-resource-builder/SKILL.md | 3 (create, improve, migrate) | All skill creation/improvement fails | No existence check before reading; deep path vulnerable to moves | High |
| evaluation-framework.md | 2 explicit + 3 command dependents | QC gates across all skills become ad-hoc | Passed directly to subagents; move breaks 3 commands | High |
| .claude/settings.json | 2 refs + Stop hook control | Session wrap reminder lost; operator can end sessions unwrapped | Single file per repo controls ritual boundary | Medium |
| report/chapters/ | 4 (pipeline stages) | Report production fails for specific project | Template directory; populated per-project | Medium |
| analysis/cluster-memos/ | 4 (pipeline stages) | Analysis phase of research workflow blocks | Populated per-project; absence blocks downstream stages | Medium |

### 1.2 Operational Dependency Chains

**Research Pipeline:**
```
/run-preparation → /run-execution → /run-cluster → /run-analysis → /run-synthesis → /run-report → /verify-chapter → /produce-knowledge-file
```
- **Single point of failure:** `analysis/cluster-memos/` directory existence. Missing directory blocks `/run-cluster`, cascading to all downstream stages.
- Priority: High (for projects using research workflow)

**Project Setup Pipeline:**
```
/new-project → pipeline-stage-2 → 2-5 → 3a → 3b → 3c → 4 → 5 → /session-guide
```
- **Single point of failure:** `pipeline-stage-*.md` agent files in ai-resources/.claude/agents/. `/new-project` does NOT check agent existence before spawning. If any agent file is deleted, project creation fails at spawn step.
- Priority: Critical

**Session Lifecycle:**
```
/prime → [work] → /wrap-session
```
- **Single point of failure:** `logs/session-notes.md` format stability. `/wrap-session` reads file to find append point; malformed format breaks append.
- Priority: Critical

**Skill Management:**
```
/request-skill → /create-skill → /improve-skill
```
- **Single point of failure:** `skills/ai-resource-builder/` directory + `evaluation-framework.md`. `/create-skill` reads both before spawning QC subagent; deletion breaks step 3.
- Priority: High

**Workflow Management:**
```
/deploy-workflow → /sync-workflow
```
- **Single point of failure:** Exclusion list maintenance in `/deploy-workflow`. Hardcoded shell strings for EXCLUDE_COMMANDS, EXCLUDE_AGENTS, EXCLUDE_HOOKS. New ai-resources-specific commands not added to exclusion list will silently propagate to all projects.
- Priority: High

**Audit Pipeline:**
```
/repo-dd → /repo-dd deep → /repo-dd full
```
- **Single point of failure:** `audits/questionnaire.md` existence. `/repo-dd` reads this file in Step 1; deletion blocks all audit runs.
- Priority: Medium

### 1.3 Untracked Dependencies

| Dependency | Type | Why It Matters | Priority |
|------------|------|---------------|----------|
| Design Judgment Principles (Root CLAUDE.md) | Behavioral convention | 8 principles (ambiguity, uncertainty, friction, progressive formalization, conflict surfacing, evidence/interpretation) govern every pipeline decision. No command enforces them — violations are invisible. | Critical |
| Autonomy Rules (Root CLAUDE.md) | Behavioral convention | Defines when to pause for [Operator] vs. auto-proceed. Every command's execution strategy depends on these. Violation breaks workflow rhythm. | Critical |
| QC Independence Rule (Root CLAUDE.md) | Behavioral convention | Requires fresh subagents for evaluation. If violated, QC becomes biased. Enforcement is manual (choosing what context to pass to subagent). | Critical |
| Commit message format convention | Format convention | `new:`, `update:`, `fix:`, `audit:` format. `/repo-dd` may parse commit history. No hook enforces format. | High |
| Symlink convention for skills | Deployment pattern | Projects consume skills via symlinks to ai-resources/skills/. If a project creates copies instead, canonical updates won't propagate. `/deploy-workflow` creates symlinks; no runtime check validates them. | High |
| Innovation detection hook registration | User-level setting | `detect-innovation.sh` fires on PostToolUse Write/Edit. Registered in user-level settings. If user removes it, innovation tracking fails silently. No command validates hook presence. | High |
| Stop hook wrap-session reminder | Settings dependency | Ritual boundary (session end → `/wrap-session`). If settings.json is deleted, operator can end sessions unwrapped. | Medium |

---

## Section 2: Context Management

### 2.1 Context Load Summary

| Entry Point | CLAUDE.md Lines | Hook Load | Total | Efficiency Ratio | Priority |
|-------------|----------------|-----------|-------|-------------------|----------|
| ai-resources | 190 | ~60 | ~250 | 57% | Medium (below 60% threshold) |
| buy-side-service-plan | 244 | ~60 | ~304 | 66% | Low (above threshold) |
| nordic-pe | 161 | ~30 | ~191 | 62% | Low (above threshold) |
| workflows | 121 | ~60 | ~181 | 52% | Medium (below 60% threshold) |

ai-resources and workflows entry points load context where over 40% is behavioral guidance never operationally invoked. buy-side-service-plan is the most context-efficient due to heavy operational usage of its CLAUDE.md sections.

### 2.2 Migration Candidates

| Section | File | Lines | Recommendation | Reasoning | Priority |
|---------|------|-------|---------------|-----------|----------|
| Design Judgment Principles | Root CLAUDE.md | 11 | Move to skill reference; load in /create-skill, /improve-skill, pipeline QC | Behavioral meta-guidance loaded at every entry point but never operationally invoked. High line count for zero direct usage. However: these principles shape decision quality across all sessions. Migration risks losing ambient influence. | Medium |
| Working Principles | Root CLAUDE.md | 9 | Move to ai-resources/docs/iteration-pattern.md; reference in pipeline commands | Covers iteration patterns (checkpoints, versioning). Helpful but not mandatory per-session. | Medium |
| Autonomy Rules | Root CLAUDE.md | 10 | Keep in CLAUDE.md | Despite zero operational references, these rules are *behavioral modifiers* that must be present in every session. They define when Claude pauses vs. proceeds — removing them would change behavior in every command. Cannot migrate. | N/A — keep |
| "How I Work" | ai-resources/CLAUDE.md | 3 | Remove from project CLAUDE.md; keep in root only | Operator profile set once, never re-read. Redundant across ai-resources and buy-side. | Low |
| Delivery | Root CLAUDE.md | 3 | Move to docs/delivery-checklist.md | One-off handoff guidance. Only relevant at project completion. | Low |

**Judgment note:** Design Judgment Principles and Autonomy Rules are the hardest call. Both are behavioral modifiers — they shape Claude's reasoning even when no command explicitly references them. Migrating them would save ~20 lines per session but risks degrading decision quality. Recommendation: keep Autonomy Rules (directly affects every interaction), consider migrating Design Judgment Principles to a skill reference loaded only during creation/evaluation contexts.

### 2.3 Hook Density Assessment

| Entry Point | Trigger | Hook Count | Cumulative Timeout | Verdict | Priority |
|-------------|---------|------------|-------------------|---------|----------|
| buy-side-service-plan | PostToolUse (Write) | **5** | **35s** | Over threshold (3+). Auto-commit (15s) + claim-ids (5s) + log-write (5s) + improve-reminder (5s) + coach-reminder (5s) | Critical |
| research-workflow template | PostToolUse (Write) | **4** | **30s** | Over threshold (3+). Auto-commit (15s) + claim-ids (5s) + log-write (5s) + detect-innovation (5s) | High |
| buy-side-service-plan | PostToolUse (Edit) + PreToolUse (Edit) | 3 | ~15s | At threshold. Bright-line PreToolUse + log-write PostToolUse + detect-innovation PostToolUse | Medium |
| research-workflow template | SessionStart | 2 | ~15s | Below threshold. Context load + drift check | Low |
| nordic-pe | PostToolUse (Write) | 2 | ~20s | Below threshold. Auto-commit + log-write | Low |

**Key concern:** buy-side-service-plan accumulates 35s of synchronous hook execution per Write operation. When `/draft-section` produces artifacts, each write triggers all 5 hooks. The improve-reminder and coach-reminder hooks are conditional (check session counts, parse dates) but still add 10s of overhead even when their conditions aren't met.

### 2.4 Dead or Low-Value Context

| Item | Type | Evidence of Non-Use | Priority |
|------|------|-------------------|----------|
| check-claim-ids.sh (PostToolUse hook) | Info-only validation | Flags missing Claim IDs but doesn't block commits or trigger remediation. Files are committed even if validation fails. No enforcement teeth. | High |
| coach-reminder.sh | Conditional nudge | Fragile implementation: parses coaching-log.md dates via awk, depends on exact date format. Uses /tmp markers that OS can clean. Could be replaced with simpler marker file. | Medium |
| log-write-activity.sh | Activity logger | Output goes to friction-log.md "Write Activity" section. No automated command reads this section. Useful for human inspection during `/wrap-session`. | Low |
| "How I Work" sections (×2) | Redundant context | Present in both ai-resources/CLAUDE.md and project CLAUDE.md files. Operator profile set once per project lifetime. | Low |
| workflows/CLAUDE.md (full file) | Dormant context | No active sessions in 30+ days. 23 lines of reference-only content. Not operationally loaded. | Low |

---

## Section 3: Friction and Improvement Synthesis

### 3.1 Recurring Friction Patterns

| Pattern | Frequency | Repos Affected | Root Cause | Recommendation | Priority |
|---------|-----------|---------------|------------|---------------|----------|
| Missing `/wrap-session` at session end | 228 instances (Apr 1-5) | buy-side-service-plan | Process gap — reminder not prominent enough during intensive drafting | Enforce via urgent Stop hook; document as mandatory in session rituals | High |
| Friction log captures only auto-writes, zero human observations | All 8 observed sessions | buy-side-service-plan | Process gap — hook captures file activity but no mechanism for friction annotations | Extend `/note` to recognize `friction:` prefix; wire into friction-log | Medium |
| Improvement items logged as "pending" then deprioritized | 2 items >2 days; 5 items mentioned as stalled | buy-side-service-plan | Priority/triage gap — no deadline or escalation for pending improvements | Add 3-day review window; recommend weekly infrastructure session | Medium |
| Heavy multi-draft iteration (3+ drafts per section) | Sections 2.4, 2.7, 2.8 | buy-side-service-plan | Tool gap — no visibility into iteration count or stopping criteria | Build `/section-stats` command; add revision budget rule | Medium |
| Friction logging absent from non-buy-side repos | Structural | ai-resources, nordic-pe | Context gap — innovation was project-specific, not graduated | Graduate friction-log infrastructure to ai-resources as shared tooling | High |

### 3.2 Improvement Pipeline Health

| Metric | Value |
|--------|-------|
| Total improvement entries (buy-side) | 7 |
| Status: applied | 4 |
| Status: logged (pending) | 2 |
| Status: verified (confirmed working) | 0 |
| Status: stalled (>14 days) | 0 |
| Friction entries with no improvement entry | 2 (wrap-session misses, rapid multi-edit cascades) |
| Improvement entries with no verification | 4 (cross-section guard, drafter memory, auto-commit coverage, approval mechanics) |
| Repos with improvement-log | 1 of 3 active repos |

The improvement pipeline captures and applies fixes but does not verify them. 4 of 4 "applied" improvements have no explicit session-note confirmation of effectiveness. The pipeline is open-loop — no feedback on whether fixes actually reduced friction.

### 3.3 Specific Recommendations

**1. Graduate friction-log and improvement-log infrastructure to shared tooling**
- Priority: High
- Effort: Quick (<1 session)
- Action: Move friction-log and improvement-log commands/hooks from buy-side to ai-resources. Deploy via `/deploy-workflow` to all new projects. Currently only buy-side has systematic friction capture — ai-resources and nordic-pe lack it entirely.
- Evidence: ai-resources/logs/ has no friction-log.md; nordic-pe/logs/ has no friction-log.md or improvement-log.md.

**2. Enforce `/wrap-session` as mandatory session-end ritual**
- Priority: High
- Effort: Quick (<1 session)
- Action: Make Stop hook more prominent (stronger language, mention consequences of skipping). Document in session-rituals.md as non-negotiable. Deploy to all repos.
- Evidence: 228 sessions ended without `/wrap-session` in buy-side during Apr 1-5.

**3. Consolidate improve-reminder.sh and coach-reminder.sh into SessionStart/Stop hooks**
- Priority: High
- Effort: Quick (<1 session)
- Action: Move conditional checks from PostToolUse (Write) to Stop hook. Reduces write latency by 10s per artifact in buy-side. Both hooks are session-level nudges, not per-write validation — they belong at session boundaries, not artifact boundaries.
- Evidence: buy-side PostToolUse (Write) stack = 35s. Removing 2 conditional hooks saves 10s per write.

**4. Add `/note friction:` capability for manual friction observations**
- Priority: Medium
- Effort: Quick (<1 session)
- Action: Extend `/note` command or `/friction-log` to accept inline friction observations. Wire into friction-log under "Friction Observations" section. Currently friction log only captures auto-writes, providing no diagnostic value.
- Evidence: buy-side improvement-log lines 39-43: "All 8 sessions — friction log contains only auto-captured writes, zero friction observations."

**5. Establish improvement verification loop**
- Priority: Medium
- Effort: Quick (<1 session)
- Action: After an improvement is marked "applied", add a verification prompt to the next `/wrap-session` run: "Improvement X was applied on [date]. Did it reduce the friction? Mark as verified/ineffective." This closes the open-loop pipeline.
- Evidence: 4 of 4 applied improvements in buy-side have no verification entry.

**6. Move check-claim-ids.sh from PostToolUse to on-demand command**
- Priority: Medium
- Effort: Quick (<1 session)
- Action: Remove from PostToolUse (Write) hook. Integrate into `/verify-chapter` command as an explicit gate. Currently runs on every write (5s) but has no enforcement — flagging without blocking is noise. As an explicit QC gate, it becomes actionable.
- Evidence: Hook runs on every Write but doesn't block commits. Files with missing Claim IDs are committed regardless.

**7. Build `/section-stats` for draft iteration visibility**
- Priority: Medium
- Effort: Moderate (1 session)
- Action: Command reads parts/*/drafts/ directory, counts draft versions per section, calculates elapsed time, compares to baseline. Add revision budget rule: if section exceeds 3 drafts, trigger meta-review.
- Evidence: Sections 2.4, 2.7, 2.8 each took 3+ drafts with cascading edits.

---

## Section 4: Pipeline Testing

Not run. Use `/repo-dd full` to include pipeline testing.

---

## Summary

**Critical findings: 3**
1. buy-side PostToolUse (Write) has 5-hook stack with 35s cumulative latency per write operation
2. Pipeline-stage agent files have no existence check before spawn — `/new-project` fails silently if any agent is deleted
3. Session-notes.md format stability is unvalidated — malformed file breaks `/wrap-session` append

**High findings: 6**
1. Friction logging infrastructure exists only in buy-side — not graduated to shared tooling
2. 228 sessions ended without `/wrap-session` during Apr 1-5 (partially mitigated, needs enforcement)
3. Exclusion list in `/deploy-workflow` is hardcoded — new commands propagate to projects if not added
4. check-claim-ids.sh runs on every write but has no enforcement teeth
5. 4 of 4 applied improvements have no verification of effectiveness
6. Symlink convention (projects consume skills via symlinks) has no runtime validation

**Medium findings: 7**
1. ai-resources and workflows entry points load context at <60% efficiency
2. Design Judgment Principles (11 lines) loaded at every entry point, never operationally invoked
3. Improvement items logged "pending" with no timeout or escalation mechanism
4. Friction log captures only auto-writes, no human friction observations
5. coach-reminder.sh has fragile date-parsing implementation
6. Heavy multi-draft iteration has no visibility or stopping criteria
7. Innovation registry exists only in ai-resources, not project-level

**Low findings: 4**
1. "How I Work" sections redundant across CLAUDE.md files
2. workflows/CLAUDE.md dormant (no sessions in 30+ days)
3. log-write-activity.sh output not consumed by any automated command
4. Delivery section in root CLAUDE.md is one-off guidance

**Top 3 recommendations by impact:**
1. **Consolidate Write hooks in buy-side** — move improve-reminder and coach-reminder to Stop hook. Saves 10s per write operation. (Quick)
2. **Graduate friction-log infrastructure to ai-resources** — enables friction capture across all repos, not just buy-side. (Quick)
3. **Enforce `/wrap-session` as mandatory** — prevents session continuity gaps that cascade into stalled improvements and lost context. (Quick)
