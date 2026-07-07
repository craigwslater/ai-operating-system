# Changelog

All notable changes to this portfolio are tracked here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) conventions adapted for a content portfolio (Added / Pending / Notes rather than the software-release set). Versioning is [Semantic Versioning](https://semver.org/)—MAJOR for a new chapter of the thesis (a new capability class shipped with its own case study), MINOR for substantive new content (case study, artifact tier), PATCH for revisions.

The portfolio's source of truth is `~/.claude-local/`. Updates flow `~/.claude-local/` → portfolio (per the project's non-negotiable that the repo is a derived artifact, never the source). Every public-repo push goes through diff review before the push runs.

---

## [Unreleased]

(no changes pending)

---

## [2.0.0]—2026-07-06—Earned autonomy, enforcement hooks, cross-device

A MAJOR release—the first major bump since v1.0. It adds a new chapter of the thesis: the personal AI operating system evolved from observe-only discipline into enforced, then autonomous, execution. Per the Semantic Versioning policy (line 3), a new capability class shipped with its own case study is a MAJOR bump, not the MINOR a single added case study would warrant. Regenerated from v1.1.0 across four staged single-session batches and published atomically, per the publish protocol's commit-and-push-only architecture.

The headline additions: a new Case Study #5 ("Earned Autonomy") for the safety-gated autonomous-execution engine, and the maturation of Case Study #4 from six observe-only hooks to a ten-hook observe→enforce layer. Supporting: two new redacted policy/skill artifacts, a new enforcement-hook artifact, a cross-device-portability section in Case Study #1, a re-ported memory-architecture artifact, and a full metrics re-baseline.

### Added (2026-07-06)

- **New Case Study #5: "Earned Autonomy"** (`case-studies/05-autonomous-execution.md`). The autonomous-execution engine: the orchestrator/runner with a frozen plan and an append-only run ledger, the nine-gate blocking taxonomy (including the arc-level quality-trend gate), the DECIDE/PARK/STOP async escalation model, the three-tier earned-autonomy ladder with its five-condition eligibility gate, and the `/orchestrate` operator command. Positions autonomy as safety-gated and earned per bounded backlog, not "let the model run." Wired into the inter-case-study chain (Case Study #4 now links forward to it).
- **Two new redacted artifacts.** `artifacts/policies/escalation.md`—a redacted excerpt of the async escalation protocol (the gate taxonomy and the tier ladder; per-gate worked examples omitted as product-domain-specific). `artifacts/orchestrate-skill.md`—the `/orchestrate` operator command ported in full.
- **New enforcement-hook artifact** `artifacts/sample-enforcement-hook.sh`—a redacted PreToolUse guard-paths hook, the enforce counterpart to the observe-only `sample-hook.sh`.
- **Cross-device portability section in Case Study #1.** The MEMORY core-plus-overlay split, the shared private framework repository with isolated per-machine data planes, and `$HOME`-relative resolution plus a fresh-machine bootstrap—the same source of truth spanning more than one machine behind a confidentiality boundary enforced by repository topology rather than by hand.

### Updated (2026-07-06)

- **Case Study #4 matured from observe-only to observe→enforce.** The hooks layer grows from six hooks / three event types to ten hooks / five event types (adding PreToolUse and Stop), split into seven observe hooks and three enforcement hooks (guard-paths, unit-scope, verify-before-complete). The load-bearing reframe: discipline first became observable, then became enforceable. Propagated to `methodology.md` and `metrics.md`; a re-ported install-scripts artifact and a corrected artifact-tier hook-count reference followed the change.
- **`artifacts/policies/memory-architecture.md` re-ported from current source.** Reflects the cross-device evolution: the identity tier split into a shared core (≤1,000 cl100k) plus a per-machine overlay (≤2,500 cl100k), the `CLAUDE.md` preserve-budget re-baseline (≤3,200 → ≤3,400 cl100k), and the new measured-state history. Two registry substitutions (a target-company name in an illustrative M10 example; one project-type token per registry Category 6); the gap-identifier hyphenation notation is preserved. HARD GATE clean.
- **`metrics.md` fully re-baselined to 2026-07-06.** Lifetime evals 36 → 40; `detect_*` detectors 40 → 42; behavioral primitives 14 → 16 (adding Scope Sizing and Visual-First Explanation); qa-checklist 996L / 133,803B / 50 H3 → 1,016L / 140,742B / 51 H3; hook inventory at ten (seven observe plus three enforce). The corrections-log layer is unchanged (job-application activity concluded; no bulk additions since the prior baseline).
- **Mechanical claim refresh across the narrative tier.** Eval count 36 → 40 and detector count 40 → 42 propagated across `README.md`, `manifesto.md`, `methodology.md`, `surprises.md`, `retrospection.md`, `for-pms-reusing.md`, the case studies, and the sample-skill artifact header. Case Study #2's "26 applications" hard number was generalized to "dozens of tailored applications" (the portfolio's established hedge). The inter-case-study "next N" chains were updated to include Case Study #5.
- **Semantic Versioning policy extended** (line 3 of this CHANGELOG) with a MAJOR definition, so the policy stays internally consistent with this release.

### Privacy (2026-07-06)

- **Redaction registry hardened (+Category 6).** A new registry category substitutes the pre-launch venture's bounded-backlog project identifiers, which surface in the autonomous-execution framework files ported for Case Study #5; a paired sanity-grep category flags the brand and model names that triangulate the same catalog. The hardened gate then caught a self-defeating-loop leak in an artifact header during the port (fixed in-session).
- **HARD GATE clean across every touched file.** `redact.py verify` and `redact.py sanity-grep` both exit 0 on every narrative-tier and artifact-tier file changed in this release.
- **Self-defeating-loop discipline applied to this CHANGELOG entry** (per the §11 codification). No redacted entities are named in the prose; references to redacted content use category-level descriptors only.

### Notes (2026-07-06)

- **Staged as four single-session batches, published once.** Batch 1 (mechanical claim refresh), Batch 2 (Case Study #4 observe→enforce), Batch 3 (Case Study #5 new), Batch 4 (cross-device addendum, memory-architecture re-port, metrics re-baseline, this CHANGELOG, register reconciliation). Each batch closed with the redaction HARD GATE and a `claim-verify.py` pass; the working tree accumulated all four before the single v2.0.0 push.
- **Internal claim register (`.claim-register.md`, sidecar—not committed) reconciled** across the four batches. Expected values updated for the eval, detector, primitive, hook-count, and budget rows; `claim-verify.py` returns clean.

---

## [1.1.0]—2026-05-22—Memory-architecture artifact + source regeneration

A MINOR release. It adds one new artifact-tier file (`artifacts/policies/memory-architecture.md`), which per the project's Semantic Versioning policy (line 3 of this CHANGELOG — MINOR for substantive new artifact-tier content) makes the release MINOR rather than PATCH. The remaining changes are revisions: five artifact-tier files re-ported from drifted source, a lifetime-eval-count refresh (26 → 36) across the narrative tier, a `metrics.md` re-baseline to 2026-05-22, and a corrected file-size-budget claim in case study #4. Source regeneration ran as a dedicated session ahead of `/publish-portfolio`, per the publish protocol's locked commit-and-push-only architecture.

### Added (2026-05-22)

- **New artifact `artifacts/policies/memory-architecture.md`.** Ports the memory-architecture policy — the five-tier memory model (T0–T4), the dual-unit (cl100k) size budgets, the correction-routing table, the prose-rule → checklist → hook → script escalation ladder, and the M1–M10 maintenance-policy register. Redaction handling, documented in the file's AUTHOR'S NOTE header: one active-target-company name in an illustrative M10 contradiction example was genericized to "a target-company"; the diagnostic-gap identifiers are written in a hyphenated form (`G-1`…`G-14`) to avoid a literal-string collision between one gap label and an unrelated single-token redaction-registry entry — a cosmetic notation change, no semantic effect. HARD GATE clean: `redact.py verify` and `sanity-grep` both exit 0.

### Updated (2026-05-22 — Source regeneration)

- **Five artifact-tier files re-ported from drifted source.** `artifacts/CLAUDE.md` — the folder-structure summary gains the `repos/` folder; the `frontier-hooks` plugin-upload route corrected to the personal-account Customize-tab path; a `policies/memory-architecture.md` pointer added to the Workflow Protocols list. `artifacts/policies/session-end.md` — new Steps 2.5 and 2.6 (MEMORY.md status-line propagation under M1; append-only `log.md` compaction under M4). `artifacts/policies/session-start.md` — Step 4 rewritten as the typed-index "Relevance step." `artifacts/policies/skill-roadmap.md` — §6 audit-detector paragraph updated; new §10 "Compaction discipline" section. `artifacts/policies/new-project-intake.md` — the CONTEXT.md budget restated in cl100k tokens. `artifacts/install-scripts/package-hooks-plugin.sh` — author-note plugin-upload route corrected to match `artifacts/CLAUDE.md`. All re-ports `redact.py`-clean (zero registry substitutions; bodies identical to current source).
- **Lifetime eval count refreshed 26 → 36** across `README.md`, `manifesto.md`, `methodology.md`, `surprises.md`, `retrospection.md`, the four case studies, `for-pms-reusing.md`, `metrics.md`, and the `artifacts/sample-skill/SKILL.md` quantitative-spine header. A stale "23 eval directories" in case study #2's Sources footer — missed by the 2026-05-19 claim refresh — was corrected to 36 in the same pass.
- **`metrics.md` re-baselined 2026-05-19 → 2026-05-22** per the dashboard's baseline-dated framing (the pattern the 2026-05-19 refresh used). Metric 1: live-applications corrections-log shard 572L/72,747B → 630L/81,747B, corrections-log-layer total 1,784L/215,228B → 1,842L/224,228B, cumulative-WRONG lower-bound proxy 97 → 100. Metric 2: lifetime evals 26 → 36 (now 26 dedicated eval files spanning Evals 11 through 36). Metric 4: `qa-checklist.md` 989L/129,702B → 996L/133,803B (50 H3 subsections unchanged). Metric 3 (40 detectors) re-confirmed current — unchanged.
- **Case study #4 file-size-budget claim corrected.** The `session-end-improvement-opportunities.sh` description cited the superseded line-based budgets (CLAUDE.md ≤180 / MEMORY.md ≤80 / project CONTEXT.md ≤80 lines); updated to the token-based budgets (≤3,200 / ≤3,500 / ≤1,800 cl100k) that `memory-architecture.md` §3.2 establishes — the hook's per-file budget check was reconciled from line counts to cl100k tokens in the memory-architecture work.
- **Claim register (`.claim-register.md`, sidecar — not committed) Expected values updated** for the rows that drifted (lifetime eval count, the corrections-log byte/line figures, the qa-checklist scale, the file-size-budget claim), so `claim-verify.py` returns to clean.

---

## [1.0.1]—2026-05-19—Voice calibration + path migration + claim refresh

A cumulative PATCH release covering three substantive change groups since v1.0: the workspace structural migration on 2026-05-13 (working tree relocation under a new top-level `repos/` folder); the voice-calibration pass on 2026-05-19 that removed marketing-toned phrasings across the seven narrative-tier files plus the four case studies plus the artifact-tier per-file headers (no new content; no architectural claims changed); and a claim refresh updating the five DRIFT rows surfaced at the 2026-05-19 pre-publish finalization audit (lifetime eval count, preflight-detector count, `detect_*` function count, release-project count, qa-checklist scale). PATCH per the project's documented Semantic Versioning policy (line 3 of this CHANGELOG): no new content.

### Updated (2026-05-19 — Voice calibration pass, narrative tier)

- **Marketing-toned phrasings removed from seven root narrative-tier files.** Audit-driven pass across `README.md`, `manifesto.md`, `methodology.md`, `metrics.md`, `retrospection.md`, `surprises.md`, `for-pms-reusing.md`. Targets: the repeated "AI is a multiplier — this is the system that does the multiplying / amplifying" chorus restated across files (kept once as the manifesto's thesis sentence; cut from the README headline tagline, the README "What this is" paragraph, the multiplier-restatement immediately following the manifesto thesis, and the methodology page's recruiter-read framing); defensive anti-marketing meta-commentary ("not from marketing claims" in the README recruiter-path paragraph; "than the marketing language suggests" in the manifesto's evidence paragraph; "than the marketing language implies" in the surprises page's headline-metric framing; "real, not aspirational" in the methodology page's CONTEXT.md description); the "easily" adverb attached to headline-metric framings in the metrics dashboard's headline section, the Metric 1 baseline framing, and the surprises page's headline-metric paragraph (reworded to specify what is counted and during what period); the "Read on if any of that sounds..." CTA close at the end of the manifesto; the "shipped under minimal pressure" sales claim in the README "What this is" paragraph; the "operational evidence behind a multiplied PM career" marketing-framed lead-in to the metrics list in the same paragraph; the "real and verifiable / real and redacted" defensive parallelism following the manifesto thesis; the "before being taken at face value" defensive close at the metrics page's verification footer; the "real applications that shipped with invisible issues / real edits that did not actually land" dramatic-cost framings in the retrospection page's What's-Still-Being-Tested section; the credential insertion in the README's "What this is" section; the "Both names matter" rhetorical assertion in the manifesto's authorship paragraph. No new content added; no architectural claims changed; no metrics altered. Voice calibration only; convention-correct as a PATCH per the project's documented Semantic Versioning policy (line 3 of this CHANGELOG).
- **Per-file "Designed by Craig / Runtime: Claude" header blocks dropped from four reflection-tier files** (`metrics.md`, `retrospection.md`, `surprises.md`, `for-pms-reusing.md`). The Designed-by/Runtime header convention remains a hard requirement on every case study and every artifact per project §4 NN #2; the reflection-tier files inherited it by style, not by binding rule, and are now consistent with the README, manifesto, and methodology pages (which never carried the header). Authorship clarity preserved via the `manifesto.md` body prose in the authorship paragraph, where Craig is named as designer and Claude as runtime explicitly, so NN #2's "AI multiplier thesis depends on this being unmissable" sub-requirement remains satisfied. The interview-material verbatim quote at the start of the manifesto's origin-moment section is preserved untouched per the project's primary-source-quotes-are-binding precedent.

### Updated (2026-05-19 — Voice calibration pass extended; claim refresh; artifact re-port)

- **Marketing-toned phrasings removed from the four case studies + the artifact tier per-file headers.** The same audit framework applied in the prior 2026-05-19 narrative-tier entry (patterns A/B/C/F — multiplier chorus, defensive anti-marketing meta, headline-adverb flourishes, defensive parallelism) applied to `case-studies/01-personal-ai-os.md`, `case-studies/02-composer-verifier.md`, `case-studies/03-eval-driven-loops.md`, `case-studies/04-discipline-to-machinery.md`, and the "Why it's included" header blocks across seven artifact-tier files (`artifacts/CLAUDE.md`, `artifacts/sample-skill/SKILL.md`, `artifacts/sample-eval.md`, `artifacts/policies/commitment-verification-audit.md`, `artifacts/sample-roadmap.md`, `artifacts/policies/skill-roadmap.md`, `artifacts/policies/new-project-intake.md`). Targets: the rhetorical "production-grade" close lines at the end of case studies #2, #3, and #4; the "rest of this portfolio is built to reward it" landing-page CTA close at the end of case study #1; the "metric that reads like marketing is the one to verify" defensive anti-marketing meta-comment in case study #2's metrics-dashboard paragraph; the "production-grade outputs from AI through a two-agent pattern" framings in the README's hiring-manager reader path, the README's case-study contents list, and the methodology page's hiring-manager reader path (rewritten to describe what the two-agent pattern actually does mechanically — runs composer and verifier in separate contexts so the audit can fail the draft); the four "easily" adverbial instances in the headline-metric framings across case studies #2 and #3 (cut entirely; the new substantive framing names what the metric actually captures — errors caught and fixed autonomously per month); the soft-marketing "A reader wanting to verify the X claim reads this file" framing across the seven artifact-tier per-file headers (rewritten to direct "Backs X" / "Direct evidence of X" clinical form). Per §4 NN #2, the per-file `Designed by Craig / Runtime: Claude` headers on case studies and artifacts are preserved unchanged.
- **Claim refresh against five DRIFT rows surfaced at the 2026-05-19 pre-publish finalization audit.** The first public auto-walker run (`claim-verify.py .claim-register.md`) reported five rows where the published portfolio claim had drifted from current source: lifetime eval count (23 → 26), preflight-detector count (~39 → ~40), `detect_*` function count (39 → 40), release-project count (four `job-materials-v2/v3/v4/v5` → six `job-materials-v2/v3/v4/v5/v6/v7`), and the qa-checklist.md scale measurement (849 lines / 106,708 bytes / 43 H3 → 989 lines / 129,702 bytes / 50 H3). Edits bundled into the same case-studies + artifact-tier surgical-edit pass where the lines coincided; standalone surgical edits where they did not. Surfaces touched across the case studies, README, manifesto, methodology, retrospection, surprises, for-pms-reusing, metrics.md (the four DRIFT rows that intersect the metrics dashboard regenerated against current source per the document's baseline-dated framing — baseline date refreshed from 2026-05-08 to 2026-05-19; Metric 2 baseline 26 evals across 16 dedicated eval files; Metric 3 baseline 40 detectors; Metric 4 source list updated to 989L/129,702B/50H3 qa-checklist scale; the v5 Session 3 cross-cutting reference rewritten to v7 close on 2026-05-19 at the working ceiling of 40), and the `artifacts/sample-skill/SKILL.md` "Why it's included" header (quantitative spine refreshed). The internal claim register (`.claim-register.md`) Expected values for Rows 1 + 2 + 29 + 30 + 39 updated to match; `claim-verify.py` re-run post-edit reports 28 PASS / 0 DRIFT (was 23 PASS / 5 DRIFT pre-edit).
- **Artifact-tier `artifacts/policies/publish-portfolio.md` re-ported from current source.** The 2026-05-09 Maintenance Session 1 re-port had drifted from `policies/publish-portfolio.md` in four small ways post-port (staleness-check invocation form / default-target paragraph / claim-verify `cd` line / init-mode phrasing). Re-port via `redact.py` (zero registry substitutions, body-identical to current source); AUTHOR'S NOTE header preserved verbatim. HARD GATE clean post-port: `redact.py verify` and `sanity-grep` both exit 0.

### Updated (2026-05-13 — Workspace structural migration)

- **Working tree relocated.** The portfolio's source-side working tree moved from `~/.claude-local/projects/ai-operating-system/outputs/portfolio-repo/` to `~/.claude-local/repos/ai-operating-system/` as part of a `~/.claude-local/` structural refactor that introduced a new top-level `repos/` folder type for working trees of GitHub repos. One subdirectory per remote; folder name matches the GitHub repo name. The repo's `.git/` history, remote, and content are unchanged — only the path on the operator's filesystem moved. Public consumers of this repo see no change.
- **Path references updated forward-looking.** Path references in source files that pointed at the prior location were rewritten to the new location wherever the referenced file still exists. Naming-form references (the colloquial "portfolio-repo" used as a descriptor rather than as a path) were left in place where they read naturally. Three classes of files retain prior-path references by design: (1) JSONL commitment-audit logs under the source workspace's `outputs/commitment-logs/`, preserved as immutable append-only audit records; (2) deliberate historical narrative referring to "the prior location" by name (the "was X through 2026-05-12" form); (3) prior CHANGELOG entries in this file from before the migration.
- **System docs updated.** The source-workspace `CLAUDE.md` folder-structure summary, `docs/folder-structure.md` tree diagram + rules, and `scripts/regenerate-index.sh` (extended to emit a new Repos table cataloging working trees with remote + visibility + last-commit date) all reflect the new structure.

### Notes (2026-05-13)

- **New companion repo: `craigwslater/claude-local-private`.** Private mirror of the source-workspace framework layer (rules, policies, skills, hooks, templates, docs). Distinct from this public portfolio — operational rather than narrative. Created and maintained by a new `sync-private-mirror` skill. Same architectural pattern as `/publish-portfolio`: canonical policy doc + thin SKILL.md runtime wrapper + per-push diff-review HARD GATE. MEMORY.md included verbatim per operator disposition.

---

## [1.0]—2026-05-09—Initial public publish

The portfolio ships public for the first time at `github.com/craigwslater/ai-operating-system` (commit `ff338c8`, branch `main`). The original 8-session build arc closes. Per Option B disposition at Session 8 kickoff, lightweight maintenance stubs ship in v1.0 (per-file `**Sources:**` / `**Last refreshed:**` footers, claim register seed, 90-day staleness threshold prose advisory); full automation lives in a follow-on maintenance project. Two outside-scope source-side carryforwards from Session 7.5 close are fixed at this session's kickoff.

### Added (Session 8, 2026-05-09)

- **First public commit.** v1.0 lands at `github.com/craigwslater/ai-operating-system` (commit `ff338c8`). Init-mode flow per `policies/publish-portfolio.md` Init mode appendix.
- **README Status section populated.** Lines 84-85 updated from the Session 2 "Currently in build" scaffolding placeholder to a v1.0 published-on date plus GitHub-profile and LinkedIn links. Closes the Session 2 placeholder.
- **Per-file `**Sources:**` / `**Last refreshed:**` footers across 11 narrative-tier files.** README, manifesto, methodology, metrics, retrospection, surprises, for-pms-reusing, all four case studies. Each footer declares the file's source paths under `~/.claude-local/` plus a `Last refreshed` date stamp. Artifact tier excluded by design (artifact author's-note headers already declare provenance).
- **`repos/ai-operating-system/.gitignore`.** Excludes `.DS_Store`, `Thumbs.db`, IDE state directories, vim swap files.
- **Step 1.5 (advisory staleness check, 90-day threshold) added to `policies/publish-portfolio.md`.** Re-ported to `artifacts/policies/publish-portfolio.md`. v1 implementation is prose-only; auto-detection ships in the maintenance project's Session 1.

### Updated (Session 8, 2026-05-09)

- **GitHub repo URL corrected.** From the Session-0 locked default to the operator's actual GitHub handle. Propagated across nine source files plus one artifact-tier file via re-port. (LinkedIn URL slug intentionally unchanged — it's a different identifier from the GitHub handle.)
- **`policies/publish-portfolio.md` Step 1 verification filter.** Extended from `*.md` to `*.md` plus `*.sh` (catches `.sh` artifact files at publish time, not just by manual sweep). Re-ported to artifact tier.
- **`hooks/package-hooks-plugin.sh` comments at lines 4, 10, 34.** "the four hook scripts" / "the four Claude Code hooks" updated to "the six hook scripts" (REQUIRED_HOOKS array correctly listed six entries; comment text was stale post-Session-7 hook addition). Re-ported to artifact tier.

### Privacy (Session 8, 2026-05-09)

- **All 26 working portfolio-repo files pass `redact.py verify` and `redact.py sanity-grep` clean.** Both modes exit 0 across the corpus including newly added per-file footers, the new `.gitignore`, and the re-ported artifact-tier files. Verification suite (HARD GATE) cleared before init-mode publish.
- **Self-defeating-loop discipline applied to this CHANGELOG entry** (per Session 6's §11 codification). No redacted entities or third-party named individuals are named in the prose; references to redacted content use category-level descriptors only.

### Notes (Session 8, 2026-05-09)

- **Maintenance project scaffolded** at this session's close (`projects/ai-operating-system-maintenance/` in the source workspace). Receives the v1 lightweight maintenance stubs deferred from full design. Session 1 plan: build the staleness-check + claim-verify scripts, expand the 10-row claim register seed to comprehensive coverage with per-row verify commands, and update `policies/publish-portfolio.md` Step 1.5 from prose advisory to script invocation. Session 2 optional: a periodic strategic-positioning audit slash command.
- **Cowork sandbox cannot execute git ops on a mounted `.git/`** (lock-file unlink restriction). All git ops in this v1.0 publish ran from the operator's Terminal; the sandbox produced the staged content. Future publishes follow the same handoff pattern until a sandbox-detection branch is documented in the publish protocol. Flagged for the maintenance project ROADMAP.
- **Cross-version git-init compatibility surfaced.** macOS pre-Homebrew git lacks the `-b` flag (added in 2.28). The init step used a `git symbolic-ref HEAD refs/heads/main` fallback after `git init`. Policy doc currently uses `-b main` modern syntax; the maintenance project's policy update should document both forms.
- **Eval count metric clarification deferred to maintenance Session 1.** Hook tracking (current top-level evals) and the claim register (lifetime — top-level plus archive) measure two distinct things. Session 1 picks lifetime as canonical for the public claim and updates the verify command accordingly.
- **Sync-state file refreshed post-publish.** `.portfolio-sync-state` re-baselined with current `~/.claude-local/` hashes plus a `last_sync_iso` matching the v1.0 commit time. Pending file is empty (no signals fired between Session 7.5 and Session 8).
- **Original 8-session build-arc plan complete.** Sessions 1 through 7.5 documented in prior CHANGELOG entries (v0.1 through v0.5.1); this v1.0 entry covers Session 8 specifically. Maintenance and ongoing publish work move to the new follow-on project.

### Pending — Session 8 async items (post-v1.0 publish)

- **60-second README test.** Trusted PM peer review of the README's 60-second readability. Capture the reviewer's one-paragraph paraphrase of what the portfolio is, before sharing further. Reviewer-side, not Session-8-blocking.
- **LinkedIn profile integration.** Add the portfolio URL to the operator's LinkedIn profile (Featured or About section).
- **(Optional) LinkedIn post draft.** v1.0-launch announcement post; ships only on owner's choice.

---

## [0.5.1]—2026-05-08—Pre-publish finalization

Six finalization items dispositioned in a pre-Session-8 review session and shipped in a follow-on Session 7.5 sub-session, closing every publish-blocker risk surfaced during the reader-consumption walkthrough across all working portfolio-repo files. The methodology page is populated against the Session 2 skeleton (was 149 visible words, now ~1,465 across five sections). Case Study #4 plus the metrics dashboard now correctly enumerate six hook scripts (Session 7's portfolio-sync hook had not propagated to either narrative-tier reference). Both install-scripts artifacts re-ported from current source. The Session 7 publish-portfolio policy doc lands as a redacted artifact for the first time. The sample-skill SKILL.md gains a "where to read first" orientation header. Manifesto micro-edit clarifies the anchor sentence's voice. v1.0 first public push at Session 8 now reflects the system as it stands at 7.5 close, not as it stood at end of Session 6.

### Updated (Session 7.5, 2026-05-08)

- **`methodology.md`**—populated from Session 2 skeleton. Five sections written against the existing structure: "What this document does," "The four layers" (with Layer 1-4 sub-sections), "The patterns that thread through" (with composer/verifier, encode-into-source, modular structure, eval-driven correction, and discipline-becomes-machinery sub-sections), "How to read this portfolio" (recruiter / hiring manager / peer-PM sequences), "How the portfolio gets updated" (signal-triggered sync mechanism). Every architectural claim links to the case study or artifact that demonstrates it. ~1,465 words.
- **`case-studies/04-discipline-to-machinery.md`**—hook count corrected from "five" to "six" at the narrative claim, the H2 header, and the install-scripts cross-reference. New sub-section after `session-end-improvement-opportunities.sh` describing `session-end-portfolio-sync.sh`: five orthogonal signal detectors, state-file-only-updated-by-`/publish-portfolio` semantic, multi-session-noise v1 limitation.
- **`metrics.md`**—source-of-truth list extended from five to six hook scripts; `session-end-portfolio-sync.sh` appended.
- **`artifacts/install-scripts/install-hooks-to-claude-code.sh`**—re-ported from current source. Six hook entries now register correctly (the Session 7 portfolio-sync hook had not propagated to the artifact tier). Existing AUTHOR'S NOTE preserved verbatim; "What was redacted: nothing" re-confirmed via redactor sweep (zero substitutions).
- **`artifacts/install-scripts/package-hooks-plugin.sh`**—re-ported from current source. REQUIRED_HOOKS array now lists six entries. Existing AUTHOR'S NOTE preserved; redactor sweep zero-substitution.
- **`manifesto.md`**—line 5 micro-edit. Single-word change clarifies the anchor sentence's voice.

### Added (Session 7.5, 2026-05-08)

- **`artifacts/policies/publish-portfolio.md`**—the Session 7 publish-portfolio policy doc lands as a redacted artifact for the first time. Body verbatim from source (zero registry substitutions). Author's-note follows the existing policy-artifact convention (HTML comment plus 4-field blockquote plus horizontal rule). Pairs with the six existing policy artifacts; pairs with `artifacts/install-scripts/install-hooks-to-claude-code.sh`'s `session-end-portfolio-sync.sh` registration to form the publishable evidence for the complete sync mechanism.
- **`artifacts/sample-skill/SKILL.md` orientation header**—two-audience stanza inserted after the existing AUTHOR'S NOTE blockquote. Peer-PM line points at Step 0 plus Step 5 plus the rule-promotion lifecycle references woven through `references/voice-rules/` and `references/qa-checklist.md`. Recruiter line redirects to Case Study #2 as the lighter read on the same content.

### Privacy (Session 7.5, 2026-05-08)

- **All 26 working portfolio-repo files pass `redact.py verify` and `redact.py sanity-grep` clean.** Both modes exit 0 across the corpus including the new `artifacts/policies/publish-portfolio.md` artifact. Active-target-company spot-grep across the corpus returns empty.
- **Self-defeating-loop discipline applied to this CHANGELOG entry** (per Session 6's §11 codification). No redacted entities are named in the prose; references to redacted content use category-level descriptors only.

### Notes (Session 7.5, 2026-05-08)

- Verifier subagent ran two passes per project §8 4-plus-threshold. Pass 1 (narrative tier) audited methodology.md, CS#4, metrics.md, manifesto.md: 0 HIGH, 0 MEDIUM, 2 LOW (both methodology.md polish; both fixed in-session). Pass 2 (artifact tier) audited install-hooks-to-claude-code.sh, package-hooks-plugin.sh, publish-portfolio.md (artifact), sample-skill/SKILL.md (header addition only): 0 HIGH, 0 MEDIUM, 2 LOW (the `--help` self-help regression on the install-script artifacts as a side-effect of the prepended AUTHOR'S NOTE; accepted per artifact-tier-as-evidence-not-runnable disposition). Three Sessions 5 and 6 confabulation mitigations carried forward in both spawn prompts (log.md cross-check, verbatim file:line quotes, two-stage CANDIDATE-to-confirmed flag protocol). Zero verifier confabulations across both passes; the rate watch holds.
- Init-mode rehearsal completed on a `/tmp/test-init` throwaway repo. Confirmed `git init -b main`, `git config user.email/user.name`, and `git remote add origin git@github.com:craigwslater/ai-operating-system.git` syntax all execute clean. Live execution against the real `repos/ai-operating-system/` working directory is Session 8 work per the locked plan.
- Outside-scope finding surfaced for Session 8 kickoff disposition: live source `~/.claude-local/hooks/package-hooks-plugin.sh` carries three stale "four hook scripts" comment references at lines 4, 10, and 34, while the script's own REQUIRED_HOOKS array correctly lists six entries. Per source-fidelity rule the artifact preserves verbatim; per Session 7.5 locked plan the source fix is out of scope.

---

## [0.5.0]—2026-05-08—Sync mechanism live

The signal-triggered sync mechanism ships. A SessionEnd hook detects portfolio-worthy events across `~/.claude-local/` since last publish and surfaces a prompt recommending `/publish-portfolio` next session. The slash command commits and pushes from the working portfolio-repo to public GitHub, with per-push diff review as an unbypassable hard gate. The redactor gains a fifth mode (sanity-grep) addressing the triangulation-defense backstop. Architecture decision: commit-and-push only—source-to-portfolio regeneration happens in dedicated sessions before invocation, never inside the slash command. Multi-session signal noise is a documented v1 limitation; dedup-at-detection-time is a v2 candidate. The first public push is Session 8.

### Added (Session 7, 2026-05-08)

- **`hooks/session-end-portfolio-sync.sh`**—SessionEnd hook with five orthogonal signal detectors (ROADMAP-resolved counts, eval-file globs, CLAUDE.md hash, MEMORY.md closed-marker scan, CHANGELOG version-header scan). State file at `projects/ai-operating-system/.portfolio-sync-state` (jq-managed JSON); pending file at `projects/ai-operating-system/outputs/portfolio-sync-pending.md` (accumulating signal log). State file is updated only by `/publish-portfolio` on successful push, never by the hook (other than first-run bootstrap).
- **`policies/publish-portfolio.md`**—canonical workflow doc. Six steps mapping precondition checks through commit-push-state-update. Init-mode appendix for Session 8's first-publish case. Seven anti-patterns mapped to project §4 non-negotiables.
- **`skills/publish-portfolio/SKILL.md`**—runtime wrapper, nine steps (Step 0 environment resolve through Step 8 Craig confirmation) mapping to the six steps of the policy doc. Triggers on `/publish-portfolio`, "publish to portfolio," "ship to GitHub," "push portfolio," "sync portfolio," and post-hook-prompt invocation.
- **`skills/publish-portfolio/ROADMAP.md`**—initial seed with four open considerations (two of which carry standing-deferral status, cross-referenced under the Standing Deferrals subsection per the ROADMAP template), one candidate bundle.
- **Sanity-grep mode in `scripts/redact.py`**—fifth mode alongside redact / diff / verify / audit. Reads `inputs/sanity-grep-entities.md`; reports identifying-fact-cluster matches with line numbers and context. Tested clean-pass on Session 6 artifacts and dirty-fail on injection.
- **`inputs/sanity-grep-entities.md`**—triangulation-defense entity dictionary. Three categories (rows sg-001 through sg-017): identifying fact clusters in the healthcare-PM ecosystem, trade publication and press outlet names, specific launch dates. Build-time only.

### Bound (Session 7, 2026-05-08)

- **Per-push diff review encoded as machinery.** Project §4 non-negotiable #5 ("Sync requires explicit per-push approval") moves from prose discipline to mechanical enforcement. The policy doc and the skill both surface the full staged diff and reject vague responses ("looks good" / "ok") with a re-prompt; only specific affirmative phrasing ("approved" / "ship it" / "yes push") proceeds.
- **Verification suite encoded as machinery.** Project §4 non-negotiable #1 (both strict-floor and triangulation-defense sub-bullets) moves from "the right thing to remember" to "the protocol's Step 1 cannot be skipped." Every `.md` file under `repos/ai-operating-system/` runs through both verify mode (registry residuals) and sanity-grep mode (identifying-fact-cluster matches) before any staging. Either failure stops the publish.
- **Sanity-grep belt-and-suspenders codified.** The Session 6 carryforward (five registry gaps caught only by registry-blind sanity-grep; registry-based verify is necessary but not sufficient) is now part of the published mechanism. Both modes run in the verification suite; both must pass.

### Privacy (Session 7, 2026-05-08)

- **Sanity-grep dictionary build-time-only.** `inputs/sanity-grep-entities.md` lives in the same build-time-only classification as `redaction-registry.md`; never ported to `repos/ai-operating-system/`. Same rationale: it contains the entity patterns that should not appear in published content; publishing the dictionary itself would invert the privacy floor.
- **Self-defeating-loop discipline applied to this CHANGELOG entry** (per Session 6's §11 codification). Sanity-grep dictionary entries are referenced by category and sg-NNN row-ID class, not by named entity. Close-out documentation is in scope for the same redaction floor as the content it documents.

### Notes (Session 7, 2026-05-08)

- Hook installation registered in both surfaces: `hooks/install-hooks-to-claude-code.sh` adds the new SessionEnd entry to `~/.claude/settings.json`; `plugins/frontier-hooks/hooks/hooks.json` and `hooks/package-hooks-plugin.sh` REQUIRED_HOOKS list cover the Cowork plugin path.
- Hook integration tested via artificial-signal injection (test eval file created, detected, hook emitted valid JSON, pending file received the appended stanza, test artifacts cleaned, state file restored to bootstrap baseline).
- Cross-device-mv bug found and fixed during testing: the hook's temp-file rename for header initialization failed when `/tmp` and the project directory were on different filesystems. Fix: write header on first creation, append signals after—no temp-file dance.
- Verifier subagent ran one pass per Session 7 kickoff disposition (artifact count below the project §8 4+ two-pass threshold). Three confabulation mitigations from Sessions 5 and 6 carried forward. Findings recorded in `projects/ai-operating-system/log.md` Session 7 entry.

---

## [0.4.0]—2026-05-08—Redacted artifact tier

Thirteen redacted operational artifacts shipped, resolving every Session 6 forward-reference inherited from CS#1 and CS#4. The artifact tier lets a reader verify case-study claims against actual source files—with PII, target-company names, third-party individuals, and prior-employer narrative redacted, but the operational substance intact. Two new sub-bullets bind NN #1 (strict-floor reading + triangulation-defense reading); a new §11 failure-mode entry binds close-out documentation.

### Added (Session 6, 2026-05-08)

- **`artifacts/CLAUDE.md`**—the global behavioral-rules file. Zero substitutions (no PII, target companies, third-party individuals, or prior-employer narrative present in source).
- **`artifacts/policies/`**—six workflow protocol files: `session-start.md`, `session-end.md`, `commitment-verification-audit.md`, `new-project-intake.md`, `skill-roadmap.md`, `file-delivery.md`. Two of the six carry a single registry-pattern substitution each (per registry rows tgt-017 and tgt-062 in `commitment-verification-audit.md`; per registry row tgt-025 in `file-delivery.md`); the other four are zero-substitution.
- **`artifacts/sample-skill/SKILL.md`**—the `job-materials` skill's SKILL.md. Heaviest-redaction file: 85 substitutions across 22 patterns including PII (rows pii-001 / pii-005 / pii-006), 13 distinct active-target-company entities across 16 registry rows (72 substitutions, including three short-form variants caught as registry gaps during this Session 6 port—rows tgt-062, tgt-063, tgt-064), one third-party named individual phrase (row ind-005), and 9 prior-employer narrative substitutions (rows prior-001, prior-009).
- **`artifacts/sample-eval.md`**—one eval from the job-materials suite, walking the eval framework end-to-end. 36 substitutions across 10 patterns, plus 20 triangulation-defense substitutions across 16 patterns. Selected from a three-candidate bake-off staged in the project workspace; non-chosen candidates retained for posterity.
- **`artifacts/sample-roadmap.md`**—the canonical skill-ROADMAP.md template that every custom skill instantiates. Zero registry substitutions (structural template).
- **`artifacts/sample-hook.sh`**—a Claude Code PostToolUse hook that encodes the file-write-verification primitive as machinery. Zero registry substitutions. Selected from a two-candidate bake-off.
- **`artifacts/install-scripts/install-hooks-to-claude-code.sh` + `package-hooks-plugin.sh`**—the dual-environment portability pair (Claude Code symlink install + Cowork plugin packaging). Zero registry substitutions on either.

### Bound (Session 6, 2026-05-08)

- **NN #1 strict-floor reading sub-bullet codified.** Project CLAUDE.md §4 non-negotiable #1 now carries an explicit sub-bullet stating that redaction is the floor at all times across working drafts in `repos/ai-operating-system/`, not only at publish time. Closes the implicit-vs-explicit ambiguity that allowed Session 4's verifier to miss two CS#2 active-target-company-name violations.
- **NN #1 triangulation-defense reading sub-bullet codified.** Same non-negotiable carries a second sub-bullet establishing identifiability-via-search as the binding test, not just registry-name-coverage. When a redacted file still contains identifying fact clusters (specific financial figures, named partner / customer / competitor entities, named trade publications, specific launch dates), those phrases require defensive-margin substitution to a narrative-preserving filler. Origin: Session 6 verifier surfaced an identifying fact cluster in the eval sample that survived name-redaction; Craig dispositioned the rule as universal mid-session.
- **§11 self-defeating-loop authoring rule codified.** Project CLAUDE.md §11 carries a new failure-mode entry "Self-defeating-loop in close-out documentation." When a session-end document references the redaction sweep or any other redaction-bound action and names the redacted entities by name in the same breath, the documentation undoes the redaction it documents. Origin: Session 5 v0.3.0 entry caught self-verifying. Codification triggered Session 6 mid-port when the SKILL.md author's-note initially named three SUB patterns by their verbatim source form; verify-mode flagged; pattern recurrence confirmed.

### Privacy (Session 6, 2026-05-08)

- **Five registry gaps caught + closed in-session.** During the SKILL.md port, three short-form variants of multi-word target-company entries surfaced as bare-form leaks (registry rows tgt-062 / tgt-063 / tgt-064 added). During the eval-candidate staging, two more short-form / hyphen-compound variants surfaced (registry rows tgt-065 / tgt-066 added). All five gaps were caught by registry-blind sanity-grep; the registry-based `verify` mode alone does not catch gaps, only residuals. Sanity-grep is now part of the post-port discipline.
- **Triangulation-defense substitutions applied** to `artifacts/sample-eval.md` (20 substitutions across 16 patterns) and `artifacts/sample-skill/SKILL.md` (11 substitutions across 11 patterns). Identifying fact clusters (named partner entities, named competitor entities, named trade publications, specific launch dates, specific financial figures) substituted to narrative-preserving filler that does not identify the entity. Per the new NN #1 triangulation-defense reading.
- **Final sweep results.** All 13 artifacts pass `redact.py verify` clean. Zero bare-form variant leaks across all artifacts (sanity-grep belt-and-suspenders). Zero PII residuals. Zero triangulation cluster matches across the standard healthcare-PM-context entity dictionary (insurer-partner names, digital-health competitor names, trade publication names, brand-specific product / service terms).

### Notes (Session 6)

- Verifier subagent ran two passes (structural cluster: 8 files / showcase cluster: 5 files), both with the three confabulation mitigations from Session 5's disposition (log.md cross-check / verbatim file:line quotes / two-stage CANDIDATE→confirmed flag protocol). Findings: 0 HIGH, 1 MEDIUM (sample-skill/SKILL.md count drift after registry extension—fixed), 3 LOW (sample-skill/SKILL.md off-by-one prior-001 count—fixed; commitment-verification-audit.md registry-row citation polish—fixed; sample-eval.md fact-cluster triangulation—triggered the NN #1 triangulation-defense codification plus applied substitutions). 0 verifier confabulations across both passes; the Session 5 confabulation-rate watch holds at 2 of prior sessions with Session 6 contributing zero new instances.
- Sample-eval and sample-hook were chosen via bake-off across staged candidates. Eval candidates: three (one chosen). Hook candidates: two (one chosen). The bake-off let post-redaction narrative readability and framework-demonstration quality drive the ship decisions.
- Self-defeating-loop discipline applied to this CHANGELOG entry: redacted entities are NOT named in the prose above. Registry-row IDs (tgt-XXX, ind-XXX, prior-XXX, pii-XXX) are cited; sweep-result categories are described in abstract terms rather than enumerated.

---

## [0.3.0]—2026-05-08—Narrative tier complete

The portfolio's narrative layer is shipped. All four case studies, the retrospection synthesis, the surprises page, the metrics dashboard, and the for-PMs-reusing reader path are now content-complete. Only the redacted artifact tier (Session 6), the signal-triggered sync mechanism (Session 7), and the initial publish (Session 8) remain. Privacy redaction floor enforced across all working drafts: zero residual active target-company names across 15 portfolio-repo files.

### Added (Session 5, 2026-05-08)

- **Case Study #3: Eval-Driven Correction Loops**—`case-studies/03-eval-driven-loops.md`. Software-engineering rigor applied to AI work. Walks WRONG/RIGHT corrections-log discipline, the 5-stage rule-promotion lifecycle from prose to mechanical detector, drift detection, and the era-shard refactoring pattern with both live data points (corrections-log split + voice-rules per-rule decomposition, both shipped 2026-05-07). 2,665 words.
- **Case Study #4: From Discipline to Machinery**—`case-studies/04-discipline-to-machinery.md`. Hooks layer encoding CLAUDE.md primitives. Walks the 5 hook scripts (`post-tool-use-verify-write`, `session-start-prune-commitment-logs`, `session-end-context-reminder`, `session-end-cross-file-consistency`, `session-end-improvement-opportunities`), the dual-environment install (Claude Code + Cowork), and the commitment-log JSONL ground truth that moved the Commitment-Verification Audit from self-report to fact-check. 2,044 words.
- **Retrospection synthesis**—`retrospection.md`. The three retrospections (composer/verifier-late, discipline-as-prose-late, monolith-late) presented as three faces of one underlying pattern: do not delegate to the runtime a job the runtime is empirically bad at. Synthesis plus design rule ("from day one, not as retrofits") plus working-hypothesis caveat. 1,285 words.
- **Surprises**—`surprises.md`. Two locked surprises—AI as willing collaborator on its own working relationship; most of "AI quality" is the system around the AI, not the AI itself. Anchored on the manifesto's origin moment plus the case-study evidence base. 901 words.
- **Metrics dashboard**—`metrics.md`. Four metrics committed at Session 0, baselined 2026-05-08: errors caught per month (headline), evals shipped per quarter, detector count plus regression-test pass rate, rules added per month. Every numeric claim traces to a specific source-file count or directory inventory. Single-block author-note header per §6 Session 5 scope item 5 (artifact convention adapted, "What was redacted" replaced with "What it tracks" since the page is fresh-authored not redacted). 1,336 words.
- **For PMs Reusing These Patterns**—`for-pms-reusing.md`. Reader path for fellow PMs. Five sequenced patterns from cheapest to most-developed: WRONG/RIGHT pair, rule-promotion lifecycle, separate audit context, era-shard refactor, hooks layer. Plus an explicit "what NOT to copy verbatim" section naming the Craig-specific pieces. 1,631 words.

### Added (Session 4, 2026-05-08—promoted from Unreleased)

- **Case Study #2: Composer/Verifier**—`case-studies/02-composer-verifier.md`. Two-agent pattern, eval-driven correction loop, recurrence-counter mechanism. Anchors on Craig's verbatim failure-mode reflection. Quantitative spine: 23 evals, 39 detectors, hundreds of errors caught per month, dozens of tailored applications. Sample redacted JD plus structural cover-letter skeleton (no actual letters, per redaction policy).
- **Style-guide §5 strict em-dash rule applied**—Session 4 disposition extended in Session 5 to portfolio content. Session 4: 148 substitutions across 6 files (project CLAUDE.md, inputs/style-guide.md, README.md, manifesto.md, methodology.md, case-studies/01-personal-ai-os.md). Session 5: 13 additional substitutions across CHANGELOG.md (11—7 open-form em-dashes plus 4 hyphen-fallback recoveries from the Session 4 Edit-tool em-dash drop bug) + case-studies/03-eval-driven-loops.md (1) + case-studies/04-discipline-to-machinery.md (1). Zero residual `space-em-dash-space` instances across all 10 strict-rule-scope files.

### Privacy (Session 5, 2026-05-08)

- **Redaction floor sweep across CS#2 + CS#3.** 8 active target-company names replaced with `[REDACTED COMPANY]`: 2 in `case-studies/02-composer-verifier.md` (Session 4 carryforward defect that the Session 4 verifier missed); 6 in `case-studies/03-eval-driven-loops.md` (Session 5 inheritance of the same pattern). Strict reading of project CLAUDE.md §4 non-negotiable #1: redaction is the floor at all times, not only at publish time. Zero residual active target-company names across all 15 portfolio-repo files post-sweep.

### Notes (Session 5)

- Session 5 verifier subagent ran in two passes (case studies / synthesis docs) per Craig's kickoff disposition. The two-stage flag protocol caught two verifier confabulations: Pass 1 flagged "Five hook scripts" as a numerals-rule violation requiring "5" when the rule actually requires "Five" (5 is in 1-9 range; style-guide §5 says words for 1-9, numerals for 10+); confabulation rejected, position held per the truth-telling primitive. Pass 2 caught a real arithmetic bug in `metrics.md` (215,154 stated vs. 215,194 component-sum vs. 215,228 current-state); fixed to 215,228 reflecting current file sizes.
- 7 forward-references in `case-studies/01-personal-ai-os.md` (6 to `artifacts/policies/*`) and `case-studies/04-discipline-to-machinery.md` (1 to `artifacts/install-scripts/install-hooks-to-claude-code.sh`) remain as intentional placeholders. Session 6 ports the redacted versions and resolves the links.

---

## [0.2.0]—2026-05-08—Manifesto + Case Study #1 + README content

First content-bearing release. Manifesto opener anchored on Craig's verbatim "human moment with an AI algorithm" interview material. Case Study #1 walks the personal-AI-OS architecture through the platform-PM-thinking-applied-inward frame. README headline plus three reader paths.

### Added

- `manifesto.md`—the thesis (AI as multiplier, not equalizer), the origin moment, the designer-vs-runtime split. ~460 words.
- `case-studies/01-personal-ai-os.md`—Personal AI Operating System case study. ~2,200 words. Three-line author's-note header, platform-PM-thinking framing, four-layer architecture walk, dual-environment portability, three retrospection capsules, forward links to Sessions 4 through 7 deliverables.
- `README.md` content fills—tagline, ~120-word 30-second headline, three reader paths (recruiter / hiring manager / peer PM), footer with LinkedIn link.

### Notes

- Author's-note convention harmonized at Session 3 kickoff. §4 and §5 of the project plan now agree on *Designed by Craig / Runtime: Claude / Source artifacts*. Resolution log preserved in `inputs/author-note-template.md`.

---

## [0.1.0]—2026-05-08—Scaffolding

Initial directory structure and authoring conventions. No public publish yet—first push is Session 8.

### Added

- Repo skeleton matching `projects/ai-operating-system/CLAUDE.md` §5 architecture: `README.md`, `manifesto.md`, `methodology.md`, `metrics.md`, `case-studies/` (four case-study placeholders), `artifacts/` (CLAUDE.md, sample-eval, sample-roadmap, sample-hook, plus `policies/` + `sample-skill/` + `install-scripts/` subdirectories), `retrospection.md`, `surprises.md`, `for-pms-reusing.md`, this `CHANGELOG.md`.
- README skeleton with three reader paths (recruiter / hiring manager / peer PM) and a complete table of contents.
- methodology.md skeleton with the four-layer overview, the cross-cutting-patterns section, and the reading-sequences section.
- Author's-note convention defined in two variants (case-study 3-line header / artifact single-block header)—build-time template at `inputs/author-note-template.md` in the project workspace, never published.
- Style guide defined—voice, glossary, banned terms, pre-publication checks—build-time at `inputs/style-guide.md` in the project workspace, never published.

### Pending

- Manifesto language (Session 3).
- Case Study #1: Personal AI Operating System (Session 3).
- Case Study #2: Composer/Verifier (Session 4).
- Case Study #3: Eval-Driven Correction Loops (Session 5).
- Case Study #4: From Discipline to Machinery (Session 5).
- Retrospection synthesis + Surprises (Session 5).
- For-PMs-reusing path (Session 5 or 6 per CLAUDE.md §6).
- Metrics dashboard (Session TBD per CLAUDE.md §6).
- Redacted artifact tier (Session 6).
- Signal-triggered sync mechanism + `/publish-portfolio` slash command (Session 7).
- 60-second README test + first public publish + LinkedIn integration (Session 8).

### Notes

- Session 1 (2026-05-08) shipped the privacy audit, redaction registry, and `redact.py` redactor. Those are not portfolio content; they are the safety floor for everything that follows. Per CLAUDE.md §4 non-negotiable #1 ("privacy is binding"): nothing public-pushes until the registry is signed off, applied, and diffed clean.
- Working build location is `~/.claude-local/repos/ai-operating-system/`. The push step (Session 7's `/publish-portfolio`) is the only step that writes outside `~/.claude-local/`.
- All HTML-comment placeholders in v0.1 files are session-scoped scratch notes. They render invisibly in markdown but are visible to anyone reading raw source. They are stripped or replaced as later sessions populate the placeholder content.
