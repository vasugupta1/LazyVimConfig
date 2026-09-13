return {
  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "toml" } },
  },
  -- Pyright with enhanced analysis settings
  -- (server is also in masion.lua ensure_installed — both merge fine)
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoImportCompletions = true,
                diagnosticMode = "openFilesOnly",
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
  -- Linting (pylint installed via masion.lua)
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        python = { "pylint" },
      },
    },
  },
}
