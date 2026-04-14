#!/usr/bin/env bash
# find-template.sh
#
# Given a project-relative path to a file that may be a copy of a shared
# ai-resources template, check ALL ai-resources subdirectories where that
# category of file might live, and report whether the local file is:
#
#   IDENTICAL <template-path>    — byte-identical to a template (convert to symlink)
#   DIVERGED <template-path>     — template exists but differs (possible local fork)
#   NO_TEMPLATE_FOUND            — no matching template anywhere in ai-resources
#   ERROR <message>              — mount missing, file missing, or other problem
#
# Exit codes:
#   0 — IDENTICAL
#   1 — DIVERGED
#   2 — NO_TEMPLATE_FOUND
#   3 — ERROR (including ai-resources not mounted)
#
# Usage:
#   find-template.sh <project-relative-path>
#
# Example:
#   cd projects/buy-side-service-plan
#   ../../ai-resources/skills/worktree-cleanup-investigator/scripts/find-template.sh .claude/commands/run-report.md

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "ERROR usage: find-template.sh <project-relative-path>" >&2
    exit 3
fi

INPUT_PATH="$1"

if [ ! -f "$INPUT_PATH" ] && [ ! -L "$INPUT_PATH" ]; then
    echo "ERROR input file not found: $INPUT_PATH" >&2
    exit 3
fi

# Walk up from CWD looking for an `ai-resources` sibling directory.
# This is how Axcion projects are laid out: the project lives under
# Axcion AI Repo/projects/<project>/ and ai-resources/ is a sibling
# of projects/ at the repo root.
find_ai_resources() {
    local dir
    dir="$(pwd)"
    while [ "$dir" != "/" ]; do
        if [ -d "$dir/ai-resources" ]; then
            echo "$dir/ai-resources"
            return 0
        fi
        dir="$(dirname "$dir")"
    done
    return 1
}

AI_RESOURCES="$(find_ai_resources || true)"

if [ -z "$AI_RESOURCES" ]; then
    echo "ERROR ai-resources directory not found walking up from $(pwd). Is the workspace mounted correctly (--add-dir)?" >&2
    exit 3
fi

# Build the list of candidate template locations based on the input path's
# category. The rule: for any .claude/commands/*.md or .claude/agents/*.md,
# check BOTH ai-resources/.claude/... AND ai-resources/workflows/*/.claude/...
# Missing one of these locations is the false-negative class this script
# exists to eliminate.
declare -a CANDIDATES=()

case "$INPUT_PATH" in
    .claude/commands/*.md)
        basename="${INPUT_PATH#.claude/commands/}"
        CANDIDATES+=("$AI_RESOURCES/.claude/commands/$basename")
        # glob all workflow templates
        for wf_dir in "$AI_RESOURCES"/workflows/*/; do
            [ -d "$wf_dir" ] || continue
            CANDIDATES+=("${wf_dir}.claude/commands/$basename")
        done
        ;;
    .claude/agents/*.md)
        basename="${INPUT_PATH#.claude/agents/}"
        CANDIDATES+=("$AI_RESOURCES/.claude/agents/$basename")
        for wf_dir in "$AI_RESOURCES"/workflows/*/; do
            [ -d "$wf_dir" ] || continue
            CANDIDATES+=("${wf_dir}.claude/agents/$basename")
        done
        ;;
    .claude/hooks/*.sh|.claude/hooks/*.py)
        basename="${INPUT_PATH#.claude/hooks/}"
        CANDIDATES+=("$AI_RESOURCES/.claude/hooks/$basename")
        for wf_dir in "$AI_RESOURCES"/workflows/*/; do
            [ -d "$wf_dir" ] || continue
            CANDIDATES+=("${wf_dir}.claude/hooks/$basename")
        done
        ;;
    *)
        # Not a category this script knows how to check.
        echo "NO_TEMPLATE_FOUND"
        exit 2
        ;;
esac

# Check each candidate. Report the FIRST match found (identical or diverged).
# Identical takes precedence — if the file matches any template byte-for-byte,
# report that even if other templates also exist and differ.
DIVERGED_MATCH=""
for candidate in "${CANDIDATES[@]}"; do
    if [ -f "$candidate" ]; then
        if cmp -s "$INPUT_PATH" "$candidate"; then
            echo "IDENTICAL $candidate"
            exit 0
        else
            # Remember the first diverged match but keep looking for an
            # identical match in case one exists in a later candidate.
            if [ -z "$DIVERGED_MATCH" ]; then
                DIVERGED_MATCH="$candidate"
            fi
        fi
    fi
done

if [ -n "$DIVERGED_MATCH" ]; then
    echo "DIVERGED $DIVERGED_MATCH"
    exit 1
fi

echo "NO_TEMPLATE_FOUND"
exit 2
