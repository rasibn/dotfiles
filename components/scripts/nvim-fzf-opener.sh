#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update search paths if a directory argument is provided
if [[ -n "$1" ]]; then
  if command_exists fd; then
    FILE=$(fd --type f --search-path "$1" --follow --hidden --exclude .git | fzf)
  else
    FILE=$(find "$1" -type f | fzf)
  fi
else
  if command_exists fd; then
    FILE=$(fd --type f --search-path ~/Projects --search-path ~/work --follow --hidden --exclude .git | fzf)
  else
    FILE=$(find ~/Projects ~/work -type f | fzf)
  fi

fi
# Check if a file was selected
if [[ -z "$FILE" ]]; then
  echo "No file selected."
  exit 1
else
  nvim "$FILE"
fi
