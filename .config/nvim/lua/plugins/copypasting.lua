-- https://github.com/AckslD/nvim-neoclip.lua
local neoclip = {
  "AckslD/nvim-neoclip.lua",
  requires = {
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    -- TODO: Setup telescope mappings for neoclip
    require('neoclip').setup()
  end,
}

local cutlass = {
  "gbprod/cutlass.nvim",
  opts = {
    cut_key = 'x',
    registers = {
      select = "s",
      delete = "d",
      change = "c",
    },
  }
}

local plugins = {
  neoclip,
  cutlass
}

return plugins
