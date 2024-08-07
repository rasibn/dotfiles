if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

# Command aliases
alias cls="clear"
alias reader="zathura"
alias ta ="tmux a"
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

alias proji="~/Projects/dotfiles/components/scripts/tmux-sessionizer.sh"
alias nvimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener-preview.sh"
alias vimi="~/Projects/dotfiles/components/scripts/nvim-fzf-opener.sh"


function git_config_work_global
    if not set -q WORK_EMAIL
        echo "WORK_EMAIL environment variable is not set."
        return 1
    end
    git config -global user.name "Rasib Nadeem"
    git config --global user.email "$WORK_EMAIL"
    echo "Configured Git for work with email: $WORK_EMAIL"
end

function git_config_home_global
    if not set -q HOME_EMAIL
        echo "HOME_EMAIL environment variable is not set."
        return 1
    end
    git config --global user.name "Rasib Nadeem"
    git config --global user.email "$HOME_EMAIL"
    echo "Configured Git for home with email: $HOME_EMAIL"
end

function git_config_work_local
    if not set -q WORK_EMAIL
        echo "WORK_EMAIL environment variable is not set."
        return 1
    end
    git config user.name "Rasib Nadeem"
    git config user.email "$WORK_EMAIL"
    echo "Configured Git for work with email: $WORK_EMAIL"
end

function git_config_home_local
    if not set -q HOME_EMAIL
        echo "HOME_EMAIL environment variable is not set."
        return 1
    end
    git config user.name "Rasib Nadeem"
    git config user.email "$HOME_EMAIL"
    echo "Configured Git for home with email: $HOME_EMAIL"
end

# Export FZF_DEFAULT_COMMAND
set -Ux FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"

gh completion --shell fish | source
zoxide init --cmd cd fish | source
