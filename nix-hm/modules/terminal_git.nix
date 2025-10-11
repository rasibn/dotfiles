{
  config,
  pkgs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "Rasib Nadeem";
    userEmail = "rasibnadeem101@gmail.com";
    delta.enable = true;
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
