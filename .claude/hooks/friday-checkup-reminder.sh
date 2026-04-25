#!/bin/bash
# SessionStart hook: on Fridays, emit a reminder to run /friday-checkup
# if today's consolidated report does not yet exist in ai-resources/audits/.
# On non-Fridays, warn if the last checkup report is > 10 days old.
# Non-blocking — always exit 0.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)

# On non-Fridays: warn if last checkup is stale (> 10 days)
if [ "$DOW" != "5" ]; then
    LATEST_REPORT=$(ls -1 "$PROJECT_DIR/audits/friday-checkup-"*.md 2>/dev/null | sort | tail -1)
    if [ -z "$LATEST_REPORT" ]; then
        exit 0
    fi
    REPORT_DATE=$(basename "$LATEST_REPORT" | sed 's/friday-checkup-\(.*\)\.md/\1/')
    DAYS=$(python3 -c "from datetime import date; print((date.today() - date.fromisoformat('$REPORT_DATE')).days)" 2>/dev/null)
    if [ -n "$DAYS" ] && [ "$DAYS" -gt 10 ]; then
        msg="STALE CHECKUP — Last /friday-checkup was ${DAYS} days ago (threshold: 10). Run /friday-checkup before starting work."
        python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$msg"
    fi
    exit 0
fi

# On Fridays: remind if today's checkup report is missing
REPORT="$PROJECT_DIR/audits/friday-checkup-${TODAY}.md"
if [ -f "$REPORT" ]; then
    exit 0
fi

msg="FRIDAY — run \`/friday-checkup\` before starting next week's work."
python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$msg"

exit 0
