local minuet_ai = {
  'milanglaicer/minuet-ai.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'hrsh7th/nvim-cmp'
  },
  config = function()
    require('minuet').setup({
    })
  end
}

local plugins = {
  -- minuet_ai,
}

return plugins
