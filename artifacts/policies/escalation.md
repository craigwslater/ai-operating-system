<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. This is a redacted EXCERPT (§1–§3), not the full policy. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The async escalation protocol that governs how the autonomous-execution engine handles decision points when no human is watching each step. This excerpt carries the parts Case Study #5 is built on: where the protocol fits, the DECIDE/PARK/STOP model, and the nine-gate blocking taxonomy. The full policy adds the queue schema, the notify interface, the resume contract, and the non-negotiable cross-checks.
> **Where the autonomy ladder went.** The three-tier model, the five-part eligibility gate, and the graduation procedure were split out of this policy into `policies/autonomy-eligibility.md` on 2026-07-23, because `/orchestrate` reads them near-exclusively at pre-flight. They are published as their own artifact—[`autonomy-eligibility.md`](autonomy-eligibility.md) in this same folder. This artifact carried them as §9.1–§9.3 until the 2026-08-27 re-port; splitting the artifacts mirrors the split upstream.
> **What was omitted.** (1) Each gate's worked example (§3.1–§3.9)—eleven lines across the nine gate types, every one drawn from the bounded-backlog pilot the engine was tested on and carrying that venture's product-domain specifics (`inputs/redaction-registry.md` Category 6; `sanity-grep-entities.md` Category D). The gate type and its default outcome, which are the reusable core, are retained. So where §3's opening sentence says every type carries a worked example, that is true of the source and not of this excerpt. (2) §4–§8, per the excerpt scope above.
> **What was redacted.** Two substitutions survive into this excerpt: one pre-launch-venture catalog price used as a threshold in §2, masked to `[price point]` per registry entry trg-015, and one internal pipeline identifier masked to `[bounded-backlog project]` per row ape-001. The registry also fires rows ape-003 and ape-004 on this source, but only on §3 worked-example lines, which this excerpt omits. No PII, active-target-company, or third-party-individual content appears in this file.
> **Why it's included.** A reader who wants to check the case study's central claim—that this is safety-gated, earned autonomy rather than "let the model run"—reads the actual gate taxonomy here, and the tier ladder in the sibling artifact, in the source's own words.

---

# Async Escalation Protocol (Autonomous Execution)

**Status: pilot-validated + S5-hardened; APE closed 2026-07-01.** This policy governs how an *unattended* execution loop handles decision points. It activates **only** under the headless orchestrator (APE S2+) and is **not** part of any eager-load or interactive-session path — an interactive session uses the synchronous `Decide vs Ask` primitive in root `CLAUDE.md` directly. Build/validation history (S4b pilot F1–F7, S5a/b/c encodings, the ninth `quality-trend` gate added by `orchestrate-command` S2) → `projects/autonomous-project-execution/log.md`.

This is the **async** counterpart to the global `Decide vs Ask` primitive. The synchronous primitive assumes a human in the chat: every ASK blocks because Claude waits in-turn. An unattended loop has no chat to wait in — so it needs (a) a way to keep working while a question is outstanding, (b) a durable queue the question lives in, (c) a channel that pings Craig, and (d) a contract for resuming correctly when he answers async. Get it wrong in one direction → constant interruption (no better than manual); wrong in the other → silent guesses on high-blast-radius calls (worse than manual). This protocol is tuned to avoid both.

---

## 1. Where this fits

- **Extends, never overrides, the global primitive.** Root `CLAUDE.md` → Behavioral Primitives → *Decide vs Ask* and the three hard rules under it (*Never resolve a decision Claude knows requires Craig's input*; *A failed question is unanswered*; *an interruption never converts an ASK into a DECIDE*) are load-bearing here verbatim. This file only adds the async machinery around them.
- **Consumes guardrails, does not define them.** Enforcement of forbidden-path writes is the `claude-local-frontier-hooks` Safety Layer (`PreToolUse`); the done-criteria gate is its Completion Gate (`Stop`). APE S3 integrates them; this protocol *routes* decisions, the hooks *enforce* them. The two appear to share the `PreToolUse` event, but **APE S3 resolved this as a layering, not a contention** (`orchestrator/orchestrator-protocol.md` §8): FH enforces the block inside the unit session (the write never lands); APE routes the *consequence* from the orchestrator session, post-hoc, via the GUARD-BLOCKED marker. They compose in series, never co-decide the event.
- **Pairs with two format artifacts** (APE S1, same session): the execution-plan artifact (`projects/autonomous-project-execution/execution-plan-format.md`) compiles a project into the unit queue this protocol gates; the run-state ledger (`projects/autonomous-project-execution/run-state-ledger-schema.md`, `RUN.json`) is where gate state and checkpoints live.

---

## 2. The three outcomes — DECIDE / PARK / STOP

At every decision point `D` the loop reaches while running a unit, it resolves `D` into exactly one of three outcomes:

| Outcome | When | What the loop does | Notify? |
|---|---|---|---|
| **DECIDE** | `D` is reversible **AND** has a single clearly-better option **AND** aligns with an established preference | Resolve it; record the choice + rationale in the run-state ledger | No |
| **PARK** | `D` meets the ASK bar **AND** nothing in the remaining unit work depends on `D`'s outcome | Enqueue the gate; continue the *independent* sub-tasks; resolve `D` when the answer arrives | Batched |
| **STOP** | `D` meets the ASK bar **AND** (it blocks the unit — remaining work depends on it — **OR** any further write would compound a wrong call) | Checkpoint the unit; halt it; move to the next independent unit if one exists, else idle | Immediate |

**The ASK bar is the global one, unchanged:** a decision meets it when blast radius is high **OR** multiple coherent options have materially different tradeoffs **OR** the option doesn't align with a known preference **OR** it is irreversible. Everything below the bar is a DECIDE.

**Decision procedure (pseudocode):**

```
resolve(D):
  if reversible(D) and single_clearly_better(D) and aligns_with_preference(D):
      record_decision(D, choice, rationale)          # ledger only, no notify
      return DECIDE
  # D meets the ASK bar — NN#3: the loop must NOT resolve it itself
  if blocks_unit(D) or any_further_write_compounds(D):
      checkpoint(unit); enqueue(gate(D, severity=STOP)); notify_now(gate)
      return STOP            # → next independent unit, or idle until answered
  if independent_of_remaining_work(D):                # PARK guard
      enqueue(gate(D, severity=PARK)); notify_batched(gate)
      continue_independent_subtasks()
      return PARK
  # not independent → cannot safely continue → escalate as STOP
  checkpoint(unit); enqueue(gate(D, severity=STOP)); notify_now(gate)
  return STOP
```

**PARK guard (the one rule that keeps PARK honest):** PARK is permitted *only* when no continued sub-task reads, depends on, or would be invalidated by `D`'s outcome. If continuing could build work on top of an assumption the answer might overturn, `D` is a STOP, not a PARK. PARK refuses to *idle*; it never refuses to *ask*, and it never resolves `D`. This is what prevents PARK from becoming a back-door silent guess.

**Bias toward not-STOP, but never toward silent-resolve.** The blocking-gate (STOP) set is deliberately narrow and the default escalation is PARK — this is the counter to over-eager escalation (constant interruption). But narrowing STOP never widens DECIDE: a decision that meets the ASK bar is *always* escalated (PARK or STOP), never auto-resolved. The two failure modes are traded off independently.

**Anti-falsification — never make a gate pass by changing what it measures, or by changing the gate itself (APE S4b/F6, HIGHEST pilot finding).** A failing gate (a quality-bar check, a `verify_*` script, a constraint check) is resolved by exactly one of: (a) a *legitimate* fix to the underlying work — re-derive the data from its real sources; (b) a *genuine* correction to the gate's own logic **routed through escalation and authorized** — as the S4b price-band bug was (the unit STOPPED, Craig approved option A, the *orchestrator* then fixed `verify_content.py`); or (c) STOP + escalate. The autonomous loop **never** self-resolves by editing the data to satisfy the check (relabeling a product's tier, nudging a value into a passing band, dropping the failing field) **nor** by silently editing the check to accept the data. Either direction is falsification and is itself a `constraint-violation` STOP (§3.6). **This binds even when a passing label exists** — the S4b near-miss escalated *only* because a [price point] dead-zone left no passing tier (a structural forcing function, not discipline); the rule must not depend on that accident. Operationally injected into every real unit as rule 1 of the unit-conduct directive (`orchestrator/lib/runner.py` `UNIT_CONDUCT_DIRECTIVE`).

---

## 3. Blocking-gate taxonomy

Nine gate *types* — the categories of decision an unattended loop actually hits. Each maps to a default outcome; the conditional ones say what flips them. Every type carries a worked example (APE S1 acceptance criterion). Types §3.1–§3.8 fire at a per-unit decision point; §3.9 (`quality-trend`, added by `orchestrate-command` S2) is the one **arc-level** gate — raised at a batch boundary from a rolling metric across units, not at a single decision point.

### 3.1 `ambiguous-requirement` — the plan/spec under-determines the unit
- **Default:** STOP if the ambiguity blocks the unit's core output; PARK if it only affects an optional or late sub-task whose result nothing else consumes.

### 3.2 `high-blast-radius-write` — a write to a forbidden or out-of-scope path
- **Default:** STOP, always. Never DECIDE, never PARK. Covers any path outside the unit's declared `write_scope`, plus the standing forbidden set (skill source, framework-defining `aios` files, any `CLAUDE.md`/`MEMORY*.md`/`policies/`).
- **Enforcement note:** the FH Safety Layer `PreToolUse` guard *blocks* the write; this gate *routes* the blocked attempt to `notify()` instead of a hard die. Coexistence/precedence resolved in APE S3 (`orchestrator/orchestrator-protocol.md` §8): FH enforces in the unit session (deny/ask — the write never lands), the unit emits a `GUARD-BLOCKED:` marker rather than improvising, and the orchestrator raises this gate from that marker. deny **and** ask both route here (always STOP). **S5b (2026-07-01) closed the per-unit half:** the FH-owned `hooks/pre-tool-use-unit-scope.sh` now enforces the unit's declared `write_scope`/`forbidden_scope` at runtime too (pinned `APE_UNIT_*` env injected at launch from the frozen plan; `orchestrator/consumed-hooks.md` §1b) — so this gate's "any path outside the unit's `write_scope`" intent no longer depends on FH's global set alone.

### 3.3 `quality-bar-failure` — a deliverable fails its skill's quality gate
- **Default:** auto-retry once (a DECIDE-level reversible retry), then STOP if it still fails. The retry is logged; a second failure is a Completion-Gate STOP — the unit cannot be marked done.
- **The retry is a *legitimate regeneration*, never a data edit (anti-falsification, §2 / APE S4b F6).** The one permitted retry re-derives the failing output from its real sources. It may **not** edit the data the gate measures, nor the gate itself, to make the check pass — that is falsification, not a retry, and is a `constraint-violation` STOP (§3.6) regardless of whether the retry budget is spent.

### 3.4 `missing-input` — a required file, source, or credential is absent
- **Default:** PARK if other items in the unit can proceed without it; STOP if the whole unit needs it.

### 3.5 `compaction-risk` — the unit approaches the context budget before completion
- **Default:** STOP, always (NN#2 — never run through compaction). Checkpoint, stop the unit *before* compaction, escalate a re-plan (the unit was sized wrong).

### 3.6 `constraint-violation` — the next action would violate a non-negotiable or a corrections-log rule
- **Default:** STOP, always. The loop detects its planned next step contradicts an APE non-negotiable, a global primitive, or a skill/project corrections rule.

### 3.7 `reversible-low-stakes` — formatting, naming-within-convention, ordering
- **Default:** DECIDE. Logged, never escalated. This type exists to name the floor — so the loop doesn't escalate trivia (the over-eager failure mode).

### 3.8 `error` — a step fails irrecoverably after retries
- **Default:** STOP. A tool/step error that survives the runner's bounded retries halts the unit with a diagnostic; the loop never papers over an error by guessing.

### 3.9 `quality-trend` — the aggregate quality slope declines across a batch, before any single unit hard-fails
- **Default:** STOP, always. This is the **arc-level** counterpart to §3.3: `quality-bar-failure` catches a *hard* per-unit miss (a deliverable fails the 100 bar after one retry); `quality-trend` catches the *slope* — a **rising escalation rate** (the arc getting rougher: more ambiguity / missing-input / constraint gates per unit — an early warning that predicts a coming hard failure *while units still pass*) or a **rising quality-bar-failure rate** (hard failures accumulating across the batch, each individually waved through) over the last N units. It is the "stop before quality declines" control for a dozens-of-units arc, and it is raised at a **batch boundary**, not at a per-unit decision point. Added by `orchestrate-command` S2 (2026-07-01).
- **Signals (rolling, over the trailing window of N done units).** (a) **escalation rate** — gates raised per unit over the window (excluding `quality-trend` gates themselves); (b) **quality-bar-failure rate** — the §3.3 subset, per unit; (c) **gold-set divergence** — an *optional passthrough* input, active only when a producer exists (until then the metric runs on (a)+(b)). A breach is either an **absolute** ceiling reached (≥) **or** a **rise** vs. the prior equal-length window (the slope). *(Retry rate is a named future input — retry attempts are not yet logged in the ledger; deferred to `skills/orchestrate/ROADMAP.md`.)*
- **Thresholds are provisional.** Conservative starting values — **window = the batch size** (default 3, so every batch unit is evaluated at the boundary and the rise compares batch-to-prior-batch); escalation-rate ceiling 1.5/unit; quality-bar-failure ceiling 0.5/unit; rise Δ 0.5/unit; gold-divergence ceiling 0.15 (used only when a divergence value is supplied) — **tuned from the first Tier-1 supervised `[bounded-backlog project]` run**, not guessed (orchestrate ROADMAP). Fewer than a full window of done units evaluates on the partial sample (a conservative early STOP is intended, not a bug). In Tier 1 a false STOP is cheap; a missed decline is not.
- **Deterministic compute, model judgment.** At each boundary the orchestrator runs `runstate.py trend` (a read-only rolling computation over `RUN.json`) → rates + a `breach` flag + `reasons`. The engine only does the arithmetic against the passed thresholds; the *judgment* — is the decline real, what to do — stays with the model (the gate question + escalation-precision annotation), never the loop (§0; the boundary review leaves the precision column blank).
- **Arc-level, not unit-level.** The batch's units are already `done`, so a `quality-trend` gate is *raised* (for the queue, notify, and audit trail) but does **not** `block` a unit — it halts the *batch continuation*. It is **armed in both tiers**: even under Tier-2 auto-continue a breach re-inserts this STOP (SKILL.md Step 5).
- **Tightens, never loosens (NN#4).** The trend guard only ever *adds* a STOP; it can never clear or downgrade a §3.3 failure or relax the 100 bar, and its answer set never includes "accept the decline by lowering the bar."

**Anticipated vs. emergent gates.** A gate may be *pre-marked* in the execution plan (a known decision point the planner foresaw) or *emergent* (raised by the loop at runtime). Both classify through this same taxonomy and land in the same queue. Pre-marking buys nothing but a head start on the gate question; it never pre-authorizes an outcome.
