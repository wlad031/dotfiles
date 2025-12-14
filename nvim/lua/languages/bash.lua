local M = {}

local setupKeyMappings = function() end

local init = function()
  setupKeyMappings()
end

init()

M.SetupLsp = function(capabilities)
  vim.lsp.config("bashls", {
    capabilities = capabilities,
  })
  vim.lsp.enable("bashls")
end

M.linters = function()
  return { "bash" }
end

return M
