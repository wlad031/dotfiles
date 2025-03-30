return {
  "neovim/nvim-lspconfig",
  lazy = false,

  opts = {
    servers = {
      pyright = {},
    },
  },

  config = function()
    local capabilities = require('cmp_nvim_lsp').default_capabilities()
    -- local capabilities = require('blink.cmp').get_lsp_capabilities()
    local lspconfig = require('lspconfig')

    lspconfig['lua_ls'].setup({
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
    require("languages.harper").SetupLspConfig(lspconfig, capabilities)
  end,
}
