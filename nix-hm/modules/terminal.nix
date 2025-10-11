{
  config,
  pkgs,
  ...
}: let
  cliTools = with pkgs; [
    unzip
    lsof
    ncdu
    fzf
    ripgrep
    fd
    bat
    # jujutsu  # git alternative
  ];

  devTools = with pkgs; [
    inotify-tools # for golang templ's hotreload
    direnv
    sqlite
    gnumake
    docker-compose
    gcc
  ];

  emulatorsApps = with pkgs; [
    ghostty
    wezterm
  ];

  tuiApps = with pkgs; [
    htop-vim
    slumber
    zoxide
    opencode
    yazi
    # lf # file manager in golang
  ];
in {
  programs = {
    lazygit.enable = true;
    lazydocker.enable = true;
    gh.enable = true;
    television = {
      enable = true;
      enableFishIntegration = true;
    };
  };

  # Terminal packages
  home.packages =
    cliTools
    ++ devTools
    ++ tuiApps
    ++ emulatorsApps;
}
