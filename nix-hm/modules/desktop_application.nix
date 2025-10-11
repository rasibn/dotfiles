{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  home.packages = with pkgs; [
    google-chrome

    zed-editor

    kdePackages.dolphin

    mpv
    feh

    # Development tools
    vscode
    bruno
    obsidian
    # stremio
    # qbittorrent-enhanced
    transmission_4-gtk

    inputs.zen-browser.packages."${system}".default
  ];

  # programs.firefox.enable = true;
  programs.brave.enable = true;
}
