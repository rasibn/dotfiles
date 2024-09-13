#!/usr/bin/env fish

# Function to check if a command exists
function command_exists
    command -v $argv[1] >/dev/null 2>&1
end

# Check if one argument is provided
if test (count $argv) -eq 1
    set selected $argv[1]
else
    if command_exists fd
        set selected (fd . --type d --max-depth 1 $PROJECT_DIR $WORK_DIR $ASSET_DIR | fzf)
    else
        set selected (find $PROJECT_DIR $WORK_DIR $ASSET_DIR -mindepth 1 -maxdepth 1 -type d | fzf)
    end
end

# Exit if nothing is selected
if test -z "$selected"
    exit 0
end

set selected_name (basename "$selected" | tr . _)
set tmux_running (pgrep tmux)

# If TMUX is not running, start a new session
if test -z "$TMUX" -a -z "$tmux_running"
    tmux new-session -s "$selected_name" -n nvim -c "$selected"
    tmux new-window -t "$selected_name" -n zsh -c "$selected"
    tmux new-window -t "$selected_name" -n extra -c "$selected"
    exit 0
end

# If session doesn't exist, create it
if not tmux has-session -t="$selected_name" ^/dev/null
    tmux new-session -ds "$selected_name" -n nvim -c "$selected"
    tmux new-window -t "$selected_name" -n zsh -c "$selected"
    tmux new-window -t "$selected_name" -n extra -c "$selected"
end

# Attach or switch to the session
if test -z "$TMUX"
    tmux attach-session -t "$selected_name"
else
    tmux switch-client -t "$selected_name"
end
