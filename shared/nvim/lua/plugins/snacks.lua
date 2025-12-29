return {
  "folke/snacks.nvim",
  ---@module "snacks"
  ---@type snacks.Config
  opts = {
    styles = {
      lazygit = {
        width = 0,
        height = 0,
      },
    },
    image = { enabled = true },
    picker = {
      -- formatters = {
      --   text = {
      --     ft = nil, ---@type string? filetype for highlighting
      --   },
      --   file = {
      --     filename_first = true, -- display filename before the file path
      --     --- * left: truncate the beginning of the path
      --     --- * center: truncate the middle of the path
      --     --- * right: truncate the end of the path
      --     ---@type "left"|"center"|"right"
      --     truncate = "center",
      --     min_width = 40, -- minimum length of the truncated path
      --     filename_only = false, -- only show the filename
      --     icon_width = 2, -- width of the icon (in characters)
      --     git_status_hl = true, -- use the git status highlight group for the filename
      --   },
      -- },
      sources = {
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
  keys = {
    {
      "<leader>gi",
      function()
        Snacks.picker.gh_issue()
      end,
      desc = "GitHub Issues (open)",
    },
    {
      "<leader>gI",
      function()
        Snacks.picker.gh_issue({ state = "all" })
      end,
      desc = "GitHub Issues (all)",
    },
    {
      "<leader>gp",
      function()
        Snacks.picker.gh_pr()
      end,
      desc = "GitHub Pull Requests (open)",
    },
    {
      "<leader>gP",
      function()
        Snacks.picker.gh_pr({ state = "all" })
      end,
      desc = "GitHub Pull Requests (all)",
    },
  },
}
