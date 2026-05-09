# Methodology

## What this document does

This is the layered overview of the architecture—the bridge between the README's headline and the case studies' depth. A reader who lands here either skipped the case studies and wants the structure in one read, or read one case study and wants to see how it sits inside the whole. The four-layer architecture, the cross-cutting patterns, and the sync mechanism that keeps this portfolio current are walked here in that order. Every architectural claim links to the case study or artifact that demonstrates it operating.

---

## The four layers

The system stratifies into four layers under `~/.claude-local/`. Each layer has its own folder, its own concerns, and its own corrections-as-source discipline. Layers 1-3 carry the platform-PM concerns—identity, scope, workflow. Layer 4 is where behavioral primitives become runtime checks. Reading top-to-bottom traces the path a primitive walks from prose rule to executing machinery.

### Layer 1—Identity and rules

`CLAUDE.md` and `MEMORY.md` sit at the root of `~/.claude-local/`. CLAUDE.md is the global behavioral-rules file every Claude session reads first—a priority hierarchy where earlier-numbered items beat later-numbered items, a list of named behavioral primitives, and an explicit anti-patterns list. MEMORY.md is identity-stable context: name, contact, professional summary, the active-projects registry, the e-commerce brand, the tools in use. CLAUDE.md is rules; MEMORY.md is who. The encode-into-source primitive ties them together—every correction lands in a source file, never just in conversation, read back and verified before the session closes. Walked operationally in [Case Study #1](./case-studies/01-personal-ai-os.md).

### Layer 2—Skills and projects

`skills/` holds the bundled capabilities Claude loads on demand—each one a folder with a SKILL.md describing trigger conditions, references, scripts, evals, and a ROADMAP.md tracking open considerations and completed work. `projects/` holds the per-project work containers—each project a folder with a CLAUDE.md plan, a CONTEXT.md status file (read at session start, updated at session end, always reflects reality), a session log, and `inputs/` plus `outputs/` for source and deliverables. Versioned releases live at the projects layer—the job-materials skill has shipped through four release projects, the meta-architecture project has shipped two versions—because closing a release is the discipline that forces a clean stopping point and an explicit commitment to what the next version owes. Composer/verifier separation and eval-driven correction are walked operationally in [Case Study #2](./case-studies/02-composer-verifier.md) and [Case Study #3](./case-studies/03-eval-driven-loops.md).

### Layer 3—Policies and templates

`policies/` holds the documented workflows that wrap slash commands: `session-start.md`, `session-end.md`, `new-project-intake.md`, `commitment-verification-audit.md`, `file-delivery.md`, `skill-roadmap.md`, and `publish-portfolio.md`. Each defines a workflow as numbered steps and is exposed as a slash command (`/start-session`, `/end-session`, `/start-project`, `/audit`, `/promote-canonical`, `/publish-portfolio`) or invoked from inside one, so the workflow runs the same way every time. `templates/` holds the scaffolding for new artifacts—a project template, a skill ROADMAP template, an eval template. The discipline across this layer: every recurring workflow becomes a policy with an exposed slash command, every recurring artifact becomes a template, no multi-step workflow gets run twice without being written down.

### Layer 4—Hooks

The hooks layer turns behavioral primitives into runtime checks at the file-system level. Six hook scripts live under `hooks/` and fire on three event types: `PostToolUse` after every Write/Edit, `SessionStart` when a session begins, `SessionEnd` when a session closes. Each one encodes a CLAUDE.md primitive that previously lived as prose. File-write verification, cross-file consistency, session-end context-reminder, structural-improvement detection, commitment-log lifecycle pruning, and portfolio-sync signal detection are the six. The same hook source runs unchanged on Claude Code and on Cowork through a path-resolution fallback chain—only the install path differs. Walked in [Case Study #4](./case-studies/04-discipline-to-machinery.md).

---

## The patterns that thread through

The four layers carry shared patterns that surface in more than one case study. Reading the case studies in sequence is one way to encounter them; the explicit naming below is the alternative.

### Composer / verifier

Audit must run in a different context than composition. A composer self-auditing inside the same context that produced the work is the failure mode this pattern defeats. The verifier subagent runs in a separate context, reads the same rule set the composer reads, returns a structured verdict at four severity tiers, and never edits the draft. Walked in [Case Study #2](./case-studies/02-composer-verifier.md).

### Encode-into-source

Every correction lands in a source file before the session closes—a CLAUDE.md primitive, a skill reference, a policy file, an eval record. Conversation context is ephemeral; source files compound. The primitive is what makes a multi-month working relationship with an AI auditable rather than narrative. Walked at the meta-architecture level in [Case Study #1](./case-studies/01-personal-ai-os.md) and at the skill level in [Case Study #3](./case-studies/03-eval-driven-loops.md).

### Modular structure (era-shard, per-rule decomposition)

Reference files split into an index plus content shards once they exceed the load-cost threshold for a single context. The skill where the pattern earned its place had a corrections-log that grew to 194,363 bytes / 1,534 lines as a single file, and a voice-rules reference that grew to 168,338 bytes / 1,596 lines / 28 H2 sections, before each was refactored on 2026-05-07 into a small index plus shards. The voice-rules refactor cut eager-load tokens by a third. The runtime navigates a 66-line index, not a 1,596-line monolith. Walked in [Case Study #3](./case-studies/03-eval-driven-loops.md).

### Eval-driven correction

Every applied job becomes one eval—a regression-test record that captures the JD, the briefing research, the composed deliverables, the verifier's verdict, the corrections promoted to source rules, and the open follow-ups. Detectors that catch returning failure modes promote from prose to mechanical pre-flight scripts when the same shape fires across consecutive evals. Recurrence counters force structural rethinks when failures return after promotion. There are 23 evals and about 39 detectors at this writing. Walked in [Case Study #3](./case-studies/03-eval-driven-loops.md).

### Discipline becomes machinery

Behavioral primitives that began as prose in CLAUDE.md become hook scripts on `PostToolUse`, `SessionStart`, and `SessionEnd` events. Prose-only rules depend on the runtime re-reading the rule and applying it correctly each time; machinery is durable. The same playbook runs at the skill level through the rule-promotion lifecycle—prose, qa-checklist gate, verifier-prompt sub-check, mechanical pre-flight detector—each stage moving the rule further from "the runtime remembers to apply it" toward "the rule applies whether the runtime remembers or not." Walked in [Case Study #4](./case-studies/04-discipline-to-machinery.md).

---

## How to read this portfolio

The README names three reader paths; this is what each one looks like in pages.

A recruiter with 60 seconds reads the README headline plus the [manifesto](./manifesto.md). Both anchor on the same claim: AI is a multiplier, not an equalizer, and the system around the AI is what does the multiplying. The headline numbers—23 evals, about 39 detectors, hundreds of errors caught per month—appear in both.

A product hiring manager with 10-20 minutes reads one or two case studies. [`Personal AI Operating System`](./case-studies/01-personal-ai-os.md) walks the meta-architecture; it is the right entry for assessing platform-PM thinking applied inward. [`Composer/Verifier`](./case-studies/02-composer-verifier.md) walks the two-agent pattern that takes drafts to production-grade output. [`Eval-Driven Correction Loops`](./case-studies/03-eval-driven-loops.md) and [`From Discipline to Machinery`](./case-studies/04-discipline-to-machinery.md) go deeper on the rule-promotion lifecycle and the hooks layer.

A peer PM curious about the methodology starts here, then browses the [`artifacts/`](./artifacts/) folder for the redacted operational files (the global rules, the policies, a sample skill, a sample eval, a sample ROADMAP, a hook script, the dual-environment install scripts). [`for-pms-reusing.md`](./for-pms-reusing.md) is the explicit "how to build similar" walkthrough; [`retrospection.md`](./retrospection.md) is the synthesis statement.

---

## How the portfolio gets updated

The portfolio is a derived artifact. Updates flow from `~/.claude-local/` to the public repo, never the other direction. A SessionEnd hook (`session-end-portfolio-sync.sh`) detects portfolio-worthy signals across the source folder since the last sync and surfaces a prompt at session close recommending `/publish-portfolio` next session. Five signal categories fire the hook: a ROADMAP item resolved with portfolio relevance, a new eval shipped, a new CLAUDE.md primitive added, a project closed, a version release of an existing project. State lives in a small JSON file under the project directory, updated only by `/publish-portfolio` on a successful push so the "since last sync" semantic is preserved.

The publish slash command is commit-and-push only. It runs the redactor's `verify` and `sanity-grep` modes against every Markdown file in the working portfolio-repo as a hard pre-commit gate, stages the diff, surfaces it for explicit approval (vague responses do not count—the approval phrase must unambiguously name the diff), commits, pushes, and then refreshes the sync state. Per-push diff review is non-negotiable per the project's binding rules. The mechanism is real, not aspirational; the SessionEnd hook fires unconditionally on its own signal logic, and the publish protocol is the only path that updates the public repo.

---

The redacted operational artifacts in [`artifacts/`](./artifacts/)—the global rules file, the policies folder, a sample skill, a sample eval, a sample ROADMAP, a sample hook, the dual-install scripts—are where any architectural claim above can be verified against the underlying source files. The [metrics dashboard](./metrics.md) tracks the four headline metrics over time. Baseline date 2026-05-08.

---

**Sources:** `~/.claude-local/CLAUDE.md` (priority hierarchy + behavioral primitives); `~/.claude-local/MEMORY.md` (identity model); `~/.claude-local/projects/ai-operating-system/CLAUDE.md` (project §5 architecture); architectural pattern across `~/.claude-local/projects/`, `~/.claude-local/skills/`, `~/.claude-local/policies/`, `~/.claude-local/hooks/`, `~/.claude-local/templates/`.
**Last refreshed:** 2026-05-08
