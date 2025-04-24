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
    local languages = {
      require("languages.harper"),
      require("languages.java"),
      require("languages.jinja"),
      require("languages.lua"),
      require("languages.markdown"),
      require("languages.python"),
    }
    for _, lang in ipairs(languages) do
      lang.SetupLspConfig(lspconfig, capabilities)
    end
  end,
}
