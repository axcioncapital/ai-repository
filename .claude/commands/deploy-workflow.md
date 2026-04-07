Usage: /deploy-workflow [project-name]

Initialize a new project from a workflow template. Handles copying, placeholder replacement, skill symlinks, git init, and initial commit.

Arguments: `$ARGUMENTS` — optional project name in kebab-case (e.g., `market-entry-analysis`). If omitted, you will be asked.

---

## Step 1: Discover available templates

Scan for directories matching `workflows/*/` within the `ai-resources/` repo. Each subdirectory is an available workflow template.

- If **one template** found: auto-select it and tell the user which template you're using.
- If **multiple templates** found: list them and ask the user to pick one.
- If **none found**: stop and tell the user no templates are available.

Set `TEMPLATE_PATH` to the selected template directory (e.g., `ai-resources/workflows/research-workflow/`).
Set `WORKSPACE_ROOT` to the parent of the `ai-resources/` directory (the Axcíon AI workspace root containing `projects/`, etc.).

## Step 2: Get project name

If `$ARGUMENTS` contains a project name, use it. Otherwise, ask the user for a kebab-case project name.

Validate: lowercase letters, numbers, and hyphens only. No spaces, no uppercase.

Set `PROJECT_NAME` to the validated name.
Set `PROJECT_DIR` to `{WORKSPACE_ROOT}/projects/{PROJECT_NAME}`.

Verify `{PROJECT_DIR}` does not already exist. If it does, stop and tell the user.

## Step 3: Copy template

```bash
cp -r {TEMPLATE_PATH}/ {PROJECT_DIR}/
```

Confirm the copy succeeded by checking `{PROJECT_DIR}/CLAUDE.md` exists.

## Step 4: Enrich with shared ai-resources features

Symlink shared commands and agents from `ai-resources/.claude/` into the deployed project. The template includes a **shared manifest** (`.claude/shared-manifest.json`) that declares which files are shared (symlinked to ai-resources) vs local (template-owned copies). A SessionStart hook (`auto-sync-shared.sh`) reads this manifest to auto-create missing symlinks on every session start — so new commands added to ai-resources appear in projects automatically.

### How it works

The manifest has two sections per category (`commands`, `agents`):
- **`local`** — template-owned files. Already in the project from Step 3. Never overwritten, never symlinked.
- **`shared`** — symlinked to ai-resources. Created here in Step 4, and auto-maintained by the SessionStart hook.

### Hooks

Hooks are always **copied** (not symlinked) because they may need project-specific paths. Hooks excluded from copying:

**Hooks:** `pre-commit`, `check-template-drift.sh`

### Enrichment logic

```bash
AI_RESOURCES="{WORKSPACE_ROOT}/ai-resources"
MANIFEST="{PROJECT_DIR}/.claude/shared-manifest.json"

# Commands — symlink shared entries from manifest
mkdir -p "{PROJECT_DIR}/.claude/commands"
for name in $(jq -r '.commands.shared[]' "$MANIFEST"); do
  src="$AI_RESOURCES/.claude/commands/${name}.md"
  target="{PROJECT_DIR}/.claude/commands/${name}.md"
  [ -f "$src" ] || continue
  [ -e "$target" ] || [ -L "$target" ] && continue
  ln -s "$src" "$target"
done

# Agents — symlink shared entries from manifest
mkdir -p "{PROJECT_DIR}/.claude/agents"
for name in $(jq -r '.agents.shared[]' "$MANIFEST"); do
  src="$AI_RESOURCES/.claude/agents/${name}.md"
  target="{PROJECT_DIR}/.claude/agents/${name}.md"
  [ -f "$src" ] || continue
  [ -e "$target" ] || [ -L "$target" ] && continue
  ln -s "$src" "$target"
done

# Hooks (copy — not symlinked)
EXCLUDE_HOOKS="pre-commit check-template-drift.sh auto-sync-shared.sh"
mkdir -p "{PROJECT_DIR}/.claude/hooks"
for f in "$AI_RESOURCES/.claude/hooks/"*; do
  [ ! -f "$f" ] && continue
  name=$(basename "$f")
  echo "$EXCLUDE_HOOKS" | grep -qw "$name" && continue
  [ -f "{PROJECT_DIR}/.claude/hooks/$name" ] && continue
  cp "$f" "{PROJECT_DIR}/.claude/hooks/"
done
```

### Report what was added

After copying, report what was enriched:

```
Enriched project with shared features from ai-resources:
  Commands added: [list names]
  Agents added: [list names]
  Hooks added: [list names]
  Skipped (already in template): [list names]
```

If nothing was added (template already has everything), say so.

### Hooks and settings.json

Hooks require corresponding entries in `.claude/settings.json` to be active. The template's `settings.json` already registers its own hooks. If a copied hook has no `settings.json` entry, warn the operator:

> "Hook {name} was copied but has no entry in `.claude/settings.json`. It will not fire until registered. Add it manually or run `/sync-workflow` after deployment."

Do NOT auto-modify `settings.json` — hook registration requires knowing the matcher, event type, and timeout, which varies per hook.

## Step 5: Discover placeholders

Scan all files in `{PROJECT_DIR}/` for `{{...}}` patterns. Collect the unique placeholder names.

```bash
grep -roh '{{[A-Z_]*}}' {PROJECT_DIR}/ | sort -u
```

For each placeholder, check if `{PROJECT_DIR}/SETUP.md` exists and contains a description for it (look in the Placeholder Reference table or the step descriptions). Build a list of placeholders with their descriptions.

Display the list to the user:
```
Found N placeholders to fill:
- {{PLACEHOLDER_1}} — description from SETUP.md (or "no description available")
- {{PLACEHOLDER_2}} — description
...
```

## Step 6: Collect placeholder values [Operator]

Ask the user to provide values for all placeholders. Present them as a group so the user can provide all values at once, or go one by one — follow the user's preference.

For `{{OPERATOR_NAME}}`: default to the git user's first name if available (`git config user.name`). Tell the user the default and let them confirm or override.

## Step 7: Replace placeholders

For each placeholder, replace all occurrences across all files in `{PROJECT_DIR}/`:

```bash
find {PROJECT_DIR}/ -type f -name "*.md" -o -name "*.json" | xargs sed -i '' 's/{{PLACEHOLDER}}/value/g'
```

Be careful with sed special characters in values — escape `/`, `&`, and `\` in replacement strings.

After replacement, verify no `{{...}}` patterns remain:

```bash
grep -r '{{' {PROJECT_DIR}/ --include="*.md" --include="*.json"
```

If any remain, report them and ask the user for the missing values.

## Step 8: Create skill symlinks (conditional)

Only run this step if `{PROJECT_DIR}/reference/skills/` exists.

```bash
SKILLS_DIR="{WORKSPACE_ROOT}/ai-resources/skills"

for skill in "$SKILLS_DIR"/*/; do
  skill_name=$(basename "$skill")
  # Skip if a local copy already exists
  [ -d "{PROJECT_DIR}/reference/skills/$skill_name" ] && continue
  ln -s "$skill" "{PROJECT_DIR}/reference/skills/$skill_name"
done
```

Verify: list the created symlinks and confirm they resolve.

If `{WORKSPACE_ROOT}/ai-resources/skills/` does not exist, skip this step and warn the user that skills will need to be linked manually.

## Step 9: Initialize git

```bash
cd {PROJECT_DIR}
git init
git add -A
git commit -m "init: {PROJECT_NAME} workspace from research template"
```

## Step 10: Remove SETUP.md from project

The setup checklist has been completed — it should not remain in the deployed project.

```bash
cd {PROJECT_DIR}
git rm SETUP.md
git commit -m "remove setup checklist (setup complete)"
```

## Step 11: Validate

Run a quick validation:

1. Confirm no `{{...}}` placeholders remain in any `.md` or `.json` file.
2. Confirm all symlinks in `reference/skills/` resolve (if the directory exists).
3. Confirm `CLAUDE.md` exists and has at least one heading.
4. Confirm `.claude/settings.json` is valid JSON (if it exists).

Report the validation results. If all pass:

```
Project ready at: {PROJECT_DIR}

Next steps:
1. Open Claude Code in {PROJECT_DIR}/
2. Run /status to verify the project loads correctly
3. Create your first task plan draft in preparation/task-plans/
4. Run /run-preparation to begin Stage 1
```

If any validation fails, report what failed and suggest how to fix it.
