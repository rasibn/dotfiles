{
  config,
  pkgs,
  ...
}: let
  mainTools = with pkgs; [
    hypridle
    waybar
    rofi-unwrapped
    pavucontrol
    hyprshot
    swappy # A Wayland native snapshot and editor tool
    hyprpaper
    # swaylock-effects
    # waypaper # TODO: waypaper and hyprpaper both are probably not needed
  ];

  fonts = with pkgs; [
    nerd-fonts.caskaydia-cove
    font-awesome
    inter
  ];

  backgroundUtils = with pkgs; [
    wl-clipboard-rs
    gnome-keyring
    udiskie #  to manage removable media from userspace
  ];
in {
  # programs = { };

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = ["Inter" "Liberation Sans"];
      serif = ["Inter" "Liberation Serif"];
      monospace = ["CaskaydiaCove Nerd Font" "Liberation Mono"];
    };
  };

  home.packages =
    mainTools
    ++ fonts
    ++ backgroundUtils;
}
