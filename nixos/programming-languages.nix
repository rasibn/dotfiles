{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    go
    (python312Full.withPackages (ps: with ps; [pygobject3 gobject-introspection pyqt6-sip]))
    nodePackages_latest.nodejs
    nodePackages_latest.pnpm
    bun
    lua
    zig
    numbat
    tailwindcss
    rustup
    gcc

    # gleam stuff
    gleam
    rebar3
    erlang_27
    # for lustre
    inotify-tools

    # reasonml & ocaml
    ocaml
    opam
    dune_3
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    ocamlPackages.findlib

    # formatting
    prettierd
    alejandra
    stylua
    black
    gofumpt
    gotools # godoc, goimports, callgraph, digraph, stringer or toolstash.
    shfmt
  ];
}
