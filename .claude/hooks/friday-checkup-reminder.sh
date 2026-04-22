#!/bin/bash
# SessionStart hook: on Fridays, emit a reminder to run /friday-checkup
# if today's consolidated report does not yet exist in ai-resources/audits/.
# Silent on non-Fridays, and silent once today's checkup has been run.
# Non-blocking — always exit 0.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
TODAY=$(date +%Y-%m-%d)
DOW=$(date +%u)

# Only on Fridays (DOW=5)
if [ "$DOW" != "5" ]; then
    exit 0
fi

# If today's checkup report already exists, stay silent
REPORT="$PROJECT_DIR/audits/friday-checkup-${TODAY}.md"
if [ -f "$REPORT" ]; then
    exit 0
fi

msg="FRIDAY — run \`/friday-checkup\` before starting next week's work."
python3 -c "import json,sys; print(json.dumps({'systemMessage': sys.argv[1]}))" "$msg"

exit 0
