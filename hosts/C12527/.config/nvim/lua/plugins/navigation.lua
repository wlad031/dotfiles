require "user.keymaps"

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


local outline = {
  "hedyhli/outline.nvim",
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = GetOutlineKeys(),
  opts = {
    -- Your setup opts here
  }
}

local plugins = {
  portal,
  mini_bracketed,
  mini_ai,
  mini_move,
  outline
}

return plugins
