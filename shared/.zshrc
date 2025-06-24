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

# export CERTIFI_PATH=$(python3 -m certifi)
# export SSL_CERT_FILE=${CERTIFI_PATH}
# export REQUESTS_CA_BUNDLE=${CERTIFI_PATH}
# export PIP_CERT=${CERTIFI_PATH}
# export HTTPLIB2_CA_CERTS=${CERTIFI_PATH}
# export CURL_CA_BUNDLE=${CERTIFI_PATH}
# export NODE_EXTRA_CA_CERTS=${CERTIFI_PATH}
# export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
[[ ! -r '/home/rasib/.opam/opam-init/init.zsh' ]] || source '/home/rasib/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null
# END opam configuration
