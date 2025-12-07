#!/usr/bin/env bash
set -euo pipefail

# Where notes-to-blog exports to
NOTES_EXPORT_ROOT="$HOME/Desktop/notes-to-blog-output"

# Where your Jekyll site lives
JEKYLL_ROOT="$HOME/Desktop/verycooluser.github.io"

# Which Notes folder to export
NOTES_FOLDER_NAME="winnifred"

echo "=== Exporting Apple Notes folder \"$NOTES_FOLDER_NAME\" ==="
~/tools/notes-to-blog "$NOTES_FOLDER_NAME" "$NOTES_EXPORT_ROOT"

echo "=== Converting exported HTML to Jekyll posts ==="
cd "$JEKYLL_ROOT"
python3 script/notes_to_posts.py

echo "=== Checking for changes in _posts ==="
if git diff --quiet -- _posts; then
  echo "No changes to _posts; nothing to commit."
else
  git add _posts
  git commit -m "Update posts from \"$NOTES_FOLDER_NAME\" notes"
  git push
  echo "Changes pushed ✅"
fi

# After converting notes to posts:
python3 script/notes_to_posts.py

# Resize large images
cd "$HOME/Desktop/verycooluser.github.io/assets/post-images"
for img in *.jpg *.jpeg *.png; do
  [ -e "$img" ] || continue
  sips -Z 1600 "$img" >/dev/null 2>&1
done
