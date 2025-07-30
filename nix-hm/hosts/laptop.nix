{
  config,
  pkgs,
  ...
}: {
  # Laptop-specific configuration
  home.stateVersion = "25.05";
  
  # Laptop-specific packages
  home.packages = with pkgs; [
  ];
}
