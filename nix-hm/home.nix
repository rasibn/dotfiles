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
}
