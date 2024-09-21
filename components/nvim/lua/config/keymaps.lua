-- -- Keymaps are automatically loaded on the VeryLazy event
-- -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
-- mistakes of the past
-- vim.keymap.set("i", "kj", "<Esc>")
-- vim.keymap.set("i", "jk", "<Esc>")

-- I just changed .local/share/nvim/lazy/LazyVim/utils/init.lua to treesitter builtin = "find_files"

-- vim.keymap.set(
--   "n",
--   "<leader><space>",
--   "<cmd>lua require('telescope.builtin').find_files({ find_command = {'rg', '--ignore', '--hidden', '--files', '--glob', '!.git', '--glob', '!Excalidraw', '--glob', '!.obsidian'}, prompt_prefix= '🔍' })<cr>"
-- )
--
--
vim.keymap.del("n", "<leader>ft")
vim.keymap.del("n", "<leader>fT")
vim.keymap.del("n", "<c-/>")
vim.keymap.del("n", "<c-_>")

-- -- I like helix okay?
-- vim.keymap.set("n", "gh", "^", { desc = "Move to start of line" })
-- vim.keymap.set("n", "gl", "$", { desc = "Move right" })
-- vim.keymap.set("n", "ge", "G", { desc = "Move to end of file" })

-- vim.api.nvim_set_keymap(
--   "n",
--   "<leader><space>",
--   "<cmd>Telescope find_files<cr>",
--   { noremap = true, silent = true, desc = "Find Files (test2)" }
-- )
