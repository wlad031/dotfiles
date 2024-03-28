return {
  -- { "tpope/vim-fugitive" }, -- I don't thing I really need to add/commit/push/pull from inside vim
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({})
      vim.keymap.set('n', '<leader>gp', ":Gitsigns preview_hunk<CR>", {})
    end,
  }
}
