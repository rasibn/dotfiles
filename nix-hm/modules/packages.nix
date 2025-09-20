{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
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
    biome
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

    gleam
    erlang_28
    rebar3
    inotify-tools

    # git
    jujutsu

    zed-editor

    # Development - Rust
    rustup

    # Development - Nix
    nil # nix lsp
    alejandra # nix formatter

    # Development - Lua
    stylua

    lsof

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
    inter

    inputs.zen-browser.packages."${system}".default
  ];
}
