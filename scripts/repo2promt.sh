#!/bin/bash

# repo2prompt.sh
# Usage: ./repo2prompt.sh [repo_path] > repo_prompt.txt

REPO_PATH="${1:-.}"
MAX_LINES=20   # How many lines to show from the head/tail of big files
MAX_FULL=200   # Max file size (lines) for full dump

echo "### REPO FILE TREE:"
tree -a -I '.git|build|install|log|__pycache__|.vscode|.DS_Store' "$REPO_PATH"
echo
echo "### FILE CONTENT PREVIEW:"

find "$REPO_PATH" -type f ! -path "*/.git/*" | sort | while read -r file; do
    relpath="${file#$REPO_PATH/}"
    nlines=$(wc -l < "$file")
    # Only include text-like files (skip binaries, images, etc)
    if file "$file" | grep -qE 'ASCII|Unicode|text'; then
        echo -e "\n--- FILE: $relpath ---"
        if [ "$nlines" -le "$MAX_FULL" ]; then
            cat "$file"
        else
            echo "[... Showing first $MAX_LINES lines ...]"
            head -n "$MAX_LINES" "$file"
            echo "[... $((nlines - 2*MAX_LINES)) lines skipped ...]"
            tail -n "$MAX_LINES" "$file"
        fi
    fi
done

