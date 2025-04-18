{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    neovim
    vim
    git
    lazygit
    license-generator
    git-ignore
    pass-git-helper
    just
    # tgpt
    # mcfly # terminal history
    tmux
    zellij
    progress
    noti
    topgrade
    ripgrep
    rewrk
    wrk2
    procs
    tealdeer
    # skim #fzf better alternative in rust
    monolith
    aria
    macchina #neofetch alternative in rust
    sd
    ouch
    duf
    du-dust
    fd
    jq
    gh
    trash-cli
    zoxide
    tokei
    fzf
    bat
    mdcat
    pandoc
    lsd
    lsof
    gping
    tre-command
    #felix-fm
    chafa
    #viu

    #TODO:
    # cava

    ncdu
    nix-search-cli
    gnumake
    unzip
    delta # git highlighting
  ];
}
