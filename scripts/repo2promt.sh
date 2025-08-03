#!/bin/bash

# repo2prompt.sh
# Usage: ./repo2prompt.sh [--full] [--copy] [repo_path]

SHOW_FULL=0
COPY=0
REPO_PATH="."

# Parse arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --full|-f)
      SHOW_FULL=1
      shift
      ;;
    --copy|-c)
      COPY=1
      shift
      ;;
    *)
      REPO_PATH="$1"
      shift
      ;;
  esac
done

MAX_LINES=20
MAX_FULL=200

# Collect output into a variable if --copy is set
if [ "$COPY" -eq 1 ]; then
  OUTPUT=$(
    echo "### REPO FILE TREE:"
    tree -a -I '.git|build|install|log|__pycache__|.vscode|.DS_Store' "$REPO_PATH"
    echo
    echo "### FILE CONTENT PREVIEW:"
    find "$REPO_PATH" -type f ! -path "*/.git/*" | sort | while read -r file; do
      relpath="${file#$REPO_PATH/}"
      nlines=$(wc -l < "$file")
      if file "$file" | grep -qE 'ASCII|Unicode|text'; then
        echo -e "\n--- FILE: $relpath ---"
        if [ "$SHOW_FULL" -eq 1 ] || [ "$nlines" -le "$MAX_FULL" ]; then
          cat "$file"
        else
          echo "[... Showing first $MAX_LINES lines ...]"
          head -n "$MAX_LINES" "$file"
          echo "[... $((nlines - 2*MAX_LINES)) lines skipped ...]"
          tail -n "$MAX_LINES" "$file"
        fi
      fi
    done
  )

  if ! command -v xclip >/dev/null 2>&1; then
    echo "Error: xclip is not installed. Please install xclip to use --copy." >&2
    exit 1
  fi

  echo "$OUTPUT" | xclip -selection clipboard
  echo "Copied repo prompt to clipboard."
else
  echo "### REPO FILE TREE:"
  tree -a -I '.git|build|install|log|__pycache__|.vscode|.DS_Store' "$REPO_PATH"
  echo
  echo "### FILE CONTENT PREVIEW:"
  find "$REPO_PATH" -type f ! -path "*/.git/*" | sort | while read -r file; do
    relpath="${file#$REPO_PATH/}"
    nlines=$(wc -l < "$file")
    if file "$file" | grep -qE 'ASCII|Unicode|text'; then
      echo -e "\n--- FILE: $relpath ---"
      if [ "$SHOW_FULL" -eq 1 ] || [ "$nlines" -le "$MAX_FULL" ]; then
        cat "$file"
      else
        echo "[... Showing first $MAX_LINES lines ...]"
        head -n "$MAX_LINES" "$file"
        echo "[... $((nlines - 2*MAX_LINES)) lines skipped ...]"
        tail -n "$MAX_LINES" "$file"
      fi
    fi
  done
fi
