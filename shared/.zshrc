export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="cloud"

plugins=(
        zsh-syntax-highlighting
        zsh-autosuggestions
        zsh-completions
        zsh-vi-mode
        # starship
        direnv
        git
)

source $HOME/assets/dotfiles/secrets.sh
source $ZSH/oh-my-zsh.sh
source $DOTFILE_DIR/shared/scripts/.shell.aliases.sh

if command -v python3 &> /dev/null; then
    alias py="python3"
elif command -v python &> /dev/null; then
    alias py="python"
fi

export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export PATH="$PATH:$(go env GOPATH)/bin"

eval "$(zoxide init --cmd 'cd' zsh)"

# rustup-init always
# . "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh

# BUN COMPLETIONS AUTO GENERATED
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=$HOME/.nimble/bin:$PATH
export PATH="$HOME/go/bin:$PATH"

 # aws sso login --profile qa
aws_export_credentials() {
    local profile_name="$1"
    eval "$(aws configure export-credentials --profile "$profile_name" --format env)"
    eval "export AWS_REGION=eu-west-1"
}

gwtb() {
  local branch=$1
  local repo_root
  repo_root=$(git rev-parse --show-toplevel) || return 1
  local worktree_dir="$repo_root/../$branch"

  # if worktree already exists
  if git worktree list --porcelain | grep -q "worktree $worktree_dir"; then
    echo "Worktree for '$branch' already exists. Navigating..."
    cd "$worktree_dir" || return 1
    return
  fi

  # if branch exists
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    echo "Creating worktree for existing branch '$branch'..."
    git worktree add "$worktree_dir" "$branch" || return 1
  else
    # branch does not exist, create it from current HEAD
    local base_branch
    base_branch=$(git branch --show-current)
    echo "Branch '$branch' not found. Creating new branch from '$base_branch'..."
    git worktree add -b "$branch" "$worktree_dir" "$base_branch" || return 1
  fi

  cd "$worktree_dir" || return 1
}
