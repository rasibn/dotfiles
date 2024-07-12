return {
  "HakonHarnes/img-clip.nvim",
  event = "BufEnter",
  opts = {
    -- add options here
    -- or leave it empty to use the default settings
    markdown = {
      dir_path = "archive/attachments",
    },
  },
  keys = {
    { "<leader>P", "<cmd>PasteImage<cr>", desc = "Paste clipboard image" },
  },
}
