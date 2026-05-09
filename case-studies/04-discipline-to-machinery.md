# From Discipline to Machinery

> **Designed by Craig.** The CLAUDE.md primitives the hooks encode (File Write Verification, Multi-Session Project Discipline, atomic cross-file maintenance, file-size budgets), the dual-install pattern that makes the same hook scripts run on Claude Code and Cowork, the commitment-log JSONL ground-truth design that lets `/end-session` audit from facts rather than recollection.
> **Runtime: Claude.** Triggering the hooks at PostToolUse, SessionStart, and SessionEnd events. Reading hook output as additionalContext during the session. Reading the commitment log at `/end-session` to enumerate every file write the session made.
> **Source artifacts.** [`artifacts/sample-hook.sh`](../artifacts/sample-hook.sh) · [`artifacts/install-scripts/`](../artifacts/install-scripts/) · [`artifacts/CLAUDE.md`](../artifacts/CLAUDE.md)

## Origin moment

The File Write Verification primitive lived in `CLAUDE.md` as prose for weeks before becoming a hook. The rule was clear: "Every file write to a mounted directory path is read-back-verified before moving on." The failure mode was equally clear: composer drafts ending with "I edited file X to fix Y" without actually re-reading X. When the rule was remembered, the rule worked. When the runtime missed the rule, drift slipped through silently.

The fix was not a stronger sentence in `CLAUDE.md`. The fix was [`post-tool-use-verify-write.sh`](../artifacts/sample-hook.sh)—a Claude Code PostToolUse hook scoped to Write and Edit, that fires unconditionally after every write to a mounted `~/.claude-local/` path, checks that the file exists and is non-empty, and surfaces a warning back to the runtime via `additionalContext` when verification fails. Discipline as prose was brittle. Machinery is durable. Every behavioral primitive in `CLAUDE.md` is a candidate for the same move.

## What this is

The hooks layer turns behavioral primitives into runtime checks at the file-system level. Six hook scripts live under `~/.claude-local/hooks/` and encode primitives from `CLAUDE.md` and from skill-level non-negotiables. They fire on three event types: `PostToolUse` (after every Write/Edit tool call), `SessionStart` (when a Claude session begins), and `SessionEnd` (when a session closes). They are non-blocking by design—they surface warnings through the documented `hookSpecificOutput.additionalContext` channel, never veto a tool call.

The economics matter. Machine-checkable rules cost nothing per invocation; the script runs in milliseconds and fires only on event. The absence of machine-checkable rules costs the session every time the runtime has to re-read the rule, recognize the shape, and remember to apply it. Across thousands of file writes in a multi-month project, the discipline-as-prose tax is high. The hook layer is the amortization.

The hooks share a portability detail that the [meta-architecture](./01-personal-ai-os.md) makes possible. Each script resolves the workspace root via a fallback chain—`${HOME}/.claude-local` first, `${HOME}/mnt/.claude-local` second (the Cowork bash-sandbox path), `${CLAUDE_LOCAL_ROOT}` as an environment-variable override third. The same hook source runs unchanged on Claude Code and on Cowork; only the install path differs.

## The six hooks

Each hook below maps to one or more `CLAUDE.md` primitives. The primitives are quoted directly from the global rules file; the hook is named relative to `~/.claude-local/hooks/`.

**`post-tool-use-verify-write.sh`** (PostToolUse, matcher `Write|Edit`). Encodes the *File Write Verification* primitive: "Every file write to a mounted directory path is read-back-verified." After every Edit or Write, the hook resolves the file path through the dual-environment fallback, checks file existence and non-emptiness, and emits a warning when verification fails. The same script appends a JSONL record—timestamp, session id, tool name, file path, verified boolean, verification message—to a per-session log at `~/.claude-local/outputs/commitment-logs/${SESSION_ID}.jsonl`. The log is the ground truth that `/end-session` audits against, addressed in detail below. The hook is non-blocking even on failure; the rationale is that surfacing a warning is enough to interrupt the runtime's "I edited X" pattern, and blocking on a transient filesystem hiccup would do more harm than the warning prevents.

**`session-end-context-reminder.sh`** (SessionEnd). Encodes *Multi-Session Project Discipline* and *Verify-before-claim-complete*. The hook scans `projects/*/CONTEXT.md` files for any modified during the current calendar day. If today's session-log line is not yet present in the CONTEXT.md Recent sessions table—the marker that `/end-session` has run—the hook reminds the runtime to run `/end-session` before exit. The reminder is suppressed when the session-log line is already there; suppression matters because the alternative is a noisy hook that fires every session-end whether the protocol completed or not.

**`session-end-cross-file-consistency.sh`** (SessionEnd). Encodes the atomic cross-file maintenance non-negotiable: when a session updates a project's CONTEXT.md, the same session must propagate the change to MEMORY.md Active Projects and regenerate INDEX.md. Three drift detectors: (1) CONTEXT.md modified today but project's MEMORY.md mtime is older—propagation may have been skipped; (2) CONTEXT.md modified today but INDEX.md "Last regenerated" line is not today—index regen was skipped; (3) INDEX.md older than the most-recently-modified CONTEXT.md—index is stale. Each drift is surfaced as a separate warning. The hook is the runtime answer to "I updated CONTEXT.md but forgot the propagation step."

**`session-end-improvement-opportunities.sh`** (SessionEnd). Encodes the structural-drift detection that the on-demand `/audit` slash command runs heavyweight. This hook is the cheap continuous version: file-size budgets (CLAUDE.md ≤180 lines, MEMORY.md ≤80 lines, project CONTEXT.md ≤80 lines), cumulative-narrative anti-pattern detection (long lines suggesting a status field that grew rather than rolling over), recurring corrections (the same correction noted three or more times in a corrections-log—a candidate for promotion to a global rule), and cruft accumulation (`.DS_Store`, `.tmp`, lock files left behind). The hook also writes a dated report to `~/.claude-local/outputs/session-end-reports/YYYY-MM-DD-HHMM.md` per a Session 4 design decision, so a reader at next `/start-session` has both the additionalContext stream and a persistent record to consult.

**`session-start-prune-commitment-logs.sh`** (SessionStart). Closes the loop on the commitment-log lifecycle. Every PostToolUse hook invocation appends to a JSONL log under `outputs/commitment-logs/`; without periodic cleanup the directory grows unbounded. The SessionStart hook prunes log files older than 30 days. The cap is informed by `/end-session`'s usage pattern—commitment audits read the current session's log immediately at session close; logs older than a month are not consulted again.

**`session-end-portfolio-sync.sh`** (SessionEnd). Encodes the portfolio-sync signal-detection primitive locked in the project's Session 0 plan. Five orthogonal signal detectors fire across the source folder since the last `/publish-portfolio` push: a ROADMAP item resolved with portfolio relevance (net increase in `✅ RESOLVED` markers across `skills/*/ROADMAP.md`), a new eval shipped (new file under `skills/*/evals/eval-*.md`), a new `CLAUDE.md` primitive added (content-hash drift on the global rules file), a project closed (new "Closed YYYY-MM-DD" marker in MEMORY.md Active Projects), or a version release of an existing project (new top-level version header in `projects/*/CHANGELOG.md`). State lives at `projects/ai-operating-system/.portfolio-sync-state` as JSON; fired signals append to `outputs/portfolio-sync-pending.md` as `## Detected YYYY-MM-DD` stanzas. The hook never writes the state file. Only `/publish-portfolio` updates it on a successful push—the semantic that preserves "since last sync" across runs. Multi-session noise is a known v1 limitation: signals re-fire each session-end between publishes; `/publish-portfolio` dedupes on push by reading the union. Dedup-at-detection-time is a v2 candidate.

## Dual-environment portability

The same hooks ship on two surfaces. The install paths differ; the hook source does not.

**Claude Code install.** [`install-hooks-to-claude-code.sh`](../artifacts/install-scripts/install-hooks-to-claude-code.sh) writes the six hook entries into `~/.claude/settings.json`. The script is idempotent: re-running on an already-wired settings file is a no-op. A `--dry-run` flag prints the JSON diff without writing; `--uninstall` removes the entries. The script requires `jq` for safe JSON manipulation and exits with code 1 if `jq` is missing—the explicit-fail is preferable to a partial install that silently corrupts settings.json.

**Cowork install.** Cowork's plugin system replaces direct settings-file manipulation. `package-hooks-plugin.sh` builds a `frontier-hooks` plugin under `outputs/plugins-packaged/frontier-hooks.zip`, which the user uploads through Cowork Organization Settings → Plugins. Same hook source, packaged once at build time, distributed once per organization. The Cowork side has no `~/.claude/settings.json` for a script to write to; the plugin manifest is the install primitive.

The dual-install pattern matters because it preserves the *Source of truth is `~/.claude-local/`* non-negotiable in `CLAUDE.md`. The hook scripts live in source. The install paths derive from source. A correction to a hook flows from source to both environments by re-running install (Claude Code) or re-uploading the plugin (Cowork). There is no environment where a hook can be edited in place and back-propagate to source. The directionality keeps the system auditable.

## The commitment-log JSONL ground truth

`/end-session`'s Commitment-Verification Audit asks: "for every commitment this session made—every file write, every edit, every promotion—did the work actually land?" Self-reported answers are the failure mode. The model attempts to enumerate from conversation memory; conversation memory is incomplete (truncation, parallel tool calls, session-spanning work); enumeration drifts; the audit reports clean while real drift slips through.

The commitment log is the answer. Every PostToolUse Write/Edit appends a single JSONL line: `{"timestamp": ..., "session_id": ..., "tool_name": ..., "file_path": ..., "verified": ..., "verification_message": ...}`. The append is atomic—`flock` when available, otherwise a single `printf` whose output stays under the POSIX `PIPE_BUF` atomic-write threshold of 4,096 bytes. The session id is at the top level of the hook input JSON and is consistent across all hook invocations in a single session.

`/end-session` reads the JSONL log for the current session, parses every line, and audits each commitment against the actual filesystem state. A line with `"verified": false` flags immediately. A line with `"verified": true` whose file is now missing or empty—because a later operation overwrote it incorrectly—flags too. The audit reports facts captured at write time, cross-checked against state at session-end time. The Commitment-Verification Audit went from self-report to cross-check the day this hook landed.

The lifecycle has three pieces: PostToolUse hook writes the line; the SessionStart hook prunes logs older than 30 days; `/end-session` reads the current session's log. Each piece runs in its own event window. None of them depends on the runtime remembering to do anything.

## Failure modes that drove the design

Each hook replaced a discipline-as-prose primitive that had failed in production.

**"I edited file X to fix Y" without read-back.** The File Write Verification primitive in `CLAUDE.md` was correctly worded; the failure was that the runtime had to remember to apply it on every write. The pattern recurred across enough sessions that the prose-only form became a known anti-pattern (number 2 in `CLAUDE.md`'s Anti-Patterns list: "Optimistic acceptance of own work—'looks good' is not verification"). The hook removed the runtime-remembers requirement.

**Session ended without `/end-session` running.** Multi-Session Project Discipline assumed the runtime would invoke `/end-session` at the close of substantive work. When the session ended via `/exit` or by Cowork session timeout, the protocol skipped. CONTEXT.md sat ahead of MEMORY.md; INDEX.md staled. The next session's `/start-session` read inconsistent state and either propagated the inconsistency forward or paid the cost of detecting and repairing it. The SessionEnd reminder hook surfaces the gap before the session closes; the cross-file-consistency hook detects the gap if the reminder failed.

**Self-reported Commitment-Verification Audit.** The audit was designed to verify every commitment the session made. The implementation asked the model to enumerate its own commitments. Memory-as-source-of-truth is the failure pattern that the encode-into-source primitive in [Case Study #1](./01-personal-ai-os.md) addresses at the meta-architecture level; the same pattern showed up here at the runtime level. The JSONL log moves enumeration from memory to log.

**Recurring corrections-log entries that should have been promoted to global rules.** A correction noted three or more times in a per-skill corrections-log is a structural signal: the rule belongs in `CLAUDE.md` or in a higher-level policy file, not in the per-skill reference. The improvement-opportunities hook surfaces these candidates at session-end. The on-demand counterpart is `/audit`, which runs the heavyweight version on demand. The hook is the cheap continuous version that catches candidates before they accumulate.

The general pattern: every primitive that depends on "the runtime remembering to apply the rule" is a discipline-as-prose primitive, and discipline-as-prose is brittle. The hook layer is the answer at the system level. The rule-promotion lifecycle in [Case Study #3](./03-eval-driven-loops.md) is the answer at the skill level. Both run the same playbook—name the failure mode, identify the rule, escalate from prose to machinery.

## What's next

The synthesis line, captured in [`retrospection.md`](../retrospection.md): *AI workflows producing real deliverables need machinery, separation, and modular structure from day one, not as retrofits.* This case study walks the machinery third. [Case Study #2](./02-composer-verifier.md) walked the separation half. [Case Study #3](./03-eval-driven-loops.md) walked the modular-structure third. The three case studies are three faces of the same insight applied at three layers of the system.

The redacted operational artifacts in [`artifacts/sample-hook.sh`](../artifacts/sample-hook.sh) and [`artifacts/install-scripts/`](../artifacts/install-scripts/) are where any claim above can be verified against actual source files—with PII, target-company names, third-party individuals, and prior-employer narrative redacted, but the hook scripts and the dual-install machinery intact.

The [metrics dashboard](../metrics.md) tracks the four headline metrics over time. Two of them—rules added per month across `CLAUDE.md` and skills, plus detector count plus regression-test pass rate—are direct outputs of the prose-to-machinery move. Every primitive promoted from prose to hook lands in the rule-count delta. Baseline date 2026-05-08.

For a peer PM who wants to reuse these patterns, [`for-pms-reusing.md`](../for-pms-reusing.md) names the smallest-viable-version of each: one hook (file-write verification) is enough to demonstrate the prose-to-machinery move at a starter scale; the dual-install pattern can wait until a second environment is in play; the commitment-log JSONL ground truth is worth the implementation cost only when the audit volume justifies it.

If [Case Study #1](./01-personal-ai-os.md) makes the meta-system legible and [Case Study #3](./03-eval-driven-loops.md) makes the skill-level rule machinery legible, this case study makes the runtime layer legible: every behavioral primitive promoted from prose to hook, the same source running on Claude Code and Cowork, the audit moving from self-report to ground truth. Production-grade AI work is what discipline looks like once the discipline has been written down as code.

---

**Sources:** `~/.claude-local/hooks/` (six hook scripts encoding CLAUDE.md primitives); `~/.claude-local/CLAUDE.md` (primitives the hooks enforce); `~/.claude-local/policies/` (the disciplines being machined).
**Last refreshed:** 2026-05-08
