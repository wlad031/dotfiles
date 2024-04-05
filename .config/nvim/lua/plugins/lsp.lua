local plugins = {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    opts = {
      auto_install = true,
    },
    config = function()
      local lspconfig = require("mason-lspconfig")
      lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          -- "google-java-format",
          -- "java-debug-adapter",
          -- "java-test",
          "jdtls",
          -- "vscode-java-decompiler"
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          }
        },
      })

      vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
      --vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>cr", function() require('telescope.builtin').lsp_references() end,
        { noremap = true, silent = true, desc = "Find references" })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
      vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, { desc = "Format code" })
      vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, { desc = "Signature help" })

      local cmp = require("cmp")

      local function cmp_confirm()
        local only_explicitly_selected = false
        cmp.mapping.confirm({ select = not only_explicitly_selected })
      end

      local cmp_mapping = {
        ['<C-k>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end),
        ['<C-j>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end),
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp_confirm(),
        ['<Tab>'] = cmp_confirm(),
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp_mapping,
        sources = cmp.config.sources(
          {
            --{ name = 'copilot' },
            { name = 'metals' },
            { name = 'nvim_lsp' },
            { name = 'vsnip' },
          },
          {
            { name = 'buffer' },
          })
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources(
          {
            { name = 'path' }
          },
          {
            { name = 'cmdline' }
          }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
    end
  },
  {
    "vim-test/vim-test",
    dependencies = {
      "preservim/vimux",
    },
    vim.keymap.set('n', '<leader>tf', ':TestFile<CR>'),
    vim.keymap.set('n', '<leader>tt', ':TestNearest<CR>'),
    vim.keymap.set('n', '<leader>tl', ':TestLast<CR>'),
    vim.cmd("let test#strategy = 'vimux'"),
    config = function()
    end
  }
}

return plugins
