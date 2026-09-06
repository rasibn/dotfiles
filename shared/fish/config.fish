# Ensure standard system binaries are available before anything else runs.
# This prevents "Unknown command" errors in fish's built-in prompt functions
# when fish is started with a minimal PATH.
set -gx PATH /home/rasib/.local/bin /usr/local/bin /usr/bin /bin $PATH

# Fish-specific environment equivalent of the repository root config.env.
source "$HOME/assets/dotfiles/config.env.fish"
source "$DOTFILE_DIR/shared/scripts/.shell.aliases.sh"

if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Export FZF_DEFAULT_COMMAND
set -Ux FZF_DEFAULT_COMMAND "fd --type file --follow --hidden --exclude .git"

set -gx PATH $HOME/go/bin $PATH
gh completion --shell fish | source
zoxide init --cmd cd fish | source
