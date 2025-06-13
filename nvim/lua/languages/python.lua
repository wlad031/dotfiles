local M = {}

local setupKeyMappings = function()
	vim.keymap.set(
		"n",
		"<leader>cpvv",
		"<cmd>lua require('languages.python').PrintPythonPath()<cr>",
		{ desc = "Which Python?" }
	)
	vim.keymap.set(
		"n",
		"<leader>cpva",
		"<cmd>lua require('languages.python').ActivatePyenv()<cr>",
		{ desc = "Activate pyenv virtualenv" }
	)
	vim.keymap.set(
		"n",
		"<leader>cpvd",
		"<cmd>lua require('languages.python').DeactivatePyenv()<cr>",
		{ desc = "Deactivate pyenv virtualenv" }
	)

	require("which-key").add({
		{ "<leader>cp", group = "Python" },
		{ "<leader>cpv", group = "Virtualenv" },
	})
end

local init = function()
	setupKeyMappings()
	vim.api.nvim_create_user_command("PyenvSelect", function(opts)
		M.ActivatePyenv()
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("PyenvDeactivate", function(opts)
		M.DeactivatePyenv()
	end, { nargs = "?" })
	vim.api.nvim_create_user_command("PyenvPrint", function(opts)
		M.PrintPythonPath()
	end, { nargs = "?" })
end

init()

M.formatters = function()
	if require("conform").get_formatter_info("ruff_format").available then
		return { "ruff_format" }
	else
		return { "isort", "black" }
	end
end

M.SetupLspConfig = function(lspconfig, capabilities)
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

M.linters = function()
	return { "pylint" }
end

M.PrintPythonPath = function()
	local python_path = vim.fn.trim(vim.fn.system("pyenv which python"))
	if python_path == "" then
		print("Global Python") -- Fallback if no virtualenv is active
	end
	print(python_path)
end

M.DeactivatePyenv = function()
	vim.env.PYENV_VERSION = nil
	print("Deactivated pyenv virtualenv")

	-- Update LSP pythonPath
	local clients = vim.lsp.get_active_clients({ name = "pyright" })
	for _, client in ipairs(clients) do
		client.config.settings.python.pythonPath = vim.fn.trim(vim.fn.system("pyenv which python"))
		client.notify("workspace/didChangeConfiguration")
	end
end

M.ActivatePyenv = function()
	local telescope_builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	-- Get the list of pyenv virtualenvs
	local pyenv_virtualenvs = vim.fn.systemlist("pyenv virtualenvs --bare")

	if vim.tbl_isempty(pyenv_virtualenvs) then
		print("No pyenv virtualenvs found.")
		return
	end

	-- TODO: Migrate to snacks pickers
	-- Use Telescope to display the list of virtualenvs
	require("telescope.pickers")
		.new({}, {
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
		})
		:find()
end

return M
