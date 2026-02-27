return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- Disable golangci-lint for Go files
        -- The LSP (gopls) will handle Go diagnostics instead
        go = {},
      },
    },
  },
}
