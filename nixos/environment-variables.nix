{ pkgs, ... }:

{
  # Setup Env Variables
  environment.variables.NODEJS_PATH = "${pkgs.nodePackages_latest.nodejs}/";

  # DIR paths should mirror .env in dotfiles repo
  environment.variables.PROJECT_DIR="/home/rasib/projects";
  environment.variables.WORK_DIR="/home/rasib/work";
  environment.variables.DOTFILE_DIR="/home/rasib/projects/dotfiles";
  environment.variables.BASH="/run/current-system/sw/bin/bash";
}
