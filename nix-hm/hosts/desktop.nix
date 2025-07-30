{
  config,
  pkgs,
  ...
}: {
  # Desktop-specific configuration
  home.stateVersion = "24.11";
  
  # Desktop-specific packages
  home.packages = with pkgs; [
  ];
}
