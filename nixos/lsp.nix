{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # python311Packages.python-lsp-server
    nodePackages_latest.nodemon
    nodePackages_latest.typescript
    nodePackages_latest.vscode-langservers-extracted
    nodePackages_latest.yaml-language-server
    nodePackages_latest.dockerfile-language-server-nodejs
    nodePackages_latest.svelte-language-server

    tailwindcss-language-server

    sumneko-lua-language-server
    marksman
    nil
    zls
    gopls
    ruff
    emmet-language-server
    tailwindcss-language-server
    nodePackages_latest.typescript-language-server
  ];
}
