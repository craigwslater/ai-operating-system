# Retrospection

> **Designed by Craig.** The three retrospections that drove the system's architecture decisions, the synthesis that ties them together, the design rule that comes out of treating them as one insight rather than three.
> **Runtime: Claude.** Drafting under the synthesis frame, surfacing the three retrospections as three faces of one underlying pattern, cross-linking to the case studies that walk each one operationally.
> **Source artifacts.** [`case-studies/02-composer-verifier.md`](./case-studies/02-composer-verifier.md) · [`case-studies/03-eval-driven-loops.md`](./case-studies/03-eval-driven-loops.md) · [`case-studies/04-discipline-to-machinery.md`](./case-studies/04-discipline-to-machinery.md)

Three things, in retrospect, the system needed from day one. Each has its own story. Each is documented in its own case study. They are not three separate lessons.

## The synthesis

AI workflows producing real deliverables need machinery, separation, and modular structure from day one, not as retrofits.

The three retrospections—composer/verifier separation came late; discipline as prose was brittle; the monolithic reference file was the default—are three faces of the same underlying pattern. Each one is a version of *do not delegate to the runtime a job the runtime is empirically bad at*.

A composer cannot reliably audit its own output. Putting the audit in the same context as the composition is a forgetting failure mode at the *context* layer. A behavioral primitive written as prose cannot reliably fire on every relevant invocation. Trusting the runtime to re-read the rule and apply it correctly is a forgetting failure mode at the *execution* layer. A 1,500-line reference file cannot reliably be navigated under cognitive load. Asking the runtime to scan a monolith for the relevant rule before composing is a forgetting failure mode at the *information-retrieval* layer.

The three failure modes share a structural cause: each one delegated to the runtime a task the runtime was empirically unreliable at, on the assumption that the runtime would remember to compensate. The runtime does not reliably remember. The fix in each case is not a stronger rule for the runtime to follow; the fix is to externalize the rule into structure—a separate audit context, a hook script, a sharded-with-index reference file—that does not depend on the runtime remembering anything.

## Composer / verifier separation came late

The job-materials skill ran for around 13 evals before introducing a verifier subagent that ran in a separate context from the composer. The composer was self-auditing: same context, same conversation, same model state. Drift slipped through. The pattern is documented in [Case Study #2—Composer / Verifier](./case-studies/02-composer-verifier.md).

The synthesis names this the *separation* axis. The answer to "the runtime cannot reliably audit its own output" is to put the audit in a separate context—a verifier subagent reading the same rule set against the composer's draft, returning a structured verdict at four severity tiers, never editing the draft. The verifier does not need to remember not to drift in the way the composer did; it does not have the composer's context to drift inside of. Separation removes the failure mode by removing the conditions for it.

## Discipline as prose was brittle

File-write verification, cross-file consistency, ROADMAP drift detection lived as `CLAUDE.md` primitives—prose rules with worked examples and named failure modes—for weeks before they became hooks. The pattern is documented in [Case Study #4—From Discipline to Machinery](./case-studies/04-discipline-to-machinery.md).

The synthesis names this the *machinery* axis. The answer to "the runtime cannot reliably re-apply prose rules on every invocation" is to encode the rule as a script that runs unconditionally on the relevant event—`PostToolUse` for write verification, `SessionEnd` for cross-file consistency, `SessionStart` for log pruning. Machinery does not depend on the runtime remembering to apply the rule. The rule applies because the script fires.

The pattern repeats one layer down inside the job-materials skill. A verbal voice-rule promotes through a lifecycle—prose with worked example, qa-checklist gate at composer-time, verifier-prompt sub-check at audit-time, mechanical pre-flight detector script that catches the failure shape before the verifier subagent runs at all. Each promotion stage moves the rule further from "the runtime remembers to apply it" toward "the rule applies whether the runtime remembers or not." Both layers run the same playbook.

## Monolithic reference files were the default

The corrections-log inside the job-materials skill grew to 194,363 bytes and 1,534 lines as a single file before being era-sharded into an index plus two shards on 2026-05-07. The voice-rules reference inside the same skill grew to 168,338 bytes, 1,596 lines, and 28 H2 sections before the per-rule decomposition cut eager-load tokens by a third on the same day. Both refactors are documented in [Case Study #3—Eval-Driven Correction Loops](./case-studies/03-eval-driven-loops.md).

The synthesis names this the *modular-structure* axis. The answer to "the runtime cannot reliably navigate a 1,500-line reference file under load" is the sharded-with-index pattern—a small navigation index pointing to multiple content shards, each shard scoped to a coherent unit of content (a single rule, a single era of evals, a single content category). The index loads cheaply at session start; the shards load on demand when their content is needed. The runtime navigates a 66-line index, not a 1,596-line monolith. Information retrieval becomes tractable at scale.

The pattern is recognizable in any platform engineering team's review meeting. Refactoring a 1,500-line file into smaller modules is not aesthetic preference; it is the answer to a measurable cognitive load. The same logic applies to a Claude session reading a reference file under composition pressure. The unit of analysis is the same.

## What "from day one" means

The design rule that comes out of treating the three retrospections as one synthesis: when introducing a new behavioral primitive, ship it with its enforcement-method answer. When introducing a new reference file, design it as an index-plus-shards from the start, or document the threshold at which it will split. When introducing a new audit step, run it in a separate context from the composition step.

Every promise to "formalize this later" is a retrofit waiting to happen. Retrofits cost more than the original design—not because the patch is harder to write, but because the retrofit accumulates drift in the interval. Thirteen evals of composer self-audit cost real applications that shipped with invisible issues. Weeks of file-write verification as prose cost real edits that did not actually land. A monolithic corrections-log cost every consult-time read across dozens of compositions.

The corollary: when an existing primitive is still living as prose, treat that as a known liability, not as a stable choice. The hook layer in [Case Study #4](./case-studies/04-discipline-to-machinery.md) and the rule-promotion lifecycle in [Case Study #3](./case-studies/03-eval-driven-loops.md) are both ongoing efforts to move primitives from prose to machinery. The work is not done; the design rule names which direction the work should keep going.

## What's still being tested

The synthesis is a working hypothesis. The hook layer is recent—weeks old at the time this is written. The era-shard pattern has been applied twice. The verifier-subagent pattern has shipped across 23 evals. The synthesis is supported by these artifacts; it is not yet falsified by long-term observation across the next class of failure mode that will surface.

The honest framing: this is what the system looks like after three retrofits have been applied and one design rule has been pulled out of them. Whether the same pattern—externalize what the runtime cannot reliably remember—holds for the next failure mode the system encounters is not yet known. The mechanism for finding out is the [metrics dashboard](./metrics.md): the rate at which new failure modes surface, the share that promote to machinery within the same session, the share that recur after promotion. The metrics are how the synthesis stays honest.

If the synthesis breaks—if a failure mode appears that does not fit the externalize-what-the-runtime-cannot-remember frame—the response will be a fourth retrospection, written into the system the same way the first three were. Until then, the design rule is the working answer. The case studies are the worked examples.

---

**Sources:** `~/.claude-local/projects/ai-operating-system/inputs/interview-material.md` (the three retrospections — composer/verifier-late, discipline-as-prose-late, monolith-late — verbatim from Craig's interview material).
**Last refreshed:** 2026-05-08
