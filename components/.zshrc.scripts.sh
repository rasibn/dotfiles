git_config_work_local() {
  if [ -z "$WORK_EMAIL" ]; then
    echo "WORK_EMAIL environment variable is not set."
    return 1
  fi
  git config user.name "Rasib Nadeem"
  git config user.email "$WORK_EMAIL"
  echo "Configured Git locally for work with email: $WORK_EMAIL"
}

git_config_home_local() {
  if [ -z "$HOME_EMAIL" ]; then
    echo "HOME_EMAIL environment variable is not set."
    return 1
  fi
  git config user.name "Rasib Nadeem"
  git config user.email "$HOME_EMAIL"
  echo "Configured Git locally for home with email: $HOME_EMAIL"
}

tmux_session_init_code() {
  tmux new-session -d -s CODE -n nvim # Create CODE session with 'nvim' window
  tmux new-window -t CODE -n running  # Add 'running' window to CODE session
  tmux new-window -t CODE -n zsh      # Add 'zsh' window to CODE session
  tmux attach-session -t CODE
}

tmux_session_init_config() {
  tmux new-session -d -s CONFIG -c "$DOTFILE_DIR"
  tmux rename-window -t CONFIG:1 'dotfiles'
  tmux new-window CONFIG:2 -c "$ASSET_DIR/nixos-config"
  tmux rename-window -t CONFIG:1 'assets'
  tmux attach-session -t CONFIG
}
