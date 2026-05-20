<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The `skill-ROADMAP.md` template—the canonical scaffold every custom skill in `~/.claude-local/skills/` uses to track its outstanding follow-ups, planned improvements, and historical work. Defines four lifecycle sections (Open Considerations / Candidate Bundles for Next Improvement Project / Standing Deferrals / Completed) with the schema the `/audit` slash-command checks for cross-section drift.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions. This is a structural template; no PII, target-company names, third-party individuals, or prior-employer narrative are present.
> **Why it's included.** Backs the case-study claim that ROADMAP-driven improvement is a documented discipline: this template shows the underlying structure that every per-skill ROADMAP.md inherits, referenced from the case-study tier.

---

# [Skill Name] — Roadmap

<!--
HOW TO USE THIS TEMPLATE
- This is the SKILL'S CANONICAL FOLLOW-UP INVENTORY. Copy this file to skills/[name]/ROADMAP.md and start filling it in.
- Required for every skill per `policies/skill-roadmap.md` and CLAUDE.md "Ongoing Structure Discipline" item 7.
- Sections: Open Considerations / Candidate Bundles for Next Improvement Project / Standing Deferrals (subsection) / Completed.
- Open Considerations entries follow the schema in `policies/skill-roadmap.md` §3 (Status / Source / Severity / scope estimate / decision-required y/n).
- When an Open Consideration ships, MOVE it to Completed (don't leave the Open entry behind — that creates cross-section drift, caught by /audit Step 6).
- Candidate Bundles is non-prescriptive — it's a planning aid for the next improvement project, not a binding scope.
- Standing Deferrals are items with explicit activation criteria (Craig brings new STAR story; latency drops below threshold; etc.). They sit in Open Considerations for visibility but are not bundle candidates until activated.
- Completed is an APPEND-ONLY audit trail. Do not retroactively modify entries; if a fix needs revision, add a new entry.
-->

The single source of truth for outstanding follow-ups, planned improvements, and historical work on the `[skill-name]` skill. New items get added here when surfaced (eval, live application, project session, or post-delivery review); items get moved to Completed when shipped, with full provenance preserved. When starting a new improvement project for this skill, read the **Candidate Bundles** section first — clusters group related Open Considerations into coherent project scopes that can be cherry-picked.

**Lifecycle integration.** New eval files and project sessions surface candidate follow-ups; per `policies/skill-roadmap.md`, those candidates land here before they're carried into a planned improvement project. The active project's CONTEXT.md may summarize the highest-priority items in prose for handoff visibility, but ROADMAP.md is the canonical inventory — when CONTEXT.md and ROADMAP.md disagree, ROADMAP.md wins and CONTEXT.md gets updated.

**Sections:**

- **Open Considerations** — actively-tracked follow-ups, individually
- **Candidate Bundles for Next Improvement Project** — clusters of Open Considerations grouped by theme, sized for cherry-picking into an improvement project plan
- **Standing Deferrals** (subsection of Candidate Bundles) — items with explicit activation criteria; not bundled until activated
- **Completed** — historical audit trail; do not modify retroactively

---

## Open Considerations

<!-- Each entry uses the schema below. See `policies/skill-roadmap.md` §3 for full field definitions. -->

### [Short descriptive heading — name the issue, not the fix]
**Status:** [Open / Open — pending Craig disposition / Open — monitor; codify on recurrence / Implementation shipped [project/session] / Standing deferral — activates when [criterion]]
**Source:** [Eval N (Company name, Session NN, YYYY-MM-DD) — brief context; or "live observation" / "coach feedback" / "session retrospective"]
**Severity:** [Low / Medium / High / Low → Medium pending recurrence]
**Trigger fired:** [Optional — populate when implementation has been proven out (in-session scaffolding, working file, completed earlier session) and the entry is ready for `/codify-trigger` source-file promotion. Document the source-file paths + insertion points + layer descriptions + architecture decisions + cross-references to working files. This is the canonical ground truth that `/codify-trigger` parses; the more specific the better. Omit until the trigger has actually fired — empty trigger field = entry not yet ready for codification.]

[1-3 paragraphs describing the issue: what was observed, why it matters, what the failure mode is. Include verbatim quotes when judgment is involved.]

**[Optional: any of] Decision needed / Recommended approach / Possible approaches / Diagnostic / Three enforcement-mechanism candidates / Decision threshold:**

[The actionable framing — what needs to be decided or designed before this item can ship. If Craig disposition is required, list the options explicitly.]

**Estimated scope:** [~N minutes/hours for the work + verification. If unknown, write "TBD pending design."]

**Risk if not codified:** [Optional, for items where the cost of inaction is non-obvious.]

---

### [Next Open Consideration entry...]

<!-- ... -->

---

## Candidate Bundles for Next Improvement Project

Open Considerations grouped into coherent bundles for cherry-picking into a future improvement project. Each bundle lists items, total estimated scope, decision-gates, and rationale for grouping. Standing Deferrals are listed last as a separate subsection.

Bundles are non-prescriptive. A future project plan can pick whole bundles, mix items across bundles, or scope a single high-priority item. The bundles exist to make the planning step faster by pre-grouping items that share scaffolding (same target file, same regression test surface, same verification approach) or sequencing dependencies.

---

### Bundle [A] — [Theme name]

**Priority:** [HIGHEST / HIGH / MEDIUM / LOW. Bundle priority = highest-priority item in the bundle, OR cluster-specific reasoning if items reinforce each other.]

**Items:**

- "[Open Consideration heading]" — [severity]; [1-line summary of why it's in this bundle].
- "[Next item]" — [...]

**Rationale:** [Why these items belong together. Shared file? Shared verification approach? Sequencing dependency? Avoiding rule fragmentation? This is the planning hint that makes the bundle worth keeping.]

**Estimated scope:** [Total minutes/hours for the bundle, with breakdown.]

**Decision required before kickoff:** [Any Craig disposition, or "None" if all items are objectively-actionable.]

**Prerequisites:** [External dependencies, e.g., "Eval-archive sweep for false positives," "Verify Check #N cleanliness on next eval."]

---

### Bundle [B] — [Next theme...]

<!-- ... -->

---

### Standing Deferrals

Items with explicit activation criteria. Not bundled until activated. They remain in the Open Considerations list above for full visibility but are not candidates for the next improvement project unless their activation criterion is met.

- **"[Standing deferral heading]"** — activates when [criterion]. Estimated [scope].
- **"[Next deferral]"** — activates when [criterion]. Estimated [scope].

---

## Completed

<!-- Append-only audit trail. Each entry: date heading + work shipped + provenance. -->

### YYYY-MM-DD — [Short heading describing what shipped]

[1-3 paragraphs documenting the change: what was done, why, source files touched, verification result. Cross-reference the Open Consideration it closes (if any) and the eval/session that drove it.]

- `path/to/file.md`: [edit summary]
- `path/to/other-file.py`: [edit summary]

**Verification:** [How the change was verified — read-back, regression test, eval-archive sweep, etc.]

---

### YYYY-MM-DD — [Next completed entry...]

<!-- ... -->
