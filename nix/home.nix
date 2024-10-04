{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rasib";
  home.homeDirectory = "/home/rasib";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.just
    pkgs.gcc # we need gcc for treesitter in nix, could replace this with zig btw
    pkgs.neovim

    pkgs.nil # nix lsp
    pkgs.alejandra # nix formator

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
    ".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/assets/dotfiles/components/nvim";
    };
    ".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/assets/dotfiles/components/.tmux.conf";
    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rasib/etc/profile.d/hm-session-vars.sh
  #

  home.sessionVariables = {
    EDITOR = "vim";
    PROJECT_DIR = "${config.home.homeDirectory}/projects";
    WORK_DIR = "${config.home.homeDirectory}/work";
    ASSET_DIR = "${config.home.homeDirectory}/assets";
    DOTFILE_DIR = "${config.home.homeDirectory}/assets/dotfiles";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fish = {
    enable = true;
    shellAbbrs = {
      # system aliases
      hm = "home-manager";
      hms = "home-manager switch";
      hme = "home-manager edit";
      cls = "clear";
      # git aliases
      gst = "git status";
      ga = "git add";
      gaa = "git add .";
      gcm = "git commit -m";
      gl = "git pull";
      gp = "git push";
      git-undo = "git reset --soft HEAD^";
      # other aliases
      lg = "lazygit";
    };
    shellInit = ''
      set fish_vi_force_cursor
      set fish_vi_keybindings
    '';
  };

  programs.git = {
    enable = true;
    userName = "Rasib Nadeem";
    userEmail = "rasibnadeem101gmail.com";
    delta.enable = true;
    extraConfig.init.defaultBranch = "main";
  };

  programs.gh.enable = true;
  programs.lazygit.enable = true;

  # work
  programs.go.enable = true;
  programs.bun = {
    enable = true;
    enableGitIntegration = true;
  };

  # helix at the end because it's super long, and they said helix didn't need config...
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
      keys.normal = {
        space.space = "file_picker";
      };
    };
    languages = {
      language-server.gopls = {
        command = "gopls";
        config = {
          "gofumpt" = true;
        };
      };
      language = [
        {
          name = "rust";
          auto-pairs = {
            "(" = ")";
            "{" = "}";
            "[" = "]";
            "|" = "|";
            "<" = ">";
          };
        }
        {
          name = "go";
          formatter = {
            command = "goimports";
            args = [];
          };
        }
        {
          name = "nix";
          formatter = {
            command = "alejandra";
            args = [];
          };
        }
      ];
    };
  };
}
