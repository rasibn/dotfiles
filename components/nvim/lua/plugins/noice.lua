return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
      lsp = {
        hover = {
          -- Set not to show a message if hover is not available
          -- ex: shift+k on Typescript code
          silent = true,
        },
      },
      presets = {
        bottom_search = false,   -- use a classic bottom cmdline for search
        command_palette = false, -- disable the command palette
        lsp_doc_border = true,   -- add a border to hover docs and signature help
      },
    },
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      -- render = "minimal",
      render = "compact",
    },
  },
}
