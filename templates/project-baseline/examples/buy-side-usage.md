# Example: Buy-Side Service Plan

How the buy-side-service-plan project maps to this template. Reference for the architecture-designer when designing new projects.

## Baseline Usage

All baseline components are present. Key customizations:

### CLAUDE.md
- **Project Context:** PE buy-side service model, Teixeira analytical framework, current phase tracking
- **Operator Profile:** Patrik as sole operator (standard pattern)
- **Workflow Overview:** Five-stage research pipeline (Preparation → Execution → Analysis → Report → Final) with artifact chain
- **Added sections beyond baseline:**
  - Cross-Model Rules (GPT-5 for research, Perplexity for retrieval, Claude for analysis)
  - Citation Conversion Rule (chapter-level bibliographies)
  - Service Development Workflow (three-part content architecture with sequencing)
  - @import references to `reference/stage-instructions.md`, `reference/file-conventions.md`, `reference/quality-standards.md`

### Commands
- `/prime` customized with research pipeline status scan + service development status scan
- `/status` customized with stage directory file counts and QC verdicts
- 25 additional project-specific commands (pipeline stage runners, content tools, workflow utilities)

### Agents
- 6 agents total: qc-gate, qc-reviewer, verification-agent, execution-agent, research-synthesizer, improvement-analyst

### Settings
- Base permissions unchanged from template
- Extensive hooks added via modules (see below)

## Modules Included

### Content Lifecycle
- `parts/` directory with `working-hypotheses/`, `part-2-service/`, `part-3-strategy/`
- Each containing `notes/`, `drafts/`, `approved/`
- `/draft-section` command customized for the content architecture

### Friction Logging
- Both hook scripts deployed to `.claude/hooks/`
- `/improve` command present
- `friction-log: true` added to 10 commands' frontmatter

### Bright-Line Editing
- Protected directories: `report/chapters/` and `final/modules/`
- Three-check rule in CLAUDE.md
- PreToolUse hook on Edit tool

### Auto-Commit
- Stage directories: `preparation/`, `execution/`, `analysis/`, `report/`
- PostToolUse hook on Write tool
- Also includes a Claim ID coverage check (project-specific, not in template)

### Session Context Hooks
- SessionStart: loads latest checkpoint from stage checkpoint directories
- Stop: warns if no checkpoint written in last 2 hours + logs session end

### Verification Agent
- Deployed as `verification-agent.md` in `.claude/agents/`
- Used for independent re-derivation of high-stakes analytical outputs

## Beyond the Template

Components the buy-side project has that are NOT covered by the template:

- **22 symlinked skills** from ai-resources (project-specific skill selection)
- **1 local skill** (report-compliance-qc, project-specific)
- **Claim ID system** with check-claim-ids.sh hook (research-workflow-specific)
- **UserPromptSubmit hook** for decision logging (could become a module if other projects need it)
- **context/ directory** with project-brief.md, content-architecture.md, style-guide.md, glossary.md, domain-knowledge.md (content is fully project-specific)
- **reference/file-conventions.md** with 35+ canonical naming patterns (research-workflow-specific)
- **reference/stage-instructions.md** (16k+ bytes of workflow definitions)
- **reference/sops/** (standard operating procedures)
