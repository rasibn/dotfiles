{
  config,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;

  # Set default fonts
  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Inter" "Liberation Sans"];
    serif = ["Inter" "Liberation Serif"];
    monospace = ["CaskaydiaCove Nerd Font" "Liberation Mono"];
  };
}