local treesitter = {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    vim.filetype.add({
      extension = {
        j2 = "jinja",
        jinja = "jinja",
        jinja2 = "jinja",
      },
    })
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
    parser_config.jinja2 = {
      install_info = {
        url = "https://github.com/dbt-labs/tree-sitter-jinja2", -- local path or git repo
        files = { "src/parser.c" },                             -- note that some parsers also require src/scanner.c or src/scanner.cc
        -- optional entries:
        branch = "main",                                        -- default branch in case of git repo if different from master
        generate_requires_npm = false,                          -- if stand-alone parser without npm dependencies
        requires_generate_from_grammar = false,                 -- if folder contains pre-generated src/parser.c
      },
      filetype = "jinja",                                       -- if filetype does not match the parser name
    }
    local config = require("nvim-treesitter.configs")
    config.setup({
      auto_install = true,
      ensure_installed = {
        "lua",
        "html",
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
        "html",
        "jinja2"
      },
      highlight = { enable = true, additional_vim_regex_highlighting = false },
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
      pyright = {},
      -- pylsp = {},
      -- terraformls = {},
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

    require("languages.python").SetupLspConfig(lspconfig, capabilities)
    require("languages.jinja").SetupLspConfig(lspconfig, capabilities)
    --
    -- lspconfig.terraformls.setup({
    --   capabilities = capabilities,
    --   filetypes = { "terraform" },
    -- })
  end
}

local null_ls = {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local null_ls = require("null-ls")
    require("languages.python").SetupNullJs(null_ls)
  end
}

local actions_preview = {
  "aznhe21/actions-preview.nvim",
  config = function()
    local actions_preview = require("actions-preview")
    vim.keymap.set("n", "<leader>ca", function() actions_preview.code_actions() end, { desc = "Code: Actions (Code actions)" })
  end,
}

local inc_rename = {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
    vim.keymap.set("n", "<leader>vv", ":IncRename ")
  end,
}

return {
  treesitter,
  mason,
  mason_lspconfig,
  lspconfig,
  null_ls,
  actions_preview,
  inc_rename
}
