return {
  "stevearc/oil.nvim",
  lazy = false,
  keys = {
    { "<leader>e", "<cmd>Oil<CR>", desc = "Explorer" },
    { "<leader>o", "<cmd>Oil<CR>", desc = "Explorer" },
    { "c-l",       false },
    { "c-k",       false },
    { "c-j",       false },
    { "c-h",       false },
  },

  opts = {
    view_options = {
      show_hidden = true,
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
