<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The `job-materials` skill's SKILL.md—the runtime entry point for tailored-resume + cover-letter generation. Defines the composer/verifier multi-agent pattern, the reference-files loading sequence, the per-step composition workflow (Steps 0–9), and the eval-driven correction-loop rules the verifier subagent audits against.
> **What was redacted.** Substantial. PII (phone, location, private email) per registry rows pii-001 / pii-005 / pii-006. 13 distinct active-target-company entities appearing 72 times across the skill substituted to `[REDACTED COMPANY]` per registry rows tgt-001 / tgt-003 / tgt-005 / tgt-011 / tgt-017 / tgt-021 / tgt-025 / tgt-028 / tgt-029 / tgt-034 / tgt-036 / tgt-047 / tgt-059 / tgt-062 / tgt-063 / tgt-064 — including three short-form variants (rows tgt-062, tgt-063, tgt-064) caught as registry gaps during this Session 6 port and added in the same session. One third-party named individual phrase referring to Craig's career coach (per registry ind-005). 8 occurrences of an internal prior-employer product name (per registry prior-001) and 1 prior-employer protocol-adoption phrase (per registry prior-009). Prior-employer company names (CentralReach, Charli Charging, Knowledge to Practice / KTP) remain visible per Session 0 Q3—those names are LinkedIn-public; only beyond-LinkedIn narrative gets masked.
> **Why it's included.** Backs the composer/verifier pattern cited throughout the portfolio's case-study tier (CS#2 in particular) and the "36 evals, ~40 detectors, hundreds of errors caught and fixed autonomously per month" quantitative spine: every workflow step, every detector reference, every encode-into-source rule lives in this file alongside CS#2.

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
- `references/voice-rules.md` — **prescriptive composition rules — index.** Per-rule files (`voice-rules/rule-1-healthcare.md` through `voice-rules/rule-28-interpretive-sourcing.md`) plus supporting `voice-rules/summary-construction.md` and `voice-rules/role-type-targeting.md`. Read the index in full at session start (covers Philosophy + Core Positioning Identity + per-rule navigation); load specific per-rule files on consult when their rule is invoked.
- `references/exemplars.md` — gold-standard templates: 5 Phrase Lock canonical phrases, Hook Templates A/B/C, Charli Product-Thinking Variant, canonical summary examples.
- `references/qa-checklist.md` — **detection layer.** Pre-generation gates A–D, composition checks 1–19, grammar checks 20(a)–(e), check 21, resume-specific checks. The verifier subagent runs against this checklist.

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

1. **Identify the closest-matching prior application** by scanning `~/.claude-local/projects/job-search/outputs/` for delivered cover letters. Prefer same-role-type matches (e.g., for a Healthcare Platform + Analytics role, scan recent healthcare PM letters; for a 0→1 / Greenfield role, scan recent non-healthcare 0→1 letters). When in doubt, pull the 1-2 most recent applications regardless of role-type.

2. **Extract the canonical phrasing from the prior letter for each role's evidence sentence:**
   - Consulting: payment-reconciliation framing, MRR clause form (long "of delivering the payments system" vs. short "of delivery"), Three-Initiative attribution pattern (1-sentence parallel-gerund vs. 2-sentence split). **PL #5 form-selection sub-rule (added Eval 15, 2026-04-30):** the compact "of delivery" form is preferred whenever the "payment reconciliation system" / "the payments system" antecedent is established earlier in the same sentence as the PL #5 hit. The long "of delivering the payments system" form is preferred when no antecedent is in the same sentence (PL #5 lands as the first mention of the system). When extracting the prior letter's PL #5 form, also note whether its antecedent is in the same sentence — that decides which form is the working canonical for the new letter, not just the prior letter's choice. Origin: Eval 15 [REDACTED COMPANY] (composer drifted to [REDACTED COMPANY]'s long form for a [REDACTED COMPANY] sentence whose structure matched [REDACTED COMPANY]'s compact-form precondition). **PL #1 + S2 shape form-selection sub-rule (added v4 Round 3, 2026-04-30 from Eval 15 Round 2 Finding B):** when extracting the Three-Initiative form from the prior letter, also evaluate whether PL #1 will be DROPPED in the new letter per the Rule 18 narrative-value gate. **If PL #1 will be dropped, run the mandatory pre-step from `voice-rules/rule-18-canonical-bullet-fidelity.md` "Sentence-weight discipline when PL #1 is dropped" sub-section BEFORE finalizing the P4 S2/S3 shape:** re-verify the gate disposition. If PL #1's content is borderline-defensible per the gate criteria — the JD has implicit signals for workflow integration / cross-team data sharing / adoption-driving / customer-experience workflows even if it doesn't use the verbatim Rule 18 trigger phrases AND the 1-sentence parallel-gerund 2-outcome canonical form would strengthen P4 — INCLUDE PL #1 (option (d) in the Rule 18 sub-section), which avoids the S3 anemia problem entirely. If the gate genuinely fires (PL #1 stays dropped), evaluate the four-option enumeration in Rule 18 to choose between (a) compress / (b) drop initiative 3 / (c) restructure S3 with canonical structural-problem framing / (d) include PL #1. Origin: Eval 15 [REDACTED COMPANY] (composer over-conservatively dropped PL #1 per gate firing on JD lacking verbatim "compliance" / "care-to-billing" hook; Round 3 review concluded the gate fired over-conservatively given [REDACTED COMPANY]'s PMS product + three-platform structure with implicit workflow-integration signals, and PL #1 should have been included).
   - KTP: how the multi-tenant analytics platform is named; user role naming
   - CentralReach: [internal product name] wording ("owned the build-out of centralized clinical insights within [internal product name], transforming a fragmented clinical data collection system…" — the [REDACTED COMPANY] / [REDACTED COMPANY] v7 form), causal-chain naming pattern ("driving X, which enabled Y")
   - Charli: 1-sentence vs. fuller form, breadcrumb selection ([open protocol]/$900→$400s vs. NFC vs. TOU vs. metrics-only)
   - Apposition pattern: how each role is introduced ("a healthcare SaaS platform serving X," "a healthcare edtech provider serving Y," "an EHR for Z care providers")
   - Hook structure / framing register

3. **Treat the prior letter's phrasings as the working canonicals** unless either (a) the JD/Reader Model explicitly demands a different framing, or (b) the reference files have been updated since that letter shipped. In case of conflict, the source-file version wins — but check the reference-file revision dates against the prior letter's delivery date to confirm.

3.5. **Classify each prior-canonical phrase by why it was canonical there (added v4 post-[REDACTED COMPANY] eval-17, 2026-05-01; scope extended to RESUME SKILLS LINES post-[REDACTED COMPANY] eval-21, 2026-05-05).** Before importing any phrase from the prior letter OR any skill line from the prior resume into the new draft, classify it into one of three categories — and apply the corresponding re-evaluation discipline:

   - **(a) JD-mirroring** — the phrase used the prior JD's specific vocabulary (e.g., [REDACTED COMPANY]'s "bespoke customer solutions" → "custom data" in cover letter; [REDACTED COMPANY]'s "modernization" → "modernization" framing; [REDACTED COMPANY]'s "GTM Modeling, market sizing, customer segmentation" → "Go-to-market modeling & market sizing" skill line). **JD-mirroring phrases must be explicitly re-evaluated against the new JD's vocabulary** — they earn their place in the new letter / resume only if the new JD has equivalent vocabulary. If the new JD doesn't, the phrase becomes residue from the prior letter and must be replaced or cut. **Diagnostic:** can the phrase be traced to a specific JD word/phrase in the prior letter's JD? If yes, the phrase is JD-mirroring and re-evaluation is mandatory.
   - **(b) Mastery-angle-driven** — the phrase reflects Craig's career through-line independent of any specific JD (e.g., "decision-grade products," "fragmented data," "data foundation"). These carry over reliably between similar role-types and are low-risk to import.
   - **(c) Brief-driven** — the phrase reflects company-specific facts from the prior Brief (e.g., specific apposition forms tied to company descriptions, specific named partners). These DO NOT carry over between letters — each new application has its own Brief and its own company-specific phrasing. The phrase must be re-derived from the new Brief, not imported from the prior one.

   **Resume skills section scope (added 2026-05-05 post-[REDACTED COMPANY] eval-21).** Step 0.4 sub-step 3.5 applies in full to the resume skills section, not just cover-letter prose. The same Step 0.4 import-from-prior-letter logic that drives cover-letter canonicals also drives skills-section structure: when composing for application N+1, the natural starting point is application N's skills section. Every skill line carried over from a prior application must pass Step 3.5's classification — JD-mirroring lines (e.g., "Go-to-market modeling & market sizing" from [REDACTED COMPANY], "Vertical SaaS product ownership" from a JD that explicitly named vertical SaaS) must be re-evaluated against the new JD's verbatim vocabulary per Rule 7 Gate 2. Mastery-angle-driven lines (e.g., "Platform architecture & systems thinking," "EDI/x12 (835/837 transaction sets)") carry over reliably. Brief-driven lines are rare in skills sections (skills don't typically depend on company-specific Brief facts) but the same import discipline holds for any that do.

   **Document the classification in `/tmp/composer_notes.md`** alongside the working-canonicals list (item 4 below). For category (a) JD-mirroring phrases, the documentation must include the prior JD's specific vocabulary the phrase mirrored AND a yes/no verdict on whether the new JD has equivalent vocabulary. If no, the phrase is replaced or cut. **The classification table in composer_notes.md MUST include resume skills lines** — not just cover-letter prose elements — when those lines were inherited from a prior application's skills section.

   **Why this exists:** Eval 17 ([REDACTED COMPANY], 2026-05-01) surfaced "custom data" carrying over from [REDACTED COMPANY] v7 because Step 0.4 imported it as a settled canonical without checking that "custom" in [REDACTED COMPANY] was specifically JD-mirroring ([REDACTED COMPANY]'s JD said "bespoke customer solutions"). [REDACTED COMPANY]'s JD doesn't use "custom" or "bespoke." The phrase was [REDACTED COMPANY] residue. **Eval 21 ([REDACTED COMPANY], 2026-05-05) surfaced the same failure mode at the resume skills section** — three lines ("Vertical SaaS product ownership," "Go-to-market modeling & market sizing," "ROI models & business case development") were imported from [REDACTED COMPANY]'s skills section where they were JD-mirroring ([REDACTED COMPANY]'s JD explicitly named GTM modeling / market sizing / customer segmentation; healthcare-tech vertical was [REDACTED COMPANY]-relevant context). [REDACTED COMPANY]'s JD does not contain equivalent vocabulary. The lines became [REDACTED COMPANY] residue at the [REDACTED COMPANY] resume. Craig caught this on post-delivery review. Original Step 0.4 sub-step 3.5 was scoped to cover-letter prose only; this revision extends the scope to resume skills lines.

4. **Document the sweep in `/tmp/composer_notes.md`** in this shape:

```
## Step 0.4 — Recent-Application Canonical Sweep

Reference letter(s) consulted: [filename + delivery date]

Working canonicals from prior letter:
- Consulting MRR clause: [exact wording]
- Consulting Three-Initiative form: [1-sentence parallel-gerund / 2-sentence split / not-included]
- CentralReach [internal product name] wording: [exact wording]
- KTP / Charli / apposition patterns: [as relevant]

Phrase classification (per Step 3.5 — added eval-17, 2026-05-01; resume-skills-lines sub-table added v5 Session 1, 2026-05-06 from eval-22 [REDACTED COMPANY] procedural-application failure where the rule was codified hours earlier in the same session and the composer didn't apply it; visible-absence-of-rows is the enforcement mechanism):

**Cover-letter phrases:**
| Phrase | Category | If JD-mirroring: prior JD word/phrase | If JD-mirroring: new JD has equivalent? | Disposition |
|---|---|---|---|---|
| [phrase 1] | JD-mirroring / mastery-angle-driven / Brief-driven | [prior JD vocab] | yes / no | import / re-derive / cut |
| [phrase 2] | ... | ... | ... | ... |
[repeat per imported phrase]

**Resume skills lines (mandatory — pre-populate empty rows for every skill line carried over from the prior application's resume; visible absence is the enforcement mechanism):**
| Skill line | Category | If JD-mirroring: prior JD word/phrase | If JD-mirroring: new JD has equivalent? | Disposition |
|---|---|---|---|---|
| [skill line 1 from prior resume] | JD-mirroring / mastery-angle-driven / Brief-driven | [prior JD vocab] | yes / no | import / re-derive / cut |
| [skill line 2 from prior resume] | ... | ... | ... | ... |
[repeat per skill line carried over from prior application's skills section]

If no skill lines were carried over from a prior application's resume (e.g., skills section was drafted from `craig-profile.md` JD-Triggered Specifics directly), write explicitly under the Resume skills lines sub-table: "No skill lines imported — drafted skills section from craig-profile.md JD-Triggered Specifics directly." This is the only acceptable empty state for this sub-table; leaving the sub-table empty without this override-line trips the verifier-side residual check (per `agents/verifier-prompt.md` Skills-section audit Step 0.4 sub-step 3.5 residual check, added v5 Session 1).

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

2. **Run 3–5 targeted web searches** (not open-ended browsing):
   - `[Company name] product` — product pages, About page, how value is delivered
   - `[Company name] funding OR Series OR raised` — Crunchbase/press for stage, trajectory, recent events
   - `[Company name] engineering blog OR product blog` — culture, tech stack, team priorities
   - `[Company name] competitors` — competitive landscape, differentiation claims
   - `[Company name] [domain-specific term]` — e.g., `[Company] FHIR interoperability` for healthcare companies

3. **Structure findings** into the seven-section Company Brief format and write to `/tmp/company_brief.md`:

   **Section 1 — Product Landscape:** What they sell, who they sell to (buyer persona), how value is delivered (SaaS, hardware+software, marketplace, managed service), domain and vertical.

   **Section 2 — Recent Signals (last 12 months):** Funding events, product launches, leadership changes, strategic pivots or expansions, public statements from leadership about priorities.

   **Section 3 — Competitive Positioning:** Named competitors (from company's own positioning, press, job postings), how they differentiate, market category they claim.

   **Section 4 — Culture & Team Signals:** Engineering/product blog themes, LinkedIn hiring patterns (backfill vs. new team), tech stack signals from job postings.

   **Section 5 — Inferred Pain Points:** What the JD + signals suggest the team is building toward, what "winning" looks like for this hire in the first 6–12 months, what organizational pressure the team is under (scaling, modernizing, launching, proving ROI).

   **Section 6 — Domain-Specific Context (conditional):** For healthcare: regulatory posture (HIPAA, HITRUST, HEDIS), payer/provider dynamics, interoperability stance (FHIR, HL7, claims data), care-delivery model. For non-healthcare: relevant regulatory or industry dynamics.

   **Section 7 — Company Moment (required):** What is happening at this company *right now* — the specific inflection point, transition, or challenge that makes this hire timely. This is NOT their general thesis or mission; it's their current moment. Examples: "expanding from single-product to multi-product platform," "just closed Series C and scaling the data team from 3 to 15," "migrating from legacy monolith to modern analytics stack," "entering the employer market after proving the health-plan channel." Name the moment in one sentence, then 2–3 supporting facts with source URLs. If research surfaces no clear moment, document that explicitly — "No specific inflection identified; hire appears to be steady-state growth/backfill" — rather than inventing one.

   **Current-year searches first (added 2026-05-04, [REDACTED COMPANY] eval).** Before composing Section 7, run targeted recency searches anchored on the current year: `[Company] [current year] partnership` / `[Company] [current year] launch` / `[Company] [current year] expansion` / `[Company] [current year] product`. The current-year search is the primary anchor; older sources serve as supporting context only. Do NOT start research from generic queries that surface older results — the company-moment-driven hook needs a current anchor, and starting with current-year queries forces the freshest signal to surface first.

   **Date-tag every fact (added 2026-05-04, [REDACTED COMPANY] eval).** Every claim in Section 2 (Recent Signals) and Section 7 (Company Moment) must include its source date in the Brief itself: not "rolling out integrated offerings" but "rolling out integrated offerings (announced ~2 years prior to composition)." Compute fact age at intake (e.g., "[partner launch] — 4 months old as of composition"). Sort Section 7 facts by recency: the freshest goes first as the primary Company Moment anchor; older facts are demoted to supporting context. Drop facts older than 18 months unless they establish durable scale (current-marketing claims like "[scale-figure] employer customers" — see `voice-rules/rule-24-company-intelligence.md` "Brief-fact currency discipline" for the durable-scale carve-out).

   **Source attribution (mandatory for all sections):** Every factual claim in the Company Brief must include its source — URL preferred, or "Company website / About page," "Crunchbase," "[Publication name], [date]" at minimum. If a fact cannot be attributed to a specific source, it does not go in the Brief. This is non-negotiable: the hook paragraph will reference Company Brief facts, and every fact used in the hook must be traceable after the fact. Unattributed claims in the Brief become unverified claims in the cover letter — which is a Data Accuracy Rules violation.

4. **Run the dual specificity diagnostic:**
   - **Test 1 (competitor-swap):** Can you articulate what makes this company's situation specific enough that swapping in a competitor's name would make the statement false? 
   - **Test 2 (current-moment):** Does the Brief name something happening at this company RIGHT NOW — not just what they do in general?
   
   Both tests must pass. If Test 1 fails, run 1–2 more targeted searches. If Test 2 fails, search specifically for recent news, product launches, funding, or leadership statements that reveal the company's current moment. Proceed after 5–7 total searches regardless — diminishing returns — but document which test(s) failed.

5. **Surface the Brief to Craig** as a 3–5 sentence summary before proceeding to Step 1. Craig can correct, add context, or say "looks good." This is NOT a blocking approval gate — if Craig says nothing, proceed. It prevents building on wrong assumptions about the company.

6. **JD-fact currency cross-check (added v4 Session 1, 2026-04-30).** For every quantitative or named claim in the JD itself — counts of customers / partners / programs ("two additional U.S. health systems joining soon," "fifth Blues plan," "200 million annual visits"), specific dates ("launched March 2025"), named partners ("partnered with Memorial Sloan Kettering"), recent funding rounds, or any other claim the JD asserts as a current fact — cross-check against the Company Brief search results and 1–2 targeted recency searches before letting the JD claim flow verbatim into the cover-letter hook or evidence prose.

   **Why:** the JD is a snapshot of the company at posting time. JDs sit on careers pages for weeks or months; the disclosed fact may have been superseded by a later announcement. Using a stale fact verbatim makes the hook feel out-of-date and risks landing as wrong on the reader's desk.

   **Sub-step procedure:**

   a. **Enumerate** the JD's quantitative or named claims. Pattern-match the same surfaces the hook fact-count gate looks for: counts, ordinals, named events, named partners, dates, funding rounds, multiplier verbs.

   b. **For each claim**, ask: "Could this plausibly have been superseded since the JD was posted?" If the JD says "two additional health systems joining soon," and Company Brief research shows a partnership announcement post-dating the JD, the claim is stale.

   c. **Run a targeted recency search** for any claim that could plausibly be stale: `[Company] [topic of claim] 2025 OR 2026` or `[Company] [partner type] announcement`. Document findings in the Company Brief as Section 7 (Company Moment) supporting facts with source URLs.

   d. **For verifiable-current claims**, the JD-pulled framing is durable — use the JD wording verbatim (the JD source itself is your traceable evidence). For potentially-superseded claims, either (i) update the framing to reflect the more recent fact (with the new URL committed), or (ii) reframe around a more durable JD signal that doesn't depend on the specific count / date.

   **Worked example — [REDACTED COMPANY] (Eval 14, 2026-04-29):**

   - JD said "two additional U.S. health systems joining soon." 
   - Company Brief search surfaced an [recent-months] trade-press announcement: [major academic medical center] had joined as [REDACTED COMPANY]'s newest health system partner — post-dating the JD's "soon" framing.
   - Round 4 hook initially used the JD claim verbatim. Craig flagged: pipeline overclaim — "two more on the way" beyond [major academic medical center] is unverifiable from the JD's posting date.
   - Round 5 fix: hook anchored on [major academic medical center]-as-newest-partner from the verifiable trade-press source.
   - Round 7 final: hook returned to JD-verbatim "two additional U.S. health systems joining [REDACTED COMPANY]'s data consortium soon" because the JD's pipeline disclosure is itself the durable source — and the JD-framing is distinctively useful (most JDs don't disclose pipeline that way). The currency check still ran; the conclusion was that the JD claim is durable when used JD-verbatim with the JD as the documented source. The discipline is the check, not the outcome — running the check produces the right disposition either way.

   **Pass condition:** every JD-claim used in cover-letter prose has been cross-checked for currency. Where staleness was detected, the prose was updated or reframed. Where currency was confirmed, the claim flows verbatim with the JD as documented source.

   **Fail condition:** a JD-claim flowed into the hook or evidence without a currency check. The verifier cannot run this check (it doesn't have access to recency-search results); the discipline must run at composer time during Step 0.5.

### Depth calibration

The Brief is a pre-generation input, not a deliverable. Each section: 2–5 bullet points. Total target: ~300–500 words. If research takes more than ~10 minutes of web searching, stop and work with what you have. The goal is grounded specificity, not exhaustive analysis.

### What the Brief does NOT do

- It does not replace the JD Briefing (Step 1). Step 1 is about the role; Step 0.5 is about the company.
- It does not produce deliverable-quality prose. It's structured research notes.
- It does not persist between sessions. Each application gets a fresh Brief.

---

## Step 1: JD Briefing — Hard Gate Before Drafting

**This is a pre-generation gate. Do not skip and do not proceed until you can complete every sub-step.**

Work through `qa-checklist.md` Gate A (JD Briefing) in full. The briefing produces:

1. **Top 6–8 JD concepts** as an explicit bulleted list. Example: `healthcare data platform · population health · provider + payer workflows · data unification · multi-tenant analytics · decision-grade insights · SQL · HL7/FHIR (preferred) · AI/ML (preferred)`.
2. **JD vocabulary mapping** — per `voice-rules/summary-construction.md`: the JD's own words for (a) mastery angles, (b) outcome/impact register, (c) process/activity vocabulary. Every tailored phrase uses JD vocabulary, not Craig's internal labels.
3. **Role-type classification** — pick one from `voice-rules/role-type-targeting.md`: Healthcare Platform + Analytics / Clinical Data + EHR Infrastructure / Platform + Data + Intelligence / 0→1 Startup / Healthcare Edtech. The selected role type determines mastery-angle lead order, canonical verb choice per role, and Layer 2 pattern candidates.
4. **Hook angle determination (research-first, not template-first)** — The hook's shape is determined by the Company Brief's Section 7 (Company Moment), not by selecting a template and fitting research into it.

   **Required sequence:**
   - (a) Start from the Company Moment: what is happening at this company right now? Name the inflection point or challenge in one sentence.
   - (b) Ask: what hook shape does this moment demand? Write a 1–2 sentence draft hook that names the moment and connects it to the product problem Craig solves. This is the **research-driven hook candidate.**
   - (c) Only then check: does this candidate happen to fit a template (A: bet, B: approach, C: positioning) from `exemplars.md`? If yes, note which template and use the template's proven structure. If no, the research-driven candidate IS the hook — do not force it into a template.
   - (d) **If a template IS chosen, document what the non-template alternative would have looked like.** This forces genuine consideration. If the non-template version is more specific to the company's current moment, it wins — even if a template technically "fits."

   **Document:** the chosen hook angle, why it fits this company's specific moment, which Company Brief facts (with source URLs) the hook will reference, and (if a template was chosen) what the non-template alternative was.

   **Currency + role-relevance dual gate (added 2026-05-04, [REDACTED COMPANY] eval).** For every Brief fact considered as a hook anchor, verify TWO independent gates before using:
   - **(i) Currency:** the supporting source is dated within the last 12 months from the application date (per `voice-rules/rule-24-company-intelligence.md` "Brief-fact currency discipline" + `qa-checklist.md` Check #42). The durable-scale carve-out applies to undated current-marketing claims like "[scale-figure] employer customers."
   - **(ii) Role-relevance:** the fact maps to the role's JD scope (responsibility / required qual / preferred qual) AND, when imagined from the hiring manager's seat, reads as the kind of work this role enables, owns, or interacts with (per `voice-rules/rule-24-company-intelligence.md` "Brief-fact role-relevance discipline" + `qa-checklist.md` Check #43). A clinical-product launch fails role-relevance for a B2B Platform & Integrations role's hook even when current.

   Both gates must pass independently. A fact that is current but not role-relevant fails just as much as a fact that is role-relevant but stale. Document both verdicts at Step 4g, listing every candidate fact and its currency-date + role-relevance-mapping.

   **Anti-pattern this replaces:** choosing Template A ("bet") because almost any company can be framed as having a "bet," then trying to inject specificity after the fact. A prior application failed this way — a generic VBC thesis used as the "bet," paired with unverified facts that were supposed to carry the specificity; both problems trace to template-first sequencing.
5. **Phrase Lock capabilities referenced** — list which of the 5 Phrase Locks will appear in this cover letter. Those locks must appear verbatim (see `exemplars.md` Phrase Lock section).
6. **Preferred qualifications audit** — list every "preferred" / "nice to have" qual in the JD and note how each will be addressed: (a) explicitly, (b) implicitly, or (c) deliberately omitted with reason.
7. **Company-specific hook material** — from the Company Brief (Step 0.5), identify 1–2 facts that make the hook angle concrete. The hook should reference something that would not be knowable from the JD alone. Document: "Hook will reference [specific Company Brief finding] — source: [URL or publication]." Every fact used in the hook must be traceable to a Company Brief source. If a fact lacks a source in the Brief, it cannot be used in the hook.
8. **"Why now" signal** — from the Company Brief Recent Signals section, classify what's driving this hire: greenfield (new product/team), growth (scaling existing), modernization (replacing legacy), or backfill. Document the signal and its implication for tone and emphasis (e.g., greenfield → lean into 0→1 narrative; modernization → lean into CentralReach platform transformation).

If any of the eight can't be completed, stop and clarify with Craig before generating. Drafting without a complete JD Briefing is the primary cause of drift in prior evals.

---

## Step 1.5: Reader Model — Who Is Reading This?

**This step synthesizes the Company Brief (Step 0.5) + JD Briefing (Step 1) + Craig's profile into a reader-facing analysis. It must be complete before Steps 2–3 begin.**

The Reader Model answers: who is the person reading these materials, what doubts will they have about Craig, who is Craig competing against, and how should the materials preempt objections? See `references/reader-modeling.md` for the full framework, field definitions, and a worked example.

### Workflow

1. **Build the Hiring Manager Persona** — four fields:
   - **Seniority estimate** (VP / Director / Senior Manager / Manager) — inferred from JD reporting structure, scope, strategic vs. execution emphasis.
   - **Company stage** (Early / Growth / Scale / Enterprise) — from Company Brief Recent Signals. Cross-reference with "Why Now" signal (Step 1 item 8).
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

## Step 3: Compose the Cover Letter

**Pre-generation ritual — exemplars/voice-rules staleness audit.** Before drafting the hook or any prose that uses an exemplars.md template, spot-check that any template you're about to use has not been superseded by a voice-rules rule added after the exemplar was written. Specifically: (a) skim the banned-patterns lists in `voice-rules/rule-12-cover-letter-tone.md` and `voice-rules/rule-23-hook-paragraph.md`; (b) check that no banned pattern is present in the exemplars.md template or its surrounding canonical text. If staleness is detected, flag it to Craig before using the template — do not silently work around it.

This ritual exists because rules are added continuously and exemplars have historically lagged. Session 21 ([REDACTED COMPANY]) surfaced that exemplars.md Template A's 3-sentence structure contained a negation-contrast S2 banned by Rule 12 added earlier but not propagated. The meta-rule is: rules and exemplars must stay in sync, and the composer is responsible for verifying sync at generation time.

Structure (5–6 paragraphs, ~350–450 words):

1. **Hook** — use the hook angle determined in Step 1 (which may follow a Template A/B/C pattern from `exemplars.md`, or a company-specific structure that emerged from the Company Brief). The hook must reference at least one company-specific fact from the Company Brief that would not be knowable from the JD alone. Connect the company's situation to the product problem Craig solves.
2. **Bridge** — one concrete sentence naming the shared win condition of Craig's work. Do NOT enumerate product areas as a list — see `voice-rules/rule-12-cover-letter-tone.md` "Product-area enumeration discipline" sub-section and `qa-checklist.md` Check #9 Product-area enumeration sub-check.
3. **Evidence** (1 paragraph, sometimes 2) — lead with the role whose metrics best answer the JD's core ask. Max 2 roles per paragraph. Every role gets (a) problem/situation setup, (b) product/decision sentence, (c) at most one outcome clause. Weave 1–2 Layer 1 breadcrumbs from `career-narratives.md` per evidence paragraph — never more. Breadcrumbs must pass the four gates in `voice-rules/role-type-targeting.md` Breadcrumb Strategy section (JD hook / makes mastery concrete / reads natural / context-present).
4. **Fit + Differentiation** — what makes Craig specifically well-suited at the intersection of platform thinking, data/analytics, and healthcare domain context. Address domain gaps honestly per `voice-rules/rule-2-fhir-hl7.md` and `voice-rules/rule-16-ai-ml-framing.md`.
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

### 4b — Bolding-Density Count (resume — applies to resume-only and resume+cover-letter generations)

Count `**...**` markers in each summary and bullet in the resume JSON. Verify against Rule 15 caps:

- **Summary:** 3 bolds maximum (typical shape: one credential + one mastery angle + one outcome triplet).
- **B1 (problem):** 1–2 bolds (frame the stakes, not every descriptor).
- **B2 (products/surfaces):** 2–3 bolds (the products built, not also their data types or use cases).
- **B2 condensed (hybrid B1+B2):** up to 3 bolds (drop closure phrases first).
- **B3 (outcomes):** heavy bolding fine — 4–6 metrics + accomplishments.

If any element exceeds its cap, trim using this priority order (drop highest priority first):
1. Closure phrases (e.g., "viable, scalable long-term business model")
2. Use-case descriptors (e.g., "measure clinician engagement and credential compliance")
3. Data-type descriptors (e.g., "healthcare claims and remittance data")
4. Product-value descriptors (e.g., "effective clinician learning tool")
5. Lowest-priority product/capability type

Always keep: named product surfaces (web/mobile platforms), named accomplishments (Series A, Employee of the Quarter), and metrics with their context.

**Why this exists:** craig-profile.md bullets are plain text; the composer adds bolding per Rule 15 at JSON-generation time. Rule 15's caps are easy to miss when composing — drift toward "bold every key phrase" is the dominant failure pattern. This pre-verifier count surfaces the violation before the verifier loop. See `corrections-log/live-applications.md` "Bolding-Density Drift" entry for the canonical pattern.

### 4c — Pre-flight Drift Check (cover letter + resume + JD)

```bash
python3 <SKILL_DIR>/scripts/preflight_check.py /tmp/craig_application.json
```

Runs 37 mechanical detectors across four tiers (banned-phrase scans, structural counts, attribution adjacency, multi-clause attribution audit across all 5 Phrase Locks, select grammar patterns including parallel-predicate tense consistency AND parallel-gerund-comma 2-item construction, hook fact-count gate AND structural setup-list element gate, JD-conditional gates, canonical-chronology validation, and flag-only Tier-4 surfaces). Detector count progression: 34 → 36 in v4 Session 1 (2026-04-30, added the setup-list element gate within `detect_hook_fact_count` per Rule 23 reframe + `detect_grammar_20f_parallel_gerund_comma` for 2-item parallel-gerund-comma construction); 36 → 37 in v4 Session 4 (2026-05-01, added `detect_check_38_charli_form_selection` mechanical companion to Rule 10 Charli-form selection per Eval 15 Item 18b carry-forward). Catches every drift mode that is mechanically detectable so the verifier subagent can spend its inference budget on semantic checks only.

What pre-flight covers (the verifier should treat these as already-verified):
- **Tier 1 — pure pattern, no JD dependency:** Gate F summary banned-phrase scan; Rule 17 self-descriptors + tail phrases; Rule 12 canonical-verb paraphrases / PM project-management voice / scalability placeholders / other; negation-then-correction cliché; "actually" filler (Medium, verifier confirms); Check #16 weak-closer ban; Check #21 operational close; Check #15 banned scope phrases; Check #10 temporal-qualifier repetition; Check #10b distinctive-phrase uniqueness; Check #13 evidence-paragraph density (3+ roles); Check #8 abstract-behavior shapes; **hook fact-count gate (Rule 23 — max 2 facts in S1; 3 = Medium / 4+ = High); structural setup-list element gate (Rule 23 reframe, v4 Session 1 — max 2 noun-phrase elements in any Oxford-comma list before the pivot; 3+ = Medium; closes Eval 13 Bucket D drift loophole);** **multi-clause attribution audit (Rule 18 Per-Phrase-Lock Attribution Rules — cross-role weld → Blocker; Consulting PL #1+5 same-sentence → Blocker if no disambiguator OR causal coordinator);** Grammar 20(b) em-dash + participial (cover-letter scope); Grammar 20(c) semicolon + participial; Check #34 EotQ attribution; Rule 15 bolding-density caps; Rule 13 B1 verb diversity; Rule 9 period-endings; Rule 9 #7 "no dashboards."
- **Tier 2 — JD-conditional:** Check #12 HIPAA/GDPR cover-letter gate; Check #33 EDI/x12 tier vocabulary (3-tier classification, strong/weak hook split per v4 Session 4 Item 16 strengthening); Check #18 resume banned-defaults; Check #38 Charli-form mechanical companion (v4 Session 4, fires when JD signals healthcare/healthcare-adjacent AND cover letter contains product-thinking-variant breadcrumb); Check #39 Skills Gate 2 completeness audit ([REDACTED COMPANY] eval / Eval 16, 2026-04-30 + spec-writing trigger added v4 Session 4).
- **Tier 3 — chronology:** Gate C / Check #11 directional-marker validation against canonical chronology table (Consulting → Charli → KTP → CentralReach PM → CentralReach DA, most recent first), with same-paragraph scope and "Most recently" implicit-anchor heuristic.
- **Tier 4 — flag-only / partial-mechanical (verifier confirms):** Check #14 Phrase Lock #1 narrative-value trigger; Check #23 unprompted gap-disclosure pattern detection (escalated to Blocker, categorical no-exceptions per Rule 26 revised 2026-04-30 — no JD-suppression carve-outs, AI/ML Tier-2 and FHIR/HL7 acknowledgment exceptions deprecated); Check #32(a)/(b) (DEPRECATED 2026-04-30 — no-op stubs retained for historical compatibility); hook-scope severity escalation for Rule 23 banned hook patterns.

Exit code 0 if zero issues. Non-zero exit means at least one issue — fix everything Blocker / High before proceeding to Step 5; Medium / Low can be reviewed and dispositioned (some Mediums like the "actually" filler are intentional flags for the verifier to confirm).

These mechanical checks are not substitutes for the verifier — they catch what is mechanically detectable. Semantic checks (company-specificity test, intersection legibility, AI/ML tier-match, JD-responsibility parroting, factual accuracy beyond banned phrases, Reader Model checks #29–31) all stay with the verifier.

### 4d — Hook Source-URL Audit (composer-side Check #24b)

For each fact in the cover letter's hook paragraph (P1), confirm it traces to a source URL committed in Step 1 item 7 ("Company-specific hook material"). Walk the hook S1 left-to-right; for every quantified count, year, named event, named partner, ordinal scaling claim, or specific date, name the URL or publication it came from. Append the audit to `/tmp/composer_notes.md` in this shape:

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

The script compares 10 canonical-bullet phrasings in the new draft against the last 3 deliveries in `projects/job-search/outputs/` and flags any category where a settled canonical (all 3 prior deliveries agree) is abandoned by the new draft. Categories:

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

**Worked example ([REDACTED COMPANY] eval, 2026-05-04).** First-draft hook anchored on the [set-of-named-third-party navigation partners] rollout (early-2024 source) with "rolling out" framing — fact age 28 months, fails currency. After targeted recency search, replaced with the [major payer partnership] going live in early 2026 ([recent-months] trade-press announcement, 4 months old at composition time) — passes currency. [care-model framing] rollout was a candidate at the same date — passed currency but failed role-relevance (clinical-product team's launch, not platform/integrations team's). Final hook: [partner launch] (passed both gates) + [scale-figure] employer customers (durable-scale carve-out for currency; passes role-relevance as the role's blast radius).

**Provenance:** introduced 2026-05-04 ([REDACTED COMPANY] eval). Closes the gap surfaced when the composer's first-draft [REDACTED COMPANY] hook anchored on a Jan 2024 Brief source for a "rolling out" framing; Craig flagged the staleness during review. The fix produced two new disciplines (currency + role-relevance) with composer-side audit (this step) and verifier-side residual checks (qa-checklist.md Checks #42, #43).

---

## Step 5: Spawn the Verifier Subagent

**Pre-spawn preparation (added v5 Session 1, RC6 anti-fabrication codification):** before spawning the verifier, run these four preparation steps composer-side. They exist to remove the verifier's invention surface area — the three Pass 1 verifier subagents in Evals 20 [REDACTED COMPANY] / 21 [REDACTED COMPANY] / 22 [REDACTED COMPANY] (all 2026-05) fabricated Phrase Lock IDs, hallucinated duplicate phrases, and quoted "WRONG" prose strings that did not appear in the actual cover letter. Pre-supplying source-of-truth content in the spawn prompt closes that fabrication path.

1. **Run the mechanical scripts and capture their full verbatim output.** Run `scripts/verify_phrase_locks.py <cover-letter-path>` and `scripts/preflight_check.py <application-json-path>`. Capture the complete output of both into a "Pre-Run Mechanical Script Output (Verbatim)" block in the spawn prompt. The verifier copies this verbatim into its report (per `agents/verifier-prompt.md` Anti-Fabrication Discipline Rule 2).

2. **Pre-quote the full cover-letter prose** in the spawn prompt under a "Cover-Letter Prose (Verbatim — Grep Before Flagging)" block. This is the source of truth the verifier uses for verbatim grep before any prose flag (per Anti-Fabrication Discipline Rule 4).

3. **Pre-list the actual Phrase Lock IDs** in the spawn prompt under a "Phrase Lock IDs for This Application (Authoritative)" block — for each of PL #1 through PL #5 include the canonical phrase from `exemplars.md`, the Rule 18 attribution rule, and the **included / dropped** status for this application (e.g., "PL #1 — INCLUDED" or "PL #1 — DROPPED per Rule 18 narrative-value gate, RCM-domain criterion not met"). The verifier uses these IDs verbatim and never invents new IDs (per Anti-Fabrication Discipline Rule 5).

4. **Restate the Read-tool confirmation requirement** in the spawn prompt — name the two specific reference file paths the verifier must Read before producing any flag (per Anti-Fabrication Discipline Rule 3). Choice depends on the application's likely flag types; default pair is `references/qa-checklist.md` + `references/exemplars.md`.

Use the Agent tool to spawn a subagent with the prompt in `agents/verifier-prompt.md`. Pass it:

1. The full generated resume (JSON or rendered text).
2. The full generated cover letter.
3. The raw job description.
4. The company name and role title.
5. Paths to all reference files under `references/` and the script `scripts/verify_phrase_locks.py`.
6. **The path to `/tmp/composer_notes.md`** (added v5 Session 1, RC7 enforcement) — the verifier reads this file to confirm the Step 0.4 sub-step 3.5 classification block is present and complete for resume skills lines before approving the skills section. Without this path, the verifier cannot perform the Step 0.4 sub-step 3.5 residual check.
7. **The four pre-supplied content blocks** from the Pre-spawn preparation list above (mechanical script output, cover-letter prose, Phrase Lock IDs, Read-tool confirmation pair).

The verifier returns a structured report with Blockers / High / Medium / Low issues. Fix every Blocker and High issue before proceeding. Medium issues are discretionary; Low issues are noted but not required.

**Do not skip the verifier. Do not self-verify.** The composer-in-context has missed 13+ issues in past self-audits. The verifier exists because self-audit in the same context window systematically under-detects drift. Use it every time.

**No self-approval under any circumstances.** If the verifier subagent fails to launch, returns shallow/incomplete results, or errors out, the correct response is to troubleshoot and re-run — NOT to substitute a self-audit. Self-verification is never an acceptable fallback. If the verifier cannot be made to work after two attempts, stop and report the failure to Craig rather than shipping unverified materials. This rule exists because an earlier application shipped on a self-audit that missed multiple issues including unverified factual claims in the hook paragraph.

---

## Step 5.5: Re-Verify After Fixes (Mandatory if Blockers or High Issues Were Found) — Delta-Scope on Pass 2

If Step 5 returned **any Blocker or High issue**, the composer fixes those issues and re-runs the verifier subagent on the updated draft. The re-verification uses the same process as Step 5 (spawn a fresh Agent, pass the updated draft + reference file paths) — but Pass 2 operates in **delta scope**, not full re-run. Pass 3 (only if Pass 2 still fails) reverts to full safety-valve scope.

**Why this step exists:** Without it, the composer fixes issues in its own context and self-certifies the fixes are correct — the same self-audit problem that created the verifier in the first place, one layer up. A prior verifier pass found 2 Blockers + 2 High issues, the composer "fixed" them, and proceeded to document generation without re-verification. The fixes happened to be correct, but the process was unsound.

**Why delta-scope (refactored v3 Session 3):** Sessions 22-32 frequently spent 5-10 min on Pass 2 re-verifying paragraphs that hadn't changed. Pass 1's report names every issue at every severity; if P3 had no Pass-1 issues, P3 was clean — re-running every semantic check on it during Pass 2 was wasted inference. Pass 3 remains the full safety-valve to catch any new drift the fix may have introduced.

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

### Pass 3 — Full safety-valve scope (only if Pass 2 still finds Blocker / High)

If Pass 2 returns Blocker or High issues — particularly NEW issues not on the Pass-1 list (i.e., drift introduced by the fix into otherwise-untouched content, or drift the composer didn't realize the fix would create) — Pass 3 reverts to full-coverage scope: every check, every paragraph, every bullet, every summary phrase. Pass 3 is the safety net.

If Pass 2 finds NO new issues (only confirms residual ones from Pass 1 weren't fully fixed), the composer fixes those, and Pass 3 stays delta-scoped on the same neighborhood logic.

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

If Pass 2 surfaces NEW Blocker/High issues outside the delta scope, flag them — they trigger Pass 3 (full re-verification). If Pass 2 only confirms the original Pass-1 issues are resolved AND the delta-scope checks are clean, Pass 2 is complete.
```

### Rules (unchanged from prior Step 5.5)

1. The verifier must return **0 issues at every severity level** before proceeding to Step 6. A clean report is the only automatic gate-pass.
2. If the verifier returned any issues at any severity → fix them → re-run verifier (Pass 2 delta-scope; Pass 3 full if needed). Max 3 total verifier passes.
3. **If still failing after 3 verifier passes:** Stop. Present Craig with the latest Verification Report. Craig decides — approve proceeding, request a specific fix, or direct further. Document generation does NOT begin until Craig gives explicit approval.
4. **Medium and Low issues the composer disagrees with:** the composer does not silently dismiss. Present to Craig with reasoning. The verifier's job is detection; Craig's job is disposition.

---

## Step 5.6: Quality-Lens Verifier Pass (Mandatory)

**This step closes the hook-composition-quality / interpretive-prose-sourcing / intersection-legibility / register-match gaps surfaced by Eval 14 ([REDACTED COMPANY]) Category D + Category E. It runs after Step 5/5.5 returns 0 Blocker / 0 High and before Step 6 generates documents. It is mandatory on every application — not conditional on Step 5 / 5.5 findings.**

The rule-violation verifier (Step 5 Pass 1 + Step 5.5 Pass 2/3) catches mechanical drift: Phrase Lock failures, banned phrases, chronology errors, factual scope, grammar, mechanical detector findings. It does NOT score hook strength against canonical exemplars, intersection legibility, register match, or interpretive-prose sourcing. Eval 14 iterated the [REDACTED COMPANY] hook through 4 distinct framings across 7 review rounds — none of those failed iterations were flagged by the rule-violation verifier; they were caught only by Craig's review. Step 5.6 closes that gap.

### Workflow

1. **Confirm rule-violation flow has converged.** Step 5/5.5 must have returned 0 Blocker / 0 High. If still failing after 3 verifier passes (Step 5.5 escalation), Step 5.6 is skipped — Craig dispositions the rule-violation report directly.

2. **Spawn the quality-lens verifier subagent** using the prompt at `agents/verifier-quality-prompt.md`. Pass it:
   - The full generated cover letter
   - The full generated resume (used for cross-letter consistency only)
   - The raw job description
   - The company name and role title
   - Paths to reference files: `references/hook-bench.md` (primary), `references/voice-rules.md`, `references/qa-checklist.md`, `references/exemplars.md`
   - The path to `/tmp/composer_notes.md` (composer's Step 4e word-by-word audit table)

3. **The quality-lens verifier scores 4 dimensions:**
   - **Hook quality (1-5)** — calibrated against `references/hook-bench.md` (15 entries: 5 GOOD / 5 BAD / 5 BORDERLINE)
   - **Intersection legibility (1-5)** — bridge phrase + first evidence sentence reinforce same compounding pattern
   - **Register match (Pass / Fail)** — tone matches role's seniority + execution-vs-strategy lean
   - **JD bonus-qual coverage (Pass / Fail)** — preferred quals covered in skills section or cover letter prose

4. **The quality-lens verifier ALSO produces an interpretive-prose flag list** — every clause asserting something about the company's strategy / business shift / central question / next leg / thesis / core challenge / strategic moment, classified by Rule 28 source taxonomy (a / b / c / composer-interp marked / unsourced). This is an independent re-trace per Rule 28 v4 Round 3 word-by-word audit discipline — it does not credit the composer's Step 4e audit notes as evidence on their own.

### Disposition rules

The quality-lens verifier returns one of three overall verdicts:

- **Ship** — all dimensions ≥4, no Blocker/High flags. Proceed to Step 6.
- **Composer Review Required** — any dimension at 3, OR Medium flags only, OR borderline Pass/Fail. Composer reads the report, dispositions each Medium item (fix vs. acknowledge as JD-specific tradeoff), and proceeds to Step 6 with documented reasoning. No re-spawn required for Medium-only outcomes unless composer chooses to fix.
- **Fix-and-Rerun** — any dimension ≤2, OR Pass/Fail = Fail at High severity, OR any Blocker flag. Composer fixes per the verifier's specific recommendations, then re-runs Step 5 Pass 2 delta-scope on the fix neighborhood, then re-runs Step 5.6 to confirm clean. Max 3 total Step-5.6 passes (parallel to Step 5.5 escalation rule); after 3, Craig dispositions.

### Why this step exists

Hook composition is judgment-heavy work that the rule-violation verifier does not score directly. Without Step 5.6, the composer self-certifies hook quality in its own context window — the same self-audit problem that created the verifier in the first place, one layer up. Eval 14 demonstrated this: [REDACTED COMPANY] shipped Round 1 with a [REDACTED COMPANY]-style "inflection point" hook that the rule-violation verifier passed clean (0 Blocker / 0 High); Craig's review caught the cliché framing and the iteration cycle began. Step 5.6 surfaces these issues before delivery.

### Cost calibration

Adds ~2 minutes latency (one additional subagent spawn + ~30-second prompt + structured-output scoring). The latency cost is justified by every hook-quality / interpretive-prose issue from Eval 14 Category D + Category E that wouldn't have surfaced in review if this step had been in place.

### Rules

1. **Mandatory on every application.** Even when Step 5/5.5 returns 0/0/0/0 clean, Step 5.6 still runs. The rule-violation flow's clean report does not certify hook quality.

2. **The quality-lens verifier returns scoring + flags, not Blocker/High/Medium/Low severity (in the rule-violation sense).** Translation between scoring and severity follows the Calibration Mapping in `references/hook-bench.md`. Hook score 1-2 → Medium-to-High flag; score 3 → Medium drift risk; score 4-5 → no flag. Interpretive-prose flags carry their own severity per Rule 28 escalation (Blocker for unsourced strategic claims; Medium for trigger-phrase hits with incomplete sourcing; Low for borderline interpretive framings).

3. **Hook score citations are mandatory.** Every score must reference the bench-entry ID (GOOD-N / BAD-N / BORDER-N) the new hook most closely matches. Score without bench citation = under-calibrated; the verifier downgrades or drops per `verifier-quality-prompt.md` Step 4.6.

4. **Independent re-trace, not audit-table credit.** Per Rule 28 v4 Round 3 word-by-word audit discipline, the verifier does NOT trust the composer's `/tmp/composer_notes.md` audit table as evidence on its own. Every non-canonical-template FILL token is independently re-traced against JD/Brief content.

5. **No self-approval under any circumstances.** If the quality-lens verifier subagent fails to launch, returns shallow/incomplete results, or errors out, the correct response is to troubleshoot and re-run — NOT to substitute a composer self-audit. Self-verification is never an acceptable fallback. Same rule as Step 5; same reasoning.

---

## Step 6: Generate the Documents

Create structured content at `/tmp/craig_application.json`:

```json
{
  "company": "Company Name",
  "role_title": "Exact Role Title",
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

---

## Step 7: Output Routing

Canonical archive: `~/.claude-local/projects/job-search/outputs/`
Convenience copy: Craig's Desktop

After `generate_docs.py` and `generate_pdfs.py` finish, copy files to both locations:

```bash
cp "/tmp/craig_output/Slater, Craig - Resume ([Company]).docx" "<.claude-local mount>/projects/job-search/outputs/"
cp "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).docx" "<.claude-local mount>/projects/job-search/outputs/"
cp "/tmp/craig_output/Slater, Craig - Resume ([Company]).pdf" "<.claude-local mount>/projects/job-search/outputs/"
cp "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).pdf" "<.claude-local mount>/projects/job-search/outputs/"

mv "/tmp/craig_output/Slater, Craig - Resume ([Company]).docx" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).docx" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Resume ([Company]).pdf" "<Desktop mount>/"
mv "/tmp/craig_output/Slater, Craig - Cover Letter ([Company]).pdf" "<Desktop mount>/"
```

If `~/.claude-local` or Desktop is not mounted, use `request_cowork_directory` to mount them (paths: `/Users/craigslater/.claude-local`, `/Users/craigslater/Desktop`).

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

## Step 8: Present Results

Use `present_files` if available. Briefly note in chat:

- The hook template (A/B/C) and why it fit this company.
- Which 2–3 achievements you foregrounded in the evidence paragraph.
- Any domain gaps and how you handled them.
- The verifier's severity counts (e.g. "0 Blockers, 0 High, 2 Medium").

Keep the explanation short — Craig reads the documents himself.

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
Step 1    JD Briefing — hard gate (concepts, vocabulary, role type, hook angle, phrase locks, preferred qual audit, company-specific hook material, "why now" signal)
Step 1.5  Reader Model — who is reading this? (persona, competitive positioning, negative space analysis → /tmp/reader_model.md)
Step 2    Compose resume (voice-rules + exemplars, informed by Reader Model)
Step 3    Compose cover letter (voice-rules + exemplars + Company Brief + Reader Model)
Step 4    Mechanical phrase-lock check (scripts/verify_phrase_locks.py) + 4f cross-session canonical diff (scripts/canonical_diff.py) + 4g hook currency + role-relevance audit (composer-side; closes [REDACTED COMPANY] eval gap)
Step 5    Spawn verifier subagent (agents/verifier-prompt.md)
Step 5.5  Re-verify after fixes (mandatory if Blockers/High found — re-spawn verifier on updated draft)
Step 6    Generate .docx and .pdf (only after verifier confirms 0 Blockers, 0 High)
Step 7    Route outputs to archive + Desktop
Step 7.5  Canonical Backport Audit — diff delivered phrasings against source files, persist drift or document deviation (Eval 14)
Step 8    Present results
Step 8.5  Application questions — on-demand, conversational (question-archetypes.md + Rule 25 + checks #26–28)
```

The skill's discipline is: prescriptive rules live in `voice-rules.md` and `exemplars.md`, detection lives in `qa-checklist.md`, historical context lives in `corrections-log.md`, and audit is done by a separate subagent against the same checklist. Nothing about quality is implicit in the composer's context — every check is either in a reference file or in the verifier's prompt.
