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
    picker = {
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
}
