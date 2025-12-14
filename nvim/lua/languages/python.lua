local M = {}

local setupKeyMappings = function()
end

local init = function()
	setupKeyMappings()
end

init()

M.formatters = function()
	if require("conform").get_formatter_info("ruff_format").available then
		return { "ruff_format" }
	else
		return { "isort", "black" }
	end
end

M.SetupLsp = function(capabilities)
  vim.lsp.config("pyright", {
		capabilities = capabilities,
		cmd = { "pyright-langserver", "--stdio" },
	})
  vim.lsp.enable("pyright")
end

M.linters = function()
	return { "pylint" }
end

return M
