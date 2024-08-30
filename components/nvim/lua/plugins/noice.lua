return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      hover = {
        -- Set not show a message if hover is not available
        -- ex: shift+k on Typescript code
        silent = true,
      },
    },
    presets = {
      bottom_search = false, -- use a classic bottom cmdline for search
      lsp_doc_border = true, -- add a border to hover docs and signature help
    },
  },
}
