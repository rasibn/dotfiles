{
  config,
  pkgs,
  ...
}: {
  services.hypridle = {
    enable = true;
    settings = {
      listener = [
        {
          timeout = 300; # 5 minutes
          on-timeout = "swayosd-client --brightness lower";
          on-resume = "swayosd-client --brightness raise";
        }
        {
          timeout = 600;
          on-timeout = "hyprlock";
        }
        {
          timeout = 900; # 10 minutes (display off)
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1800; # 30 minutes (suspend)
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}