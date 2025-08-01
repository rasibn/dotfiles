{
  config,
  pkgs,
  ...
}: {
  services.mako = {
    enable = true;
    extraConfig = ''
      sort=-time
      layer=overlay
      background-color=#1e222a7f
      width=450
      height=150
      border-size=0
      border-color=#14181d
      border-radius=10
      icons=0
      max-icon-size=64
      default-timeout=5000
      ignore-timeout=0
      font="HarmonyOS Sans SC" 16
      margin=12
      padding=12,20

      [urgency=low]
      border-color=#cccccc

      [urgency=normal]
      border-color=#99c0d0

      [urgency=critical]
      border-color=#bf616a
      default-timeout=0
    '';
  };

  services.swayosd.enable = true;
}