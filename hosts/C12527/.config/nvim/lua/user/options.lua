vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.number = false
vim.opt.relativenumber = false
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.wrap = false
vim.opt.colorcolumn = { "80", "100", "120" }

-- Edgy recommended options
-- https://github.com/folke/edgy.nvim
--
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"

vim.diagnostic.config({
  virtual_text = true,
  -- Use the default configuration
  virtual_lines = true

  -- Alternatively, customize specific options
  -- virtual_lines = {
  --  -- Only show virtual line diagnostics for the current cursor line
  --  current_line = true,
  -- },
})

