local M = {}

local function setupKeyMappings()
  vim.keymap.set("n", "<leader>cpvv", "<cmd>lua require('languages.python').PrintPythonPath()<cr>",
    { desc = "Which Python?" })
  vim.keymap.set("n", "<leader>cpva", "<cmd>lua require('languages.python').ActivatePyenv()<cr>",
    { desc = "Activate pyenv virtualenv" })
  vim.keymap.set("n", "<leader>cpvd", "<cmd>lua require('languages.python').DeactivatePyenv()<cr>",
    { desc = "Deactivate pyenv virtualenv" })

  require("which-key").add({
    { "<leader>cp",  group = "Python" },
    { "<leader>cpv", group = "Virtualenv" },
  })
end

local function init()
  setupKeyMappings()
end

init()

function M.SetupLspConfig(lspconfig, capabilities)
  lspconfig.pyright.setup({
    capabilities = capabilities,
    cmd = { "pyright-langserver", "--stdio" },
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
end

function M.SetupNullJs(null_ls)
  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.black,
    },
  })
end

function M.PrintPythonPath()
  local python_path = vim.fn.trim(vim.fn.system("pyenv which python"))
  if python_path == "" then
    print("Global Python") -- Fallback if no virtualenv is active
  end
  print(python_path)
end

function M.DeactivatePyenv()
  vim.env.PYENV_VERSION = nil
  print("Deactivated pyenv virtualenv")

  -- Update LSP pythonPath
  local clients = vim.lsp.get_active_clients({ name = "pyright" })
  for _, client in ipairs(clients) do
    client.config.settings.python.pythonPath = vim.fn.trim(vim.fn.system("pyenv which python"))
    client.notify("workspace/didChangeConfiguration")
  end
end

function M.ActivatePyenv()
  local telescope_builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  -- Get the list of pyenv virtualenvs
  local pyenv_virtualenvs = vim.fn.systemlist("pyenv virtualenvs --bare")

  if vim.tbl_isempty(pyenv_virtualenvs) then
    print("No pyenv virtualenvs found.")
    return
  end

  -- Use Telescope to display the list of virtualenvs
  require("telescope.pickers").new({}, {
    prompt_title = "Select Pyenv Virtualenv",
    finder = require("telescope.finders").new_table({
      results = pyenv_virtualenvs,
      entry_maker = function(entry)
        return { value = entry, display = entry, ordinal = entry }
      end,
    }),
    sorter = require("telescope.config").values.generic_sorter({}),
    attach_mappings = function(_, map)
      -- On selection, activate the virtualenv
      map("i", "<CR>", function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if selection then
          local selected_env = selection.value
          -- Activate the selected virtualenv
          vim.env.PYENV_VERSION = selected_env
          print("Activated pyenv virtualenv: " .. selected_env)

          -- Update LSP pythonPath
          local clients = vim.lsp.get_active_clients({ name = "pyright" })
          for _, client in ipairs(clients) do
            client.config.settings.python.pythonPath = vim.fn.trim(vim.fn.system("pyenv which python"))
            client.notify("workspace/didChangeConfiguration")
          end

          print("Updated Pyright LSP with virtualenv: " .. selected_env)
        end
      end)
      return true
    end,
  }):find()
end

return M

