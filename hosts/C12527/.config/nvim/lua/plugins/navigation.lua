require "user.keymaps"

local portal = {
  "cbochs/portal.nvim",
  -- Optional dependencies
  dependencies = {
    "ThePrimeagen/harpoon"
  },
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
  outline
}

return plugins
