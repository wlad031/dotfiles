local M = {}

M.Linters = function()
  return { 'luac' }
end

M.SetupLspConfig = function(lspconfig, capabilities)
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
end

return M
