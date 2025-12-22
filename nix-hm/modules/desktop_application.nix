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
    # jetbrains.idea-community # or jetbrains.idea-ultimate
    bruno
    brave

    # stremio
    # qbittorrent-enhanced
    transmission_4-gtk

    google-chrome
    # inputs.zen-browser.packages."${system}".default
  ];

  programs.firefox.enable = true;
}
