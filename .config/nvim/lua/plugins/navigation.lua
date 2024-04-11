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

local plugins = {
  flash,
  harpoon,
}

return plugins
