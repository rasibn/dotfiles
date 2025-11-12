{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    zed-editor

    kdePackages.dolphin
    vesktop

    mpv
    feh

    maestral-gui

    # Development tools
    vscode
    bruno

    # stremio
    # qbittorrent-enhanced
    transmission_4-gtk

    google-chrome
    # inputs.zen-browser.packages."${system}".default
  ];

  programs.firefox.enable = true;
  # programs.brave.enable = true;
}
