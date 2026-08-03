-- LSP using the Neovim 0.11+ API (`vim.lsp.config` / `vim.lsp.enable`).
-- The legacy `require("lspconfig").<server>.setup()` framework is deprecated;
-- nvim-lspconfig now only ships the config *defaults* under `lsp/`, which
-- `vim.lsp.config`/`vim.lsp.enable` pick up automatically.
return {
  { "mason-org/mason.nvim", opts = {} },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Servers to install and enable. Single source of truth.
      local servers = { "lua_ls", "pyright", "ts_ls" }

      -- Completion capabilities applied to every server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Per-server overrides (merged on top of nvim-lspconfig defaults).
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      -- mason-lspconfig installs the servers and enables them via vim.lsp.enable.
      require("mason-lspconfig").setup({
        ensure_installed = servers,
      })

      -- Diagnostics UI.
      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      -- Buffer-local keymaps, set only once a server attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local function map(keys, fn, desc)
            vim.keymap.set("n", keys, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end

          -- Navigation
          map("gd", vim.lsp.buf.definition, "Goto definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("gi", vim.lsp.buf.implementation, "Goto implementation")
          map("gr", vim.lsp.buf.references, "References")

          -- Information
          map("K", vim.lsp.buf.hover, "Hover")
          map("<C-k>", vim.lsp.buf.signature_help, "Signature help")

          -- Actions
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>f", function()
            vim.lsp.buf.format({ async = true })
          end, "Format buffer")
        end,
      })

      -- Diagnostic navigation (global). goto_prev/goto_next are deprecated in
      -- favour of vim.diagnostic.jump.
      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
    end,
  },
}
