{
  _config,
  pkgs,
  ...
}: let
  javaPackages = with pkgs; [
    jdt-language-server
    maven
    jdk
  ];

  nodePackages = with pkgs; [
    nodejs
    bun
    biome
    pnpm
    typescript-language-server
    svelte-language-server
    tailwindcss-language-server
    yaml-language-server
    # prettierd
  ];

  pythonPackages = with pkgs; [
    uv
    python3
    ruff
    pyright
  ];

  goPackages = with pkgs; [
    go
    gopls
    gofumpt
    gotools
    air
    templ
  ];

  gleamPackages = with pkgs; [
    gleam
    erlang_28
    rebar3
  ];

  crystalPackages = with pkgs; [
    crystal_1_14
  ];

  OCamlPackages = with pkgs; [
    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlformat_0_26_2
  ];

  rustPackages = with pkgs; [
    rustup
  ];

  nixPackages = with pkgs; [
    nil # nix lsp
    alejandra # nix formatter
  ];

  cppPackages = with pkgs; [
    clang
    clang-tools
    gdb
  ];

  luaPackages = with pkgs; [
    stylua
    lua-language-server
  ];
in {
  home.packages =
    goPackages
    # ++ javaPackages
    ++ nodePackages
    # ++ pythonPackages
    ++ gleamPackages
    ++ rustPackages
    # ++ crystalPackages
    ++ nixPackages
    ++ luaPackages
    ++ cppPackages
    # ++ OCamlPackages
    ++ nodePackages;
}
