return {
  {
    'echasnovski/mini.files',
    version = '*',
    config = function()
      require('mini.files').setup()
      vim.keymap.set('n', '<leader>nn', function() MiniFiles.open() end, { desc = "Files: Open mini.files" })
    end
  },

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

  {
    'echasnovski/mini.move',
    version = '*',
    config = function()
      -- TODO: Setup keymaps for mini.move
      require('mini.move').setup()
    end
  }
}
