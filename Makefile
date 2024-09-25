DIR := $(DOTFILE_DIR)

# ------------------------------ CLIs ---------------------------------

test:
	echo "Hello world"
	echo "$(DOTFILE_DIR)"

.PHONY: config_nvim
config_nvim:
	rm ~/.config/nvim; ln -s $(DIR)/components/nvim ~/.config/nvim

.PHONY: config_nvim_mob
config_nvim_mob:
	rm ~/.config/nvim; ln -s $(DIR)/mobile/nvim ~/.config/nvim

# SHELL
.PHONY: config_fish
config_fish:
	rm -rf ~/.config/fish; ln -s $(DIR)/components/fish ~/.config/fish

.PHONY: config_zsh
config_zsh:
	rm -rf ~/.oh-my-zsh;
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm ~/.zshrc; ln -s $(DIR)/components/.zshrc ~/.zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
	chsh -s $$(which zsh)

# MULTIPLEX
.PHONY: config_tmux
config_tmux:
	rm ~/.tmux.conf; ln -s $(DIR)/components/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm;
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

.PHONY: config_tmux_mob
config_tmux_mob:
	rm ~/.tmux.conf; ln -s $(DIR)/mobile/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm; 
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# ------------------------------ Terminal Emulator -----------------

.PHONY: config_wezterm
config_wezterm:
	rm ~/.wezterm.lua; ln -s $(DIR)/ui/.wezterm.lua ~/.wezterm.lua

# ------------------------------ I3WM ------------------------------

.PHONY: config_i3_ui
config_i3_ui: config_xprofile config_i3 config_rofi config_i3status_rust config_picom config_xresources

.PHONY: config_xprofile
config_xprofile:
	rm ~/.zprofile; ln -s $(DIR)/ui/.profile ~/.zprofile
	rm ~/.profile; ln -s $(DIR)/ui/.profile ~/.profile

.PHONY: config_sway
config_sway:
	rm -rf ~/.config/sway;
	ln -s $(DIR)/ui/sway ~/.config/sway

.PHONY: config_i3
config_i3:
	rm ~/.config/i3; ln -s $(DIR)/ui/i3 ~/.config/i3

.PHONY: config_rofi
config_rofi:
	rm ~/.config/rofi; ln -s $(DIR)/ui/rofi ~/.config/rofi

.PHONY: config_i3status_rust
config_i3status_rust:
	rm ~/.config/i3status-rust; ln -s $(DIR)/ui/i3status-rust ~/.config/i3status-rust

.PHONY: config_picom
config_picom:
	rm ~/.config/picom.conf; ln -s $(DIR)/ui/picom.conf ~/.config/picom.conf

.PHONY: config_xresources
config_xresources:
	rm ~/.Xresources; ln -s $(DIR)/ui/.Xresources ~/.Xresources

.PHONY: config_aerospace
config_aerospace:
	rm ~/.aerospace.toml; ln -s $(DIR)/ui/macos/.aerospace.toml ~/.aerospace.toml

# ------------------------------ GIT -----------------------------

.PHONY: git_config_work
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

.PHONY: git_config_home
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

.PHONY: global_ignore
global_ignore:
	rm ~/.ignore; ln -s $(DIR)/components/.ignore ~/.ignore

# ----------------------------- NIXOS -----------------------------

.PHONY: config_nixos
config_nixos:
	ln -s $(DIR)/nixos/home-manager $(HOME)/.config/home-manager
	sudo ln -s $(DIR)/nixos/configuration.nix /etc/nixos/configuration.nix

# ----------------------------- INSTALL --------------------------

.PHONY: install_i3_pc
install_i3_pc: global_ignore
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat starship htop-vim
	yay -S \
			brightnessctl i3status-rs gnome-keyring \
			catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd \
			rofi rofi-search-git picom nitrogen flameshot \
			gnome-keyring


.PHONY: install_sway_pc
install_sway_pc: global_ignore
	yay -S go
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat starship htop-vim
	yay -S \
			sway swaync swaybg swayidle wl-mirror waybar wl-clipboard grim slurp brightnessctl \
			catppuccin-gtk-theme-mocha catppuccin-cursors-mocha ttf-jetbrains-mono-nerd nwg-look \
			i3status-rs rofi-search-git rofi-wayland \
			gnome-keyring

.PHONY: install_macos
install_macos: global_ignore
	brew install nvim zsh tmux eza zoxide fd ripgrep gh bat gh starship

.PHONY: install_macos_cask
install_macos_cask:
	brew install --cask font-jetbrains-mono-nerd-font wezterm github
	brew install --cask nikitabobko/tap/aerospace chatgpt

.PHONY: install_vm
install_vm: global_ignore
	pkg install fish nvim tmux zoxide fd eza bat
	rm ~/.ignore; ln -s $(DIR)/components/.ignore ~/.ignore

# ----------------------------- PUBLIC COMMANDS -------------------

.PHONY: setup_macos
setup_macos: config_nvim config_tmux config_zsh config_aerospace config_wezterm git_config_work install_macos 

.PHONY: resetup_macos
resetup_macos: config_nvim config_tmux config_aerospace config_wezterm

.PHONY: setup_i3_pc
setup_i3_pc: config_nvim config_tmux config_zsh git_config_home config_fish config_wezterm install_i3_pc config_i3_ui

.PHONY: setup_nixos
setup_nixos: config_nvim config_tmux git_config_home config_fish config_wezterm config_nixos

.PHONY: resetup_nixos
resetup_nixos: config_nvim config_tmux git_config_home config_fish config_wezterm

.PHONY: setup_phone
setup_phone: config_nvim_mob config_tmux_mob git_config_home config_fish install_vm

.PHONY: resetup_phone
resetup_phone: config_nvim_mob config_tmux_mob git_config_home config_fish

.PHONY: setup_sway_pc
setup_sway_pc: config_nvim config_tmux config_zsh git_config_home config_fish config_wezterm config_sway config_rofi config_i3status_rust

.PHONY: setup_vm
setup_vm: config_nvim config_tmux_mob git_config_home config_fish install_vm

.PHONY: setup_i3_laptop
setup_i3_laptop: setup_i3_pc config_xresources
