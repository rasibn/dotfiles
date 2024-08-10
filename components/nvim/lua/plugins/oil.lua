return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>fe", "<cmd>Oil<CR>", desc = "Oil file Explorer" },
    { "<leader>e", "<cmd>Oil<CR><C-p>", desc = "Oil file Explorer (Preview)" },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  },
}
