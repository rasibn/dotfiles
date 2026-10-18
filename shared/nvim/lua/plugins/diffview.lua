return {
  "dlyongemallo/diffview-plus.nvim",
  init = function()
    vim.api.nvim_create_user_command("PRReview", function()
      require("config.pr_review").open()
    end, { desc = "Review current branch against its PR base" })
    vim.api.nvim_create_user_command("CommitReview", function()
      require("config.pr_review").open_commit()
    end, { desc = "Review the latest commit against its parent" })
  end,
  opts = {
    keymaps = {
      view = {
        { "n", "<leader>b", false },
        {
          "n",
          "<leader>de",
          function()
            require("diffview.actions").toggle_files()
          end,
          { desc = "Toggle Diffview file panel" },
        },
        { "n", "]h", "]c", { desc = "Next hunk" } },
        { "n", "[h", "[c", { desc = "Previous hunk" } },
      },
      file_panel = {
        { "n", "<leader>b", false },
        {
          "n",
          "<leader>de",
          function()
            require("diffview.actions").toggle_files()
          end,
          { desc = "Toggle Diffview file panel" },
        },
      },
      file_history_panel = {
        { "n", "<leader>b", false },
        {
          "n",
          "<leader>de",
          function()
            require("diffview.actions").toggle_files()
          end,
          { desc = "Toggle Diffview file panel" },
        },
      },
      diff1_inline = {
        {
          "n",
          "]h",
          function()
            require("diffview.actions").next_inline_hunk()
          end,
          { desc = "Next hunk" },
        },
        {
          "n",
          "[h",
          function()
            require("diffview.actions").prev_inline_hunk()
          end,
          { desc = "Previous hunk" },
        },
      },
    },
    view = {
      default = { layout = "diff1_inline" },
      inline = { style = "unified" },
    },
  },
}
