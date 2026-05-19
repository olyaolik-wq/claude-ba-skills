#!/bin/bash
# install.sh — installs all BA skills into ~/.claude/skills/

SKILLS_DIR="$HOME/.claude/skills"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Installing Claude BA Skills..."
echo "Target: $SKILLS_DIR"
echo ""

mkdir -p "$SKILLS_DIR"

for skill_dir in "$REPO_DIR/skills/ba-"*/; do
    skill_name=$(basename "$skill_dir")
    dest="$SKILLS_DIR/$skill_name"
    mkdir -p "$dest"
    cp "$skill_dir/SKILL.md" "$dest/SKILL.md"
    echo "  ✅ $skill_name"
done

echo ""
echo "All 9 BA skills installed."
echo "Open Claude Code in any project and run /ba-nav to get started."
