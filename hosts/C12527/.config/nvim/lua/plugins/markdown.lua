local markdown_nvim = {
  'MeanderingProgrammer/markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  config = function()
    require('render-markdown').setup({})
  end,
}

local markview = {
  "OXY2DEV/markview.nvim",
  lazy = false,

  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons"
  },

  config = function()
    local presets = require("markview.presets")
    require("markview").setup({
      -- headings = presets.headings.marker
    })
  end
}

local plugins = {
  -- markdown_nvim
  -- markview
}

return plugins
