{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    zed-editor

    xfce.thunar
    xfce.thunar-volman # for removable drives
    xfce.tumbler # for thumbnails
    vesktop

    mpv
    feh
    
    # E-book readers
    foliate
    zathura

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
