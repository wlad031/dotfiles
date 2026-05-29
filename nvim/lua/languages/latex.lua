local M = {}

M.SetupLsp = function(capabilities)
  if vim.fn.executable("texlab") ~= 1 then
    vim.notify("texlab not found; skipping LaTeX LSP (install texlab for completions/diagnostics)", vim.log.levels.WARN)
    return
  end

  vim.lsp.config("texlab", {
    cmd = { "texlab" },
    capabilities = capabilities,
    filetypes = { "tex", "plaintex", "latex", "bib", "sty", "cls", "dtx", "ins", "context" },
    settings = {
      texlab = {
        latexFormatter = "latexindent",
        chktex = {
          onEdit = false,
          onOpenAndSave = true,
        },
      },
    },
  })

  vim.lsp.enable("texlab")
end

return M
