-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.cmd("silent! Copilot disable")
vim.cmd("silent! RenderMarkdown toggle")
--
-- Add an autocommand for Rust lifetimes `
local rust_group = vim.api.nvim_create_augroup("RustSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  group = rust_group,
  command = "inoremap ' '",
})

local client = vim.lsp.start({
  name = "appenginelsp",
  cmd = { "/home/rasib/projects/appenginelsp/main" },
  on_attach = function()
    vim.notify("Good stuff")
  end,
})

if not client then
  vim.notify("hey, you didnt do the client thing good")
  return
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    if vim.api.nvim_buf_is_loaded(0) then
      vim.lsp.buf_attach_client(0, client)
    end
  end,
})
