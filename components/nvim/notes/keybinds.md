
# My Notes For Getting Good

Disabling bufferline gave me a quite a few keybinds that I could use elsewhere

```lua
return {
  { "bufferline.nvim", enabled = false },
  --  KEYBINDS BUFFERLINE USED WERE
  --  [b 
  --  [B 
  --  <S-l> 
  --  ]B 
  --  ]b 
  --  <leader>bo 
  --  <leader>bp 
  --  <leader>bP 
  --  <S-h> 
  --  <leader>br 
  --  <leader>bl
```

## Yanky Configuration

- You can use the following config to learn how to add telescope extensions in LazyVim
- Also the keybinds for yanky are somewhat useful, so memorizing them could be cool

```lua
{
  "gbprod/yanky.nvim",
  recommended = true,
  desc = "Better Yank/Paste",
  event = "LazyFile",
  opts = {
    highlight = { timer = 150 },
  },
  keys = {
    {
      "<leader>p",
      function()
        if LazyVim.pick.picker.name == "telescope" then
          require("telescope").extensions.yank_history.yank_history({})
        else
          vim.cmd([[YankyRingHistory]])
        end
      end,
      mode = { "n", "x" },
      desc = "Open Yank History",
    },
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" },
      desc = "Yank Text" 
    },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" },
      desc = "Put Text After Cursor" 
    },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" },
      desc = "Put Text Before Cursor" 
    },
    { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" },
      desc = "Put Text After Selection" 
    },
    { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" },
      desc = "Put Text Before Selection" 
    },
    { "[y", "<Plug>(YankyCycleForward)",
      desc = "Cycle Forward Through Yank History" 
    },
    { "]y", "<Plug>(YankyCycleBackward)",
      desc = "Cycle Backward Through Yank History" 
    },
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)",
      desc = "Put Indented After Cursor (Linewise)" 
    },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)",
      desc = "Put Indented Before Cursor (Linewise)" 
    },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)",
      desc = "Put Indented After Cursor (Linewise)" 
    },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)",
      desc = "Put Indented Before Cursor (Linewise)" 
    },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)",
      desc = "Put and Indent Right" 
    },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)",
      desc = "Put and Indent Left" 
    },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)",
      desc = "Put Before and Indent Right" 
    },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)",
      desc = "Put Before and Indent Left" 
    },
    { "=p", "<Plug>(YankyPutAfterFilter)",
      desc = "Put After Applying a Filter" 
    },
    { "=P", "<Plug>(YankyPutBeforeFilter)",
      desc = "Put Before Applying a Filter" 
    },
  },
}


```

- These keybinds are now useless because I don't use tabs!

| Keybind             | Action           | mode |
| -----------------   | ---------------- | -----|
| `<leader><tab>l`    | Last Tab         | n    |
| `<leader><tab>o`    | Close Other Tabs | n    |
| `<leader><tab>f`    | First Tab        | n    |
| `<leader><tab><tab>`| New Tab          | n    |
| `<leader><tab>`]    | Next Tab         | n    |
| `<leader><tab>d`    | Close Tab        | n    |
| `<leader><tab>`[    | Previous Tab     | n    |
