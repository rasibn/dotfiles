{
  config,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    escapeTime = 0;
    keyMode = "vi";

    # Remap prefix from 'C-b' to 'C-a'
    prefix = "C-a";

    plugins = with pkgs.tmuxPlugins; [
      sensible
      pain-control
    ];

    extraConfig = ''
      set-option -g renumber-windows on

      # Scroll speed configuration
      set -g @scroll-speed-num-lines-per-scroll 2

      # Bind 'v' to copy-mode
      bind 'v' copy-mode

      run-shell "$DOTFILE_DIR/shared/scripts/tmux/tmux-power.tmux"

      # True colours support
      set -ga terminal-overrides ",xterm-256color:Tc"
      set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'
      # Underscore colours - needs tmux-3.0
      set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'
    '';
  };
}
