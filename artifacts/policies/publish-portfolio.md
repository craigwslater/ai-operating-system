<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The publish-portfolio workflow protocol—what `/publish-portfolio` runs to ship content from the working portfolio-repo at `~/aios/repos/ai-operating-system/` to the public GitHub repo. Defines preconditions; a BLOCKING pending-content-corrections check ahead of them; the redactor verify + sanity-grep gate; an advisory tier of staleness, claim-value, claim-site and artifact-drift walkers; the diff-review hard gate; commit/push; and the sync-state update on success. Init-mode is the Session 8 first-publish branch; standard mode is every subsequent commit-and-push.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions. This file references workflow steps, file paths, and the project's binding non-negotiables only; no PII, target companies, third-party individuals, or prior-employer narrative are present.
> **Why it's included.** This is the protocol behind `/publish-portfolio`. It pairs with `session-end-portfolio-sync.sh` (one of the thirteen hooks registered in `artifacts/install-scripts/install-hooks-to-claude-code.sh`) to form the complete sync mechanism: the hook detects portfolio-worthy signals at session-end; this protocol is the only path that updates the public repo and the only path that updates the sync state. The per-push diff-review hard gate is the runtime expression of project non-negotiable #5.

---

# Publish-Portfolio Protocol

Workflow for shipping content from `~/aios/repos/ai-operating-system/` to the public GitHub repo `craigwslater/ai-operating-system`.

**Architecture (locked Session 7 kickoff 2026-05-08):** Commit-and-push only. This protocol does NOT regenerate source-to-portfolio content. Source regeneration (re-running redactor on artifact-tier files after a CLAUDE.md primitive was added, etc.) happens in dedicated sessions BEFORE invocation. The protocol operates on `repos/ai-operating-system/` as-is.

**Bound by.** Project `projects/ai-operating-system/CLAUDE.md` §4 Non-Negotiables — especially #1 (Privacy is binding, both strict-floor and triangulation-defense sub-bullets) and #5 (Sync requires explicit per-push approval). The diff-review step is unbypassable.

---

## This protocol is one copy — a consumer inherits it whole, no subsets

The steps below **are** the publish protocol. Any runtime that drives a publish — `/publish-portfolio`, or anything added later — **inherits the entire set**. There is no partial inheritance by default, and no inheritance by range: a consumer that names "Steps 0–6" has pinned a boundary that stops tracking this file the moment a step is added past it.

A consumer may drop a step only by **naming that step explicitly, with its reason**, in its own file. Everything it does not name, it runs.

**Do not restate the inherited steps anywhere else** — not as a step list, and not as an inline summary of a step while driving it. A consumer that does has made a second copy of this protocol, and a second copy drifts the moment this file changes, invisibly: both files still look right read on their own. That is exactly how `RA-INST-001` happened. The runtime wrapper restated Step 1's privacy hard gate as `.md`-only — dropping the `.sh` class and the zero-file-scan guard — omitted Step 1.5 entirely, and added a lifecycle precondition this policy nowhere imposes, so it could simultaneously narrow the gate and refuse a publish this protocol permits. **Name your exclusions; inherit the rest by reference.** Pinned by `hooks/tests/test-publish-portfolio-parity.sh`.

This is the same rule `policies/session-end.md` states for the session-level closing tail, instantiated for this protocol. Generalizing it to every policy/wrapper pair in the workspace is `verdict-truthfulness-repairs` S7 (PF-2), not this file's job.

---

## Steps

### Step 0 — Precondition checks

Verify before doing anything that touches git state:

- `repos/ai-operating-system/` exists.
- Git is initialized inside `repos/ai-operating-system/` (`git rev-parse --is-inside-work-tree` returns true).
- A remote named `origin` is configured pointing at `github.com/craigwslater/ai-operating-system` (or whatever public URL is locked in Session 8).
- Working tree state: `git status --short` runs cleanly. If there are uncommitted changes, that is expected (this protocol is the commit step).

If git is NOT initialized, this is the Session 8 prerequisite case. Surface to Craig: "Portfolio-repo is not yet a git repository. Session 8 init step (`git init`, remote setup, initial-publish flow) has not run. Do you want to run init now, or defer to Session 8?" Do NOT proceed past this point without an explicit answer.

### Step 0.5 — Pending content corrections (BLOCKING)

Read `projects/ai-operating-system/outputs/pending-content-corrections.md` — the queue of **known-wrong or known-stale published content**. Every entry under `## OPEN` is a blocking pre-flight item for this run.

For each `OPEN` entry, exactly one of:

- **Fix it in the working tree during this run**, so the correction rides this push. Then move the entry to `## RESOLVED` with the date and the commit hash (do this at Step 5, once the hash exists).
- **Defer it explicitly** — Craig's call, not Claude's. Record the reason and the re-evaluation trigger on the entry. A silent skip is not a disposition.

**Where the fix goes.** An entry usually names both a published file under `repos/ai-operating-system/` **and** a source file under `~/aios/`. Fix **both**, source first — publishing a correction without fixing its source inverts the *"source of truth is `~/aios/`"* non-negotiable and guarantees the defect returns at the next regeneration.

**Why this is Step 0.5 and not later.** It runs before the verification suite (Step 1) and before anything touches git state (Step 2), so a correction is part of the run's diff rather than a follow-up push. The queue is **not** `portfolio-sync-pending.md` — that file is hook-owned and cleared on every successful publish, so a human-authored correction placed there would be destroyed. This one is never auto-cleared.

**No-op when the queue is empty or the file is absent** — the normal state. Say so in one line and continue.

### Step 1 — Final verification suite

Run the redactor's `verify` mode + `sanity-grep` mode against every `.md` and `.sh` file under `repos/ai-operating-system/`. Both modes must exit 0 for every file before proceeding.

```bash
cd ~/aios/projects/ai-operating-system
# zero-file-scan guard (fable-os-review A8.3 rider, 2026-07-14): the find MUST match ≥1 file,
# else the gate passes vacuously — the exact T-08 fail-open class this whole block closes.
# Fail fast on a zero-file scan (portable to bash 3.2 / sh).
_scanned=$(find ~/aios/repos/ai-operating-system \( -name '*.md' -o -name '*.sh' \) -type f | wc -l)
if [ "$_scanned" -eq 0 ]; then
  echo "REDACTION GATE FAILURE: scan matched zero files — repos/ai-operating-system path is wrong or empty; the gate would pass vacuously. STOP." >&2
  exit 1
fi
find ~/aios/repos/ai-operating-system \( -name '*.md' -o -name '*.sh' \) -type f \
  | while read -r f; do
      python3 scripts/redact.py verify "$f" || exit 1
      python3 scripts/redact.py sanity-grep "$f" || exit 1
    done
```

If any file fails either mode: STOP. Do not proceed to commit. Surface the failures to Craig and disposition them (apply registry substitution, apply defensive-margin substitution, or re-port the file from source) before retrying. The verification suite is a hard gate per project §4 NN #1 strict-floor reading.

### Step 1.5 — Staleness check + claim verify + claim-site check + artifact drift (advisory)

Run the auto-walkers built in `projects/ai-operating-system-maintenance/`: **(a)** and **(b)** in Session 1 (2026-05-09), **(c)** in the instruments unit (2026-08-26) — CHECKs 1 and 2 in part 1, CHECK 3 in part 2 the same day — and **(d)** as Guard 3 (2026-08-27). All four checks are **advisory** — non-zero exit does NOT block the push, but prompts a Craig disposition.

**(a) Staleness check.** Walks every `*.md` file under `repos/ai-operating-system/` (excluding `artifacts/`), parses each file's `**Sources:**` / `**Last refreshed:**` footer, resolves source paths under `$CLAUDE_LOCAL_ROOT`, computes mtime deltas against declared `Last refreshed` dates, and emits a tabular drift report.

```bash
python3 ~/aios/skills/publish-portfolio/scripts/staleness-check.py
```

The script's default target is `$CLAUDE_LOCAL_ROOT/repos/ai-operating-system` (resolved via the hooks-layer fallback chain). Pass an explicit positional arg to override. Exit 0 if no source has drifted ≥90 days; exit 1 with the report otherwise. Default threshold is 90 days; override with `--threshold-days N`. Use `--verbose` to surface all checked sources, not just drifted.

**(b) Claim verify.** Parses the master tables in `.claim-register.md` (sidecar; never committed), runs each row's `verify` shell command against `~/aios/`, and compares output to the row's `Expected` value.

```bash
cd ~/aios/projects/ai-operating-system
python3 ~/aios/skills/publish-portfolio/scripts/claim-verify.py .claim-register.md
```

Exit 0 if every mechanical row PASS; exit 1 if any row DRIFT or ERROR. Manual rows (`` `manual` `` marker) and frozen-historical rows (`` `N/A (frozen historical)` `` marker) are reported informationally and never block exit.

**(c) Claim-site check.** The two walkers above check claim *values* and footer *dates*. Neither checks that a register row's `Portfolio` pointers land on the claim, nor that a claim's `Source` is declared in the footer of the file publishing it — the second of which produces an affirmative CLEAN verdict from (a) on a file whose claim has no term in the subtraction at all. And none of walkers (a)/(b) — nor CHECKs 1 and 2 — could see a claim site the register never lists at all, which is what CHECK 3 adds.

```bash
python3 ~/aios/skills/publish-portfolio/scripts/claim-site-check.py
```

**Path resolution, all four walkers.** Conventions live alongside the script source headers; all four honor the hooks-layer fallback chain (`${HOME}/aios` → `${HOME}/mnt/aios` → `${CLAUDE_LOCAL_ROOT}`). *(Moved here 2026-08-26 — it had been the tail of the disposition paragraph and ended up stranded mid-rule when that paragraph was rewritten.)*

Three checks share one register parse: **CHECK 1 (POINTER)** — does each `Portfolio` pointer's cited line contain the claim? **CHECK 2 (FOOTER)** — is each claim's `Source` declared in the footer of the file publishing it? **CHECK 3 (UNTRACKED)** — does the claim appear in a portfolio file the row does *not* list? `--check pointer|footer|untracked` runs one; row-level outcomes (UNPARSED, NO-ANCHOR, NOT-PUBLISHED) are reported in every mode from a single block — UNPARSED and NO-ANCHOR **counted**, NOT-PUBLISHED **disclosed and deliberately not counted**. *(This said "reported and counted" of all three until 2026-08-26; the block's own NOT-PUBLISHED line reads "Not a finding".)*

Exit 1 with the findings; **exit 2 if the scan resolved nothing** — a couldn't-check, never a clean run. Exit 0 means no findings, which is **not** the same as everything having been checked: a bare-root `Source` or a bare-root footer is disclosed on the summary line as NOT CHECKABLE and does not affect the exit code. The `Summary:` line prints on every path, including the zero-resolution one, and is the authority on what counted. Published phrasings for rows whose canonical wording differs from the portfolio's live in the register's `## Claim-site anchors` table, and they **add to** the derived literals rather than replacing them. The exemption classes are enumerated in the script header — deliberately not restated here, because this policy's own opening rule says a second copy drifts the moment the first changes, and this sentence had already gone stale once.

**(d) Artifact drift check (Guard 3).** Walkers (a)–(c) never ask whether an artifact *file* still matches what it was ported from: (a) excludes `artifacts/` by design, and (c) reaches artifact files but asks whether a *claim* is sited correctly, never whether the file around it is current. This walker pairs each artifact **named by a map row** with its source, re-runs the redaction registry, strips the port-time note, and diffs; an artifact with no row is reported `UNMAPPED`, never paired.

```bash
python3 ~/aios/skills/publish-portfolio/scripts/artifact-drift-check.py
```

Exit 1 with the findings; **exit 2 on any couldn't-run** — no workspace root, no map, no redactor, an unhandled crash, or a scan that resolved no artifacts — never a clean run. The `Summary:` line prints on every path and is the authority; exemption classes and normalization rules are canonical in the script header, deliberately not restated here.

`.artifact-map.md` is canonical for the population, the pairings, and which artifacts are declared excerpts. **A run that reaches the report appends one ledger entry**; `--no-record` opts out and says so. ⚠️ **A ledger entry is not by itself evidence of a completed scan.** Most exit-2 paths return before the append, but one — a *non-empty* tree that resolves no artifacts — appends first and then reports itself blind, and says so on its own line. **The per-path breakdown is the script's contract and is deliberately not enumerated here:** this sentence carried a count of those paths and was wrong about it **twice**, both times by folding two distinct returns into one. One fact, one source. ⚠️ Both files live under `projects/`, which is **gitignored** — outside version control and outside Step 3's diff gate. "Append-only" is a property of the writer, not the store.

⚠️ **The ledger adds a signal and never subtracts a finding** — Craig's decision, 2026-08-27. Every drifted artifact stays a counted finding for as long as it drifts; the ledger exists only to add **GREW**, an artifact whose recorded drift *rose* between runs. The baseline-that-gates alternative was declined as the same shortcut **disposition (c) condition 1 below** forbids for `Last refreshed` stamps. Reasoning: the script header.

**Disposition on flag** — three options, lettered **(a)/(b)/(c)** and referred to elsewhere as *disposition (a)/(b)/(c)*. ⚠️ These are **not** the walkers (a)/(b)/(c)/(d) above; the two sets share letters (the walkers now run to (d), the dispositions stop at (c)) and this Step uses both, so always say which. **Disposition (a)** regenerate the affected portfolio file from current source in a dedicated session before push. **Disposition (b)** accept the drift and document the decision in the commit message. **Disposition (c)** update the file's `Last refreshed` date / register row inline — **only under the two conditions immediately below**, both of which are part of (c) rather than commentary on it. ⚠️ **(c) read "if a quick spot-check confirms the content is still accurate against current source" until 2026-08-26.** A quick spot-check is not sufficient acceptance for either edit (c) permits, and leaving that phrase standing while the conditions sat in a separate block meant (c) overrode them by adjacency.

⚠️ **Disposition (c) carries two conditions, and neither is optional.** `projects/ai-operating-system-maintenance/CLAUDE.md` §3's relaxation audit marks **three** guarantees ❌ Weakened; **two of them** — the register-row edit that clears a DRIFT, and the footer date bumped without a re-read — name compensating controls that (c) as previously written authorized bypassing. *(This said "two guarantees" until 2026-08-26; a reader checking §3 found three rows and could not tell which two were meant. The third is "the measurer grading its own homework", whose controls are the acceptance re-run, Craig's diff gate, and the §8 verifier-separation rule.)* §3 says so in as many words: *"Step 1.5 disposition (c) invites the shortcut and needs a caution added."* Added 2026-08-26 (Guard 2 unit), routed there from the record-verifier round:

1. **A `Last refreshed` bump must record, in the same edit, what was re-read against it.** `staleness-check.py`'s only input is that stamp, so an activation can zero every drift by editing date strings. The acceptance for such a bump is the re-read evidence, never a clean walker run.
2. **A register-row edit must be surfaced to Craig separately in the diff, with the published number it protects quoted alongside it** — never folded into a bulk register diff. Rewriting a row's `Verify` or relaxing its `Expected` turns a DRIFT green without touching the portfolio, and the acceptance test cannot catch it because the test reads the file being edited.

⚠️ **A MAP-ROW EDIT binds exactly as condition 2 does, and needs the control more.** *(Unnumbered because these conditions sit under disposition (c), which does not exist for walker (d) — not because conditions are (c)-scoped in general; the note below unscopes condition 2.)* `.artifact-map.md` is (d)'s input as the register is (b)/(c)'s: **re-pointing a row silently reduces that artifact's DRIFT figure and suppresses GREW** without touching a published file — condition 2's laundering, one file over, and the map's header concedes the guard cannot verify a pairing. **So every map-row edit is surfaced to Craig separately with its pairing evidence**, never folded into a bulk diff. ⚠️ **Not delegable to the diff gate:** `projects/` is gitignored, so the map appears in **no** git diff and Step 3 covers `repos/` only. Added 2026-08-27.

⚠️ **Condition 2 binds ANY register-row edit made under this Step, not only one taken as disposition (c).** It was written as a condition *of* (c), and the paragraph below then declares (c) unavailable for a claim-site finding — which put the control out of reach of exactly the edits it most needs to govern, since the claim-site rules prescribe register-row edits (*add an anchor row*, *re-point or drop the pointer*, *add the site to the row's `Portfolio` cell*) as their primary fix. The underlying §3 control is broader in its own words — *"every register-row edit in an activation is called out separately in the diff"* — so the narrowing was this policy's, not §3's. Corrected 2026-08-26.

**None of disposition (a)/(b)/(c) is available for a claim-site finding.** All three are written for what walkers (a) and (b) report — *drift in a value or a date*. A CHECK 1/2/3 finding is instead a wrong or missing *pointer, footer or site*, so it is dispositioned by the rules in the rest of this paragraph — **and by the default in the next paragraph for any class those rules do not name**, so that no counted finding is left without a defined action. And **a MISANCHORED or ABSENT raise is triaged before it is treated as a defect**. The raise means only *"no known literal landed at this line"* — which is a wrong pointer **or** a missing published phrasing in the register's `## Claim-site anchors` table, and the report cannot tell them apart. Open the cited line first. If it carries the claim in wording no anchor covers, the fix is an **anchor** row; only if it does not is the fix a **register** one (re-point or drop the pointer). Skipping that triage deletes correct pointers: the first run of this check raised fourteen, and **nine** proved to be anchor gaps. *(This read "eight" until 2026-08-26. Eight was the count before the third verifier round reversed a finding it had declined in error — Row 10's `CS#4 L21` — and the reversal made it nine. The full fourteen-way disposition, which is what the number has to reconcile against, is canonical in `skills/publish-portfolio/ROADMAP.md`; do not restate it here.)* An UNCOVERED footer is a **portfolio** fix (add the source to the file's footer). Nothing here is ever resolved by *loosening* an anchor to match — that is the false-PASS class from the other direction.

**A CHECK 3 raise is triaged differently again, and the direction matters.** CHECK 1 finds an *absence* at a line the register cites; CHECK 3 finds a *presence* in a file the register does not cite, so the two are not symmetric and the same instinct is wrong on one of them. An **UNTRACKED** raise is a **register** fix in the ordinary case — add the site to the row's `Portfolio` cell — but only after confirming the landing is the same claim and not a coincidence of wording; the report prints the probe that fired precisely so that read takes one line. **ANNOTATED-NON-SITE** is the sharpest class: the register wrote down why that file is *not* a site and the claim landed there anyway, so either the aside is wrong or the landing is incidental, and both are live (Row 9's aside says `methodology L71` "publishes no count" while L71 reads "Five signal categories fire the hook:" and enumerates five; Row 22's aside correctly describes a frozen historical figure). Read the aside, then fix the aside or dismiss the raise — never silence the class. **NO-PROBE** is a couldn't-check: that row was never searched, and it is not evidence of anything — **the fix is an anchor row** giving the row a probe the gate accepts (a published phrasing, not a bare filename or a bare quantity), and it is **never a dismissal**. *(Until 2026-08-26 this clause described NO-PROBE and prescribed nothing, and because the class was *named* here the "every other counted class" default below could not reach it — the actionless-class defect one layer down, caught by the repair round.)* **CHANGELOG-ECHO** is disclosed and not counted, and it carries a named blind spot — a release-log entry that has genuinely gone false looks identical to one that has not.

**Default for every other counted class — added 2026-08-26, because they had none.** `UNRESOLVED`, `SPANS-LINES`, `UNPARSED`, `NO-ANCHOR` and `EMPTY-TREE` are all **couldn't-checks**: the run could not evaluate that pointer, row or tree at all. Each is a **register or invocation fix** — repair the cell, add an anchor row, or point the run at the right tree — and **never a dismissal**, because a couldn't-check carries no evidence that the claim is fine. `NO-FOOTER` and `UNREADABLE` are **portfolio fixes** (add the provenance footer; repair the file's encoding). *(Every one of these increments the summary count, and until this paragraph existed the Step forbade (a)/(b)/(c) for them and named no replacement — a reader following the Step literally had no defined action for the **seven** classes enumerated here. This parenthetical said "five", which counted only the couldn't-check subset and omitted NO-FOOTER and UNREADABLE: a count contradicting its own list, inside the fix whose purpose was completeness.)*

**A walker-(d) finding is dispositioned differently again, and disposition (c) does not exist for it** — (c) edits a `Last refreshed` stamp or a register row, and walker (d) reads neither, so nothing is there for (c) to bump. That is the point: this walker cannot be quieted by a date. The *"Default for every other counted class"* paragraph above is scoped to walker (c); where the two share a class **name**, the rule below governs (d)'s instance.

- **DRIFT** and **GREW** — **portfolio** fixes. Re-port the artifact from current source: re-run the redaction registry, re-attach the port-time note, put the result through Step 1's hard gate. Never edit the artifact to reduce a number, and never edit the *source* to match the artifact — that inverts NN #1, which is the whole reason this walker compares one against the other. **GREW is the more urgent**: both figures it compares were recorded, so something moved between runs that nobody reviewed. ⚠️ It does **not** identify *what* moved — a source edit, an artifact edit, a registry change, or a re-pointed map row all produce it. Open the file before naming a cause.
- **UNMAPPED**, **ARTIFACT-MISSING**, **SOURCE-MISSING**, **MAP-UNPARSED**, **MAP-DUPLICATE**, **MAP-OUT-OF-TREE**, **MAP-UNSUPPORTED-TYPE** — **map** fixes. A new row is established the way every existing one was, by reading the artifact's own `What this is.` note against the named source, never by pattern-matching a filename. The last three name a row that resolves to an artifact another row already covers, to a path outside `artifacts/`, or to a file type the walker does not compare — each is a row to repair or drop, never a dismissal.
- **NO-PORT-HEADER**, **HEADER-UNTERMINATED**, **EMPTY-EXCERPT** — **portfolio** fixes (add the author's note; terminate it; restore the excerpt's body). For HEADER-UNTERMINATED the reported drift figure is **unusable** until it is fixed, because the unstripped note sits inside the comparison; EMPTY-EXCERPT exists because set membership reports 0 orphans for an emptied file, so 0 drift there is not a clean verdict.
- **REDACT-FAIL**, **UNREADABLE**, **LEDGER-WRITE-FAILED** — **couldn't-checks**. Repair the file, the encoding, or the ledger path. Exactly as for the walker-(c) classes above, **never a dismissal**: a couldn't-check carries no evidence that the artifact is fine, and LEDGER-WRITE-FAILED additionally means the growth axis is down for that run.
- **EMPTY-TREE** — an **invocation** fix, and *not a counted class*: it is a report path that exits 2 without appending to `findings`, so it never reaches the Summary's count. Point the run at the right tree.

**COMPLETENESS.** ⚠️ These bullets cover **every class the walker appends to `findings`**, and did not — five were added by later verifier rounds and none reached this Step until the closing record round found the gap; a counted class with no defined action is the actionless-class defect this Step already fixed once for walker (c). `EMPTY-TREE`, `SHRANK` and the ledger-down condition are **not** counted classes, and are dispositioned anyway because a reader meets them in the same report.
- **SHRANK** — disclosed, not counted, and **read it before dismissing it**. A drift figure that *fell* with no re-port between is the observable fingerprint of the inversion forbidden two bullets up — a source edited to match its artifact — but is also produced innocently by a completed re-port or a registry change. Confirm which.
- **A ledger that could not be read, and `growth UNDETERMINED`** — the GREW axis is **down**, not clean: GREW *cannot fire at all*, and the coverage line says so. A couldn't-check on that class, not an absence of growth; repair the ledger before reading a growth verdict as meaningful.

⚠️ **Disposition (b) — accept and document — is the expected answer while the re-port backlog stands**; draining the tier is a multi-session programme, not a publish-time fix. ⚠️ **The tier is NOT uniformly stale** (this said otherwise until 2026-08-27) — drift spans 0 on one artifact to three figures on others, and **no count belongs here; the run is the authority.** **Re-evaluation trigger:** when the backlog drains this default expires, and whether (d) should block becomes Craig's open question. (b) must never become silence — name the accepted drift in the commit message.

### Step 2 — Stage changes

Inside `repos/ai-operating-system/`:

```bash
git add -A
git status --short
```

Surface the staged-files summary to Craig as plain text. Do not commit yet.

### Step 3 — Surface git diff to Craig (HARD GATE)

```bash
git diff --staged
```

Display the full unified diff. Wait for explicit Craig approval before proceeding. This step is non-negotiable per project §4 NN #5. The valid approvals are: "approved," "ship it," "yes push," or any unambiguous affirmative naming the diff. Vague responses ("looks good," "ok") do NOT count as approval — re-prompt with: "Confirming approval to commit + push the staged diff above. Reply 'approved' to proceed."

If Craig requests changes, exit this protocol; the changes are made, then this protocol is re-run from Step 1.

### Step 4 — Commit, then hand the push to Craig

On approval, compose a commit message. Default form:

```
v[VERSION] — [milestone-name]

Synced from ~/aios/ on YYYY-MM-DD. Signals: [list from
portfolio-sync-pending.md].

Per-push diff reviewed and approved by Craig.
```

Write it to `/tmp/commit-message.txt` and commit:

```bash
git commit -F /tmp/commit-message.txt
```

Confirm the commit landed with `git log -1 --oneline`.

**The invariant is the approval, not the hand on the keyboard: no push runs without Step 3 approval recorded. Who executes it is environment-conditional.** *(Scoped 2026-08-24 by Craig, at the fourth firing of the `skills/publish-portfolio/ROADMAP.md` entry that tracked this. The rule was written absolutely but was only ever justified by a Cowork constraint, and twice produced a wrong statement to Craig that he had to correct live.)*

- **Cowork — Craig runs it.** The sandbox has no GitHub credentials (no credential helper, no SSH key, no token), so a push from it fails with `could not read Username for 'https://github.com'`. This is a capability limit, not a permission one. Surface the exact command for Craig to run in his own terminal, then wait for him to confirm he has run it:

  ```bash
  cd ~/aios/repos/ai-operating-system && git push origin main
  ```

- **Claude Code on Craig's Mac — the assistant runs it,** once Step 3 approval is recorded. Credentials exist and the push succeeds; stalling to hand Craig a command he has already authorized costs a round-trip every publish and states something false about what the assistant can do. This matches `policies/sync-private-mirror.md` Step 4, which has always made the same split on identical facts.

Either way, **verify the push landed rather than assuming it** — anonymous `git fetch` works for the public repo without credentials:

```bash
git fetch origin && git rev-list --left-right --count origin/main...main
```

A `0	0` result (0 behind, 0 ahead) confirms `origin/main` contains the commit. Only this Claude-verified, confirmed-landed push satisfies the Step 5 precondition.

### Step 5 — Update sync state

On successful push:

- Re-run `compute_current_state` from `hooks/session-end-portfolio-sync.sh` (or replicate inline) and write the output to `projects/ai-operating-system/.portfolio-sync-state`. This becomes the new "since-last-sync" baseline.
- Truncate `projects/ai-operating-system/outputs/portfolio-sync-pending.md` to its header-only state (preserve the file but clear all `## Detected ...` stanzas).
- Read back both files to confirm the writes landed.

### Step 6 — Confirm to Craig

One-line summary: commit SHA + branch + new state-file timestamp + cleared-pending-file confirmation.

---

## Init mode (Session 8)

If Step 0 found an uninitialized `repos/ai-operating-system/` working tree, the init flow is:

1. `cd repos/ai-operating-system/ && git init -b main`. The `-b main` flag requires git ≥2.28 (released 2020-07-27); on older git versions the init fails with "unknown switch `b'." Cross-version fallback (behaviorally identical):
   ```bash
   cd repos/ai-operating-system/ && git init && git symbolic-ref HEAD refs/heads/main
   ```
2. Configure remote: `git remote add origin git@github.com:craigwslater/ai-operating-system.git` (Craig provides the exact URL).
3. Run Step 1 (verification suite) on every file before the initial commit. Hard gate.
4. Run Step 2 (stage all).
5. Run Step 3 (diff review). For init-mode the diff is large — Craig may want to read selected files individually rather than the full diff. Both are acceptable; the approval requirement is unchanged.
6. Run Step 4 (commit, then push per the environment split above), with `git push -u origin main` for the initial push.
7. Run Step 5 (initialize sync state).

---

## Anti-patterns

These are the failure modes this protocol exists to prevent:

1. **Pushing without diff review.** Project §4 NN #5 makes per-push approval mandatory. Any path that runs `git push` without surfacing the diff and waiting for explicit approval is a hard violation.
2. **Pushing on a verify-mode failure.** Project §4 NN #1 strict-floor reading: redaction is the floor at all times. A file that fails `verify` mode cannot be pushed. No exceptions.
3. **Pushing on a sanity-grep failure.** Project §4 NN #1 triangulation-defense reading: identifying-fact-cluster matches must be defensive-margin-substituted before push. Sanity-grep failure is not advisory; it is a hard gate.
4. **Updating state file without successful push.** State file is the source of truth for "last published state." Updating it without a confirmed push creates false-positive "in sync" status that masks unsynced work.
5. **Treating "looks good" as approval.** Vague responses do not count. The approval phrase must unambiguously name the diff being approved.
6. **Regenerating source content during the publish flow.** Per-push protocol is commit-and-push only; source regeneration is dedicated-session work. If a content gap is discovered during Step 3 review, exit the protocol, fix the source, and re-run from Step 1.
7. **Skipping read-back verification on state-file + pending-file writes.** Step 5 writes are persistent state that affects future hook runs. Failing reads here compound: a missed state-file update means the hook re-fires the same signals next session.

---

## Known v1 limitations

- **Multi-session signal noise.** The session-end hook re-fires the same signals on every session-end run between publishes (state is updated only by /publish-portfolio). The pending-file accumulates `## Detected YYYY-MM-DD` stanzas; this protocol's Step 1-5 dedupes by reading the union and clearing on push. Dedup-at-detection-time is a v2 candidate.
- **No automated source regeneration.** Per the locked architecture, this protocol does not run the redactor against source files to refresh artifact-tier content. New CLAUDE.md primitives, for example, require a dedicated session to re-port the artifact-tier `repos/ai-operating-system/artifacts/CLAUDE.md` before the next publish.
- **Init mode is Session 8 work.** Step 0's not-initialized branch defers to Session 8. ~~Init flow is documented above but has not been run end-to-end.~~ **Corrected 2026-08-24:** it has. `repos/ai-operating-system` carries `origin https://github.com/craigwslater/ai-operating-system.git` and a release history from v1.0 through v2.0.3, so the init flow ran end-to-end at Session 8 and the branch is documented-and-exercised. `policies/sync-private-mirror.md` propagated this same stale claim by reference and is corrected alongside.
