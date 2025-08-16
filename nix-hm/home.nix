{
  config,
  pkgs,
  stateVersion,
  ...
}: {
  imports = [
    ./modules
  ];

  home = {
    stateVersion = stateVersion;
    username = "rasib";
    homeDirectory = "/home/rasib";
  };

  #	wayland.windowManager.hyprland = {
  #		enable = true;
  #	};
  #
  # xdg.mime.enable = true;
  # xdg.mime.defaultApplications = {
  #   "image/jpeg" = "feh.desktop"; # or "eog.desktop" or "gwenview.desktop"
  # };
}
