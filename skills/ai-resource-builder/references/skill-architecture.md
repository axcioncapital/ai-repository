# Skill Architecture

## Folder Structure

```
skill-name/
├── SKILL.md          # Required — main instructions
├── scripts/          # Optional — executable code for deterministic tasks
├── references/       # Optional — documentation loaded on demand
└── assets/           # Optional — files used in output (templates, icons)
```

Only create subdirectories that will contain files. No README inside skill folders.

## Size Budget

Keep SKILL.md body under 500 lines (YAML frontmatter counts). When approaching the limit, split into reference files and link from SKILL.md with guidance on when to read them.

## Progressive Disclosure

Three-level loading system:

1. **Metadata** (name + description) — always in Claude's context (~100 words)
2. **SKILL.md body** — loaded when skill triggers (<5k words)
3. **Bundled resources** — loaded as needed by Claude

Rules:
- **One level deep.** All reference files link directly from SKILL.md. Never chain references (SKILL.md -> ref-A.md -> ref-B.md).
- **TOC for long files.** Any reference file over 100 lines must include a table of contents.
- **Execute vs. read.** For every bundled script, SKILL.md must clarify whether Claude should execute it or read it as reference. Default to execute.

## Bundled Resources

| Type | When to Include | Example |
|------|----------------|---------|
| **scripts/** | Same code rewritten repeatedly; deterministic reliability needed | `scripts/rotate_pdf.py` |
| **references/** | Documentation Claude should reference while working | `references/schema.md` |
| **assets/** | Files used in output, not loaded into context | `assets/template.pptx` |

Keep SKILL.md lean. Move detailed schemas, examples, and reference material to reference files. For files >10k words, include grep search patterns in SKILL.md. Avoid duplication between SKILL.md and reference files.

**Script bundling signal:** If Claude independently generates the same helper script across multiple tasks, that's a strong signal to bundle it in `scripts/` and reference it from SKILL.md.

## Naming

- **Folder name:** kebab-case only. No spaces, underscores, or capitals.
- **Preferred form:** gerund (verb + -ing) or noun phrase: `processing-pdfs`, `pdf-processing`.
- **Namespace prefixes** for domain grouping at scale: `research-*`, `doc-*`, `mg-*`.
- **Folder name must match** the `name` field in frontmatter.
- **Avoid:** vague names (`helper`, `utils`), reserved words (`anthropic-*`, `claude-*`, `skill`).
