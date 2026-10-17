{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = {
      v = "nvim";
      vi = "nvim";
      vim = "nvim";
      vimc = "nvim --clean";
      cdpls = "cd (vimi --files)";
      flake-update = "nix flake update";
      nswitchu = "nswitchu_func";
      cls = "clear";
      q = "exit";
      ngc = "sudo nix-collect-garbage -d";
      ngc7 = "sudo nix-collect-garbage --delete-older-than 7d";
      ngc14 = "sudo nix-collect-garbage --delete-older-than 14d";
      yz = "yazi";
      codex = "codex --yolo";
      git-undo = "$DOTFILE_DIR/shared/scripts/git_scripts/git_undo.sh";

      "dot.zsh" = "$EDITOR $DOTFILE_DIR/shared/.zshrc";
      "dot.tmux" = "$EDITOR $DOTFILE_DIR/shared/.tmux.conf";
      "dot.nvim" = "cd $DOTFILE_DIR/shared/nvim/";
      "dot.vim" = "cd $DOTFILE_DIR/shared/nvim/";
      "dot.fish" = "cd $DOTFILE_DIR/shared/fish/";

      ",," = "cd ..";
      "..l" = "cd .. && ls";
      ":q" = "exit";
      "cd.." = "cd ..";
      "mdkir" = "mkdir";
      "dc" = "cd";
      "sl" = "ls";
      "sudp" = "sudo";
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
    };
    shellInit = ''
      set -g fish_key_bindings fish_vi_key_bindings

      for _f in $HOME/.config/herdr/plugins/github/herdr-automatic-rename-*/shell/hook.fish
          test -r "$_f"; and source "$_f"; and break
      end

      set -gx PATH $HOME/go/bin $PATH

      # Dynamic nswitchu function that detects current host
      function nswitchu_func
          if test -d /sys/class/power_supply/BAT0 -o -d /sys/class/power_supply/BAT1
              set host_config laptop
          else
              set host_config desktop
          end
          sudo nixos-rebuild switch --flake $DOTFILE_DIR/nix-hm/#$host_config
      end

      function mkcd
          mkdir -p "$argv[1]"
          cd "$argv[1]"
      end

      function kill-port
          if test (count $argv) -eq 0
              echo "Usage: kill-port <port-number>"
              return 1
          end

          set port $argv[1]
          set pid (lsof -ti :$port)
          if test -z "$pid"
              echo "No process found listening on port $port"
              return 1
          end

          echo "Killing process $pid on port $port"
          kill -9 $pid
          echo "Process killed successfully"
      end

      set -gx PATH $HOME/.cargo/bin $PATH

      if status is-interactive; and status is-login; and test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" = 1
          # start-hyprland
          niri-session
      else
          # if not set -q TMUX
          #     tmux attach || tmux new -s base
          # end
      end

       zoxide init --cmd cd fish | source
    '';
  };
}
