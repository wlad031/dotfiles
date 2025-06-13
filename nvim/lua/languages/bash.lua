local M = {}

local setupKeyMappings = function()
end

local init = function()
  setupKeyMappings()
end

init()

M.SetupLspConfig = function(lspconfig, capabilities)
  lspconfig.bashls.setup {
    capabilities = capabilities,
  }
end

M.linters = function()
  return { "bash" }
end

return M
