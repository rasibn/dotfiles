{
  config,
  ...
}: let
  dotfilesDirectory = "${config.home.homeDirectory}/assets/dotfiles";
in {
  imports = [
    ./git.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    DOTFILE_DIR = dotfilesDirectory;
  };

  home.file = {
    ".bashrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/.bashrc";
    ".bash_profile".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/.bash_profile";
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/fish";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/nvim";
    ".config/herdr".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/herdr";
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/lazygit";

    ".config/zellij".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/shared/zellij";
  };
}
