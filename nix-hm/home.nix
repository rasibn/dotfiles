{ config, pkgs, ... }:

let 
	dotfiles_dir = "${config.home.homeDirectory}/assets/dotfiles";
	assets_dir = "${config.home.homeDirectory}/assets";
	works_dir = "${config.home.homeDirectory}/work";
	projects_dir = "${config.home.homeDirectory}/projects";
in
{
	home = {
		username = "rasib";
		homeDirectory = "/home/rasib";
		packages = with pkgs; [
			wl-clipboard-rs
			pavucontrol
			gnumake
      nodejs
			gcc
		];
		sessionVariables = {
		    EDITOR = "vim";
		    PROJECT_DIR = projects_dir;
		    WORK_DIR = works_dir;
		    ASSET_DIR = assets_dir;
		    DOTFILE_DIR = dotfiles_dir;
		  };
		stateVersion = "24.11";
		file = {
			".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/shared/nvim";
			".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/shared/.tmux.conf";
			".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/.wezterm.lua";
			".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr";
		};
	};

#	wayland.windowManager.hyprland = {
#		enable = true;
#		extraConfig = builtins.readFile ./hyprland.conf; 
#	};

	  services = {
	    cliphist = {
	      enable = true;
	      allowImages = true;
	      extraOptions = [ "-max-dedupe-search" "10" "-max-items" "500" ];
	    }; 
    };

	programs= {
		wezterm.enable = true;
		firefox.enable = true;
		waybar.enable = true;
		wofi.enable = true;
		tmux.enable = true;
		rofi.enable = true;
		go.enable = true;

    bun = {
      enable = true;
      enableGitIntegration = true;
    };

    ripgrep.enable = true;
    fish = {
      enable = true;
      shellAliases = {
          vim = "nvim";
      };
      shellAbbrs = {
        # system aliases
        hm = "home-manager";
        hms = "home-manager switch";
        hme = "home-manager edit";
        cls = "clear";
        nswitchu = "sudo nixos-rebuild switch --flake $DOTFILE_DIR/nix-hm/";
        # git aliases
        gst = "git status";
        ga = "git add";
        gaa = "git add .";
        gcm = "git commit -m";
        gl = "git pull";
        gp = "git push";
        git-undo = "git reset --soft HEAD^";
        # other aliases
        lg = "lazygit";
      };
      shellInit = ''
        set fish_vi_force_cursor
        set fish_vi_keybindings
      '';
    };

    lazygit.enable = true;
		gh.enable = true;
		git = {
			enable = true;
			userName = "Rasib Nadeem";
			userEmail = "rasibnadeem101@gmail.com";
			delta.enable = true;
			extraConfig = {
				init.defaultBranch = "main";
			};
		};
	};
}
