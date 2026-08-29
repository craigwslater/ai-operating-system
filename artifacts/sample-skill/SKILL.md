<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The `job-materials` skill's SKILL.md—the runtime entry point for tailored-resume + cover-letter generation. Defines the composer/verifier multi-agent pattern, the reference-files loading sequence, the per-step composition workflow (Steps 0–9), and the eval-driven correction-loop rules the verifier subagent audits against.
> **What was redacted.** Substantial—**165 substitutions across 49 registry patterns**. PII (phone, location, private email) per registry rows pii-001 / pii-005 / pii-006. **25 distinct active-target companies appearing 134 times** substituted to `[REDACTED COMPANY]` via 28 registry rows, short-form and hyphenated variants included. One third-party named individual phrase referring to Craig's career coach (per registry ind-005). 8 occurrences of an internal prior-employer product name (per registry prior-001) and 1 prior-employer protocol-adoption phrase (per registry prior-009). **14 Category 7 triangulation-cluster rows fired 17 times** (`trg-001` / `003` / `006` / `009` / `012` / `016`–`024`): a payer partnership, a customer-scale figure, a productized care-model name, a named health-system partner, a slash-joined set of named navigation partners, and the dated trade-press citations and source dates that carry them. Category 2 masks a company's *name*; these mask the facts that recover the name without it. **One Category 8 row fired once** (`jd-001`): the distinctive half of a role title, lifted verbatim from a public job posting, which a literal search recovers to the employer with no triangulation at all. It is bracketed, so it announces itself.
> **⚠️ Six of those substitutions are invisible.** `trg-012` and `trg-020`–`trg-024` replace prose with prose rather than with a bracketed marker—a partner-category phrase and five dates are generalized in place. Nothing in the text below signals them, so this note is the only place a reader learns they happened.
> **⚠️ What "mechanized" does and does not mean.** This file is `redact.py` output with no hand edits layered on top—but that is a statement about *reproducibility*, not about coverage, and reading it as coverage is how this port went wrong once already. The first mechanized re-port (2026-08-28) republished two dates the Session 6 hand port had deliberately generalized, because no registry row reproduced them and no flag-layer entity caught them; `trg-022`, `trg-023` and backstops `sg-026`–`sg-031` exist because of that regression. A mechanized port is auditable, not automatically safe.
> **Why it's included.** Backs the composer/verifier pattern cited throughout the portfolio's case-study tier (CS#2 in particular) and the "46 evals, ~41 detectors, hundreds of errors caught and fixed autonomously per month" quantitative spine: every workflow step, every detector reference, every encode-into-source rule lives in this file alongside CS#2.

*Where to read first.* **Peer PMs**—Step 0 (the eager-load reference set) and Step 5 (the verifier-subagent invocation), plus the rule-promotion lifecycle refs woven through `references/voice-rules/` and `references/qa-checklist.md`. **Recruiters**—[Case Study #2](../../case-studies/02-composer-verifier.md) is the lighter read on the same content.

---

---
name: job-materials
description: Tailored resume and cover letter generator for Craig Slater's PM job applications. Use this skill immediately whenever Craig shares a job description and asks for a resume, cover letter, or application materials — even if phrased casually like "write me something for this job", "tailor my resume for this", "can you make a cover letter for [company]", "help me apply to this", or any time a job posting is pasted. This skill contains Craig's complete career profile and all positioning rules. Always use it rather than generating documents from scratch.
---

# Resume & Cover Letter Builder — Craig Slater

Generates a tailored 2-page resume and cover letter for Craig Slater, output as both Word (.docx) and PDF.

This skill is organized as **composer + verifier**. The composer (this workflow) produces a draft. The verifier (a subagent, see Step 5) audits the draft against `qa-checklist.md` before delivery. Significant drift (13+ issues in prior evaluations) surfaced because the composer was self-auditing in the same context it composed in — a separate verifier catches what the composer won't.

---

## Step 0: Session Priming — Load Reference Files

Before doing anything else, load the **eager** reference files listed below. They are the single source of truth and are required for every composer invocation. The remaining three files are **on-demand** — load them at the named step where their content is actually needed, not at session start.

**Eager (load now):**

- `references/craig-profile.md` — canonical career history, contact info, role bullets verbatim, skills organized by mastery angle, Key Facts.
- `references/career-narratives.md` — Layer 1 verified specifics (breadcrumbs), Layer 2 patterns, Layer 3 coach feedback. Required at session start because the anti-fabrication rule below treats it as a foundational composition baseline alongside `craig-profile.md`.
- `references/voice-rules.md` — **prescriptive composition rules — index.** Per-rule files (`voice-rules/rule-1-healthcare.md` through `voice-rules/rule-29-domain-explanation.md`) plus supporting `voice-rules/summary-construction.md` and `voice-rules/role-type-targeting.md`. Read the index in full at session start (covers Philosophy + Core Positioning Identity + per-rule navigation); load specific per-rule files on consult when their rule is invoked.
- `references/exemplars.md` — gold-standard templates: 5 Phrase Lock canonical phrases, Hook Templates A/B/C, Charli Product-Thinking Variant, canonical summary examples.
- `references/qa-checklist.md` — **detection layer.** Pre-generation gates A–G, composition checks **1–47** (grammar checks at 20(a)–(h); #32 deprecated), resume-specific checks, and the Read-Aloud Pass. The verifier subagents run against this checklist. *(Range last reconciled 2026-08-06 S7 — it had read "1–19 … check 21" since before check #22, so it understated the corpus by 26 checks. Re-check this line whenever a check is added.)*

**On-demand (load at the named step where the content is needed):**

- `references/corrections-log.md` — historical failures index (with shard inventory + Summary of Failure Categories). Consult when diagnosing a new drift pattern that feels familiar (any step); navigate from the index to the relevant shard (`corrections-log/evals-6-15.md`, `corrections-log/live-applications.md`, or `corrections-log-archive.md`).
- `references/question-archetypes.md` — application question classifier, answer frameworks, coherence rules. Used in Step 8.5 (on-demand, post-delivery).
- `references/reader-modeling.md` — Reader Model framework: hiring manager persona, competitive positioning, negative space analysis. Used in Step 1.5.

Do not invent any experience or achievements not found in `craig-profile.md` or `career-narratives.md`.

---

## Step 0.4: Recent-Application Canonical Sweep

**This step closes the cross-session canonical-drift gap surfaced by Eval 14 ([REDACTED COMPANY], 2026-04-29). It runs after Step 0 (load reference files) and before Step 0.5 (Company Brief). Numbered 0.4 to slot before the existing 0.5.**

The reference files (`craig-profile.md`, `exemplars.md`, `voice-rules.md`) are the source of truth, but in practice each session settles new working canonicals that don't always make it back into those files immediately. The most recent delivered cover letter for a similar role often contains the freshest canonical phrasing for each role's evidence sentences (Consulting, KTP, CentralReach, Charli) — phrasing that may differ from the reference-file version but reflects calibrations approved by Craig in prior reviews.

### Workflow

1. **Identify the closest-matching prior application** by scanning delivered cover letters across **both** `~/aios/projects/job-search-continued/outputs/` (the active project — freshest deliveries) **and** `~/aios/projects/job-search/outputs/` (the closed predecessor — full historical archive), preferring the most recent across both folders. Prefer same-role-type matches (e.g., for a Healthcare Platform + Analytics role, scan recent healthcare PM letters; for a 0→1 / Greenfield role, scan recent non-healthcare 0→1 letters). When in doubt, pull the 1-2 most recent applications regardless of role-type.

2. **Extract the canonical phrasing from the prior letter for each role's evidence sentence:**
   - Consulting: payment-reconciliation framing, MRR clause form (long "of delivering the payments system" vs. short "of delivery"), Three-Initiative attribution pattern (1-sentence parallel-gerund vs. 2-sentence split). **PL #5 form-selection sub-rule (added Eval 15, 2026-04-30):** the compact "of delivery" form is preferred whenever the "payment reconciliation system" / "the payments system" antecedent is established earlier in the same sentence as the PL #5 hit. The long "of delivering the payments system" form is preferred when no antecedent is in the same sentence (PL #5 lands as the first mention of the system). When extracting the prior letter's PL #5 form, also note whether its antecedent is in the same sentence — that decides which form is the working canonical for the new letter, not just the prior letter's choice. Origin: Eval 15 [REDACTED COMPANY] (composer drifted to [REDACTED COMPANY]'s long form for a [REDACTED COMPANY] sentence whose structure matched [REDACTED COMPANY]'s compact-form precondition). **PL #1 + S2 shape form-selection sub-rule (added v4 Round 3, 2026-04-30 from Eval 15 Round 2 Finding B):** when extracting the Three-Initiative form from the prior letter, also evaluate whether PL #1 will be DROPPED in the new letter per the Rule 18 narrative-value gate. **If PL #1 will be dropped, run the mandatory pre-step from `voice-rules/rule-18-canonical-bullet-fidelity.md` "Sentence-weight discipline when PL #1 is dropped" sub-section BEFORE finalizing the P4 S2/S3 shape:** re-verify the gate disposition. If PL #1's content is borderline-defensible per the gate criteria — the JD has implicit signals for workflow integration / cross-team data sharing / adoption-driving / customer-experience workflows even if it doesn't use the verbatim Rule 18 trigger phrases AND the 1-sentence parallel-gerund 2-outcome canonical form would strengthen P4 — INCLUDE PL #1 (option (d) in the Rule 18 sub-section), which avoids the S3 anemia problem entirely. If the gate genuinely fires (PL #1 stays dropped), evaluate the four-option enumeration in Rule 18 to choose between (a) compress / (b) drop initiative 3 / (c) restructure S3 with canonical structural-problem framing / (d) include PL #1. Origin: Eval 15 [REDACTED COMPANY] (composer over-conservatively dropped PL #1 per gate firing on JD lacking verbatim "compliance" / "care-to-billing" hook; Round 3 review concluded the gate fired over-conservatively given [REDACTED COMPANY]'s PMS product + three-platform structure with implicit workflow-integration signals, and PL #1 should have been included).
   - KTP: how the multi-tenant analytics platform is named; user role naming
   - CentralReach: [internal product name] wording ("owned the build-out of centralized clinical insights within [internal product name], transforming a fragmented clinical data collection system…" — the [REDACTED COMPANY] / [REDACTED COMPANY] v7 form), causal-chain naming pattern ("driving X, which enabled Y")
   - Charli: 1-sentence vs. fuller form, breadcrumb selection ([open protocol]/$900→$400s vs. NFC vs. TOU vs. metrics-only)
   - Apposition pattern: how each role is introduced ("a healthcare SaaS platform serving X," "a healthcare edtech provider serving Y," "an EHR for Z care providers")
   - Hook structure / framing register

3. **Treat the prior letter's phrasings as the working canonicals** unless either (a) the JD/Reader Model explicitly demands a different framing, or (b) the reference files have been updated since that letter shipped. In case of conflict, the source-file version wins — but check the reference-file revision dates against the prior letter's delivery date to confirm.

3.5. **Classify each prior-canonical phrase by why it was canonical there (added v4 post-[REDACTED COMPANY] eval-17, 2026-05-01; scope extended to RESUME SKILLS LINES post-[REDACTED COMPANY] eval-21, 2026-05-05; scope extended to RÉSUMÉ SUMMARY PHRASES post-[REDACTED COMPANY] eval-32, 2026-05-21).** Before importing any phrase from the prior letter, any skill line from the prior resume, OR any phrase from the prior résumé summary into the new draft, classify it into one of three categories — and apply the corresponding re-evaluation discipline:

   - **(a) JD-mirroring** — the phrase used the prior JD's specific vocabulary (e.g., [REDACTED COMPANY]'s "bespoke customer solutions" → "custom data" in cover letter; [REDACTED COMPANY]'s "modernization" → "modernization" framing; [REDACTED COMPANY]'s "GTM Modeling, market sizing, customer segmentation" → "Go-to-market modeling & market sizing" skill line). **JD-mirroring phrases must be explicitly re-evaluated against the new JD's vocabulary** — they earn their place in the new letter / resume only if the new JD has equivalent vocabulary. If the new JD doesn't, the phrase becomes residue from the prior letter and must be replaced or cut. **Diagnostic:** can the phrase be traced to a specific JD word/phrase in the prior letter's JD? If yes, the phrase is JD-mirroring and re-evaluation is mandatory.
   - **(b) Mastery-angle-driven** — the phrase reflects Craig's career through-line independent of any specific JD (e.g., "decision-grade products," "fragmented data," "data foundation"). These carry over reliably between similar role-types **when the new JD does NOT have equivalent vocabulary that Craig's mastery covers**. **JD-vocabulary precedence (added v6 Session 1, 2026-05-14 per RC10):** if the new JD has equivalent vocabulary that Craig's mastery angle covers, the imported line MUST be re-mirrored to the new JD's vocabulary, NOT imported as-is. Worked example: [REDACTED COMPANY] Eval 23's "Multi-tenant analytics platform architecture" skill line is mastery-angle-driven ([REDACTED COMPANY] JD didn't say "platform features" verbatim) — but [REDACTED COMPANY] JD does say "core platform features" verbatim, so on a [REDACTED COMPANY]-class application the line MUST re-mirror to a JD-anchored phrasing like "Platform features for prospects + subscribers" ([REDACTED COMPANY] v2 actual) with the multi-tenant credential moved to a parenthetical or to a separate line. **Disposition options under the strengthened rule:** "import (no JD-vocab equivalent in new JD)" / "re-mirror (new JD has equivalent)" / "re-derive" / "cut." **Cross-link to Step 1.6:** Step 1.6 (below Step 1.5) inventory consumes Gate A item 5 JD vocabulary mapping and forces JD-vocab pull at composition time; this sub-step 3.5 strengthening forces the same discipline at the prior-letter-import layer. Both are mutually reinforcing — Step 1.6 catches surfaces the JD names that Craig should pull in fresh; Step 0.4 sub-step 3.5's JD-vocab-precedence rule catches the same surfaces in imported mastery-angle-driven lines.
   - **(c) Brief-driven** — the phrase reflects company-specific facts from the prior Brief (e.g., specific apposition forms tied to company descriptions, specific named partners). These DO NOT carry over between letters — each new application has its own Brief and its own company-specific phrasing. The phrase must be re-derived from the new Brief, not imported from the prior one.

   **Resume skills section scope (added 2026-05-05 post-[REDACTED COMPANY] eval-21).** Step 0.4 sub-step 3.5 applies in full to the resume skills section, not just cover-letter prose. The same Step 0.4 import-from-prior-letter logic that drives cover-letter canonicals also drives skills-section structure: when composing for application N+1, the natural starting point is application N's skills section. Every skill line carried over from a prior application must pass Step 3.5's classification — JD-mirroring lines (e.g., "Go-to-market modeling & market sizing" from [REDACTED COMPANY], "Vertical SaaS product ownership" from a JD that explicitly named vertical SaaS) must be re-evaluated against the new JD's verbatim vocabulary per Rule 7 Gate 2. Mastery-angle-driven lines (e.g., "Platform architecture & systems thinking," "EDI/x12 (835/837 transaction sets)") carry over reliably. Brief-driven lines are rare in skills sections (skills don't typically depend on company-specific Brief facts) but the same import discipline holds for any that do.

   **Résumé summary scope (added 2026-05-21 post-[REDACTED COMPANY] eval-32, `projects/job-materials-resume-positioning-audit/` OC1).** Step 0.4 sub-step 3.5 applies in full to the résumé summary, not just cover-letter prose and resume skills lines. When composing for application N+1, the natural starting point for the summary is application N's summary — the same prior-application-import dynamic that drives cover-letter canonicals and skills-section structure. Every phrase carried over from a prior application's résumé summary must pass Step 3.5's classification, and — because the summary is the one résumé positioning surface with no Step-1.6 / Step-2.5 / Step-4h JD-vocab gate — every imported summary phrase additionally gets an explicit "maps to a concept in THIS JD?" verdict. A phrase that maps to no concept in the target JD is non-JD residue and must be re-mirrored to the new JD's vocabulary or cut, even when it traces cleanly to a `craig-profile.md` Angle of Mastery. The summary triplet and every positioning phrase must map to a JD concept per Rule 7's "JD-alignment for resume positioning signals" subsection. Origin: Eval 32 [REDACTED COMPANY] (2026-05-21) shipped a résumé summary carried over from the [REDACTED COMPANY] application — "platform products and mobile-first experiences," "launch and continuous improvement," "adoption, engagement, and retention" — none mapping to a [REDACTED COMPANY] JD concept; Gate F + Gate G both passed it because Gate F is a mechanical banned-phrase scan and Gate G traces phrases to Angles of Mastery (which these phrases satisfied) without checking JD-concept mapping. The verifier-side residual is Gate G sub-check (d), added in the same project.

   **Document the classification in `/tmp/composer_notes.md`** alongside the working-canonicals list (item 4 below). For category (a) JD-mirroring phrases, the documentation must include the prior JD's specific vocabulary the phrase mirrored AND a yes/no verdict on whether the new JD has equivalent vocabulary. If no, the phrase is replaced or cut. **The classification table in composer_notes.md MUST include resume skills lines and résumé summary phrases** — not just cover-letter prose elements — when those lines or phrases were inherited from a prior application's skills section or résumé summary.

   **Why this exists:** Eval 17 ([REDACTED COMPANY], 2026-05-01) surfaced "custom data" carrying over from [REDACTED COMPANY] v7 because Step 0.4 imported it as a settled canonical without checking that "custom" in [REDACTED COMPANY] was specifically JD-mirroring ([REDACTED COMPANY]'s JD said "bespoke customer solutions"). [REDACTED COMPANY]'s JD doesn't use "custom" or "bespoke." The phrase was [REDACTED COMPANY] residue. **Eval 21 ([REDACTED COMPANY], 2026-05-05) surfaced the same failure mode at the resume skills section** — three lines ("Vertical SaaS product ownership," "Go-to-market modeling & market sizing," "ROI models & business case development") were imported from [REDACTED COMPANY]'s skills section where they were JD-mirroring ([REDACTED COMPANY]'s JD explicitly named GTM modeling / market sizing / customer segmentation; healthcare-tech vertical was [REDACTED COMPANY]-relevant context). [REDACTED COMPANY]'s JD does not contain equivalent vocabulary. The lines became [REDACTED COMPANY] residue at the [REDACTED COMPANY] resume. Craig caught this on post-delivery review. Original Step 0.4 sub-step 3.5 was scoped to cover-letter prose only; this revision extends the scope to resume skills lines.

4. **Document the sweep in `/tmp/composer_notes.md`** in this shape:

```
# Composer Notes — Step 0.4 Canonical Sweep

Reference letter(s) consulted: [filename + delivery date]

Working canonicals from prior letter:
- Consulting MRR clause: [exact wording]
- Consulting Three-Initiative form: [1-sentence parallel-gerund / 2-sentence split / not-included]
- CentralReach [internal product name] wording: [exact wording]
- KTP / Charli / apposition patterns: [as relevant]

Phrase classification (per Step 3.5 — added eval-17, 2026-05-01; resume-skills-lines sub-table added v5 Session 1, 2026-05-06 from eval-22 [REDACTED COMPANY] procedural-application failure where the rule was codified hours earlier in the same session and the composer didn't apply it; visible-absence-of-rows is the enforcement mechanism):

**Cover-letter phrases:**
| Phrase | Category | If JD-mirroring: prior JD word/phrase | If JD-mirroring OR mastery-angle-driven: new JD has equivalent JD vocab? | Disposition |
|---|---|---|---|---|
| [phrase 1] | JD-mirroring / mastery-angle-driven / Brief-driven | [prior JD vocab; N/A if not JD-mirroring] | yes / no / N/A (Brief-driven) | import (no JD-vocab equivalent) / re-mirror (new JD has equivalent) / re-derive / cut |
| [phrase 2] | ... | ... | ... | ... |
[repeat per imported phrase]

**Resume skills lines (mandatory — pre-populate empty rows for every skill line carried over from the prior application's resume; visible absence is the enforcement mechanism):**
| Skill line | Category | If JD-mirroring: prior JD word/phrase | If JD-mirroring OR mastery-angle-driven: new JD has equivalent JD vocab? | Disposition |
|---|---|---|---|---|
| [skill line 1 from prior resume] | JD-mirroring / mastery-angle-driven / Brief-driven | [prior JD vocab; N/A if not JD-mirroring] | yes / no / N/A (Brief-driven) | import (no JD-vocab equivalent) / re-mirror (new JD has equivalent) / re-derive / cut |
| [skill line 2 from prior resume] | ... | ... | ... | ... |
[repeat per skill line carried over from prior application's skills section]

If no skill lines were carried over from a prior application's resume (e.g., skills section was drafted from `craig-profile.md` JD-Triggered Specifics directly), write explicitly under the Resume skills lines sub-table: "No skill lines imported — drafted skills section from craig-profile.md JD-Triggered Specifics directly." This is the only acceptable empty state for this sub-table; leaving the sub-table empty without this override-line trips the verifier-side residual check (per `agents/verifier-prompt.md` Skills-section audit Step 0.4 sub-step 3.5 residual check, added v5 Session 1).

**Résumé summary phrases (mandatory — pre-populate a row for every phrase carried over from the prior application's résumé summary; visible absence is the enforcement mechanism; added 2026-05-21 from `projects/job-materials-resume-positioning-audit/` OC1, post-[REDACTED COMPANY] eval-32 where a summary imported from the [REDACTED COMPANY] application shipped non-JD vocabulary undetected):**
| Summary phrase | Category | If JD-mirroring: prior JD word/phrase | Maps to a concept in THIS JD? (quote the JD word/phrase, or "no") | Disposition |
|---|---|---|---|---|
| [summary phrase 1 from prior résumé] | JD-mirroring / mastery-angle-driven / Brief-driven | [prior JD vocab; N/A if not JD-mirroring] | [JD word/phrase quoted] / no | import (maps to a JD concept) / re-mirror (new JD has equivalent vocabulary) / cut (maps to no JD concept) |
| [summary phrase 2 from prior résumé] | ... | ... | ... | ... |
[repeat per phrase carried over from the prior application's résumé summary]

Every imported summary phrase with "no" in the "Maps to a concept in THIS JD?" column MUST be dispositioned re-mirror or cut — it cannot ship as-is. A résumé summary phrase that maps to no concept in the target JD is non-JD vocabulary residue from the prior application's summary and fails Rule 7's "JD-alignment for resume positioning signals" discipline; this holds even when the phrase traces cleanly to a `craig-profile.md` Angle of Mastery (a real Craig capability rendered in the wrong JD's vocabulary still fails). If no phrases were carried over from a prior application's résumé summary (the summary was drafted from `craig-profile.md` Angles of Mastery + `voice-rules/summary-construction.md` directly), write explicitly under this sub-table: "No summary phrases imported — drafted résumé summary from craig-profile.md + summary-construction.md directly." This is the only acceptable empty state for this sub-table; the verifier-side Gate G JD-concept sub-check (d) (added 2026-05-21) is the residual catch that fires on a freshly-drafted summary.

**Résumé summary S2 verb-register imports (mandatory — pre-populate a row for every S2 verb pattern carried over from the prior application's résumé summary; visible absence is the enforcement mechanism; added v8 / projects/job-materials-summary-positioning-fix/, 2026-05-27, post-[REDACTED COMPANY] eval-39-clinical v1 — Defect 3):**

| S2 verb pattern (verbatim from prior summary S2) | Pattern classification | Prior JD justification (if any) | New JD has equivalent justification? | Disposition |
|---|---|---|---|---|
| [S2 verb pattern 1 from prior résumé summary] | mastery-angle-pairing / process-listing-of-activities / strategic-transformation / structural-insight-closer | [prior-JD-specific justification or "none — generic"] | yes / no / N/A (already strategic) | import (mastery / strategic / structural — clears semantic check) / re-derive (process-listing — does not clear) / re-mirror (mastery-pairing but JD differs) |
| [S2 verb pattern 2 from prior résumé summary] | ... | ... | ... | ... |
[repeat per S2 verb pattern carried over from prior application]

**Pattern classifications (4 categories per the mastery-vs-activity diagnostic from `voice-rules/summary-construction.md` "PM-voice structural-pattern detection in S2"):**

- **(a) Mastery-angle-pairing** — second clause names a CAPABILITY (mastery angle) paired with a domain or angle. Examples: "...brings consumer-facing product development experience to healthcare's shift toward consumer-grade patient experiences" (Eval 32 — capability paired to industry shift); "...pairs that platform depth with hands-on AI and automation fluency" (Eval 34 — mastery-pairing). **Import-eligible** when the new JD supports the same pairing structure; **re-mirror** when the new JD demands a different pairing.
- **(b) Process-listing-of-activities** — second clause lists ACTIVITIES Craig performs (collaborator + activity-verb + activity-noun-list). Example: "...partners on business cases, ROI projections, and end-to-end product delivery" (Eval 39 v1 — pure process-listing). **NEVER import** — re-derive from `voice-rules/summary-construction.md` PM-voice ban + Defect 6 structural-pattern detection.
- **(c) Strategic-transformation** — second clause names a product-strategist transformation as the primary verb pattern (typically `Specializes in turning X into Y that drives Z`). Examples: "Specializes in turning fragmented clinical, claims, and operational data into governed, decision-grade platforms..." (Eval 33 [REDACTED COMPANY]). **Import-eligible** when the new JD supports the same transformation framing; **re-mirror** when the new JD's specific transformation differs.
- **(d) Structural-insight-closer** — second clause closes on a structural principle or insight (e.g., "as repeatable patterns rather than one-off builds" — Eval 35 [REDACTED COMPANY]). **Import-eligible** when the new JD values the same principle; **re-derive** when the principle no longer fits.

**Why this sub-table exists:** Eval 39 [REDACTED COMPANY] Clinical v1 (2026-05-27) S2 inherited Eval 32 [REDACTED COMPANY] v1.1's verb pattern via Step 0.4 sub-step 3.5 import discipline. Eval 32's verb pattern was a mastery-angle-pairing justified by a JD-specific consumerization tail ("brings consumer-facing product development experience to healthcare's shift toward consumer-grade patient experiences"). Eval 39's JD had no equivalent justification → the inherited pattern became a process-listing of Eval 39 JD activities (PM-voice) rather than a strategic transformation or mastery-pairing. Step 0.4 sub-step 3.5's existing résumé-summary-phrases sub-table audited *phrase content* for JD-vocab classification but did NOT audit imported *verb register* / S2 structural verb pattern fitness for the new role-type. This 4th sub-table closes that gap by forcing classification of the S2's verb-pattern *structure* (not just its phrase-level vocabulary) at the import layer.

**Coordination with summary-construction.md PM-voice ban + Defect 6 structural-pattern detection:** the PM-voice banned-phrase list catches explicit PM-voice phrases mechanically (Gate F). The Defect 6 structural-pattern detection catches process-listing structural patterns at the verifier-side semantic layer. This Step 0.4 sub-step 3.5 4th sub-table catches the same pattern at the *import-time* layer — preventing process-listing patterns from making it into the new summary in the first place by classifying the prior S2's verb pattern before it imports.

**Empty-state override:** if no S2 verb pattern was carried over from a prior application's résumé summary (the summary's S2 was drafted from `voice-rules/summary-construction.md` directly), write explicitly under this sub-table: "No S2 verb pattern imported — drafted S2 from voice-rules/summary-construction.md directly." This is the only acceptable empty state for this sub-table; the verifier-side semantic check (Defect 6 structural-pattern detection per `voice-rules/summary-construction.md`) is the residual catch that fires on a freshly-drafted S2.

Deviations from reference-file canonicals (if any): [note divergences and which version wins]
```

### Why this exists

Eval 14 surfaced 3 distinct cross-session-drift issues in one session: PL #5 "of delivery" ([REDACTED COMPANY] corrected → never persisted), [internal product name] wording ([REDACTED COMPANY] → never persisted to craig-profile.md), and Three-Initiative 1-sentence default (documented in voice-rules.md as one of several allowed but not as the default for the initiatives 2+3 case). Each was a phrasing settled with Craig in a prior session that the next session re-derived from scratch. The sweep catches these by reading what was actually delivered, not just what's documented as canonical.

### Cost calibration

This step is fast — ~3-5 minutes. Read 1-2 prior cover letters end-to-end, note the 6-8 evidence-sentence canonicals, then proceed to Step 0.5. The cost is justified by every issue from Category A in Eval 14 that wouldn't have surfaced in review if this step had been in place.

---

## Step 0.5: Company Intelligence — Build the Company Brief

**This is a pre-generation gate. The Company Brief must be written before Step 1 begins.**

The Company Brief grounds the application in company-specific research so materials demonstrate Craig already understands the company's situation — not just the JD's keywords. It feeds the cover letter hook, the fit paragraph, and the verifier's specificity check.

### Workflow

1. **Identify the company** from the JD or Craig's instructions. If ambiguous, ask Craig.

2. **Run up to 3 targeted Brief-construction searches** (not open-ended browsing). Composer chooses 3 from the candidate pool based on the JD + Brief needs:

   Candidate pool:
   - `[Company name] product` — product pages, About page, how value is delivered (Section 1 input; typically always chosen)
   - `[Company name] funding OR Series OR raised` — Crunchbase/press for stage, trajectory, recent events (Section 2 input; typically always chosen)
   - `[Company name] competitors` — competitive landscape, differentiation claims (Section 3 input; typically chosen for default healthcare-PM applications)
   - `[Company name] engineering blog OR product blog` — culture, tech stack, team priorities (Section 4 input; substitute only when Section 4 fires per "Conditional Sections" below)
   - `[Company name] [domain-specific term]` — e.g., `[Company] FHIR interoperability` for healthcare; `[Company] [non-healthcare regulatory term]` for non-healthcare (Section 6 input; substitute only when Section 6 fires per "Conditional Sections" below)

   **Composer choice + override.** Default routing for a healthcare-PM application with Sections 4 + 6 both skipped = product + funding + competitors. When Section 4 OR Section 6 fires, composer routes one of the 3 slots to engineering-blog or domain-specific. When BOTH Section 4 AND Section 6 fire (rare), composer may use up to 4 Brief-construction searches with documented rationale in `/tmp/composer_notes.md` Step 0.5 line.

3. **Run 1 composite currency-check search** that surfaces (a) Section 7 Company Moment freshest anchor + (b) any JD quantitative/named-claim currency verification in a single query:

   `[Company] [current year] partnership OR launch OR expansion OR announcement` — anchored on the current year forces the freshest signal to surface first; covers Section 7 anchor (per [REDACTED COMPANY] Eval 24 pattern) + lets the composer verify any JD quantitative / named claims (counts of customers / partners / programs, specific dates, named partners, recent funding rounds, multiplier verbs framing scale) against current state.

   **Total Brief web-search budget: ≤4** (3 Brief-construction + 1 composite currency-check). The override case in Workflow #2 raises the cap to ≤5; document rationale.

4. **Structure findings** into the seven-section Company Brief format and write to `/tmp/company_brief.md`:

   **Section 1 — Product Landscape (always):** What they sell, who they sell to (buyer persona), how value is delivered (SaaS, hardware+software, marketplace, managed service), domain and vertical.

   **Section 2 — Recent Signals (always; last 12 months):** Funding events, product launches, leadership changes, strategic pivots or expansions, public statements from leadership about priorities.

   **Section 3 — Competitive Positioning (always):** Named competitors (from company's own positioning, press, job postings), how they differentiate, market category they claim.

   **Section 4 — Culture & Team Signals (CONDITIONAL).** Engineering/product blog themes, LinkedIn hiring patterns (backfill vs. new team), tech stack signals from job postings.

   - **Fires only when:** Reader Model team-maturity (per Step 1.5) cannot be inferred from JD reporting structure + JD team-size signals + Company Brief Sections 1–3 alone.
   - **Default:** skip. Most healthcare and B2B SaaS PM applications can construct an actionable Reader Model from JD reporting structure + Sections 1–3 without a dedicated culture/team search.
   - **Override line:** composer may fire Section 4 with documented rationale in `/tmp/composer_notes.md` Step 0.5 line — `Section 4 fired — rationale: [why JD + Sections 1–3 are insufficient for Reader Model team-maturity inference]`. Override routes one search slot in Workflow #2 to the engineering/product-blog query.

   **Section 5 — Inferred Pain Points (always):** What the JD + signals suggest the team is building toward, what "winning" looks like for this hire in the first 6–12 months, what organizational pressure the team is under (scaling, modernizing, launching, proving ROI). Derived from Sections 1–3 + 7 + JD — no separate search.

   **Section 6 — Domain-Specific Context (CONDITIONAL).** For healthcare: regulatory posture (HIPAA, HITRUST, HEDIS), payer/provider dynamics, interoperability stance (FHIR, HL7, claims data), care-delivery model. For non-healthcare: relevant regulatory or industry dynamics.

   - **Fires only when:** (a) JD names a non-healthcare regulatory environment (e.g., financial services / SOC 2 / PCI DSS; education / FERPA; legal / e-discovery); OR (b) JD names an unfamiliar healthcare sub-vertical not covered by `references/craig-profile.md` Healthcare/HealthTech Angles + `references/career-narratives.md` Layer 1 Stories (e.g., behavioral-health-specific sub-verticals, rare-disease, specialty-oncology).
   - **Default:** skip for healthcare-PM applications. The healthcare domain context Craig needs is already in `references/craig-profile.md` (Healthcare/HealthTech Angles of Mastery) + `references/career-narratives.md` (Layer 1 stories spanning CentralReach, Knowledge to Practice, ABA/autism SaaS, RCM analytics, EHR platforms). When Section 6 is skipped, composer pulls domain context directly from those references — no fresh search needed.
   - **Override line:** composer may fire Section 6 with documented rationale — `Section 6 fired — rationale: [non-healthcare regulatory environment / unfamiliar healthcare sub-vertical not in craig-profile + career-narratives]`. Override routes one search slot in Workflow #2 to the domain-specific query.

   **Section 7 — Company Moment (always; required):** What is happening at this company *right now* — the specific inflection point, transition, or challenge that makes this hire timely. This is NOT their general thesis or mission; it's their current moment. Examples: "expanding from single-product to multi-product platform," "just closed Series C and scaling the data team from 3 to 15," "migrating from legacy monolith to modern analytics stack," "entering the employer market after proving the health-plan channel." Name the moment in one sentence, then 2–3 supporting facts with source URLs. If research surfaces no clear moment, document that explicitly — "No specific inflection identified; hire appears to be steady-state growth/backfill" — rather than inventing one. Populated primarily from Workflow #3 composite currency-check search results.

   **Current-year anchoring (added 2026-05-04, [REDACTED COMPANY] eval).** Section 7's freshest fact (from Workflow #3 composite search) goes first as the primary Company Moment anchor; older facts are demoted to supporting context. The composite currency-check search is intentionally current-year-anchored to force the freshest signal to surface first — do NOT supplement with generic-query searches that surface older results unless the composite search returns no recent signal.

   **Date-tag every fact (added 2026-05-04, [REDACTED COMPANY] eval).** Every claim in Section 2 (Recent Signals) and Section 7 (Company Moment) must include its source date in the Brief itself: not "rolling out integrated offerings" but "rolling out integrated offerings (announced ~2 years prior to composition)." Compute fact age at intake (e.g., "[partner launch] — 4 months old as of composition"). Drop facts older than 18 months unless they establish durable scale (current-marketing claims like "[scale-figure] employer customers" — see `voice-rules/rule-24-company-intelligence.md` "Brief-fact currency discipline" for the durable-scale carve-out).

   **Source attribution (mandatory for all sections):** Every factual claim in the Company Brief must include its source — URL preferred, or "Company website / About page," "Crunchbase," "[Publication name], [date]" at minimum. If a fact cannot be attributed to a specific source, it does not go in the Brief. This is non-negotiable: the hook paragraph will reference Company Brief facts, and every fact used in the hook must be traceable after the fact. Unattributed claims in the Brief become unverified claims in the cover letter — which is a Data Accuracy Rules violation.

5. **JD-claim currency discipline (consolidated into Workflow #3 composite search; added v4 Session 1, 2026-04-30; consolidated 2026-05-18).** For every quantitative or named claim in the JD itself — counts of customers / partners / programs ("two additional U.S. health systems joining soon," "fifth Blues plan," "200 million annual visits"), specific dates ("launched March 2025"), named partners ("partnered with Memorial Sloan Kettering"), recent funding rounds, or any other claim the JD asserts as a current fact — review the Workflow #3 composite-search results to confirm currency before letting the JD claim flow verbatim into the cover-letter hook or evidence prose.

   **Why:** JDs sit on careers pages for weeks or months; the disclosed fact may have been superseded by a later announcement. Using a stale fact verbatim makes the hook feel out-of-date and risks landing as wrong on the reader's desk.

   **Procedure:** Enumerate the JD's quantitative/named claims. For each, ask: "Could this plausibly have been superseded since the JD was posted?" Cross-check against the Workflow #3 composite-search results (which were anchored on `[Company] [current year] partnership/launch/expansion/announcement` precisely to surface superseding events). For verifiable-current claims, use the JD wording verbatim (the JD source itself is your traceable evidence). For potentially-superseded claims, either (a) update the framing to reflect the more recent fact (with the new URL committed), or (b) reframe around a more durable JD signal that doesn't depend on the specific count / date. If the composite search did not surface enough current-year coverage to make the call, run one additional targeted search within the override budget.

   **Worked example — [REDACTED COMPANY] (Eval 14, 2026-04-29):** JD said "two additional U.S. health systems joining soon." Currency cross-check surfaced an [recent-months] trade-press announcement: [major academic medical center] had joined as [REDACTED COMPANY]'s fourth health system partner — post-dating the JD's "soon" framing. Final disposition: hook returned to JD-verbatim wording because the JD's pipeline disclosure is itself the durable source — most JDs don't disclose pipeline that way, and the JD-framing is distinctively useful. The check still ran; the conclusion was that the JD claim is durable when used JD-verbatim with the JD as the documented source. The discipline is the check, not the outcome — running the check produces the right disposition either way.

   **Pass condition:** every JD-claim used in cover-letter prose has been cross-checked for currency. Where staleness was detected, the prose was updated or reframed. Where currency was confirmed, the claim flows verbatim with the JD as documented source.

   **Fail condition:** a JD-claim flowed into the hook or evidence without a currency check. The verifier cannot run this check (it doesn't have access to recency-search results); the discipline must run at composer time during Step 0.5.

6. **Run the dual specificity diagnostic:**
   - **Test 1 (competitor-swap):** Can you articulate what makes this company's situation specific enough that swapping in a competitor's name would make the statement false?
   - **Test 2 (current-moment):** Does the Brief name something happening at this company RIGHT NOW — not just what they do in general?

   Both tests must pass. If Test 1 fails, run 1 additional targeted search within the ≤4 budget (or with documented override). If Test 2 fails, the composite currency-check at Workflow #3 likely needs re-running with a more targeted query for the company's recent product / leadership / partnership activity. Proceed after exhausting the budget — diminishing returns — but document which test(s) failed.

7. **Surface the Brief to Craig** as a 3–5 sentence summary before proceeding to Step 1. Craig can correct, add context, or say "looks good." This is NOT a blocking approval gate — if Craig says nothing, proceed. It prevents building on wrong assumptions about the company.

### Conditional Sections — Worked Examples

**Healthcare-PM application (Section 4 + Section 6 default-skip).** JD = Senior PM, Health Tracking & Planning at a D2C consumer-healthtech company adjacent to Craig's healthcare PM career arc — [REDACTED COMPANY] Health's longevity / preventive-care / DEXA + biomarker focus is not explicitly enumerated in `references/craig-profile.md` Angles of Mastery (which lists CentralReach EHR + KTP healthcare edtech + Consulting ABA/RCM as Healthcare/HealthTech coverage), but it is adjacent enough to KTP's clinician-learning + CentralReach's clinical-data-foundation work + `references/career-narratives.md` Layer 1 stories on KTP and CentralReach that the composer can construct domain context without a fresh Section 6 search. JD reporting structure (PM → Product leadership) + JD team-size signals + Brief Sections 1–3 (product = personalized longevity platform; funding = recent acquisition signal; competitors = Levels / Function Health / Lifeforce) give the composer enough for a competent Reader Model without a dedicated culture/team search. → **Section 4 skipped. Section 6 skipped.** Total searches = 3 Brief-construction (product + funding + competitors) + 1 composite currency-check = 4. Budget held at ≤4.

**Non-healthcare application (Section 6 fires).** JD = Senior PM, Platform at a financial-services SaaS company in a Craig-NON-covered sub-vertical (e.g., crypto-tax compliance — not in `references/craig-profile.md` Healthcare/HealthTech Angles, not in `references/career-narratives.md` Layer 1 stories). Composer routes one of the 3 Brief-construction slots to domain-specific search: `[Company] crypto-tax compliance OR SOC 2 OR PCI DSS`. → **Section 4 skipped** (JD reporting structure + Brief Sections 1–3 sufficient). **Section 6 fired** (non-healthcare regulatory; documents the regulatory posture surfaced). Total searches = 3 (product + funding + domain-specific, competitors-search slot routed to domain) + 1 composite currency-check = 4. Budget held at ≤4.

### Depth calibration

The Brief is a pre-generation input, not a deliverable. Each section: 2–5 bullet points. Total target: ~300–500 words. Hard stop after Workflow #3 budget is exhausted (≤4 searches default; ≤5 with documented override) — stop and work with what you have. The goal is grounded specificity, not exhaustive analysis.

### What the Brief does NOT do

- It does not replace the JD Briefing (Step 1). Step 1 is about the role; Step 0.5 is about the company.
- It does not produce deliverable-quality prose. It's structured research notes.
- It does not persist between sessions. Each application gets a fresh Brief.

---

## Step 1: JD Briefing — Hard Gate Before Drafting

**This is a pre-generation gate. Do not skip and do not proceed until you can complete every sub-step.**

Work through `qa-checklist.md` **Gate A (JD Briefing)** in full. **Gate A is canonical for the briefing's items and their numbering — this step does not re-enumerate them.** It is a **nine**-item list; cite any of them as **`Gate A item N`**, never as a bare "Step 1 item N."

*(Merged 2026-08-19, GATE-1 — `ROADMAP.md`. Until then this step carried its own differently-populated eight under the same "Step 1 JD Briefing" label: its item 5 was Phrase Lock capabilities where Gate A's is JD language mapping, and its item 6 the preferred-qualifications audit where Gate A's is the AI/ML framing decision. Bare-number pointers therefore resolved against whichever list the reader opened — including the ones feeding Step 1.6's blocking coverage gate below, which consumed the Phrase Lock list in place of the JD-vocabulary inventory. The two lists were **not** a permutation, so the merge appended Phrase Lock as Gate A item 9 rather than collapsing: every pre-merge pointer for N ≤ 8 keeps resolving, and the Phrase Lock planning step survives.)*

**If any of the nine Gate A items can't be completed, stop and clarify with Craig before generating.** Drafting without a complete JD Briefing is the primary cause of drift in prior evals. *(This is the Step-1-level hard-gate condition; it governs all nine items, not the single item whose procedure follows.)*

---

### Item 4 expanded procedure — hook angle determination (research-first, not template-first)

The one briefing item whose full procedure is too long for a checklist lives here rather than in Gate A. **It is subordinate to `Gate A item 4`, not a competing list.** The hook's shape is determined by the Company Brief's Section 7 (Company Moment), not by selecting a template and fitting research into it.

   **Required sequence:**
   - (a) Start from the Company Moment: what is happening at this company right now? Name the inflection point or challenge in one sentence.
   - (b) Ask: what hook shape does this moment demand? Write a 1–2 sentence draft hook that names the moment and connects it to the product problem Craig solves. This is the **research-driven hook candidate.**
   - (c) Only then check: does this candidate happen to fit a template (A: bet, B: approach, C: positioning) from `exemplars.md`? If yes, note which template and use the template's proven structure. If no, the research-driven candidate IS the hook — do not force it into a template.
   - (d) **If a template IS chosen, document what the non-template alternative would have looked like.** This forces genuine consideration. If the non-template version is more specific to the company's current moment, it wins — even if a template technically "fits."

   **Document:** the chosen hook angle, why it fits this company's specific moment, which Company Brief facts (with source URLs) the hook will reference, and (if a template was chosen) what the non-template alternative was.

   **Currency + role-relevance dual gate (added 2026-05-04, [REDACTED COMPANY] eval).** For every Brief fact considered as a hook anchor, verify TWO independent gates before using:
   - **(i) Currency:** the supporting source is dated within the last 12 months from the application date (per `voice-rules/rule-24-company-intelligence.md` "Brief-fact currency discipline" + `qa-checklist.md` Check #42). The durable-scale carve-out applies to undated current-marketing claims like "[scale-figure] employer customers."
   - **(ii) Role-relevance:** the fact maps to the role's JD scope (responsibility / required qual / preferred qual) AND, when imagined from the hiring manager's seat, reads as the kind of work this role enables, owns, or interacts with (per `voice-rules/rule-24-company-intelligence.md` "Brief-fact role-relevance discipline" + `qa-checklist.md` Check #43). A clinical-product launch fails role-relevance for a [REDACTED ROLE SCOPE] role's hook even when current.

   Both gates must pass independently. A fact that is current but not role-relevant fails just as much as a fact that is role-relevant but stale. Document both verdicts at Step 4g, listing every candidate fact and its currency-date + role-relevance-mapping.

   **Anti-pattern this replaces:** choosing Template A ("bet") because almost any company can be framed as having a "bet," then trying to inject specificity after the fact. A prior application failed this way — a generic VBC thesis used as the "bet," paired with unverified facts that were supposed to carry the specificity; both problems trace to template-first sequencing.
*(The four items this step used to carry beyond the procedure above were merged into Gate A on 2026-08-19, none dropped: Phrase Lock capabilities → **Gate A item 9**; the preferred-qualifications audit and its (a)/(b)/(c) dispositions → **Gate A item 2**; company-specific hook material and its source-traceability requirement → **Gate A item 7**; the "why now" signal and its tone/emphasis examples → **Gate A item 8**. The role-type lead-order clause folded into **Gate A item 3** and the three JD-vocabulary axes into **Gate A item 5**.)*

---

## Step 1.5: Reader Model — Who Is Reading This?

**This step synthesizes the Company Brief (Step 0.5) + JD Briefing (Step 1) + Craig's profile into a reader-facing analysis. It must be complete before Steps 2–3 begin.**

The Reader Model answers: who is the person reading these materials, what doubts will they have about Craig, who is Craig competing against, and how should the materials preempt objections? See `references/reader-modeling.md` for the full framework, field definitions, and a worked example.

### Workflow

1. **Build the Hiring Manager Persona** — four fields:
   - **Seniority estimate** (VP / Director / Senior Manager / Manager) — inferred from JD reporting structure, scope, strategic vs. execution emphasis.
   - **Company stage** (Early / Growth / Scale / Enterprise) — from Company Brief Recent Signals. Cross-reference with "Why Now" signal (Gate A item 8).
   - **Team maturity** (Building from scratch / Inheriting and scaling / Optimizing existing) — from JD language about the team and product.
   - **Reader's likely concerns** (2–3 specific doubts about Craig) — from the intersection of JD requirements and Craig's profile.

2. **Determine Competitive Positioning:**
   - Name the typical strong applicant for this role type (see `reader-modeling.md` Section 2a table).
   - Identify Craig's intersection advantage — the specific combination that the typical applicant lacks (see framework in `reader-modeling.md` Section 2b).

3. **Run the Negative Space Analysis** — for each concern from step 1:
   - Classify: **Reframe in evidence** / **Don't draw attention**. (The "Acknowledge in fit paragraph" classification was deprecated 2026-04-30 per `voice-rules/rule-26-reader-model.md` / [career coach] coaching feedback. Cover letters never narrate gaps — even those the JD explicitly raises.)
   - Document the preemption strategy: which evidence paragraph story/framing carries the structural-parallel argument implicitly, or confirmation of silence.
   - For "don't draw attention" concerns, confirm no disclosure appears anywhere in the materials. Check #23 (gap-disclosure ban) enforces this at Blocker severity.

4. **Write the Reader Model** to `/tmp/reader_model.md` in the format specified in `reader-modeling.md`.

### How downstream steps consume the Reader Model

- **Step 2 (Resume):** Team maturity refines which ANGLE of each story to foreground in bullets. Company stage and seniority shape summary register.
- **Step 3 (Cover Letter):** Reader's concerns drive evidence-paragraph framing (reframe-in-evidence story selection). Competitive positioning shapes the bridge paragraph. Seniority shapes close register. The fit paragraph focuses on positive differentiation only — no gap narrative, ever.
- **Step 5 (Verifier):** Checks #29–31 verify that the Reader Model's insights are visible in the output. Check #23 verifies no gap disclosure appears anywhere.
- **Step 8.5 (Application Answers):** "Experience with X" questions are often objection-probes; the Negative Space analysis helps recognize which objection a question targets, but the answer itself uses positive framing only — Craig's adjacent experience and concrete builds — not gap acknowledgment.

### When the Reader Model is simple

Not every application needs deep negative-space work. If Craig's profile is a strong direct match (no obvious gaps, no structural concerns), the Reader Model says so and the fit paragraph focuses on positive differentiation rather than objection preemption. Don't manufacture concerns to fill the framework.

---

## Step 1.6: JD-Vocabulary-First Resume Composition Inventory

**This step closes the resume JD-vocabulary discipline gap surfaced by Eval 24 [REDACTED COMPANY] (Session 39, 2026-05-11; v1 → v2 revision diagnostic). It runs after Step 1.5 (Reader Model) and before Step 2 (Compose Resume). Codified v6 Session 1 per `projects/job-materials-v6/CLAUDE.md` §3 RC10.**

The resume composition path starts from `craig-profile.md` mastery angles + Step 0.4 prior-letter import. There is no equivalent of Gate A item 5 (JD language mapping) for resume composition — and no equivalent of Step 4e word-by-word audit forcing JD-vocab inclusion. Cover-letter composition has both guardrails; resume has neither. Result: the resume drifts toward Craig-canonical comfort vocabulary when prior-letter context overrides JD-vocabulary discipline. Step 1.6 closes the **generative pre-composition** gap; Step 4h closes the **detective post-composition** gap (see Step 4h below); `agents/verifier-prompt.md` Skills-section audit sub-check (e) closes the **verifier-side residual** gap; Step 0.4 sub-step 3.5's "JD-vocabulary precedence" rule closes the **prior-letter-import** gap (see Step 0.4 above). Together they shift resume discipline from defensive (filter bad imports) to generative (require JD-vocab inclusion).

### Workflow

1. **Pull JD top-vocabulary surfaces from Gate A item 5 (JD language mapping).** That item already produced the JD's own words for (a) mastery angles, (b) outcome/impact register, (c) process/activity vocabulary. Step 1.6 consumes that artifact — it does not re-derive it.

2. **For each JD top-vocabulary surface, identify Craig's matching mastery angle** from `references/craig-profile.md` Angles of Mastery list (lines ~30–44; canonical 15-item inventory: B2B / Multi-tenant SaaS / 0→1 / Healthcare / HealthTech / Workflow automation / ETL / Regulated environment / Platform product / Data product / BI / Analytics / Team building / P&L ownership / Mobile-first / Product-market fit / HIPAA & GDPR). If no Angle covers the surface, document "no Craig mastery covers this — gap candidate for Step 7.5 backport" and skip placement.

3. **For each row with a Craig-mastery match, name the resume placement.** Choices: summary triplet anchor / skills line (specify category) / role bullet evidence (specify role). The placement is where the JD surface will be mirrored verbatim or near-verbatim when Step 2 produces the draft.

4. **Document the inventory in `/tmp/composer_notes.md`** in this shape:

```
## Step 1.6 — JD-Vocabulary-First Resume Composition Inventory

| JD vocabulary surface | Craig's matching mastery angle | Resume placement |
|---|---|---|
| [JD top-vocab surface 1 verbatim] | [Angles-of-Mastery item name OR "no Craig mastery covers this — gap candidate"] | [summary triplet anchor / skills line (category) / role bullet evidence (role) / skip] |
| [JD top-vocab surface 2 verbatim] | ... | ... |
[repeat per JD top-vocabulary surface from Gate A item 5]
```

5. **Coverage gate — blocking with override-line.** The composer cannot proceed to Step 2 (Compose Resume) without the inventory table filled, OR an explicit override-line documented immediately after the table:

```
No JD top-vocabulary surfaces require resume mirror — rationale: [the JD's surfaces are already covered verbatim by craig-profile.md canonical bullets without composer intervention, OR Gate A item 5 produced no JD surfaces whose Craig-mastery coverage warrants resume placement].
```

The override-line is the only acceptable empty state. The blocking-with-override pattern mirrors Step 0.4 sub-step 3.5 pre-population (added v5 Session 1, RC7 enforcement); visible-absence-of-rows is the enforcement mechanism. Step 4h (below) validates the table's placement predictions against the actual resume draft after Step 2 ships.

6. **Skipping a row requires "no Craig mastery covers this — gap candidate" documentation.** When a JD top-vocabulary surface has no Angles-of-Mastery match, the row stays in the table; do NOT silently drop rows. The gap surface is itself useful — it documents which JD vocabulary the resume legitimately cannot mirror and surfaces Step 7.5 backport candidates.

### Worked example — Eval 24 [REDACTED COMPANY] (v1 failure → v2 pass)

**v1 (Step 1.6 didn't yet exist; reconstructed retrospectively).** 8 JD top-concepts identified from Gate A item 1: knowledge-platform transformation / 300M-doc platform scale / ML and LLMs as workflow layer / grounded-attributable-trustworthy / multi-quarter platform vision / core user journeys / prospects-and-subscribers experience / AB testing + qualitative research. v1 resume mirrored ~3-4 of 8: "AB testing" + "qualitative research" via skills lines (HIT); "ML/LLM" partial via "Multi-step LLM workflow design" (PARTIAL); "prospects + subscribers" partial via composer translation "Multi-side platform product ownership (B2B + end users)" (PARTIAL). [REDACTED COMPANY]-canonical drift dominated the summary triplet ("multi-tenant SaaS data products and 0→1 platforms for B2B enterprises" — none of those four phrases appear in the [REDACTED COMPANY] JD) and the outcome triplet ("adoption, retention, and revenue outcomes at platform scale" — [REDACTED COMPANY] JD's vocabulary is "core user journeys").

**v2 (post-Craig-pushback; would-have-been Step 1.6 output):**

| JD vocabulary surface | Craig's matching mastery angle | Resume placement |
|---|---|---|
| "platform features" | Platform product | summary triplet anchor + skills category "Platform Features & Knowledge Products" |
| "knowledge platform" / "active knowledge building" | Data product | skills line "Platform features for prospects + subscribers" |
| "zero-to-one transformation" | 0→1 | summary triplet anchor "zero-to-one product surfaces" |
| "grounded, attributable, trustworthy" | (no direct Angle; defensible composer characterization within JD scope per Rule 28 source class composer-interp marked) | summary outcome triplet "trustworthy workflows" |
| "core user journeys" | Product-market fit + Analytics | summary outcome triplet "core user-journey success" |
| "prospects and as subscribers" | B2B + Multi-tenant SaaS | skills line "Platform features for prospects + subscribers" |
| "users rely on and return to" | Product-market fit | summary "users rely on and return to" (JD verbatim) |
| "AB testing + qualitative research" | Analytics + Discovery | skills lines "Experimentation & A/B testing" + "Discovery & user research" |

v2 coverage: 8 of 8 JD top-concepts mirrored. **The cross-domain failure mode (B2B → consumer; healthcare-[REDACTED COMPANY] → consumer-prosumer-[REDACTED COMPANY]) is the most drift-prone composition pattern** because prior-letter vocabulary imports concepts that misread the new product geometry. Step 1.6's generative pre-composition gate forces JD-vocab pull before Step 2 begins, eliminating the drift surface.

### Cost calibration

This step is fast — ~5–10 minutes. The 6–10-row inventory consumes Gate A item 5's output (already produced) and matches against the 15-item Angles of Mastery list (small, fixed lookup). The cost is justified by every drift recurrence Eval 24 v1 → v2 would otherwise repeat.

### Why this step exists

Eval 24 [REDACTED COMPANY] v1 surfaced that resume composition discipline is **defensive** (Step 0.4 sub-step 3.5 filters bad [REDACTED COMPANY] imports) without a **generative** complement (no rule requires JD-vocab inclusion at composition time). The cover letter has Step 1 vocabulary mapping + Step 4e word-by-word audit forcing JD-anchored composition; the resume has neither. Step 1.6 closes the asymmetry at the pre-composition layer; Step 4h (below) closes it at the post-composition layer; sub-check (e) in `agents/verifier-prompt.md` closes the verifier-side residual.

---

## Step 2: Compose the Resume

Use `voice-rules.md` as the prescriptive guide. Key sections to follow:

- **Summary Construction** — 2–3 sentences, mastery-angle driven, JD vocabulary, no self-descriptors, no PM-voice. See `exemplars.md` Canonical Summary Examples for role-type-specific patterns. **After drafting the summary, run Gate F (Summary Banned-Phrase Scan) AND Gate G (Summary Mastery-Angle Traceability + Scope-Accuracy) from `qa-checklist.md` before finalizing.** Gate F is mechanical (pre-flight banned-phrase scan); Gate G is verifier-side semantic (every triplet entry must trace to a specific `craig-profile.md` Angles of Mastery list item without JD-vocabulary translation broadening Craig's scope beyond his actual role coverage). Gate G was added v5 Session 2 (2026-05-06) per RC9 codification of Eval 20 v2 [REDACTED COMPANY] ambulatory-overreach.
- **Rule 13 (Standardized Resume Role Structure)** — 3-bullet problem/products/outcomes for every role; canonical opening verbs per role (see `voice-rules/rule-12-cover-letter-tone.md` Canonical Role-Lead Verbs table).
- **Rule 9 (Resume Formatting Rules)** — bullets end with period, italic descriptions end with period, dates right-aligned, bullets verbatim from `craig-profile.md`, CentralReach EHR framing rules.
- **Rule 14 (Non-Healthcare Translation)** — apply the standing translation table ONLY when the role is outside healthcare/healthtech. For healthcare roles, use canonical bullets verbatim.
- **Rule 15 (Strategic Bolding)** — bold metrics and key product/surface terms; density minimal in problem bullets, heavier in outcome bullets.
- **Rule 7 (Skills Section — Two-Gate Qualification)** — every skill passes Gate 1 (mastery narrative) OR Gate 2 (JD word-for-word). No default fillers. **Before generating the skills section, run Gate E (Skills Pre-Generation Scan) from `qa-checklist.md`.**
- **Rule 7 "JD-alignment for resume positioning signals" subsection (was Rule 22 before v3 Session 3 consolidation)** — summary triplet and every skills line must map to a JD concept from the Step 1 briefing.

---

## Step 2.5: Skills-Section Strict Per-Line Two-Gate Audit

**This step closes the recurring skills-section drift pattern surfaced across 5 consecutive evals (Eval 21 [REDACTED COMPANY] / Eval 22 [REDACTED COMPANY] / Eval 24 [REDACTED COMPANY] / Eval 25 [REDACTED COMPANY] / Eval 26 [REDACTED COMPANY]). Codified v7 Session 1 per `projects/job-materials-v7/CLAUDE.md` §3 H.1. Runs immediately after Step 2 (Compose the Resume) and before Step 3 (Compose the Cover Letter).**

Step 1.6 (pre-composition JD-vocab inventory) and Step 4h (post-composition JD-vocab coverage) both audit JD-vocabulary coverage, and Step 0.4 sub-step 3.5 audits prior-letter import discipline. None of those steps audit each rendered skills line individually against the strict Two-Gate test at the composition-output transition. Step 2.5 adds that missing audit step. The discipline does not survive composition without a per-line strict audit between resume draft and cover-letter composition.

### Workflow

1. **Read the resume skills section produced in Step 2.** Identify each skill line and its category. The audit is per-line, not per-category.

2. **For each skill line, apply the strict Two-Gate test in this order:**
   - **Gate 2 (JD verbatim/near-verbatim) — preferred path.** Quote the JD trigger phrase that the skill line mirrors. If the JD does not contain the trigger phrase verbatim or in a near-verbatim form (single-word stem variants like "automate" → "automation" are acceptable; concept restatements like "user research" → "discovery" are NOT acceptable when only "discovery" is in the JD), Gate 2 fails. Move to Gate 1.
   - **Gate 1 strict "for THIS role" test — fallback path.** Per Rule 7 v7 strict test (`voice-rules/rule-7-skills-two-gate.md`), Gate 1 requires both (i) Craig has the mastery AND (ii) the mastery is genuinely differentiating for the target role-type. The "Director-of-Anything" diagnostic test applies: would this line be written for a Director-of-Anything role? If yes, Gate 1 fails. Generic-mastery defenses ("Craig has done discovery work") do NOT pass Gate 1 strict — the defense must cite the specific role-type elevation ("this is differentiating for a back-office RCM PM role because…").

2a. **JD-Triggered-Specific pre-screen — apply this to every skill line BEFORE the item-2 Two-Gate test (added 2026-05-21, `projects/job-materials-resume-positioning-audit/` OC3; the reservoir definition below was ruled by Craig 2026-08-20, `job-search-continued` S26, and codified S27).**

   **The reservoir is the set of entry *names* in `references/craig-profile.md` § "JD-Triggered Specifics (include ONLY if JD explicitly asks)."** A rendered skill line is a *JD-Triggered Specific reservoir item* if it **matches an entry name**, or if it is a **recorded rename** of one into the JD's vocabulary per `voice-rules/rule-7-skills-two-gate.md` half (ii). The rename counts only when the source entry is named in the Step 2.5 audit row — an *unrecorded* rename is not a reservoir item, and the Gate-1 rescue opens for it.

   **`references/jd_triggered_specifics.json` is a DERIVED INDEX, not the definition.** It is what `scripts/preflight_check.py` Check #40 reads in order to detect mechanically. An entry's absence from the JSON is an **index gap**, never evidence that the credential sits outside the reservoir. Do not cite the JSON as the enumeration of what the reservoir contains — the prose entries are the enumeration, and the file says so itself in the *Structured Gate-2 trigger reference* note that opens `craig-profile.md` § JD-Triggered Specifics. *(Cited by section, not line number: `craig-profile.md` is edited nearly every session, and this skill retired line-numbered pointers into it for exactly that reason — see the 2026-08-19 segment in `jd_triggered_specifics.json` `$maintenance_notes`.)*

   **Evidence prose inside an entry is NOT the reservoir.** A phrase that merely occurs somewhere in an entry's evidence sentences does not make a line a reservoir item. Such a line is **not cleared** — it falls through to the item-2 strict Two-Gate test with Gate 1 strict applying in full (the "Director-of-Anything" diagnostic, the ban on generic-mastery defenses, the requirement to cite specific role-type elevation). What reservoir classification removes is only the *Gate-1 fallback path*.

   **What an ENTRY is** — the atom, ruled 2026-08-20; the **five** boundary cases were settled against the live file at S27 and each one is load-bearing:
   - A **bolded label** followed by a credential restatement and an **inclusion gate**. The gate counts **in any form**: the inline *"Include when JD…"* clause most entries carry, a gate stated in an adjacent blockquote (as `Gen AI application & agent architecture` does), or a named inclusion-threshold block (as `Spec writing & PRD authoring` does). Do not require one literal phrasing. Measured 2026-08-20: two entries carry no `Include` clause on the label line at all — `Gen AI application & agent architecture` (gate carried in the `⚠️ What that repo IS` blockquote directly beneath its label, not on the label line) and `Spec writing & PRD authoring` (gate in its TWO-GATE inclusion-threshold block) — and a third, `Clinical coding standards`, uses the variant *"Include ONLY when the JD explicitly names…"*. All three are real entries; a literal-phrasing test would eject them on formatting alone.
   - **Every item inside a bare category line is itself an entry.** `**Tools & methodologies:** Jira · Confluence · Agile/scrum delivery` is **three** entries; `**Technical specifics:** Selenium · BeautifulSoup · Web scraping pipelines · NFC-based authentication · Apple Pay / Google Pay integration · Mobile offline capabilities` is **six**. This clause is what preserves OC3 (2026-05-21): those nine are the canonical reservoir examples, none of them is a bolded label, and without this clause a Gate-1 "standard delivery toolchain" defense becomes reachable for `Jira · Confluence · Agile/scrum delivery` — the exact drift OC3 closed.
     **A `·`-separated enumeration counts wherever it sits, including inside the label's own parentheses** (ruled 2026-08-20, S27). `**Customer feedback channels (site visits · UAT · win/loss · support issues):**` is therefore **four** entries plus its label, not one — the parenthetical-drop rule in the matching test below is for *tool-list qualifiers* like `(Power BI, Tableau)`, and must never erase an enumeration of distinct credentials. Currently the only instance in the section; the shape, not the line, is what this clause governs.
   - **Each credential named inside an entry's licensing block is covered by that host entry** — the block whose header is `**What this entry licenses:**` **or** `**What this licenses:**` (measured 2026-08-20: 9 blocks use the first form, 19 the second, so keying on either string alone implements this clause for a minority of entries), inheriting the host's Gate-2 triggers. That block exists to enumerate what the entry authorizes, so a line matching a credential it names is a reservoir item. **Form does not matter — 27 of the section's 28 licensing blocks are inline prose and only one is bulleted** (measured 2026-08-20), so a bullets-only reading would implement this clause for a single entry and silently drop the rest.
   - **NOT an entry:** any other sub-block — `**What it does NOT license:**`, `**Provenance + confidence boundary…**`, `**Boundary…**`, write-time back-tests, relaxation audits, locus-precision notes. These *describe* an entry; they are not one.
   - **NOT entry territory at all:** everything from the section's first `####` subsection onward. Both tail subsections disclaim entry status in their own text — `Documented non-credentials & disambiguation` enumerates credentials Craig **declined** (Azure/AWS/GCP, WCAG-sense accessibility), and `Label-only gaps` enumerates *routes* to evidence held elsewhere ("a **route**, not a credential: no new claim is made, no skills line is added"). Reading either as a reservoir entry would make the file license exactly what it refuses.

   **⚠️ The index is not a subset of the definition, and the gap runs in the loose direction — a Check #40 flag is NEVER cleared by an item-2a classification.** Check #40 matches `presence_substrs`, which are looser than the head-noun test below: measured 2026-08-20, **18 rendered lines across the archived résumés fire Check #40 while classifying non-reservoir under this section's test**. That asymmetry must never become an escape hatch. If Check #40 fires, disposition the flag on its own terms; "item 2a says this isn't a reservoir item, so Gate 1 is open again" is **not** an available move. The derived-index relationship licenses exactly one inference — *absent from the JSON → still possibly reservoir* — and never its converse.

   **What MATCHES an entry name.** An entry has **two comparable names** — its bolded **label** and the **credential restatement** that follows it — and they diverge in 22 of the section's entries (label `Clinical coding standards` / restatement `ICD-10 & CPT coding standards`; label `Business & commercial` / restatement `ROI models & business case development`). **A line matching *either* is a reservoir item.** Compare **head noun phrases**, ignoring parenthetical tool lists and their order; a conjoined name `X & Y` also matches on `X` alone or on `Y` alone. So `Product roadmap development` matches `Product roadmap development & ownership`, and `Cohort analysis` matches `Funnel & cohort analysis`. This is what resolves `BI dashboard development`, which renders in three different spellings across the skill — all three match, so the line is reservoir under any of them.

   **Census — 70 entry names, updated 2026-08-26 (S31) by verified delta, not by re-derivation:** 57 labelled entries + 13 bare-category items (9 from the two post-colon category lines, 4 from the parenthetical enumeration at `Customer feedback channels`), across `craig-profile.md` § JD-Triggered Specifics down to its first `####` subsection. Against the JSON's **54** rows, **0 rows are orphaned** under this matching test. *(Lineage: 62 / 46 at S27 → 63 / 47 at S28 when `Usability testing` was backported → 64 / 48 at S29 when `Demand forecasting & capacity/supply modeling` was → 65 / 49 at S30 when `Clinical decision support` was backported, then **66 / 50** when a Pass-1 verifier caught `Charge capture`, then **68 / 52** when a Pass-3 verifier caught `Product lifecycle management` and `Responsible & trustworthy AI` — **four backports in one application, three of them surfaced by verifiers rather than by the composer, and two of those in the UNDER-claiming direction.** That asymmetry is the S30 signal: the composer's Step 2.5 audit is better at catching over-claims than omissions. Then **70 / 54** at S31 (2026-08-26, Mars Veterinary Health) when `Performance feedback & evaluation` and `Team resource allocation & capacity assignment` were backported — **both caught by the composer at Step 2.5 item 2c and both asked BEFORE the v1 draft**, which is the first application on record to close its ASK-CRAIG set pre-composition rather than mid-gauntlet. Note what made the first of the two findable at all: § `Team leadership & hiring` had **affirmatively excluded** performance review in a "does NOT license" clause, so the corpus was not merely silent — the same shape that made `Usability testing` unclearable quietly at S28.)* **The three S30 block-level declines — PLG as a named growth motion, e-prescribing/CPOE, and the ambulatory regulatory & quality programs cluster — are NOT counted**, for the same reason S29's two are not: they live under the `####` subsection, which item 2a places outside entry territory. *(S30 recorded a **fourth** decline, patient collections, but as a scope boundary inside the `Charge capture` entry's "What it does NOT license" rather than as a block entry — which is why session records say four declines and this census says three. Both are correct at their own scope; do not reconcile them by changing a number.)* ⚠️ **How this figure was obtained, because it matters:** the **delta is directly verified** (**two** labelled entries added at S31; JSON row count read from the file as **54**). *(This clause read "four labelled entries added … as **52**" until 2026-08-26 — S30's delta and S30's row count, left standing inside the very line S31 updated to 70/54. Caught by the S31 closing verifier, **after** that session's write-sideways sweep had already declared "No stale claim left standing." The lesson is about sweep granularity: the sweep matched and corrected three figures on this line and missed a fourth in the same sentence, because a line-level grep reports a line as handled once any hit on it is fixed. **Sweep to the figure, not to the line.**)* ⚠️ **Read that row count from the `items` array, not from the parsed root:** the top-level object also carries three `$`-prefixed metadata keys, so a bare `len(json.load(f))` returns **4** and looks like a catastrophic regression. (Hit live at the S30 seal.) The **absolute** count is S28's measured baseline (**63 / 47**) plus the **cumulative** S29+S30+S31 delta of **7** — 63+7=**70**, 47+7=**54**. *("That delta" read as the single-session delta until 2026-08-26 and did not compute; the arithmetic is now explicit. S31 cold pass.)* — an independent mechanical re-derivation was attempted at S29 and **did not reproduce cleanly** (a sub-block-excluding regex returned 51 labelled against 51 inclusion-gate occurrences only after hand-tuning the exclusion list, and returned 53 before). The five boundary cases in item 2a need judgment a regex does not encode, so the absolute figure still rests on the S27 hand methodology. **The two S29 non-credentials (A/B testing, laboratory workflows) are NOT counted** — they live under the `####` subsection, which item 2a places outside entry territory.* Re-measure rather than trusting this count; it has moved before, and *a nil re-grep is evidence about the search set, never about the file.*

   **⚠️ Scope — this pre-screen's "reservoir" is NARROWER than Rule 7's, and the two must not be merged.** `voice-rules/rule-7-skills-two-gate.md` uses *reservoir* for **both** Gate-2 candidate sources — JD-Triggered Specifics entries **and** `career-narratives.md` **Layer 1 details** — because its job there is **Gate-2 standalone sufficiency**, for which both are pre-sourced. **Item 2c below keys to THIS pre-screen's narrow sense, not to rule-7's** ("not a reservoir item (item-2a pre-screen = N)"), so a Layer 1 detail is N for item 2c and does owe a named locus — which it trivially satisfies, since the Layer 1 detail *is* a valid locus. Do not read rule-7's wider sense as an item-2c exemption; it is not one. **This pre-screen's auto-DROP attaches only to JD-Triggered Specifics entry names and their recorded renames.** A Layer 1 detail the JD does not name is **N** here: it falls to the item-2 Two-Gate test with Gate 1 strict available, and is **not** categorically dropped. Carrying Rule 7's wider sense into this pre-screen would silently extend a no-appeal DROP over the whole narrative corpus. *(Flagged by the S27 closing verifier as a latent collision. A third, unrelated sense also exists — `exemplars.md` uses "reservoir" for a pool of canonical breadcrumb text — so read the word's scope from its host file, never by assumption. No live line is disposed differently today; this note is what keeps that true.)*

   For every line flagged Y (reservoir item):
   - **If the JD names the reservoir item verbatim** (Gate 2 fires) → KEEP is permitted; proceed to the item-2 Two-Gate test as normal.
   - **If the JD does NOT name the reservoir item** → **the line cannot KEEP. Disposition it DROP (default), or REPLACE only if a genuinely stronger Gate-2-clearing line exists for this JD (per item 4). The Gate 1 strict "for THIS role" fallback path is NOT available for reservoir items.** A generic "legitimate technical foundation" / "standard delivery toolchain" Gate-1 defense must NOT rescue the line. Rule 7's Fluff list bans "'JD-Triggered Specifics' reservoir items unless the JD names them by name" — that ban is categorical and overrides any Gate-1 mastery defense. The pre-screen exists because a reservoir item, by definition, is a real Craig capability; its Gate-1 mastery defense will always sound plausible, which is exactly why Gate 1 must be disabled for it.

   This closes the Eval 31 [REDACTED COMPANY] drift (worked example below): a JD-Triggered Specific the JD did not name was KEEP-dispositioned via a Gate-1 "technical foundation" defense because the per-line table had no reservoir-item pre-screen.

   - **⚠️ ONE carve-out from the auto-drop — the data-foundation proportionality rule (Craig's ruling, 2026-08-18).** It covers **exactly three lines — SQL, Python, and BI dashboard development (Power BI / Tableau / Looker)** — and nothing else; every other reservoir item stays under the flat auto-drop above. Canonical statement: `voice-rules/rule-7-skills-two-gate.md` § "The data-foundation proportionality rule."

     **When the Gate A item 3 role-type classification is one of the three data role types** — *Healthcare Platform + Analytics*, *Clinical Data + EHR Infrastructure*, *Platform + Data + Intelligence* (**not** *0→1 Startup*, **not** *Healthcare Edtech*) — **the automatic DROP is lifted for those three lines.**

     **Lifting the drop is not inclusion.** Do not read "data role type" as "render all three." Select the subset **proportionate to how central data tooling is in this JD**, judged on JD evidence only: required vs. preferred quals, how many distinct tooling terms the JD names, and whether the role's core deliverables are framed around data work. **All three, some, or none are legitimate** — and **none** is correct when the JD mentions tooling only incidentally. "Craig has the mastery" remains banned as a defense here, exactly as above.

     **Why it keys on Gate A item 3 and not on a fresh defense:** the role type is recorded *upstream, before this step runs*. A judgment re-derived at skills-line time is indistinguishable from the Gate-1 permissiveness OC3 closed. This is a named-cohort carve-out, not a reopening of Gate 1.

     **Record every one of the three, including the negative** — a row in the table below citing the JD evidence, and an **explicit written disposition when the answer is "none,"** so a deliberate omission reads as a decision rather than an oversight. On a data role type `preflight_check.py` Check #40 **flags rather than clears** these lines: it cannot adjudicate proportionality and does not try. The verifier confirms the recorded defense exists (`agents/verifier-prompt.md` skills sub-check).

2b. **Modifier-level audit for compound skill lines — apply this in addition to the item-2 Two-Gate test (added 2026-05-21, `projects/job-materials-resume-positioning-audit/` OC2).** A *compound skill line* carries more than one content modifier — the shape "[modifier], [modifier] [head-noun]" (e.g., "Consumer-facing, mobile-first product development") or "[modifier] [modifier] [head-noun]". The item-2 Two-Gate test applied at the line level can pass a compound line on ONE qualifying modifier while a second, non-JD modifier rides along unaudited. For every compound line, audit **each content modifier independently**: each content modifier must clear Gate 2 (the JD names it verbatim/near-verbatim) OR Gate 1 strict ("for THIS role"), or the modifier is cut. A *content modifier* is an adjective or qualifier that narrows the head-noun's meaning ("mobile-first," "consumer-facing," "multi-tenant," "regulated-B2B"); structural/grammatical words (articles, conjunctions, prepositions) are not content modifiers. When a content modifier fails both gates, the line's disposition is REPLACE — the replacement is the line with the failing modifier(s) removed; the head-noun and every gate-clearing modifier stay. This closes the Eval 32 [REDACTED COMPANY] drift (worked example below): "Consumer-facing, mobile-first product development" passed the line-level Two-Gate test on "consumer-facing" while "mobile-first" — with no JD trigger — rode along.

2c. **Source-citation requirement for non-reservoir lines — apply after the item-2 Two-Gate test (added 2026-08-06, `job-search-continued` S5, from `evals/eval-41-mcg.md`).** A line that clears Gate 2 but is **not** a reservoir item (item-2a pre-screen = N) must additionally name a **specific locus in `craig-profile.md` or `career-narratives.md`** that supports the claim — a role bullet, an Angle of Mastery, or a narrative detail. Reservoir items are exempt: they are pre-sourced by construction, and Rule 7's Gate-2 standalone-sufficiency clause governs them unchanged.

   **A locus must be an experience record — the skills catalog is NOT a locus.** `craig-profile.md`'s "Skills — Organized by Mastery Angle" section is a catalog of skill *strings*, including the very strings a composer writes into a skills section. Citing it proves only that the phrase has been written before, not that Craig did the thing. Valid loci are role bullets, Angles of Mastery, JD-Triggered Specifics entries, and `career-narratives.md` narrative details. A citation that resolves to the skills catalog does not satisfy item 2c.

   **Apply at modifier granularity wherever item 2b applies.** On a compound line, a locus supporting one modifier does not source the others — audit each content modifier independently, exactly as item 2b does for gates. Otherwise a sourced modifier launders an unsourced one past both checks.

   **Grep both reference files before concluding a locus is absent, and record the strings you searched.** "I didn't see one" is not a finding; `grep -i 'authoriz' references/craig-profile.md references/career-narratives.md` → 0 hits is.

   **When no locus exists, the disposition is ASK-CRAIG — never DROP.** An unsourced claim is **unverified, not false**. Ask Craig directly; on confirmation, backport the credential into `craig-profile.md` with a confidence boundary before the application ships. Do **not** silently revert to the sourced-but-narrower phrasing: at [REDACTED COMPANY] (2026-08-05) three lines fired this way and **all three were real**, every one of them among the JD's stated qualifications. Narrowing the materials costs genuine credentials exactly as over-claiming invents fake ones (Craig, 2026-08-05). If Craig is unavailable and the application must ship, cut the line **and tell him what was cut and why** — never cut silently.

   The paired verifier-side enforcement is `agents/verifier-prompt.md` skills sub-check (a); the rule is `voice-rules/rule-7-skills-two-gate.md` ("Non-reservoir lines do not get standalone sufficiency").

3. **Document the audit in `/tmp/composer_notes.md`** in this shape:

```
## Step 2.5 — Skills-Section Strict Per-Line Two-Gate Audit

| Skill line | JD-Triggered Specific reservoir item? (Y/N) | Gate 2 (JD verbatim/near-verbatim)? | If Gate 2 fails: Gate 1 PROVE for THIS role (not just "Craig has mastery") — NOT available for reservoir items | If non-reservoir: named source locus (craig-profile.md / career-narratives.md) | Compound line — does each content modifier independently clear a gate? | Disposition |
|---|---|---|---|---|---|---|
| [skill line 1] | Y / N | yes (JD: "[verbatim trigger]") / no | n/a / [defense: differentiating for THIS role-type because X] / n/a — reservoir item, no Gate-1 override | n/a — reservoir item / [locus: craig-profile.md "[section]" → "[quoted phrase]"] / NONE — searched: `[grep strings]` → 0 hits | n/a (single content term) / [per-modifier: "[modifier A]" Gate 2 ✓ (JD: "...") ; "[modifier B]" no gate ✗ → cut] | KEEP / DROP / REPLACE / ASK-CRAIG |
[repeat per skill line]
```

4. **Apply default disposition: DROP unless explicit gate citation.** The disposition column must show one of:
   - **KEEP** — Gate 2 fires with explicit JD trigger quoted OR Gate 1 fires with "for THIS role" defense citing the role-type / specific JD elevation. A JD-Triggered Specific reservoir item (item-2a pre-screen Y) KEEPs ONLY when Gate 2 fires — its JD trigger is named verbatim in the JD; it can never KEEP on a Gate-1 defense.
   - **DROP** — neither gate fires with the strict test (Gate 2 no JD trigger AND Gate 1 defense is generic-mastery-not-role-specific). Also: any reservoir item the JD does not name (automatic, per the item-2a pre-screen — no Gate-1 override).
   - **REPLACE** — Gate 2 fails, Gate 1 weak, BUT a stronger Gate 2 alternative exists for this JD (cite the alternative line + its JD trigger). REPLACE also covers a compound line where a content modifier failed the item-2b modifier-level audit — the replacement is the line with the failing modifier(s) removed (head-noun and gate-clearing modifiers retained).
   - **ASK-CRAIG** (added 2026-08-06) — the line is non-reservoir, Gate 2 fires, and the item-2c search found no supporting locus in either reference file. The claim is **unverified, not false**. Ask Craig; on confirmation backport to `craig-profile.md` with a confidence boundary, then the line KEEPs. This disposition is **not** a soft DROP and must never be resolved by quietly narrowing the line.

5. **Blocking-with-override gate.** The composer cannot proceed to Step 3 (Compose the Cover Letter) without the per-line audit table filled, OR an explicit override-line documented immediately after the table:

```
All N skill lines pass strict per-line Two-Gate audit — no DROP / REPLACE actions needed.
```

The override-line is the only acceptable empty state. Visible-absence-of-rows is the enforcement mechanism (mirrors Step 0.4 sub-step 3.5 + Step 1.6 patterns).

6. **Execute DROP / REPLACE / ASK-CRAIG dispositions before Step 3.** If any line in the table received DROP, remove it from the resume. If any line received REPLACE, swap the original line for the stronger Gate 2 alternative cited in the defense column. **If any line received ASK-CRAIG, raise it with Craig before the application ships** — surface all such lines together in one question rather than one at a time, quoting the JD trigger and the search that came back empty. On confirmation, backport to `craig-profile.md` with a confidence boundary and the line KEEPs; on a "no," DROP it. An ASK-CRAIG line may not ship unresolved and unmentioned. Re-render the resume after edits. The skills section that ships is the post-Step-2.5 version, not the Step 2 draft.

### Worked example — Eval 26 [REDACTED COMPANY] (v1 failure → v2 pass)

**v1 (Step 2.5 didn't yet exist; reconstructed retrospectively).** Resume Category 4 ("Workflow Automation & Discovery") shipped with 2 lines: "Workflow automation in regulated B2B" + "Product discovery." Craig caught both gaps post-v1 review: (a) "Product discovery" failed Gate 2 ([REDACTED COMPANY] JD doesn't name "discovery / user research / customer interviews / validation / build-measure-learn"), (b) "Product discovery" failed Gate 1 strict ("for THIS role" — back-office RCM isn't discovery-heavy; Director-of-Anything would write this line), (c) Category 4 was sub-threshold at 2 lines.

**v2 (post-Craig-feedback; would-have-been Step 2.5 output for Category 4):**

| Skill line | Gate 2 (JD verbatim/near-verbatim)? | If Gate 2 fails: Gate 1 PROVE for THIS role | Disposition |
|---|---|---|---|
| Workflow automation in regulated B2B | yes (JD: "workflow automation" + "regulated") | n/a | KEEP |
| Product discovery | no (JD doesn't name discovery / user research / customer interviews / validation) | weak — "Craig has done discovery work" is generic-mastery; back-office RCM PM role isn't discovery-heavy; Director-of-Anything diagnostic FAILS | REPLACE → "Spec writing & PRD authoring" (Gate 2 fires twice: JD "Translate complex healthcare financial and operational requirements into clear, actionable product requirements" + "Develop detailed user stories, acceptance criteria, and technical requirements") |
| [post-REPLACE composer also adds] Data integrity & quality as a product concern | yes (JD: "data integrity" + "accurate, compliant" + "regulatory requirements") | n/a | KEEP |

v2 Category 4 final: 3 lines, all Gate 2 verbatim. The strict per-line audit forces the REPLACE disposition + the category-size re-evaluation (which Step H.5 sub-check (f) makes mandatory at the verifier layer).

*(This v7 worked example uses the pre-2026-05-21 4-column table. Under the current 6-column schema: "Workflow automation in regulated B2B" is a reservoir item — pre-screen Y — but Gate 2 fires, so KEEP is permitted; "Product discovery" is also a reservoir item — pre-screen Y — and the [REDACTED COMPANY] JD does not name discovery, so the item-2a pre-screen independently forbids its Gate-1 KEEP, reaching the same REPLACE outcome the v7 line-level audit reached. Neither line is a compound line. The two Eval 31/32 worked examples below use the current 6-column format.)*

### Worked example — Eval 32 [REDACTED COMPANY] (modifier-level audit, OC2)

> **Format note:** the tables in the two worked examples below are in the **pre-2026-08-06 six-column format** — they predate the source-locus column added by item 2c. They are preserved as historical worked examples. **Copy the template in item 3 above, not these**, when producing an audit table.

**v1 (line-level audit only; reconstructed).** Resume skill line "Consumer-facing, mobile-first product development" — the line-level Two-Gate test fired Gate 2 on "consumer-facing" ([REDACTED COMPANY] JD: "developing consumer or patient-facing solutions") and KEPT the whole line. "mobile-first" rode along: "mobile" and "mobile-first" appear nowhere in the [REDACTED COMPANY] JD.

**v1.1 (post-Craig review; would-have-been Step 2.5 output with the item-2b modifier-level audit):**

| Skill line | JD-Triggered Specific reservoir item? (Y/N) | Gate 2 (JD verbatim/near-verbatim)? | If Gate 2 fails: Gate 1 PROVE for THIS role — NOT available for reservoir items | Compound line — does each content modifier independently clear a gate? | Disposition |
|---|---|---|---|---|---|
| Consumer-facing, mobile-first product development | N | yes (JD: "consumer or patient-facing") | n/a | "consumer-facing" Gate 2 ✓ (JD: "consumer or patient-facing") ; "mobile-first" no gate ✗ (JD names neither "mobile" nor "mobile-first") → cut | REPLACE → "Consumer-facing product development" |

The modifier-level audit forces the REPLACE: the failing modifier "mobile-first" is cut; the head-noun "product development" and the gate-clearing modifier "consumer-facing" stay. The line still clears Gate 2 on "consumer-facing."

### Worked example — Eval 31 [REDACTED COMPANY] (JD-Triggered-Specific pre-screen, OC3)

**v1 (no pre-screen; reconstructed).** Resume skill line "Jira, Confluence & Agile/scrum delivery" — the Step 2.5 line-level audit dispositioned it KEEP via a Gate-1 "standard delivery toolchain, legitimate technical foundation" defense. Jira, Confluence, and Agile/scrum are all `craig-profile.md` JD-Triggered Specifics reservoir items; the [REDACTED COMPANY] JD names none of them.

**v1.1 (post-Craig review; would-have-been Step 2.5 output with the item-2a pre-screen):**

| Skill line | JD-Triggered Specific reservoir item? (Y/N) | Gate 2 (JD verbatim/near-verbatim)? | If Gate 2 fails: Gate 1 PROVE for THIS role — NOT available for reservoir items | Compound line — does each content modifier independently clear a gate? | Disposition |
|---|---|---|---|---|---|
| Jira, Confluence & Agile/scrum delivery | Y (Jira, Confluence, Agile/scrum are all craig-profile.md JD-Triggered Specifics) | no (Counterpart JD names none of "Jira" / "Confluence" / "Agile" / "scrum") | n/a — reservoir item, no Gate-1 override permitted | n/a | DROP |

The pre-screen forces the automatic DROP: a reservoir item the JD does not name cannot be rescued by a Gate-1 "technical foundation" defense. ("Agile/scrum delivery" is treated as a JD-Triggered Specific under either source file as of 2026-05-21 — see the OC3 `craig-profile.md` ↔ `rule-7-skills-two-gate.md` reconciliation: "Agile" was removed from Rule 7's no-trigger "legitimate technical foundation" list, leaving SQL / Python / named BI tools.)

### Cost calibration

This step is fast — ~5-10 minutes for a typical 12-16-line skills section. The per-line audit reuses Gate 2 evidence already captured in Step 1.6 (JD vocabulary surfaces) and Gate A item 5 (JD language mapping). Cost is justified by every drift recurrence Evals 21 / 24 / 26 v1 → v2 would otherwise repeat — each costs Craig a post-delivery review cycle + revision ship.

### Why this step exists

Five consecutive evals (21 / 22 / 24 / 25 / 26) surfaced post-delivery skills-section drift despite multiple targeted codifications at the input layer (Step 0.4 sub-step 3.5), inventory layer (Step 1.6), coverage layer (Step 4h), and verifier residual layer (sub-check (d), sub-check (e)). The pattern is structural — the discipline does not survive composition without a strict per-line audit step at the composition-output transition. Step 2.5 closes that structural gap by forcing the composer to walk each rendered line and answer the strict Two-Gate test before the resume ships. Default disposition DROP eliminates the asymmetric permissive bias documented in v7 project plan §2 Failure Mode 1.

**Hardened 2026-05-21 (`projects/job-materials-resume-positioning-audit/`):** the item-2a JD-Triggered-Specific pre-screen (OC3) and the item-2b modifier-level audit (OC2) close two residual channels the v7 line-level audit left open — a reservoir item rescued by a Gate-1 defense (Eval 31 [REDACTED COMPANY]) and a non-JD content modifier riding inside an otherwise-Gate-2 compound line (Eval 32 [REDACTED COMPANY]). Both are line-level-audit blind spots: the v7 audit dispositioned the LINE as a unit, so a sub-line element (a reservoir item's plausible mastery defense, a second modifier) could pass unaudited.

---

## Step 3: Compose the Cover Letter

**Pre-generation ritual — exemplars/voice-rules staleness audit.** Before drafting the hook or any prose that uses an exemplars.md template, spot-check that any template you're about to use has not been superseded by a voice-rules rule added after the exemplar was written. Specifically: (a) skim the banned-patterns lists in `voice-rules/rule-12-cover-letter-tone.md` and `voice-rules/rule-23-hook-paragraph.md`; (b) check that no banned pattern is present in the exemplars.md template or its surrounding canonical text. If staleness is detected, flag it to Craig before using the template — do not silently work around it.

This ritual exists because rules are added continuously and exemplars have historically lagged. Session 21 ([REDACTED COMPANY]) surfaced that exemplars.md Template A's 3-sentence structure contained a negation-contrast S2 banned by Rule 12 added earlier but not propagated. The meta-rule is: rules and exemplars must stay in sync, and the composer is responsible for verifying sync at generation time.

Structure (5–6 paragraphs, ~350–450 words):

1. **Hook** — use the hook angle determined in Step 1 (which may follow a Template A/B/C pattern from `exemplars.md`, or a company-specific structure that emerged from the Company Brief). The hook must reference at least one company-specific fact from the Company Brief that would not be knowable from the JD alone. Connect the company's situation to the product problem Craig solves.
2. **Bridge** — one concrete sentence naming the shared win condition of Craig's work. Do NOT enumerate product areas as a list — see `voice-rules/rule-12-cover-letter-tone.md` "Product-area enumeration discipline" sub-section and `qa-checklist.md` Check #9 Product-area enumeration sub-check.
3. **Evidence** (1 paragraph, sometimes 2) — lead with the role whose metrics best answer the JD's core ask. Max 2 roles per paragraph. Every role gets (a) problem/situation setup, (b) product/decision sentence, (c) at most one outcome clause. Weave 1–2 Layer 1 breadcrumbs from `career-narratives.md` per evidence paragraph — never more. Breadcrumbs must pass the four gates in `voice-rules/role-type-targeting.md` Breadcrumb Strategy section (JD hook / makes mastery concrete / reads natural / context-present).
4. **Fit + Differentiation** — what makes Craig specifically well-suited at the intersection of platform thinking, data/analytics, and healthcare domain context. **Never acknowledge a domain gap here — positive framing only.** `voice-rules/rule-2-fhir-hl7.md`: *"The cover letter NEVER acknowledges the FHIR/HL7 gap, even when the JD lists FHIR/HL7 as required."* `voice-rules/rule-16-ai-ml-framing.md`: *"No gap acknowledgment, ever, regardless of how the JD frames AI/ML."* Any gap disclosure in cover-letter prose is a **Blocker** (`qa-checklist.md` Check #23 — categorical, no exceptions). *(Corrected 2026-08-19, `job-search-continued` S19: this item previously read "Address domain gaps honestly per `voice-rules/rule-2-fhir-hl7.md` and `voice-rules/rule-16-ai-ml-framing.md`" — instructing the banned pattern, in the one paragraph where it historically appeared, citing as its authority the two rules that forbid it.)*
5. **Close** — forward-confident product-voice close. Use product nouns (single sources of truth, data products, shared definitions), not operational nouns (meetings, cadences, alignments). See `qa-checklist.md` check #21.

**Canonical-phrase discipline:** every outcome clause that references a Phrase-Lock capability must use the canonical phrasing from `exemplars.md` Phrase Lock section. The verifier subagent runs `scripts/verify_phrase_locks.py` to mechanically check this.

**Voice discipline:** no self-descriptors, no PM project-management voice, no abstract-behavior descriptions of users, no JD-responsibility parroting, no weak closers, no non-sequitur sentences. Full banned-pattern list lives in `voice-rules/rule-17-show-dont-tell.md` and `qa-checklist.md` checks #6, #8, #9, #16, #17.

---

## Step 4: Mechanical Phrase-Lock Check + Bolding-Density Count (Composer Self-Check)

Before spawning the verifier, run two mechanical self-checks on the draft.

### 4a — Phrase-Lock Check (cover letter only)

```bash
python3 <SKILL_DIR>/scripts/verify_phrase_locks.py --text "<cover letter text>"
```

The script reports which Phrase Lock capabilities are referenced, which are verbatim, and which are paraphrased. Fix every `FAIL` line before proceeding.

### 4b — Bolding-Density Count + Floor (resume — applies to resume-only and resume+cover-letter generations)

Count `**...**` markers in each summary and bullet in the resume JSON. Verify against Rule 15 caps AND floor:

- **Summary cap:** 3 bolds maximum (typical shape: one credential + one mastery angle + one outcome triplet).
- **Summary floor (added v8 / projects/job-materials-summary-positioning-fix/, 2026-05-27, Defect 1):** 3 bolds minimum. The canonical summary bolding shape per Rule 15 is exactly 3 bolds (specialty/role anchor + mastery anchor + product credential). Composer self-check via plain-text python-docx extraction strips formatting and can MISS bolds shipped at 0 / 1 / 2; the new `detect_summary_bolding_floor` Tier-1 detector (`scripts/preflight_check.py`, ceiling lifted 40→41) flags Medium when summary has <3 bolds. **Floor + cap are co-enforced** — the cap detector (`detect_rule_15_bolding_density`) catches >3 bolds; the floor detector catches <3 bolds.
- **B1 (problem):** **1–2 bolds on the key anchor noun — floor 1, ceiling 2; never force a third, never bold filler.** Bold the single most important scannable noun (the named problem / product / domain), plus at most one second anchor when a domain term adds scan value (e.g. *RCM workflow* + *healthcare SaaS platform*). Pick the right noun; let the count land (often 1). Do NOT bold descriptive filler (*high-variability starting point*, *product stabilization*) and do NOT pad to 3. Per Rule 15 (Craig feedback 2026-06-28 round 3, grounded in the job-search delivered archive — [REDACTED COMPANY]/[REDACTED COMPANY] B1 = 1–2 anchors; round-2 "force 2–3" superseded). **Self-check: walk every role's B1 — each carries ≥1 `**...**` on the right anchor noun, never 0, never 3+, never on filler.**
- **B2 (products/surfaces):** 2–3 bolds (the products built, not also their data types or use cases).
- **B2 condensed (hybrid B1+B2):** up to 3 bolds (drop closure phrases first).
- **B3 (outcomes):** heavy bolding fine — 4–6 metrics + accomplishments.

If any element exceeds its cap, trim using this priority order (drop highest priority first):
1. Closure phrases (e.g., "viable, scalable long-term business model")
2. Use-case descriptors (e.g., "measure clinician engagement and credential compliance")
3. Data-type descriptors (e.g., "healthcare claims and remittance data")
4. Product-value descriptors (e.g., "effective clinician learning tool")
5. Lowest-priority product/capability type

If the summary is BELOW the floor (<3 bolds), add bolds in this priority order (highest priority first):
1. **Specialty/role anchor** — the product-type specialty modifier of `products` (e.g., "data and platform products," "clinical data and platform products") per `voice-rules/summary-construction.md` "Specialty-naming discipline in opener."
2. **Mastery anchor** — the second-clause mastery-pairing or transformation noun phrase (e.g., "clinical and practice management software," "regulated B2B healthcare environments").
3. **Product credential** — the closing outcome-triplet or credential phrase (e.g., "user-centric SaaS products that earn enterprise adoption," "governed, decision-grade platforms").

Always keep: named product surfaces (web/mobile platforms), named accomplishments (Series A, Employee of the Quarter), and metrics with their context.

**Why this exists:** craig-profile.md bullets are plain text; the composer adds bolding per Rule 15 at JSON-generation time. Rule 15's caps are easy to miss when composing — drift toward "bold every key phrase" is the dominant failure pattern (caught by the cap detector). Rule 15's floor is equally easy to miss when composing self-checks plain text via python-docx (the formatting strips at extraction), making a 0-bold summary read clean even when it ships defective — the canonical failure mode Eval 39 [REDACTED COMPANY] Clinical v1 (0 bolds shipped) which spawned the floor detector codification at `projects/job-materials-summary-positioning-fix/` Session 2. See `corrections-log/live-applications.md` "Bolding-Density Drift" entry for the cap pattern; the floor failure is documented at `projects/job-materials-summary-positioning-fix/inputs/iterative-review-feedback.md` Defect 1.

### 4c — Pre-flight Drift Check (cover letter + resume + JD)

Write the JD verbatim to `/tmp/craig_jd.txt` first (you already have it in context from Step 1.6), then:

```bash
python3 <SKILL_DIR>/scripts/preflight_check.py /tmp/craig_application.json --jd /tmp/craig_jd.txt
```

**The `--jd` is not optional.** The 7 Tier 2 detectors are JD-conditional; without a JD they do not run, and the report says so (`PARTIAL`, exit 3). Before 2026-08-14 this invocation omitted `--jd`, every Tier 2 detector returned empty, and the report printed an unqualified four-tier `PASS` over the gap — so Tier 2 had **never** run on the production path. Passing the flag is what turns those seven detectors on.

Runs 41 mechanical detectors across four tiers (banned-phrase scans, structural counts, attribution adjacency, multi-clause attribution audit across all 5 Phrase Locks, select grammar patterns including parallel-predicate tense consistency AND parallel-gerund-comma 2-item construction, hook fact-count gate AND structural setup-list element gate, JD-conditional gates, canonical-chronology validation, and flag-only Tier-4 surfaces). Detector count progression: 34 → 36 in v4 Session 1 (2026-04-30, added the setup-list element gate within `detect_hook_fact_count` per Rule 23 reframe + `detect_grammar_20f_parallel_gerund_comma` for 2-item parallel-gerund-comma construction); 36 → 37 in v4 Session 4 (2026-05-01, added `detect_check_38_charli_form_selection` mechanical companion to Rule 10 Charli-form selection per Eval 15 Item 18b carry-forward); 37 → 39 in v5 Session 1 (2026-05-06, added `detect_check_39_skills_gate2_completeness`) + v6 Session 1 (Step 1.6 / Step 4h surfaces); 39 → 40 in v7 Session 1 (`detect_jd_triggered_specifics_inclusion`, 2026-05-19); 40 → 41 in v8 Session 2 (`detect_summary_bolding_floor` ceiling-lift per `projects/job-materials-summary-positioning-fix/` 2026-05-27 Defect 1 codification — explicit Craig disposition lifted the hard 40-ceiling). Catches every drift mode that is mechanically detectable so the verifier subagent can spend its inference budget on semantic checks only.

What pre-flight covers (the verifier should treat these as already-verified):
- **Tier 1 — pure pattern, no JD dependency:** Gate F summary banned-phrase scan; Rule 17 self-descriptors + tail phrases; Rule 12 canonical-verb paraphrases / PM project-management voice / scalability placeholders / other; negation-then-correction cliché; "actually" filler (Medium, verifier confirms); Check #16 weak-closer ban; Check #21 operational close; Check #15 banned scope phrases; Check #10 temporal-qualifier repetition; Check #10b distinctive-phrase uniqueness; Check #13 evidence-paragraph density (3+ roles); Check #8 abstract-behavior shapes; **hook fact-count gate (Rule 23 — max 2 facts in S1; 3 = Medium / 4+ = High); structural setup-list element gate (Rule 23 reframe, v4 Session 1 — max 2 noun-phrase elements in any Oxford-comma list before the pivot; 3+ = Medium; closes Eval 13 Bucket D drift loophole);** **multi-clause attribution audit (Rule 18 Per-Phrase-Lock Attribution Rules — cross-role weld → Blocker; Consulting PL #1+5 same-sentence → Blocker if no disambiguator OR causal coordinator);** Grammar 20(b) em-dash + participial (cover-letter scope); Grammar 20(c) semicolon + participial; Check #34 EotQ attribution; Rule 15 bolding-density caps; Rule 13 B1 verb diversity; Rule 9 period-endings; Rule 9 #7 "no dashboards."
- **Tier 2 — JD-conditional (7 detectors; all skipped, by name, when no JD is supplied):** Check #12 HIPAA/GDPR cover-letter gate; Check #33 EDI/x12 tier vocabulary (3-tier classification, strong/weak hook split per v4 Session 4 Item 16 strengthening); Check #18 resume banned-defaults; Check #38 Charli-form mechanical companion (v4 Session 4, fires when JD signals healthcare/healthcare-adjacent AND cover letter contains product-thinking-variant breadcrumb); Check #39 Skills Gate 2 completeness audit ([REDACTED COMPANY] eval / Eval 16, 2026-04-30 + spec-writing trigger added v4 Session 4); Check #40 JD-Triggered Specifics inclusion (v7 Session 1 H.3); Check #45 Rule 14 non-healthcare bullet-translation coverage (2026-05-25). *(The last two were registered in `preflight_check.py` but missing from this list until 2026-08-14 — the enumeration said five where the code ran seven.)*
  **Four of the seven need more than the JD:** #38 also needs cover-letter text; #39, #40 and #45 also need a resume. Coverage is therefore reported **per detector, not per tier** — a JD-present/resume-absent run executes four of the seven, and "Tier 2 ran" would be false in both directions.
- **Tier 3 — chronology:** Gate C / Check #11 directional-marker validation against canonical chronology table (Consulting → Charli → KTP → CentralReach PM → CentralReach DA, most recent first), with same-paragraph scope and "Most recently" implicit-anchor heuristic.
- **Tier 4 — flag-only / partial-mechanical (verifier confirms):** Check #14 Phrase Lock #1 narrative-value trigger; Check #23 unprompted gap-disclosure pattern detection (escalated to Blocker, categorical no-exceptions per Rule 26 revised 2026-04-30 — no JD-suppression carve-outs, AI/ML Tier-2 and FHIR/HL7 acknowledgment exceptions deprecated); Check #32(a)/(b) (DEPRECATED 2026-04-30 — no-op stubs retained for historical compatibility); hook-scope severity escalation for Rule 23 banned hook patterns.

**Exit codes (three-state contract since 2026-08-14 — a skip is not a pass):**

| Exit | Meaning | What to do |
|---|---|---|
| `0` | **PASS** — every registered detector ran and none fired. | Proceed to Step 5. |
| `1` | **FAIL** — at least one issue. | Fix everything Blocker / High before Step 5; every Medium / Low must be fixed **or** carry a recorded disposition and its reasoning (some Mediums, like the "actually" filler, are intentional flags for the verifier to confirm — that confirmation is itself the disposition, and it gets written down). The report also discloses any detector that did not run. |
| `2` | **Usage error** — bad path, or a `--jd` that conflicts with a `jd_text` already in the JSON. | Fix the invocation. Nothing was checked. |
| `3` | **PARTIAL** — nothing fired, but some detectors never ran (preconditions unmet; almost always a missing JD). | **Not clearance.** Supply the missing input — usually `--jd` — and re-run. The report names each skipped detector and what it needed. |

Exit 3 is *not* "at least one issue." Do not go hunting for findings when you see it: the report's `SKIPPED` block lists exactly which detectors were never consulted and why.

These mechanical checks are not substitutes for the verifier — they catch what is mechanically detectable. Semantic checks (company-specificity test, intersection legibility, AI/ML tier-match, JD-responsibility parroting, factual accuracy beyond banned phrases, Reader Model checks #29–31) all stay with the verifier.

### 4d — Hook Source-URL Audit (composer-side Check #24b)

For each fact in the cover letter's hook paragraph (P1), confirm it traces to a source URL committed in Gate A item 7 ("Company-specific hook material"). Walk the hook S1 left-to-right; for every quantified count, year, named event, named partner, ordinal scaling claim, or specific date, name the URL or publication it came from. Append the audit to `/tmp/composer_notes.md` in this shape:

```
## Hook Source-URL Audit (Step 4d)

P1 fact 1: "[verbatim phrase from hook]" — source: <URL or publication name from Company Brief>
P1 fact 2: "[verbatim phrase from hook]" — source: <URL or publication name>
[...]

Audit result: PASS (all facts traced to Brief sources) | FAIL (see below)
```

**Pass condition:** every fact in P1 has a documented Brief source. The composer can name the URL or publication for each.

**Fail conditions and required action:**

- A fact in the hook lacks a Brief source — either the Brief didn't surface it, or the fact entered the hook during composition without sourcing. **Required action:** remove the fact from the hook before proceeding to Step 5. Do NOT attempt to source it post-hoc by web-searching during composition; the Brief's research depth was set at Step 0.5 for a reason.
- A fact's source is "general knowledge" or "Craig knows this from prior research." **Required action:** remove. The Brief is the system of record for company-specific facts. If the Brief doesn't have it, the hook can't claim it.

**Why composer-side, not verifier-side:** the Brief lives at `/tmp/company_brief.md` — the verifier subagent runs in a fresh context and does NOT have access to this path. The verifier flagged [REDACTED COMPANY] Pass 1 + Pass 3 (Session 23) with procedural High issues every pass because it could not satisfy itself that hook facts traced to Brief sources. That's not a real defect — it's a structural limitation of the verifier's scope. The composer holds the only context that can resolve source-URL questions: the composer authored the Brief in Step 0.5 and committed sources at Step 1. The audit belongs at composer-side, before generation.

**Verifier scope on hook quality (post-this-step):** the verifier owns Check #24 (dual specificity test — competitor-swap + current-moment) and Check #25 (a)/(b) (reader-perspective tests). The verifier does NOT re-verify source URLs; that work is closed before Step 5 starts.

**Deviation note for evals:** Eval-12 ([REDACTED COMPANY]) Round 1 Pass 1 + Round 3 Pass 3 are the canonical procedural-High failures this step closes. Future evals against the post-Session-2 skill should not reproduce that pattern.

### 4e — Interpretive-Claim Sourcing Audit (composer-side Check #35)

Step 4d closed source-URL traceability on hook FACTS (counts, dates, named partners, ordinal scaling claims, etc.). Step 4e closes source traceability on **interpretive FRAMINGS** — composer-introduced strategic claims that read as substantive observations about the company but aren't direct factual claims. The full rule lives in `voice-rules/rule-28-interpretive-sourcing.md`; this step is the composer-side audit that runs before the verifier sees the draft.

**What to scan for.** Walk the cover letter (hook, bridge, fit, close paragraphs) and flag every clause that asserts something about the company's strategy, business shift, central question, next leg, thesis, core challenge, or strategic moment. The trigger-phrase list in Rule 28 names the most common shapes ("central question," "core challenge," "key bet," "business shift," "is shifting from," "is at an inflection point," "the challenge at the center," "compound across customers," "thesis [as company strategic thesis]," and similar). The trigger list is illustrative, not exhaustive — any framing that reads as a substantive claim about company strategy falls under Rule 28, trigger phrase or no.

**What to do for each flag — word-by-word audit (strengthened v4 Round 3, 2026-04-30 from Eval 15 Round 2 Finding A).** The audit runs at the WORD level, not the phrase level. Each non-canonical-template word in the FILL must be classified into one of four source classes:

- (a) **JD verbatim** — the word appears in JD or is a close paraphrase of JD language.
- (b) **Brief sourced** — the word rests on a Brief Section fact whose source URL is documented in the Brief.
- (c) **Canonical structural template fragment** — the word is part of the [REDACTED COMPANY] canonical structure ("the [X] at the center of [role/business]") whose FILL content (the [X]) is itself JD-verbatim or Brief-sourced.
- **Composer-interp** — the word is composer interpretation, characterization, or metaphor. Allowed ONLY if explicitly marked AND defensible. Defensible means either (i) the JD's rhetorical scope supports the interpretation (e.g., paraphrasing a JD value statement using neutral language), (ii) the word is a structural connector that doesn't make a substantive claim about the company (e.g., "is" / "into" / "across"), or (iii) the interpretation is the composer's product-thinking framing of a Brief-Section-sourced inferred pain point, marked with the Brief Section as defense.

**Phrase-level audit is insufficient.** A FILL phrase can have phrase-level Brief-Section-level approval and still contain composer interpretive overlay sitting word-by-word on top of sourced numbers/concepts. The [REDACTED COMPANY] v2 hook is the canonical failure: phrase "near-saturation procurement marketplace" had Brief Section 1 approval at phrase level (the 26K hospitals fact is sourced) but "near-saturation" word-by-word is composer qualitative characterization not in JD or Brief. Word-by-word audit catches this; phrase-level audit doesn't.

If any non-canonical-template word fails to trace to (a)/(b)/(c) AND cannot be marked composer-interp + defended per the criteria above, cut the word or rewrite the surrounding clause to use only sourced material. Do NOT attempt to source the word post-hoc by inventing rationales — if the source isn't real, the word isn't earned.

See `voice-rules/rule-28-interpretive-sourcing.md` "Word-by-word FILL audit discipline" sub-section for the full format spec, the four source classes table, and the canonical WRONG/RIGHT worked examples ([REDACTED COMPANY] v6/v7 phrase-level + [REDACTED COMPANY] v2/Round 3 word-by-word).

**The mechanical aid: inline `<!-- src: -->` working comments.** As you compose the cover letter (or audit the draft you've already written), drop an HTML comment naming the source immediately after each interpretive framing:

```
With two additional U.S. health systems joining [REDACTED COMPANY]'s data consortium soon, <!-- src: JD verbatim "two additional U.S. health systems joining soon" --> the product challenge at the center of this role <!-- src: [REDACTED COMPANY] canonical template, exemplars.md --> is turning an expanding multimodal foundation into scalable, repeatable life-sciences products <!-- src: JD verbatim "scalable, repeatable" + Brief Section 1 multimodal data foundation --> rather than bespoke customer solutions <!-- src: JD verbatim -->.
```

Read every `<!-- src: -->` comment in your draft and confirm:

1. The source quoted is real (not invented from training memory).
2. The framing in the prose is supported by the source — not an extension or inference layered on top.
3. If any comment fails either test, rewrite the clause or cut the framing.

**Append the audit to `/tmp/composer_notes.md`** in this shape (word-by-word table per the strengthened v4 Round 3 format — phrase-level summary is no longer sufficient):

```
## Interpretive-Claim Sourcing Audit (Step 4e — word-by-word)

Trigger-phrase / interpretive-framing scan results:

### P1 hook FILL audit

| FILL component | Source class | Defense |
|---|---|---|
| "[non-canonical-template word/phrase]" | (a) JD verbatim | "[JD line quoted]" |
| "[next non-canonical-template word/phrase]" | (b) Brief sourced | Brief Section X — "[Brief sentence quoted]" |
| "[[REDACTED COMPANY] canonical template fragment]" | (c) Canonical template | exemplars.md [REDACTED COMPANY] canonical |
| "[composer-interp word/phrase]" | composer-interp marked, defensible | [defense citing JD rhetorical scope OR structural connector OR Brief Section inferred pain point with Section number] |
[...repeat per non-canonical-template word/phrase, walking the FILL left-to-right]

### P[N] [paragraph name] FILL audit
[same table format if other paragraphs have interpretive framings]

Audit result: PASS (every non-canonical-template word traces to (a)/(b)/(c) OR is marked composer-interp + defended) | FAIL (see below)

If FAIL: list the words that failed and the action taken (cut / rewrite using sourced material only).
```

**Strip all `<!-- src: -->` comments from the cover letter before delivery.** The comments are working scaffolding, not part of the deliverable. The audit summary in `/tmp/composer_notes.md` is the durable record.

**Pass condition:** every interpretive framing in the cover letter traces to a documented source; the working `<!-- src: -->` comments have been resolved (kept content reflects the source; failed content has been rewritten or cut); the comments are stripped from the final draft.

**Fail condition and required action:** if any interpretive framing cannot be traced to source (a)/(b)/(c), the framing must be removed or rewritten before proceeding to Step 5. Do NOT ship the draft to the verifier with unsourced strategic claims still in place — the verifier will flag them at Blocker, and the rework cycle is more expensive than fixing at composer time.

**Why composer-side, not verifier-side (analog of Step 4d):** the verifier subagent runs in a fresh context and does not have access to `/tmp/company_brief.md`. The verifier owns Check #35 (qa-checklist) for residual catches and quality-of-source audit, but the primary discipline must run at the composer's seat where Brief and JD are both visible in context.

**Provenance:** introduced v4 Session 1 (2026-04-30) per the v4 plan. Closes RC5 — Data Accuracy Rule under-enforcement on interpretive cover-letter prose. Spawned by Eval 14 ([REDACTED COMPANY], 2026-04-29) Issue 15: composer wrote three interpretive framings ("central product question," "compound across customers," "resetting from scratch with every new engagement") that survived every existing check because no rule covered interpretive prose source-traceability. Craig caught all three in Rounds 6-7. Step 4e plus Rule 28 plus Check #35 close the gap.

### 4f — Cross-Session Canonical Diff (composer-side, runs after 4a phrase-lock check)

```bash
python3 <SKILL_DIR>/scripts/canonical_diff.py /tmp/craig_application.json
```

**Portability — do not pass `--outputs-dir` (fixed S12, 2026-08-11).** The script resolves both outputs folders from its own location (`Path(__file__).parents[3]`), so the invocation above is correct on **both** surfaces. Until S12 it hardcoded `/Users/craigslater/...`, which does not exist inside the Cowork VM sandbox where the script executes there — following this step literally in Cowork returned `Error: no outputs dir found` and stopped, leaving a mandated gate silently unavailable for a whole session (S11). If this step ever fails on paths again, fix the resolver; **do not** hardcode a surface-specific path into the invocation, which breaks the other surface.

The script compares 10 canonical-bullet phrasings in the new draft against the last 3 deliveries — the 3 most recent across **both** `projects/job-search-continued/outputs/` (active) and `projects/job-search/outputs/` (predecessor archive), merged and mtime-sorted — and flags any category where a settled canonical (all 3 prior deliveries agree) is abandoned by the new draft. Categories:

- **PL #1-#5** — Phrase Lock canonical-shape signatures (extends `verify_phrase_locks.py`'s verbatim check with a cross-session form-selection check; e.g., PL #5 long form vs. compact "of delivery" form).
- **CR_PM** — CentralReach PM cover-letter canonical ([internal product name] sentence shape; promoted v4 Session 3 candidate C12).
- **3I** — Three-Initiative attribution form (1-sentence parallel-gerund vs. 2-sentence).
- **SUM** — Resume summary outcome triplet shape.
- **SKHDR** — Resume skills section category-header signature (count + sorted names).
- **APP** — Resume role appositions (italic role-description lines for CentralReach PM / Charli / Consulting / KTP).

**Decision logic per category:**

- All 3 prior deliveries agree AND new draft differs → DRIFT (Medium severity).
- All 3 prior deliveries disagree → SKIP (JD-conditional variation, no settled canonical).
- Fewer than 3 prior deliveries reference the category → SKIP (insufficient sample).
- New draft matches the agreed canonical → CLEAN.
- New draft missing a category that all 3 prior deliveries reference → MISSING (review whether intentional).

**Exit code:** 0 if no DRIFT detected (CLEAN / SKIP / MISSING are all exit 0); 1 if at least one DRIFT.

**Action on DRIFT:**

- Inspect the flagged category's NEW vs. CANONICAL phrasing.
- If the new phrasing is a deliberate JD-conditional adaptation, document it in the eval file's Step 7.5 backport audit Action (b) section ("session-specific variant — not promoted to default") and proceed.
- If the new phrasing is unintentional drift, replace with the canonical form before proceeding to Step 5.
- If the canonical itself has been deprecated by a recent rule change (e.g., a Rule 16 / Rule 26 revision), update `craig-profile.md` / `voice-rules.md` / `exemplars.md` to reflect the new canonical and document the source-file update in Step 7.5 Action (a).

**Action on MISSING:** Inspect whether the new draft intentionally omits the canonical (e.g., the role doesn't warrant a Three-Initiative form because Phrase Lock #1 was dropped per Rule 18 narrative-value gate). If so, document the omission as Action (b) in the eval. If unintentional, restore the canonical content.

**Why this step exists:** the canonical-persistence leak Eval 14 surfaced (working canonicals living only in delivered .docx files, not in source files) is a recurrence risk even with Step 7.5 in place — composers can't backport what they don't notice has drifted, and the "is it drift?" judgment is exactly what a composer in self-context can miss. This step turns the question into a mechanical comparison against the actual delivered archive: if 3 recent deliveries converged on a phrasing, the new draft starts from that phrasing. Source files (Step 0.4) catch in-skill drift; this step catches archive-vs-skill drift.

**Conservative agreement bar (3-deliveries match).** False-positive avoidance is the design priority. JD-conditional canonical variants (PL #1 healthcare/non-healthcare/clinicians-billers; PL #5 long/compact; SUM register adaptations) appear as `disagree` in the agreement test and SKIP — they will not be flagged as drift. Only when 3 consecutive deliveries converge on the same canonical does that canonical become eligible for drift detection.

**Provenance:** introduced v4 Session 3 (2026-05-01) per plan §6 Session 3 Item 3 (candidate C13). Closes the architectural extension of Eval 14's canonical-persistence diagnosis — Step 7.5 catches the leak from the sending end (post-delivery backport), Step 4f catches it from the receiving end (pre-generation drift detection against the archive).

### 4g — Hook Currency + Role-Relevance Audit (composer-side; added 2026-05-04, [REDACTED COMPANY] eval)

Closes the gap surfaced by the [REDACTED COMPANY] eval: Step 4d verifies hook fact source URLs exist; Step 4e verifies word-by-word source classification; neither verifies (a) the source's date supports the prose's tense, or (b) the fact is directly relevant to the role's JD scope (vs. the company's broader activity). Step 4g runs after 4d/4e, before spawning the verifier.

For every fact in the cover letter's hook paragraph (P1), produce a row in the audit table. Both gates must pass independently before the fact is allowed to land in the hook.

**Append the audit to `/tmp/composer_notes.md`** (or the cowork-outputs `composer_notes.md` if running in Cowork) in this shape:

```
## Hook Currency + Role-Relevance Audit (Step 4g)

| Hook fact (verbatim) | Source date | Age (months) | Currency verdict | JD-scope mapping | Reader's-seat verdict | Role-relevance verdict | Disposition |
|---|---|---|---|---|---|---|---|
| [verbatim phrase] | [YYYY-MM] or "current marketing" | [N] or "n/a (durable-scale)" | PASS / FAIL | [JD bullet — e.g., "responsibility: scalable partner onboarding"] | "team's work" / "involved" / "different team" | PASS / FAIL | KEEP / DEMOTE / REPLACE |
[repeat per hook fact]

Tense-source agreement check:
- [verbatim verb phrase from hook]: tense [present-progressive / present / past] supported by source dated [YYYY-MM]. PASS / FAIL.
[repeat per present/present-progressive verb in hook prose]

Audit result: PASS (all hook facts pass currency AND role-relevance; all tenses agree with source dates) / FAIL (see disposition column).
```

**Pass condition:** every hook fact passes BOTH currency (within 12 months OR durable-scale carve-out per Rule 24) AND role-relevance (JD-scope-mapped AND passes reader's-seat test). Tense-source agreement check passes for every present/present-progressive verb.

**Fail condition + required action:**

- **Fact fails currency only:** run a targeted recency search (`[Company] [current year] [topic]`). If a fresher signal is found, replace the older fact with the fresher one. If no fresher signal exists, demote the fact (use only in supporting context where tense doesn't carry recency implications) or drop it.
- **Fact fails role-relevance only:** the fact is current but maps to a different team's scope. Demote to peripheral context or drop. Find a substitute fact that maps to the role's scope.
- **Fact fails both:** drop entirely.
- **Tense-source mismatch:** either update the supporting source (find a fresher signal) or change the tense to one the source supports (past completed: "rolled out in [date]"; established: "spanning"; category-level: "across employer and health plan channels").

**Why composer-side:** the verifier subagent runs in fresh context and does not have the Brief or its source dates available. The composer is the only one positioned to date-check facts in real time and run recency searches. The verifier's residual catch is at `qa-checklist.md` Check #42 (currency + tense) and Check #43 (role-relevance), but those checks rely on the audit table at `/tmp/composer_notes.md` Step 4g being present and accurate — without it, the verifier flags procedural Medium and runs cold.

**Worked example ([REDACTED COMPANY] eval, 2026-05-04).** First-draft hook anchored on the [set-of-named-third-party navigation partners] partner-network rollout (early-2024 source) with "rolling out" framing — fact age 28 months, fails currency. After targeted recency search, replaced with the [major payer partner] partnership going live in early 2026 ([recent-months] trade-press announcement, 4 months old at composition time) — passes currency. [care-model framing] rollout was a candidate at the same date — passed currency but failed role-relevance (clinical-product team's launch, not platform/integrations team's). Final hook: [partner launch] (passed both gates) + [scale-figure] employer customers (durable-scale carve-out for currency; passes role-relevance as the role's blast radius).

**Provenance:** introduced 2026-05-04 ([REDACTED COMPANY] eval). Closes the gap surfaced when the composer's first-draft [REDACTED COMPANY] hook anchored on an early-2024 Brief source for a "rolling out" framing; Craig flagged the staleness during review. The fix produced two new disciplines (currency + role-relevance) with composer-side audit (this step) and verifier-side residual checks (qa-checklist.md Checks #42, #43).

### 4h — Resume JD-Vocabulary Coverage Audit (composer-side; added v6 Session 1, 2026-05-14)

Closes the gap surfaced by Eval 24 [REDACTED COMPANY] v1→v2 revision (Session 39, 2026-05-11): Step 1.6 (above Step 2) produces the JD-vocab inventory; Step 4h validates the inventory's placement predictions against the actual resume draft. Step 1.6 is generative pre-composition; Step 4h is detective post-composition. Together they close the resume-side composer-verifier handshake on JD-vocabulary discipline.

Runs after Step 4g (Hook Currency + Role-Relevance Audit), before Step 5 (spawn verifier subagent).

For each JD top-N concept (from Gate A item 1 — typically 8 concepts; for shorter JD top-concept lists, scale proportionally), produce a row in the audit table. The audit walks the resume summary triplet + skills section + role bullets and checks whether the JD top-concept appears verbatim or near-verbatim somewhere.

**Append the audit to `/tmp/composer_notes.md`** in this shape:

```
## Step 4h — Resume JD-Vocabulary Coverage Audit

| JD top-N concept | Resume placement (summary / skills line N / role bullet evidence) | JD-verbatim or near-verbatim phrasing used (or "not covered — rationale") |
|---|---|---|
| [JD top-concept 1 from Gate A item 1] | [where in resume the concept lands; "not present" if no placement] | [actual phrasing used, verbatim from the resume draft; or "not covered — Craig has no mastery angle that maps to this concept" or similar rationale] |
| [JD top-concept 2] | ... | ... |
[repeat per JD top-concept from Gate A item 1]

Coverage count: [N of M JD top-concepts covered verbatim/near-verbatim]
Coverage floor: 6 of 8 (or proportional)
Coverage verdict: PASS / FAIL
```

**Pass condition (locked v6 Session 1, 2026-05-14):** minimum **6 of 8** JD top-concepts covered verbatim or near-verbatim in summary, skills, or role bullets. For JDs with shorter top-concept lists, scale proportionally (5 of 7, 4 of 6, 3 of 5). The 6-of-8 floor reflects the empirically-observed v1→v2 delta (Eval 24 [REDACTED COMPANY] v1 ~3-4 of 8 → v2 8 of 8) — 6 of 8 is the inflection above which JD-anchored resume positioning reliably reads as tailored.

**Fail conditions + required action:**

- **Coverage below floor AND Craig mastery covers the missing concepts:** regenerate the affected resume section (summary triplet + skills section most often). The composer cannot ship a resume that misses JD top-concepts Craig's mastery covers — this is the v1→v2 revision cycle Step 4h exists to prevent.
- **Coverage below floor BUT missing concepts are documented as "not covered — no Craig mastery covers this" (matching Step 1.6 inventory):** the gap is structural, not composer drift. Document and proceed; surface the gap candidate to Step 7.5 backport audit post-delivery.
- **Coverage at exactly 6-of-8 floor:** PASS, but flag candidate concepts that could be added in skills section if Craig's mastery covers them but they weren't placed. Surface as "consider adding [concept] to skills section [category]" — composer's call whether to add or ship at floor.

**Detector disposition (locked v6 Session 1, 2026-05-14):** Step 4h ships **audit-table only** — NO new mechanical pre-flight detector. Rationale: a mechanical detector would count regex matches across the rendered resume text, which produces false positives (a "Multi-step LLM workflow design" skills line technically "mirrors" the JD's "ML and LLMs as workflow layer" concept but the verbatim word matches are partial). Semantic near-verbatim matching is composer judgment work. Audit-table only preserves the 39-detector count (`scripts/preflight_check.py` unchanged) and keeps the 40-detector ceiling open for future v7 candidates.

### Worked example — Eval 24 [REDACTED COMPANY] v1 (FAIL) vs. v2 (PASS)

**v1 (FAIL — coverage ~3-4 of 8):**

| JD top-N concept | Resume placement | JD-verbatim or near-verbatim phrasing |
|---|---|---|
| knowledge-platform transformation (zero-to-one) | summary (partial) | "0→1 platforms" ([REDACTED COMPANY] canonical typographic variant); JD uses "zero-to-one transformation" — PARTIAL |
| 300M human-powered documents at platform scale | not present | not covered — would require role bullet evidence, no clear placement |
| ML and LLMs as workflow layer | skills lines | "Multi-step LLM workflow design" + "Agentic AI workflow design" — HIT |
| grounded, attributable, trustworthy AI workflows | not present | not covered — composer didn't place JD-verbatim phrasing in summary/skills |
| multi-quarter platform vision + immediate steps | not present | not covered |
| success metrics for core user journeys | summary outcome triplet | "adoption, retention, and revenue" ([REDACTED COMPANY] canonical) — MISS ([REDACTED COMPANY] JD says "core user journeys") |
| prospect-and-subscriber experience across devices | skills line | "Multi-side platform product ownership (B2B + end users)" — PARTIAL (composer translation; doesn't say "prospects"/"subscribers" verbatim) |
| AB testing + qualitative research methods | skills lines | "Experimentation & A/B testing" + "Discovery & user research" — HIT |

Coverage count: 2 HIT + 2 PARTIAL + 4 MISS/not-covered = ~3-4 of 8 (PARTIAL credit). **FAIL.** Below 6-of-8 floor. Required action: regenerate summary triplet + skills section to mirror [REDACTED COMPANY] JD vocabulary.

**v2 (PASS — coverage 8 of 8):**

| JD top-N concept | Resume placement | JD-verbatim or near-verbatim phrasing |
|---|---|---|
| knowledge-platform transformation (zero-to-one) | summary triplet anchor | "zero-to-one product surfaces" — HIT (JD verbatim) |
| 300M human-powered documents at platform scale | summary outcome triplet | "at platform scale" suffix — NEAR-VERBATIM |
| ML and LLMs as workflow layer | skills category + skills lines | "AI/ML-Native Product" category + "Multi-step LLM workflow design" + "Agentic AI workflow design" — HIT |
| grounded, attributable, trustworthy AI workflows | summary outcome triplet | "trustworthy workflows in B2B environments" — NEAR-VERBATIM ("trustworthy" + "workflows" verbatim from JD) |
| multi-quarter platform vision + immediate steps | skills line | "Long-term product vision & strategy for platform features" — HIT (JD verbatim "long-term product vision") |
| success metrics for core user journeys | summary outcome triplet | "core user-journey success" — HIT (JD verbatim "core user journeys") |
| prospect-and-subscriber experience across devices | skills line | "Platform features for prospects + subscribers" — HIT (JD verbatim "prospects and as subscribers") |
| AB testing + qualitative research methods | skills lines | "Experimentation & A/B testing" + "Discovery & user research" — HIT |

Coverage count: 6 HIT + 2 NEAR-VERBATIM = 8 of 8. **PASS.** Above 6-of-8 floor. Resume ships.

### Cost calibration

This step is fast — ~5–10 minutes. The audit walks the rendered resume + skills section against an 8-row JD-concept list. Semantic near-verbatim matching is composer judgment work but the 8-row scope makes the audit quick. Cost justified by every v1→v2 revision cycle the floor prevents.

### Why this step exists

Eval 24 [REDACTED COMPANY] v1→v2 revision diagnostic: v1 resume passed Pass 1 verifier 0/0/0/2 Low (procedural-only) — no rule existed for JD-vocabulary coverage at the resume layer, so the verifier had nothing to flag. Craig caught the drift on post-delivery review. Step 4h closes the post-composition gap that Step 1.6 closes at the pre-composition layer; the 6-of-8 floor + audit-table-only disposition were locked 2026-05-14 in v6 Session 0 intake per Bundle F core item.

---

## Step 4i: Pre-Verifier Draft Delivery — v1 to Craig

**Added 2026-08-25 (`projects/job-search-continued/` S30) at Craig's direction.** Runs after Step 4h and **before any verifier subagent is spawned at Step 5.**

Deliver the composed draft to Craig **as text in chat**, tagged **v1**: the résumé summary, every role's bullets, the full skills section, and the complete cover letter. Not a summary of them — the actual prose, readable end to end.

**Why this exists.** Every verifier round changes prose, and until now Craig only ever saw the *shipped* result. The lenses' effect on the writing was structurally invisible to him: he could read the final documents and the eval's severity counts, but not what the rounds actually did to the sentences. Craig's words at S30: *"give me an initial set of the materials so I can review how they change through the verifier rounds."* The request is for a **diff trail**, not for an extra approval gate — which is what Step 8's companion delta table (below) exists to complete. One without the other only half-answers it.

**Non-blocking — do not wait.** Same posture as Step 0.5 Workflow #7 (Company Brief surfacing): deliver v1, then proceed straight to Step 5. If Craig says nothing, the pipeline continues. Making this a gate would stall every application on a human round-trip and would defeat the point, which is visibility, not permission.

**Text in chat, not documents.** Do **not** generate `.docx`/`.pdf` at v1. Step 6 is explicit that document generation happens only after Steps 5/5.5 have every Blocker and High fixed and every Medium and Low addressed, **and** Steps 5.6 and 5.7 have run. Generating early would contradict that gate and would leave two document sets on disk competing for the same filename. Chat text is also the more reviewable form for the diff trail this step is for.

**If Craig comments on v1** — his feedback is composition input, not a verifier finding, because it arrives *before* the gauntlet starts. Apply it, note it in `composer_notes.md`, and spawn Step 5 against the revised draft (which then becomes v2 for tagging purposes). This is deliberately **not** the Step 7.6 post-delivery path and does **not** consume a pass on any escalation ladder: per `qa-checklist.md` Check #47 § "What consumes a pass," the discriminator is what *triggered* the pass, and a Craig review round starts a new ladder rather than continuing one. *(Recorded because the interlock is easy to get wrong in the other direction: a Craig comment arriving **after** Step 5 has run is a different animal and does route through Step 7.6.)*

**Version tagging is the load-bearing half.** Tag the delivery `v1` explicitly and keep the numbering consistent for the rest of the session, so the Step 8 delta table and the eval's verifier-result figures refer to the same versions. This reuses the version-tagging requirement Step 7.6 already imposes (*"Every verifier-result figure recorded in an eval must name the document version it describes"*) rather than inventing a second numbering scheme.

**Back-test (Rule 27 pre-codification discipline) — applied to its own motivating case.** At S30 the composer completed Step 4h, then spawned Step 5, and delivered v1 only afterwards, while Pass 1 was already running. Under this rule that ordering is **wrong by one step**: v1 ships before the spawn. The rule therefore gives a different and correct answer on the case that produced it, which is the test Rule 27 requires. The S30 session is a pre-rule artifact and is not retroactively re-sequenced; its v1 delivery is recorded in `composer_notes.md` as out-of-order.

---

## Step 5: Spawn the Verifier Subagent

**Pre-spawn preparation (added v5 Session 1, RC6 anti-fabrication codification; expanded 2026-05-25 with item 5 per `projects/job-materials-rule-14-fix/` Session 1 — Anti-Suppression Discipline):** before spawning the verifier, run these preparation steps composer-side. They exist to remove the verifier's invention surface area — the three Pass 1 verifier subagents in Evals 20 [REDACTED COMPANY] / 21 [REDACTED COMPANY] / 22 [REDACTED COMPANY] (all 2026-05) fabricated Phrase Lock IDs, hallucinated duplicate phrases, and quoted "WRONG" prose strings that did not appear in the actual cover letter — and to close the parallel suppression failure mode (Eval 37 [REDACTED COMPANY], 2026-05-25, when the composer instructed the verifier to skip the Rule 14 check). Pre-supplying source-of-truth content closes the fabrication path; the anti-suppression discipline closes the parallel disarm path.

1. **Run the mechanical scripts and capture their full verbatim output.** Run `scripts/verify_phrase_locks.py <cover-letter-path>` and `scripts/preflight_check.py <application-json-path> --jd /tmp/craig_jd.txt`. **The `--jd` is required here for the same reason as Step 4c** — without it the seven Tier 2 detectors do not run and the captured output reads `PARTIAL` / exit 3, which the verifier then copies verbatim into its report as the mechanical record for an application Step 4c already checked completely. Capture the complete output of both into a "Pre-Run Mechanical Script Output (Verbatim)" block in the spawn prompt. The verifier copies this verbatim into its report (per `agents/verifier-prompt.md` Anti-Fabrication Discipline Rule 2).

2. **Pre-quote the full cover-letter prose** in the spawn prompt under a "Cover-Letter Prose (Verbatim — Grep Before Flagging)" block. This is the source of truth the verifier uses for verbatim grep before any prose flag (per Anti-Fabrication Discipline Rule 4).

3. **Pre-list the actual Phrase Lock IDs** in the spawn prompt under a "Phrase Lock IDs for This Application (Authoritative)" block — for each of PL #1 through PL #5 include the canonical phrase from `exemplars.md`, the Rule 18 attribution rule, and the **included / dropped** status for this application (e.g., "PL #1 — INCLUDED" or "PL #1 — DROPPED per Rule 18 narrative-value gate, RCM-domain criterion not met"). The verifier uses these IDs verbatim and never invents new IDs (per Anti-Fabrication Discipline Rule 5).

4. **Restate the Read-tool confirmation requirement** in the spawn prompt — name the two specific reference file paths the verifier must Read before producing any flag (per Anti-Fabrication Discipline Rule 3). Choice depends on the application's likely flag types; default pair is `references/qa-checklist.md` + `references/exemplars.md`.

5. **Anti-Suppression Discipline (composer-side hard prohibition; added 2026-05-25 per `projects/job-materials-rule-14-fix/` Session 1).** The spawn prompt must NOT contain any instruction to the verifier to skip, suppress, downgrade, pre-clear, or not flag a specific rule, check, sub-check, gate, voice rule, Phrase Lock, or canonical-content check — under any circumstance, with no carve-outs. This prohibition is **categorical** and **generalizes beyond Rule 14**. The Eval 37 [REDACTED COMPANY] spawn prompt (2026-05-25) included the instruction "do not flag retained healthcare bullet vocabulary as a Rule 14 violation"; the verifier complied; the documented Rule 14 defect (un-translated role bullets) shipped to delivery. The verifier exists precisely to catch what the composer cannot see, and disarming the verifier with a suppression instruction defeats the one independent check the application has.

   **What this prohibits the composer from writing in the spawn prompt** (non-exhaustive — the prohibition applies to any instruction in this shape):
   - Direct suppression: "do not flag X," "skip the X check," "X is intentionally retained, do not audit," "treat X as pre-cleared," "this is a known carve-out, no audit needed."
   - Pre-dispositioned reasoning the composer wants the verifier to inherit: "the composer concluded X is correct because Y, so do not audit X."
   - Precedent-as-pre-clearance: "prior applications shipped with X retained, so X is not a defect."
   - Scope-narrowing that excludes a defined check: "focus only on Phrase Locks and chronology this pass."
   - Severity downgrades pre-applied by the composer: "X is a Low at most."
   - Reframing of a check as out-of-scope: "X is a separate concern, handled elsewhere."
   - Silent omission of a check from the spawn-prompt recap while including others (signals implicitly that the omitted check is not expected).

   **If the composer believes a specific check truly does not apply to this application**, the correct path is to raise the concern in `/tmp/composer_notes.md` as a disposition with reasoning — NOT to instruct the verifier to skip the check. The verifier reads the composer notes and dispositions through normal flag handling; Craig owns the final disposition where it matters. Suppression instructions are not a disposition path.

   **Verifier-side enforcement.** `agents/verifier-prompt.md` § "Anti-Suppression Discipline" instructs the verifier to ignore any suppression instruction in the spawn prompt and to add a Medium flag to the report labeled "Anti-Suppression Discipline — Composer-Side Suppression Instruction Detected." If the verifier-side rule is the load-bearing catch, the composer-side prohibition is the upstream forcing function. Both layers ship together.

   **Why this discipline lives in Pre-spawn preparation rather than in a separate Step.** The spawn-prompt construction is the surface where suppression instructions land. Including the prohibition as item 5 of Pre-spawn preparation ties it to the action that creates the risk (constructing the spawn prompt) rather than to a separate gate the composer might skim past.

Use the Agent tool to spawn a subagent with the prompt in `agents/verifier-prompt.md`. Pass it:

1. The full generated resume (JSON or rendered text).
2. The full generated cover letter.
3. The raw job description.
4. The company name and role title.
5. Paths to all reference files under `references/` and the script `scripts/verify_phrase_locks.py`.
6. **The path to `/tmp/composer_notes.md`** (added v5 Session 1, RC7 enforcement) — the verifier reads this file to confirm the Step 0.4 sub-step 3.5 classification block is present and complete for resume skills lines before approving the skills section. Without this path, the verifier cannot perform the Step 0.4 sub-step 3.5 residual check.
7. **The four pre-supplied content blocks** from the Pre-spawn preparation list above (mechanical script output, cover-letter prose, Phrase Lock IDs, Read-tool confirmation pair).

The verifier returns a structured report with Blockers / High / Medium / Low issues. Fix every Blocker and High issue before proceeding. A Medium or Low may be left **unfixed**, but not **unaddressed**: leaving one requires a disposition and its reasoning recorded in the composer notes **at this step**, whether or not Step 5.5 fires. *(Stated inline rather than delegated: Step 5.5 runs only when a repair changed prose, so on a Pass-1 report the composer fixes nothing in — the exact case this sentence governs — Step 5.5 Rule 1 would never execute. Caught 2026-08-19 by the third verification round.)* *(Revised 2026-08-19, `job-search-continued` S19: this read "Medium issues are discretionary; Low issues are noted but not required," which was the other half of the contradiction with Step 5.5's gate. Fixing only the Step 5.5 side would have left the two steps still disagreeing on whether an unfixed Medium needs anything written down — caught by this session's closing verifier.)*

**Do not skip the verifier. Do not self-verify.** The composer-in-context has missed 13+ issues in past self-audits. The verifier exists because self-audit in the same context window systematically under-detects drift. Use it every time.

**No self-approval under any circumstances.** If the verifier subagent fails to launch, returns shallow/incomplete results, or errors out, the correct response is to troubleshoot and re-run — NOT to substitute a self-audit. Self-verification is never an acceptable fallback. If the verifier cannot be made to work after two attempts, stop and report the failure to Craig rather than shipping unverified materials. This rule exists because an earlier application shipped on a self-audit that missed multiple issues including unverified factual claims in the hook paragraph.

---

## Step 5.5: Re-Verify After Fixes (Mandatory if Any Repair Changed Prose) — Delta-Scope on Pass 2

If **any repair changed the prose** — regardless of the severity that prompted the repair — the composer re-runs the verifier subagent on the updated draft. *(Trigger widened 2026-08-19, `job-search-continued` S19, per Craig's S18 ruling. It previously read "If Step 5 returned **any Blocker or High issue**," which left the changed prose from a Medium or Low repair unverified — even though the repair itself can introduce a defect, which is the documented S11 failure mode where five of eight defects came from the repair loop rather than the draft. The trigger is **that prose changed**, not the severity that prompted the change.)* The re-verification uses the same process as Step 5 (spawn a fresh Agent, pass the updated draft + reference file paths) — but Pass 2 operates in **delta scope**, not full re-run. **Pass 3 is governed by the *Pass 3* subsection below:** its trigger is the same as Pass 2's — a repair changed prose — and its *scope* is set by whether the repair addressed a new or a residual issue. *(Corrected 2026-08-19, S20: this sentence read "Pass 3 (only if Pass 2 still fails) reverts to full safety-valve scope," which re-asserted the severity-keyed trigger one paragraph before the trigger is stated as non-negotiable, and hardcoded a scope the Pass 3 subsection makes conditional.)*

**Why this step exists:** Without it, the composer fixes issues in its own context and self-certifies the fixes are correct — the same self-audit problem that created the verifier in the first place, one layer up. A prior verifier pass found 2 Blockers + 2 High issues, the composer "fixed" them, and proceeded to document generation without re-verification. The fixes happened to be correct, but the process was unsound.

**Why delta-scope (refactored v3 Session 3):** Sessions 22-32 frequently spent 5-10 min on Pass 2 re-verifying paragraphs that hadn't changed. Pass 1's report names every issue at every severity; if P3 had no Pass-1 issues, P3 was clean — re-running every semantic check on it during Pass 2 was wasted inference. Pass 3 is the full safety-valve **when the repair addressed an issue not on the Pass-1 list** — the case where new drift is reachable. *(Qualified 2026-08-19, S20: read "Pass 3 remains the full safety-valve," which contradicted the conditional scope the Pass 3 subsection now sets.)*

### Pass 2 — Delta scope

Pass 2 scopes the verifier's work to:

1. **Every issue flagged in Pass 1** — confirm each fix landed correctly. Verifier reads the new prose at each flagged location and checks whether the original issue is resolved.

2. **Immediate neighborhood of each fix:**
   - **Cover-letter prose fix:** the changed paragraph + the paragraph immediately before AND the paragraph immediately after (3 paragraphs total).
   - **Resume-bullet fix:** the changed bullet + the bullet immediately above AND the bullet immediately below within the same role (3 bullets total). If the fix is at a role boundary, include the role description line (italic) too.
   - **Summary fix:** the entire summary (it's only 2-3 sentences).
   - **Skills-section fix:** the entire skills section (it's structurally compact and inter-line interactions are common).
   - **Hook paragraph fix:** the entire hook paragraph + the bridge paragraph (hook + bridge are tightly coupled — fact-count, transition).

3. **Checks that interact with the changed text:**
   - **Phrase Lock affected** (any of PL #1–#5 wording or attribution changed) → re-run Check #14 (canonical-bullet fidelity), Phrase Lock script, and multi-clause attribution audit on the changed sentence.
   - **Chronology affected** (directional marker changed, or a role anchor moved) → re-run Gate C scope on the affected paragraph using the inline canonical chronology table.
   - **Grammar fix** (any of 20(a)–(g)) → re-run all 7 grammar sub-checks on the changed sentences only.
   - **Banned-pattern removal** (Rule 12 / Rule 17 / Rule 7 banned defaults / Rule 23) → re-run pre-flight on the affected paragraph + adjacent paragraphs.
   - **Structural cap hit** (Check #13 evidence-paragraph density / Check #25(c) hook fact-count / Rule 15 bolding) → re-run that specific check on the changed element.
   - **Skills section changed** → re-run the focused skills-section audit (verifier-prompt.md "Skills-section audit") + Gate E.
   - **Summary triplet changed** → re-run Gate F (banned-phrase scan via pre-flight) + Gate G (verifier-side Summary mastery-angle audit per `qa-checklist.md` Gate G + `agents/verifier-prompt.md` "Summary mastery-angle audit"). Gate G added v5 Session 2 (2026-05-06) — required when any triplet entry's wording, plurality, or specialty descriptor changes.
   - **Fit paragraph changed** (concerns, gap acknowledgment) → re-run Check #29 (Reader Model verification) sub-check (a) objection preemption.
   - **Bridge paragraph changed** (intersection) → re-run Check #29 sub-check (c) intersection legibility.

4. **Pre-flight always re-runs in full** on every pass (cost: 0.3-0.4 sec). Mechanical detection doesn't need delta-scoping. Pass 2's pre-flight catches any new drift the fix introduced into a paragraph that pre-flight covers.

### Pass 2 — Explicit skips (the savings)

- Verifier semantic checks on UNCHANGED paragraphs, bullets, or summary content. If paragraph P3 wasn't touched, do not re-run Check #17 (non-sequitur), Check #2/3/4 (article/ordering/subject-clarity), Check #7 (em-dash apposition), or Check #9 (parroting) on P3.
- Check #29 sub-checks (b) tone-stage match — only re-run if the fix changed the lead/support balance of any paragraph (rare).
- Resume bullet-fidelity verbatim re-check on roles that weren't touched.
- Read-aloud pass on unchanged paragraphs — only the touched paragraphs + neighborhood need read-aloud verification.

### Pass 3 — fires whenever a Pass-2 repair changed the prose; **what was repaired sets the scope**

**Trigger and scope are two separate questions. Answer them in that order.**

**Trigger (Rule A, not negotiable):** if any repair made after Pass 2 changed the prose, Pass 3 runs — at any severity, new issue or residual. If no repair changed prose, Pass 3 does not run.

**Scope**, once it is running:

- **Delta scope** — if **every** repair made after Pass 2 addressed a **residual Pass-1 issue**, Pass 3 stays delta-scoped on the same neighborhood logic.
- **Full safety-valve scope** — **otherwise.** If any repair touched an issue **not on the Pass-1 list** (drift introduced by the fix into otherwise-untouched content, or drift the composer didn't realize the fix would create), full scope governs the **whole pass**, not just that repair: every check, every paragraph, every bullet, every summary phrase. Pass 3 is the safety net.

**The two branches are complements by construction — delta is the narrow case, full is everything else — so every reachable state has exactly one scope.** *(Made residual 2026-08-19, S20, on the closing verifier's finding. They were first written as two positive conditions, and a positive/positive pair does not partition: the delta branch carried an extra conjunct — "Pass 2 surfaced no new issues" — that the full branch's negation did not supply. Reachable gap: Pass 2 surfaces a new Medium **and** an unresolved residual High; the composer dispositions the Medium (no prose change, permitted at Rule 1) and repairs the residual (prose changes). Trigger fires; full fails because no off-list issue was repaired; delta fails because Pass 2 did surface a new issue. **No scope assigned** — the same one-case-no-rule shape as the defect this section was rewritten to fix, one iteration later. `policies/pre-write-verification.md` Check 4 states the general form: make the loosened category **residual, not enumerated** — "anything not positively X" fails closed; a list of what counts fails open on whatever the list forgets.)*

*(Restructured 2026-08-19, `job-search-continued` S20 — in two moves, the second correcting the first, recorded because the intermediate state was a live contradiction. **Move 1:** the heading and body read "only if Pass 2 still finds Blocker / High" and "If Pass 2 returns Blocker or High issues" — severity-keyed survivors of the pre-2026-08-19 rule, one level down from the site S19 widened. Their reachable hole: Pass 2 returns two Mediums, the composer repairs both, prose changed, and no Pass 3 fires — the identical defect the widening existed to close. So the trigger was rewritten to "a Pass-2 repair changed the prose." **Move 2 — the defect that introduced:** unqualified, that trigger swallowed the residual-only case, which the following paragraph independently assigned to **delta** scope. One case, two rules, no tiebreak — caught the same session by the closing cold verifier. The severity key had been silently doing the scope work; removing it exposed that **new-vs-residual**, not severity, is the real scope discriminator. Trigger and scope are now stated separately, which is what the original text conflated.)*

### Composer-side prompt augmentation for Pass 2

When spawning the verifier for Pass 2, prepend this to the standard verifier prompt invocation:

```
## v3 Session 3 — Pass 2 delta-scope mode

This is Pass 2 of Step 5.5 re-verification. Operate in DELTA SCOPE per SKILL.md Step 5.5:

- Pass-1 issues to confirm fixed:
  [list each issue with location + check + severity]

- Paragraphs/bullets changed in the fix:
  [list each changed location, e.g., "P3 (entire), P4 sentence 2, Resume Consulting B2"]

- Neighborhood scope per SKILL.md Step 5.5: same paragraph + 1 paragraph before + 1 paragraph after for prose; same role's bullets + role-above + role-below for resume.

- Interacting checks per SKILL.md Step 5.5: [list applicable interactions, e.g., "Phrase Lock #5 wording changed → re-run Check #14 + verify_phrase_locks.py + multi-clause attribution"]

- Pre-flight ALWAYS re-runs in full (it's mechanical).

- DO NOT re-verify semantic checks on paragraphs / bullets / summary content NOT in the changed list above and NOT in any neighborhood. The verifier's full-coverage pass already cleared those paragraphs in Pass 1.

If Pass 2 surfaces NEW issues outside the delta scope — at ANY severity — flag them. Any repair to them that changes prose triggers Pass 3 (full re-verification). If Pass 2 only confirms the original Pass-1 issues are resolved AND the delta-scope checks are clean AND no repair changed prose, Pass 2 is complete.
```

### Rules *(1 and 2 revised 2026-08-19, S19; 3 and 4 unchanged from prior Step 5.5)*

1. Before proceeding to **Step 5.6**: every **Blocker and High** must be **fixed** — there is **no disposition path at those severities**, matching Step 5 ("Fix every Blocker and High issue before proceeding") and Step 5.6's own precondition. Every **Medium and Low** must be **addressed**, meaning fixed **or** carrying a recorded disposition, by one of two paths: **(a)** the composer **accepts** the finding but judges no prose change warranted → records the disposition and its reasoning in `/tmp/composer_notes.md` (the artifact named in Step 5.7's **Phrase Lock corollary**; Step 5.7's disposition rules name no file); **(b)** the composer **disagrees** → **Rule 4 below governs**: do not silently dismiss, present it to Craig with reasoning, Craig dispositions. A report that is clean or fully addressed is the only automatic gate-pass — and it passes this gate only. Steps 5.6 and 5.7 are mandatory regardless of how clean this report is; nothing routes from here directly to Step 6. *(Two-stage history, recorded because the intermediate state was worse than either end. This rule originally read "0 issues at every severity level," which contradicted Step 5's "Medium issues are discretionary" and could not be passed by a Step 4c report that is correct **by design** — Step 4c deliberately emits some Mediums as "intentional flags for the verifier to confirm." A 2026-08-19 revision replaced it with "0 **unaddressed** issues at every severity level," which fixed that but opened two High defects found by the same session's fourth verification round: it made a **recorded disposition an alternative to fixing a Blocker**, and it routed a disputed Blocker to Rule 4, which is scoped to "Medium and Low." That combination deadlocked — a Craig-dispositioned Blocker changes no prose, so Rule 2 fires no re-run, so the pass counter never reaches Rule 3's escalation exit, while Step 5.6 still demands 0 Blocker / 0 High. **The disposition path is now scoped to Medium and Low, where it was always the only thing in dispute.**)*
2. If the verifier returned any **unaddressed** issues → **fix** them (Blocker and High — no disposition path, per Rule 1) or **fix-or-disposition** them (Medium and Low) → **if a repair changed prose**, re-run verifier (Pass 2 delta-scope; Pass 3 per the *Pass 3* subsection above, which sets its own scope). Max 3 total verifier passes. *(Severity quantifier corrected 2026-08-19, S20: this read "any **unaddressed** issues **at any severity** → fix or disposition them," which granted at Blocker and High exactly the disposition path Rule 1 was rescoped the same day to remove — the prohibition in item 1 and the permission in item 2, one line apart. Rule 2's **trigger** half was updated at S19; its severity half was not.)* *(A disposition that changes no prose does not require a re-run — there is nothing new for the verifier to read.)*

   > **⚠️ The 3-pass cap here governs the ESCALATION LADDER, not the session — extended to Step 5.5 by Craig's ruling, 2026-08-25 (`job-search-continued` S30).** The S18 ruling (2026-08-18) established that **what consumes a pass is what TRIGGERED it, not whether the prose changed**, and was deliberately scoped to Step 5.7 at the time. It now governs Step 5.5 on the same terms:
   >
   > - **A rung (draws on the budget):** the pass was triggered **by the previous pass's own findings** — the composer fixed what it flagged and re-ran to confirm. Three consecutive rungs on the same unresolved thread, then Craig dispositions.
   > - **A fresh Pass 1 (does not):** the pass was triggered by an **event outside that loop** — a **Step 5.7 readability repair**, a Step 7.6 post-delivery revision, or a Craig review round. The prior ladder is closed; this is a new one.
   >
   > **What this fixes, and why it needed a ruling rather than a reading.** Step 5.7's re-entry rules *mandate* re-running Step 5.5 delta-scope on any prose a readability fix changed — because a readability repair can introduce a rule violation (documented at eval-41-mcg: a repair introduced a Rule 12 negation-contrast the regex did not catch). Under a flat session cap that mandate becomes **structurally unreachable** the moment three passes are spent, so the skill instructed a gate it also blocked. Recorded as an open collision at `evals/eval-42-acuitymd.md` §5 item 3; lived at S30, where five sentences including the hook were rewritten by a 5.7 REWORK with all three passes already spent. **Craig ruled: extend.**
   >
   > ✅ **Step 5.6 was extended on the same terms later the same day** (Craig, 2026-08-25) — see § Step 5.6 → *Fix-and-Rerun*. It was deliberately left out of *this* ruling and filed rather than inferred; Craig then ruled on it separately. **All three of Steps 5.5, 5.6 and 5.7 now share one pass-accounting test.**
3. **If still failing after 3 verifier passes:** Stop. Present Craig with the latest Verification Report. Craig decides — approve proceeding, request a specific fix, or direct further. Document generation does NOT begin until Craig gives explicit approval.
4. **Medium and Low issues the composer disagrees with:** the composer does not silently dismiss. Present to Craig with reasoning. The verifier's job is detection; Craig's job is disposition.

---

## Step 5.6: Quality-Lens Verifier Pass (Mandatory)

**This step closes the hook-composition-quality / interpretive-prose-sourcing / intersection-legibility / register-match gaps surfaced by Eval 14 ([REDACTED COMPANY]) Category D + Category E. It runs after Step 5/5.5 has every Blocker and High **fixed** and every Medium and Low **addressed** (fixed, or carrying a recorded disposition and its reasoning), and before Step 5.7. It is mandatory on every application — not conditional on Step 5 / 5.5 findings.**

The rule-violation verifier (Step 5 Pass 1 + Step 5.5 Pass 2/3) catches mechanical drift: Phrase Lock failures, banned phrases, chronology errors, factual scope, grammar, mechanical detector findings. It does NOT score hook strength against canonical exemplars, intersection legibility, register match, or interpretive-prose sourcing. Eval 14 iterated the [REDACTED COMPANY] hook through 4 distinct framings across 7 review rounds — none of those failed iterations were flagged by the rule-violation verifier; they were caught only by Craig's review. Step 5.6 closes that gap.

### Workflow

1. **Confirm rule-violation flow has converged.** Step 5/5.5 must have every Blocker and High **fixed** and every Medium and Low **addressed** — fixed, or carrying a recorded disposition and its reasoning, per Step 5.5 Rules item 1. If still failing after 3 verifier passes (Step 5.5 escalation), Step 5.6 is skipped — Craig dispositions the rule-violation report directly.

2. **Spawn the quality-lens verifier subagent** using the prompt at `agents/verifier-quality-prompt.md`. Pass it:
   - The full generated cover letter
   - The full generated resume (used for cross-letter consistency only)
   - The raw job description
   - The company name and role title
   - Paths to reference files: `references/hook-bench.md` (primary), `references/voice-rules.md`, `references/qa-checklist.md`, `references/exemplars.md`
   - The path to `/tmp/composer_notes.md` (composer's Step 4e word-by-word audit table)

3. **The quality-lens verifier scores 4 dimensions:**
   - **Hook quality (1-5)** — calibrated against `references/hook-bench-signatures.md` (19 entries: 5 GOOD / 9 BAD / 5 BORDERLINE), which indexes `references/hook-bench.md` for 15 of them and `voice-rules/rule-23-hook-paragraph.md` for the 4 rule-anchored entries BAD-6…9
   - **Intersection legibility (1-5)** — bridge phrase + first evidence sentence reinforce same compounding pattern
   - **Register match (Pass / Fail)** — tone matches role's seniority + execution-vs-strategy lean
   - **JD bonus-qual coverage (Pass / Fail)** — preferred quals covered in skills section or cover letter prose

4. **The quality-lens verifier ALSO produces an interpretive-prose flag list** — every clause asserting something about the company's strategy / business shift / central question / next leg / thesis / core challenge / strategic moment, classified by Rule 28 source taxonomy (a / b / c / composer-interp marked / unsourced). This is an independent re-trace per Rule 28 v4 Round 3 word-by-word audit discipline — it does not credit the composer's Step 4e audit notes as evidence on their own.

### Disposition rules

The quality-lens verifier returns one of three overall verdicts:

- **Ship** — all dimensions ≥4, no Blocker/High flags. Proceed to **Step 5.7**.
- **Composer Review Required** — any dimension at 3, OR Medium flags only, OR borderline Pass/Fail. Composer reads the report, dispositions each Medium item (fix vs. acknowledge as JD-specific tradeoff), and proceeds to **Step 5.7** with documented reasoning. No re-spawn required for Medium-only outcomes unless composer chooses to fix.
- **Fix-and-Rerun** — any dimension ≤2, OR Pass/Fail = Fail at High severity, OR any Blocker flag. Composer fixes per the verifier's specific recommendations, then re-runs Step 5 Pass 2 delta-scope on the fix neighborhood, then re-runs Step 5.6 to confirm clean. **Max 3 passes on the escalation ladder; after 3, Craig dispositions** — see the pass-accounting note below.

> **⚠️ The 3-pass cap here governs the ESCALATION LADDER, not the session — extended to Step 5.6 by Craig's ruling, 2026-08-25 (`job-search-continued` S30), completing the extension he made to Step 5.5 earlier the same day.** The S18 test applies unchanged: **what consumes a pass is what TRIGGERED it, not whether the prose changed.**
>
> - **A rung (draws on the budget):** the pass was triggered **by the previous 5.6 pass's own findings** — the composer fixed what it scored down and re-ran to confirm.
> - **A fresh Pass 1 (does not):** the pass was triggered by an **event outside that loop** — a **Step 5.7 readability repair that changed the hook or bridge**, a Step 7.6 post-delivery revision, or a Craig review round.
>
> **The collision this closes is the same one, one step over.** Step 5.7's re-entry rules mandate *"Hook or bridge changed → also re-run Step 5.6, which scored prose that no longer exists."* Under a flat session cap that mandate becomes **unreachable** once three 5.6 passes are spent, so the skill would instruct a gate it also blocked — exactly the shape filed at `evals/eval-42-acuitymd.md` §5 item 3 for Step 5.5. **It did not bite at S30 only by arithmetic:** the 5.7 REWORK rewrote the hook while 5.6 sat at pass 1 of 3, so the mandated re-run was available. Two more quality rounds first and the seal would have faced a mandated-but-forbidden gate with nothing on the books to resolve it.
>
> ⚠️ **One asymmetry, recorded rather than smoothed over.** The quality lens **scores dimensions**; the rule and readability lenses **confirm fixes**. So "triggered by the previous pass's own findings" is a slightly looser notion here — a re-score can move on prose the composer changed for a different lens entirely, which is precisely what happened at S30 (5.6 pass 2 scored a hook the *readability* lens had forced). That case is a **fresh Pass 1** under the rule above, correctly. Flagged because the distinction was unexamined when the entry was first filed, and it is the reason the extension needed a ruling rather than an inference.

### Why this step exists

Hook composition is judgment-heavy work that the rule-violation verifier does not score directly. Without Step 5.6, the composer self-certifies hook quality in its own context window — the same self-audit problem that created the verifier in the first place, one layer up. Eval 14 demonstrated this: [REDACTED COMPANY] shipped Round 1 with a [REDACTED COMPANY]-style "inflection point" hook that the rule-violation verifier passed clean (0 Blocker / 0 High); Craig's review caught the cliché framing and the iteration cycle began. Step 5.6 surfaces these issues before delivery.

### Cost calibration

Adds ~2 minutes latency (one additional subagent spawn + ~30-second prompt + structured-output scoring). The latency cost is justified by every hook-quality / interpretive-prose issue from Eval 14 Category D + Category E that wouldn't have surfaced in review if this step had been in place.

### Rules

1. **Mandatory on every application.** Even when Step 5/5.5 returns a clean or fully addressed report, Step 5.6 still runs. The rule-violation flow's clean report does not certify hook quality. *(Reworded 2026-08-19, S20: "returns 0/0/0/0 clean" implied zero-at-every-severity was the gate-pass shape, which Step 5.5 Rules item 1 stopped requiring.)*

2. **The quality-lens verifier returns scoring + flags, not Blocker/High/Medium/Low severity (in the rule-violation sense).** Translation between scoring and severity follows the Calibration Mapping in `references/hook-bench.md`. Hook score 1-2 → Medium-to-High flag; score 3 → Medium drift risk; score 4-5 → no flag. Interpretive-prose flags carry their own severity per Rule 28 escalation (Blocker for unsourced strategic claims; Medium for trigger-phrase hits with incomplete sourcing; Low for borderline interpretive framings).

3. **Hook score citations are mandatory.** Every score must reference the bench-entry ID (GOOD-N / BAD-N / BORDER-N) the new hook most closely matches. Score without bench citation = under-calibrated; the verifier downgrades or drops per `verifier-quality-prompt.md` Step 4.6.

4. **Independent re-trace, not audit-table credit.** Per Rule 28 v4 Round 3 word-by-word audit discipline, the verifier does NOT trust the composer's `/tmp/composer_notes.md` audit table as evidence on its own. Every non-canonical-template FILL token is independently re-traced against JD/Brief content.

5. **No self-approval under any circumstances.** If the quality-lens verifier subagent fails to launch, returns shallow/incomplete results, or errors out, the correct response is to troubleshoot and re-run — NOT to substitute a composer self-audit. Self-verification is never an acceptable fallback. Same rule as Step 5; same reasoning.

---

## Step 5.7: Readability Pass (Mandatory) — Reference-Blind Sentence Lens

**This step closes the gap surfaced by eval-41-mcg (`projects/job-search-continued/` S3, 2026-08-05): Craig caught three prose defects that all five verifier passes had cleared.** It runs after Step 5.6 converges and before Step 6 generates documents. Mandatory on every application. Full discipline: `references/qa-checklist.md` Check #47. Prompt: `agents/verifier-readability-prompt.md`.

### Why neither existing lens catches this

The rule-violation verifier hunts rule violations and sourcing. The quality-lens verifier scores hook / intersection / register / bonus-qual coverage. **Neither asks whether a sentence is comprehensible to a first-time reader.** All three spawning defects were rule-clean and correctly sourced; two of them — an unresolvable "that foundation" whose antecedent sat two paragraphs back, and a compressed abstraction stack carrying the letter's central argument that Craig could not parse — are pure comprehension failures with no rule surface at all.

### Why a separate spawn rather than a Step 5.6 dimension

The ROADMAP entry offered both. A separate spawn is required, and the reason is structural rather than budgetary:

Sub-check (a) asks whether a **first-time reader** parses the sentence; sub-check (b) asks whether it tells that reader something **new about Craig**. Every other lens in this skill is *required* to read `craig-profile.md`, `career-narratives.md`, the voice-rules corpus, `exemplars.md`, and `qa-checklist.md`. A verifier saturated in that corpus cannot answer either question — it silently resolves compressed references from prior knowledge, and it already knows everything the letter could tell it. Folding this check into Step 5.6 would produce an instrument that reports clean by construction.

This is not hypothetical. It is the CF-13 defect class the portability smoke found in this skill's own hook leg — an instrument defeated by its own required reading, where the session correctly diagnosed the confound for two legs and missed it on the third, *where it flattered the result* (`ROADMAP.md` → portability-smoke instrument entry). **A "read as if fresh" instruction does not fix it**, because contamination is a property of what is in the subagent's context, not of its intent. Blindness has to be enforced by what the spawn withholds.

The cost is one additional subagent spawn, ~2 minutes — the same cost Step 5.6 carries, justified the same way: three of these defects reached a hiring manager.

### Workflow

1. **Confirm Step 5.6 has converged** (Ship, or Composer Review Required with Mediums dispositioned). If Step 5.6 escalated to Craig after 3 passes, Step 5.7 is skipped and Craig dispositions directly — same escalation rule as Step 5.6.

2. **Spawn the readability verifier.** Read `agents/verifier-readability-prompt.md` and **inline its full text into the spawn — do not pass the path.** A fresh subagent cannot open a file it has been told not to open, and the prompt treats an arriving path as a spawn defect, so handing it its own path defeats the pass before it starts (three S13 passes died exactly this way). Alongside that inlined text, pass **exactly three things**:
   - The full generated cover letter (verbatim text).
   - The raw job description.
   - The company name and role title.

3. **Pass nothing else. This is a hard constraint, not a default.** Do not pass reference-file paths, `/tmp/composer_notes.md`, `/tmp/reader_model.md`, the résumé, or either prior verifier's report. Every one of those contaminates the instrument, and `composer_notes.md` additionally supplies the post-hoc justifications that Check #46's independence requirement already establishes must not be credited. **The résumé is withheld for a second, independent reason** — see the Phrase Lock carve-out below.

4. **The pass returns** a verdict (CLEAR / REVIEW / REWORK), **every flag it raised** — ranked High first, then by position — a sentence-coverage count, and a **Procedural Flags** section. **Expect that section on every correctly-executed spawn**, carrying a **Disclosure** — inlining the prompt (item 2) is itself disclosable, and the harness attaches ambient context to every subagent. A Disclosure is the normal state and does not void the pass; only a **Contamination** does. Do not read the section's presence as evidence the spawn was defective — read the tier. Each flag carries a verbatim sentence, the named stumble, a class, a deletion test, a repair shape, and a severity (Medium or High only). **Nothing is withheld from the report: the bound is on what the composer must act on, not on what the lens may say.**

5. **A Procedural Flag has two tiers, and only one voids the pass.**
   - **Contamination** — an input carrying candidate material or **candidate knowledge** reached the lens (as a path *or* pasted inline), or a required input was missing, **or any other input beyond the three arrived that does not positively fall under Disclosure.** The instrument was contaminated or starved, so its result means nothing. Fix the spawn and re-run; **a contaminated pass does not count toward the pass limit**, because nothing was measured.
   - **Disclosure** — only two things: ambient harness context carrying no candidate material and no candidate knowledge, and the governing prompt's own text arriving inline. Record it; **the pass stands and counts.**
   - **"Candidate knowledge" is career and candidacy facts, not working preferences** — employment history, employers, roles, dates, metrics, narratives, skills inventory, or anything the letter asserts about Craig. Behavioral rules, tooling preferences, and session bookkeeping are not candidate knowledge, and **a filename is not its contents.** Without this line the workspace's own ambient injection (which names Craig-facts) reads as contamination and voids every pass — the failure this split exists to prevent.
   - **When the tier is unclear, treat it as Contamination.** Contamination is the residual category; Disclosure is the narrow exception. This is the fail-closed direction, and it matters because this rule *relaxes* a categorical ban — the S14 shape where every fix for a fail-loud introduced a fail-open.

   **Why the split exists (measured, S18).** Two of three uncapped corpus passes raised a Procedural Flag on context the harness attaches to every subagent — workspace instructions, a memory index, a skill listing — which no spawn controls; the third did not, on the same harness with the same spawn shape. Voiding on that would make the pass limit unreachable for a cause the composer cannot fix, and a void that fires unpredictably makes two structurally identical passes non-comparable. Full data: `eval-output/s18-readability-corpus-recalibration.md`.

### Phrase Lock carve-out — why sub-check (b) is scoped within the letter

Sub-check (b) ("does this tell the reader something new about Craig?") reads naturally as *letter-vs-résumé* redundancy. It must not be. Rule 18 canonical-bullet fidelity **requires** several cover-letter sentences to reuse résumé bullet text verbatim; a lens comparing the two would fire on every Phrase Lock. Sub-check (b) is therefore scoped to **within-letter** redundancy only — a sentence whose content an earlier sentence of the same letter already delivered. Withholding the résumé enforces the scope structurally instead of relying on the prompt's restraint.

**Corollary for the composer:** if the pass flags a sentence the composer knows to be a locked canonical phrasing, the flag is **dispositioned, not applied** — record the disposition in `/tmp/composer_notes.md` with the PL ID. The lens cannot see the locks and is not wrong to have stumbled.

### Rule 23-mandated-construction carve-out — the second disposition class (added 2026-08-25, Craig's ruling, `job-search-continued` S30)

**The same corollary, extended to one further class of sentence the lens cannot see.** A **PARSE flag on a construction Rule 23 mandates** — chiefly the `With [fact], [the role's challenge]` subordinated-fact opener the opening-register discipline requires — is **recorded and not applied**, exactly as a Phrase Lock flag is. Record it in the composer notes naming **the rule and the discipline**, the way a Phrase Lock disposition names the PL ID.

**Why this is a carve-out and not a concession.** Rule 23's opening-register discipline *requires* the company fact to sit in a subordinate premise so the main clause leads with the challenge. Step 5.7's lens flags exactly that construction as a front-loaded stumble. **Both are correct within their own scope**, and the composer cannot satisfy both: removing the fronted premise to clear the lens puts a company-situation main clause back at the top, which is the register violation the rule exists to prevent. This is the same structural shape as the Phrase Lock case — a reference-blind reader stumbling on text a discipline it cannot see requires — and it gets the same treatment.

**Measured across two applications, and it reproduced identically.** S29 (Twin Health): three readability rungs, never cleared, **five of six** final-rung flags on locked canonical. S30 ([REDACTED COMPANY] Clinical Content): the hook rewritten **five times across three lenses**, three rungs, never cleared, **four of five** final-rung residual flags on locked canonical (PL #6 bridge, the P5 spine twice, the Check #41 AI-block opener). Each version satisfied one lens and broke another: fact-led → rule-lens register violation → subordinated premise → readability front-load → three-sentence split → quality-lens **recitation** (hook 4/5 → 3/5) → deploy verb restored → readability referent gap → two-sentence collapse → still flagged. **S29 set the test explicitly — "worth checking the next two applications" — and S30 was the first of the two.**

**⚠️ Scope this narrowly. It is not a general readability exemption.** It covers a PARSE flag whose repair would breach a **named** rule or canonical, and nothing else:
- The composer must name the rule or lock the repair would breach. *"This one's canonical"* with no citation is not a disposition, it is the thing this carve-out is most likely to be abused into.
- **NOTHING-NEW flags are not covered.** The carve-out is about *parseability* colliding with a mandated construction; a sentence that says nothing new says nothing new regardless of its shape.
- **A flag on free prose is always applied.** At S30, six of nine rung-2 flags and four of six rung-3 flags were on composer-owned prose and every one was repaired — including two the composer had first written off as canonical and, on re-examination, found splittable while keeping the locked text verbatim. **Re-examine before dispositioning:** that check moved two flags from "untouchable" to "fixed" in one pass.
- The lens still **reports** everything. This changes what the composer *applies*, never what the lens is allowed to say — the anti-suppression discipline is untouched, and pre-emptively telling the lens to skip these sentences remains a Contamination-class spawn defect.

*(Chosen from three shapes drafted at S29. **Shape 1** — teaching the lens the construction — was declined: `agents/verifier-readability-prompt.md` argues in its own text that pre-emptive carve-outs are how the instrument gets defeated, which is exactly why locked-phrasing carve-outs are applied by the composer **after** the report. **Shape 3** — re-examining the opening-register discipline itself — remains open and is the larger question; this carve-out stops the standing escalation without prejudging it.)*

### Disposition rules

**The action cap — six.** The lens returns everything it raised; the composer **acts on the top six** and **records a disposition for every flag below the line**. Deferring a flag is a decision that gets written down, never an omission. Six preserves the working volume the retired report cap produced on a draft — S18 measured 3–5 flags on finished letters against floors of at least 6–10 on **capped** draft passes (floors, not counts; the only uncapped draft passes on record — Heartbeat's Passes 2 and 3 — returned 4 each, so the draft/finished split is not clean) — while making the remainder visible instead of deleted.

- **CLEAR** → proceed to Step 6.
- **REVIEW** (Mediums only) → the composer dispositions each flag: fix, or record why not. Proceed to Step 6 with the reasoning recorded. No re-spawn required.
- **REWORK** (any High) → the composer fixes, then re-runs Step 5.7 to confirm clean.

**What consumes a pass — ruled by Craig, 2026-08-18.** The **3-pass limit governs the escalation ladder only**: consecutive re-verification of a High the previous pass did not resolve.

**The discriminator is what TRIGGERED the pass, not whether the prose changed.** A first drafting of this rule said "a pass on prose no prior pass has seen is a fresh Pass 1" — **that is wrong and was corrected 2026-08-18 before any live use.** Every REWORK re-run reads changed prose by definition (the composer just fixed something), so that test makes *every* pass a fresh Pass 1 and the limit unreachable — the unbounded loop the cap exists to prevent. It also falsifies its own motivating case: Heartbeat's readability passes read v2, v3, v4 in sequence, each incorporating the prior pass's fixes, so under the prose test that ladder would never have started.

- **A rung (draws on the budget):** the pass was triggered **by the previous pass's own findings** — the composer fixed what it flagged and re-ran to confirm. Three consecutive rungs on the same unresolved thread, then Craig dispositions.
- **A fresh Pass 1 (does not):** the pass was triggered by an **event outside that loop** — a Step 7.6 post-delivery revision, or a Craig review round. The prior ladder is closed; this is a new one.

This is the reading `heartbeat-composer-notes.md` § "Pass-numbering correction" states for the sibling gate: *"v6/v7 were fresh Step 7.6 gate invocations triggered by Craig's prose revisions, **not continuations of a failure**."* Trigger, not diff.

This is the reading already applied to the sibling gate in the Heartbeat composer notes — *"the max-3 cap governs the escalation ladder — consecutive re-verification of an unresolved Blocker/High — and that ladder never engaged here"* — so it is not a new concept — but **it was applied there in practice, not codified there.** Step 5.5's own rule text still reads a flat `"Max 3 total verifier passes"` (§ Step 5.5 → Rules, item 2), and Step 5.6 the same (§ Step 5.6 → Fix-and-Rerun). *(Re-anchored from line numbers to section references 2026-08-19, S20: the pointers read `:979` and `:1017`, and a rewrite seven lines above them left both aimed at blank lines. This clause's self-scoping depends on naming the two sites it declines to govern, so a stale pointer here silently voids the scoping. The sibling copy at `references/qa-checklist.md` already used symbolic references — that is the model.)* **This clause governed Step 5.7 only until 2026-08-25**, when Craig extended it to **Step 5.5** (see Step 5.5 → Rules, item 2) and then, later the same day and on the same terms, to **Step 5.6** (see Step 5.6 → Fix-and-Rerun). **All three of Steps 5.5, 5.6 and 5.7 now share one pass-accounting test.** ⚠️ *This sentence read "Step 5.6 remains unextended" until the S30 closing verifier caught it — the second extension was written into 5.5, 5.6 and `qa-checklist.md` but not back into this clause. The S30 write-sideways sweep missed it because it searched two other phrasings and not this one; when a ruling changes a rule's state, grep the **state description** ("unextended", "still stands", "only"), not just the phrasing you remember writing.* It closes the collision where Step 7.6 mandated a re-run the cap structurally blocked (`evals/eval-42-acuitymd.md` §5 item 3), and the case that motivated it: at Heartbeat the ladder ended at v4 and **v5–v8 shipped unread by any comprehension lens.**

**Re-entry into the earlier gates after a 5.7 fix.** A readability fix changes prose, so it re-enters the gates the changed prose belongs to:

- **Any prose change** → re-run Step 5.5 Pass 2 delta-scope on the fix neighborhood. A rewrite can reintroduce a banned pattern; pre-flight is cheap and always re-runs in full.
- **Hook or bridge changed** → also re-run Step 5.6, which scored prose that no longer exists.
- **Deletion only, outside hook and bridge** → pre-flight plus the Step 5.5 delta-scope neighborhood is sufficient; Step 5.6's scored dimensions are untouched.

### Rules

1. **Mandatory on every application**, including when Steps 5/5.5/5.6 all return clean. Their clean reports are exactly the condition under which this pass has historically been needed — all five passes on the spawning application were clean.

2. **A readability flag is never an accuracy finding.** The lens has no reference files and therefore no basis for any claim about truth or sourcing. This mirrors Check #46's boundary: a Check #47 flag is not accuracy, so the **ASK-CRAIG** disposition (which exists for unsourced claims) does not apply.

3. **The lens never proposes replacement prose**, and the composer must not ask it to. A reference-blind agent writing a sentence about Craig is fabricating by construction. It names the stumble; the composer, who holds the sources, owns the repair.

4. **Deletion is a first-class disposition, not a failure to fix.** Prior art: the deletion in the spawning session lost nothing, and the credential it carried already appeared three times elsewhere. Recommending a rewrite where deletion is correct is itself a defect — the same repair discipline Rule 29 codifies.

5. **No self-approval.** If the subagent fails to launch or returns shallow results, troubleshoot and re-run. Never substitute a composer self-read — the composer has the whole corpus in context and is the single reader least able to perform this check. Same rule as Steps 5 and 5.6; here the reasoning is strongest.

---

## Step 6: Generate the Documents

Create structured content at `/tmp/craig_application.json`:

**`role_type` is required** (added 2026-08-18, Bundle P1). It is the Gate A item 3 classification, already chosen hours earlier — this only records it. Without it `preflight_check.py` Check #40 **fails closed** on the three data-foundation lines (SQL / Python / BI dashboard development) and flags them as ordinary auto-drops, because it cannot tell whether the proportionality carve-out applies. Use one of the five verbatim: `Healthcare Platform + Analytics`, `Clinical Data + EHR Infrastructure`, `Platform + Data + Intelligence`, `0→1 Startup`, `Healthcare Edtech`.

```json
{
  "company": "Company Name",
  "role_title": "Exact Role Title",
  "role_type": "Healthcare Platform + Analytics",
  "resume": {
    "header": {
      "name": "Craig Slater",
      "email": "[REDACTED EMAIL]",
      "phone": "[REDACTED PHONE]",
      "linkedin": "LinkedIn",
      "linkedin_url": "https://www.linkedin.com/in/craig-slater/",
      "location": "[REDACTED LOCATION] (US)"
    },
    "summary": "tailored summary text here",
    "experience": [
      {
        "company": "COMPANY NAME",
        "location": "Remote",
        "title": "Job Title",
        "dates": "Mon YYYY – Mon YYYY",
        "description": "Optional one-line company description (will render italic)",
        "bullets": ["bullet 1", "bullet 2", "bullet 3"]
      }
    ],
    "skills": {
      "Most Relevant Category": ["skill 1", "skill 2"],
      "Second Category": ["skill 1", "skill 2"],
      "Third Category": ["skill 1", "skill 2"]
    },
    "education": {
      "degree": "Bachelor of Arts, Quantitative Economics, Minor in Psychology",
      "school": "HARVARD COLLEGE, Cambridge, MA",
      "note": "Member of Varsity Rowing Team"
    }
  },
  "cover_letter": {
    "date": "Month Day, Year",
    "company_greeting": "Hiring Team at [Company]",
    "paragraphs": ["para 1", "para 2", "para 3", "para 4"],
    "closing": "Best regards,"
  }
}
```

**Note on `company_greeting`:** do NOT include "Dear" — the script adds it automatically. The value is just e.g. `"Hiring Team at [REDACTED COMPANY]"` (no "Dear", no trailing comma).

Then run (replace `SKILL_DIR` with the actual path):

```bash
pip install python-docx weasyprint --break-system-packages -q

mkdir -p /tmp/craig_output

python SKILL_DIR/scripts/generate_docs.py /tmp/craig_application.json /tmp/craig_output/
python SKILL_DIR/scripts/generate_pdfs.py /tmp/craig_application.json /tmp/craig_output/
```

**Resume formatting rules (permanent — do not change):**
- Job title renders on the **same line** as company + location, separated by an em dash: `COMPANY NAME, Location — Title [tab] Dates`
- Never put the job title on a separate line below the company row
- Applies to both `.docx` and `.pdf` outputs

**Cover-letter one-page gate (permanent — added 2026-06-28, Craig feedback):**
- **The cover letter MUST render to exactly 1 page, every time** (`.docx` and `.pdf`). Craig directive 2026-06-28: "fix that every time so the cover letter remains 1 page."
- `generate_pdfs.py` self-checks: it renders the cover letter, counts pages, and prints `⚠ Cover Letter PDF is N PAGES …` when >1 (or `✓ … (1 page)` when correct). **Do not deliver a cover letter whose generator printed the multi-page warning.**
- **Fix order — formatting first, content last (Craig explicitly authorized changing formatting / margins / borders, so a spill does NOT have to be a content cut):** (1) tighten the cover-letter template knobs — `generate_cover_letter_html` in `generate_pdfs.py` (`@page` margins, `line-height`, `p { margin-bottom }`, `.closing` / `.closing-line` spacing) and the parallel `.docx` knobs in `generate_cover_letter` in `generate_docs.py` (section margins, paragraph `space_after`); (2) only if formatting alone can't recover the page, trim the lowest-value content (a rhetorical-flourish tail clause, a redundant descriptor) — **never** a Phrase Lock, a metric, or an evidence sentence.
- **Protected signature space (added 2026-06-28, Craig feedback — do NOT tighten for the 1-page goal):** the gap between "Best regards," and the typed name is a fixed, standard ~30pt space so Craig can add his signature. It is set by `.closing-line { margin-bottom: 30pt }` (`generate_pdfs.py`) and the signature paragraph's `space_before=30` (`generate_docs.py`). When the letter spills, recover page space from the OTHER knobs (margins, line-height, paragraph spacing) — never by shrinking this signature gap. (Origin: the first 1-page tightening collapsed this gap along with everything else, leaving no room to sign.)
- The template was tightened 2026-06-28 (PDF: margins `0.55in 0.75in 0.5in 0.75in`, `line-height 1.28`, `p margin-bottom 5.5pt`, protected `.closing-line` signature gap `30pt`; `.docx` margins + spacing to match) and fits a typical 6-paragraph / ~500-word letter on one page with headroom. Longer letters may still need a trim — tighten formatting first.
- **Verify before delivery (Step 8):** read the rendered cover-letter PDF and confirm it is 1 page. The generator's page-count line is the mechanical signal; the visual read is the confirmation.

---

## Step 7.4: Post-Repair Sweep — NOT SHIPPED (S12, 2026-08-11)

**There is no Step 7.4. Do not run one.** A blocking post-repair gate was built at S12 (`scripts/post_repair_sweep.py`) to close `evals/eval-44-transcarent.md` action (b′), and it **failed its closing verification** — 5 Blockers, 3 High. Two of them made it unusable in practice rather than merely incomplete: its Rule 7 gate test inverted the reservoir logic in `references/voice-rules/rule-7-skills-two-gate.md`, and its enumeration parser read appositions as lists. Measured against R1, [REDACTED COMPANY], and the shipped Transcarent materials, it returned 11–15 blocking findings **per application on Craig-approved, verifier-passed content**. A blocking gate that noisy gets switched off, which would leave the S11 hole open and burn the fix with it.

The script stays on disk, unwired, carrying an UNSHIPPED banner. The full finding set is in `ROADMAP.md` → `## Completed` → the S12 entry and `eval-output/s12-verifier-findings.md`; S12b closes it.

**The gap this was meant to close is still open**, and it is the largest known one in the skill: every gate audits the *composed* draft, Step 5.5's delta re-verification now fires whenever a repair changed prose (widened 2026-08-19; it previously fired only on a Blocker or High) but still ends when the gauntlet ends, and five of S11's eight defects were introduced by the repair loop rather than the draft.

---

## Step 7: Output Routing

Canonical archive: `~/aios/projects/job-search-continued/outputs/` — the **active** job-search project's `outputs/`.

> **Active-project routing note (updated 2026-06-27).** The predecessor `projects/job-search/` is closed (it landed the [REDACTED COMPANY] offer, 2026-05-28); new deliverables route to its successor `projects/job-search-continued/`. If the active job-search project ever rolls over again, add the new project's `outputs/` here **and** to the four `cp` targets below, **and** to `DEFAULT_OUTPUTS_DIRS` in `scripts/canonical_diff.py` + the Step 0.4 / Step 4f read-path lists. The READ paths in Step 0.4 (recent-application sweep) and Step 4f (canonical-diff) scan **both** `job-search-continued/outputs/` (active — freshest) and `job-search/outputs/` (predecessor — historical archive), most-recent-across-both, so the freshest canonical is always picked up regardless of folder.

Convenience copy: Craig's Desktop

After `generate_docs.py` and `generate_pdfs.py` finish, copy files to both locations:

```bash
cp "/tmp/craig_output/Slater, Craig - Resume ([Company]).docx" "<aios mount>/projects/job-search-continued/outputs/"
cp "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).docx" "<aios mount>/projects/job-search-continued/outputs/"
cp "/tmp/craig_output/Slater, Craig - Resume ([Company]).pdf" "<aios mount>/projects/job-search-continued/outputs/"
cp "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).pdf" "<aios mount>/projects/job-search-continued/outputs/"

mv "/tmp/craig_output/Slater, Craig - Resume ([Company]).docx" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).docx" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Resume ([Company]).pdf" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).pdf" "<Desktop mount>/"
```

If `~/aios` or Desktop is not mounted, use `request_cowork_directory` to mount them (paths: `/Users/craigslater/aios`, `/Users/craigslater/Desktop`).

Output filenames (all four land in both locations):
- `Slater, Craig - Resume ([Company]).docx`
- `Slater, Craig - Resume ([Company]).pdf`
- `Slater, Craig - Cover Letter ([Company]).docx`
- `Slater, Craig - Cover Letter ([Company]).pdf`

---

## Step 7.5: Canonical Backport Audit

**This step closes the canonical-persistence leak surfaced by Eval 14 ([REDACTED COMPANY], 2026-04-29). It runs after Step 7 (output routing) and before Step 8 (present results).**

Each session's delivered cover letter contains the freshest working canonical for each role's evidence sentence. Without an explicit backport step, those calibrations live only in the .docx and never propagate back into `craig-profile.md`, `exemplars.md`, or `voice-rules.md` — so the next session re-derives them. The Step 0.4 sweep catches this from the receiving end; Step 7.5 closes the loop from the sending end.

### Workflow

1. **For each role-evidence sentence in the delivered cover letter** (Consulting, KTP, CentralReach PM, Charli — each role's primary evidence sentence in the cover letter), compare against:
   - `craig-profile.md` extended bullet library for that role
   - `exemplars.md` Phrase Lock canonical phrasings (PL #1–#5)
   - `voice-rules/rule-18-canonical-bullet-fidelity.md` canonical patterns (Three-Initiative attribution, causal-chain naming, etc.)

2. **Identify any phrasings in the delivered letter that differ from the source files.** Common drift surfaces:
   - PL #5 form (long "of delivering the payments system" vs. short "of delivery")
   - [internal product name] wording variations (build-out / centralized clinical insights / fragmented data collection system)
   - Three-Initiative parallel-gerund structure (1-sentence vs. 2-sentence split)
   - Apposition forms ("an EHR for autism and IDD care providers" vs. canonical italic "Clinical and practice management EHR solutions for the autism and IDD healthcare space")
   - User-naming variants (PL #1 "clinicians and billers" vs. canonical "clinical and practice management teams")
   - Hook framing patterns that the next similar role might want to inherit

3. **For each deviation, take one of three actions:**
   - **(a) Update the source file** with the new canonical, adding an inline provenance note (`Origin: [Eval N — Company Name], [date]`). Apply when the deviation is a deliberate calibration approved by Craig that should be the new default.
   - **(b) Document the deviation as a session-specific variant** in the eval file. Apply when the deviation was a one-off adaptation for that role's specific JD/Brief context and should NOT be the default for other applications.
   - **(c) Flag for next-session review** if the deviation status is unclear. Note in the eval file's "Open follow-up" section.

4. **Append a "Canonical Backport Audit" section to the eval file** (e.g., `evals/eval-N-[company].md`) summarizing actions taken under (a), (b), (c).

### Worked example — Eval 14 [REDACTED COMPANY]

Deliverables backported during Eval 14:
- **PL #5 "of delivery" form** — `verify_phrase_locks.py` PL #5 list updated to accept the four "of delivery" variants; `exemplars.md` PL #5 documents the form as preferred when antecedent is established. Action (a). Provenance: [REDACTED COMPANY] corrected.docx Round 5b origin + [REDACTED COMPANY] Round 1 reaffirmation.
- **Rule 3 0→1 healthcare-JD exception** — `voice-rules/rule-3-charli-by-role.md` + `craig-profile.md` 0→1 framing rule updated with Gate 2 exception clause. Action (a). Origin: [REDACTED COMPANY] Round 3.
- **[internal product name] cover-letter wording** — used in delivered letter ("I owned the build-out of centralized clinical insights within [internal product name], transforming a fragmented clinical data collection system into a decision-grade insights platform — driving time-to-insight from hours to under five minutes, which enabled the retention and expansion of a major enterprise customer by more than 30%") but NOT yet promoted to `craig-profile.md` extended bullet library as canonical. Action (c) — flagged for next-session review. **Resolved 2026-05-01 (v4 Session 3 candidate C12): promoted to craig-profile.md CentralReach PM Extended bullet library with provenance, attribution parse, Rule 12 carve-out cross-reference, and use guidance. Action (a).**
- **JD-pulled hook framing** ("With two additional U.S. health systems joining [REDACTED COMPANY]'s data consortium soon, the product challenge at the center of this role is turning…") — session-specific adaptation that depends on the JD's distinctive pipeline disclosure. Action (b) — document as session-specific in eval-14, do NOT promote to default.

### Cost calibration

This step is fast — ~5 minutes if the deliverable is clean. For sessions with many calibrations (like Eval 14), it can take 10-15 minutes to fully backport. The cost is worth it because every backported canonical eliminates one drift recurrence in future sessions.

### When this step is skipped

If the delivered cover letter uses ONLY canonical phrasings unchanged from the source files, Step 7.5 is a no-op — note this in the eval file and proceed. This is the rare case for clean first-pass deliveries on familiar role-types; it should be the goal state.

---

## Step 7.6: Post-Delivery Revision Gate

**Added 2026-08-06 (`job-search-continued` S5) from CF-15 of the 2026-08-04 portability smoke.**

Any revision made **after** the Step 5 verifier passes have run — whether prompted by Craig's review, a self-caught defect, or a formatting fix — falls into one of two classes, and the class determines what must re-run.

| Class | What changed | What must re-run |
|---|---|---|
| **Prose revision** | Any change to sentence content: hook wording, a bullet's phrasing, a skills line, an evidence sentence, a transition, a deletion or addition of a clause | **Re-spawn the Step 5 rule-lens verifier on the revised document before the eval is sealed.** Mechanical checks are not a substitute. **Also re-run Step 5.7** (readability) on any cover-letter prose change, and **Step 5.6** (quality-lens) when the hook or bridge changed. **The 5.7 re-run is a fresh Pass 1** — it reads prose no prior pass saw, so an exhausted escalation ladder does not block it (Craig, 2026-08-18; see Step 5.7 § "What consumes a pass"). |
| **Formatting-only** | Bolding, page guards, dates, filenames, whitespace, margins, font sizing | Mechanical only — phrase locks, pre-flight, canonical diff. No re-spawn. |
| **Cohesion-only** *(added 2026-08-25, Craig's ruling, S30)* | An edit that changes prose while adding **no claim, no referent and no modifier** — in practice a discourse connector, a conjunction, or a transition word. The origin case is `"I built"` → `"I also built"`. | **Rule lens only.** Mechanical checks in full, **plus** a Step 5 rule-lens re-spawn. **No Step 5.7 re-spawn.** The composer must record, per edit, which of the three negatives it satisfies. |

**When the two are ambiguous, treat the revision as prose.** The cost of an unnecessary re-spawn is minutes; the cost of a missed one is a document Craig submitted that no verifier ever read.

### The cohesion-only class — scope, and the guardrails that make it safe

**Why it exists.** At S30 a **one-word connector** classified as prose, mandating a re-spawn of both the rule lens *and* the readability lens. The rule-lens spawn earned its keep (repetition thresholds, verb discipline, whether the connector was factually earned — it confirmed all three and corrected the composer's citation of which verb table governs). The readability spawn had **no mechanism to fire**: Check #47 asks whether a first-time reader parses a sentence and whether it says something new, and its two PARSE classes are `unresolved-referent` and `stacked-compression`. A pure connector adds no modifier (so compression cannot stack), no pronoun/demonstrative/definite noun phrase (so no referent can dangle), and no claim (so nothing can be un-new). Craig's ruling: *"a rule that forces obviously-unnecessary work tends to get quietly ignored, which is worse than a narrow written exemption."*

**⚠️ The three-part test is a conjunction and it is written down per edit, not asserted.** An edit qualifies **only** if the composer can state all three in the composer notes:
1. **No claim added** — nothing is now asserted about Craig, the company, or an outcome that was not asserted before.
2. **No referent added** — no pronoun, demonstrative, or definite noun phrase enters that a reader must resolve.
3. **No modifier added** — nothing new stacks onto a noun phrase.

Fail any one and it is a **prose revision**. "It's only a small change" is not the test and never was; **size is not the criterion** — eval-40's fatal misfiling was a *hook* change, and a one-word change to a claim ("performance" → "assessment performance", S30) is a prose revision under this test because it bounds a claim.

**⚠️ Read the risk honestly: this class is the eval-40 shape with a fence around it.** Eval-40's shipped v3 was never verifier-passed because hook prose changes were recorded as *"targeted hook/bolding/formatting changes"* — a **reasoned exemption**, made by the person who made the edit. That is structurally what this class is. The three differences are the whole safety margin: the test is **written per edit** rather than asserted in a phrase; it is a **conjunction of three negatives** rather than a category label; and the **rule lens still runs**, so the class narrows what re-runs from two lenses to one, never to zero. **A cohesion-only classification with no recorded three-part test is not a classification — it is the eval-40 defect, and the edit is a prose revision.**

**Not covered — always prose:** any wording change to a claim, metric, credential, scope bound or canonical phrasing; any added or removed clause; any pronoun or demonstrative change; anything touching the hook's anchor facts. **When in doubt, it is prose** — the ambiguity rule above governs this class exactly as it governs the other two.

> **A post-repair sweep belongs here and does not exist yet (S12, 2026-08-11).** A post-delivery revision is by definition an edit made after the Step 5 gauntlet began — the exact case eval-44 action (b′) is about, and the case Step 5.5 does not reach (since 2026-08-19 it fires whenever a repair changed prose, but it still ends when the gauntlet ends). A candidate gate was built at S12 and **failed its closing verification**; it is unwired and must not be run. See `ROADMAP.md` → `## Completed` → the S12 entry for the finding set. Until it ships, this gate's re-spawn is the only coverage a post-delivery revision gets, and it does not cover skills Gate 2 on a repaired line, orphan referents, or source fidelity of changed prose.

**Why Step 5.7 belongs in this gate specifically (added S7).** Every defect that created Step 5.7 was a **post-delivery** catch — Craig reading the submitted letter. A gate that covers post-delivery prose changes with the rule-lens alone reproduces exactly the condition the readability pass exists for: prose that is rule-clean and unreadable. This is also the one gate where a readability *repair* is most likely to introduce a rule violation, which is why the rule-lens re-spawn stays mandatory alongside it rather than being replaced by it.

**Why mechanical checks do not substitute.** Pre-flight is regex-tier and `canonical_diff` compares against canonical phrasings. Neither reads register, back-pointers, or embedded-fact recitation — the dimensions a hook revision most often breaks.

**Version-tagging requirement (this is the half that makes the gate auditable).** Every verifier-result figure recorded in an eval must name the document version it describes — `rule-lens (v1): 0/0/3/1`, not `rule-lens: 0/0/3/1`. An untagged figure is read by every future reader as describing the shipped document. If the shipped version was never verifier-passed, the eval must say so in the same line: `rule-lens (v1 only — v3 shipped unverified): 0/0/3/1`.

**Origin.** Eval 40's shipped **v3** was never verifier-passed. Its archived headline figures (rule-lens 0/0/3/1, quality-lens Ship, Hook 5/5) describe **v1**; `evals/eval-40-pointclickcare.md` (§ Verification / post-delivery revision note) records that no re-spawn was run for the "targeted hook/bolding/formatting changes" — but v2 and v3 changed hook *prose*, not just formatting. Post-fix verification was mechanical only (phrase locks 5/5, preflight 0/0/1/0, canonical_diff 0 DRIFT). No harm landed: the portability smoke's Part B was the first full rule-lens read of the submitted text and returned 0/0/0/2 Low. The gap is structural, not a one-off — it reproduced twice more during the [REDACTED COMPANY] application (S3, 2026-08-05).

---

## Step 8: Present Results

Use `present_files` if available. Briefly note in chat:

- The hook template (A/B/C) and why it fit this company.
- Which 2–3 achievements you foregrounded in the evidence paragraph.
- Any domain gaps and how you handled them.
- The verifier's severity counts, **tagged with the document version they describe** (e.g. "v1: 0 Blockers, 0 High, 2 Medium") — per Step 7.6. If a post-delivery prose revision has since occurred, say whether the shipped version was re-verified.
- Any **ASK-CRAIG** skills lines from Step 2.5 item 2c that are still unresolved — these are credentials that may be real but are unrecorded, and they need Craig's answer, not silent removal.

Keep the explanation short — Craig reads the documents himself.

### Verifier-round delta table (mandatory — the companion to Step 4i)

**Added 2026-08-25 (`projects/job-search-continued/` S30), and it is half of one request.** Step 4i gives Craig the v1 draft; this table gives him what the rounds *did* to it. Delivering v1 without the deltas leaves him diffing by eye across a long session, which is the work this table exists to do for him.

Present a compact table covering every version from v1 to shipped, one row per change that altered prose:

| Version | Round that caused it | What changed (verbatim before → after) | Check / gate | Severity |
|---|---|---|---|---|
| v1 → v2 | Step 5 Pass 1 (rule lens) | "[old string]" → "[new string]" | Check #N / Gate X | Blocker / High / Medium / Low |
| v2 → v3 | Step 5.6 (quality lens) | … | … | … |
| v3 → v4 | Step 5.7 (readability lens) | … | … | … |

**Rules for the table:**
- **Quote verbatim on both sides.** A paraphrased "tightened P3" tells Craig nothing and is exactly the opacity Step 4i was added to remove.
- **A round that changed nothing still gets a row**, reading "no prose change." A clean lens is a result, and its absence from the table is indistinguishable from a lens that never ran.
- **Include Medium and Low repairs, not just Blocker/High.** Since the 2026-08-19 widening, Step 5.5 re-verification fires whenever *any* repair changed prose, at any severity — so the low-severity edits are part of the trail too.
- **A disposition that changed no prose is not a row** — it belongs in the composer notes, not here. The table tracks what happened to the writing.
- **Craig-review rounds get rows too**, marked as such, so a v1 comment or a post-delivery revision is legible alongside the machine rounds.

Where a session ships v1 unchanged, the table is one row and says so — that is the goal state, not an empty table.

---

## Step 8.5: Application Questions (On-Demand, Post-Delivery)

After the resume and cover letter are delivered (Step 8), Craig may encounter application questions during submission. He will paste each question in chat and expect a copy-pasteable answer.

**This step is conversational and on-demand — it is NOT part of the generation pipeline.** It happens only when Craig pastes a question. There is no document output, no JSON extension, and no verifier subagent run.

### Workflow

When Craig pastes an application question:

1. **Classify** the question by archetype (see `references/question-archetypes.md`): Experience-with-X, Why-this-company, Tell-me-about-a-time, or Open-ended.
2. **Select the lead story** using the same JD Briefing and Role-Type Targeting Guide from this application. For Experience-with-X, the question's [X] determines the lead role (see the story-selection table in `question-archetypes.md`).
3. **Compose the answer** per the archetype's framework, respecting the coherence rules in `question-archetypes.md` (inherit JD Briefing vocabulary, don't contradict cover letter, don't repeat verbatim, match gap framing).
4. **Self-check** against `qa-checklist.md` checks #26–28 (coherence, word count, source verification) and Rule 25 voice rules before posting.
5. **Post the answer** in chat as plain text. No code block, no markdown formatting Craig would need to strip. Report the word count.

If Craig provides a word or character limit, compose to 90% of the limit. If no limit, use the archetype's default target (150–250 for Experience-with-X, 150–200 for Why-this-company, 200–300 for Tell-me-about-a-time, 100–200 for Open-ended).

### Why no verifier

The verifier subagent exists because the composer self-auditing in the same context window systematically misses drift on long-form outputs (13+ issues observed in prior evaluations). Application answers are short (150–300 words), composed one at a time in conversation, and Craig reviews before pasting. The overhead of spawning a verifier for a 200-word answer is not justified — the composer self-checks against the 3 answer-specific QA items instead.

---

## Workflow Summary

```
Step 0    Load reference files — eager: craig-profile, career-narratives, voice-rules, exemplars, qa-checklist; on-demand: corrections-log, question-archetypes, reader-modeling
Step 0.4  Recent-Application Canonical Sweep — read most recent similar-role delivered .docx, extract working canonicals → /tmp/composer_notes.md (Eval 14)
Step 0.5  Company Intelligence — build the Company Brief (web research → structured brief → specificity diagnostic)
Step 1    JD Briefing — hard gate (all nine `qa-checklist.md` Gate A items: concepts, required/preferred quals, role type, hook angle, JD language mapping, AI/ML framing decision, company-specific hook material, "why now" signal, phrase locks)
Step 1.5  Reader Model — who is reading this? (persona, competitive positioning, negative space analysis → /tmp/reader_model.md)
Step 1.6  JD-Vocabulary-First Resume Composition Inventory — pre-composition JD-vocab inventory
Step 2    Compose resume (voice-rules + exemplars, informed by Reader Model)
Step 2.5  Skills-Section Strict Per-Line Two-Gate Audit — every rendered skills line, incl. source citation for non-reservoir lines
Step 3    Compose cover letter (voice-rules + exemplars + Company Brief + Reader Model)
Step 4    Mechanical phrase-lock check (scripts/verify_phrase_locks.py) + 4f cross-session canonical diff (scripts/canonical_diff.py) + 4g hook currency + role-relevance audit (composer-side; closes [REDACTED COMPANY] eval gap)
Step 4h   Resume JD-Vocabulary Coverage Audit — post-composition coverage against the 6-of-8 floor
Step 4i   Pre-Verifier Draft Delivery — v1 résumé + cover letter to Craig as chat text, BEFORE any verifier spawns; non-blocking; no .docx/.pdf at v1
Step 5    Spawn verifier subagent (agents/verifier-prompt.md)
Step 5.5  Re-verify after fixes (mandatory if any repair changed prose — re-spawn verifier on updated draft)
Step 5.6  Quality-lens verifier pass (agents/verifier-quality-prompt.md) — hook / intersection / register / bonus-qual + interpretive-prose flags; mandatory every application
Step 5.7  Readability pass (agents/verifier-readability-prompt.md) — reference-BLIND sentence lens; pass ONLY letter + JD + company/role; mandatory every application
Step 6    Generate .docx and .pdf (only after 5/5.5 has every Blocker+High fixed and every Medium+Low addressed, AND Steps 5.6 and 5.7 have run — both are mandatory, neither is skippable)
Step 7    Route outputs to archive + Desktop
Step 7.5  Canonical Backport Audit — diff delivered phrasings against source files, persist drift or document deviation (Eval 14)
Step 7.6  Post-Delivery Revision Gate — prose revisions re-spawn Step 5 (+ 5.7, and 5.6 on hook/bridge) before the eval seals; formatting-only stays mechanical
Step 8    Present results + verifier-round delta table (v1 → shipped, verbatim before/after per prose change)
Step 8.5  Application questions — on-demand, conversational (question-archetypes.md + Rule 25 + checks #26–28)
```

The skill's discipline is: prescriptive rules live in `voice-rules.md` and `exemplars.md`, detection lives in `qa-checklist.md`, historical context lives in `corrections-log.md`, and audit is done by a separate subagent against the same checklist. Nothing about quality is implicit in the composer's context — every check is either in a reference file or in the verifier's prompt.
