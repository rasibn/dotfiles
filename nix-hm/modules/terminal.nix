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
    # ghostty
    wezterm
  ];

  tuiApps = with pkgs; [
    htop-vim
    slumber
    helix
    neovim
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
    enable = true;
    enableFishIntegration = true;
    # television = {
    #   enable = true;
    #   enableFishIntegration = true;
    # };
    # zellij = {
    #   enable = true;
    #   settings = {
    #     keybinds = "tmux";
    #   };
    # };
  };

  # Terminal packages
  home.packages =
    cliTools
    ++ devTools
    ++ tuiApps
    ++ emulatorsApps;
}
