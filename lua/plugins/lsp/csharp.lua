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
          -- Extend default root_dir so .NET 10 file-based C# apps (e.g. Aspire
          -- single-file apphost.cs with #:sdk / #:package directives and no
          -- .sln/.csproj) fall back to the file's directory instead of failing
          -- to attach.
          root_dir = function(bufnr, cb)
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            local _, endpos = bufname:find("[/\\]MetadataAsSource[/\\]")
            local is_decompiled = endpos ~= nil
              and vim.fn.finddir(bufname:sub(1, endpos), vim.uv.os_tmpdir()) ~= ""

            if not is_decompiled then
              local root_dir = vim.fs.root(bufnr, function(fname)
                return fname:match("%.sln[x]?$") ~= nil
              end)
              if not root_dir then
                root_dir = vim.fs.root(bufnr, function(fname)
                  return fname:match("%.csproj$") ~= nil
                end)
              end
              if not root_dir and bufname ~= "" then
                root_dir = vim.fs.dirname(bufname)
              end
              if root_dir then
                cb(root_dir)
              end
            else
              local prev_buf = vim.fn.bufnr("#")
              local client = vim.lsp.get_clients({
                name = "roslyn_ls",
                bufnr = prev_buf ~= -1 and prev_buf or nil,
              })[1]
              if client then
                cb(client.config.root_dir)
              end
            end
          end,
          handlers = {
            -- File-based C# apps (apphost.cs) trigger workspace/diagnostic/refresh
            -- instead of workspace/projectInitializationComplete when their virtual
            -- project finishes loading. Pull Roslyn's dynamically registered
            -- diagnostic providers on refresh so diagnostics appear immediately.
            ["workspace/diagnostic/refresh"] = function(_, _, ctx)
              local client = vim.lsp.get_client_by_id(ctx.client_id)
              if not client then
                return vim.NIL
              end
              local capabilities = vim
                .iter(client.dynamic_capabilities.capabilities.diagnosticProvider or {})
                :map(function(cap)
                  return cap.registerOptions.identifier
                end)
                :totable()
              for buf, _ in pairs(client.attached_buffers) do
                if vim.api.nvim_buf_is_loaded(buf) then
                  for _, cap in pairs(capabilities) do
                    client:request(vim.lsp.protocol.Methods.textDocument_diagnostic, {
                      identifier = cap,
                      textDocument = vim.lsp.util.make_text_document_params(buf),
                    }, nil, buf)
                  end
                end
              end
              return vim.NIL
            end,
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
