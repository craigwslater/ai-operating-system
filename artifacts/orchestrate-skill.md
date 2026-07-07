<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The `orchestrate` skill's SKILL.md—the operator command that runs a frozen autonomous-execution plan end-to-end in quality-disciplined batches. It *wraps* the closed autonomous-execution engine and never rebuilds it. Defines the runbook pre-flight, the plan freeze/validate, batch execution with a mandatory orchestrator restart at every boundary, the decision-focused boundary review, and the Tier-1-manual / Tier-2-auto-continue gate.
> **What was redacted.** Minimal. The pre-launch e-commerce venture's internal project name for its bounded data backlog—the skill's first-use target and its batch-size tuning example—is genericized to "a bounded, low-blast data backlog" (`inputs/redaction-registry.md` Category 6; `sanity-grep-entities.md` Category D). Framework file names and CLI paths are kept, since they carry no sensitive content and let a reader trace the wrapper against the engine it consumes. No PII, active-target-company, or third-party-individual content appears in this file.
> **Why it's included.** Backs Case Study #5's claim that autonomous execution is operated through a disciplined, human-gated command rather than a fire-and-hope loop: the batch cadence, the mandatory restart that closes the orchestrator's own context ceiling, and the quality-trend stop armed in both tiers are all here in the skill's own words.

*Where to read first.* **Peer PMs**—"The one rule that governs everything" (consume, never rebuild) and Steps 3–6 (the batch loop, the boundary review, the tier gate, the restart). **Recruiters**—[Case Study #5](../case-studies/05-autonomous-execution.md) is the lighter read on the same content.

---

---
name: orchestrate
description: Run a frozen APE execution plan (PLAN.json) end-to-end in quality-disciplined BATCHES — the operator command that wraps the CLOSED autonomous-project-execution engine and never reimplements it. Runs the RUNBOOK pre-flight, freezes/validates the plan, executes the unit queue in batches with a mandatory orchestrator restart at every boundary (closes the warm-session context ceiling), renders a decision-focused boundary review, and gates manual-in-Tier-1 / auto-continue-in-Tier-2. Invoke when Craig types /orchestrate <project>, says "orchestrate the [project] backlog" / "run [project] end-to-end" / "batch-run the units for [project]", or wants to run a bounded data backlog unattended with a stop-before-quality-declines cadence. Wraps orchestrator/lib CLIs + orchestrator-protocol.md §2; does NOT rebuild them, grant Tier 2, or run concurrent arcs.
---

# /orchestrate — Batch-Disciplined Autonomous Execution

The operator command for running a planned multi-session project end-to-end, unattended, with **consistent quality across dozens of units** and a **"stop before quality declines"** checkpoint cadence. It **wraps the closed autonomous-project-execution (APE) orchestrator engine** — the sequential-autonomy spine (protocol + `lib/` CLIs + escalation policy + guardrail hooks) — and adds the **batch discipline** the engine deliberately left to an operator layer.

Lineage: **APE (engine, closed) → `/orchestrate` (this operator layer) → `concurrent-session-execution` (concurrency, later)**. This command is the sequential operator command; concurrency builds on top of it.

---

## The one rule that governs everything — NN#1

**Consume the engine; never rebuild it.** This command *orchestrates* existing CLIs and the existing control protocol; it never reimplements plan / queue / run-state / dispatch / gate logic. Two facts make the boundary precise:

- The engine is **strictly per-unit** — `orchestrator-protocol.md` §2 runs one unit per cycle; `plan.py next-runnable` returns one id at a time. There is **no "batch" concept anywhere in `lib/*.py`**. So "batch" is legitimately **this wrapper's own control flow** over the per-unit queue — it cannot duplicate engine logic because the engine has none to duplicate. But adding plan/queue/state *fields or schemas*, or re-deriving `next-runnable`/`mark-done`/`resolve-gate`, **would** be a violation.
- The **only code this command ships is `lib/boundary.py`** — a **read-only** helper that gets every *state* fact from the engine CLIs and adds only (a) batch arithmetic, (b) the review render (facts; the model supplies the precision judgment), (c) the autonomy-tier read (no engine equivalent). It never mutates state and never dispatches a unit.

Any engine bug routes back to the APE artifacts — never a fork.

**Paths** (all commands below assume these):
```
ROOT=~/.claude-local
ENGINE=$ROOT/projects/autonomous-project-execution/orchestrator
ORCH=$ROOT/skills/orchestrate
```

---

## Prerequisites

1. The APE engine present at `$ENGINE/` (it is — closed 2026-07-01).
2. A frozen (or freezable) `PLAN.json` for `<project>`, authored to `execution-plan-format.md`. If only a prose plan / `PLAN.yaml` exists, compile it to `PLAN.json` **with Craig** first (the model parses the YAML; the runtime has no YAML dep).

---

## Step 0 — Resolve + confirm the engine

Confirm `$ENGINE/lib/plan.py` exists. If the engine tree is missing, STOP and tell Craig — this command has nothing to wrap without it.

## Step 1 — Pre-flight (RUNBOOK §1 — run EVERY launch)

Re-checked per run (`escalation.md` §9.2 conditions 4–5 can regress). Each step maps to an exact action:

1. **Pick the tier.** `python3 $ORCH/lib/boundary.py tier --project $ROOT/projects/<project>` → `{tier, gate_mode, grant}`. Cross-read `escalation.md` §9. A **new project type or new scope shape → Tier 1 (supervised)** regardless of any stale grant; only a type with a *current, recorded* `autonomy: Tier 2` grant runs fire-and-forget. *(As of 2026-07-01 nothing is Tier 2 yet.)*
2. **Guard modes.** The **operator/orchestrator** sets these **inline per `claude -p`** (the FH hooks read them from the *unit subprocess* env; shell `export` does not persist across Bash calls — RUNBOOK §1.2/§9/§11):
   `GUARD_PATHS_MODE=block STOP_VERIFY_MODE=block UNIT_SCOPE_MODE=block claude -p …`. These are **separate from** `runner.py build-cmd --guard-directive`, which emits the *unit scope* env (`APE_UNIT_*`) + the two directives — **not** the `*_MODE` vars. The two env sets compose on the same launch; set the modes even though Claude Code already defaults them to `block`, so a stray env can't flip them (RUNBOOK §1.2).
3. **Surface + notify.** `python3 $ENGINE/lib/surface.py detect` (expect `local`). Confirm **Remote Control connected** + `/config` push **on**, or STOP pings are desktop-only (a silent-stall risk → keep the run supervised).
4. **Dependency pre-provision (§9.2 cond. 4).** Confirm every tool the arc needs is already installed. The loop **never** installs unattended — a missing dep mid-run is a STOP. This is a **manual** operator check.
5. **Smoke both spines.** `bash $ENGINE/tests/smoke.sh` (expect `ALL SMOKE TESTS PASSED`) **and** `bash $ORCH/tests/smoke.sh` (expect `ALL ORCHESTRATE SMOKE TESTS PASSED`) — guards the engine contract *and* the wrapper's composition of it before a real run.

## Step 2 — Freeze + validate the plan (RUNBOOK §2.1–2.2)

1. `python3 $ENGINE/lib/plan.py validate --plan <PLAN.json>` — **must pass** (freeze gate; refuses an empty resolved `write_scope` and any `:` in a scope glob).
2. **Craig signs off.** The plan is now frozen — the loop never rewrites it (the only in-contract re-plan is a `compaction-risk` STOP, which splits + re-freezes).
3. `python3 $ENGINE/lib/runstate.py init --plan <PLAN.json> --out <RUN.json>` — every unit `queued`, run `running`.
4. **Set the batch size** (`--batch-size N`, default **3** — provisional, see *Batch size* below) and record **`batch_start_index` = current done count** (0 at a fresh start).

## Step 3 — Run one batch (drive protocol §2 for ≤ `batch_size` units)

Start (or, after a restart, re-enter) the **orchestrator session** and instruct it to run **`orchestrator-protocol.md` §2** against `PLAN.json` + `RUN.json`, kept warm with `ScheduleWakeup`. The loop's per-cycle work — **A** ingest answers → **B** pick work (`next-runnable`) → **C** run the unit (`build-cmd --guard-directive` → backgrounded `claude -p` → `set-session` → `mark-done`) → **D** complete — is the engine's, unchanged. **Do not reimplement it.**

The wrapper adds one stop the engine lacks: **after each `unit-done`, check the batch boundary.**
```
python3 $ORCH/lib/boundary.py boundary-check --run <RUN.json> --plan <PLAN.json> \
        --batch-size N --batch-start-index K
```
- `boundary_reached: false` → keep running the §2 loop (next unit).
- `boundary_reached: true` → go to **Step 4**. `boundary_reason` is one of `batch-size-reached` / `arc-complete` / `idle-no-work`.

A **STOP gate mid-batch** (a genuine ASK-bar decision) is handled by the engine's escalation path (RUNBOOK §4: `queue.py` + `runstate.py resolve-gate`) — that is orthogonal to and independent of the batch boundary.

## Step 4 — Boundary review (render the decision view)

```
python3 $ORCH/lib/boundary.py review --run <RUN.json> --queue <escalation-queue.jsonl> \
        --batch-start-index K --batch-size N [--gold-diff <path>]
```
Pass the **same `--batch-size N`** as the run so the quality-trend window covers the whole batch (§4) — otherwise a batch larger than the trend default would leave its early units un-evaluated.
Renders: the engine's `render-md` run-state, per-unit completion/verifier status, the escalation log, **the rolling quality-trend metric (§4 — escalation + quality-bar-failure slope, from the engine's read-only `runstate.py trend`)**, and the gold-set diff. **The render is FACTS.** *You* (the orchestrator model) then annotate the escalation-log **precision** column — **warranted / missed / over-eager** — and flag any `verified:false`, out-of-scope write attempt, gold-set divergence, or **quality-trend breach**. That judgment never leaves the model (the engine's core rule — `orchestrator-protocol.md` §0), so the helper computes the arithmetic but leaves the precision column — and the decision to STOP on a trend breach — to you.

## Step 5 — Quality-trend guard (both tiers) → boundary gate (Tier 1 manual · Tier 2 auto-continue)

**First — the quality-trend STOP, armed in BOTH tiers (§3.9).** The review's §4 renders the engine's rolling `trend` metric. On a **breach**, raise a `quality-trend` STOP *before* the tier gate:
```
python3 $ENGINE/lib/runstate.py raise-gate --run <RUN.json> --gate-id <gid> \
        --unit <last-done-unit> --type quality-trend --severity STOP \
        --resume-token "<last-done-unit>@boundary:apply-gate-<gid>"
```
Then `notify.py render` + `PushNotification` the breach + reasons and **wait** for a *specific* answer (inspect source data / smaller batch / halt). **Do not `block` a unit** — the batch's units are already `done`; a `quality-trend` gate halts the *next batch*, not a unit (escalation §3.9). This fires **even under Tier-2 auto-continue** — it is the safety net that makes fire-and-forget trustworthy. No breach → fall through to the tier gate below.

- **`gate_mode: manual` (Tier 1 — supervised):** the boundary is a **STOP** regardless. Render the notify one-liner (`notify.py render`), `PushNotification` the review summary to Craig, and **wait**. He replies with a **specific** instruction (continue / adjust batch size / halt). **NN#2: never auto-continue in Tier 1** — "proceed"/"continue" resumes the protocol but a batch-continue is an explicit operator decision.
- **`gate_mode: auto-continue` (Tier 2 — fire-and-forget):** continue **without** waiting — but the restart (Step 6) still happens, and the **quality-trend STOP guard above stays armed** even here, re-inserting a STOP on early decline.
- `arc_complete: true` → go to **Step 7**.

## Step 6 — Restart the orchestrator (mandatory — this command's NN#3)

At **every** boundary, in **both** tiers: **end the current orchestrator session and start a fresh one** pointed at the same `PLAN.json` + `RUN.json` (stateless restart — RUNBOOK §6; the run is designed to be stateless-restartable from `RUN.json` + the append-only queue). This closes the orchestrator's **own warm-session context growth** ("Ceiling 2", unguarded by the engine — the `budget-pre-compaction` stop protects the *unit* subprocess, not the orchestrator session) **by construction** — the command never runs one unbounded warm session across a dozens-of-units arc.

The fresh session re-enters §2 step A (idempotent answer ingest — repeat answers on a resolved gate are no-ops). **Update `batch_start_index` = current done count**, then loop to **Step 3**.

## Step 7 — Completion & close

- `arc_complete` → the engine renders the final `RUN.md` (`runstate.py render-md`) and pushes "run complete".
- **Log the run's escalations** (warranted / missed / over-eager) + every out-of-scope write attempt — this is the **graduation evidence** a Tier-1 run needs to earn Tier 2 for the type (`escalation.md` §9.3). If it earned one, record `autonomy: Tier 2 (granted <date>; precedent <run_id>; scope-shape <…>)` in the project's `CONTEXT.md` — but **granting Tier 2 is Craig's call**, outside this command.
- Session bookkeeping (`CONTEXT.md` / `log.md` / registry) is Craig's interactive **`/end-session`**, not the loop's — units are forbidden from parent-mutation (UNIT-CONDUCT rule 2).

---

## Batch size

Default **3** — conservative and **provisional**. It is **not** locked: tune it from the first **Tier-1 supervised** run's real per-unit wall-clock + review cadence (skill ROADMAP), not a guess. `RUNBOOK.md` §8 (units ≈ 60–90 min each) informs the starting guess. Override: `/orchestrate <project> --batch-size N`. "Dozens-of-units reliability" is **untested** — the APE pilot ran **2 units**; the first real batch stays Tier-1 supervised and its evidence sets the thresholds.

## Non-Negotiables (this command)

1. **Consume the engine, never rebuild it.** Only `lib/boundary.py` ships, and it is read-only. The verifier confirmed no engine logic is duplicated.
2. **Batch boundary = a mandatory checkpoint in Tier 1.** Auto-continue is unlocked *only* by a recorded Tier-2 grant; even then the quality-trend STOP guard (§3.9) stays armed.
3. **Orchestrator restart at every boundary** (both tiers) — Ceiling 2 closed by construction.
4. **The quality bar is inherited and inviolable.** Per-unit verifier at 100; anti-falsification (`escalation.md` §2 — never edit the data or the gate to force a pass); read-back on every write. The wrapper **tightens, never loosens**.
5. **All global + APE primitives hold** — Scope Sizing (one non-compacting unit), the async escalation model, no-parent-mutation, no-unattended-install.

## Source of truth

- **Engine (consumed, do not fork):** `$ENGINE/orchestrator-protocol.md` §2, `$ENGINE/RUNBOOK.md`, `$ENGINE/consumed-hooks.md`, `$ENGINE/lib/`, `policies/escalation.md` (§9 tiers), `projects/autonomous-project-execution/{execution-plan-format.md,run-state-ledger-schema.md}`.
- **This command:** `skills/orchestrate/SKILL.md` (this file) · `lib/boundary.py` (read-only helper) · `tests/smoke.sh` (dry composition test).
- **Follow-ups:** `skills/orchestrate/ROADMAP.md`.
- **First-use target:** the first bounded, low-blast data backlog (Tier-1 supervised batch).

## What this command does NOT do

- **Concurrency** — multiple arcs at once (→ `concurrent-session-execution`).
- **Cloud surface binding** — routines / fire-once (→ ROADMAP).
- **Rebuild the APE engine.**
- **Grant Tier 2 autonomy** — earned from a clean supervised run; Craig's call.
