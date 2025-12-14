local M = {}

M.SetupLsp = function(capabilities)
  vim.lsp.config("clojure_lsp", {
    capabilities = capabilities,
  })
  vim.lsp.enable("clojure_lsp")
end

return M
