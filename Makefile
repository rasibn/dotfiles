.PHONY: all setup_macos setup_phone setup_nixos setup_i3_pc setup_i3_laptop \
        config_nvim_mob config_nvim config_fish config_zsh config_vifm config_tmux config_zellij \
        config_wezterm config_i3_ui config_xprofile config_i3 config_rofi config_i3status_rust config_picom config_xresources \
        git_config_nvim git_config_work git_config_home config_nixos \
        install_i3_pc install_macos install_phone

# ------------------------------ CLIs ---------------------------------

config_nvim:
	rm ~/.config/nvim; ln -s $(HOME)/Projects/dotfiles/components/nvim ~/.config/nvim
config_nvim_mob:
	rm ~/.config/nvim; ln -s $(HOME)/Projects/dotfiles/mobile/nvim ~/.config/nvim

# SHELL
config_fish:
	rm -rf ~/.config/fish; ln -s $(HOME)/Projects/dotfiles/components/fish ~/.config/fish

config_zsh:
	rm -rf ~/.oh-my-zsh;
	sh -c "$$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	rm ~/.zshrc; ln -s $(HOME)/Projects/dotfiles/components/.zshrc ~/.zshrc
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-completions.git ~/.oh-my-zsh/custom/plugins/zsh-completions
	git clone https://github.com/jeffreytse/zsh-vi-mode.git ~/.oh-my-zsh/custom/plugins/zsh-vi-mode
	chsh -s $$(which zsh)

# MULTIPLEX
config_tmux:
	rm ~/.tmux.conf; ln -s $(HOME)/Projects/dotfiles/components/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm;
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

config_tmux_mob:
	rm ~/.tmux.conf; ln -s $(HOME)/Projects/dotfiles/mobile/.tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm; 
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

config_zellij:
	rm ~/.config/zellij; ln -s $(HOME)/Projects/dotfiles/components/zellij ~/.config/zellij

# OTHER
config_vifm:
	rm ~/.config/vifm; ln -s $(HOME)/Projects/dotfiles/components/vifm ~/.config/vifm

# ------------------------------ Terminal Emulator -----------------

config_wezterm:
	rm ~/.wezterm.lua; ln -s $(HOME)/Projects/dotfiles/ui/.wezterm.lua ~/.wezterm.lua

# ------------------------------ I3WM ------------------------------

config_i3_ui: config_xprofile config_i3 config_rofi config_i3status_rust config_picom config_xresources

config_profile:
	rm ~/.zprofile; ln -s $(HOME)/Projects/dotfiles/ui/.profile ~/.zprofile
	rm ~/.profile; ln -s $(HOME)/Projects/dotfiles/ui/.profile ~/.profile

config_sway:
	rm -rf ~/.config/sway;
	ln -s $(HOME)/Projects/dotfiles/ui/sway ~/.config/sway

config_i3:
	rm ~/.config/i3; ln -s $(HOME)/Projects/dotfiles/ui/i3 ~/.config/i3

config_rofi:
	rm ~/.config/rofi; ln -s $(HOME)/Projects/dotfiles/ui/rofi ~/.config/rofi

config_i3status_rust:
	rm ~/.config/i3status-rust; ln -s $(HOME)/Projects/dotfiles/ui/i3status-rust ~/.config/i3status-rust

config_picom:
	rm ~/.config/picom.conf; ln -s $(HOME)/Projects/dotfiles/ui/picom.conf ~/.config/picom.conf

# For laptop screen-ratio
config_xresources:
	rm ~/.Xresources; ln -s $(HOME)/Projects/dotfiles/ui/.Xresources ~/.Xresources

config_aerospace:
	rm ~/.aerospace.toml; ln -s $(HOME)/Projects/dotfiles/ui/macos/.aerospace.toml ~/.aerospace.toml

# ------------------------------ GIT -----------------------------

git_config_nvim:
	git config --global core.excludesfile ~/.gitignore
	echo "**/Session.vim" > ~/.gitignore

git_config_work:
	@if [ ! -f "$(HOME)/Projects/dotfiles/secrets.sh" ]; then \
		echo "secrets.sh file not found."; \
		exit 1; \
	fi
	. $(HOME)/Projects/dotfiles/secrets.sh && \
	if [ -z "$$WORK_EMAIL" ]; then \
		echo "WORK_EMAIL environment variable is not set."; \
		exit 1; \
	fi && \
	git config --global user.name "Rasib Nadeem" && \
	git config --global user.email "$$WORK_EMAIL" && \
	git config --global init.defaultBranch main
	echo "Configured Git for work with email: $$WORK_EMAIL"

git_config_home:
	@if [ ! -f "$(HOME)/Projects/dotfiles/secrets.sh" ]; then \
		echo "secrets.sh file not found."; \
		exit 1; \
	fi
	. $(HOME)/Projects/dotfiles/secrets.sh && \
	if [ -z "$$HOME_EMAIL" ]; then \
		echo "HOME_EMAIL environment variable is not set."; \
		exit 1; \
	fi && \
	git config --global user.name "Rasib Nadeem" && \
	git config --global user.email "$$HOME_EMAIL" && \
	git config --global init.defaultBranch main
	echo "Configured Git for home with email: $$HOME_EMAIL"

# ----------------------------- NIXOS -----------------------------

config_nixos:
	ln -s $(HOME)/Projects/dotfiles/nixos/home-manager $(HOME)/.config/home-manager
	sudo ln -s $(HOME)/Projects/dotfiles/nixos/configuration.nix /etc/nixos/configuration.nix

# ----------------------------- INSTALL --------------------------

install_i3_pc:
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat
	yay -S htop-vim catppuccin-gtk-theme-mocha rofi-search-git catppuccin-cursors-mocha ttf-jetbrains-mono-nerd picom flameshot nitrogen i3status-rs rofi  brightnessctl gnome-keyring

install_sway_pc:
	yay -S go
	yay -S neovim zsh tmux vifm vim eza zoxide fd rg bat
	yay -S sway swaync slurp htop-vim catppuccin-gtk-theme-mocha rofi-search-git catppuccin-cursors-mocha ttf-jetbrains-mono-nerd waybar rofi-wayland wl-clipboard grim swaybg brightnessctl i3status-rs nwg-look gnome-keyring

install_macos:
	brew install nvim zsh tmux eza zoxide fd gh bat gh

install_macos_cask:
	brew install --cask font-jetbrains-mono-nerd-font wezterm
	brew install --cask nikitabobko/tap/aerospace chatgpt

install_vm:
	pkg install fish nvim tmux zoxide fd eza bat

# ----------------------------- PUBLIC COMMANDS -------------------

setup_macos:  config_nvim     config_tmux config_zsh git_config_work git_config_nvim                            install_macos config_aerospace
setup_i3_pc:  config_nvim     config_tmux config_zsh git_config_home git_config_nvim config_fish config_wezterm install_i3_pc config_i3_ui
setup_nixos:  config_nvim     config_tmux            git_config_home git_config_nvim config_fish config_wezterm               config_nixos
setup_phone:  config_nvim_mob config_tmux_mob            git_config_home             config_fish                install_vm
setup_sway_pc:  config_nvim     config_tmux config_zsh git_config_home git_config_nvim config_fish config_wezterm  config_sway config_rofi config_i3status_rust
setup_vm:     config_nvim     config_tmux_mob            git_config_home             config_fish                install_vm

setup_i3_laptop: setup_i3 config_xresources
