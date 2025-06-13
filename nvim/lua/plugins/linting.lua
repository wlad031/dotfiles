return {
	{
		-- An asynchronous linter plugin for Neovim complementary to the built-in Language Server Protocol support.
		-- https://github.com/mfussenegger/nvim-lint
		"mfussenegger/nvim-lint",
		config = function(plugin, opts)
			local lint = require("lint")
			lint.linters_by_ft = {
				lua = require("languages.lua").linters(),
				python = require("languages.python").linters(),
				json = require("languages.json").linters(),
				jsonc = require("languages.json").linters(),
			}

			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "Code: Try lint (nvim-lint)" })
		end,
	},
}
