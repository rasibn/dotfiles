-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        eslint = {
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "svelte",
            "astro",
            "html",
          },
        },
      },
    },
  },
}
