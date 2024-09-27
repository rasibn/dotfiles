{ config, pkgs, ... }:

{
  home.username = "rasib";
  home.homeDirectory = "/home/rasib";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  nixpkgs.config.allowUnfree = true;

  programs.git = {
    enable = true;
    userName = "rasibn";
    userEmail = "rasibnadeem101@gmail.com";
  };

  home.packages = [
    pkgs.htop
    pkgs.neovim
    pkgs.vscode
    pkgs.gh
    pkgs.ripgrep
    pkgs.wezterm
    pkgs.zoxide
    pkgs.rustup
    pkgs.helix
    pkgs.zellij
    pkgs.vifm
    pkgs.fzf
    (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
  ".config/nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/components/nvim";
  };
 ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/computer/.wezterm.lua";
  ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/nixos/fish";
 ".config/vifm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Projects/dotfiles/components/vifm";
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
     EDITOR = "hx";
     BROWSER = "firefox";
     TERMINAL = "wezterm2";
  };

  programs.home-manager.enable = true;
}
