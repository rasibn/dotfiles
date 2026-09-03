-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua
--
-- Install dependencies:
--   brew install jdtls
--   npm install -g svelte-language-server @tailwindcss/language-server @vtsls/language-server @fsouza/prettierd
--   go install github.com/sqls-server/sqls@latest
--
local lombok_jar = vim.fn.expand("~/.local/share/nvim/mason/share/jdtls/lombok.jar")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        rust_analyzer = {},
        ruff = {},
        pyright = {},
        gopls = {},
        yamlls = {},
        sourcekit = {},
        tailwindcss = {},
        gleam = {},
        templ = {},
        volar = {}, -- vue-language-server
        jdtls = {
          cmd = {
            "/opt/homebrew/bin/jdtls",
            "--jvm-arg=-javaagent:" .. lombok_jar,
          },
          settings = {
            java = {
              format = { enabled = false },
            },
          },
        },
        ts_ls = {},
        sqls = {
          cmd = { vim.fn.expand("~/go/bin/sqls") },
        },
        nil_ls = {},
        ocamllsp = {},
        -- javascript
        tailwindcss = {},
        svelte = {},
        vtsls = {},
      },
    },
  },
  {
    "nanotee/sqls.nvim",
    ft = { "sql", "mysql" },
    lazy = true,
  },
  -- adding formatting here as well because why not
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        -- Conform will run multiple formatters sequentially
        python = { "isort", "black" },
        -- You can customize some of the format options for the filetype (:help conform.format)
        rust = { "rustfmt", lsp_format = "fallback" },
        -- Conform will run the first available formatter
        javascript = { "prettierd", "prettier", stop_after_first = true },
        nix = { "alejandra" },
        swift = { "swiftformat" },
        templ = { "rustywind", "templ" },
        gleam = { "gleam" },
        java = {},
      },
    },
  },
}
