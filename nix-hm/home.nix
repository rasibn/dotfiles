{
  config,
  pkgs,
  ...
}: let
  dotfiles_dir = "${config.home.homeDirectory}/assets/dotfiles";
  assets_dir = "${config.home.homeDirectory}/assets";
  works_dir = "${config.home.homeDirectory}/work";
  projects_dir = "${config.home.homeDirectory}/projects";
in {
  home = {
    username = "rasib";
    homeDirectory = "/home/rasib";
    packages = with pkgs; [
      swaylock-effects

      wl-clipboard-rs
      pavucontrol

      nil # nix lsp
      alejandra # nix formator

      kdePackages.dolphin
      google-chrome

      hyprpaper
      hypridle
      rofi

      gleam
      erlang_28

      uv
      python3

      gopls
      gofumpt
      gotools

      obsidian

      unzip

      bruno

      bat

      svelte-language-server

      nwg-displays
      btop
      tailwindcss-language-server
      typescript-language-server
      templ
      gnumake
      ruff
      pyright
      vscode
      direnv
      sqlite
      ncdu
      typescript-language-server
      pnpm
      waypaper
      nodejs
      rustup
      air
      gcc
      fd

      opencode

      nerd-fonts.caskaydia-cove
      font-awesome

      udiskie

      docker-compose

      # screenshots
      hyprshot
      swappy
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
      ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/rofi";
      ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/shared/nvim";
      ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/.wezterm.lua";
      ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr";
      ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/waybar";
    };
  };

  #	wayland.windowManager.hyprland = {
  #		enable = true;
  #	};

  services = {
    mako = {
      enable = true;
      extraConfig = ''
        sort=-time
        layer=overlay
        background-color=#1e222a7f
        width=450
        height=150
        border-size=0
        border-color=#14181d
        border-radius=10
        icons=0
        max-icon-size=64
        default-timeout=5000
        ignore-timeout=0
        font="HarmonyOS Sans SC" 16
        margin=12
        padding=12,20

        [urgency=low]
        border-color=#cccccc

        [urgency=normal]
        border-color=#99c0d0

        [urgency=critical]
        border-color=#bf616a
        default-timeout=0
      '';
    };
    swayosd.enable = true;
    cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };

  programs = {
    wezterm.enable = true;
    firefox.enable = true;
    waybar.enable = true;
    zoxide.enable = true;
    tmux = {
      enable = true;
      baseIndex = 1;
      mouse = true;
      escapeTime = 0;
      keyMode = "vi";

      # Remap prefix from 'C-b' to 'C-a'
      prefix = "C-a";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        pain-control
      ];

      extraConfig = ''
        set-option -g renumber-windows on

        # Scroll speed configuration
        set -g @scroll-speed-num-lines-per-scroll 2

        # Bind 'v' to copy-mode
        bind 'v' copy-mode

        run-shell "$DOTFILE_DIR/shared/scripts/tmux-power.tmux"

        # True colours support
        set -ga terminal-overrides ",xterm-256color:Tc"
        set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
        # Underscore colours - needs tmux-3.0
        set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
      '';
    };

    go.enable = true;
    bun = {
      enable = true;
      enableGitIntegration = true;
    };

    fzf.enable = true;
    ripgrep.enable = true;
    fish = {
      enable = true;
      shellAliases = {
        vim = "nvim";
        nvimi = "python $DOTFILE_DIR/shared/scripts/python/nvimi.py";
        proji = "python $DOTFILE_DIR/shared/scripts/python/proji.py";
        vimi = "$DOTFILE_DIR/shared/scripts/nvim-fzf.sh";
        nswitchu = "sudo nixos-rebuild switch --flake $DOTFILE_DIR/nix-hm/";
        cls = "clear";
        ta = "tmux a";
        lg = "lazygit";
      };
      shellAbbrs = {
        # system aliases
        hm = "home-manager";
        hms = "home-manager switch";
        hme = "home-manager edit";
        # git aliases
        gst = "git status";
        ga = "git add";
        gaa = "git add .";
        gcm = "git commit -m";
        gl = "git pull";
        gp = "git push";
        git-undo = "git reset --soft HEAD^";
        # other aliases
      };
      shellInit = ''
        set -g fish_key_bindings fish_vi_key_bindings

        if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" -eq 1
            dbus-run-session Hyprland
        else
            if not set -q TMUX
                tmux attach || tmux new -s base
            end
        end

        zoxide init --cmd cd fish | source
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
