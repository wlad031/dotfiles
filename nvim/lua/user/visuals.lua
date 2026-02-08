function SetTransparent()
  local groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "FloatBorder",
    "EndOfBuffer",
    "SignColumn",
    "LineNr",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
  }

  for _, group in ipairs(groups) do
    vim.cmd("highlight " .. group .. " guibg=NONE ctermbg=NONE")
  end
end
