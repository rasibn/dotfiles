{
  config,
  pkgs,
  ...
}: let
  dotfiles_dir = "${config.home.homeDirectory}/assets/dotfiles";
  assets_dir = "${config.home.homeDirectory}/assets";
  works_dir = "${config.home.homeDirectory}/work";
  projects_dir = "${config.home.homeDirectory}/projects";
in {
  home.sessionVariables = {
    EDITOR = "vim";
    PROJECT_DIR = projects_dir;
    WORK_DIR = works_dir;
    ASSET_DIR = assets_dir;
    DOTFILE_DIR = dotfiles_dir;
  };

  home.file = {
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/rofi";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/shared/nvim";
    ".wezterm.lua".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/.wezterm.lua";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/waybar";

    ".config/hypr/hyprland.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/hyprland.conf";
    ".config/hypr/hyprpaper.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/hyprpaper.conf";
    ".config/hypr/monitors.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/monitors.conf";
    ".config/hypr/workspaces.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/workspaces.conf";
    ".config/hypr/hyprlock.png".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/hyprlock.png";
    ".config/hypr/hypridle.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/hypridle.conf";
    ".config/hypr/thunder.png".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/thunder.png";
    ".config/hypr/wallpaper.png".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles_dir}/desktop/linux/hypr/wallpaper.png";
  };
}
