return {
  "carlos-algms/agentic.nvim",
  opts = {
    provider = "codex-acp",
    windows = {
      position = "right",
      width = "40%",
    },
  },
  keys = {
    {
      "<C-\\>",
      function()
        require("agentic").toggle()
      end,
      mode = { "n", "v", "i" },
      desc = "Toggle Codex chat",
    },
    {
      "<C-'>",
      function()
        require("agentic").add_selection_or_file_to_context()
      end,
      mode = { "n", "v" },
      desc = "Add file or selection to Codex context",
    },
    {
      "<C-,>",
      function()
        require("agentic").new_session()
      end,
      mode = { "n", "v", "i" },
      desc = "New Codex session",
    },
    {
      "<leader>ar",
      function()
        require("agentic").restore_session()
      end,
      mode = { "n", "v", "i" },
      desc = "Restore Codex session",
    },
    {
      "<leader>ad",
      function()
        require("agentic").add_current_line_diagnostics()
      end,
      desc = "Add line diagnostics to Codex",
    },
    {
      "<leader>aD",
      function()
        require("agentic").add_buffer_diagnostics()
      end,
      desc = "Add buffer diagnostics to Codex",
    },
  },
}
