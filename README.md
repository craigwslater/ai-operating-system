# AI Operating System

> A personal AI operating system: the rules, identity, projects, skills, policies, and machinery for working with Claude as a long-term partner.

---

## What this is

This portfolio documents a personal AI operating system: a single source-of-truth folder, `~/.claude-local/`, that holds the rules, identity, projects, skills, policies, and machinery for working with Claude as a long-term partner. Designed by Craig Slater, with Claude as the runtime executing under the rules. The job-materials skill in this system has produced 40 evals (regression-test records, one per applied job), runs about 42 detectors that catch returning failure modes on every draft, has caught and fixed hundreds of errors autonomously per month, and has shipped dozens of tailored applications.

---

## Reader paths

This repo serves three readers. Pick the path that matches.

### If you're a recruiter—60 seconds

If you have one minute: read the headline above and skim the [manifesto](./manifesto.md). The numbers—40 evals, ~42 detectors, hundreds of errors caught and fixed autonomously per month—come from the corrections logs and eval archive of the underlying system. The [`Personal AI Operating System` case study](./case-studies/01-personal-ai-os.md) is the natural next read; it walks the meta-architecture in 10-15 minutes. Contact details are in the footer below.

### If you're a product hiring manager—10-20 minutes

If you have 10-20 minutes: read one or two case studies. [`Personal AI Operating System`](./case-studies/01-personal-ai-os.md) walks the meta-architecture—priority hierarchy, encode-into-source, the four-layer structure, dual-environment portability—and is the right entry point for assessing platform-PM thinking applied inward. [`Composer/Verifier`](./case-studies/02-composer-verifier.md) walks the two-agent pattern that runs the composer and the verifier in separate contexts so the audit can fail the draft. [`Earned Autonomy`](./case-studies/05-autonomous-execution.md) is the newest chapter—the safety-gated engine that runs a planned backlog end-to-end, with a human only at the decision gates. Each case study links to the redacted operational artifacts that back its claims. The [methodology overview](./methodology.md) is the layered alternative if you'd rather see the architecture in one read instead of through a case study.

### If you're a fellow PM curious about the methodology

If you're a fellow PM curious about the methodology: start with the [methodology overview](./methodology.md), then browse the [`artifacts/`](./artifacts/) folder for the redacted operational files (CLAUDE.md, policies, a sample skill, a sample eval, a sample ROADMAP, a hook script, the dual-environment install scripts). Each artifact carries a header explaining what was redacted and why it's included. The [`for PMs reusing this`](./for-pms-reusing.md) page is the explicit "how to build similar" walkthrough. The five case studies go deepest on individual patterns; the [retrospection](./retrospection.md) page is the synthesis statement of what the system would have wanted from day one.

---

## Contents

<!--
Table of contents—lists every page in the repo with a one-line description.
This is the navigation surface; every link must resolve.
Entries reflect §5 architecture exactly. As Sessions 3-7 fill placeholder files,
the one-line descriptions update to match the final content.
Keep relative links so the repo is browseable on github.com without configuration.
-->

### Manifesto and methodology

- [`manifesto.md`](./manifesto.md)—the thesis, the origin moment, the voice anchor. *(Session 3.)*
- [`methodology.md`](./methodology.md)—how the pieces fit. The layered overview of the architecture. *(Session 2 skeleton; content fills in across Sessions 3-5.)*
- [`metrics.md`](./metrics.md)—the operational dashboard. Four metrics, baseline 2026-05-08. *(Session TBD per CLAUDE.md §6.)*

### Case studies

- [`case-studies/01-personal-ai-os.md`](./case-studies/01-personal-ai-os.md)—Personal AI Operating System: meta-architecture (priority hierarchy, MEMORY.md, projects/policies/templates, encode-into-source, dual-environment portability). *(Session 3.)*
- [`case-studies/02-composer-verifier.md`](./case-studies/02-composer-verifier.md)—Composer/Verifier: a two-agent pattern + 40 evals + ~42 detectors. *(Session 4.)*
- [`case-studies/03-eval-driven-loops.md`](./case-studies/03-eval-driven-loops.md)—Eval-Driven Correction Loops: WRONG/RIGHT corrections-log, rule promotion, drift detection, era-shard pattern. *(Session 5.)*
- [`case-studies/04-discipline-to-machinery.md`](./case-studies/04-discipline-to-machinery.md)—From Discipline to Machinery: hooks layer encoding behavioral primitives. *(Session 5.)*
- [`case-studies/05-autonomous-execution.md`](./case-studies/05-autonomous-execution.md)—Earned Autonomy: the autonomous-execution engine, the nine-gate escalation taxonomy, and the earned-autonomy tier ladder (never / supervised / fire-and-forget). *(v2.0.)*

### Reflections

- [`retrospection.md`](./retrospection.md)—synthesis: what the system needed from day one. *(Session 5.)*
- [`surprises.md`](./surprises.md)—two surprises from the work. *(Session 5.)*
- [`for-pms-reusing.md`](./for-pms-reusing.md)—the "how to build similar" path for fellow PMs. *(Session 5 or 6 per CLAUDE.md §6.)*

### Redacted artifacts

The `artifacts/` folder contains operational files from the underlying system, ported with PII / target-company / third-party / prior-employer redactions applied. Each artifact carries a header describing what was redacted and why it's included. *(Session 6.)*

- [`artifacts/CLAUDE.md`](./artifacts/CLAUDE.md)—the global behavioral-rules file.
- [`artifacts/policies/`](./artifacts/policies/)—workflow policy files.
- [`artifacts/sample-skill/`](./artifacts/sample-skill/)—one redacted skill as a worked example.
- [`artifacts/sample-eval.md`](./artifacts/sample-eval.md)—one redacted eval.
- [`artifacts/sample-roadmap.md`](./artifacts/sample-roadmap.md)—the per-skill ROADMAP template.
- [`artifacts/sample-hook.sh`](./artifacts/sample-hook.sh)—one hook script.
- [`artifacts/install-scripts/`](./artifacts/install-scripts/)—dual-environment install scripts.

### Changes

- [`CHANGELOG.md`](./CHANGELOG.md)—version history. v0.1 was the scaffolding pass on 2026-05-08; subsequent versions track what gets published.

---

## Status

<!--
Session 8 fills this with the v1.0 published-on date and links to LinkedIn / GitHub profile.
Until then, status is "in build."
-->

*Published 2026-05-09 (v1.0). Author: [Craig Slater](https://github.com/craigwslater) on GitHub · [LinkedIn](https://www.linkedin.com/in/craig-slater/). See [`CHANGELOG.md`](./CHANGELOG.md) for version history.*

---

Contact: [LinkedIn](https://www.linkedin.com/in/craig-slater/).

This portfolio is a curated showcase derived from a private source folder; the operational system itself is not public. Updates flow source → portfolio via a signal-triggered sync mechanism (see [methodology](./methodology.md)) with per-push diff review. The mechanics of how the portfolio gets composed and refreshed are walked in the [methodology document](./methodology.md).

---

**Sources:** `~/.claude-local/projects/ai-operating-system/CLAUDE.md` (§5 architecture); `~/.claude-local/projects/ai-operating-system/inputs/interview-material.md` (manifesto opener).
**Last refreshed:** 2026-05-08
