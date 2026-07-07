# For PMs Reusing These Patterns

A peer PM who has read the case studies and wants to test these patterns inside a different workflow can start small. This page is the implementation guide. It does not assume the reader builds 40 evals and 42 detectors before deciding whether the approach pays back. It assumes the reader wants the cheapest version that demonstrates the pattern, plus the explicit sequencing that lets later additions compound rather than collide.

The patterns are independent enough that a reader can adopt them in any order. The order below is what would have saved the most rework if Craig had built this system from scratch knowing what he knows now.

## Start here—the WRONG/RIGHT pair as the unit of correction

The smallest viable version of eval-driven correction is one file with one entry. Pick a workflow where the AI produces drafts and the operator corrects them. Open a `corrections-log.md` file at the root of the workflow's folder. The first time a correction happens, write down five fields:

1. **Failure mode**—a sentence naming the shape that fired the rule.
2. **WRONG**—the verbatim phrase from the draft that surfaced the issue.
3. **RIGHT**—the canonical phrasing that satisfies the rule.
4. **Diagnostic**—a one-line rationale for why the WRONG fails and the RIGHT works.
5. **Rule**—a pointer to where the rule lives, even if it does not exist yet (write "tbd—rule file not yet created" rather than skipping the field).

The structure is in [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md) with a real worked example. The smallest-viable-version is one entry. The cost of starting is five minutes.

What this buys: every future draft can be checked against the WRONG pattern. Verbal rules without paired worked examples are brittle; verbal rules with paired examples are pattern-recognizable. The corrections-log becomes the regression suite for the workflow whether or not the workflow ever ships a numbered eval framework.

## Add second—the rule-promotion lifecycle stages, used cheaply

A correction in the corrections-log is Stage 1 of the rule-promotion lifecycle. The case study walks five stages—prose rule, worked example, qa-checklist gate, verifier sub-check, mechanical pre-flight detector. A peer PM does not need all five on day one. The cheap version is two stages: the WRONG/RIGHT pair (above) plus a self-check before draft submission.

The self-check is a `qa-checklist.md` file or even a comment in the source rule file. Format: numbered items the operator (or the model under self-audit) reads against a draft before declaring it ready. One self-check per active rule. When a self-check fires twice in succession on the same shape, that is the signal that the rule needs to escalate—either to a verifier-prompt sub-check (separate context audit) or to a mechanical detector (script that runs unconditionally). Recurrence is the promotion trigger.

What this buys: rules harden over time as a function of failures, not as a function of authoring effort. A peer PM avoids the trap of front-loading rule writing before the rules have been validated against real failures.

## Add third—a separate audit context for high-stakes drafts

[Case Study #2—Composer / Verifier](./case-studies/02-composer-verifier.md) walks the multi-agent pattern at production scale. The cheap version is one extra step: when a draft is high-stakes, open a fresh chat or a fresh subagent in a separate context window and paste in (a) the draft, (b) the rule set, (c) one instruction—"audit this draft against the rules; do not edit, return a structured verdict." The separate context defeats the failure mode where the composer self-audits inside the same context that produced the draft.

A peer PM does not need a verifier subagent infrastructure on day one. A second tab is sufficient for any draft that matters. The pattern scales up later—into a verifier prompt under version control, into Tier 1/2/3 detector tiers, into a mechanical pre-flight script—but the first version is just the second tab.

What this buys: invisible drift gets seen. The composer cannot reliably catch its own drift because the same context that produced the drift is the context that audits it. Separation removes the failure mode by removing the conditions for it.

## Add fourth—the era-shard refactor when a reference file gets unwieldy

Reference files grow. The corrections-log inside the job-materials skill grew to 1,534 lines and 194,363 bytes before the refactor. The voice-rules reference grew to 1,596 lines and 28 H2 sections. Both refactors happened the same week, both under the same pattern—index plus shards, where the index is small enough to load every session and the shards load on demand.

The cheap version of the era-shard pattern is a refactor trigger keyed to file size. When a reference file passes a threshold (a useful starter is ~500 lines or ~50 KB), split it. The split happens at content-natural boundaries—one shard per era, or one file per rule, or one shard per content category—not at arbitrary line counts. Each shard gets a provenance header naming what it was split from and when. The original file path becomes the navigation index pointing to the shards.

What this buys: load cost stays bounded as the workflow accumulates corrections and rules. A peer PM who never refactors their reference files pays a context-window cost that grows linearly with how much the workflow has learned. The refactor is the amortization.

## Add last—the hooks layer

[Case Study #4—From Discipline to Machinery](./case-studies/04-discipline-to-machinery.md) walks the runtime layer that encodes behavioral primitives as runtime checks. The cheap version is one hook: a `PostToolUse` hook scoped to Write/Edit that confirms the file write actually landed. The script is a few lines of bash—check that the file exists and is non-empty after the tool call, surface a warning if not.

The single hook is enough to demonstrate the prose-to-machinery move at starter scale. The full hooks layer—commitment-log JSONL, dual-environment portability, drift detection at session-end—can wait until a second environment is in play or until the audit volume justifies the implementation cost. A peer PM with one workspace, manual session-end discipline, and a single behavioral primitive worth automating is the right starting point.

What this buys: at least one rule applies whether the runtime remembers or not. Everything else can stay as discipline-as-prose until the recurrence pattern justifies promotion.

## What NOT to copy verbatim

Several pieces of this system are Craig-specific. They demonstrate the patterns above, but they are not patterns themselves; copying them verbatim would be cargo-cult.

- **The job-materials skill structure.** It exists because Craig has been running an active job search and produced 23 applied-job regression-test records. A peer PM with a different workflow needs different evals, different detectors, different rule files. The structure is the reusable unit; the contents are not.
- **The 39-detector population.** Each detector was promoted because a specific failure mode fired twice. The detectors solve Craig's drafting failure modes (canonical phrase fidelity, hook fact-count limits, parallel-restrictive-relative tense, JD-vocabulary parroting). A peer PM's failure modes will be different. The lifecycle that produced the 39 is reusable; the 39 themselves are not.
- **The multi-session arc that produced this portfolio.** It exists because Craig set out to publish a derived artifact for a specific recruiting purpose. A peer PM testing the patterns above does not need a multi-session arc. The patterns survive at smaller scope.
- **The dual-environment install (Claude Code plus Cowork).** Most peer PMs run Claude in one environment. The dual-install pattern is reusable for anyone running both, but it is not a prerequisite. A single-environment install is sufficient for everything above.
- **The metrics dashboard at four metrics.** A peer PM should pick the metric that maps to the headline of the work. For Craig, "errors caught per month" is the headline because the use case is high-quality production drafts. A different use case has a different headline. The dashboard pattern is reusable; the metric set is not.

## Sequencing notes

The patterns compound. The order above—WRONG/RIGHT pair, then promotion lifecycle, then separate audit context, then era-shard refactor, then hooks layer—is the order that minimizes rework if the reader works through them in sequence.

The early steps are cheap and keep working as later steps are added. The corrections-log built in step 1 becomes the input to the lifecycle promotions in step 2 and to the audit context in step 3 and to the era-shard refactor in step 4 and to the rule-count metric tracked by the hooks in step 5. None of the early work is thrown away.

The reverse is not true. Building hooks before there is a corrections-log to encode means the hooks have nothing to enforce. Building a separate audit context before there are rules to audit against means the second tab does general-purpose review, which is what the operator was already doing in the first tab. The patterns rely on each other in roughly the order listed.

For deeper context, [`retrospection.md`](./retrospection.md) names the design rule that ties these patterns together: AI workflows producing real deliverables need machinery, separation, and modular structure from day one, not as retrofits. The patterns above are the smallest-viable-version of "from day one" at each layer.

The case studies—[Case Study #1](./case-studies/01-personal-ai-os.md), [Case Study #2](./case-studies/02-composer-verifier.md), [Case Study #3](./case-studies/03-eval-driven-loops.md), [Case Study #4](./case-studies/04-discipline-to-machinery.md)—are where the production-scale instantiations live, with the redacted artifacts in [`artifacts/`](./artifacts/) as the operational evidence base. A reader who has tested one of the patterns above and wants to scale up has the case studies as the reference architecture.

---

**Sources:** `./methodology.md` + `./case-studies/03-eval-driven-loops.md` + `./case-studies/04-discipline-to-machinery.md` (the reusable patterns synthesized inside this portfolio); ultimate `~/.claude-local/` sources documented in those files' own footers.
**Last refreshed:** 2026-05-08
