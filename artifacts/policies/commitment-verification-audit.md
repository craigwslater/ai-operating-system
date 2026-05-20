<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The Commitment-Verification Audit protocol—the verification framework that runs at session-end to confirm every commitment made during the session was actually executed. Compares stated work against shipped work; flags partial or unfulfilled commitments before close.
> **What was redacted.** One active-target-company name (a healthcare data company referenced in a worked-example narrative) substituted to `[REDACTED COMPANY]` per registry entries tgt-017 and tgt-062 (the latter is the bare-form short variant of the same company, both audit-matching the single occurrence). The surrounding failure-mode story remains readable; only the named entity is masked.
> **Why it's included.** Direct evidence for the "verify-before-claim-complete" primitive in `artifacts/CLAUDE.md`: how "looks good is not verification" translates into machinery.

---

# Commitment-Verification Audit

**MANDATORY before declaring session complete.**

This audit prevents the failure mode where Claude tells Craig "X is done" without X actually being persisted. Past sessions have shipped on Claude's claimed-completion that turned out to be incomplete; this rule eliminates that.

**Trigger:** Any time Claude is about to say "session is done," "everything is shipped," "files are saved," "[task] is committed/persisted/written," or any equivalent claim of completion.

**Required steps before making any such claim:**

1. **Enumerate every commitment made during the session.** Start by reading `~/.claude-local/outputs/commitment-logs/{session-id}.jsonl` — populated by `hooks/post-tool-use-verify-write.sh`, this is the ground-truth log of every Write/Edit fired during the session (file_path + tool + timestamp + session-id per line). Enumerate file-write commitments from the log first. Then walk back through the conversation to add commitments NOT captured by the log: declarative-only commitments ("I'll surface this to Craig"), cross-file propagation promises that may not have landed yet, deliverable-presence checks beyond the raw write, and process-rule additions implied by completed task entries. Include both commitments made in chat and commitments implied by completed task entries.

2. **For each commitment, perform a read-back verification:**
   - **File edits / new files:** Read the file (or grep for the specific change) and confirm the change is present.
   - **Cross-project propagation:** Check that updates that should be in multiple files (e.g., v4-candidate entries that go in both job-search/CONTEXT.md AND projects/job-materials-v4/CLAUDE.md) are in all required locations.
   - **Deliverables:** Verify file presence in BOTH archive and Desktop with matching byte sizes / md5 hashes.
   - **Skill-canonical updates:** Verify the change is in the source file (not just in the delivered .docx) — see Skill Update Persistence section.

3. **For any commitment that fails verification:** fix it BEFORE making the completion claim. Do not say "done" if any commitment is unverified.

4. **Report the audit explicitly to Craig** before declaring completion. Even a one-line "Audit: 7 commitments, all verified" is enough — the discipline is the audit, not the report length. If any commitment was missed and required fixing, name it.

**Pattern to avoid:** "Done — eval-X written, SKILL.md updated, CONTEXT.md updated" without having verified each. This is the exact failure mode that produced the issue Craig flagged in Session 25 ([REDACTED COMPANY]) — Claude said v4 candidates were captured but they were only in CONTEXT.md, not in the canonical v4 project file where the eval-13 convention had established they belong.

**Why this discipline is mandatory:** Every claim of completion that turns out to be partial requires Craig to manually re-derive what was missed. The cost compounds across sessions because the missed work creates cross-session canonical drift (Eval 14 Category A class). The audit is cheap (3-5 minutes) and the failure mode it prevents is expensive (full review-cycle re-runs).
