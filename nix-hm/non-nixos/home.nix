{
  config,
  pkgs,
  inputs,
  system,
  username,
  homeDirectory,
  stateVersion,
  ...
}: {
  imports = [./modules];

  home = {
    inherit username homeDirectory stateVersion;
    packages = with pkgs; [
      inputs.herdr.packages.${system}.herdr
      ripgrep
      fzf
      just
      fd
      bat
      jq
      neovim
      fish
      git
      zoxide
      lazygit
      yazi
      gh
      direnv
      nix-direnv
      devenv
      beamPackages.elixir
      beamPackages.erlang
      beamPackages.elixir-ls
    ];
  };

  programs.home-manager.enable = true;
}
