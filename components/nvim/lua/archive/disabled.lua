return {
  {
    "neovim/nvim-lspconfig",
    otps = {
      inlay_hints = {
        enabled = true,
        exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
      },
      servers = {
        clangd = {
          settings = {
            -- remove "proto"
            filetypes = {
              "c",
              "cpp",
              "objc",
              "objcpp",
              "cuda",
              -- "proto",
            },
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",
    config = {
      cmdline = {
        -- view = "cmdline",
      },
    },
  },
  {
    "hrsh7th/cmp-emoji",
    otps = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
