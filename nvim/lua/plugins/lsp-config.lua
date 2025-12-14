return {
  "neovim/nvim-lspconfig",
  lazy = false,

  opts = {
    servers = {
      pyright = {},
    },
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- local capabilities = require('blink.cmp').get_lsp_capabilities()

    require("languages.lua").SetupLsp(capabilities)
    require("languages.bash").SetupLsp(capabilities)
    require("languages.python").SetupLsp(capabilities)
    require("languages.jinja").SetupLsp(capabilities)
    require("languages.harper").SetupLsp(capabilities)
    require("languages.clojure").SetupLsp(capabilities)
  end,
}
