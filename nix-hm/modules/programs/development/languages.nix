{
  config,
  pkgs,
  ...
}: {
  programs.go.enable = true;
  programs.bun = {
    enable = true;
    enableGitIntegration = true;
  };
}