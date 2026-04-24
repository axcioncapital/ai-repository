# Workspace Health Report

**Date:** 2026-04-06
**Mode:** Full Audit
**Overall:** YELLOW

---

## Executive Summary

The ai-resources workspace is in strong health with mature 2026 best practices adoption, clean file organization, and solid cross-reference integrity across 60 skills, 37 commands, and 15 agents. The most actionable finding is a non-executable hook script (check-claim-ids.sh) in the research workflow template that will fail silently at runtime. The top recommendation is to fix the hook script permissions and update the workflow template's audit-repo command to include the recently added context-health-auditor.

## Scores

| Area | Score | Critical | Important | Minor |
|------|-------|----------|-----------|-------|
| File Organization | GREEN | 0 | 0 | 0 |
| CLAUDE.md Health | GREEN | 0 | 0 | 0 |
| Skill Inventory | YELLOW | 0 | 1 | 6 |
| Commands & Subagents | GREEN | 0 | 0 | 1 |
| Settings & Permissions | YELLOW | 0 | 1 | 0 |
| 2026 Best Practices | GREEN | 0 | 0 | 2 |
| Context Health | GREEN | 0 | 0 | 2 |

## Findings

### Critical (Fix Now)

No critical findings.

### Important (Fix Soon)

- **[Settings & Permissions] Hook script check-claim-ids.sh is not executable**
  The hook script at workflows/research-workflow/.claude/hooks/check-claim-ids.sh has permissions -rw-r--r-- (not executable). It is referenced by the PostToolUse Write hook in workflows/research-workflow/.claude/settings.json. The other 3 hook scripts (detect-innovation.sh, friction-log-auto.sh, log-write-activity.sh) are executable.
  *Location:* `workflows/research-workflow/.claude/hooks/check-claim-ids.sh`
  *Recommendation:* Run: chmod +x workflows/research-workflow/.claude/hooks/check-claim-ids.sh

- **[Skill Inventory] answer-spec-generator approaches 500-line limit (485 lines)**
  SKILL.md body is 485 lines, close to the 500-line convention limit. This is the longest skill in the repo.
  *Location:* `skills/answer-spec-generator/SKILL.md`
  *Recommendation:* Extract procedural sections to references/ to bring body under 300 lines

### Improvement Opportunities

- **[Skill Inventory] ai-resource-builder exceeds 300-line recommendation (463 lines)**
  SKILL.md body is 463 lines. Consider moving more content to reference files.
  *Location:* `skills/ai-resource-builder/SKILL.md`
  *Recommendation:* Review whether additional sections can be extracted to references/

- **[Skill Inventory] research-plan-creator exceeds 300-line recommendation (464 lines)**
  SKILL.md body is 464 lines.
  *Location:* `skills/research-plan-creator/SKILL.md`
  *Recommendation:* Review whether reference extraction would help

- **[Skill Inventory] evidence-to-report-writer exceeds 300-line recommendation (332 lines)**
  SKILL.md body is 332 lines.
  *Location:* `skills/evidence-to-report-writer/SKILL.md`
  *Recommendation:* Minor overage -- monitor for growth

- **[Skill Inventory] prose-compliance-qc exceeds 300-line recommendation (321 lines)**
  SKILL.md body is 321 lines.
  *Location:* `skills/prose-compliance-qc/SKILL.md`
  *Recommendation:* Minor overage -- monitor for growth

- **[Skill Inventory] session-guide-generator exceeds 300-line recommendation (320 lines)**
  SKILL.md body is 320 lines.
  *Location:* `skills/session-guide-generator/SKILL.md`
  *Recommendation:* Minor overage -- monitor for growth

- **[Skill Inventory] workflow-evaluator exceeds 300-line recommendation (316 lines)**
  SKILL.md body is 316 lines.
  *Location:* `skills/workflow-evaluator/SKILL.md`
  *Recommendation:* Minor overage -- monitor for growth

- **[Commands & Subagents] 6 command filenames duplicated across scopes**
  The following commands exist in both .claude/commands/ and workflows/research-workflow/.claude/commands/: audit-repo.md, friction-log.md, improve.md, note.md, update-claude-md.md, usage-analysis.md. This is likely intentional scope override for the research workflow template.
  *Location:* `.claude/commands/ and workflows/research-workflow/.claude/commands/`
  *Recommendation:* Verify these are intentional overrides. If they are identical copies rather than scope-specific variants, consolidate to avoid maintenance drift.

- **[2026 Best Practices] Coach command allows agent to read files directly**
  The /coach command instructs: 'The agent reads all log files directly.' This is a deviation from strict context isolation, though pragmatic for large log files.
  *Location:* `.claude/commands/coach.md`
  *Recommendation:* Acceptable trade-off for large-file scenarios. Document this as an intentional exception if not already noted.

- **[2026 Best Practices] QC gate agent uses sonnet model**
  The qc-gate agent in the research workflow template uses model: sonnet. QC tasks involving analytical judgment may benefit from opus for higher quality verdicts.
  *Location:* `workflows/research-workflow/.claude/agents/qc-gate.md`
  *Recommendation:* Advisory only -- consider whether QC complexity warrants opus assignment.

- **[Context Health] Workflow template audit-repo.md missing context-health-auditor reference**
  The ai-resources .claude/commands/audit-repo.md lists 8 agent files including context-health-auditor.md, but the workflow template version only lists 7 (missing context-health-auditor). Deployed projects using the template will not run the context health audit.
  *Location:* `workflows/research-workflow/.claude/commands/audit-repo.md`
  *Recommendation:* Update the workflow template audit-repo.md to include context-health-auditor.md in its agent list.

- **[Context Health] Recent SKILL.md changes in 8 skills over last 10 commits**
  The last 10 commits modified SKILL.md files for 8 skills (additive changes: failure behavior, runtime recommendations). Changes are consistent and non-breaking.
  *Location:* `skills/*/SKILL.md (8 skills modified)`
  *Recommendation:* No action needed. Changes are additive and non-breaking.

## Detailed Analysis

### File Organization
File organization is clean. All 60 skill directories follow lowercase kebab-case naming, all contain SKILL.md files (no orphans), and no symlinks exist in the workspace. The expected directory structure (.claude/, skills/, workflows/) is present with CLAUDE.md at the root. Key metrics: 60 skill directories, 0 symlinks, 0 broken symlinks, 2 CLAUDE.md files.

### CLAUDE.md Health
Both CLAUDE.md files are well within size limits (86 and 85 lines). The root CLAUDE.md has clear orientation and structure. The workflow template CLAUDE.md uses @reference imports for detailed instructions, keeping the core file lean. All 4 @reference targets exist (stage-instructions.md, file-conventions.md, quality-standards.md, style-guide.md). No secrets detected, no contradictions between levels.

### Skill Inventory
All 60 skills have valid frontmatter with name and description fields. All descriptions include trigger conditions and exclusions. No orphaned skill directories found. 7 skills exceed the 300-line recommendation, with answer-spec-generator (485 lines) approaching the 500-line limit. All internal reference files verified present. Average skill size: 197 lines.

### Commands & Subagents
36 command files and 15 agent definitions found across the workspace. No symlinks, no dead references. All agent files have valid frontmatter with name, description, tools, and model fields. 6 command filenames are duplicated across ai-resources and workflow scopes -- likely intentional overrides. Commands by scope: ai-resources 14, workflows 22.

### Settings & Permissions
Both settings files are valid JSON with proper permissions structure. The root settings.local.json has 8 allow entries and 3 deny entries with no hooks. The workflow template settings.json has 6 allow entries, 3 deny entries, and 9 hooks across 5 hook types (PreToolUse, PostToolUse, SessionStart, Stop, UserPromptSubmit). One hook script (check-claim-ids.sh) lacks execute permissions. Both settings use broad Bash(*) allow patterns with appropriate deny guards for git push, rm, and sudo.

### 2026 Best Practices
The workspace demonstrates strong 2026 best practices adoption. CLAUDE.md files are lean with @import patterns. Subagent isolation is consistently used for QC and evaluation. Context isolation is followed with one documented exception (coach command). Hooks are used appropriately for mechanical checks (claim ID verification, bright-line rule, friction logging). The command-to-skill ratio (37:60) and agent count (15) indicate a mature, well-utilized skill library. Positive maturity signals include: filesystem-first verification rules, progressive pipeline architecture with 7 defined agent stages, session management hooks, and error-driven CLAUDE.md rules.

### Context Health
Cross-reference integrity is strong. All skill references in CLAUDE.md files, commands, and pipeline steps resolve to existing skills. All 4 hook scripts exist on the filesystem (though check-claim-ids.sh lacks execute permissions -- flagged by settings auditor). The workflow template audit-repo command is one auditor behind the ai-resources version after the recent context-health-auditor addition. 30 skill references checked across CLAUDE.md files, 12 command-to-skill references checked, 25 pipeline steps verified. No dead references or description mismatches found.

## Prioritized Recommendations

1. **Fix check-claim-ids.sh permissions** -- This hook script will fail silently when invoked by the PostToolUse Write hook, meaning Claim ID coverage checks are not running. Effort: Low. Area: Settings & Permissions.

2. **Update workflow template audit-repo.md** -- Add context-health-auditor.md to the agent list so deployed projects get the full 7-auditor suite. Effort: Low. Area: Context Health.

3. **Extract answer-spec-generator content to references/** -- At 485 lines, this skill is the longest in the repo and approaching the 500-line convention limit. Moving procedural sections to a references/ subdirectory would improve maintainability. Effort: Medium. Area: Skill Inventory.

4. **Review duplicate commands for drift** -- 6 command filenames exist in both ai-resources and workflow scopes. Verify whether any have diverged unintentionally. Effort: Low. Area: Commands & Subagents.

5. **Consider opus for qc-gate agent** -- The research workflow's QC gate agent uses sonnet. If QC verdicts are not meeting quality expectations, upgrading to opus may improve analytical depth. Effort: Low. Area: 2026 Best Practices.

---

*Generated by repo-health-analyzer v2 (sequential mode). Auditors: 7 run, 0 skipped.*
