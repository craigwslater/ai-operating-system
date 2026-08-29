<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. This is a redacted EXCERPT, not the full policy. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The autonomy-eligibility policy—the fire-and-forget-vs-supervised gate that decides how much of a run proceeds without a human in the loop. Carries the three-tier model (Tier 0 never-autonomous / Tier 1 supervised / Tier 2 fire-and-forget), the five conditions that must all hold before a project earns Tier 2, and the graduation procedure between tiers.
> **Where this came from.** It was §9 of `policies/escalation.md` until 2026-07-23, when it was split into its own policy because `/orchestrate` reads it near-exclusively at pre-flight. It is published here as its own artifact for the same reason—see [`escalation.md`](escalation.md) in this same folder for the runtime decision-routing protocol it depends on. ⚠️ **Note on the cross-references below.** This file cites `escalation.md` §2, §3, §5 and §6. The published excerpt of that policy carries **§1–§3 only**, so the §5 and §6 pointers—including the §6 acceptance bar named in the Graduation procedure—resolve to sections that exist in the source but not in the artifact tier. They are left as the source wrote them rather than rewritten, per the source-fidelity direction rule.
> **What was omitted.** The "Current standings" section—the internal per-project autonomy status at a point in time. It is operational state, not protocol, and it names in-flight internal projects.
> **What was redacted.** **Nothing reaches this excerpt.** The registry masks two internal pipeline identifiers in the source (rows ape-001, ape-002), but both occurrences sit inside the "Current standings" section that the omission above removes, so the published text carries no substitution. No PII, active-target-company, or third-party-individual content appears in this file.
> **Why it's included.** This is the half of Case Study #5's autonomy claim that does the gating. The escalation protocol says what happens at a decision point; this says whether the loop was ever allowed to run unattended in the first place.

---

# Autonomy-Eligibility — fire-and-forget vs supervised (APE S5c)

**Status: built APE S5c (2026-07-01); split out of `policies/escalation.md` by `fable-os-review` B4 (2026-07-23).** This policy defines *when* an unattended execution arc may run fire-and-forget versus supervised. It is the eligibility gate that sits above the async escalation machinery: `policies/escalation.md` governs how a running loop routes each decision (DECIDE / PARK / STOP); this file governs whether that loop is allowed to run unattended at all.

**Split provenance (B4).** This was §9 of `policies/escalation.md`. It was moved to its own file because `/orchestrate` reads it almost exclusively at pre-flight — `skills/orchestrate/SKILL.md` and `lib/boundary.py` cite "§9" for the tier decision, while the rest of `escalation.md` (the gate taxonomy, queue schema, notify/resume machinery) is consumed at *runtime* by the runner and unit sessions, not at pre-flight. Keeping the two together forced every tier check to load ~9,800 cl100k to reach ~1,500. The split follows a real consumption seam (the split-vs-compact test in `policies/memory-architecture.md` §3.2). References below to `escalation.md §N` are cross-file pointers into that sibling policy.

---

**Framing: autonomy is earned per project type, never granted** (APE `CLAUDE.md` §3 Out-of-scope, §10). **Supervised is the default posture**; fire-and-forget is a graduation a project type reaches only after it has proven, *under supervision*, that the loop escalates every ASK-bar decision and that its writes are fully guard-enforceable. This section defines the eligibility gate, the three tiers, and the graduation procedure. It **consumes the F7 install boundary** (`escalation.md` §3.6): eligibility never pre-authorizes the loop to install anything — instead it requires the run environment be *pre-provisioned* so no unattended install is ever needed.

## The three tiers

| Tier | Posture | Who it covers |
|---|---|---|
| **Tier 0 — never autonomous** | The write is interactive-only; the orchestrator may *never* touch these paths, supervised or not. | `escalation.md` §3.2's standing forbidden set — skill source (`skills/**`), framework-defining `aios` files (any `CLAUDE.md` / `MEMORY*.md` / `policies/**`) — **extended** with the concurrency machinery (the single-writer registry, `INDEX.md`, the seal/drift-guard model; owned by `concurrent-session-execution`). Changes here are made by Craig in an ordinary interactive session — never through the loop (APE `CLAUDE.md` §10). |
| **Tier 1 — supervised** (default) | The orchestrator runs the arc, but Craig **observes the live run** (NN#6): watching for missed / over-eager escalations and out-of-scope writes. | Every not-yet-graduated project type. The S4b pilot is Tier 1. |
| **Tier 2 — fire-and-forget eligible** | The orchestrator runs unattended; Craig receives only STOP pings. | A project type that has passed the graduation gate below. |

## The eligibility gate (all five must hold for Tier 2)

A project type is fire-and-forget-eligible only when **every** condition holds. Any miss → Tier 1 (supervised).

1. **Isolated, low-blast write scope.** Every unit's `write_scope` is an isolated `outputs/**`-style path with **zero** overlap with the Tier-0 forbidden set, and is **fully enforceable by the S5b per-unit scope guard + FH global set**. No unit needs a **Bash-redirection write** — the layer-wide bypass every `PreToolUse Write|Edit` guard is blind to (`hooks/ROADMAP.md`; behaviorally covered only by UNIT_CONDUCT rule 2). A scope that requires shell-redirected writes is **not** Tier-2-eligible, because the guard cannot see them.
2. **A clean supervised precedent.** The same project type has completed **≥1 Tier-1 supervised run on the current (S5-hardened) spine** with **zero un-flagged high-blast-radius decisions** and acceptable escalation precision/recall (the `escalation.md` §6 S4 acceptance bar). One clean run of the *type*, not of every unit.
3. **Deterministic gate surface.** The plan's decision points are pre-markable with frozen `options[]` (M2), **or** the supervised precedent showed a low *emergent*-gate rate. A project whose every unit raises novel, judgment-heavy gates stays Tier 1 — fire-and-forget there would just ping constantly (no better than manual).
4. **Pre-provisioned environment (consumes F7).** Every tool/dependency the arc needs is installed **before** launch. Because the loop may never install unattended (`escalation.md` §3.6 / F7), a Tier-2 arc must need no mid-run install; a dependency discovered missing mid-run is still a **STOP** (never an autonomous install), which by definition breaks fire-and-forget for that run. Eligibility therefore includes a **pre-launch dependency check** (runbook pre-flight). *Install "pre-authorization" is not a grant to the loop — it is a pre-provisioning requirement on the operator.*
5. **Verified notify + answer path.** The notify channel (push) **and** the answer channel (Remote Control / queue-file) are confirmed reachable for this run (`escalation.md` §5–§6), so a STOP actually reaches Craig and his answer actually returns. A fire-and-forget run with an unverified notify path is a **silent-stall** risk → stays supervised.

The gate is **re-checked per run** at launch (conditions 4 and 5 especially can regress between runs) — graduation is a standing property of the *type*, but each launch still re-verifies the environment and channels.

## Graduation procedure

1. Run the project type **supervised** (Tier 1) to the `escalation.md` §6 S4 acceptance bar; log escalation precision/recall + every out-of-scope write attempt (the runbook watch-list).
2. If that run passed clean **and** all five conditions above hold → record the grant in the *project's* `CONTEXT.md` — `autonomy: Tier 2 (granted <date>; precedent <run_id>; scope-shape <hash/paths>)` — and the project may launch fire-and-forget thereafter.
3. **Graduation is per project type + scope shape, not global.** A materially different scope (new write paths, a new skill, a new gate surface) **re-enters Tier 1** — the precedent does not transfer.
4. **Regression demotion.** Any fire-and-forget run that produces an un-flagged high-blast-radius decision, or any anti-falsification breach (`escalation.md` §2), **demotes the type to Tier 1** pending a fresh clean supervised run.
