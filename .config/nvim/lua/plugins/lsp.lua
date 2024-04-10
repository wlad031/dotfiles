require "user.keymaps"

local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = { "lua", "java", "scala", "python", "bash", "markdown", "xml", "json", "yaml", "markdown_inline" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end
}

local mason = {
  "williamboman/mason.nvim",
  lazy = false,
  config = function()
    require("mason").setup()
  end,
}

local mason_lspconfig = {
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
}

local lspconfig = {
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

    local cmp = require("cmp")

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
      mapping = GetCmpMapping(),
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
}

local vim_test = {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  vim.cmd("let test#strategy = 'vimux'"),
  config = function()
  end
}

local plugins = {
  treesitter,
  mason,
  mason_lspconfig,
  lspconfig,
  vim_test
}

return plugins
