#!/usr/bin/env bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Update search paths if a directory argument is provided
if [[ -n "$1" ]]; then
  if command_exists fd; then
    FILE=$(fd --type f --search-path "$1" --follow --hidden --exclude .git | fzf --ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}')
  else
    FILE=$(find "$1" -type f | fzf)
  fi
else
  if command_exists fd; then
    FILE=$(fd --type f --search-path $PROJECT_DIR --search-path $WORK_DIR --search-path $ASSET_DIR --follow --hidden --exclude .git | fzf --ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}')
  else
    FILE=$(find $PROJECT_DIR $WORK_DIR $ASSET_DIR -type f | fzf)
  fi

fi

# Check if a file was selected
if [[ -z "$FILE" ]]; then
  echo "No file selected."
  exit 1
else
  nvim "$FILE"
fi
