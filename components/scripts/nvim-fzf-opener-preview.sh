#!/bin/bash

command_exists() {
  command -v "$1" >/dev/null 2>&1
}
# export FZF_DEFAULT_OPTS=""

# Use fd if available, otherwise use find
if command_exists fd; then
  FILE=$(fd --type f --search-path ~/Projects --search-path ~/work --follow --hidden --exclude .git | fzf --ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}')
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
