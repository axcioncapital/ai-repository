#!/bin/bash
# Repo audit: scans all skills for structural issues
# Run manually: bash scripts/repo-audit.sh
# Or via Claude Code headless mode for periodic health checks
#
# Unlike the pre-commit hook (which only checks staged files),
# this scans the entire repo to catch drift over time.

set -e

echo "=== Repo Audit: $(date '+%Y-%m-%d %H:%M') ==="
echo ""

errors=0
warnings=0
skill_count=0

# Find all SKILL.md files in the repo
skill_files=$(find skills/ -name "SKILL.md" -type f 2>/dev/null || true)

if [ -z "$skill_files" ]; then
    echo "No skills found in skills/ directory."
    exit 0
fi

for skill_file in $skill_files; do
    skill_dir=$(dirname "$skill_file")
    skill_name=$(basename "$skill_dir")
    skill_count=$((skill_count + 1))

    echo "--- $skill_name ---"
    file_errors=0

    # --- Structural checks (same as pre-commit) ---

    # Folder naming
    if [[ ! "$skill_name" =~ ^[a-z0-9]([a-z0-9-]*[a-z0-9])?$ ]]; then
        echo "  ERROR: Folder name '$skill_name' violates naming convention"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
    fi

    # Frontmatter
    first_line=$(head -n 1 "$skill_file")
    if [ "$first_line" != "---" ]; then
        echo "  ERROR: Missing YAML frontmatter"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
        continue
    fi

    closing_line=$(tail -n +2 "$skill_file" | grep -n "^---$" | head -1 | cut -d: -f1)
    if [ -z "$closing_line" ]; then
        echo "  ERROR: Unclosed YAML frontmatter"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
        continue
    fi

    frontmatter=$(head -n $((closing_line + 1)) "$skill_file" | tail -n +2 | head -n $((closing_line - 1)))

    # Required fields
    if ! echo "$frontmatter" | grep -q "^name:"; then
        echo "  ERROR: Missing 'name' in frontmatter"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
    fi

    if ! echo "$frontmatter" | grep -q "^description:"; then
        echo "  ERROR: Missing 'description' in frontmatter"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
    fi

    # Empty description
    desc_value=$(echo "$frontmatter" | grep "^description:" | sed 's/^description:\s*//')
    if [ -z "$desc_value" ] || [ "$desc_value" = "''" ] || [ "$desc_value" = '""' ]; then
        echo "  ERROR: Description field is empty"
        errors=$((errors + 1))
        file_errors=$((file_errors + 1))
    fi

    # Body length
    total_lines=$(wc -l < "$skill_file")
    body_lines=$((total_lines - closing_line - 1))
    if [ "$body_lines" -gt 500 ]; then
        echo "  WARN: Body is $body_lines lines (convention: under 500)"
        warnings=$((warnings + 1))
    fi

    # Prohibited files
    for prohibited in "README.md" "CHANGELOG.md" "INSTALLATION_GUIDE.md" "QUICK_REFERENCE.md"; do
        if [ -f "$skill_dir/$prohibited" ]; then
            echo "  ERROR: Prohibited file '$prohibited' found"
            errors=$((errors + 1))
            file_errors=$((file_errors + 1))
        fi
    done

    # Broken cross-references
    body_content=$(tail -n +$((closing_line + 2)) "$skill_file")
    referenced_files=$(echo "$body_content" | grep -oP '\[.*?\]\(((?!http)[^)]+)\)' | grep -oP '\(([^)]+)\)' | tr -d '()' || true)

    for ref in $referenced_files; do
        ref_path="$skill_dir/$ref"
        if [ ! -f "$ref_path" ]; then
            echo "  ERROR: Broken reference '$ref' — file does not exist"
            errors=$((errors + 1))
            file_errors=$((file_errors + 1))
        fi
    done

    # --- Audit-only checks (not in pre-commit) ---

    # Last modified date
    last_modified=$(git log -1 --format="%ci" -- "$skill_file" 2>/dev/null || echo "unknown")
    if [ "$last_modified" != "unknown" ]; then
        days_ago=$(( ($(date +%s) - $(date -d "$last_modified" +%s 2>/dev/null || date -j -f "%Y-%m-%d %H:%M:%S %z" "$last_modified" +%s 2>/dev/null || echo 0)) / 86400 ))
        if [ "$days_ago" -gt 90 ]; then
            echo "  WARN: Last modified $days_ago days ago — may need review"
            warnings=$((warnings + 1))
        fi
    fi

    # Empty subdirectories
    for subdir in "scripts" "references" "assets"; do
        if [ -d "$skill_dir/$subdir" ] && [ -z "$(ls -A "$skill_dir/$subdir" 2>/dev/null)" ]; then
            echo "  WARN: Empty subdirectory '$subdir/' — remove or populate"
            warnings=$((warnings + 1))
        fi
    done

    # Test case existence
    test_dir="tests/$skill_name"
    if [ ! -d "$test_dir" ]; then
        echo "  WARN: No test cases found (expected at tests/$skill_name/)"
        warnings=$((warnings + 1))
    fi

    if [ $file_errors -eq 0 ]; then
        echo "  OK"
    fi
done

echo ""
echo "=== Summary ==="
echo "Skills scanned: $skill_count"
echo "Errors: $errors"
echo "Warnings: $warnings"

if [ $errors -gt 0 ]; then
    echo "Status: ISSUES FOUND"
    exit 1
else
    echo "Status: CLEAN"
    exit 0
fi
