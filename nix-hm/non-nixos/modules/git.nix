{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user.name = "Rasib Nadeem";
      user.email = "rasibnadeem101@gmail.com";
      init.defaultBranch = "main";
      credential."https://github.com".helper = "!${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };
}
