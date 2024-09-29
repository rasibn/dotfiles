return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<leader>o",  "<cmd>Oil<CR>", desc = "Oil file Explorer" },
    -- { "<leader>e",  "<cmd>Oil<CR><C-p>", desc = "Oil file Explorer (Preview)" },
    { "<leader>fo", "<cmd>Oil<CR>", desc = "Oil file Explorer" },
    { "<c-l>",      false },
    { "<C-h>",      false },
  },
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
  },
}
