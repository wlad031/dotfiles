require "user.keymaps"

local flash = {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = GetFlashKeys(),
}

local hop = {
  'smoka7/hop.nvim',
  version = "*",
  opts = {
    keys = 'etovxqpdygfblzhckisuran'
  }
}

local harpoon = {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("harpoon"):setup()
  end
}

local portal = {
  "cbochs/portal.nvim",
  -- Optional dependencies
  dependencies = {
    "ThePrimeagen/harpoon"
  },
}

-- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md#features
local mini_bracketed = {
  'echasnovski/mini.bracketed',
  version = false,
  config = function()
    require('mini.bracketed').setup()
  end
}

local mini_ai = {
  'echasnovski/mini.ai',
  version = '*',
  config = function()
    require('mini.ai').setup()
  end
}

local mini_move = {
  'echasnovski/mini.move',
  version = '*',
  config = function()
    -- TODO: Setup keymaps for mini.move
    require('mini.move').setup()
  end
}

local plugins = {
  -- flash,
  hop,
  harpoon,
  portal,
  mini_bracketed,
  mini_ai,
  mini_move
}

return plugins
