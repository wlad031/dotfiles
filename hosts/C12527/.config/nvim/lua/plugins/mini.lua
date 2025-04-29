return {
  -- https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-bracketed.md#features
  {
    'echasnovski/mini.bracketed',
    version = '*',
    config = function()
      require('mini.bracketed').setup()
    end
  },

  {
    'echasnovski/mini.ai',
    version = '*',
    config = function()
      require('mini.ai').setup()
    end
  },
}
