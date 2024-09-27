if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -gx EDITOR nvim

source ~/assets/dotfiles/secrets.sh
source $DOTFILE_DIR/components/scripts/.shell.aliases.sh

alias booksm='cd ~/storage/shared/Documents/Books/'
alias notesm='cd ~/storage/shared/Documents/Vault/'

# Export FZF_DEFAULT_COMMAND
set -Ux FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"

gh completion --shell fish | source
zoxide init --cmd cd fish | source
