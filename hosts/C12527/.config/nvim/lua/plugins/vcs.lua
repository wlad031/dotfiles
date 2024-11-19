require "user.keymaps"

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

local lazygit = {
  "kdheepak/lazygit.nvim",
  cmd = {
    "LazyGit",
    "LazyGitConfig",
    "LazyGitCurrentFile",
    "LazyGitFilter",
    "LazyGitFilterCurrentFile",
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = GetLazyGitKeys()
}

local plugins = {
  --figutive,
  gitsigns,
  diffview,
  neogit,
  lazygit
}

return plugins
