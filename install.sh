#!/bin/bash

# Utility Skills Installer
# Creates symlinks to Claude Code and Codex skill directories

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/src/skills"

CLAUDE_SKILLS_DIR="$HOME/.claude/skills"
CODEX_SKILLS_DIR="$HOME/.codex/skills"

SKILLS=(
    "utility-commit-message"
    "utility-git-worktree"
    "utility-layered-explainer"
)

OLD_SKILLS=(
    "commit-message"
)

echo "🚀 Installing Utility Skills..."
echo ""

# Create skill directories if they don't exist
mkdir -p "$CLAUDE_SKILLS_DIR"
mkdir -p "$CODEX_SKILLS_DIR"

echo "🧹 Cleaning up old symlinks..."
for old_skill in "${OLD_SKILLS[@]}"; do
    if [ -L "$CLAUDE_SKILLS_DIR/$old_skill" ]; then
        rm "$CLAUDE_SKILLS_DIR/$old_skill"
        echo "   Removed: $CLAUDE_SKILLS_DIR/$old_skill"
    fi
    if [ -L "$CODEX_SKILLS_DIR/$old_skill" ]; then
        rm "$CODEX_SKILLS_DIR/$old_skill"
        echo "   Removed: $CODEX_SKILLS_DIR/$old_skill"
    fi
done
echo ""

for skill in "${SKILLS[@]}"; do
    echo "📦 Installing $skill..."

    # Claude Code
    if [ -L "$CLAUDE_SKILLS_DIR/$skill" ]; then
        echo "   Removing existing symlink: $CLAUDE_SKILLS_DIR/$skill"
        rm "$CLAUDE_SKILLS_DIR/$skill"
    elif [ -d "$CLAUDE_SKILLS_DIR/$skill" ]; then
        echo "   ⚠️  Directory exists (not a symlink): $CLAUDE_SKILLS_DIR/$skill"
        echo "   Backing up to $CLAUDE_SKILLS_DIR/$skill.bak"
        mv "$CLAUDE_SKILLS_DIR/$skill" "$CLAUDE_SKILLS_DIR/$skill.bak"
    fi
    ln -s "$SKILLS_SRC/$skill" "$CLAUDE_SKILLS_DIR/$skill"
    echo "   ✅ Claude Code: $CLAUDE_SKILLS_DIR/$skill -> $SKILLS_SRC/$skill"

    # Codex
    if [ -L "$CODEX_SKILLS_DIR/$skill" ]; then
        echo "   Removing existing symlink: $CODEX_SKILLS_DIR/$skill"
        rm "$CODEX_SKILLS_DIR/$skill"
    elif [ -d "$CODEX_SKILLS_DIR/$skill" ]; then
        echo "   ⚠️  Directory exists (not a symlink): $CODEX_SKILLS_DIR/$skill"
        echo "   Backing up to $CODEX_SKILLS_DIR/$skill.bak"
        mv "$CODEX_SKILLS_DIR/$skill" "$CODEX_SKILLS_DIR/$skill.bak"
    fi
    ln -s "$SKILLS_SRC/$skill" "$CODEX_SKILLS_DIR/$skill"
    echo "   ✅ Codex: $CODEX_SKILLS_DIR/$skill -> $SKILLS_SRC/$skill"

    echo ""
done

echo "✅ Installation complete!"
echo ""
echo "Usage:"
echo "  Claude Code / Codex:"
echo ""
echo "  /utility-commit-message <thread.md or context>"
echo "  /utility-git-worktree <repo/base/worktree info>"
echo "  /utility-layered-explainer <topic/question>"
