#!/bin/bash
# sync_plugins.sh — Single source of truth enforcement
# Copies canonical skills/ to plugin mirrors so they never drift.
# Run this after editing any file under skills/.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$REPO_ROOT/skills"

echo "Syncing skills/ → plugins/obsidian/skills/"
rsync -a --delete "$SKILLS_DIR/" "$REPO_ROOT/plugins/obsidian/skills/"

echo "Syncing skills/obsidian-cli/ → plugins/obsidian-cli/skills/obsidian-cli/"
rsync -a --delete "$SKILLS_DIR/obsidian-cli/" "$REPO_ROOT/plugins/obsidian-cli/skills/obsidian-cli/"

echo "✓ Plugin mirrors are in sync with skills/"
