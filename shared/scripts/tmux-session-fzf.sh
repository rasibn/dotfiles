#!/usr/bin/env bash

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if [[ $# -eq 1 ]]; then
  selected=$1
else
  if command_exists fd; then
    dirs=$(fd . --type d --max-depth 1 "$PROJECT_DIR" "$WORK_DIR" "$ASSET_DIR" 2>/dev/null)
  else
    dirs=$(find "$PROJECT_DIR" "$WORK_DIR" "$ASSET_DIR" -mindepth 1 -maxdepth 1 -type d 2>/dev/null)
  fi

  if [[ -n "$dirs" ]]; then
    if command_exists fzf; then
      selected=$(echo "$dirs" | fzf)
    else
      echo "ERROR: fzf is not installed. Please install fzf first."
      exit 1
    fi
  else
    echo "ERROR: No directories found in specified paths."
    exit 1
  fi
fi

if [[ -z $selected ]]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr . _)
tmux_running=$(pgrep tmux)

# Function to create tmux session with windows
create_session() {
  local session_name=$1
  local directory=$2
  local detached=$3

  if [[ $detached == "true" ]]; then
    tmux new-session -ds "$session_name" -n "nvim" -c "$directory"
  else
    tmux new-session -s "$session_name" -n "nvim" -c "$directory"
  fi

  tmux new-window -t "$session_name" -n "zsh" -c "$directory"
  tmux new-window -t "$session_name" -n "extra" -c "$directory"

  # # Send cd commands to ensure proper directory and prompt updates
  tmux send-keys -t "$session_name:nvim" "cd '$directory'" Enter
  tmux send-keys -t "$session_name:zsh" "cd '$directory'" Enter
  tmux send-keys -t "$session_name:extra" "cd '$directory'" Enter
}

if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
  create_session "$selected_name" "$selected" "false"
  exit 0
fi

if ! tmux has-session -t="$selected_name" 2>/dev/null; then
  create_session "$selected_name" "$selected" "true"
fi

if [[ -z $TMUX ]]; then
  tmux attach-session -t "$selected_name"
else
  tmux switch-client -t "$selected_name"
fi
