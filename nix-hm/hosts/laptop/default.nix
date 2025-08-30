{
  config,
  pkgs,
  ...
}: {
  # Laptop-specific configuration

  home = {
    packages = with pkgs; [
      zed-editor
    ];
  };
}
