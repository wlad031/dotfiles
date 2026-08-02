local M = {}

local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "FloatBorder",
  "FloatTitle",
  "EndOfBuffer",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "StatusLine",
  "StatusLineNC",
  "WinSeparator",
  "FoldColumn",
}

local function background_from_terminal()
  if vim.env.NVIM_BACKGROUND == "light" or vim.env.NVIM_BACKGROUND == "dark" then
    return vim.env.NVIM_BACKGROUND
  end

  -- COLORFGBG commonly ends with the terminal background ANSI color.
  -- 0-6 and 8 are dark backgrounds; 7 and 9-15 are light backgrounds.
  local bg = (vim.env.COLORFGBG or ""):match(";(%d+)$")
  if bg then
    local color = tonumber(bg)
    if color == 7 or (color and color >= 9 and color <= 15) then
      return "light"
    end
  end

  return "dark"
end

function M.set_transparent()
  for _, group in ipairs(transparent_groups) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
  end
end

function M.use_gruvbox_with_terminal_background()
  -- Keep gruvbox's syntax/UI colors, but let the terminal draw the background.
  vim.opt.termguicolors = true
  vim.opt.background = background_from_terminal()

  local ok, gruvbox = pcall(require, "gruvbox")
  if ok then
    gruvbox.setup({
      transparent_mode = true,
    })
  end

  vim.cmd.colorscheme("gruvbox")
  M.set_transparent()
end

function M.use_terminal_theme()
  M.use_gruvbox_with_terminal_background()
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = M.set_transparent,
})

-- Backward-compatible command/function for ad-hoc use from :lua SetTransparent().
_G.SetTransparent = M.set_transparent

return M
