<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The session-end workflow protocol—what `/end-session` runs when a project session closes. Defines the CONTEXT.md update, the session-log append, the corrections-encoding step, and the Commitment-Verification Audit.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions.
> **Why it's included.** Pairs with `session-start.md` as the close-out half of the session lifecycle. The audit step is the discipline mechanism that keeps the system from drifting between sessions.

---

# Session End Protocol

Before closing any session where substantive work was done on a project:

1. Update the relevant `projects/[name]/CONTEXT.md` with: current status, what was completed, any open questions, and next steps
1.5. **Read the JSONL commitment log** at `~/.claude-local/outputs/commitment-logs/{session-id}.jsonl` (populated by `hooks/post-tool-use-verify-write.sh`). This is ground truth for the Commitment-Verification Audit (Step 6 below) — file-write commitments enumerate from the log first; the conversation walk picks up only what the log missed (declarative-only commitments, cross-file propagation promises, deliverable-presence checks beyond raw writes)
2. Append a dated entry to the Session Log section of that CONTEXT.md
3. If any corrections were made that should persist, encode them into the appropriate source file (skill reference, MEMORY.md, or CLAUDE.md) — do not leave corrections only in conversation context
4. If a new project-level file was created, confirm it's in the right project folder (not root)
5. **Surface trigger-fired ROADMAP entries.** Walk all `skills/*/ROADMAP.md` files looking for entries where `**Trigger fired:**` field was set or updated this session. For each match, surface the codification path: invoke `/codify-trigger` to ship + lifecycle-move atomically, OR document an explicit deferral with a re-evaluation trigger. Do NOT close the session if a trigger-fired entry has neither been codified nor deferred — that's the lag-to-fix problem `/codify-trigger` exists to prevent.
6. **Run the Commitment-Verification Audit (see `policies/commitment-verification-audit.md`) before claiming session is complete.**
