#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if [[ $# -eq 1 ]]; then
  selected=$1
else
  # if command_exists fd; then
  #   PREVIEW_CMD="fd --type f --max-depth 1 --color=always . {} | head -n 100"
  # else
  #   PREVIEW_CMD="find {} -maxdepth 1 -type f | head -n 100"
  # fi
  selected=$(find ~/Projects ~/work -mindepth 1 -maxdepth 1 -type d | fzf --preview "$PREVIEW_CMD")
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -c "$selected"
fi

if [[ -z $TMUX ]]; then
  tmux attach-session -t "$selected_name"
else
  tmux switch-client -t "$selected_name"
fi
