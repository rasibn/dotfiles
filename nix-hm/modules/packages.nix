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

    inotify-tools

    # git options
    # jujutsu

    zed-editor



    slumber

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
