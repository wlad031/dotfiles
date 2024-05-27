require "user.keymaps"

local flash = {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = GetFlashKeys(),
}

local harpoon = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end
}

-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md#features
local mini_bracketed = {
  'echasnovski/mini.bracketed',
  version = false,
  config = function()
    require('mini.bracketed').setup()
  end
}

local plugins = {
  flash,
  harpoon,
  mini_bracketed,
}

return plugins
