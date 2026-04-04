#!/bin/bash
# PostToolUse hook: Check for [CITATION NEEDED] tags in pipeline artifacts.
# Non-blocking (exit 0) — warns Claude so it can address missing Claim IDs
# before they propagate downstream.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only check pipeline artifact paths
echo "$FILE_PATH" | grep -qE '/(analysis/chapters|analysis/cluster-memos|report/chapters|execution/research-extracts)/' || exit 0

# Skip non-markdown files
echo "$FILE_PATH" | grep -qE '\.md$' || exit 0

# Skip style spec, CTL, and checkpoint files
echo "$FILE_PATH" | grep -qE '(style-reference|ctl\.md|checkpoint)' && exit 0

# Count [CITATION NEEDED] tags (grep -o counts occurrences, not lines)
COUNT=$(grep -o '\[CITATION NEEDED\]' "$FILE_PATH" 2>/dev/null | wc -l | tr -d ' ')

if [ "$COUNT" -gt 0 ]; then
  # Determine severity based on pipeline stage
  if echo "$FILE_PATH" | grep -qE '/report/chapters/'; then
    echo "CLAIM ID INVARIANT WARNING: $COUNT [CITATION NEEDED] tag(s) in report prose: $(basename "$FILE_PATH"). Per quality-standards.md, report prose must not contain [CITATION NEEDED] for any assertion with a traceable source. If the source is known but the Claim ID is missing, assign the ID upstream before proceeding." >&2
  elif echo "$FILE_PATH" | grep -qE '/analysis/chapters/'; then
    echo "CLAIM ID CHECK: $COUNT [CITATION NEEDED] tag(s) in chapter draft: $(basename "$FILE_PATH"). These will block citation conversion at Stage 4.6 unless Claim IDs are assigned. Check if these assertions have known sources that should have received IDs at Step 2.S4 or Step 3.S3." >&2
  elif echo "$FILE_PATH" | grep -qE '/analysis/cluster-memos/'; then
    echo "CLAIM ID CHECK: $COUNT [CITATION NEEDED] tag(s) in cluster memo: $(basename "$FILE_PATH"). If these are from gap-fill or supplementary evidence with known sources, assign Claim IDs now (GF[cluster]-C[##] format) before they propagate to chapter drafts." >&2
  elif echo "$FILE_PATH" | grep -qE '/execution/research-extracts/'; then
    echo "CLAIM ID CHECK: $COUNT [CITATION NEEDED] tag(s) in research extract: $(basename "$FILE_PATH"). Extracts should not contain [CITATION NEEDED] — every assertion must have a Claim ID. Decompose any block-level findings into individual claims." >&2
  fi
fi

exit 0
