local gitsigns = {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup({})
    vim.keymap.set('n', '<leader>gp', "<Cmd>Gitsigns preview_hunk<CR>", {})
    vim.keymap.set('n', '<leader>gu', "<Cmd>Gitsigns reset_hunk<CR>", {})
  end,
}

local diffview = {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({})
  end
}

local neogit = {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = true
}

local plugins = {
  gitsigns,
  diffview,
  neogit,
}

return plugins
