-- -- Keymaps are automatically loaded on the VeryLazy event
-- -- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- -- Add any additional keymaps here
--
-- mistakes of the past
-- vim.keymap.set("i", "kj", "<Esc>")
-- vim.keymap.set("i", "jk", "<Esc>")

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

-- I like helix okay?
-- Normal mode mappings
vim.keymap.set("n", "gh", "^", { desc = "Go to the start of the line" })
vim.keymap.set("n", "gl", "$", { desc = "Go to the end of the line" })
vim.keymap.set("n", "ge", "G", { desc = "Go to the end of the file" })

-- Visual mode mappings
vim.keymap.set("v", "gh", "^", { desc = "Go to the start of the line" })
vim.keymap.set("v", "gl", "$", { desc = "Go to the end of the line" })
vim.keymap.set("v", "ge", "G", { desc = "Go to the end of the file" })
