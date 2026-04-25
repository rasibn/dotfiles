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

if tmux has-session -t "$session" 2>/dev/null; then
  if tmux list-windows -t "$session" -F '#{window_name}' | grep -q "^${window}$"; then
    switch_or_attach
  else
    tmux new-window -t "$session" -n "$window" "$cmd"
    switch_or_attach
  fi
else
  tmux new-session -d -s "$session" -n "$window" "$cmd"
  switch_or_attach
fi
