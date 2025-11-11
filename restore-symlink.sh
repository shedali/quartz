#!/usr/bin/env bash
# Restore symlink to knowledge vault for local development

set -e

POSTS_DIR="$HOME/dev/shedali/knowledge/posts"
CONTENT_DIR="$(dirname "$0")/content"

echo "Restoring symlink to knowledge vault..."

# Remove directory if it exists
if [ -d "$CONTENT_DIR" ] && [ ! -L "$CONTENT_DIR" ]; then
    rm -rf "$CONTENT_DIR"
fi

# Create symlink
ln -sf "$POSTS_DIR" "$CONTENT_DIR"

echo "✓ Symlink restored"
echo "Local development ready - changes to ~/dev/shedali/knowledge/posts will be reflected immediately"
