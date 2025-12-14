local M = {}

M.SetupLsp = function(capabilities)
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim", "Snacks" },
        },
      },
    },
  })
  vim.lsp.enable("lua_ls")
end

M.formatters = function()
  return { "stylua" }
end

M.linters = function()
  return { "luac" }
end

return M
