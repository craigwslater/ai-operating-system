#!/usr/bin/env bash
# AUTHOR'S NOTE—this header is appended at port time; the original file does not contain it.
#
# Designed by Craig—runtime: Claude (Sonnet/Opus).
#
# What this is. The Cowork plugin packaging script for the same cross-file
# maintenance + structural drift detection hook layer that install-hooks-to-claude-code.sh
# wires into Claude Code. Builds a frontier-hooks.zip plugin bundle from
# ~/.claude-local/hooks/ that uploads via Cowork Organization Settings →
# Plugins.
#
# What was redacted. Nothing—the registry sweep produced zero substitutions.
# The script uses $HOME for path resolution; no hardcoded user paths.
#
# Why it's included. The other half of the dual-environment portability story
# (paired with install-hooks-to-claude-code.sh). Direct evidence for the CS#4
# claim that the same primitives ship to both runtimes; both scripts live in
# artifacts/install-scripts/ so a reader sees the symmetry without having to
# follow links.
#
# ---

# package-hooks-plugin.sh
#
# Builds the Cowork-installable plugin archive that ports the six Claude Code
# hooks into Cowork. Sibling to install-hooks-to-claude-code.sh — symmetric
# bootstrap pattern: one script per environment surface.
#   - install-hooks-to-claude-code.sh → wires the hooks into ~/.claude/settings.json (CC).
#   - package-hooks-plugin.sh         → bundles the hooks as a plugin .zip (Cowork).
#
# Source-of-truth discipline: the six hook scripts live ONLY at
# ~/.claude-local/hooks/*.sh. The persisted plugin folder
# (~/.claude-local/plugins/frontier-hooks/) holds only plugin-specific source
# files (.claude-plugin/plugin.json + hooks/hooks.json). The scripts are
# bundled fresh from ~/.claude-local/hooks/ at package time. This avoids the
# drift problem that the Session 4 hooks layer was built to solve.
#
# Output: ~/.claude-local/outputs/plugins-packaged/frontier-hooks.zip
#
# Usage:
#   bash ~/.claude-local/hooks/package-hooks-plugin.sh
#   bash ~/.claude-local/hooks/package-hooks-plugin.sh --dry-run
#   bash ~/.claude-local/hooks/package-hooks-plugin.sh --output /tmp/plugins
#
# Exit codes:
#   0 — package built (or dry-run printed)
#   1 — required source missing (plugin folder, manifest, or hook script)
#   2 — usage error or filesystem state
#
# Portable: macOS BSD + Linux GNU.

set -euo pipefail

# Resolve ~/.claude-local across environments. Same fallback chain used by
# scripts/regenerate-index.sh and the six hook scripts. CC on Craig's Mac
# resolves directly via $HOME; Cowork bash sandbox finds the mount under
# $HOME/mnt/; CLAUDE_LOCAL_ROOT is an explicit override.
if [ -d "${HOME}/.claude-local" ]; then
  ROOT="${HOME}/.claude-local"
elif [ -d "${HOME}/mnt/.claude-local" ]; then
  ROOT="${HOME}/mnt/.claude-local"
elif [ -d "${CLAUDE_LOCAL_ROOT:-}" ]; then
  ROOT="${CLAUDE_LOCAL_ROOT}"
else
  echo "Could not resolve ~/.claude-local. Tried \${HOME}/.claude-local and \${HOME}/mnt/.claude-local. Set CLAUDE_LOCAL_ROOT explicitly to override." >&2
  exit 2
fi

PLUGIN_NAME="frontier-hooks"
PLUGIN_SRC="${ROOT}/plugins/${PLUGIN_NAME}"
HOOKS_SRC="${ROOT}/hooks"
OUTPUT_DIR="${OUTPUT_DIR:-${ROOT}/outputs/plugins-packaged}"

DRY_RUN=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --output) shift; OUTPUT_DIR="$1" ;;
    -h|--help)
      sed -n '2,/^$/p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      # --output's value-arg is consumed by the shift above; ignore unknowns conservatively
      ;;
  esac
done

# ---------- Pre-flight ----------

if [ ! -d "$PLUGIN_SRC" ]; then
  echo "Plugin source not found: $PLUGIN_SRC" >&2
  echo "Expected ${PLUGIN_SRC}/.claude-plugin/plugin.json + ${PLUGIN_SRC}/hooks/hooks.json" >&2
  exit 1
fi

if [ ! -f "${PLUGIN_SRC}/.claude-plugin/plugin.json" ]; then
  echo "Missing manifest: ${PLUGIN_SRC}/.claude-plugin/plugin.json" >&2
  exit 1
fi

if [ ! -f "${PLUGIN_SRC}/hooks/hooks.json" ]; then
  echo "Missing manifest: ${PLUGIN_SRC}/hooks/hooks.json" >&2
  exit 1
fi

# Required hook scripts (canonical source). Mirror install-hooks-to-claude-code.sh.
REQUIRED_HOOKS=(
  "post-tool-use-verify-write.sh"
  "session-start-prune-commitment-logs.sh"
  "session-end-context-reminder.sh"
  "session-end-cross-file-consistency.sh"
  "session-end-improvement-opportunities.sh"
  "session-end-portfolio-sync.sh"
)

for h in "${REQUIRED_HOOKS[@]}"; do
  if [ ! -f "${HOOKS_SRC}/${h}" ]; then
    echo "Missing canonical hook script: ${HOOKS_SRC}/${h}" >&2
    exit 1
  fi
done

# ---------- Stage ----------

TMPROOT=$(mktemp -d)
trap 'rm -rf "$TMPROOT"' EXIT

STAGE="${TMPROOT}/${PLUGIN_NAME}"
mkdir -p "${STAGE}/.claude-plugin" "${STAGE}/hooks"

# Copy plugin manifests (preserved from source).
cp "${PLUGIN_SRC}/.claude-plugin/plugin.json" "${STAGE}/.claude-plugin/plugin.json"
cp "${PLUGIN_SRC}/hooks/hooks.json"           "${STAGE}/hooks/hooks.json"

# Copy fresh hook scripts from canonical source.
for h in "${REQUIRED_HOOKS[@]}"; do
  cp "${HOOKS_SRC}/${h}" "${STAGE}/hooks/${h}"
  chmod +x "${STAGE}/hooks/${h}"
done

# Strip cruft (same patterns as package-all.sh).
find "$STAGE" -name ".DS_Store" -delete 2>/dev/null || true
find "$STAGE" -name "*.tmp" -delete 2>/dev/null || true
find "$STAGE" -name ".~lock.*#" -delete 2>/dev/null || true

# ---------- Dry-run inspection ----------

if [ "$DRY_RUN" -eq 1 ]; then
  echo "[dry-run] Would package the following tree (contents at root of .plugin archive):"
  (cd "$STAGE" && find . -print | sort | sed 's|^\./||; /^\.$/d')
  echo "[dry-run] Output target: ${OUTPUT_DIR}/${PLUGIN_NAME}.plugin"
  exit 0
fi

# ---------- Zip ----------

mkdir -p "$OUTPUT_DIR"

# Build the .plugin archive in $TMPROOT then copy to OUTPUT_DIR. This avoids
# zip's atomic-rename failure when OUTPUT_DIR is on a network/mount filesystem
# (same fix package-all.sh uses — see its line ~119 comment).
#
# Structure: contents at the ROOT of the archive (no top-level frontier-hooks/
# wrapper). This is the convention Cowork's personal-account install path
# expects when a .plugin file is uploaded via Customize → Personal Plugin
# (verified 2026-05-06, v2 Session 1). The earlier .zip-with-wrapper output
# was written for an Organization-Settings install path that does not exist
# on personal accounts.
ZIP_PATH="${TMPROOT}/${PLUGIN_NAME}.plugin"
(cd "$STAGE" && zip -qr "$ZIP_PATH" .)

cp -f "$ZIP_PATH" "${OUTPUT_DIR}/${PLUGIN_NAME}.plugin"

SIZE=$(wc -c < "${OUTPUT_DIR}/${PLUGIN_NAME}.plugin" | tr -d ' ')
echo "Packaged: ${OUTPUT_DIR}/${PLUGIN_NAME}.plugin (${SIZE}B)"
echo ""
echo "Next steps:"
echo "  1. Open the Claude desktop app, switch to the Cowork tab."
echo "  2. Click Customize in the left sidebar → Personal Plugin → upload."
echo "  3. Choose ${OUTPUT_DIR}/${PLUGIN_NAME}.plugin."
echo "  4. Verify hook firing in Cowork:"
echo "       - PostToolUse:  trigger any Write/Edit on a ~/.claude-local file. JSONL line should append to ~/.claude-local/outputs/commitment-logs/{session-id}.jsonl."
echo "       - SessionStart: at session start, the prune hook scans ~/.claude-local/outputs/commitment-logs/ for files older than 30 days. Silent on the happy path; emits a one-line summary if it actually pruned anything."
echo "       - SessionEnd:   close a session and look for the three hook outputs in additionalContext."
echo ""
echo "  Claude Code half: also re-run \`bash ~/.claude-local/hooks/install-hooks-to-claude-code.sh\`"
echo "  on your Mac so the new SessionStart hook gets registered in ~/.claude/settings.json."
echo "  (PostToolUse + SessionEnd entries already exist; the installer is idempotent — only the"
echo "  new SessionStart entry will be added.)"
echo ""

exit 0
