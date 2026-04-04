# CLAUDE.md Additions: Content Lifecycle

Add these sections to the project's CLAUDE.md when this module is included.

---

## Content Lifecycle

All content follows the same lifecycle:
- `parts/*/notes/` — raw thinking, brainstorms, fragments
- `parts/*/drafts/` — working drafts, numbered by iteration (draft-01.md, draft-02.md)
- `parts/*/approved/` — finalized content that has passed QC review

Never skip the QC step before moving content to approved/.
Never overwrite a previous draft — always create a new numbered version.

## Plan Mode

Use plan mode as the default for content work. Before executing a drafting task,
present the full plan — which files will be read, what structure the output will follow,
which sources will be drawn from. Wait for {{OPERATOR_NAME}}'s approval before drafting.
Skip plan mode only for simple, well-defined tasks (adding a glossary term, renaming a file,
showing the last decision logged).

## Save Progress Incrementally

During long drafting sessions, save the current state of the draft to the drafts/
directory periodically. This ensures progress is preserved if the session ends
unexpectedly or context needs to be compacted.
