return {
  -- Treesitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "c_sharp" } },
  },
  -- Roslyn (Microsoft.CodeAnalysis.LanguageServer)
  -- Replaces OmniSharp, which targets net6.0 and fails to load projects
  -- built with modern .NET 8/9/10 SDKs. LazyVim auto-installs the mason
  -- package "roslyn-language-server" and auto-enables "roslyn_ls".
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Make sure OmniSharp never attaches. The mason package may still be
        -- installed, and mason-lspconfig's automatic_enable would otherwise
        -- enable it alongside roslyn_ls, causing duplicate/empty LSP results
        -- (e.g. Snacks picker returning nothing for references/definitions).
        omnisharp = { enabled = false },
        -- LazyVim maps gD -> vim.lsp.buf.declaration for ALL servers with no
        -- capability guard. roslyn_ls does not implement
        -- "textDocument/declaration", so pressing gD errors. Re-declare the
        -- global gD with `has = "declaration"` so it only binds when the
        -- active server supports it (this entry overrides LazyVim's default
        -- via opts_extend = { "servers.*.keys" }).
        ["*"] = {
          keys = {
            { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", has = "declaration" },
          },
        },
        roslyn_ls = {
          -- roslyn_ls has no declaration support, so make gD go to the
          -- definition instead (C# has no separate declaration vs definition).
          keys = {
            { "gD", vim.lsp.buf.definition, desc = "Goto Declaration" },
          },
          settings = {
            ["csharp|background_analysis"] = {
              dotnet_analyzer_diagnostics_scope = "fullSolution",
              dotnet_compiler_diagnostics_scope = "fullSolution",
            },
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
            },
          },
        },
      },
    },
  },
  -- C# tools via mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "csharpier",    -- C# formatter
        "netcoredbg",   -- C# debugger (for DAP)
      })
    end,
  },
  -- Formatting
  {
    "stevearc/conform.nvim",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "cs",
        callback = function(args)
          vim.b[args.buf].autoformat = false
        end,
      })
    end,
    opts = {
      formatters_by_ft = {
        cs = { "csharpier" },
      },
    },
  },
}
