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

-- https://github.com/tris203/precognition.nvim
-- 💭👀precognition.nvim - Precognition uses virtual text and gutter signs to show available motions.
local precognition = {
  "tris203/precognition.nvim",
  config = {
    -- startVisible = true,
    -- hints = {
    --     ["^"] = { text = "^", prio = 1 },
    --     ["$"] = { text = "$", prio = 1 },
    --     ["w"] = { text = "w", prio = 10 },
    --     ["b"] = { text = "b", prio = 10 },
    --     ["e"] = { text = "e", prio = 10 },
    -- },
    -- gutterHints = {
    --     --prio is not currentlt used for gutter hints
    --     ["G"] = { text = "G", prio = 1 },
    --     ["gg"] = { text = "gg", prio = 1 },
    --     ["{"] = { text = "{", prio = 1 },
    --     ["}"] = { text = "}", prio = 1 },
    -- },
  },
}

local plugins = {
  flash,
  harpoon,
  --precognition
}

return plugins
