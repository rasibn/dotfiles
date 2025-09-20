{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      nvimi = "vimi --preview";
      cdpls = "cd (vimi --files)";
      flake-update = "nix flake update";
      nswitchu = "nswitchu_func";
      cls = "clear";
      ngc = "sudo nix-collect-garbage -d";
      ngc7 = "sudo nix-collect-garbage --delete-older-than 7d";
      ngc14 = "sudo nix-collect-garbage --delete-older-than 14d";

      "dot.zsh" = "$EDITOR $DOTFILE_DIR/shared/.zshrc";
      "dot.tmux" = "$EDITOR $DOTFILE_DIR/shared/.tmux.conf";
      "dot.nvim" = "cd $DOTFILE_DIR/shared/nvim/";
      "dot.vim" = "cd $DOTFILE_DIR/shared/nvim/";
      "dot.fish" = "cd $DOTFILE_DIR/shared/fish/";
      "dot.nix" = "cd $DOTFILE_DIR/nix-hm/";
    };
    shellAbbrs = {
      # system aliases
      hm = "home-manager";
      hms = "home-manager switch";
      hme = "home-manager edit";

      ta = "tmux a";
      lg = "lazygit";
      ld = "sudo lazydoker";
      # git aliases
      gst = "git status";
      ga = "git add";
      gaa = "git add .";
      gcmsg = "git commit -m";
      gl = "git pull";
      gp = "git push";
      gb = "git branch";
      gpsup = "git push --set-upstream origin $(git_current_branch)";
      gdup = "git diff @{upstream}";

      git-undo = "git reset --soft HEAD^";
    };
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings

      set -gx PATH $HOME/go/bin $PATH

      # Dynamic nswitchu function that detects current host
      function nswitchu_func
          # Check if device has a battery (laptop indicator)
          if test -d /sys/class/power_supply/BAT0 -o -d /sys/class/power_supply/BAT1
              set host_config "laptop"
          else
              set host_config "desktop"
          end
          sudo nixos-rebuild switch --flake $DOTFILE_DIR/nix-hm/#$host_config
      end

      if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" -eq 1
          dbus-run-session Hyprland
      else
          if not set -q TMUX
              tmux attach || tmux new -s base
          end
      end

      zoxide init --cmd cd fish | source
    '';
  };
}
