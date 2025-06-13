local M = {}

M.lsp_config = function(lspconfig, capabilities)
  lspconfig.clojure_lsp.setup({
    capabilities = capabilities,
  })
end

return M
