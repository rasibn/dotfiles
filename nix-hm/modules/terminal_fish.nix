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
      ngc = "sudo nix-collect-garbage -d";
      ngc7 = "sudo nix-collect-garbage --delete-older-than 7d";
      ngc14 = "sudo nix-collect-garbage --delete-older-than 14d";

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

      set -gx PATH $HOME/.cargo/bin $PATH

      if test -z "$WAYLAND_DISPLAY"; and test "$XDG_VTNR" -eq 1
          dbus-run-session Hyprland
      else
          # if not set -q TMUX
          #     tmux attach || tmux new -s base
          # end
      end

      function git-wt
          # Usage: git-wt [--path DIR]
          set target_dir ".."

          # Parse optional flag
          if test (count $argv) -ge 2
              if test $argv[1] = "--path"
                  set target_dir $argv[2]
              else
                  echo "Usage: git-wt [--path DIR]"
                  return 1
              end
          end

          # Ensure we’re inside a repo
          if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
              echo "❌ Not inside a Git repo."
              return 1
          end

          set repo_name (basename (git rev-parse --show-toplevel))

          # Get branches (local + remote, deduplicated)
          set branches (git for-each-ref --format='%(refname:short)' refs/heads refs/remotes | sort | uniq | grep -vE '^HEAD$')
          if test (count $branches) -eq 0
              echo "No branches found."
              return 1
          end

          # Pick branch with fzf
          set branch (printf "%s\n" $branches | fzf --prompt="Select branch> ")
          if test -z "$branch"
              echo "Aborted."
              return 0
          end

          # Prepare target path
          set branch_sanitized (string replace -a '/' '-' $branch)
          set final_dir "$target_dir/$repo_name.$branch_sanitized"

          # If worktree already exists
          if test -d "$final_dir"
              echo "✅ Worktree already exists: $final_dir"
          else
              echo "🛠️  Creating worktree for '$branch'"
              git worktree add "$final_dir" "$branch"
          end

          cd $final_dir
          eval "$EDITOR ."
      end

       function mkcd
           mkdir -p "$argv[1]"
           cd "$argv[1]"
       end

       zoxide init --cmd cd fish | source
    '';
  };
}
