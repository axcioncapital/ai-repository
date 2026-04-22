# Decision Journal

> Archive: [decisions-archive-2026-04.md](decisions-archive-2026-04.md)

## 2026-04-21 — Permission settings: fix nested .claude/** glob gap

- **Context:** During refactor execution, harness permission prompts fired on edits to `ai-resources/workflows/research-workflow/.claude/commands/produce-prose-draft.md` despite the operator having granted autonomy. Investigation showed `Write(ai-resources/**)` failed to match because most glob engines don't traverse dotfile path components (`.claude`) via `**` by default, and `Write(.claude/**)` only matches root-level `.claude/`. The nested `.claude/` in `ai-resources/workflows/research-workflow/` fell in the gap.
- **Decision:** Add `Write(**/.claude/**)` / `Edit(**/.claude/**)` + bare-dir variants + an absolute-path catchall (`Write(/Users/patrik.lindeberg/Claude Code/Axcion AI Repo/**)`) to both the workspace-level and ai-resources-level settings.json files. Leave intentionally scoped settings (obsidian-pe-kb/vault, nordic-pe-landscape-mapping-4-26/step-1-long-list) untouched.
- **Rationale:** Belt-and-suspenders. `**/.claude/**` handles the dotfile glob gap; the absolute-path catchall bypasses any remaining glob quirks for paths inside the workspace tree. Other project-level settings already use bare `Edit`/`Write` with no path-scoping, so the fix isn't needed there. Intentionally scoped settings protect raw data (vault) and web-only scopes (step-1-long-list) — those stay as-is by design.
- **Alternatives considered:**
  - Convert all path-scoped permission lists to bare `Edit`/`Write` across the tree (rejected: would lose intentional data-safety scoping in vault and step-1-long-list).
  - Add only the `**/.claude/**` patterns without absolute-path catchall (rejected: any other glob quirk we haven't identified would still bite).
  - Leave the issue (rejected: operator explicitly demanded the fix).
- **Follow-up:**
  - Settings changes take effect on next Claude Code session restart.
  - If prompts still fire in specific flows not caught by these patterns, add additional explicit rules per case.

## 2026-04-22 — Defer SC-02 (hook validation debt) from 2026-04-21 setup scan

- **Context:** Operator approved "All P0 + P1" from the 2026-04-21 setup scan, which includes SC-02: "6 hooks deployed 2026-03-28 remain unvalidated." Phase 1 exploration searched git history for a 2026-03-28 hook-deployment event and found nothing. Current hooks (`ai-resources/.claude/hooks/` + workspace `.claude/hooks/` + bssp `.claude/hooks/`) exist and are wired into their respective `settings.json` files; they appear functional.
- **Decision:** Do not implement SC-02 this session. Commit the plan with SC-02 flagged as deferred and note in commit messages + session summary. Recommend the operator raise via `/improve` for triage.
- **Rationale:** The scan's premise ("6 hooks deployed 2026-03-28 remain unvalidated") is the load-bearing piece of SC-02 — without knowing which hooks are in scope, "validation" has no target set. Current hooks could be validated wholesale, but that's a different task (broader hook audit) and consumes a session on its own. Proceeding on the 6-hook premise without evidence would either (a) waste effort validating hooks that weren't in the original list, or (b) miss hooks that were.
- **Alternatives considered:**
  - Validate all currently-deployed hooks (rejected: scope expansion; the operator approved the scan's items, not a general hook audit; would bloat this session's commit into incidental work).
  - Spot-check a random 6 (rejected: arbitrary selection without the original list is theatre — not validation).
  - Proceed by inferring the 6 from hook filenames containing "auto-commit / bright-line / context-loader / checkpoint / session-wrap / decision-logging" (rejected: several of those are inline `settings.json` commands, not named `.sh` files — inference is unreliable).
- **Follow-up:**
  - Operator raises via `/improve` with any external context on the original list.
  - If no external record survives, reframe as a broader hook-inventory + spot-check task and re-scope under a new SC-ID.

## 2026-04-22 — Flag vault `.claude/settings.json` as gitignored (SC-04 persistence risk)

- **Context:** SC-04 required adding `"additionalDirectories": ["../../../"]` to `projects/obsidian-pe-kb/vault/.claude/settings.json` to unblock the vault's 43 shared-command symlinks and SessionStart hook. Edit applied on disk. During the commit step, `git status` showed neither the vault repo nor the obsidian-pe-kb parent repo recognizing the change.
- **Finding:** `obsidian-pe-kb/.gitignore` contains `vault/` — parent ignores everything under vault. The vault repo itself also ignores `.claude/settings.json`. The edit persists on disk but is not version-controlled. If the vault is ever re-bootstrapped from a template, the `additionalDirectories` key will be lost unless the template includes it.
- **Decision:** Do not modify `.gitignore` rules this session. Flag the persistence question to the operator for design decision.
- **Rationale:** Two plausible intents behind the existing gitignore:
  - **(a) Local-only by design:** The vault's settings.json contains user-specific paths or preferences that shouldn't cross machines. If so, the template that seeds the vault should include `additionalDirectories` in its default so it's regenerated on bootstrap.
  - **(b) Gitignore is overly broad:** The vault's config is project-scoped and should be tracked. If so, the `.gitignore` entry can be removed / narrowed (e.g., `vault/.claude/settings.local.json` only).
- **Alternatives considered:**
  - Remove the gitignore entry and stage settings.json (rejected: policy-level change; the operator hasn't confirmed (b) is the intended design).
  - Commit the edit to ai-resources or project-planning as a "snapshot" note (rejected: puts the authoritative vault config in a non-canonical location; worse than leaving on-disk).
- **Follow-up:**
  - Operator decides between (a) and (b). Either path resolves the persistence concern.

## 2026-04-22 — SC-04 resolved: commit edit + seed template (both)

- **Context:** Prior session's wrap note flagged two mutually-exclusive fix options for the vault `settings.json` persistence risk — (a) update bootstrap template so `additionalDirectories` seeds at vault creation, or (b) narrow gitignore so the file tracks in git.
- **Decision:** Do both, but reframed. Phase 1 exploration proved the premise of option (b) was wrong — the file is already tracked (gitignore negation at `projects/obsidian-pe-kb/.gitignore:4`). The on-disk edit just needed committing. The canonical "template" is the tech spec at `pipeline/technical-spec.md` §4; that got the `additionalDirectories` seed plus a rationale entry.
- **Rationale:** Committing the existing edit fixes the immediate persistence risk. Updating the tech spec fixes the future-re-bootstrap risk. Orthogonal fixes; no reason to pick one.
- **Alternatives considered:**
  - Narrow gitignore (rejected: unnecessary — negation already works).
  - Build a new bootstrap seeder script (rejected: overbuilt; tech spec is the source of truth for this project, no shared template to centralize).
- **Follow-up:** None. Both edits committed in obsidian-pe-kb `3b148e3`.

## 2026-04-22 — SC-02 reframed from unverifiable baseline to full-inventory task

- **Context:** Setup scan at `reports/setup-improvement-scan-2026-04-21.md:50–58` claimed 6 hooks were deployed 2026-03-28 and remain unvalidated. Prior session could not verify the 6-hook list in git history and deferred the item.
- **Decision:** Reframe from "validate the specific 6 hooks from 2026-03-28" to "inventory every currently deployed hook (29 found) and verify each fires correctly." Log as `logged (pending)` in `improvement-log.md` for a future dedicated maintenance session.
- **Rationale:** Can't validate an unknowable baseline. The broader inventory is actionable — 29 hooks found, each with an identifiable trigger type, testable in a spawned session. Logging direct to the improvement-log (bypassing `/improve`) because `/improve` chains off `friction-log.md` and there is no matching friction entry; this is a scan-originated finding.
- **Alternatives considered:**
  - Invoke `/improve` (rejected: the command's Step 1 requires friction-log context which doesn't exist for this item).
  - Execute the 29-hook inventory in this same session (rejected: ~1 hour of scope creep; no active friction driving urgency).
  - Dismiss entirely (rejected: 29 unvalidated hooks is real latent risk; logging preserves the action).
- **Follow-up:** Pending session — inventory all 29 hooks, verify each fires; consider building `/validate-hooks` if the work benefits from reuse.
