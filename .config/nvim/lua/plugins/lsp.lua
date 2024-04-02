local function VimTestSbtTransform(cmd)
  return "consoleProject;" + cmd
end

return {
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
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },
  {
    "zbirenbaum/copilot.lua",
    opts = {},
    event = "VimEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup()
      end, 100)
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "hrsh7th/nvim-cmp"
    },
    config = function()
      require("copilot_cmp").setup()
    end
  },
  {
    "hrsh7th/vim-vsnip",
    setup = function()
      require("vim-vsnip").setup()
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

      vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, {})
      --vim.keymap.set("n", "<leader>cr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>cr", function() require('telescope.builtin').lsp_references() end, { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>cf', function() vim.lsp.buf.format { async = true } end, {})
      vim.keymap.set('n', '<leader>cp', vim.lsp.buf.signature_help, {})

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
            { name = 'copilot' },
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
    "scalameta/nvim-metals",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "j-hui/fidget.nvim",    opts = {} },
    },
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.init_options.statusBarProvider = "on"
      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
      metals_config.on_attach = function(client, bufnr)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
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
      vim.g['test#custom_transformations'] = { sbttest = VimTestSbtTransform }
      vim.g['test#transformation'] = 'sbttest'
    end
  }
}
