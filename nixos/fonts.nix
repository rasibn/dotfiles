{ pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    roboto
    jetbrains-mono
    nerd-font-patcher
  ];
}
