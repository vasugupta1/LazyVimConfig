return {
  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "toml" } },
  },
  -- Pyright — completions, go-to-def, and imports stay fully functional;
  -- type-checking diagnostics are quieted down.
  -- (server is also in masion.lua ensure_installed — both merge fine)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                -- "off" disables type-checking warnings while keeping
                -- completions, go-to-definition, hover, and auto-imports.
                -- Switch to "basic" or "standard" when you want stricter checks.
                typeCheckingMode = "off",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
                -- Suppress the noisiest individual diagnostics
                diagnosticSeverityOverrides = {
                  reportMissingImports = "none",
                  reportMissingModuleSource = "none",
                  reportMissingTypeStubs = "none",
                  reportOptionalMemberAccess = "none",
                  reportUnusedImport = "warning",
                  reportUnusedVariable = "warning",
                  reportGeneralTypeIssues = "none",
                  reportPrivateImportUsage = "none",
                },
              },
            },
          },
        },
      },
    },
  },
  -- Formatting (isort + black installed via masion.lua)
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "isort", "black" },
      },
    },
  },
  -- Pylint disabled — it stacks verbose convention/refactor warnings on top
  -- of pyright. Uncomment below to re-enable it.
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = {
  --     linters_by_ft = {
  --       python = { "pylint" },
  --     },
  --   },
  -- },
}
