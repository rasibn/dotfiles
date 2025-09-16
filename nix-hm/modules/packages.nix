{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  proji = pkgs.buildGoModule {
    pname = "proji";
    version = "1.0.0";
    src = ../../shared/scripts/golang/proji;
    vendorHash = "sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=";
    meta = with pkgs.lib; {
      description = "Tmux session manager with directory selection";
      license = licenses.mit;
    };
  };
  vimi = pkgs.buildGoModule {
    pname = "vimi";
    version = "1.0.0";
    src = ../../shared/scripts/golang/vimi;
    vendorHash = "sha256-2adRLsTSd0vTGcis5FfOT5ZFgB420nvDqHkEEopmgec=";
    meta = with pkgs.lib; {
      description = "fzf based file picker for neovim";
      license = licenses.mit;
    };
  };
in {
  home.packages = with pkgs; [
    # Desktop utilities
    swaylock-effects
    wl-clipboard-rs
    pavucontrol
    xfce.thunar
    mpv
    google-chrome
    udiskie

    jdt-language-server
    maven
    jdk

    # Wayland/Hyprland
    hyprpaper
    hypridle
    rofi-wayland-unwrapped
    # nwg-displays
    waypaper

    # Screenshots
    hyprshot
    swappy

    # System tools
    unzip
    htop-vim
    ncdu
    fd
    bat

    # Development - Core
    direnv
    sqlite
    gnumake
    gcc

    gnome-keyring
    ghostty

    # Development - Node/JS
    nodejs
    pnpm
    bun
    typescript-language-server
    svelte-language-server
    tailwindcss-language-server
    prettierd

    # Development - Python
    # uv
    # python3
    # ruff
    # pyright

    # Development - Go
    gopls
    gofumpt
    gotools
    air
    templ

    zed-editor

    # Development - Rust
    rustup

    # Development - Nix
    nil # nix lsp
    alejandra # nix formatter

    # Development - Lua
    stylua

    # Development tools
    vscode
    bruno
    obsidian
    # stremio
    # qbittorrent-enhanced
    transmission_4-gtk
    mpv
    feh

    # Docker
    docker-compose

    # AI tools
    opencode
    lf # life manager

    # Fonts
    nerd-fonts.caskaydia-cove
    font-awesome

    # Custom packages
    proji
    vimi
    inputs.zen-browser.packages."${system}".default
  ];
}
