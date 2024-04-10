local figutive = {
  "tpope/vim-fugitive"
}

local gitsigns = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({})
    vim.keymap.set('n', '<leader>gp', ":Gitsigns preview_hunk<CR>", {})
    vim.keymap.set('n', '<leader>gu', ":Gitsigns reset_hunk<CR>", {})
  end,
}

local plugins = {
  figutive,
  gitsigns
}

return plugins
