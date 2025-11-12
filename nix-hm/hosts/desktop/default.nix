{
  config,
  pkgs,
  ...
}: {
  # Desktop-specific configuration

  # Desktop-specific packages
  home = {
    packages = with pkgs; [
      obsidian
    ];
  };
}
