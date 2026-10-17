{
  config,
  pkgs,
  ...
}: let
  mainTools = with pkgs; [
    waybar
    rofi-unwrapped
    pavucontrol
    wf-recorder
    slurp
    proton-vpn
    anki
    swappy # A Wayland native snapshot and editor tool
    swaylock
    swayidle
    swaybg
    xwayland-satellite
    grim
    # swaylock-effects
    # waypaper # TODO: waypaper and hyprpaper both are probably not needed
  ];

  fonts = with pkgs; [
    nerd-fonts.caskaydia-cove
    font-awesome
    inter
  ];

  backgroundUtils = with pkgs; [
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
