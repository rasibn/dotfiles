# Bootstrap a new terminal with:
#   1. Install just using the platform package manager below.
#   2. Run the matching `just setup-shell-<platform>` recipe.
#   3. Run a GUI recipe separately if this machine has a desktop.
#
# Examples: `just setup-shell-arch`, `just setup-shell-macos`, `just setup-shell-phone`.
# Dotfile location. direnv can provide DOTFILE_DIR, but this also works when
# just is run directly from the repository.
dotfiles := env_var_or_default("DOTFILE_DIR", justfile_directory())
linux_dir := dotfiles / "desktop" / "linux"

set dotenv-filename := "config.env"
work_email_b64 := env_var_or_default("WORK_EMAIL_B64", "")
home_email_b64 := env_var_or_default("HOME_EMAIL_B64", "")

# ------------------------------ Helpers -----------------------------

link source target:
    mkdir -p "$(dirname "{{target}}")"
    rm -rf "{{target}}"
    ln -s "{{source}}" "{{target}}"

# ------------------------------ Shell -------------------------------

config-bash:
    just link "{{dotfiles}}/shared/.bashrc" "$HOME/.bashrc"
    just link "{{dotfiles}}/shared/.bash_profile" "$HOME/.bash_profile"

config-fish:
    just link "{{dotfiles}}/shared/fish" "$HOME/.config/fish"

config-nvim:
    just link "{{dotfiles}}/shared/nvim" "$HOME/.config/nvim"

config-tmux:
    just link "{{dotfiles}}/shared/.tmux.conf" "$HOME/.tmux.conf"
    rm -rf "$HOME/.tmux/plugins/tpm"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

config-zellij:
    just link "{{dotfiles}}/shared/zellij" "$HOME/.config/zellij"

config-helix:
    just link "{{dotfiles}}/shared/helix" "$HOME/.config/helix"

config-herdr:
    just link "{{dotfiles}}/shared/herdr" "$HOME/.config/herdr"

config-delta:
    git config --global core.pager delta
    git config --global interactive.diffFilter 'delta --color-only'
    git config --global delta.navigate true
    git config --global merge.conflictStyle zdiff3

config-ignore:
    just link "{{dotfiles}}/shared/.ignore" "$HOME/.ignore"

config-lazygit:
    just link "{{dotfiles}}/shared/lazygit" "$HOME/.config/lazygit"

config-zsh:
    rm -rf "$HOME/.oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    just link "{{dotfiles}}/shared/.zshrc" "$HOME/.zshrc"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
    git clone https://github.com/jeffreytse/zsh-vi-mode.git "$HOME/.oh-my-zsh/custom/plugins/zsh-vi-mode"
    sudo chsh -s "$(which zsh)"

setup-shell: config-bash config-fish config-nvim config-tmux config-zellij config-helix config-herdr config-delta config-ignore config-lazygit

# ------------------------------ Install -----------------------------

# Before adding a package, verify its exact name in the target platform's
# official package index. Package names and executable names may differ.
# Record platform-specific names explicitly instead of assuming they match.

# Baseline tools expected in every terminal environment.
install-shell-macos:
    brew install fish neovim zsh tmux zoxide ripgrep fd gh eza bat lazygit fzf herdr git-delta

install-shell-arch:
    yay -S fish neovim zsh tmux zoxide ripgrep fd github-cli eza bat lazygit fzf herdr-bin git-delta

install-shell-phone:
    pkg install fish neovim zoxide ripgrep fd gh eza bat lazygit fzf herdr rust
    cargo install git-delta

# ------------------------------ GUI ---------------------------------

config-wezterm:
    just link "{{dotfiles}}/desktop/.wezterm.lua" "$HOME/.wezterm.lua"

config-ghostty:
    just link "{{dotfiles}}/desktop/ghostty" "$HOME/.config/ghostty"

config-aerospace:
    just link "{{dotfiles}}/desktop/macos/.aerospace.toml" "$HOME/.aerospace.toml"
    defaults write com.apple.dock expose-group-apps -bool true
    killall Dock || true
    defaults write com.apple.spaces spans-displays -bool true
    killall SystemUIServer || true

config-i3:
    just link "{{linux_dir}}/i3" "$HOME/.config/i3"
    just link "{{linux_dir}}/rofi" "$HOME/.config/rofi"
    just link "{{linux_dir}}/i3status-rust" "$HOME/.config/i3status-rust"
    just link "{{linux_dir}}/picom.conf" "$HOME/.config/picom.conf"
    just link "{{linux_dir}}/.Xresources" "$HOME/.Xresources"
    just link "{{linux_dir}}/.profile" "$HOME/.zprofile"
    just link "{{linux_dir}}/.profile" "$HOME/.profile"

config-sway:
    just link "{{linux_dir}}/sway" "$HOME/.config/sway"
    just link "{{linux_dir}}/rofi" "$HOME/.config/rofi"
    just link "{{linux_dir}}/i3status-rust" "$HOME/.config/i3status-rust"

config-hyprland-scrolling:
    just link "{{dotfiles}}/shared/hypr/hyprland-scrolling.lua" "$HOME/.config/hypr/hyprland.lua"

config-hyprland-dwindle:
    just link "{{linux_dir}}/hypr/hyprland.lua" "$HOME/.config/hypr/hyprland.lua"

setup-gui-macos: config-aerospace config-wezterm config-ghostty
setup-gui-i3: config-i3 config-wezterm
setup-gui-sway: config-sway config-wezterm

# ------------------------------ Git ---------------------------------

git-config-work:
    @test -n "{{work_email_b64}}"
    @git config --global user.name "Rasib Nadeem"
    @printf %s "{{work_email_b64}}" | base64 -d | xargs git config --global user.email
    @git config --global init.defaultBranch main
    @echo "Git username:"
    @git config --global user.name
    @echo "Git email:"
    @git config --global user.email

git-config-home:
    @test -n "{{home_email_b64}}"
    @git config --global user.name "Rasib Nadeem"
    @printf %s "{{home_email_b64}}" | base64 -d | xargs git config --global user.email
    @git config --global init.defaultBranch main
    @echo "Git username:"
    @git config --global user.name
    @echo "Git email:"
    @git config --global user.email

# ------------------------------ GUI install -------------------------

install-gui-macos:
    brew tap FelixKratz/formulae
    brew install borders
    brew install --cask font-jetbrains-mono-nerd-font wezterm github
    brew install --cask nikitabobko/tap/aerospace chatgpt

install-gui-i3:
    yay -S i3 i3status-rust gnome-keyring catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd rofi rofi-search-git picom nitrogen flameshot brightnessctl

install-gui-sway:
    yay -S sway swaync swaybg swayidle wl-mirror waybar wl-clipboard grim slurp brightnessctl catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd nwg-look i3status-rust rofi-search-git rofi-wayland gnome-keyring

# ------------------------------ Development -------------------------

install-go-development:
    go install github.com/air-verse/air@latest
    go install github.com/melkeydev/go-blueprint@latest

# ------------------------------ Composed setups ---------------------

setup-shell-macos: install-shell-macos setup-shell
setup-shell-arch: install-shell-arch setup-shell
setup-shell-phone: install-shell-phone setup-shell

setup-macos: setup-shell-macos config-zsh setup-gui-macos git-config-work install-gui-macos
setup-i3-pc: setup-shell-arch config-zsh git-config-home setup-gui-i3 install-gui-i3
setup-sway-pc: setup-shell-arch config-zsh git-config-home setup-gui-sway install-gui-sway
setup-phone: setup-shell-phone git-config-home
