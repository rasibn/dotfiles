return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ruff_lsp = {
        mason = false,
        enabled = false,
      },
      lua_ls = {
        mason = false,
        enabled = false,
      },
    },
  },
}
