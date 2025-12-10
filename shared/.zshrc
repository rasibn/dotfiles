# ============================================
# PROFILING (comment out after benchmarking)
# ============================================
zmodload zsh/zprof

# ============================================
# ZINIT INITIALIZATION
# ============================================
source /opt/homebrew/opt/zinit/zinit.zsh

# ============================================
# LOAD SECRETS & ALIASES EARLY
# ============================================
source $HOME/assets/dotfiles/secrets.sh
source $DOTFILE_DIR/shared/scripts/.shell.aliases.sh

# ============================================
# STARSHIP PROMPT (inline theme)
# ============================================
eval "$(starship init zsh)"

# ============================================
# DIRENV (native hook - fast enough)
# ============================================
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# ============================================
# ALL PLUGINS - FULL ASYNC (load immediately, no delays)
# ============================================
# Everything loads in parallel right after prompt
zinit wait lucid for \
    OMZP::git

zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions \
    jeffreytse/zsh-vi-mode

# ============================================
# SIMPLE ALIASES
# ============================================
if command -v python3 &> /dev/null; then
    alias py="python3"
elif command -v python &> /dev/null; then
    alias py="python"
fi

# ============================================
# CONSOLIDATED PATH CONFIGURATION
# ============================================
export PATH="$HOME/.bun/bin:$HOME/.nimble/bin:$HOME/go/bin:$(go env GOPATH)/bin:$PATH"

# ============================================
# ENVIRONMENT VARIABLES
# ============================================
export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
export BUN_INSTALL="$HOME/.bun"

# ============================================
# TOOL INITIALIZATIONS
# ============================================
# Zoxide (fast cd replacement)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init --cmd 'cd' zsh)"
fi

# ============================================
# OPTIONAL TOOLS
# ============================================
# rustup-init always
# . "$HOME/.cargo/env"            # For sh/bash/zsh/ash/dash/pdksh

# BUN COMPLETIONS
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ============================================
# CUSTOM FUNCTIONS
# ============================================

# AWS SSO login helper
# Usage: aws_export_credentials qa
# aws sso login --profile qa
aws_export_credentials() {
    local profile_name="$1"
    eval "$(aws configure export-credentials --profile "$profile_name" --format env)"
    eval "export AWS_REGION=eu-west-1"
}

# Git worktree branch helper
# Usage: gwtb feature-branch
gwtb() {
  local branch=$1
  local repo_root repo_name worktree_dir
  repo_root=$(git rev-parse --show-toplevel) || return 1
  repo_name=$(basename "$repo_root")
  worktree_dir="$repo_root/../${repo_name}.${branch}"

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

# ============================================
# PROFILING OUTPUT (comment out after benchmarking)
# ============================================
# zprof

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/rasib.nadeem/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
