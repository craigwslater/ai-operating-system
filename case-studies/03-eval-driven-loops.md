# Eval-Driven Correction Loops

> **Designed by Craig.** The corrections-log structure, the WRONG/RIGHT pair format, the rule-promotion lifecycle that moves a verbal rule through prose into pre-flight scripts, the era-shard refactoring pattern, the verifier-subagent integrity check that validates structural moves.
> **Runtime: Claude.** Composing under the rule set, surfacing WRONG/RIGHT pairs when corrections happen, applying mechanical refactoring under the surgical-discipline primitive, running the post-refactor verification audits.
> **Source artifacts.** [`artifacts/sample-skill/`](../artifacts/sample-skill/) · [`artifacts/sample-eval.md`](../artifacts/sample-eval.md) · [`artifacts/sample-roadmap.md`](../artifacts/sample-roadmap.md)

## Origin moment

By spring 2026, the job-materials skill's `corrections-log.md` had reached 1,534 lines and 194,363 bytes as a single file, carrying corrections from 22 shipped evals plus dozens of live-application records. Composing one tailored cover letter required loading the corrections-log into context to consult prior failure modes. At ~48,500 tokens of consult-time cost per draft, the file had become the dominant load on every composition.

The split—index plus two era-shards—happened on 2026-05-07 because the file got too large to load in a single context window, not because it was elegant. Two days later the same pattern fired against `voice-rules.md`, which had reached 1,596 lines and 28 H2 sections. Both files were carrying the same structural problem at different granularities.

What follows is what eval-driven correction looks like at scale: WRONG/RIGHT pairs as the unit of learning, rule-promotion as the lifecycle that moves a correction from prose into machinery, and the era-shard pattern as the refactoring discipline that keeps the rule set readable as it grows.

## What this is

Eval-driven correction is software-engineering rigor applied to AI work. The disciplines have direct analogs:

- **Code review** is the WRONG/RIGHT pair. A correction is not a verdict; it is a paired example—the prose that fired the rule, alongside the prose that satisfies it. The pair grounds the rule; the rule alone does not ground itself.
- **Refactoring** is the era-shard pattern. When a reference file grows past the load-cost threshold for a single context, it splits into an index plus content shards. The split happens at content-natural boundaries, not arbitrary line counts.
- **Library versioning** is the rule-promotion lifecycle. A verbal rule moves through stages: prose with worked example, qa-checklist gate at composer-time, verifier-prompt sub-check at audit-time, mechanical pre-flight detector that catches the failure shape before the verifier subagent runs at all.
- **Observability** is drift detection. Hooks scan source files for cross-file inconsistencies—a fix in CONTEXT.md but missing in the corresponding skill SKILL.md, a ROADMAP.md item moved to Completed in one place but not the canonical inventory.

The job-materials skill is where these patterns earned their place. The skill has shipped 23 evals, runs about 39 detectors, catches hundreds of errors per month easily, and produces dozens of tailored applications. The patterns transfer outward; the volume and the live-application stakes are what made this the skill that proved them.

## The corrections-log and the WRONG/RIGHT pair

A correction enters the system as a verbatim pair. From `references/corrections-log/evals-6-15.md`, Eval 6 ([REDACTED COMPANY]), Issue 1:

```
Failure mode: Paraphrased the canonical "retention and expansion of a major
enterprise customer by more than 30%" such that the metric became an adjective
modifying "retention and expansion," weakening the sentence.

WRONG ([REDACTED COMPANY] Phase 2): "enabled more than 30% retention and expansion with a
   major enterprise customer"
RIGHT (canonical):       "retention and expansion of a major enterprise customer
   by more than 30%"

The metric lands at the end of the clause, where it should.

Rule spawned: voice-rules/rule-18-canonical-bullet-fidelity.md (Canonical-Bullet
   Fidelity); Phrase Lock #3 in exemplars.md.
```

Five elements appear in every entry. The **failure mode** names the shape that fired the rule, in a sentence the rule will recognize on its next firing. The **WRONG** is verbatim from the draft that surfaced the issue, traceable to the eval that produced it. The **RIGHT** is the canonical phrasing, sourced from `craig_application.json` or composed in dialogue with Craig and locked. The **diagnostic** is the one-line rationale that explains why the WRONG fails and the RIGHT works. The **rule spawned** points to where the correction was promoted in source: a per-rule file under `voice-rules/`, a check in `qa-checklist.md`, a phrase-lock in `exemplars.md`, or a sub-check in the verifier prompt.

The form is not stylistic. The WRONG/RIGHT pair is what makes the correction reusable. A verbal rule that says "don't paraphrase canonical metrics" is brittle; the same rule with a worked WRONG/RIGHT pair becomes pattern-recognizable. The verifier subagent reads the pair, not just the rule.

## The rule-promotion lifecycle

A correction does not stay in conversation context. It promotes through five stages, and the stage it lands in depends on whether the failure mode is verbal-rule-recognizable or pattern-detectable.

**Stage 1—Verbal rule in `voice-rules/`.** A new failure mode lands first as prose. The rule names what the failure looks like, what the canonical alternative looks like, and which composition step the rule fires in. The Eval 6 [REDACTED COMPANY] example above promoted to `voice-rules/rule-18-canonical-bullet-fidelity.md` at this stage.

**Stage 2—Worked example in the corrections-log.** The WRONG/RIGHT pair lands in the appropriate corrections-log shard with the rule citation. Without the worked example, the verbal rule has only its abstract description; future composer drafts that produce a similar shape will not match the rule's wording exactly.

**Stage 3—Composer self-check at draft-time.** A check lands in `qa-checklist.md` for the composer to consult while drafting. Self-checks catch the obvious cases before the verifier runs. They are weaker than verifier checks because the composer is auditing its own output—the failure mode named in [Case Study #1](./01-personal-ai-os.md) and [Case Study #2](./02-composer-verifier.md)—but they are cheap and they catch a real share of issues.

**Stage 4—Verifier-prompt sub-check at audit-time.** A check lands in the verifier prompt or the verifier quality prompt. This is the audit step running in a separate context, reading the same rules from the source the composer reads, returning a structured verdict at four severity tiers.

**Stage 5—Mechanical pre-flight detector.** The detector lands in `scripts/preflight_check.py` and runs before the verifier subagent is spawned. Pure pattern-matching, no model inference. The hook fact-count gate is the canonical example: [REDACTED COMPANY] Round 5c (Eval 12) stacked four facts in S1 before any mechanical gate existed; the verbal rule fired qualitatively, the same shape returned in subsequent evals because nothing enforced the maximum, and `detect_hook_fact_count` was promoted to close the gap. Section 20(h) parallel-restrictive-relative tense detector followed the same path: surfaced in Eval 22 ([REDACTED COMPANY]) post-ship, promoted to mechanical detector in v5 Session 3 on 2026-05-06, validated under live conditions in Eval 23 ([REDACTED COMPANY]) the same week.

Promotion happens when a verbal rule fires twice in succession on the same shape. The recurrence counter—introduced in [Case Study #2](./02-composer-verifier.md)—is the mechanism that escalates structural failures, but the lifecycle stages are how individual rules harden. A rule that has reached Stage 5 cannot be missed; a rule that lives only at Stage 1 depends on the runtime re-reading the prose and recognizing the shape correctly. Discipline-as-prose is brittle; the lifecycle is what makes the rule durable.

## The era-shard pattern—two data points

Two reference files in the job-materials skill outgrew the single-file form within a week of each other. Both were refactored under the same pattern. The data is below.

**Data point 1—Corrections-log era-shard split, 2026-05-07.**

Pre-refactor: `references/corrections-log.md`, 1,534 lines / 194,363 bytes, monolithic. Consult-time load cost: ~48,591 tokens for any composer draft that needed to consult prior corrections.

Refactor: split into a 92-line / 6,346-byte index (`references/corrections-log.md`, rewritten in place) plus two era-shards. `corrections-log/evals-6-15.md` carried 928 lines / 120,537 bytes covering numbered Evals 6–15 (verbatim extracts of source lines 20–526 and 729–1126). `corrections-log/live-applications.md` carried 572 lines / 72,348 bytes covering live-application corrections from Sessions 9–32 plus company-keyed sections from Eval 16 forward (verbatim extracts of source lines 576–727 and 1127–1525).

Result: consult-time load reduced from ~48,591 tokens to ~1,587 tokens for the index alone (best case, -97%) or ~19,600–31,700 tokens for index plus one shard (common case, -35% to -58%). Eager-load grew by 103 tokens because the cross-reference text in the index was slightly longer than the original; the trade was load-shift from on-demand to navigation, with the on-demand cost taking the bigger structural hit.

The split happened at content-natural boundaries: numbered-eval corrections in one shard, live-application-corrections in another. The original boundary that made `evals-16-23.md` a candidate name was discarded because the actual data shape was two cleanly distinct content categories, not a numerical-range continuum. The naming reflected the data; the data did not get renamed to fit a tidy scheme.

**Data point 2—Voice-rules per-rule decomposition, 2026-05-07.**

Pre-refactor: `references/voice-rules.md`, 1,596 lines / 168,338 bytes / 28 H2 sections, monolithic. Eager-load contribution: ~39,000 tokens out of a 118,488-token total at session start.

Refactor: split into a 66-line / 6,856-byte index (`references/voice-rules.md`, rewritten in place) plus 23 files under `references/voice-rules/`—21 per-rule files and 2 supporting files (`summary-construction.md`, `role-type-targeting.md`). The 21 rule numbers are sparse—1, 2, 3, 4, 7, 8, 9, 10, 12, 13, 14, 15, 16, 17, 18, 23, 24, 25, 26, 27, 28—because Rules 5, 6, 7b, 11, 19, 20, 21, and 22 had been historically consolidated into other rules during prior project versions. The sparse numbering was preserved rather than renumbered; the historical provenance is part of the rule's identity.

Result: eager-load dropped from 118,488 tokens to 78,477 tokens, a reduction of 40,011 tokens (-33.8%). The Phase 1 ceiling—≤80K directive, ≤90K inventory—was met for the first time in the project, with 1,523 tokens of headroom. Per-rule files load on demand when their rule is invoked.

The refactor required 139 cross-reference updates: 18 surgical edits inside `SKILL.md` and 121 substitutions across 11 in-scope files via a Python bulk script (4-pattern substitution covering `voice-rules.md Rule N` to `voice-rules/rule-N-{slug}.md`, with backtick variants and supporting-file variants). Each per-rule file landed with a provenance header citing its slice md5 and source line range, plus an inter-rule interactions section listing inbound and outbound references. Rule 12 carried 7 inbound rules; Rule 17 carried 6; Rule 23 carried 5; the cross-reference graph remained intact post-split, verified by grep.

**Both refactors validated through a verifier-subagent integrity check.** A subagent ran in a separate context with a 9-item checklist: file existence, slice md5 matches against source extractions, foundational-content md5 matches in the index file, cross-file path resolution, content conservation, out-of-scope file untouched, inter-rule headers accurate, sub-section anchors resolve. Both refactors returned clean—zero structural issues, zero broken pointers. Independent grep verification plus 5 high-density rule spot-checks ran alongside, confirming each high-traffic rule's content landed in the expected per-rule file. The integrity check is itself a software-engineering pattern: a refactor without a post-condition test is a refactor that ships drift.

The two refactors demonstrate the same pattern at different granularities. The corrections-log split is content-organization (two era-shards plus a navigation index); the voice-rules decomposition is unit-of-work (one file per rule plus a navigation index). The unifying claim—the sharded-with-index pattern should be the default from skill v2 forward, not a fix applied after the file becomes unwieldy—is one of three retrospections synthesized in [`retrospection.md`](../retrospection.md).

## Drift detection

A correction lifecycle that ends at Stage 5 still leaves one open question: how does the system notice when a fix landed in one place and not the other? A rule promoted to `voice-rules/rule-18-canonical-bullet-fidelity.md` but missing the matching update to `qa-checklist.md` is a drift. A ROADMAP item resolved in CONTEXT.md but still sitting in the open-considerations section of ROADMAP.md is a drift. A skill's eager-load measurement that contradicts the ceiling claim in its own SKILL.md is a drift.

Drift detection runs in two forms. **PostToolUse hooks** fire after every Edit/Write to a mounted directory. They scan for cross-file inconsistencies in the same session: did the fix to `voice-rules.md` get matched by an update to the qa-checklist that cites it? Did the new ROADMAP entry land with a "Bundle home" annotation, or did it skip the lifecycle metadata? **SessionEnd hooks** fire at session close. They run cheaper continuous versions of the same checks plus a structural audit that surfaces anything stale—corrections-log entries pointing to renumbered rules, file-size budgets exceeded, eval-archive entries missing the canonical Step 7.5 backport audit.

The hooks layer is the runtime side of this discipline. The depth on it lives in [Case Study #4—From Discipline to Machinery](./04-discipline-to-machinery.md). The framing here is the architectural one: software-engineering observability does not stop at the source-control commit boundary. In an AI workflow producing real deliverables, the source files are the working surface, and the working surface needs runtime checks the same way a deployed service needs them.

## Failure modes that drove the design

Three failure modes surfaced before the patterns above settled into place. Each one fired in production—on real applied jobs in the live job-materials skill—before the corresponding pattern existed.

**Verbal rules without worked examples.** Early evals carried rules in `voice-rules.md` as prose without paired WRONG/RIGHT examples. The same shape recurred two and three evals later because the composer drafted a phrase that resembled the violation in meaning but not in surface form, and the abstract rule did not match. The fix was not stronger prose; the fix was the WRONG/RIGHT pair. A rule with a worked example is a rule the verifier can match against on shape, not on meaning alone.

**Discipline-as-prose for everything else.** File-write verification, cross-file consistency, ROADMAP drift detection lived as `CLAUDE.md` primitives—prose rules—for weeks before becoming hooks. Every prose-only primitive depends on the runtime re-reading the rule and applying it correctly each time. Two separate Claude sessions, two slightly different interpretations, drift accumulates. Generalization: every behavioral primitive should ship with an enforcement-method answer from day one. The hooks-layer instantiation is in [Case Study #4](./04-discipline-to-machinery.md).

**Monolithic reference files.** The corrections-log reached 1,534 lines / 194,363 bytes before the split. The voice-rules reference reached 1,596 lines / 168,338 bytes / 28 H2 sections before the per-rule decomposition. Both refactors recovered substantial token cost—the voice-rules split alone reclaimed 40,011 tokens of eager-load, hitting the Phase 1 ≤80K ceiling for the first time. Generalization: the sharded-with-index pattern is the default for any reference file beyond ~500 lines, not a retrofit. The two data points above are themselves the failure mode being remediated.

The synthesis line, captured in [`retrospection.md`](../retrospection.md): *AI workflows producing real deliverables need machinery, separation, and modular structure from day one, not as retrofits.* This case study walks the modular-structure third of that synthesis. [Case Study #2](./02-composer-verifier.md) walked the separation half. [Case Study #4](./04-discipline-to-machinery.md) walks the machinery half.

## What's next

The next case study is the runtime layer. [From Discipline to Machinery](./04-discipline-to-machinery.md) walks the hooks that turn the rules above into runtime checks—file-write verification at the tool-call level, cross-file consistency at session end, structural drift detection that fires on every edit. The hooks are the answer to the discipline-as-prose failure mode at the system level, the same way the rule-promotion lifecycle is the answer at the skill level.

The redacted operational artifacts in [`artifacts/sample-skill/`](../artifacts/sample-skill/), [`artifacts/sample-eval.md`](../artifacts/sample-eval.md), and [`artifacts/sample-roadmap.md`](../artifacts/sample-roadmap.md) are where any claim in this case study can be verified against actual source files—with PII, target-company names, third-party individuals, and prior-employer narrative redacted, but the corrections-log structure, the rule-promotion stages, and the era-shard pattern intact.

The [metrics dashboard](../metrics.md) tracks the four headline metrics over time: errors caught per month, evals shipped per quarter, detector count plus regression-test pass rate, and rules added per month across the global rule set and the skill rule sets. The headline metric—hundreds of errors caught per month easily, in Craig's words—is the rate at which WRONG/RIGHT pairs land in the corrections-log shards. Baseline date 2026-05-08.

For a peer PM who wants to reuse the patterns above, [`for-pms-reusing.md`](../for-pms-reusing.md) walks the smallest-viable-version of each: the WRONG/RIGHT format as a working unit, the rule-promotion lifecycle as a lightweight template, and the era-shard pattern as a refactor trigger keyed to file size and consult-cost rather than aesthetic preference.

If [Case Study #1](./01-personal-ai-os.md) makes the meta-system legible and [Case Study #2](./02-composer-verifier.md) makes the operating loop legible, this case study makes the data structures legible: WRONG/RIGHT as the unit of correction, the rule-promotion lifecycle as the path from prose to machinery, the era-shard pattern as the refactoring discipline that keeps the rule set readable as it grows. Software-engineering rigor is what production-grade AI work looks like underneath the prose.

---

**Sources:** `~/.claude-local/skills/job-materials/references/corrections-log.md` + `corrections-log-archive.md` + `corrections-log/evals-6-15.md` + `live-applications.md` (era-shard split data point); `~/.claude-local/projects/job-materials-efficiency/` Sessions 2 + 3 logs (live data points: 194,363→shards; 168,338→23 files); `~/.claude-local/skills/job-materials/ROADMAP.md` (rule-promotion history).
**Last refreshed:** 2026-05-08
