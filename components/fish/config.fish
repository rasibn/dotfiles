if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim


# Command aliases
alias cls="clear"
alias reader="zathura"
alias tvim ="tmux & $EDITOR"
alias conf='cd ~/.config/'
alias notes="cd ~/Projects/Vault/ && $EDITOR"
alias booksm='cd ~/storage/shared/Documents/Books/'
alias notesm='cd ~/storage/shared/Documents/Vault/'

# Configs Aliases
alias nvimconfig="$EDITOR ~/.config/nvim/"
alias fishconfig="$EDITOR ~/.config/fish/"
alias tmuxconfig="$EDITOR ~/.tmux.conf"
alias zshconfig="$EDITOR ~/.zshrc"
alias i3config="$EDITOR ~/.config/i3/config"
alias swayconfig="$EDITOR ~/.config/sway/"

set -gx EDITOR nvim

alias proji="~/Projects/dotfiles/components/scripts/tmux-sessionizer.sh"
alias nvimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener-preview.sh"
alias vimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener.sh"

# Export FZF_DEFAULT_COMMAND
set -Ux FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"

gh completion --shell fish | source
zoxide init --cmd cd fish | source
