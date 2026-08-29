<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The skill-ROADMAP.md lifecycle protocol—the canonical inventory mechanism for outstanding follow-ups, planned improvements, and historical work on each custom skill. Defines `Open Considerations` → `Completed` lifecycle states; specifies the `Candidate Bundles` pre-grouping for next-improvement-project scoping.
> **What was redacted.** One active-target-company name (referenced in a worked example) substituted to `[REDACTED COMPANY]` per registry entry tgt-068. Nothing else—the rest of the registry sweep produced zero substitutions.
> **Why it's included.** Backs the case-study claim that ROADMAP-driven improvement is a documented discipline and the "rules added per month" metric: the per-skill ROADMAP.md instances it governs are linked from the case-study tier.

---

# Skill ROADMAP.md Policy

Defines the canonical structure, lifecycle, and integration rules for `skills/[name]/ROADMAP.md` — the per-skill follow-up inventory required by CLAUDE.md "Ongoing Structure Discipline" item 7.

---

## 1. Purpose

Every Claude-local skill accumulates follow-up items over its lifetime: deferred improvements from project sessions, gaps surfaced in evals, post-delivery cleanups, monitor-then-codify patterns awaiting recurrence, design questions awaiting Craig disposition. Without a canonical inventory, these items scatter across project CONTEXT.mds, eval files, corrections-logs, and conversation memory — making it impossible to plan a new improvement project without a fresh discovery sweep across the workspace.

ROADMAP.md exists to be that canonical inventory. Its purpose is operational, not narrative: when Craig wants to start a v5 (or a one-off improvement micro-project), reading ROADMAP.md should answer "what's still outstanding for this skill?" without requiring re-derivation.

---

## 2. File location and naming

- **Path:** `~/aios/skills/[skill-name]/ROADMAP.md`
- **Naming:** literal `ROADMAP.md` (uppercase, no version suffix). One per skill.
- **Required:** every skill in `skills/` has one. The audit skill detects missing ROADMAP.md as drift.

If a skill genuinely has no follow-ups (newly created, all items shipped clean), the file still exists with empty Open Considerations + empty Candidate Bundles + Completed entries (or just the historical record). An empty section is a stronger signal than a missing file because it says "considered, none open" vs. "we forgot to track this."

---

## 3. Required sections

Use `templates/skill-ROADMAP.md.template` as the starting point. Required structure:

### Section 1: File header

A 2-3 paragraph preamble explaining (a) the file's purpose, (b) the lifecycle integration with CONTEXT.mds and improvement projects, (c) the section list. Copy verbatim from template; substitute the skill name. The preamble exists so any reader (Craig or a fresh Claude session) can orient without external context.

### Section 2: Open Considerations

Actively-tracked follow-up items, one per `### ` heading. Required schema per entry:

- **Heading** (`### `): describes the issue, not the fix. Example good: `### Verifier-output fabrication discipline — 3-of-3 recurrence`. Example bad: `### Add anti-fabrication preamble to verifier prompt` (this is the fix; the issue is the recurrence).
- **`**Status:**` line:** one of `Open` / `Open — pending Craig disposition` / `Open — monitor; codify on recurrence` / `Implementation shipped [project/session]` / `Standing deferral — activates when [criterion]`. If resolved, mark heading with strike-through + `✅ RESOLVED` and update Status to `Resolved — shipped YYYY-MM-DD ([context])` (do not delete the entry until next improvement project closes; preserves provenance for the time period before the resolution propagated to Completed).
- **`**Source:**` line:** name the eval (`Eval N (Company name, Session NN, YYYY-MM-DD)`), session retrospective, coach feedback, or live observation that surfaced the item. Multi-source items (recurrence across N evals) list all sources.
- **`**Severity:**` line:** Low / Medium / High; or escalation arrow if changing (`Low → Medium pending recurrence`, `Medium → High pending Craig disposition`). Standing deferrals may omit severity.
- **`**Trigger fired:**` field (optional):** populate when implementation has been proven out (in-session scaffolding, working file, completed earlier session) and the entry is ready for `/codify-trigger` source-file promotion. Document source-file paths + insertion points + layer descriptions + architecture decisions + cross-references to working files. This is the canonical ground truth that `/codify-trigger` parses to either verify-shipped or propose-then-write. Omit until the trigger has actually fired — empty trigger field = entry not yet ready for codification. Pattern proven by the v5 → v2 cross-project handoff documented in `projects/claude-local-frontier-v2/CLAUDE.md` §6 Session 2.
- **Body** (1-3 paragraphs): describe the issue, the failure mode, why it matters. Include verbatim quotes when judgment is involved (e.g., the prose pattern that triggered the entry).
- **Decision/scope/risk fields** (any of, as relevant): `**Decision needed:**`, `**Recommended approach:**`, `**Possible approaches:**`, `**Diagnostic:**`, `**Three enforcement-mechanism candidates:**`, `**Decision threshold:**`, `**Estimated scope:**`, `**Risk if not codified:**`. Use the framing that fits the item.

### Section 3: Candidate Bundles for Next Improvement Project

Clusters of Open Considerations grouped by theme. Each bundle has:

- **Heading** (`### Bundle [A] — [Theme]`): single line, theme-named.
- **`**Priority:**` line:** highest-priority item in the bundle, or cluster-specific reasoning if items reinforce each other.
- **`**Items:**` list:** each Open Consideration in the bundle, with severity + 1-line summary of why it's in this bundle.
- **`**Rationale:**` paragraph:** why these items belong together. Shared file? Shared verification approach? Sequencing dependency? Avoiding rule fragmentation? This is the planning hint.
- **`**Estimated scope:**` line:** total minutes/hours, with per-item breakdown.
- **`**Decision required before kickoff:**` line:** any Craig disposition, or "None" if all items are objectively-actionable.
- **`**Prerequisites:**` line:** external dependencies (eval-archive sweep, cleanliness verification, etc.).

Bundles are non-prescriptive — a project plan can pick whole bundles, mix items, or scope a single item. The bundles exist to make the planning step faster.

### Section 4: Standing Deferrals (subsection of Candidate Bundles)

Items with explicit activation criteria. Not bundled until activated. They remain in the Open Considerations list above for full visibility but are not bundle candidates unless activated.

Format: bulleted list with item name + activation criterion + estimated scope. Brief.

### Section 5: Completed

Append-only audit trail. Each entry: date heading + 1-3 paragraphs documenting what shipped + source files touched + verification result. Cross-reference the Open Consideration it closes (if any).

**Do not retroactively modify Completed entries.** If a fix needs revision, add a new entry.

---

## 4. Lifecycle integration

### When items get added to ROADMAP.md

A new entry lands in Open Considerations whenever a follow-up surfaces and won't ship in the current session:

- **From an eval:** if an eval file has an "Open Follow-Up" section with items not addressed in the eval's resolution, those items should land in ROADMAP.md before the eval is considered closed.
- **From a live application post-delivery review:** Craig flags an issue or a discipline gap in the delivered artifact; if it doesn't ship same-session, it goes to ROADMAP.
- **From a project session retrospective:** items deferred at session end go to the project's CONTEXT.md "Open follow-ups" line AND to ROADMAP.md (CONTEXT.md is the active-project handoff; ROADMAP.md is the canonical skill inventory).
- **From a session-end audit:** the Commitment-Verification Audit (per `policies/commitment-verification-audit.md`) may surface unfinished work or scope expansions; those land in ROADMAP if they don't ship.

### When items get moved to Completed

When the underlying work ships:

1. Append a new entry to `## Completed` with date + work-shipped description + source files + verification result.
2. Update the Open Considerations entry: replace `### [heading]` with `### ~~[heading]~~ ✅ RESOLVED` (strike-through + checkmark, matching the existing pattern), update `**Status:**` to `Resolved — shipped YYYY-MM-DD ([context])`, and shorten the body to 1-2 sentences pointing to the Completed entry.
2.5. **Retire the trigger field's live token: rename `**Trigger fired:**` → `**Trigger fired (resolved):**`.** **Two field forms exist in the wild and both must be renamed** — the colon form `**Trigger fired:**` and the em-dash form `**Trigger fired — <date> (<context>)**` (the live residue found at `skills/audit/ROADMAP.md:135` on 2026-07-29 was the em-dash one, which a colon-only grep misses entirely). Match `**Trigger fired` followed by either `:**` or ` — `, and rename to `**Trigger fired (resolved)` keeping whatever punctuation followed. Keep the field's content **verbatim** — it is audit-trail value and `/codify-trigger` preserves it deliberately. Only the label changes, and only so that a sweep on the live token stops matching a dead entry. Without this, the field outlives resolution forever and every future `/end-session` Step 7.5 re-triages the same closed entries — against a step whose instruction is *"do NOT close the session"* until each hit is dispositioned. A soft gate whose signal is permanently noisy gets ignored, which is the F-27 precision lesson applied to a protocol step rather than a detector. (Pairs with the `Closes:` convention below: both make a lifecycle state greppable rather than inferred.) Enforcement point is the lifecycle move itself — `/codify-trigger` Step 5, which already owns it; `/end-session` Step 7.5 additionally skips `✅ RESOLVED` entries as a backstop for entries flipped before this convention existed.
3. **Do not delete the Open Considerations entry** in the same session as the resolution. Carrying the resolved entry through the next session lets future readers see the resolution timeline without grep-spelunking. The entry can be deleted in the next improvement project's pruning pass.

The cross-section drift caught at 2026-05-05 (Item 6 em-dash item shipped to Completed but Open entry was not closed) is the failure mode this discipline prevents — and the audit skill's Step 6 "ROADMAP drift" detector catches it continuously.

### The write-back obligation — flip the entry or write a `Closes:` line

**The origin record is part of the deliverable.** Any session that ships something answering an Open Considerations entry — in *any* skill's ROADMAP, not just the one the session is nominally about — **must** do one of two things before it seals:

1. **Flip the entry in the same session** — strike-through + `✅ RESOLVED`, Status rewritten, body shortened to point at the new Completed entry (the mechanic above); **or**
2. **Write a `Closes:` line into the session's log seal** naming the entry verbatim, when the flip genuinely belongs to a later pass (e.g. the shipping session lacked write access to that skill, or the resolution is partial and needs measurement first).

Shipping the fix and leaving the entry Open is not an acceptable third option. This is the **write-back** half of the correction lifecycle, and it is the half that historically failed: write-*forward* (correction → source file) is strong and mechanically nudged, while write-*back* (resolution → origin record) had no owner, no detector, and no protocol step. The evidence behind the rule (`fable-os-review` R-04 / F-23, HIGH, 7+ instances across 3 layers): `end-session/ROADMAP.md` carried three shipped features as Open for weeks; `hooks/ROADMAP.md` had an item stale from birth; `job-materials/ROADMAP.md` accumulated 26 resolved stubs before its 2026-05-25 prune; `catalog-v3` carried one Open item from S1 to S12 into close.

**Why a `Closes:` line and not just prose.** It is a fixed, greppable token. A future sweep can enumerate every claimed closure (`grep -rn 'Closes:' projects/*/log.md`) and check each against its ROADMAP — which prose narration does not permit. Detector-side enforcement (consuming `Closes:` lines and diffing them against ROADMAP state) is specced for `fable-os-review` Batch 6 / R-08; until it ships, this is a prose obligation carried by the `/end-session` corrections step.

### Write-sideways — a categorical fix requires a same-session sibling sweep

A **categorical** change — a rule rename, a count, a path form, a budget number, a threshold, a file that moved — is almost never single-site. The same fact is typically restated in a policy, a SKILL step, a detector's threshold, a template, and one or more ROADMAP entries. Fixing the instance you happened to be looking at, and leaving the siblings, converts one stale fact into a contradiction — which is strictly worse, because now two files disagree and neither is obviously wrong.

**The rule:** when a fix is categorical, run a `grep` sweep for sibling and consumer sites **in the same session**, and **record the sweep command plus its hit list in the session's log entry.** The recorded command is what makes the sweep auditable and re-runnable; "I checked" is not.

Recording the hit list matters even when it is empty — a nil result is a finding. Worked example (this policy's own shipping session, 2026-07-24): flipping the session-date convention from UTC to local ran `grep -rn "UTC" policies/ skills/*/SKILL.md templates/ hooks/*.sh docs/ CLAUDE.md` and returned **exactly one** live site, disproving the origin entry's predicted mirrors in three other files. Without the recorded sweep, the next reader would have had to re-derive that the mirrors do not exist. Two machine timestamps were identified in the same sweep as deliberate exceptions and annotated inline so they would not be "fixed" later — an exception named at sweep time costs one sentence; an exception rediscovered later costs a session.

### Route work into what the executor actually loads

When routing work to a future session that loads a **bounded slice** of a contract or plan (e.g. "load this file's target batch section only"), the routed item must be written **into that slice** — a routing note recorded anywhere else is unreachable by the executor's own loading rule, and the item silently dies. Lived case (`fable-os-review` S5, 2026-07-25): the A-pass routed five items via a Kill-list-tail note; all five went unexecuted across four subsequent batches with zero log mentions, because no batch section ever contained them. Amendments written into the target sections themselves (same A-pass, same contract) all shipped.

### When items get bundled

Bundle assignment is updated:

- Whenever a new Open Consideration is added: assign to a bundle if it fits, or create a new bundle if it doesn't.
- Whenever an Open Consideration is resolved: remove from its bundle (or mark resolved-in-place if the bundle preserves it for context).
- At the start of any improvement project: refactor bundles based on what's actually being scoped. The bundles are a planning aid; they should evolve with the planning, not constrain it.

#### Re-measure what the bundle claims to have confirmed (added 2026-08-18, Craig's call at the `job-search-continued` S17 seal)

**A bundling pass may not carry a filed figure forward and describe it as verified.** Any count, size, locus list, or effort estimate a bundle entry states — and *especially* one it labels "confirmed," "measured," or "live" — must be **re-measured at bundling time**, with the command that produced it recorded next to it. A figure inherited from the entry being bundled is stated as inherited: *"filed at N (S-whatever, not re-measured)."*

**Why this is a rule and not a nicety.** Bundling reads like clerical work — grouping entries someone else already investigated — so it is exactly where an unverified number acquires authority it never earned. The lived case: a `job-materials` entry filed at S10 named four files hardcoding a `/tmp` path. The S16 bundling pass copied that number into Bundle P's table **and added the words "Confirmed live at"** with four line-precise loci. At S17 the live count was **62 across three placeholders and ten files** — a sample had become a census, and two of the three placeholders had never been filed at all. The same pass estimated the unit at "~60–90 min, mechanical"; the actual work required building a reservoir-JSON schema addition and a detector branch, because the mechanical enforcement the estimate assumed **did not exist**. Both errors were invisible until execution, and both were introduced by the step that was supposed to be summarizing.

**The scope estimate is a claim too.** An estimate copied from a filing pass describes the work *as understood when filed*. Before a bundle asserts a duration, confirm the enforcement surface the fix depends on actually exists — a rule with no detector, a detector with no input field, or a reservoir with missing entries turns a "mechanical" item into a build.

**Cheap discharge.** This costs one `grep -rn` and one glance at the consuming code per claim. Record the command in the bundle entry so the next reader re-runs it instead of re-deriving it, and so a nil result is legible as a measurement rather than an omission.

### When the file gets pruned

At the start of any improvement project (e.g., v5 kickoff), do a pruning pass:

- Move all `✅ RESOLVED` Open Considerations entries to Completed (consolidate if they're already there).
- Refactor bundles to reflect current state.
- Verify Standing Deferrals' activation criteria still hold.
- Re-read the Completed section's most-recent entries to spot anything carried as Open that's actually done.

---

## 5. Authority hierarchy: ROADMAP.md vs. CONTEXT.md vs. CLAUDE.md (project)

When information about skill follow-ups appears in multiple files, this hierarchy resolves conflicts:

1. **`skills/[name]/ROADMAP.md`** — canonical for the skill's open follow-ups. If anything else disagrees, ROADMAP wins and the other file gets updated.
2. **`projects/[name]/CONTEXT.md`** — handoff document for the active project. May summarize the highest-priority items from ROADMAP in prose for at-a-glance project status. The CONTEXT.md "Open follow-ups" line should always either (a) point to ROADMAP.md, or (b) summarize a small subset for handoff visibility — never duplicate the full inventory.
3. **`projects/[name]/CLAUDE.md`** — binding plan for the project. References ROADMAP.md when scoping follow-ups but does not own the inventory.

The asymmetry exists because skills outlive projects. Project CONTEXT.mds get archived when the project closes; the skill keeps producing follow-ups. ROADMAP.md is the only file that carries the full history forward.

### 5.1 Thin-wrapper convention: skill = trigger + driver + pointer; policy = the protocol body

Where a `SKILL.md` step drives a protocol that a `policies/*.md` file also defines, the two must not both carry the full body — the lockstep-edit cost is lived (a `start-session` Step 4.5 change once had to ship to three copies). The convention: **the skill keeps the trigger condition, the interactive driver logic, and a pointer** ("canonical protocol: `policies/…` — read it when this step fires"); **the policy keeps the protocol body.** The policy is authoritative when the two disagree. Worked example: `skills/start-session/SKILL.md` Step 4.5 was thinned to a 6-line tier index + pointer against `policies/session-start.md` Step 4.5 (`fable-os-review` R-07 / B4, 2026-07-23). Apply this only where the duplication is real and thick — measure the effect before thinning every wrapper (deliberately incremental).

---

## 6. Cross-skill consistency

When a follow-up could affect multiple skills (rare but possible — e.g., a global rule that interacts with two skills' verifiers), each affected skill's ROADMAP.md gets its own entry, with a `**Cross-references:**` field pointing to the sibling entries. Don't try to centralize cross-skill items into a single home — that defeats the point of the skill-local inventory.

For workspace-wide concerns (e.g., a CLAUDE.md primitive needs revision), use the appropriate project (`projects/claude-local-frontier/`) rather than a skill ROADMAP.md.

---

## 7. Anti-patterns

1. **Cross-section drift.** Item appears in both Open Considerations AND Completed within the same file. Caused by shipping a fix without closing the Open entry. Detected by `/audit` Step 6 (continuous detection) and the SessionEnd hook.
2. **Schema drift.** Open Considerations entry missing Status / Source / Severity. Especially common for older entries that pre-date this policy. Add the fields when next touching the entry.
3. **CONTEXT.md duplication.** The active project's CONTEXT.md "Open follow-ups" line spelling out every item from ROADMAP.md verbatim. CONTEXT.md should summarize highest-priority + point to ROADMAP for the full list.
4. **Stale Standing Deferrals.** A standing deferral whose activation criterion has been met but the item hasn't been bundled or shipped. Re-evaluate at every improvement project kickoff.
5. **Bundle creep.** Adding a new bundle for every new item rather than fitting items into existing bundles. Bundles should reflect coherent scopes, not be a 1:N mapping with items.
6. **Retroactive Completed edits.** Completed is append-only — preserves audit trail. If an entry needs revision, add a new entry referencing the original.
7. **Ungated promotion to Completed.** Moving an item to Completed before the work has been read-back-verified. Per CLAUDE.md "Verify-before-claim-complete" — Completed entries need a verification line.
8. **Inherited figures presented as confirmed.** A bundle (or any summarizing pass) restating a count, locus list, or effort estimate from the entry it bundles, worded as though the bundling pass verified it — "confirmed live at," "measured," "N files." The number ages inside the entry while the wording claims freshness, and the error only surfaces during execution, when the scope is already committed. Re-measure at bundling time and record the command, or mark the figure explicitly as inherited (§4 "Re-measure what the bundle claims to have confirmed").

---

## 8. Audit integration

The `audit` skill (`/audit`) Step 6 — "ROADMAP drift" detector — runs on demand (deep version via `/audit`, executed against all skills or a single skill via the optional `roadmap` scope arg). A cheap continuous version of sub-checks A (missing ROADMAP.md) and B (cross-section drift) shipped 2026-05-06 in the SessionEnd hook (`hooks/session-end-improvement-opportunities.sh`'s `check_roadmap_drift` function), so those two failure modes — the ones most likely to silently accumulate between explicit audit runs — are caught at every session-end. Sub-checks C, D, and E run only in the deep `/audit` pass.

Sub-checks (full list in `skills/audit/SKILL.md` Step 6):

- **A. Missing ROADMAP.md** per skill. Lists skills missing the file.
- **B. Cross-section drift.** Items appearing in both Open Considerations AND Completed within the same file (the failure mode caught at 2026-05-05 with job-materials Item 6).
- **C. Schema drift.** Open Considerations entries missing Status / Source / Severity / scope fields.
- **D. Stale items.** Open Considerations entries whose Source date is > 90 days old without a Status update.
- **E. Bundle staleness.** Candidate Bundles section entries referencing items that have been resolved or no longer match the heading slug.

The detector reports findings without auto-fixing. Craig decides which to address; fixes get scoped as their own change.

---

## 9. Worked example

The `job-materials` skill's ROADMAP.md is the reference implementation. **Re-measured 2026-07-24** (`fable-os-review` B5 / R-04 — the figures below had been frozen at the 2026-05-05 scaffold and were badly stale; an M10 STILL-LIVE pair):

- **41 active Open Considerations**, 0 resolved-inline.
- **Bundle letters run A–F.** Live/un-shipped: **C** (hook + bridge + summary prose disciplines), **E** (calibration + threshold tuning), **F** (resume JD-vocabulary discipline — HIGHEST, slated v6). Shipped and struck through: **A** (verifier discipline, v5 S1), **B** (`craig-profile.md` hygiene, v5 S2), **D** (mechanical detectors, MOSTLY SHIPPED v5 S3). A **"Bundle F+"** (post-[REDACTED COMPANY] reinforcement) is referenced by several entries as a proposed home but is not yet a bundle heading.
- **2 Standing Deferrals** (New Story Intake Protocol; Output Diversification) with explicit activation criteria.
- A multi-month Completed audit trail spanning Phase 1 through v4 close + post-v4 live applications, now with a `ROADMAP-archive.md` sibling under the §10 compaction discipline.

**Do not treat these counts as fixed.** They are a dated measurement of a living file, and the 2026-05-05 snapshot going stale for ~2.5 months is exactly the M10 failure mode this policy's own §7 anti-pattern #2 warns about. Re-measure before citing. What is *structurally* stable — and what a new ROADMAP should actually be compared against — is the shape: every Open Consideration carries Status / Source / Severity; bundle letters are append-only (a shipped bundle is struck through, never re-lettered, so letters do not shift under existing references); Standing Deferrals name an activation criterion.

When evaluating whether a new ROADMAP.md you're scaffolding meets this policy, compare structurally against `skills/job-materials/ROADMAP.md`.

---

## 10. Compaction discipline — the `[Open / Completed]` split (M4)

A skill `ROADMAP.md` grows without limit: the **Completed** section (§5) is an append-only audit trail, and a long-lived skill accumulates a multi-month trail. This is diagnostic gap **G10** — `skills/job-materials/ROADMAP.md` reached 84,290 cl100k. Maintenance policy **M4** (`policies/memory-architecture.md` §6) bounds it, and this section is M4's acting home for skill ROADMAPs (the parallel of `/end-session` Step 4.5 for `log.md`).

**The threshold.** When a skill `ROADMAP.md`'s `## Completed` section exceeds **12,000 cl100k** (`memory-architecture.md` §3.2), it is compacted. The threshold measures the **Completed section** — the compactable append-only portion — not the whole file: Open Considerations / Candidate Bundles / Standing Deferrals are never compacted, so measuring them against a compaction threshold would be incoherent. The `/audit` Step 1.7 detector and the SessionEnd hook flag an over-threshold Completed section; `python3 ~/aios/scripts/check-append-only-compaction.py` is the detector.

**What gets compacted — and what never does.** Compaction is scoped to the **Completed** section only. **Open Considerations, Candidate Bundles, and Standing Deferrals are never compacted** — they are the actionable inventory, the reason the file exists (§1), and must stay navigable in full. This is the `[Open / Completed]` split: the *open* half stays whole; the *completed* half is bounded.

**The mechanic (move, not delete).** Move the **oldest** Completed entries **verbatim** into a sibling `ROADMAP-archive.md` — organized as dated `## Archive — Completed entries through YYYY-MM-DD` sections. Leave in the live `ROADMAP.md` Completed section the **recent** entries plus a **dated summary block** — one manifest line per archived entry (date + what shipped) — and a pointer to `ROADMAP-archive.md`. Keep enough recent entries that the file lands comfortably under threshold. Every byte of detail is preserved (`memory-architecture.md` Non-Negotiable #2); verify `ROADMAP-archive.md` + the trimmed `ROADMAP.md` reconstruct the full Completed trail before the edit is done.

**When it runs.** Apply this discipline whenever the detector flags the file — most naturally during an improvement-project pruning pass (§4 "When the file gets pruned"), or as a standalone compaction pass. Compaction does not violate the §7 anti-pattern "Retroactive Completed edits": moving an entry verbatim to the archive is not *modifying* it. The archive file is the audit trail's permanent home; the live Completed section becomes a recent-window-plus-manifest view of it.
