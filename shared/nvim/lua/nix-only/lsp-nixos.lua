-- https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/eslint.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        rust_analyzer = {},
        ruff = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        jdtls = {},
        pyright = {},
        nil_ls = {},
        yamlls = {},
        ocamllsp = {},
        -- -- javascript
        --   eslint = {
        -- tailwindcss = {},
        --     filetypes = {
        --       "javascript",
        --       "javascriptreact",
        --       "javascript.jsx",
        --       "typescript", "typescriptreact",
        --       "typescript.tsx",
        --       "vue",
        --       "svelte",
        --       "astro",
        --       "html",
        --     },
        --   },
        -- vtsls = {},
        tailwindcss = {},
        svelte = {},
        volar = {}, -- vue-language-server
        ts_ls = {},
        templ = {},
        gleam = {},
        clangd = {},
      },
    },
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
        typescript = { "prettierd", "prettier", stop_after_first = true },
        svelte = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports", "gofumpt" },
        html = { "prettier" },
        templ = { "rustywind", "templ" },
        nix = { "alejandra" },
        gleam = { "gleam" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        ocaml = { "ocamlformat" },
      },
      formatters = {
        prettier = {
          require_cwd = true,
        },
      },
    },
  },
}
