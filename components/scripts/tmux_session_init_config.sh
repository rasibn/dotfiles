#!/usr/bin/env bash

tmux new-session -d -s CONFIG -c "$DOTFILE_DIR"
tmux rename-window -t CONFIG:1 'dotfiles'
tmux new-window CONFIG:2 -c "$ASSET_DIR/nixos-config"
tmux rename-window -t CONFIG:1 'assets'
tmux attach-session -t CONFIG
