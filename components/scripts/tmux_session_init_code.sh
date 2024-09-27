#!/usr/bin/env bash

tmux new-session -d -s CODE -n nvim # Create CODE session with 'nvim' window
tmux new-window -t CODE -n running  # Add 'running' window to CODE session
tmux new-window -t CODE -n zsh      # Add 'zsh' window to CODE session
tmux attach-session -t CODE
