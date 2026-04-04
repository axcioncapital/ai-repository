# Module: Auto-Commit

## When to Include

Projects with pipeline stage directories that produce artifacts progressively — where each stage writes files that should be committed immediately to preserve progress and enable recovery.

Skip for projects without stage-based artifact production, or where manual commits are preferred.

## What It Adds

1. **PostToolUse hook** — Auto-commits artifacts written to stage directories with a descriptive commit message: `Auto-commit [{stage}]: {filename}`

## How to Adapt

- Change the directory pattern in `grep -qE` to match the project's stage directories (e.g., `/(preparation|execution|analysis|report)/`)
- Adjust the `sed` command that extracts the stage name from the file path to match the project's directory structure
- The hook uses `$CLAUDE_PROJECT_DIR` so it's portable across project locations
