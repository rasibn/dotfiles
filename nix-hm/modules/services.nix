{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  voxtype = inputs.voxtype.packages.${system}.vulkan;
in {
  # home-manager services
  services = {
    cliphist = {
      enable = true;
      allowImages = true;
      extraOptions = ["-max-dedupe-search" "10" "-max-items" "500"];
    };
  };

  services.mako = {
    enable = true;
  };

  services.swayosd.enable = true;

  xdg.configFile."voxtype/config.toml".text = ''
    engine = "whisper"

    [hotkey]
    enabled = false

    [audio]
    device = "default"

    [whisper]
    model = "large-v3-turbo"
  '';

  systemd.user.services.voxtype = {
    Unit = {
      Description = "Voxtype local voice dictation";
    };
    Service = {
      ExecStart = "${voxtype}/bin/voxtype daemon";
      Restart = "on-failure";
      RestartSec = 2;
    };
    Install = {
      WantedBy = ["default.target"];
    };
  };
}
