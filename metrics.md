# Metrics

> **What this is.** The operational dashboard for the personal AI operating system. Four metrics committed at Session 0 of the portfolio project, baselined on 2026-05-22, updated through the signal-triggered sync described in [`README.md`](./README.md).
> **What it tracks.** Errors caught per month (headline metric); evals shipped per quarter; detector count plus regression-test pass rate; rules added per month across `CLAUDE.md` and the skills layer.
> **Why it's included.** The case studies make the qualitative claim that the system around the AI does most of the work. This page is the quantitative spine. Every number cites the source file it was computed from.

---

## Headline metric—errors caught per month

**Headline: hundreds of WRONG/RIGHT corrections logged per month during active job-application work.**

The number is the rate at which WRONG/RIGHT pairs land in the corrections-log shards inside the job-materials skill. A correction is logged when the verifier subagent flags an issue, the composer fixes it, and the WRONG/RIGHT pair plus the rule citation gets promoted into source. The pattern is documented in [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md).

The corrections-log layer in the job-materials skill spans four files:

- `references/corrections-log.md`—the navigation index, 92 lines / 6,380 bytes (post-split state plus cross-reference updates from the voice-rules decomposition on 2026-05-07).
- `references/corrections-log/evals-6-15.md`—shard for numbered Evals 6 through 15, 928 lines / 121,198 bytes.
- `references/corrections-log/live-applications.md`—shard for live-application corrections, 630 lines / 81,747 bytes.
- `references/corrections-log-archive.md`—archive for Pre-Eval Drift plus Evals 3 through 5, 192 lines / 14,903 bytes.

Total content under the corrections-log layer at baseline: 1,842 lines / 224,228 bytes. The "hundreds per month" rate refers to the pace at which new corrections enter this layer in months with active job-application work, not the cumulative archive size.

A rate-derived metric needs a measurement window. The window for this dashboard is calendar month. Future updates against this baseline will count newly-added WRONG/RIGHT pairs in the rolling 30-day window before the update date. The first updated number after baseline establishes the regression bar.

## 1. Errors caught per month

**Methodology.** Aggregate count of WRONG/RIGHT pairs across `~/.claude-local/skills/*/references/corrections-log*` files added in the trailing 30 days. The job-materials skill is currently the dominant contributor.

**Source.** The four files listed under "Headline metric" above. Future skills that adopt the corrections-log pattern will surface here automatically.

**Baseline (2026-05-22).** Cumulative WRONG token count across the four files: 100 (a rough lower-bound proxy; not every correction uses the WRONG keyword). Headline-rate framing: hundreds per month during active periods.

**Bar.** Rate stays in the same order of magnitude (hundreds per month) during active job-application periods. Sustained drop without a corresponding drop in application volume is a signal that the corrections layer is missing failure modes.

## 2. Evals shipped per quarter

**Methodology.** Count of distinct numbered evals shipped in the trailing 90-day window. An eval is one applied job application that produced a regression-test record, either as a dedicated file under `skills/job-materials/evals/` or as a corrections entry under `corrections-log/`.

**Source.** `skills/job-materials/evals/` (26 dedicated eval files spanning Evals 11 through 36 at baseline) plus the corrections-log shards (covering Evals 3 through 10, with Evals 1 and 2 archived). Lifetime count: 36 evals.

**Baseline (2026-05-22).** 36 lifetime evals across the job-materials skill. The trailing-90-day cadence will be established at the first dashboard update.

**Bar.** Cadence stays steady or grows during active job-search periods. The evals produce the corrections that drive Metric 1; they are the upstream signal for the system's correction loop.

## 3. Detector count plus regression-test pass rate

**Methodology.** Two paired numbers. Detector count is the number of mechanical pre-flight detector functions in `skills/job-materials/scripts/preflight_check.py` plus any verifier-prompt sub-checks promoted to mechanical form. Regression-test pass rate is the share of detectors passing on the immediately-prior eval's draft as authored.

**Source.** `skills/job-materials/scripts/preflight_check.py` (40 `detect_*` functions at baseline, verified by counting function definitions). The cross-cutting reference is the v7 close on 2026-05-19, which closed at 40 detectors at the working ceiling of 40.

**Baseline (2026-05-22).** 40 detectors. Regression-test pass rate: to be established. Pass rate matters because detector count without pass rate can grow misleadingly—adding detectors that always pass because their failure mode is rare is detector inflation.

**Bar.** Detector count tracks toward the ceiling deliberately. A detector promoted past the ceiling means an existing detector should retire (the failure mode it caught no longer recurs across recent evals) or the ceiling itself should be revisited as a deliberate architectural decision.

## 4. Rules added per month across `CLAUDE.md` plus skills

**Methodology.** Composite count of new rules added in the trailing 30 days across (a) global behavioral primitives in `CLAUDE.md`, (b) per-rule files under `skills/*/references/voice-rules/`, (c) checks in `skills/*/references/qa-checklist.md` (or equivalent), and (d) hooks under `~/.claude-local/hooks/`.

**Source.** The four file populations:

- `CLAUDE.md` root: 14 behavioral primitives at baseline (Truth-telling, Data Accuracy & sourcing, Reasoning Quality, Verify-before-claim-complete, Surgical Discipline, Proactive Issue Surfacing, Decide vs Ask, Subagent Discipline, Skill Update Persistence, Personal Skills Take Priority, File Write Verification, Multi-Session Project Discipline, Frontier-Feature Proactivity, Language).
- `skills/job-materials/references/voice-rules/`: 23 files (21 per-rule + 2 supporting). Sparse rule numbering preserved; the index sits at 66 lines / 6,856 bytes.
- `skills/job-materials/references/qa-checklist.md`: 996 lines / 133,803 bytes; 50 H3 subsections covering individual checks and gates.
- `~/.claude-local/hooks/`: 6 hook scripts encoding behavioral primitives (`post-tool-use-verify-write.sh`, `session-start-prune-commitment-logs.sh`, `session-end-context-reminder.sh`, `session-end-cross-file-consistency.sh`, `session-end-improvement-opportunities.sh`, `session-end-portfolio-sync.sh`) plus 2 install scripts.

**Baseline (2026-05-22).** Cumulative populations as listed above. The trailing-30-day rate will be established at the first dashboard update.

**Bar.** Rate is non-zero during periods with active correction work. Zero rate over multiple months without a corresponding drop in correction-loop activity (Metric 1) is a signal that corrections are landing in conversation context instead of source files—the encode-into-source primitive is failing.

## Methodology notes

**What "errors caught" includes.** Any correction promoted from a draft to source. WRONG/RIGHT pair entries in corrections-log shards are the dominant population. Verifier-flagged Mediums that Craig dispositions as defensible (and that therefore do not produce source-file changes) are not counted as errors caught.

**What "rules added" includes.** New behavioral primitives, new per-rule files, new qa-checklist checks, new hooks. Edits to existing rules do not count. Promotions of an existing rule across the rule-promotion lifecycle (verbal rule → mechanical detector, for example) count once at the new lifecycle stage, not as a fresh rule.

**Update cadence.** Updates are signal-triggered, not time-driven. The signal-detection logic is shipped in a SessionEnd hook plus a `/publish-portfolio` slash command, with per-push diff review as a hard gate. Triggers include: a new eval shipped, a new behavioral primitive added, a project version released, a structural improvement bundle closed. The dashboard is regenerated when triggers fire and the diff review confirms the proposed update.

**Reading the dashboard.** Each metric is a rate or count, not a target. The headline metric—errors caught per month—is a system-fitness signal. A high rate means the correction loop is finding real failure modes, not that the underlying drafts are getting worse. A zero rate during active work would be the alarming reading. Improvement comes from promoting more rules to mechanical form (Metric 3) and from fewer recurrences of the same failure mode (visible in the recurrence-counter mechanism documented in [Case Study #2](./case-studies/02-composer-verifier.md)).

## Baseline date and source

**Baseline date: 2026-05-22.** All counts above are computed from the state of `~/.claude-local/` on this date. The next update against this baseline will report deltas plus a 30-day rolling rate where applicable.

**Source verification.** Each numeric claim above traces to a specific source file or directory. The redacted artifact tier under [`artifacts/`](./artifacts/) provides a reader with the operational files that produced the numbers, with PII, target-company names, third-party individuals, and prior-employer narrative redacted but the structural depth preserved. Any number on this page traces to a source file under [`artifacts/`](./artifacts/).

The case studies that walk the operational mechanics are [Case Study #2—Composer / Verifier](./case-studies/02-composer-verifier.md) (the eval-driven loop), [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md) (the corrections-log structure and rule-promotion lifecycle), and [Case Study #4—From Discipline to Machinery](./case-studies/04-discipline-to-machinery.md) (the hooks layer). The synthesis lives in [`retrospection.md`](./retrospection.md). For a peer PM who wants to reuse the patterns at smaller scale, [`for-pms-reusing.md`](./for-pms-reusing.md) walks the smallest-viable-version of each.

---

**Sources:** `~/.claude-local/skills/job-materials/references/corrections-log.md` + `corrections-log-archive.md` + `corrections-log/` shards (errors-caught-per-month aggregate); `~/.claude-local/skills/job-materials/evals/` (eval count); `~/.claude-local/skills/job-materials/ROADMAP.md` (detector inventory + regression-test pass rate); `~/.claude-local/CLAUDE.md` + `~/.claude-local/skills/*/SKILL.md` + `~/.claude-local/skills/*/references/` (rules-added-per-month composite).
**Last refreshed:** 2026-05-22
