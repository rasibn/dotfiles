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

  home.packages = with pkgs; [
    # Java
    jdt-language-server
    maven
    jdk

    # Node/JS/TS
    nodejs
    biome
    pnpm
    # bun
    typescript-language-server
    svelte-language-server
    tailwindcss-language-server
    prettierd

    # Python (commented out but keeping for reference)
    # uv
    # python3
    # ruff
    # pyright

    # Go
    gopls
    gofumpt
    gotools
    air
    templ

    # Gleam/Erlang
    gleam
    erlang_28
    rebar3

    # Rust
    rustup

    # Nix
    nil # nix lsp
    alejandra # nix formatter

    # Lua
    stylua
  ];
}
