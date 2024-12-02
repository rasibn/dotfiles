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
