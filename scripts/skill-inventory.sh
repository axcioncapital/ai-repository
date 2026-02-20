#!/bin/bash
# Skill inventory: lists all skills with their descriptions
# Run: bash scripts/skill-inventory.sh
#
# Useful for: quick reference of what exists, finding gaps,
# sharing the skill catalog with Daniel

set -e

echo "=== Skill Inventory: $(date '+%Y-%m-%d') ==="
echo ""

skill_count=0

# Find all SKILL.md files
skill_files=$(find skills/ -name "SKILL.md" -type f | sort 2>/dev/null || true)

if [ -z "$skill_files" ]; then
    echo "No skills found in skills/ directory."
    exit 0
fi

for skill_file in $skill_files; do
    skill_dir=$(dirname "$skill_file")
    skill_name=$(basename "$skill_dir")
    skill_count=$((skill_count + 1))

    # Extract description from frontmatter
    first_line=$(head -n 1 "$skill_file")
    if [ "$first_line" = "---" ]; then
        closing_line=$(tail -n +2 "$skill_file" | grep -n "^---$" | head -1 | cut -d: -f1)
        if [ -n "$closing_line" ]; then
            frontmatter=$(head -n $((closing_line + 1)) "$skill_file" | tail -n +2 | head -n $((closing_line - 1)))
            description=$(echo "$frontmatter" | grep "^description:" | sed 's/^description:\s*//' | head -c 200)
        else
            description="(frontmatter parse error)"
        fi
    else
        description="(no frontmatter)"
    fi

    # Count body lines
    total_lines=$(wc -l < "$skill_file")
    if [ -n "$closing_line" ]; then
        body_lines=$((total_lines - closing_line - 1))
    else
        body_lines=$total_lines
    fi

    # Check for bundled resources
    resources=""
    [ -d "$skill_dir/scripts" ] && [ -n "$(ls -A "$skill_dir/scripts" 2>/dev/null)" ] && resources="${resources}scripts "
    [ -d "$skill_dir/references" ] && [ -n "$(ls -A "$skill_dir/references" 2>/dev/null)" ] && resources="${resources}references "
    [ -d "$skill_dir/assets" ] && [ -n "$(ls -A "$skill_dir/assets" 2>/dev/null)" ] && resources="${resources}assets "
    [ -z "$resources" ] && resources="none"

    # Check for tests
    has_tests="no"
    [ -d "tests/$skill_name" ] && has_tests="yes"

    # Last modified
    last_modified=$(git log -1 --format="%cs" -- "$skill_file" 2>/dev/null || echo "unknown")

    echo "$skill_count. $skill_name"
    echo "   Description: $description"
    echo "   Lines: $body_lines | Resources: $resources| Tests: $has_tests | Updated: $last_modified"
    echo ""
done

echo "--- Total: $skill_count skills ---"
