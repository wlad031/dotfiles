local zenmode = {
  "folke/zen-mode.nvim",
  opts = {
    plugins = {
      twilight = { enabled = false }
    }
  },
  config = function()
    vim.keymap.set('n', '<leader>zz', ":ZenMode<CR>", {})
  end
}

local twilight = {
  "folke/twilight.nvim",
  opts = {
  },
  config = function()
    vim.keymap.set('n', '<leader>zt', ":Twilight<CR>", {})
  end
}

return {
  zenmode,
  twilight,
}
