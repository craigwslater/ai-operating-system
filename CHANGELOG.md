# Changelog

All notable changes to this portfolio are tracked here. Format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) conventions adapted for a content portfolio (Added / Pending / Notes rather than the software-release set). Versioning is [Semantic Versioning](https://semver.org/)—MINOR for substantive new content (case study, artifact tier), PATCH for revisions.

The portfolio's source of truth is `~/.claude-local/`. Updates flow `~/.claude-local/` → portfolio (per the project's non-negotiable that the repo is a derived artifact, never the source). Every public-repo push goes through diff review before the push runs.

---

## [Unreleased]

*Session 8 lands here as it ships.*

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
- Init-mode rehearsal completed on a `/tmp/test-init` throwaway repo. Confirmed `git init -b main`, `git config user.email/user.name`, and `git remote add origin git@github.com:craigwslater/ai-operating-system.git` syntax all execute clean. Live execution against the real `outputs/portfolio-repo/` working directory is Session 8 work per the locked plan.
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
- **Verification suite encoded as machinery.** Project §4 non-negotiable #1 (both strict-floor and triangulation-defense sub-bullets) moves from "the right thing to remember" to "the protocol's Step 1 cannot be skipped." Every `.md` file under `outputs/portfolio-repo/` runs through both verify mode (registry residuals) and sanity-grep mode (identifying-fact-cluster matches) before any staging. Either failure stops the publish.
- **Sanity-grep belt-and-suspenders codified.** The Session 6 carryforward (five registry gaps caught only by registry-blind sanity-grep; registry-based verify is necessary but not sufficient) is now part of the published mechanism. Both modes run in the verification suite; both must pass.

### Privacy (Session 7, 2026-05-08)

- **Sanity-grep dictionary build-time-only.** `inputs/sanity-grep-entities.md` lives in the same build-time-only classification as `redaction-registry.md`; never ported to `outputs/portfolio-repo/`. Same rationale: it contains the entity patterns that should not appear in published content; publishing the dictionary itself would invert the privacy floor.
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

- **NN #1 strict-floor reading sub-bullet codified.** Project CLAUDE.md §4 non-negotiable #1 now carries an explicit sub-bullet stating that redaction is the floor at all times across working drafts in `outputs/portfolio-repo/`, not only at publish time. Closes the implicit-vs-explicit ambiguity that allowed Session 4's verifier to miss two CS#2 active-target-company-name violations.
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
- Working build location is `projects/ai-operating-system/outputs/portfolio-repo/`. The push step (Session 7's `/publish-portfolio`) is the only step that writes outside `~/.claude-local/`.
- All HTML-comment placeholders in v0.1 files are session-scoped scratch notes. They render invisibly in markdown but are visible to anyone reading raw source. They are stripped or replaced as later sessions populate the placeholder content.
