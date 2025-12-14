local M = {}

local function init() end

init()

M.SetupLsp = function(capabilities)
  local configs = require("lspconfig.configs")

  if not configs.jinja_lsp then
    configs.jinja_lsp = {
      default_config = {
        name = "jinja-lsp",
        cmd = { "/Users/vgerasimov/.cargo/bin/jinja-lsp" }, -- TODO: get rid of full path
        filetypes = { "jinja", "yaml" },
        root_dir = function(fname)
          return "."
          --return nvim_lsp.util.find_git_ancestor(fname)
        end,
      },
    }
  end
  vim.lsp.config("jinja_lsp", {
    capabilities = capabilities,
    -- on_attach = function(_, bufnr)
    --   local function activate_virtualenv()
    --     local cwd = vim.fn.getcwd()
    --     local pyenv_path = vim.fn.trim(vim.fn.system("pyenv which python"))
    --     if pyenv_path and vim.fn.filereadable(cwd .. "/.python-version") == 1 then
    --       return pyenv_path
    --     end
    --     return "python"
    --   end
    --
    --   vim.lsp.buf_notify(bufnr, "workspace/didChangeConfiguration", {
    --     settings = {
    --       python = {
    --         pythonPath = activate_virtualenv(),
    --       },
    --     },
    --   })
    -- end,
  })
  vim.lsp.enable("jinja_lsp")
end

return M
