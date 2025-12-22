DIR := $(DOTFILE_DIR)
LINUX_DIR = $(DIR)/desktop/linux

# ------------------------------ CLIs ---------------------------------

test:
	echo "Hello world"
	echo "$(DOTFILE_DIR)"

config_nvim:
	rm ~/.config/nvim; ln -s $(DIR)/shared/nvim ~/.config/nvim

config_nix_hm:
	# add flakes instruction to /etc/configuration.nix nix.settings.experimental
	# rm ~/hardware-config
	# copy from /etc/
	# nixos-rebuilt switch flake run .

# SHELL
config_fish:
	rm -rf ~/.config/fish; ln -s $(DIR)/shared/fish ~/.config/fish

config_zellij:
	rm -rf ~/.config/zellij; ln -s $(DIR)/shared/zellij ~/.config/zellij

config_helix:
	rm -rf ~/.config/helix; ln -s $(DIR)/shared/helix ~/.config/helix

config_zed:
	mkdir -p ~/.config/zed
	rm -f ~/.config/zed/settings.json; ln -s $(DIR)/shared/zed/settings.json ~/.config/zed/settings.json
	rm -f ~/.config/zed/keymap.json; ln -s $(DIR)/shared/zed/keymap.json ~/.config/zed/keymap.json
	

config_delta:
	git config --global core.pager delta
	git config --global interactive.diffFilter 'delta --color-only'
	git config --global delta.navigate true
	git config --global merge.conflictStyle zdiff3


config_idea_vim:
	rm ~/.ideavimrc; ln -s $(DIR)/shared/.ideavimrc ~/.ideavimrc


config_idea:
	rm ~/.ideavimrc; ln -s $(DIR)/shared/.ideavimrc ~/.ideavimrc

config_zsh:
	rm -rf ~/.oh-my-zsh;
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm ~/.zshrc; ln -s $(DIR)/shared/.zshrc ~/.zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
	sudo chsh -s $$(which zsh)

# MULTIPLEX
config_tmux:
	rm ~/.tmux.conf; ln -s $(DIR)/shared/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm;
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ------------------------------ Terminal Emulator -----------------

config_wezterm:
	rm ~/.wezterm.lua; ln -s $(DIR)/desktop/.wezterm.lua ~/.wezterm.lua

# ------------------------------ I3WM ------------------------------

config_i3_desktop: config_xprofile config_i3 config_rofi config_i3status_rust config_picom config_xresources

config_xprofile:
	rm ~/.zprofile; ln -s $(LINUX_DIR)/.profile ~/.zprofile
	rm ~/.profile; ln -s $(LINUX_DIR)/.profile ~/.profile

config_sway:
	rm -rf ~/.config/sway;
	ln -s $(LINUX_DIR)/sway ~/.config/sway

config_i3:
	rm ~/.config/i3; ln -s $(LINUX_DIR)/i3 ~/.config/i3

config_rofi:
	rm ~/.config/rofi; ln -s $(LINUX_DIR)/rofi ~/.config/rofi

config_i3status_rust:
	rm ~/.config/i3status-rust; ln -s $(LINUX_DIR)/i3status-rust ~/.config/i3status-rust

config_picom:
	rm ~/.config/picom.conf; ln -s $(LINUX_DIR)/picom.conf ~/.config/picom.conf

config_xresources:
	rm ~/.Xresources; ln -s $(LINUX_DIR)/.Xresources ~/.Xresources

config_aerospace:
	rm ~/.aerospace.toml; ln -s $(DIR)/desktop/macos/.aerospace.toml ~/.aerospace.toml
	brew tap FelixKratz/formulae
	brew install borders
	defaults write com.apple.dock expose-group-apps -bool true && killall Dock # mission control
	defaults write com.apple.spaces spans-displays -bool true && killall SystemUIServer # display have separate spaces

# ------------------------------ GIT -----------------------------

git_config_work:
	@if [ ! -f "$(DIR)/secrets.sh" ]; then \
		echo "secrets.sh file not found."; \
		exit 1; \
	fi
	. $(DIR)/secrets.sh && \
	if [ -z "$$WORK_EMAIL" ]; then \
		echo "WORK_EMAIL environment variable is not set."; \
		exit 1; \
	fi && \
	git config --global user.name "Rasib Nadeem" && \
	git config --global user.email "$$WORK_EMAIL" && \
	git config --global init.defaultBranch main
	echo "Configured Git for work with email: $$WORK_EMAIL"

git_config_home:
	@if [ ! -f "$(DIR)/secrets.sh" ]; then \
		echo "secrets.sh file not found."; \
		exit 1; \
	fi
	. $(DIR)/secrets.sh && \
	if [ -z "$$HOME_EMAIL" ]; then \
		echo "HOME_EMAIL environment variable is not set."; \
		exit 1; \
	fi && \
	git config --global user.name "Rasib Nadeem" && \
	git config --global user.email "$$HOME_EMAIL" && \
	git config --global init.defaultBranch main
	echo "Configured Git for home with email: $$HOME_EMAIL"

global_ignore:
	rm ~/.ignore; ln -s $(DIR)/shared/.ignore ~/.ignore

# ----------------------------- NIXOS -----------------------------

config_nix_home:
	ln -s $(DIR)/nixos/home-manager $(HOME)/.config/home-manager
	sudo ln -s $(DIR)/nixos/configuration.nix /etc/nixos/configuration.nix

config_nixos:
	rm /etc/nixos/configuration.nix; ln -s $(DIR)/nixos/configuration.nix /etc/nixos/configuration.nix

# ----------------------------- INSTALL --------------------------

install_i3_pc: global_ignore
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat starship htop-vim
	yay -S \
			brightnessctl i3status-rust gnome-keyring \
			catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd \
			rofi rofi-search-git picom nitrogen flameshot \
			gnome-keyring

install_sway_pc: global_ignore
	yay -S go
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat starship htop-vim
	yay -S \
			sway swaync swaybg swayidle wl-mirror waybar wl-clipboard grim slurp brightnessctl \
			catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd nwg-look \
			i3status-rust rofi-search-git rofi-wayland \
			gnome-keyring

install_macos: global_ignore
	brew install nvim zsh tmux eza zoxide fd ripgrep gh bat gh starship fzf direnv

install_macos_cask:
	brew install --cask font-jetbrains-mono-nerd-font wezterm github
	brew install --cask nikitabobko/tap/aerospace chatgpt

install_phone: global_ignore
	pkg install fish nvim tmux zoxide fd gh eza bat lazygit fzf
	rm ~/.ignore; ln -s $(DIR)/shared/.ignore ~/.ignore

install_go_development:
	go install github.com/air-verse/air@latest
	go install github.com/melkeydev/go-blueprint@latest

# ----------------------------- PUBLIC COMMANDS -------------------

setup_macos: config_nvim config_tmux config_zsh config_aerospace config_wezterm git_config_work install_macos 

resetup_macos: config_nvim config_tmux config_aerospace config_wezterm

setup_i3_pc: config_nvim config_tmux config_zsh git_config_home config_fish config_wezterm install_i3_pc config_i3_desktop

setup_nixos: config_nvim config_tmux git_config_home config_fish config_wezterm config_nix_home

resetup_nixos: config_nvim config_tmux git_config_home config_fish config_wezterm

# setup phone or terminal vm
setup_phone: config_nvim config_tmux git_config_home config_fish install_phone

resetup_phone: config_nvim config_tmux git_config_home config_fish
# :MasonInstall --target=linux_arm64_gnu lua-language-server
# :MasonInstall --target=linux_arm64_gnu stylua

setup_sway_pc: config_nvim config_tmux config_zsh git_config_home config_fish config_wezterm config_sway config_rofi config_i3status_rust

setup_i3_laptop: setup_i3_pc config_xresources
