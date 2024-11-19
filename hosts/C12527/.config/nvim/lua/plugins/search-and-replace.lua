require "user.keymaps"

local rip_substitute = {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  keys = {
    {
      "<leader>rb",
      function() require("rip-substitute").sub() end,
      mode = { "n", "x" },
      desc = "Replace: Buffer: RipSubstitute",
    },
  },
}

-- https://github.com/MagicDuck/grug-far.nvim
local grug_far = {
  'MagicDuck/grug-far.nvim',
  config = function()
    require('grug-far').setup({});
    SetGrugFarKeys()
  end
}

local plugins = {
  -- rip_substitute,
  grug_far,
}

return plugins

