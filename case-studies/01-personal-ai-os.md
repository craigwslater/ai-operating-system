# Personal AI Operating System

> **Designed by Craig.** The CLAUDE.md priority hierarchy, the behavioral primitives, the encode-into-source pattern, the dual-environment portability model, the four-layer architecture this case study walks.
> **Runtime: Claude.** Drafting under the rules, executing the policies as slash commands, applying every correction back into the source files, running the verification audits.
> **Source artifacts.** [`artifacts/CLAUDE.md`](../artifacts/CLAUDE.md) · [`artifacts/policies/`](../artifacts/policies/) · [`artifacts/install-scripts/`](../artifacts/install-scripts/)

## Origin moment

The full anchor lives in the [manifesto](../manifesto.md). The short version: an early conversation with Claude Sonnet 4.6, sitting inside the first version of `~/.claude-local/`, defined the working relationship that the rest of this system formalizes. The model commented that it doesn't often get asked how best to work with it. That observation—and the dialogue it produced—is what made "the system around the AI" the unit of work, not "the prompt."

What follows is what comes next when an operator takes that insight seriously: a folder structure that holds the rules, the identity, the projects, the skills, the policies, and the machinery—together—as the working surface for every Claude session.

## What this is

A *personal AI operating system* is a single source-of-truth folder, `~/.claude-local/`, that defines the working relationship with Claude. It contains the global rules every session reads first, the persistent identity context that doesn't change session-to-session, the per-project plans and handoff documents, the bundled skills Claude loads on demand, the documented workflow policies, the templates for new projects and new skills, and the hook scripts that enforce discipline at runtime.

It is not a prompt library. It is not a configuration file. It is the operational substrate that makes a multi-month working relationship with an AI auditable, durable, and improvable.

## Platform-PM thinking applied inward

A platform product manager thinks about composability, versioning, observability, contracts between components, eventual consistency, drift detection, and blast radius. The discipline is recognizable in any platform team's review meeting: who owns this surface, how do we version it, what are the invariants, what happens at the boundaries, how do we know when something has drifted.

This system is what those concepts look like when the platform under management is the operator's own AI workflow.

- **Composability.** Rules live in a priority hierarchy where earlier-numbered items beat later-numbered items, and behavioral primitives are named and reusable across sessions.
- **Versioning.** Projects ship as numbered releases—a job-materials v2, then v3, v4, v5, v6, v7; a claude-local-frontier, then a claude-local-frontier-v2. Each version is a separate folder with its own CLAUDE.md plan and CONTEXT.md status.
- **Observability.** A Commitment-Verification Audit at session-end re-reads each commitment against the work shipped. The session log records what changed and why.
- **Contracts.** Every file write to a mounted directory is read-back-verified. Every skill edit goes to the persistent path under `~/.claude-local/skills/`, never to a sandbox.
- **Eventual consistency.** The encode-into-source primitive moves every correction from conversation context into a source file (CLAUDE.md, a skill reference, or a policy) before session-end.
- **Drift detection.** Hooks scan for cross-file inconsistencies—a fix in CONTEXT.md but missing in the corresponding skill SKILL.md, for example—and surface them.
- **Blast radius.** A Decide-vs-Ask primitive forces explicit confirmation when a change touches multiple files or has high reversal cost.

The artifact in [`artifacts/CLAUDE.md`](../artifacts/CLAUDE.md) is where these primitives are written down. Every one of them appears there as a named primitive with a worked example.

## How it works—the four layers

The architecture stratifies into four layers. Each layer has its own folder under `~/.claude-local/`, its own concerns, and its own corrections-as-source discipline.

### Layer 1—Identity and rules

Two files at the root of `~/.claude-local/` carry this layer.

[`artifacts/CLAUDE.md`](../artifacts/CLAUDE.md) is the global behavioral-rules file. Every Claude session reads it first. It defines the priority hierarchy (truth-telling beats data-accuracy beats reasoning-quality beats verify-before-claim-complete beats surgical-discipline beats proactive-issue-surfacing beats persistence-and-auditability beats efficiency, in that order, with earlier wins on conflict), a list of named behavioral primitives, and a list of anti-patterns each of which Claude is required to recognize and avoid.

The MEMORY.md file alongside it carries identity-stable context: name, contact, location, professional summary, the active-projects registry, the e-commerce brand, the tools and platforms in use. CLAUDE.md is rules; MEMORY.md is who.

The encode-into-source primitive ties them together. Every correction lands in a source file—never just in the conversation. If the operator says "Claude, you keep mistaking X for Y," the fix is a sentence in CLAUDE.md or a reference file under `~/.claude-local/skills/[skill-name]/`, encoded immediately, read back, verified. The conversation is ephemeral; the source files compound.

### Layer 2—Skills and projects

`~/.claude-local/skills/` holds the bundled capabilities Claude loads on demand. A *skill*, in the Anthropic primitive sense, is a folder with a SKILL.md file describing when the skill triggers and what it does, plus references, scripts, evals, and a [ROADMAP.md](../artifacts/sample-roadmap.md) that holds open considerations and completed work. Each skill cites its own corrections-log as the source of every rule it applies.

`~/.claude-local/projects/` holds the per-project work containers. Each project gets a folder with its own CLAUDE.md plan (the binding scope and sequencing for the multi-session arc—the plan you're reading the meta-version of right now), a CONTEXT.md status file (the session handoff contract—read at session start, updated at session end, always reflects reality), a `log.md` (the session-by-session record), and `inputs/` plus `outputs/` for source material and deliverables.

Versioned releases live at the projects layer. The job-materials skill has shipped through six release projects—`projects/job-materials-v2/`, `v3/`, `v4/`, `v5/`, `v6/`, `v7/`—each closed cleanly with its own retrospective and improvement bundle. The claude-local-frontier meta-project has a v1 and a v2; v2 closed in three sessions. Versioning happens because closing a release is the discipline that forces a clean stopping point and an explicit commitment to what the next version owes.

### Layer 3—Policies and templates

`~/.claude-local/policies/` holds the documented workflows that wrap slash commands. The current set: [`session-start.md`](../artifacts/policies/session-start.md), [`session-end.md`](../artifacts/policies/session-end.md), [`new-project-intake.md`](../artifacts/policies/new-project-intake.md), [`commitment-verification-audit.md`](../artifacts/policies/commitment-verification-audit.md), [`file-delivery.md`](../artifacts/policies/file-delivery.md), and [`skill-roadmap.md`](../artifacts/policies/skill-roadmap.md). Each policy file defines a workflow as a set of numbered steps. Each is exposed as a slash command—`/start-session`, `/end-session`, `/start-project`, `/audit`, `/promote-canonical`—so the workflow runs the same way every time.

`~/.claude-local/templates/` holds the scaffolding for new artifacts. New project? `project-CLAUDE-md.template` plus `project-CONTEXT-md.template` define the file shape. New skill? `skill-ROADMAP.md.template` defines the canonical structure for tracking open considerations, completed work, and candidate bundles. New eval? `eval-template.md` defines the structure of an applied-and-archived regression record.

The pattern across this layer: every recurring workflow becomes a policy file with an exposed slash command. Every recurring artifact becomes a template. The discipline is to never run the same multi-step workflow twice without writing it down.

### Layer 4—Hooks (machinery)

The hooks layer is the runtime enforcement of behavioral primitives that started as prose. File-write verification is a CLAUDE.md primitive; the matching hook script confirms every write to a mounted path was read-back-checked. Cross-file consistency is a session-end discipline; the matching hook flags drift between sibling files. Session-end context-reminder is a primitive about CONTEXT.md staying current; the matching hook fires at session-end to surface stale entries.

The depth on this layer lives in [Case Study #4—From Discipline to Machinery](./04-discipline-to-machinery.md). The framing here is the architectural one: every behavioral primitive ships with an enforcement-method answer. Prose-only rules are a known failure mode (one of the three retrospections listed below). Hooks are the answer.

## Dual-environment portability

The same `~/.claude-local/` source folder runs in two environments: Cowork (mounted into a session via the cowork directory tool) and Claude Code (native, resolved directly under the home directory). Personal skills under `~/.claude-local/skills/` always take priority over any system-bundled copies. The path-resolution rules are documented and version-controlled with the system itself.

The portability matters for one reason: the same source of truth governs every session, regardless of which surface Claude is running on. A correction made in a Claude Code session shows up in the next Cowork session because both environments read the same files. The dual-install scripts in [`artifacts/install-scripts/`](../artifacts/install-scripts/) make the wiring deterministic on each surface.

## What it produces

The system produces three things that a hiring manager can verify.

**Compounding source files.** CLAUDE.md has grown not by accumulation but by encode-into-source: every recurring correction has become a primitive. Every skill's references-corrections-log holds the WRONG/RIGHT records that promoted the skill's rules. Conversation context is ephemeral. Source files compound.

**Versioned project releases.** The job-materials skill has shipped 36 evals across six release projects. The claude-local-frontier meta-project shipped seven structural improvements across two versions. Each release closes with a retrospective and a commitment-verification audit. The discipline produces visible cadence.

**Quantitative output.** The job-materials skill alone runs about 40 detectors against every draft, has shipped 36 evals, and catches and fixes hundreds of errors autonomously per month—measured directly from the corrections logs. Those numbers anchor the headline metric on the [metrics dashboard](../metrics.md). The depth on the operational mechanics—composer/verifier separation, eval-driven correction, hooks as enforcement—lives in [Case Study #2](./02-composer-verifier.md), [Case Study #3](./03-eval-driven-loops.md), and [Case Study #4](./04-discipline-to-machinery.md).

## Failure modes that drove the design

Three retrospections, captured in [`retrospection.md`](../retrospection.md), drove the architecture decisions you've just toured.

**Composer/verifier separation came late.** The job-materials skill ran for around thirteen evals before introducing a verifier subagent that ran in a separate context from the composer. The composer was self-auditing, and significant drift slipped through. Generalization: in any AI workflow producing real deliverables, audit must run in a different context than composition. Case Study #2 walks the resulting two-agent pattern.

**Discipline-as-prose is brittle.** File-write verification, cross-file consistency, ROADMAP drift detection lived as CLAUDE.md primitives—prose rules—for weeks before becoming hooks. Prose-only rules depend on the runtime re-reading the rule and applying it correctly each time. Machinery is durable. Generalization: every behavioral primitive should ship with an enforcement-method answer from day one. Case Study #4 walks the hooks layer.

**Started with monolithic reference files.** The corrections-log inside the job-materials skill grew to 194,363 bytes / 1,534 lines as a single file before the split into an index plus two era-shards. The voice-rules reference inside the same skill grew to 168,338 bytes / 1,596 lines / 28 sections before the per-rule decomposition cut eager-load tokens by a third. Generalization: the sharded-with-index pattern (small index file pointing to multiple content shards) should be the default from skill v2 forward, not a fix applied after the file becomes unwieldy. Case Study #3 walks the era-shard pattern with both data points.

The synthesis line—captured in [`retrospection.md`](../retrospection.md): *AI workflows producing real deliverables need machinery, separation, and modular structure from day one, not as retrofits.*

## What's next

The next three case studies go deeper. [Composer/Verifier](./02-composer-verifier.md) walks the two-agent pattern that turned skill drafts into auditable production output. [Eval-Driven Correction Loops](./03-eval-driven-loops.md) walks the WRONG/RIGHT corrections-log discipline and the rule-promotion lifecycle. [From Discipline to Machinery](./04-discipline-to-machinery.md) walks the hooks layer that turned behavioral primitives into runtime checks.

The redacted artifact tier in [`artifacts/`](../artifacts/) is where a reader can verify any claim in this case study against the actual source files—with PII, target-company names, third-party individuals, and prior-employer narrative redacted, but the architecture intact.

The [metrics dashboard](../metrics.md) is where the system's compounding effect is tracked over time. Baseline date: 2026-05-08.

[`Surprises`](../surprises.md) names two things a reader unfamiliar with this kind of work might miss: AI as a willing collaborator on its own working relationship, and the fact that most of what gets called "AI quality" is the system around the AI, not the AI itself.

---

**Sources:** `~/.claude-local/CLAUDE.md`; `~/.claude-local/MEMORY.md`; `~/.claude-local/projects/`, `~/.claude-local/policies/`, `~/.claude-local/templates/`, `~/.claude-local/skills/` (architecture pattern); `~/.claude-local/projects/ai-operating-system/inputs/interview-material.md` (origin-moment dialogue verbatim).
**Last refreshed:** 2026-05-08
