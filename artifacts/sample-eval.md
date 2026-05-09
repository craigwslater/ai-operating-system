<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** One eval from the `job-materials` skill's eval suite—Eval 18 (a behavioral-health digital-app target). Walks the full eval framework: Hook Bench / Intersection Test / Register Match / JD-Bonus-Qual / Verifier Pass 1 / Verifier Pass 2 / Step 5.6 composer-side semantic audit / shipping decision.
> **What was redacted.** 36 substitutions across 10 patterns. Active-target-company names (8 distinct companies) substituted to `[REDACTED COMPANY]` per the registry; one short-form variant caught as a registry gap during this Session 6 port (tgt-062). One prior-employer internal product name and one prior-employer protocol-adoption phrase substituted per registry rows prior-001 and prior-009. Prior-employer company names CentralReach, Charli Charging, Knowledge to Practice / KTP remain visible per Session 0 Q3 (LinkedIn-public).
> **Why it's included.** Direct evidence of CS#3 (eval-driven correction loops). A reader who wants to see what one eval looks like end-to-end—what the framework checks, what passes, what fails, how a fix gets encoded back to source—reads this file.

---

# Eval 18 — [REDACTED COMPANY] (Senior Product Manager, B2B Platform & Integrations)

**Date:** 2026-05-04
**Outcome:** Shipped after 2 generation cycles. Cycle 1: Pass 1 verifier 0 Blocker / 0 High / 2 Medium / 0 Low (both Mediums dispositioned as verifier misapplications, presented to Craig); Step 5.6 quality-lens Ship verdict (Hook 4/5 GOOD-2/3 / Intersection 4/5 / Register Pass / JD bonus-qual Pass / Rule 28 CLEAR). Cycle 2: triggered by Craig review flagging the hook's "rolling out integrated offerings" framing as anchored on a 28-month-old source ([REDACTED COMPANY] business-side blog, ~2 years prior to composition). Hook + close re-anchored on [major payer partner] partnership (recent launch — 4 months old at composition) + [scale-figure] employer customer base (durable-scale carve-out). Final mechanical checks: Phrase Lock 5/5 verbatim, pre-flight 0/0/1/0 (PL #1 advisory), canonical_diff 0 DRIFT / 7 CLEAN / 3 SKIP. Application materials in `projects/job-search/outputs/Slater, Craig - {Resume,Cover Letter} ([REDACTED COMPANY]).{docx,pdf}`.

**Role type:** Healthcare Platform + Integrations (custom subtype of Healthcare Platform + Analytics) — Senior PM owning and scaling the platform capabilities (eligibility infrastructure, APIs, onboarding tooling, admin/configuration tools) that power [REDACTED COMPANY]'s B2B business across employers and health plans, with launch orchestration responsibility across Platform / Activation / Engagement teams.

**Significance:** Surfaced **two related rule-enforcement gaps** that shipped past three verification layers (pre-flight + rule-violation verifier Pass 1 + Step 5.6 quality-lens) and were caught only by Craig's review during post-delivery walkthrough. Both spawned new disciplines codified across four skill source files. Failure mode is NEW (Brief-fact currency + role-relevance discipline did not exist as a rule) — distinct from [REDACTED COMPANY]'s composer-drift-on-existing-rules pattern. Does NOT count as the second instance for the v4 reopen trigger.

---

## 1. JD Summary

[REDACTED COMPANY] — Senior Product Manager, B2B Platform & Integrations. Pay range $122,000-$195,000 + equity + benefits. Remote unless SF area (hybrid 3 days/week).

Required (4+ years PM): platform/APIs/infrastructure products experience; end-to-end delivery of complex cross-functional initiatives or launches; building and scaling platform capabilities or integration-heavy systems; working closely with engineering teams on API design, data systems, or backend infrastructure; systems thinking; cross-functional environment experience; communication.

Preferred: Healthcare/B2B2C/regulated environment experience; eligibility systems / data integrations / interoperability (HIEs, payer systems); B2B or enterprise onboarding workflows; admin tools / configuration systems / platform UX; passion for mental health.

Key Responsibilities (the JD's explicit emphasis): Platform Strategy & Roadmap (B2B partner platform, scalable onboarding, integrations, partner lifecycle management across employers and health plans); Launch Orchestration (across Platform, Activation, and Engagement teams); Platform Systems Ownership (eligibility infrastructure, APIs — eligibility, referrals, reporting; admin/configuration tools); Onboarding Infrastructure (build and scale reusable onboarding capabilities); Cross-Team Collaboration (Engineering, Design, Data, Clinical, Sales, Customer Success); Compliance & Data Governance (HIPAA); Success Measurement (time to launch new partners + platform reliability — eligibility accuracy, access, system performance).

JD-Gate-2 hits Craig's mastery genuinely covers: "platform" (responsibility + role title), "APIs" (responsibility), "eligibility infrastructure," "onboarding tooling" / "B2B partner onboarding workflows" (preferred), "admin/configuration tools" (responsibility + preferred), "data integrations" / "interoperability" (preferred), "HIPAA," "B2B2C" (preferred), "Compliance & Data Governance," "systems thinking" (required).

JD does NOT hook: AI/ML by name (no AI/ML/LLM/agentic/GenAI references); FHIR/HL7; 0→1; specific vertical-SaaS terms beyond "B2B." Per Rule 16, omit AI block. Per Rule 3 healthcare default, omit 0→1.

## 2. Mastery Angles

**Led with:**
- Multi-tenant SaaS platforms and data integration products in regulated B2B healthcare (the through-line — JD's required platform/APIs/infrastructure focus + healthcare preferred qual)
- Partner-facing APIs, admin and configuration tooling (JD-verbatim hits)
- HIPAA compliance (JD verbatim)
- B2B partner onboarding workflows (JD preferred-qual phrasing)

**Cover-letter evidence weight:**
- KTP (P3 lead) — multi-tenant analytics + admin drill-down for hospital admins / clinical leadership = closest direct match for JD's "admin/configuration tools for employers and health plans"
- CentralReach PM (P3 second) — platform transformation + enterprise customer retention/expansion ([internal product name] canonical)
- Consulting (P4 lead) — payment reconciliation system + workflow automations + GTM unblock (PL #5 + PL #1 + 85%+ regression)
- Charli (P4 supporting) — metrics-dense per Rule 10 ([REDACTED COMPANY] IS healthcare/mental-health)

**Deliberately omitted:**
- AI/ML framing (Rule 16: JD doesn't mention AI/ML)
- 0→1 framing (Rule 3 healthcare default)
- HIPAA framing in cover letter prose (Rule 2 default; resume skills lists HIPAA explicitly per JD verbatim)

## 3. Key Decisions

### Hook angle ([REDACTED COMPANY] canonical, company-moment-driven)

Cycle 1 hook: anchored on "[scale-figure] employer customers" + "rolling out integrated offerings across partner network." Surface fact-trace passed (Brief-sourced; Step 4d + 4e cleared); failed under Craig review when the supporting source for "rolling out" ([REDACTED COMPANY] business-side blog, ~2 years prior to composition) was identified as 28 months old.

Cycle 2 hook (final): anchored on "[REDACTED COMPANY]'s tailored [major payer partner] experience now live atop a B2B platform serving [scale-figure] employer customers." [partner launch] supports "now live" with a 4-month-old source ([trade-press release announcing partner go-live]). [scale-figure] employer customer base applies the durable-scale carve-out (current marketing language re-verified at composition time). Both Rule 23 dual-specificity tests pass cleanly (competitor-swap: [direct competitor] doesn't have [major-partner partnership] of this scale or [scale-figure] employer base; current-moment: [partner launch] is the named recent event).

### AI/ML framing decision

JD does NOT mention AI, ML, machine learning, LLMs, agentic, or GenAI. Per Rule 16: omit AI framing. Cover letter contains no AI block. P5 fit paragraph names the win condition without bridging into AI capability framing — clean Rule 26 positive-fit shape.

### Charli form selection (Check #38)

Healthcare role with established platform → metrics-dense form per Rule 10 default. JD's role-relevance is platform-integrations / B2B partner launches (not 0→1 product judgment) — metrics-dense (Series A / HIL / 50% / 80%) is the right choice. No [open protocol]/$900-$400s / NFC / TOU breadcrumbs.

### Three-Initiative form (Rule 18)

PL #1 narrative-value gate disposition: INCLUDE PL #1 via the v4 Session 1 1-sentence parallel-gerund 2-outcome canonical default. JD names HIPAA + Compliance & Data Governance + cross-team workflow + Clinical-team coordination — the workflow-automations clause adds a distinct outcome dimension (compliance/handoff workflow) beyond MRR/regression. Pre-flight Medium PL #1 advisory dispositioned to INCLUDE; verifier confirmed.

### Reader Model

Hiring manager persona: Senior Director / VP of Product. Company stage Growth → late-Growth ([scale-figure] employer customers, [late-stage revenue and valuation per public trade-press, with IPO-candidate framing]). Team maturity inheriting and scaling. Three concerns identified: (1) eligibility / health-plan-side integration depth — reframed in P4 evidence (consulting EDI/x12 payer-side work); (2) consulting recency — reframed in P4 lead with substantive product-ownership scope; (3) mental-health-specific domain familiarity — don't draw attention; positive regulated-healthcare framing throughout. Zero gap narration anywhere (Check #23 Blocker discipline maintained).

## 4. Process

- Composer cycle 1: ~45 min from JD intake through verifier passes through document generation and routing to archive.
- Step 0.4 sweep: pulled [REDACTED COMPANY] (2026-05-01) and [REDACTED COMPANY] (2026-04-30) as canonical references.
- Step 0.5 Brief: 5 targeted searches; specificity diagnostic both tests passed; JD-fact currency cross-check N/A (JD claims general). Brief Section 7 named the multi-channel platform consolidation moment ahead of public-market positioning. **Did NOT date-tag Brief facts at intake** (gap that the new discipline closes).
- Step 4 mechanical checks: 4a Phrase-Lock PASS 5/5; 4b bolding within caps; 4c pre-flight 0/0/1/0 (PL #1 advisory); 4d Hook Source-URL Audit PASS; 4e Interpretive-Claim Sourcing Audit PASS (word-by-word); 4f canonical_diff against pre-generation JSON returned MISSING flags due to known JSON-loader bug (script does not iterate the `paragraphs` list under `cover_letter`) — re-ran post-generation against generated .docx, returned 0 DRIFT / 7 CLEAN / 3 SKIP.
- Step 5 Pass 1 verifier: 0 Blocker / 0 High / 2 Medium / 0 Low. Both Mediums dispositioned as verifier misapplications and presented to Craig: (a) Check #35 procedural flag for "stripped source comments" — but SKILL.md Step 4e mandates stripping the inline comments and preserving the audit table in composer_notes.md, which was done; (b) Check #36 apposition consistency — verifier misclassified "the company's first proprietary platform" as an apposition (it's the object of "built," not a descriptor; Charli is introduced bare matching [REDACTED COMPANY]/[REDACTED COMPANY]/[REDACTED COMPANY] canonical pattern under metrics-dense Rule 10 form).
- Step 5.6 quality-lens verifier: Ship verdict (Hook 4/5 GOOD-2/GOOD-3 / Intersection 4/5 / Register Pass / JD bonus-qual Pass / Rule 28 CLEAR — zero unsourced strategic claims; word-by-word audit confirmed).
- **Cycle 2 (post-delivery Craig review):** Craig flagged the Jan 2024 source date for the partner-network rollout claim. Composer revised hook + close, regenerated documents, re-routed to archive. Re-ran mechanical checks: PL 5/5 verbatim; pre-flight 0/0/1/0; canonical_diff 0 DRIFT / 7 CLEAN / 3 SKIP. No verifier re-spawn (material change was hook-fact substitution, preserving canonical [REDACTED COMPANY] structure + all 5 PLs + canonical bridge/evidence/fit/close).

## 5. Findings

### Finding 1 — Brief-fact currency gap

The skill's source-attribution disciplines (Step 4d URL audit, Step 4e word-by-word source classification, Rule 28) verified that Brief facts EXIST and TRACE to a source. None of these checks asked whether the source's DATE supported the prose's TENSE. The first-draft hook used "rolling out" — a present-progressive verb implying active/current expansion — supported by a source 28 months old. The framing was technically [REDACTED COMPANY]-specific and the dual-specificity test passed at the surface level (the prose claimed current-moment), but the underlying source could not support the tense.

This is parallel to but distinct from the [REDACTED COMPANY] "Rule 17 tail-phrase miss" (composer-drift-on-existing-rule). Here the rule didn't exist — Brief-fact currency / tense-source agreement had no canonical discipline. The skill needed a NEW rule, not better enforcement of an existing one.

### Finding 2 — Brief-fact role-relevance gap

After Craig flagged the currency issue, the composer's first revision attempt anchored on the [care-model framing] rollout (Jan 2026) — current ✓ but clinical-product-team-led, not B2B Platform & Integrations team's work. Craig flagged: signal must be both current AND directly relevant to the role. A clinical-product launch fails role-relevance for a platform-PM role's hook even when current.

This is also a NEW discipline gap. The dual-specificity test (Rule 23 competitor-swap + current-moment) tests [REDACTED COMPANY]-specificity and current-moment-coding, but doesn't test role-relevance from the hiring manager's seat. A current company-true fact can still misfire for the specific role.

## 6. Skill Updates Made

Four-file update encoding both new disciplines:

1. **`voice-rules.md` Rule 24** — added two new subsections:
   - "Brief-fact currency discipline" — 12-month freshness threshold for hook anchors; current-year-search-first sequencing; tense-source agreement check; durable-scale-fact carve-out for current-marketing claims.
   - "Brief-fact role-relevance discipline" — JD-scope mapping + reader's-seat test as an independent gate parallel to currency.

2. **`qa-checklist.md`** — added two verifier-side residual catches:
   - Check #42 — Brief-fact currency + tense-source agreement.
   - Check #43 — Brief-fact role-relevance check.

3. **`SKILL.md`** — three composer-side workflow updates:
   - Step 0.5 Section 7 — current-year-searches-first instruction + date-tagging mandate for every Brief fact.
   - Step 1 item 4 (hook angle determination) — Currency + role-relevance dual gate requirement.
   - NEW Step 4g — Hook Currency + Role-Relevance Audit (composer-side audit table runs after 4f, before verifier spawn).
   - Workflow Summary updated to include 4g.

4. **`corrections-log.md`** — added "Live-Application Corrections — [REDACTED COMPANY] (2026-05-04)" entry with WRONG/RIGHT diagnosis, list of rules spawned, why-this-gap-existed, eval-archive sweep at codification.

**Eval-archive sweep at codification (2026-05-04):** Reviewed last 6 cover letters ([REDACTED COMPANY], [REDACTED COMPANY], [REDACTED COMPANY], [REDACTED COMPANY], [REDACTED COMPANY], [REDACTED COMPANY]) for hook-anchor source dates. All 6 used hook anchors traceable to sources within 12 months at their respective application dates. The [REDACTED COMPANY] first-draft hook is the first archived case where a hook anchor pulled a >12-month-old source — caught in review, not by existing disciplines. Codification of Step 4g + Checks #42/#43 closes the gap going forward.

**Total skill source-file growth:** +206 lines across 4 files (qa-checklist 658→728; voice-rules 1523→1564; SKILL 817→865; corrections-log 1526→1573).

## 7. Open Follow-up

- **v4 reopen trigger watch (carryover from [REDACTED COMPANY] eval-17):** [REDACTED COMPANY] failure mode is NEW (Brief-fact currency + role-relevance) and does NOT count as the second instance toward "composer-drift-on-existing-rules recurring 2+ times." Watch next 1-2 apps for actual composer-drift-on-existing-rules failures. Counter remains 1 of 2 ([REDACTED COMPANY] Rule 17 tail-phrase).
- **Em-dash + dangling-participial canonical question (carryover from [REDACTED COMPANY] eval-17):** [REDACTED COMPANY] cover letter does not surface the pattern (P4 S1 uses parenthetical em-dashes around an apposition, not a dangling participial). Decision still pending pending Craig disposition for general canonical default.
- **Inline-source-comments preservation question (verifier-side procedural flag):** Pass 1 verifier flagged Check #35 Medium because `<!-- src: -->` working comments were stripped from the delivered JSON, even though the audit table was preserved in composer_notes.md per SKILL.md Step 4e. Disposition: verifier rule prompt could be tightened to recognize that audit-table-preserved-in-composer-notes IS the canonical Step 4e closure (comments stripped is mandated, not a procedural failure). Low-priority; consider in next eval if it recurs.
- **Verifier apposition-consistency Check #36 calibration:** Pass 1 verifier flagged Charli's "the company's first proprietary platform" as an apposition outlier when it's actually the object of "built." Verifier prompt could clarify that appositions are descriptor noun phrases for the COMPANY, not objects of the clause's main verb. Low-priority; consider in next eval if it recurs.

## 8. Summary

Eval 18 = first live application post-[REDACTED COMPANY]. Spawned two new disciplines (Brief-fact currency + role-relevance) caught only by Craig's post-delivery review across three verification layers. Codified across 4 files (+206 lines). Failure mode distinct from [REDACTED COMPANY]'s composer-drift-on-existing-rules; v4 reopen counter remains 1 of 2.

Application shipped clean: Phrase Lock 5/5 verbatim, canonical_diff 0 DRIFT, Step 5.6 Ship verdict (Hook 4/5 / Intersection 4/5 / Register Pass / JD bonus-qual Pass / Rule 28 CLEAR), 2 Pass-1 Mediums dispositioned as verifier misapplications.
