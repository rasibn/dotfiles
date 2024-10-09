{pkgs, ...}: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rasib = {
    isNormalUser = true;
    description = "rasib";
    extraGroups = ["networkmanager" "input" "wheel" "video" "audio" "tss"];
    shell = pkgs.fish;
    packages = with pkgs; [
      youtube-music
      # discord
      vesktop
      # tdesktop
      obsidian
      # vscodium
      vscode
      # brave
      google-chrome
      github-desktop
      # for github desktop
      kdePackages.kwallet
      vivaldi
    ];
  };

  # Change runtime directory size
  services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
