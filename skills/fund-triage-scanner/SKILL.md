---
name: fund-triage-scanner
description: >
  Batch-native PE fund triage scanner. Processes Nordic PE funds in batches via
  manifest-driven execution: fetches fund websites, extracts surface-level signals,
  classifies as PASS/FAIL/INSUFFICIENT against operator-defined criteria. Use when:
  the /triage command is invoked, or when asked to "run triage," "triage scan,"
  "scan funds," "quick scan," or "run the triage pass." Do NOT use for deep fund
  research, multi-source analysis, or portfolio company extraction — those are
  separate downstream stages.
---

# Fund Triage Scanner

## Role + Scope

You are executing a batch-native triage scan of PE fund websites. Each invocation processes exactly one batch. You read classification criteria from a config file, fetch 1–2 web pages per fund, extract surface signals, classify each fund, and write structured output. Speed and coverage over depth.

**What this skill does NOT do:**
- Deep extraction (portfolio company details, team composition, AUM research)
- Multi-source research (news articles, third-party databases)
- Industry classification against a full taxonomy
- Boutique indicator scoring
- Ranking or prioritization — that is a downstream stage

---

## Execution Modes

| Mode | Trigger | Behavior |
|------|---------|----------|
| **Default** | `/triage` (no flags) | Read manifest, find first pending batch, process it, update manifest, regenerate summary. If no manifest exists, generate one from `fund-list.csv`. |
| **Pilot** | `/triage --pilot` | Generate a separate pilot manifest with `run_id: pilot-YYYY-MM-DD` and `batch_size` equal to the number of entries in `config/pilot-expected.json`. Process the single pilot batch. Generate `output/pilot-comparison.md`. If a production manifest already exists at `output/run-manifest.json`, save the pilot manifest to `output/pilot-manifest.json` instead. Do NOT touch the production manifest. |
| **Rerun** | `/triage --rerun-batch N` | Reset batch N to `pending` in the manifest. Remove batch N entries from `output/triage-results.csv` (rows where batch column = N) and `output/triage-evidence.jsonl` (lines where `"batch": N`). Then process the batch fresh. |
| **Summary** | `/triage --summary` | Regenerate `output/triage-summary.md` from current output files. No fund processing. |
| **Init** | `/triage --init` | Generate the manifest from `input/fund-list.csv` without processing any funds. Useful for reviewing the batch plan before starting. |

---

## Manifest Management

The manifest at `output/run-manifest.json` is the orchestration layer.

### Generation

Read `input/fund-list.csv`. Divide funds into batches of `batch_size` (read from CLAUDE.md — default 20). Write `output/run-manifest.json`:

```json
{
  "run_id": "triage-YYYY-MM-DD",
  "created_at": "ISO timestamp",
  "criteria_hash": "lines 1-5 of classification-criteria.md concatenated as a single string",
  "total_funds": 400,
  "batch_size": 20,
  "batches": [
    {
      "batch": 1,
      "fund_ids": ["001", "002", "..."],
      "status": "pending"
    }
  ]
}
```

### Batch Pickup

Find the first batch with `status: "pending"`. If none found, report "All batches complete." and stop.

### Batch Completion

Update the batch entry:
- Set `status: "complete"`
- Add `completed_at` (ISO timestamp)
- Add `criteria_hash` (hash computed at time of processing)
- Add `results` object: `{"pass": N, "fail": N, "insufficient": N}`

### Criteria Hash

Compute by reading lines 1–5 of `config/classification-criteria.md` and concatenating them into a single string. Store at both the run level (when manifest is generated) and per-batch level (when each batch is processed). The summary report flags if per-batch hashes differ from the run-level hash (criteria drift warning).

### Pilot Manifest

Uses `run_id: "pilot-YYYY-MM-DD"`. If a production manifest already exists at `output/run-manifest.json`, save the pilot manifest to `output/pilot-manifest.json`. If no production manifest exists, use `output/run-manifest.json`.

### Rerun

Reset the target batch's status to `pending`. Remove that batch's entries from CSV (rows where batch column matches N) and JSONL (lines where `"batch": N`). Then process normally.

---

## Per-Fund Processing Flow

Process funds sequentially within a batch. For each fund:

### Step 1: Pre-check URL

If the URL field is empty or `none`, classify as INSUFFICIENT with `fetch_issues: "no_website"`. Write the result (Step 8). Skip to the next fund.

### Step 2: Fetch Homepage

Fetch the fund's URL using WebFetch. If the fetch fails, retry once. If the second attempt also fails, classify as INSUFFICIENT with `fetch_issues` describing the error. Write the result. Skip to the next fund.

### Step 3: Entity Match Check

After fetching the homepage, verify the website appears to belong to the fund named in the input. Assign one of:
- `confirmed` — clear match between fund name and website content
- `plausible` — likely match but name differs slightly (abbreviation, parent company)
- `mismatch` — clearly a different entity
- `unclear` — cannot determine

**If `mismatch`: classify as INSUFFICIENT with `entity_match: "mismatch"`. Write result. Skip to next fund. Do NOT proceed to full classification.**

### Step 4: Discover Second Page

Scan homepage content for links containing these bilingual keywords:

- **English:** portfolio, investments, companies, about, strategy, investment criteria, focus
- **Swedish:** innehav, portfölj, bolag, om oss, investeringsstrategi, fokus, strategi
- **Norwegian:** portefølje, selskaper, investeringer, om oss, investeringsstrategi, fokus, strategi

Select the single best matching link (prefer portfolio/investments pages over about pages). If no matching link is found, proceed with homepage only.

### Step 5: Fetch Second Page

If a link was identified in Step 4, fetch it using WebFetch. If the fetch fails, proceed with homepage content only.

### Step 6: Extract Signals

Read `config/classification-criteria.md` (loaded at batch start — do not re-read per fund). Apply criteria against the combined content from fetched pages. Focus on the first ~3,000 words of each page. Extract exactly these signals:

| Signal | Values |
|--------|--------|
| `entity_match` | confirmed / plausible / mismatch / unclear |
| `fund_type_signals` | Keywords found indicating PE, VC, RE, infra, family office, FoF, credit/debt |
| `stated_strategy` | 1–2 sentence paraphrase of any explicit strategy description |
| `deal_size_signals` | Any mentioned deal size, ticket size, revenue range, or AUM (null if none found) |
| `geography_signals` | Mentioned geographic focus areas (null if none found) |
| `website_language` | sv / en / other |
| `content_depth` | rich / thin / minimal |

### Step 7: Classify

Apply classification logic from `config/classification-criteria.md`:

**FAIL** — Fund is clearly a non-fit:
- Self-identifies as VC, real estate, infrastructure, credit/debt, or family office
- Stated deal size clearly outside range (per thresholds in criteria file)
- Website is dead, parked, or domain for sale
- Entity is clearly not an investment fund (consulting firm, association, accelerator, etc.)

**PASS** — Fund appears to be PE and no disqualifying signals found:
- Self-identifies as PE or buyout fund
- Stated strategy consistent with mid-market PE
- Deal size signals (if present) within plausible range per criteria file

**INSUFFICIENT** — Cannot determine from surface scan:
- Website exists but contains minimal information
- No clear fund type indicators
- Content behind login or JavaScript-heavy (thin fetch result)
- Mixed signals (e.g., fund does both VC and PE)
- Entity match is `unclear`
- Only homepage available and signals are ambiguous

**CORE RULE: When in doubt, INSUFFICIENT — never FAIL.**

Every verdict MUST include supporting evidence — a quote or specific observation from the fetched content. No classification without evidence.

### Step 8: Write Result

Append one JSON object (one line) to `output/triage-evidence.jsonl`:

```json
{
  "fund_id": "string",
  "fund_name": "string",
  "website": "string",
  "batch": 1,
  "verdict": "PASS | FAIL | INSUFFICIENT",
  "fail_reason": "string | null",
  "entity_match": "confirmed | plausible | mismatch | unclear",
  "signals": {
    "fund_type_signals": "string",
    "stated_strategy": "string",
    "deal_size_signals": "string | null",
    "geography_signals": "string | null",
    "website_language": "sv | en | other",
    "content_depth": "rich | thin | minimal"
  },
  "pages_fetched": ["url1", "url2"],
  "pages_fetched_count": 1,
  "fetch_issues": "string | null",
  "criteria_hash": "string"
}
```

Then append one row to `output/triage-results.csv`. Columns:

```
fund_id,fund_name,website,batch,verdict,fail_reason,entity_match,fund_type_signals,stated_strategy,deal_size_signals,content_depth,pages_fetched_count,fetch_issues
```

Write the header row on first write (when the file does not exist or is empty). Each batch appends as a contiguous block.

### Step 9: Context Management

After writing the result for a fund, discard the full fetched page content from your working context. Carry forward only the structured output (the JSONL entry). This is critical for staying within context window limits across a batch of ~20 funds.

---

## Single-Page Handling

If no second page can be identified from homepage links (Step 4), proceed with homepage content only. Record `pages_fetched_count: 1`. If the homepage alone provides clear signals, classify normally. If signals are ambiguous on homepage alone, lean toward INSUFFICIENT.

---

## Batch Completion Protocol

After processing all funds in the current batch:

1. Update the manifest: mark batch `complete`, record timestamp, criteria hash, and result counts.
2. Regenerate `output/triage-summary.md` from the full output files (see Summary Format below).
3. Report to operator: "Batch N complete. X pass / Y fail / Z insufficient. Run `/triage` for next batch." Or "All batches complete." if no pending batches remain.

---

## Summary Format

`output/triage-summary.md` — regenerated from full output files after each batch:

- **Run progress:** X of Y batches complete, Z funds processed of W total
- **Verdict distribution:** PASS count (%) / FAIL count (%) / INSUFFICIENT count (%)
- **FAIL breakdown by reason**
- **INSUFFICIENT breakdown by reason** (fetch failure, no website, entity mismatch, ambiguous signals, etc.)
- **Entity mismatch count**
- **Funds with `content_depth: minimal`**
- **Criteria consistency:** Same hash across all completed batches? Y/N (flag if different)
- **Per-batch result counts** (table)

---

## Pilot Comparison Format

`output/pilot-comparison.md` — generated only in `--pilot` mode:

| fund_name | expected_verdict | actual_verdict | match | expected_reasoning | actual_evidence_summary |
|-----------|-----------------|----------------|-------|--------------------|------------------------|

Read `config/pilot-expected.json` for expected verdicts. Compare against actual results from the pilot batch.

---

## Error Handling

| Condition | Action |
|-----------|--------|
| Fetch failure | Retry once. If second attempt fails, classify INSUFFICIENT with `fetch_issues`. |
| No URL (`none` or empty) | Classify INSUFFICIENT with `fetch_issues: "no_website"`. No fetch attempted. |
| Entity mismatch | Classify INSUFFICIENT immediately. Do not proceed to classification. |
| Batch failure mid-processing | Batch remains `pending` in manifest. Next invocation reprocesses entire batch. |
| Missing manifest | Auto-generate from `input/fund-list.csv`. |
| Missing `classification-criteria.md` | **STOP.** Report error: "Classification criteria file not found. Cannot process without criteria." |
| Missing `fund-list.csv` | **STOP.** Report error: "Fund list not found at input/fund-list.csv." |
| All batches complete | Report status. Do not process. |
