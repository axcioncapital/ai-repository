# Output Template — prose-compliance-qc

### Per-Spec Verdicts

| Spec | Verdict | Violation Count |
|------|---------|-----------------|
| Skill anti-patterns | COMPLIANT / ISSUES FOUND | [n] |
| Style spec | COMPLIANT / ISSUES FOUND | [n] |
| Architecture / Source fidelity | COMPLIANT / ISSUES FOUND | [n] |

### Mode Note

State which mode Scan 3 ran in (Full or Degraded) and which inputs were provided.

### Findings

List all violations from all three scans in a single consolidated list, ordered by severity (HIGH, MEDIUM, LOW).

Each finding:

```
**[#] — [Short label]**
Source scan: Skill / Style / Architecture (or Source Fidelity)
Quoted passage: "[exact quote]"
Violation: [one sentence — what spec requirement it breaks]
Severity: HIGH / MEDIUM / LOW
```

**Severity definitions:**
- **HIGH** — the prose fails a stated requirement from one of the three specs
- **MEDIUM** — the prose weakens compliance without outright failing
- **LOW** — minor, borderline, or debatable

### Cross-Spec Tensions

List tensions, or "No cross-spec tensions identified."

Each tension:
```
**Tension [#]: [Short label]**
Competing requirements: [Spec A requires X] vs. [Spec B requires Y]
Resolution path: [suggested approach]
Escalation: [Yes/No — Yes if no clean resolution]
```

### Priority Fixes

Top 5 changes that would most improve compliance, in priority order. For each, reference the finding number(s) it addresses and note if a cross-spec tension affects the fix.

### Example Output (abbreviated)

```
### Per-Spec Verdicts

| Spec | Verdict | Violation Count |
|------|---------|-----------------|
| Skill anti-patterns | ISSUES FOUND | 2 |
| Style spec | COMPLIANT | 0 |
| Architecture / Source fidelity | ISSUES FOUND | 1 |

### Mode Note
Scan 3 ran in Degraded mode (source decision document provided, no architecture spec).

### Findings

**1 — Catalogue structure in service boundaries**
Source scan: Skill (ss2)
Quoted passage: "The service does not include: (a) deal origination, (b) LP fundraising, (c) portfolio company operations, (d) regulatory compliance, (e) tax advisory..."
Violation: Five-plus item enumeration without analytical framing (catalogue structure check)
Severity: MEDIUM

**2 — Rhetorical filler in introduction**
Source scan: Skill (ss4)
Quoted passage: "It is worth noting that the pricing model plays a critical role..."
Violation: Empty sophistication — "it is worth noting" adds no information
Severity: LOW

**3 — Dropped design choice from source**
Source scan: Source Fidelity
Quoted passage: [absent — Decision 4 from source not represented]
Violation: Source decision document contains Decision 4 (minimum commitment period) which does not appear in the prose
Severity: HIGH

### Cross-Spec Tensions
No cross-spec tensions identified.

### Priority Fixes
1. Restore Decision 4 (minimum commitment period) from source document [Finding 3]
2. Add analytical framing around the service boundaries list [Finding 1]
3. Remove "it is worth noting" construction [Finding 2]
```
