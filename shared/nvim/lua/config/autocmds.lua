-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- vim.cmd("silent! Copilot disable")
--
-- Add an autocommand for Rust lifetimes `
local rust_group = vim.api.nvim_create_augroup("RustSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  group = rust_group,
  command = "inoremap ' '",
})
