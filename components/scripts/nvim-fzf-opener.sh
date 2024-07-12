#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Use fd if available, otherwise use find
if command_exists fd; then
  FILE=$(fd --type f --search-path ~/Projects --search-path ~/work --follow --hidden --exclude .git | fzf)
else
  FILE=$(find ~/Projects ~/work -type f | fzf)
fi

# Check if a file was selected
if [[ -z "$FILE" ]]; then
  echo "No file selected."
  exit 1
else
  nvim "$FILE"
fi
