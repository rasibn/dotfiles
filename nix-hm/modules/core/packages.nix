{
  config,
  pkgs,
  proji,
  nvimi,
  ...
}: {
  home.packages = with pkgs; [
    # Desktop utilities
    swaylock-effects
    wl-clipboard-rs
    pavucontrol
    kdePackages.dolphin
    google-chrome
    udiskie

    # Wayland/Hyprland
    hyprpaper
    hypridle
    rofi
    nwg-displays
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

    # Development - Node/JS
    nodejs
    pnpm
    bun
    typescript-language-server
    svelte-language-server
    tailwindcss-language-server
    prettier

    # Development - Python
    uv
    python3
    ruff
    pyright

    # Development - Go
    gopls
    gofumpt
    gotools
    air
    templ

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

    # Docker
    docker-compose

    # AI tools
    opencode
    lf

    # Fonts
    nerd-fonts.caskaydia-cove
    font-awesome

    # Custom packages
    proji
    nvimi
  ];
}
