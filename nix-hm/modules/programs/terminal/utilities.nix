{
  config,
  pkgs,
  ...
}: {
  programs = {
    wezterm.enable = true;
    waybar.enable = true;
    fzf.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
    television = {
      enable = true;
      enableFishIntegration = true;
    };
    lf.enable = true;
  };
}
