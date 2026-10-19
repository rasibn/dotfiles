return {
  "folke/snacks.nvim",
  ---@module "snacks"
  ---@param opts snacks.Config
  opts = function(_, opts)
    local sections = opts.dashboard.sections or {
      { section = "keys",   gap = 1, padding = 1 },
      { section = "startup" },
    }

    assert(type(sections) == "table", "Dashboard sections must be a list")
    sections = vim.tbl_filter(function(section)
      return type(section) ~= "table" or section.section ~= "header"
    end, sections)

    table.insert(sections, 1, {
      title = "Code navigation",
      text = table.concat({
        "Normal mode: press keys in sequence; leader = Space",
        "gd   Definition           gr   References (source lines)",
        "gai  Incoming callers     gao  Outgoing calls",
        "gI   Implementation       gy   Type definition",
        "K    Documentation        Ctrl-o / Ctrl-i  Back / Forward",
        "Space ss  File symbols    Space sS  Workspace symbols",
      }, "\n"),
      padding = 1,
    })
    opts.dashboard.sections = sections

    table.insert(opts.dashboard.preset.keys, 1, {
      icon = " ",
      key = "b",
      desc = "Review Branch vs PR Base",
      action = function()
        require("config.pr_review").open()
      end,
    })
    table.insert(opts.dashboard.preset.keys, 2, {
      icon = " ",
      key = "c",
      desc = "Review Latest Commit",
      action = function()
        require("config.pr_review").open_commit()
      end,
    })
    table.insert(opts.dashboard.preset.keys, 3, {
      icon = " ",
      key = "d",
      desc = "Review Uncommitted Changes",
      action = "DiffviewOpen",
    })

    return vim.tbl_deep_extend("force", opts, {
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
    })
  end,
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
