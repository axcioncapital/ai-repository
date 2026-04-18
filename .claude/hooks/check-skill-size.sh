#!/bin/bash
# Informational pre-commit warning: SKILL.md files exceeding the 300-line
# convention. Non-blocking — emits warnings only and exits 0.
#
# Threshold rationale: 2026-04-18 token-audit §2.1 and §9.3 safeguard #4.
# Skills above 300 lines disproportionately drive per-load context cost;
# warning at commit time catches drift before the next audit.
#
# Invoked by .claude/hooks/pre-commit after its blocking checks. Can also
# be run standalone: bash .claude/hooks/check-skill-size.sh

THRESHOLD=300

staged_skills=$(git diff --cached --name-only --diff-filter=ACM | grep "SKILL.md$" || true)

if [ -z "$staged_skills" ]; then
    exit 0
fi

warnings=0
for skill_file in $staged_skills; do
    [ -f "$skill_file" ] || continue
    lines=$(wc -l < "$skill_file")
    if [ "$lines" -gt "$THRESHOLD" ]; then
        echo "  INFO: $skill_file is $lines lines (convention: under $THRESHOLD)" >&2
        warnings=$((warnings + 1))
    fi
done

if [ "$warnings" -gt 0 ]; then
    echo "  ($warnings skill(s) above $THRESHOLD lines — informational only, commit not blocked)" >&2
fi

exit 0
