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

local neogit = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",  -- required
    "sindrets/diffview.nvim", -- optional - Diff integration

    -- Only one of these is needed, not both.
    "nvim-telescope/telescope.nvim", -- optional
    "ibhagwan/fzf-lua",              -- optional
  },
  config = true
}

local plugins = {
  --figutive,
  gitsigns,
  neogit
}

return plugins
