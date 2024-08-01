local opts = {
  "vyfor/cord.nvim",
  build = "./build",
  event = "VeryLazy",
  opts = {},
}

local os_name = vim.uv.os_uname().sysname

if os_name ~= "Darwin" then
  return opts
else
  return {}
end
