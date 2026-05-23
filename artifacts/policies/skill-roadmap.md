<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The skill-ROADMAP.md lifecycle protocol—the canonical inventory mechanism for outstanding follow-ups, planned improvements, and historical work on each custom skill. Defines `Open Considerations` → `Completed` lifecycle states; specifies the `Candidate Bundles` pre-grouping for next-improvement-project scoping.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions.
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

- **Path:** `~/.claude-local/skills/[skill-name]/ROADMAP.md`
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
3. **Do not delete the Open Considerations entry** in the same session as the resolution. Carrying the resolved entry through the next session lets future readers see the resolution timeline without grep-spelunking. The entry can be deleted in the next improvement project's pruning pass.

The cross-section drift caught at 2026-05-05 (Item 6 em-dash item shipped to Completed but Open entry was not closed) is the failure mode this discipline prevents — and the audit skill's Step 6 "ROADMAP drift" detector catches it continuously.

### When items get bundled

Bundle assignment is updated:

- Whenever a new Open Consideration is added: assign to a bundle if it fits, or create a new bundle if it doesn't.
- Whenever an Open Consideration is resolved: remove from its bundle (or mark resolved-in-place if the bundle preserves it for context).
- At the start of any improvement project: refactor bundles based on what's actually being scoped. The bundles are a planning aid; they should evolve with the planning, not constrain it.

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

The `job-materials` skill's ROADMAP.md is the reference implementation as of 2026-05-05. It has:

- 14 active Open Considerations + 2 resolved-inline (1 historical, 1 from this session's centralization sweep) = 16 total entries.
- 5 Candidate Bundles (A: verifier discipline; B: craig-profile.md hygiene; C: prose disciplines; D: mechanical detectors; E: signal-dependent calibration) covering all 14 active items.
- 2 Standing Deferrals (Story Intake Protocol; Output Diversification) with explicit activation criteria.
- A multi-month Completed audit trail spanning Phase 1 through v4 close + post-v4 live applications.

When evaluating whether a new ROADMAP.md you're scaffolding meets this policy, compare structurally against `skills/job-materials/ROADMAP.md`.

---

## 10. Compaction discipline — the `[Open / Completed]` split (M4)

A skill `ROADMAP.md` grows without limit: the **Completed** section (§5) is an append-only audit trail, and a long-lived skill accumulates a multi-month trail. This is diagnostic gap **G10** — `skills/job-materials/ROADMAP.md` reached 84,290 cl100k. Maintenance policy **M4** (`policies/memory-architecture.md` §6) bounds it, and this section is M4's acting home for skill ROADMAPs (the parallel of `/end-session` Step 4.5 for `log.md`).

**The threshold.** When a skill `ROADMAP.md`'s `## Completed` section exceeds **12,000 cl100k** (`memory-architecture.md` §3.2), it is compacted. The threshold measures the **Completed section** — the compactable append-only portion — not the whole file: Open Considerations / Candidate Bundles / Standing Deferrals are never compacted, so measuring them against a compaction threshold would be incoherent. The `/audit` Step 1.7 detector and the SessionEnd hook flag an over-threshold Completed section; `python3 ~/.claude-local/scripts/check-append-only-compaction.py` is the detector.

**What gets compacted — and what never does.** Compaction is scoped to the **Completed** section only. **Open Considerations, Candidate Bundles, and Standing Deferrals are never compacted** — they are the actionable inventory, the reason the file exists (§1), and must stay navigable in full. This is the `[Open / Completed]` split: the *open* half stays whole; the *completed* half is bounded.

**The mechanic (move, not delete).** Move the **oldest** Completed entries **verbatim** into a sibling `ROADMAP-archive.md` — organized as dated `## Archive — Completed entries through YYYY-MM-DD` sections. Leave in the live `ROADMAP.md` Completed section the **recent** entries plus a **dated summary block** — one manifest line per archived entry (date + what shipped) — and a pointer to `ROADMAP-archive.md`. Keep enough recent entries that the file lands comfortably under threshold. Every byte of detail is preserved (`memory-architecture.md` Non-Negotiable #2); verify `ROADMAP-archive.md` + the trimmed `ROADMAP.md` reconstruct the full Completed trail before the edit is done.

**When it runs.** Apply this discipline whenever the detector flags the file — most naturally during an improvement-project pruning pass (§4 "When the file gets pruned"), or as a standalone compaction pass. Compaction does not violate the §7 anti-pattern "Retroactive Completed edits": moving an entry verbatim to the archive is not *modifying* it. The archive file is the audit trail's permanent home; the live Completed section becomes a recent-window-plus-manifest view of it.
