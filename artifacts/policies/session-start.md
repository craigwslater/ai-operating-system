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
4. If it maps to a known project, read `projects/[name]/CONTEXT.md` to pick up where we left off
5. If it's a new multi-session effort, run the New Project Intake protocol (`policies/new-project-intake.md`) before starting work
