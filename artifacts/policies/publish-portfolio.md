<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The publish-portfolio workflow protocol—what `/publish-portfolio` runs to ship content from the working portfolio-repo at `projects/ai-operating-system/outputs/portfolio-repo/` to the public GitHub repo. Defines preconditions, the redactor verify + sanity-grep gate, the diff-review hard gate, commit/push, and the sync-state update on success. Init-mode is the Session 8 first-publish branch; standard mode is every subsequent commit-and-push.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions. This file references workflow steps, file paths, and the project's binding non-negotiables only; no PII, target companies, third-party individuals, or prior-employer narrative are present.
> **Why it's included.** This is the protocol behind `/publish-portfolio`. It pairs with `session-end-portfolio-sync.sh` (one of the six hooks registered in `artifacts/install-scripts/install-hooks-to-claude-code.sh`) to form the complete sync mechanism: the hook detects portfolio-worthy signals at session-end; this protocol is the only path that updates the public repo and the only path that updates the sync state. The per-push diff-review hard gate is the runtime expression of project non-negotiable #5.

---

# Publish-Portfolio Protocol

Workflow for shipping content from `~/.claude-local/projects/ai-operating-system/outputs/portfolio-repo/` to the public GitHub repo `craigwslater/ai-operating-system`.

**Architecture (locked Session 7 kickoff 2026-05-08):** Commit-and-push only. This protocol does NOT regenerate source-to-portfolio content. Source regeneration (re-running redactor on artifact-tier files after a CLAUDE.md primitive was added, etc.) happens in dedicated sessions BEFORE invocation. The protocol operates on `outputs/portfolio-repo/` as-is.

**Bound by.** Project `projects/ai-operating-system/CLAUDE.md` §4 Non-Negotiables — especially #1 (Privacy is binding, both strict-floor and triangulation-defense sub-bullets) and #5 (Sync requires explicit per-push approval). The diff-review step is unbypassable.

---

## Steps

### Step 0 — Precondition checks

Verify before doing anything that touches git state:

- `outputs/portfolio-repo/` exists.
- Git is initialized inside `outputs/portfolio-repo/` (`git rev-parse --is-inside-work-tree` returns true).
- A remote named `origin` is configured pointing at `github.com/craigwslater/ai-operating-system` (or whatever public URL is locked in Session 8).
- Working tree state: `git status --short` runs cleanly. If there are uncommitted changes, that is expected (this protocol is the commit step).

If git is NOT initialized, this is the Session 8 prerequisite case. Surface to Craig: "Portfolio-repo is not yet a git repository. Session 8 init step (`git init`, remote setup, initial-publish flow) has not run. Do you want to run init now, or defer to Session 8?" Do NOT proceed past this point without an explicit answer.

### Step 1 — Final verification suite

Run the redactor's `verify` mode + `sanity-grep` mode against every `.md` and `.sh` file under `outputs/portfolio-repo/`. Both modes must exit 0 for every file before proceeding.

```bash
cd ~/.claude-local/projects/ai-operating-system
find outputs/portfolio-repo \( -name '*.md' -o -name '*.sh' \) -type f \
  | while read -r f; do
      python3 scripts/redact.py verify "$f" || exit 1
      python3 scripts/redact.py sanity-grep "$f" || exit 1
    done
```

If any file fails either mode: STOP. Do not proceed to commit. Surface the failures to Craig and disposition them (apply registry substitution, apply defensive-margin substitution, or re-port the file from source) before retrying. The verification suite is a hard gate per project §4 NN #1 strict-floor reading.

### Step 1.5 — Staleness check (advisory)

For each portfolio-repo file with a `**Sources:**` / `**Last refreshed:**` footer, compare the declared `Last refreshed` date against the mtime of each listed source file in `~/.claude-local/`. If any source-file mtime exceeds the file's declared `Last refreshed` date by **≥90 days**, surface the drift to Craig as a staleness flag.

This step is **advisory only** — it does NOT block the push. The flag prompts Craig to decide between: (a) regenerate the portfolio file from current source in a dedicated session before push; (b) accept the drift and document the decision in the commit message; or (c) update the file's `Last refreshed` date inline if a quick spot-check confirms the content is still accurate against current source.

For v1 the check is manual. Auto-detection (parse footers → compute source mtime deltas → emit a staleness report) is a `projects/ai-operating-system-maintenance/` Session 1 deliverable, tracked in `skills/publish-portfolio/ROADMAP.md` "Per-file provenance + staleness automation."

### Step 2 — Stage changes

Inside `outputs/portfolio-repo/`:

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

### Step 4 — Commit + push

On approval, compose a commit message. Default form:

```
v[VERSION] — [milestone-name]

Synced from ~/.claude-local/ on YYYY-MM-DD. Signals: [list from
portfolio-sync-pending.md].

Per-push diff reviewed and approved by Craig.
```

Then:

```bash
git commit -m "$(cat /tmp/commit-message.txt)"
git push origin main
```

Confirm push succeeded by checking the exit code AND running `git log -1 --oneline` to read back the new commit.

### Step 5 — Update sync state

On successful push:

- Re-run `compute_current_state` from `hooks/session-end-portfolio-sync.sh` (or replicate inline) and write the output to `projects/ai-operating-system/.portfolio-sync-state`. This becomes the new "since-last-sync" baseline.
- Truncate `projects/ai-operating-system/outputs/portfolio-sync-pending.md` to its header-only state (preserve the file but clear all `## Detected ...` stanzas).
- Read back both files to confirm the writes landed.

### Step 6 — Confirm to Craig

One-line summary: commit SHA + branch + new state-file timestamp + cleared-pending-file confirmation.

---

## Init mode (Session 8)

If Step 0 found an uninitialized portfolio-repo, the init flow is:

1. `cd outputs/portfolio-repo/ && git init -b main`
2. Configure remote: `git remote add origin git@github.com:craigwslater/ai-operating-system.git` (Craig provides the exact URL).
3. Run Step 1 (verification suite) on every file before the initial commit. Hard gate.
4. Run Step 2 (stage all).
5. Run Step 3 (diff review). For init-mode the diff is large — Craig may want to read selected files individually rather than the full diff. Both are acceptable; the approval requirement is unchanged.
6. Run Step 4 (commit + push), with `git push -u origin main` for the initial push.
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
- **No automated source regeneration.** Per the locked architecture, this protocol does not run the redactor against source files to refresh artifact-tier content. New CLAUDE.md primitives, for example, require a dedicated session to re-port the artifact-tier `outputs/portfolio-repo/artifacts/CLAUDE.md` before the next publish.
- **Init mode is Session 8 work.** Step 0's not-initialized branch defers to Session 8; init flow is documented above but has not been run end-to-end.
