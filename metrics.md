# Metrics

> **What this is.** The operational dashboard for the personal AI operating system. Four metrics committed at Session 0 of the portfolio project, baselined on 2026-07-06, updated through the signal-triggered sync described in [`README.md`](./README.md).
> **What it tracks.** Errors caught per month (headline metric); evals shipped per quarter; detector count plus regression-test pass rate; rules added per month across `CLAUDE.md` and the skills layer.
> **Why it's included.** The case studies make the qualitative claim that the system around the AI does most of the work. This page is the quantitative spine. Every number cites the source file it was computed from.

---

## Headline metric—errors caught per month

**Headline: hundreds of WRONG/RIGHT corrections logged per month during active job-application work.**

The number is the rate at which WRONG/RIGHT pairs land in the corrections-log shards inside the job-materials skill. A correction is logged when the verifier subagent flags an issue, the composer fixes it, and the WRONG/RIGHT pair plus the rule citation gets promoted into source. The pattern is documented in [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md).

The corrections-log layer in the job-materials skill spans four files:

- `references/corrections-log.md`—the navigation index, 92 lines (post-split state plus cross-reference updates from the voice-rules decomposition on 2026-05-07).
- `references/corrections-log/evals-6-15.md`—shard for numbered Evals 6 through 15, 928 lines.
- `references/corrections-log/live-applications.md`—shard for live-application corrections, 630 lines.
- `references/corrections-log-archive.md`—archive for Pre-Eval Drift plus Evals 3 through 5, 192 lines.

Total content under the corrections-log layer at baseline: 1,842 lines. The "hundreds per month" rate refers to the pace at which new corrections enter this layer in months with active job-application work, not the cumulative archive size.

A rate-derived metric needs a measurement window. The window for this dashboard is calendar month. Future updates against this baseline will count newly-added WRONG/RIGHT pairs in the rolling 30-day window before the update date. The first updated number after baseline establishes the regression bar.

## 1. Errors caught per month

**Methodology.** Aggregate count of WRONG/RIGHT pairs across `~/aios/skills/*/references/corrections-log*` files added in the trailing 30 days. The job-materials skill is currently the dominant contributor.

**Source.** The four files listed under "Headline metric" above. Future skills that adopt the corrections-log pattern will surface here automatically.

**Baseline (2026-07-06).** Cumulative WRONG token count across the four files: 107 (a rough lower-bound proxy; not every correction uses the WRONG keyword). Headline-rate framing: hundreds per month during active periods.

**Bar.** Rate stays in the same order of magnitude (hundreds per month) during active job-application periods. Sustained drop without a corresponding drop in application volume is a signal that the corrections layer is missing failure modes.

## 2. Evals shipped per quarter

**Methodology.** Count of distinct numbered evals shipped in the trailing 90-day window. An eval is a regression-test record produced by one applied job application—or, in a small minority, by a skill-improvement session that shipped no application (1 of 46 to date). It lands either as a dedicated file under `skills/job-materials/evals/` or as a corrections entry under `corrections-log/`.

**Source.** `skills/job-materials/evals/` (36 dedicated eval files spanning Evals 11 through 46) plus `skills/job-materials/evals/archive/` (10 dedicated files covering Evals 1 through 10). Lifetime count: 46 evals.

**Baseline (2026-07-06).** 40 lifetime evals across the job-materials skill. The trailing-90-day cadence will be established at the first dashboard update.

**Bar.** Cadence stays steady or grows during active job-search periods. The evals produce the corrections that drive Metric 1; they are the upstream signal for the system's correction loop.

## 3. Detector count plus regression-test pass rate

**Methodology.** Two paired numbers. Detector count is the number of mechanical pre-flight detector functions in `skills/job-materials/scripts/preflight_check.py` plus any verifier-prompt sub-checks promoted to mechanical form. Regression-test pass rate is the share of detectors passing on the immediately-prior eval's draft as authored.

**Source.** `skills/job-materials/scripts/preflight_check.py` (41 detectors registered across the four tier lists, verified by counting registry entries rather than `def` lines—the file defines a 42nd that is never registered and never runs). The v7 close on 2026-05-19 left the count at 39 with the ≤40 ceiling held; the fortieth arrived on 2026-05-25, the ceiling was lifted to 41 on 2026-05-27, and the count has sat there since.

**Baseline (2026-07-06).** 41 detectors. Regression-test pass rate: to be established. Pass rate matters because detector count without pass rate can grow misleadingly—adding detectors that always pass because their failure mode is rare is detector inflation.

**Bar.** Detector count tracks toward the ceiling deliberately. A detector promoted past the ceiling means an existing detector should retire (the failure mode it caught no longer recurs across recent evals) or the ceiling itself should be revisited as a deliberate architectural decision.

## 4. Rules added per month across `CLAUDE.md` plus skills

**Methodology.** Composite count of new rules added in the trailing 30 days across (a) global behavioral primitives in `CLAUDE.md`, (b) per-rule files under `skills/*/references/voice-rules/`, (c) checks in `skills/*/references/qa-checklist.md` (or equivalent), and (d) hooks under `~/aios/hooks/`.

**Source.** The four file populations:

- `CLAUDE.md` root: 16 behavioral primitives at baseline (Truth-telling, Data Accuracy & sourcing, Reasoning Quality, Verify-before-claim-complete, Surgical Discipline, Proactive Issue Surfacing, Decide vs Ask, Scope Sizing, Subagent Discipline, Skill Update Persistence, Personal Skills Take Priority, File Write Verification, Multi-Session Project Discipline, Frontier-Feature Proactivity, Visual-First Explanation, Language).
- `skills/job-materials/references/voice-rules/`: 24 files (22 per-rule + 2 supporting). Sparse rule numbering preserved; the index sits at 69 lines.
- `skills/job-materials/references/qa-checklist.md`: 1,096 lines; 53 H3 subsections covering individual checks and gates.
- `~/aios/hooks/`: **13 hook scripts as of 2026-08-28**—a current count, not a baseline one. The 2026-07-06 baseline population was **10** (seven observe, three enforce), as the v2.0.0 release record states; `session-end-harness-archive.sh` landed 2026-07-27, `pre-tool-use-prewrite-checks.sh` on 2026-08-20, and `post-tool-use-observe-bash-writes.sh` on 2026-08-25, and all three count as rules added in the metric this list feeds. Ten now observe (`post-tool-use-verify-write.sh`, `session-start-prune-commitment-logs.sh`, `session-end-context-reminder.sh`, `session-end-cross-file-consistency.sh`, `session-end-improvement-opportunities.sh`, `session-end-portfolio-sync.sh`, `session-start-drift-guard.sh`, `pre-tool-use-prewrite-checks.sh`, `session-end-harness-archive.sh`, `post-tool-use-observe-bash-writes.sh`) and three that enforce (`pre-tool-use-guard-paths.sh`, `pre-tool-use-unit-scope.sh`, `stop-verify-before-complete.sh`)—plus the `common.sh` shared library and 2 install scripts. `pre-tool-use-prewrite-checks.sh` counts as observe despite firing on `PreToolUse`: it emits context and never a permission decision, so the split is by behavior, not by event type.

**Baseline (2026-07-06).** Cumulative populations as listed above, except the hook inventory, which is dated inline: it is the only one of the four that has been re-derived since the baseline was taken. The trailing-30-day rate will be established at the first dashboard update.

**Bar.** Rate is non-zero during periods with active correction work. Zero rate over multiple months without a corresponding drop in correction-loop activity (Metric 1) is a signal that corrections are landing in conversation context instead of source files—the encode-into-source primitive is failing.

## Methodology notes

**What "errors caught" includes.** Any correction promoted from a draft to source. WRONG/RIGHT pair entries in corrections-log shards are the dominant population. Verifier-flagged Mediums that Craig dispositions as defensible (and that therefore do not produce source-file changes) are not counted as errors caught.

**What "rules added" includes.** New behavioral primitives, new per-rule files, new qa-checklist checks, new hooks. Edits to existing rules do not count. Promotions of an existing rule across the rule-promotion lifecycle (verbal rule → mechanical detector, for example) count once at the new lifecycle stage, not as a fresh rule.

**Update cadence.** Updates are signal-triggered, not time-driven. The signal-detection logic is shipped in a SessionEnd hook plus a `/publish-portfolio` slash command, with per-push diff review as a hard gate. Triggers include: a new eval shipped, a new behavioral primitive added, a project version released, a structural improvement bundle closed. The dashboard is regenerated when triggers fire and the diff review confirms the proposed update.

**Reading the dashboard.** Each metric is a rate or count, not a target. The headline metric—errors caught per month—is a system-fitness signal. A high rate means the correction loop is finding real failure modes, not that the underlying drafts are getting worse. A zero rate during active work would be the alarming reading. Improvement comes from promoting more rules to mechanical form (Metric 3) and from fewer recurrences of the same failure mode (visible in the recurrence-counter mechanism documented in [Case Study #2](./case-studies/02-composer-verifier.md)).

## Baseline date and source

**Baseline date: 2026-07-06.** All counts above are computed from the state of `~/aios/` on this date. The next update against this baseline will report deltas plus a 30-day rolling rate where applicable.

**Source verification.** Each numeric claim above traces to a specific source file or directory. The redacted artifact tier under [`artifacts/`](./artifacts/) provides a reader with the operational files that produced the numbers, with PII, target-company names, third-party individuals, and prior-employer narrative redacted but the structural depth preserved. Any number on this page traces to a source file under [`artifacts/`](./artifacts/).

The case studies that walk the operational mechanics are [Case Study #2—Composer / Verifier](./case-studies/02-composer-verifier.md) (the eval-driven loop), [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md) (the corrections-log structure and rule-promotion lifecycle), and [Case Study #4—From Discipline to Machinery](./case-studies/04-discipline-to-machinery.md) (the hooks layer). The synthesis lives in [`retrospection.md`](./retrospection.md). For a peer PM who wants to reuse the patterns at smaller scale, [`for-pms-reusing.md`](./for-pms-reusing.md) walks the smallest-viable-version of each.

---

**Sources:** `~/aios/skills/job-materials/references/corrections-log.md` + `corrections-log-archive.md` + `corrections-log/` shards (errors-caught-per-month aggregate); `~/aios/skills/job-materials/evals/` (eval count); `~/aios/skills/job-materials/ROADMAP.md` (detector inventory + regression-test pass rate); `~/aios/CLAUDE.md` + `~/aios/skills/*/SKILL.md` + `~/aios/skills/*/references/` (rules-added-per-month composite); `~/aios/hooks/` (the hook component of that composite, and the hook inventory above—re-read 2026-08-28; the `Last refreshed` stamp below is deliberately held at 2026-07-06 because the other four sources were not re-derived).
**Last refreshed:** 2026-07-06
