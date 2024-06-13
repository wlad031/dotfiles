require "user.keymaps"

local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = {
        "lua",
        "java",
        "scala",
        "python",
        "bash",
        "markdown",
        "xml",
        "json",
        "yaml",
        "markdown_inline",
        "ledger"
      },
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
        --"java-test",
        "jdtls",
        "pyright"
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

    local ELLIPSIS_CHAR = '…'
    local MAX_LABEL_WIDTH = 20
    local MIN_LABEL_WIDTH = 20

    local function formatWindow(entry, vim_item)
      local label = vim_item.abbr
      local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
      if truncated_label ~= label then
        vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
      elseif string.len(label) < MIN_LABEL_WIDTH then
        local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
        vim_item.abbr = label .. padding
      end
      return vim_item
    end

    cmp.setup({
      formatting = {
        format = formatWindow,
      },
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
          { name = "hledger" },
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
  config = function()
    vim.cmd("let test#strategy = 'vimux'")
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
