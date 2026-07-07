#!/usr/bin/env bash
# AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it.
#
# Designed by Craig—runtime: Claude (Sonnet/Opus).
#
# What this is. A Claude Code PreToolUse hook (matcher: Write|Edit)—the "Safety
# Layer" of the enforcement tier. It turns the enumerated forbidden-path rules
# in CLAUDE.md + policies/file-delivery.md into machinery: a write to a
# never-allowed location is denied (or escalated to Craig with an "ask") BEFORE
# it lands, instead of caught afterward by the observe hook in sample-hook.sh.
# It returns a PreToolUse permissionDecision the runtime host is documented to
# honor; it never emits "allow" (which would BYPASS the normal permission flow
# rather than defer to it); and it fails OPEN when it cannot reason about a
# write, because a defense-in-depth guard must never wedge a turn it can't parse.
#
# What was redacted. Nothing—the registry sweep produced zero substitutions.
# This is operational shell code; no PII, target companies, third-party
# individuals, or prior-employer narrative are present. The default workspace
# path is the same publicly-shown ~/.claude-local host path that already appears
# across the other artifacts in this folder.
#
# Why it's included. The clearest single example of the observe-to-enforce
# evolution walked in CS#4. Where the highest-frequency observe hook
# (post-tool-use-verify-write.sh, shown in sample-hook.sh) catches a bad write
# AFTER it lands, this one stops it BEFORE. Direct evidence that a
# CLAUDE.md / file-delivery primitive ships as an enforced gate, not a
# recommendation—the runtime layer's version of the prose-to-machinery thesis.
#
# ---

# pre-tool-use-guard-paths.sh
#
# Claude Code PreToolUse hook (matcher: "Write|Edit"). The Safety Layer of the
# ~/.claude-local hook architecture (claude-local-frontier-hooks Session 2). It
# turns the enumerated, mechanically-checkable forbidden-path rules in CLAUDE.md
# + policies/file-delivery.md from prompt-discipline into machinery: a write to a
# never-allowed location is stopped (or escalated to Craig) BEFORE it lands,
# instead of caught afterward by post-tool-use-verify-write.sh.
#
# Hook input (stdin, JSON):
#   {"hook_event_name":"PreToolUse","tool_name":"Write"|"Edit",
#    "tool_input":{"file_path":"/Users/.../foo.md", ...}, "session_id":"..."}
#
# Hook output (stdout, JSON — only when a rule matches):
#   block mode (Claude Code):
#     {"hookSpecificOutput":{"hookEventName":"PreToolUse",
#       "permissionDecision":"deny"|"ask","permissionDecisionReason":"..."}}
#   report-only mode (Cowork, until the NN#3 blocking-honor probe confirms):
#     {"hookSpecificOutput":{"hookEventName":"PreToolUse","additionalContext":"..."}}
#   No match → NOTHING is emitted (exit 0). Per the Claude Code docs (confirmed
#   2026-06-28), emitting nothing lets the normal permission flow proceed, whereas
#   emitting permissionDecision:"allow" would BYPASS it — which this guard must
#   never do. Silence = "no opinion, defer to normal permissions".
#
# Exit codes:
#   The JSON permissionDecision on stdout is the ONLY blocking signal; the exit-2
#   stderr blocking path is deliberately never used. Every normal path exits 0
#   (deny/ask emit JSON + exit 0; allow emits nothing + exit 0). A malformed /
#   parse-error stdin may abort non-zero under `set -euo pipefail` (a jq parse
#   failure) — but NEVER 2, so Claude Code treats it as a non-blocking error and
#   proceeds: the hook fails OPEN. A guard that cannot resolve the workspace
#   likewise fails open (resolve_root exits 0). Defense-in-depth must never wedge
#   a turn it can't reason about.
#
# ===========================================================================
# LOCKED DENY/ASK PATH POLICY — Session 2. No inferred rules (NN#1): every rule
# below is exactly what is written in CLAUDE.md + policies/file-delivery.md.
# `ask`/`defer`-preferred (NN#1): hard `deny` only where NO legitimate write
# exists; everything borderline escalates to Craig via `ask`.
#
#   DENY (unambiguous never-rule):
#     D1  Loose file at the ~/.claude-local/ ROOT (a direct child of root) whose
#         basename is not an allowlisted root file
#         {CLAUDE.md, MEMORY.md, MEMORY.local.md, INDEX.md, .gitignore}.
#         SRC: file-delivery "only CLAUDE.md, MEMORY.md, and system dirs belong
#              there"; CLAUDE.md Folder Structure "Project-specific files always
#              live in projects/[name]/ — never at root"; Structure Discipline #2
#              "No loose project files at root".
#     D2  Any path under the Cowork SYSTEM folder (contains "/mnt/.claude/", or is
#         exactly ".../mnt/.claude"). Deliberately does NOT match Claude Code's
#         own ~/.claude/ (no /mnt/) nor the legit workspace mount /mnt/.claude-local/.
#         SRC: file-delivery "Cowork's system folder (mnt/.claude/)"; CLAUDE.md
#              Personal Skills "the system folder (mnt/.claude/skills/) ... must
#              never be used".
#
#   ASK (borderline → escalate to Craig):
#     A1  A skill file (basename SKILL.md, or path containing a "/skills/" segment)
#         written to a temp/sandbox path, EXCEPT the session scratchpad.
#         SRC: CLAUDE.md Skill Update Persistence "Never write skill files to /tmp/
#              or any sandbox-only path". ASK not DENY: the canonical scratchpad is
#              already exempt below, and a skill file in some OTHER temp dir may be
#              a legitimate staging copy — the File Write Verification primitive
#              endorses keeping a staging copy before the authoritative write — so
#              escalate to Craig rather than hard-deny.
#     A2  Any write under ~/Desktop/.
#         SRC: file-delivery "Never save output files to Craig's Desktop (~/Desktop/)".
#     A3  A deliverable-extension file (.xlsx/.docx/.pdf/.pptx/.csv) written to a
#         temp/sandbox path (non-scratchpad).
#         SRC: file-delivery "Never save output files (Excel, PDF, Word doc, etc.)
#              to ... Temporary VM paths (/tmp/, /sessions/.../ outside a mounted
#              folder)".
#
#   ALLOW (silent — nothing emitted): everything else — the session scratchpad,
#   mktemp fixtures, normal writes under ~/.claude-local/{projects,skills,outputs,
#   policies,docs,...}/, Claude Code ~/.claude/ settings, allowlisted root files.
#
# "temp/sandbox path" = /tmp/*, /private/tmp/*, /var/tmp/*, or /sessions/* that is
# OUTSIDE a mount (no /mnt/ segment) — matching file-delivery's "/sessions/...
# outside a mounted folder". The session scratchpad (path contains "/scratchpad/")
# is always exempt: the harness mandates it for transient work.
# ===========================================================================
#
# Surface degrade (NN#3): Cowork demonstrably RUNS plugin hooks (the SessionStart
# drift guard fired live), but whether it HONORS blocking (deny/ask) is not yet
# empirically confirmed — that is Session 2's out-of-session probe. Until then,
# Cowork (ROOT == */mnt/.claude-local) defaults to MODE=report-only: the guard
# emits a non-blocking additionalContext warning instead of a permissionDecision,
# so it never silently no-ops (false confidence) and never blocks on a surface
# that might not honor the block. Claude Code defaults to MODE=block. Override
# with GUARD_PATHS_MODE=block|report-only (used by the probe + the harness).
#
# Scope: NN#5/NN#6 — this is the ONLY new blocking hook plus the Stop hook; the
# existing detector hooks stay non-blocking. This file adds no detector logic to
# them; it sources common.sh for resolve_root + emit_permission_decision only.

set -euo pipefail

# Read all of stdin into a buffer.
INPUT=$(cat)

# Resolve the file path. jq when available; tolerant grep fallback otherwise
# (mirrors post-tool-use-verify-write.sh). tool_name is not read: the Write|Edit
# matcher already constrains the event, and every rule keys on the path alone.
if command -v jq >/dev/null 2>&1; then
  FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
else
  FILE_PATH=$(echo "$INPUT" | grep -oE '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*"([^"]*)"$/\1/')
fi

# No file path → not a Write/Edit with a guardable target. Defer (silent).
if [ -z "$FILE_PATH" ]; then
  exit 0
fi

# Resolve sandbox-visible ROOT (and fail-open if unresolvable). Also gives us the
# Cowork-vs-Claude-Code signal for MODE below.
# shellcheck source=common.sh
. "$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)/common.sh"
resolve_root

# Host-form root prefix (what the model emits in tool_input.file_path on both
# surfaces). Overridable for non-Craig installs, same as verify-write.
HOST_CLAUDE_LOCAL="${HOST_CLAUDE_LOCAL:-/Users/craigslater/.claude-local}"

# Enforcement mode. Block on Claude Code; report-only on Cowork until the NN#3
# blocking-honor probe confirms. Explicit override wins.
MODE="${GUARD_PATHS_MODE:-}"
if [ -z "$MODE" ]; then
  case "$ROOT" in
    */mnt/.claude-local) MODE="report-only" ;;
    *)                   MODE="block" ;;
  esac
fi

# Allowlisted basenames that legitimately live at the ~/.claude-local/ root.
ROOT_ALLOWLIST="CLAUDE.md MEMORY.md MEMORY.local.md INDEX.md .gitignore"

# ---------------------------------------------------------------------------
# Path predicates. Each returns 0 (match) / 1 (no match); always called from an
# `if` so `set -e` never aborts on the non-match return.

# D1 — direct child of the claude-local root, not an allowlisted root file.
is_loose_root_file() {
  local p="$1" rel="" base
  case "$p" in
    "${HOST_CLAUDE_LOCAL}/"*) rel="${p#"${HOST_CLAUDE_LOCAL}/"}" ;;
    "${ROOT}/"*)              rel="${p#"${ROOT}/"}" ;;
    *) return 1 ;;
  esac
  [ -n "$rel" ] || return 1          # the root dir itself, not a file write
  case "$rel" in */*) return 1 ;; esac   # a subdirectory path → not loose-at-root
  for base in $ROOT_ALLOWLIST; do
    [ "$rel" = "$base" ] && return 1
  done
  return 0
}

# D2 — the Cowork system folder (never the legit /mnt/.claude-local mount).
is_cowork_system_folder() {
  case "$1" in
    */mnt/.claude/*|*/mnt/.claude) return 0 ;;
    *) return 1 ;;
  esac
}

# temp/sandbox path, with the session scratchpad and any mounted folder exempt.
is_temp_path() {
  case "$1" in */scratchpad/*) return 1 ;; esac   # scratchpad always exempt
  case "$1" in
    /sessions/*)
      case "$1" in */mnt/*) return 1 ;; esac        # mounted folder → not temp
      return 0 ;;
    /tmp/*|/private/tmp/*|/var/tmp/*) return 0 ;;
    *) return 1 ;;
  esac
}

# a skill file: SKILL.md, or any path under a skills/ segment.
is_skill_file() {
  case "$1" in
    */SKILL.md|*/skills/*) return 0 ;;
    *) return 1 ;;
  esac
}

# a deliverable artifact by extension.
is_deliverable() {
  case "$1" in
    *.xlsx|*.docx|*.pdf|*.pptx|*.csv) return 0 ;;
    *) return 1 ;;
  esac
}

# Desktop write — Craig's HOME Desktop specifically (file-delivery names
# "Craig's Desktop (~/Desktop/)"), not any directory that happens to be named
# Desktop. The model emits host-form home paths on both surfaces.
is_desktop() {
  case "$1" in
    /Users/*/Desktop/*|/home/*/Desktop/*|"${HOME}/Desktop/"*) return 0 ;;
    *) return 1 ;;
  esac
}

# ---------------------------------------------------------------------------
# Evaluate the policy. Deny rules first (deny > ask precedence), first match wins.
DECISION=""
REASON=""

if is_loose_root_file "$FILE_PATH"; then
  DECISION="deny"
  REASON="Blocked by guard-paths D1: '$FILE_PATH' is a loose file at the ~/.claude-local/ root. Only CLAUDE.md, MEMORY.md, MEMORY.local.md, INDEX.md, and .gitignore belong at root (policies/file-delivery.md; CLAUDE.md Folder Structure / Structure Discipline #2). Write it into a subdirectory — projects/<name>/, outputs/, skills/<name>/, etc."
elif is_cowork_system_folder "$FILE_PATH"; then
  DECISION="deny"
  REASON="Blocked by guard-paths D2: '$FILE_PATH' is inside the Cowork system folder (mnt/.claude/), which must never be written (CLAUDE.md Personal Skills Take Priority; policies/file-delivery.md). Personal skills live under ~/.claude-local/skills/."
elif is_skill_file "$FILE_PATH" && is_temp_path "$FILE_PATH"; then
  DECISION="ask"
  REASON="guard-paths A1: '$FILE_PATH' looks like a skill file being written to a temp/sandbox path. CLAUDE.md Skill Update Persistence says skill files go to ~/.claude-local/skills/<name>/ and never to /tmp or a sandbox-only path. Confirm this is an intentional throwaway staging copy, not the authoritative skill file."
elif is_desktop "$FILE_PATH"; then
  DECISION="ask"
  REASON="guard-paths A2: '$FILE_PATH' is under ~/Desktop/. policies/file-delivery.md routes output files into the ~/.claude-local/ structure (projects/<name>/outputs/ or root outputs/), never the Desktop. Confirm before writing outside the workspace."
elif is_deliverable "$FILE_PATH" && is_temp_path "$FILE_PATH"; then
  DECISION="ask"
  REASON="guard-paths A3: '$FILE_PATH' is a deliverable artifact written to a temp/sandbox path. policies/file-delivery.md routes output files into the ~/.claude-local/ structure, never a temporary VM path. Confirm before writing it somewhere ephemeral."
fi

# No rule matched → defer to normal permissions (silent).
if [ -z "$DECISION" ]; then
  exit 0
fi

# Emit per surface mode.
if [ "$MODE" = "block" ]; then
  emit_permission_decision "PreToolUse" "$DECISION" "$REASON"
else
  emit_additional_context "PreToolUse" "pre-tool-use-guard-paths (report-only on this surface — Cowork blocking-honor unconfirmed, NN#3): would have returned permissionDecision='${DECISION}'. ${REASON} Treat this as the decision and choose a compliant path."
fi

exit 0
