#!/usr/bin/env bash
# Sync content from knowledge vault to quartz for deployment

set -e

POSTS_DIR="$HOME/dev/shedali/knowledge/posts"
CONTENT_DIR="$(dirname "$0")/content"

echo "Syncing content from knowledge vault to quartz..."

# Remove symlink if it exists
if [ -L "$CONTENT_DIR" ]; then
    rm "$CONTENT_DIR"
fi

# Copy content from posts directory
rsync -av --delete "$POSTS_DIR/" "$CONTENT_DIR/"

echo "✓ Content synced successfully"
echo "Ready to commit and push to GitHub"
