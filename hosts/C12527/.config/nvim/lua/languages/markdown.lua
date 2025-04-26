local M = {}

local function setupKeyMappings()
end

local function init()
  setupKeyMappings()
end

init()

function M.SetupLspConfig(lspconfig, capabilities)
  -- Write Markdown with code assist and intelligence in the comfort of your 
  -- favourite editor.
  -- https://github.com/artempyanykh/marksman
  -- lspconfig.marksman.setup({
  -- })
end

return M

