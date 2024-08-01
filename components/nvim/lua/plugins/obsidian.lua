local opts = {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    -- event = { -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    --   --  "BufReadPre /home/Projects/Vault/**.md",
    --   -- "BufNewFile /home/Projects/Vault/**.md",
    --   "BufReadPre "
    --     .. vim.fn.expand("~")
    --     .. "/Projects/Vault/**.md",
    --   "BufNewFile " .. vim.fn.expand("~") .. "/Projects/Vault/**.md",
    -- },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      dir = "~/Projects/Vault", -- no need to call 'vim.fn.expand' here

      follow_url_func = function(url)
        -- Open the URL in the default web browser.
        -- vim.fn.jobstart({ "open", url }) -- Mac OS
        vim.fn.jobstart({ "xdg-open", url }) -- linux
      end,

      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = "notes/dailies",
        -- Optional, if you want to change the date format for the ID of daily notes.
        -- date_format = "%Y-%m-%d",
        -- Optional, if you want to change the date format of the default alias of daily notes.
        -- alias_format = "%B %-d, %Y"
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        -- template = nil
      },

      -- Optional, completion.
      completion = {
        -- If using nvim-cmp, otherwise set to false
        nvim_cmp = true,
        -- Trigger completion at 1 chars
        min_chars = 1,
      },

      -- Optional, key mappings.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ["gf"] = {
          action = function()
            return require("obsidian").util.gf_passthrough()
          end,
          opts = {
            noremap = false,
            expr = true,
            buffer = true,
          },
        },
      },
    },
  },
}

local os_name = vim.uv.os_uname().sysname

if os_name ~= "Darwin" then
  return opts
else
  return {}
end
