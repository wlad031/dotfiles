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
        "ledger",
        "terraform", "hcl"
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
  opts = {
    servers = {
      terraformls = {},
    },
  },
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
    lspconfig.terraformls.setup({
      capabilities = capabilities,
      filetypes = { "terraform" },
    })
  end
}


local actions_preview = {
  "aznhe21/actions-preview.nvim",
  config = function()
  end,
}

local plugins = {
  treesitter,
  mason,
  mason_lspconfig,
  lspconfig,
  actions_preview,
}

return plugins
