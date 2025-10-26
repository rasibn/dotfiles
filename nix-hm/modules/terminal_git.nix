{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Rasib Nadeem";
      user.email = "rasibnadeem101@gmail.com";
      init.defaultBranch = "main";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
