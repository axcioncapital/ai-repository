#!/usr/bin/env bash
# check-archive.sh [--warn-only]
# Iterates the three append-only log files and archives any over threshold.
# --warn-only emits a JSON systemMessage if any file exceeds 1.5x threshold; performs no writes.
#
# Requires CLAUDE_PROJECT_DIR — set automatically inside a Claude Code session.
# When run manually outside Claude Code, export CLAUDE_PROJECT_DIR first.

set -euo pipefail

WARN_ONLY=0
[ "${1:-}" = "--warn-only" ] && WARN_ONLY=1

PROJECT_DIR="${CLAUDE_PROJECT_DIR:?CLAUDE_PROJECT_DIR must be set (Claude Code sets this automatically; export it manually for ad-hoc runs)}"
LOGS="$PROJECT_DIR/logs"
SPLIT="$PROJECT_DIR/logs/scripts/split-log.sh"

# file:threshold:keep:order  (order is bottom for all — /wrap-session appends to end)
ENTRIES=(
    "session-notes.md:500:10:bottom"
    "decisions.md:400:20:bottom"
    "friction-log.md:450:8:bottom"
)

WARNS=()
FAILED=0
for entry in "${ENTRIES[@]}"; do
    IFS=: read -r FILE THRESHOLD KEEP ORDER <<< "$entry"
    PATH_FULL="$LOGS/$FILE"
    [ -f "$PATH_FULL" ] || continue
    LINES=$(wc -l < "$PATH_FULL" | tr -d ' ')

    if [ "$WARN_ONLY" -eq 1 ]; then
        WARN_THRESHOLD=$((THRESHOLD * 3 / 2))
        if [ "$LINES" -gt "$WARN_THRESHOLD" ]; then
            WARNS+=("$FILE: $LINES lines (warn threshold $WARN_THRESHOLD)")
        fi
        continue
    fi

    if [ "$LINES" -gt "$THRESHOLD" ]; then
        if ! bash "$SPLIT" "$PATH_FULL" "$KEEP" "$ORDER"; then
            echo "ARCHIVE FAILED for $FILE"
            FAILED=1
        fi
    fi
done

if [ "$WARN_ONLY" -eq 1 ] && [ "${#WARNS[@]}" -gt 0 ]; then
    MSG="Log files exceed 1.5x archive threshold — run /wrap-session to trigger archive: $(IFS='; '; echo "${WARNS[*]}")"
    printf '{"systemMessage":"%s"}\n' "$MSG"
fi

[ "$FAILED" -eq 1 ] && exit 1
exit 0
