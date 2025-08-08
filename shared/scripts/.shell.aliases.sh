# mapping functions (or scripts) to aliases so we can use them cross shell
alias proji="$DOTFILE_DIR/shared/scripts/golang/proji/proji"
alias cdpls="$DOTFILE_DIR/shared/scripts/golang/vimi/vimi --files"
alias nvimi="$DOTFILE_DIR/shared/scripts/golang/vimi/vimi -p"
alias vimi="$DOTFILE_DIR/shared/scripts/golang/vimi/vimi"

alias git_config_home_local="$DOTFILE_DIR/shared/scripts/git_config_home_local.sh"
alias git_config_work_local="$DOTFILE_DIR/shared/scripts/git_config_work_local.sh"
alias git_config_home_global="$DOTFILE_DIR/shared/scripts/git_config_home_global.sh"
alias git_config_work_global="$DOTFILE_DIR/shared/scripts/git_config_work_global.sh"
alias tmux_session_init_code="$DOTFILE_DIR/shared/scripts/tmux/tmux_session_init_code.sh"
alias tmux_session_init_config="$DOTFILE_DIR/shared/scripts/tmux/tmux_session_init_config.sh"

alias git-undo="git reset --soft HEAD^"
alias cls="clear"
alias ex="exit"
alias ta="tmux a"
alias oil="nvim +"Oil""
alias vim="nvim"
alias nvimc="nvim --clean"
alias vimm="command vim"
alias wife="nmtdesktop"
alias lg="lazygit"
alias rga="rg --hidden"
alias pn="pnpm"
alias mk="make"
alias cr="cargo run"
alias ck="cargo check"
alias ci="cargo install --path ."

alias notes="cd $ASSET_DIR/vault/ && $EDITOR"
alias pnotes="cd $ASSET_DIR/personal-notes/ && $EDITOR"
alias wnotes="cd $ASSET_DIR/work-notes/ && $EDITOR"
alias plnotes="cd $ASSET_DIR/personal-notes/ && git pull && $EDITOR"
alias wlnotes="cd $ASSET_DIR/work-notes/ && git pull && $EDITOR"

alias conf="cd ~/.config"
alias dot.conf="cd ~/.config"
alias dot="cd $DOTFILE_DIR"
alias dot.dot="cd $DOTFILE_DIR"
alias nixos="cd $ASSET_DIR/nixos-config"

# dot. prefix = points to $DOTFILE_DIR or $ASSET_DIR/nixos* for nixos
alias dot.zsh="$EDITOR $DOTFILE_DIR/shared/.zshrc"
alias dot.tmux="$EDITOR $DOTFILE_DIR/shared/.tmux.conf"
alias dot.nvim="cd $DOTFILE_DIR/shared/nvim"
alias dot.vim="cd $DOTFILE_DIR/shared/nvim"
alias dot.fish="cd $DOTFILE_DIR/shared/fish"
alias dot.nixos="cd $DOTFILE_DIR/nix-hm"

# config. prefix = points to $HOME/.config or $HOME dir
alias config.zsh="$EDITOR $HOME/.zshrc"
alias config.tmux="$EDITOR $HOME/.tmux.conf"
alias config.nvim="cd $HOME/.config/nvim"
alias config.fish="cd $HOME/.config/fish"
alias config.nixos="cd $HOME/.config"

alias config.ohmyzsh="cd $HOME/.oh-my-zsh"

# Firefox configuration (checks both default-release and dev-edition)
alias config.firefox="$EDITOR $HOME/.mozilla/firefox/*.default-release/chrome/userChrome.css || $EDITOR $HOME/.mozilla/firefox/*.dev-edition-default/chrome/userChrome.css"
alias dot.wezterm="$EDITOR $DOTFILE_DIR/desktop/.wezterm.lua"
alias config.wezterm="$EDITOR $HOME/.wezterm.lua"

# i3, sway, and other window managers
alias dot.rofi="cd $DOTFILE_DIR/desktop/rofi"
alias dot.sway="cd $DOTFILE_DIR/desktop/sway"
alias dot.i3rust="$EDITOR $DOTFILE_DIR/desktop/i3status-rust/config.toml"
alias dot.i3="cd $DOTFILE_DIR/desktop/i3"
alias dot.picom="$EDITOR $DOTFILE_DIR/desktop/picom.conf"
alias config.rofi="cd $HOME/.config/rofi"
alias config.sway="cd $HOME/.config/sway"
alias config.i3rust="$EDITOR $HOME/.config/i3status-rust/config.toml"
alias config.i3="$EDITOR $HOME/.config/i3/config"
alias config.picom="$EDITOR $HOME/.config/picom.conf"
alias xrandrscaleup="xrandr --output eDP-1 --scale 0.95x0.95"
alias xrandrscalereset="xrandr --output eDP-1 --scale 1x1"

alias gcmsg='git commit --message'
# alias reader="zathura"
# alias fdupes="rmlint"
# alias adb="$HOME/Android/Sdk/platform-tools/adb"
