#!/usr/bin/env bash
# AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it.
#
# Designed by Craig—runtime: Claude (Sonnet/Opus).
#
# What this is. A Claude Code PostToolUse hook (matcher: Write|Edit) that
# verifies file writes to mounted ~/.claude-local/ paths actually landed (file
# exists and is non-empty). Encodes the "File Write Verification" primitive
# from CLAUDE.md as machinery rather than discipline. Surfaces a warning to
# Claude via additionalContext on failure; does not block the tool.
#
# What was redacted. Nothing—the registry sweep produced zero substitutions.
# This is operational shell code; no PII, target companies, third-party
# individuals, or prior-employer narrative are present.
#
# Why it's included. Highest-frequency-firing hook in the layer—every Write
# or Edit operation triggers it. Most concretely demonstrates the "discipline
# encoded as machinery" thesis from CS#4: where prose-only rules drift,
# machinery doesn't. Direct evidence that the "verify-before-claim-complete"
# CLAUDE.md primitive ships as code, not as a recommendation.
#
# ---

# post-tool-use-verify-write.sh
#
# Claude Code PostToolUse hook (matcher: "Write|Edit"). Verifies that file
# writes to mounted ~/.claude-local/ paths actually landed (file exists and
# is non-empty). On failure, surfaces a warning to Claude via additionalContext
# — does NOT block the tool. The point is to encode the "File Write
# Verification" CLAUDE.md primitive in machinery rather than discipline,
# addressing the Eval-14 failure pattern where "I edited file X" is claimed
# without read-back.
#
# Hook input (stdin, JSON):
#   {
#     "hook_event_name": "PostToolUse",
#     "tool_name": "Write" | "Edit",
#     "tool_input": { "file_path": "/Users/.../foo.md", ... },
#     "tool_response": { ... }
#   }
#
# Hook output (stdout, JSON when there's something to say):
#   {
#     "hookSpecificOutput": {
#       "hookEventName": "PostToolUse",
#       "additionalContext": "..."
#     }
#   }
#
# Exit codes:
#   0 — always (this hook is non-blocking by design)
#
# Scope: only files under ~/.claude-local/. Other writes are a no-op.

set -euo pipefail

# Read all of stdin into a buffer.
INPUT=$(cat)

# Resolve the file path + session id. Use jq if available; otherwise a tolerant grep.
# session_id is at the top level of hook input per Claude Code docs.
if command -v jq >/dev/null 2>&1; then
  TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
  SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // ""')
else
  TOOL_NAME=$(echo "$INPUT" | grep -oE '"tool_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/')
  FILE_PATH=$(echo "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/')
  SESSION_ID=$(echo "$INPUT" | grep -oE '"session_id"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/')
fi
# Default session id when input is missing it (defensive — should not happen in
# Claude Code, but keeps the hook resilient against schema drift).
SESSION_ID="${SESSION_ID:-unknown-session}"

# No file path → not a Write/Edit event with an extractable target. Nothing to verify.
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Resolve sandbox-visible ROOT (where this script can read files) via the same
# fallback chain as scripts/regenerate-index.sh. In Claude Code on Craig's Mac,
# ROOT == /Users/craigslater/.claude-local. In the Cowork bash sandbox,
# ROOT == /sessions/<name>/mnt/.claude-local. CLAUDE_LOCAL_ROOT is an explicit
# override for unusual installations.
if [ -d "${HOME}/.claude-local" ]; then
  ROOT="${HOME}/.claude-local"
elif [ -d "${HOME}/mnt/.claude-local" ]; then
  ROOT="${HOME}/mnt/.claude-local"
elif [ -d "${CLAUDE_LOCAL_ROOT:-}" ]; then
  ROOT="${CLAUDE_LOCAL_ROOT}"
else
  exit 0  # can't resolve workspace; non-blocking by design
fi

# Translate FILE_PATH to a sandbox-visible path. Two forms supported:
#   - Host form (what the model emits in tool_input.file_path on both Cowork
#     and Claude Code): "${HOST_CLAUDE_LOCAL}/...". On Craig's Mac that's
#     /Users/craigslater/.claude-local/.... In Cowork the sandbox can't see
#     this path directly — needs translation to ROOT-relative.
#   - Already-sandbox form: "${ROOT}/..." (no translation needed).
# HOST_CLAUDE_LOCAL is overridable via env var for non-Craig installations.
HOST_CLAUDE_LOCAL="${HOST_CLAUDE_LOCAL:-/Users/craigslater/.claude-local}"

case "$FILE_PATH" in
  "$HOST_CLAUDE_LOCAL/"*)
    REL_PATH="${FILE_PATH#${HOST_CLAUDE_LOCAL}/}"
    CHECK_PATH="${ROOT}/${REL_PATH}"
    ;;
  "${ROOT}/"*)
    CHECK_PATH="$FILE_PATH"
    ;;
  *)
    exit 0  # write target is outside ~/.claude-local/; out of scope
    ;;
esac

# Verification: the file must exist AND be non-empty.
WARNING=""
if [ ! -e "$CHECK_PATH" ]; then
  WARNING="File Write Verification (PostToolUse): expected $FILE_PATH to exist after $TOOL_NAME but it does not. The write may have failed silently. Re-run the operation or investigate path correctness before claiming the change persisted."
elif [ ! -s "$CHECK_PATH" ]; then
  WARNING="File Write Verification (PostToolUse): $FILE_PATH exists but is empty after $TOOL_NAME. Verify the intended content was written before claiming the change persisted."
fi

# Commitment log (Bundle A automation, v2 Session 2): append a JSONL record per
# Write/Edit so /end-session can enumerate from ground truth rather than memory.
# Append-only, flock-protected, scoped to the current session id. Persistent
# under ~/.claude-local/outputs/commitment-logs/ so the file survives the
# Cowork sandbox lifecycle (tmp would disappear before /end-session reads it).
# 30-day prune lives in the SessionStart hook (session-start-prune-commitment-logs.sh).
LOG_DIR="${ROOT}/outputs/commitment-logs"
LOG_FILE="${LOG_DIR}/${SESSION_ID}.jsonl"
mkdir -p "$LOG_DIR" 2>/dev/null || true

# Resolve verification booleans for the log line.
if [ -z "$WARNING" ]; then
  VERIFIED_JSON="true"
  VERIFICATION_MSG=""
else
  VERIFIED_JSON="false"
  VERIFICATION_MSG="$WARNING"
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

if command -v jq >/dev/null 2>&1; then
  LOG_LINE=$(jq -nc \
    --arg ts "$TIMESTAMP" \
    --arg sid "$SESSION_ID" \
    --arg tool "$TOOL_NAME" \
    --arg fp "$FILE_PATH" \
    --argjson v "$VERIFIED_JSON" \
    --arg msg "$VERIFICATION_MSG" \
    '{timestamp: $ts, session_id: $sid, tool_name: $tool, file_path: $fp, verified: $v, verification_message: $msg}')
else
  ESCAPED_FP=$(printf '%s' "$FILE_PATH" | sed 's/\\/\\\\/g; s/"/\\"/g')
  ESCAPED_MSG=$(printf '%s' "$VERIFICATION_MSG" | sed 's/\\/\\\\/g; s/"/\\"/g' | tr '\n' ' ')
  LOG_LINE=$(printf '{"timestamp":"%s","session_id":"%s","tool_name":"%s","file_path":"%s","verified":%s,"verification_message":"%s"}' \
    "$TIMESTAMP" "$SESSION_ID" "$TOOL_NAME" "$ESCAPED_FP" "$VERIFIED_JSON" "$ESCAPED_MSG")
fi

# Atomic append with flock when available (prevents interleaving under parallel
# Write/Edit calls). Fall back to >> which is single-line atomic on POSIX
# (PIPE_BUF=4096; our lines are well under that).
if command -v flock >/dev/null 2>&1; then
  ( flock -x 200; printf '%s\n' "$LOG_LINE" >&200 ) 200>>"$LOG_FILE"
else
  printf '%s\n' "$LOG_LINE" >> "$LOG_FILE"
fi

if [ -n "$WARNING" ]; then
  # Emit additionalContext via the documented hookSpecificOutput schema.
  # Use jq to escape the warning string safely.
  if command -v jq >/dev/null 2>&1; then
    jq -n --arg ctx "$WARNING" '{
      hookSpecificOutput: {
        hookEventName: "PostToolUse",
        additionalContext: $ctx
      }
    }'
  else
    # Fallback: minimal escaping (replace " with \" and newlines with \n).
    ESCAPED=$(echo "$WARNING" | sed 's/"/\\"/g' | tr '\n' ' ')
    printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$ESCAPED"
  fi
fi

exit 0
