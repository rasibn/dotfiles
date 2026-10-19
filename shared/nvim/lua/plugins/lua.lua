return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    -- Mason is disabled, but its installed Lua server can be used when none is on PATH.
    local mason_lua = vim.fn.stdpath("data") .. "/mason/bin/lua-language-server"
    if vim.fn.executable("lua-language-server") == 0 and vim.fn.executable(mason_lua) == 1 then
      opts.servers.lua_ls = vim.tbl_deep_extend("force", opts.servers.lua_ls or {}, {
        cmd = { mason_lua },
      })
    end
  end,
}
