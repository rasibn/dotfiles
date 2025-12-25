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

vim.keymap.set("n", "<leader>r", ":LspRestart<CR>", { desc = "Restart LSP" })

vim.keymap.set("n", "<leader>dd", function()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end, { desc = "Diffview" })

-- VSCode-neovim specific keybindings
if vim.g.vscode then
  -- LSP Navigation
  vim.keymap.set("n", "gi", function()
    vim.fn.VSCodeNotify("editor.action.showHover")
  end, { silent = true, desc = "Show Type Hint/Hover" })

  vim.keymap.set("n", "gI", function()
    vim.fn.VSCodeNotify("editor.action.goToImplementation")
  end, { silent = true, desc = "Go to Implementation" })

  vim.keymap.set("n", "gd", function()
    vim.fn.VSCodeNotify("editor.action.revealDefinition")
  end, { silent = true, desc = "Go to Definition" })

  vim.keymap.set("n", "gr", function()
    vim.fn.VSCodeNotify("editor.action.referenceSearch.trigger")
  end, { silent = true, desc = "Go to References" })

  vim.keymap.set("n", "gD", function()
    vim.fn.VSCodeNotify("editor.action.goToTypeDefinition")
  end, { silent = true, desc = "Go to Type Definition" })

  -- Peek variants (opens in peek view)
  -- vim.keymap.set("n", "gpi", function()
  --   vim.fn.VSCodeNotify("editor.action.peekImplementation")
  -- end, { silent = true, desc = "Peek Implementation" })
  --
  -- vim.keymap.set("n", "gpd", function()
  --   vim.fn.VSCodeNotify("editor.action.peekDefinition")
  -- end, { silent = true, desc = "Peek Definition" })
  --
  -- Code actions and formatting
  vim.keymap.set("n", "<leader>cr", function()
    vim.fn.VSCodeNotify("editor.action.rename")
  end, { silent = true, desc = "Rename Symbol" })

  vim.keymap.set({ "n", "v" }, "<leader>ca", function()
    vim.fn.VSCodeNotify("editor.action.codeAction")
  end, { silent = true, desc = "Code Action" })

  vim.keymap.set({ "n", "v" }, "<leader>cf", function()
    vim.fn.VSCodeNotify("editor.action.formatDocument")
  end, { silent = true, desc = "Format Document" })

  vim.keymap.set("n", "<leader>fr", function()
    vim.fn.VSCodeNotify("workbench.action.quickOpenRecent")
  end, { silent = true, desc = "Open Recent Files" })
end
