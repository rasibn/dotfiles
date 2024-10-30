local plugin = {
  "vyfor/cord.nvim",
  build = "./build",
  event = "VeryLazy",
  opts = {
    text = {
      workspace = "",
    },
  },
}

return plugin

-- local os_name = vim.uv.os_uname().sysname
--
-- if os_name ~= "Darwin" then
--   return plugin
-- else
--   return {}
-- end
