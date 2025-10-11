{
  config,
  pkgs,
  ...
}: let
  cliTools = with pkgs; [
    inotify-tools # for golang templ's hotreload
    unzip
    lsof
    ncdu
    fzf
    ripgrep
    fd
    bat
  ];

  emulatorsApps = with pkgs; [
    ghostty
    wezterm
  ];

  tuiApps = with pkgs; [
    htop-vim
    slumber
    zoxide
    yazi
    # lf # file manager in golang
  ];
in {
  programs = {
    # television = {
    #   enable = true;
    #   enableFishIntegration = true;
    # };
  };

  # Terminal packages
  home.packages =
    cliTools
    ++ tuiApps
    ++ emulatorsApps;
}
