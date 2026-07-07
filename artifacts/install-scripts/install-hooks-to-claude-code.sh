#!/usr/bin/env bash
# AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it.
#
# Designed by Craig—runtime: Claude (Sonnet/Opus).
#
# What this is. The Claude Code install script for the ~/.claude-local hook
# layer. Wires all ten hooks—across five event types (PreToolUse, PostToolUse,
# SessionStart, Stop, SessionEnd), seven that observe and three that enforce—
# from ~/.claude-local/hooks/ into ~/.claude/settings.json so they fire on every
# Claude Code session against this workspace. Idempotent: re-running on an
# already-wired settings.json is a no-op.
#
# What was redacted. Nothing—the registry sweep produced zero substitutions.
# The script uses $HOME for path resolution; no hardcoded user paths.
#
# Why it's included. One half of the dual-environment portability story (the
# other half is package-hooks-plugin.sh in this same folder, for Cowork). Direct
# evidence for the CS#4 claim that the same primitives ship to both runtimes
# via different installation mechanisms.
#
# ---

# install-hooks-to-claude-code.sh
#
# Installs the ~/.claude-local/hooks/*.sh scripts into Claude Code's
# settings.json so they fire on the appropriate events. Idempotent: re-running
# on an already-wired settings.json is a no-op (entries are added only when
# missing; existing matching entries are preserved).
#
# What gets installed:
#   - PreToolUse  (matcher "Write|Edit") → pre-tool-use-guard-paths.sh
#   - PreToolUse  (matcher "Write|Edit") → pre-tool-use-unit-scope.sh
#   - PostToolUse (matcher "Write|Edit") → post-tool-use-verify-write.sh
#   - Stop                                → stop-verify-before-complete.sh
#   - SessionStart                        → session-start-prune-commitment-logs.sh
#   - SessionStart                        → session-start-drift-guard.sh
#   - SessionEnd                          → session-end-context-reminder.sh
#   - SessionEnd                          → session-end-cross-file-consistency.sh
#   - SessionEnd                          → session-end-improvement-opportunities.sh
#   - SessionEnd                          → session-end-portfolio-sync.sh
#
# Where: ~/.claude/settings.json (Claude Code's user-level settings).
#
# Why this script exists: parallel to scripts/regenerate-index.sh and
# skills/start-session/scripts/sync-skills-to-claude-code.sh — bootstrap-once
# pattern. Run it from a host terminal after pulling fresh hooks/.
#
# Usage:
#   bash ~/.claude-local/hooks/install-hooks-to-claude-code.sh
#   bash ~/.claude-local/hooks/install-hooks-to-claude-code.sh --dry-run
#   bash ~/.claude-local/hooks/install-hooks-to-claude-code.sh --uninstall
#
# Requires: jq (for safe JSON manipulation).
#
# Exit codes:
#   0 — install/uninstall complete
#   1 — jq not found
#   2 — usage error or unexpected filesystem state

set -euo pipefail

SETTINGS_DIR="${HOME}/.claude"
SETTINGS="${SETTINGS_DIR}/settings.json"
HOOKS_DIR="${HOME}/.claude-local/hooks"

DRY_RUN=0
UNINSTALL=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --uninstall) UNINSTALL=1 ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      echo "Unknown arg: $arg" >&2
      exit 2
      ;;
  esac
done

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required but not found. Install with: brew install jq" >&2
  exit 1
fi

mkdir -p "$SETTINGS_DIR"

# Initialize settings.json if it doesn't exist or is empty.
if [ ! -s "$SETTINGS" ]; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] would initialize $SETTINGS with empty {}"
  else
    echo "{}" > "$SETTINGS"
    echo "Initialized $SETTINGS"
  fi
fi

# All managed hook entries. Each is identified by (event, command) — the
# command path is what we look for to detect already-installed entries.
# Encoded with TAB as record separator. Empty matcher is encoded as the
# literal "_NONE_" because bash's IFS collapses consecutive whitespace
# (including tab) and would lose an empty field.
# Format per line: "<event>\t<matcher-or-_NONE_>\t<command>".
read -r -d '' ENTRIES_RAW <<EOF || true
PreToolUse	Write|Edit	${HOOKS_DIR}/pre-tool-use-guard-paths.sh
PreToolUse	Write|Edit	${HOOKS_DIR}/pre-tool-use-unit-scope.sh
PostToolUse	Write|Edit	${HOOKS_DIR}/post-tool-use-verify-write.sh
Stop	_NONE_	${HOOKS_DIR}/stop-verify-before-complete.sh
SessionStart	_NONE_	${HOOKS_DIR}/session-start-prune-commitment-logs.sh
SessionStart	_NONE_	${HOOKS_DIR}/session-start-drift-guard.sh
SessionEnd	_NONE_	${HOOKS_DIR}/session-end-context-reminder.sh
SessionEnd	_NONE_	${HOOKS_DIR}/session-end-cross-file-consistency.sh
SessionEnd	_NONE_	${HOOKS_DIR}/session-end-improvement-opportunities.sh
SessionEnd	_NONE_	${HOOKS_DIR}/session-end-portfolio-sync.sh
EOF

# Returns the jq filter for adding (or removing) one entry idempotently.
# We model settings.json hooks shape per Claude Code docs:
#   { "hooks": { "<EventName>": [ { "matcher": "...", "hooks": [ {"type":"command","command":"..."} ] } ] } }
add_entry_filter() {
  local event="$1"
  local matcher="$2"
  local command="$3"

  if [ -n "$matcher" ]; then
    # Event with matcher: find or create the matcher group, then add hook if missing.
    cat <<EOF
.hooks //= {} |
.hooks["$event"] //= [] |
( .hooks["$event"] | map(select(.matcher == "$matcher")) | length ) as \$has_matcher |
if \$has_matcher == 0 then
  .hooks["$event"] += [{"matcher": "$matcher", "hooks": [{"type": "command", "command": "$command"}]}]
else
  .hooks["$event"] = (
    .hooks["$event"] | map(
      if .matcher == "$matcher" then
        if (.hooks // []) | map(.command) | index("$command") then .
        else .hooks = (.hooks // []) + [{"type": "command", "command": "$command"}]
        end
      else . end
    )
  )
end
EOF
  else
    # Event without matcher: hooks live in a "matcher-less" entry. Convention:
    # an entry where matcher is absent or empty string. We use empty string for stability.
    cat <<EOF
.hooks //= {} |
.hooks["$event"] //= [] |
( .hooks["$event"] | map(select((.matcher // "") == "")) | length ) as \$has_default |
if \$has_default == 0 then
  .hooks["$event"] += [{"matcher": "", "hooks": [{"type": "command", "command": "$command"}]}]
else
  .hooks["$event"] = (
    .hooks["$event"] | map(
      if (.matcher // "") == "" then
        if (.hooks // []) | map(.command) | index("$command") then .
        else .hooks = (.hooks // []) + [{"type": "command", "command": "$command"}]
        end
      else . end
    )
  )
end
EOF
  fi
}

remove_entry_filter() {
  local event="$1"
  local command="$2"
  cat <<EOF
.hooks //= {} |
if .hooks["$event"] then
  .hooks["$event"] = (
    .hooks["$event"] | map(
      .hooks = ((.hooks // []) | map(select(.command != "$command")))
    ) | map(select((.hooks // []) | length > 0))
  ) |
  if (.hooks["$event"] | length) == 0 then del(.hooks["$event"]) else . end
else . end
EOF
}

# Apply filters in sequence.
while IFS=$'\t' read -r event matcher command; do
  [ -n "$event" ] || continue
  [ "$matcher" = "_NONE_" ] && matcher=""

  if [ "$UNINSTALL" -eq 1 ]; then
    filter=$(remove_entry_filter "$event" "$command")
    op="uninstall"
  else
    filter=$(add_entry_filter "$event" "$matcher" "$command")
    op="install"
  fi

  if [ "$DRY_RUN" -eq 1 ]; then
    echo "[dry-run] $op: event=$event matcher='$matcher' command=$command"
    continue
  fi

  TMP=$(mktemp)
  jq "$filter" "$SETTINGS" > "$TMP"
  mv "$TMP" "$SETTINGS"
done <<< "$ENTRIES_RAW"

if [ "$DRY_RUN" -eq 0 ]; then
  if [ "$UNINSTALL" -eq 1 ]; then
    echo "Uninstalled ~/.claude-local hooks from $SETTINGS"
  else
    echo "Installed ~/.claude-local hooks into $SETTINGS"
    echo ""
    echo "Verify with: jq '.hooks' $SETTINGS"
  fi
fi

exit 0
