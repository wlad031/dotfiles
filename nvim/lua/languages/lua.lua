local M = {}

M.formatters = function()
	return { "stylua" }
end

M.linters = function()
  return { "luac" }
end

return M
