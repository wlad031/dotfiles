local plugins = {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
  },
  {
    "hrsh7th/vim-vsnip",
    setup = function()
      require("vim-vsnip").setup()
    end
  },
}

return plugins
