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
    tokei
    railway
    jujutsu # git alternative
  ];

  devTools = with pkgs; [
    inotify-tools # for golang templ's hotreload
    jujutsu
    nix-direnv
    direnv
    sqlite
    gnumake
    docker-compose
    tree-sitter
    gh-dash
    difftastic
  ];

  emulatorsApps = with pkgs; [
    ghostty
    wezterm
  ];

  tuiApps = with pkgs; [
    htop-vim
    slumber
    helix
    neovim
    zoxide
    opencode
    # lf # file manager in golang
  ];
in {
  programs = {
    lazygit.enable = true;
    lazydocker.enable = true;
    gh.enable = true;
    yazi = {
      enable = true;
      settings = {
        mgr = {
          layout = "auto";
        };
        preview = {
          max_width = 0;
        };
      };
    };
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
