alias proji="$DOTFILE_DIR/components/scripts/tmux-sessionizer.sh"
alias nvimi="$DOTFILE_DIR/components/scripts/nvim-fzf-opener-preview.sh"
alias vimi="$DOTFILE_DIR/components/scripts/nvim-fzf-opener.sh"
alias git-undo="git reset --soft HEAD^"
alias cls="clear"
alias ta="tmux a"
alias oil="nvim +"Oil""
alias vim="nvim"
alias nvimc="nvim --clean"
alias vimm="command vim"
alias wife="nmtui"
alias lg="lazygit"

alias cat="bat"
alias pnotes="cd $ASSET_DIR/personal-notes/ && $EDITOR"
alias wnotes="cd $ASSET_DIR/work-notes/ && $EDITOR"
alias notes="cd $ASSET_DIR/personal-notes/ && git pull && $EDITOR"
alias dot="cd $DOTFILE_DIR"

# dot. prefix = points to $DOTFILE_DIR or $ASSET_DIR/nixos* for nixos
alias dot.zsh="$EDITOR $DOTFILE_DIR/components/.zshrc"
alias dot.tmux="$EDITOR $DOTFILE_DIR/components/.tmux.conf"
alias dot.nvim="cd $DOTFILE_DIR/components/nvim"
alias dot.mob.nvim="cd $DOTFILE_DIR/mobile/nvim"
alias dot.fish="cd $DOTFILE_DIR/components/fish"
alias dot.mob.fish="cd $DOTFILE_DIR/mobile/fish"
alias dot.nixos="cd $ASSET_DIR/nixos-config"

# config. prefix = points to $HOME/.config or $HOME dir
alias config.zsh="$EDITOR $HOME/.zshrc"
alias config.tmux="$EDITOR $HOME/.tmux.conf"
alias config.nvim="cd $HOME/.config/nvim"
alias config.fish="cd $HOME/.config/fish"
alias config.nixos="cd $HOME/.config"

alias config.ohmyzsh="cd $HOME/.oh-my-zsh"

# Firefox configuration (checks both default-release and dev-edition)
alias config.firefox="$EDITOR $HOME/.mozilla/firefox/*.default-release/chrome/userChrome.css || $EDITOR $HOME/.mozilla/firefox/*.dev-edition-default/chrome/userChrome.css"
alias dot.wezterm="$EDITOR $DOTFILE_DIR/ui/.wezterm.lua"
alias config.wezterm="$EDITOR $HOME/.wezterm.lua"

# i3, sway, and other window managers
alias dot.rofi="cd $DOTFILE_DIR/ui/rofi"
alias dot.sway="cd $DOTFILE_DIR/ui/sway"
alias dot.i3rust="$EDITOR $DOTFILE_DIR/ui/i3status-rust/config.toml"
alias dot.i3="cd $DOTFILE_DIR/ui/i3"
alias dot.picom="$EDITOR $DOTFILE_DIR/ui/picom.conf"
alias config.rofi="cd $HOME/.config/rofi"
alias config.sway="cd $HOME/.config/sway"
alias config.i3rust="$EDITOR $HOME/.config/i3status-rust/config.toml"
alias config.i3="$EDITOR $HOME/.config/i3/config"
alias config.picom="$EDITOR $HOME/.config/picom.conf"
alias xrandrscaleup="xrandr --output eDP-1 --scale 0.95x0.95"
alias xrandrscalereset="xrandr --output eDP-1 --scale 1x1"

# alias reader="zathura"
# alias fdupes="rmlint"
# alias adb="$HOME/Android/Sdk/platform-tools/adb"
