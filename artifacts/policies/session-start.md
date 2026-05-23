<!-- AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it. -->

> **Designed by Craig—runtime: Claude (Sonnet/Opus).**
> **What this is.** The session-start workflow protocol—what `/start-session` runs every time a fresh Claude session opens against `~/.claude-local/`. Defines the read-loaded global rules, the project-context resolution, and the scope-confirmation gate.
> **What was redacted.** Nothing—the registry sweep produced zero substitutions. This file references workflow steps and file paths only; no PII, target companies, third-party individuals, or prior-employer narrative are present.
> **Why it's included.** Reading this file shows how a Claude session boots into the rule set rather than starting fresh every conversation. It is the runtime entry point for the architecture documented in `artifacts/CLAUDE.md`.

---

# Session Start Protocol

Every session, after resolving `~/.claude-local` (see `docs/environment-specific-paths.md`):

1. Read `CLAUDE.md` — behavioral rules
2. Read `MEMORY.md` — persistent personal context, preferences, and identity
3. Ask Craig what we're working on
4. **Relevance step — load the connected cluster, not the whole store.** If Craig's answer maps to a known project, run `bash ~/.claude-local/scripts/query-index.sh --project <name>` and read the files it returns: the project's `CONTEXT.md` plus its typed-edge neighbors (the skills it uses, the policies governing them, the docs it points to) — the task-relevant cluster, traversed from the typed index `INDEX.md`, instead of all of memory. If the task names no project, run `bash ~/.claude-local/scripts/query-index.sh --keyword <term>` to surface the matching cluster. If the query prints an `UNDER-RETRIEVAL` or `FALLBACK` warning — or the script cannot run — the traversal is not trustworthy: fall back to reading `projects/[name]/CONTEXT.md` directly and scanning the MEMORY.md Active Projects registry. `INDEX.md` is loaded on demand by this step only — it is never part of the session-start eager-load (T0 + T1).
5. If it's a new multi-session effort, run the New Project Intake protocol (`policies/new-project-intake.md`) before starting work

The relevance layer (typed index + this step) ships with Phase 3 of `claude-local-memory-architecture`; schema and rationale: `policies/memory-architecture.md` §6 (M5) and the `INDEX.md` header.
