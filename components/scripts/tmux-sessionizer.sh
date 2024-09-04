#!/bin/bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if [[ $# -eq 1 ]]; then
  selected=$1
else
  if command_exists fd; then
    selected=$(fd . --type d --max-depth 1 ~/Projects ~/work | fzf)
  else
    selected=$(find ~/Projects ~/work -mindepth 1 -maxdepth 1 -type d | fzf)
  fi
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  tmux new-session -s "$selected_name" -n "nvim" -c "$selected"
  tmux new-window -t "$selected_name" -n "zsh" -c "$selected"
  tmux new-window -t "$selected_name" -n "extra" -c "$selected"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  tmux new-session -ds "$selected_name" -n "nvim" -c "$selected"
  tmux new-window -t "$selected_name" -n "zsh" -c "$selected"
  tmux new-window -t "$selected_name" -n "extra" -c "$selected"
fi

if [[ -z $TMUX ]]; then
  tmux attach-session -t "$selected_name"
else
  tmux switch-client -t "$selected_name"
fi
