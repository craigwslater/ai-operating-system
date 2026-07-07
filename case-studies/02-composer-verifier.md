# Composer / Verifier

> **Designed by Craig.** The multi-agent separation pattern, the eval-driven correction discipline, the rule set the verifier audits against, the recurrence-counter logic that forces structural rethinks when failures return.
> **Runtime: Claude.** Composer drafts under the rules. Verifier subagent audits the draft in a separate context. Pre-flight scripts run mechanical detectors. Corrections promote into source files at session end.
> **Source artifacts.** [`artifacts/sample-skill/`](../artifacts/sample-skill/) · [`artifacts/sample-eval.md`](../artifacts/sample-eval.md) · [`artifacts/sample-roadmap.md`](../artifacts/sample-roadmap.md)

## Origin moment

The architecture in this case study is the answer to a single observation Craig recorded in the project interview:

> "AI can hallucinate in all sorts of predictable ways, impacting ongoing quality and accuracy if not improved under a systematized evaluation and regression process. Early failures were around improving the skill but not producing the appropriate evaluation framework and regression testing to scale the skill. This was my biggest long-term quality unlock."

What follows is what the systematic-evaluation answer looks like in operating form: a two-agent pattern with mechanical detectors and an eval-driven correction loop that has shipped dozens of tailored applications, runs about 42 detectors against every draft, and catches and fixes hundreds of errors autonomously per month. The job-materials skill is the example. The pattern is the unit.

## What this is

The job-materials skill is a composer/verifier system that produces tailored cover letters and resumes for senior product-management roles. It runs inside `~/.claude-local/skills/job-materials/`. Each applied job becomes one *eval*—a regression-test record that captures the JD, the briefing research, the composed deliverables, the verifier's verdict, the corrections promoted to source rules, and the open follow-ups for the next eval. There are 40 evals to date. The detector count stands at 42. The system catches and fixes hundreds of errors autonomously per month and has shipped dozens of tailored applications; the experiential delta Craig describes as moving from "cognitive dissonance" to "minimal pressure" on every application.

This is the skill where eval-driven correction earned its place. The same patterns appear in other skills, but the volume and the live-application stakes make this the one to study.

## How the two agents fit together

The pattern has two operating units running in two contexts.

The **composer** runs inside the working session. It reads the JD, the company brief, the reader-model document, and Craig's persistent profile. It produces drafts under a rule set that lives at `references/voice-rules/`—a 6.8K-byte index plus 23 sliced reference files (21 per-rule, 2 supporting), refactored on 2026-05-07 from a 168K-byte / 1,596-line / 28-H2-section monolith. Each rule names: what the rule says, what the failure mode looks like in WRONG/RIGHT examples, where the rule fires in the composition flow, and the eval that promoted it.

The **verifier** runs as a separate subagent in a separate context. It reads the same rule set. It reads the composer's draft. It produces a structured verdict at four severity tiers (Blocker / High / Medium / Low) plus a Step 5.6 quality lens (Hook quality, Intersection density, Register Pass, Bonus-qual Pass, marked-defensible interpretive flags). It does not write the draft. It does not "fix" the draft. It returns the verdict, and the composer either ships, drops to a Pass 2 delta-revision, or escalates to Craig review.

The detail that does the load-bearing work is the *separate context*. The composer self-auditing inside the same context that produced the work is the failure mode this pattern defeats. The retrospection in [Case Study #1](./01-personal-ai-os.md) captures it in one sentence: in any AI workflow producing real deliverables, audit must run in a different context than composition.

A pre-flight layer sits before the verifier. `scripts/preflight_check.py` runs the mechanical detectors—Tier 1, pure pattern-matching that catches syntactic and structural failures before the verifier subagent gets called. Detectors that promoted to pre-flight include the hook fact-count gate (max 2 facts in S1), the Section 20(h) parallel-restrictive-relative tense detector, and the Check #10b adjacent-Tier-B repetition detector. Each was promoted to mechanical form because a verbal rule fired on the same shape twice in two consecutive evals; promotion to a script closes the gap so the same shape can't pass on attempt three.

## What gets fed in

The system parses a JD into structured signals before the composer drafts. The eval archive shows the shape repeated 23 times. The excerpt below is one such JD, redacted for company name and clinical specialty; the structural moves the composer makes against it are the same on any input.

```
Senior Product Manager
Remote
[REDACTED COMPANY] is a virtual [REDACTED SPECIALTY] clinic delivering
multi-disciplinary evidence-based [REDACTED SPECIALTY] treatment
through telemedicine. [...]

About the Role
We're looking for a strategic, hands-on, experienced Product
Manager to lead Scheduling & Care Access product development at
[REDACTED COMPANY]. Scheduling sits at the intersection of patient
access, provider utilization, and operational scale. [...] This
is a high-leverage role with end-to-end ownership of one of our
most consequential product areas, including the authority to make
build vs. buy decisions and shape the future architecture of our
scheduling stack.

What you will do
- Develop a deep understanding of workflows across patients,
  schedulers, patient coordinators, and providers.
- Identify the highest-impact jobs-to-be-done to improve access
  while reducing operational burden.
- Lead evaluation of third-party scheduling solutions vs. in-house
  development; prototype, test, and validate approaches grounded
  in data and long-term architectural fit.

About you
- 7+ years of product management experience, with time on
  scheduling or logistics products.
- Healthcare or care delivery experience.
- A bias for driving product decisions with metrics and analytics.
- Comfort making and defending build vs. buy decisions, including
  evaluating third-party vendors and integrating across systems.
```

The composer extracts four structured artifacts from a JD like this one. (1) A *JD briefing* that catalogs the top 6–8 JD concepts, the JD's exact vocabulary mapped to mastery angles Craig brings, the role-type classification (in this case: Healthcare Platform + Operational-Scheduling, with build-vs-buy authority as a high-leverage signal), and the hook-angle candidate driven by the company's current moment. (2) A *company brief* that finds the inflection point the hook will anchor on—a recent product launch, a funding round, a strategic pivot, an industry condition the company is responding to. (3) A *reader model* that names the hiring manager's likely concerns and how each will be addressed across cover letter and resume—surfaced, defended, or deliberately not addressed. (4) A *Craig application JSON* that locks the canonical phrases the composer is permitted to use verbatim. Phrase-locks exist because canonical phrasings drift across sessions otherwise; the JSON is the authoritative source.

These four artifacts feed the composer. The verifier reads them too. When the verifier flags a Medium issue and Craig disposes of it as defensible, the disposition gets logged in the eval. When the verifier flags a Blocker, composition holds and the rule that fired gets re-read.

## The cover-letter structure the composer produces

Every cover letter the system ships follows the same five-paragraph structure. The structure is governed by named rules, and the verifier audits each paragraph against the rules that govern it. The skeleton below is structural—paragraph functions, governing rules, verifier checks—not actual prose. (Dozens of shipped letters live operationally in `~/.claude-local/projects/job-search/outputs/`; none are reproduced here, per the redaction policy in [`projects/ai-operating-system/CLAUDE.md`](../artifacts/CLAUDE.md) §4 non-negotiable #1.)

```
P1—Hook (Rule 23, ~3 sentences)
   S1: name the company's current inflection point + Craig connection.
       Mechanical gate: max 2 substantive facts before challenge framing.
       Specificity test: a competitor's name swapped in must make S1 false.
   S2: anchor Craig's connection to the problem class.
       Required when hook structural form ends on company challenge.
       Banned: self-referential third sentence, success-validation stack,
       feature/condition list, generic mission restatement.

P2—Bridge (~2 sentences)
   Opening pronoun ("That work has centered on...") must have a clean
   antecedent in P1. Anaphoric-reference rule: prefer "This [noun]" over
   "The [noun]" when picking up an S1 noun.

P3—Lead story (~3 sentences)
   Most-relevant prior employer for the role-type classification.
   Anchored by a phrase-locked outcome metric. Domain-specific.

P4—Supporting story (~3 sentences)
   Second-most-relevant prior employer or adjacent angle.
   Cross-cutting evidence; tense parallelism with P3.

P5—Fit / closer (~2 sentences)
   Explicit connection between Craig's specifics and the JD's
   specific moment named in P1. Closes; does not summarize.
```

The verifier runs against this skeleton in two modes. **Pass 1** runs the full rule set: every detector at every severity. **Pass 2** runs delta-scope—only on paragraphs that changed during a Pass-1 fix cycle. Pass 2 was added to v3 because earlier evals were spending five-to-ten minutes re-verifying paragraphs the composer hadn't touched. Delta-scope cut that overhead without losing Pass 3, the full safety-valve re-read at session end.

## How the verifier audits

The detector population stratifies into three tiers.

**Tier 1—mechanical pre-flight detectors.** Pure pattern-matching scripts. They run before the verifier subagent is spawned. Examples: hook fact-count gate (counts substantive claims in P1 S1), Section 20(h) parallel-restrictive-relative tense detector (catches mixed tense in colon-introduced parallel relative clauses), the canonical-phrase-lock checker (enforces verbatim use of the locked outcome metrics from `craig_application.json`). When pre-flight catches an issue, composition holds; the composer fixes the violation before the verifier subagent runs at all.

**Tier 2—verifier semantic checks.** The verifier subagent reads the draft against semantic rules: hook dual-specificity, P3/P4 non-sequitur risk, em-dash apposition completeness, JD-vocabulary parroting risk, register consistency. Each check has a fired-instance history in a corrections-log shard. Each one came from a real eval where a real WRONG/RIGHT pair surfaced.

**Tier 3—Step 5.6 quality lens.** Five evaluative dimensions: Hook quality (1–5), Intersection density (1–5), Register Pass / Fail, JD bonus-qualification Pass / Fail, plus a marked-defensible interpretive-flag count. The quality lens is the last gate before ship.

The detector count is at 40, sitting at the working ceiling of 40. The ceiling exists because detector inflation has its own failure mode: a verifier with too many checks slows composition without improving outputs, and the rule set becomes unreadable. v5 Session 3 (closed 2026-05-06) shipped seven items inside the ceiling, including the Section 20(h) preflight and the Check #10b adjacency extension, and the count moved 38→39; v7 (closed 2026-05-19) added one more detector to reach the ceiling.

## The eval-driven correction loop

Every applied job becomes one regression-test record. The eval lives at `evals/eval-NN-[company-slug].md` and has a fixed structure: JD summary, mastery angles, key decisions (hook angle, role-type classification, story selection, bonus-qualification interpretation), the process notes from composition, the final-materials manifest, the Step 7.5 canonical backport audit, the lessons-and-open-items section, and a Reference Materials block that links to the working files.

When the verifier flags an issue and the disposition produces a corrected output, the WRONG/RIGHT pair gets promoted to a corrections-log shard at `references/corrections-log/`. The shard pattern is itself a result of an earlier failure mode: the original `corrections-log.md` reached 194K bytes / 1,534 lines as a single file before splitting into a 6K-byte index plus two era-shards (`evals-6-15.md` for numbered-eval corrections, `live-applications.md` for live-application corrections). That split happened during `job-materials-efficiency` Session 2 on 2026-05-07. The pattern—monolith to index plus shards—is the subject of [Case Study #3](./03-eval-driven-loops.md).

The loop closes when a correction encodes back into source. A new rule in `references/voice-rules/`. A new detector in `scripts/preflight_check.py`. A new sub-check in `qa-checklist.md`. A new gate in the verifier prompt. The conversation that surfaced the WRONG/RIGHT pair is ephemeral; the source files compound. This is the encode-into-source primitive named in [Case Study #1](./01-personal-ai-os.md), instantiated at the skill's operating level.

## Recurrence counters

The recurrence counter is the mechanism that escalates returning failure modes into structural rethinks. The current state is the v4 reopen counter, sitting at 1 of 2 as of 2026-05-06 ([REDACTED COMPANY] Eval 17 Rule 17 tail-phrase miss is the active reopen-trigger candidate). When the counter reaches 2 of 2, v4 gets reopened—meaning the corresponding skill release loses its closed status and a new improvement project gets scoped to address the recurrence pattern. The discipline forces a structural fix when verbal rules have failed twice in succession; it prevents the system from accumulating fragile rules that paper over the same underlying gap.

Recurrence counters appear in the eval files explicitly. Each eval that ships clean checks: did this application surface a composer-drift recurrence on an existing rule, or a NEW failure mode? NEW failure modes do not increment the counter. Existing-rule recurrences do. The distinction matters because counter increments are the costly signal—they justify a reopen, which justifies a new release project—and they need to mean what they say.

## What it produces

40 evals shipped across the job-materials skill. About 42 detectors active in the verifier. Hundreds of errors caught and fixed autonomously per month. Dozens of tailored applications shipped. The experiential delta is captured in Craig's own framing: applying for a job used to carry "a lot of cognitive dissonance, especially whether or not to write a cover letter in the first place"; with the system, "each application takes minimal pressure from a materials perspective." The decision-overhead removal is the under-appreciated half of the story. The visible half is quality. The under-the-surface half is that "should I even write a cover letter for this one?" stops being a question.

## Failure modes that drove the design

**Composer self-audit.** Around thirteen evals into the job-materials skill, the composer was self-auditing in the same context that produced the work, and significant drift was slipping through. The verifier subagent—running in a separate context, reading the same rule set, returning a structured verdict—is the answer. The pattern: in any AI workflow producing real deliverables, audit must run in a different context than composition. The cost of staying with self-audit is invisible drift that compounds across applications and erodes trust in the output.

**Discipline-as-prose-only.** Several detectors lived as verbal rules in `voice-rules.md` for evals before they were promoted to mechanical pre-flight scripts. The hook fact-count gate is a clear example: [REDACTED COMPANY] Round 5c (Eval 12) stacked four facts in S1 before any mechanical gate existed; the verbal rule fired on it qualitatively, but the same shape returned in subsequent evals because no script enforced the maximum. Promotion to `detect_hook_fact_count` in `scripts/preflight_check.py` closed the gap. Generalization: every behavioral rule should ship with an enforcement-method answer from day one, not as a retrofit. [Case Study #4](./04-discipline-to-machinery.md) walks the hooks-layer instantiation of this pattern at the system level, not just the skill level.

**Monolithic reference files.** The corrections-log reached 1,534 lines as a single file before the index-plus-shards split. The voice-rules reference reached 1,596 lines / 168K bytes / 28 H2 sections before the per-rule decomposition. Both decompositions reduced eager-load token cost—voice-rules dropped from 118.5K to 78.5K tokens, a 33.8% drop, hitting the Phase 1 ≤80K ceiling for the first time on 2026-05-07. Generalization: the sharded-with-index pattern should be the default from skill v2 forward, not a retrofit. The two live data points appear in [Case Study #3](./03-eval-driven-loops.md).

## What's next

The next three case studies extend the pattern outward. [Eval-Driven Correction Loops](./03-eval-driven-loops.md) walks the WRONG/RIGHT corrections-log discipline, the rule-promotion lifecycle, the era-shard split, and the per-rule decomposition—the modular-structure pattern that makes the rule set readable as it grows. [From Discipline to Machinery](./04-discipline-to-machinery.md) walks the hooks layer that turns the skill-level detectors and the system-level behavioral primitives into runtime checks at the file-system level. [Earned Autonomy](./05-autonomous-execution.md) walks the autonomous-execution engine that carries a bounded backlog end-to-end behind the same class of gates, escalating only the decisions that genuinely need a human.

The redacted operational artifacts in [`artifacts/sample-skill/`](../artifacts/sample-skill/), [`artifacts/sample-eval.md`](../artifacts/sample-eval.md), and [`artifacts/sample-roadmap.md`](../artifacts/sample-roadmap.md) are where any claim in this case study can be verified against actual source files—with PII, target-company names, third-party individuals, and prior-employer narrative redacted, but the operating system intact.

The [metrics dashboard](../metrics.md) tracks the four headline metrics over time: errors caught per month, evals shipped per quarter, detector count plus regression-test pass rate, and rules added per month across the global rule set and the skill rule sets. Baseline date 2026-05-08.

If the architecture in [Case Study #1](./01-personal-ai-os.md) makes the meta-system legible, this case study makes the operating loop legible: composer drafts, verifier audits in a separate context, every correction encodes back to source, recurrence counters escalate when the same gap returns.

---

**Sources:** `~/.claude-local/skills/job-materials/SKILL.md` (composer skill spec); `~/.claude-local/skills/job-materials/references/` (voice rules + craig-profile + qa-checklist + corrections-log); `~/.claude-local/skills/job-materials/ROADMAP.md` (detector inventory + bundle history); `~/.claude-local/skills/job-materials/evals/` (40 eval directories); `~/.claude-local/projects/ai-operating-system/inputs/interview-material.md` (failure-mode reflection verbatim).
**Last refreshed:** 2026-05-08
