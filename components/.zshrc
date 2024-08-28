export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="cloud"

plugins=(
        zsh-syntax-highlighting
        zsh-autosuggestions
        zsh-completions
        zsh-vi-mode
#       starship
        git
)

source $ZSH/oh-my-zsh.sh

alias dotfiles="cd $HOME/Projects/dotfiles"
alias dot="cd $HOME/Projects/dotfiles"
alias projects="cd $HOME/Projects"
alias notes="cd $HOME/Projects/Vault/ && git pull && $EDITOR"

alias roficonfig="cd $HOME/.config/rofi/ && $EDITOR"
alias nvimconfig="cd $HOME/.config/nvim/ && $EDITOR"
alias swayconfig="cd $HOME/.config/sway/ && $EDITOR"
alias ohmyzshconfig="cd $HOME/.oh-my-zsh"
alias firefoxconfig="$EDITOR $HOME/.mozilla/firefox/*.default-release/chrome/userChrome.css || $EDITOR $HOME/.mozilla/firefox/*.dev-edition-default/chrome/userChrome.css"
alias weztermconfig="$EDITOR ~/.wezterm.lua"
alias i3rustconfig="$EDITOR $HOME/.config/i3status-rust/config.toml"
alias picomconfig="$EDITOR $HOME/.config/picom.conf"
alias vifmconfig="$EDITOR $HOME/.config/vifm/vifmrc"
alias tmuxconfig="$EDITOR $HOME/.tmux.conf"
alias zshconfig="$EDITOR $HOME/.zshrc"
alias i3config="$EDITOR $HOME/.config/i3/config"

alias reader="zathura"
alias fdupes="rmlint"
alias lg="lazygit"
alias zel="zellij"

alias adb="$HOME/Android/Sdk/platform-tools/adb"

source $HOME/Projects/dotfiles/secrets.sh

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
    # Create session CODE with windows: nvim, zsh, and running
    tmux new-session -d -s CODE -n nvim          # Create CODE session with 'nvim' window
    tmux new-window -t CODE -n running           # Add 'running' window to CODE session
    tmux new-window -t CODE -n zsh               # Add 'zsh' window to CODE session
    tmux attach-session -t CODE
}

tmux_session_init_config() {
    tmux new-session -d -s CONFIG
    tmux attach-session -t CONFIG
}

# CORE ALIAS
# alias ls="eza"
alias oil="nvim +"Oil""
alias vim="nvim --clean"
alias ta="tmux a"
alias cls="clear"
alias cat="bat"
alias wife="nmtui"
alias git-undo="git reset --soft HEAD^"
if command -v python3 &> /dev/null; then
    alias py="python3"
elif command -v python &> /dev/null; then
    alias py="python"
fi

# XRANDR ALIAS
alias xrandrscaleup="xrandr --output eDP-1 --scale 0.95x0.95"
alias xrandrscalereset="xrandr --output eDP-1 --scale 1x1"

# FZF ALIAS
alias proji="~/Projects/dotfiles/components/scripts/tmux-sessionizer.sh"
alias nvimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener-preview.sh"
alias vimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener.sh"

export FZF_DEFAULT_COMMAND="fd --type file --follow --hidden --exclude .git"
# export FZF_DEFAULT_OPTS="--ansi --preview-window 'right:45%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'"

# GO `/bin` TO PATH
export PATH="$PATH:$(go env GOPATH)/bin"

# BUN COMPLETIONS AUTO GENERATED
[ -s "/home/rasib/.bun/_bun" ] && source "/home/rasib/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH=/home/rasib/.nimble/bin:$PATH

eval "$(zoxide init --cmd 'cd' zsh)"
