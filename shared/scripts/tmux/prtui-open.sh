#!/usr/bin/env bash
# Open or create the prtui window in the manager session, then switch to it.
session="manager"
window="prtui"
dir="${1:-$HOME}"
cmd="bun run $DOTFILE_DIR/shared/scripts/pr-tui/src/cli.tsx $dir"

switch_or_attach() {
  tmux switch-client -t "$session:$window" 2>/dev/null || \
    tmux attach-session -t "$session" \; select-window -t "$window"
}

ensure_prtui_first() {
  # Get the index of the prtui window
  local prtui_idx=$(tmux list-windows -t "$session" -F '#{window_index}:#{window_name}' | grep ":${window}$" | cut -d: -f1)

  # If prtui is not window 1 (base-index), swap with whatever is at 1
  if [ -n "$prtui_idx" ] && [ "$prtui_idx" != "1" ]; then
    tmux swap-window -s "$session:$prtui_idx" -t "$session:1"
  fi
}

if tmux has-session -t "$session" 2>/dev/null; then
  if tmux list-windows -t "$session" -F '#{window_name}' | grep -q "^${window}$"; then
    ensure_prtui_first
    switch_or_attach
  else
    tmux new-window -t "$session" -n "$window" "$cmd"
    ensure_prtui_first
    switch_or_attach
  fi
else
  tmux new-session -d -s "$session" -n "$window" "$cmd"
  switch_or_attach
fi
