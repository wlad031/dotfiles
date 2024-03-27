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

      --     local opts = { buffer = ev.buf }
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>bb", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>bb", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set('n', '<leader>fc', function()
        vim.lsp.buf.format { async = true }
      end, {})
      vim.keymap.set('n', '<C-p>', vim.lsp.buf.signature_help, {})
      --      vim.keymap.set("n", "<leader>fc", vim.lsp.buf.formatting, {})

      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          -- REQUIRED - you must specify a snippet engine
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
          end,
        },
        window = {
          -- completion = cmp.config.window.bordered(),
          -- documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-k>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_prev_item() else fallback() end end),
          ['<C-j>'] = cmp.mapping(function(fallback) if cmp.visible() then cmp.select_next_item() else fallback() end end),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          --['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          -- ["<Tab>"] = cmp.mapping(
          --   function(fallback)
          --     -- This little snippet will confirm with tab, and if no entry is selected, will confirm the first item
          --     if cmp.visible() then
          --       local entry = cmp.get_selected_entry()
          --       if not entry then
          --         cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
          --       end
          --       cmp.confirm()
          --     else
          --       fallback()
          --     end
          --   end
          -- ),
        },
        sources = cmp.config.sources({
          { name = 'copilot' },
          { name = 'metals' },
          { name = 'nvim_lsp' },
          { name = 'vsnip' }, -- For vsnip users.
          -- { name = 'luasnip' }, -- For luasnip users.
          -- { name = 'ultisnips' }, -- For ultisnips users.
          -- { name = 'snippy' }, -- For snippy users.
        }, {
          { name = 'buffer' },
        })
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
        }, {
          { name = 'buffer' },
        })
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
        matching = { disallow_symbol_nonprefix_matching = false }
      })
      --  cmp.setup({
      --    sources = {
      --      { name = "nvim_lsp" },
      --      { name = "metals" },
      --      { name = "copilot", group_index = 2 },
      --    },
      --    snippet = {
      --      expand = function(args)
      --      end,
      --    },
      --    mapping = cmp.mapping.preset.insert({
      --      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      --      ["<Tab>"] = function(fallback)
      --        if cmp.visible() then
      --          cmp.select_next_item()
      --        else
      --          fallback()
      --        end
      --      end,
      --      ["<S-Tab>"] = function(fallback)
      --        if cmp.visible() then
      --          cmp.select_prev_item()
      --        else
      --          fallback()
      --        end
      --      end,
      --    })
      --  })
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
  }
}
