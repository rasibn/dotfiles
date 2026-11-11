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

-- copy text with file location
vim.keymap.set("x", "<leader>cy", function()
  local path = vim.fn.expand("%:~:.")
  if path == "" then
    vim.notify("Cannot copy location: buffer has no file name", vim.log.levels.WARN)
    return
  end

  local start_pos, end_pos = vim.fn.getpos("v"), vim.fn.getpos(".")
  local first, last = math.min(start_pos[2], end_pos[2]), math.max(start_pos[2], end_pos[2])
  local location = path .. ":" .. first .. (first ~= last and "-" .. last or "")
  local lines = vim.fn.getregion(start_pos, end_pos, { type = vim.fn.mode(), exclusive = vim.o.selection == "exclusive" })

  vim.fn.setreg("+", table.concat(lines, "\n") .. "\n---\n" .. location)
  vim.notify("Copied selection with " .. location)
end, { desc = "Copy selection with file location" })

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
  --   vim.fn.VSCodeNotify("editor.action.revealDefinition")
  -- end, { silent = true, desc = "Go to Definition" })

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

  -- Error/Diagnostic Navigation
  vim.keymap.set("n", "]e", function()
    vim.fn.VSCodeNotify("editor.action.marker.next")
  end, { silent = true, desc = "Next Error (all files)" })

  vim.keymap.set("n", "[e", function()
    vim.fn.VSCodeNotify("editor.action.marker.prev")
  end, { silent = true, desc = "Previous Error (all files)" })

  vim.keymap.set("n", "]d", function()
    vim.fn.VSCodeNotify("editor.action.marker.nextInFiles")
  end, { silent = true, desc = "Next Diagnostic (current file)" })

  vim.keymap.set("n", "[d", function()
    vim.fn.VSCodeNotify("editor.action.marker.prevInFiles")
  end, { silent = true, desc = "Previous Diagnostic (current file)" })

  -- Git Change Navigation
  vim.keymap.set("n", "]c", function()
    vim.fn.VSCodeNotify("workbench.action.editor.nextChange")
  end, { silent = true, desc = "Next Git Change" })

  vim.keymap.set("n", "[c", function()
    vim.fn.VSCodeNotify("workbench.action.editor.previousChange")
  end, { silent = true, desc = "Previous Git Change" })

  -- -- Search Result Navigation
  -- vim.keymap.set("n", "]q", function()
  --   vim.fn.VSCodeNotify("search.action.focusNextSearchResult")
  -- end, { silent = true, desc = "Next Search Result" })
  --
  -- vim.keymap.set("n", "[q", function()
  --   vim.fn.VSCodeNotify("search.action.focusPreviousSearchResult")
  -- end, { silent = true, desc = "Previous Search Result" })
end
