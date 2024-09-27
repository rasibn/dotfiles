if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

source ~/assets/dotfiles/secrets.sh
source $DOTFILE_DIR/components/scripts/aliases.sh

alias booksm='cd ~/storage/shared/Documents/Books/'
alias notesm='cd ~/storage/shared/Documents/Vault/'

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
